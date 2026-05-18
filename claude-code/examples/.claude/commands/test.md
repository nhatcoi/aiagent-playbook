# /test [--unit | --integration | --e2e | --all]

Run tests scoped to recently changed files, or all tests.

## Steps

1. Determine scope:
   - `--unit` → `pnpm test --run`
   - `--integration` → `pnpm test:integration --run`
   - `--e2e` → `pnpm e2e`
   - `--all` → all three in sequence
   - Default (no flag) → detect changed files from `git diff --name-only HEAD` and run matching specs

2. Smart scope (default mode):
   ```bash
   git diff --name-only HEAD | grep -E '\.(ts|tsx)$'
   ```
   Map each changed file to its `.spec.ts` / `.integration.spec.ts` counterpart.
   Run only matched spec files.

3. Report:
   - Pass/fail count
   - List failing tests by name
   - Coverage delta if available

## Examples

```
/test                    # auto-scope to changed files
/test --unit             # all unit tests
/test --integration      # integration suite (needs Postgres)
/test --e2e              # Playwright
/test --all              # full pipeline
```

## Rules

- 🚫 Do not fix failing tests automatically — report and wait for user
- 🚫 Do not skip tests to make the suite pass
