# Stripe Business Associate Agreement (BAA) — Request Template
**Use:** Send to Stripe's healthcare team to initiate BAA process  
**Status:** BLOCKS LAUNCH — must be executed before processing payments for ABA clients

---

## How To Send This

1. Go to https://support.stripe.com/contact/email
2. Select "Other" → "HIPAA / Healthcare"
3. Or email: `healthcare@stripe.com`
4. Paste the email below
5. Expected response time: 3–10 business days

---

## EMAIL TEMPLATE

**Subject:** BAA Request — Horizon ABA Health (Healthcare SaaS, Pre-Launch)

```
Hello Stripe Healthcare Team,

I'm writing to request a Business Associate Agreement (BAA) for Horizon ABA Health,
a healthcare SaaS application serving Applied Behavior Analysis (ABA) therapy providers.

Our use case:
- We process recurring subscription payments from ABA therapy providers
- Some billing metadata may include client identifiers tied to therapy services
- This creates potential PHI exposure under HIPAA, requiring a BAA

Please confirm:
1. Eligibility for Stripe's healthcare account tier
2. BAA terms and how to execute
3. Any required changes to our existing Stripe account configuration
4. Pricing impact (if any) of moving to the healthcare tier
5. Whether Stripe Atlas, Stripe Billing, Stripe Tax, and Stripe Connect are all covered under the BAA

Our current Stripe account email: [FOUNDER TO FILL IN]
Our current Stripe account ID: [FOUNDER TO FILL IN — from Stripe dashboard URL]
Business legal name: [FOUNDER TO FILL IN]
Business address: [FOUNDER TO FILL IN]
EIN: [FOUNDER TO FILL IN]

We have not yet launched publicly and would like to have the BAA in place before
our first paid user signs up.

Thank you,
[FOUNDER NAME]
[TITLE]
Horizon ABA Health
[CONTACT EMAIL]
[PHONE]
```

---

## What To Expect Back

Stripe will:
1. Send you a BAA document (PDF or DocuSign)
2. Possibly ask follow-up questions about your data flow
3. Request you upgrade to their healthcare tier if not already on it
4. Provide BAA execution within 2–4 weeks once questions are answered

---

## Things To Verify In The BAA

When you receive Stripe's BAA, Horizon Counselor must confirm:

- [ ] Stripe is named as Business Associate
- [ ] All Stripe products you use are listed (Billing, Connect, Tax, etc.)
- [ ] Breach notification timeline is acceptable (typically 60 days)
- [ ] Subcontractor provisions are present
- [ ] Termination terms are clear
- [ ] Return/destruction of PHI on termination is addressed
- [ ] Indemnification terms are acceptable

---

## After Execution

- [ ] Store signed BAA in legal vault
- [ ] Add to Horizon compliance binder
- [ ] Update privacy policy to disclose Stripe as a business associate
- [ ] Update internal SOC2 / compliance documentation
- [ ] Add expiration/renewal date to calendar
