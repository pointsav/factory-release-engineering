#!/usr/bin/env bash
#
# verify-license-closure.sh
# ──────────────────────────────────────────────────────────────────────────
# Hard-fails if any Apache-2.0-tier directory in pointsav-monorepo has an
# in-process Cargo path dependency on a directory assigned a stricter tier
# (AGPL-3.0-or-later, FSL-1.1-ALv2, PointSav-ARR) — the exact class of
# mislabeling risk found manually during the 2026-09-01 licensing-architecture
# execution (os-console/os-totebox/app-console-content/app-console-system all
# had real cross-tier dependencies a one-time audit caught; this is that audit
# turned into a standing CI check, per BRIEF-workspace-governance-and-
# promotion-redesign.md item 9's "verify-license-closure" recommendation).
#
# Read-only; never modifies the target. Resolves each directory's license
# tier the same way propagate-licenses.sh does: exact monorepo_directories
# entry wins, then longest-matching prefix pattern, exact overrides win over
# prefix defaults.
#
# Usage:
#   verify-license-closure.sh <pointsav-monorepo-path>
#   verify-license-closure.sh --json <pointsav-monorepo-path>
#
# Exit codes:
#   0 — no cross-tier violations found
#   1 — at least one violation found
#   2 — error (missing map, bad arguments, target not found, etc.)
# ──────────────────────────────────────────────────────────────────────────

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRE_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
MAP="$FRE_ROOT/mapping/repo-license-map.yaml"

[[ -f "$MAP" ]] || { echo "ERROR: mapping file not found: $MAP" >&2; exit 2; }

OUTPUT=human
TARGET=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --json) OUTPUT=json; shift ;;
    -*)     echo "ERROR: unknown option: $1" >&2; exit 2 ;;
    *)      TARGET="$1"; shift ;;
  esac
done
[[ -n "$TARGET" ]] || { echo "Usage: verify-license-closure.sh [--json] <pointsav-monorepo-path>" >&2; exit 2; }
[[ -d "$TARGET" ]] || { echo "ERROR: not a directory: $TARGET" >&2; exit 2; }

python3 - "$MAP" "$TARGET" "$OUTPUT" <<'PYEOF'
import sys, os, re, glob, yaml

map_path, target, output = sys.argv[1], sys.argv[2], sys.argv[3]

with open(map_path) as f:
    m = yaml.safe_load(f)

md = m.get("monorepo_directories", {}) or {}
exact = {}
prefixes = []
for k, v in md.items():
    # This map's own convention (confirmed against the live file, not assumed):
    # a trailing "/" marks an exact directory match ("os-mediakit/"); a key with
    # no trailing slash is a prefix pattern ("moonshot-", "service-", "app-console-").
    # There is no "*" wildcard character anywhere in this file's actual key syntax.
    if k.endswith("/"):
        exact[k.rstrip("/")] = v
    else:
        prefixes.append((k, v))
# longest-prefix-first so matching picks the most specific pattern
prefixes.sort(key=lambda t: -len(t[0]))

def tier_of(relpath):
    # relpath may be a bare top-level dir name ("os-totebox") or a deeper
    # relative path ("service-slm/crates/slm-doorman-server") -- resolve
    # against the FULL path first (matches add-spdx-headers.sh's
    # resolve_file_license() convention: nested exact/prefix keys like
    # "service-slm/crates/slm-doorman/" must win over the shorter "service-"
    # prefix). Falls back to prefix matching against the full path, longest
    # first. Fixed 2026-09-25 -- previously truncated to the top-level
    # segment only, which could never see a nested override and produced
    # false cross-tier violations for exactly the kind of sub-crate split
    # the 2026-09-25 linkage-surface-boundary ratification introduced.
    if relpath in exact:
        return exact[relpath]
    for pfx, lic in prefixes:
        if relpath.startswith(pfx):
            return lic
    return None

# Discover every directory under target with its own Cargo.toml (a crate root)
crate_dirs = []
for entry in sorted(os.listdir(target)):
    full = os.path.join(target, entry)
    if os.path.isdir(full) and os.path.isfile(os.path.join(full, "Cargo.toml")):
        crate_dirs.append(entry)

PATH_DEP_RE = re.compile(r'path\s*=\s*"([^"]+)"')

def path_deps(cargo_toml_path):
    deps = []
    try:
        with open(cargo_toml_path) as f:
            content = f.read()
    except OSError:
        return deps
    for m2 in PATH_DEP_RE.finditer(content):
        deps.append(m2.group(1))
    return deps

def resolve_dep_path(base_dir, rel_path):
    # Resolve a path dependency relative to its crate, as a full path
    # relative to the monorepo root (NOT truncated to the top-level segment
    # -- a nested monorepo_directories key like "service-slm/crates/
    # slm-doorman-server/" must be resolvable, see tier_of() above). Fixed
    # 2026-09-25 alongside tier_of().
    abs_path = os.path.normpath(os.path.join(target, base_dir, rel_path))
    try:
        rel_to_target = os.path.relpath(abs_path, target)
    except ValueError:
        return None
    if rel_to_target.startswith(".."):
        return None  # escapes the monorepo entirely -- not this check's concern
    return rel_to_target.replace(os.sep, "/")

violations = []
checked = 0
for crate_dir in crate_dirs:
    src_tier = tier_of(crate_dir)
    if src_tier != "Apache-2.0":
        continue
    checked += 1
    cargo_toml = os.path.join(target, crate_dir, "Cargo.toml")
    for rel_path in path_deps(cargo_toml):
        dep_full = resolve_dep_path(crate_dir, rel_path)
        if dep_full is None or dep_full == crate_dir or dep_full.split("/")[0] == crate_dir:
            continue
        dep_tier = tier_of(dep_full)
        if dep_tier is not None and dep_tier != "Apache-2.0":
            violations.append({
                "apache_crate": crate_dir,
                "path_dependency": rel_path,
                "resolves_to": dep_full,
                "resolves_to_tier": dep_tier,
            })
    # Also check nested crates (e.g. app-orchestration-slm/crates/*) for
    # path deps escaping their own sub-workspace into a different top-level dir.
    for nested in glob.glob(os.path.join(target, crate_dir, "**", "Cargo.toml"), recursive=True):
        if nested == cargo_toml:
            continue
        nested_rel_dir = os.path.dirname(os.path.relpath(nested, target)).replace(os.sep, "/")
        for rel_path in path_deps(nested):
            dep_full = resolve_dep_path(nested_rel_dir, rel_path)
            if dep_full is None or dep_full.split("/")[0] == crate_dir:
                continue
            dep_tier = tier_of(dep_full)
            if dep_tier is not None and dep_tier != "Apache-2.0":
                violations.append({
                    "apache_crate": f"{crate_dir} (via {nested_rel_dir})",
                    "path_dependency": rel_path,
                    "resolves_to": dep_full,
                    "resolves_to_tier": dep_tier,
                })

if output == "json":
    import json
    print(json.dumps({"checked": checked, "violations": violations}, indent=2))
else:
    print(f"[verify-license-closure] {checked} Apache-2.0-tier crate(s) checked")
    if not violations:
        print("[verify-license-closure] CLEAN — no cross-tier path dependencies found")
    else:
        for v in violations:
            print(f"  ✗ {v['apache_crate']} -> {v['path_dependency']} (resolves to {v['resolves_to']}, tier: {v['resolves_to_tier']})")
        print(f"[verify-license-closure] {len(violations)} VIOLATION(S) FOUND")

sys.exit(1 if violations else 0)
PYEOF
