# Horizon Mandatory Rules
**Authority:** Founder + Counselor (Horizon Legal Fortress)  
**Binding on:** All Horizon entities, all sessions, all AI assistants (Claude, ChatGPT)  
**Created:** 2026-06-01  
**Status:** ACTIVE  
**Amendment:** Founder + Counselor joint signature only

---

## RULE 1 — DATA DICTIONARY REQUIREMENT

### 1.1 The Rule
**No Horizon product, audit, or legal review proceeds without a completed Data Dictionary.**

A Data Dictionary lists every field the product collects, where it's stored,
whether it's linked to an individual, and whether it's tied to treatment / health.
Without it, Counselor is guessing and legal determinations are unreliable.

### 1.2 When This Rule Triggers
- Before any HIPAA review
- Before any compliance audit completion
- Before any BAA execution
- Before any launch
- Before any acquisition integration
- Before any cross-product data sharing

### 1.3 What Counts As Complete
- [ ] Every field the product collects is listed (none omitted)
- [ ] Every third-party integration is listed
- [ ] Every data flow path is documented
- [ ] Founder has reviewed the actual data model and signed off on accuracy
- [ ] Counselor has reviewed and confirmed the dictionary is sufficient for legal determinations

### 1.4 Template
Master template: `docs/horizon-aba/legal/HIPAA_DATA_DICTIONARY_TEMPLATE.md`

Every Horizon product creates its own filled-in version at:
`docs/{product}/legal/DATA_DICTIONARY.md`

### 1.5 Enforcement
- Counselor must refuse to issue determinations without a complete Data Dictionary
- Founder must not authorize launch without a complete Data Dictionary
- AI assistants (Claude, ChatGPT) working on legal/compliance matters must
  refuse to provide compliance opinions until the Data Dictionary is complete
- Sessions blocked on this requirement must log it explicitly per Rule 3

---

## RULE 2 — OBSIDIAN SYNC REQUIREMENT

### 2.1 The Rule
**Every Horizon work session must end with Obsidian synced.**

Obsidian is the project memory. Without sync, future Claude and ChatGPT sessions
will not know what was decided. Decisions get duplicated. Audits get re-done.
Contradictions creep in.

### 2.2 What "Synced" Means
After every session, the Horizon Obsidian vault must contain:
- Updated session log
- Updated decision records (if any decisions were made)
- Updated architecture notes (if architecture changed)
- Updated audit notes (if audits ran)
- All new files mirrored from `docs/horizon-aba/obsidian/` into the vault

### 2.3 How To Sync

**Option A — Automated (Recommended)**
Install Obsidian Git plugin → point at `syoandy/agentgpt` → enable auto-pull
on Obsidian launch. After this is set up, sync happens automatically every
time Obsidian opens.

**Option B — Manual**
Copy files from `docs/horizon-aba/obsidian/` into Obsidian vault folder
`/Horizon ABA/` after every session.

### 2.4 Enforcement
- Every session in SESSION_LOG.md must end with a sync status line:
  - `Obsidian: ✅ synced` — completed
  - `Obsidian: ⛔ BLOCKED — [reason]` — explicit blocker recorded
  - Never silent. Never "skipped without comment."
- AI assistants must include this status in every session handoff
- Founder confirms sync on session close

### 2.5 If Obsidian Is Unavailable
- AI assistant produces drop-in files in `docs/horizon-aba/obsidian/`
- Session log documents the blocker
- Founder syncs manually when access is restored
- Work continues — never silently skip the update

---

## RULE 3 — BLOCKER DOCUMENTATION

### 3.1 The Rule
**Every blocker must be explicitly documented. No silent skips.**

### 3.2 What Counts As A Blocker
- A required system is unavailable (Obsidian, Graphify, NotebookLM, GitHub MCP)
- A required input is missing (Data Dictionary, Counselor signature, BAA)
- A required approval is pending (Counselor determination, Founder co-sign)
- Code access is restricted (e.g., session not scoped to required repo)

### 3.3 Required Documentation Format
For every blocker, the session log must contain:

```
Blocker:     [what is blocked]
System:      [which system / artifact / approval]
Status:      [BLOCKED / PENDING / WAITING]
Reason:      [why]
Resolution:  [what unblocks it]
Owner:       [who can unblock — Founder / Counselor / Engineering / External]
```

### 3.4 Enforcement
- No session is "complete" with undocumented blockers
- AI assistants must list all blockers before declaring session done
- Counselor reviews open blockers in every legal package
- Founder reviews open blockers before authorizing any launch

---

## RULE 4 — HORIZON MEMORY ORDER

### 4.1 The Reading Order
Every Horizon session must read context in this order:

1. **Horizon Vault** (if accessible)
2. **Obsidian** (Horizon ABA folder)
3. **Graphify** (`graphify/horizon_nodes.json`)
4. **NotebookLM** (Horizon project sources)
5. **Current handoffs** (SESSION_LOG.md most recent session)
6. **Current task specification** (the message from Founder)

### 4.2 Why
Reading in this order prevents duplicate work, contradictions, and
re-implementation of already-decided architecture.

### 4.3 Enforcement
- AI assistants must check existing work before creating new artifacts
- Counselor must check prior determinations before issuing new ones
- New artifacts must reference what they supersede if anything

---

## RULE 5 — CONTEXT-FIRST CHECK

### 5.1 The Rule
**Before creating a new feature, audit, document, specification, or workflow,
check whether an equivalent already exists.**

### 5.2 Where To Check
- Obsidian vault
- Graphify node map (`horizon_nodes.json`)
- NotebookLM project sources
- Existing `docs/horizon-aba/` files
- Horizon repository code

### 5.3 What To Do If A Duplicate Exists
- Reference and update the existing artifact instead of creating a new one
- If the existing artifact is wrong, supersede it explicitly with a dated revision
- Document the supersession in SESSION_LOG.md

### 5.4 Enforcement
- AI assistants must run this check before any "create new X" task
- Reviewer (Counselor / Founder) rejects duplicate artifacts
- This rule applies across the full Horizon empire, not just one product

---

## RULE 6 — HANDOFF COMPLETENESS

### 6.1 The Rule
A session is not complete until the handoff package contains all of:

- [ ] Obsidian updated (or blocker documented per Rule 3)
- [ ] Graphify updated (or blocker documented per Rule 3)
- [ ] NotebookLM updated or considered (or blocker documented per Rule 3)
- [ ] Verification evidence logged
- [ ] Files changed logged
- [ ] Remaining gaps logged
- [ ] Next milestone set

### 6.2 Enforcement
- AI assistants must produce this checklist at the end of every session
- Founder verifies completeness before closing the session

---

## RULE 7 — NO SCATTER

### 7.1 The Rule
**One system, one source of truth.**

All Horizon ABA Health work lives in:
- Repo: `syoandy/agentgpt` (interim) → `syoandy/horizon-ab-health` (target)
- Branch: `claude/create-feep-IU72S` (interim)
- Folder: `docs/horizon-aba/`

Do not create parallel systems, duplicate folders, or alternative branches
without Founder + Counselor approval.

### 7.2 Enforcement
- AI assistants check existing folder structure before creating new top-level folders
- Founder rejects scattered systems

---

## RULE 8 — AMENDMENT PROTOCOL

These rules may be amended only by:
- Founder + Counselor joint signature, OR
- Founder solo override (Emergency Article IV from Counselor Authority Doctrine)

Amendments recorded in SESSION_LOG.md with date and signatures.
Prior versions retained in git history.

---

## RULE INDEX QUICK REFERENCE

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

---

## SIGNATURES

```
Founder:     Yoandy OS (Telegram ID: 8577755724)
Date:        2026-06-02
Signature:   Yoandy OS  ✅ SIGNED

Counselor:   Horizon Counselor (Not bar-admitted, per Counselor Doctrine VI.3)
Date:        2026-06-02
Signature:   Horizon Counselor  ✅ SIGNED
```

Rules take effect on Founder signature. Counselor signature confirms enforcement authority.
