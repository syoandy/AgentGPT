# Cross-Company Isolation Enforcement
**Parent doctrine:** FEEP Article IV  
**Applies to:** All inter-entity boundaries

This document operationalizes FEEP Article IV: each entity is its own logical island.

---

## 1. ISOLATION DOMAINS

| Domain | Required Isolation Level | Rationale |
|---|---|---|
| Customer data | HARD (no overlap) | Privacy, GDPR, HIPAA |
| Authentication | HARD (separate identity stores) | Blast radius |
| Databases | HARD (separate clusters or schemas) | Data security |
| Stripe accounts | HARD (one per entity) | Money trail, BAA scoping |
| Email providers | HARD (separate sender domains) | BAA scoping, reputation |
| API keys + secrets | HARD (separate vaults per entity) | Blast radius |
| Domain / DNS | SOFT (shared root OK, subdomain isolation required) | Brand efficiency |
| Marketing pixels | SOFT (separate Pixel IDs per entity) | Attribution + privacy |
| Founder identity | SHARED (one Yoandy OS) | Single owner |
| Counselor | SHARED (one Counselor) | Single legal authority |
| Doctrine documents | SHARED (FEEP applies to all) | Consistency |
| Banking entity | SHARED (one holding) | Tax + ownership efficiency |

---

## 2. HARD ISOLATION ENFORCEMENT

### 2.1 Customer Data
- No two entities share a customer table
- A person who is a customer of two entities exists as two separate records
- Cross-selling between entities requires explicit opt-in per entity (per ToS / Privacy Policy)
- No data joins across entity boundaries without Counselor approval + customer consent

### 2.2 Authentication
- Each entity has its own identity provider tenant
- Users authenticating to Entity A cannot use that session at Entity B
- SSO across entities is forbidden unless Counselor + Founder approve in writing per entity pair

