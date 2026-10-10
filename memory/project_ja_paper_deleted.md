---
name: project-ja-paper-deleted
description: similarity-metric の JA 版原稿は EN 完成まで意図的に削除。Rule 2.7（EN/JA 同期）は EN 確定まで保留。hook は JA ファイルが存在するときだけ発火する
metadata:
  type: project
---
**Source**: `SUITS.md` Current Status「JA paper: 意図的に削除済み（EN 完成まで Rule 2.7 保留）」、`.claude/hooks/check-paper-sync.sh`。

- EN（`paper/per_em_W1_wiley.tex`）が原稿。段落レビューも EN で行う
- JA 版（`*_ja.md`）は EN が確定（Jessica 承認）した後に再作成し、その時点で Rule 2.7 を再開する
- `check-paper-sync.sh` は `paper/*_ja.md` が存在するときだけ同期を促す。存在しない間は沈黙が正しい
- CLAUDE.md Rule 2.7 のファイル名は project ごとに読み替える（`projects/{project}/paper/{stem}.tex` ↔ `{stem}_ja.md`）
