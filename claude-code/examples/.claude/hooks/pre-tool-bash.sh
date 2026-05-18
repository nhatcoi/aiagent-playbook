#!/usr/bin/env bash
# PreToolUse hook — blocks dangerous Bash patterns before execution
# Registered in settings.json under hooks.PreToolUse[matcher="Bash"]

set -e

input=$(cat)
cmd=$(echo "$input" | jq -r '.tool_input.command // empty')

BLOCKED_PATTERNS=(
  "rm -rf /"
  "rm -rf ~"
  "rm -rf \$HOME"
  ":(){ :|:& };:"
  "dd if=.* of=/dev/sd"
  "mkfs"
  "> /dev/sda"
  "curl .* | bash"
  "wget .* | sh"
  "git push --force"
  "git reset --hard"
)

for pattern in "${BLOCKED_PATTERNS[@]}"; do
  if [[ "$cmd" == *"$pattern"* ]]; then
    echo "{\"decision\": \"block\", \"reason\": \"Dangerous command blocked: $pattern\"}"
    exit 0
  fi
done

echo '{"decision": "approve"}'
