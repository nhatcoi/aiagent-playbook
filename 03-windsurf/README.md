# 03 — Windsurf (Codeium)

IDE agent của Codeium. Triết lý: **Cascade** = agent autonomous chain-of-thought, edit/run/test trong 1 flow.

## Cấu trúc

```
.windsurf/
├── rules/
│   ├── global.md       # always
│   └── project.md      # workspace-level
└── workflows/          # multi-step workflow user-defined
    └── ship-feature.md
```

Hoặc file đơn `.windsurfrules` ở root (giống `.cursorrules`).

## Cascade flow

```
User: "thêm endpoint /users/:id/orders"
  ↓
Cascade:
  - search code → tìm pattern endpoint cũ
  - tạo controller + service + repo
  - chạy test
  - nếu fail → tự fix → retry
  - report diff
```

Khác Cursor:
- Cursor: edit suggest, user phải accept
- Windsurf: chạy tận end-to-end, có thể commit

## Memories
Windsurf có memory tự động: lưu fact về codebase, user preference qua session.

## Tài liệu
- https://docs.windsurf.com
- https://windsurf.com

## Repo / examples
- [Codeium/windsurf-docs](https://github.com/Exafunction) — hub Codeium
- Awesome rule: thường share trong `awesome-windsurf-rules`

## So sánh

| | Cursor | Windsurf | Claude Code |
|-|--------|----------|-------------|
| Mode mặc định | Suggest | Autonomous | Interactive agent |
| Rule scope | File glob | File + workflow | Workflow |
| Memory native | ❌ | ✅ | ✅ |
| Sub-agent | ❌ | ❌ | ✅ |
