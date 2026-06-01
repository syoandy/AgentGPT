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
