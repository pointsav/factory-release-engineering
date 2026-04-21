#!/usr/bin/env bash
#
# add-spdx-headers.sh
# ──────────────────────────────────────────────────────────────────────────
# Stamps SPDX source-file headers on non-excluded source files in a target
# repository according to the license assigned in
# mapping/repo-license-map.yaml.
#
# Supports two modes automatically, based on the target repo's license:
#   - Single-license repos: one SPDX identifier across all stamped files.
#   - MIXED monorepos: per-file license resolved via monorepo_directories
#     longest-prefix matching.
#
# Idempotent: files already having a matching SPDX header are left alone.
# Files with an SPDX header naming a non-Woodfine copyright holder (i.e.
# vendored third-party code) are also left alone.
#
# Repos with a content license (CC BY 4.0, CC BY-ND 4.0) have
# header_template: null in the YAML — the script exits 0 without stamping
# anything in that case.
#
# Does NOT commit or push. Operator reviews staged changes and commits.
#
# Usage:
#   add-spdx-headers.sh <target-repo-path>
#   add-spdx-headers.sh --check <target-repo-path>
#   add-spdx-headers.sh --help
#
# Dependencies:
#   - yq (mikefarah)
#   - git, find, grep, sed
# ──────────────────────────────────────────────────────────────────────────

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
MAP="$FRE_ROOT/mapping/repo-license-map.yaml"

[[ -f "$MAP" ]] || { echo "ERROR: mapping file not found: $MAP" >&2; exit 2; }

for tool in yq git find grep; do
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
log()  { printf '[spdx] %s\n' "$*"; }
warn() { printf '[spdx] WARN: %s\n' "$*" >&2; }
fail() { printf '[spdx] FAIL: %s\n' "$*" >&2; exit 1; }

# ---- Determine license for this repo ----

REPO_NAME=$(basename "$TARGET")
LICENSE=$(yaml ".repositories[] | select(.name == \"$REPO_NAME\") | .license" | head -1)

if [[ -z "$LICENSE" || "$LICENSE" == "null" ]]; then
  fail "no license assignment in map for '$REPO_NAME'"
fi

log "repo: $REPO_NAME → license: $LICENSE"

YEAR=$(yaml '.defaults.year')
COPYRIGHT_HOLDER=$(yaml '.defaults.copyright_holder')

# ---- Mode detection ----

IS_MIXED=no
if [[ "$LICENSE" == "MIXED" ]]; then
  IS_MIXED=yes
  log "mode: per-directory (MIXED — resolving license per source file)"
fi

# ---- For non-MIXED repos, resolve header up-front ----

if [[ "$IS_MIXED" == "no" ]]; then
  HEADER_TEMPLATE=$(yaml ".licenses.\"$LICENSE\".header_template")

  if [[ -z "$HEADER_TEMPLATE" || "$HEADER_TEMPLATE" == "null" ]]; then
    log "license '$LICENSE' has no header_template"
    log "(correct for content licenses: CC BY 4.0, CC BY-ND 4.0)"
    log "no source-file headers to stamp — exiting"
    exit 0
  fi

  HEADER_SUBS=$(yaml ".licenses.\"$LICENSE\".header_substitutions // {}")
  PROP_ID=$(echo "$HEADER_SUBS" | yq -r '."${proprietary-license-id}" // ""')

  if [[ -n "$PROP_ID" ]]; then
    SPDX_ID="$PROP_ID"
  else
    SPDX_ID="$LICENSE"
  fi

  log "spdx-id: $SPDX_ID"

  HEADER_BODY=$(cat "$FRE_ROOT/$HEADER_TEMPLATE")
  HEADER_BODY="${HEADER_BODY//\$\{year\}/$YEAR}"
  HEADER_BODY="${HEADER_BODY//\$\{proprietary-license-id\}/$SPDX_ID}"
fi

# ---- For MIXED repos, load monorepo_directories rules sorted by prefix length ----

