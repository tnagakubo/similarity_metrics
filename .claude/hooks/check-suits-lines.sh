#!/bin/bash
# Donna's Gatekeeper: SUITS.md Line Count Monitor
# Warns at 800+, alerts at 900+

SUITS_FILE="/mnt/c/Users/hrd13/Documents/Gak/0 Study/800Claude/20260201_SUITS/SUITS.md"

if [ -f "$SUITS_FILE" ]; then
  LINES=$(wc -l < "$SUITS_FILE")

  if [ "$LINES" -ge 1000 ]; then
    echo "🚨 Donna: SUITS.md が ${LINES} 行です！1000行超過 - 即座にアーカイブしてください！" >&2
    echo "   /archive コマンドを実行してください" >&2
  elif [ "$LINES" -ge 900 ]; then
    echo "🔴 Donna: SUITS.md が ${LINES} 行です！アーカイブ準備をしてください" >&2
  elif [ "$LINES" -ge 800 ]; then
    echo "⚠️ Donna: SUITS.md が ${LINES} 行です（警告ライン超過）" >&2
  fi
fi

exit 0
