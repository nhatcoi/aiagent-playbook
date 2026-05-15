# 14 — Real-World Applications

Cách áp agent vào bài toán thật. Mỗi case study: vấn đề → kiến trúc → trade-off.

## Case 1: Code Bug Fixer (SWE-bench style)

**Problem**: nhận issue GitHub → fix tự động → PR.

**Architecture**:
```
issue → Investigator agent (locate code)
      → Plan agent (design fix)
      → Builder agent (apply edit)
      → Test runner
      → Reviewer agent
      → PR creator
```
- Sandbox: Docker
- Memory: git commits
- Eval: SWE-bench Verified

**Trade-off**: Test coverage tệ → agent commit fix sai. Cần regression test net mới.

## Case 2: Customer Support Agent

**Problem**: triage support ticket → trả lời hoặc escalate.

**Architecture (handoff/Swarm)**:
```
triage → (billing | technical | sales) → human if escalate
```
- Memory: vector DB (past ticket)
- Tool: order lookup, refund, KB search
- Guardrail: không hứa refund > $X

**Trade-off**: latency từng handoff. Cache + streaming.

## Case 3: Data Pipeline Agent

**Problem**: user mô tả NL → agent tạo SQL + chạy + report.

**Architecture (sequential)**:
```
NL → Schema linker → SQL writer → Validator → Executor → Chart
```
- Validator: dry-run EXPLAIN, check cost
- Executor: sandbox connection read-only

**Trade-off**: hallucination cột không tồn tại. Schema linker phải hard-constraint.

## Case 4: Research Assistant

**Problem**: research topic → bài tổng hợp + citation.

**Architecture (debate + sequential)**:
```
Planner → [Searcher × N song song] → Synthesizer → Critic → Writer
```
- Tool: web search, arxiv API, scholar
- Memory: cache search result
- Guardrail: cite mọi claim, refuse if no source

## Case 5: Codebase Onboarding Agent

**Problem**: dev mới vào repo → agent giải thích, gen diagram, gợi ý task starter.

**Architecture (single agent + nhiều tool)**:
```
explorer agent
├── repo map tool
├── git history tool
├── diagram gen (Mermaid/Excalidraw)
└── question-answer over codebase
```

## Bài học chung

| Bài học | Chi tiết |
|---------|----------|
| Tool > Prompt | Cải tool tốt hơn nhồi prompt dài |
| Eval bắt buộc | Không có eval = không biết có tốt hơn |
| Cost monitoring | Token explode rất nhanh với multi-agent |
| Human-in-loop | Cho điểm dừng review trước action không thể revert |
| Idempotent action | Retry không gây side-effect đôi |
| Observability | Trace toàn bộ turn — LangSmith, Langfuse, Helicone |
