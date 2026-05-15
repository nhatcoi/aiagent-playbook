# 11 — AutoGen (Microsoft)

Framework multi-agent của Microsoft Research. Triết lý: **conversable agents** — agent giao tiếp như chat 2 chiều, không cần graph rõ.

## Phiên bản

- **AutoGen v0.2** — original, code-first, dễ học
- **AutoGen v0.4+** — rewrite hoàn toàn, layered architecture (Core / AgentChat / Extensions)
- **AutoGen Studio** — UI no-code

## Khái niệm (v0.4)

```python
from autogen_agentchat.agents import AssistantAgent, UserProxyAgent
from autogen_agentchat.teams import RoundRobinGroupChat
from autogen_ext.models.openai import OpenAIChatCompletionClient

model = OpenAIChatCompletionClient(model="gpt-4")

coder = AssistantAgent("Coder", model_client=model, system_message="Viết Python sạch")
critic = AssistantAgent("Critic", model_client=model, system_message="Review code, đề xuất fix")

team = RoundRobinGroupChat([coder, critic], max_turns=4)
result = await team.run(task="Viết FizzBuzz có test")
```

## Patterns built-in

- RoundRobinGroupChat — vòng tròn
- SelectorGroupChat — model chọn agent kế tiếp
- Swarm — handoff giống OpenAI Swarm
- MagenticOne — autonomous browse + code

## So sánh

| | AutoGen | LangGraph | CrewAI |
|-|---------|-----------|--------|
| Trừu tượng cốt lõi | Conversation | Graph | Role/Task |
| Async-first | ✅ | ✅ | ⚠️ |
| Streaming | ✅ | ✅ | Limited |
| UI tool | AutoGen Studio | LangGraph Studio | — |

## MagenticOne (đáng học)

Hệ multi-agent autonomous: Orchestrator + WebSurfer + FileSurfer + Coder + Terminal. State-of-art GAIA benchmark 2024.

Repo: bên trong `autogen_ext.teams.magentic_one`

## Repos
- [microsoft/autogen](https://github.com/microsoft/autogen)
- Docs: https://microsoft.github.io/autogen/
- [microsoft/RD-Agent](https://github.com/microsoft/RD-Agent) — research+dev agent dùng AutoGen

## Khi chọn
- Microsoft stack / Azure OpenAI
- Cần "agent nói chuyện nhau" tự do
- R&D, prototype agent mới (MagenticOne style)
