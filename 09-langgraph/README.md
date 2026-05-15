# 09 — LangGraph

Của LangChain. Mô hình agent = **graph state machine**. Node = step, edge = transition, shared state object.

## Triết lý

- Explicit control flow (không nhường hết cho LLM)
- Checkpoint state → resumable, time-travel
- Human-in-the-loop dễ
- Streaming token + state event

## Khái niệm

```python
from langgraph.graph import StateGraph, END
from typing import TypedDict

class State(TypedDict):
    messages: list
    iteration: int

def planner(state: State) -> State:
    # LLM call
    return {"messages": state["messages"] + [...]}

def executor(state: State) -> State:
    return {...}

def should_continue(state: State) -> str:
    if state["iteration"] > 5:
        return "end"
    return "continue"

graph = StateGraph(State)
graph.add_node("planner", planner)
graph.add_node("executor", executor)
graph.add_edge("planner", "executor")
graph.add_conditional_edges(
    "executor",
    should_continue,
    {"continue": "planner", "end": END},
)
graph.set_entry_point("planner")
app = graph.compile(checkpointer=MemorySaver())
```

## Patterns built-in

| Pattern | Module |
|---------|--------|
| ReAct agent | `create_react_agent` |
| Supervisor | `langgraph-supervisor` |
| Swarm-like handoff | `langgraph-swarm` |
| Plan-and-Execute | tự build |
| Hierarchical | nested graphs |

## So sánh

| | LangGraph | CrewAI | AutoGen |
|-|-----------|--------|---------|
| Style | Graph DSL | Role-based crew | Conversable agents |
| Control flow | Explicit edge | Sequential/hier | Free-form chat |
| Memory | Checkpointer | Limited | Built-in |
| Production | Mạnh nhất | OK | OK |
| Learning curve | Trung-cao | Thấp | Trung |

## Repos
- [langchain-ai/langgraph](https://github.com/langchain-ai/langgraph)
- [langchain-ai/langgraph-supervisor-py](https://github.com/langchain-ai/langgraph-supervisor-py)
- [langchain-ai/langgraph-swarm-py](https://github.com/langchain-ai/langgraph-swarm-py)
- Docs: https://langchain-ai.github.io/langgraph/

## Khi chọn
- Cần explicit control, debugging
- Multi-step pipeline phức tạp
- Cần checkpoint/resume (long-running task)
- Cần human approval ở step cụ thể

Không chọn nếu: prototype nhanh — overkill cho 1 LLM call.
