# Horizon ABA Health — NotebookLM Source Document
**Upload this file to your Horizon NotebookLM project as a source.**  
**Updated:** 2026-06-01 | Branch: claude/create-feep-IU72S

---

## Project Overview

Horizon ABA Health is a SaaS subscription app serving Applied Behavior Analysis therapy providers and clients. It includes subscription billing, free trial flows, and health-data handling that triggers HIPAA compliance requirements.

---

## Compliance Audit Summary (2026-06-01)

### What was audited
Subscription flow, free trial flow, checkout, Stripe integration, Apple App Store path, Google Play path, cancellation flow, billing portal, terms of service, auto-renewal disclosures, trial reminders, refund workflow, chargeback handling, and account settings.

### What was built
Five compliance components are now ready to wire into the Horizon codebase:
1. **SubscriptionDisclosure** — React component, places required legal disclosure above every purchase button. Required by ROSCA, CA AB 2863, NY GBL §527-a.
2. **TrialReminderService** — Go service, sends T-7/T-3/T-1/T-0 reminder emails with trial end date, charge amount, and cancellation link.
3. **StripeWebhookHandler** — Go handler, covers all critical subscription lifecycle events including dispute.created.
4. **CancellationFlow** — React component, cancellation in ≤2 clicks, no dark patterns, sends confirmation email.
5. **DisputeDashboard** — Go service, tracks chargeback rate against Visa VDMP (0.65%) and Mastercard ECP (1.0%) thresholds.

### What still needs to happen
- Wire all 5 components into the actual `horizon-ab-health` codebase
- Submit `COUNSELOR_APPROVAL_PACKAGE.md` to Horizon Counselor (P0 — blocks launch)
- Execute Stripe Healthcare BAA (no standard Stripe account covers this)
- Execute Email Provider BAA (required before any user emails are sent)
- Apple IAP determination (is there an iOS app? does it sell subscriptions?)
- Google Play billing determination (is there an Android app?)
- Code-level verification of existing Stripe flow, checkout screens, and cancellation

### FEEP — Empire-Wide Master Doctrine
The Founder Empire Execution Protocol (FEEP) is the master operating system for
all Yoandy OS empire entities. Horizon ABA Health operates under FEEP as the
first reference implementation.

**FEEP consists of 8 documents** in `docs/feep/`:
- **00_FEEP_MASTER.md** — 18 articles: Founder Supremacy, Counselor structure,
  Truth Source rule, Cross-contamination prevention, Security Tiers, Financial
  doctrine, Legal compliance chain, Automation law, Truth Score, Launch sequence,
  Acquisition sequence, Audit doctrine, Memory order, Chain of command, Amendment
  procedure, Expansion rules, Emergency override, Doctrine stack
- **01_UNIVERSAL_GOVERNANCE_TEMPLATE.md** — per-entity governance template
- **02_UNIVERSAL_APP_BUILD_DOCTRINE.md** — code, stack, security per tier
- **03_UNIVERSAL_DEPLOYMENT_DOCTRINE.md** — Truth Source rule + rollout phases
- **04_UNIVERSAL_AUDIT_MATRIX.md** — quarterly + annual audit cadence
- **05_CROSS_COMPANY_ISOLATION.md** — hard isolation enforcement
- **06_FUTURE_COMPANY_ONBOARDING.md** — greenfield + acquisition paths
- **07_SCALABILITY_SCORE.md** — quarterly empire readiness score (0-100)

**Current Empire Scalability Score: 48 / 100** (Foundation laid, operational
activation pending Founder Action Sheet completion).

### Legal Authority — Counselor Authority Doctrine
Horizon Counselor holds **supreme internal legal authority** across all Horizon
entities under the Counselor Authority Doctrine (Articles I–XI). Counselor
functions as General Counsel equivalent with veto power over launches, contracts,
vendor onboarding, and all legal artifacts.

**Routing:** Founder → Counselor → Determinations → [if Article III threshold: Founder co-sign] → Launch.

**External counsel only required for Article V mandatory escalations**: litigation,
government investigations, subpoenas, securities, patents, trademark disputes,
GDPR cross-border, criminal exposure.

**Bar status caveat:** If Counselor is not bar-admitted, attorney-client privilege
does not apply to Counselor-Founder communications, and external counsel is
required for regulator-facing opinions. Founder accepts this risk per Article VI.

