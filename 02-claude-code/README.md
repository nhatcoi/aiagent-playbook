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

## Ecosystem repos — kit & collections

Claude Code không có marketplace chính thức. Repo dưới đây là nguồn cộng đồng.

### Phân loại

| Loại | Repo | Mục đích |
|------|------|----------|
| **Kit / Starter** | [duthaho/claudekit](https://github.com/duthaho/claudekit) | Pre-built commands, skills, hooks — copy thẳng vào `.claude/` |
| **Kit / Starter** | [garrytan/gstack](https://github.com/garrytan/gstack) | Setup cá nhân Garry Tan — thiên về workflow cấu hình |
| **Official** | [anthropics/skills](https://github.com/anthropics/skills) | Official Agent Skills từ Anthropic |
| **Framework / methodology** | [obra/superpowers](https://github.com/obra/superpowers) | Skill framework + methodology — cách tổ chức và thiết kế skill hơn là content sẵn có |
| **Skills engineering** | [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills) | Production-grade engineering skills (Addy Osmani) |
| **Agents & commands** | [wshobson/agents](https://github.com/wshobson/agents) + [commands](https://github.com/wshobson/commands) | Sub-agents + slash commands theo domain |
| **Curated list** | [hesreallyhim/awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code) | Tổng hợp mọi thứ xung quanh Claude Code |
| **Curated list** | [VoltAgent/awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents) | Sub-agents collection chuyên biệt |
| **Curated list** | [VoltAgent/awesome-agent-skills](https://github.com/VoltAgent/awesome-agent-skills) | 1,000+ skills cộng đồng |
| **Token optimization** | [rtk-ai/rtk](https://github.com/rtk-ai/rtk) | CLI proxy lọc output, giảm 60-90% token dev commands |
| **Usage analytics** | [ryoppippi/ccusage](https://github.com/ryoppippi/ccusage) | Phân tích token consumption của Claude Code |

### Khi nào dùng loại nào

```
Mới bắt đầu, muốn có ngay bộ tool  →  duthaho/claudekit
Muốn hiểu cách thiết kế skill      →  obra/superpowers
Cần skill theo domain cụ thể        →  wshobson/agents + addyosmani/agent-skills
Muốn khám phá / tìm inspiration     →  awesome-claude-code (hesreallyhim)
Đang burn token quá nhiều           →  rtk-ai/rtk
```

### Kit vs Collection vs Framework

| | Kit | Collection | Framework |
|-|-----|-----------|-----------|
| Cài thế nào | Copy `.claude/` folder | Chọn từng file cần | Đọc methodology, tự viết |
| Time-to-use | < 5 phút | 30 phút | Ngày - tuần |
| Tailored | Ít | Trung bình | Cao |
| Ví dụ | claudekit | wshobson/agents | superpowers |

> **Gợi ý thực tế**: bắt đầu từ kit → chạy thật → extract những gì hoạt động → synthesize thành skill riêng theo `docs/skills-playbook.md`.

## Deep-dive nội bộ
- [docs/anatomy.md](./docs/anatomy.md) — loop, file precedence, permission modes
- [docs/skills-playbook.md](./docs/skills-playbook.md) — viết skill tự kích hoạt, không tốn context, tái lặp ổn định

## Tài liệu chính
- https://docs.claude.com/en/docs/claude-code/overview
- https://docs.claude.com/en/docs/claude-code/sub-agents
- https://docs.claude.com/en/docs/claude-code/skills
- https://docs.claude.com/en/docs/claude-code/hooks
