# FEEP — Founder Empire Execution Protocol
**Master Doctrine of the Yoandy OS Empire**  
**Version:** 1.0  
**Effective:** Upon Founder + Counselor signature  
**Binding on:** All Horizon entities, PoolCurrent, Legal Fortress, all future SaaS, trusts, licensing structures, and acquisitions  
**Amendment:** Article XV procedure only

---

# ARTICLE I — FOUNDER SUPREMACY

## 1.1 The Founder
The Empire has one Founder.
- Name: Yoandy OS
- Telegram ID: 8577755724
- Authority: Absolute and irrevocable except by death, written succession, or Article XV self-amendment

## 1.2 Founder Powers (Standing, No Approval Required)
- Final authority on all matters across all entities
- Veto over any decision by any board, officer, or AI assistant
- Sole owner of empire-level strategy
- Sole authority to designate or replace Counselor
- Sole authority to acquire, divest, or dissolve any entity
- Sole authority to amend FEEP via Article XV

## 1.3 Founder Bottleneck Prevention
To prevent the Founder from becoming a single point of failure:
- All standing decisions are delegated to officers per Article II
- Founder only steps in for: doctrine changes, acquisitions, litigation, settlements >$10k, customer data sale (auto-veto), and emergency override
- Routine operations never wait for Founder

---

# ARTICLE II — BOARD AND OFFICER HIERARCHY

## 2.1 Official Roles (Empire-Wide)

| Role | Authority | Reports To |
|---|---|---|
| Founder | Absolute | None |
| Counselor | Supreme legal authority (per Counselor Authority Doctrine) | Founder |
| Chief of Staff | Operational coordination across entities | Founder |
| Entity Lead (per company) | Day-to-day operations of that entity | Chief of Staff or Founder |
| Security Officer | Empire-wide security policy | Founder |
| Finance Officer | Financial movement, banking, treasury | Founder |
| Engineering Lead | Code, deployment, infrastructure | Entity Lead |
| AI Assistants (Claude, ChatGPT) | Execute under Founder + Counselor doctrine | Whoever invoked them |

## 2.2 Decision Routing
```
Operational decision → Entity Lead → resolves
Cross-entity decision → Chief of Staff → resolves
Legal decision → Counselor → resolves (or escalates per Article V of Counselor Doctrine)
Financial decision (above threshold) → Founder + Finance Officer
Strategic decision → Founder
```

## 2.3 No Decisions In The Air
Every decision has exactly one owner. If ownership is unclear, decision halts until Founder assigns.

---

# ARTICLE III — UNIVERSAL DEPLOYMENT TRUTH SYSTEM

## 3.1 The Three-Source Truth Rule
A claim about production is true only if confirmed by all three of:
1. **Code** — what the source repository contains on the deployed branch
2. **Infrastructure** — what is actually running (containers, processes, DNS, certs)
3. **Behavior** — what an end user actually experiences

If any of the three disagrees, the system is **not deployed**, regardless of intermediate "success" messages.

## 3.2 Banned Phrases (For AI Assistants)
AI assistants must never claim "deployed", "live", "shipped", or "in production" based on:
- "Build succeeded"
- "Tests passed"
- "PR merged"
- "Pushed to main"

These are necessary but not sufficient. Verification requires Article III.1.

## 3.3 Production Truth Score
For any feature claimed deployed, the Truth Score is:
```
Truth Score = (code_verified + infra_verified + behavior_verified) / 3 * 100
```
- 100% = deployed
- 67% = staged, not deployed
- 33% = partial
- 0% = not deployed

Truth Score is recorded in the entity's SESSION_LOG for every release.

---

# ARTICLE IV — CROSS-PROJECT CONTAMINATION PREVENTION

## 4.1 Hard Isolation Rules
Each entity is its own logical island:
- Own repository
- Own database
- Own secrets / API keys
- Own customer base
- Own legal entity (where applicable)
- Own brand and domain

