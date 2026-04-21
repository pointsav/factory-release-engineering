#!/usr/bin/env bash
#
# propagate-licenses.sh
# ──────────────────────────────────────────────────────────────────────────
# Propagates licenses, NOTICE files, and policy documents from the
# factory-release-engineering canonical directory into a target repository
# according to mapping/repo-license-map.yaml.
#
# Reads:  factory-release-engineering/mapping/repo-license-map.yaml
#         factory-release-engineering/licenses/*.txt
#         factory-release-engineering/policies/*.md
# Writes: <target-repo>/LICENSE
#         <target-repo>/NOTICE              (if license requires)
#         <target-repo>/CODE_OF_CONDUCT.md
#         <target-repo>/CONTRIBUTING.md     (if license requires, and if
#                                            policies/CONTRIBUTING.md exists)
#         <target-repo>/SECURITY.md         (likewise)
#         <target-repo>/TRADEMARK.md        (likewise)
#
# Does NOT modify .git, commit, or push. Operator reviews staged changes
# and commits manually.
#
# Usage:
#   propagate-licenses.sh <target-repo-path>
#   propagate-licenses.sh --all <parent-directory>
#   propagate-licenses.sh --check <target-repo-path>
#   propagate-licenses.sh --help
#
# Dependencies:
#   - yq (mikefarah version) — https://github.com/mikefarah/yq
#   - git
# ──────────────────────────────────────────────────────────────────────────

set -euo pipefail

# ---- Locate the factory-release-engineering root ----

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
MAP="$FRE_ROOT/mapping/repo-license-map.yaml"

if [[ ! -f "$MAP" ]]; then
  echo "ERROR: mapping file not found: $MAP" >&2
  exit 2
fi

# ---- Prerequisite tools ----

for tool in yq git; do
  command -v "$tool" >/dev/null 2>&1 || {
    echo "ERROR: required tool not found: $tool" >&2
    case "$tool" in
      yq)  echo "       Install from https://github.com/mikefarah/yq" >&2 ;;
    esac
    exit 2
  }
done

# ---- Argument parsing ----

usage() {
  sed -n '/^# Usage:/,/^# Dependencies:/p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
  exit "${1:-0}"
}

MODE=single
TARGET=""

case "${1:-}" in
  -h|--help)   usage 0 ;;
  --all)       MODE=all;    TARGET="${2:?--all requires a parent directory}" ;;
  --check)     MODE=check;  TARGET="${2:?--check requires a target repo path}" ;;
  "")          usage 2 ;;
  -*)          echo "ERROR: unknown option: $1" >&2; usage 2 ;;
  *)           TARGET="$1" ;;
esac

# ---- Helpers ----

yaml() { yq -r "$1" "$MAP"; }

log()  { printf '[propagate] %s\n' "$*"; }
warn() { printf '[propagate] WARN: %s\n' "$*" >&2; }
fail() { printf '[propagate] FAIL: %s\n' "$*" >&2; exit 1; }

# Resolve a repo name → license SPDX identifier (or empty if not in map).
resolve_license() {
  local repo_name="$1"
  yaml ".repositories[] | select(.name == \"$repo_name\") | .license" | head -1
}

# Render a canonical source file with placeholders substituted.
# stdout: the rendered text. stderr: nothing.
# Args: <source-path> <license-spdx-id>
render_substituted() {
  local src="$1" license="$2"
  if [[ ! -f "$src" ]]; then
    warn "missing canonical artifact: $src"
    return 1
  fi

  local year copyright_holder
  year=$(yaml '.defaults.year')
  copyright_holder=$(yaml '.defaults.copyright_holder')

  # Per-license header substitutions (e.g. proprietary ${proprietary-license-id})
  local header_subs
  header_subs=$(yaml ".licenses.\"$license\".header_substitutions // {}")

  # Apply: start with defaults, then overlay per-license.
  local content
  content=$(cat "$src")
  content="${content//\$\{year\}/$year}"
  content="${content//\$\{licensor name\}/$copyright_holder}"
  content="${content//\$\{copyright holder\}/$copyright_holder}"

  # Substitute any license-specific header placeholders (proprietary only).
  local license_ref_val
  license_ref_val=$(echo "$header_subs" | yq -r '."${proprietary-license-id}" // ""' -)
  if [[ -n "$license_ref_val" ]]; then
    content="${content//\$\{proprietary-license-id\}/$license_ref_val}"
  fi

  printf '%s\n' "$content"
}

