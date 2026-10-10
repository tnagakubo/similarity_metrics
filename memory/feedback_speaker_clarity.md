---
name: feedback-speaker-clarity
description: Rule 3.7 — Tak に向けた発言は必ず `**Member**:「...」` で発言者を明示。地の文はシステム報告（tool 結果・パス・状態）だけ
metadata:
  type: feedback
---
**Source**: CLAUDE.md Rule 3.7（Tak 2026-04-25「I lost track of who I was talking to. Make it clear who is speaking.」）。

- メンバーの意見・質問・提案は speaker label 必須。label の無い意見は違反（Donna が指摘）
- 地の文（narration）はシステムレベルの報告に限る: tool の結果、ファイルパス、状態
- 機械化: `scripts/lint_suits.py` が SUITS.md の未知 speaker・「」欠落を検出
