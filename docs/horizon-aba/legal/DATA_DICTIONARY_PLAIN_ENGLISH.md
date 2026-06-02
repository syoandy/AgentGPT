# What Is A Data Dictionary?
**For:** Founder, in plain English  
**Why this exists:** Founder said "idk what this is" — fair.

---

## The 60-Second Version

A Data Dictionary is **a list of every piece of information your app touches.**

That's it. Not legal jargon. Not technical. Just a list.

For each thing you collect, you write down:
1. **What it is** (e.g., "user's email")
2. **Where you got it** (e.g., "user typed it in signup form")
3. **Where you store it** (e.g., "in our database")
4. **Whether it's tied to a person** (yes/no)
5. **Whether it's medical** (yes/no)

That's the whole job.

---

## Why It Matters

Because the law treats different data differently:

| Data type | Law that cares |
|---|---|
| Name + email | basic privacy laws |
| Credit card | PCI DSS (payment security) |
| Social security number | identity theft laws |
| Health information | **HIPAA** ← Horizon ABA's big one |
| Children's data (under 13) | **COPPA** |
| Biometrics (face, fingerprint, voice) | **BIPA** (Illinois) |

The Counselor needs to know what data Horizon touches so they can tell you which laws apply.

Without a Data Dictionary, Counselor is guessing — and guessing wrong here is what HIPAA fines are made of.

---

## Example — A Simple Made-Up App

Let's say you're building a recipe app called "RecipeBox." Here's what the Data Dictionary might look like:

| Field | From | Stored | Tied to person? | Medical? |
|---|---|---|---|---|
| Email | User signup form | Database | Yes | No |
| Favorite recipes list | User saved them | Database | Yes | No |
| Profile photo | User uploaded | S3 bucket | Yes | No |
| Login IP address | Auto-captured | Logs (90 days) | Indirectly | No |

Counselor looks at this and says: "OK, no HIPAA needed, no BAA needed, basic Privacy Policy is enough."

---

## For Horizon ABA — What's Different

Horizon ABA is therapy software. Even if Horizon doesn't collect "diagnoses" or "session notes," **just knowing that John Smith is using a therapy app** is PHI (Protected Health Information).

So your Data Dictionary needs to list every field you handle — even mundane ones like email and billing address — because in a therapy context, those become PHI by association.

---

## The Template Is Already Built

`docs/horizon-aba/legal/HIPAA_DATA_DICTIONARY_TEMPLATE.md` has:
- A table with 23 example fields already pre-filled with common entries
- 23 yes/no questions

You just go through and update what Horizon actually collects. Strike out fields that don't apply. Add fields that aren't listed. Answer yes/no to the questions.

**Estimated time: 30 minutes if you already know the data model.**

---

## What I'd Need From You To Fill It In Myself

I could draft a starter version IF you tell me:

1. Does Horizon collect any clinical/session/treatment data, or just billing + scheduling?
2. Where is data stored? (AWS / GCP / your laptop / TBD)
3. Are clients minors? (ABA often serves children)
4. Do you integrate with EHR systems (electronic health records)?
5. Do you integrate with insurance billing?

Even ballpark answers help. I can draft a strawman dictionary, and you mark what's wrong.

---

## The Even Simpler Version

If you can't answer those questions because Horizon isn't built yet:

That's fine. You answer "PLANNED" for things you intend to collect later, and "NOT COLLECTED" for things you definitely won't.

The exercise of just listing it forces you to make architecture decisions before you write code — which is what good builders do anyway.