## 4.2 No Shared Production Resources
The following are NEVER shared across entities:
- Database connections
- Stripe accounts
- Email provider accounts (BAAs are entity-scoped)
- Cloud storage buckets containing customer data
- Domains and subdomains (with explicit exceptions per Article IV.4)
- Customer authentication systems

## 4.3 Permitted Shared Resources
The following MAY be shared:
- Founder identity (single Telegram ID, single email)
- Counselor (same person across entities, per Counselor Doctrine 8.3)
- Doctrine documents (FEEP applies to all)
- Internal tools and AI assistants
- Banking entity (one ownership entity)

## 4.4 Brand-Level Exceptions
If two entities are part of the same brand family, they may share:
- DNS records under one root domain (with subdomain separation)
- Marketing site infrastructure
- Identity provider (with strict tenant isolation)

Exceptions are documented in `docs/feep/exceptions/{entity-pair}.md`

## 4.5 Cross-Contamination Detection
Quarterly audit verifies:
- No entity's data appears in another entity's DB
- No entity's API key is committed in another entity's repo
- No customer record exists in two entities

Findings recorded in `docs/feep/audits/cross-contamination-{YYYY-Q}.md`

---

# ARTICLE V — SECURITY TIER DOCTRINE BY INDUSTRY

## 5.1 Tier Definitions

| Tier | Industry | Required Controls |
|---|---|---|
| **Tier S** | Healthcare (PHI), Banking, Children's services | HIPAA Security Rule + SOC 2 + BAAs + encryption at rest/transit + audit logging + breach notification + Counselor signoff before launch |
| **Tier A** | Payments, B2B SaaS handling PII, Financial services | SOC 2 prep + encryption + MFA enforced + Counselor signoff before launch |
| **Tier B** | Consumer SaaS handling PII, B2B SaaS no PII | TLS everywhere + MFA available + secrets in vault + Counselor signoff before launch |
| **Tier C** | Marketing sites, content products, no user data | Standard web hardening |

## 5.2 Tier Assignment Per Entity

| Entity | Tier | Rationale |
|---|---|---|
| Horizon ABA Health | **S** | ABA therapy = PHI under HIPAA |
| PoolCurrent | **TBD** | Counselor to determine based on data model |
| Future SaaS products | Assessed at onboarding (Article XIII) | |
| Marketing sites | C | |

## 5.3 Tier Upgrade Required When
- Product begins collecting new data type that triggers higher tier
- Product enters a regulated industry
- Product reaches user count thresholds (>10k = re-evaluate)
- Product launches in new geography (EU = GDPR triggers re-eval)

## 5.4 Tier Downgrade Forbidden
Once an entity is assigned a tier, it cannot downgrade — only upgrade.

---

# ARTICLE VI — FINANCIAL MOVEMENT DOCTRINE

## 6.1 Banking Architecture
- One holding company at top
- Each operating entity has its own bank account
- No commingling of operating funds across entities
- Founder is signatory on all accounts
- Finance Officer co-signs above thresholds per Article VI.3

## 6.2 Money Flow Rules
- Customer payments → Entity Stripe account → Entity bank account
- Operating expenses → paid from entity bank account
- Profit distributions → from entity to holding (documented, taxed)
- No entity-to-entity loans without written agreement and interest
- No personal Founder withdrawals from entity accounts (use distribution)

## 6.3 Approval Thresholds

| Amount | Approval |
|---|---|
| < $1,000 | Entity Lead alone |
| $1,000 – $10,000 | Entity Lead + Finance Officer |
| $10,000 – $50,000 | Counselor + Finance Officer |
| > $50,000 | Founder co-sign required |
| Any wire transfer | Founder approval, regardless of amount |
| Any crypto transfer | Founder approval, regardless of amount |

## 6.4 Forbidden Movements
- Cash transactions > $10,000 without IRS Form 8300 filing
- International wires to unverified counterparties
- Crypto from anonymized sources
- Any transaction lacking written purpose

## 6.5 Treasury Holdings
- Minimum 6 months operating runway held per entity
- Excess profit → distributed to holding per quarter
- Holding maintains 12 months consolidated runway minimum

---

# ARTICLE VII — LEGAL COMPLIANCE CHAIN

