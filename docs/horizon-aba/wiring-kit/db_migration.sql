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
