#!/bin/bash
# Donna: Subagent completion -> SUITS.md recording reminder
# Fires on SubagentStop. A background member (@bg) finished. Per
# feedback_bg_report_timing the result must NOT interrupt an ongoing paragraph
# review; it is held until Tak asks. But it MUST eventually land in SUITS.md.
# Advisory only (exit 0). No jq dependency.
cat > /dev/null 2>&1 || true

echo "Donna: background メンバーの作業が一つ終わったわ。レビュー中なら Tak が聞くまで保留、そうでなければ結果を SUITS.md に scene で記録して。(Rule 2 / feedback_bg_report_timing)" >&2
exit 0