## 7.1 Compliance Floor (All Entities)
- Federal: applicable federal law per industry (HIPAA, ROSCA, FTC, COPPA, etc.)
- State: laws of any state where customers reside
- International: GDPR if EU users, UK GDPR if UK users
- Counselor maintains the compliance matrix per entity

## 7.2 Documentation Required Per Entity
- Terms of Service (Counselor-approved)
- Privacy Policy (Counselor-approved)
- Cookie Policy (if cookies used)
- BAAs (if Tier S)
- DPAs (if EU users)
- Insurance certificates (E&O, cyber, general liability)
- Articles of Incorporation / formation docs
- Operating Agreement (if LLC)
- IP assignments from contributors
- Founder Employment Agreement (if W-2 from entity)

## 7.3 Counselor Approval Gate
Per Counselor Authority Doctrine: no entity launches without Counselor sign-off.

---

# ARTICLE VIII — AUTOMATION VALIDATION LAW

## 8.1 The Rule
No automated process may run in production without:
1. Code review by a human (Founder, Engineering Lead, or Counselor depending on domain)
2. Test coverage for the happy path AND named failure modes
3. Monitoring + alerting on failure
4. Documented rollback procedure
5. Owner of record (one person)

## 8.2 AI Assistant Automation
AI assistants (Claude, ChatGPT, etc.) acting on behalf of entities must:
- Identify themselves in commits and audit logs
- Operate under named user (founder or specific delegate) with that user's authority, no more
- Not commit to main / production branches directly
- Not approve their own PRs
- Not delete data or branches without explicit human confirmation
- Refuse to violate FEEP, even if instructed to do so

## 8.3 Banned Automations
- Automated tweets / public statements without human review
- Automated emails to >100 recipients without human review
- Automated financial transactions above Article VI.3 thresholds
- Automated legal document signing
- Automated customer data deletion (except per documented retention policy)
- Automated production deploys without Article III verification

---

# ARTICLE IX — PRODUCTION TRUTH SCORING

## 9.1 Truth Score Cadence
- Every production deploy → Truth Score calculated and logged
- Weekly → all entities' current Truth Score summarized in empire dashboard
- Quarterly → Counselor reviews scores for compliance reporting

## 9.2 Required Evidence (Per Score)
- Code: commit SHA on deployed branch
- Infra: live URL + cert validity + service health endpoint
- Behavior: screenshot or automated test of end-user flow

Stored in `docs/{entity}/truth-scores/{YYYY-MM-DD}-{feature}.md`

## 9.3 Score Below 100 = Not Done
A feature with Truth Score < 100 is "in progress", never "complete". This is a hard rule.

---

# ARTICLE X — UNIVERSAL COMPANY LAUNCH SEQUENCE

## 10.1 Phase 0 — Founder Decision
- Founder declares intent to launch a new entity
- Working name assigned
- Industry assessed → Security Tier assigned per Article V.2

## 10.2 Phase 1 — Legal Formation
- Entity formation (LLC or C-Corp, per Counselor recommendation)
- EIN obtained
- Bank account opened
- Stripe account opened (Healthcare tier if Tier S)
- Insurance acquired

## 10.3 Phase 2 — Doctrine Adoption
- Entity creates `docs/{entity}/` folder in entity repo
- Copies FEEP, Counselor Doctrine, Mandatory Rules by reference (not duplication)
- Creates entity-specific implementation docs (SUBSCRIPTION_COMPLIANCE_AUDIT.md style)
- Counselor reviews and approves

## 10.4 Phase 3 — Build
- Codebase created per Article XI (Universal App Build Doctrine)
- Components built (subscription, cancellation, disclosures, reminders if applicable)
- Tests written
- CI/CD configured

## 10.5 Phase 4 — Pre-Launch Approval
- Founder fills Data Dictionary
- Counselor reviews Approval Package
- BAAs executed (if Tier S)
- ToS and Privacy Policy published
- Truth Score = 100 verified

## 10.6 Phase 5 — Launch
- First customer onboarded
- Monitoring active
- Dispute monitoring active (if billing)
- Session log marks launch date

