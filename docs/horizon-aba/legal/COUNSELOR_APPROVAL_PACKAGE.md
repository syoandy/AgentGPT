# Horizon ABA Health — Counselor Approval Package
**Submit to:** Horizon Counselor (Supreme Legal Authority — see COUNSELOR_AUTHORITY_DOCTRINE.md)  
**From:** Founder, Horizon ABA Health  
**Date:** 2026-06-01  
**Status:** PRE-LAUNCH — Counselor approval required before public launch  
**Routing:** Horizon Legal Fortress → Counselor → Determinations → Founder co-sign (if Article III threshold)  
**Authority basis:** Counselor Authority Doctrine, Articles I–XI

---

## What This Document Is

This is a complete approval package submitted to **Horizon Counselor** for legal sign-off
on Horizon ABA Health's pre-launch compliance posture. It contains every artifact the
counselor needs to issue approval or flag remaining gaps — no external attorney engagement
required.

**Counselor workflow:**
1. Receive this package + 5 attached artifact files
2. Review against Horizon Legal Fortress standards
3. Founder completes the HIPAA Data Dictionary (Section 7 below)
4. Counselor issues written determination on each of the 13 questions in Section 2
5. Counselor signs off, flags conditions, or requires additional work
6. Founder signs risk acceptance for any approved-with-conditions items

---

## SECTION 1 — Product Summary

**Product:** Horizon ABA Health  
**Type:** SaaS subscription web application (+ possibly iOS/Android — to be confirmed)  
**Market:** Applied Behavior Analysis (ABA) therapy providers and possibly clients  
**Business model:** Recurring monthly/annual subscriptions with free trial  
**Payment processor:** Stripe (standard account currently — needs migration to Healthcare tier)  
**Hosting:** TBD — confirm BAA-eligible (AWS/GCP/Azure with BAA)  
**Repo (private):** `github.com/syoandy/horizon-ab-health`  
**Empire position:** Operates under Horizon Legal Fortress + FEEP doctrine

---

## SECTION 2 — Counselor Determinations Required

Counselor must issue written rulings on each of these. These are the binary,
launch-blocking questions:

### HIPAA Scope
1. **Does Horizon's data model constitute PHI under HIPAA?**
   - Based on the data dictionary in Section 7
   - Requires definitive yes/no
2. **Is Horizon a Covered Entity, Business Associate, or neither?**
3. **If PHI is involved, what is the minimum required compliance set?**
   - BAAs only?
   - Full HIPAA Security Rule?
   - HITECH breach notification?

### Subscription Law
4. **Post-FTC-Click-to-Cancel-vacatur (July 2024) — what federal standard applies to Horizon now?**
5. **Which state auto-renewal laws apply based on Horizon's intended customer geography?**
6. **Is an affirmative consent checkbox required at checkout, and in which states?**

### App Store / Platform Law
7. **If Horizon launches an iOS app selling subscriptions, does it require Apple In-App Purchase?**
8. **Does Horizon qualify for any Apple exemptions (reader app, B2B, healthcare)?**

### Minors / COPPA
9. **If ABA clients include minors, does Horizon's data collection trigger COPPA?**
10. **What parental consent mechanism is required?**

### State-Specific
11. **California — CCPA/CPRA applicability and required disclosures**
12. **New York — Shield Act applicability**
13. **Illinois — BIPA applicability if any biometric data is captured (video assessments?)**

---

## SECTION 3 — Pre-Built Artifacts Submitted

All artifacts are ready for counselor review:

| Artifact | What it covers | Counselor action |
|---|---|---|
| `SubscriptionDisclosure.tsx` | Auto-renewal disclosure per ROSCA + state law | Approve copy + placement |
| `CancellationFlow.tsx` | Online cancellation, no dark patterns | Confirm sufficient under state law |
| `trial_reminder.go` | T-7/T-3/T-1/T-0 email reminders | Approve email copy |
| `stripe_webhooks.go` | Subscription lifecycle + dispute handling | Technical only — no review needed |
| `dispute_dashboard.go` | Chargeback monitoring | Technical only — no review needed |
| `STRIPE_BAA_REQUEST_TEMPLATE.md` | Pre-drafted Stripe BAA request | Confirm BAA addendum terms acceptable |
| `EMAIL_BAA_REQUEST_TEMPLATE.md` | Pre-drafted email provider BAA request | Confirm terms acceptable |
| `TOS_SUBSCRIPTION_LANGUAGE.md` | ROSCA-compliant ToS clauses | Approve + integrate into full ToS |
| `PRIVACY_POLICY_HEALTH_DATA.md` | HIPAA-aware privacy disclosures | Approve + integrate into full Privacy Policy |
| `HIPAA_DATA_DICTIONARY_TEMPLATE.md` | Founder-completed PHI inventory | Use as basis for Section 2 determination |

