# Project: FullStack Monorepo

NestJS + Next.js + Postgres. Monorepo managed with pnpm workspaces.

@.claude/contexts/api.md
@.claude/contexts/web.md
@.claude/contexts/db.md
@.claude/rules/git.md
@.claude/rules/security.md
@.claude/rules/api.md

## Engineering Principles

- Analyze before coding — read existing code first
- Reuse existing modules, never duplicate logic
- Never break public API contracts
- Prefer composition over inheritance
- One concern per commit

## Stack

| Layer     | Tech                                       |
|-----------|--------------------------------------------|
| Runtime   | Node 20, pnpm 9                            |
| Backend   | NestJS 10, Prisma 5, Postgres 16, Redis 7  |
| Frontend  | Next.js 14 (App Router), React 18, Tailwind, TanStack Query |
| Testing   | Vitest (unit), Playwright (E2E), Testcontainers (integration) |
| CI        | GitHub Actions                             |

## Monorepo Layout

```
apps/
├── web/          # Next.js — App Router
└── api/          # NestJS — REST + GraphQL
packages/
├── db/           # Prisma schema + migrations
├── types/        # shared TypeScript types
└── ui/           # design system components
```

## Commands

| Command           | Purpose                        |
|-------------------|--------------------------------|
| `pnpm dev`        | start all apps in watch mode   |
| `pnpm test`       | unit tests (Vitest)            |
| `pnpm e2e`        | E2E tests (Playwright)         |
| `pnpm db:migrate` | run pending Prisma migrations  |
| `pnpm lint`       | ESLint + Prettier check        |
| `pnpm typecheck`  | tsc --noEmit across monorepo   |

## Absolute Prohibitions

- 🚫 Commit without explicit user approval
- 🚫 Modify already-merged migrations
- 🚫 Push directly to `main`
- 🚫 Skip pre-commit hooks (`--no-verify`)
- 🚫 Store secrets in code or `.env` committed to git
- 🚫 Mock DB in integration tests (use Testcontainers)
