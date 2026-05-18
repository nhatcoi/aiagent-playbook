# 08 — OpenAI Swarm

Framework lightweight của OpenAI cho multi-agent **handoff**. Sau 2025 đã chuyển thành **OpenAI Agents SDK** (production-grade).

## Triết lý

- Mỗi agent = (instructions, tools, handoffs)
- Conversation đi qua chuỗi agent bằng handoff (function call → switch agent)
- Stateless: client giữ state, server xử lý 1 turn

## Khái niệm cốt lõi

```python
from swarm import Agent, Swarm

triage = Agent(
    name="Triage",
    instructions="Phân loại yêu cầu user → handoff đến agent đúng",
    functions=[transfer_to_sales, transfer_to_support],
)

sales = Agent(
    name="Sales",
    instructions="Bạn là sales rep, giúp khách về giá/plan",
    functions=[get_pricing],
)

def transfer_to_sales():
    return sales

client = Swarm()
response = client.run(agent=triage, messages=[{"role": "user", "content": "..."}])
```

## So sánh handoff vs supervisor

| Handoff (Swarm) | Supervisor (LangGraph) |
|-----------------|------------------------|
| Agent A trao toàn quyền cho B | Sếp gọi worker rồi nhận lại |
| State: hidden trong conversation | State: explicit graph state |
| Đơn giản | Mạnh, phức tạp hơn |
| Tốt cho customer service | Tốt cho pipeline cố định |

## Migration sang Agents SDK

```python
from agents import Agent, Runner, handoff

billing = Agent(name="Billing", instructions="...", tools=[...])
support = Agent(name="Support", instructions="...", handoffs=[handoff(billing)])

result = Runner.run_sync(starting_agent=support, input="hỏi về hóa đơn")
```

Khác biệt chính:
- Built-in tracing (OpenAI dashboard)
- Guardrails (input/output validation)
- Lifecycle hooks
- Sessions = memory

## Repos
- [openai/swarm](https://github.com/openai/swarm) — experimental, learn từ đây
- [openai/openai-agents-python](https://github.com/openai/openai-agents-python) — production
- Docs: https://openai.github.io/openai-agents-python/

## Khi chọn
- Bạn đã dùng OpenAI ecosystem
- Cần multi-agent kiểu customer service / routing
- Muốn framework nhẹ, ít abstraction
