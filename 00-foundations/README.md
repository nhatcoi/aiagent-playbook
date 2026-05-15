# 00 — Foundations

Nền tảng phải nắm trước khi đụng bất kỳ agent nào.

## 5 trụ cột của mọi AI Agent

```
┌─────────────────────────────────────────────────┐
│                  AGENT LOOP                      │
│                                                  │
│   ┌─────────┐   ┌──────┐   ┌────────┐           │
│   │ Prompt  │──▶│ LLM  │──▶│ Action │──┐        │
│   └─────────┘   └──────┘   └────────┘  │        │
│        ▲                                │        │
│        │        ┌──────────┐            │        │
│        └────────│  Memory  │◀───────────┘        │
│                 └──────────┘                     │
└─────────────────────────────────────────────────┘
```

| Trụ cột | Câu hỏi cốt lõi | File |
|---------|-----------------|------|
| Prompt | Cách kể cho LLM biết phải làm gì | [prompt-engineering.md](./prompt-engineering.md) |
| Tools | LLM tương tác thế giới ra sao | [tool-use.md](./tool-use.md) |
| Memory | Nhớ gì, quên gì, ở đâu | [memory-systems.md](./memory-systems.md) |
| Planning | Chia task lớn → bước nhỏ | [planning.md](./planning.md) |
| Loop / Orchestration | Agent chạy bao lâu, dừng khi nào | [orchestration.md](./orchestration.md) |

## Patterns phổ biến

- **ReAct** (Reason + Act) — `Thought → Action → Observation` lặp
- **Plan-and-Execute** — plan trước, execute sau
- **Reflexion** — agent self-critique
- **CodeAct** — LLM viết code thay vì JSON tool call
- **Multi-agent** — supervisor / hierarchical / debate

Chi tiết: [agent-patterns.md](./agent-patterns.md)

## Tài liệu gốc bắt buộc đọc

- [Anthropic — Building effective agents](https://www.anthropic.com/research/building-effective-agents)
- [OpenAI — A practical guide to building agents (PDF)](https://cdn.openai.com/business-guides/A-practical-guide-to-building-agents.pdf)
- [Lilian Weng — LLM Powered Autonomous Agents](https://lilianweng.github.io/posts/2023-06-23-agent/)
- Paper: ReAct (Yao 2022), Reflexion (Shinn 2023), Toolformer (Schick 2023)
