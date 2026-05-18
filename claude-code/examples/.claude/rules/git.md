# Git Workflow Rules

## Branching

- Branch from `main`; name: `feat/<slug>`, `fix/<slug>`, `chore/<slug>`
- One feature per branch — split large features into sequential PRs
- Delete branch after merge

## Commits

- Conventional Commits format: `feat(scope): subject`
- Subject ≤ 50 characters, imperative mood ("add" not "added")
- Body only when "why" is not obvious from the diff
- Each commit must build and pass lint — no "WIP" commits on PRs

## Pull Requests

- PR title = conventional commit subject of the primary change
- PR body must include: what changed, why, how to test
- Minimum 1 reviewer approval before merge
- Squash-merge into `main` to keep linear history

## Protected Branches

| Branch | Rule                               |
|--------|------------------------------------|
| `main` | No direct push; requires PR + CI   |
| `staging` | Auto-deploy on push; requires CI |

## Absolute Prohibitions

- 🚫 `git push --force` on `main` or `staging`
- 🚫 `git reset --hard` on shared branches
- 🚫 `--no-verify` to skip pre-commit hooks
- 🚫 Merging with failing CI checks
- 🚫 Committing during merge freeze without explicit approval
