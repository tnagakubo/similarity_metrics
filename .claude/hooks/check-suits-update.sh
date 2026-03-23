#!/bin/bash
# Donna's Gatekeeper: Smart SUITS.md update reminder
# Only reminds when editing files OTHER than SUITS.md
# No jq dependency — uses raw grep on input

INPUT=$(cat)

# Don't remind when editing SUITS.md itself
if echo "$INPUT" | grep -qi "SUITS\.md"; then
  exit 0
fi

# Don't remind for settings/config files (handle both / and \ path separators)
if echo "$INPUT" | grep -qi '\.claude[/\\]\|settings\.json\|settings\.local\|\.bib\|MEMORY\.md\|memory[/\\]'; then
  exit 0
fi

# Don't remind for knowledge base or archive operations
if echo "$INPUT" | grep -qi 'knowledge[/\\]\|archives[/\\]'; then
  exit 0
fi

echo "Donna: Update SUITS.md." >&2
exit 0
