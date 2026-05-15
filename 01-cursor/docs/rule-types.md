# Cursor Rule Types — chi tiết

## 1. Always-applied

```mdc
---
alwaysApply: true
---
- Code phải có type, không `any`
- Comment tiếng Anh
```

Dùng cho rule global, không phụ thuộc context. Nhớ: rule này nhồi vào MỌI prompt → tốn token.

## 2. Auto-attached (glob)

```mdc
---
globs:
  - "src/**/*.tsx"
  - "src/**/*.ts"
alwaysApply: false
---
```

Cursor scan các file đang mở / mention trong chat → nếu match glob → attach rule. Hiệu quả nhất khi:
- Project có nhiều stack khác nhau
- Mỗi folder có convention riêng

## 3. Agent-requested

```mdc
---
description: "Rule cho viết SQL migration an toàn"
alwaysApply: false
---
```

Không glob. LLM đọc `description` → tự quyết định pull rule nếu thấy liên quan. Phù hợp cho rule task-specific (migration, refactor pattern, security review).

## 4. Manual (legacy `.cursorrules`)

File cũ, đặt ở root. Vẫn hoạt động nhưng nên migrate sang `.cursor/rules/`.

## Best practices

- Mỗi rule file < 500 dòng
- 1 rule = 1 concern (đừng nhét frontend + backend + db vào 1 file)
- Dùng heading rõ: `## DO`, `## DON'T`
- Examples > Rules dài dòng
- Version rule trong git, review như code
