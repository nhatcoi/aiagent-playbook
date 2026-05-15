# Project: Example FullStack App

Mono repo NestJS + Next.js + Postgres.

## Engineering Principles
- Analyze before coding
- Reuse existing modules
- Never break public APIs
- Prefer composition over inheritance

## Workflow
1. Search existing implementation (`grep`, `find`)
2. Create implementation plan
3. Implement incrementally — 1 concern / commit
4. Run tests + lint
5. Update docs nếu API thay đổi

## Stack
- Runtime: Node 20
- Backend: NestJS 10, Prisma 5, Postgres 16, Redis 7
- Frontend: Next.js 14, React 18, Tailwind, TanStack Query
- Test: Vitest (unit) + Playwright (E2E)
- CI: GitHub Actions

## Layout
```
apps/
├── web/    # Next.js
└── api/    # NestJS
packages/
├── db/     # Prisma
├── types/  # shared types
└── ui/     # design system
```

## Important commands
- `pnpm dev` — chạy all
- `pnpm test` — unit
- `pnpm e2e` — playwright
- `pnpm db:migrate` — chạy migration

## Forbidden
- ❌ Commit khi user chưa explicit OK
- ❌ Sửa migration đã merge
- ❌ Push thẳng main
- ❌ Skip pre-commit hook (--no-verify)

## Style
- Tiếng Việt trong chat, English trong code/comment
- Trả lời ngắn, file_path:line khi reference
