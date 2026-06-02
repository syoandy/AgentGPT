# Universal Audit Matrix
**Parent doctrine:** FEEP Article XII  
**Applies to:** Every empire entity

This matrix defines WHAT to audit, WHEN to audit it, WHO runs the audit, and WHAT counts as a passing result.

---

## 1. AUDIT CATEGORIES

| Category | Frequency | Auditor | Tier Trigger |
|---|---|---|---|
| Compliance | Quarterly | Counselor | All tiers |
| Security | Quarterly | Security Officer | Tier A and above |
| Cross-contamination | Quarterly | Chief of Staff | All tiers |
| Truth Score reconciliation | Quarterly | Engineering Lead | All tiers |
| Financial | Quarterly | Finance Officer + external CPA | All tiers |
| Doctrine consistency | Annual | Counselor | Empire-wide |
| Counselor effectiveness | Annual | Founder | Empire-wide |
| AI assistant work review | Annual | Founder + Counselor | Empire-wide |
| Penetration test | Annual | External vendor | Tier S |
| SOC 2 audit | Annual | External auditor | Tier A and above |
| HIPAA risk assessment | Annual | Counselor + Security Officer | Tier S |

---

## 2. COMPLIANCE AUDIT — DETAILED

### What to audit
- ToS current and Counselor-approved
- Privacy Policy current and Counselor-approved
- BAAs current (no expired, all vendors covered)
- State law applicability matrix current (geography of users vs. applicable laws)
- Federal law applicability current (HIPAA, ROSCA, FTC, COPPA)
- Regulatory filings current (state registrations, tax filings)
- Customer-facing legal disclosures rendering correctly
- Data retention policy followed (logs purged on schedule)

### Output
`docs/{entity}/audits/compliance-{YYYY-Q}.md` — pass/fail per item with evidence

### Pass criteria
- 100% of items PASS, OR
- Items below pass have documented remediation plan with deadline

---

## 3. SECURITY AUDIT — DETAILED

### What to audit
- Access list — who has prod access, has it changed
- MFA enforced for everyone with admin
- Secrets rotated per policy (90 days for Tier A, 30 days for Tier S)
- Dependency CVEs (none unpatched older than 7 days for critical)
- Backup integrity test — restore a backup and verify
- Encryption verified (at rest + in transit)
- Audit log integrity (Tier S — verify immutability)
- Vendor security review (any new vendor since last audit)

### Output
`docs/{entity}/audits/security-{YYYY-Q}.md`

### Pass criteria
- No critical CVEs older than 7 days
- All admin accounts have MFA
- Backup restore succeeded in last 90 days
- No data leakage in logs (PII scan)

---

## 4. CROSS-CONTAMINATION AUDIT — DETAILED

Per FEEP Article IV.5.

