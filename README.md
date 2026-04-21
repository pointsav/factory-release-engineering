# factory-release-engineering

**Purpose.** Canonical source for all licenses, policies, and institutional-maturity templates that propagate across every PointSav and Woodfine repository. One location, version-controlled, authoritative. When a license or policy needs to change, it changes here first and propagates outward — never edited in place across twenty repos.

**Copyright holder.** Woodfine Capital Projects Inc. PointSav Digital Systems™ and Woodfine Management Corp. operate under the intellectual property definitions of Woodfine Capital Projects Inc.

**Authority.** This directory is the release-engineering authority for the PointSav platform. It is referenced by — and supersedes — any individual repository's LICENSE, NOTICE, CONTRIBUTING, or policy file that diverges from its contents. When MEMO V8 is ratified, this directory's contents will reflect the licensing structure it formalizes.

---

## 1. Directory layout

```
factory-release-engineering/
├── README.md                    ← this file
├── LICENSE-MATRIX.md            ← canonical per-repo and per-directory license mapping
├── PLAYBOOK.md                  ← step-by-step rollout procedure for Claude Code
│
├── licenses/                    ← full text of every license the platform uses
│   ├── AGPL-3.0.txt
│   ├── Apache-2.0.txt
│   ├── FSL-1.1-Apache-2.0.txt
│   ├── CC-BY-4.0.txt
│   ├── CC-BY-ND-4.0.txt
│   ├── PointSav-ARR.txt
│   └── PointSav-Commercial.txt
│
├── headers/                     ← SPDX headers for source-file annotation
│   ├── agpl-3.0-header.txt
│   ├── fsl-1.1-header.txt
│   └── proprietary-header.txt
│
├── policies/                    ← institutional maturity policy templates
│   ├── CODE_OF_CONDUCT.md       ← Contributor Covenant 2.1
│   ├── CONTRIBUTING.md
│   ├── SECURITY.md
│   └── TRADEMARK.md
│
├── cla/                         ← CLA Assistant wiring + agreements
│   ├── individual-cla.md
│   ├── corporate-cla.md
│   └── cla-assistant-config.yml
│
├── github/                      ← GitHub repo-hygiene templates
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.md
│   │   ├── feature_request.md
│   │   └── security_report.md
│   ├── PULL_REQUEST_TEMPLATE.md
│   └── CODEOWNERS.template
│
├── readmes/                     ← bilingual README sections pointing to licenses
│   ├── license-section-en.md
│   └── license-section-es.md
│
├── mapping/                     ← machine-readable repo → license assignments
│   └── repo-license-map.yaml
│
└── scripts/                     ← propagation automation
    ├── propagate-licenses.sh
    ├── add-spdx-headers.sh
    └── verify-repo-compliance.sh
```

## 2. Working principles

**Single source of truth.** Every license text lives here exactly once. Repositories never contain their own copy of AGPL-3.0 or Apache-2.0 text — they contain a LICENSE file generated from this directory by the propagation script.

**Mapping before propagation.** `mapping/repo-license-map.yaml` declares every target repo, every directory class within the monorepo, and which license each receives. The propagation script reads this map. Changes to licensing happen by editing the map, not by editing files across repos.

**English licenses, bilingual README sections.** License files are English-only — legal instruments are monolingual to avoid translation-drift ambiguity. Each target repo's README receives a bilingual English/Spanish section (from `readmes/`) that explains the license in both languages and points to the authoritative English text.

**CLA before merge.** No contribution is merged to any AGPLv3 or FSL-licensed repo without a signed CLA on file. CLA Assistant (GitHub-native) enforces this.

**SPDX headers on source files.** Every source file in an AGPLv3, FSL, or Apache-2.0 directory carries a machine-readable SPDX identifier header. This is the REUSE Software specification standard.

## 3. License inventory

| License | Used for | Where |
|---|---|---|
| AGPL-3.0 | Open-source platform core | `os-totebox`, `os-console`, `os-workplace`, `os-privategit`, all `service-*`, `system-*`, `tool-*`, `moonshot-*`, dependent `app-*` classes |
| Apache-2.0 | Permissive-licensed code | Marketing site code (`*.github.io`), generic build tooling |
| FSL-1.1-ALv2 | Paid commercial tier with 2-year DOSP | `os-orchestration`, `os-infrastructure`, `os-network-admin`, `os-mediakit`, dependent `app-*` classes |
| CC BY 4.0 | Open documentation content | `content-wiki-documentation` |
| CC BY-ND 4.0 | Corporate content, attribution required, no derivatives | `content-wiki-corporate`, `content-wiki-projects` |
| PointSav-ARR (public showcase) | Public operational reference | `*-fleet-deployment` repos, `*-media-assets`, `pointsav-design-system` |
| PointSav Commercial | Commercial alternative to AGPLv3 for customers who cannot accept AGPL; commercial license for FSL-tier during 2-year window | Purchased separately by customers |

Full mapping: see `LICENSE-MATRIX.md`.

## 4. Rollout status

| Phase | Status |
|---|---|
| 1. Templates assembled in `factory-release-engineering/` | Complete |
| 2. MEMO V8 drafted reflecting new licensing structure | Pending |
| 3. `os-interface/` → `os-orchestration/` rename in monorepo | Pending |
| 4. Monorepo per-directory licensing propagated | Pending |
| 5. PointSav org peripheral repos licensed | Pending |
| 6. Woodfine org repos licensed | Pending |
| 7. CLA Assistant activated on all AGPL/FSL repos | Pending |

## 5. Governance

**Changes to this directory** are proposed by pull request against the `factory-release-engineering` repository (or against the parent monorepo if this is held there). Changes affecting license selection, commercial terms, or trademark policy require review by legal counsel before merge. Changes to policy templates (CONTRIBUTING, CODE_OF_CONDUCT, SECURITY) may be approved by the repository maintainers.

**MEMO authority.** Any change to licensing that contradicts MEMO V8 or later must be accompanied by a MEMO amendment in the same release cycle. The MEMO is the architectural authority; `factory-release-engineering/` is the implementation of what the MEMO specifies.

---

*factory-release-engineering*
*Release-engineering authority for the PointSav platform.*
*© 2026 Woodfine Capital Projects Inc. All rights reserved.*
