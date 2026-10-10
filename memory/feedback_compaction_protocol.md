---
name: feedback-compaction-protocol
description: 語られた ≠ ディスクにコミット。compaction / session 再開後は 5-step state verification を行い、要約ではなくディスクの実状態から再開する
metadata:
  type: feedback
---
**Source**（repo 版、2026-10-10 復元）: `.claude/hooks/post-compact-remind.sh`、`.claude/hooks/pre-compact-snapshot.sh`、`.claude/hooks/check-persistence.sh`、`.claude/skills/handoff/SKILL.md`。

**原則**: 「done」はディスクに在るものだけ。会話で語られた成果・要約に残った成果は「語っただけ」。

**5-step State Verification**（compaction 後・再開時・`/handoff`）:
1. `SUITS.md` 最新 scene の日時 + `git log -5`
2. `git status --porcelain` / `git diff --stat`（構造変更か内容変更か）
3. 実ファイル構造を grep で確認（要約を信用しない）
4. 不確かさを Tak に開示。慌てて行動しない
5. 再開し、"Compaction recovery complete" scene を SUITS.md に追加

**機械化**: PreCompact hook が `.claude/state/precompact_snapshot.md` にディスクの実状態を保存 → 復帰後はそれを読む。Stop hook が modified/untracked 数を突きつける。`scripts/check_consistency.sh` が Phase 同期・stale な state file を検出する。
