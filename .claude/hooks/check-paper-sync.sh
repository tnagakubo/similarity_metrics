#!/bin/bash
# Rachel & Donna: Paper EN/JA synchronization reminder
# Triggers when one paper version is edited, reminds to sync the other

INPUT=$(cat 2>/dev/null || echo "")

EN_FILE="nABCD_wiley.tex"
JA_FILE="nABCD_paper_ja.md"

# Check if English version was edited
if echo "$INPUT" | grep -qi "$EN_FILE" 2>/dev/null; then
  echo "Rachel: EN版 ($EN_FILE) が更新されました。JA版 ($JA_FILE) も同期してください。(Rule 2.7)" >&2
  exit 0
fi

# Check if Japanese version was edited
if echo "$INPUT" | grep -qi "$JA_FILE" 2>/dev/null; then
  echo "Rachel: JA版 ($JA_FILE) が更新されました。EN版 ($EN_FILE) も同期してください。(Rule 2.7)" >&2
  exit 0
fi

exit 0
