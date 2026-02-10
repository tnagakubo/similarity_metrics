#!/bin/bash
# Donna's Gatekeeper: DOI/URL Validation for Paper Requests
# Exit 0 = OK, Exit 2 = Block

INPUT=$(cat)
PROMPT=$(echo "$INPUT" | jq -r '.prompt // empty' 2>/dev/null)

# If jq fails or prompt is empty, pass through
if [ -z "$PROMPT" ]; then
  exit 0
fi

# Check if this is a paper request (case insensitive)
if echo "$PROMPT" | grep -qiE "(request-paper|/request-paper|paper.*request|論文.*リクエスト|PDF.*取得)"; then
  # Check for DOI pattern (10.xxxx) or URL (http/https)
  if echo "$PROMPT" | grep -qiE "(10\.[0-9]+/|doi:|https?://|DOI)"; then
    # Has DOI or URL - OK
    exit 0
  else
    # Missing DOI/URL - Block!
    echo "❌ Donna: Paper Request には DOI または URL が必要です！" >&2
    echo "   Format: DOI: 10.xxxx/yyyy または URL: https://..." >&2
    echo "   Rule 2.6 violation - request blocked" >&2
    exit 2
  fi
fi

# Not a paper request - pass through
exit 0
