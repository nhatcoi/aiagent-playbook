# 12 — MCP (Model Context Protocol)

Chuẩn mở của Anthropic (2024). Định nghĩa cách LLM client kết nối **resources, tools, prompts** từ server bên ngoài. Giống "USB for LLM".

## Tại sao quan trọng

Trước MCP: mỗi agent (Cursor, Claude Code, Cline…) tự build tool integration → trùng lặp. MCP: viết 1 server, dùng được mọi client.

## Kiến trúc

```
┌──────────────┐    JSON-RPC    ┌──────────────┐
│  MCP Client  │ ◄────────────► │  MCP Server  │
│ (Claude Code,│                │ (Github, DB, │
│  Cursor,…)   │                │  Slack,…)    │
└──────────────┘                └──────────────┘
```

Transport: stdio (local), HTTP+SSE (remote), streamable HTTP.

## Server expose 3 primitive

| Primitive | Mục đích | Ví dụ |
|-----------|----------|-------|
| Resources | Data đọc được (file, row, doc) | `file://`, `postgres://table/users` |
| Tools | Action có side-effect | `create_issue`, `send_message` |
| Prompts | Template prompt reusable | `code-review`, `summarize` |

## Server tối thiểu (Python)

```python
from mcp.server.fastmcp import FastMCP

mcp = FastMCP("demo")

@mcp.tool()
def add(a: int, b: int) -> int:
    """Cộng 2 số"""
    return a + b

@mcp.resource("greeting://{name}")
def greet(name: str) -> str:
    return f"Xin chào {name}"

if __name__ == "__main__":
    mcp.run()
```

## Connect vào Claude Code

`.claude/settings.json`:
```json
{
  "mcpServers": {
    "demo": {
      "command": "python",
      "args": ["server.py"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": { "GITHUB_PERSONAL_ACCESS_TOKEN": "..." }
    }
  }
}
```

## Servers có sẵn

- Filesystem, Git, GitHub, Postgres, Sqlite, Slack, Memory, Brave Search…
- Đầy đủ: [modelcontextprotocol/servers](https://github.com/modelcontextprotocol/servers)
- Awesome: [punkpeye/awesome-mcp-servers](https://github.com/punkpeye/awesome-mcp-servers)

## Tài liệu
- Spec: https://modelcontextprotocol.io
- Repo chính: [modelcontextprotocol/specification](https://github.com/modelcontextprotocol/specification)

## Tương lai
MCP đang trở thành de-facto standard. OpenAI Agents SDK, LangGraph, mọi IDE agent đều add MCP support 2025-2026.
