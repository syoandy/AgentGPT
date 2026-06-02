# Future Company Onboarding Framework
**Parent doctrine:** FEEP Article X (Launch), Article XI (Acquisition), Article XIII  
**Applies to:** Any new entity entering the Empire

There are two paths in:
- **Greenfield launch** (new entity created by Founder)
- **Acquisition** (existing entity bought by Founder)

Both end at the same place: an entity fully compliant with FEEP.

---

## 1. PHASE 0 — DECISION

### 1.1 Greenfield Launch
- Founder declares intent in writing (commit to `docs/feep/decisions/{YYYY-MM-DD}-launch-{name}.md`)
- Working name assigned
- Market thesis documented
- Founder + Counselor confirm no FEEP-blocking issues

### 1.2 Acquisition
- Pre-acquisition due diligence (per FEEP XI.1)
- Counselor go/no-go in writing
- Founder commits in writing to acquire

### 1.3 Output
`docs/feep/decisions/{YYYY-MM-DD}-{launch|acquire}-{name}.md`

---

## 2. PHASE 1 — TIER ASSIGNMENT

Per FEEP Article V.2, assign tier:

| Question | Answer | Tier Implication |
|---|---|---|
| Will it handle PHI? | Yes | **Tier S** (always) |
| Will it handle banking / financial data? | Yes | **Tier S** |
| Will it handle children's data (<13)? | Yes | **Tier S** (COPPA) |
| Will it process payments? | Yes | At least **Tier A** |
| Will it handle PII (email, name, address)? | Yes | At least **Tier B** |
| Marketing or content only? | Yes | **Tier C** |

Pick the highest applicable tier. Tier cannot be downgraded later.

Output: `docs/{entity}/security/TIER_ASSIGNMENT.md`

---

## 3. PHASE 2 — LEGAL FORMATION

### 3.1 Greenfield
- Decide structure: LLC vs C-Corp (Counselor recommends)
- File formation with state
- Obtain EIN from IRS
- Open business bank account
- Apply for Stripe account (Healthcare tier if Tier S)
- Acquire insurance (E&O, cyber, general liability)
- Tier S: Apply for HIPAA-eligible hosting (AWS / GCP / Azure BAA)

### 3.2 Acquisition
- Transfer entity ownership (stock or asset purchase per Counselor)
- Update bank signatories to Founder
- Re-execute Stripe account in Founder's control
- Transfer or re-issue insurance
- Tier S: Verify hosting BAA in place

### 3.3 Output Checklist
- [ ] Articles / Certificate of Formation filed
- [ ] EIN obtained
- [ ] Bank account opened (Founder signatory)
- [ ] Stripe account opened (right tier)
- [ ] Insurance bound
- [ ] Hosting account opened with BAA if applicable
- [ ] Domain registered
- [ ] Trademark search done (Counselor recommends if conflict)

---

## 4. PHASE 3 — DOCTRINE ADOPTION

### 4.1 Repository Structure
Create entity repo with required structure (per Universal Governance Template §5):

```
{entity}-app/
├── docs/
│   ├── governance/
│   ├── legal/
│   ├── security/
│   ├── financial/
│   ├── operations/
│   └── audits/
├── src/ or cmd/ (per stack)
└── ...
```

### 4.2 Doctrine References (Not Copies)
In `docs/governance/DOCTRINE_REFERENCES.md`:

```markdown
# Doctrines Governing This Entity

- FEEP: docs/feep/00_FEEP_MASTER.md @ commit {SHA at adoption}
- Counselor Authority Doctrine: docs/horizon-aba/legal/COUNSELOR_AUTHORITY_DOCTRINE.md @ {SHA}
- Mandatory Rules: docs/horizon-aba/MANDATORY_RULES.md @ {SHA}
- Universal Governance Template: docs/feep/01_UNIVERSAL_GOVERNANCE_TEMPLATE.md @ {SHA}
- Universal App Build Doctrine: docs/feep/02_UNIVERSAL_APP_BUILD_DOCTRINE.md @ {SHA}
- Universal Deployment Doctrine: docs/feep/03_UNIVERSAL_DEPLOYMENT_DOCTRINE.md @ {SHA}
- Universal Audit Matrix: docs/feep/04_UNIVERSAL_AUDIT_MATRIX.md @ {SHA}
- Cross-Company Isolation: docs/feep/05_CROSS_COMPANY_ISOLATION.md @ {SHA}

This entity adopts these doctrines in full as of {date}.
```

### 4.3 Entity-Specific Implementations
Create where applicable:
- `docs/legal/DATA_DICTIONARY.md` (filled in, per Mandatory Rule 1)
- `docs/legal/COMPLIANCE_AUDIT.md`
- `docs/governance/ENTITY_INFO.md`
- `docs/governance/OFFICERS.md`
- `docs/governance/DECISION_MATRIX.md`

---

## 5. PHASE 4 — BUILD

Follow Universal App Build Doctrine:
- Stack chosen (defaults from §1 of Build Doctrine, deviate only with reason)
- Project structure per §2 or §3 of Build Doctrine
- Mandatory components for billing-capable entities (§4)
- Code standards (§5)
- Security per assigned Tier (§6)
- Tests at required coverage (§5)
- CI/CD configured (§8)

For acquisitions: refactor existing codebase toward Universal App Build Doctrine over 90 days post-close.