## 10.7 Phase 6 — Steady State
- Quarterly Counselor compliance reviews
- Quarterly Truth Score audit
- Quarterly Cross-Contamination audit (Article IV.5)

---

# ARTICLE XI — UNIVERSAL ACQUISITION INTEGRATION SEQUENCE

## 11.1 Pre-Acquisition Due Diligence
Before signing:
- Acquired entity's tech stack assessed
- Acquired entity's data audited (PII / PHI / regulated data)
- Acquired entity's customer agreements reviewed
- Acquired entity's outstanding legal matters reviewed
- Counselor produces written go/no-go recommendation

## 11.2 Post-Acquisition Integration

### Day 1
- Founder confirms ownership transfer in writing
- Acquired entity's bank accounts re-signatory'd to Founder
- Acquired entity's domains transferred
- Acquired entity's cloud accounts re-rooted

### Week 1
- Cross-Contamination audit run — find any data overlap with existing entities
- Acquired entity's customers notified per ToS/Privacy Policy
- Acquired entity's BAAs reviewed and re-executed if needed
- Acquired entity's tier assigned per Article V

### Month 1
- Acquired entity's codebase merged into empire repo structure
- Acquired entity's CI/CD migrated to empire standards
- Acquired entity's session log started under FEEP rules

### Month 3
- Full FEEP compliance verified
- Counselor signs off integration complete
- Acquired entity reaches Truth Score 100

## 11.3 Acquisition Veto Conditions
Founder MUST veto acquisition if:
- Acquired entity has pending HIPAA breach (Tier S only)
- Acquired entity has pending FTC investigation
- Acquired entity has customer data of unknown provenance
- Acquired entity's owner refuses standard reps and warranties
- Acquired entity's financials lack 2+ years of audited records

---

# ARTICLE XII — AUDIT AND CONTRADICTION DETECTION

## 12.1 Quarterly Audits (Per Entity)
1. **Compliance audit** — Counselor verifies legal posture
2. **Security audit** — Security Officer verifies controls per Tier
3. **Cross-Contamination audit** — verifies isolation per Article IV
4. **Truth Score audit** — verifies production matches code
5. **Financial audit** — Finance Officer verifies books

## 12.2 Annual Audits (Empire-Wide)
1. **Doctrine consistency audit** — finds contradictions between FEEP and entity-level docs
2. **Counselor effectiveness audit** — measures escalation rate, approval cycle time
3. **AI assistant audit** — reviews work produced by Claude/ChatGPT sessions

## 12.3 Contradiction Detection
When two documents disagree:
- FEEP > Counselor Authority Doctrine > Mandatory Rules > Entity-specific doctrine > Session logs
- Lower documents must be amended to align with higher within 30 days of detection
- Founder may override the hierarchy only via Article XV self-amendment

---

# ARTICLE XIII — FUTURE COMPANY ONBOARDING FRAMEWORK

Companion document: `docs/feep/06_FUTURE_COMPANY_ONBOARDING.md`

In summary:
1. Industry assessment + Tier assignment
2. Legal formation
3. Doctrine adoption (by reference)
4. Build per Universal App Build Doctrine
5. Pre-launch Counselor approval
6. Launch
7. Steady-state audits

---

# ARTICLE XIV — OPERATIONAL CHAIN OF COMMAND

## 14.1 Daily Operations
- Entity Lead has full operational authority within their entity
- Cross-entity coordination → Chief of Staff
- AI assistants serve under whoever invoked them, but always under FEEP

## 14.2 Crisis Response
- Tier 1 (data breach, regulatory inquiry, lawsuit) → Counselor takes operational control, Founder notified within 4 hours
- Tier 2 (production outage, key personnel issue) → Entity Lead with Chief of Staff support, Founder notified within 24 hours
- Tier 3 (routine bug, vendor issue) → Entity Lead, no Founder notification needed

