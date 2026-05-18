# 07 — Devin & Autonomous SWE Agents

Devin (Cognition AI) là agent autonomous đầu tiên có "máy tính riêng" (browser, terminal, editor). Mở đường cho open-source: OpenDevin / OpenHands, SWE-agent, Cognition Devin clones.

## Triết lý

- Agent = SWE đầy đủ: nhận task → planning → coding → testing → PR
- Không sit-by-side mà tự chạy long-running task
- Có sandbox riêng (Docker/VM)

## Đại diện

| Project | Repo | Đặc điểm |
|---------|------|----------|
| OpenHands (was OpenDevin) | [All-Hands-AI/OpenHands](https://github.com/All-Hands-AI/OpenHands) | Mạnh nhất open-source, có UI, Docker sandbox |
| SWE-agent | [SWE-agent/SWE-agent](https://github.com/SWE-agent/SWE-agent) | Princeton, benchmark SWE-bench |
| Aider `/architect` | [Aider-AI/aider](https://github.com/Aider-AI/aider) | Lite version |
| AutoGPT | [Significant-Gravitas/AutoGPT](https://github.com/Significant-Gravitas/AutoGPT) | Generic autonomous agent |
| Devika | [stitionai/devika](https://github.com/stitionai/devika) | Devin alternative |

## Kiến trúc chung

```
┌─────────────────────────────────────────────┐
│              Task input                      │
└─────────────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────────────┐
│  Planner LLM                                │
│  → step list                                │
└─────────────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────────────┐
│  Executor LLM      ↔   Sandbox              │
│  - bash             │  Docker container     │
│  - editor           │  - filesystem         │
│  - browser          │  - network            │
│  - python           │  - gpu (optional)     │
└─────────────────────────────────────────────┘
                 ↓
┌─────────────────────────────────────────────┐
│  Verifier — tests, lint, type check         │
│  → nếu fail: re-plan / repair                │
└─────────────────────────────────────────────┘
                 ↓
                PR / output
```

## Benchmark
- **SWE-bench**: 2k issue thật từ GitHub. Devin Q1/2024: ~13%, hiện 2026 top model: >55%.
- Lesson: scaffolding + tool design quan trọng hơn raw LLM power.

## Khi dùng autonomous
- Task có spec rõ, có test → OK
- Task explore, ambiguous → human-in-loop tốt hơn
- Greenfield → tệ (không context)

## Repos đáng xem
- [All-Hands-AI/OpenHands](https://github.com/All-Hands-AI/OpenHands)
- [SWE-agent/SWE-agent](https://github.com/SWE-agent/SWE-agent)
- [princeton-nlp/SWE-bench](https://github.com/princeton-nlp/SWE-bench)
- [grapeot/devin.cursorrules](https://github.com/grapeot/devin.cursorrules) — biến Cursor thành Devin lite bằng rule
