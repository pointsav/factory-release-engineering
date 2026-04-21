# LICENSE-MATRIX

Version 1.0 — Effective 2026-04-20
Copyright (c) 2026 Woodfine Capital Projects Inc. All rights reserved.

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
| `pointsav-design-system` | PointSav-ARR | Design system (strict licensing) |
| `pointsav-fleet-deployment` | PointSav-ARR | Operational deployment records |
| `pointsav-media-assets` | PointSav-ARR | Branded imagery |
| `pointsav.github.io` | Apache-2.0 | Public marketing site |

### 3.2 woodfine GitHub org (5 repos)

| Repository | License | Purpose |
|---|---|---|
| `content-wiki-corporate` | CC BY-ND 4.0 | Corporate content (no derivatives) |
| `content-wiki-projects` | CC BY-ND 4.0 | Project content (no derivatives) |
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
a negotiated Order Form. Commercial use contexts:

  (a) AGPLv3-alternative — for customers using AGPLv3 code without
      accepting AGPLv3 Section 13 copyleft obligations.
  (b) FSL pre-DOSP — for customers using FSL-licensed code during
      the two-year window before automatic Apache-2.0 conversion.

## 4. Per-directory licensing inside `pointsav-monorepo`

The monorepo contains 102 top-level subdirectories assigned to
licenses as follows.

### 4.1 `os-*/` — platform core modules (8 directories)

Each `os-*/` directory is named explicitly.

| Directory | License |
|---|---|
| `os-console/` | AGPL-3.0-or-later |
| `os-privategit/` | AGPL-3.0-or-later |
| `os-totebox/` | AGPL-3.0-or-later |
| `os-workplace/` | AGPL-3.0-or-later |
| `os-infrastructure/` | FSL-1.1-ALv2 |
| `os-interface/` | FSL-1.1-ALv2 — renames to `os-orchestration/` per Rollout Phase 3 |
| `os-mediakit/` | FSL-1.1-ALv2 |
| `os-network-admin/` | FSL-1.1-ALv2 |

### 4.2 Platform-wide prefix categories (all AGPL-3.0-or-later)

Any directory beginning with one of these prefixes inherits
AGPL-3.0-or-later automatically.

| Prefix | Count (current) | License |
|---|---|---|
| `service-*` | 17 | AGPL-3.0-or-later |
| `system-*` | 14 | AGPL-3.0-or-later |
| `tool-*` | 8 | AGPL-3.0-or-later |
| `moonshot-*` | 9 | AGPL-3.0-or-later |

### 4.3 `app-*` inheritance rule

The 29 `app-*/` directories follow a naming convention
`app-<domain>-<thing>/` where `<domain>` matches an `os-*` module.
Each `app-*/` directory inherits the license of its parent domain:

| Prefix | Inherits from | License | Count |
|---|---|---|---|
| `app-console-*` | `os-console` | AGPL-3.0-or-later | 10 |
| `app-privategit-*` | `os-privategit` | AGPL-3.0-or-later | 2 |
| `app-totebox-*` | `os-totebox` | AGPL-3.0-or-later | 2 |
| `app-workplace-*` | `os-workplace` | AGPL-3.0-or-later | 3 |
| `app-mediakit-*` | `os-mediakit` | FSL-1.1-ALv2 | 4 |
| `app-network-*` | `os-network-admin` | FSL-1.1-ALv2 | 8 |

New `app-*/` directories must match one of these inheritance patterns.
A new `app-*/` directory that does not match an existing domain is a
defect and must be resolved by either (a) creating the corresponding
`os-*/` module first, or (b) amending this matrix to add a new
inheritance pattern.

### 4.4 Unmatched directories are defects

Any directory in `pointsav-monorepo` that does not match an entry in
§4.1, §4.2, or §4.3 is undefined under this matrix. Such directories
are defects and must be resolved before propagation. The propagation
and verification scripts surface unmatched directories as errors.

## 5. Propagation artifacts per license

Every licensed repository receives a standard set of artifacts. This
table states what the propagation script generates per license.

| License               | LICENSE file                      | SPDX header template         | NOTICE file | Bilingual README section | Incorporated policies                    |
|-----------------------|-----------------------------------|------------------------------|-------------|--------------------------|------------------------------------------|
| AGPL-3.0-or-later     | licenses/AGPL-3.0.txt             | agpl-3.0-header.txt          | optional    | yes                      | CODE_OF_CONDUCT, CONTRIBUTING, SECURITY  |
| Apache-2.0            | licenses/Apache-2.0.txt           | apache-2.0-header.txt        | required    | yes                      | CODE_OF_CONDUCT, CONTRIBUTING, SECURITY  |
| FSL-1.1-ALv2          | licenses/FSL-1.1-Apache-2.0.txt   | fsl-1.1-header.txt           | optional    | yes                      | CODE_OF_CONDUCT, CONTRIBUTING, SECURITY  |
| CC BY 4.0             | licenses/CC-BY-4.0.txt            | none (content license)       | no          | yes                      | CODE_OF_CONDUCT                          |
| CC BY-ND 4.0          | licenses/CC-BY-ND-4.0.txt         | none (content license)       | no          | English-only section     | CODE_OF_CONDUCT                          |
| PointSav-ARR          | licenses/PointSav-ARR.txt         | proprietary-header.txt       | no          | yes                      | TRADEMARK, SECURITY                      |
| PointSav-Commercial   | delivered per Order Form          | proprietary-header.txt       | n/a         | n/a                      | TRADEMARK, SECURITY (per contract)       |
| MIXED (monorepo)      | licenses/MIXED-MONOREPO-NOTICE.txt| per-directory via §4 rules   | no          | yes                      | CODE_OF_CONDUCT, CONTRIBUTING, SECURITY, TRADEMARK |

The `MIXED` license type is used for monorepos containing directories
under multiple licenses. Instead of writing a single LICENSE text, the
propagation script writes `MIXED-MONOREPO-NOTICE.txt` at the repo root
and relies on per-source-file SPDX headers (stamped by
`add-spdx-headers.sh`) for actual licensing disambiguation.

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
    an entry in §4 before being merged. Unmatched new directories
    are blocked at propagation time by `verify-repo-compliance.sh`.
