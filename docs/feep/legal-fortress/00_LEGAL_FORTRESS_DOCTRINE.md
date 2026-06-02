# Legal Fortress — Operating Doctrine
**Parent doctrine:** FEEP Master  
**Operational head:** Horizon Counselor (per Counselor Authority Doctrine 8.1)  
**Scope:** Empire-wide legal posture, risk management, contract architecture, IP protection, litigation readiness

---

## 1. WHAT LEGAL FORTRESS IS

Legal Fortress is the **structural legal defense system** of the empire. It is not a single document — it is a **set of interlocking protections** that, together, make the empire resilient against:

- Personal liability of the Founder
- Cross-entity liability spillover
- Customer lawsuits
- Regulatory action (HHS, FTC, state AGs)
- IP theft and infringement
- Contract disputes
- Employment claims
- Tax exposure

Counselor is the operational head of Legal Fortress. FEEP defines the strategic doctrine. This document defines the **components** of the Fortress.

---

## 2. THE FIVE PILLARS

### Pillar 1 — Corporate Veil Protection
- Holding company at top, operating entities below
- Each entity properly formed (LLC or C-Corp)
- Each entity adequately capitalized
- Books kept separately (no commingling — FEEP Article VI)
- Formalities observed (annual meetings, resolutions, signed minutes)
- Personal vs. business expenses strictly separated

**Counselor verifies quarterly.** Veil breach = empire-wide liability exposure.

### Pillar 2 — Contract Architecture
- Standard contract library maintained by Counselor:
  - MSA (Master Services Agreement)
  - DPA (Data Processing Agreement)
  - BAA (Business Associate Agreement)
  - NDA (Mutual + One-Way)
  - Vendor agreement
  - Customer ToS
  - Privacy Policy
  - Employment agreement
  - Contractor agreement
  - IP assignment
- All public contracts reviewed by Counselor before deployment
- Contract repository: `docs/feep/legal-fortress/contracts/`

### Pillar 3 — IP Protection
- All code committed by Founder, employees, or contractors carries IP assignment
- Trademark registrations for each entity name + key product names
- Copyright notices on all public-facing material
- Trade secret protection: source code, customer lists, internal docs marked confidential
- Patent considerations (Counselor advises, USPTO bar required for filings — escalation per Counselor Doctrine V)
- Domain ownership consolidated under holding entity

### Pillar 4 — Insurance Stack
Required policies per entity:

| Policy | All Tiers | Tier S Adds | Tier A Adds |
|---|---|---|---|
| General Liability | ✅ | — | — |
| Errors & Omissions (E&O) | ✅ | — | — |
| Cyber liability | ✅ | enhanced | enhanced |
| Directors & Officers (D&O) | ✅ if Corp | — | — |
| Employment Practices Liability | ✅ if employees | — | — |
| Crime coverage | — | ✅ | — |
| Business interruption | — | ✅ | — |
| HIPAA-specific cyber rider | — | ✅ | — |

Counselor reviews coverage annually. Policy renewal dates tracked in `docs/feep/legal-fortress/insurance-calendar.md`.

### Pillar 5 — Litigation Readiness
- Document retention policy (per FEEP Build Doctrine §5 logging retention)
- Litigation hold procedure documented
- Outside counsel relationships pre-established for:
  - Healthcare regulatory (HHS, state health depts)
  - FTC / consumer protection
  - Employment disputes
  - Commercial litigation
  - IP disputes
  - Securities (if equity raising)
- Crisis communications plan
- Insurance notification procedures (notify within hours, not days)

---

## 3. RISK REGISTER

The empire maintains a written risk register at `docs/feep/legal-fortress/risk-register.md`:

| Risk Category | Likelihood | Impact | Mitigation | Owner |
|---|---|---|---|---|
| HIPAA breach (Horizon ABA) | Medium | Critical | BAAs, encryption, audit logs, breach plan | Counselor |
| FTC consumer protection action | Low | High | ROSCA compliance, Counselor review | Counselor |
| State AG action (CA AB 2863) | Low | Medium | State law matrix, ToS compliance | Counselor |
| Customer chargeback storm | Medium | Medium | Dispute dashboard, retention discipline | Entity Lead |
| IP theft by employee | Low | High | IP assignments, NDAs, exit interviews | Founder |
| Tax exposure (multi-state nexus) | Medium | Medium | State tax review, automated filings | Finance Officer |
| Veil-piercing lawsuit | Low | Critical | Corporate formalities, capitalization | Counselor |
| Vendor data breach | Medium | High | BAA list, vendor security review | Counselor |
| Founder incapacitation | Low | Critical | Succession Doctrine, Counselor + Chief of Staff | Founder |

Updated quarterly. New risks added as identified.

---

## 4. CONTRACT REVIEW WORKFLOW

```
Counterparty proposes contract
   ↓
Counselor reviews against standard library
   ↓
Counselor either:
   ├─ Approves as-is
   ├─ Returns with redlines
   ├─ Escalates to external counsel (Article V of Counselor Doctrine)
   ↓
Founder co-signs if over $50k or otherwise per FEEP Article VI.3
   ↓
Both parties execute
   ↓
Executed copy filed in docs/feep/legal-fortress/contracts/executed/{counterparty}-{date}.pdf
   ↓
Entry added to docs/feep/legal-fortress/contract-registry.md
```

---

## 5. CONTRACT REGISTRY (Format)

`docs/feep/legal-fortress/contract-registry.md`:

