# Database Context: Prisma + Postgres

## Schema Location

```
packages/db/
├── prisma/
│   ├── schema.prisma       # source of truth
│   └── migrations/         # never edit after merge
└── src/
    └── index.ts            # re-exports PrismaClient
```

## Prisma Client Usage

```ts
// Always inject PrismaService — never instantiate PrismaClient directly
@Injectable()
export class UsersService {
  constructor(private prisma: PrismaService) {}
}
```

## Migration Rules

- **Never** edit a migration file after it has been merged to `main`
- **Never** run `prisma migrate dev` in production — use `prisma migrate deploy`
- For NOT NULL columns: always migrate in 3 steps (add nullable → backfill → set NOT NULL)
- For big tables: use `CREATE INDEX CONCURRENTLY` to avoid table locks
- Use `/migrate-db` skill for any migration involving NOT NULL, index creation, or column drops

## Query Conventions

```ts
// Prefer select over findMany with no filter on large tables
const users = await prisma.user.findMany({
  where: { active: true },
  select: { id: true, email: true },   // explicit projection
  take: 50,                             // always paginate
});
```

## Anti-Patterns

- 🚫 `findMany()` without `where` or `take` on large tables
- 🚫 N+1 queries — use `include` or `select` with nested relations
- 🚫 Raw `$queryRaw` without parameterized inputs (SQL injection risk)
- 🚫 `prisma.$connect()` / `$disconnect()` manually — let PrismaService handle lifecycle
