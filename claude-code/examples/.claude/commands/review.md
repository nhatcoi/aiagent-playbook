# /review [PR_NUMBER | --branch BRANCH]

Run a full code review on a PR or the current branch diff.

## Steps

1. Determine target:
   - If `PR_NUMBER` given: `gh pr diff <PR_NUMBER>`
   - If `--branch`: `git diff main...<BRANCH>`
   - Default: `git diff main...HEAD`

2. Fetch PR description if available:
   - `gh pr view <PR_NUMBER> --json title,body,labels`

3. Delegate to `reviewer` agent with full diff + context

4. Append to review output:
   - Files changed count
   - Test coverage estimate (any new code without tests?)
   - Migration risk (did any Prisma schema change?)

## Output

Review comments in format:
```
path:line: 🔴 BLOCKER: problem. fix.
path:line: 🟠 MAJOR: problem. fix.
```

Followed by summary:
```
Blockers: N | Majors: N | Verdict: APPROVE / REQUEST CHANGES
```

## Prohibitions

- 🚫 Do not auto-approve or auto-merge
- 🚫 Do not comment on formatting (CI handles ESLint/Prettier)
