# Wiring Completion Checklist
**Use this to verify the new Claude session actually finished the job.**

---

## Pre-flight (before any code changes)
- [ ] Repo audit complete — entry point, router, existing Stripe code, frontend root all identified
- [ ] Branch `claude/wire-compliance-components` created off `master`
- [ ] DB migration plan reviewed (use `db_migration.sql` or adapt to existing schema)

## Component 1 — SubscriptionDisclosure
- [ ] File copied into `web/components/billing/` (or Horizon equivalent)
- [ ] Rendered above every "Subscribe" / "Start Trial" / "Confirm Purchase" button
- [ ] Props populated from real subscription data
- [ ] Mobile-responsive — no scroll required to see disclosure
- [ ] Trial fields shown when trial offered

## Component 2 — CancellationFlow
- [ ] Route `/account/cancel` exists
- [ ] Link from account settings — ≤2 clicks to reach
- [ ] `onCancel` calls backend cancellation API
- [ ] Confirmation email triggered on cancellation
- [ ] No dark patterns (no scary copy, no pre-selected "keep", no multi-step loops)
- [ ] No support ticket required to cancel
- [ ] California subscribers can cancel online without contacting support

## Component 3 — TrialReminderService
- [ ] Service deployed
- [ ] Scheduled to run daily at 00:00 UTC
- [ ] `EmailSender` interface implemented with BAA-signed email provider
- [ ] `getTrials` queries return all active trials with `TrialEndDate` set
- [ ] T-7 email sent and verified in test
- [ ] T-3 email sent and verified in test
- [ ] T-1 email sent and verified in test
- [ ] T-0 conversion email sent and verified in test
- [ ] Each email contains: trial end date, charge amount, cancel link

## Component 4 — StripeWebhookHandler
- [ ] Endpoint `POST /api/webhooks/stripe` mounted
- [ ] Webhook signing secret loaded from env
- [ ] Stripe Dashboard webhook configured with all 8 event types
- [ ] Test event delivers successfully (Stripe test mode)
- [ ] Idempotency check via `stripe_webhook_events` table
- [ ] Receipt email sent on `invoice.payment_succeeded`
- [ ] Dunning flow triggered on `invoice.payment_failed`
- [ ] Dispute record written + ops alert on `charge.dispute.created`

## Component 5 — DisputeDashboard
- [ ] Admin route `/admin/disputes` mounted
- [ ] Admin auth required
- [ ] Metrics display correctly (charges, disputes, refunds, rate)
- [ ] Alerts fire at 0.65% (VDMP) and 1.0% (ECP)
- [ ] Recent disputes table populated
- [ ] Daily alert email sent when alerts present

## Audit Closure
- [ ] All `🔍 NEEDS CODE REVIEW` items in `SUBSCRIPTION_COMPLIANCE_AUDIT.md` replaced
- [ ] Each item has `✅ PASS` / `❌ FAIL` / `⚠️ PARTIAL` / `🔲 NOT IMPLEMENTED` with file:line citation
- [ ] Audit summary updated with new completion percentage

## Tests
- [ ] Unit tests for trial reminder timing
- [ ] Unit tests for Stripe webhook event routing
- [ ] Integration test for cancellation flow
- [ ] CI passing on the branch

## Documentation
- [ ] `SESSION_LOG.md` updated in horizon-ab-health repo
- [ ] Component locations documented (where each component now lives)
- [ ] Env vars documented (STRIPE_WEBHOOK_SECRET, etc.)

## Handoff (Mandatory Rule 6)
- [ ] Obsidian: ✅ synced or ⛔ BLOCKED with documented reason
- [ ] Graphify: ✅ updated or ⛔ BLOCKED with documented reason
- [ ] NotebookLM: ✅ updated or ⛔ BLOCKED with documented reason
- [ ] Verification evidence attached
- [ ] Files changed listed
- [ ] Remaining gaps listed
- [ ] Next milestone set

## Counselor Approval Required Before Merge
- [ ] ToS clauses approved (now visible at checkout)
- [ ] Privacy Policy section approved (HIPAA disclosures)
- [ ] BAA confirmed signed with Stripe (Healthcare tier)
- [ ] BAA confirmed signed with email provider

## Pull Request
- [ ] PR opened against `master`
- [ ] PR body includes audit summary
- [ ] PR body includes counselor review checklist
- [ ] CI green
- [ ] Counselor tagged for review
