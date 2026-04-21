#!/usr/bin/env bash
#
# verify-repo-compliance.sh
# ──────────────────────────────────────────────────────────────────────────
# Verifies that a target repository conforms to what mapping/repo-license-map.yaml
# says it should contain. Read-only; never modifies the target.
#
# Usage:
#   verify-repo-compliance.sh <target-repo-path>
#   verify-repo-compliance.sh --json <target-repo-path>
#   verify-repo-compliance.sh --include-headers <target-repo-path>
#   verify-repo-compliance.sh --help
#
# Exit codes:
#   0 — compliant
#   1 — divergence found
#   2 — error (missing map, unknown repo, bad arguments, etc.)
#
# Dependencies:
#   - yq (mikefarah)
#   - diff, grep, find
# ──────────────────────────────────────────────────────────────────────────

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
MAP="$FRE_ROOT/mapping/repo-license-map.yaml"

[[ -f "$MAP" ]] || { echo "ERROR: mapping file not found: $MAP" >&2; exit 2; }

for tool in yq diff grep find; do
  command -v "$tool" >/dev/null 2>&1 || {
    echo "ERROR: required tool not found: $tool" >&2
    exit 2
  }
done

usage() {
  sed -n '/^# Usage:/,/^# Dependencies:/p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
  exit "${1:-0}"
}

OUTPUT=human
INCLUDE_HEADERS=no
TARGET=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)          usage 0 ;;
    --json)             OUTPUT=json; shift ;;
    --include-headers)  INCLUDE_HEADERS=yes; shift ;;
    -*)                 echo "ERROR: unknown option: $1" >&2; usage 2 ;;
    *)                  TARGET="$1"; shift ;;
  esac
done

[[ -n "$TARGET" ]] || usage 2
[[ -d "$TARGET" ]] || { echo "ERROR: not a directory: $TARGET" >&2; exit 2; }

yaml() { yq -r "$1" "$MAP"; }

# ---- Result accumulator ----

declare -a CHECKS=()  # each entry: "name|status|detail" (status = pass|fail|warn|skip)

record() {
  CHECKS+=("$1|$2|$3")
}

# ---- Determine license ----

REPO_NAME=$(basename "$TARGET")
LICENSE=$(yaml ".repositories[] | select(.name == \"$REPO_NAME\") | .license" | head -1)

if [[ -z "$LICENSE" || "$LICENSE" == "null" ]]; then
  record "license-assignment" "fail" "no license assignment in map for '$REPO_NAME'"
  LICENSE=""
else
  record "license-assignment" "pass" "$LICENSE"
fi

# ---- Substitution helpers (mirror propagate-licenses.sh) ----

YEAR=$(yaml '.defaults.year')
COPYRIGHT_HOLDER=$(yaml '.defaults.copyright_holder')

render_substituted() {
  local src="$1" license="$2"
  [[ -f "$src" ]] || return 1

  local content
  content=$(cat "$src")
  content="${content//\$\{year\}/$YEAR}"
  content="${content//\$\{licensor name\}/$COPYRIGHT_HOLDER}"
  content="${content//\$\{copyright holder\}/$COPYRIGHT_HOLDER}"

  local header_subs
  header_subs=$(yaml ".licenses.\"$license\".header_substitutions // {}")
  local prop_id
  prop_id=$(echo "$header_subs" | yq -r '."${proprietary-license-id}" // ""' -)
  if [[ -n "$prop_id" ]]; then
    content="${content//\$\{proprietary-license-id\}/$prop_id}"
  fi

  printf '%s\n' "$content"
}

compare_file() {
  local check_name="$1" canonical="$2" target_file="$3" license="$4"
  if [[ ! -f "$target_file" ]]; then
    record "$check_name" "fail" "missing: $target_file"
    return
  fi
  if [[ ! -f "$canonical" ]]; then
    record "$check_name" "skip" "canonical source missing: $canonical"
    return
  fi
  local rendered
  rendered=$(render_substituted "$canonical" "$license")
  if diff -q <(printf '%s' "$rendered") "$target_file" >/dev/null 2>&1; then
    record "$check_name" "pass" "matches canonical"
  else
    record "$check_name" "fail" "diverges from canonical"
  fi
}

# ---- Checks ----

