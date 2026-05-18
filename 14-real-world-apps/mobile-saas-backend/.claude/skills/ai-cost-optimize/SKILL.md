---
name: ai-cost-optimize
description: >
  Use this skill when analyzing or optimizing AI generation cost, GPU usage,
  token consumption, queue throughput, or detecting prompt abuse.
  Triggered by: "AI queue quá tải", "generation chậm", "token budget",
  "cost per request", "GPU burn", "rate limiting AI", "cache generation",
  "free user abuse", "margin AI feature", "latency AI".
---

# AI Cost Optimization

## Framework phân tích — 4 trục

```
Cost = Volume × Cost-per-call × (1 - Cache hit rate)
```

Trước khi optimize: đo đủ 4 trục này.

| Trục | Câu hỏi | Tool đo |
|------|---------|---------|
| Volume | Bao nhiêu request/phút? Free vs paid ratio? | API metrics, Datadog |
| Cost-per-call | Token count trung bình? Model nào? | LLM provider dashboard |
| Cache | Cache hit rate? Có cache không? | Redis/CDN metrics |
| Abuse | Top user by request? Burst pattern? | Log analysis |

## Chiến lược giảm cost — ưu tiên theo ROI

### 1. Cache generation output (ROI cao nhất)
- Nếu same prompt → same output: cache aggressively
- Cache key: `hash(prompt + model + params)`
- TTL: tùy content (photo caption = 7 ngày, news = 1h)
- Lưu ý: embedding-based similarity cache cho prompt gần giống nhau

### 2. Queue + async processing
```
Request → Queue → Worker pool → Webhook callback
```
- Không block user thread
- Priority queue: paid > free, retry > new
- Premium lane riêng tránh noisy neighbor

### 3. Model routing — rẻ trước, đắt sau
```
Simple request → Small model (rẻ hơn 10x)
Complex request → Large model
Failed/low quality → Retry với larger model
```

### 4. Quota enforcement theo entitlement
```
Free:    5 generations/ngày, small model only
Premium: 100 generations/ngày, large model
Pro:     unlimited, priority queue
```
- Enforce ở middleware, không ở business logic
- Rate limit: token bucket per user per feature

### 5. Batch processing
- Group nhiều request → 1 API call
- Hiệu quả cho: embedding, classification, batch image

### 6. Prompt optimization
- Trim whitespace, remove redundant instruction
- System prompt caching (Anthropic: cache_control)
- Few-shot example: chỉ lấy relevant examples

## Abuse detection

Dấu hiệu:
- User free có request spike > 10x bình thường
- Prompt rất ngắn (exploit template injection)
- Nhiều account từ same IP/device

Xử lý:
- Rate limit hard cap per device (không chỉ per user)
- CAPTCHA trigger khi burst
- Shadow ban: throttle thay vì block ngay

## Phân tích feature cost

Trước khi design AI feature:

```
Est. cost = Daily active users × usage rate × cost per call
Margin = Revenue per user - AI cost per user
```

Nếu margin < 0 với free user → cần harder quota hoặc async với delay.

## Output format khi báo cáo cost issue

```
Current: [X requests/day, $Y/day, Z% cache hit]
Hotspot: [feature / model / user segment tốn nhất]
Abuse: [có / không, pattern gì]
Quick win: [< 1 tuần implement]
Long-term: [queue / cache / model routing]
Est. saving: [$Z/month sau optimize]
```

## References

- Cost breakdown by feature: `references/cost_by_feature.md`
