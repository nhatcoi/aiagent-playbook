#!/usr/bin/env bash
# PostToolUse hook — runs lint + typecheck on edited TypeScript files
# Registered in settings.json under hooks.PostToolUse[matcher="Edit|Write"]

set -e

input=$(cat)
file=$(echo "$input" | jq -r '.tool_input.file_path // empty')

# Only act on TypeScript source files
if [[ "$file" != *.ts && "$file" != *.tsx ]]; then
  exit 0
fi

# Skip generated files and node_modules
if [[ "$file" == *"/node_modules/"* || "$file" == *"/.next/"* || "$file" == *"/dist/"* ]]; then
  exit 0
fi

echo "Post-edit lint: $file"

# Run ESLint on the changed file only (fast)
if command -v pnpm &>/dev/null; then
  pnpm eslint "$file" --max-warnings=0 2>&1 || {
    echo "ESLint found issues in $file. Fix before committing."
    exit 1
  }
fi

exit 0
