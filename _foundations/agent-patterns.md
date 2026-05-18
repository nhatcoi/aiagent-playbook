# Agent Patterns

## 1. ReAct (Reason + Act)

```
Thought: tôi cần biết file config ở đâu
Action: grep "config" -r .
Observation: tìm thấy config/app.yaml
Thought: đọc file đó
Action: read("config/app.yaml")
Observation: ...
Thought: đủ info → trả lời
```

Đơn giản, mạnh, đa số agent dùng. Yếu: dễ loop, không nhìn xa.

## 2. Plan-and-Execute

```
Plan: [1] đọc spec → [2] sửa file A → [3] test → [4] commit
Execute(1) → Execute(2) → ...
```

Mạnh: nhìn xa. Yếu: plan sai = chạy sai. Khắc phục bằng re-plan.

## 3. Reflexion (Self-Critique)

```
Try → Output → Critic("output đúng chưa?") → nếu sai: retry với feedback
```

Tăng chất lượng nhưng tốn token gấp 2-3 lần.

## 4. Tree of Thoughts (ToT)

Mở rộng nhiều nhánh suy nghĩ, đánh giá, chọn nhánh tốt nhất. Tốt cho bài toán search.

## 5. CodeAct

Thay vì JSON tool call, LLM viết Python execute trực tiếp. Đại diện: OpenInterpreter, smolagents.

## 6. Multi-Agent

| Pattern | Mô tả | Đại diện |
|---------|-------|----------|
| Supervisor | 1 sếp điều phối nhiều worker | LangGraph supervisor |
| Hierarchical | Cây nhiều tầng | CrewAI hierarchical |
| Debate | Nhiều agent tranh luận → consensus | Society of Mind |
| Handoff | Agent A bàn giao Agent B | OpenAI Swarm |
| Blackboard | Shared state, agent đọc/ghi tự do | AutoGen GroupChat |

## So sánh nhanh

| Pattern | Latency | Cost | Quality | Khi nào dùng |
|---------|---------|------|---------|--------------|
| Single ReAct | Thấp | Thấp | OK | Task ngắn, rõ ràng |
| Plan-Execute | Trung | Trung | Tốt | Task dài, nhiều bước |
| Reflexion | Cao | Cao | Rất tốt | Cần độ chính xác cao |
| Multi-agent | Rất cao | Rất cao | Tốt nhất | Domain phức tạp, nhiều vai trò |
