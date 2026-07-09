#!/usr/bin/env bash
#
# fix-cargo-license-field.sh
# ──────────────────────────────────────────────────────────────────────────
# Patches the Cargo.toml `[package] license = "..."` field to match the
# license assigned in mapping/repo-license-map.yaml.
#
# add-spdx-headers.sh stamps the top-of-file SPDX comment header but never
# touches this field — this script fills that gap. Same resolution logic
# (MIXED-monorepo per-directory longest-prefix match, proprietary-license-id
# substitution) as add-spdx-headers.sh, applied to Cargo.toml package
# metadata instead of source-file comments.
#
# Idempotent: a Cargo.toml whose license field already matches is left alone.
# Only rewrites the `license = "..."` line; `license.workspace = true` lines
# (inheriting from a workspace root Cargo.toml) are left untouched — fix the
# workspace root's own Cargo.toml instead.
#
# Does NOT commit or push. Operator reviews staged changes and commits.
#
# Usage:
#   fix-cargo-license-field.sh <target-repo-path>
#   fix-cargo-license-field.sh --check <target-repo-path>
#   fix-cargo-license-field.sh --help
#
# Dependencies:
#   - yq (mikefarah), git, find, grep, sed
# ──────────────────────────────────────────────────────────────────────────

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
MAP="$FRE_ROOT/mapping/repo-license-map.yaml"

[[ -f "$MAP" ]] || { echo "ERROR: mapping file not found: $MAP" >&2; exit 2; }

for tool in yq git find grep sed; do
  command -v "$tool" >/dev/null 2>&1 || {
    echo "ERROR: required tool not found: $tool" >&2
    exit 2
  }
done

usage() {
  sed -n '/^# Usage:/,/^# Dependencies:/p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
  exit "${1:-0}"
}

MODE=apply
TARGET=""

case "${1:-}" in
  -h|--help)  usage 0 ;;
  --check)    MODE=check; TARGET="${2:?--check requires a target repo path}" ;;
  "")         usage 2 ;;
  -*)         echo "ERROR: unknown option: $1" >&2; usage 2 ;;
  *)          TARGET="$1" ;;
esac

[[ -d "$TARGET" ]] || { echo "ERROR: not a directory: $TARGET" >&2; exit 1; }

yaml() { yq -r "$1" "$MAP"; }
log()  { printf '[cargo-license] %s\n' "$*"; }
warn() { printf '[cargo-license] WARN: %s\n' "$*" >&2; }
fail() { printf '[cargo-license] FAIL: %s\n' "$*" >&2; exit 1; }

REPO_NAME=$(basename "$TARGET")
LICENSE=$(yaml ".repositories[] | select(.name == \"$REPO_NAME\") | .license" | head -1)

[[ -n "$LICENSE" && "$LICENSE" != "null" ]] || fail "no license assignment in map for '$REPO_NAME'"

log "repo: $REPO_NAME → license: $LICENSE"

IS_MIXED=no
[[ "$LICENSE" == "MIXED" ]] && IS_MIXED=yes

# Resolve a license key (e.g. "PointSav-ARR") to the SPDX-expression string
# that actually belongs in a Cargo.toml license field (e.g.
# "LicenseRef-PointSav-ARR"), via the same header_substitutions table
# add-spdx-headers.sh uses for its ${proprietary-license-id} placeholder.
# Falls back to the license key itself when no substitution is defined.
resolve_spdx_expression() {
  local key="$1" subs prop_id
  subs=$(yaml ".licenses.\"$key\".header_substitutions // {}")
  prop_id=$(echo "$subs" | yq -r '."${proprietary-license-id}" // ""')
  if [[ -n "$prop_id" ]]; then
    echo "$prop_id"
  else
    echo "$key"
  fi
}

if [[ "$IS_MIXED" == "yes" ]]; then
  declare -a MONO_KEYS
  while IFS= read -r key; do
    MONO_KEYS+=("$key")
  done < <(yq -r '.monorepo_directories | keys | .[]' "$MAP" | awk '{print length "\t" $0}' | sort -rn | cut -f2)
fi

resolve_file_license() {
  local rel="$1" prefix
  for prefix in "${MONO_KEYS[@]}"; do
    if [[ "$rel" == "$prefix"* ]]; then
      yaml ".monorepo_directories.\"$prefix\""
      return
    fi
  done
}

# ---- Walk ----

fixed=0 already_correct=0 skipped_workspace_inherit=0 skipped_no_rule=0

if [[ "$IS_MIXED" == "no" ]]; then
  EXPECTED=$(resolve_spdx_expression "$LICENSE")
fi

while IFS= read -r file; do
  rel="${file#$TARGET/}"

  if [[ "$IS_MIXED" == "yes" ]]; then
    file_license=$(resolve_file_license "$rel")
    if [[ -z "$file_license" ]]; then
      skipped_no_rule=$((skipped_no_rule + 1))
      continue
    fi
    expected=$(resolve_spdx_expression "$file_license")
  else
    expected="$EXPECTED"
  fi

  current_line=$(grep -m1 '^license[[:space:]]*=' "$file" || true)

  if [[ -z "$current_line" ]]; then
    # No `license = "..."` line at all (likely `license.workspace = true`
    # or no license field present) — not this script's job, skip.
    skipped_workspace_inherit=$((skipped_workspace_inherit + 1))
    continue
  fi

  if echo "$current_line" | grep -qF "\"$expected\""; then
    already_correct=$((already_correct + 1))
    continue
  fi

  if [[ "$MODE" == "check" ]]; then
    log "  would fix: $file (\"$(echo "$current_line" | sed -E 's/^license[[:space:]]*=[[:space:]]*//')\" → \"$expected\")"
  else
    sed -i "s/^license[[:space:]]*=.*/license = \"$expected\"/" "$file"
    log "  fixed: $file → \"$expected\""
  fi
  fixed=$((fixed + 1))
done < <(find "$TARGET" -name Cargo.toml -not -path '*/target/*' | sort)

log ""
log "Summary for $REPO_NAME:"
log "  fixed:                    $fixed"
log "  already correct:          $already_correct"
log "  license.workspace/no-field: $skipped_workspace_inherit"
log "  no monorepo rule:         $skipped_no_rule"

if [[ "$MODE" == "check" ]]; then
  log ""
  log "Check mode — no files written."
else
  log ""
  log "Cargo.toml license fields updated. Review changes and commit manually."
fi
