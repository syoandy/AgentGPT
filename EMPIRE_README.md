# Yoandy OS Empire — Repository Navigation
**Repo:** `syoandy/agentgpt`  
**Empire branch:** `claude/create-feep-IU72S`  
**Founder:** Yoandy OS (Telegram: 8577755724 · Email: tuxpropertymanagement@gmail.com)  
**Status:** Pre-launch, Scalability Score 56/100

> This README is for empire navigation. The repo also contains the AgentGPT codebase (upstream project) — that's separate. Empire docs live under `docs/feep/`, `docs/horizon-aba/`, `docs/poolcurrent/`, and `scripts/`.

---

## START HERE

If you're new to the empire (founder, counselor, AI assistant, new hire):

1. **Read FEEP first:** `docs/feep/00_FEEP_MASTER.md`
2. **Then read Counselor Authority Doctrine:** `docs/horizon-aba/legal/COUNSELOR_AUTHORITY_DOCTRINE.md`
3. **Then read Mandatory Rules:** `docs/horizon-aba/MANDATORY_RULES.md`
4. **Then read the section below relevant to your role**

---

## DOCTRINE STACK (Empire-Wide)

| # | Document | Status |
|---|---|---|
| Master | [FEEP](docs/feep/00_FEEP_MASTER.md) | ✅ Founder signed |
| Authority | [Counselor Authority Doctrine](docs/horizon-aba/legal/COUNSELOR_AUTHORITY_DOCTRINE.md) | ✅ Founder signed |
| Rules | [Mandatory Rules](docs/horizon-aba/MANDATORY_RULES.md) | ✅ Founder signed |
| Succession | [Founder Succession Doctrine](docs/feep/08_FOUNDER_SUCCESSION_DOCTRINE.md) | ✅ Founder signed |
| Defense | [Legal Fortress Doctrine](docs/feep/legal-fortress/00_LEGAL_FORTRESS_DOCTRINE.md) | Operational |
| Template | [Universal Governance Template](docs/feep/01_UNIVERSAL_GOVERNANCE_TEMPLATE.md) | Operational |
| Template | [Universal App Build Doctrine](docs/feep/02_UNIVERSAL_APP_BUILD_DOCTRINE.md) | Operational |
| Template | [Universal Deployment Doctrine](docs/feep/03_UNIVERSAL_DEPLOYMENT_DOCTRINE.md) | Operational |
| Template | [Universal Audit Matrix](docs/feep/04_UNIVERSAL_AUDIT_MATRIX.md) | Operational |
| Template | [Cross-Company Isolation](docs/feep/05_CROSS_COMPANY_ISOLATION.md) | Operational |
| Template | [Future Company Onboarding](docs/feep/06_FUTURE_COMPANY_ONBOARDING.md) | Operational |
| Metric | [Empire Scalability Score](docs/feep/07_SCALABILITY_SCORE.md) | Active: 56/100 |

---

## ENTITY MAP

| Entity | Folder | Tier | Status |
|---|---|---|---|
| Horizon ABA Health | [docs/horizon-aba/](docs/horizon-aba/) | S (PHI) | Pre-launch — components built, awaiting wiring + Counselor approval |
| PoolCurrent | [docs/poolcurrent/](docs/poolcurrent/) | TBD | Skeleton only — awaiting Founder description |
| Legal Fortress | [docs/feep/legal-fortress/](docs/feep/legal-fortress/) | n/a | Operational defense doctrine |

---

## I'M THE FOUNDER, WHAT DO I DO NEXT?

Open the Founder Action Sheet: [docs/horizon-aba/FOUNDER_ACTION_SHEET.md](docs/horizon-aba/FOUNDER_ACTION_SHEET.md)

Current open actions:

| Action | Effort | Unlocks |
|---|---|---|
| 1. Designate Counselor | 5 min | ~12 score points |
| 3. Fill HIPAA Data Dictionary | 30 min | Counselor review unblocked |
| 4. Send Stripe BAA email | 2 min | Use `docs/horizon-aba/legal/ready-to-send/STRIPE_BAA_EMAIL.txt` |
| 5. Send Email Provider BAA email | 2 min | Use `docs/horizon-aba/legal/ready-to-send/POSTMARK_BAA_EMAIL.txt` |
| 6. Start new Claude session in `horizon-ab-health` | 5 min | Wires 5 components, finishes audit |
| 7. Counselor approves package | Counselor SLA | Final 4% to launch |

---

## I'M THE COUNSELOR, WHERE DO I START?

Open Counselor Onboarding: [docs/horizon-aba/templates/COUNSELOR_ONBOARDING.md](docs/horizon-aba/templates/COUNSELOR_ONBOARDING.md)

This walks you through:
- Reading order (6 doctrines)
- Your bar status decision
- First-week tasks
- How to issue determinations

