# /ship

Full pipeline: lint → typecheck → test → commit → open PR.

## Steps

1. **Guard checks** (abort if any fail):
   ```bash
   pnpm lint
   pnpm typecheck
   pnpm test --run
   ```

2. **Commit** (if there are staged or unstaged changes):
   - Follow `/commit` flow
   - Wait for user approval of commit message

3. **Push** branch:
   ```bash
   git push -u origin HEAD
   ```

4. **Open PR**:
   - `gh pr create` with auto-generated title + body
   - Label: `needs-review`
   - Assign to user if possible

5. **Report**: paste PR URL

## Abort Conditions

| Condition            | Action                          |
|----------------------|---------------------------------|
| lint error           | Show errors, stop               |
| typecheck error      | Show errors, stop               |
| test failure         | Show failures, stop             |
| No changes to commit | Skip step 2, continue to push   |
| PR already open      | Update existing PR, skip create |

## Prohibitions

- 🚫 Never push to `main` directly
- 🚫 Never skip failing lint/type/test with `--no-verify` or flags
- 🚫 Never merge — only open the PR
