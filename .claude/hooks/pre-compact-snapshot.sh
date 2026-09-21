#!/bin/bash
# Donna: Pre-compaction state snapshot (mechanizes feedback_compaction_protocol step 1-3)
# Fires on PreCompact. Writes the on-disk truth to .claude/state/precompact_snapshot.md
# so that the post-compaction 5-step verification starts from facts, not from a summary.
# Advisory only (exit 0). No jq dependency.
cat > /dev/null 2>&1 || true

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd)" || exit 0
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." 2>/dev/null && pwd)" || exit 0
cd "$PROJECT_DIR" 2>/dev/null || exit 0

STATE_DIR="$PROJECT_DIR/.claude/state"
mkdir -p "$STATE_DIR" 2>/dev/null || exit 0
OUT="$STATE_DIR/precompact_snapshot.md"
NOW=$(date '+%Y-%m-%d %H:%M' 2>/dev/null)

{
  echo "# Pre-compaction snapshot — $NOW"
  echo
  echo "## Lifecycle phase (LAB_STATUS.md)"
  for f in projects/*/LAB_STATUS.md; do
    [ -f "$f" ] || continue
    echo "- $(basename "$(dirname "$f")"): $(grep -m1 '^\*\*Phase\*\*' "$f" | sed 's/\*\*//g')"
    echo "  Next: $(sed -n '/^## Next/,$p' "$f" | sed -n '2,4p' | tr '\n' ' ')"
  done
  echo
  echo "## git log -5"
  git log --oneline -5 2>/dev/null
  echo
  echo "## git status --porcelain"
  git status --porcelain 2>/dev/null
  echo
  echo "## git diff --stat"
  git diff --stat 2>/dev/null | tail -20
  echo
  echo "## SUITS.md — latest scene headers (top 5)"
  grep -m5 '^### \[' SUITS.md 2>/dev/null
  echo
  echo "## SUITS.md — Current Status block"
  sed -n '/^## Current Status/,/^---/p' SUITS.md 2>/dev/null | head -20
} > "$OUT" 2>/dev/null

echo "Donna: Compaction 前にディスクの実状態を ${OUT#$PROJECT_DIR/} に保存したわ。復帰後はまずこれを読んで 5-step verification。" >&2
exit 0
