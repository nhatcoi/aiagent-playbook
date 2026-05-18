# AGENTS.md — Cross-vendor convention

`AGENTS.md` là file markdown ở repo root mô tả project cho coding agent. Không phải spec chính thức (chưa có RFC), nhưng đã được Codex, Cody, Aider, Continue, Cursor (qua rule) công nhận.

## Tại sao có

Mỗi vendor 1 tên: `CLAUDE.md`, `.cursorrules`, `.windsurfrules`, `.github/copilot-instructions.md`, `CONVENTIONS.md`. Project dùng 3 agent → 3 file trùng nội dung. `AGENTS.md` = chuẩn chung.

## Cấu trúc đề xuất

```markdown
# <Project Name>

Mô tả 2-3 dòng project là gì.

## Setup
Cách clone + chạy local. Command cụ thể.

## Architecture
Layout cấp cao. Module chính. Boundary.

## Build / Test / Lint
Command để verify code đúng. Agent sẽ chạy trước khi báo done.

## Code Style
Convention quan trọng. Naming. Pattern.

## Database / Migration
Quy tắc khi đụng schema (nếu có).

## Security
Secret handling. Forbidden actions.

## PR / Commit
Format commit. Branch naming. Review checklist.

## Forbidden
Hành vi cấm tuyệt đối.
```

## Best practices

- < 200 dòng — dài hơn agent bỏ qua giữa
- Mỗi heading rõ scope (không trộn frontend + backend nếu repo lớn)
- Code block với command cụ thể tốt hơn diễn giải
- DO / DON'T list ngắn hơn paragraph
- Update khi convention thay đổi (như CHANGELOG.md)

## Nested AGENTS.md

Codex support nested: `apps/web/AGENTS.md` override root khi agent làm việc trong `apps/web/`. Tốt cho monorepo.

## Tools đọc AGENTS.md (2026)

| Tool | Đọc trực tiếp | Cách dùng |
|------|---------------|-----------|
| OpenAI Codex CLI | ✅ native | `AGENTS.md` ở root |
| Sourcegraph Cody | ✅ | tự load |
| Claude Code | ⚠️ fallback | nếu không có `CLAUDE.md` |
| Aider | ✅ qua `read:` config | `.aider.conf.yml` |
| Cursor | ⚠️ qua `.cursor/rules/agents.mdc` reference | manual |
| Continue.dev | ✅ qua context provider | config |

Hướng cross-vendor: viết `AGENTS.md` chính, symlink `CLAUDE.md` và `CONVENTIONS.md` cho vendor riêng.

## Ví dụ thật

- [openai/codex](https://github.com/openai/codex/blob/main/AGENTS.md)
- [agents.md](https://agents.md) — spec proposal cộng đồng
