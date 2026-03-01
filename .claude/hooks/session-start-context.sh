#!/bin/bash
# Donna: Session Start - Inject project context
# Fires on SessionStart — gives Claude context about current state

SCRIPT_DIR="$(cd "$(dirname "$0")" 2>/dev/null && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." 2>/dev/null && pwd)"
SUITS_FILE="$PROJECT_DIR/SUITS.md"

echo "Donna: New session started." >&2

# Show SUITS.md line count
if [ -f "$SUITS_FILE" ]; then
  LINES=$(wc -l < "$SUITS_FILE")
  echo "Donna: SUITS.md is ${LINES} lines." >&2
fi

# Show git branch
BRANCH=$(git -C "$PROJECT_DIR" branch --show-current 2>/dev/null)
if [ -n "$BRANCH" ]; then
  echo "Donna: Branch: ${BRANCH}" >&2
fi

exit 0
