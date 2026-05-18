---
name: deploy
description: Deploy to staging or production. Triggers on "deploy to staging", "cut a release", "ship to prod".
---

# Deploy Skill

## Pre-Deploy Checklist

Run in this order — abort on any failure:

```bash
pnpm lint
pnpm typecheck
pnpm test --run
pnpm db:migrate    # staging only; prod uses separate pipeline
```

## Staging Deploy

```bash
git push origin main     # triggers GitHub Actions → staging auto-deploy
gh run watch             # stream CI output
```

Verify at: `https://staging.example.com`

## Production Deploy

Production is **manual gate only** — never automated from `main` push.

Steps:
1. Open GitHub Actions → "Deploy to Production" workflow
2. Click "Run workflow" → select `main` → confirm
3. Monitor deploy: `gh run watch`
4. Smoke test: auth flow, DB connection, critical API endpoints
5. If rollback needed: re-run previous successful workflow run

## Post-Deploy Verification

| Check                  | Command / URL                        |
|------------------------|--------------------------------------|
| API health             | `curl https://api.example.com/health` |
| DB migrations applied  | `prisma migrate status`              |
| Error rate             | Grafana → API Latency dashboard      |
| Auth flow              | Manual login test                    |

## Rollback

- Code: re-run last successful production workflow
- DB migration: run `prisma migrate resolve --rolled-back <migration_name>` then deploy previous version
- 🚫 Never manually edit prod DB — always go through migrations
