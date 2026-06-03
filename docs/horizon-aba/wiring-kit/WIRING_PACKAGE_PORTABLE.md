# Horizon AB Health — Compliance Wiring: Self-Contained Runbook
**For:** A Claude session working directly in `syoandy/horizon-ab-health`  
**Branch to create:** `claude/wire-compliance-components`  
**Base branch:** `master`  
**Zero cross-repo dependencies** — all code and instructions are inline below.  
**Created:** 2026-06-03 by prior Claude session (AgentGPT / docs/horizon-aba)

---

## What This Package Contains

| # | Component | Language | Purpose |
|---|-----------|----------|---------|
| 1 | `SubscriptionDisclosure.tsx` | TypeScript/React | ROSCA / CA AB 2863 / NY GBL §527-a disclosure above purchase buttons |
| 2 | `CancellationFlow.tsx` | TypeScript/React | No-dark-pattern cancellation UI, ≤2 clicks, online-only |
| 3 | `trial_reminder.go` | Go | T-7 / T-3 / T-1 / T-0 trial conversion email service |
| 4 | `stripe_webhooks.go` | Go | Stripe subscription/payment/dispute webhook handler (8 events) |
| 5 | `dispute_dashboard.go` | Go | Visa VDMP + Mastercard ECP chargeback monitoring with auto-alerts |
| 6 | `db_migration.sql` | SQL (PostgreSQL) | Tables: trials, disputes, stripe_webhook_events, cancellation_log |

---

## STEP 0 — Orientation (do this before touching any code)

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

Document your findings before proceeding. Note the actual directory paths for:
- Go package root (e.g., `internal/`, `pkg/`, `app/`)
- Frontend root (e.g., `web/`, `frontend/`, `client/`)
- Existing webhook handler location (if any)

Then create the branch:

```bash
git checkout master && git pull
git checkout -b claude/wire-compliance-components
```

---

## STEP 1 — Run DB Migration

Run this against the Horizon database **before** wiring any Go components.  
Adapt column types if Horizon uses MySQL or SQLite instead of PostgreSQL.

### File: `db_migration.sql`

```sql
-- Horizon AB Health — DB migration for compliance components
-- Run this against the Horizon DB before wiring the components.
-- Adapt schema/types to your actual DB (PostgreSQL assumed here).

-- ============================================================================
-- TRIALS — supports trial reminder service
-- ============================================================================
-- If you already have a subscriptions table with trial_end, you can skip this
-- and have the reminder service query subscriptions directly.

CREATE TABLE IF NOT EXISTS trials (
    id              SERIAL PRIMARY KEY,
    user_id         TEXT NOT NULL,
    email           TEXT NOT NULL,
    first_name      TEXT,
    plan_name       TEXT NOT NULL,
    charge_amount   TEXT NOT NULL,           -- e.g. "$29.99"
    trial_start     TIMESTAMPTZ NOT NULL,
    trial_end       TIMESTAMPTZ NOT NULL,
    status          TEXT NOT NULL DEFAULT 'active',  -- active / converted / cancelled
    reminders_sent  TEXT[] DEFAULT '{}',     -- ['t-7', 't-3', 't-1', 't-0']
    stripe_sub_id   TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_trials_status_end ON trials(status, trial_end);
CREATE INDEX idx_trials_user ON trials(user_id);

-- ============================================================================
-- DISPUTES — supports dispute dashboard
-- ============================================================================

CREATE TABLE IF NOT EXISTS disputes (
    id                  SERIAL PRIMARY KEY,
    stripe_dispute_id   TEXT NOT NULL UNIQUE,
    stripe_charge_id    TEXT NOT NULL,
    customer_id         TEXT,
    customer_email      TEXT,
    amount_cents        BIGINT NOT NULL,
    currency            TEXT NOT NULL DEFAULT 'usd',
    reason              TEXT,                -- fraudulent / duplicate / etc
    status              TEXT NOT NULL,       -- needs_response / under_review / won / lost
    evidence_due        TIMESTAMPTZ,
    resolved            BOOLEAN NOT NULL DEFAULT FALSE,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_disputes_created ON disputes(created_at DESC);
CREATE INDEX idx_disputes_status ON disputes(status);
CREATE INDEX idx_disputes_resolved ON disputes(resolved);

-- ============================================================================
-- WEBHOOK EVENTS — idempotency for Stripe webhooks
-- ============================================================================
-- Prevents double-processing of the same Stripe event on retry.

CREATE TABLE IF NOT EXISTS stripe_webhook_events (
    stripe_event_id     TEXT PRIMARY KEY,
    event_type          TEXT NOT NULL,
    processed_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    payload_hash        TEXT NOT NULL
);

-- ============================================================================
-- CANCELLATION_LOG — audit trail for cancellations
-- ============================================================================

CREATE TABLE IF NOT EXISTS cancellation_log (
    id                  SERIAL PRIMARY KEY,
    user_id             TEXT NOT NULL,
    stripe_sub_id       TEXT,
    plan_name           TEXT,
    cancelled_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    access_ends_at      TIMESTAMPTZ NOT NULL,
    cancellation_reason TEXT,
    discount_offered    BOOLEAN DEFAULT FALSE,
    discount_accepted   BOOLEAN DEFAULT FALSE,
    confirmation_sent   BOOLEAN DEFAULT FALSE,
    confirmation_email  TEXT
);

CREATE INDEX idx_cancellation_user ON cancellation_log(user_id);
CREATE INDEX idx_cancellation_date ON cancellation_log(cancelled_at DESC);
```

---

## STEP 2 — Wire Component 1: `SubscriptionDisclosure.tsx`

