# Case Study: Mobile SaaS Backend — AI-Powered Subscription App

**Context**: Server team của AI mobile app (photo/music/mail AI). Business model: subscription + entitlement + AI cost + retention. Core revenue pipeline: purchase → verify → entitlement → renew.

## Domain model

```
User
 ├── Subscription       (Apple/Google billing state)
 ├── Entitlements       (feature access, derived from subscription)
 ├── Usage / Quota      (AI generations per day)
 ├── AI Jobs            (async generation queue)
 ├── Revenue Events     (purchase, renew, refund, cancel)
 ├── Ads State          (disable ads sau purchase)
 ├── Experiment Flags   (A/B testing)
 └── Analytics          (funnel, DAU, retention)
```

## Tại sao backend ảnh hưởng trực tiếp revenue

| Backend issue | Business impact |
|---------------|----------------|
| Webhook handler không idempotent | Duplicate charge / state sai |
| Grace period xử lý sai | Mất paying user |
| AI queue chậm | Giảm conversion, tăng churn |
| Entitlement sync lag | User chửi, refund |
| Ads không disable sau purchase | 1-star review, churn |
| Trial abuse không chặn | CAC tăng, LTV giảm |

## Skills trong case study này

| Skill | Trigger | Business value |
|-------|---------|----------------|
| [`subscription-billing-debug`](./.claude/skills/subscription-billing-debug/SKILL.md) | "user mất premium", "billing fail", "webhook" | Revenue protection |
| [`ai-cost-optimize`](./.claude/skills/ai-cost-optimize/SKILL.md) | "AI queue quá tải", "token budget", "GPU cost" | Margin control |
| [`backend-domain-review`](./.claude/skills/backend-domain-review/SKILL.md) | "review subscription", "review billing design" | Senior engineering lens |
| [`incident-commander`](./.claude/skills/incident-commander/SKILL.md) | "production down", "revenue drop", `/incident` | P0 response |

## Cách dùng

Copy `.claude/` folder vào project thật:

```bash
cp -r .claude/ /path/to/your/project/.claude/
```

Skill tự kích hoạt khi Claude Code nhận prompt match description. `incident-commander` cần gõ `/incident` hoặc describe incident rõ ràng (có `disable-model-invocation: true`).

## Skills chưa build (gợi ý tiếp theo)

| Skill | Mô tả ngắn | Priority |
|-------|-----------|---------|
| `revenue-flow-analyzer` | Correlate backend incident với revenue metric | High |
| `mobile-reliability` | Idempotency, retry, eventual consistency patterns | High |
| `entitlement-designer` | Design hệ thống entitlement free/premium/pro | Medium |
| `analytics-coverage` | Check funnel event tracking đầy đủ chưa | Medium |
| `event-driven-design` | Kafka/SQS, outbox pattern, DLQ | Medium |
| `abuse-detection` | Trial abuse, prompt injection, rate limit | Medium |

## Bài học từ case study này

1. **Skill trigger = business language** — "billing fail" không phải "webhook handler bug". Viết description theo ngôn ngữ user sẽ gõ.
2. **Reference file bắt buộc** — Apple lifecycle, webhook events là domain knowledge thay đổi chậm, tách ra `references/` để update độc lập.
3. **`disable-model-invocation: true` cho incident** — production incident không nên agent tự chạy action, cần human review từng bước.
4. **Domain review > code review** — skill review nhìn vào revenue risk trước, code style sau.
