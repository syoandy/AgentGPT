# Universal Governance Template
**Parent doctrine:** FEEP Article II  
**Applies to:** Every Horizon empire entity

This template is copied (by reference, not duplication) into every new entity's docs folder during Phase 2 of the Universal Company Launch Sequence.

---

## 1. ENTITY IDENTITY

```
Entity legal name:        ____________________________
DBA / brand name:         ____________________________
Formation type:           [LLC / C-Corp / Trust / Other]
State of formation:       ____________________________
EIN:                      ____________________________
Incorporated date:        ____________________________
Tier (per FEEP V):        [S / A / B / C]
Industry:                 ____________________________
Primary product:          ____________________________
```

---

## 2. OFFICERS

```
Founder:                Yoandy OS (always)
Counselor:              (per Counselor Doctrine — same person across empire)
Entity Lead:            ____________________________
Engineering Lead:       ____________________________
Finance Officer:        (Founder or designated)
Security Officer:       (per FEEP V tier requirements)
```

---

## 3. DECISION AUTHORITY MATRIX

| Decision Type | Authority | Override |
|---|---|---|
| Product roadmap | Entity Lead | Founder |
| Hiring | Entity Lead | Founder |
| Vendor selection (< $1k/mo) | Entity Lead | None below threshold |
| Vendor selection ($1k–$10k/mo) | Entity Lead + Finance Officer | Founder |
| Vendor selection (> $10k/mo) | Founder | None |
| Contract review (< $50k total) | Counselor | Founder |
| Contract review (> $50k total) | Counselor → Founder | None |
| Legal artifact (ToS, Privacy, BAA) | Counselor | Founder |
| Production deploy | Engineering Lead | Counselor (Tier S only) |
| Production data deletion | Engineering Lead + Counselor | Founder |
| Customer refund (< $500) | Entity Lead | None |
| Customer refund (> $500) | Entity Lead + Finance Officer | Founder |
| Public statement on legal matter | Counselor | Founder |
| Settlement < $10k | Counselor | Founder |
| Settlement > $10k | Founder + Counselor | None |
| Acquisition | Founder | None |
| Entity dissolution | Founder | None |

---

## 4. MEETING CADENCE

| Meeting | Frequency | Attendees | Purpose |
|---|---|---|---|
| Daily standup (engineering) | Daily | Engineering team | Status |
| Entity weekly | Weekly | Entity Lead + key staff | Progress, blockers |
| Empire monthly | Monthly | Founder + all Entity Leads + Counselor | Cross-entity coordination |
| Quarterly board review | Quarterly | Founder + Counselor + Entity Lead | Compliance, audits, strategy |
| Annual planning | Annually | Founder + Counselor + Chief of Staff | Empire-wide strategy |

---

## 5. DOCUMENTATION SCHEMA (Per Entity)

Every entity creates this folder structure in its repo:

```
docs/
├── governance/
│   ├── ENTITY_INFO.md             — Section 1 above, filled in
│   ├── OFFICERS.md                — Section 2 above
│   ├── DECISION_MATRIX.md         — Section 3 above
│   └── MEETING_LOG.md             — minutes from all meetings
├── legal/
│   ├── COUNSELOR_APPROVAL_PACKAGE.md
│   ├── DATA_DICTIONARY.md         — entity-specific
│   ├── ToS.md
│   ├── PRIVACY_POLICY.md
│   ├── BAA_REGISTRY.md            — list of all executed BAAs
│   └── COMPLIANCE_AUDIT.md
├── security/
│   ├── TIER_ASSIGNMENT.md         — per FEEP Article V
│   ├── ACCESS_CONTROL.md
│   └── INCIDENT_LOG.md
├── financial/
│   ├── BANK_ACCOUNTS.md
│   ├── STRIPE_CONFIG.md
│   └── REVENUE_LOG.md
├── operations/
│   ├── SESSION_LOG.md             — chronological work log
│   ├── DEPLOY_LOG.md              — every production deploy
│   └── TRUTH_SCORES/              — per-feature truth score files
└── audits/
    ├── quarterly-{YYYY-Q}.md      — compliance + security + financial
    └── cross-contamination-{YYYY-Q}.md
```

---

## 6. ROLE RESPONSIBILITY MATRIX (RACI)

| Activity | Founder | Counselor | Entity Lead | Eng Lead | Finance | Security |
|---|---|---|---|---|---|---|
| Set strategy | R/A | C | C | I | I | I |
| Approve ToS | A | R | C | I | I | I |
| Run production | I | I | A | R | I | C |
| Sign contract <$50k | I | R | C | I | C | I |
| Sign contract >$50k | A | R | C | I | C | I |
| Hire engineer | I | I | A | R | I | I |
| Configure CI/CD | I | I | A | R | I | C |
| Configure auth | I | C | A | R | I | R |
| Bank reconciliation | A | I | I | I | R | I |
| Security audit | I | C | I | C | I | R/A |
| HIPAA review (Tier S) | A | R | C | C | I | C |

**Legend:** R = Responsible (does the work) · A = Accountable (signs off) · C = Consulted · I = Informed

---

## 7. SUCCESSION

If the Entity Lead becomes unavailable:
1. Chief of Staff appointed acting Entity Lead
2. Founder designates permanent successor within 90 days
3. Counselor continues — Counselor role is empire-wide, not entity-specific

If the Founder becomes unavailable:
- Per separate Founder Succession Doctrine (TBD — to be drafted)
- Counselor + Chief of Staff jointly manage empire under interim doctrine
- Final disposition per Founder's estate plan

---

## 8. AMENDMENT

This template may be amended only by FEEP Article XV procedure.
Entity-level customizations must be additive — they cannot weaken empire-wide requirements.
