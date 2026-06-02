# PoolCurrent — Entity Skeleton
**Status:** SKELETON — entity exists in FEEP doctrine; specifics unknown to this AI session  
**Action Required:** Founder fills in actual entity details  
**Doctrine adopted:** FEEP, Counselor Authority Doctrine, Mandatory Rules, Universal Governance Template

---

## 1. ENTITY IDENTITY (Founder Fills In)

```
Entity legal name:        [PoolCurrent LLC / Inc — Founder fills in]
DBA / brand name:         PoolCurrent
Formation type:           [LLC / C-Corp]
State of formation:       ____________________________
EIN:                      ____________________________
Incorporated date:        ____________________________
Industry:                 [Founder describes]
Primary product:          [Founder describes]
Tier (per FEEP V):        [TBD — Counselor assigns based on Founder description]
```

---

## 2. WHY THIS SKELETON EXISTS

PoolCurrent was named in the original FEEP mission as an empire entity. This AI
session has no information about what PoolCurrent does, who its customers are,
or what tier it should be. Rather than guess, this skeleton stays empty until
Founder fills it in.

What this skeleton provides:
- Folder structure matching Universal Governance Template
- Reference to FEEP doctrines (binding immediately upon entity creation)
- Placeholder files ready to fill in
- Tier assignment template

---

## 3. DOCTRINES THIS ENTITY ADOPTS

PoolCurrent is bound by:

| Doctrine | Location | Status |
|---|---|---|
| FEEP Master | `docs/feep/00_FEEP_MASTER.md` | Bound |
| Counselor Authority Doctrine | `docs/horizon-aba/legal/COUNSELOR_AUTHORITY_DOCTRINE.md` | Bound |
| Mandatory Rules | `docs/horizon-aba/MANDATORY_RULES.md` | Bound |
| Universal Governance Template | `docs/feep/01_UNIVERSAL_GOVERNANCE_TEMPLATE.md` | Adopt as template |
| Universal App Build Doctrine | `docs/feep/02_UNIVERSAL_APP_BUILD_DOCTRINE.md` | Applied to PoolCurrent code |
| Universal Deployment Doctrine | `docs/feep/03_UNIVERSAL_DEPLOYMENT_DOCTRINE.md` | Applied to PoolCurrent deploys |
| Universal Audit Matrix | `docs/feep/04_UNIVERSAL_AUDIT_MATRIX.md` | PoolCurrent audited per cadence |
| Cross-Company Isolation | `docs/feep/05_CROSS_COMPANY_ISOLATION.md` | PoolCurrent isolated from Horizon |
| Future Company Onboarding | `docs/feep/06_FUTURE_COMPANY_ONBOARDING.md` | Followed if PoolCurrent launches new sub-product |
| Empire Scalability Score | `docs/feep/07_SCALABILITY_SCORE.md` | PoolCurrent contributes to score |
| Founder Succession Doctrine | `docs/feep/08_FOUNDER_SUCCESSION_DOCTRINE.md` | Bound |
| Legal Fortress | `docs/feep/legal-fortress/00_LEGAL_FORTRESS_DOCTRINE.md` | Bound |

---

## 4. CROSS-COMPANY ISOLATION DECLARATIONS

Per Cross-Company Isolation doctrine, PoolCurrent MUST have:

- [ ] Separate cloud / hosting account from Horizon ABA
- [ ] Separate Stripe account (Tier-appropriate)
- [ ] Separate database cluster or schema
- [ ] Separate email provider tenant
- [ ] Separate secrets vault namespace
- [ ] Separate domain(s)
- [ ] Separate ToS, Privacy Policy, BAA registry
- [ ] Customer data NEVER intersects with Horizon's

If any sharing exists, document in `docs/feep/exceptions/horizon-poolcurrent-{date}.md` with justification + risk assessment.

---

## 5. ENTITY-SPECIFIC DOCS TO CREATE (When Tier Is Known)

