---
name: pr-review
description: Full PR review pipeline. Triggers on "review PR #N", "review this PR", "/review".
---

# PR Review Skill

## Workflow

1. **Fetch PR context:**
   ```bash
   gh pr view <PR_NUMBER> --json title,body,author,labels,files
   gh pr diff <PR_NUMBER>
   ```

2. **Check CI status:**
   ```bash
   gh pr checks <PR_NUMBER>
   ```
   If CI is failing → report failures, do not proceed with code review until fixed.

3. **Delegate diff to `reviewer` agent** with full diff + PR description as context

4. **Migration check:** if any file in `packages/db/prisma/migrations/` changed:
   - Verify 3-step pattern for NOT NULL columns
   - Verify `CONCURRENTLY` for index creation on large tables
   - Flag if down migration is missing

5. **Test coverage check:**
   - For every new service method, check that a `.spec.ts` file was updated
   - For integration changes, check for `.integration.spec.ts`
   - Flag missing tests as 🟠 MAJOR

6. **Output:** full reviewer output + summary:
   ```
   Blockers: N | Majors: N | Migration risk: LOW/MEDIUM/HIGH
   Verdict: APPROVE / REQUEST CHANGES
   ```

## Rules

- 🚫 Do not auto-approve — always output the verdict for the user to act on
- 🚫 Do not comment on style/formatting — CI handles that
- 🚫 Do not review draft PRs unless user explicitly asks
