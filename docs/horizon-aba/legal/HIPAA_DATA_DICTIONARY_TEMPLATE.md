# HIPAA Data Dictionary Template — Founder Fills In
**Use:** Counsel needs this to determine if Horizon handles PHI  
**Action required:** Founder fills in before sending to attorney

---

## Instructions

For every data field Horizon collects, fill in the table below.
Be honest — if you don't know, mark "UNKNOWN" so counsel can investigate.

This is the single most important document for the HIPAA review.
Without it, your attorney is guessing.

---

## Table — Fields Horizon Collects

| Field Name | Collected From | Stored Where | Linked To Individual? | Linked To Treatment? | PHI? (counsel determines) |
|---|---|---|---|---|---|
| First name | [user/provider] | [database] | Yes | [yes/no] | TBD |
| Last name | [user/provider] | [database] | Yes | [yes/no] | TBD |
| Email | [user/provider] | [database] | Yes | [yes/no] | TBD |
| Phone | [user/provider] | [database] | Yes | [yes/no] | TBD |
| Date of birth | [user/provider] | [database] | Yes | [yes/no] | TBD |
| Billing address | [user] | [Stripe + database] | Yes | [yes/no] | TBD |
| Payment method | [user] | [Stripe — not Horizon DB] | Yes | No (billing only) | No |
| Subscription plan | [system] | [database] | Yes | [yes/no] | TBD |
| Trial start/end dates | [system] | [database] | Yes | [yes/no] | TBD |
| ABA client identifier | [provider] | [database] | Yes | YES | LIKELY YES |
| Session schedules | [provider] | [database] | Yes | YES | LIKELY YES |
| Session notes (clinical) | [provider] | [database] | Yes | YES | YES |
| Assessment results | [provider] | [database] | Yes | YES | YES |
| Behavioral data logs | [provider] | [database] | Yes | YES | YES |
| Insurance information | [user/provider] | [database] | Yes | YES | YES |
| Diagnosis codes (ICD-10) | [provider] | [database] | Yes | YES | YES |
| Treatment plans | [provider] | [database] | Yes | YES | YES |
| Provider NPI numbers | [provider] | [database] | Yes | YES | Provider-PII (not PHI but sensitive) |
| Parent/guardian names | [user/provider] | [database] | Yes | YES | YES (if linked to minor) |
| Video recordings | [provider] | [storage] | Yes | YES | YES + BIPA risk |
| Audio recordings | [provider] | [storage] | Yes | YES | YES |
| IP address | [system] | [logs] | Indirectly | [yes/no] | Likely yes if linked to PHI |
| Device fingerprint | [system] | [logs] | Indirectly | [yes/no] | TBD |

**Add rows for every other field Horizon collects.**

---

## Critical Questions For Founder To Answer

### Data Collection
1. Does Horizon collect clinical notes? [Y/N]
2. Does Horizon collect assessment results? [Y/N]
3. Does Horizon collect insurance information? [Y/N]
4. Does Horizon collect diagnosis codes? [Y/N]
5. Does Horizon collect treatment plans? [Y/N]
6. Does Horizon collect video/audio recordings? [Y/N]
7. Does Horizon collect minor children's information? [Y/N]
8. Does Horizon integrate with EHR systems? [Y/N]
9. Does Horizon integrate with insurance/billing systems? [Y/N]
10. Does Horizon share data with third parties (other than service providers)? [Y/N]

### Data Storage
11. Where is data stored? (AWS / GCP / Azure / Other / Multiple)
12. Is data encrypted at rest? [Y/N — algorithm if yes]
13. Is data encrypted in transit? [Y/N — TLS version]
14. Who has access to production data? (Engineering / Customer support / Admin / Founder)
15. Is access logged and audited? [Y/N]

### Data Subjects
16. Are Horizon's primary users: (Therapists / Parents / Clients / All)
17. Are any users likely under 13? [Y/N — triggers COPPA]
18. Are any users likely under 18? [Y/N]
19. Geographic distribution of users (US-only / US+international / EU)

### Business Model
20. Does Horizon receive payment from insurance companies directly? [Y/N]
21. Does Horizon submit insurance claims on behalf of providers? [Y/N]
22. Does Horizon have access to provider EHR systems? [Y/N]
23. Are providers Horizon's customers, or is Horizon billed by providers' customers? [Y/N]

---

## Why Counsel Needs This

This table determines:
- Whether Horizon is a **Covered Entity** under HIPAA (probably no, but counsel decides)
- Whether Horizon is a **Business Associate** under HIPAA (probably yes, but counsel decides)
- Whether **BAAs are required** with downstream vendors (almost certainly yes)
- Whether **HIPAA Security Rule** applies in full (almost certainly yes)
- Whether **COPPA** applies (depends on age data)
- Whether **BIPA** applies (depends on biometric data)
- Whether **state-specific** health privacy laws apply (depends on user geography)

Without this table, your attorney is operating on assumptions. Bad assumptions = bad legal advice.

---

## Founder Sign-Off

Before sending to counsel, founder confirms:

- [ ] All fields Horizon actually collects are listed above
- [ ] All planned future fields are listed and marked as "PLANNED"
- [ ] All third-party integrations are listed
- [ ] All data flow paths are documented
- [ ] Founder has reviewed the actual data model and confirmed accuracy

**Signed:** _________________________ **Date:** _____________
