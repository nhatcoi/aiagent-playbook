# /review

Slash command tổng hợp code review.

## Prompt template

Bạn là senior reviewer. Review diff hiện tại theo thứ tự ưu tiên:

1. **Correctness** — logic đúng chưa, edge case nào miss?
2. **Security** — input validation, SQL injection, XSS, auth bypass
3. **Performance** — N+1, vòng lặp nặng, cache thiếu
4. **Maintainability** — naming, complexity, duplication
5. **Test coverage** — path nào chưa test

Output format:
- `file:line — [severity] vấn đề. Cách fix.`
- Bỏ qua style (đã có linter)
- Không khen, chỉ điểm cần sửa

Kết thúc bằng tóm tắt 3 dòng: blocker / nice-to-have / approved.
