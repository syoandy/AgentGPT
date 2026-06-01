# Horizon ABA Health — Attorney Briefing Packet
**For:** Healthcare-SaaS legal counsel review  
**From:** Founder, Horizon ABA Health  
**Date:** 2026-06-01  
**Status:** PRE-LAUNCH — review required before public launch  
**Estimated review hours:** 4–8 hours (initial review + BAA execution oversight)

---

## What This Document Is
This is a pre-built briefing packet to hand to your healthcare-SaaS attorney. It contains everything they need to give you a focused, fixed-fee review instead of an open-ended discovery engagement.

**How to use it:**
1. Find a healthcare-SaaS attorney (recommendations at bottom)
2. Email them this document + the 4 attached files
3. Request a fixed-fee scope: "Review pre-launch HIPAA and subscription compliance for SaaS"
4. Expect 1–2 week turnaround

---

## SECTION 1 — Product Summary

**Product:** Horizon ABA Health  
**Type:** SaaS subscription web application (+ possibly iOS/Android — confirm with founder)  
**Market:** Applied Behavior Analysis (ABA) therapy providers and possibly clients  
**Business model:** Recurring monthly/annual subscriptions with free trial  
**Payment processor:** Stripe (standard account currently — needs migration to Healthcare tier)  
**Hosting:** TBD — confirm BAA-eligible (AWS/GCP/Azure with BAA)  
**Repo (private):** `github.com/syoandy/horizon-ab-health`  

---

## SECTION 2 — Specific Questions for Counsel

These are the binary, action-blocking questions. Please answer in writing:

### HIPAA Scope
1. **Does Horizon's data model constitute PHI?**
   - Founder needs definitive yes/no based on actual data fields collected
   - Data fields TBD — founder to provide data dictionary
2. **Is Horizon a Covered Entity, Business Associate, or neither?**
3. **If PHI is involved, what is the minimum required compliance set?**
   - BAAs only?
   - Full HIPAA Security Rule?
   - HITECH breach notification?

### Subscription Law
4. **Post-FTC-Click-to-Cancel-vacatur (July 2024) — what is the current federal standard?**
5. **Which state auto-renewal laws apply to Horizon based on intended customer geography?**
6. **Does Horizon need an affirmative consent checkbox at checkout, and in which states?**

### App Store / Platform Law
7. **If Horizon launches an iOS app selling subscriptions, does it require Apple In-App Purchase?**
8. **Are there any exceptions Horizon qualifies for (reader apps, B2B, healthcare)?**

### Minors / COPPA
9. **If ABA therapy clients include minors, does Horizon's data collection trigger COPPA?**
10. **What parental consent mechanisms are required?**

### State-Specific
11. **California — CCPA/CPRA applicability and required disclosures**
12. **New York — Shield Act applicability**
13. **Illinois — BIPA applicability if any biometric data is captured (video assessments?)**

---

## SECTION 3 — What's Already Built (Pre-Compliance)

Pre-built and ready for legal review:

| Asset | What it covers | Counsel action |
|---|---|---|
| `SubscriptionDisclosure.tsx` | Auto-renewal disclosure required by ROSCA/CA AB 2863 | Review copy + placement |
| `CancellationFlow.tsx` | Online cancellation, no dark patterns | Confirm sufficient under state law |
| `trial_reminder.go` | T-7/T-3/T-1/T-0 email reminders | Review email copy |
| `stripe_webhooks.go` | Subscription lifecycle + dispute handling | No legal review needed |
| `dispute_dashboard.go` | Chargeback monitoring | No legal review needed |
| `STRIPE_BAA_REQUEST_TEMPLATE.md` | Pre-drafted Stripe BAA request | Counsel to confirm BAA addendum terms |
| `EMAIL_BAA_REQUEST_TEMPLATE.md` | Pre-drafted email provider BAA request | Counsel to confirm terms |
| `TOS_SUBSCRIPTION_LANGUAGE.md` | ROSCA-compliant ToS clauses | Counsel to integrate into full ToS |
| `PRIVACY_POLICY_HEALTH_DATA.md` | HIPAA-aware privacy disclosures | Counsel to integrate into full Privacy Policy |

---

## SECTION 4 — Counsel Deliverables Requested

Please provide:

- [ ] **Written PHI determination** for Horizon's data model
- [ ] **HIPAA compliance roadmap** if applicable
- [ ] **State law applicability matrix** (which states require what)
- [ ] **Reviewed Terms of Service** (full document, not just subscription clauses)
- [ ] **Reviewed Privacy Policy** (full document)
- [ ] **Cookie/tracking policy** if applicable
- [ ] **Sign-off letter** stating launch readiness from a legal standpoint
- [ ] **List of remaining legal risks** the founder is accepting at launch

---

## SECTION 5 — Engagement Recommendations

**Type of counsel needed:**
- Healthcare-SaaS attorney (NOT a general business attorney)
- Familiar with HIPAA, HITECH, state privacy law, and FTC consumer protection
- Bonus: prior ABA therapy industry experience

**How to find one:**
- Search "healthcare SaaS attorney" + your state on Avvo or Martindale-Hubbell
- Ask in r/healthIT or r/medlaw subreddits
- LinkedIn search: "HIPAA attorney" filtered to law firm employees
- State bar referral service (free)

**Estimated cost ranges (US):**
- Initial review: $1,500–$5,000 fixed fee for a defined scope like this
- Ongoing counsel (post-launch): $300–$600/hour as needed
- BAA negotiation: typically included in initial fee

**Red flags to avoid:**
- Attorney quoting hourly with no cap on initial review
- Attorney who doesn't specifically mention HIPAA in their practice areas
- Attorney unfamiliar with SaaS billing law (ROSCA, state auto-renewal)

---

## SECTION 6 — Founder's Risk Acceptance Statement

If counsel identifies risks the founder chooses to accept, document them here:

```
Risk:        [description]
Likelihood:  [low / medium / high]
Impact:      [description]
Mitigation:  [what's in place]
Accepted by: [founder signature + date]
```

This protects the founder if a risk later materializes — shows informed decision-making, not negligence.

---

## SECTION 7 — File Index

Attach these to counsel email:

```
docs/horizon-aba/legal/
├── ATTORNEY_BRIEFING_PACKET.md         ← this file
├── STRIPE_BAA_REQUEST_TEMPLATE.md
├── EMAIL_BAA_REQUEST_TEMPLATE.md
├── TOS_SUBSCRIPTION_LANGUAGE.md
├── PRIVACY_POLICY_HEALTH_DATA.md
└── HIPAA_DATA_DICTIONARY_TEMPLATE.md   ← founder fills in before sending
```

Plus reference docs:
```
docs/horizon-aba/SUBSCRIPTION_COMPLIANCE_AUDIT.md
docs/horizon-aba/obsidian/Horizon ABA - HIPAA Requirements.md
```