# Write a target file iff content differs. Prints a one-line summary.
# Args: <target-path> <content (via stdin)>
# Sets CHANGED=yes if a write occurred.
write_if_different() {
  local target="$1"
  local new_content
  new_content=$(cat)

  if [[ "$MODE" == "check" ]]; then
    if [[ -f "$target" ]] && diff -q <(printf '%s' "$new_content") "$target" >/dev/null 2>&1; then
      log "  ok: $target (matches canonical)"
    else
      log "  would update: $target"
      if [[ -f "$target" ]]; then
        diff -u "$target" <(printf '%s' "$new_content") || true
      fi
    fi
    return
  fi

  if [[ -f "$target" ]] && diff -q <(printf '%s' "$new_content") "$target" >/dev/null 2>&1; then
    log "  unchanged: $target"
    return
  fi

  printf '%s' "$new_content" > "$target"
  log "  wrote: $target"
  CHANGED=yes
}

# Propagate a single policy by name. Looks up policies/<POLICY>.md and
# copies it (with substitutions) into the target repo.
propagate_policy() {
  local target_root="$1" license="$2" policy="$3"
  local src="$FRE_ROOT/policies/$policy.md"
  if [[ ! -f "$src" ]]; then
    warn "  policy source missing: $src (skipping $policy for this repo)"
    return
  fi
  render_substituted "$src" "$license" | write_if_different "$target_root/$policy.md"
}

# Append the bilingual README section to the target repo's README.md.
# Reads readmes/license-section-{en,es}.md, applies substitutions, and
# writes between marker comments. Idempotent: replaces any existing
# marked block on re-run rather than duplicating it.
propagate_bilingual_readme() {
  local target_root="$1" license="$2"
  local target_readme="$target_root/README.md"
  local begin_marker="<!-- BEGIN: factory-release-engineering license-section -->"
  local end_marker="<!-- END: factory-release-engineering license-section -->"

  local year copyright_holder
  year=$(yaml '.defaults.year')
  copyright_holder=$(yaml '.defaults.copyright_holder')

  local en_content es_content

  if [[ "$license" == "MIXED" ]]; then
    # Multi-license repos get a pointer section, not the standard templated
    # "licensed under the X" phrasing. The LICENSE file (MIXED-MONOREPO-NOTICE)
    # is authoritative; the README section just points readers there.
    en_content=$(printf '## License\n\nThis repository contains code under multiple licenses. See the `LICENSE` file in the root of this repository for the canonical multi-license notice, which is authoritative. Each source file carries an SPDX-License-Identifier header identifying the license applicable to that file.\n\nCopyright (c) %s %s. All rights not expressly granted by the applicable licenses are reserved.' "$year" "$copyright_holder")
    es_content=$(printf '## Licencia\n\nEste repositorio contiene código bajo múltiples licencias. Véase el archivo `LICENSE` en la raíz del repositorio para el aviso canónico de múltiples licencias, el cual es la versión autoritativa. Cada archivo fuente incluye un encabezado SPDX-License-Identifier que identifica la licencia aplicable a ese archivo.\n\nCopyright (c) %s %s. Se reservan todos los derechos no concedidos expresamente por las licencias aplicables.' "$year" "$copyright_holder")
  else
    local en_src="$FRE_ROOT/readmes/license-section-en.md"
    local es_src="$FRE_ROOT/readmes/license-section-es.md"

    if [[ ! -f "$en_src" ]]; then
      warn "  readmes/license-section-en.md not found — skipping bilingual append"
      return
    fi

    local corporate_contact commercial_alt
    corporate_contact=$(yaml '.defaults.contacts.corporate')
    commercial_alt=$(yaml ".licenses.\"$license\".commercial_alternative // \"\"")

    en_content=$(cat "$en_src")
    es_content=$(cat "$es_src" 2>/dev/null || echo "")

    en_content="${en_content//\$\{license_name\}/$license}"
    en_content="${en_content//\$\{year\}/$year}"
    en_content="${en_content//\$\{copyright_holder\}/$copyright_holder}"
    es_content="${es_content//\$\{license_name\}/$license}"
    es_content="${es_content//\$\{year\}/$year}"
    es_content="${es_content//\$\{copyright_holder\}/$copyright_holder}"

    if [[ -n "$commercial_alt" ]]; then
      local ca_en="If the terms of the $license do not accommodate your use case, a commercial alternative is available under the **$commercial_alt**. Contact $corporate_contact for details."
      local ca_es="Si los términos de la $license no se ajustan a su caso de uso, existe una alternativa comercial disponible bajo la **$commercial_alt**. Para más información, escriba a $corporate_contact."
      en_content="${en_content//\$\{commercial_alternative_en\}/$ca_en}"
      es_content="${es_content//\$\{commercial_alternative_es\}/$ca_es}"
    else
      en_content="${en_content//\$\{commercial_alternative_en\}/}"
      es_content="${es_content//\$\{commercial_alternative_es\}/}"
    fi
  fi

  local injected
  injected=$(printf '%s\n%s\n\n%s\n%s' "$begin_marker" "$en_content" "$es_content" "$end_marker")

  if [[ ! -f "$target_readme" ]]; then
    if [[ "$MODE" == "check" ]]; then
      log "  would create: $target_readme (with license section)"
    else
      printf '# %s\n\n%s\n' "$(basename "$target_root")" "$injected" > "$target_readme"
      log "  created: $target_readme (with license section)"
      CHANGED=yes
    fi
    return
  fi

  if grep -qF "$begin_marker" "$target_readme"; then
    local tmp; tmp=$(mktemp)
    awk -v begin="$begin_marker" -v end="$end_marker" '
      $0 == begin { skip = 1; next }
      $0 == end { skip = 0; next }
      !skip { print }
    ' "$target_readme" > "$tmp"
    if [[ "$MODE" == "check" ]]; then
      log "  would refresh bilingual README block in $target_readme"
      rm -f "$tmp"
    else
      printf '\n%s\n' "$injected" >> "$tmp"
      mv "$tmp" "$target_readme"
      log "  refreshed bilingual README block in $target_readme"
      CHANGED=yes
    fi
  else
    if [[ "$MODE" == "check" ]]; then
      log "  would append bilingual README block to $target_readme"
    else
      printf '\n%s\n' "$injected" >> "$target_readme"
      log "  appended bilingual README block to $target_readme"
      CHANGED=yes
    fi
  fi
}

