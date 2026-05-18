# Claude Code — Anatomy

## Loop chính

```
user prompt
   ↓
[hook: UserPromptSubmit]
   ↓
LLM (Sonnet/Opus/Haiku)
   ├─ đọc CLAUDE.md (auto-injected)
   ├─ đọc MEMORY.md (nếu có)
   ├─ thấy /command → load command file
   └─ thấy skill match → load SKILL.md
   ↓
tool call → [hook: PreToolUse] → execute → [hook: PostToolUse]
   ↓
loop tới khi xong → [hook: Stop]
```

## File precedence

1. CLI flag
2. `.claude/settings.local.json` (gitignored, per-user)
3. `.claude/settings.json` (committed, team)
4. `~/.claude/settings.json` (global user)
5. Default

## Memory anatomy

```
.claude/memory/
├── MEMORY.md            # index, luôn load vào context
├── user_role.md         # user là ai
├── feedback_testing.md  # rule user đã correct
├── project_freeze.md    # state dự án
└── ref_grafana.md       # link tài nguyên ngoài
```

Mỗi file có frontmatter:
```yaml
---
name: feedback-testing
description: User muốn integration test hit DB thật
metadata:
  type: feedback
---
```

## Agent vs Skill vs Command — quyết định khi nào dùng

| Câu hỏi | Đáp án |
|---------|--------|
| User cần gõ trigger? | Command |
| LLM nên tự load khi gặp pattern? | Skill |
| Cần context riêng, tốn token, kết quả tóm tắt? | Agent |
| Cần shell side-effect tự động? | Hook |

## Permission modes

- `default` — hỏi user mỗi tool nguy hiểm
- `acceptEdits` — auto accept file edit
- `bypassPermissions` — chạy mọi thứ (CI mode)
- `plan` — chỉ plan, không action

Cấu hình trong `settings.json`:
```json
{
  "permissions": {
    "allow": ["Bash(npm run *)", "Read(src/**)"],
    "deny": ["Bash(rm -rf *)"]
  }
}
```
