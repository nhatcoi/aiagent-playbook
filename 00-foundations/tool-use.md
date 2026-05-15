# Tool Use

LLM mạnh ở suy luận, yếu ở action. Tool = cách LLM tương tác file system, HTTP, DB…

## Schema chuẩn (Anthropic / OpenAI)

```json
{
  "name": "read_file",
  "description": "Đọc nội dung file",
  "input_schema": {
    "type": "object",
    "properties": {
      "path": { "type": "string", "description": "Đường dẫn tuyệt đối" }
    },
    "required": ["path"]
  }
}
```

## Nguyên tắc thiết kế tool

1. **Tên động từ + danh từ**: `read_file`, `run_tests` — không phải `fileHelper`
2. **Description rõ KHI NÀO dùng**, không chỉ tả tool làm gì
3. **Input ít nhất có thể** — mỗi field thêm = một chỗ LLM có thể sai
4. **Return có structure** — JSON > free text
5. **Error message hướng dẫn fix** — `"path not found, try absolute path starting with /"`

## Loại tool phổ biến

| Nhóm | Ví dụ |
|------|-------|
| File system | read, write, edit, glob, grep |
| Code execution | bash, python, sandbox |
| HTTP / API | fetch, search web |
| Memory | save_memory, recall |
| Sub-agent | spawn_agent, delegate |
| User interaction | ask_user, show_choices |

## Vấn đề thực tế

- **Tool soup**: nhiều tool quá → LLM rối. Quy tắc: ≤ 20 tool/agent, dùng tool search nếu nhiều hơn.
- **Hallucinate args**: LLM bịa field. Khắc phục: strict JSON schema validation.
- **Long output**: tool trả 100k token → tràn context. Khắc phục: truncate + cho phép paginate.

## MCP (Model Context Protocol)

Chuẩn mở của Anthropic để tool có thể plug vào bất kỳ agent. Xem `12-mcp/`.