if [[ -n "$LICENSE" ]]; then
  # LICENSE file
  license_file=$(yaml ".licenses.\"$LICENSE\".license_file")
  if [[ "$license_file" != "null" && -n "$license_file" ]]; then
    compare_file "license-file" "$FRE_ROOT/$license_file" "$TARGET/LICENSE" "$LICENSE"
  fi

  # NOTICE (only if required — presence check, not content match,
  # because NOTICE content is generated, not copied from a canonical file)
  notice_mode=$(yaml ".licenses.\"$LICENSE\".notice_file")
  if [[ "$notice_mode" == "required" ]]; then
    if [[ -f "$TARGET/NOTICE" ]]; then
      record "notice-file" "pass" "present"
    else
      record "notice-file" "fail" "required NOTICE file missing"
    fi
  fi

  # Policies
  while IFS= read -r policy; do
    [[ -z "$policy" ]] && continue
    compare_file "policy-$policy" "$FRE_ROOT/policies/$policy.md" "$TARGET/$policy.md" "$LICENSE"
  done < <(yaml ".licenses.\"$LICENSE\".policies[]?")

  # SPDX headers on source files (optional)
  if [[ "$INCLUDE_HEADERS" == "yes" ]]; then
    header_subs=$(yaml ".licenses.\"$LICENSE\".header_substitutions // {}")
    prop_id=$(echo "$header_subs" | yq -r '."${proprietary-license-id}" // ""' -)
    if [[ -n "$prop_id" ]]; then
      expected_spdx="$prop_id"
    else
      expected_spdx="$LICENSE"
    fi

    missing_headers=0 examined=0
    while IFS= read -r file; do
      case "$file" in
        */node_modules/*|*/vendor/*|*/.git/*|*/dist/*|*/build/*) continue ;;
        *.min.js|*.min.css|*.lock) continue ;;
      esac
      case "$file" in
        *.js|*.ts|*.tsx|*.jsx|*.go|*.py|*.rb|*.sh|*.rs|*.java|*.c|*.cpp|*.h|*.hpp|*.sql)
          examined=$((examined + 1))
          if ! head -20 "$file" 2>/dev/null | grep -q "SPDX-License-Identifier:.*$expected_spdx"; then
            missing_headers=$((missing_headers + 1))
          fi
          ;;
      esac
    done < <(find "$TARGET" -type f -not -path '*/.git/*')

    if [[ $missing_headers -eq 0 ]]; then
      record "spdx-headers" "pass" "all $examined source files have correct header"
    else
      record "spdx-headers" "fail" "$missing_headers of $examined source files missing or wrong"
    fi
  fi

  # Bilingual README section (presence-only; content check is harder and
  # can be added later once readmes/ artifacts exist)
  bilingual=$(yaml ".licenses.\"$LICENSE\".bilingual_readme")
  if [[ "$bilingual" == "true" ]]; then
    if [[ ! -f "$FRE_ROOT/readmes/license-section-en.md" ]]; then
      record "bilingual-readme" "skip" "canonical readmes/ sources not yet created"
    else
      if [[ -f "$TARGET/README.md" ]] && grep -qF "$(head -1 "$FRE_ROOT/readmes/license-section-en.md")" "$TARGET/README.md"; then
        record "bilingual-readme" "pass" "license section present in README.md"
      else
        record "bilingual-readme" "fail" "license section missing from README.md"
      fi
    fi
  fi
fi

# ---- Output ----

FAIL_COUNT=0
for entry in "${CHECKS[@]}"; do
  IFS='|' read -r name status detail <<< "$entry"
  [[ "$status" == "fail" ]] && FAIL_COUNT=$((FAIL_COUNT + 1))
done

if [[ "$OUTPUT" == "json" ]]; then
  printf '{\n  "repo": "%s",\n  "license": "%s",\n  "checks": [\n' "$REPO_NAME" "$LICENSE"
  first=1
  for entry in "${CHECKS[@]}"; do
    IFS='|' read -r name status detail <<< "$entry"
    [[ $first -eq 0 ]] && printf ',\n'
    first=0
    detail_escaped=$(printf '%s' "$detail" | sed 's/\\/\\\\/g; s/"/\\"/g')
    printf '    {"name": "%s", "status": "%s", "detail": "%s"}' "$name" "$status" "$detail_escaped"
  done
  printf '\n  ],\n  "overall": "%s"\n}\n' "$([[ $FAIL_COUNT -eq 0 ]] && echo pass || echo fail)"
else
  printf '[verify] repo: %s  license: %s\n' "$REPO_NAME" "$LICENSE"
  for entry in "${CHECKS[@]}"; do
    IFS='|' read -r name status detail <<< "$entry"
    case "$status" in
      pass) symbol="✓" ;;
      fail) symbol="✗" ;;
      warn) symbol="!" ;;
      skip) symbol="-" ;;
    esac
    printf '  %s %-22s %s\n' "$symbol" "$name" "$detail"
  done
  printf '[verify] %s\n' "$([[ $FAIL_COUNT -eq 0 ]] && echo 'COMPLIANT' || echo "DIVERGENT ($FAIL_COUNT failure(s))")"
fi

[[ $FAIL_COUNT -eq 0 ]] && exit 0 || exit 1
