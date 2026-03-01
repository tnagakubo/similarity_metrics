#!/bin/bash
# Donna's Gatekeeper: Bash command safety check
# Fires on PreToolUse for Bash — blocks dangerous commands

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty' 2>/dev/null)

# If jq fails or command is empty, pass through
if [ -z "$COMMAND" ]; then
  exit 0
fi

# Block rm -rf on project root or home
if echo "$COMMAND" | grep -qE "rm\s+-rf\s+(/|~|\\\$HOME|/c/Users)" ; then
  echo "Donna: Blocked dangerous rm -rf command. Rule violation." >&2
  exit 2
fi

# Block git push --force to main/master
if echo "$COMMAND" | grep -qE "git\s+push\s+.*--force.*(main|master)" ; then
  echo "Donna: Blocked force push to main/master. Ask Tak first." >&2
  exit 2
fi

# Block git reset --hard without confirmation
if echo "$COMMAND" | grep -qE "git\s+reset\s+--hard" ; then
  echo "Donna: Warning - git reset --hard detected. Proceed with caution." >&2
fi

exit 0
