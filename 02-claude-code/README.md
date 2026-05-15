# 02 — Claude Code

CLI agent của Anthropic. Khác Cursor: scope rule theo **workflow / task**, không theo file. Hỗ trợ sub-agent, skill, hook, memory persistence.

## Cấu trúc chuẩn

```
project-root/
├── CLAUDE.md                 # bộ não trung tâm (system-level)
└── .claude/
    ├── agents/               # sub-agent định nghĩa
    │   ├── reviewer.md
    │   ├── investigator.md
    │   └── builder.md
    ├── commands/             # slash command custom (/foo)
    │   ├── commit.md
    │   └── review.md
    ├── skills/               # skill có thể invoke (load on demand)
    │   └── migrate-db/
    │       └── SKILL.md
    ├── memory/               # memory persistent across session
    │   ├── MEMORY.md         # index
    │   ├── user_role.md
    │   └── feedback_*.md
    ├── hooks/                # shell hook (SessionStart, PreToolUse…)
    │   └── pre-commit.sh
    ├── templates/            # snippet, boilerplate
    └── settings.json         # config (permission, model, env)
```

## CLAUDE.md = bộ não

```markdown
# Project: Foo Bar API

## Stack
Node 20 + NestJS + Postgres 16 + Redis

## Engineering Principles
- Đọc trước khi viết
- Reuse module
- Không break public API
- Composition > inheritance

## Workflow
1. Search existing implementation
2. Create plan
3. Implement incrementally
4. Run tests
5. Update docs

## Important paths
- Schema: prisma/schema.prisma
- Migrations: prisma/migrations/
- API entry: apps/api/src/main.ts

## Forbidden
- Không commit khi user chưa duyệt
- Không sửa migration đã merge
```

## Sub-agent

```markdown
---
name: reviewer
description: Review diff, severity-tagged, no praise
tools: Read, Grep, Bash
model: sonnet
---

Bạn là senior reviewer. Output format:
`path:line: <emoji> <severity>: <problem>. <fix>.`
Skip nit, focus correctness/security/perf.
```

Gọi bằng Agent tool với `subagent_type: reviewer`.

## Skills vs Commands vs Agents

| Loại | Trigger | Phạm vi | Khi dùng |
|------|---------|---------|----------|
| Command | User gõ `/foo` | Cùng thread | Workflow user thực hiện |
| Skill | LLM tự invoke | Cùng thread | Capability mở rộng on-demand |
| Agent | LLM spawn | Thread riêng (isolated context) | Task tốn token, độc lập |

## Hooks

```json
// .claude/settings.json
{
  "hooks": {
    "PreToolUse": [
      { "matcher": "Bash", "hooks": [{ "command": "scripts/audit.sh" }] }
    ],
    "SessionStart": [
      { "hooks": [{ "command": "scripts/load-context.sh" }] }
    ]
  }
}
```

## So sánh nhanh

| Cursor | Claude Code |
|--------|-------------|
| `.cursor/rules/*.mdc` (glob-scoped) | `CLAUDE.md` + `.claude/*` (task-scoped) |
| 1 agent | Multi-agent (Task tool) |
| Không hook | Hook đầy đủ |
| Không skill | Skill loadable |
| Memory: chat history | Memory: file-based persistent |

## Tài liệu chính
- https://docs.claude.com/en/docs/claude-code/overview
- https://docs.claude.com/en/docs/claude-code/sub-agents
- https://docs.claude.com/en/docs/claude-code/skills
- https://docs.claude.com/en/docs/claude-code/hooks
