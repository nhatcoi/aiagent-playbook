# Example FullStack App

Mono repo Go API + Next.js web. Mục tiêu: marketplace order system.

## Setup
```
git clone <repo>
make setup    # cài deps, init DB local (docker compose)
make dev      # chạy api:8080, web:3000
```

## Architecture
```
cmd/api/        — entry point HTTP
internal/
  ├── order/    — bounded context order
  ├── user/     — bounded context user
  ├── payment/  — bounded context payment
  └── platform/ — infra: db, cache, queue
web/            — Next.js 14
db/migrations/  — goose migrations
```

Boundary: context không gọi nhau trực tiếp, qua event (NATS).

## Build / Test / Lint
```
make build         # compile all
make test          # go test + vitest
make test-integration  # testcontainers Postgres
make lint          # golangci-lint + eslint
```
Agent PHẢI chạy `make test lint` trước khi báo done.

## Code Style — Go
- gofmt + golangci-lint sạch
- Error wrap: `fmt.Errorf("create order: %w", err)`
- Table-driven test
- Public func có doc comment `// FuncName ...`
- Không panic ngoài `main()`
- `context.Context` là arg đầu tiên

## Code Style — Web
- Functional component + hooks
- TanStack Query cho server state
- Tailwind, không CSS Module
- Type strict, không `any`

## Database
- Migration goose, mỗi migration 1 concern
- Add NOT NULL column → 3 bước (nullable → backfill → not null)
- Index FK column
- Không `SELECT *`

## Security
- Secret qua env, không hardcode
- Input validation: ozzo-validation (Go), Zod (web)
- Auth check ở handler, không service
- Rate limit endpoint public

## PR / Commit
- Conventional Commits: `feat(order): ...`, `fix(payment): ...`
- Subject ≤ 50 ký tự
- Body trả lời "why"
- 1 PR = 1 concern, ≤ 400 dòng diff

## Forbidden
- ❌ commit khi user chưa OK
- ❌ `git push --force` main
- ❌ skip pre-commit (`--no-verify`)
- ❌ `rm -rf` ngoài `/tmp`
- ❌ commit secret (`.env`, `*.key`)
- ❌ sửa migration đã merge