---

## SECTION 4 — Counselor Deliverables Required

Counselor must produce:

- [ ] **Written PHI determination** for Horizon's data model
- [ ] **HIPAA compliance roadmap** if applicable
- [ ] **State law applicability matrix** (which states require what)
- [ ] **Approved Terms of Service** (full document — counselor integrates)
- [ ] **Approved Privacy Policy** (full document — counselor integrates)
- [ ] **Cookie/tracking policy** if applicable
- [ ] **Sign-off letter** stating launch readiness from a legal standpoint
- [ ] **List of remaining legal risks** the founder is accepting at launch

---

## SECTION 5 — Routing Through Horizon Legal Chain

```
Founder
   ↓ submits this package
Horizon Counselor — Supreme Legal Authority
   ↓ exercises Article I authority under COUNSELOR_AUTHORITY_DOCTRINE.md
Written determinations issued on all 13 binary questions
   ↓
[If Article III Founder Threshold triggered] → Founder co-sign required
[Otherwise] → Counselor approval is final
   ↓
Launch authorized
```

### External Counsel Escalation
Per Counselor Authority Doctrine Article V, Counselor must escalate ONLY when an Article V mandatory escalation applies:
- Litigation filed against Horizon
- Government investigation (FTC, HHS, state AG, etc.)
- Subpoena response
- Securities matters
- Patent matters (USPTO bar required)
- Trademark disputes
- Cross-border (GDPR/UK GDPR) disputes
- Criminal exposure

**Routine HIPAA review, ToS approval, BAA execution, and state law applicability remain entirely within Counselor's authority — no external counsel needed.**

Escalations are documented in the session log per Article II Section 2.3.

---

## SECTION 6 — Founder's Risk Acceptance Statement

For any condition-based approvals from Counselor:

```
Risk:        [description]
Likelihood:  [low / medium / high]
Impact:      [description]
Mitigation:  [what's in place]
Counselor sign-off date: ____________
Founder accepts:  _________________________ Date: __________
```

This protects the founder if a risk later materializes — shows informed decision-making
under Horizon Legal Fortress oversight.

---

## SECTION 7 — File Index

All artifacts live in `docs/horizon-aba/legal/`:

```
docs/horizon-aba/legal/
├── COUNSELOR_AUTHORITY_DOCTRINE.md     ← Articles I–XI defining Counselor power
├── COUNSELOR_APPROVAL_PACKAGE.md       ← this file
├── STRIPE_BAA_REQUEST_TEMPLATE.md
├── EMAIL_BAA_REQUEST_TEMPLATE.md
├── TOS_SUBSCRIPTION_LANGUAGE.md
├── PRIVACY_POLICY_HEALTH_DATA.md
└── HIPAA_DATA_DICTIONARY_TEMPLATE.md   ← founder fills in before submitting
```

Plus reference docs:
```
docs/horizon-aba/SUBSCRIPTION_COMPLIANCE_AUDIT.md
docs/horizon-aba/obsidian/Horizon ABA - HIPAA Requirements.md
```

---

## SECTION 8 — Submission Checklist

Before submitting to Counselor:

- [x] HIPAA Data Dictionary fully filled in — approved + signed by Founder 2026-06-03
- [x] All data fields Horizon collects are listed (30 fields; unknowns flagged for Counselor)
- [x] All third-party integrations are listed (Stripe, Postmark/email, AWS, planned clearinghouse)
- [x] All data flow paths are documented
- [x] Founder has reviewed each Section 2 question and is ready to receive a binary answer
- [ ] Founder understands Section 6 risk acceptance is binding
- [x] All 5 attached artifacts are current versions on branch `claude/create-feep-IU72S`

**Package status: READY FOR COUNSELOR REVIEW (2026-06-03)**
