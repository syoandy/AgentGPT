# Horizon AB Health — Component Integration Runbook
**For:** New Claude session working in `syoandy/horizon-ab-health`  
**Branch to create:** `claude/wire-compliance-components`  
**Base branch:** `master`

---

## Step 0 — Verify Repo Structure

Before wiring anything, map the Horizon codebase:

```bash
# Find the entry point
find . -name "main.go" -not -path "./vendor/*"

# Find the router setup
grep -r "router\|http.HandleFunc\|gin.Default\|chi.NewRouter\|fiber.New" --include="*.go" | head -20

# Find existing Stripe code
grep -r "stripe.com/stripe-go\|stripe-webhook\|StripeKey" --include="*.go" | head -20

# Find the frontend root
find . -name "package.json" -not -path "*/node_modules/*"

# Find existing checkout / subscription / cancellation screens
find . -type f \( -name "*checkout*" -o -name "*subscribe*" -o -name "*cancel*" -o -name "*billing*" \) -not -path "*/node_modules/*"
```

Document findings in `SESSION_LOG.md` before proceeding.

---

## Step 1 — Wire `SubscriptionDisclosure.tsx`

### What it does
React component that displays ROSCA/CA AB 2863 compliant disclosure above any purchase button.

### Where to put it
- **Path:** `web/components/billing/SubscriptionDisclosure.tsx` (adjust to Horizon convention)
- **Used by:** Every screen with a purchase/subscribe button

### How to wire it
1. Copy `SubscriptionDisclosure.tsx` from the agentgpt repo into the determined path
2. Find every "Subscribe", "Start Trial", "Confirm Purchase" button
3. Render the component **directly above** that button, NOT in a modal or expandable section
4. Pass props from your subscription config:
   ```tsx
   <SubscriptionDisclosure
     billingAmount={plan.formattedPrice}
     billingFrequency={plan.interval}
     trialDays={plan.trialDays}
     trialEndDate={formatDate(addDays(now, plan.trialDays))}
     cancelPath="/account/subscription"
   />
   ```

### Acceptance criteria
- [ ] Component imported into every checkout screen
- [ ] Disclosure visible above purchase button without scroll
- [ ] All required fields populated (amount, frequency, cancel path)
- [ ] If trial offered, trial fields populated

---

## Step 2 — Wire `CancellationFlow.tsx`

### What it does
Self-contained cancellation UI — no dark patterns, ≤2 clicks, sends confirmation.

### Where to put it
- **Path:** `web/pages/account/cancel.tsx` or `web/components/billing/CancellationFlow.tsx`
- **Route:** `/account/cancel`
- **Linked from:** Account settings page

### How to wire it
1. Copy `CancellationFlow.tsx` into the determined path
2. Create the `/account/cancel` route if it doesn't exist
3. Implement the `onCancel` prop — call your backend's cancellation API:
   ```tsx
   <CancellationFlow
     planName={subscription.planName}
     billingAmount={subscription.formattedPrice}
     accessEndDate={subscription.currentPeriodEndFormatted}
     onCancel={async () => {
       await fetch('/api/subscription/cancel', { method: 'POST' })
     }}
   />
   ```
4. In account settings, add a "Cancel Subscription" link that goes to `/account/cancel`
5. Ensure cancellation backend triggers a confirmation email

### Acceptance criteria
- [ ] Route `/account/cancel` exists and is reachable from account settings in ≤2 clicks
- [ ] Cancellation completes in single confirmation (no multi-step "are you sure" loops)
- [ ] Confirmation email triggered on cancellation
- [ ] No support ticket required to cancel
- [ ] Discount-offer step is optional and skippable

---

## Step 3 — Wire `trial_reminder.go`

### What it does
Sends T-7, T-3, T-1, T-0 email reminders before trial conversion.

### Where to put it
- **Path:** `internal/billing/trial_reminder.go` or `pkg/trial/reminder.go`

### Database requirement
You need a way to query active trials. Either:
- Add a `trials` table (see `db_migration.sql`)
- Or query Stripe directly via the `subscription.trial_end` field

