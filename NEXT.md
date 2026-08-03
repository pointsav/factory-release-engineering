# factory-release-engineering — NEXT

Open defects and governance items. No CHANGELOG.md exists in this repo (corrected 2026-08-02, previously claimed items "move to CHANGELOG.md" — they don't; resolved items stay in place below, marked Closed with their resolution).

---

## Open defects

### DEF-001 — §4.3 / monorepo gap: `app-orchestration-*` undefined

**Raised:** 2026-05-07 from project-bim session-close audit
**Closed:** 2026-05-20 — operator ratified FSL-1.1-ALv2 (follow inheritance rule).
**Superseded:** 2026-07-07 — `os-interface` (and therefore `app-orchestration-*` by
inheritance) was reclassified from FSL-1.1-ALv2 to PointSav-ARR (proprietary,
permanent commercial moat — Doctrine claim #23; `BRIEF-software-licensing-structure.md`).
This entry was never updated to reflect that at the time; corrected 2026-08-02.

`app-orchestration-*` follows the inheritance rule: `os-interface` → PointSav-ARR.
`app-orchestration-bim` Cargo.toml declares `license = "LicenseRef-PointSav-ARR"`
— already correct, written when the crate was created. See DEF-003 below for the
one remaining gap (the crate's `LICENSE` file itself has the wrong text).

---

### DEF-002 — EUPL-1.2 not in license catalog

**Raised:** 2026-05-07 from project-bim session-close audit
**Closed:** 2026-05-20 — N/A. No directory in pointsav-monorepo uses EUPL-1.2 following
DEF-001 closure. EUPL-1.2 catalog entry and stub files retained for future reference
but no propagation action is required.

---

### DEF-003 — `app-orchestration-bim/LICENSE` has unsubstituted FSL template text

**Raised:** 2026-05-07 from project-bim session-close audit
**Status:** open — project-bim cluster scope; corrected/narrowed 2026-08-02.

`app-orchestration-bim` crate now exists (confirmed 2026-08-02, no longer Reserved-folder).
Verified this session: SPDX headers on `.rs` files and the `Cargo.toml` `license` field
are already correct (`LicenseRef-PointSav-ARR`, matching the 2026-07-07 classification).
The one remaining gap: `app-orchestration-bim/LICENSE` still contains the raw
FSL-1.1-ALv2 template text with literal unsubstituted `${year}`/`${licensor name}`
placeholders — leftover from before the 2026-07-07 PointSav-ARR correction, and never
propagated correctly even for FSL (the placeholders were never filled either way).

**Required action (project-bim cluster session):**
- [ ] Replace `app-orchestration-bim/LICENSE` with `licenses/PointSav-ARR.txt`'s text
      (substituted: `${year}` → `2026`), matching what the Cargo.toml/SPDX headers
      already correctly declare. Command Session relayed this via mailbox 2026-08-02
      rather than editing another archive's crate content directly.

---

### DEF-004 — DTCG token data layer unlicensed (`woodfine-design-bim/`)

**Raised:** 2026-05-07 from project-bim session-close audit
**Closed:** 2026-05-20 — resolved by earlier project-bim session work.

`woodfine-design-bim` was renamed to `woodfine-bim-library` and its LICENSE file
changed to Apache-2.0 (commit 7267e15). The repo-level Apache-2.0 LICENSE covers
all DTCG JSON token files. JSON files cannot carry inline SPDX comment headers;
coverage by the repo-level LICENSE is the correct resolution. `woodfine-bim-library`
added to repo-license-map.yaml and LICENSE-MATRIX.md §3.2 this session.

---

### DEF-005 — `factory-release-engineering` LICENSE expected to diverge from MIXED-MONOREPO-NOTICE.txt

**Raised:** 2026-05-24 from license audit (project-editorial)
**Status:** open — expected divergence; verify-repo-compliance.sh reports `license-file diverges`.

The governance repo's root LICENSE is a per-file breakdown (licenses/ → upstream copyright;
policies/, headers/, mapping/ → CC BY 4.0; scripts/ → AGPL; cla/ → all rights reserved).
`verify-repo-compliance.sh` compares it against `licenses/MIXED-MONOREPO-NOTICE.txt`, which is
a per-directory notice intended for engineering monorepos. These are legitimately different
formats for different purposes.

**Required actions (governance resolution needed):**
- [ ] Option A: Create `licenses/MIXED-FRE-NOTICE.txt` as the canonical per-file notice for
      the governance repo, and update `repo-license-map.yaml` to reference it for
      `factory-release-engineering`.
- [ ] Option B: Update `verify-repo-compliance.sh` to accept a per-repo `license_file_override`
      field in the YAML that points to a repo-specific canonical file.
- [ ] Option C: Assign `factory-release-engineering` its own license key (e.g., `MIXED-FRE`)
      in the license catalog.

Until resolved: the single `license-file` failure in `verify-repo-compliance.sh` on
`factory-release-engineering` is expected and does not indicate a compliance problem.

---

### DEF-006 — `github/` staging templates never propagated to downstream `.github/`

**Raised:** 2026-08-02, GitHub public-presentation audit.
**Status:** open — feature work, not part of the 2026-08-02 docs-remediation pass.

`github/CODEOWNERS.template`, `github/ISSUE_TEMPLATE/`, and
`github/PULL_REQUEST_TEMPLATE.md` are staged in this repo but
`scripts/propagate-licenses.sh` has no logic to copy or substitute any of
them into a target repo's real `.github/` directory (confirmed by grep —
zero references to `.github`, `ISSUE_TEMPLATE`, `CODEOWNERS`, or
`editorconfig` in the script). `CONTRIBUTING.md` previously claimed these
were live in every repo; corrected 2026-08-02 to describe actual current
state instead.

**Required actions (future propagation-tooling session):**
- [ ] Extend `propagate-licenses.sh` to copy `github/ISSUE_TEMPLATE/` and
      `github/PULL_REQUEST_TEMPLATE.md` to each target repo's `.github/`
- [ ] Add `${default_owners}`/`${release_eng_owners}`/`${infra_owners}`
      substitution logic for `github/CODEOWNERS.template` → target repo's
      `.github/CODEOWNERS`, sourced from a new per-repo owners field in
      `mapping/repo-license-map.yaml`
- [ ] Add a canonical `.editorconfig` source file to this repo and
      propagate it the same way

---

*Copyright © 2026 Woodfine Capital Projects Inc. See LICENSE for terms.*

*Woodfine Capital Projects™, MCorp™, PointSav Digital Systems™, Totebox Orchestration™, and Totebox Archive™ are trademarks of Woodfine Capital Projects Inc., used in Canada, the United States, Latin America, and Europe. All other trademarks are the property of their respective owners.*
