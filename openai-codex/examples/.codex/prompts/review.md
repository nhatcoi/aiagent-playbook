# /review — Code review diff

Review diff hiện tại theo thứ tự ưu tiên:

1. **Correctness** — logic đúng, edge case
2. **Security** — input validation, SQL injection, auth bypass, secret leak
3. **Performance** — N+1, vòng lặp nặng, allocate trong hot path
4. **Maintainability** — naming, complexity, duplication
5. **Test coverage** — path nào chưa test

## Output format
`<file>:<line> — [severity] <vấn đề>. <fix>.`

Severity: BLOCKER / MAJOR / MINOR

## Rules
- No khen
- Skip lint/format (đã có tool)
- Skip nit trừ khi gây hiểu nhầm
- Kết thúc bằng 3 dòng tóm tắt: blocker count / major count / verdict (approve | request-changes)

## Steps
1. `git diff <base>...HEAD`
2. Đọc file đầy đủ nếu cần context
3. Output theo format trên
