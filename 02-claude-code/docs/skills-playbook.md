# Skills — Playbook

> Skill tốt = **tự kích hoạt đúng lúc · không tốn context vô ích · tái lặp ổn định**.
> Thiếu 1 trong 3 → đừng viết skill, viết command hoặc agent.

## 1. Skill là gì

Một **thư mục** chứa:

```
.claude/skills/<skill-name>/
├── SKILL.md           # bắt buộc — frontmatter + body
├── scripts/           # mã agent sẽ thực thi
├── references/        # tài liệu load on-demand
└── assets/            # template, schema, fixture…
```

**Critical rule:** Claude **không tự quét** thư mục con. Mọi file hỗ trợ phải được tham chiếu rõ ràng trong `SKILL.md` (đường dẫn tương đối). Để file trong `references/` mà không nhắc → coi như không tồn tại.

## 2. SKILL.md — anatomy

```markdown
---
name: pdf-processing
description: Extract text and tables from PDF files. Use when user pastes a PDF path or asks "parse this PDF".
---

# Body markdown — instruction agent đọc khi skill được load.
```

### Frontmatter bắt buộc

| Field | Ràng buộc |
|-------|-----------|
| `name` | kebab-case, lowercase, 1 dấu `-`, không leading/trailing/double hyphen |
| `description` | 1-1024 ký tự (Claude Code: `description + when_to_use` cap 1,536) |

**Valid vs invalid name**

```
✅ pdf-processing      ❌ PDF-Processing   (uppercase)
✅ data-analysis       ❌ -pdf             (leading hyphen)
✅ code-review         ❌ pdf--processing  (double hyphen)
```

### Frontmatter tuỳ chọn

| Field | Khi nào dùng |
|-------|--------------|
| `disable-model-invocation: true` | Skill có side effect (deploy, commit, Slack) — chỉ chạy khi user gõ `/skill-name` |
| `user-invocable: true` | Cho phép user gọi qua slash command |
| `allowed-tools` | Whitelist tool skill được phép dùng |
| `model` / `effort` | Override model hoặc reasoning effort |
| `context: fork` | Chạy trong context fork riêng (không ô nhiễm main thread) |
| `agent hooks` / `paths` / `shell` | Hook lifecycle, đường dẫn ràng buộc, shell command kèm theo |

## 3. Description quyết định 90% khả năng kích hoạt

Khi user **không** gõ `/skill-name`, Claude quyết định load skill dựa vào `description` + `when_to_use`. Description viết kém → skill không bao giờ trigger.

**4 nguyên tắc**

- **Imperative** — bắt đầu bằng "Use this skill when…"
- **User intent** — mô tả việc user đang cố làm, không phải tính năng skill có
- **Pushy** — liệt kê các context áp dụng cụ thể
- **Concise** — 1 câu đến 1 đoạn ngắn

**Đối chiếu**

```
🚫 "PDF utilities for extracting content"
✅ "Use this skill when user asks to extract text, tables, or
   metadata from a PDF, or pastes a .pdf path/URL."
```

## 4. Hai loại skill — chọn đúng loại trước khi viết

| Loại | Trigger | `disable-model-invocation` | Ví dụ |
|------|---------|---------------------------|-------|
| **Reference** | Agent tự load khi gặp pattern | `false` (mặc định) | API conventions, schema docs, code style guide |
| **Task** | User gõ `/skill-name` | `true` (an toàn) | deploy, commit, db-migrate, release |

### Task skill — ví dụ chuẩn

```markdown
---
name: deploy
description: Deploy the application to production
context: fork
disable-model-invocation: true
---

Deploy the application:
1. Run the test suite
2. Build the application
3. Push to the deployment target
```

**Nguyên tắc side-effect = block auto:** nếu skill ghi vào file shared / push remote / gọi API có chi phí → bật `disable-model-invocation: true`. Tránh tình huống Claude vừa review xong code rồi tự "looks good, deploying!".

## 5. Hai cách sinh ra skill từ thực tế

### A. Extract from hands-on
Trích từ công việc thủ công bạn vừa làm cùng Claude → tổng hợp thành quy ước.

### B. Synthesize from artifacts
Dựa vào failures + fixes, transcript, review comment → đúc kết.

**Trong cả 2 cách, ghi chú lại:**

- Các bước **bạn** làm tốt
- Các bước **agent** làm tốt (và bước nào nó hay sai)
- Format input / output cụ thể
- Thông tin dự án mà **bạn** đã phải cung cấp lặp lại

Sau đó: **step 2 — thực thi và revise**. Skill v1 không bao giờ đúng; chạy thật, sửa, commit lại.

## 6. Context budget

Khi skill được load, **toàn bộ SKILL.md đi vào context window**. Vì vậy:

- Đừng viết lại kiến thức agent đã biết (cú pháp Python, cách `git commit`…)
- Đừng nhồi mọi chi tiết — agent không trích xuất được phần liên quan, dễ làm theo instruction sai cho task hiện tại
- **Concise stepwise + working example** > exhaustive documentation

### Progressive disclosure

```
SKILL.md           ≤ 500 dòng / ~5,000 tokens   (luôn vào context)
references/*.md    chi tiết, agent đọc on-demand qua Read
scripts/*          code, agent đọc khi cần thực thi
```

Quy tắc: nếu phải thêm dòng thứ 501, đẩy chi tiết sang `references/` và để SKILL.md trỏ tới đó.

## 7. Boundary — phạm vi skill

Không quá rộng cũng không quá hẹp.

```
✅ "DB query + result formatting"
🚫 thêm "DB admin / migration / backup" → quá rộng, description loãng
🚫 tách thành "DB query" và "result formatting" riêng → trigger không đáng tin
```

**Test boundary:** viết description xong, tự hỏi *"có context nào skill nên match nhưng description không gọi tên ra không?"* Nếu có → mở rộng description, không mở rộng scope.

## 8. Vòng đời — mỗi lần sửa, thêm note

Mỗi khi bạn sửa hành vi của agent (correct nó, đổi prompt, đổi tool whitelist) → thêm dòng note vào skill. Skill là **memory đông cứng** cho 1 workflow; thiếu vòng feedback thì nó stale.

## 9. Anti-patterns

- 🚫 Để file trong `references/` mà SKILL.md không nhắc → invisible
- 🚫 Description kiểu "Utilities for X" — không có user intent, không trigger
- 🚫 Skill có side effect nhưng để `disable-model-invocation: false`
- 🚫 SKILL.md > 500 dòng — nhồi mọi thứ vào main context
- 🚫 Skill bao trùm nhiều domain → kích hoạt sai lúc, hoặc không bao giờ
- 🚫 Viết skill cho task chỉ làm 1 lần — đó là prompt, không phải skill
- 🚫 Copy doc framework vào SKILL.md — agent đã biết, lãng phí token

## 10. Skill vs Command vs Agent — quyết định 30 giây

| Câu hỏi | Đáp án |
|---------|--------|
| User chủ động gõ trigger? | **Command** |
| Agent tự load khi gặp pattern, không side-effect? | **Skill** (reference) |
| User gõ `/x`, có side-effect, cần block auto? | **Skill** (task, `disable-model-invocation: true`) |
| Cần context window riêng, tốn token, trả về summary? | **Agent** |
| Cần shell side-effect tự động theo event? | **Hook** |

Xem thêm: [`anatomy.md`](./anatomy.md), ví dụ thực tế ở [`../examples/.claude/skills/migrate-db/SKILL.md`](../examples/.claude/skills/migrate-db/SKILL.md).
