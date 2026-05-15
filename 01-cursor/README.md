# 01 — Cursor

Cursor = IDE fork từ VSCode, tích hợp agent. Triết lý: **rule scoped theo file pattern**, agent đọc rule liên quan thôi.

## Cấu trúc chuẩn

```
.cursor/
├── rules/
│   ├── general.mdc        # áp mọi nơi (alwaysApply: true)
│   ├── frontend.mdc       # glob: src/web/**
│   ├── backend.mdc        # glob: src/api/**
│   ├── database.mdc       # glob: db/migrations/**
│   ├── testing.mdc        # glob: **/*.test.ts
│   └── architecture.mdc   # description-based, agent tự pick
└── commands/              # slash commands (Cursor 0.42+)
    └── review.md
```

## File `.mdc` (Markdown + Config)

```mdc
---
description: Rule cho code frontend React
globs:
  - "src/web/**/*.{ts,tsx}"
alwaysApply: false
---

# Frontend Rules

- Dùng functional component + hooks
- State global → Zustand, không Redux
- Style: Tailwind, không CSS module
- Test: Vitest + React Testing Library

## Anti-patterns
- ❌ class component
- ❌ `any` type
- ❌ inline style object
```

## 3 loại rule

| Loại | Cấu hình | Khi trigger |
|------|----------|-------------|
| Always | `alwaysApply: true` | Mọi prompt |
| Auto-attached | `globs: [...]` | Khi file matching trong context |
| Agent-requested | `description: ...` | LLM tự quyết định pull |

## So sánh Cursor vs Claude Code

| Khía cạnh | Cursor | Claude Code |
|-----------|--------|-------------|
| Scope rule | File pattern (glob) | Workflow / task |
| Entry point | `.cursor/rules/*.mdc` | `CLAUDE.md` |
| Sub-agent | Không (1 agent chính) | `.claude/agents/*.md` |
| Slash command | `.cursor/commands/*.md` | `.claude/commands/*.md` |
| Hook | Không có | `.claude/hooks/` |
| Memory | Không native | `.claude/memory/` |

## Tài liệu chính thức
- https://docs.cursor.com/context/rules
- https://docs.cursor.com/agent

## Xem thêm
- [docs/](./docs) — chi tiết từng loại rule
- [examples/](./examples) — bộ rule mẫu cho dự án full-stack
