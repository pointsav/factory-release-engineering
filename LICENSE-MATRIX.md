# LICENSE-MATRIX

Version 1.0 — Effective 2026-04-20
Copyright © 2026 Woodfine Capital Projects Inc. All rights reserved.

This matrix is effective as of the date above, subject to amendment
when MEMO V8 is ratified.

## 1. Purpose

This matrix is the authoritative mapping of repositories and monorepo
directories to their applicable licenses. It is the human-readable
companion to `mapping/repo-license-map.yaml`, which is the
machine-readable form read by the propagation scripts.

When the two diverge, the YAML file controls for automated propagation
and this matrix controls for human understanding. Divergences between
the two are defects and should be resolved in the same PR.

### 1.1 Per-country IP-holding note (Canada)

Copyright across all repositories listed in this matrix is held by
Woodfine Capital Projects Inc. ("WCP Inc.") under the Canadian-simple
posture described in the README §6. Two Canadian-specific points
inform the licensing posture:

1. **§ 13(3) first-ownership vs § 13(4) assignment.** WCP's holding
   of copyright is on the basis of Canadian Copyright Act § 13(3)
   (employer is first owner of in-scope employee work under a
   contract of service). § 13(3) creates first-ownership at the
   moment of fixation; no separate written assignment instrument is
   required for the right to vest. Distinguish this from § 13(4)
   assignments, which require a written-signed instrument and are
   subject to the § 14(1) reversionary interest below.
2. **§ 14(1) reversionary interest.** Where copyright is **assigned**
   under § 13(4) and the author is a natural person, the assignment
   automatically terminates 25 years after the author's death, with
   the reversionary interest passing to the author's estate. This
   provision **does not apply** to § 13(3) employer-vested
   first-ownership works (where the employer never received an
   "assignment"). It does apply to assignments from contractors,
   founders, or other natural-person contributors. The Canadian
   reversionary interest cannot be contracted out of for assignments;
   any downstream licensee taking under WCP-as-assignee should
   understand the time-bounded nature of the underlying chain-of-title
   for natural-person-authored works in the Canadian regime.

This section is informational, not legal advice. Counsel review is
recommended for any project where the chain-of-title shifts from
§ 13(3) employer-vested to § 13(4) assigned-from-contributor.

## 2. Authority

This matrix is maintained in the `factory-release-engineering`
repository at `pointsav/factory-release-engineering`. Changes are
proposed by pull request per README §5. Changes that affect commercial
terms require legal counsel review. Changes that affect the license of
an in-force repository or an in-force monorepo directory require MEMO
amendment or equivalent governance authority.

## 3. Repository inventory

Repositories are distributed across two GitHub organizations.

### 3.1 pointsav GitHub org (7 repos)

| Repository | License | Purpose |
|---|---|---|
| `pointsav-monorepo` | **MIXED** — see §4 | Platform code; per-directory licensing |
| `factory-release-engineering` | **MIXED** — governance repo | This repository; canonical source for licenses, policies, scripts |
| `content-wiki-documentation` | CC BY 4.0 | Open technical documentation |
| `pointsav-design-system` | Apache-2.0 | Open-source design system (matches IBM Carbon, Adobe Spectrum convention) |
| `pointsav-fleet-deployment` | PointSav-ARR | Operational deployment records |
| `pointsav-media-assets` | PointSav-ARR | Branded imagery |
| `pointsav.github.io` | Apache-2.0 | Public marketing site |

### 3.2 woodfine GitHub org (6 repos)

| Repository | License | Purpose |
|---|---|---|
| `content-wiki-corporate` | CC BY-ND 4.0 | Corporate content (no derivatives) |
| `content-wiki-projects` | CC BY-ND 4.0 | Project content (no derivatives) |
| `woodfine-bim-library` | Apache-2.0 | BIM Object Library — DTCG token data files |
| `woodfine-fleet-deployment` | PointSav-ARR | Operational deployment records |
| `woodfine-media-assets` | PointSav-ARR | Branded imagery |
| `woodfine.github.io` | Apache-2.0 | Public marketing site |

### 3.3 Translation restriction (CC BY-ND 4.0)

CC BY-ND 4.0 prohibits derivative works in public distribution. This
includes translations. Any Spanish-language version of
`content-wiki-corporate` or `content-wiki-projects` is prohibited by
this license without a separate agreement. These repositories are
English-only in public distribution.

### 3.4 PointSav-Commercial

PointSav-Commercial is governed by the bespoke
`licenses/PointSav-Commercial.txt`. It is not applied as a LICENSE
file in any public repository — it is distributed per-customer under
a negotiated Order Form. Commercial use context:

  (a) AGPLv3-alternative — for customers using AGPLv3 code without
      accepting AGPLv3 Section 13 copyleft obligations.

  ~~(b) FSL pre-DOSP...~~ **Removed 2026-09-25 — FSL-1.1-ALv2 retired as
  policy, see §4.7.** No PointSav repository or module carries FSL going
  forward; this commercial-use context no longer applies to anything live.

**Binary distribution (software.pointsav.com) — corrected 2026-08-02 to match
the §4.1/§4.1a/§4.3 license corrections of 2026-07-07; superseded again
2026-09-25 by the FSL retirement and linkage-surface boundary rule (§4.7):**

