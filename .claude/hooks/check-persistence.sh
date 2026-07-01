#!/bin/bash
# Donna's Gatekeeper: Persistence Guard (anti premature-declaration)
# Fires on Stop. A hook cannot read the transcript, so instead of guessing
# what was "claimed", it surfaces the ACTUAL on-disk git state and forces
# Claude to reconcile any "done" claims against reality before stopping.
# Reference: feedback_compaction_protocol — "語られた ≠ ディスクにコミット"
# Portable path detection (works in MSYS, WSL, Linux). No jq dependency.
# Consume stdin (hook framework sends JSON on Stop)
cat > /dev/null 2>&1 || true

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd)" || exit 0
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." 2>/dev/null && pwd)" || exit 0
cd "$PROJECT_DIR" 2>/dev/null || exit 0

# Only meaningful inside a git work tree
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

STATUS="$(git status --porcelain 2>/dev/null)"
MODIFIED=$(printf '%s\n' "$STATUS" | grep -c '^ *M' 2>/dev/null) || MODIFIED=0
UNTRACKED=$(printf '%s\n' "$STATUS" | grep -c '^??' 2>/dev/null) || UNTRACKED=0
MODIFIED="${MODIFIED//[^0-9]/}"; MODIFIED="${MODIFIED:-0}"
UNTRACKED="${UNTRACKED//[^0-9]/}"; UNTRACKED="${UNTRACKED:-0}"

# Advisory only (exit 0): never block Stop — just confront with reality.
echo "Donna: 終わる前に確認。ディスクの実状態は modified=${MODIFIED}, untracked=${UNTRACKED}。" >&2
echo "Donna: 「done」と言ったものが本当にここに在る? 在らないなら、それは語っただけよ。(Persistence Guard)" >&2

exit 0