### What it does
Renders a legally-required recurring-billing disclosure directly above any purchase or subscribe button. Required by ROSCA, CA AB 2863, NY GBL §527-a. Must NOT be hidden behind a link or collapsible.

### Where to put it
- **Path:** `web/components/billing/SubscriptionDisclosure.tsx`  
  (adjust to Horizon's actual frontend directory structure)

### The file — copy verbatim

```tsx
// SubscriptionDisclosure — place this component ABOVE every purchase/confirm button.
// Required by ROSCA, CA AB 2863, NY GBL §527-a.
// Do not hide behind a link. Do not require scroll to find.

import React from "react";

interface Props {
  billingAmount: string;       // "$29.99"
  billingFrequency: string;    // "month" | "year" | "week"
  trialDays?: number;          // 14
  trialEndDate?: string;       // "June 15, 2026"
  cancelPath: string;          // "/account/cancel" or external URL
}

const frequencyLabel: Record<string, string> = {
  month: "every month",
  year: "every year",
  week: "every week",
};

export function SubscriptionDisclosure({
  billingAmount,
  billingFrequency,
  trialDays,
  trialEndDate,
  cancelPath,
}: Props) {
  const interval = frequencyLabel[billingFrequency] ?? billingFrequency;

  return (
    <div
      role="note"
      aria-label="Subscription terms"
      style={{
        fontSize: 13,
        color: "#374151",
        lineHeight: 1.5,
        border: "1px solid #D1D5DB",
        borderRadius: 6,
        padding: "10px 14px",
        marginBottom: 12,
        backgroundColor: "#F9FAFB",
      }}
    >
      {trialDays && trialEndDate ? (
        <>
          <strong>Free trial:</strong> Your {trialDays}-day free trial ends on{" "}
          <strong>{trialEndDate}</strong>. After that, you will be charged{" "}
          <strong>{billingAmount}</strong> automatically {interval} until you
          cancel.{" "}
        </>
      ) : (
        <>
          You will be charged <strong>{billingAmount}</strong> automatically{" "}
          {interval} until you cancel.{" "}
        </>
      )}
      Cancel anytime in{" "}
      <a href={cancelPath} style={{ color: "#2563EB", textDecoration: "underline" }}>
        Account Settings
      </a>
      . By completing this purchase you agree to these recurring billing terms.
    </div>
  );
}
```

### How to wire it

1. Find every "Subscribe", "Start Trial", "Confirm Purchase" button in the frontend.
2. Import and render `<SubscriptionDisclosure>` **directly above** that button.
3. Pass real subscription data as props:

```tsx
import { SubscriptionDisclosure } from "../billing/SubscriptionDisclosure";

// With trial:
<SubscriptionDisclosure
  billingAmount={plan.formattedPrice}
  billingFrequency={plan.interval}
  trialDays={plan.trialDays}
  trialEndDate={formatDate(addDays(now, plan.trialDays))}
  cancelPath="/account/cancel"
/>
<button>Start Free Trial</button>

// Without trial:
<SubscriptionDisclosure
  billingAmount={plan.formattedPrice}
  billingFrequency={plan.interval}
  cancelPath="/account/cancel"
/>
<button>Subscribe Now</button>
```

### Acceptance criteria
- [ ] Component imported into every checkout screen
- [ ] Disclosure visible above purchase button without scroll
- [ ] All required fields populated (amount, frequency, cancel path)
- [ ] If trial offered, trial fields populated

---

## STEP 3 — Wire Component 2: `CancellationFlow.tsx`

### What it does
Self-contained cancellation UI with no dark patterns. ≤2 clicks to reach from account settings. Optional one-time discount offer step. Sends confirmation email on cancel.

### Where to put it
- **Path:** `web/pages/account/cancel.tsx` or `web/components/billing/CancellationFlow.tsx`
- **Route:** `/account/cancel`

### The file — copy verbatim

```tsx
// CancellationFlow — self-contained cancellation UI.
// Cancellation must be reachable from Account Settings in ≤2 clicks.
// No dark patterns: no fake urgency, no pre-selected "keep subscription",
// no multi-step "are you sure" loops beyond one confirmation.
// Required by CA AB 2863 (cancel must be available online without support ticket).

import React, { useState } from "react";

type Step = "entry" | "offer" | "confirm" | "done";

interface Props {
  planName: string;           // "Horizon Pro"
  billingAmount: string;      // "$29.99/month"
  accessEndDate: string;      // "June 30, 2026"
  discountOffer?: {
    label: string;            // "50% off for 3 months"
    onAccept: () => Promise<void>;
  };
  onCancel: () => Promise<void>;  // calls your cancellation API
}

export function CancellationFlow({
  planName,
  billingAmount,
  accessEndDate,
  discountOffer,
  onCancel,
}: Props) {
  const [step, setStep] = useState<Step>("entry");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function handleConfirmCancel() {
    setLoading(true);
    setError(null);
    try {
      await onCancel();
      setStep("done");
    } catch {
      setError("Something went wrong. Please try again or contact support.");
    } finally {
      setLoading(false);
    }
  }

  async function handleAcceptOffer() {
    if (!discountOffer) return;
    setLoading(true);
    try {
      await discountOffer.onAccept();
      // Redirect back to account — offer accepted, not cancelled.
      window.location.href = "/account";
    } catch {
      setError("Could not apply offer. Please try again.");
    } finally {
      setLoading(false);
    }
  }

  if (step === "done") {
    return (
      <div style={styles.card}>
        <h2 style={styles.heading}>Subscription Cancelled</h2>
        <p>
          Your <strong>{planName}</strong> subscription has been cancelled.
          You will continue to have access until <strong>{accessEndDate}</strong>.
        </p>
        <p style={styles.muted}>
          A confirmation email has been sent to your inbox.
        </p>
        <a href="/account" style={styles.link}>Back to Account</a>
      </div>
    );
  }

  if (step === "offer" && discountOffer) {
    return (
      <div style={styles.card}>
        <h2 style={styles.heading}>Before you go</h2>
        <p>
          We'd like to offer you <strong>{discountOffer.label}</strong> to stay.
        </p>
        <div style={styles.buttonRow}>
          <button
            onClick={handleAcceptOffer}
            disabled={loading}
            style={styles.primaryButton}
          >
            {loading ? "Applying..." : `Get ${discountOffer.label}`}
          </button>
          <button
            onClick={() => setStep("confirm")}
            disabled={loading}
            style={styles.ghostButton}
          >
            No thanks, cancel anyway
          </button>
        </div>
        {error && <p style={styles.error}>{error}</p>}
      </div>
    );
  }

  if (step === "confirm") {
    return (
      <div style={styles.card}>
        <h2 style={styles.heading}>Confirm Cancellation</h2>
        <p>
          You are about to cancel your <strong>{planName}</strong> subscription (
          {billingAmount}).
        </p>
        <p>
          You will keep access until <strong>{accessEndDate}</strong>. After
          that, you will not be charged again.
        </p>
        <div style={styles.buttonRow}>
          <button
            onClick={handleConfirmCancel}
            disabled={loading}
            style={styles.dangerButton}
          >
            {loading ? "Cancelling..." : "Yes, cancel my subscription"}
          </button>
          <a href="/account" style={styles.ghostButton}>
            Keep my subscription
          </a>
        </div>
        {error && <p style={styles.error}>{error}</p>}
      </div>
    );
  }

  // entry step
  return (
    <div style={styles.card}>
      <h2 style={styles.heading}>Cancel Subscription</h2>
      <p>
        You are currently on the <strong>{planName}</strong> plan (
        {billingAmount}).
      </p>
      <p>
        Cancelling will stop future charges. You will keep access until{" "}
        <strong>{accessEndDate}</strong>.
      </p>
      <div style={styles.buttonRow}>
        <button
          onClick={() => setStep(discountOffer ? "offer" : "confirm")}
          style={styles.dangerButton}
        >
          Cancel Subscription
        </button>
        <a href="/account" style={styles.ghostButton}>
          Go back
        </a>
      </div>
    </div>
  );
}

const styles: Record<string, React.CSSProperties> = {
  card: {
    maxWidth: 480,
    margin: "40px auto",
    padding: 28,
    border: "1px solid #E5E7EB",
    borderRadius: 10,
    fontFamily: "system-ui, sans-serif",
  },
  heading: { marginTop: 0, fontSize: 20, color: "#111827" },
  muted: { color: "#6B7280", fontSize: 13 },
  buttonRow: { display: "flex", gap: 12, flexWrap: "wrap", marginTop: 20 },
  primaryButton: {
    padding: "10px 20px",
    background: "#2563EB",
    color: "#fff",
    border: "none",
    borderRadius: 6,
    cursor: "pointer",
    fontSize: 14,
  },
  dangerButton: {
    padding: "10px 20px",
    background: "#DC2626",
    color: "#fff",
    border: "none",
    borderRadius: 6,
    cursor: "pointer",
    fontSize: 14,
  },
  ghostButton: {
    padding: "10px 20px",
    background: "transparent",
    color: "#374151",
    border: "1px solid #D1D5DB",
    borderRadius: 6,
    cursor: "pointer",
    fontSize: 14,
    textDecoration: "none",
    display: "inline-block",
  },
  link: { color: "#2563EB", textDecoration: "underline", fontSize: 14 },
  error: { color: "#DC2626", fontSize: 13, marginTop: 8 },
};
```

### How to wire it

1. Create the `/account/cancel` route if it doesn't exist.
2. Import `CancellationFlow` and render it on that page/route:

```tsx
import { CancellationFlow } from "../../components/billing/CancellationFlow";

export default function CancelPage() {
  // Load subscription data from your backend/context
  return (
    <CancellationFlow
      planName={subscription.planName}
      billingAmount={subscription.formattedPrice}
      accessEndDate={subscription.currentPeriodEndFormatted}
      onCancel={async () => {
        await fetch("/api/subscription/cancel", { method: "POST" });
      }}
    />
  );
}
```

3. In account settings, add a "Cancel Subscription" link pointing to `/account/cancel`.
4. Ensure the backend `/api/subscription/cancel` endpoint triggers a confirmation email.

### Acceptance criteria
- [ ] Route `/account/cancel` exists and reachable from account settings in ≤2 clicks
- [ ] Cancellation completes in single confirmation (no multi-step loops)
- [ ] Confirmation email triggered on cancellation
- [ ] No support ticket required to cancel
- [ ] Discount-offer step is optional and skippable

---

## STEP 4 — Wire Component 3: `trial_reminder.go`

### What it does
Sends T-7, T-3, T-1, T-0 reminder emails before trial converts to paid. Runs once per day via scheduler. Required by ROSCA and CA AB 2863.

### Where to put it
- **Path:** `internal/billing/trial_reminder.go` (adjust to Horizon's package structure)

### The file — copy verbatim

```go
// Trial Reminder Service — sends reminder emails at T-7, T-3, T-1, and T-0.
// Wire into your scheduler (cron job, Temporal, or equivalent).
// Required by ROSCA and CA AB 2863 best practice.

package trialreminder

import (
	"context"
	"fmt"
	"time"
)

// TrialReminder holds the data needed to send a reminder.
type TrialReminder struct {
	UserID        string
	Email         string
	FirstName     string
	TrialEndDate  time.Time
	ChargeAmount  string // "$29.99"
	CancelURL     string // "https://app.horizonhealth.com/account/cancel"
	PlanName      string // "Horizon Pro"
}

// EmailSender is the interface you wire to your email provider (SendGrid, SES, Postmark).
type EmailSender interface {
	Send(ctx context.Context, to, subject, htmlBody string) error
}

// ReminderService checks all active trials and fires reminders on schedule.
type ReminderService struct {
	emailSender EmailSender
	getTrials   func(ctx context.Context) ([]TrialReminder, error)
}

func NewReminderService(sender EmailSender, getTrials func(ctx context.Context) ([]TrialReminder, error)) *ReminderService {
	return &ReminderService{emailSender: sender, getTrials: getTrials}
}

// Run is called once per day by your scheduler.
func (s *ReminderService) Run(ctx context.Context) error {
	trials, err := s.getTrials(ctx)
	if err != nil {
		return fmt.Errorf("fetching trials: %w", err)
	}

	now := time.Now().UTC().Truncate(24 * time.Hour)

	for _, t := range trials {
		end := t.TrialEndDate.UTC().Truncate(24 * time.Hour)
		daysLeft := int(end.Sub(now).Hours() / 24)

		switch daysLeft {
		case 7:
			_ = s.send7Day(ctx, t)
		case 3:
			_ = s.send3Day(ctx, t)
		case 1:
			_ = s.send1Day(ctx, t)
		case 0:
			_ = s.sendConversionDay(ctx, t)
		}
	}
	return nil
}

func (s *ReminderService) send7Day(ctx context.Context, t TrialReminder) error {
	subject := fmt.Sprintf("Your Horizon free trial ends in 7 days")
	body := buildEmailHTML(t, "7 days", "7 days")
	return s.emailSender.Send(ctx, t.Email, subject, body)
}

func (s *ReminderService) send3Day(ctx context.Context, t TrialReminder) error {
	subject := fmt.Sprintf("Your Horizon free trial ends in 3 days")
	body := buildEmailHTML(t, "3 days", "3 days")
	return s.emailSender.Send(ctx, t.Email, subject, body)
}

func (s *ReminderService) send1Day(ctx context.Context, t TrialReminder) error {
	subject := fmt.Sprintf("Your trial ends tomorrow — %s will be charged", t.ChargeAmount)
	body := buildEmailHTML(t, "tomorrow", "1 day")
	return s.emailSender.Send(ctx, t.Email, subject, body)
}

func (s *ReminderService) sendConversionDay(ctx context.Context, t TrialReminder) error {
	subject := fmt.Sprintf("Your Horizon trial has ended — %s charged today", t.ChargeAmount)
	body := buildConversionHTML(t)
	return s.emailSender.Send(ctx, t.Email, subject, body)
}

// buildEmailHTML produces the reminder email body.
// All required disclosures: end date, charge amount, cancel URL, cancel steps.
func buildEmailHTML(t TrialReminder, timeUntil, daysLabel string) string {
	return fmt.Sprintf(`
<p>Hi %s,</p>

<p>Your <strong>%s free trial</strong> ends in <strong>%s</strong> on <strong>%s</strong>.</p>

<p>After your trial, you will be automatically charged <strong>%s/month</strong>
for the <strong>%s</strong> plan.</p>

<table style="border:1px solid #ddd; border-radius:6px; padding:16px; margin:16px 0;">
  <tr><td><strong>Trial ends:</strong></td><td>%s</td></tr>
  <tr><td><strong>Amount:</strong></td><td>%s/month</td></tr>
  <tr><td><strong>Billed:</strong></td><td>Automatically each month</td></tr>
</table>

<p><strong>To cancel before being charged:</strong><br>
1. Log in to your Horizon account<br>
2. Go to Account → Subscription<br>
3. Click "Cancel Subscription"<br>
4. Confirm cancellation</p>

<p>Or cancel directly: <a href="%s">Cancel my subscription</a></p>

<p>If you have questions, reply to this email.</p>
<p>— The Horizon Team</p>
`,
		t.FirstName,
		t.PlanName,
		timeUntil,
		t.TrialEndDate.Format("January 2, 2006"),
		t.ChargeAmount,
		t.PlanName,
		t.TrialEndDate.Format("January 2, 2006"),
		t.ChargeAmount,
		t.CancelURL,
	)
}

func buildConversionHTML(t TrialReminder) string {
	return fmt.Sprintf(`
<p>Hi %s,</p>

<p>Your free trial has ended and your <strong>%s</strong> subscription is now active.</p>

<p>You have been charged <strong>%s</strong> today for your first month.</p>

<p>To manage or cancel your subscription:<br>
<a href="%s">Manage my subscription</a></p>

<p>— The Horizon Team</p>
`,
		t.FirstName,
		t.PlanName,
		t.ChargeAmount,
		t.CancelURL,
	)
}
```

### How to wire it

1. Implement the `EmailSender` interface with your email provider (SendGrid, SES, Postmark — must have BAA if sending PHI):

```go
type sendgridSender struct{ client *sendgrid.Client }
func (s *sendgridSender) Send(ctx context.Context, to, subject, html string) error { ... }
```

2. Implement the `getTrials` function querying your DB:

```go
func getActiveTrials(db *sql.DB) func(ctx context.Context) ([]trialreminder.TrialReminder, error) {
    return func(ctx context.Context) ([]trialreminder.TrialReminder, error) {
        rows, err := db.QueryContext(ctx,
            `SELECT user_id, email, first_name, plan_name, charge_amount, trial_end
             FROM trials WHERE status = 'active'`)
        // ... scan rows into []TrialReminder
    }
}
```

3. Wire to your daily scheduler (cron example):

```go
// go get github.com/robfig/cron/v3
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
- [ ] Service runs once per day at 00:00 UTC
- [ ] T-7, T-3, T-1, T-0 emails sent at correct intervals
- [ ] Each email contains: trial end date, charge amount, cancel link, cancel steps
- [ ] Email provider has BAA executed (HIPAA requirement)

---

## STEP 5 — Wire Component 4: `stripe_webhooks.go`

### What it does
Handles all 8 critical Stripe subscription events. Verifies webhook signature. Returns 200 even on handler errors to prevent Stripe retries from flooding.

### Where to put it
- **Path:** `internal/billing/stripe_webhooks.go`
- **Mounted at:** `POST /api/webhooks/stripe`

### The file — copy verbatim

```go
// Stripe Webhook Handler — add to your existing Stripe webhook endpoint.
// Handles all subscription lifecycle and dispute events required for compliance.
// Wire each case into your own DB/email/notification logic.

package stripewebhooks

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"time"

	"github.com/stripe/stripe-go/v76"
	"github.com/stripe/stripe-go/v76/webhook"
)

// Handler handles incoming Stripe webhook events.
type Handler struct {
	webhookSecret string
	svc           SubscriptionService
}

// SubscriptionService — implement these in your application layer.
type SubscriptionService interface {
	// Subscription lifecycle
	OnSubscriptionCreated(ctx context.Context, sub *stripe.Subscription) error
	OnSubscriptionUpdated(ctx context.Context, sub *stripe.Subscription) error
	OnSubscriptionCancelled(ctx context.Context, sub *stripe.Subscription) error
	OnSubscriptionPaused(ctx context.Context, sub *stripe.Subscription) error

	// Invoices / payments
	OnPaymentSucceeded(ctx context.Context, inv *stripe.Invoice) error   // send receipt
	OnPaymentFailed(ctx context.Context, inv *stripe.Invoice) error      // trigger dunning

	// Trial
	OnTrialWillEnd(ctx context.Context, sub *stripe.Subscription) error  // T-3 reminder

	// Disputes
	OnDisputeCreated(ctx context.Context, dispute *stripe.Dispute) error // alert + log
}

func NewHandler(webhookSecret string, svc SubscriptionService) *Handler {
	return &Handler{webhookSecret: webhookSecret, svc: svc}
}

func (h *Handler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	body, err := io.ReadAll(r.Body)
	if err != nil {
		http.Error(w, "cannot read body", http.StatusBadRequest)
		return
	}

	event, err := webhook.ConstructEvent(body, r.Header.Get("Stripe-Signature"), h.webhookSecret)
	if err != nil {
		http.Error(w, "signature verification failed", http.StatusBadRequest)
		return
	}

	ctx := r.Context()
	if err := h.dispatch(ctx, event); err != nil {
		// Log the error but return 200 so Stripe does not retry indefinitely.
		// Alert your on-call system here.
		fmt.Printf("webhook dispatch error [%s]: %v\n", event.Type, err)
	}

	w.WriteHeader(http.StatusOK)
}

func (h *Handler) dispatch(ctx context.Context, event stripe.Event) error {
	switch event.Type {

	case "customer.subscription.created":
		var sub stripe.Subscription
		if err := json.Unmarshal(event.Data.Raw, &sub); err != nil {
			return err
		}
		return h.svc.OnSubscriptionCreated(ctx, &sub)

	case "customer.subscription.updated":
		var sub stripe.Subscription
		if err := json.Unmarshal(event.Data.Raw, &sub); err != nil {
			return err
		}
		return h.svc.OnSubscriptionUpdated(ctx, &sub)

	case "customer.subscription.deleted":
		var sub stripe.Subscription
		if err := json.Unmarshal(event.Data.Raw, &sub); err != nil {
			return err
		}
		return h.svc.OnSubscriptionCancelled(ctx, &sub)

	case "customer.subscription.paused":
		var sub stripe.Subscription
		if err := json.Unmarshal(event.Data.Raw, &sub); err != nil {
			return err
		}
		return h.svc.OnSubscriptionPaused(ctx, &sub)

	case "customer.subscription.trial_will_end":
		// Stripe fires this 3 days before trial ends.
		// Use this as the authoritative T-3 trigger (overrides cron if you prefer).
		var sub stripe.Subscription
		if err := json.Unmarshal(event.Data.Raw, &sub); err != nil {
			return err
		}
		return h.svc.OnTrialWillEnd(ctx, &sub)

	case "invoice.payment_succeeded":
		var inv stripe.Invoice
		if err := json.Unmarshal(event.Data.Raw, &inv); err != nil {
			return err
		}
		return h.svc.OnPaymentSucceeded(ctx, &inv)

	case "invoice.payment_failed":
		var inv stripe.Invoice
		if err := json.Unmarshal(event.Data.Raw, &inv); err != nil {
			return err
		}
		return h.svc.OnPaymentFailed(ctx, &inv)

	case "charge.dispute.created":
		var dispute stripe.Dispute
		if err := json.Unmarshal(event.Data.Raw, &dispute); err != nil {
			return err
		}
		return h.svc.OnDisputeCreated(ctx, &dispute)
	}

	// Unhandled event types are not errors — Stripe sends many event types.
	return nil
}

// ── Receipt Email Template ─────────────────────────────────────────────────────

// BuildReceiptEmail returns the HTML receipt body for invoice.payment_succeeded.
func BuildReceiptEmail(inv *stripe.Invoice, cancelURL string) string {
	charged := fmt.Sprintf("$%.2f", float64(inv.AmountPaid)/100)
	period := "N/A"
	if inv.Lines != nil && len(inv.Lines.Data) > 0 {
		line := inv.Lines.Data[0]
		if line.Period != nil {
			start := time.Unix(line.Period.Start, 0).Format("Jan 2, 2006")
			end := time.Unix(line.Period.End, 0).Format("Jan 2, 2006")
			period = fmt.Sprintf("%s – %s", start, end)
		}
	}

	return fmt.Sprintf(`
<p>Thank you for your payment.</p>

<table style="border:1px solid #ddd; border-radius:6px; padding:16px;">
  <tr><td><strong>Amount charged:</strong></td><td>%s</td></tr>
  <tr><td><strong>Billing period:</strong></td><td>%s</td></tr>
  <tr><td><strong>Invoice ID:</strong></td><td>%s</td></tr>
</table>

<p>To manage or cancel your subscription:
<a href="%s">Manage Subscription</a></p>
`, charged, period, inv.ID, cancelURL)
}

// ── Dispute Alert ──────────────────────────────────────────────────────────────

// DisputeAlert is the data you log and alert on when a chargeback is filed.
type DisputeAlert struct {
	DisputeID  string
	ChargeID   string
	Amount     int64
	Currency   string
	Reason     string
	Status     string
	EvidenceDue time.Time
	CustomerID string
}

func BuildDisputeAlert(d *stripe.Dispute) DisputeAlert {
	return DisputeAlert{
		DisputeID:   d.ID,
		ChargeID:    d.Charge.ID,
		Amount:      d.Amount,
		Currency:    string(d.Currency),
		Reason:      string(d.Reason),
		Status:      string(d.Status),
		EvidenceDue: time.Unix(d.EvidenceDetails.DueBy, 0),
	}
}
```

### How to wire it

1. Mount in your router:

```go
handler := stripewebhooks.NewHandler(os.Getenv("STRIPE_WEBHOOK_SECRET"), yourServiceImpl)
router.HandleFunc("/api/webhooks/stripe", handler.ServeHTTP)
```

2. Implement the `SubscriptionService` interface in your application layer (one struct with all 8 methods).

3. In Stripe Dashboard → Webhooks → add endpoint with these 8 events:
   - `customer.subscription.created`
   - `customer.subscription.updated`
   - `customer.subscription.deleted`
   - `customer.subscription.paused`
   - `customer.subscription.trial_will_end`
   - `invoice.payment_succeeded`
   - `invoice.payment_failed`
   - `charge.dispute.created`

4. Copy the signing secret into env var `STRIPE_WEBHOOK_SECRET`.

5. Add idempotency check using `stripe_webhook_events` table (from migration) to prevent double-processing on Stripe retries.

### Acceptance criteria
- [ ] Webhook endpoint responds 200 to Stripe test events
- [ ] All 8 event types route to correct handler
- [ ] Signature verification rejects invalid payloads
- [ ] Dispute events trigger ops alert
- [ ] Receipt emails sent within 1 hour of `invoice.payment_succeeded`

---

## STEP 6 — Wire Component 5: `dispute_dashboard.go`

### What it does
Backend data layer for chargeback/dispute monitoring. Tracks disputes against Visa VDMP (0.65%) and Mastercard ECP (1.0%) thresholds. Auto-generates alerts when thresholds are breached.

### Where to put it
- **Path:** `internal/admin/dispute_dashboard.go`
- **Admin route:** `GET /admin/disputes`

### The file — copy verbatim

```go
// Dispute & Chargeback Monitoring Dashboard — backend data layer.
// Wire to your admin frontend (table + chart of the metrics below).
// Alert thresholds based on Visa VDMP (>0.65%) and Mastercard ECP (>1.0%).

package disputedashboard

import (
	"context"
	"time"
)

// MetricWindow is the time period for a dashboard snapshot.
type MetricWindow struct {
	Start time.Time
	End   time.Time
}

// Last30Days returns a 30-day window ending now.
func Last30Days() MetricWindow {
	now := time.Now().UTC()
	return MetricWindow{Start: now.AddDate(0, 0, -30), End: now}
}

// DashboardMetrics is the full set of metrics shown on the admin dashboard.
type DashboardMetrics struct {
	Window             MetricWindow
	TotalCharges       int
	TotalRevenue       int64  // cents
	Disputes           int
	DisputeRate        float64 // disputes / charges
	Refunds            int
	RefundRate         float64
	FailedPayments     int
	Cancellations      int
	ActiveSubscriptions int
	Alerts             []Alert
}

// Alert is a threshold breach that requires action.
type Alert struct {
	Level   string // "warning" | "critical"
	Metric  string
	Value   float64
	Message string
}

// DisputeRecord is a single chargeback row in the admin table.
type DisputeRecord struct {
	ID           string
	CustomerID   string
	CustomerEmail string
	Amount       int64  // cents
	Currency     string
	Reason       string
	Status       string
	CreatedAt    time.Time
	EvidenceDue  time.Time
	Resolved     bool
}

// MetricsRepository — implement against your actual database.
type MetricsRepository interface {
	CountCharges(ctx context.Context, w MetricWindow) (int, error)
	SumRevenue(ctx context.Context, w MetricWindow) (int64, error)
	CountDisputes(ctx context.Context, w MetricWindow) (int, error)
	CountRefunds(ctx context.Context, w MetricWindow) (int, error)
	CountFailedPayments(ctx context.Context, w MetricWindow) (int, error)
	CountCancellations(ctx context.Context, w MetricWindow) (int, error)
	CountActiveSubscriptions(ctx context.Context) (int, error)
	ListDisputes(ctx context.Context, w MetricWindow) ([]DisputeRecord, error)
}

type DashboardService struct {
	repo MetricsRepository
}

func NewDashboardService(repo MetricsRepository) *DashboardService {
	return &DashboardService{repo: repo}
}

// GetMetrics returns the full dashboard snapshot with auto-generated alerts.
func (s *DashboardService) GetMetrics(ctx context.Context, w MetricWindow) (*DashboardMetrics, error) {
	charges, err := s.repo.CountCharges(ctx, w)
	if err != nil {
		return nil, err
	}
	revenue, err := s.repo.SumRevenue(ctx, w)
	if err != nil {
		return nil, err
	}
	disputes, err := s.repo.CountDisputes(ctx, w)
	if err != nil {
		return nil, err
	}
	refunds, err := s.repo.CountRefunds(ctx, w)
	if err != nil {
		return nil, err
	}
	failed, err := s.repo.CountFailedPayments(ctx, w)
	if err != nil {
		return nil, err
	}
	cancellations, err := s.repo.CountCancellations(ctx, w)
	if err != nil {
		return nil, err
	}
	active, err := s.repo.CountActiveSubscriptions(ctx)
	if err != nil {
		return nil, err
	}

	var disputeRate, refundRate float64
	if charges > 0 {
		disputeRate = float64(disputes) / float64(charges)
		refundRate = float64(refunds) / float64(charges)
	}

	m := &DashboardMetrics{
		Window:              w,
		TotalCharges:        charges,
		TotalRevenue:        revenue,
		Disputes:            disputes,
		DisputeRate:         disputeRate,
		Refunds:             refunds,
		RefundRate:          refundRate,
		FailedPayments:      failed,
		Cancellations:       cancellations,
		ActiveSubscriptions: active,
	}

	m.Alerts = generateAlerts(m)
	return m, nil
}

func generateAlerts(m *DashboardMetrics) []Alert {
	var alerts []Alert

	// Visa VDMP threshold
	if m.DisputeRate >= 0.0065 {
		level := "warning"
		msg := "Visa VDMP threshold approaching — review dispute reasons immediately"
		if m.DisputeRate >= 0.009 {
			level = "critical"
			msg = "Dispute rate critical — Visa may place account in monitoring program"
		}
		alerts = append(alerts, Alert{
			Level:   level,
			Metric:  "dispute_rate",
			Value:   m.DisputeRate * 100,
			Message: msg,
		})
	}

	// Mastercard ECP threshold
	if m.DisputeRate >= 0.01 {
		alerts = append(alerts, Alert{
			Level:   "critical",
			Metric:  "dispute_rate_mc",
			Value:   m.DisputeRate * 100,
			Message: "Mastercard Excessive Chargeback threshold breached",
		})
	}

	// High refund rate
	if m.RefundRate >= 0.05 {
		alerts = append(alerts, Alert{
			Level:   "warning",
			Metric:  "refund_rate",
			Value:   m.RefundRate * 100,
			Message: "Refund rate above 5% — review cancellation and billing clarity",
		})
	}

	// Raw dispute count floor regardless of rate
	if m.Disputes >= 5 {
		alerts = append(alerts, Alert{
			Level:   "warning",
			Metric:  "dispute_count",
			Value:   float64(m.Disputes),
			Message: "5+ disputes in 30 days — investigate patterns",
		})
	}

	return alerts
}

// ListDisputes returns all dispute records for the admin table.
func (s *DashboardService) ListDisputes(ctx context.Context, w MetricWindow) ([]DisputeRecord, error) {
	return s.repo.ListDisputes(ctx, w)
}
```

### How to wire it

1. Implement `MetricsRepository` against your DB (one struct, 8 methods, SQL queries against `disputes`, `cancellation_log`, and your charges/invoices tables).

2. Create admin route:

```go
dashSvc := disputedashboard.NewDashboardService(yourRepoImpl)

router.HandleFunc("/admin/disputes", func(w http.ResponseWriter, r *http.Request) {
    // Require admin auth middleware
    ctx := r.Context()
    metrics, err := dashSvc.GetMetrics(ctx, disputedashboard.Last30Days())
    if err != nil {
        http.Error(w, err.Error(), 500)
        return
    }
    json.NewEncoder(w).Encode(metrics)
})
```

3. Build a simple admin UI page (or add to existing admin panel) showing:
   - Dispute count + rate (with VDMP/ECP threshold lines)
   - Refund rate
   - Failed payment count
   - List of recent disputes (reason + amount + status + evidence due date)
   - Active alerts from `metrics.Alerts`

4. Set up a daily cron/job that emails ops if `metrics.Alerts` is non-empty.

### Acceptance criteria
- [ ] Admin can view dispute metrics at `/admin/disputes`
- [ ] Alerts fire at 0.65% (Visa VDMP) and 1.0% (MC ECP)
- [ ] Recent disputes show with reason + amount + status
- [ ] Daily alert email sent to ops when alerts present
- [ ] Admin auth required (no public access)

---

## STEP 7 — Env Vars Required

Add these to your `.env` / secrets manager / deployment config:

```
STRIPE_WEBHOOK_SECRET=whsec_...        # from Stripe Dashboard → Webhooks → signing secret
STRIPE_SECRET_KEY=sk_live_...          # or sk_test_ for test mode
APP_CANCEL_URL=https://app.horizonhealth.com/account/cancel
EMAIL_FROM=noreply@horizonhealth.com
```

---

## STEP 8 — Add Go Dependency (stripe-go)

If `github.com/stripe/stripe-go/v76` is not already in `go.mod`:

```bash
go get github.com/stripe/stripe-go/v76
```

---

## STEP 9 — Commit, Push, Open PR

```bash
git add internal/billing/trial_reminder.go
git add internal/billing/stripe_webhooks.go
git add internal/admin/dispute_dashboard.go
git add web/components/billing/SubscriptionDisclosure.tsx
git add web/pages/account/cancel.tsx   # or wherever CancellationFlow lands
git add db/migrations/YYYYMMDD_compliance.sql

git commit -m "Wire 5 compliance components (ROSCA / CA AB 2863 / VDMP)"
git push -u origin claude/wire-compliance-components

gh pr create \
  --title "Wire compliance components (per docs/horizon-aba audit)" \
  --body "$(cat <<'EOF'
## Summary
Wires 5 compliance components from prior audit:
- SubscriptionDisclosure (ROSCA / CA AB 2863 / NY GBL §527-a)
- CancellationFlow (no dark patterns, ≤2 clicks, online-only)
- TrialReminderService (T-7/T-3/T-1/T-0)
- StripeWebhookHandler (8 events including disputes)
- DisputeDashboard (Visa VDMP + MC ECP alerts)

## DB Migration
Run db_migration.sql before deploying: tables trials, disputes,
stripe_webhook_events, cancellation_log

## Counselor Review Required
- [ ] Approve ToS subscription clauses (now displayed at checkout)
- [ ] Approve Privacy Policy health-data section
- [ ] Confirm BAA signed with Stripe (Healthcare tier)
- [ ] Confirm BAA signed with email provider

## Test plan
- [ ] Trial reminder runs at T-7/T-3/T-1/T-0
- [ ] Stripe test webhooks deliver successfully
- [ ] Cancellation completes in single flow
- [ ] Dispute alerts fire at correct thresholds
- [ ] go test ./internal/billing/... passing
- [ ] go test ./internal/admin/... passing
EOF
)"
```

---

## STEP 10 — Completion Checklist

### Pre-flight
- [ ] Repo audit complete — entry point, router, existing Stripe code, frontend root all identified
- [ ] Branch `claude/wire-compliance-components` created off `master`
- [ ] DB migration applied

### Component 1 — SubscriptionDisclosure
- [ ] File at `web/components/billing/SubscriptionDisclosure.tsx` (or Horizon equivalent)
- [ ] Rendered above every "Subscribe" / "Start Trial" / "Confirm Purchase" button
- [ ] Props populated from real subscription data
- [ ] Mobile-responsive — no scroll required to see disclosure
- [ ] Trial fields shown when trial offered

### Component 2 — CancellationFlow
- [ ] Route `/account/cancel` exists
- [ ] Link from account settings — ≤2 clicks to reach
- [ ] `onCancel` calls backend cancellation API
- [ ] Confirmation email triggered on cancellation
- [ ] No dark patterns
- [ ] No support ticket required to cancel

### Component 3 — TrialReminderService
- [ ] Service deployed and scheduled daily at 00:00 UTC
- [ ] `EmailSender` interface wired to BAA-signed email provider
- [ ] T-7 / T-3 / T-1 / T-0 emails verified in test
- [ ] Each email contains: trial end date, charge amount, cancel link

### Component 4 — StripeWebhookHandler
- [ ] Endpoint `POST /api/webhooks/stripe` mounted
- [ ] Webhook signing secret loaded from env
- [ ] Stripe Dashboard configured with all 8 event types
- [ ] Test event delivers successfully (Stripe test mode)
- [ ] Receipt email sent on `invoice.payment_succeeded`
- [ ] Dispute record written + ops alert on `charge.dispute.created`

### Component 5 — DisputeDashboard
- [ ] Admin route `/admin/disputes` mounted with auth
- [ ] Metrics display correctly
- [ ] Alerts fire at 0.65% (VDMP) and 1.0% (ECP)
- [ ] Daily alert email when alerts present

### Tests
- [ ] `trial_reminder_test.go` — verifies T-7/T-3/T-1/T-0 trigger timing
- [ ] `stripe_webhooks_test.go` — verifies each event routes correctly
- [ ] `cancellation_flow_test.tsx` — verifies cancel completes + email sent
- [ ] CI green on branch

### Documentation
- [ ] `SESSION_LOG.md` updated in horizon-ab-health repo with:
  - Files added/modified
  - Audit status for each previously NEEDS CODE REVIEW item
  - Env vars documented
  - Remaining gaps
  - Next milestone: Counselor approval + BAAs signed

### Counselor Approval Required Before Merge
- [ ] ToS clauses approved (now visible at checkout)
- [ ] Privacy Policy section approved (HIPAA disclosures)
- [ ] BAA confirmed signed with Stripe (Healthcare tier)
- [ ] BAA confirmed signed with email provider

### Pull Request
- [ ] PR open against `master`
- [ ] PR body includes audit summary and counselor review checklist
- [ ] CI green
- [ ] Counselor tagged for review

---

## When To Ask Founder For Help

- If Horizon's existing checkout / billing code looks materially different from these components — ask before refactoring
- If Stripe account is not on Healthcare tier yet — flag and wait for BAA execution
- If email provider has no BAA — flag and wait
- If existing ToS / Privacy Policy is on a CMS you cannot edit — request CMS access
- If Apple/Google IAP determination cannot be made from code alone — ask Founder
- If anything is unclear — ASK before acting. Do not assume.
