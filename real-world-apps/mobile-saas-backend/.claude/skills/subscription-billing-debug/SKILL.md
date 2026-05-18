---
name: subscription-billing-debug
description: >
  Use this skill when investigating any subscription or billing issue:
  purchase fail, restore lỗi, user mất premium, duplicate renew event,
  webhook race condition, grace period bug, entitlement mismatch,
  Apple/Google receipt validation error, refund not revoking access.
  Triggered by: "user mất subscription", "billing fail", "restore purchase",
  "duplicate event", "webhook", "receipt", "entitlement sai", "grace period".
---

# Subscription & Billing Debug

## Subscription lifecycle — trục tham chiếu

```
Trial → Active → (Renew | Cancel | Refund | Expire)
                        ↓            ↓
                  Grace Period → Expired
                        ↓
                  Lapsed (re-subscribe)
```

Apple thêm: Family Sharing, Introductory Offer, Promotional Offer, Billing Retry.
Google thêm: Account Hold, Pause, Deferred.

## Debug checklist — làm theo thứ tự

1. **Xác định subscription state hiện tại**
   - Hỏi: state trong DB là gì? Apple/Google API nói gì?
   - State mismatch là root cause 80% case

2. **Trace webhook timeline**
   - Lấy tất cả event trong 48h gần nhất theo `original_transaction_id`
   - Tìm event bị skip hoặc xử lý sai thứ tự
   - File reference: `references/webhook_events.md`

3. **Check idempotency**
   - Webhook có thể deliver nhiều lần — handler có idempotent không?
   - Duplicate event xử lý thế nào? Log duplicate hay upsert?

4. **Check grace period logic**
   - `DID_FAIL_TO_RENEW` + trong grace period → user vẫn có access
   - Grace period expire → `GRACE_PERIOD_EXPIRED` → revoke
   - Lỗi phổ biến: revoke quá sớm khi billing retry còn chạy

5. **Entitlement sync**
   - Entitlement update synchronous hay async?
   - Nếu async: lag bao nhiêu? User thấy trạng thái cũ bao lâu?
   - Refund event có trigger revoke entitlement không?

## Edge cases hay gặp

| Case | Dấu hiệu | Fix hướng |
|------|----------|-----------|
| Duplicate `DID_RENEW` | Charge 2 lần trong log | Idempotency key trên `transaction_id` |
| Grace period revoke sớm | User premium báo mất access trong 16 ngày | Check `is_in_billing_retry_period` trước khi revoke |
| Restore purchase race | 2 request restore cùng lúc | DB transaction + unique constraint |
| Family sharing edge | Member mất access khi owner cancel | Handle `REVOKE` notification riêng |
| Refund không revoke | Refund processed nhưng user vẫn premium | `REFUND` webhook → trigger entitlement job |
| Webhook out-of-order | `CANCEL` đến trước `PURCHASE` | Sort + replay theo `purchase_date_ms` |

## Reconciliation khi không chắc

Nếu DB state và Apple/Google state lệch:
1. Gọi Apple `verifyReceipt` hoặc Google `subscriptions.get` lấy ground truth
2. So sánh `expires_date` — tin platform, không tin DB
3. Chạy reconciliation job: query tất cả active subscription, verify từng cái

## Output format khi báo cáo

```
Root cause: [state mismatch / webhook miss / idempotency fail / ...]
Timeline: [event sequence ngắn gọn]
User impact: [bao nhiêu user, revenue ảnh hưởng]
Fix: [immediate mitigation] + [long-term fix]
Prevention: [idempotency / retry / reconciliation cron]
```

## References

- Apple subscription lifecycle: `references/apple_subscription_flow.md`
- Webhook event types: `references/webhook_events.md`
- Entitlement rules: `references/entitlement_rules.md`
