#!/usr/bin/env bash
# SessionStart hook — prints project status when Claude Code session begins
# Registered in settings.json under hooks.SessionStart

echo "=== Session Start: FullStack Monorepo ==="
echo "Branch: $(git branch --show-current 2>/dev/null || echo 'unknown')"
echo "Last commit: $(git log --oneline -1 2>/dev/null || echo 'none')"
echo "Uncommitted: $(git status --short 2>/dev/null | wc -l | tr -d ' ') files"

# Warn if on main
branch=$(git branch --show-current 2>/dev/null)
if [[ "$branch" == "main" ]]; then
  echo "⚠️  WARNING: You are on the main branch. Create a feature branch before making changes."
fi

# Check for pending migrations
if command -v pnpm &>/dev/null; then
  pending=$(pnpm prisma migrate status 2>/dev/null | grep "Following migration" | wc -l)
  if [[ "$pending" -gt 0 ]]; then
    echo "⚠️  $pending pending DB migration(s). Run: pnpm db:migrate"
  fi
fi

echo "=========================================="
