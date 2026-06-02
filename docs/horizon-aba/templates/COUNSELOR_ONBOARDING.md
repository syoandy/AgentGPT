# Counselor Onboarding
**For:** Whoever Founder designates as Horizon Counselor  
**First read:** Required before signing Counselor Authority Doctrine

Welcome. You are being designated as Horizon Counselor — the supreme internal legal authority of the Yoandy OS empire under the doctrines below.

Read these before you sign. They define what you can and cannot do.

---

## DAY 1 — READING ORDER

Read in this sequence. Each builds on the prior.

1. **FEEP Master** (`docs/feep/00_FEEP_MASTER.md`)
   The umbrella. 18 articles defining the empire's operating system.

2. **Counselor Authority Doctrine** (`docs/horizon-aba/legal/COUNSELOR_AUTHORITY_DOCTRINE.md`)
   YOUR role. Articles I-XI define your powers, limits, escalations, and bar-status implications. **Read this twice.**

3. **Mandatory Rules** (`docs/horizon-aba/MANDATORY_RULES.md`)
   8 binding rules. You enforce them.

4. **Legal Fortress Doctrine** (`docs/feep/legal-fortress/00_LEGAL_FORTRESS_DOCTRINE.md`)
   The five pillars you operationally head. Risk register, contract architecture, insurance, retention, incidents.

5. **Founder Succession Doctrine** (`docs/feep/08_FOUNDER_SUCCESSION_DOCTRINE.md`)
   What happens if Founder becomes unavailable. You and Chief of Staff carry continuity.

6. **Horizon ABA Health audit + approval package** (`docs/horizon-aba/`)
   Your first piece of work. The approval package + 5 pre-built artifacts await your determinations.

---

## YOUR FIRST WEEK

| Day | Task |
|---|---|
| 1 | Read all 6 doctrines above. Mark questions for Founder discussion. |
| 2 | Meeting with Founder. Cover: your bar status (Article VI), threshold preferences (Article III), escalation criteria (Article V). |
| 3 | Sign Counselor Authority Doctrine Article X. Counselor signature unlocks the doctrine fully. |
| 4 | Begin Horizon ABA approval package review. Open `templates/COUNSELOR_DETERMINATION_TEMPLATE.md`. |
| 5-7 | Issue first determinations on the 13 binary questions. Either complete or flag NEEDS MORE INFO. |

---

## YOUR BAR STATUS (Critical Decision)

Counselor Authority Doctrine Article VI is honest about what document elevation can and cannot grant:

| Capability | Bar-Admitted | Not Bar-Admitted |
|---|---|---|
| Attorney-client privilege | ✅ applies | ❌ does NOT apply |
| Internal Horizon authority | ✅ full | ✅ full |
| Sign BAAs / approve ToS | ✅ | ✅ |
| Represent Horizon in court | ✅ within bar jurisdiction | ❌ external counsel required |
| HIPAA opinion weight to regulators | ✅ | ❌ external healthcare counsel for regulator interactions |
| Article V mandatory escalations | Shorter list | Full list (litigation, gov, subpoenas, securities, patents, GDPR, criminal) |

Designate honestly. Filed in Article VI Section 6.4.

---

## WHAT YOU CAN DO ALONE (No Founder Approval)

Per Article I.2-1.3:
- Approve / reject / condition any legal artifact submitted to you
- Halt any launch failing legal review
- Veto contracts below $50k
- Veto new vendor onboarding involving PHI / payment / PII
- Sign BAAs and DPAs with vendors
- Direct engineering to implement legal controls
- Authorize breach notifications
- Suspend any product or feature pending remediation
- Interpret Horizon doctrine across the empire
- Engage external counsel (Article V mandatory escalations)

## WHAT REQUIRES FOUNDER CO-SIGN (Article III)

- Contracts > $50,000 total
- Acquisitions / mergers
- Litigation initiation
- Settlements > $10,000
- Debt > $25,000
- Doctrine amendments
- FEEP amendments
- Sale of customer data (AUTOMATIC VETO — never)

## WHAT YOU MUST ESCALATE EXTERNALLY (Article V)

These require licensed bar attorneys regardless of your internal authority:
- Litigation
- Government investigations
- Subpoenas
- Securities matters
- Patent matters (USPTO bar)
- Trademark disputes
- GDPR cross-border
- Criminal exposure

You select and direct the external counsel. They report to you, not Founder.

---

## EMERGENCY POWERS (Article IV)

Standing authority — no pre-approval needed for:
- Take-down of compromised systems
- Initiate breach notifications
- Engage emergency external counsel
- Direct emergency security controls

Notify Founder within 4 hours.

---

## DOCUMENTATION YOU OWN

Every determination, decision, and approval recorded in:
- `docs/horizon-aba/SESSION_LOG.md` (chronological)
- `docs/horizon-aba/graphify/horizon_nodes.json` (relationship map)
- `docs/horizon-aba/legal/determinations/` (your determinations)
- `docs/feep/legal-fortress/contract-registry.md` (contracts)
- `docs/feep/legal-fortress/risk-register.md` (risks you've flagged)

Per Mandatory Rule 3: **No verbal-only decisions. No undocumented approvals.**

---

## YOUR RELATIONSHIP WITH AI ASSISTANTS

AI assistants (Claude, ChatGPT) working on Horizon legal matters must route through you (FEEP Article XVIII, Counselor Doctrine Article IX).

They:
- Cannot substitute their opinion for yours
- Must flag matters requiring Counselor review explicitly
- Must maintain documentation chain
- Cannot deploy production code autonomously
- Cannot approve their own PRs

You can use them to draft artifacts. You sign-off the artifacts.

---

## RESOURCES YOU NEED FROM FOUNDER

Before your first determination, request from Founder:

- [ ] Confirmation of bar status (so Article V escalation list is calibrated)
- [ ] Customer geography (which states/countries — drives state law applicability)
- [ ] Vendor list (so you can verify BAAs in place)
- [ ] HIPAA Data Dictionary (filled in — Mandatory Rule 1)
- [ ] Insurance certificates
- [ ] Formation documents for each entity

---

## YOUR FIRST DETERMINATION OUTPUT

Use `templates/COUNSELOR_DETERMINATION_TEMPLATE.md` to respond to the Horizon ABA approval package.

Your determination becomes the authoritative answer to those 13 questions. Founder accepts conditions you set. Engineering implements the changes you require.

---

## QUESTIONS TO ASK FOUNDER ON DAY 2

1. Am I bar-admitted in any jurisdiction, and which?
2. What is the realistic geography of Horizon ABA customers (next 12 months)?
3. Are there any pending legal matters I should know about?
4. Do you want me to act as Counselor for PoolCurrent too, or different person?
5. What's your tolerance for conditional approvals vs. strict approve/reject?
6. What's the escalation budget for external counsel ($X/month I can spend without Founder pre-approval)?
7. Founder Succession Doctrine — who's the Acting Authority you'd designate?

---

## SIGNING IN

When ready to sign Counselor Authority Doctrine Article X:
1. Fill in your name and bar status in Section 6.4
2. Sign Counselor signature line
3. Notify Founder
4. Update `docs/horizon-aba/SESSION_LOG.md` with designation date
5. Update `docs/horizon-aba/graphify/horizon_nodes.json` — replace "TBD" in horizon-counselor node with your details

You're live the moment you sign.
