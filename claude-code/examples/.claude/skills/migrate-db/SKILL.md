---
name: migrate-db
description: Safe Prisma migration guide for production. Triggers on "create migration", "add column", "drop column", "add index", "rename table".
---

# Migrate DB Skill

Never run `prisma migrate dev` in production. Use `prisma migrate deploy`.

## Adding a NOT NULL Column (3-step, zero downtime)

**Step 1** — Add nullable:
```sql
ALTER TABLE users ADD COLUMN phone VARCHAR(20);
```

**Step 2** — Backfill:
```sql
UPDATE users SET phone = '' WHERE phone IS NULL;
```

**Step 3** — Set NOT NULL:
```sql
ALTER TABLE users ALTER COLUMN phone SET NOT NULL;
```

Deploy + verify between each step. Each step = separate migration file.

## Dropping a Column (safe path)

1. Rename to `_deprecated_phone` — deploy and monitor 1 release cycle
2. Remove all code references
3. Drop in a follow-up migration

## Adding an Index on a Large Table

```sql
-- Postgres only: non-blocking
CREATE INDEX CONCURRENTLY idx_users_email ON users(email);
```

Never use plain `CREATE INDEX` on a table with >100k rows in prod — it locks the table.

## Pre-Merge Checklist

- [ ] Migration has a `down` rollback
- [ ] Tested with real data (Testcontainers)
- [ ] Runtime estimate: < 1 second, or batched for large tables
- [ ] Prisma schema updated to match
- [ ] PR description explains why the schema changed
