# 13 — Multi-Agent Patterns

Sau khi nắm từng framework, hiểu **pattern chung**. Framework là gói code, pattern là tư duy.

## 6 patterns cốt lõi

### 1. Single agent + tools
```
User → Agent ──tools──► World
```
Đơn giản nhất. 80% use case không cần multi-agent.

### 2. Supervisor (Manager-Worker)
```
              ┌─ Worker A
Supervisor ──┼─ Worker B
              └─ Worker C
```
Supervisor LLM nhận task, route đến worker phù hợp. Khi nào dùng: nhiều worker chuyên môn khác nhau, cần coordinator.

### 3. Hierarchical
```
       CEO
      /   \
    PM     PM
   / \    / \
  Dev Dev Dev Dev
```
Cây nhiều tầng. Dùng cho task rất phức tạp, scope rộng. Cẩn thận: cost tăng theo depth × breadth.

### 4. Sequential pipeline
```
A ──► B ──► C ──► D
```
Output A là input B. Dùng cho workflow tuyến tính: research → write → review → publish.

### 5. Debate / Society of Mind
```
Agent1 ──┐
Agent2 ──┼──► Aggregator ──► answer
Agent3 ──┘
```
Nhiều agent đề xuất song song, aggregator chọn/tổng hợp. Tăng quality, tăng cost 3-5×.

### 6. Handoff (Swarm)
```
A ──► B ──► C  (mỗi agent bàn giao hoàn toàn)
```
Khác sequential: không có shared state, conversation ownership chuyển. Tốt cho customer routing.

## Khi nào KHÔNG multi-agent

- Task < 10 step → single agent
- Latency-sensitive (chat) → single
- Cost-sensitive → single + tool tốt
- Domain hẹp → 1 agent giỏi đủ rồi

> Quy tắc: thử single agent + tốt prompt + tốt tool trước. Đa số "cần multi-agent" thật ra là "prompt chưa đủ tốt".

## Anti-patterns

- 🚫 Tạo agent cho mỗi step → tốn token, dễ thông tin thất lạc
- 🚫 Agent A và B chat vô tận → cap max_turns
- 🚫 Không có evaluator → không biết multi-agent có tốt hơn single không
- 🚫 Shared memory không versioned → race condition logic

## Tài liệu
- [Anthropic — Building effective agents](https://www.anthropic.com/research/building-effective-agents)
- [LangChain — Multi-agent collaboration](https://langchain-ai.github.io/langgraph/tutorials/multi_agent/multi-agent-collaboration/)
- Paper: AutoGen, Multi-Agent Debate (Du 2023), AgentVerse
