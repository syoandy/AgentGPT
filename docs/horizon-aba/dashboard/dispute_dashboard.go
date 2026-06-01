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
