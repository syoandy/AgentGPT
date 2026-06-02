# Universal Deployment Doctrine
**Parent doctrine:** FEEP Article III, IX  
**Applies to:** Every empire entity production deploy

---

## 1. THE THREE-SOURCE TRUTH RULE (Restated)

A deploy is real only when verified across:
1. **Code** — commit SHA on the deployed branch
2. **Infrastructure** — what's actually running (containers, processes, certs, DNS)
3. **Behavior** — what an end user actually experiences

If any disagrees, **the feature is not deployed**, regardless of green CI or merged PRs.

---

## 2. DEPLOY ROLES

| Role | Action |
|---|---|
| Engineering Lead | Triggers deploy, owns rollback |
| Counselor (Tier S only) | Approves deploys that touch PHI handling |
| Security Officer (Tier S only) | Reviews security-sensitive deploys |
| Founder | Override only — never the routine path |
| AI Assistants | Cannot deploy autonomously (per FEEP VIII.2) |

---

## 3. DEPLOY READINESS CHECKLIST (Pre-Deploy)

Before any production deploy:

- [ ] CI pipeline green on the target commit
- [ ] Feature flag configured (off by default per Build Doctrine 11)
- [ ] Migrations tested in staging
- [ ] Rollback plan documented in PR
- [ ] Truth Score capability in place (smoke tests / health endpoint)
- [ ] On-call engineer named for next 4 hours
- [ ] Tier S: Counselor sign-off on PHI-affecting changes
- [ ] No active incident (no deploys during incident response)

---

## 4. DEPLOY WINDOWS

Allowed deploy times:
- Monday–Thursday, 09:00–15:00 local time
- Emergency deploys: any time with Founder + Counselor + Engineering Lead notified

Forbidden deploy times:
- Friday after 15:00 local
- Weekends (except emergency)
- Holiday windows (Thanksgiving week, Dec 20 – Jan 2)
- During active incident
- During business-critical events (sales launches, billing cycles for SaaS)

---

## 5. ROLLOUT PHASES

| Phase | % Traffic | Hold Time | Decision |
|---|---|---|---|
| Canary | 1% | 30 min | Auto-advance if no errors |
| Expanded | 10% | 2 hours | Auto-advance if metrics stable |
| Majority | 50% | 4 hours | Manual advance after dashboard check |
| Full | 100% | — | Truth Score recorded |

Halt at any phase if:
- Error rate increases > 2x baseline
- p95 latency increases > 50%
- Any Sev 1 alert fires
- Counselor or Security Officer requests halt

---

## 6. ROLLBACK PROCEDURE

Every deploy must support rollback to the previous version within 5 minutes.

### Rollback Triggers (Automatic)
- Error rate > 5% sustained for 5 minutes
- p95 latency > 2x baseline sustained for 10 minutes
- Health endpoint failure for 3 consecutive minutes
- Database migration failure mid-deploy

### Rollback Triggers (Manual)
- Engineering Lead decision
- Counselor override (Tier S)
- Founder override

### Rollback Steps
1. Reset traffic to previous version
2. Confirm previous version healthy
3. Investigate root cause (separate session, post-rollback)
4. Schedule retry only after fix verified in staging
5. Log rollback in DEPLOY_LOG.md and SESSION_LOG.md

---

## 7. TRUTH SCORE RECORDING

After every deploy, record in `docs/{entity}/operations/TRUTH_SCORES/{YYYY-MM-DD}-{feature}.md`:

```markdown
# Truth Score — {feature}
**Deploy date:** YYYY-MM-DD HH:MM TZ
**Engineer:** name
**Commit SHA:** abc1234

## Code Verified ✅
- Branch: main
- Commit SHA: abc1234
- PR: #123 merged at YYYY-MM-DD HH:MM

## Infrastructure Verified ✅
- URL: https://app.example.com/feature
- Cert valid until: YYYY-MM-DD
- Health endpoint: 200 OK at YYYY-MM-DD HH:MM
- Container image: tag v1.2.3 in production registry

## Behavior Verified ✅
- E2E test: passed at YYYY-MM-DD HH:MM (link to CI run)
- Manual verification: screenshot attached / steps documented
- User flow: signup → use feature → result observed

## Truth Score: 100 / 100
```

If any field cannot be verified → Truth Score < 100 → feature is NOT deployed per FEEP.

---

## 8. DEPLOY LOG FORMAT

`docs/{entity}/operations/DEPLOY_LOG.md` — one entry per deploy:

```markdown
## {YYYY-MM-DD HH:MM} — {feature short name}
- Commit: abc1234
- Engineer: name
- Tier of change: [low / medium / high]
- Rollout: 1% → 10% → 50% → 100% completed at HH:MM
- Truth Score: 100
- Counselor approval (if Tier S): [yes — date] / [N/A]
- Issues: none / list
```

---

## 9. SPECIAL DEPLOY CATEGORIES

### Database Migrations
- Forward + backward migrations both tested in staging
- Run in maintenance window or with backward-compatible rollout
- Tier S: PHI schema changes require Counselor approval

### Public-Facing Legal Document Changes (ToS / Privacy Policy)
- Counselor approval required regardless of Tier
- Old version archived in `docs/{entity}/legal/archive/`
- Users notified per ToS change clause (typically 30-day notice)

### Authentication Changes
- Always behind feature flag
- Rollout 1% → 10% → 50% → 100% over minimum 7 days
- Security Officer approval (Tier A+)
- Monitor failed login rate at every phase

### Pricing Changes
- 30-day notice to existing customers
- Old price grandfathered per ToS
- Marketing approval + Counselor approval
- Truth Score recorded for new pricing page

---

## 10. INCIDENT-FREE DEPLOYS

Goal: 99%+ of deploys complete without incident.

Track:
- Total deploys per month
- Deploys requiring rollback
- Deploys causing customer-facing incident
- Mean time to detect (MTTD)
- Mean time to restore (MTTR)

Counselor reviews quarterly. Trend deterioration triggers process review.

---

## 11. AI ASSISTANT BOUNDARIES IN DEPLOY

Per FEEP VIII.2, AI assistants may:
- ✅ Open PRs to non-production branches
- ✅ Run staging deploys after human PR approval
- ✅ Generate Truth Score reports for human review
- ✅ Recommend rollback when metrics deteriorate

AI assistants may NOT:
- ❌ Deploy to production autonomously
- ❌ Approve their own PRs
- ❌ Merge to main / production branches
- ❌ Skip the deploy readiness checklist
- ❌ Override a Counselor or Security Officer halt

---

## 12. POST-DEPLOY (Always)

Within 24 hours of any production deploy:
- [ ] Truth Score file created
- [ ] DEPLOY_LOG.md entry written
- [ ] SESSION_LOG.md entry written
- [ ] Monitoring dashboard reviewed
- [ ] If issues: incident log opened in `docs/{entity}/security/INCIDENT_LOG.md`
