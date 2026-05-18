# Apple Subscription Flow — Reference

## Notification types (App Store Server Notifications V2)

| Notification | subtype | Ý nghĩa |
|-------------|---------|---------|
| `SUBSCRIBED` | `INITIAL_BUY` | Mua lần đầu |
| `SUBSCRIBED` | `RESUBSCRIBE` | Tái đăng ký sau cancel |
| `DID_RENEW` | `— ` | Renew thành công |
| `DID_FAIL_TO_RENEW` | `GRACE_PERIOD` | Billing fail, vào grace period (16 ngày) |
| `DID_FAIL_TO_RENEW` | `— ` | Billing fail, hết grace period |
| `EXPIRED` | `VOLUNTARY` | User cancel |
| `EXPIRED` | `BILLING_RETRY` | Hết billing retry |
| `EXPIRED` | `PRICE_INCREASE` | Không đồng ý tăng giá |
| `GRACE_PERIOD_EXPIRED` | `— ` | Grace period kết thúc |
| `REFUND` | `— ` | Apple refund |
| `REVOKE` | `— ` | Family sharing member mất access |
| `OFFER_REDEEMED` | `— ` | Dùng promo code |

## Grace period

- Kéo dài 16 ngày (subscriptions > 1 month) hoặc 6 ngày (weekly)
- Trong grace period: user **vẫn có access**
- `is_in_billing_retry_period: true` → đang retry
- Không revoke cho đến `GRACE_PERIOD_EXPIRED`

## Idempotency key

Dùng `transaction_id` (unique per transaction) làm idempotency key.
`original_transaction_id` = group tất cả renew của 1 subscription.
