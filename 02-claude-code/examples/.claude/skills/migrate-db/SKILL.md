---
name: migrate-db
description: Tạo Prisma migration an toàn cho prod. Trigger khi user nói "tạo migration", "add column", "thêm bảng".
---

# Migrate DB Skill

## Quy trình an toàn

### Thêm NOT NULL column
1. Tạo migration `add_<col>_nullable.sql`:
   ```sql
   ALTER TABLE users ADD COLUMN email VARCHAR(255);
   ```
2. Tạo migration `backfill_<col>.sql`:
   ```sql
   UPDATE users SET email = '' WHERE email IS NULL;
   ```
3. Tạo migration `set_<col>_not_null.sql`:
   ```sql
   ALTER TABLE users ALTER COLUMN email SET NOT NULL;
   ```

### Drop column
1. Soft: rename `_deprecated_<col>`
2. Deploy + monitor 1 release
3. Drop thực sự

### Add index trên bảng lớn
- Postgres: `CREATE INDEX CONCURRENTLY`
- Không lock table

## Checklist trước khi merge
- [ ] Có rollback (`down`)
- [ ] Test với data thật (testcontainer)
- [ ] Estimate runtime (< 1s prod, hoặc batch)
- [ ] Update Prisma schema khớp
- [ ] Tạo PR description giải thích why
