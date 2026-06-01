---
tags: [horizon-aba, compliance, billing, subscription, audit]
created: 2026-06-01
updated: 2026-06-01
status: in-progress
branch: claude/create-feep-IU72S
---

# Horizon ABA — Subscription & Billing Compliance Audit

## Status
| Area | Status |
|---|---|
| Auto-Renewal Disclosure | ✅ Component built — wire into Horizon |
| Trial Reminder System | ✅ Service built — wire into Horizon |
| Cancellation Flow | ✅ Component built — wire into Horizon |
| Stripe Webhooks | ✅ Handler built — wire into Horizon |
| Dispute Dashboard | ✅ Built — wire into Horizon |
| HIPAA BAA (Stripe) | ⚠️ LEGAL REVIEW REQUIRED — P0 |
| HIPAA BAA (Email) | ⚠️ LEGAL REVIEW REQUIRED — P0 |
| Apple IAP | 🔍 Needs iOS code review |
| Google Play Billing | 🔍 Needs Android code review |
| Code-level verification | 🔍 Blocked — needs horizon-ab-health access |

## Key Legal Bases
- ROSCA (15 U.S.C. § 8403) — federal, active
- CA AB 2863 — strongest state auto-renewal law
- NY GBL §527-a — active
- Apple App Store §3.1.2
- Google Play Subscriptions policy
- HIPAA — ABA therapy = PHI regardless of data stored

## Components Built
- `SubscriptionDisclosure.tsx` — required disclosure above every purchase button
- `trial_reminder.go` — T-7/T-3/T-1/T-0 email reminders
- `stripe_webhooks.go` — full lifecycle + dispute event handling
- `CancellationFlow.tsx` — clean cancel UI, no dark patterns
- `dispute_dashboard.go` — chargeback monitoring with auto-alerts

## Where Files Live
All in `syoandy/agentgpt` repo, branch `claude/create-feep-IU72S`:
```
docs/horizon-aba/
  components/
    SubscriptionDisclosure.tsx
    CancellationFlow.tsx
  services/
    trial_reminder.go
  webhooks/
    stripe_webhooks.go
  dashboard/
    dispute_dashboard.go
```

## Decisions
- All Horizon docs stored in `syoandy/agentgpt` — no scattered systems
- HIPAA flagged P0 — blocks launch regardless of other readiness
- FTC Click-to-Cancel rule vacated July 2024 — state laws still apply

## Next Actions
- [ ] Wire components into `syoandy/horizon-ab-health`
- [ ] HIPAA legal review
- [ ] Apple/Google billing determination
- [ ] Code-level audit once Horizon repo is accessible

## Related Notes
- [[Horizon ABA - Session Log]]
- [[Horizon ABA - HIPAA Requirements]]
- [[Horizon ABA - App Store Compliance]]
