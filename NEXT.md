# factory-release-engineering — NEXT

Open defects and governance items. Resolved items move to CHANGELOG.md.

---

## Open defects

### DEF-001 — §4.3 / monorepo gap: `app-orchestration-*` undefined

**Raised:** 2026-05-07 from project-bim session-close audit
**Closed:** 2026-05-20 — operator ratified FSL-1.1-ALv2 (follow inheritance rule).

`app-orchestration-*` follows the inheritance rule: `os-interface` → FSL-1.1-ALv2.
The EUPL-1.2 exception row in repo-license-map.yaml and LICENSE-MATRIX.md §4.3
has been corrected. `app-orchestration-bim` Cargo.toml must declare
`license = "FSL-1.1-ALv2"` when the crate is written (project-bim scope).

---

### DEF-002 — EUPL-1.2 not in license catalog

**Raised:** 2026-05-07 from project-bim session-close audit
**Closed:** 2026-05-20 — N/A. No directory in pointsav-monorepo uses EUPL-1.2 following
DEF-001 closure. EUPL-1.2 catalog entry and stub files retained for future reference
but no propagation action is required.

---

### DEF-003 — SPDX headers missing from `app-orchestration-bim/src/*.rs`

**Raised:** 2026-05-07 from project-bim session-close audit
**Status:** open — project-bim cluster scope; blocks Stage 6 promotion.

`app-orchestration-bim` crate does not exist yet (Reserved-folder state as of 2026-05-20).
When the crate is written, all `.rs` source files must carry SPDX headers.

**Required actions (project-bim cluster session, when crate is written):**
- [ ] Add `// SPDX-FileCopyrightText: 2026 Woodfine Capital Projects Inc.` and
      `// SPDX-License-Identifier: FSL-1.1-ALv2` to every `.rs` file in
      `app-orchestration-bim/src/`
- [ ] Declare `license = "FSL-1.1-ALv2"` in `app-orchestration-bim/Cargo.toml`
- [ ] Commit in cluster/project-bim before Stage 6 promotion

---

### DEF-004 — DTCG token data layer unlicensed (`woodfine-design-bim/`)

**Raised:** 2026-05-07 from project-bim session-close audit
**Status:** open — pending operator decision on data-layer license.

The DTCG JSON token files in `woodfine-design-bim/` have no stated license. The
EUPL-1.2 Rust software and the DTCG data files are legally distinct works. A public
repository without a stated license defaults to all-rights-reserved, which conflicts
with the open-design-standard positioning of the BIM platform.

Recommended resolution: CC BY 4.0 for `woodfine-design-bim/*.dtcg.json` — consistent
with `content-wiki-documentation` (CC BY 4.0) and open-standard positioning.

**Required actions:**
- [ ] Operator decision: confirm CC BY 4.0, or select an alternative data-layer license
- [ ] Once decided: add `LICENSE` file to `woodfine-design-bim/` repo
- [ ] Add per-file SPDX headers to DTCG JSON files (project-bim cluster session)

---

*Copyright © 2026 Woodfine Capital Projects Inc. See LICENSE for terms.*

*Woodfine Capital Projects™, Woodfine Management Corp™, PointSav Digital Systems™, Totebox Orchestration™, and Totebox Archive™ are trademarks of Woodfine Capital Projects Inc., used in Canada, the United States, Latin America, and Europe. All other trademarks are the property of their respective owners.*