As copyright holder of all AGPL-3.0-or-later source code in `pointsav-monorepo`
under Canadian Copyright Act § 13(3), Woodfine Capital Projects Inc. distributes
pre-compiled binaries of AGPL-licensed modules under PointSav-Commercial terms
that convey Apache-2.0-equivalent rights to the purchaser: no copyleft
obligations; may fork, redistribute, and compete. This is not a source-level
relicensing — the GitHub source remains AGPL-3.0-or-later. It is a separate
commercial grant for the compiled binary artifact only. This tier is called
**PointSav Commercial (Apache-compatible)** in storefront copy and uses
`license_tier: commercial` in the `foundry-soft-v1` sidecar. As of 2026-09-25
this covers the modules still AGPL after §4.7's reconciliation:
`os-infrastructure`, `os-network-admin`, and their `app-network-*`/
`app-infrastructure-*` surfaces, plus any `os-console`/`os-totebox`/
`os-workplace` module pending its own archive's Apache-2.0 execution (§4.1c) —
this commercial grant remains the correct interim distribution vehicle for
each such module until its Cargo.toml/SPDX headers actually flip.

**FSL retired 2026-09-25 (§4.7) — the FSL $19 tier described in earlier
revisions of this paragraph no longer exists.** `os-privategit`, `os-totebox`,
and the `app-privategit-*`/`app-totebox-*` families resolve to Apache-2.0
(§4.1, §4.7) and are distributed **free** (`price_usdc: 0`, per the existing
"Apache entries must always be `price_usdc: 0`" invariant already enforced in
`app-privategit-software/src/main.rs`) — not the old $19 FSL price point.
`os-infrastructure`/`os-network-admin` resolve to AGPL-3.0-or-later (§4.1,
§4.7) and fall under the AGPL Commercial-grant paragraph above, same as any
other AGPL module. **`os-mediakit`/`app-mediakit-*` removed from the old FSL
paragraph 2026-09-01** — relicensed to Apache-2.0 (see §4.1, §4.2); the
`foundry-soft-v1` sidecar's `license_tier` enum needs a new `open` value
(`price_usdc: "0.00"`) to represent free Apache-tier distribution — not yet
implemented, tracked in NEXT.md.

