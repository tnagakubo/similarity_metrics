#!/bin/bash
# Donna's Gatekeeper: SUITS.md Line Count Monitor
# Portable path detection (works in MSYS, WSL, Linux)
# Consume stdin (hook framework sends JSON on PostToolUse/Stop)
cat > /dev/null 2>&1 || true

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd)" || exit 0
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." 2>/dev/null && pwd)" || exit 0
SUITS_FILE="$PROJECT_DIR/SUITS.md"

if [ -f "$SUITS_FILE" ]; then
  LINES=$(wc -l < "$SUITS_FILE" 2>/dev/null) || LINES=0
  # Strip all non-digit characters (whitespace, \r, etc)
  LINES="${LINES//[^0-9]/}"
  LINES="${LINES:-0}"

  if [ "$LINES" -ge 1000 ] 2>/dev/null; then
    echo "Donna: SUITS.md ${LINES} lines. Archive now. /archive" >&2
    exit 2
  elif [ "$LINES" -ge 900 ] 2>/dev/null; then
    echo "Donna: SUITS.md ${LINES} lines. Prepare archive." >&2
  elif [ "$LINES" -ge 800 ] 2>/dev/null; then
    echo "Donna: SUITS.md ${LINES} lines. Warning." >&2
  fi
fi

exit 0
