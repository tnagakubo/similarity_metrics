#!/bin/bash
# Donna's Gatekeeper: Smart SUITS.md update reminder
# Only reminds when editing files OTHER than SUITS.md
# No jq dependency — uses raw grep on input

INPUT=$(cat 2>/dev/null || echo "")

# Don't remind when editing SUITS.md itself
if echo "$INPUT" | grep -qi "SUITS\.md" 2>/dev/null; then
  exit 0
fi

# Don't remind for settings/config files (handle both / and \ path separators)
if echo "$INPUT" | grep -qi '\.claude[/\\]\|settings\.json\|settings\.local\|\.bib\|MEMORY\.md\|memory[/\\]' 2>/dev/null; then
  exit 0
fi

# Don't remind for knowledge base or archive operations
if echo "$INPUT" | grep -qi 'knowledge[/\\]\|archives[/\\]' 2>/dev/null; then
  exit 0
fi

echo "Donna: Update SUITS.md." >&2
exit 0