### How to wire it
1. Copy `trial_reminder.go` into the determined path
2. Implement the `EmailSender` interface using your email provider
3. Implement the `getTrials` function — must return all trials with `TrialEndDate` set
4. Wire to scheduler — pick one:
   - **Cron (preferred for simple):** Run `Run(ctx)` once per day at 00:00 UTC
   - **Temporal:** Create a workflow that calls `Run` daily
   - **AWS EventBridge:** Schedule daily Lambda invocation

Example with cron (using github.com/robfig/cron):
```go
c := cron.New()
c.AddFunc("0 0 * * *", func() {
    ctx := context.Background()
    if err := reminderService.Run(ctx); err != nil {
        log.Printf("trial reminder failed: %v", err)
    }
})
c.Start()
```

### Acceptance criteria
- [ ] Service runs once per day
- [ ] T-7, T-3, T-1, T-0 emails sent at correct intervals
- [ ] Each email contains: trial end date, charge amount, cancel link
- [ ] Email provider has BAA executed (see EMAIL_BAA_REQUEST_TEMPLATE.md)

---

## Step 4 — Wire `stripe_webhooks.go`

### What it does
Handles all critical Stripe subscription events including disputes.

### Where to put it
- **Path:** `internal/billing/stripe_webhooks.go`
- **Mounted at:** `POST /api/webhooks/stripe` (or wherever existing webhook lives)

### How to wire it
1. Copy `stripe_webhooks.go` into the determined path
2. Implement the `SubscriptionService` interface:
   - `OnSubscriptionCreated` — log new subscription, send welcome email
   - `OnSubscriptionUpdated` — update local subscription record
   - `OnSubscriptionCancelled` — mark account as cancelled, schedule access end
   - `OnSubscriptionPaused` — flag account
   - `OnTrialWillEnd` — trigger T-3 reminder (alternative to cron-based)
   - `OnPaymentSucceeded` — send receipt email using `BuildReceiptEmail`
   - `OnPaymentFailed` — start dunning flow (Stripe Smart Retries or custom)
   - `OnDisputeCreated` — write to `DisputeRecord` table + alert ops
3. Mount in router:
   ```go
   handler := stripewebhooks.NewHandler(os.Getenv("STRIPE_WEBHOOK_SECRET"), service)
   router.HandleFunc("/api/webhooks/stripe", handler.ServeHTTP)
   ```
4. In Stripe Dashboard → Webhooks → add endpoint with these events:
   - customer.subscription.created
   - customer.subscription.updated
   - customer.subscription.deleted
   - customer.subscription.paused
   - customer.subscription.trial_will_end
   - invoice.payment_succeeded
   - invoice.payment_failed
   - charge.dispute.created
5. Copy the signing secret into `STRIPE_WEBHOOK_SECRET` env var

### Acceptance criteria
- [ ] Webhook endpoint responds 200 to Stripe test events
- [ ] All 8 event types route to correct handler
- [ ] Signature verification rejects invalid payloads
- [ ] Dispute events trigger ops alert
- [ ] Receipt emails sent within 1 hour of `invoice.payment_succeeded`

---

## Step 5 — Wire `dispute_dashboard.go`

### What it does
Tracks chargebacks against Visa VDMP + Mastercard ECP thresholds with auto-alerts.

### Where to put it
- **Path:** `internal/admin/dispute_dashboard.go`
- **Mounted at:** Admin panel — `/admin/disputes` route

### How to wire it
1. Copy `dispute_dashboard.go` into the determined path
2. Implement the `MetricsRepository` interface against your DB
3. Create admin route:
   ```go
   router.HandleFunc("/admin/disputes", func(w http.ResponseWriter, r *http.Request) {
       // Require admin auth
       metrics, err := dashboardService.GetMetrics(ctx, disputedashboard.Last30Days())
       if err != nil { http.Error(w, err.Error(), 500); return }
       json.NewEncoder(w).Encode(metrics)
   })
   ```
