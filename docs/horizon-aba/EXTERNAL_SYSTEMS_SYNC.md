# External Systems Sync — Horizon AB Health
**Branch:** claude/create-feep-IU72S  
**Updated:** 2026-06-01  
**Status:** ⛔ ALL THREE SYSTEMS BLOCKED — No API access from this sandbox

---

## BLOCKER PRIORITY: HIGH
These are not optional documentation steps.
Obsidian, Graphify, and NotebookLM are the project memory.
Until they are updated, no session is considered fully complete.

---

## SYSTEM 1 — OBSIDIAN

**Status:** ⛔ BLOCKED — Obsidian vault not accessible from this sandbox  
**What's needed:** Obsidian vault path on your local machine or a sync plugin (e.g. Obsidian Git) pointed at this repo  
**Resolution:** Drop the files below into your vault manually, or connect Obsidian Git to this branch

### How to resolve
Option A (easiest): Install the **Obsidian Git** plugin → point it at `syoandy/agentgpt` → it auto-pulls `docs/horizon-aba/` into your vault on every sync.  
Option B: Manually copy the files in `docs/horizon-aba/obsidian/` into your vault.

### Files ready to drop into Obsidian
→ See `docs/horizon-aba/obsidian/` folder (created below)

---

## SYSTEM 2 — GRAPHIFY

**Status:** ⛔ BLOCKED — No Graphify API or MCP tool available  
**What's needed:** Graphify API key + endpoint, or manual import  
**Resolution:** Import the JSON node/relationship file below into Graphify

### Files ready to import into Graphify
→ See `docs/horizon-aba/graphify/horizon_nodes.json`

---

## SYSTEM 3 — NOTEBOOKLM

**Status:** ⛔ BLOCKED — NotebookLM has no API, manual upload only  
**What's needed:** Manual upload of source documents to your NotebookLM project  
**Resolution:** Upload the file below to your Horizon NotebookLM project as a source

### Files ready to upload to NotebookLM
→ See `docs/horizon-aba/notebooklm/horizon_source.md`

---

## SYNC CHECKLIST — Run After Every Session

After Claude completes any Horizon session:

- [ ] Pull latest from branch `claude/create-feep-IU72S`
- [ ] Copy `docs/horizon-aba/obsidian/*.md` → your Obsidian vault `/Horizon ABA/`
- [ ] Import `docs/horizon-aba/graphify/horizon_nodes.json` → Graphify (merge, not replace)
- [ ] Upload `docs/horizon-aba/notebooklm/horizon_source.md` → NotebookLM project source
- [ ] Mark session complete in SESSION_LOG.md

---

## WHY THIS MATTERS

Without these updates:
- Future Claude sessions will not know what was decided
- Future ChatGPT sessions will not know what was built
- Decisions will be duplicated or contradicted
- Compliance audit findings will be re-done from scratch

This is the project memory. Keep it current.
