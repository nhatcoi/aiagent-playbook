---
name: backend-domain-review
description: >
  Use this skill when reviewing backend code, API design, or system design
  through a business/domain lens — not just code style.
  Triggered by: "review subscription service", "review billing", "review AI feature",
  "design entitlement", "review purchase flow", "review webhook handler",
  "design quota system", "review payment", "check revenue risk".
---

# Backend Domain Review

> Review không phải tìm bug syntax. Review là tìm revenue risk, reliability gap, domain violation.

## Review lens — 6 góc nhìn

### 1. Revenue risk
- Webhook handler có idempotent không? Duplicate event gây charge 2 lần?
- Subscription state machine có đủ transition không?
- Refund có trigger revoke entitlement không?
- Reconciliation job tồn tại không?

### 2. Entitlement correctness
- Entitlement check ở đúng layer không? (middleware, không phải DB trigger)
- Premium vs free boundary rõ ràng?
- Entitlement cache invalidation khi subscription thay đổi?
- Downgrade (premium → free) xử lý graceful?

### 3. AI cost control
- Endpoint AI có rate limit per user không?
- Quota enforcement trước khi gọi model?
- Response có được cache không? Cache key đúng chưa?
- Free user và paid user cùng queue → noisy neighbor?

### 4. Retry & reliability
- Idempotency key trên mọi mutation?
- Retry có exponential backoff không?
- Dead letter queue khi exhausted retry?
- Timeout setting phù hợp chưa? (AI call timeout khác DB call)

### 5. Analytics coverage
- Revenue event tracking đầy đủ? (purchase, renew, cancel, refund)
- Conversion funnel event missing?
- A/B experiment flag tracked?

### 6. Abuse & security
- Input validation trước khi vào model?
- Prompt injection guard?
- Rate limit theo device (không chỉ user)?
- Trial abuse prevention (multiple trial account)?

## Severity tagging

```
path:line: 🔴 CRITICAL: [revenue / data loss / security] — [fix]
path:line: 🟠 HIGH:     [reliability / cost] — [fix]
path:line: 🟡 MEDIUM:   [correctness / missing coverage] — [fix]
path:line: ⚪ LOW:       [nit / style] — [fix]
```

## Checklist nhanh cho subscription service

- [ ] Webhook handler: idempotent (idempotency key lưu DB)
- [ ] Subscription state: enum rõ, transition validat
- [ ] Grace period: không revoke sớm
- [ ] Refund: trigger entitlement revoke
- [ ] Restore purchase: race condition handled
- [ ] Expiry: cron check hoặc event-driven?
- [ ] Reconciliation: job định kỳ compare DB vs platform

## Checklist nhanh cho AI feature

- [ ] Rate limit: có per user per feature
- [ ] Quota: check trước khi call model
- [ ] Cache: có cache output không?
- [ ] Queue: async hay sync? Priority lane?
- [ ] Cost tracking: log token count per request
- [ ] Timeout: AI call có timeout riêng?
- [ ] Fallback: model fail → fallback hay error?

## Những gì KHÔNG cần comment trong review

- Code style (đó là job của linter)
- Naming convention bình thường
- Test coverage (nói ở PR template, không phải review comment)
