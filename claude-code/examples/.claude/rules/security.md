# Security Rules

Apply everywhere. Non-negotiable.

## Input Validation

- Validate ALL external input at system boundary: HTTP body, query params, headers, file uploads
- Use `class-validator` + `ValidationPipe` with `whitelist: true, forbidNonWhitelisted: true`
- Never trust `req.user` without verifying the JWT signature first (handled by `JwtAuthGuard`)

## Secrets

- 🚫 Never hardcode secrets, tokens, or credentials in source code
- 🚫 Never commit `.env` files
- 🚫 Never log tokens, passwords, or PII — redact before logging
- All secrets via environment variables; document required vars in `.env.example`

## Authentication & Authorization

- Every route must either have `JwtAuthGuard` or explicit `@Public()` opt-out
- Role checks via `RolesGuard` + `@Roles(Role.ADMIN)` — never inline `if (user.role === 'admin')`
- Tokens expire in 15 minutes; refresh tokens rotate on use

## Database

- 🚫 No raw SQL string concatenation — use Prisma parameterized queries
- `$queryRaw` is permitted only with tagged template literals: `prisma.$queryRaw\`SELECT...\``
- DB user for app has no `DROP`, `TRUNCATE`, `ALTER` privileges

## File Uploads

- Validate MIME type server-side (not just extension)
- Store in object storage (S3/GCS), never on local disk
- Signed URLs for access, max 1-hour expiry

## Dependency Security

- Run `pnpm audit` in CI; fail on high/critical severity
- Pin major versions in `package.json`; dependabot handles patch updates
