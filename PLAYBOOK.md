# PLAYBOOK

Version 1.0 — Operational runbook
Effective 2026-04-20

Step-by-step rollout procedure for propagating licenses, policies, and
SPDX headers from `factory-release-engineering` into every PointSav
and Woodfine repository. Designed for execution by Claude Code acting
as the release-engineering operator, with a human reviewer approving
each PR before merge.

This playbook assumes `factory-release-engineering/mapping/repo-license-map.yaml`
is the authoritative source of truth. Any repository not in the map is
out of scope for this playbook until added.

---

## Preconditions

Before running any phase:

  1. `factory-release-engineering/` is cloned locally, on `main`,
     up-to-date.
  2. `mapping/repo-license-map.yaml` parses cleanly (run
     `python3 -c 'import yaml; yaml.safe_load(open("mapping/repo-license-map.yaml"))'`).
  3. All three scripts pass `bash -n`.
  4. Every license, header, and policy artifact referenced in the map
     exists on disk (run `scripts/verify-repo-compliance.sh` against a
     clean scratch directory to exercise missing-artifact warnings
     before touching real repos).
  5. `yq` (mikefarah) is installed and on `$PATH`.
  6. Operator has write access — either directly or via PR — to every
     target repository named in the map.

If any of (1)-(5) fail, stop and remediate before proceeding. Running
the playbook against a broken scaffold will produce broken target
repositories.

---

## Phase 1 — Enumerate targets

Extract the target-repo list from the map:

```bash
yq -r '.repositories[].name' mapping/repo-license-map.yaml
```

Confirm the list matches expectation. If any repos are missing, stop
and resolve before running subsequent phases. See
`LICENSE-MATRIX.md` §7 for the consolidated list of open enumeration
questions.

---

## Phase 2 — Clone targets to a working directory

```bash
export ROLLOUT_DIR="$HOME/rollout-$(date +%Y%m%d)"
mkdir -p "$ROLLOUT_DIR"
cd "$ROLLOUT_DIR"

while IFS= read -r repo; do
  org=$(yq -r ".repositories[] | select(.name == \"$repo\") | .organization" \
        /path/to/factory-release-engineering/mapping/repo-license-map.yaml)
  gh repo clone "$org/$repo"
done < <(yq -r '.repositories[].name' /path/to/factory-release-engineering/mapping/repo-license-map.yaml)
```

Verify every repo cloned successfully before proceeding.

---

## Phase 3 — Propagate licenses and policies

For each target:

```bash
cd "$ROLLOUT_DIR/<repo-name>"
git checkout -b release-eng/propagate-v1.0
/path/to/factory-release-engineering/scripts/propagate-licenses.sh .
git status     # review staged changes
git diff       # inspect content
```

The script writes LICENSE, NOTICE (if required), and policy files. It
does NOT commit.

If the diff looks wrong, do not commit. Fix the canonical source in
`factory-release-engineering/` and re-run. The script is idempotent.

When the diff is correct, commit:

```bash
git add LICENSE NOTICE CODE_OF_CONDUCT.md CONTRIBUTING.md SECURITY.md TRADEMARK.md
git commit -m "release-eng: propagate v1.0 canonical licenses and policies"
```

Repeat for every target. A batch variant exists:

```bash
/path/to/factory-release-engineering/scripts/propagate-licenses.sh --all "$ROLLOUT_DIR"
```

Use batch mode only after single-repo propagation has been verified
on at least two representative repos (one AGPL, one FSL).

---

## Phase 4 — Stamp SPDX headers

For each repository that carries source-file SPDX headers (AGPL, FSL,
PointSav-*):

```bash
cd "$ROLLOUT_DIR/<repo-name>"
/path/to/factory-release-engineering/scripts/add-spdx-headers.sh --check .
```

Review the "would stamp" output. If it looks correct, run without
`--check`:

```bash
/path/to/factory-release-engineering/scripts/add-spdx-headers.sh .
git add -A
git commit -m "release-eng: stamp SPDX headers"
```

Repositories under CC BY 4.0, CC BY-ND 4.0, and Apache-2.0 may skip
this phase (no source-file SPDX templates). See LICENSE-MATRIX.md
QUESTION E for Apache-2.0.

