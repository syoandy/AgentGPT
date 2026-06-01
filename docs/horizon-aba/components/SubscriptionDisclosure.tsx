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

// ── Usage example ──────────────────────────────────────────────────────────────
//
// <SubscriptionDisclosure
//   billingAmount="$29.99"
//   billingFrequency="month"
//   trialDays={14}
//   trialEndDate="June 15, 2026"
//   cancelPath="/account/cancel"
// />
// <button>Start Free Trial</button>
//
// ── Without trial ─────────────────────────────────────────────────────────────
//
// <SubscriptionDisclosure
//   billingAmount="$29.99"
//   billingFrequency="month"
//   cancelPath="/account/cancel"
// />
// <button>Subscribe Now</button>
