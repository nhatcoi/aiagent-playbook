# AI Agent Architecture — Learning Path

Repo cá nhân học sâu về AI Agent: từ nền tảng → từng agent (Cursor, Claude Code, Aider, Cline, LangGraph, CrewAI, AutoGen, MCP…) → multi-agent patterns → real-world apps.

## Lộ trình

| Stage | Folder | Mục tiêu |
|-------|--------|----------|
| 0 | [00-foundations](./00-foundations) | Khái niệm cốt lõi: LLM, prompt, tool use, memory, planning, orchestration |
| 1 | [01-cursor](./01-cursor) | Cursor — rule scoped theo file (`.cursor/rules/*.mdc`) |
| 2 | [02-claude-code](./02-claude-code) | Claude Code — `CLAUDE.md` + `.claude/{agents,commands,skills,memory,hooks}` |
| 3 | [03-windsurf](./03-windsurf) | Windsurf/Codeium — Cascade flow, rules |
| 4 | [04-aider](./04-aider) | Aider — git-native pair programming, repo map |
| 5 | [05-cline](./05-cline) | Cline/Roo Code — autonomous coding agent trong VSCode |
| 6 | [06-continue-dev](./06-continue-dev) | Continue.dev — open-source autopilot |
| 7 | [07-devin-autonomous](./07-devin-autonomous) | Devin / OpenDevin / SWE-agent — autonomous SWE agents |
| 8 | [08-openai-swarm](./08-openai-swarm) | OpenAI Swarm — handoff-based multi-agent |
| 9 | [09-langgraph](./09-langgraph) | LangGraph — graph state machines cho agent |
| 10 | [10-crewai](./10-crewai) | CrewAI — role-based crew |
| 11 | [11-autogen](./11-autogen) | Microsoft AutoGen — conversable agents |
| 12 | [12-mcp](./12-mcp) | Model Context Protocol — chuẩn tool/resource |
| 13 | [13-multi-agent-patterns](./13-multi-agent-patterns) | Patterns: supervisor, hierarchical, debate, blackboard |
| 14 | [14-real-world-apps](./14-real-world-apps) | Case study: bug fixer, data pipeline, doc agent |
| ∞ | [resources](./resources) | Papers, blogs, videos, GitHub repos |

## Cách dùng

1. Đi tuần tự từ `00-foundations` để nắm khái niệm.
2. Mỗi folder agent có 3 thứ:
   - `README.md` — tổng quan + so sánh
   - `docs/` — tài liệu chi tiết
   - `examples/` — cấu trúc thư mục mẫu, file config, snippet
3. Sau khi học xong từng agent, đọc `13-multi-agent-patterns` để hiểu cách chúng kết hợp.
4. `resources/github-repos.md` là danh sách repo tham khảo tốt nhất theo từng chủ đề.

## Triết lý

> "Đừng học framework. Hãy học **abstraction** đằng sau nó."

Mỗi agent dù khác nhau về API vẫn chia sẻ 5 trụ cột: **Prompt · Tools · Memory · Planning · Loop**. Khi nắm được, bạn có thể tự design agent thay vì chỉ dùng.
