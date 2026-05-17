# Cursor Rules — Playbook

> Rule tốt = **trigger đúng file · không lãng phí token · tái lặp ổn định**.
> Đây là phiên bản "skill" của Cursor: thay vì `SKILL.md`, bạn viết `.mdc`.

## 1. Rule là gì — so với Claude Code Skill

| Claude Code | Cursor | Ghi chú |
|-------------|--------|---------|
| `SKILL.md` (1 file / skill) | `.mdc` (1 file / rule) | Unit cơ bản |
| `description` → LLM tự load | `description` → agent-requested | Cùng cơ chế pull |
| `when_to_use` | `globs` hoặc `description` | Cursor có thêm glob trigger |
| `disable-model-invocation` | Không có tương đương | Cursor không hỗ trợ block auto |
| `context: fork` | Không có | Cursor chạy in-thread |
| `.claude/skills/<name>/` (folder) | `.cursor/rules/<name>.mdc` (file đơn) | Cursor không có thư mục con |

## 2. Anatomy của `.mdc`

```mdc
---
description: Mô tả ngắn — LLM đọc để quyết định có pull rule này không
globs:
  - "src/api/**/*.ts"
alwaysApply: false
---

# Rule Title

Body markdown — instruction agent đọc khi rule được attach.
```

### Frontmatter — 3 field chính

| Field | Giá trị | Khi nào dùng |
|-------|---------|--------------|
| `alwaysApply: true` | Bỏ `globs` + `description` | Rule áp mọi prompt — chi phí cao |
| `globs: [...]` | Pattern glob | Rule tự attach khi file match mở trong editor |
| `description: "..."` | Chuỗi text | LLM pull on-demand khi thấy liên quan |

> Ba loại **không loại trừ nhau**. `globs + description` = attach theo file VÀ agent có thể tự pull thêm.

## 3. Ba loại rule — quyết định 30 giây

```
Cần áp mọi lúc, không phụ thuộc context?    →  alwaysApply: true
Rule gắn với file/folder cụ thể?             →  globs
Rule gắn với task / scenario cụ thể?         →  description (agent-requested)
```

### Ví dụ chọn đúng loại

| Scenario | Loại đúng | Sai |
|----------|-----------|-----|
| "Không dùng `any` TypeScript" | `alwaysApply` | agent-requested (bỏ lỡ khi không hỏi) |
| "Convention viết NestJS controller" | `globs: src/api/**` | `alwaysApply` (lãng phí token trên file frontend) |
| "Rule migration DB an toàn" | `description` | `globs` (migration không phải `*.sql` duy nhất) |
| "Code style chung toàn team" | `alwaysApply` | `globs` (phụ thuộc file, dễ bỏ sót) |

## 4. Description quyết định trigger (agent-requested)

Giống Claude Code skill: description kém → rule không bao giờ được pull.

**4 nguyên tắc**

- **Cụ thể về task** — "Use this rule when writing SQL migrations" thay vì "Database utilities"
- **User intent** — mô tả việc user đang làm, không phải nội dung rule
- **Trigger context rõ** — list keyword / file type / command user hay gõ kèm
- **Ngắn** — agent đọc nhiều description cùng lúc; < 2 câu

```mdc
# Kém
description: "SQL và database utilities"

# Tốt
description: "Use when writing or reviewing SQL migrations, schema changes,
  or raw queries. Triggered by: ALTER TABLE, CREATE INDEX, migration files."
```

## 5. Context budget — chi phí token

Cursor inject rule vào **mỗi request** theo loại:

```
alwaysApply → inject mọi prompt
globs       → inject khi file match đang mở
agent-req   → inject khi LLM kéo về
```

**Hệ quả thực tế**

- `alwaysApply` tốn token ngay cả khi user hỏi "giải thích cái này" không liên quan rule
- File rule dài 1,000 dòng với `alwaysApply: true` = cháy token cả ngày
- Dùng `alwaysApply` cho **kiến thức nền tảng ngắn** (<50 dòng), không nhồi chi tiết

### Progressive disclosure trong Cursor

```
general.mdc (alwaysApply, < 50 dòng)     luôn vào context
backend.mdc (globs: src/api/**)           chỉ khi làm backend
sql-migration.mdc (description-based)    chỉ khi làm migration
```

Không tồn tại `references/` như Claude Code, nhưng có thể split file.

## 6. Quy tắc viết body

**DO**

```mdc
## DO
- Dùng `z.object()` validate mọi input ở controller layer
- Return `{ data, error, meta }` chuẩn cho mọi endpoint
- Rate limit public endpoint với `@Throttle(10, 60)`
```

**DON'T (gọi là anti-patterns)**

```mdc
## DON'T
- ❌ `SELECT *` — chỉ fetch field cần thiết
- ❌ Catch lỗi rồi swallow (silent fail)
- ❌ Business logic trong controller
```

**Ưu tiên example > prose dài**

```mdc
# Kém
Khi viết controller, hãy đảm bảo validation được thực hiện đúng cách
và error được xử lý phù hợp theo convention của team.

# Tốt
Controller phải:
1. Validate input với DTO + class-validator
2. Delegate sang service — không business logic
3. Throw exception rõ ràng, không return null
```

## 7. Hai cách tạo rule từ thực tế

Giống với Claude Code Skills:

### A. Extract from hands-on
Sau phiên làm việc với Cursor → note lại:
- Agent làm đúng gì mà không cần nhắc?
- Agent hay sai ở bước nào?
- Bạn phải sửa / nhắc lại mấy lần?

→ Đóng gói thành rule, test phiên tiếp theo.

### B. Synthesize from review
Xem lại diff / PR comment → tổng hợp pattern sai lặp lại → viết rule ngăn chặn.

## 8. Anti-patterns

- 🚫 `alwaysApply: true` cho rule dài > 100 dòng — cháy token vô ích
- 🚫 Description kiểu "Rule cho database" — không đủ cụ thể để trigger
- 🚫 1 file nhồi frontend + backend + db — LLM không trích đúng phần liên quan
- 🚫 Duplicate rule giữa `general.mdc` và `backend.mdc` — contradiction
- 🚫 Không version rule trong git — rule change không trace được
- 🚫 Rule > 500 dòng — không tồn tại progressive disclosure trong Cursor → phải split file

## 9. Bộ rule tối thiểu cho dự án mới

```
.cursor/rules/
├── general.mdc       alwaysApply — coding principles, language, format
├── frontend.mdc      globs: src/web/**
├── backend.mdc       globs: src/api/**
├── testing.mdc       globs: **/*.{test,spec}.ts
└── migration.mdc     description — SQL migration safety
```

Thêm khi cần: `security.mdc` (agent-requested), `performance.mdc`, `docs.mdc`.

## 10. Rule vs Command trong Cursor

| | Rule (`.mdc`) | Command (`.cursor/commands/*.md`) |
|-|---------------|----------------------------------|
| Trigger | Tự động (glob/desc/always) | User gõ `/command-name` |
| Mục đích | Convention, constraint, style | Workflow: review, commit, generate |
| Cần LLM kéo về | Có (agent-requested type) | Không — user chủ động |
| Side effect | Không | Có thể |

Xem thêm: [`rule-types.md`](./rule-types.md), ví dụ thực tế ở [`../examples/.cursor/rules/`](../examples/.cursor/rules/).
