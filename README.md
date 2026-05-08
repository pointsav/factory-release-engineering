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
| Apache-2.0 | Permissive-licensed code | Marketing site code (`*.github.io`), generic build tooling, `pointsav-design-system` |
| FSL-1.1-ALv2 | Paid commercial tier with 2-year DOSP | `os-orchestration`, `os-infrastructure`, `os-network-admin`, `os-mediakit`, dependent `app-*` classes |
| CC BY 4.0 | Open documentation content | `content-wiki-documentation` |
| CC BY-ND 4.0 | Corporate content, attribution required, no derivatives | `content-wiki-corporate`, `content-wiki-projects` |
| PointSav-ARR (public showcase) | Public operational reference | `*-fleet-deployment` repos, `*-media-assets` |
| PointSav Commercial | Commercial alternative to AGPLv3 for customers who cannot accept AGPL; commercial license for FSL-tier during 2-year window | Purchased separately by customers |

Full mapping: see `LICENSE-MATRIX.md`.

## 4. Rollout status

| Phase | Status |
|---|---|
| 1. Templates assembled in `factory-release-engineering/` | Complete |
| 2. MEMO V8 drafted reflecting new licensing structure | Drafted (pending counsel review) |
| 3. `os-interface/` → `os-orchestration/` rename in monorepo | Pending |
| 4. Monorepo per-directory licensing propagated | Pending |
| 5. PointSav org peripheral repos licensed | Pending |
| 6. Woodfine org repos licensed | Pending |
| 7. CLA Assistant activated on all AGPL/FSL repos | Pending |

## 5. Governance

**Changes to this directory** are proposed by pull request against the `factory-release-engineering` repository (or against the parent monorepo if this is held there). Changes affecting license selection, commercial terms, or trademark policy require review by legal counsel before merge. Changes to policy templates (CONTRIBUTING, CODE_OF_CONDUCT, SECURITY) may be approved by the repository maintainers.

**MEMO authority.** Any change to licensing that contradicts MEMO V8 or later must be accompanied by a MEMO amendment in the same release cycle. The MEMO is the architectural authority; `factory-release-engineering/` is the implementation of what the MEMO specifies.

## 6. Copyright structure (Canadian-simple posture)

**Holder.** Copyright is held by **Woodfine Capital Projects Inc.** ("WCP Inc.") on the basis of Canadian Copyright Act § 13(3), which makes the employer the **first owner** of copyright in works made by an employee in the course of employment under a contract of service. § 13(3) creates first-ownership, not assignment; it does not require a separate written instrument for the right to vest, and the resulting ownership is not subject to the § 14(1) reversionary interest that applies to § 13(4) assignments.

**Corporate structure.** The Foundry trajectory is operated under three entities of differing status:

| Entity | Status | Role |
|---|---|---|
| Woodfine Capital Projects Inc. | Incorporated (BC); parent holding | Copyright + trademark holder for all software, documentation, content, and brand IP |
| Woodfine Management Corp. | Incorporated (BC); operating sub | Operations / shield-blocker; **does not generate IP-derived revenue using WCP IP** |
| PointSav Digital Systems | **Yet to be incorporated** | Operated as a **trade name** of WCP Inc. pre-incorporation; eventual BC operating subsidiary |

**Why this works without inter-company IP agreements.** The structure has **no inter-company IP flow** while it operates this way. WCP holds IP and (through its employees) creates and uses it directly; Woodfine Management Corp. is genuinely non-operating with respect to WCP IP; "PointSav Digital Systems" is a trade name of WCP, not a separate legal person. Canadian Copyright Act § 13(3) is sufficient for vesting; CRA § 247 transfer-pricing documentation requirements that attach to inter-company IP use do not attach when there is no inter-company use.

**Operational disciplines that maintain the posture.** This structure depends on the following disciplines being kept:

- **Employee-only contributors.** Every IP-creating contributor is a bona fide WCP Inc. employee on T4 payroll, performing in-scope work under WCP direction. Independent contractors retain copyright by default under Canadian law and would require separate written assignment under § 13(4). Until counsel-drafted contractor IP-assignment templates are in place, the posture admits no contractor contributions to in-scope work.
- **Woodfine Management Corp. stays non-operating** with respect to WCP IP. If Woodfine Management Corp. begins using WCP IP to generate revenue, an inter-company licence with arm's-length pricing documentation becomes expected.
- **"PointSav Digital Systems" is a trade name of WCP** under BC's *Partnership Act* until incorporation. A Declaration of Trade Name with the BC Registrar should be filed if the brand is used commercially before incorporation.
- **Moral rights gap acknowledged.** § 14.1 moral rights cannot be assigned, only waived in writing. § 13(3) does not waive them. The current posture admits this residual gap and does not paper it; counsel-drafted moral-rights waivers may be added later as the structure matures.

**Trigger events that require revisiting this posture.** When any of the following occurs, the posture upgrades and counsel-drafted agreements (master IP assignment, inter-company IPAA, moral-rights waivers) become standard:

- First hire who is not a founder/officer
- First contractor contribution to in-scope code, content, or design work
- First external revenue generated using WCP IP
- Reporting-issuer status under BCSC NI 51-102
- PointSav Digital Systems Inc. incorporation event (handled at the rollover; see PLAYBOOK)
- Any inter-company IP use between WCP and an operating sub

**Why this structure preserves WCP equity value.** Holding IP at the parent enables **share-sale** transactions (selling WCP equity transfers the entire IP estate in one transaction; no per-asset assignments, no Bulk Sales Act triggers, no consents required). Asset-sale alternatives at sub-co level require enumerated IP schedules, individual assignments, and customer consents. The asymmetry also runs forward in time: pushing IP **down** to PointSav Digital Systems Inc. on incorporation via § 85 rollover is a single-event transaction; pulling IP **up** from a sub-holder later requires § 13(4) assignment + § 247 documentation + potential GST/HST implications + FMV crystallisation. The posture preserves both share-sale optionality today and the cleaner downstream-rollover path at incorporation.

**This section is not legal advice.** It describes the operational posture chosen for the current state of the Foundry trajectory. Counsel review is recommended before any trigger event above; the structure is intentionally minimal so it can be evolved as the project matures, without unwinding pre-existing agreements.

---

*factory-release-engineering*
*Release-engineering authority for the PointSav platform.*
*© 2026 Woodfine Capital Projects Inc. All rights reserved.*


---

*Copyright © 2026 Woodfine Capital Projects Inc. See [LICENSE](LICENSE) for terms.*

*Woodfine Capital Projects™, Woodfine Management Corp™, PointSav Digital Systems™, Totebox Orchestration™, and Totebox Archive™ are trademarks of Woodfine Capital Projects Inc., used in Canada, the United States, Latin America, and Europe. All other trademarks are the property of their respective owners.*