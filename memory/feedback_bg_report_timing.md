---
name: feedback-bg-report-timing
description: background メンバー（@bg / Agent）の結果は進行中の段落レビューを中断しない。Tak が聞くまで保留し、必ず最終的に SUITS.md に scene で落とす
metadata:
  type: feedback
---
**Source**: `.claude/hooks/subagent-stop-record.sh`、CLAUDE.md Rule 3.6。

- 段落レビュー中に bg の結果が返っても割り込まない（Tak の注意は今の段落にある）
- 保留した結果は Tak が聞いたとき、またはレビューの区切りで、SUITS.md に scene（TOP）として記録する。記録されない bg 作業は Rule 2 違反
- Tak の判断を要する作業（段落の適用、構成変更）は @bg 不可
