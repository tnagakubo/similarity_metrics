#!/bin/bash
# Donna: Session Start - Inject project context
# Fires on SessionStart — gives Claude context about current state
# Consume stdin (hook framework may send JSON)
cat > /dev/null 2>&1 || true

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd)" || exit 0
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." 2>/dev/null && pwd)" || exit 0
SUITS_FILE="$PROJECT_DIR/SUITS.md"

echo "Donna: New session started." >&2

# Show SUITS.md line count
if [ -f "$SUITS_FILE" ]; then
  LINES=$(wc -l < "$SUITS_FILE" 2>/dev/null) || LINES=0
  # Strip all non-digit characters (whitespace, \r, etc)
  LINES="${LINES//[^0-9]/}"
  LINES="${LINES:-0}"
  echo "Donna: SUITS.md is ${LINES} lines." >&2
fi

# Show git branch
BRANCH=$(git -C "$PROJECT_DIR" branch --show-current 2>/dev/null) || BRANCH=""
if [ -n "$BRANCH" ]; then
  echo "Donna: Branch: ${BRANCH}" >&2
fi

# Show lifecycle phase per project (RESEARCH_FRAMEWORK.md / LAB_STATUS.md)
for f in "$PROJECT_DIR"/projects/*/LAB_STATUS.md; do
  [ -f "$f" ] || continue
  P=$(grep -m1 '^\*\*Phase\*\*' "$f" 2>/dev/null | sed 's/\*\*//g')
  [ -n "$P" ] && echo "Donna: $(basename "$(dirname "$f")") — ${P}  (/phase で詳細)" >&2
done

# Post-compaction snapshot left behind? Point at it.
SNAP="$PROJECT_DIR/.claude/state/precompact_snapshot.md"
if [ -f "$SNAP" ]; then
  echo "Donna: 前回の compaction snapshot が在るわ → .claude/state/precompact_snapshot.md（復帰時はまず 5-step verification）" >&2
fi

exit 0
