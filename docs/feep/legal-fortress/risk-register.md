# Empire Risk Register
**Per Legal Fortress Doctrine §3**  
**Maintained by:** Counselor  
**Review cadence:** Quarterly + immediate on new risk identification  
**Last updated:** 2026-06-02

---

## ACTIVE RISKS

| ID | Risk | Likelihood | Impact | Mitigation | Owner | Status |
|---|---|---|---|---|---|---|
| R-001 | HIPAA breach (Horizon ABA) | Medium | Critical | BAAs (pending), encryption, audit logs, breach plan | Counselor | OPEN — BAAs pending execution |
| R-002 | FTC consumer protection action (subscription/billing) | Low | High | ROSCA compliance via SubscriptionDisclosure, CancellationFlow | Counselor | PENDING WIRING |
| R-003 | State AG action (CA AB 2863, NY GBL §527-a) | Low | Medium | State law applicability matrix, ToS compliance | Counselor | PENDING WIRING |
| R-004 | Customer chargeback storm | Medium | Medium | Dispute dashboard, retention discipline, trial reminders | Entity Lead | PENDING WIRING |
| R-005 | IP theft by employee | Low | High | IP assignments, NDAs, exit interviews | Founder | NO EMPLOYEES YET |
| R-006 | Tax exposure (multi-state nexus) | Medium | Medium | State tax review, automated filings | Finance Officer | PENDING ENTITY ACTIVATION |
| R-007 | Veil-piercing lawsuit | Low | Critical | Corporate formalities, capitalization, separate books | Counselor | DEPENDS ON ENTITY FORMATION STATUS |
| R-008 | Vendor data breach (Stripe, hosting, email) | Medium | High | BAA list, vendor security review, incident response | Counselor | BAA EXECUTION IN PROGRESS |
| R-009 | Founder incapacitation | Low | Critical | Founder Succession Doctrine (signed), POAs (pending), estate plan (pending) | Founder | DOCTRINE SIGNED 2026-06-02; PERSONAL DOCS PENDING |
| R-010 | Cross-company contamination (Horizon → PoolCurrent or vice versa) | Low | High | Cross-Company Isolation Doctrine + quarterly audit | Counselor | PENDING POOLCURRENT ACTIVATION |
| R-011 | AI assistant generating non-compliant artifacts | Medium | Medium | Counselor approval gate on all legal artifacts, Mandatory Rule 5 (Context-First) | Counselor | ACTIVE CONTROL |
| R-012 | Apple App Store rejection (if iOS app) | Medium | High | §3.1.2 compliance, IAP if required | Engineering Lead | TBD — iOS status unknown |
| R-013 | Google Play rejection (if Android app) | Medium | High | Google Play Billing compliance | Engineering Lead | TBD — Android status unknown |
| R-014 | BIPA exposure (if biometric capture) | Low | Critical | Avoid biometric capture, or BIPA notice + consent | Counselor | TBD — video/audio capture status unknown |
| R-015 | GDPR exposure (if EU users) | Low | High | Avoid EU users or full GDPR posture (DPA, DPO, etc.) | Counselor | TBD — geography unknown |
| R-016 | Counselor unavailable (sickness, conflict, separation) | Low | High | Acting Counselor per Counselor Doctrine VII | Founder | NO COUNSELOR DESIGNATED YET |

---

## RESOLVED / CLOSED RISKS

(None yet — empire is pre-launch)

---

## NEW RISK INTAKE

When a new risk is identified:

1. Add to table above with provisional ID (R-XXX)
2. Assign Likelihood (Low / Medium / High)
3. Assign Impact (Low / Medium / High / Critical)
4. Document Mitigation already in place
5. Assign Owner (who is responsible for managing it)
6. Status (OPEN / IN PROGRESS / RESOLVED / TRANSFERRED)
7. Counselor reviews + accepts into register at next quarterly review (or sooner for high-priority)

---

## QUARTERLY REVIEW CHECKLIST

For each Active Risk:
- [ ] Has likelihood or impact changed?
- [ ] Is mitigation still effective?
- [ ] Owner still accurate?
- [ ] Status accurate?
- [ ] Should this risk be closed?
- [ ] New risks since last review?

Output: append to `docs/feep/legal-fortress/risk-register-history.md` (rolling log).

---

## RISK APPETITE STATEMENT

Founder + Counselor have agreed on the following risk appetite:

| Domain | Acceptable | Not Acceptable |
|---|---|---|
| HIPAA compliance | Operating under BAAs with documented controls | Operating without BAAs |
| Subscription law | Best-effort compliance + ongoing review | Knowing violation |
| Customer data | Tier S security with quarterly audits | Any sale or unauthorized sharing |
| Marketing claims | Substantiated claims per FTC standard | Aspirational claims about compliance |
| Geography expansion | Methodical state-by-state with Counselor review | Launching in EU without GDPR posture |
| AI assistant work | Human review on all artifacts | Autonomous deployment of legal/compliance code |

This statement is appended to the Risk Register and updated annually.
