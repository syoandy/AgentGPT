# Universal App Build Doctrine
**Parent doctrine:** FEEP Article III, V, VIII  
**Applies to:** Every Horizon empire SaaS / app build

---

## 1. STACK STANDARDS (Reference, Not Mandate)

Choose the right tool for the job. These are defaults — deviate with documented reason.

| Layer | Default | Alternative | When to deviate |
|---|---|---|---|
| Backend language | Go | TypeScript (Node), Rust | Performance-critical = Rust; team strength elsewhere = TS |
| Frontend framework | Next.js (React) | SvelteKit | Static-first marketing = Astro |
| Database | PostgreSQL | MySQL, MongoDB | Document-first product = Mongo (rare) |
| Cache | Redis | Memcached | Almost never deviate |
| Queue | PostgreSQL (via `select for update skip locked`) | Redis, Temporal | High-throughput async = Temporal |
| Auth | Auth0 / Clerk / Supabase Auth | NextAuth | Always prefer managed |
| Payments | Stripe | Adyen, PayPal | International-first = Adyen |
| Email (transactional) | Postmark or AWS SES | SendGrid | BAA required (Tier S) = whichever offers BAA |
| Email (marketing) | Customer.io | ConvertKit | — |
| Hosting | AWS (with BAA if Tier S), Vercel for frontend | GCP, Fly.io | — |
| Monitoring | Sentry + Datadog | New Relic | — |
| Secrets | AWS Secrets Manager, Doppler | HashiCorp Vault | — |
| CI/CD | GitHub Actions | CircleCI | — |
| IaC | Terraform | Pulumi | — |

---

## 2. PROJECT STRUCTURE (Go Backend)

```
{entity}-app/
├── cmd/
│   └── server/
│       └── main.go              — Entry point
├── internal/
│   ├── billing/                 — Stripe + subscription logic
│   ├── auth/                    — User authentication
│   ├── api/                     — HTTP handlers
│   ├── domain/                  — Business logic (entity-specific)
│   ├── storage/                 — DB layer
│   └── notifications/           — Email + push
├── pkg/                         — Reusable across entities
│   └── (only if truly cross-entity reusable)
├── migrations/                  — SQL migrations
├── web/                         — Frontend (or separate repo)
├── docs/                        — Per Section 5 of Governance Template
└── scripts/                     — Ops scripts
```

---

## 3. PROJECT STRUCTURE (TypeScript / Next.js Frontend)

```
{entity}-web/
├── pages/                       — Routes (or app/ for Next 13+)
│   ├── account/
│   │   ├── subscription.tsx
│   │   └── cancel.tsx
│   └── checkout/
├── components/
│   ├── billing/
│   │   ├── SubscriptionDisclosure.tsx
│   │   └── CancellationFlow.tsx
│   └── ui/                      — Generic UI components
├── lib/                         — Client-side utilities
├── styles/
├── public/
└── tests/
```

---

## 4. MANDATORY COMPONENTS (Tier A and Tier S, If Selling Subscriptions)

Per Horizon ABA Health audit findings, every billing-capable entity MUST include:

1. **SubscriptionDisclosure** — placed above every purchase button
2. **CancellationFlow** — at `/account/cancel`, ≤2 clicks from settings
3. **TrialReminderService** — T-7/T-3/T-1/T-0 emails (only if free trial offered)
4. **StripeWebhookHandler** — handles 8 critical events including disputes
5. **DisputeDashboard** — admin route with Visa VDMP + MC ECP alerts

These are not optional. Reference implementations live in `docs/horizon-aba/wiring-kit/`.

---

## 5. CODE STANDARDS

### Naming
- Files: `snake_case.go`, `PascalCase.tsx`
- Functions: `PascalCase` (Go exported), `camelCase` (Go unexported, TS)
- Constants: `SCREAMING_SNAKE_CASE`
- Types: `PascalCase`

### Error Handling
- Go: return errors, never `panic` in production code
- TS: typed errors, never throw raw strings
- All errors logged with correlation ID
- Errors visible to user are sanitized (no stack traces, no internals)