## 14.3 Handoff Between AI Sessions
- ChatGPT → Claude or vice versa → handoff via SESSION_LOG.md
- Reading order: per Horizon Memory Order (Mandatory Rule 4)
- AI must check existing decisions before generating new ones (Mandatory Rule 5)
- AI must document blockers explicitly (Mandatory Rule 3)

---

# ARTICLE XV — AMENDMENT PROTOCOL

## 15.1 Who Can Amend
- Founder + Counselor joint signature, OR
- Founder solo override (Emergency, per Counselor Authority Doctrine Article IV)

## 15.2 How
- Amendment recorded in `docs/feep/amendments/{YYYY-MM-DD}-{title}.md`
- Affected articles in FEEP updated to reference amendment
- SESSION_LOG.md gets entry
- Amendments take effect on signature date

## 15.3 Prior Versions
- Retained in git history
- Active version is whatever is on `main` of the empire repo

---

# ARTICLE XVI — EXPANSION RULES

## 16.1 New Entity Trigger
Founder may launch new entity when:
- A new market opportunity is identified
- Tier separation requires isolation (cannot mix Tier S with Tier B in same legal entity)
- Acquisition makes operational sense
- Tax / legal structure benefits warrant separation

## 16.2 Hard Caps
- Maximum 7 active entities under Founder's direct attention
- Beyond 7: empire must hire a President or COO before adding more

## 16.3 Discontinuation
An entity may be discontinued if:
- Founder declares so in writing
- Counselor verifies no outstanding legal obligations
- All customers refunded or migrated per ToS
- Books closed per Finance Officer
- Entity formally dissolved per state law

---

# ARTICLE XVII — EMERGENCY OVERRIDE DOCTRINE

## 17.1 Founder Emergency Override
In any crisis, Founder may override any FEEP article via:
1. Written declaration (email, Telegram message, or commit)
2. Statement of which article(s) overridden
3. Acceptance of responsibility
4. Filed in SESSION_LOG.md within 24 hours

## 17.2 Counselor Emergency Powers
Per Counselor Authority Doctrine Article IV:
- Take-down compromised systems without pre-approval
- Initiate breach notifications
- Engage external counsel for crisis response
- Notify Founder within 4 hours

## 17.3 AI Assistant Emergency Behavior
In any situation where an AI assistant detects:
- Customer data exposure
- Financial fraud signal
- Regulatory inquiry mid-session
- Security vulnerability with active exploit

The AI must:
- Halt the current task
- Alert the user (Founder) immediately
- Log to SESSION_LOG.md
- Refuse to continue until Founder confirms

---

# ARTICLE XVIII — DOCTRINE STACK

FEEP is the apex. Below it:

```
FEEP (this document) — Empire-wide
├── Counselor Authority Doctrine — legal authority
├── Mandatory Rules — operational rules
│
├── Universal Governance Template — applied to each entity
├── Universal App Build Doctrine — code/architecture
├── Universal Deployment Doctrine — release process
├── Universal Audit Matrix — what to audit, when
├── Cross-Company Isolation — Article IV expanded
├── Future Company Onboarding — Article XIII expanded
└── Scalability Score — final empire metric

Per-entity implementations:
├── docs/horizon-aba/ — first implementation
├── docs/poolcurrent/ — to be created
└── docs/{future-entity}/ — created at Phase 0
```

---

# SIGNATURES

```
Founder:               Yoandy OS
Founder Telegram ID:   8577755724
Founder Email:         tuxpropertymanagement@gmail.com
Date:                  2026-06-02
Founder signature:     Yoandy OS  ✅ SIGNED

Counselor:             Horizon Counselor
Counselor designation: General Counsel
Bar status:            Not bar-admitted (per Counselor Doctrine Article VI.3)
Date:                  2026-06-02
Counselor signature:   Horizon Counselor  ✅ SIGNED
```

---

# EFFECTIVE DATE

**FEEP is in effect as of 2026-06-02** — fully signed by both Founder and Counselor.

This doctrine binds all Horizon entities, PoolCurrent (the pool app, isolated from Horizon),
all future SaaS, all trusts, all licensing structures, all acquisitions, and all AI assistants
working on empire matters.
