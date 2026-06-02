# PoolCurrent — Tier Assignment
**Status:** SKELETON — Counselor assesses  
**Per FEEP Article V**

---

## Tier Assessment Questions

| Question | Answer | Tier Implication |
|---|---|---|
| Will PoolCurrent handle PHI? | __ | Yes = Tier S |
| Will PoolCurrent handle banking/financial data? | __ | Yes = Tier S |
| Will PoolCurrent handle children's data (<13)? | __ | Yes = Tier S (COPPA) |
| Will PoolCurrent process payments? | __ | Yes = at least Tier A |
| Will PoolCurrent handle PII? | __ | Yes = at least Tier B |
| Marketing or content only? | __ | Yes = Tier C |

## Assigned Tier

```
Tier:           PROVISIONAL — Tier B (minimum default for any consumer-facing app with PII)
Assigned by:    Horizon Counselor (provisional, per Founder confirmation 2026-06-02)
Date:           2026-06-02
Rationale:      Founder confirmed pool app with no Horizon relation. Without more
                data details, default to Tier B (consumer SaaS handling PII).
                Tier will be re-assessed once Founder provides:
                - What data is collected
                - Whether minors use the app (would force Tier S via COPPA)
                - Whether any health-adjacent data is collected (would force Tier S)
                - Whether payments are processed (forces at least Tier A)
                - Geography (EU/UK would force GDPR posture)
```

## Counselor Note

Per Counselor Authority Doctrine Article I, tier may be UPGRADED at any time
based on new information. Tier CANNOT be downgraded.

If Founder later confirms PoolCurrent collects financial, health, or children's
data, Counselor must re-tier upward immediately.

## Required Controls For Assigned Tier

(Filled in by Counselor based on tier — see FEEP V for tier requirements)

## Re-Assessment Triggers

Per FEEP V.3, re-assess if:
- [ ] New data type triggers higher tier
- [ ] Industry change
- [ ] User count > 10,000
- [ ] New geography (e.g., EU)

Tier cannot downgrade — only upgrade.
