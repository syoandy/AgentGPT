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
