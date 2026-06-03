# HIPAA Data Dictionary — Horizon ABA Health
**Status:** STRAWMAN DRAFT — Filled by AI (2026-06-03) based on ABA domain knowledge  
**Review required:** Founder confirms accuracy; Counselor makes legal determinations  
**Filed by:** Claude (Horizon session, FEEP Rule 5 — Context-First)  
**Founder sign-off:** PENDING

> ⚠️ STRAWMAN NOTICE: Rows and answers marked `[STRAWMAN]` are AI-generated best-guess
> based on standard ABA therapy platform architecture. Founder must confirm each one.
> Rows marked `[UNKNOWN]` need Founder input before Counselor can issue determinations.

---

## Instructions

For every data field Horizon collects, the table below documents what it is, where it comes from,
where it lives, and whether it is PHI. Counselor uses this to determine which laws apply.

---

## Table — Fields Horizon Collects

| Field Name | Collected From | Stored Where | Linked To Individual? | Linked To Treatment? | PHI? (counsel determines) |
|---|---|---|---|---|---|
| First name (client) | User — parent/guardian at registration | PostgreSQL DB (horizon prod) | Yes | Yes — ABA context makes all identifiers PHI | TBD |
| Last name (client) | User — parent/guardian at registration | PostgreSQL DB | Yes | Yes | TBD |
| Email (parent/guardian) | User — at account signup | PostgreSQL DB | Yes | Yes [STRAWMAN] | TBD |
| Phone (parent/guardian) | User — at account signup | PostgreSQL DB | Yes | Yes [STRAWMAN] | TBD |
| Date of birth (client) | User — parent/guardian at registration | PostgreSQL DB | Yes | Yes | TBD |
| Billing address | User — at subscription checkout | Stripe + PostgreSQL DB | Yes | Indirect — linked to treatment client | TBD |
| Payment method (card) | User | Stripe only — NOT in Horizon DB | Yes | No (billing only) | No — Stripe holds, not Horizon |
| Subscription plan | System — assigned at checkout | PostgreSQL DB | Yes | Yes [STRAWMAN] — indicates therapy platform use | TBD |
| Trial start/end dates | System | PostgreSQL DB | Yes | Yes [STRAWMAN] | TBD |
| ABA client identifier (internal ID) | System — generated at intake | PostgreSQL DB | Yes | YES | LIKELY YES |
| Session schedule (date/time/therapist) | Provider — BCBA/RBT at scheduling | PostgreSQL DB | Yes | YES | LIKELY YES |
| Session notes (clinical narrative) | Provider — BCBA/RBT during/after session | PostgreSQL DB | Yes | YES | YES |
| Behavioral data logs (target behaviors, trial data) | Provider — RBT during session | PostgreSQL DB | Yes | YES | YES |
| Skill acquisition data (goals, mastery levels) | Provider — BCBA | PostgreSQL DB | Yes | YES | YES |
| Assessment results (VB-MAPP, ABLLS-R, PEAK, etc.) | Provider — BCBA | PostgreSQL DB | Yes | YES | YES |
| Diagnosis codes (ICD-10: F84.x, F80.x, etc.) | Provider — BCBA at intake | PostgreSQL DB | Yes | YES | YES |
| Treatment plans (goals, objectives, interventions) | Provider — BCBA | PostgreSQL DB | Yes | YES | YES |
| Insurance information (payer, member ID, group, auth) | User — parent/guardian; Provider | PostgreSQL DB | Yes | YES | YES |
| Insurance authorization numbers | Provider or User | PostgreSQL DB | Yes | YES | YES |
| CPT/billing codes (97151–97158 ABA codes) | System — generated from session data | PostgreSQL DB | Yes | YES | YES |
| Provider name (BCBA/RBT) | Provider — self-registered | PostgreSQL DB | Yes | YES | Provider-PII (sensitive, not PHI for the provider) |
| Provider NPI number | Provider — self-registered | PostgreSQL DB | Yes | YES | Provider-PII (not PHI, but sensitive — public NPI registry) |
| Provider credentials/license | Provider — self-registered | PostgreSQL DB | Yes | YES | Provider-PII |
| Parent/guardian first + last name | User — at registration | PostgreSQL DB | Yes | YES — linked to minor client | YES (if linked to minor's record) |
| Minor client relationship to guardian | User | PostgreSQL DB | Yes | YES | TBD |
| Login IP address | System — auto-captured | Application logs (90-day retention) [STRAWMAN] | Indirect | Indirect | Likely yes if logs are linked to PHI sessions |
| User agent / device info | System — auto-captured | Application logs (90-day retention) [STRAWMAN] | Indirect | Indirect | TBD |
| Video recordings of sessions | [UNKNOWN — does Horizon record sessions?] | [UNKNOWN — AWS S3 if yes] | Yes | YES | YES + BIPA risk if yes |
| Audio recordings | [UNKNOWN] | [UNKNOWN] | Yes | YES | YES if yes |
| School/program affiliation (if tracked) | User or Provider | [UNKNOWN] | Yes | YES | TBD |
| Emergency contact info | User — parent/guardian | PostgreSQL DB [STRAWMAN] | Yes | Indirect | TBD |

**Founder: strike out rows that don't apply. Add rows for any field not listed.**

---

## Critical Questions — Answered (Strawman + UNKNOWN flagged)

### Data Collection

**1. Does Horizon collect clinical notes?**
> [STRAWMAN] YES — Session notes are a core ABA platform feature.
> *Founder confirm: Y / N*

**2. Does Horizon collect assessment results?**
> [STRAWMAN] YES — VB-MAPP, ABLLS-R, PEAK, and similar assessments are standard in ABA.
> *Founder confirm: Y / N / PLANNED*

**3. Does Horizon collect insurance information?**
> [STRAWMAN] YES — ABA therapy is largely insurance-funded; billing requires payer info.
> *Founder confirm: Y / N / PLANNED*

**4. Does Horizon collect diagnosis codes?**
> [STRAWMAN] YES — ABA serves clients with autism (F84.0) and related diagnoses; codes required for insurance claims.
> *Founder confirm: Y / N / PLANNED*

**5. Does Horizon collect treatment plans?**
> [STRAWMAN] YES — Treatment plans (goals, objectives, interventions) are central to ABA workflow.
> *Founder confirm: Y / N / PLANNED*

**6. Does Horizon collect video/audio recordings?**
> [UNKNOWN] — Some ABA platforms record sessions for supervision. Does Horizon?
> *Founder must answer: Y / N / PLANNED*
> ⚠️ If YES: triggers BIPA (Illinois biometric law) and HIPAA video PHI rules. Flag to Counselor immediately.

**7. Does Horizon collect minor children's information?**
> [STRAWMAN] YES — ABA primarily serves children ages 2–18, often diagnosed with autism in early childhood.
> *Founder confirm: Y / N*
> ⚠️ If YES: COPPA applies to users under 13. Parental consent mechanism required.

**8. Does Horizon integrate with EHR systems?**
> [STRAWMAN] NOT in V1 — PLANNED for future (HL7/FHIR integration with pediatric EHRs).
> *Founder confirm: Y / N / PLANNED*

**9. Does Horizon integrate with insurance/billing systems?**
> [STRAWMAN] PLANNED — Direct clearinghouse integration (Availity, Change Healthcare) for claim submission is a likely V2 feature.
> *Founder confirm: Y / N / PLANNED*

**10. Does Horizon share data with third parties (other than service providers)?**
> [STRAWMAN] NO — Data shared only with:
> - Stripe (billing — under BAA or PCI scope)
> - Email provider / Postmark (transactional email — BAA required)
> - No data sold or shared with advertisers
> *Founder confirm: Y / N — list any third parties if YES*

---

### Data Storage

**11. Where is data stored?**
> [STRAWMAN] AWS (us-east-1) — PostgreSQL via RDS; file storage via S3 if video/audio.
> *Founder confirm or correct.*

**12. Is data encrypted at rest?**
> [STRAWMAN] PLANNED — AWS RDS encryption (AES-256) + S3 server-side encryption. HIPAA requires this.
> *Founder confirm: Y / N / PLANNED — if Y, state algorithm*

**13. Is data encrypted in transit?**
> [STRAWMAN] YES — Standard Go TLS 1.3 for all API endpoints. HIPAA requires this.
> *Founder confirm: Y / N — if Y, TLS version*

**14. Who has access to production data?**
> [STRAWMAN] Engineering team + Founder (development stage). Should be locked down pre-launch.
> *Founder confirm and list names/roles.*

**15. Is access logged and audited?**
> [STRAWMAN] PLANNED — Access logging to be implemented before launch per HIPAA Security Rule §164.312(b).
> *Founder confirm: Y / N / PLANNED*

---

### Data Subjects

**16. Are Horizon's primary users therapists, parents, clients, or all?**
> [STRAWMAN] ABA Providers (BCBAs and RBTs) are the primary platform users. Parents/guardians have secondary access (progress reports, scheduling). Clients (children) do not directly interact with the platform.
> *Founder confirm or correct.*

**17. Are any users likely under 13?**
> [STRAWMAN] YES — The *clients* (the children receiving ABA therapy) are often 2–8 years old. The *platform users* (parents, providers) are adults. However, the platform handles data ABOUT children under 13.
> *Founder confirm: Y / N*
> ⚠️ COPPA applies to data collected FROM children under 13. Data collected ABOUT them with parental consent may be treated differently — Counselor must determine.

**18. Are any users likely under 18?**
> [STRAWMAN] YES — ABA commonly serves clients up to age 18+.
> *Founder confirm: Y / N*

**19. Geographic distribution of users:**
> [STRAWMAN] US-only (V1). ABA is a US-dominant specialty service.
> *Founder confirm or correct.*
> Note: If US + international, GDPR (EU) and PIPEDA (Canada) may apply — Counselor determination required.

---

### Business Model

**20. Does Horizon receive payment from insurance companies directly?**
> [STRAWMAN] NO — Horizon is B2B SaaS. ABA practices (the customers) bill insurance and pay Horizon a subscription fee. Horizon does not bill insurance directly.
> *Founder confirm: Y / N*

**21. Does Horizon submit insurance claims on behalf of providers?**
> [STRAWMAN] PLANNED (V2) — Claim submission via clearinghouse is a planned feature. Not in V1.
> *Founder confirm: Y / N / PLANNED*
> ⚠️ If YES: Horizon may become a Business Associate of the insurance company as well, not just the provider.

**22. Does Horizon have access to provider EHR systems?**
> [STRAWMAN] NO (V1). PLANNED future integration.
> *Founder confirm: Y / N / PLANNED*

**23. Are providers Horizon's customers, or is Horizon billed by providers' customers?**
> [STRAWMAN] Providers (ABA practices / clinics) ARE Horizon's customers. Horizon is B2B SaaS — ABA clinics subscribe and their staff uses the platform to serve their clients (the children + families).
> *Founder confirm: Y / N — correct if different*

---

## Third-Party Integrations (Strawman List)

| Vendor | Purpose | PHI Shared? | BAA Status |
|---|---|---|---|
| Stripe | Payment processing, subscription billing | No PHI — billing address only | PCI scope; BAA request sent (deferred per Founder) |
| Postmark (or email provider) | Transactional email (trial reminders, receipts) | Possibly — if email contains PHI (appointment reminders with client names) | BAA request sent (deferred per Founder) |
| AWS | Infrastructure (hosting, storage, DB) | YES — all PHI lives on AWS | AWS BAA auto-included in AWS HIPAA-eligible services |
| [UNKNOWN] Clearinghouse | Insurance claim submission (if V2) | YES — claims contain PHI | BAA required before implementation |
| [UNKNOWN] EHR system | Future integration | YES | BAA required before implementation |

---

## Why Horizon Is Almost Certainly a Business Associate

Horizon ABA Health is software used by healthcare providers to deliver ABA therapy.
Even if Horizon never reads the clinical data directly, it creates, receives, maintains,
and transmits PHI on behalf of covered entities (the ABA practices).

That makes Horizon a **Business Associate** under 45 CFR §160.103.

**Consequences (Counselor to confirm):**
1. BAA required with every ABA practice that subscribes (Horizon is the BA, practice is the CE)
2. BAA required with AWS, email provider, and any vendor that touches PHI
3. HIPAA Security Rule applies in full to Horizon's systems
4. HIPAA Breach Notification Rule applies
5. Cannot use PHI for any purpose other than providing the service

---

## Founder Sign-Off

Before sending to Counselor, Founder confirms:

- [ ] Rows marked [STRAWMAN] are reviewed and corrected where wrong
- [ ] Rows marked [UNKNOWN] are answered
- [ ] All fields Horizon actually collects are in the table
- [ ] All planned future fields are listed and marked "PLANNED"
- [ ] Third-party integrations list is complete
- [ ] Video/audio question (Q6) answered — this has BIPA implications

**Signed:** _________________________ **Date:** _____________

---

*Drafted by: Claude (AI, Horizon FEEP session) on 2026-06-03*  
*Based on: ABA therapy platform domain knowledge + HIPAA 45 CFR Parts 160/164*  
*Pending: Founder review + Counselor legal determinations*
