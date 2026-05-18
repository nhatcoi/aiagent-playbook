# Frontend Context: Next.js App Router

## Directory Structure

```
apps/web/src/
├── app/
│   ├── layout.tsx          # root layout (server component)
│   ├── page.tsx            # home route
│   ├── (auth)/             # grouped routes
│   │   ├── login/
│   │   └── register/
│   └── dashboard/
│       ├── layout.tsx      # dashboard shell
│       └── page.tsx
├── components/
│   ├── ui/                 # primitives from packages/ui
│   └── features/           # feature-specific components
├── hooks/                  # custom React hooks
├── lib/
│   ├── api.ts              # TanStack Query + fetch wrapper
│   └── auth.ts             # session utilities
└── types/                  # page-level types (shared from packages/types)
```

## Conventions

- **Server Components** (default): fetch data directly, no `useState`/`useEffect`
- **Client Components**: add `'use client'` only when needed (interactivity, browser APIs)
- **Data fetching**: TanStack Query for client-side; `fetch` with `cache` option for server
- **Forms**: React Hook Form + Zod schema validation
- **Styles**: Tailwind utility classes; no inline `style` props

## Server vs Client Component

| Need | Component Type |
|------|----------------|
| DB / API fetch | Server |
| onClick, onChange | Client |
| useState, useEffect | Client |
| SEO, metadata | Server |
| Browser API (localStorage) | Client |

## Anti-Patterns

- 🚫 `'use client'` on layout files
- 🚫 Fetch inside `useEffect` — use TanStack Query
- 🚫 Prop drilling more than 2 levels — use context or Zustand
- 🚫 Direct API calls from components — always go through `lib/api.ts`
