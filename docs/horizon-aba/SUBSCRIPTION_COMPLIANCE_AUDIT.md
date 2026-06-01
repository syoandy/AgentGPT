# Horizon AB Health — Subscription & Billing Compliance Audit
**Branch:** claude/create-feep-IU72S  
**Date:** 2026-06-01  
**Auditor:** Claude (Opus)  
**Status:** FRAMEWORK COMPLETE — Code verification pending Horizon repo access

---

## AUDIT STATUS LEGEND

| Symbol | Meaning |
|---|---|
| ✅ PASS | Verified in code |
| ❌ FAIL | Missing or broken — fix required |
| ⚠️ PARTIAL | Exists but incomplete |
| 🔲 NOT IMPLEMENTED | Not built yet |
| 🔍 NEEDS CODE REVIEW | Framework defined — must verify in Horizon codebase |
| ⚖️ LEGAL REVIEW REQUIRED | Legal interpretation involved — qualified counsel required |

---

## PART 1 — AUTO-RENEWAL DISCLOSURE AUDIT

### Legal Basis
- **ROSCA** (Restore Online Shoppers' Confidence Act, 15 U.S.C. § 8403) — Federal, active
- **FTC Click-to-Cancel Rule** — Original rule vacated by 8th Circuit (July 2024). Replacement rulemaking pending. ⚖️ LEGAL REVIEW REQUIRED
- **California AB 2863** (effective 2022) — Strongest state auto-renewal law, applies to any subscriber in CA
- **New York GBL §527-a** — Active, requires clear disclosure + acknowledgment
- **Florida SB 1030** — Active for subscriptions over $10/month or $100/year

### Required Disclosure Elements (Before Purchase)
Every checkout screen where a subscription is purchased MUST show ALL of the following on the SAME screen as the purchase button:

| # | Required Element | Status |
|---|---|---|
| 1 | Recurring billing frequency (weekly / monthly / annual) | 🔍 NEEDS CODE REVIEW |
| 2 | Exact subscription amount charged | 🔍 NEEDS CODE REVIEW |
| 3 | Billing interval (e.g., "billed every 30 days") | 🔍 NEEDS CODE REVIEW |
| 4 | Renewal terms ("automatically renews until cancelled") | 🔍 NEEDS CODE REVIEW |
| 5 | How to cancel (exact steps or link) | 🔍 NEEDS CODE REVIEW |
| 6 | Trial conversion terms if trial offered | 🔍 NEEDS CODE REVIEW |
| 7 | Disclosure must NOT require opening another page | 🔍 NEEDS CODE REVIEW |

### Screens To Audit (When Horizon Code Is Accessible)
- [ ] Registration screen
- [ ] Plan selection screen
- [ ] Checkout screen
- [ ] Payment entry screen
- [ ] Confirmation/receipt screen
- [ ] Account settings / subscription management
- [ ] Any upsell or upgrade screen

### SubscriptionDisclosure Component — Required Implementation

```tsx
// components/SubscriptionDisclosure.tsx
interface SubscriptionDisclosureProps {
  billingAmount: string;         // e.g. "$29.99"
  billingFrequency: string;      // e.g. "monthly"
  billingInterval: string;       // e.g. "every 30 days"
  trialDays?: number;            // e.g. 14
  trialEndDate?: string;         // e.g. "June 15, 2026"
  cancelUrl: string;             // direct link to cancellation
}

// Required copy template:
// "After your [X]-day free trial, you will be charged [AMOUNT] [FREQUENCY]
// ([INTERVAL]), automatically renewing until cancelled.
// Cancel anytime at [cancelUrl] or in Account Settings."
```

**Placement rules:**
- Must appear ABOVE the purchase/confirm button
- Font size: minimum 12px, not grey-on-grey
- Must not be hidden behind a "See terms" link
- Must not require scroll to find

---

## PART 2 — FREE TRIAL COMPLIANCE AUDIT

### Legal Basis
- ROSCA §8403(3): Must clearly describe the terms of the offer at time of initial transaction
- CA AB 2863: Requires affirmative consent checkbox for trial-to-paid conversion
- ⚖️ LEGAL REVIEW REQUIRED — State-by-state consent requirements vary

### Trial Configuration Audit

| Item | Required | Status |
|---|---|---|
| Trial duration clearly stated at signup | Yes | 🔍 NEEDS CODE REVIEW |
| Exact conversion date shown | Yes | 🔍 NEEDS CODE REVIEW |
| Amount to be charged after trial shown | Yes | 🔍 NEEDS CODE REVIEW |
| Affirmative consent checkbox (not pre-checked) | Yes (CA/NY) | 🔍 NEEDS CODE REVIEW |
| Trial reminder emails exist | Yes | 🔍 NEEDS CODE REVIEW |
| In-app trial expiry notice exists | Recommended | 🔍 NEEDS CODE REVIEW |
| Cancellation before trial end honored | Yes — legally required | 🔍 NEEDS CODE REVIEW |

### Trial Reminder Architecture (Build if Missing)

```
T-7 days before trial ends:
  → Email: "Your free trial ends in 7 days"
  → Content: trial end date, charge amount, cancel link

T-3 days before trial ends:
  → Email: "3 days left on your Horizon free trial"
  → In-app banner: persistent, dismissible once

T-1 day before trial ends:
  → Email: "Your trial ends tomorrow — charge of $X on [date]"
  → In-app banner: non-dismissible until acknowledged

T-0 (day of conversion):
  → Email receipt immediately after charge
  → In-app: welcome to paid plan confirmation
```

**Required reminder content (every reminder):**
- Trial expiration date
- Conversion date
- Exact charge amount
- Step-by-step cancellation instructions
- Direct cancel link

---

## PART 3 — CANCELLATION FLOW AUDIT

### Legal Basis
- ROSCA §8403(3): Cancellation must be simple
- FTC Policy: Cancellation must be as easy as enrollment (pending rulemaking status ⚖️ LEGAL REVIEW REQUIRED)
- CA AB 2863: Cancel must be available online without contacting support
- No dark patterns allowed (FTC guidance, EU DSA Article 25 if EU users present)

### Click-Count Standard

| Action | Acceptable Max | Status |
|---|---|---|
| Subscribe (clicks from landing page to confirmed) | N/A — baseline | 🔍 NEEDS CODE REVIEW |
| Cancel (clicks from account settings to confirmed cancelled) | Must be ≤ subscribe clicks | 🔍 NEEDS CODE REVIEW |
| Find cancellation option in account settings | ≤ 2 clicks | 🔍 NEEDS CODE REVIEW |
| Cancellation confirmation received | Immediate | 🔍 NEEDS CODE REVIEW |

### Dark Pattern Checklist

| Pattern | Allowed? | Status |
|---|---|---|
| "Confirm cancellation" page with scary language | No | 🔍 NEEDS CODE REVIEW |
| Offering discount instead of processing cancellation | Allowed IF easy to skip | 🔍 NEEDS CODE REVIEW |
| Requiring support ticket to cancel | No — illegal in CA | 🔍 NEEDS CODE REVIEW |
| Pre-selecting "keep subscription" on cancel screen | No | 🔍 NEEDS CODE REVIEW |
| Hiding cancel button (low contrast, small text) | No | 🔍 NEEDS CODE REVIEW |
| Requiring phone call to cancel | No | 🔍 NEEDS CODE REVIEW |
| Multi-step "are you sure" loops (>1 confirmation) | No | 🔍 NEEDS CODE REVIEW |

### Required Cancellation Confirmation Content
After cancellation is confirmed, user must receive:
- [ ] On-screen confirmation message
- [ ] Email confirmation of cancellation
- [ ] Access end date (when paid period expires)
- [ ] Offer to resubscribe (optional, must not obscure confirmation)

---

## PART 4 — APPLE APP STORE COMPLIANCE

### Determination Required (When Code Is Accessible)

| Question | Answer | Evidence |
|---|---|---|
| Does Horizon have an iOS app? | Unknown | 🔍 NEEDS CODE REVIEW |
| Are subscriptions sold through iOS? | Unknown | 🔍 NEEDS CODE REVIEW |
| Are digital services delivered through iOS? | Unknown | 🔍 NEEDS CODE REVIEW |
| Is Apple In-App Purchase (IAP) used? | Unknown | 🔍 NEEDS CODE REVIEW |

### If iOS Subscriptions Exist — Apple Requirements

| Requirement | Apple Guideline | Status |
|---|---|---|
| Subscriptions use StoreKit / IAP | §3.1.1 | 🔍 NEEDS CODE REVIEW |
| Subscription management link shown in-app | §3.1.2 | 🔍 NEEDS CODE REVIEW |
| Restore Purchases button exists | §3.1.1 | 🔍 NEEDS CODE REVIEW |
| Free trial terms shown before purchase | §3.1.2 | 🔍 NEEDS CODE REVIEW |
| No external payment link shown to iOS users | §3.1.3 | 🔍 NEEDS CODE REVIEW |

> ⚖️ LEGAL REVIEW REQUIRED — Apple's DMA (EU) compliance opened limited external link exceptions in 2024. Applicability to US subscribers remains governed by §3.1.1. Do not implement external billing bypass without legal sign-off.

### Subscription Management Link (Required)
```
// Must deep-link to: itms-apps://apps.apple.com/account/subscriptions
// Label: "Manage Subscription" — must be visible in account settings
```

---

## PART 5 — GOOGLE PLAY COMPLIANCE

### Determination Required (When Code Is Accessible)

| Question | Answer | Evidence |
|---|---|---|
| Does Horizon have an Android app? | Unknown | 🔍 NEEDS CODE REVIEW |
| Are subscriptions sold through Android? | Unknown | 🔍 NEEDS CODE REVIEW |
| Is Google Play Billing Library used? | Unknown | 🔍 NEEDS CODE REVIEW |

### If Android Subscriptions Exist — Google Requirements

| Requirement | Google Policy | Status |
|---|---|---|
| Subscriptions use Google Play Billing | Payments policy §4 | 🔍 NEEDS CODE REVIEW |
| Subscription management link shown | Developer policy | 🔍 NEEDS CODE REVIEW |
| Restore/reconnect subscription flow exists | Required | 🔍 NEEDS CODE REVIEW |
| Price and terms disclosed before purchase | Required | 🔍 NEEDS CODE REVIEW |

### Subscription Management Link (Required)
```
// Must deep-link to: https://play.google.com/store/account/subscriptions
// Label: "Manage Subscription" — must be visible in account settings
```

---

## PART 6 — STRIPE FLOW AUDIT

### Stripe Billing Requirements

| Item | Status |
|---|---|
| Webhook handler exists for subscription events | 🔍 NEEDS CODE REVIEW |
| `customer.subscription.deleted` handled | 🔍 NEEDS CODE REVIEW |
| `invoice.payment_failed` handled | 🔍 NEEDS CODE REVIEW |
| `invoice.payment_succeeded` triggers receipt email | 🔍 NEEDS CODE REVIEW |
| `customer.subscription.trial_will_end` (3 days) handled | 🔍 NEEDS CODE REVIEW |
| Billing portal enabled in Stripe dashboard | 🔍 NEEDS CODE REVIEW |
| Customer portal link accessible from account settings | 🔍 NEEDS CODE REVIEW |
| Failed payment retry logic configured | 🔍 NEEDS CODE REVIEW |
| Dunning emails active (Stripe Smart Retries or custom) | 🔍 NEEDS CODE REVIEW |

### Critical Stripe Webhooks To Verify
```
customer.subscription.created
customer.subscription.updated
customer.subscription.deleted
customer.subscription.trial_will_end    ← triggers T-3 reminder
invoice.created
invoice.finalized
invoice.payment_succeeded               ← triggers receipt
invoice.payment_failed                  ← triggers dunning flow
customer.subscription.paused
charge.dispute.created                  ← triggers dispute alert
```

---

## PART 7 — DISPUTE PREVENTION & CHARGEBACK MONITORING

### Chargeback Thresholds (Visa/Mastercard)
- **Visa Dispute Monitoring Program (VDMP):** triggered at >0.65% dispute rate
- **Visa Fraud Monitoring Program (VFMP):** triggered at >0.65% fraud rate
- **Mastercard Excessive Chargeback Program:** triggered at >1.0% chargeback rate
- Above 1.8% (Visa) or 1.5% (MC) = excessive, potential termination

### Pre-Renewal Prevention Checklist
Before every renewal charge:
- [ ] Reminder email sent (T-7, T-3, T-1)
- [ ] In-app renewal notice shown
- [ ] Cancel path accessible and prominent
- [ ] Billing amount matches what was disclosed at signup

### Post-Renewal Requirements
After every charge:
- [ ] Receipt email sent within 1 hour
- [ ] Invoice accessible in account
- [ ] Subscription status visible in account settings

### Dispute Monitoring Dashboard — Required Fields

```
Metric                    | Threshold  | Alert Level
--------------------------|------------|-------------
Chargeback count (30d)    | >5         | Warning
Chargeback rate           | >0.65%     | Critical
Refund rate (30d)         | >5%        | Warning
Failed payments (30d)     | Track      | Info
Cancellations (30d)       | Track      | Info
Dispute reason breakdown  | Track      | Info
```

---

## PART 8 — TERMS OF SERVICE & PRIVACY AUDIT

| Item | Status |
|---|---|
| ToS includes subscription terms | 🔍 NEEDS CODE REVIEW |
| ToS includes auto-renewal language | 🔍 NEEDS CODE REVIEW |
| ToS includes refund policy | 🔍 NEEDS CODE REVIEW |
| Privacy Policy covers payment data handling | 🔍 NEEDS CODE REVIEW |
| Privacy Policy covers health data (ABA therapy context) | ⚖️ LEGAL REVIEW REQUIRED |
| HIPAA Business Associate Agreement (BAA) in place with Stripe | ⚖️ LEGAL REVIEW REQUIRED |
| HIPAA BAA in place with email provider | ⚖️ LEGAL REVIEW REQUIRED |
| COPPA compliance (if minors are clients) | ⚖️ LEGAL REVIEW REQUIRED |

> ⚖️ LEGAL REVIEW REQUIRED — Horizon serves ABA therapy clients. ABA therapy involves PHI (Protected Health Information) under HIPAA. Even if Horizon does not store clinical notes, intake data, session data, or client demographics may constitute PHI. Full HIPAA gap analysis required before launch. Standard Stripe account does NOT include a BAA — Stripe offers a BAA under their healthcare tier.

---

## GAP SUMMARY

| Category | Status | Priority |
|---|---|---|
| SubscriptionDisclosure component | 🔲 NOT IMPLEMENTED (unverified) | P0 — blocks launch |
| Trial reminder emails | 🔲 NOT IMPLEMENTED (unverified) | P0 — blocks launch |
| Cancellation confirmation email | 🔲 NOT IMPLEMENTED (unverified) | P0 — blocks launch |
| Stripe webhook: trial_will_end | 🔍 NEEDS CODE REVIEW | P0 |
| Stripe webhook: dispute.created | 🔍 NEEDS CODE REVIEW | P0 |
| HIPAA BAA with Stripe | ⚖️ LEGAL REVIEW REQUIRED | P0 |
| HIPAA BAA with email provider | ⚖️ LEGAL REVIEW REQUIRED | P0 |
| Apple IAP determination | 🔍 NEEDS CODE REVIEW | P1 |
| Google Play billing determination | 🔍 NEEDS CODE REVIEW | P1 |
| Chargeback monitoring dashboard | 🔲 NOT IMPLEMENTED | P1 |
| CA/NY affirmative consent checkbox | 🔍 NEEDS CODE REVIEW | P1 |
| Dispute monitoring alerts | 🔲 NOT IMPLEMENTED | P2 |

---

## RECOMMENDED IMPLEMENTATION ORDER

1. **HIPAA legal review** — Do this first. Everything else depends on it.
2. **SubscriptionDisclosure component** — Must exist before any paid user can subscribe.
3. **Trial reminder service** (T-7, T-3, T-1 emails + in-app)
4. **Stripe webhook audit** — Verify all critical events handled.
5. **Cancellation flow audit + confirmation emails**
6. **App Store / Google Play billing determination**
7. **Chargeback monitoring dashboard**
8. **Dispute alert system**

---

## HANDOFF RECORD

**Systems updated:**
- ✅ `docs/horizon-aba/SUBSCRIPTION_COMPLIANCE_AUDIT.md` — this file
- ⛔ Obsidian — unavailable from this sandbox
- ⛔ Graphify — unavailable from this sandbox
- ⛔ NotebookLM — unavailable from this sandbox

**Remaining blockers:**
- Horizon codebase (`syoandy/horizon-ab-health`) not accessible from this session
- All 🔍 NEEDS CODE REVIEW items remain open until access is granted

**Next milestone:**
- Code-level audit of Horizon billing, checkout, Stripe webhooks, and cancellation flow
- Requires session access to `syoandy/horizon-ab-health`

---

*All legal interpretations marked ⚖️ LEGAL REVIEW REQUIRED. Do not claim legal compliance without review by qualified counsel.*
