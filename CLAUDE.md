# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A **personal learning playbook** (in Vietnamese) for AI agent architectures. **There is no application code, no build, no tests, no lint.** Every numbered folder is curriculum content authored as Markdown. Treat tasks here as documentation/editorial work, not software engineering.

## Repository layout convention

Top-level folders are numbered `00-14` to enforce reading order:

- `00-foundations` — the 5 pillars (Prompt / Tools / Memory / Planning / Loop) that the rest of the repo references
- `01-cursor` … `12-mcp` — one folder per agent/framework
- `13-multi-agent-patterns` — pattern abstractions on top of the frameworks
- `14-real-world-apps` — case studies
- `resources/` — papers, blogs, videos, GitHub repos (with `resources/repos/` as a personal catalog split by category)

Inside most numbered folders the shape is:

```
NN-name/
├── README.md     # overview + comparison tables
├── references.md # canonical links (when present)
├── docs/         # deeper write-ups
└── examples/     # sample config/scaffolding (NOT executable code)
```

Notable: `02-claude-code/examples/` contains a **sample** `CLAUDE.md` + `.claude/` tree for a fictional NestJS+Next.js project. It is teaching material — do not treat it as configuration for this repo. The real config for this repo is `.claude/settings.local.json` at root.

## Editorial conventions to preserve

Read `README.md` and `00-foundations/README.md` before editing — they set the voice. Specifically:

- **Language**: Vietnamese for prose, English for code/identifiers/headings of technical artifacts. Existing files mix both deliberately; keep that style.
- **Framing**: every framework is explained as a concrete instance of the 5 pillars (Prompt · Tools · Memory · Planning · Loop). When adding a new framework folder, structure it the same way and include a comparison table against at least one sibling.
- **Diagrams**: ASCII boxes/arrows are used throughout (see `13-multi-agent-patterns/README.md`). Stay with ASCII rather than introducing Mermaid/images unless explicitly asked.
- **Tables**: README files lead with a comparison table (e.g. `Cursor vs Claude Code`, "When command vs skill vs agent"). Preserve that pattern.
- **Tone**: terse, opinionated, prescriptive. Anti-patterns are called out explicitly with 🚫 — keep that.
- **Cross-references**: link via relative paths to neighboring folders rather than duplicating content.

## When asked to add a new agent/framework folder

1. Pick the next free `NN-` prefix and add a row to the table in root `README.md`.
2. Mirror the standard layout above (`README.md`, `docs/`, `examples/`, optional `references.md`).
3. The `README.md` must answer: what it is, how it maps to the 5 pillars, a comparison table vs the closest sibling, anti-patterns, and a "Tài liệu chính" (canonical docs) list at the bottom.
4. `examples/` holds illustrative config/scaffolding only — never runnable code unless the user asks for it.

## What NOT to do

- Don't invent build/test/lint commands or `package.json`/`pyproject.toml` for this repo — there are none.
- Don't restructure the numbering or rename top-level folders; the order is the curriculum.
- Don't translate Vietnamese prose to English wholesale (or vice versa) without being asked.