if [[ "$IS_MIXED" == "yes" ]]; then
  declare -a MONO_KEYS
  while IFS= read -r key; do
    MONO_KEYS+=("$key")
  done < <(yq -r '.monorepo_directories | keys | .[]' "$MAP" | awk '{print length "\t" $0}' | sort -rn | cut -f2)
fi

# Resolve a file's relative path to its license via longest-prefix match
# against monorepo_directories. Prints the license identifier (empty if
# no rule matches).
resolve_file_license() {
  local rel="$1" prefix
  for prefix in "${MONO_KEYS[@]}"; do
    if [[ "$rel" == "$prefix"* ]]; then
      yaml ".monorepo_directories.\"$prefix\""
      return
    fi
  done
}

# ---- Comment-style dispatch by extension ----

comment_style() {
  local file="$1" base ext
  base=$(basename "$file")
  ext="${base##*.}"
  case "$base" in
    Dockerfile|Makefile|*.dockerfile) echo hash; return ;;
  esac
  case "$ext" in
    js|jsx|ts|tsx|go|java|kt|kts|c|cpp|cc|cxx|h|hpp|hxx|rs|scala|swift|cs|m|mm)
      echo slash ;;
    py|rb|sh|bash|zsh|fish|pl|pm|r|R|yaml|yml|toml|ini|cfg)
      echo hash ;;
    sql|hs|lhs|lua|ada)
      echo dashdash ;;
    css|scss|sass|less)
      echo cblock ;;
    html|htm|vue)
      echo htmlblock ;;
    *)
      echo skip ;;
  esac
}

wrap_header() {
  local style="$1" body="$2"
  case "$style" in
    slash)
      while IFS= read -r line; do
        [[ -n "$line" ]] && echo "// $line" || echo "//"
      done <<< "$body"
      ;;
    hash)
      while IFS= read -r line; do
        [[ -n "$line" ]] && echo "# $line" || echo "#"
      done <<< "$body"
      ;;
    dashdash)
      while IFS= read -r line; do
        [[ -n "$line" ]] && echo "-- $line" || echo "--"
      done <<< "$body"
      ;;
    cblock)
      echo "/*"
      while IFS= read -r line; do
        [[ -n "$line" ]] && echo " * $line" || echo " *"
      done <<< "$body"
      echo " */"
      ;;
    htmlblock)
      echo "<!--"
      while IFS= read -r line; do
        [[ -n "$line" ]] && echo "  $line" || echo ""
      done <<< "$body"
      echo "-->"
      ;;
  esac
}

# ---- Skip rules ----

