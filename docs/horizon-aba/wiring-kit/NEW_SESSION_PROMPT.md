# Paste This Into The New Claude Session

When you start a fresh Claude Code session pointed at `syoandy/horizon-ab-health`,
paste the prompt below as your first message. This gives the new Claude every piece
of context it needs and ensures it follows Horizon Mandatory Rules.

---

## COPY EVERYTHING BELOW THIS LINE ⬇️

```
HORIZON SESSION CONTEXT

Founder:           Yoandy OS (Telegram ID: 8577755724)
Repo:              syoandy/horizon-ab-health
Branch to create:  claude/wire-compliance-components
Authority:         Horizon Counselor (per COUNSELOR_AUTHORITY_DOCTRINE.md in agentgpt repo)
Rules:             Horizon Mandatory Rules (per MANDATORY_RULES.md in agentgpt repo)

CONTEXT FROM PRIOR SESSIONS

Prior work was done in syoandy/agentgpt on branch claude/create-feep-IU72S in
docs/horizon-aba/. That folder contains:

- 5 compliance components ready to wire into THIS repo
- Compliance audit + legal pack + Counselor doctrine
- Mandatory Rules (binding on this session too)
- Full wiring kit at docs/horizon-aba/wiring-kit/

READ THESE FIRST (per Horizon Memory Order, Rule 4)
You will need to read them from syoandy/agentgpt branch claude/create-feep-IU72S.
If you cannot read from agentgpt, ask Founder to copy them in or extend session scope.

Required reading:
1. docs/horizon-aba/MANDATORY_RULES.md (8 binding rules)
2. docs/horizon-aba/wiring-kit/INTEGRATION_GUIDE.md (your runbook)
3. docs/horizon-aba/wiring-kit/checklist.md (your done-criteria)
4. docs/horizon-aba/SUBSCRIPTION_COMPLIANCE_AUDIT.md (the audit being closed)

YOUR JOB

1. Create branch claude/wire-compliance-components in horizon-ab-health
2. Audit the existing Horizon codebase against SUBSCRIPTION_COMPLIANCE_AUDIT.md
3. Wire in the 5 components from docs/horizon-aba/:
   - components/SubscriptionDisclosure.tsx
   - components/CancellationFlow.tsx
   - services/trial_reminder.go
   - webhooks/stripe_webhooks.go
   - dashboard/dispute_dashboard.go
4. Replace all 🔍 NEEDS CODE REVIEW items in the audit with PASS / FAIL / PARTIAL
   based on what you find in the actual code
5. Follow INTEGRATION_GUIDE.md step by step
6. Update SESSION_LOG.md following Rule 6 (Handoff Completeness)
7. Commit and push branch
8. Open a PR to main (or whatever the default branch is) when components are wired

CRITICAL RULES (PARTIAL LIST — READ MANDATORY_RULES.md FOR FULL)

- Rule 1: No legal review without a complete Data Dictionary — flag if missing
- Rule 2: End session with Obsidian sync status (synced or BLOCKED with reason)
- Rule 3: Document every blocker — no silent skips
- Rule 5: Check for existing components before creating new ones (Context-First)
- Rule 6: Session not complete until handoff checklist is done
- Rule 7: No scatter — keep everything in one place
- Counselor must approve any change to public-facing legal artifacts (ToS, Privacy)

If anything is unclear, ASK before acting. Do not assume.

START
```

## COPY EVERYTHING ABOVE THIS LINE ⬆️

---

## What to do after pasting

1. Send the prompt
2. The new Claude will start reading and asking clarifying questions
3. Answer them — most should be obvious (yes/no, file paths, etc.)
4. Watch it work — it commits to its own branch, not main
5. When it opens a PR, review it before merging
