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

## Ecosystem repos — kit & collections

| Loại | Repo | Mục đích |
|------|------|----------|
| **CLI Kit** | [duongductrong/cursor-kit](https://github.com/duongductrong/cursor-kit) | CLI khởi tạo rule, commands, skills; kéo template; share config |
| **Community directory** | [pontusab/cursor.directory](https://github.com/pontusab/cursor.directory) | Directory rule theo stack, search được |
| **Curated list** | [PatrickJS/awesome-cursorrules](https://github.com/PatrickJS/awesome-cursorrules) | `.cursorrules` theo từng ngôn ngữ / framework |
| **Agentic workflow** | [s-smits/agentic-cursorrules](https://github.com/s-smits/agentic-cursorrules) | Rule biến Cursor thành agent tự lập kế hoạch |
| **Devin-like** | [grapeot/devin.cursorrules](https://github.com/grapeot/devin.cursorrules) | Rule làm Cursor gần giống Devin: plan → execute → reflect |
| **Method** | [bmadcode/BMAD-METHOD](https://github.com/bmadcode/BMAD-METHOD) | Framework dùng rule + agent cho product dev (work cả Cursor + Claude) |

### Khi nào dùng loại nào

```
Bắt đầu dự án, cần bộ rule nhanh     →  cursor.directory hoặc awesome-cursorrules
Muốn CLI khởi tạo có tool tốt         →  cursor-kit
Muốn Cursor tự plan + loop agent      →  agentic-cursorrules hoặc devin.cursorrules
Làm product team, cần method rõ       →  BMAD-METHOD
```

## Deep-dive nội bộ
- [docs/rule-types.md](./docs/rule-types.md) — 4 loại rule, best practices
- [docs/rules-playbook.md](./docs/rules-playbook.md) — viết rule trigger đúng, không tốn token, tái lặp ổn định

## Tài liệu chính thức
- https://docs.cursor.com/context/rules
- https://docs.cursor.com/agent

## Xem thêm
- [examples/](./examples) — bộ rule mẫu cho dự án full-stack
- [references.md](./references.md) — links tổng hợp