is_excluded_path() {
  local rel="$1"
  case "$rel" in
    # Third-party and vendored code (adapter stubs, upstream sources,
    # wrappers — none are Woodfine-authored, so no Woodfine SPDX header)
    */node_modules/*|*/vendor/*|vendor-*|*/vendor-*|vendors-*|*/vendors-*)
      return 0 ;;
    # Build artifacts, virtual envs, caches
    */.venv/*|*/venv/*|*/.tox/*|*/dist/*|*/build/*|*/target/*|*/.next/*|*/.nuxt/*|*/.cache/*|*/__pycache__/*|*/.git/*)
      return 0 ;;
    # Data directories (files are already .json/.mmdb-style data, not source)
    discovery-queue/*|*/discovery-queue/*)
      return 0 ;;
    # Lockfiles and binaries
    *.min.js|*.min.css|*.lock|package-lock.json|yarn.lock|pnpm-lock.yaml|Gemfile.lock|go.sum|Cargo.lock|poetry.lock)
      return 0 ;;
    # Image, font, binary data files
    *.svg|*.png|*.jpg|*.jpeg|*.gif|*.ico|*.woff|*.woff2|*.ttf|*.eot|*.pdf|*.zip|*.tar|*.gz|*.mmdb)
      return 0 ;;
  esac
  return 1
}

# Returns: match | other | none
# Args: <file> <expected-spdx-id>
existing_header_status() {
  local file="$1" expected_spdx="$2" head20
  head20=$(head -20 "$file" 2>/dev/null || true)
  if ! echo "$head20" | grep -q 'SPDX-License-Identifier:'; then
    echo none; return
  fi
  if echo "$head20" | grep -q "SPDX-License-Identifier:.*$expected_spdx" \
     && echo "$head20" | grep -qi "Woodfine Capital Projects"; then
    echo match; return
  fi
  echo other
}

# Args: <file> <style> <header-body>
stamp_file() {
  local file="$1" style="$2" body="$3"
  local header tmp
  header=$(wrap_header "$style" "$body")
  tmp=$(mktemp)

  if head -1 "$file" | grep -q '^#!'; then
    head -1 "$file" > "$tmp"
    printf '%s\n\n' "$header" >> "$tmp"
    tail -n +2 "$file" >> "$tmp"
  else
    printf '%s\n\n' "$header" > "$tmp"
    cat "$file" >> "$tmp"
  fi

  if [[ "$MODE" == "check" ]]; then
    log "  would stamp: $file"
    rm -f "$tmp"
  else
    mv "$tmp" "$file"
    log "  stamped: $file"
    CHANGED=yes
  fi
}

# ---- Walk ----

CHANGED=no
stamped=0 skipped_path=0 skipped_existing=0 skipped_vendored=0 skipped_ext=0 skipped_no_rule=0 skipped_content=0

while IFS= read -r file; do
  rel="${file#$TARGET/}"

  if is_excluded_path "$rel"; then
    skipped_path=$((skipped_path + 1))
    continue
  fi

  style=$(comment_style "$file")
  if [[ "$style" == "skip" ]]; then
    skipped_ext=$((skipped_ext + 1))
    continue
  fi

  # Resolve per-file SPDX_ID and HEADER_BODY.
  # For non-MIXED repos, these are already set at the top.
  # For MIXED repos, resolve via monorepo_directories.
  file_spdx_id="${SPDX_ID:-}"
  file_header_body="${HEADER_BODY:-}"

  if [[ "$IS_MIXED" == "yes" ]]; then
    file_license=$(resolve_file_license "$rel")
    if [[ -z "$file_license" ]]; then
      skipped_no_rule=$((skipped_no_rule + 1))
      continue
    fi
    file_header_template=$(yaml ".licenses.\"$file_license\".header_template")
    if [[ -z "$file_header_template" || "$file_header_template" == "null" ]]; then
      skipped_content=$((skipped_content + 1))
      continue
    fi
    file_spdx_id="$file_license"
    file_header_body=$(cat "$FRE_ROOT/$file_header_template")
    file_header_body="${file_header_body//\$\{year\}/$YEAR}"
  fi

  status=$(existing_header_status "$file" "$file_spdx_id")
  case "$status" in
    match) skipped_existing=$((skipped_existing + 1)); continue ;;
    other) skipped_vendored=$((skipped_vendored + 1));  continue ;;
    none)  stamp_file "$file" "$style" "$file_header_body"; stamped=$((stamped + 1)) ;;
  esac
done < <(find "$TARGET" -type f -not -path '*/.git/*')

# ---- Summary ----

log ""
log "Summary for $REPO_NAME:"
log "  stamped:               $stamped"
log "  already had header:    $skipped_existing"
log "  vendored (other SPDX): $skipped_vendored"
log "  excluded path:         $skipped_path"
log "  unhandled extension:   $skipped_ext"
if [[ "$IS_MIXED" == "yes" ]]; then
  log "  content license dir:   $skipped_content"
  log "  no monorepo rule:      $skipped_no_rule"
fi

if [[ "$MODE" != "check" && "$CHANGED" == "yes" ]]; then
  log ""
  log "Files stamped. Review changes and commit manually."
fi
