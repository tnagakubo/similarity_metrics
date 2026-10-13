#!/bin/bash
# referee-blind.sh — the cold-read referee's blind list as a tool scope, not a request (RESEARCH_FRAMEWORK S20).
# Fires on PreToolUse(Read|Grep|Glob|Bash|Write). Only acts when the hook input says the caller is the `referee`
# subagent (`agent_type`). Blocks (exit 2) any read of the lab's internal record and any write outside the referee's
# output directory, and tells the agent why. Every other agent and the main session pass through untouched.
# The list mirrors .claude/agents/referee.md — keep the two in sync (scripts/tests/run_tests.sh checks the hook).
INPUT=$(cat 2>/dev/null || echo "")
[ -z "$INPUT" ] && exit 0
AGENT=$(printf '%s' "$INPUT" | grep -oE '"agent_type" *: *"[^"]*"' | head -1 | sed -E 's/.*: *"//; s/"$//')
[ "$AGENT" = "referee" ] || exit 0
TOOL=$(printf '%s' "$INPUT" | grep -oE '"tool_name" *: *"[^"]*"' | head -1 | sed -E 's/.*: *"//; s/"$//')
# The strings the tool will touch: file_path / path / pattern / command (all of tool_input, flattened)
TARGET=$(printf '%s' "$INPUT" | grep -oE '"(file_path|path|pattern|command|glob)" *: *"([^"\\]|\\.)*"' | sed -E 's/^"[a-z_]+" *: *"//; s/"$//; s#\\\\#/#g')
[ -z "$TARGET" ] && exit 0
TARGET_L=$(printf '%s' "$TARGET" | tr 'A-Z' 'a-z')
# ---- blind list (paths that carry the lab's own context) ----------------------------------------------------------
BLIND='suits\.md|(^|/)archives?/|(^|/)memory/|\.claude/|(^|/)agents/|claims\.md|decisions\.md|lab_status\.md|review_queue|restructure_|paper_logic|paper_outline|claude_science/|existing_methods_and_novelty|ideas_backlog|research_framework\.md|claude\.md|readme\.md|\.remember/|\.git/|git log|git show|knowledge/(summaries|methods|quotes|index)|/archive/|paper/backup/|paper/submission/|results/replication|replication_[0-9]|_provenance\.md'
HIT=0
printf '%s\n' "$TARGET_L" | grep -qE "$BLIND" && HIT=1
# review_response/ is blind except the referee's own output directory review_response/referee/
if printf '%s\n' "$TARGET_L" | grep -q 'review_response/' && ! printf '%s\n' "$TARGET_L" | grep -q 'review_response/referee/'; then HIT=1; fi
if [ $HIT -eq 1 ]; then
  echo "Referee blind list: '$TARGET' carries the authors' internal record (SUITS / CLAIMS / DECISIONS / memory / lab docs / provenance). A journal referee never sees it. Use the manuscript, bib, PROTOCOL_*.md, data/, R/, results/*.csv, figures/, knowledge/pdfs/ only." >&2
  exit 2
fi
# ---- writes only under review_response/referee/ ------------------------------------------------------------------
if [ "$TOOL" = "Write" ]; then
  case "$TARGET_L" in
    *review_response/referee/*) ;;
    *) echo "Referee writes only under review_response/referee/<date>/ (your output directory). '$TARGET' is outside it." >&2; exit 2 ;;
  esac
fi
if [ "$TOOL" = "Bash" ] && printf '%s' "$TARGET" | grep -qE '(>|>>|tee |sed +-i|mv |cp |rm )' && ! printf '%s' "$TARGET_L" | grep -q 'review_response/referee/'; then
  echo "Referee: shell writes are allowed only under review_response/referee/<date>/. Rewrite the command to target your output directory." >&2
  exit 2
fi
exit 0
