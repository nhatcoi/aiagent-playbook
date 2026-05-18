# Orchestration & Agent Loop

## Agent loop tối giản

```python
while not done:
    response = llm.invoke(messages + tools)
    if response.tool_calls:
        for call in response.tool_calls:
            result = execute(call)
            messages.append(result)
    else:
        done = True
return response.content
```

## Stop conditions

| Điều kiện | Khi áp dụng |
|-----------|-------------|
| LLM không gọi tool nữa | Default |
| Đạt max_iterations | Tránh infinite loop |
| Token budget hết | Cost control |
| User cancel | Interactive UI |
| Error rate cao | Detect agent "lạc" |

## Control flow patterns

### Linear
```
input → agent → output
```

### Branch
```
              ┌─ agent A
input → router┤
              └─ agent B
```

### Loop with feedback
```
input → agent → critic ─┐
         ▲              │
         └──────────────┘  (nếu critic không pass)
```

### DAG (LangGraph)
Node = step, edge = transition. State chia sẻ giữa node.

## Token / Context strategies

- **Sliding window**: chỉ giữ N message cuối
- **Summarization**: nén turn cũ thành summary
- **Compaction** (Claude Code): khi gần limit, summarize toàn bộ + giữ recent
- **Sub-agent isolation**: spawn agent con, tool result không quay về parent

## Production concerns

| Vấn đề | Giải pháp |
|--------|-----------|
| Cost vượt budget | Token counter + circuit breaker |
| LLM down | Retry + fallback model |
| Tool flaky | Idempotency + retry |
| Logging | Trace mỗi turn (LangSmith, Langfuse, Helicone) |
| Eval | Golden set + LLM-as-judge |