4. Build a simple admin UI page showing:
   - Dispute count + rate (with VDMP/ECP threshold lines)
   - Refund rate
   - Failed payment count
   - List of recent disputes from `ListDisputes`
   - Active alerts from `metrics.Alerts`
5. Set up daily alert email if `metrics.Alerts` is non-empty

### Acceptance criteria
- [ ] Admin can view dispute metrics
- [ ] Alerts fire at 0.65% (Visa VDMP) and 1.0% (MC ECP)
- [ ] Recent disputes show with reason + amount + status
- [ ] Daily alert email sent to ops when alerts present

---

## Step 6 — Close The Audit

For each item in `SUBSCRIPTION_COMPLIANCE_AUDIT.md` currently marked `🔍 NEEDS CODE REVIEW`:

1. Find the corresponding code in Horizon
2. Verify it against the requirement
3. Mark as `✅ PASS`, `❌ FAIL`, `⚠️ PARTIAL`, or `🔲 NOT IMPLEMENTED`
4. Add file:line citations as evidence

Example:
```
| Webhook handler exists for subscription events | ✅ PASS — internal/billing/stripe_webhooks.go:25 |
```

---

## Step 7 — Run Tests

Add tests for each component if Horizon has a test framework:

```bash
go test ./internal/billing/...
go test ./internal/admin/...
npm test -- --testPathPattern=billing
```

If tests don't exist, write at minimum:
- `trial_reminder_test.go` — verifies T-7/T-3/T-1/T-0 trigger timing
- `stripe_webhooks_test.go` — verifies each event routes correctly
- `cancellation_flow_test.tsx` — verifies cancel completes + email sent

---

## Step 8 — Handoff (Rule 6)

Before declaring done, update `SESSION_LOG.md`:

```
## Session: Wiring Compliance Components
Date: [YYYY-MM-DD]

### Work Completed
- [list of files added/modified]

### Audit Status After Wiring
- [list each previously NEEDS CODE REVIEW item with new status]

### Handoff Status (Rule 6)
- Obsidian: ✅ synced (or ⛔ BLOCKED — reason)
- Graphify: ✅ updated (or ⛔ BLOCKED — reason)
- NotebookLM: ✅ updated (or ⛔ BLOCKED — reason)
- Verification: tests passing + Stripe test webhook delivered
- Files changed: [list]
- Remaining gaps: [list]
- Next milestone: Counselor approval + BAAs signed

### Counselor Review Required Before Merge
- ToS clauses now display in checkout — Counselor must approve copy
- Privacy Policy updated — Counselor must approve
```

---

## Step 9 — Open PR

```bash
git push -u origin claude/wire-compliance-components
gh pr create --title "Wire compliance components (per docs/horizon-aba audit)" --body "$(cat <<'EOF'
## Summary
Wires 5 compliance components from prior audit:
- SubscriptionDisclosure (ROSCA / CA AB 2863)
- CancellationFlow (no dark patterns)
- TrialReminderService (T-7/T-3/T-1/T-0)
- StripeWebhookHandler (8 events including disputes)
- DisputeDashboard (Visa VDMP + MC ECP alerts)

## Audit Status
[paste updated audit summary]

## Counselor Review Required
- [ ] Approve ToS subscription clauses (now displayed at checkout)
- [ ] Approve Privacy Policy health-data section

## Test plan
- [ ] Trial reminder runs at T-7/T-3/T-1/T-0
- [ ] Stripe test webhooks deliver successfully
- [ ] Cancellation completes in single flow
- [ ] Dispute alerts fire at correct thresholds
EOF
)"
```

---

## When To Ask Founder For Help

- If Horizon's existing checkout / billing code looks materially different from these components → ask before refactoring
- If Stripe account is not on Healthcare tier yet → flag and wait for BAA execution
- If email provider has no BAA → flag and wait
- If existing ToS / Privacy Policy is on a CMS you cannot edit → request CMS access
- If Apple/Google IAP determination cannot be made from code alone → ask Founder
