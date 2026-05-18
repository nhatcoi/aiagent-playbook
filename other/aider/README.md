# 04 — Aider

CLI pair-programmer **git-native**. Mỗi edit = 1 commit. Triết lý: dùng git làm memory + audit trail.

## Đặc trưng

- Repo map: aider scan repo → tạo abstract map → đưa LLM context biết file nào liên quan
- Edit format: SEARCH/REPLACE block (text-based diff)
- Auto-commit mỗi edit, commit message do LLM tạo
- Hỗ trợ nhiều model: GPT-4, Claude, Llama, DeepSeek (cost-effective)

## Cấu trúc

```
project/
├── .aider.conf.yml      # config
├── .aiderignore         # giống .gitignore
├── .aider.tags.cache/   # cache repo map
└── CONVENTIONS.md       # rule giống CLAUDE.md
```

## `.aider.conf.yml`

```yaml
model: claude-sonnet-4-6
edit-format: diff
auto-commits: true
dirty-commits: true
read:
  - CONVENTIONS.md
  - docs/architecture.md
test-cmd: pnpm test
```

## Workflow

```
$ aider src/api/user.ts
> add pagination to listUsers

aider: [scan repo map]
       [generate SEARCH/REPLACE]
       [apply]
       [git commit "feat: paginate listUsers"]
       [run test-cmd]
       [report]
```

## Mạnh / yếu

| Mạnh | Yếu |
|------|-----|
| Git history rõ ràng | Không có UI |
| Hỗ trợ nhiều model | Edit format đôi khi fail |
| Repo map hiệu quả với codebase lớn | Không multi-agent |
| Mode `/architect` planning | Không sandbox tool tích hợp |

## Repo
- [Aider-AI/aider](https://github.com/Aider-AI/aider)
- Docs: https://aider.chat/docs

## Lesson rút ra
**Git là agent memory rẻ nhất**. Mỗi commit = checkpoint, có thể revert, có audit. Nhiều framework agent hiện đại copy idea này.