| File | Purpose | When |
|---|---|---|
| `governance/ENTITY_INFO.md` | Identity per §1 above | Immediately on Founder fill-in |
| `governance/OFFICERS.md` | Officer designations | Phase 2 of Launch Sequence |
| `governance/DECISION_MATRIX.md` | RACI per Universal Governance §3 | Phase 2 |
| `legal/DATA_DICTIONARY.md` | Data fields collected (Mandatory Rule 1) | Phase 3 |
| `legal/COMPLIANCE_AUDIT.md` | Compliance posture per tier | Phase 4 |
| `legal/COUNSELOR_APPROVAL_PACKAGE.md` | Submission to Counselor | Phase 5 |
| `legal/ToS.md` | Customer-facing ToS | Phase 5 |
| `legal/PRIVACY_POLICY.md` | Customer-facing Privacy | Phase 5 |
| `legal/BAA_REGISTRY.md` | Executed BAAs (if Tier S/A) | Phase 5 |
| `security/TIER_ASSIGNMENT.md` | Tier rationale + controls | Phase 1 |
| `security/INCIDENT_LOG.md` | Started empty | Phase 5 |
| `financial/BANK_ACCOUNTS.md` | Bank info | Phase 2 |
| `financial/STRIPE_CONFIG.md` | Stripe account + config | Phase 2 |
| `operations/SESSION_LOG.md` | Started empty | Phase 0 |
| `operations/DEPLOY_LOG.md` | Started empty | Phase 5 |

---

## 6. PHASE STATUS

Per Future Company Onboarding Framework:

| Phase | Status |
|---|---|
| Phase 0 — Founder Decision | ⚠️ Originally declared in FEEP mission, specifics unknown |
| Phase 1 — Tier Assignment | 🔲 Pending Founder description + Counselor assessment |
| Phase 2 — Legal Formation | ❓ Unknown to this session |
| Phase 3 — Doctrine Adoption | 🔲 This file is start of adoption |
| Phase 4 — Build | ❓ Unknown |
| Phase 5 — Pre-Launch Approval | 🔲 Pending |
| Phase 6 — Launch | 🔲 Pending |
| Phase 7 — Steady State | 🔲 Pending |

---

## 7. ACTION ITEMS FOR FOUNDER

To activate this skeleton:

1. **Describe PoolCurrent** in `governance/ENTITY_INFO.md`:
   - What does it do?
   - Who are its customers?
   - What data does it handle?
   - Does it process payments?
2. **Request Counselor tier assignment** based on description
3. **Confirm legal formation status** (already formed? to be formed?)
4. **Begin Phase 1-7 sequence** per Future Company Onboarding Framework

---

## 8. SESSION LOG (For This Skeleton)

```
2026-06-01 — Skeleton created by Claude in syoandy/agentgpt branch claude/create-feep-IU72S
2026-06-01 — Folder structure established: governance/, legal/, security/, operations/
2026-06-01 — Doctrine references confirmed
2026-06-01 — Awaiting Founder input to activate
```

---

## 9. ISOLATION FROM HORIZON ABA — DEFAULT POSTURE

Until proven otherwise:
- PoolCurrent has NO operational tie to Horizon ABA
- PoolCurrent has NO data tie to Horizon ABA
- PoolCurrent shares ONLY: Founder, Counselor, doctrine documents

Any change to this posture requires Cross-Company Isolation exception per FEEP V.

---

## 10. FILE INDEX

```
docs/poolcurrent/
├── README.md  (this file — skeleton)
├── governance/
│   ├── ENTITY_INFO.md         (created empty, Founder fills)
│   ├── OFFICERS.md            (created empty)
│   └── DECISION_MATRIX.md     (created empty)
├── legal/
│   ├── DATA_DICTIONARY.md     (created empty)
│   └── (more added when Counselor approves Phase 5)
├── security/
│   └── TIER_ASSIGNMENT.md     (created empty)
└── operations/
    └── SESSION_LOG.md         (created with one entry)
```
