---
description: Build and track the point-by-point response to reviewer comments (Phase 8)
model: opus
argument-hint: "[init <review file> | status | close <id>]"
---

# Research Lab: Respond to Reviewers（Phase 8）

査読コメントを一件ずつ追跡し、各変更を段落レビュー（Tak OK）で通してから response letter に落とす。
Argument: $ARGUMENTS

Tracker: `projects/{project}/review_response/RESPONSE_TRACKER.md`
Letter: `projects/{project}/review_response/RESPONSE_LETTER.md`

## Execution

### `init <review file>`
1. **Donna**: review file を読み、コメントを `R{reviewer}.{n}` で番号付けし tracker に起票（comment 原文 / 分類 / 担当 / 方針 / 変更箇所 / 状態）
2. **Harvey**: 対応順序（text 順 or 重要度順）を決め、キューを宣言
3. **Louis**: 「この comment の裏にある本当の懸念」を各件に一行添える

### `status`
- **Donna**: tracker を表で表示。open / in-review / closed 件数

### `close <id>`
1. 該当 comment の変更が原稿に **適用され**、段落レビューで Tak OK が出ていることを Donna が git diff で確認
2. **Katrina**: 検証 grep（旧文言残存 0）+ コンパイル error 0
3. **Harvey**: response 文（英語、丁寧だが譲らない所は譲らない）を letter に追記。形式: Comment → Response → Changes made（§/行）
4. **Donna**: tracker の状態を closed に、SUITS.md に scene（TOP）

### 全件 closed のとき
- **Rachel**: letter 内の引用と新規 .bib entry の DOI を確認
- `/phase next`（Phase 8 → 7 Submission prep に戻り Terminal pass）

## 原則
- 変更は必ず段落レビューを通す（@bg 不可）
- 反論する場合も、reviewer の懸念を一文で正確に言い換えてから
- 応答で新しい claim を足さない（証拠がないものは書かない）
