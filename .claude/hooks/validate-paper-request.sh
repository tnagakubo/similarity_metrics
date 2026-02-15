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
if echo "$PROMPT" | grep -qiE "(request-paper|/request-paper|paper.*request)"; then
  # Check for DOI pattern (10.xxxx) or URL (http/https)
  if echo "$PROMPT" | grep -qiE "(10\.[0-9]+/|doi:|https?://|DOI)"; then
    exit 0
  else
    echo "Donna: Paper Request requires DOI or URL. Rule 2.6." >&2
    exit 2
  fi
fi

exit 0
