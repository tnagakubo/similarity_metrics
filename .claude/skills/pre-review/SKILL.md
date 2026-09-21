---
description: Proactive self-review — each member states what they would attack as a reviewer before any external review
model: opus
argument-hint: "[section or all]"
---

# Research Lab: Pre-Review（Proactive Self-Review）

External review・投稿・Phase 6 の入口で必ず実行。Tak 指示 (2026-03-16)「Reviewer に言われる前に自分たちで弱点を見つけろ」。
対象: $ARGUMENTS（空なら原稿全体）

## Execution

1. **Donna**: Pre-Review Check — `memory/feedback_tak_feedback_patterns.md` と `templates/review_checklist.md` を読み、該当パターンを列挙
2. **並列**（Agent tool、各メンバー 1 つ。`.claude/agents/{name}.md` を使う）: 「自分が *Statistics in Medicine* の reviewer なら、この原稿のどこを突くか」を独立に書く
   - **Harvey**: message strength、章間論理、overclaim
   - **Mike**: 数学・推定論理・bootstrap 妥当性・P4
   - **Rachel**: 文献整合、引用の accuracy、DOI、E17 の文言
   - **Katrina**: 図表・数値表記・caption・形式
   - **Louis**: 最も攻撃的に。fatal flaw 候補を優先
   - **Jessica**: regulatory message と「この論文が要る理由」
   各 agent の返答は **指摘 3 件以内、各 1–2 文、§/行番号付き**
3. **Louis**: 全指摘を Critical / Major / Minor に分類し、重複を統合
4. **Harvey**: 各 Critical/Major に対し「直す / 反論を書く / 受け入れて narrow」を決める
5. **Donna**: 結果を `projects/{project}/review_response/PRE_REVIEW_{YYYYMMDD}.md` に表で保存（指摘 / 分類 / 担当 / 方針 / 状態）
6. **Donna**: SUITS.md に scene（TOP）

## 出力表

| # | 指摘（§/行） | 分類 | 発見者 | 方針 | 状態 |
|---|---|---|---|---|---|

## 禁止
- Harvey と Mike だけで済ませる
- 「問題なし」で終わる（Louis は必ず一件以上出す）