Full doctrine: `docs/horizon-aba/legal/COUNSELOR_AUTHORITY_DOCTRINE.md`

### Mandatory Rules (8 binding rules)
Per `docs/horizon-aba/MANDATORY_RULES.md`:
- **Rule 1 — Data Dictionary:** No legal review without a complete data dictionary
- **Rule 2 — Obsidian Sync:** Every session ends with Obsidian synced or blocker documented
- **Rule 3 — Blocker Documentation:** Every blocker explicit, no silent skips
- **Rule 4 — Memory Order:** Vault → Obsidian → Graphify → NotebookLM → handoffs → task
- **Rule 5 — Context-First:** Check for existing artifacts before creating new ones
- **Rule 6 — Handoff Completeness:** Session not done until handoff checklist is complete
- **Rule 7 — No Scatter:** One system, one source of truth
- **Rule 8 — Amendment Protocol:** Founder + Counselor joint signature only

These rules bind all Horizon entities, all sessions, and all AI assistants
(Claude, ChatGPT) on Horizon work.

### Legal findings
- **ROSCA** (15 U.S.C. § 8403): Federal law, active. Requires clear disclosure of recurring billing terms before purchase and simple cancellation.
- **CA AB 2863**: Strongest state auto-renewal law. Requires affirmative consent checkbox (not pre-checked) for trial-to-paid conversion for California subscribers.
- **NY GBL §527-a**: Active. Clear disclosure + acknowledgment required.
- **FTC Click-to-Cancel**: Original rule vacated by 8th Circuit July 2024. Replacement rulemaking status pending. LEGAL REVIEW REQUIRED.
- **HIPAA**: ABA therapy involves Protected Health Information. Horizon must have BAAs in place with Stripe and email provider before launch.
- **Apple §3.1.2**: Auto-renewable subscriptions must use StoreKit/IAP, include subscription management link, and restore purchases.
- **Google Play Subscriptions Policy**: Recurring billing must use Google Play Billing Library.

---

## Architecture Decisions

| Decision | Reason |
|---|---|
| All docs in `syoandy/agentgpt`, branch `claude/create-feep-IU72S` | Founder requested no scattered systems — single source of truth |
| Components written in Go (backend) + TSX (frontend) | Horizon codebase is Go; frontend framework TBD pending code access |
| HIPAA flagged P0 | ABA therapy = PHI regardless of what specific data is stored |
| FTC Click-to-Cancel marked LEGAL REVIEW REQUIRED | Rule status is uncertain after 2024 court decision |

---

## File Index

```
docs/horizon-aba/
├── SUBSCRIPTION_COMPLIANCE_AUDIT.md     — Full audit with PASS/FAIL/PARTIAL/NOT IMPLEMENTED
├── SESSION_LOG.md                       — Running session log + decision record
├── EXTERNAL_SYSTEMS_SYNC.md            — How to sync Obsidian/Graphify/NLM
├── components/
│   ├── SubscriptionDisclosure.tsx       — Legal disclosure component
│   └── CancellationFlow.tsx             — Cancellation UI
├── services/
│   └── trial_reminder.go               — T-7/T-3/T-1/T-0 reminder service
├── webhooks/
│   └── stripe_webhooks.go              — Stripe event handler
├── dashboard/
│   └── dispute_dashboard.go            — Chargeback monitoring
├── obsidian/
│   ├── Horizon ABA - Compliance Audit.md
│   ├── Horizon ABA - Session Log.md
│   └── Horizon ABA - HIPAA Requirements.md
├── graphify/
│   └── horizon_nodes.json              — Node/relationship map for Graphify
└── notebooklm/
    └── horizon_source.md               — This file
```

---

## Open Questions for Horizon Counselor
1. Does Horizon's specific data model constitute PHI under HIPAA?
2. What is the current federal standard for cancellation ease post-FTC rule vacatur?
3. Does Horizon's iOS app (if any) qualify for any DMA external payment exemption?
4. Do any Horizon clients involve minors — triggering COPPA?
5. Which states beyond CA and NY have active auto-renewal enforcement priority?

Full 13-question list in `docs/horizon-aba/legal/COUNSELOR_APPROVAL_PACKAGE.md` Section 2.
