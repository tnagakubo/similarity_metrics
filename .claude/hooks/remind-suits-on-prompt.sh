#!/bin/bash
# Donna: Remind to update SUITS.md
# Fires on UserPromptSubmit
# Consume stdin (hook framework sends user prompt as JSON)
cat > /dev/null 2>&1 || true

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd)" || exit 0
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." 2>/dev/null && pwd)" || exit 0
SUITS_FILE="$PROJECT_DIR/SUITS.md"

if [ -f "$SUITS_FILE" ]; then
  NOW=$(date +%s 2>/dev/null) || NOW=0
  # MSYS stat: try GNU format first, then BSD, then fallback
  MTIME=$(stat -c %Y "$SUITS_FILE" 2>/dev/null || stat -f %m "$SUITS_FILE" 2>/dev/null) || MTIME=0
  # Strip all non-digit characters (whitespace, \r, etc)
  NOW="${NOW//[^0-9]/}"
  MTIME="${MTIME//[^0-9]/}"
  # Default to 0 if empty
  NOW="${NOW:-0}"
  MTIME="${MTIME:-0}"
  # Safe arithmetic: only compute if both are positive integers
  if [ "$NOW" -gt 0 ] 2>/dev/null && [ "$MTIME" -gt 0 ] 2>/dev/null; then
    DIFF=$(( NOW - MTIME )) 2>/dev/null || DIFF=9999
    if [ "${DIFF}" -lt 300 ] 2>/dev/null; then
      exit 0
    fi
  fi
fi

echo "Donna: SUITS.md に前回の作業を記録したか確認。未記録なら最優先で更新。" >&2
exit 0
