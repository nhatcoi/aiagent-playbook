# 06 — Continue.dev

Open-source IDE assistant (VSCode + JetBrains). Self-host model được. Triết lý: customizable từng tầng.

## Cấu trúc

```
~/.continue/
├── config.yaml              # cấu hình model, context, slash command
├── assistants/              # nhiều assistant khác nhau
└── prompts/                 # template prompt
```

Hoặc trong workspace:
```
.continue/
├── config.yaml
└── docs/                    # context provider tự custom
```

## `config.yaml` ví dụ

```yaml
models:
  - name: Claude Sonnet
    provider: anthropic
    model: claude-sonnet-4-6
    apiKey: ${ANTHROPIC_API_KEY}
  - name: Local Llama
    provider: ollama
    model: llama3:70b

contextProviders:
  - name: code
  - name: docs
  - name: diff
  - name: codebase

slashCommands:
  - name: review
    description: review current diff
    prompt: "review diff theo correctness/security/perf"
```

## Mạnh

- Local model first-class (Ollama, vLLM)
- Plug nhiều provider
- Context provider extensible (URL, JIRA, docs site)
- Open-source → audit được

## Repo
- [continuedev/continue](https://github.com/continuedev/continue)
- Hub: https://hub.continue.dev

## Khi nào chọn Continue
- Cần self-host (data sensitive)
- Mix nhiều model
- Cần customize sâu (rules, context provider)

Không cho: muốn cài & dùng nhanh — Cursor mượt hơn.
