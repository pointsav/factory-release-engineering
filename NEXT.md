# factory-release-engineering — NEXT

Open defects and governance items. Resolved items move to CHANGELOG.md.

---

## Open defects

### DEF-001 — §4.3 / monorepo gap: `app-orchestration-*` undefined

**Raised:** 2026-05-07 from project-bim session-close audit
**Status:** partial — row added to LICENSE-MATRIX §4.3 and repo-license-map.yaml 2026-05-07;
EUPL-1.2 exception to standard inheritance rule requires operator ratification.

`app-orchestration-bim` declares `license = "EUPL-1.2"` in Cargo.toml. The inheritance
rule (§4.3) maps `app-orchestration-*` → `os-interface` (→ `os-orchestration`) →
FSL-1.1-ALv2. EUPL-1.2 is an intentional override per the project-bim session, but the
exception is not yet governance-ratified.

**Required actions:**
- [ ] Operator decision: ratify EUPL-1.2 as the license for `app-orchestration-*`, OR
      revert Cargo.toml to FSL-1.1-ALv2 to follow the inheritance rule
- [ ] DEF-002 (EUPL-1.2 catalog) must close before propagation scripts run against
      `app-orchestration-bim`
- [ ] DEF-003 (SPDX headers) must close before Stage 6 promotion of cluster/project-bim

---

### DEF-002 — EUPL-1.2 not in license catalog

**Raised:** 2026-05-07 from project-bim session-close audit
**Status:** open — catalog stub added to repo-license-map.yaml 2026-05-07; license text
and header template pending.

`licenses/EUPL-1.2.txt` does not exist. `headers/eupl-1.2-header.txt` is a minimal stub.
The propagation and SPDX-header scripts will fail on EUPL-1.2 directories until both
files are present.

**Required actions:**
- [ ] Download canonical EUPL-1.2 text from the European Union Publications Office
      and save as `licenses/EUPL-1.2.txt`
- [ ] Verify `headers/eupl-1.2-header.txt` stub is sufficient, or expand to match the
      EUPL-1.2 notice block convention
- [ ] Add bilingual README license section for EUPL-1.2 in `readmes/` if required
- [ ] Mark catalog stub in repo-license-map.yaml as active once files land

---

### DEF-003 — SPDX headers missing from `app-orchestration-bim/src/*.rs`

**Raised:** 2026-05-07 from project-bim session-close audit
**Status:** open — project-bim cluster scope; blocks Stage 6 promotion.

All `.rs` source files under
`clones/project-bim/pointsav-monorepo/app-orchestration-bim/src/` have no
`SPDX-FileCopyrightText` or `SPDX-License-Identifier` headers.
PLAYBOOK Phase 4 requires these for non-CC repositories.

**Required actions (project-bim cluster session, after DEF-002 closes):**
- [ ] Add `// SPDX-FileCopyrightText: 2026 Woodfine Capital Projects Inc.` and
      `// SPDX-License-Identifier: EUPL-1.2` to every `.rs` file in
      `app-orchestration-bim/src/`
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
