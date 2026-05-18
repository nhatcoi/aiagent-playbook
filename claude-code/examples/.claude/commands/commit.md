# /commit

Generate a Conventional Commit message and create the commit.

## Steps

1. Run in parallel:
   - `git status` (no `-uall` flag)
   - `git diff` (staged + unstaged)
   - `git log --oneline -10` (match existing style)

2. Analyze diff → draft commit message:
   - Conventional Commits: `feat:`, `fix:`, `refactor:`, `docs:`, `test:`, `chore:`
   - Subject ≤ 50 characters
   - Body only when "why" is non-obvious from the diff
   - English only

3. Warn user if any staged file looks like a secret:
   - `.env`, `*.key`, `*.pem`, `credentials.*`
   - Block the commit and explain

4. Show the message → wait for user approval → commit

## Commit Format

```
<type>(<scope>): <subject>

<body — why, not what>

Co-Authored-By: Claude <noreply@anthropic.com>
```

## Examples

```
feat(auth): add refresh token rotation

fix(api): handle null user in /me endpoint

refactor(db): extract connection pool to shared module
```

## Prohibitions

- 🚫 `git add -A` or `git add .` — stage files selectively by name
- 🚫 `--no-verify` (bypass pre-commit hook)
- 🚫 `--amend` unless user explicitly requested it
- 🚫 Auto-push after commit
