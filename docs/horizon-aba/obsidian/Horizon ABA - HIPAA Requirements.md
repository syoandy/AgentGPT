---
tags: [horizon-aba, hipaa, legal, compliance, P0, counselor-approval-required]
created: 2026-06-01
status: COUNSELOR APPROVAL REQUIRED
priority: P0 — blocks launch
routing: Founder → Horizon Counselor → Approval
---

# Horizon ABA — HIPAA Requirements

## Why HIPAA Applies
Horizon ABA serves Applied Behavior Analysis therapy clients.
ABA therapy involves Protected Health Information (PHI) under HIPAA:
- Client names + demographics
- Session scheduling data
- Progress/assessment data
- Billing data tied to treatment

**Even if Horizon does not store clinical notes**, intake and scheduling data likely constitutes PHI.

> ⚠️ COUNSELOR APPROVAL REQUIRED — Horizon Counselor must determine PHI scope before launch under Horizon Legal Fortress.

## Required Actions (All P0)

### 1. Stripe Healthcare BAA
- Standard Stripe account does NOT include a Business Associate Agreement
- Stripe offers BAA under their **healthcare tier**
- Without BAA, using Stripe to process payments for PHI-related services = HIPAA violation
- **Action:** Contact Stripe healthcare team → execute BAA before first paid user

### 2. Email Provider BAA
- Any email provider sending PHI-adjacent data (trial reminders, receipts with names/plan info) needs a BAA
- Compliant providers: Google Workspace (BAA available), SendGrid (BAA available), Postmark (BAA available), AWS SES (BAA available)
- **Action:** Execute BAA with chosen email provider before sending any user emails

### 3. HIPAA-Compliant Hosting
- If PHI is stored, hosting must be HIPAA-eligible
- AWS, GCP, Azure all offer BAA — standard tiers apply
- **Action:** Confirm hosting BAA is in place

### 4. COPPA
- If any Horizon clients are minors (common in ABA therapy), COPPA applies
- **Action:** Submit to Horizon Counselor for review of data collection from or about minors

## Routing Chain
```
Founder
  ↓ submits COUNSELOR_APPROVAL_PACKAGE.md + 5 artifacts
Horizon Counselor
  ↓ reviews under Horizon Legal Fortress
Written determinations on 13 binary questions
  ↓
Founder signs off / accepts conditions
  ↓
Launch authorized
```
No external attorney unless Counselor escalates.

## Breach Notification Rule
If PHI is exposed:
- Notify affected individuals within 60 days
- Notify HHS within 60 days
- If >500 individuals in a state: notify prominent media

## Related Notes
- [[Horizon ABA - Compliance Audit]]
- [[Horizon ABA - App Store Compliance]]
