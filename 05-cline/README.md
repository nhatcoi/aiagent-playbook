# 05 — Cline (formerly Claude Dev) + Roo Code

VSCode extension agent autonomous. Cline = bản gốc, Roo Code = fork với nhiều mode.

## Đặc trưng

- Plan / Act mode tách bạch
- Custom mode: code, architect, ask, debug, orchestrator…
- MCP support
- Workspace rules file
- Computer use: snap browser, click, type (Roo)

## Cấu trúc

```
.clinerules/                  # Cline
├── 01-coding.md
└── 02-architecture.md

.roo/                         # Roo Code
├── rules/
│   └── general.md
└── modes/
    └── architect.json        # custom mode
```

## Custom mode (Roo)

```json
{
  "slug": "go-expert",
  "name": "Go Expert",
  "roleDefinition": "Bạn là Go expert. Pure Go, không framework lạ. Lo về goroutine leak và data race.",
  "groups": ["read", "edit", "command"],
  "customInstructions": "Mọi public func phải có doc comment."
}
```

## Plan/Act split

```
Plan mode (read-only):
  - explore code, design approach, list steps
  → user duyệt
Act mode:
  - execute từng step
```

Tránh được agent code bừa.

## Repo
- [cline/cline](https://github.com/cline/cline)
- [RooCodeInc/Roo-Code](https://github.com/RooCodeInc/Roo-Code)

## Pattern đáng học
- **Plan/Act tách mode** — giảm agent off-track
- **Per-mode tool whitelist** — architect không edit file, code không browse web
- **Cost transparency** — show token + $ mỗi turn
