# Truth Score — {feature name}
**Deploy date:** YYYY-MM-DD HH:MM TZ  
**Engineer:** name  
**Commit SHA:** abc1234  
**Entity:** {entity name}  
**Feature:** {short description}

Per FEEP Article III + IX. A feature with Truth Score < 100 is NOT deployed, regardless of CI status.

---

## CODE VERIFIED — {✅ / ❌}

| Item | Status | Evidence |
|---|---|---|
| Branch | __ | main |
| Commit SHA | __ | abc1234 |
| PR | __ | #123 merged YYYY-MM-DD HH:MM (link) |
| CI green on commit | __ | Link to CI run |
| Build artifact present | __ | Registry / S3 URL |
| Signed (Tier A+) | __ | Signing key + signature |

**Code verified:** [YES / NO]

---

## INFRASTRUCTURE VERIFIED — {✅ / ❌}

| Item | Status | Evidence |
|---|---|---|
| URL accessible | __ | https://... — response 200 |
| Cert valid | __ | Valid until YYYY-MM-DD |
| Health endpoint | __ | /health returns 200 at HH:MM |
| Container image | __ | Tag v1.2.3 running |
| DB migration applied | __ | Migration log entry |
| Feature flag state | __ | Flag X enabled at N% |
| Monitoring active | __ | Sentry/Datadog dashboard link |

**Infrastructure verified:** [YES / NO]

---

## BEHAVIOR VERIFIED — {✅ / ❌}

| Item | Status | Evidence |
|---|---|---|
| E2E test passed | __ | CI link YYYY-MM-DD HH:MM |
| Manual verification | __ | Screenshot attached / steps documented below |
| User flow end-to-end | __ | Described below |
| No regression in adjacent flows | __ | Sample tested |

**Manual verification steps performed:**
1. ____________________
2. ____________________
3. ____________________

**Screenshots/recordings:**
- [Path to screenshot 1]
- [Path to screenshot 2]

**Behavior verified:** [YES / NO]

---

## TRUTH SCORE

```
Score = (code_verified + infra_verified + behavior_verified) / 3 * 100

Code:        [YES = 1, NO = 0]
Infra:       [YES = 1, NO = 0]
Behavior:    [YES = 1, NO = 0]
Sum:         _
Score:       _ / 100
```

---

## VERDICT

- [ ] **DEPLOYED** (Score = 100)
- [ ] **NOT DEPLOYED** (Score < 100 — feature remains "in progress" per FEEP IX.3)

If NOT DEPLOYED: status updated in SESSION_LOG, marketing claims withheld, follow-up tasks created.

---

## SIGNATURES

```
Engineering Lead:    __________________________
Date:                __________________________

(Tier S only) Counselor verification: __________________________
Date:                __________________________
```

---

## FILED AT

`docs/{entity}/operations/TRUTH_SCORES/{YYYY-MM-DD}-{feature-slug}.md`
