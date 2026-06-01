# Email Provider BAA — Request Template
**Use:** Sign a BAA with whichever email provider sends Horizon emails  
**Status:** BLOCKS LAUNCH — required before sending any client-facing email

---

## Why This Matters

Trial reminder emails, receipts, cancellation confirmations, and account notifications
will all contain user identifiers (name, email, plan) tied to ABA therapy services.
Under HIPAA, the email provider becomes a Business Associate and a BAA is required.

---

## BAA-Eligible Providers (Verified Public Info, Verify Current Status)

| Provider | BAA Available? | Notes |
|---|---|---|
| **AWS SES** | Yes | Included with AWS BAA — must enable, technical setup required |
| **Google Workspace / Gmail API** | Yes | Available with Business Standard+ plans, requires signing |
| **SendGrid** | Yes | Requires Pro plan or above, contact sales |
| **Postmark** | Yes | Available on most plans, contact sales |
| **Mailgun** | Yes | Requires HIPAA add-on |
| **Resend** | ⚠️ Check current status | New entrant — verify BAA availability |
| **Mailchimp / Mandrill** | ❌ No | Do not use for PHI-related email |
| **SparkPost** | Yes | Enterprise tier required |

---

## HOW TO REQUEST (per provider)

### AWS SES
1. Already covered under AWS BAA — check at https://aws.amazon.com/compliance/hipaa-compliance/
2. Sign AWS BAA via AWS Artifact in your AWS console
3. Confirm SES is in the "HIPAA Eligible Services" list (it is)

### SendGrid
1. Email: `compliance@sendgrid.com`
2. Subject: "BAA Request — Healthcare SaaS"
3. Required: Be on Pro plan or above

### Postmark
1. Email: `support@postmarkapp.com`
2. Subject: "HIPAA BAA Request"
3. They will send BAA via DocuSign typically within 1 week

### Google Workspace
1. Admin Console → Account → Account settings → Legal and compliance
2. Review and accept BAA
3. Only covers core services (Gmail, Calendar, Drive) — confirm scope

---

## EMAIL TEMPLATE (Generic — Adapt Per Provider)

**Subject:** BAA Request — Healthcare SaaS, Pre-Launch

```
Hello,

I'm requesting a Business Associate Agreement (BAA) for Horizon ABA Health,
a healthcare SaaS application that will send transactional emails to users
receiving Applied Behavior Analysis therapy services.

Use case:
- Trial reminder emails
- Subscription receipts
- Cancellation confirmations
- Account notifications
- Password reset and authentication

Email content may include user names and plan information tied to therapy services,
creating potential PHI exposure under HIPAA.

Please confirm:
1. Your service is HIPAA-eligible and a BAA is available
2. Which plan tier is required (we are currently evaluating)
3. BAA execution process and timeline
4. Whether subprocessors are covered
5. Any technical configuration changes required (e.g., disabling open/click tracking
   to avoid PHI leakage to third parties)

Our business details:
- Legal name: [FOUNDER TO FILL IN]
- Address: [FOUNDER TO FILL IN]
- EIN: [FOUNDER TO FILL IN]
- Expected monthly volume: [estimate]

Thank you,
[FOUNDER NAME]
Horizon ABA Health
```

---

## Technical Configuration After BAA

Once BAA is signed, configure your email provider to:

- [ ] **Disable open/click tracking** if it routes through a non-BAA pixel server
- [ ] **Disable email analytics** that share data with non-BAA third parties
- [ ] **Configure encryption at rest** (typically default but verify)
- [ ] **Enable TLS for email transport** (force STARTTLS)
- [ ] **Limit log retention** to minimum required
- [ ] **Enable audit logging** for compliance evidence

---

## What NOT To Do

- ❌ Do not send PHI-containing emails before BAA is signed
- ❌ Do not use a non-BAA fallback provider as backup
- ❌ Do not include detailed treatment information in emails (limit to billing + scheduling)
- ❌ Do not use email marketing tools (Mailchimp, Klaviyo) for transactional health emails
- ❌ Do not share email logs with non-BAA analytics tools
