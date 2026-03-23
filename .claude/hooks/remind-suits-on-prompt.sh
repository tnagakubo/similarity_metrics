#!/bin/bash
# Donna: Remind to update SUITS.md — only when SUITS.md hasn't been updated recently
# Fires on UserPromptSubmit — lightweight check to reduce noise

SCRIPT_DIR="$(cd "$(dirname "$0")" 2>/dev/null && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." 2>/dev/null && pwd)"
SUITS_FILE="$PROJECT_DIR/SUITS.md"

# Skip reminder if SUITS.md was modified within the last 5 minutes
if [ -f "$SUITS_FILE" ]; then
  NOW=$(date +%s)
  MTIME=$(stat -c %Y "$SUITS_FILE" 2>/dev/null || stat -f %m "$SUITS_FILE" 2>/dev/null)
  if [ -n "$MTIME" ]; then
    DIFF=$((NOW - MTIME))
    if [ "$DIFF" -lt 300 ]; then
      exit 0
    fi
  fi
fi

echo "Donna: SUITS.md に前回の作業を記録したか確認。未記録なら最優先で更新。" >&2
exit 0
