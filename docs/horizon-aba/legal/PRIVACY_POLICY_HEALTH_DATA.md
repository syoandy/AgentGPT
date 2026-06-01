# Privacy Policy — Health Data Section Template
**Use:** Pre-drafted health-data disclosures for Horizon's Privacy Policy  
**Status:** ⚖️ LEGAL REVIEW REQUIRED — counsel must integrate into full Privacy Policy

---

## How To Use

These clauses cover the HIPAA + state privacy law floor for a healthcare SaaS.
Horizon Counselor must:
1. Confirm Horizon is/isn't a Covered Entity or Business Associate
2. Integrate these clauses into the full Privacy Policy
3. Add CCPA/CPRA, GDPR (if EU users), and state-specific clauses

---

## SECTION 1 — Information We Collect

```
1. INFORMATION WE COLLECT

1.1 Account Information. When you create an account, we collect:
- Name, email address, phone number
- Billing address and payment information (processed by Stripe)
- Account credentials

1.2 Service Use Information. When you use Horizon ABA Health, we collect:
- [LIST SPECIFIC DATA TYPES — founder must complete after data dictionary review]
- Session activity and feature usage logs
- Device information (browser, OS, IP address)

1.3 Communications. When you contact us, we retain:
- Email communications
- Support ticket records
- Phone call records (if applicable)

1.4 [IF MINORS] Children's Information. If our Service is used to support therapy
for minor children, parental consent is required and additional COPPA protections
apply. See Section [X] for details.
```

---

## SECTION 2 — Health Information (HIPAA Notice)

```
2. PROTECTED HEALTH INFORMATION (PHI)

Horizon ABA Health may handle Protected Health Information (PHI) as defined by
the Health Insurance Portability and Accountability Act of 1996 (HIPAA).

2.1 Our Role. [INSERT BASED ON COUNSEL DETERMINATION:
"We act as a Covered Entity under HIPAA" OR
"We act as a Business Associate to your healthcare provider under HIPAA" OR
"We do not handle PHI"]

2.2 How We Protect PHI. We implement administrative, physical, and technical
safeguards required under the HIPAA Security Rule, including:
- Encryption of PHI in transit (TLS 1.2+) and at rest (AES-256)
- Access controls and audit logging
- Workforce HIPAA training
- Business Associate Agreements with subprocessors who may access PHI
- Breach notification procedures per the HIPAA Breach Notification Rule

2.3 Our Business Associates. We have executed Business Associate Agreements (BAAs)
with the following service providers who may handle PHI:
- Stripe, Inc. (payment processing)
- [Email provider] (transactional email)
- [Hosting provider] (data storage and compute)
- [Other vendors as applicable]

2.4 Your HIPAA Rights. If you are an individual whose PHI we handle, you have
the right to:
- Access your PHI
- Request corrections to your PHI
- Receive an accounting of disclosures
- Request restrictions on uses and disclosures
- Receive confidential communications
- File a complaint with us or with the U.S. Department of Health and Human
  Services Office for Civil Rights

To exercise these rights, contact privacy@[YOUR_DOMAIN].

2.5 Breach Notification. In the event of a breach of unsecured PHI, we will
notify affected individuals within 60 days as required by the HIPAA Breach
Notification Rule. Breaches affecting 500 or more individuals in a state will
also be reported to the U.S. Department of Health and Human Services and
prominent media outlets in that state.
```

---

## SECTION 3 — How We Use Information

```
3. HOW WE USE INFORMATION

We use your information to:
- Provide, maintain, and improve the Service
- Process payments and manage subscriptions
- Send transactional emails (receipts, reminders, account notifications)
- Provide customer support
- Comply with legal obligations
- Detect and prevent fraud or abuse

We DO NOT:
- Sell your personal information to third parties
- Use your PHI for marketing purposes
- Share your data with advertising networks
- Use your data to train AI models without your explicit consent
```

---

## SECTION 4 — Information Sharing

```
4. INFORMATION SHARING

We share information only:
4.1 With Service Providers (Business Associates). We share information with
vendors who help us operate the Service (Stripe for payment, [Email provider]
for email, etc.). All such vendors who may access PHI have signed BAAs.

4.2 For Legal Reasons. We may disclose information if required by law,
subpoena, or court order, or to protect the rights, property, or safety of
Horizon, our users, or the public.

4.3 With Your Consent. We may share information with your explicit, written
consent (such as sharing your data with your healthcare provider or insurer
at your request).

4.4 In Business Transfers. If Horizon is involved in a merger, acquisition,
or asset sale, your information may be transferred. We will provide notice
before your information becomes subject to a different privacy policy.

We DO NOT share PHI for marketing purposes without your explicit authorization.
```

---

## SECTION 5 — Data Retention

```
5. DATA RETENTION

We retain your information for as long as your account is active or as needed
to provide the Service. After account closure:
- Account information: retained for [X] years for tax, audit, and compliance
- PHI: retained per HIPAA requirements (typically 6 years minimum)
- Billing records: retained for [X] years per tax law
- Marketing communications opt-outs: retained indefinitely to honor your choice

You may request deletion of your data subject to legal and regulatory retention
requirements.
```

---

## SECTION 6 — California Residents (CCPA/CPRA)

```
6. CALIFORNIA PRIVACY RIGHTS

If you are a California resident, you have additional rights under the
California Consumer Privacy Act (CCPA) and California Privacy Rights Act (CPRA):

- Right to Know what personal information we collect and how it is used
- Right to Delete your personal information
- Right to Correct inaccurate information
- Right to Opt-Out of the sale or sharing of personal information
- Right to Limit use of sensitive personal information
- Right to Non-Discrimination for exercising these rights

To exercise these rights, email privacy@[YOUR_DOMAIN] or call [PHONE].

Note: PHI subject to HIPAA is exempt from certain CCPA provisions. Where
HIPAA and CCPA both apply, HIPAA provisions take precedence for PHI.
```

---

## SECTION 7 — Security

```
7. SECURITY

We use industry-standard security measures including:
- Encryption in transit (TLS 1.2+)
- Encryption at rest (AES-256)
- Multi-factor authentication for admin access
- Regular security audits and penetration testing
- Access controls and audit logging
- Incident response procedures

No system is 100% secure. If you suspect a security incident, contact
security@[YOUR_DOMAIN] immediately.
```

---

## SECTION 8 — Contact

```
8. CONTACT

Privacy questions: privacy@[YOUR_DOMAIN]
HIPAA-specific questions: hipaa@[YOUR_DOMAIN] OR same as privacy
Security incidents: security@[YOUR_DOMAIN]
Mailing address: [BUSINESS ADDRESS]
HIPAA Privacy Officer: [NAME] — [EMAIL]
```

---

## Horizon Counselor Approval Checklist

- [ ] PHI handling clauses match Horizon Counselor's HIPAA determination
- [ ] BAA list reflects actually signed agreements (not aspirational)
- [ ] Breach notification timeline matches state law (some states require shorter)
- [ ] CCPA/CPRA section reviewed against current regulations
- [ ] GDPR section added if EU users are expected
- [ ] Children's privacy section added if minors are users (COPPA)
- [ ] Data retention periods set per legal counsel recommendation
- [ ] HIPAA Privacy Officer designated (required if Covered Entity)
- [ ] Notice of Privacy Practices created (required if Covered Entity)