### What to check (every entity pair)
- No entity's customer email appears in another entity's customer table
- No shared Stripe customer ID across entities
- No shared API keys in code
- No shared database connections
- No subdomain crossover (e.g., admin.entity1.com doesn't resolve to entity2 infra)
- DNS records correctly attributed

### Tooling
SQL query examples (adapt to your DB):
```sql
-- Find customer emails appearing in multiple entities
SELECT email, COUNT(DISTINCT entity_db) FROM (
  SELECT email, 'horizon' AS entity_db FROM horizon.users
  UNION ALL
  SELECT email, 'poolcurrent' FROM poolcurrent.users
) cross_entity GROUP BY email HAVING COUNT(DISTINCT entity_db) > 1;
```

### Output
`docs/feep/audits/cross-contamination-{YYYY-Q}.md`

### Pass criteria
- Zero unexplained overlaps
- Any overlaps must be documented in `docs/feep/exceptions/` and have valid reason

---

## 5. TRUTH SCORE RECONCILIATION

### What to check
- Every feature claimed "shipped" in last quarter has a Truth Score file
- Every Truth Score file shows 100/100
- For features with Truth Score < 100: status updated to "in progress" not "complete"
- Public claims (marketing, sales decks) match Truth Score reality

### Output
`docs/{entity}/audits/truth-score-{YYYY-Q}.md`

### Pass criteria
- 100% of "shipped" features have Truth Score = 100
- No false production claims in marketing material

---

## 6. FINANCIAL AUDIT

### Internal (Finance Officer)
- Bank reconciliation
- Stripe payouts match revenue recognized
- All vendor invoices paid on time
- Tax estimated payments current
- Expense categorization accurate

### External (CPA)
- GAAP-compliant books
- Tax returns filed on time
- 1099s issued where required

### Output
`docs/{entity}/audits/financial-{YYYY-Q}.md`

### Pass criteria
- Bank rec matches to the penny
- No unexplained vendor payments
- CPA letter of no findings

---

## 7. DOCTRINE CONSISTENCY AUDIT (Annual, Empire-Wide)

### What to check
- FEEP > Counselor Authority Doctrine > Mandatory Rules — no contradictions
- Each entity's local docs align with FEEP — no contradictions
- Each entity's customizations are additive (no weakening of empire standards)
- Amendment trail complete (every change has Article XV record)

### Process
1. Counselor reads FEEP cover-to-cover
2. Counselor scans each entity's `docs/{entity}/` for inconsistencies
3. Counselor produces contradiction report
4. Founder + Counselor agree on resolution (amend FEEP or amend entity doc)

### Output
`docs/feep/audits/doctrine-consistency-{YYYY}.md`

### Pass criteria
- Zero unresolved contradictions
- Any contradictions found have remediation plan within 30 days

---

## 8. COUNSELOR EFFECTIVENESS AUDIT (Annual)

### What to measure
- Total approval packages reviewed
- Average turnaround time (target: ≤5 business days)
- Escalations to external counsel (rate + reason)
- Veto count (and downstream impact)
- Founder override count (high count = Counselor over-restrictive or Founder bypassing)

### Output
`docs/feep/audits/counselor-effectiveness-{YYYY}.md`

### Pass criteria
- Counselor turnaround ≤5 business days average
- External counsel escalations < 15% of packages
- Founder override count = 0 (any override = doctrine review needed)

---

## 9. AI ASSISTANT WORK REVIEW (Annual)

### What to check (sample)
- Random sample 10% of AI-produced files from year
- Verify: followed FEEP, followed Mandatory Rules, no fabrication
- Identify any AI-introduced contradictions
- Identify any AI-skipped blocker documentation

### Output
`docs/feep/audits/ai-assistant-{YYYY}.md`

### Pass criteria
- < 5% of sampled AI output has FEEP violation
- Zero fabricated compliance claims
- Blocker documentation complete on 100% of sampled sessions

---

## 10. PENETRATION TEST (Tier S Only, Annual)

### Scope
- External: public-facing endpoints
- Internal: post-auth attack paths
- Social: phishing simulation (with workforce consent)

### Vendor selection
- Counselor + Security Officer pick vendor
- Vendor must have prior healthcare-SaaS experience (Tier S)
- Vendor signs BAA before access

### Output
- Vendor report
- Remediation plan with deadlines
- Filed in `docs/{entity}/security/pentest-{YYYY}.md`

### Pass criteria
- No critical findings unresolved at 30 days
- No high findings unresolved at 90 days
- All remediations tested in subsequent year's test

---

## 11. SOC 2 AUDIT (Tier A and Above, Annual)

### Type
- Type 1 first year
- Type 2 every year thereafter

### Trust Service Criteria
- Security (always)
- Availability (always)
- Confidentiality (Tier A+)
- Privacy (Tier S)
- Processing Integrity (if billing core)

### Output
- SOC 2 report from external auditor
- Filed in `docs/{entity}/security/soc2-{YYYY}.md`

---

## 12. HIPAA RISK ASSESSMENT (Tier S Only, Annual)

Per 45 CFR § 164.308(a)(1)(ii)(A).

### Process
- Identify all PHI handled by entity
- Identify threats to PHI (technical, physical, administrative)
- Identify vulnerabilities
- Determine risk levels
- Document remediations
- Update policies + procedures

### Output
- HIPAA Risk Assessment document
- Filed in `docs/{entity}/legal/hipaa-risk-assessment-{YYYY}.md`

### Pass criteria
- Assessment completed annually (HHS requirement)
- High-risk findings have documented mitigation
- Workforce HIPAA training current (every employee, every year)

---

## 13. AUDIT CALENDAR — TEMPLATE

Per entity, annually:

| Month | Audit |
|---|---|
| Jan | Q4 compliance + security + cross-contamination + Truth Score + financial |
| Feb | (no audits — Q1 begins) |
| Mar | (Q1 in progress) |
| Apr | Q1 compliance + security + cross-contamination + Truth Score + financial |
| Jul | Q2 compliance + security + cross-contamination + Truth Score + financial |
| Oct | Q3 compliance + security + cross-contamination + Truth Score + financial |
| Nov-Dec | Annual: doctrine consistency, Counselor effectiveness, AI review, SOC 2 prep, HIPAA risk |

---

## 14. AUDIT FAILURE PROTOCOL

If an audit fails:
1. Counselor notified within 24 hours
2. Founder notified within 48 hours
3. Remediation plan within 7 days (with deadline)
4. Re-audit on remediation deadline
5. If re-audit fails: escalation to Founder for entity-level decision (continue / pause / dissolve)

Repeated audit failures = doctrine violation = Article XV review.
