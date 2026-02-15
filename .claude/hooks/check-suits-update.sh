#!/bin/bash
# Donna's Gatekeeper: Smart SUITS.md update reminder
# Only reminds when editing files OTHER than SUITS.md

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)

# Don't remind when editing SUITS.md itself
if echo "$FILE_PATH" | grep -qi "SUITS.md"; then
  exit 0
fi

# Don't remind for settings/config files
if echo "$FILE_PATH" | grep -qi "\.claude/\|settings\|\.json$"; then
  exit 0
fi

echo "Donna: Update SUITS.md." >&2
exit 0