---

## 6. PHASE 5 — PRE-LAUNCH APPROVAL

### 6.1 Founder Action Sheet (Per Horizon Pattern)
- [ ] Fill Data Dictionary
- [ ] Designate Entity Lead, Engineering Lead, etc.
- [ ] Sign Doctrine References document

### 6.2 Counselor Approval Package
Per Counselor Authority Doctrine Approval Package format:
- Product summary
- 13 binary determinations (HIPAA scope, subscription law, etc.)
- Pre-built artifacts (ToS, Privacy, BAAs)
- Data Dictionary attached
- Counselor written determinations
- Founder sign-off on conditions

### 6.3 BAAs (Tier S)
- [ ] Stripe Healthcare BAA signed
- [ ] Email provider BAA signed
- [ ] Hosting BAA signed
- [ ] Any vendor handling PHI has BAA

### 6.4 Public Legal Docs Published
- [ ] ToS published
- [ ] Privacy Policy published
- [ ] Cookie Policy if applicable
- [ ] HIPAA Notice of Privacy Practices if Tier S Covered Entity

### 6.5 Truth Score Capability Verified
- [ ] Code verified — commit SHA matches deployed
- [ ] Infra verified — health endpoint returns 200
- [ ] Behavior verified — end-to-end flow tested

---

## 7. PHASE 6 — LAUNCH

### 7.1 First Customer
- Onboard first customer
- Monitor closely (dashboards open)
- Capture screenshots of every flow (Truth Score evidence)
- Log launch date in `docs/operations/SESSION_LOG.md`

### 7.2 Soft Launch Window (First 7 Days)
- Founder + Engineering Lead on-call
- Counselor available within 4 hours
- All metrics monitored continuously
- Issues triaged within 1 hour

### 7.3 Hard Launch (Day 8+)
- Marketing site goes live
- Public announcement (Counselor approves messaging)
- Standard operations begin

---

## 8. PHASE 7 — STEADY STATE

### 8.1 Quarterly Audits (Per Audit Matrix)
- Q1, Q2, Q3, Q4 audits as defined in `04_UNIVERSAL_AUDIT_MATRIX.md`

### 8.2 Annual Audits
- Doctrine consistency
- Counselor effectiveness
- AI assistant review
- SOC 2 (Tier A+)
- HIPAA risk assessment (Tier S)
- Penetration test (Tier S)

### 8.3 Continuous
- Truth Score every deploy
- Session log every session
- Decision matrix followed for every decision

---

## 9. ONBOARDING TIMELINE (Greenfield Tier S)

| Week | Phase | Deliverable |
|---|---|---|
| 1 | Decision + Tier | Decision doc |
| 2–3 | Legal formation | EIN, bank, Stripe, insurance |
| 4 | Doctrine adoption | Repo, docs structure, references |
| 5–12 | Build | Codebase + Tier S security |
| 13 | Pre-launch | Counselor approval package |
| 14 | Counselor review | Determinations + conditions |
| 15 | Final BAAs | Stripe + Email + Hosting BAAs executed |
| 16 | Soft launch | First 1–10 customers |
| 17–24 | Hard launch + monitor | Public launch + steady state |

---

## 10. ONBOARDING TIMELINE (Greenfield Tier B/C)

| Week | Phase | Deliverable |
|---|---|---|
| 1 | Decision + Tier | Decision doc |
| 2 | Legal formation | EIN, bank, Stripe, insurance |
| 3 | Doctrine adoption | Repo, docs structure |
| 4–8 | Build | Codebase |
| 9 | Pre-launch | Counselor approval (shorter for Tier B/C) |
| 10 | Soft launch | First customers |
| 11+ | Hard launch | Public launch |

---

## 11. ONBOARDING TIMELINE (Acquisition)

| Month | Phase | Deliverable |
|---|---|---|
| Day 1 | Ownership transfer | Signed docs, bank/Stripe/domain transferred |
| Week 1 | Initial integration | Cross-contamination audit, BAA reissue, customer notification |
| Month 1 | Codebase merge | Acquired codebase in empire repo structure, CI/CD migrated |
| Month 3 | Full FEEP compliance | All Phase 5 + Phase 6 deliverables, Truth Score 100, Counselor sign-off |

---

## 12. ONBOARDING FAILURE CONDITIONS

Halt onboarding if:
- Counselor refuses to issue determinations
- BAAs cannot be executed within 60 days of launch target (Tier S)
- Cross-contamination audit reveals data leakage from existing entities
- Truth Score cannot reach 100 in pre-launch verification
- Founder declares pause for any reason

Halted entities documented in `docs/feep/decisions/{date}-halt-{name}.md` with reason and resolution path.

---

## 13. DECOMMISSIONING

When an entity is decommissioned:
- Founder declaration in writing
- Counselor verifies no outstanding obligations
- All customers refunded or migrated per ToS
- All data deleted or transferred per Privacy Policy retention
- Books closed per Finance Officer
- State filings to dissolve (LLC: Certificate of Dissolution; Corp: Articles of Dissolution)
- Final cross-contamination audit (verify no data left behind in shared infrastructure)
- Domain transferred to holding or released
- All BAAs terminated with proper notice

Output: `docs/feep/decisions/{date}-decommission-{name}.md`
