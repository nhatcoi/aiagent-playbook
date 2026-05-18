# 10 — CrewAI

Multi-agent framework **role-based**. Tư duy giống team nhân sự: agent = nhân viên có role + goal + backstory.

## Khái niệm

```python
from crewai import Agent, Task, Crew, Process

researcher = Agent(
    role="Senior Research Analyst",
    goal="Tìm thông tin mới nhất về {topic}",
    backstory="Bạn 10 năm phân tích thị trường tech",
    tools=[search_tool],
    verbose=True,
)

writer = Agent(
    role="Tech Writer",
    goal="Viết bài blog dễ hiểu từ research",
    backstory="Bạn là tác giả blog tech 500k follower",
)

research_task = Task(
    description="Research về {topic}",
    agent=researcher,
    expected_output="Bullet list 10 điểm",
)

write_task = Task(
    description="Viết bài blog 1000 từ",
    agent=writer,
    context=[research_task],
    expected_output="Markdown",
)

crew = Crew(
    agents=[researcher, writer],
    tasks=[research_task, write_task],
    process=Process.sequential,  # hoặc hierarchical
)
crew.kickoff(inputs={"topic": "LLM agent 2026"})
```

## Process types

- **Sequential** — task chạy tuần tự, output nối tiếp
- **Hierarchical** — Manager agent điều phối, delegate

## Đặc trưng

- DSL gọn, dễ đọc → demo nhanh
- Built-in: memory, cache, planning
- Flows (mới): kết hợp event + crew

## Mạnh / yếu

| Mạnh | Yếu |
|------|-----|
| Code đọc giống user story | Lock vào abstraction (khó debug khi sai) |
| Đông community | Performance reliability kém LangGraph |
| Tích hợp 100+ tool | Documentation hay đổi |

## Repos
- [crewAIInc/crewAI](https://github.com/crewAIInc/crewAI)
- [crewAIInc/crewAI-examples](https://github.com/crewAIInc/crewAI-examples)
- Docs: https://docs.crewai.com

## Khi chọn
- Demo / POC multi-agent nhanh
- Workflow có role rõ ràng (researcher/writer/QA)
- Không cần kiểm soát flow chi tiết

Không chọn nếu: production-critical, cần determinism — LangGraph tốt hơn.
