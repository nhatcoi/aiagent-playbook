# /commit

Tạo commit message + commit.

## Prompt

1. Chạy parallel:
   - `git status` (không -uall)
   - `git diff` (cả staged + unstaged)
   - `git log --oneline -10` (theo style repo)

2. Phân tích diff → draft commit message:
   - Conventional Commit: `feat:`, `fix:`, `refactor:`, `docs:`, `test:`, `chore:`
   - Subject ≤ 50 ký tự
   - Body chỉ khi "why" không hiển nhiên
   - Tiếng Anh

3. Cảnh báo nếu staged file chứa secret (`.env`, `*.key`, `credentials.*`)

4. Show message → đợi user OK → commit

```
<type>(<scope>): <subject>

<body — tại sao, không phải làm gì>

Co-Authored-By: Claude <noreply@anthropic.com>
```

## Cấm
- ❌ `git add -A` / `git add .` — thêm có chọn lọc
- ❌ `--no-verify` (skip hook)
- ❌ `--amend` trừ khi user yêu cầu rõ
- ❌ push tự động
