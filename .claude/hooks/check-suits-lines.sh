#!/bin/bash
# Donna's Gatekeeper: SUITS.md Line Count Monitor
# Portable path detection (works in MSYS, WSL, Linux)

SCRIPT_DIR="$(cd "$(dirname "$0")" 2>/dev/null && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." 2>/dev/null && pwd)"
SUITS_FILE="$PROJECT_DIR/SUITS.md"

if [ -f "$SUITS_FILE" ]; then
  LINES=$(wc -l < "$SUITS_FILE")

  if [ "$LINES" -ge 1000 ]; then
    echo "Donna: SUITS.md ${LINES} lines. Archive now. /archive" >&2
    exit 2
  elif [ "$LINES" -ge 900 ]; then
    echo "Donna: SUITS.md ${LINES} lines. Prepare archive." >&2
  elif [ "$LINES" -ge 800 ]; then
    echo "Donna: SUITS.md ${LINES} lines. Warning." >&2
  fi
fi

exit 0
