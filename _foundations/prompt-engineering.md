# Prompt Engineering for Agents

## Cấu trúc system prompt agent

```
[ROLE]       — bạn là ai
[GOAL]       — mục tiêu chính
[CONTEXT]    — môi trường, file, repo
[TOOLS]      — danh sách tool + khi nào dùng
[RULES]      — must/never
[OUTPUT]     — format trả ra
[EXAMPLES]   — few-shot
```

## Kỹ thuật quan trọng

| Kỹ thuật | Khi dùng |
|----------|----------|
| Few-shot | Output format khó tả bằng lời |
| Chain-of-Thought | Task cần suy luận nhiều bước |
| XML tags | Anthropic Claude — `<context>`, `<task>` |
| Markdown | Dễ đọc, dễ parse |
| Negative examples | Có lỗi lặp lại không sửa được |
| Persona | "Bạn là senior Go engineer 10 năm" |

## Anti-patterns

- ❌ Prompt dài 5000 token nhưng nhồi rule vô tổ chức → LLM bỏ qua giữa
- ❌ "Hãy cố gắng" → vô nghĩa, LLM không có khái niệm "cố gắng"
- ❌ Trùng rule mâu thuẫn → LLM chọn random
- ❌ Không cho ví dụ tool call → LLM bịa schema

## Tham khảo

- [Anthropic Prompt Engineering Guide](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/overview)
- [OpenAI Prompt Guide](https://platform.openai.com/docs/guides/prompt-engineering)
- Repo: [anthropics/prompt-eng-interactive-tutorial](https://github.com/anthropics/prompt-eng-interactive-tutorial)