---

## Phase 5 — Verify compliance

For each repository:

```bash
cd "$ROLLOUT_DIR/<repo-name>"
/path/to/factory-release-engineering/scripts/verify-repo-compliance.sh .
```

Expected output: `[verify] COMPLIANT`.

If output is `DIVERGENT`, do not push the branch. Diagnose the
divergence (missing file, content mismatch, etc.) and resolve by
re-running Phase 3 or Phase 4 after fixing the canonical source.

For CI-style structured output:

```bash
/path/to/factory-release-engineering/scripts/verify-repo-compliance.sh --json . > verify.json
echo $?   # 0 = compliant, 1 = divergent, 2 = error
```

---

## Phase 6 — Push and open pull requests

```bash
cd "$ROLLOUT_DIR/<repo-name>"
git push -u origin release-eng/propagate-v1.0
gh pr create \
  --title "release-eng: propagate canonical licenses and policies (v1.0)" \
  --body "$(cat <<EOF
Propagated from factory-release-engineering v1.0.

- LICENSE, NOTICE (where required), CODE_OF_CONDUCT, CONTRIBUTING,
  SECURITY, TRADEMARK files generated from canonical sources.
- SPDX source-file headers stamped where applicable.
- verify-repo-compliance.sh reports COMPLIANT.

License: \$(yq -r ".repositories[] | select(.name == \"\$(basename \$(pwd))\") | .license" /path/to/factory-release-engineering/mapping/repo-license-map.yaml)
EOF
)"
```

Repeat for every target. Each PR gets human review before merge per
README §5 governance.

---

## Phase 7 — Post-merge verification

After PRs are merged, re-clone fresh and re-run Phase 5 verification.
This catches any hand-edits made during review that diverged from
canonical.

```bash
cd /tmp && rm -rf verify-post-merge && mkdir verify-post-merge && cd verify-post-merge
while IFS= read -r repo; do
  org=$(yq -r ".repositories[] | select(.name == \"$repo\") | .organization" \
        /path/to/factory-release-engineering/mapping/repo-license-map.yaml)
  gh repo clone "$org/$repo"
  /path/to/factory-release-engineering/scripts/verify-repo-compliance.sh "$repo"
done < <(yq -r '.repositories[].name' /path/to/factory-release-engineering/mapping/repo-license-map.yaml)
```

Any non-COMPLIANT repo at this stage is a defect: either the merge
introduced a regression or a post-merge edit drifted the repo from
canonical. Open a ticket and remediate.

---

## Rollback

License and policy propagation is additive. Rollback is performed
per-repo by reverting the propagation commit:

```bash
cd "$ROLLOUT_DIR/<repo-name>"
git revert <propagation-commit-sha>
git push
```

SPDX-header stamping is harder to rollback because it modifies many
files. Use `git revert` against the stamping commit specifically; do
not attempt manual un-stamping.

Do not rollback a license change (switching an in-force repo from
AGPL to FSL, for example) without MEMO-level authorization per
LICENSE-MATRIX.md §6.

---

## Common failure modes

**`no license assignment in map for '<repo-name>'`** — the repo is not
listed in `mapping/repo-license-map.yaml`. Add it to the map and
LICENSE-MATRIX.md in the same PR; rerun.

**`missing canonical artifact: <path>`** — a file referenced in the
YAML catalog does not exist in `factory-release-engineering/`. Check
whether the scaffold build-out is complete for the relevant license.
Some artifacts (CLA forms, GitHub templates) may be drafted but not
yet present.

**`bilingual README propagation not yet implemented`** — harmless
warning. The scripts will emit this until the bilingual README append
logic is wired into `propagate-licenses.sh`. Does not block rollout.

**`spdx-headers: X of Y source files missing or wrong`** — Phase 4
was skipped, incomplete, or the stamp logic mishandled an extension.
Re-run Phase 4 with `--check` to see which files were missed and why.

---

## Change control

Changes to this playbook are PR'd against
`factory-release-engineering/`. Significant changes (new phases, new
scripts invoked, new target-repo discovery mechanisms) require the
same review posture as changes to the scripts themselves.