### Logging
- Structured JSON logs (no plain text)
- Required fields: `timestamp`, `level`, `service`, `correlation_id`, `user_id` (if applicable)
- No PII in logs (Tier S: enforce automated check in CI)
- Log retention per Tier:
  - Tier S: 6 years (HIPAA)
  - Tier A: 1 year
  - Tier B: 90 days
  - Tier C: 30 days

### Testing
- Unit tests: every public function with branching logic
- Integration tests: every external service interaction
- E2E tests: critical user flows (signup, checkout, cancel)
- Test coverage minimums:
  - Tier S: 80%
  - Tier A: 70%
  - Tier B: 60%
  - Tier C: 40%

---

## 6. SECURITY REQUIREMENTS (Per Tier)

### All Tiers
- TLS 1.2+ everywhere
- No secrets in code or commits (CI enforces)
- Dependencies scanned weekly (`go list -m`, `npm audit`)
- Critical CVEs patched within 7 days

### Tier A and Above
- MFA enforced for admin users
- Session timeouts: 24h max
- Rate limiting on auth + checkout endpoints
- WAF in front of public endpoints

### Tier S Only
- Encryption at rest (AES-256)
- Audit logging on every PHI access (immutable log)
- Workforce HIPAA training documented
- Quarterly penetration testing
- Annual SOC 2 audit (or equivalent)
- Incident response plan with 60-day breach notification capability

---

## 7. DEPENDENCY MANAGEMENT

### Adding a Dependency
1. Verify license is compatible (MIT, Apache 2.0, BSD = always OK)
2. Verify maintainer activity (last commit < 1 year)
3. Verify security history (no unpatched CVEs)
4. Document why it was added (in PR description)
5. Tier S: Counselor approval if dependency handles PHI

### Dependency Updates
- Auto-PRs via Renovate or Dependabot
- Patch + minor: auto-merge after CI passes
- Major: manual review required

---

## 8. CI/CD PIPELINE (Mandatory Steps)

```
1. Checkout
2. Install deps (cached)
3. Lint
4. Type check (TS) or vet (Go)
5. Unit tests
6. Integration tests
7. Security scan (CodeQL or equivalent)
8. Secret scan
9. Dependency vulnerability scan
10. Build
11. Sign artifact (Tier A+)
12. Deploy to staging
13. E2E tests in staging
14. Manual approval gate (Tier S)
15. Deploy to production
16. Smoke tests in production
17. Truth Score recorded (per FEEP IX)
```

If any step fails, pipeline halts. No skipping.

---

## 9. ENVIRONMENTS

Every entity has at minimum:
- `local` — developer machines
- `staging` — production-like, fake data, accessible to team only
- `production` — real users, real data

Tier S adds:
- `staging-phi` — production-like with synthetic PHI (not real)

---

## 10. DATABASE STANDARDS

### Schema
- All tables have `id`, `created_at`, `updated_at`
- Soft deletes use `deleted_at` (nullable timestamp), not booleans
- Foreign keys explicit (no implicit references)
- Indexes documented in migration comments

### Migrations
- Forward and backward (every migration is reversible, even if reverse is "no-op with warning")
- Tested in staging before production
- Tier S: Counselor reviews migrations that add/remove PHI fields

### PII / PHI Tagging
- Every column containing PII or PHI is tagged in schema comments:
  ```sql
  email TEXT NOT NULL, -- PII: contact info
  ssn TEXT,           -- PHI: identifier (encrypted at rest)
  ```
- Tier S adds automated check: no untagged columns in tables containing PHI

---

## 11. FEATURE FLAG DOCTRINE

- All new features behind a feature flag for first 30 days
- Default: off
- Rollout: 1% → 10% → 50% → 100% with monitoring at each step
- Cleanup: flag removed within 90 days of 100% rollout

---

## 12. WHAT NOT TO DO

- ❌ Never commit secrets (CI rejects)
- ❌ Never log PII or PHI
- ❌ Never store passwords (use OAuth or hashed-only with Argon2)
- ❌ Never deploy on Friday after 3pm local
- ❌ Never deploy without Truth Score capability
- ❌ Never skip migrations to "fix later"
- ❌ Never use `--no-verify` on commits in production code
- ❌ Never `rm -rf` production data without Founder approval
- ❌ Never share Stripe keys across entities
- ❌ Never disable security checks "temporarily"
