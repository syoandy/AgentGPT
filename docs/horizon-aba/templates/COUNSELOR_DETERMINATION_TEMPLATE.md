# Counselor Determination Response — Template
**Use:** Counselor fills this in to respond to a COUNSELOR_APPROVAL_PACKAGE.md  
**Authority:** Counselor Authority Doctrine Article I + II.2

This is what Counselor returns after reviewing an Approval Package. It is the operational output of Counselor's authority.

---

## SECTION A — IDENTIFICATION

```
Entity reviewed:           Horizon AB Health
Approval Package version:  docs/horizon-aba/legal/COUNSELOR_APPROVAL_PACKAGE.md @ commit ____________________
Submission date:           ____________________
Determination date:        ____________________
Counselor name:            ____________________
Counselor bar status:      [Bar-admitted in {state} / Not bar-admitted]
Determination ID:          DET-HORIZON-{YYYY-MM-DD}-001
```

---

## SECTION B — BINARY DETERMINATIONS (13 Questions)

For each question, mark one: **YES / NO / NEEDS MORE INFO / ESCALATE TO EXTERNAL**

### B.1 HIPAA Scope

**Q1: Does Horizon's data model constitute PHI?**
- [ ] YES — Horizon handles PHI
- [ ] NO — Horizon does not handle PHI
- [ ] NEEDS MORE INFO — specify what data field(s) need clarification
- [ ] ESCALATE — qualified healthcare counsel required
- Rationale: ____________________
- Conditions: ____________________

**Q2: Is Horizon a Covered Entity, Business Associate, or neither?**
- [ ] Covered Entity
- [ ] Business Associate
- [ ] Neither
- [ ] ESCALATE
- Rationale: ____________________

**Q3: If PHI is involved, what is the minimum required compliance set?**
- [ ] BAAs only
- [ ] Full HIPAA Security Rule
- [ ] HITECH breach notification (always with above)
- [ ] N/A — no PHI
- Rationale: ____________________

### B.2 Subscription Law

**Q4: Post-FTC Click-to-Cancel-vacatur (July 2024), what federal standard applies to Horizon?**
- Determination: ____________________
- Citation: ____________________
- Action required: ____________________

**Q5: Which state auto-renewal laws apply based on Horizon's customer geography?**
- Applicable states: ____________________
- Per-state requirements summarized: ____________________

**Q6: Is an affirmative consent checkbox required at checkout, and in which states?**
- [ ] YES — required nationwide
- [ ] YES — required in: ____________________
- [ ] NO
- Action: ____________________

### B.3 App Store / Platform Law

**Q7: If Horizon launches iOS app selling subscriptions, does it require Apple IAP?**
- [ ] YES — IAP required
- [ ] NO — exemption applies: ____________________
- [ ] NEEDS MORE INFO — specifically: ____________________

**Q8: Does Horizon qualify for any Apple exemptions (reader app, B2B, healthcare)?**
- [ ] YES — exemption: ____________________
- [ ] NO
- Action: ____________________

### B.4 Minors / COPPA

**Q9: If ABA clients include minors, does Horizon's data collection trigger COPPA?**
- [ ] YES — COPPA applies
- [ ] NO
- [ ] NEEDS MORE INFO — clarify: do users include children under 13?
- Action: ____________________

**Q10: What parental consent mechanism is required?**
- Determination: ____________________
- Implementation requirements: ____________________

### B.5 State-Specific

**Q11: California — CCPA/CPRA applicability and required disclosures**
- Applicable? [Y/N]: ___
- Required disclosures: ____________________

**Q12: New York — Shield Act applicability**
- Applicable? [Y/N]: ___
- Required actions: ____________________

**Q13: Illinois — BIPA applicability if biometric data captured (video assessments?)**
- [ ] YES — BIPA applies
- [ ] NO — no biometric data
- [ ] NEEDS MORE INFO — does Horizon capture video/audio of identifiable persons?
- Action if YES: ____________________

---

## SECTION C — ARTIFACT-LEVEL APPROVALS

For each artifact submitted in the Package:

| Artifact | Status | Conditions | Re-review Required |
|---|---|---|---|
| `SubscriptionDisclosure.tsx` | [APPROVED / CONDITIONAL / REJECTED] | ____ | [Y/N] |
| `CancellationFlow.tsx` | __ | __ | __ |
| `trial_reminder.go` | __ | __ | __ |
| `stripe_webhooks.go` | __ | __ | __ |
| `dispute_dashboard.go` | __ | __ | __ |
| `STRIPE_BAA_REQUEST_TEMPLATE.md` | __ | __ | __ |
| `EMAIL_BAA_REQUEST_TEMPLATE.md` | __ | __ | __ |
| `TOS_SUBSCRIPTION_LANGUAGE.md` | __ | __ | __ |
| `PRIVACY_POLICY_HEALTH_DATA.md` | __ | __ | __ |
| `HIPAA_DATA_DICTIONARY` (filled-in version) | __ | __ | __ |

---

## SECTION D — RISKS COUNSELOR FLAGS

| Risk | Likelihood | Impact | Recommendation |
|---|---|---|---|
| (Counselor fills in) | | | |

---

## SECTION E — REMEDIATIONS REQUIRED BEFORE LAUNCH

Action items Founder + Engineering must complete:

- [ ] ____________________  — deadline: __
- [ ] ____________________  — deadline: __
- [ ] ____________________  — deadline: __

---

## SECTION F — APPROVED CONDITIONALLY ON

If approved with conditions, list each:

```
Condition 1: ____________________
Verification: who confirms this is met + when
Sign-off:    Counselor + Founder

Condition 2: ____________________
...
```

---

## SECTION G — RE-REVIEW TRIGGERS

Counselor must re-review if any of these occur post-approval:

- [ ] User count crosses {N}
- [ ] New data type added to product
- [ ] New geography (state or country)
- [ ] New product line or feature category
- [ ] Material change to ToS or Privacy Policy
- [ ] BAA terminated or vendor change
- [ ] Active regulatory inquiry
- [ ] Security incident affecting PHI
- [ ] Other: ____________________

---

## SECTION H — ESCALATIONS

If Counselor escalated any question to external counsel (per Counselor Doctrine Article V):

| Question | External Counsel | Engagement Date | Expected Response |
|---|---|---|---|
| | | | |

---

## SECTION I — DETERMINATION FILING

Filed in: `docs/horizon-aba/legal/determinations/DET-HORIZON-{YYYY-MM-DD}-001.md`

Cross-references:
- COUNSELOR_APPROVAL_PACKAGE.md @ commit ____
- HIPAA_DATA_DICTIONARY.md @ commit ____
- SESSION_LOG.md entry: date ____

---

## SECTION J — SIGNATURES

```
Counselor signature:        ____________________
Date:                       ____________________

Founder acknowledgment:     ____________________  (acknowledges receipt + accepts conditions)
Founder signature:          ____________________
Date:                       ____________________
```

---

## SECTION K — IF DETERMINATION INCLUDES ANY "NEEDS MORE INFO"

The Approval Package returns to Founder for completion.
Founder updates the Package + re-submits.
Counselor re-reviews only the updated questions.
New Determination issued with same ID + "-r2" suffix.