# Main per-repo propagation.
propagate_one() {
  local target="$1"
  [[ -d "$target" ]] || fail "target is not a directory: $target"
  [[ -d "$target/.git" ]] || warn "target is not a git repo: $target (continuing anyway)"

  local repo_name
  repo_name=$(basename "$target")

  local license
  license=$(resolve_license "$repo_name")

  if [[ -z "$license" || "$license" == "null" ]]; then
    warn "no license assignment in map for '$repo_name' — skipping"
    return
  fi

  log "repo: $repo_name → license: $license"

  # License catalog entry
  local license_file
  license_file=$(yaml ".licenses.\"$license\".license_file")
  if [[ -z "$license_file" || "$license_file" == "null" ]]; then
    fail "license '$license' has no license_file in catalog"
  fi

  # LICENSE
  render_substituted "$FRE_ROOT/$license_file" "$license" \
    | write_if_different "$target/LICENSE"

  # NOTICE (if required)
  local notice_mode
  notice_mode=$(yaml ".licenses.\"$license\".notice_file")
  case "$notice_mode" in
    required)
      # Minimal Woodfine NOTICE.
      local year copyright_holder
      year=$(yaml '.defaults.year')
      copyright_holder=$(yaml '.defaults.copyright_holder')
      printf '%s %s\nAll rights reserved.\n\nThis product includes software developed by %s.\n' \
        "$copyright_holder" "$year" "$copyright_holder" \
        | write_if_different "$target/NOTICE"
      ;;
    optional|null|"")
      : ;;
  esac

  # Policies
  local policies
  policies=$(yaml ".licenses.\"$license\".policies[]?")
  while IFS= read -r policy; do
    [[ -z "$policy" ]] && continue
    propagate_policy "$target" "$license" "$policy"
  done <<< "$policies"

  # Bilingual README section
  local bilingual
  bilingual=$(yaml ".licenses.\"$license\".bilingual_readme")
  if [[ "$bilingual" == "true" ]]; then
    propagate_bilingual_readme "$target" "$license"
  fi

  log "  done: $repo_name"
}

# ---- Main ----

CHANGED=no

case "$MODE" in
  single|check)
    propagate_one "$TARGET"
    ;;
  all)
    [[ -d "$TARGET" ]] || fail "parent directory not found: $TARGET"
    while IFS= read -r repo_name; do
      [[ -z "$repo_name" ]] && continue
      if [[ -d "$TARGET/$repo_name" ]]; then
        propagate_one "$TARGET/$repo_name"
      else
        warn "repo in map not found under parent: $repo_name (expected $TARGET/$repo_name)"
      fi
    done < <(yaml '.repositories[].name')
    ;;
esac

if [[ "$MODE" != "check" && "$CHANGED" == "yes" ]]; then
  log ""
  log "Files written. Review the staged changes in the target repo(s) and commit manually."
fi