When ready to respond to Horizon ABA approval package:
- Use template: [docs/horizon-aba/templates/COUNSELOR_DETERMINATION_TEMPLATE.md](docs/horizon-aba/templates/COUNSELOR_DETERMINATION_TEMPLATE.md)
- Package to review: [docs/horizon-aba/legal/COUNSELOR_APPROVAL_PACKAGE.md](docs/horizon-aba/legal/COUNSELOR_APPROVAL_PACKAGE.md)

---

## I'M A CLAUDE OR CHATGPT SESSION WORKING ON THE EMPIRE

Reading order (Mandatory Rule 4):
1. Horizon Vault (if accessible)
2. Obsidian (Horizon ABA folder)
3. Graphify (`docs/horizon-aba/graphify/horizon_nodes.json`)
4. NotebookLM (Horizon project sources)
5. Current handoffs (most recent entry in `docs/horizon-aba/SESSION_LOG.md`)
6. Current task specification (the message from Founder)

You must:
- Follow all 8 Mandatory Rules
- Document all blockers explicitly (Rule 3)
- End every session with handoff completeness (Rule 6)
- Sync to Obsidian (Rule 2) or document the blocker

If you need to wire components into `syoandy/horizon-ab-health`, use:
- [docs/horizon-aba/wiring-kit/NEW_SESSION_PROMPT.md](docs/horizon-aba/wiring-kit/NEW_SESSION_PROMPT.md)
- [docs/horizon-aba/wiring-kit/INTEGRATION_GUIDE.md](docs/horizon-aba/wiring-kit/INTEGRATION_GUIDE.md)
- [docs/horizon-aba/wiring-kit/checklist.md](docs/horizon-aba/wiring-kit/checklist.md)
- [docs/horizon-aba/wiring-kit/db_migration.sql](docs/horizon-aba/wiring-kit/db_migration.sql)

---

## SCRIPTS

| Script | Purpose | Cadence |
|---|---|---|
| [scripts/empire-status.sh](scripts/empire-status.sh) | Generates `docs/feep/audits/empire-status-{YYYY-MM-DD}.md` | On-demand |
| [scripts/cross-contamination-audit.sh](scripts/cross-contamination-audit.sh) | Quarterly per FEEP Article IV.5 | Quarterly |

---

## TEMPLATES

| Template | When To Use |
|---|---|
| [Counselor Determination Template](docs/horizon-aba/templates/COUNSELOR_DETERMINATION_TEMPLATE.md) | Counselor responds to any Approval Package |
| [Counselor Onboarding](docs/horizon-aba/templates/COUNSELOR_ONBOARDING.md) | New Counselor designation |
| [Truth Score Template](docs/horizon-aba/templates/TRUTH_SCORE_TEMPLATE.md) | Every production deploy (per FEEP III + IX) |
| [HIPAA Data Dictionary Template](docs/horizon-aba/legal/HIPAA_DATA_DICTIONARY_TEMPLATE.md) | Every Tier S entity |
| [Stripe BAA Email](docs/horizon-aba/legal/ready-to-send/STRIPE_BAA_EMAIL.txt) | Copy-paste-ready Stripe healthcare BAA request |
| [Postmark BAA Email](docs/horizon-aba/legal/ready-to-send/POSTMARK_BAA_EMAIL.txt) | Copy-paste-ready email provider BAA request |
| [ToS Subscription Language](docs/horizon-aba/legal/TOS_SUBSCRIPTION_LANGUAGE.md) | ROSCA-compliant subscription clauses |
| [Privacy Policy Health Data](docs/horizon-aba/legal/PRIVACY_POLICY_HEALTH_DATA.md) | HIPAA-aware privacy section |

---

## OBSIDIAN / GRAPHIFY / NOTEBOOKLM SYNC

- **Obsidian:** Auto-pulls from this branch every 30 min via Obsidian Git plugin. Files in [docs/horizon-aba/obsidian/](docs/horizon-aba/obsidian/).
- **Graphify:** Import [docs/horizon-aba/graphify/horizon_nodes.json](docs/horizon-aba/graphify/horizon_nodes.json) on changes (merge, not replace).
- **NotebookLM:** Upload [docs/horizon-aba/notebooklm/horizon_source.md](docs/horizon-aba/notebooklm/horizon_source.md) on changes.

---

## SESSION HISTORY

All AI assistant sessions logged in: [docs/horizon-aba/SESSION_LOG.md](docs/horizon-aba/SESSION_LOG.md)

Reading the most recent session is the fastest way to get current context.

---

## EMPIRE SCALABILITY SCORE

**Current: 56 / 100 (Survival Mode, improving)**

Run `./scripts/empire-status.sh` for live snapshot.

Path to 80+:
1. Designate Counselor (+~12 points)
2. Wire components into horizon-ab-health (+~5 points)
3. First Truth Score 100 deploy (+~5 points)
4. PoolCurrent activation (+~3 points)

See: [docs/feep/07_SCALABILITY_SCORE.md](docs/feep/07_SCALABILITY_SCORE.md)
