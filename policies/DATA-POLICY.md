# Data Policy — Zero-Cookie and Zero-State Telemetry Posture

**Woodfine Capital Projects Inc. — PointSav Digital Systems**
Version 1.0 — Effective 2026-06-22

---

This Data Policy describes the data handling practices for all customer-facing digital surfaces operated by PointSav Digital Systems, a trade name of Woodfine Capital Projects Inc. ("Woodfine"). References to "we," "our," or "the Platform" in this policy refer to Woodfine Capital Projects Inc. and PointSav Digital Systems.

This policy applies to: `gis.woodfinegroup.com`, `documentation.pointsav.com`, `home.woodfinegroup.com`, `home.pointsav.com`, and all other production surfaces published under the `woodfinegroup.com` and `pointsav.com` domains unless a surface-specific disclosure states otherwise.

---

## 1. Zero-Cookie Architecture

The Platform does not deploy HTTP cookies of any kind — functional, session, analytical, or tracking. No cookie banner, consent management platform, or opt-out mechanism is required, because no cookies are set. The absence of cookies is structural: the server does not issue `Set-Cookie` headers and no client-side cookie API calls are made.

This posture is verifiable: running `document.cookie` in the browser developer console on any Platform surface returns an empty string.

## 2. Zero-State Telemetry Architecture

The Platform does not deploy third-party analytics, tracking pixels, session replay tools, fingerprinting libraries, or behavioural telemetry of any kind. No personally identifiable information (PII) is collected from visitors. No data is transmitted to advertising networks, data brokers, or third-party analytics providers.

System interactions are limited to the collection of anonymized network routing data (IP addresses logged transiently by infrastructure for abuse prevention, not retained beyond the session) and aggregated viewport data strictly for the purpose of auditing infrastructure performance. These logs do not identify individuals and are not cross-referenced with external data sources.

## 3. Strictly-Necessary Local Storage

Certain Platform surfaces use the browser's `localStorage` API to retain user interface preferences on the visitor's own device. This local storage:

- Is stored on-device and never transmitted to Woodfine servers or any third party.
- Contains only UI state (for example: map view position, a "welcome message seen" flag, or display preferences).
- Does not contain, derive, or transmit any personally identifiable information.
- Is classified as strictly-necessary local storage under the EU ePrivacy Directive, the EU General Data Protection Regulation (GDPR), the California Consumer Privacy Act (CCPA/CPRA), and the Personal Information Protection and Electronic Documents Act (PIPEDA). It does not require consent under any of these frameworks.

Strictly-necessary local storage is functionally and legally distinct from cookies: it is not transmitted with HTTP requests, is not accessible by the server, and is governed by the same-origin policy of the browser.

## 4. Infrastructure Data Handling

The Platform runs on private infrastructure hosted within the Google Cloud Platform (`us-west1` region). Data routing is subject to Google Cloud's standard infrastructure data handling practices as described in the applicable Google Cloud terms. Woodfine does not collect, process, or retain visitor data beyond what is described in §§1–3 above.

## 5. Regulatory Compliance

The Zero-Cookie and Zero-State Telemetry architecture described in this policy is consistent with the requirements of:

- **EU GDPR (Regulation 2016/679)** — Processing is limited to the transient IP-address logging described in §2 (Art. 6(1)(f) legitimate interest — abuse prevention), not retained beyond the session; no other personal data is processed and no consent-requiring processing occurs.
- **EU ePrivacy Directive (2002/58/EC, as amended)** — No tracking cookies are deployed; strictly-necessary local storage is exempt from consent requirements.
- **California CCPA/CPRA** — No personal information is collected or sold, other than the transient IP-address logging described in §2, which is not sold, shared, or retained beyond the session.
- **Canada PIPEDA (S.C. 2000, c. 5)** — Collection is limited to the transient IP-address logging described in §2, for the reasonable purpose of abuse prevention, not retained beyond the session; no other personal information is collected, used, or disclosed.

This policy does not constitute legal advice. Platform operators should consult qualified legal counsel regarding their specific obligations under applicable privacy legislation.

## 6. Contact

Questions regarding this Data Policy, including GDPR Art. 13/15 inquiries, may be directed to the System Administrator, PointSav Digital Systems: `open.source@pointsav.com`. No separate Data Protection Officer is currently appointed — the Platform's processing does not meet the GDPR Art. 37 threshold (no large-scale or systematic monitoring, no large-scale special-category processing); this determination will be revisited if that scope changes.

---

*This document is effective as of the date above and supersedes any prior data handling disclosures published by PointSav Digital Systems or Woodfine Capital Projects Inc. on the surfaces listed in the preamble. Material changes will be reflected in an updated version number and effective date.*
