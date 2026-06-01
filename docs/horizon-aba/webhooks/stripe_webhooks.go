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
