#!/bin/bash
# Donna's Linter: SUITS.md character-consistency lint. Fires on PostToolUse(Write|Edit).
# Only when SUITS.md itself was edited; checks the 2 newest scenes (Rule 3 / 3.7 / 3.8,
# suits-script.md). Advisory only (exit 0). No jq dependency.
INPUT=$(cat 2>/dev/null || echo "")
printf '%s' "$INPUT" | grep -qE '"file_path" *: *"[^"]*SUITS\.md"' || exit 0
cd "$(git rev-parse --show-toplevel 2>/dev/null || pwd)" || exit 0
command -v python3 >/dev/null 2>&1 || exit 0
python3 scripts/lint_suits.py SUITS.md --scenes 2 --quiet >&2 2>/dev/null
exit 0
