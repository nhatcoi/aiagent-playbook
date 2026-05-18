# 15 — OpenAI Codex CLI

CLI coding agent open-source của OpenAI (2025). Tương đương Claude Code phía OpenAI. Viết bằng Rust + TypeScript wrapper, chạy local, sandbox built-in.

> Khác **OpenAI Codex (cloud)** — service trên ChatGPT chạy task song song trên cloud sandbox. Folder này tập trung **Codex CLI** (terminal, OSS).

## Cấu trúc chuẩn

```
project-root/
├── AGENTS.md                  # bộ não — instructions cấp project
└── .codex/                    # (optional, per-project override)
    ├── config.toml
    └── prompts/               # custom prompt / slash command
        ├── review.md
        └── plan.md

~/.codex/                      # global config
├── config.toml
├── AGENTS.md                  # global instructions
├── prompts/
├── log/
└── sessions/
```

## `AGENTS.md` = bộ não trung tâm

Giống `CLAUDE.md` nhưng tên file chuẩn hóa khác. Codex auto-load `AGENTS.md` ở:
1. `~/.codex/AGENTS.md` (global)
2. Repo root
3. Workdir hiện tại

Tất cả merge lại theo thứ tự specific > general.

```markdown
# Project: Foo API

## Stack
Go 1.23, Postgres, Redis

## Workflow
1. Search existing code
2. Plan
3. Implement
4. Test
5. Update docs

## Forbidden
- ❌ commit không có user confirm
- ❌ skip pre-commit hook
- ❌ chạy `rm -rf` ngoài /tmp

## Style
- gofmt + golangci-lint sạch
- table-driven test
- error wrap với `fmt.Errorf("...: %w", err)`
```

## `~/.codex/config.toml`

```toml
model = "gpt-5-codex"
model_provider = "openai"
approval_policy = "on-failure"   # untrusted | on-failure | on-request | never
sandbox_mode = "workspace-write" # read-only | workspace-write | danger-full-access
notify = ["terminal-notifier"]   # macOS notification

[model_providers.openai]
name = "OpenAI"
base_url = "https://api.openai.com/v1"

[mcp_servers.github]
command = "npx"
args = ["-y", "@modelcontextprotocol/server-github"]
env = { GITHUB_PERSONAL_ACCESS_TOKEN = "ghp_..." }

[shell_environment_policy]
inherit = "core"
include_only = ["PATH", "HOME", "LANG"]
```

## Approval modes

| Mode | Read file | Edit file | Run command | Network |
|------|-----------|-----------|-------------|---------|
| `untrusted` | Hỏi | Hỏi | Hỏi | Hỏi |
| `on-failure` | Auto | Auto | Auto, hỏi nếu fail | Hỏi |
| `on-request` | Auto | Auto | Auto trừ destructive | Hỏi |
| `never` | Auto tất | Auto tất | Auto tất | Auto |

CLI flag: `codex --ask-for-approval untrusted` hoặc `codex -a never` (CI).

## Sandbox

- macOS: Seatbelt (`sandbox-exec`)
- Linux: Landlock + seccomp
- `workspace-write`: chỉ ghi trong cwd + `/tmp`, không network
- `danger-full-access`: tắt sandbox (CI / Docker)

## Slash commands (prompts)

`~/.codex/prompts/review.md`:
```md
Review diff hiện tại. Output: file:line — vấn đề — fix.
Skip lint. Focus correctness + security.
```

Gọi trong session: `/review`

## So sánh Codex CLI vs Claude Code vs Aider

| | Codex CLI | Claude Code | Aider |
|-|-----------|-------------|-------|
| Vendor | OpenAI | Anthropic | Community |
| OSS | ✅ Apache 2.0 | ❌ (CLI binary) | ✅ Apache 2.0 |
| Model | GPT-5-codex, GPT-4.1, qua provider config | Claude Sonnet/Opus/Haiku | Any (LiteLLM) |
| Brain file | `AGENTS.md` | `CLAUDE.md` | `CONVENTIONS.md` |
| Sub-agent | ❌ (1 agent) | ✅ `.claude/agents/` | ❌ |
| Skill | ❌ | ✅ `.claude/skills/` | ❌ |
| Hooks | ❌ | ✅ | ❌ |
| Slash command | ✅ `prompts/` | ✅ `commands/` | ✅ `/` built-in |
| MCP | ✅ | ✅ | ⚠️ partial |
| Sandbox built-in | ✅ Seatbelt/Landlock | ⚠️ permission-based | ❌ |
| Git auto-commit | ❌ (manual) | ❌ | ✅ |
| TUI | ✅ Ink | ✅ Ink | terminal raw |

## Convention `AGENTS.md`

`AGENTS.md` đang trở thành **chuẩn cross-vendor**. Sourcegraph Cody, Cursor, Codex đều đọc. Anthropic Claude Code đọc `CLAUDE.md` nhưng cũng fallback `AGENTS.md`. Cấu trúc tối thiểu:

```markdown
# Project Name

## Setup
<command để dev chạy được local>

## Build / Test
<command build, test, lint>

## Code Style
<key conventions>

## PR rules
<commit message format, branch, review checklist>
```

Mục tiêu: agent (bất kể vendor) đọc 30 giây là code đúng convention.

## Khi chọn Codex CLI

- Đã trả ChatGPT Plus/Pro/Business (subscription auth) → tiết kiệm so với pay-per-token
- Cần OSS, audit được source
- Cần sandbox cứng (Seatbelt/Landlock)
- Muốn dùng GPT-5/o-series cho coding

Không chọn nếu: cần sub-agent multi-context, cần skill load on-demand → Claude Code hợp hơn.

## Tài liệu
- Repo: [openai/codex](https://github.com/openai/codex)
- Docs: https://github.com/openai/codex/tree/main/docs
- AGENTS.md spec: https://agents.md
- Cloud version: https://openai.com/codex