```markdown
| ID | Counterparty | Type | Entity | Effective | Termination | Annual $ | File |
|---|---|---|---|---|---|---|---|
| C-001 | Stripe | BAA | Horizon ABA | 2026-XX-XX | 2027-XX-XX | $0 | contracts/executed/stripe-baa-2026.pdf |
| C-002 | AWS | BAA | Horizon ABA | 2026-XX-XX | rolling | varies | contracts/executed/aws-baa-2026.pdf |
```

Counselor reviews registry quarterly for:
- Expiring contracts (90-day window)
- Termination notices required
- Renegotiation opportunities
- BAA gaps

---

## 6. POLICY LIBRARY

Counselor maintains and Founder approves:

| Policy | Required For | Review Cadence |
|---|---|---|
| Information Security Policy | All tiers | Annual |
| Acceptable Use Policy | All tiers | Annual |
| Data Retention Policy | All tiers | Annual |
| Incident Response Plan | Tier A+ | Annual |
| Business Continuity Plan | Tier S | Annual |
| HIPAA Privacy Policies | Tier S Covered Entity | Annual |
| HIPAA Security Policies | Tier S | Annual |
| Workforce HIPAA Training | Tier S | Annual per employee |
| Code of Conduct | All tiers with employees | Annual |
| Whistleblower Policy | Corps (Tier A+) | Annual |

All policies stored in `docs/feep/legal-fortress/policies/`.

---

## 7. RECORDS RETENTION SCHEDULE

| Record Type | Retention | Authority |
|---|---|---|
| Tax records | 7 years | IRS standard |
| Employment records | 7 years post-separation | State law max |
| HIPAA PHI | 6 years minimum | 45 CFR § 164.530(j) |
| Customer billing records | 7 years | Tax / dispute defense |
| Contracts (executed) | Term + 6 years | Statute of limitations |
| Marketing claims (substantiation) | 3 years post-claim | FTC standard |
| Cybersecurity audit logs | 1 year minimum, 6 years (Tier S) | Industry standard |
| Email communications (business) | 7 years | Litigation preservation |
| Customer support tickets | 3 years | Customer trust + dispute |
| Code commits | Permanent | Git history |
| Session logs (AI assistants) | 7 years | FEEP audit trail |

Counselor enforces. Engineering Lead implements automated deletion at end of retention.

---

## 8. INCIDENT RESPONSE FLOW

When an incident occurs:

```
T+0     Detection (engineer, monitor, customer report)
T+5min  On-call confirms incident type + severity
T+15min Counselor notified (Tier 1 or 2)
T+30min Founder notified (Tier 1 or breach)
T+1hr   Containment actions documented
T+4hr   Customer impact assessment
T+24hr  Internal post-mortem started
T+48hr  Customer communication (if affected)
T+60day Breach notification to authorities (if PHI/PII breach)
T+90day Post-mortem published + remediations tracked
```

Counselor's role:
- Tier 1: takes operational control (per Counselor Doctrine IV)
- Tier 2: advises, monitors, files documentation
- Tier 3: post-incident review only

Incident log: `docs/{entity}/security/INCIDENT_LOG.md`

---

## 9. BANKRUPTCY / DISTRESS REMOTENESS

To protect the empire from single-entity distress:

- Holding company holds no operational liabilities
- Each operating entity is a separate legal entity
- No upstream guarantees from holding for operating debts
- No cross-entity guarantees
- Insurance limits per entity, not aggregated
- Customer contracts at operating entity level only

If one entity faces distress:
- Other entities are insulated
- Founder personal assets are insulated (subject to veil holding)
- Counselor coordinates with bankruptcy counsel (escalation per Article V)

---

## 10. INTERNATIONAL / CROSS-BORDER

If the empire ever serves non-US customers:

| Issue | Doctrine |
|---|---|
| GDPR (EU users) | DPA executed, EU representative appointed, data residency considered |
| UK GDPR (UK users) | Similar to GDPR + UK representative |
| Canada (PIPEDA) | Privacy policy compliant, breach notification flow |
| Data transfer mechanisms | Standard Contractual Clauses post-Schrems II |
| Tax — VAT / GST | Tax officer registration in applicable jurisdictions |
| Local entity requirement | Counselor advises on local entity if revenue thresholds hit |

External counsel mandatory for any non-US matter (per Counselor Doctrine Article V).

---

## 11. FOUNDER PERSONAL LEGAL POSTURE

Beyond the entity-level Fortress, Founder's personal legal posture:

| Item | Status | Owner |
|---|---|---|
| Personal estate plan (will, trust) | TBD | Founder + external estate counsel |
| Personal umbrella insurance | TBD | Founder |
| Asset protection trust | TBD | Founder + Counselor + external |
| Pre/post-nuptial agreement | If applicable | Founder + external |
| Power of attorney (financial + healthcare) | TBD | Founder + external |
| Beneficiary designations consistent | TBD | Founder |
| Founder Employment Agreement (per entity) | TBD | Counselor |

Counselor coordinates with external estate counsel — Counselor does not draft personal estate documents (out of empire scope).

---

## 12. ANNUAL LEGAL FORTRESS REVIEW

Every November:
- All 5 Pillars assessed
- Risk Register updated
- Contract Registry reviewed
- Policy library reviewed
- Insurance renewals confirmed
- External counsel relationships reviewed
- Records retention compliance audited
- Incident response plan tested (tabletop exercise)

Output: `docs/feep/legal-fortress/annual-review-{YYYY}.md` signed by Counselor + Founder.

---

## 13. WHAT LEGAL FORTRESS IS NOT

- Not a substitute for licensed external counsel on bar-required matters
- Not personal legal advice for Founder's personal life
- Not a guarantee against all lawsuits — it minimizes exposure, not eliminates
- Not a tax avoidance scheme — it operates within legal compliance

Counselor states limits explicitly in any approval document where overreach risk exists.