**Not distributed under either tier above:** `os-orchestration` and
`app-orchestration-*` (in the private `pointsav-orchestration-private` repo,
§4.1b) are PointSav-ARR (proprietary, permanent commercial moat — §4.1a,
Doctrine claim #23) and are excluded from both the Apache-compatible
commercial grant and the (now-retired) FSL tier described here. This note
exists only to make the exclusion explicit, since a reader could otherwise
assume every AGPL directory eventually reaches the storefront under the
Commercial grant.

**Storefront layout, recommended 2026-09-25 (`BRIEF-dogfood-licensing-
handoff-2026-09-25.md`, project-dogfood):** three groups, not the prior
generic "Delivery/Platform/Infrastructure" tiering — **Appliances** (`os-*`,
free/open substrate, `$0 USDC`, grouped by function not alphabetically);
**Fleet Orchestration** (`os-orchestration` alone — the actual paid product,
buy-once/all-features per §4.1a); **Tools** (`tool-*`, all individually
downloadable per §4.7 item 5). Show the full intended catalog now, including
unbuilt slots greyed out as visible placeholders, filling in automatically as
each binary ships. Owner: project-software.

Specification: `conventions/software-distribution-substrate.md`.

## 4. Per-directory licensing inside `pointsav-monorepo`

The monorepo contains 102 top-level subdirectories assigned to
licenses as follows.

### 4.1 `os-*/` — platform core modules (8 directories)

Each `os-*/` directory is named explicitly.

| Directory | License |
|---|---|
| `os-console/` | AGPL-3.0-or-later — relicense to Apache-2.0 proposed 2026-09-01, was BLOCKED; **unblocked 2026-09-25 (§4.7), ratified, pending Cargo.toml/SPDX execution by project-console. See §4.1c.** |
| `os-privategit/` | FSL-1.1-ALv2, corrected 2026-07-07 (was AGPL-3.0-or-later); **FSL retired 2026-09-25 — resolves to Apache-2.0** (zero AGPL-tier path dependencies, same clean pattern as `os-mediakit`'s audit; `Cargo.toml` carries no `[dependencies]` at all). Ratified, pending Cargo.toml/SPDX execution by project-software. See §4.7. |
| `os-totebox/` | FSL-1.1-ALv2, corrected 2026-07-07 (was AGPL-3.0-or-later); relicense to Apache-2.0 proposed 2026-09-01, was BLOCKED; **FSL retired + unblocked 2026-09-25 (§4.7) — resolves to Apache-2.0**, its own bundled daemon set (`service-fs`/`-input`/`-people`/`-email`/`-extraction`/`-http`/`-ingress`, `slm-doorman-server`/`-mcp-server`, §4.2a) having cleared the blocking dependency. Ratified, pending Cargo.toml/SPDX execution by project-totebox. See §4.1c, §4.7. |
| `os-workplace/` | AGPL-3.0-or-later — **relicense to Apache-2.0 ratified 2026-09-25** (whole `os-workplace`/`app-workplace-*` family, §4.7). Pending Cargo.toml/SPDX execution by project-workplace. |
| `os-infrastructure/` | FSL-1.1-ALv2; **FSL retired 2026-09-25 — resolves to AGPL-3.0-or-later** (explicitly named staying-AGPL in the §4.7 ratification — not a Product with a clean Apache-tier dependency graph). Pending Cargo.toml/SPDX execution by project-infrastructure. See §4.7. |
| `os-interface/` | **Removed from `pointsav-monorepo` 2026-09-01 — see §4.1b.** Formerly PointSav-ARR (proprietary), corrected 2026-07-07 (was FSL-1.1-ALv2; renamed to `os-orchestration/` per Rollout Phase 3). |
| `os-orchestration/` | **Removed from `pointsav-monorepo` 2026-09-01 — see §4.1b.** Formerly PointSav-ARR (proprietary), added to this matrix 2026-08-02. Pricing/tier confirmed unchanged 2026-09-25: Proprietary, buy-once/all-features, no modular tiering. See §4.7 item 6. |
| `os-mediakit/` | **Apache-2.0 — relicensed 2026-09-01** (was FSL-1.1-ALv2). Linking-boundary audit clean (zero cross-tier path dependencies). Reconfirmed correct 2026-09-25 against an independent, unaudited later conclusion that had argued for AGPL — see §4.7 item 3. See §4.1c. |
| `os-network-admin/` | FSL-1.1-ALv2; **FSL retired 2026-09-25 — resolves to AGPL-3.0-or-later** (explicitly named staying-AGPL in the §4.7 ratification, same reasoning as `os-infrastructure`). Pending Cargo.toml/SPDX execution. See §4.7. |

### 4.1a Per-product tier decision record (2026-07-07)

Full reasoning for the three corrections above (and the exact overrides in §4.2a) is recorded
in `BRIEF-software-licensing-structure.md` (Command-scope Foundry workspace,
`.agent/briefs/`) — operator-ratified, early-stage sole-decision-maker sign-off in lieu of a
separate formal legal-counsel/MEMO pass (see that BRIEF's Work Log for the explicit
authorization record). Summary: `os-orchestration` is the company's stated permanent
commercial moat and must never open-source; `os-totebox` and `os-privategit` (the storefront
engine) both move to FSL specifically because FSL guarantees day-one source/data readability
(satisfying data-portability/no-lock-in commitments) while still giving a 2-year commercial
protection window before full Apache-2.0 conversion.

### 4.1b Orchestration layer relocated to a private repo (2026-09-01)

`os-interface/`, `os-orchestration/`, and all `app-orchestration-*/` directories (bim,
command, exchange, gis, graph, market, slm — 9 directories total) were extracted, with full
history, to a new private repository: `pointsav/pointsav-orchestration-private`. This is not
a licensing change — these directories were already PointSav-ARR (proprietary), unchanged —
it is a correction of where genuinely non-public code was living. The real license-enforcement
source (Ed25519 license gate, metering, fleet allocation) had been publicly readable on
`pointsav-monorepo` and both `jwoodfine`/`pwoodfine` public staging forks for approximately 3
months (first committed 2026-06-05) before discovery and remediation. Full-history purge
(`git filter-repo --invert-paths`) applied to canonical and both forks; see NOTAM for the
incident record. `app-orchestration-bim`/`app-orchestration-graph` were also removed from
`pointsav-monorepo`'s root `Cargo.toml` workspace members as part of this change (they were
the only two of the 9 registered there — the rest are self-contained nested workspaces).

### 4.1c Apache-2.0 convergence attempt (2026-09-01) — partial, real blockers found

`BRIEF-pointsav-licensing-architecture.md` (project-editorial) proposed converging
`os-console`/`app-console-*`, `os-totebox`/`app-totebox-*`, and `os-mediakit`/`app-mediakit-*`
to Apache-2.0. Ratified as design direction, but execution required a linking-boundary audit
first (Apache-tier crates cannot safely path-depend, in-process, on AGPL+Commercial-tier
crates — the dependency would functionally infect the "Apache" label with copyleft
obligations). Audit result: **not uniformly safe to execute.**

**Executed (audit clean):** `os-mediakit`/`app-mediakit-*` — zero cross-tier dependencies,
relicensed to Apache-2.0 above and in §4.2.

**Was blocked as of 2026-09-01 — unblocked 2026-09-25 via dependency relicense, not refactor:**
- `os-console` path-depends on `system-gateway-mba` (AGPL+Commercial tier).
- `app-console-content` path-depends on `system-gateway-mba`.
- `app-console-system` path-depends on `system-core` and `system-ledger` (both AGPL+Commercial tier).
- `os-totebox` path-depends on `service-content` and `slm-doorman-server` (both AGPL+Commercial tier).

**Resolution, 2026-09-25 (`BRIEF-dogfood-licensing-handoff-2026-09-25.md`, §4.7 below):** rather
than removing or refactoring out these dependencies, the linkage-surface boundary rule ratified
this session moves the *dependencies themselves* to Apache-2.0 — `system-core`, `system-ledger`,
and `system-gateway-mba` (§4.2a), and `service-content`/`slm-doorman-server` as part of the
`os-totebox` bundled-daemon-set move (§4.2a). This clears every blocker listed above without a
refactor. `os-console`, `app-console-content`, `app-console-system`, and `os-totebox` are
therefore **ratified for Apache-2.0, pending each owning archive's own Cargo.toml/SPDX
execution** (project-console for the `os-console`/`app-console-*` family; project-totebox for
`os-totebox`) — see §4.1 above and §4.7. Re-verify the dependency graph at execution time before
treating this as fully closed; this table update is the ratification record, not confirmation
that every path dependency has been re-walked post-relicense.

**Separately found, not a cross-tier violation but blocks a clean relicense:** `console-core`
(real, git-tracked source, depended on by `app-console-keys`) is currently mismarked as
gitignored/local-only in `mapping/repo-license-map.yaml` — needs an explicit map entry before
any relicense commit references it. Note: `BRIEF-pointsav-licensing-architecture.md`
(project-editorial) separately flagged a broader "~2,650-file, 7+ `vendor-*` dirs" version of
this defect class — checked directly this pass, that specific claim appears **stale**: all 7
named `vendor-*` directories are already correctly classified `upstream` in
`mapping/repo-license-map.yaml` (fixed 2026-08-02, per §4.5's own history). `console-core` looks
like a genuinely new, separate instance, not evidence the older defect is still open — but the
full ~2,650-file count wasn't independently re-audited this pass, so treat "is the broader claim
still accurate at all" as an open question, not resolved either way.

### 4.2 Platform-wide prefix categories (all AGPL-3.0-or-later)

Any directory beginning with one of these prefixes inherits
AGPL-3.0-or-later automatically.

| Prefix | Count (current, refreshed 2026-08-02) | License |
|---|---|---|
| `service-*` | 27 | AGPL-3.0-or-later |
| `system-*` | 23 | AGPL-3.0-or-later |
| `tool-*` | 10 (0 exact overrides — `tool-wallet/`'s Apache-2.0 exception reversed 2026-09-01, see §4.2a) | AGPL-3.0-or-later |
| `moonshot-*` | 23 (1 exact override — `moonshot-sel4-vmm/`, stays AGPL-3.0-or-later, see §4.2a) | **Apache-2.0 — relicensed 2026-09-01** (was AGPL-3.0-or-later; the 5 crates previously overridden to FSL-1.1-ALv2 now match this default and no longer need an override) |

### 4.2a Exact overrides of prefix patterns (2026-07-07)

Individual directories carved out of a blanket prefix category above via an exact
override in `mapping/repo-license-map.yaml` (exact directory names override prefix
patterns, per that file's own matching rule). Tracked here so §4.2's table doesn't
silently go stale. Full reasoning: `BRIEF-software-licensing-structure.md`
(Command-scope Foundry workspace).

| Directory | Prefix category it overrides | License | Rationale |
|---|---|---|---|
| `tool-wallet/` | `tool-*` (AGPL-3.0-or-later) | ~~Apache-2.0~~ **Reversed 2026-09-01, back to AGPL-3.0-or-later (no override — matches default)** | Relicensed to Apache-2.0 2026-07-07 (no revenue role, seeds the Binary Library's Open Source/Community shelf) — reversed as part of tonight's 3-tier licensing convergence (`BRIEF-pointsav-licensing-architecture.md`, project-editorial); `tool-*` stays uniformly AGPL+Commercial, no exceptions. |
| `moonshot-sel4-vmm/` | `moonshot-*` (now Apache-2.0, see §4.2) | **AGPL-3.0-or-later (unchanged — exact override, excluded from the 2026-09-01 moonshot-* Apache move)** | Investigated specifically, not swept in blanket — this crate is a `#![no_std]` seL4 Protection Domain that boots under seL4's rootserver and talks to the GPL-2.0-only `vendor-sel4-kernel` via its syscall ABI (no Cargo-level path dependency today, but real ABI-level coupling a dependency-graph check doesn't catch). Its current AGPL license was never a deliberate crate-specific choice either (set by a mechanical 2026-07-03 policy-propagation commit) — but absent legal review of the GPL-2.0 ABI-coupling question, and since it doesn't fit the "external adoption race" rationale justifying the rest of `moonshot-*`'s move (no incumbent OSS seL4 VMM it competes with), kept at AGPL-3.0-or-later pending that review. |
| ~~`moonshot-docengine/`~~ | ~~`moonshot-*` (AGPL-3.0-or-later)~~ | ~~FSL-1.1-ALv2~~ **Override removed 2026-09-01 — see §4.2, now matches the moonshot-* Apache-2.0 default directly, no override needed.** | Was: commodity document-engine infrastructure (replaces ProseMirror/Lexical/TipTap) — real outside-adoption potential. |
| ~~`moonshot-editor/`~~ | ~~`moonshot-*` (AGPL-3.0-or-later)~~ | ~~FSL-1.1-ALv2~~ **Override removed 2026-09-01 — matches new default.** | Was: editor/viewer/file-tree widget surface (replaces CodeMirror/Monaco/react-arborist). |
| ~~`moonshot-crdt/`~~ | ~~`moonshot-*` (AGPL-3.0-or-later)~~ | ~~FSL-1.1-ALv2~~ **Override removed 2026-09-01 — matches new default.** | Was: collaborative state/version-lineage engine (replaces Loro/Yjs/Automerge). |
| ~~`moonshot-parser/`~~ | ~~`moonshot-*` (AGPL-3.0-or-later)~~ | ~~FSL-1.1-ALv2~~ **Override removed 2026-09-01 — matches new default.** | Was: incremental syntax parser (replaces tree-sitter). |
| ~~`moonshot-bim-engine/`~~ | ~~`moonshot-*` (AGPL-3.0-or-later)~~ | ~~FSL-1.1-ALv2~~ **Override removed 2026-09-01 — matches new default.** | Was: sovereign IFC/BIM engine (replaces web-ifc/xeokit). |

### 4.2a (continued) — new exact overrides, 2026-09-25 linkage-surface boundary rule

Ratified via `BRIEF-dogfood-licensing-handoff-2026-09-25.md` (§4.7 below), superseding
DOCTRINE §3.1's "Platform (`system-*`) → AGPL like the Linux kernel" analogy — Rust's static
linking has no process boundary the way a kernel/userspace syscall boundary does, so that
analogy never actually applied. New rule: Apache-2.0 for anything linked into, or shipped as
part of, a Product's own declared binary set; AGPL-3.0-or-later reserved for daemons that are
genuinely PointSav's own separate infrastructure layer. **Ratified, pending each owning
archive's own Cargo.toml/SPDX execution — not yet applied to source.**

| Directory | Prefix category it overrides | License | Rationale |
|---|---|---|---|
| `system-core/` | `system-*` (AGPL-3.0-or-later) | **Apache-2.0** | Only 3 of 22 `system-*` crates move (verified via direct `Cargo.toml` dependency check against the live monorepo, not a design-pass guess) — linked into multiple Products' own binary sets, no remaining AGPL-tier dependents that would be orphaned. |
| `system-ledger/` | `system-*` (AGPL-3.0-or-later) | **Apache-2.0** | Same verification as `system-core/`. |
| `system-gateway-mba/` | `system-*` (AGPL-3.0-or-later) | **Apache-2.0** | Same verification. Single crate (`[[bin]]` targets `proofctl`/`pairing-server` inside one `Cargo.toml`) — the whole crate moves, not a lib/bin split (Cargo has no mechanism to license a lib target differently from bin targets in the same crate). |
| `service-content/` | `service-*` (AGPL-3.0-or-later) | **Apache-2.0** | Named explicitly in the §4.7 ratification; also the dependency that was blocking `os-totebox`'s Apache convergence, see §4.1c. |
| `service-fs/`, `service-input/`, `service-people/`, `service-email/`, `service-extraction/`, `service-http/`, `service-ingress/` | `service-*` (AGPL-3.0-or-later) | **Apache-2.0** | `os-totebox`'s own declared bundled-daemon binary set per project-totebox's own BRIEF — not standalone infrastructure. Refinement found during this session specifically because treating them as standalone-infra AGPL daemons would have re-introduced the exact `os-totebox` blocker §4.1c had just cleared. |
| `service-slm/crates/slm-doorman/`, `service-slm/crates/slm-doorman-server/`, `service-slm/crates/slm-mcp-server/` | `service-*` (AGPL-3.0-or-later) | **Apache-2.0** | `service-slm`'s Doorman-side crates — part of `os-totebox`'s bundled daemon set (`slm-doorman-server`/`-mcp-server` explicitly named). Sub-crate-level override: `service-slm/router/`, `service-slm/crates/slm-core/`, and `service-slm/crates/adapter-hub/` are **not** named in the ratification and stay under the `service-` AGPL default — do not assume the whole `service-slm/` family moved. **Schema note:** `mapping/repo-license-map.yaml`'s matching rule (`propagate-licenses.sh`/`add-spdx-headers.sh`) does plain longest-string-prefix matching against a file's full relative path, so a nested key like `service-slm/crates/slm-doorman/` works correctly and takes precedence over the shorter `service-` prefix — confirmed by reading the matching function directly, not assumed. |
| `tool-typeset/` | `tool-*` (AGPL-3.0-or-later) | **Apache-2.0** | Named explicitly (§4.7 item 4) — **reverses the 2026-07-07 round-11 decision** that put it under the uniform `tool-*` AGPL default. |
| `tool-wiki-core/` | `tool-*` (AGPL-3.0-or-later) | **Apache-2.0** | Same reversal as `tool-typeset/`. |
| `console-core/` | (currently classified `AGPL-3.0-or-later`, §4.1c/§4.6, inherits `os-console`'s tier) | **Apache-2.0** | Explicitly named in §4.7 item 4's Apache-move list; moves with `os-console` once that relicense executes (§4.1c) rather than staying pinned to `os-console`'s pre-relicense tier. |

**Note on `tool-wallet/`'s continued AGPL status:** unaffected by this pass — the §4.2 table
above already reflects its 2026-09-01 reversal back to the `tool-*` default; nothing in the
2026-09-25 ratification revisits it.

**Note on the 5 crossed-out `moonshot-*` rows above:** kept visible (struck through, not deleted)
for audit-trail continuity rather than silently removed — they document that these 5 crates went
FSL → Apache in one step, not AGPL → Apache like their 17 `moonshot-*` siblings. This is a real,
already-published relicensing event (the FSL assignment was live; see `moonshot-docengine`'s
commit history) — needs its own public relicensing notice from Command when the actual `Cargo.toml`
license fields + this table's history are executed together, not a silent table update. **Not yet
executed against the actual `Cargo.toml` `license` fields in `pointsav-monorepo` this pass** — this
table update is the ratification record; the corresponding source-file SPDX/Cargo.toml edits and
public notice are tracked in NEXT.md as separate follow-up work.

### 4.3 `app-*` inheritance rule

The 29 `app-*/` directories follow a naming convention
`app-<domain>-<thing>/` where `<domain>` matches an `os-*` module.
Each `app-*/` directory inherits the license of its parent domain:

| Prefix | Inherits from | License | Count |
|---|---|---|---|
| `app-console-*` | `os-console` | AGPL-3.0-or-later — **relicense to Apache-2.0 ratified 2026-09-25, pending execution alongside `os-console` (§4.1c, §4.7).** | 16 |
| `app-privategit-*` | `os-privategit` | ~~FSL-1.1-ALv2~~ **FSL retired 2026-09-25 — resolves to Apache-2.0** alongside `os-privategit` (§4.1, §4.7). Ratified, pending Cargo.toml/SPDX execution by project-software and project-design (owner of `app-privategit-design`). | 7 |
| `app-totebox-*` | `os-totebox` | ~~FSL-1.1-ALv2~~ **FSL retired + unblocked 2026-09-25 — resolves to Apache-2.0** alongside `os-totebox` (§4.1, §4.1c, §4.7). Ratified, pending Cargo.toml/SPDX execution by project-totebox. | 2 |
| `app-workplace-*` | `os-workplace` | AGPL-3.0-or-later — **relicense to Apache-2.0 ratified 2026-09-25**, alongside `os-workplace` (§4.7 item 4, "whole `os-workplace`/`app-workplace-*` family"). Pending execution by project-workplace. | 9 |
| `app-mediakit-*` | `os-mediakit` | **Apache-2.0 — relicensed 2026-09-01** (was FSL-1.1-ALv2) | 7 |
| `app-network-*` | `os-network-admin` | ~~FSL-1.1-ALv2~~ **FSL retired 2026-09-25 — resolves to AGPL-3.0-or-later** (explicitly named staying-AGPL, §4.7 item 4). Pending Cargo.toml/SPDX execution by project-infrastructure. | 9 |
| `app-orchestration-*` | `os-interface` (→ `os-orchestration`) | **Removed from `pointsav-monorepo` 2026-09-01 — see §4.1b.** Formerly PointSav-ARR (proprietary), corrected 2026-07-07. | 0 (was 7) |

Counts refreshed 2026-08-02 against live `pointsav-monorepo`; §4.2's prefix-category counts below carry the same staleness pattern and are refreshed in the same pass.

New `app-*/` directories must match one of these inheritance patterns.
A new `app-*/` directory that does not match an existing domain is a
defect and must be resolved by either (a) creating the corresponding
`os-*/` module first, or (b) amending this matrix to add a new
inheritance pattern.

### 4.4 Additional tracked directories

Added 2026-05-24 (license audit). These directories are tracked in git and
require explicit license assignment.

| Directory | License | Notes |
|---|---|---|
| `foundry-nodeclass/` | AGPL-3.0-or-later | Workspace node classification library |
| `scripts/` | AGPL-3.0-or-later | Build and automation scripts |
| `slm/` | AGPL-3.0-or-later | Language model module configuration |
| `docs/` | AGPL-3.0-or-later | Internal technical documentation |
| `templates/` | ~~FSL-1.1-ALv2~~ **Apache-2.0 — FSL retired 2026-09-25, resolves to Apache-2.0** matching its own mediakit surface (`app-mediakit-*` moved 2026-09-01). Pending Cargo.toml/SPDX execution. | HTML/CSS shell templates (app-mediakit surface) |
| `vendor-virtio/` | upstream | virtio driver stubs; README.md states upstream SPDX identifier |
| `vendor-wireguard/` | upstream | WireGuard tooling; README.md states upstream SPDX identifier |

### 4.5 Gitignored local-only directories

**Corrected 2026-08-02:** a 2026-08-02 audit found this section's factual claim
was wrong for 7 of its 9 original entries — `git ls-tree` confirms
`vendor-azure-auth/`, `vendor-gpu-drivers/`, `vendor-linux-systemd/`,
`vendor-microsoft-graph/`, `vendor-phi3-mini/`, `vendor-sel4-kernel/`, and
`vendor-slm-engine/` are real, git-tracked directories, not gitignored. They
have been moved to `mapping/repo-license-map.yaml`'s active `upstream` entries
(vendored third-party code, same treatment as `vendor-virtio/`/
`vendor-wireguard/` in §4.4) and removed from this table. `app-infrastructure-*/`
is also git-tracked (as `app-infrastructure-cloud/`, `-leased/`, `-onprem/`) and
has been moved to §4.6's pending-classification list instead, since — unlike
the vendor-* directories — it is Woodfine-authored operational content with no
established license precedent, not vendored upstream code.

Only `discovery-queue/` was confirmed genuinely gitignored/local-only.

| Directory | Notes |
|---|---|
| `discovery-queue/` | Operator-local transaction queue — removed from tracking 2026-05-24 |

### 4.6 Unmatched directories are defects

Any directory in `pointsav-monorepo` that does not match an entry in
§4.1–§4.5 is undefined under this matrix. Such directories
are defects and must be resolved before propagation.

**Note on enforcement (2026-08-02):** `scripts/verify-repo-compliance.sh`
checks per-repository license compliance (LICENSE file, policies, SPDX headers)
but does not currently walk `monorepo_directories` to flag unmatched
directories — the "propagation and verification scripts surface unmatched
directories as errors" claim above describes intended, not current, behavior.
Building that check is separate follow-up work, not part of this pass.

**Confirmed unmatched directories (2026-08-02 audit, verified via
`git ls-tree -d --name-only HEAD` against every active rule in
`mapping/repo-license-map.yaml`):** originally 21 directories remained unmatched after that
pass resolved `os-orchestration/` (§4.1) and the 7 vendored-upstream
directories (§4.4/§4.5); 20 remain as of 2026-09-01 (`console-core/` classified above, found
during tonight's licensing linking-boundary audit). None of the rest have been assigned a
license — this list exists so the gap is visible and trackable, not to imply resolution.
Each requires content review before classification; several appear to be
scratch/workspace clutter rather than shippable product code and may resolve
via removal rather than a license assignment. See `NEXT.md` for the tracked
follow-up item.

| Directory | Notes |
|---|---|
| `app-infrastructure-cloud/` | Real, tracked (moved here 2026-08-02 from §4.5, which wrongly called it gitignored) |
| `app-infrastructure-leased/` | Same as above |
| `app-infrastructure-onprem/` | Same as above |
| `bread/` | Unknown purpose — no near-miss rule; needs content review |
| `briefs/` | Unknown purpose — no near-miss rule; needs content review |
| ~~`console-core/`~~ | **Classified 2026-09-01, moved to §4.1 — AGPL-3.0-or-later, inherits `os-console`'s tier.** Found real and depended on (path dep, `app-console-keys`) during the linking-boundary audit for tonight's Apache-2.0 convergence attempt (§4.1c). |
| `data/` | Unknown purpose — no near-miss rule; needs content review |
| `infrastructure/` | Unknown purpose — no near-miss rule; needs content review |
| `JOURNAL/` | Unknown purpose — no near-miss rule; needs content review |
| `proposed/` | Unknown purpose — no near-miss rule; needs content review |
| `SUMMARY/` | Unknown purpose — no near-miss rule; needs content review |
| `work/` | Unknown purpose — no near-miss rule; needs content review |
| `workplace-shell-chrome/` | Unknown purpose — no near-miss rule; needs content review |
| `vendor-libvmm/` | Not documented anywhere, unlike its vendor-* siblings in §4.4/§4.5 |
| `vendor-sel4-project/` | Not documented anywhere |
| `vendor-sel4-tools/` | Not documented anywhere |
| `vendor-tantivy/` | Not documented anywhere |
| `vendor-tantivy-columnar/` | Not documented anywhere |
| `vendor-tantivy-common/` | Not documented anywhere |
| `.cargo/` | Workspace/build config, not a licensable code module — likely out of scope for a license assignment rather than a defect; flagged for a scope decision, not silently excluded |
| `.github/` | CI/workflow config, not a licensable code module — same flag as `.cargo/` above |

### 4.7 FSL-1.1-ALv2 retirement and linkage-surface boundary rule (2026-09-25)

**Ratified this session** via `BRIEF-dogfood-licensing-handoff-2026-09-25.md`
(project-dogfood's vision-reinvention licensing sub-track), reconciling
`business-admin/project-vision/vision/doctrine/DOCTRINE.md` §4.2b/§4.2c
against this matrix and live source (not memory), with explicit operator
sign-off on each disagreement. Full reasoning trail lives in DOCTRINE
§4.2b/§4.2c; this section is the operational ratification record. **This
table update is the ratification record — the corresponding source-file
SPDX/`Cargo.toml` edits are tracked as follow-up work, executed by each
owning project-* archive via its own normal Stage 6 flow, not by this
repository's maintainers directly.**

1. **FSL-1.1-ALv2 retired as policy.** No new FSL assignment permitted going
   forward. Every live instance resolves to Apache-2.0 or AGPL-3.0-or-later
   per its family — see §4.1 (`os-privategit`, `os-totebox`, `os-infrastructure`,
   `os-network-admin`), §4.3 (`app-privategit-*`, `app-totebox-*`,
   `app-network-*`), and §4.4 (`templates/`). Footprint: 170 files, 25
   top-level locations, 11 `Cargo.toml` fields across the fleet (full audit in
   DOCTRINE §4.2b). A narrow future exception is theoretically possible; the
   default going forward is no more new FSL assignments. The live
   `software.pointsav.com` site still listed FSL-1.1-ALv2 as an active tier as
   of 2026-09-25 — needs correcting once execution lands (owner:
   project-software).

2. **Linkage-surface boundary rule**, superseding DOCTRINE §3.1's "Platform
   (`system-*`) → AGPL like the Linux kernel" analogy (Rust's static linking
   has no process boundary the way a kernel/userspace syscall boundary does —
   the analogy never transferred). New rule: **Apache-2.0** for anything
   linked into, or shipped as part of, a Product's own declared binary set;
   **AGPL-3.0-or-later** reserved for daemons that are genuinely PointSav's
   own separate infrastructure layer. External precedent considered: Google's
   org-wide AGPL ban, Fuchsia's device-component policy, cBioPortal's 2026-09
   AGPL→Apache relicense, Android Bionic's BSD-not-LGPL choice — all point to
   the deterrent being corporate legal/procurement policy and third-party
   linking, not end-user discomfort (Signal/Nextcloud/Grafana/Ghostscript are
   AGPL and mass-adopted). Full per-crate application: §4.2a.

3. **Real, accepted cost:** this gives up AGPL protection on the
   capability-ledger substrate (`system-core`/`system-ledger`) — the layer
   both independent design passes (Fable, Opus) flagged as most competitively
   valuable. Operator accepted this explicitly against the mass-adoption
   goal, not overlooked.

4. **MSP/reseller question resolved — no new license mechanism.** Checked
   directly against `pointsav-orchestration-private`'s actual code: the
   license gate covers exactly three things (shared-GPU Tier-B brokering,
   central fleet pairing, cross-archive DataGraph federation) and never gates
   an MSP running separate, unrelated client `os-totebox` instances (boots and
   runs fully standalone). The real MSP AGPL exposure was the now-fixed
   `os-totebox` daemon-set misclassification (§4.2a), not a gap needing a new
   §7 additional-permission carve-out — a carve-out would be irrevocable once
   granted and would make the license AGPL in name only. `TRADEMARK.md`
   §3(d)/§5(a) remains the actual lever against a reseller rebranding a
   modified fork, independent of copyright license, and applies the same to
   Apache or AGPL components.

5. **Distribution defaults:** `tool-*` reversed from internal-only tooling to
   individually downloadable on the public storefront, same as `os-*` —
   `conventions/soft-distribution-pipeline.md` updated in place to match
   (project-dogfood, same session). Family-bound `app-*` (console, privategit,
   workplace, network, totebox families) default to **bundled inside their
   `os-*` parent's own binary** for now; standalone/cross-cutting products
   (mediakit family, orchestration-side apps, standalone services) were never
   bundling candidates and are unaffected.
6. **Payment currency confirmed: USDC-only, no change.** USDT considered and
   declined — reputational/scrutiny cost with institutional buyers (2021
   NYAG/CFTC reserve-transparency settlements) outweighs any benefit toward
   the mass-adoption-comfort goal.

**Not yet actioned — real bugs found, not licensing decisions (owners
named, tracked in NEXT.md, not re-litigated here):** `os-orchestration`'s
license-gate implementation has 3 real gaps against DOCTRINE (missing
`fleet-max-N` field; tokens expire, conflicting with item 6's buy-once
decision; a `COMMAND_SELF_ISSUE_LICENSE=1` dev-key fallback that may ship in
the public binary) — owner: project-orchestration. `service-slm`'s 51 `.rs`
files under `crates/` carry `SPDX-License-Identifier: Apache-2.0 OR MIT`
while every `Cargo.toml` there currently declares `AGPL-3.0-or-later` —
which one actually controls is an open legal question, not resolved by this
pass — owner: project-totebox, needs a legal read.

## 5. Propagation artifacts per license

Every licensed repository receives a standard set of artifacts. This
table states what the propagation script generates per license.

| License               | LICENSE file                      | SPDX header template         | NOTICE file | Bilingual README section | Incorporated policies                    |
|-----------------------|-----------------------------------|------------------------------|-------------|--------------------------|------------------------------------------|
| AGPL-3.0-or-later     | licenses/AGPL-3.0.txt             | agpl-3.0-header.txt          | optional    | yes                      | CODE_OF_CONDUCT, CONTRIBUTING, SECURITY  |
| Apache-2.0            | licenses/Apache-2.0.txt           | apache-2.0-header.txt        | required    | yes                      | CODE_OF_CONDUCT, CONTRIBUTING, SECURITY  |
| FSL-1.1-ALv2 **(retired 2026-09-25, §4.7 — no new assignments)** | licenses/FSL-1.1-Apache-2.0.txt | fsl-1.1-header.txt | optional | yes | CODE_OF_CONDUCT, CONTRIBUTING, SECURITY  |
| CC BY 4.0             | licenses/CC-BY-4.0.txt            | none (content license)       | no          | yes                      | CODE_OF_CONDUCT                          |
| CC BY-ND 4.0          | licenses/CC-BY-ND-4.0.txt         | none (content license)       | no          | English-only section     | CODE_OF_CONDUCT                          |
| PointSav-ARR          | licenses/PointSav-ARR.txt         | proprietary-header.txt       | no          | yes                      | TRADEMARK, SECURITY                      |
| PointSav-Commercial   | delivered per Order Form          | proprietary-header.txt       | n/a         | n/a                      | TRADEMARK, SECURITY (per contract)       |
| EUPL-1.2              | `licenses/EUPL-1.2.txt` (pending DEF-002) | `headers/eupl-1.2-header.txt` (stub) | optional | yes | CODE_OF_CONDUCT, CONTRIBUTING, SECURITY |
| MIXED (monorepo)      | licenses/MIXED-MONOREPO-NOTICE.txt| per-directory via §4 rules   | no          | yes                      | CODE_OF_CONDUCT, CONTRIBUTING, SECURITY, TRADEMARK |

The `MIXED` license type is used for monorepos containing directories
under multiple licenses. Instead of writing a single LICENSE text, the
propagation script writes `MIXED-MONOREPO-NOTICE.txt` at the repo root
and relies on per-source-file SPDX headers (stamped by
`add-spdx-headers.sh`) for actual licensing disambiguation.

### 5.1 Website-content policies (not per-repo propagation)

`policies/DISCLAIMER.md` and `policies/HOMEPAGE-DISCLAIMER.md` are securities
disclaimers for the live `woodfinegroup.com`/`home.woodfinegroup.com` corporate
site, not repo governance boilerplate — they do not belong in the §5 per-license
propagation table above (stamping a securities disclaimer into, say,
`pointsav-design-system`'s README would be wrong). They are already correctly
routed via `tokens/legal-tokens-woodfine.yaml` and `tokens/legal-tokens-pointsav.yaml`
(consumed by `app-mediakit-knowledge`'s `shell_chrome()` for live site rendering
and CI footer validation). This section exists solely so this routing isn't
mistaken for an orphaned gap.

## 6. Change control

Changes to this matrix follow README §5:

  - PR against the `factory-release-engineering` repository.
  - Changes to license selection, commercial terms, or trademark
    policy require legal counsel review.
  - Changes to in-force assignments (downgrading a repo from FSL
    to Apache, or switching AGPL to a proprietary alternative)
    require MEMO-level governance review.
  - Changes to `mapping/repo-license-map.yaml` must be reflected
    here in the same PR. Divergence is a defect.
  - New directories added to `pointsav-monorepo` must be covered by
    an entry in §4 before being merged. **This is not yet automated** —
    `verify-repo-compliance.sh` does not currently walk `monorepo_directories`
    to flag unmatched ones (see §4.6's enforcement note); until that check is
    built, this rule is enforced by manual review at merge time.

---

*Copyright © 2026 Woodfine Capital Projects Inc. See LICENSE for terms.*

*Woodfine Capital Projects™, MCorp™, PointSav Digital Systems™, Totebox Orchestration™, and Totebox Archive™ are trademarks of Woodfine Capital Projects Inc., used in Canada, the United States, Latin America, and Europe. All other trademarks are the property of their respective owners.*