### 2.3 Databases
- Separate DB clusters preferred
- If shared cluster: separate schemas + separate DB users + separate connection strings
- Backup files isolated (no entity can restore another entity's backup by accident)
- Production DB credentials never shared across entities

### 2.4 Stripe
- One Stripe account per entity
- Healthcare tier required for Tier S entities (separate from non-Tier-S entities)
- Webhooks signed with entity-specific secrets
- Refunds processed only against the entity's own Stripe account

### 2.5 Email Providers
- Separate sender domain per entity (e.g., mail.horizonhealth.com, mail.poolcurrent.com)
- Separate BAA per entity (BAAs are entity-scoped)
- Separate suppression lists (no entity should email another's unsubscribed users)

### 2.6 API Keys + Secrets
- Separate Vault / Secrets Manager namespaces per entity
- No engineer has rotation access to multiple entities' secrets without documented reason
- Tier S: secret access is audit-logged with entity attribution

---

## 3. SOFT ISOLATION ENFORCEMENT

### 3.1 Domain / DNS
- Brand family may share root domain
- Subdomain isolation required:
  - app.entity1.com → entity1 infra
  - app.entity2.com → entity2 infra
- DNS records attributed in DNS provider (not mixed across accounts)
- Tier S: DNS provider must be HIPAA-eligible

### 3.2 Marketing Pixels
- Separate Pixel / Tag Manager containers per entity
- No cross-entity remarketing without explicit ToS/Privacy disclosure + customer consent

---

## 4. SHARED RESOURCE GOVERNANCE

### 4.1 Founder Identity
- Yoandy OS appears as signatory on all entity bank accounts, Stripe, hosting
- Telegram ID 8577755724 is the canonical founder authentication
- No other person inherits this access except via documented succession

### 4.2 Counselor
- One Counselor across the empire (per Counselor Doctrine 8.3)
- Counselor's bar status applies empire-wide
- Counselor maintains separate determinations per entity (no shortcutting)

### 4.3 Doctrine Documents
- FEEP, Counselor Doctrine, Mandatory Rules, Universal templates apply to all entities
- Stored in single canonical location: `docs/feep/` in the empire reference repo
- Entities reference by URL/SHA, do not copy + modify

### 4.4 Banking
- One holding entity owns all operating entities
- Holding has its own books separate from operating entities
- Distributions from operating to holding are documented, taxed events
- No operating-to-operating loans without written agreement + interest

---

## 5. DETECTION TOOLING

### 5.1 Cross-Customer Detection
Per FEEP IV.5, quarterly query:

```sql
-- Adjust to your DB topology
WITH cross_entity AS (
  SELECT lower(email) AS email, 'horizon-aba' AS entity FROM horizon_aba.users
  UNION ALL
  SELECT lower(email) AS email, 'poolcurrent' AS entity FROM poolcurrent.users
)
SELECT email, COUNT(DISTINCT entity) AS entity_count, ARRAY_AGG(entity) AS entities
FROM cross_entity
GROUP BY email
HAVING COUNT(DISTINCT entity) > 1
ORDER BY entity_count DESC;
```

### 5.2 Shared API Key Detection
```bash
# Scan all entity repos for shared keys
for entity in horizon-ab-health poolcurrent; do
  git -C "$entity" grep -h "STRIPE_SECRET_KEY\|sk_live_" | sort -u
done | sort | uniq -d  # duplicates across entities = LEAK
```

### 5.3 DNS Attribution Check
```bash
# Verify DNS records attributed correctly
for domain in horizonhealth.com poolcurrent.com; do
  dig +short $domain
  whois $domain | grep -E "Registrant|Name Server"
done
```

---

## 6. VIOLATION RESPONSE

### Level 1 — Minor violation (e.g., one shared analytics tag)
- Engineering Lead remediates within 7 days
- Logged in `docs/feep/audits/cross-contamination-{YYYY-Q}.md`

### Level 2 — Customer data crossing entity boundaries
- Counselor halts all data flow immediately
- Investigation: how did it happen, how much data, what entities
- Remediation plan within 24 hours
- Counselor determines if breach notification required
- Founder notified within 4 hours

### Level 3 — Money flowing across entity boundaries without documentation
- Founder + Finance Officer halt all transactions immediately
- Counselor reviews for fraud, tax, or piercing-the-veil exposure
- Remediation: documented loan or distribution per Article VI
- Treasury review across all entities

### Level 4 — Tier S data appearing in Tier C entity
- Counselor declares incident
- Tier S entity assumes worst-case breach
- HIPAA breach notification timeline begins
- External counsel may be engaged

---

## 7. EXCEPTIONS

If a true business need requires deviating from isolation rules, document the exception:

```
File: docs/feep/exceptions/{entity-pair}-{date}.md

Exception:    [what is shared]
Entities:     [Entity A] and [Entity B]
Justification: [why this is necessary]
Risk assessed: [low / medium / high]
Mitigation:   [what controls are in place]
Counselor:    Approved by [name] on [date]
Founder:      Approved by Yoandy OS on [date]
Review date:  [annual review required]
```

Exceptions are reviewed annually. Any exception without active review → automatic expiration → enforcement reverts to default isolation.

---

## 8. HORIZON ABA → OTHER ENTITIES (Specific Boundaries)

Since Horizon ABA is Tier S (PHI), it has the strictest isolation requirements:

- Horizon ABA database MUST NOT be queryable from any non-Horizon-ABA infrastructure
- Horizon ABA Stripe is on Healthcare tier — never mixed with non-healthcare entities
- Horizon ABA email provider has its own BAA — emails never sent through shared infrastructure
- Horizon ABA admins are NOT admins of any other Tier S entity (defense in depth)
- Horizon ABA hosting account isolated even from PoolCurrent (different AWS account or different cloud entirely if needed)

---

## 9. CHECKLIST — NEW ENTITY ISOLATION SETUP

When launching a new entity, before any customer:

- [ ] Separate AWS / GCP / cloud account opened
- [ ] Separate DNS zones
- [ ] Separate Stripe account
- [ ] Separate email provider account + BAA if applicable
- [ ] Separate database cluster (or schema with separate credentials)
- [ ] Separate secrets vault namespace
- [ ] Separate monitoring tenant (separate Sentry/Datadog projects)
- [ ] Separate domains registered
- [ ] Separate ToS, Privacy Policy, BAA registry
- [ ] Tier assigned per FEEP Article V
- [ ] Counselor approval that isolation is sufficient for assigned Tier
