#!/usr/bin/env bash
# PreToolUse hook cho Bash — chặn lệnh nguy hiểm
# Cài: .claude/settings.json
# {
#   "hooks": {
#     "PreToolUse": [
#       { "matcher": "Bash", "hooks": [{ "command": ".claude/hooks/pre-tool-bash.sh" }] }
#     ]
#   }
# }

set -e

# Đọc input JSON từ stdin
input=$(cat)
cmd=$(echo "$input" | jq -r '.tool_input.command // empty')

# Blocklist
patterns=(
  "rm -rf /"
  "rm -rf ~"
  ":(){ :|:& };:"      # fork bomb
  "dd if=.* of=/dev/sd"
  "mkfs"
  "> /dev/sda"
)

for p in "${patterns[@]}"; do
  if [[ "$cmd" == *"$p"* ]]; then
    echo "{\"decision\": \"block\", \"reason\": \"Dangerous command pattern: $p\"}"
    exit 0
  fi
done

# OK
echo '{"decision": "approve"}'
