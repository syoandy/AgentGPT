# Founder Action Sheet — Last Mile to 100%
**Current readiness:** ~78% (Action 2 complete)  
**After completing this sheet:** ~95% (the final 5% is Counselor turnaround)  
**Total effort:** ~40 minutes of your time remaining

## Action Status

| Action | Status | Completed |
|---|---|---|
| 1. Designate Counselor | 🔲 PENDING | — |
| 2. Sign Doctrines | ✅ DONE | 2026-06-02 |
| 3. Fill Data Dictionary | 🔲 PENDING | — |
| 4. Send Stripe BAA email | 🔲 PENDING | — |
| 5. Send Email BAA email | 🔲 PENDING | — |
| 6. Start wiring session | 🔲 PENDING | — |
| 7. Counselor approval | 🔲 PENDING — depends on #1 + #3 | — |

---

## ⏱ ACTION 1 — Designate Counselor (2 min)

Open: `docs/horizon-aba/legal/COUNSELOR_AUTHORITY_DOCTRINE.md`

Scroll to **Article X — Approval Signatures**.

Fill in:
- Counselor Name: [the person who will serve as Horizon Counselor]
- Counselor designation: General Counsel (default)
- Bar admission: Yes or No (honest answer)
- Bar number / Jurisdiction: (if Yes)
- Date: today's date
- Counselor signature: their typed name = consent

Same in `MANDATORY_RULES.md` → Signatures section.

**If you ARE the Counselor:** put your own name. The doctrine allows this.

---

## ⏱ ACTION 2 — Sign The Two Doctrines (1 min)

In both files above, add your Founder signature line:
```
Founder:     Yoandy OS (Telegram ID: 8577755724)
Date:        [today]
Signature:   Yoandy OS
```

Save. Commit. The doctrines become active immediately.

---

## ⏱ ACTION 3 — Fill HIPAA Data Dictionary (30 min)

Open: `docs/horizon-aba/legal/HIPAA_DATA_DICTIONARY_TEMPLATE.md`

For each row in the table, replace placeholders with actual answers:
- `[user/provider]` → who actually enters this data
- `[database]` → which DB / storage system
- `[yes/no]` → yes or no for "Linked to Treatment"
- `TBD` → leave as TBD if you genuinely don't know

Then answer the **23 critical questions** below the table. Most are Y/N.

Sign at the bottom. Save.

---

## ⏱ ACTION 4 — Send Stripe Healthcare BAA Request (3 min)

Open: `docs/horizon-aba/legal/STRIPE_BAA_REQUEST_TEMPLATE.md`

1. Open your Stripe Dashboard → get your account ID + email
2. Fill in `[FOUNDER TO FILL IN]` slots in the email template
3. Email it to: **healthcare@stripe.com**
4. Mark sent in SESSION_LOG.md

Expected reply: 3–10 business days.

---

## ⏱ ACTION 5 — Send Email Provider BAA Request (3 min)

Open: `docs/horizon-aba/legal/EMAIL_BAA_REQUEST_TEMPLATE.md`

1. Choose your email provider (Postmark / SendGrid Pro / AWS SES / Google Workspace)
2. Fill in business details in the template
3. Send to the provider's compliance address (listed in the template)
4. Mark sent in SESSION_LOG.md

Expected reply: 1–2 weeks.

---

## ⏱ ACTION 6 — Start The Wiring Session (5 min)

This is the big one — unlocks the final 12%.

1. Open a **new Claude Code session**
2. Set working directory / repo: `syoandy/horizon-ab-health`
3. Open `docs/horizon-aba/wiring-kit/NEW_SESSION_PROMPT.md`
4. Copy everything between the ⬇️ and ⬆️ markers
5. Paste it as the first message in the new session
6. The new Claude will do the wiring autonomously

Watch the new session work. When it opens a PR, review against `wiring-kit/checklist.md` before merging.

---

## ⏱ ACTION 7 — Submit To Counselor (1 min)

Once Actions 1–3 are done, hand the Counselor:
- `docs/horizon-aba/legal/COUNSELOR_APPROVAL_PACKAGE.md`
- The filled-in `HIPAA_DATA_DICTIONARY_TEMPLATE.md`
- Reference to `docs/horizon-aba/legal/COUNSELOR_AUTHORITY_DOCTRINE.md`

Counselor returns determinations on the 13 questions → final 4% unlocks.

---

## Done = 100%

| Action | Unlocks | Time |
|---|---|---|
| 1. Designate Counselor | 1% | 2 min |
| 2. Sign Doctrines | 2% | 1 min |
| 3. Fill Data Dictionary | 5% | 30 min |
| 4. Send Stripe BAA | 1% | 3 min |
| 5. Send Email BAA | 1% | 3 min |
| 6. Start wiring session | 12% | 5 min (then runs on its own) |
| 7. Counselor approval | 4% | counselor SLA, not your effort |
| **Total** | **26%** | **~45 min active time** |

---

## When You Finish Each Action

Edit `docs/horizon-aba/SESSION_LOG.md` and add a one-liner:

```
Action 1 (Counselor designated): ✅ DONE [date]
Action 2 (Doctrines signed):     ✅ DONE [date]
Action 3 (Data Dictionary):      ✅ DONE [date]
...
```

This keeps the project memory clean per Rule 6 (Handoff Completeness).
