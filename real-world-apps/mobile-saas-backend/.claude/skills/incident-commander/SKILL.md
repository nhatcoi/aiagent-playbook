---
name: incident-commander
description: >
  Use this skill when responding to production incidents affecting revenue,
  subscription, or AI services. Triggered by: "production down", "revenue drop",
  "subscription broken", "entitlement wrong", "AI generation fail",
  "webhook backlog", "blast radius", "/incident".
context: fork
disable-model-invocation: true
---

# Incident Commander

> Bước 1: đừng panic. Bước 2: làm theo checklist.

## Phase 1 — Detect & Scope (5 phút đầu)

```
1. Xác định symptom: user-facing hay internal?
2. Revenue pipeline bị ảnh hưởng không? (purchase / renew / entitlement)
3. Blast radius: bao nhiêu user? bao nhiêu %?
4. Start time: khi nào bắt đầu? Build nào deploy gần nhất?
5. Severity:
   - P0: revenue pipeline down, 100% user bị ảnh hưởng
   - P1: partial revenue impact, >10% user
   - P2: non-revenue, <10% user
```

## Phase 2 — Immediate Mitigation

Làm ngay, không chờ root cause:

| Symptom | Mitigation |
|---------|-----------|
| Webhook backlog lớn | Scale worker + pause non-critical queue |
| AI queue overload | Enable rate limit cứng, drop free tier tạm |
| Subscription state sai | Flag affected users, freeze state change |
| Entitlement wrong | Fallback: default to last known good state |
| Build mới gây lỗi | Rollback ngay nếu < 30 phút deploy |

## Phase 3 — Root Cause

Timeline:
```
1. Lấy error log từ thời điểm start → sekarang
2. Diff deploy gần nhất
3. Trace 1 affected user end-to-end
4. Xác định: code bug / data bug / infra / third-party (Apple/Google)?
```

## Phase 4 — Communication

**Stakeholder update (gửi mỗi 15 phút trong incident)**:

```
[TIME] Incident Update — [SEVERITY]

Status: Investigating / Mitigating / Resolved
Impact: [mô tả ngắn]
Affected: [user segment / % / revenue estimate]
Current action: [đang làm gì]
ETA: [khi nào xong hoặc update tiếp theo]
```

**Post-incident (sau resolve, trong 24h)**:

```
## Incident Report — [date]

### Timeline
- HH:MM: [event]

### Root Cause
[1 paragraph]

### Impact
- Users affected:
- Revenue impact:
- Duration:

### Fix
[immediate fix + long-term fix]

### Prevention
[checklist item thêm vào / alert thêm / test thêm]
```

## Câu hỏi cần hỏi ngay

- "Deploy gần nhất là lúc nào?"
- "Apple/Google dashboard có alert không?"
- "Webhook delivery rate bình thường không?"
- "Error rate của subscription API đang là bao nhiêu?"
- "Có thể rollback không?"

## Revenue triage — ưu tiên fix theo thứ tự

```
1. Purchase flow (tiền mới)
2. Renewal flow (recurring revenue)
3. Entitlement (user experience)
4. Analytics (tracking)
5. Ads (secondary revenue)
```
