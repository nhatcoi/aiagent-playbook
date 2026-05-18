---
name: feedback-testing
description: Integration tests must use real Postgres via Testcontainers — never mock the DB client
metadata:
  type: feedback
---

Integration tests must hit a real Postgres database (Testcontainers). Never mock `PrismaClient` or the DB connection in `*.integration.spec.ts` files.

**Why:** Q3/2025 incident — mocked integration tests passed while the prod migration failed because the mock didn't enforce the actual DB constraint. Caught in prod, not CI.

**How to apply:** When writing or reviewing any `*.integration.spec.ts`, reject mocked DB. Unit tests (`*.spec.ts`) may mock freely.
