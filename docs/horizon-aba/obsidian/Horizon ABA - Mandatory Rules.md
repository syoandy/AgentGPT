---
tags: [horizon-aba, rules, doctrine, mandatory, P0]
created: 2026-06-01
status: ACTIVE
binding_on: All Horizon entities, all sessions, all AI assistants
amendment: Founder + Counselor joint signature only
---

# Horizon Mandatory Rules

## Quick Reference

| # | Rule | One-line summary |
|---|---|---|
| 1 | Data Dictionary | No legal review without a complete data dictionary |
| 2 | Obsidian Sync | Every session ends with Obsidian synced or blocker documented |
| 3 | Blocker Documentation | Every blocker explicitly logged — no silent skips |
| 4 | Memory Order | Read context in the documented order before acting |
| 5 | Context-First | Check for existing artifacts before creating new ones |
| 6 | Handoff Completeness | Session not done until handoff checklist is complete |
| 7 | No Scatter | One system, one source of truth |
| 8 | Amendment | Founder + Counselor only |

## Two Newest Binding Rules (Session 7)

### Rule 1 — Data Dictionary
Before any HIPAA review, compliance audit, BAA execution, launch, acquisition,
or cross-product data sharing — the product's Data Dictionary must be complete.
Master template at `docs/horizon-aba/legal/HIPAA_DATA_DICTIONARY_TEMPLATE.md`.
Per-product instances at `docs/{product}/legal/DATA_DICTIONARY.md`.

### Rule 2 — Obsidian Sync
Every session must end with `Obsidian: ✅ synced` or `Obsidian: ⛔ BLOCKED — [reason]`
in the session log. Never silent. Recommended automation: Obsidian Git plugin
pointed at `syoandy/agentgpt`, branch `claude/create-feep-IU72S`.

## Source of Truth
Full rules: `docs/horizon-aba/MANDATORY_RULES.md` (8 rules, signatures pending)

## Related Notes
- [[Horizon Counselor - Authority Doctrine]]
- [[Horizon ABA - Session Log]]
- [[Horizon ABA - Compliance Audit]]
