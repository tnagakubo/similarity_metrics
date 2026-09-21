---
paths:
  - "projects/**/paper/**/*.tex"
  - "projects/**/paper/**/*.md"
  - "projects/**/PAPER_OUTLINE*.md"
---

# Paper-writing rules（原稿ファイルを触るときだけ読み込まれる）

Source of truth: `templates/review_checklist.md`（Tak の 5 原則）と `memory/feedback_tak_feedback_patterns.md`。

## 提示前チェック（Harvey + Mike、必須）
- 段落単位で提示する。一文単位は不可
- P1 初見理解可能性 / P2 論理的必然性 / P3 不要なら削除 / P4 数学的正確性 / P5 主張と証拠の比例
- 修正案は Option A（最小）/ B（構造）/ C（折衷）。各 option に 変更内容・影響範囲・trade-off を 1–2 行
- 全メンバーが役割別に発言する。Louis は全段落必須。Jessica は key decision 前

## 文言規則
- ICH E17 に "recommends" を使わない → describes / notes / permits
- 本文で `\emph{}` を使わない。自明な数式説明は削除
- estimation-centered: "significant" / "non-significant" / binary な poolable 表現を避ける
- simulation は "proves" と書かない → demonstrates / illustrates まで
- 証拠を削ったら claim も narrow する（例: shape evidence なし → "scale and skewness"）

## 作業順序
- 本体 §1–§4 → Discussion 整合 → 最後に Abstract / 略語 / Data availability（Terminal pass）
- セクション単位の書き換えは C1 Cross-Section Cascade Check を実行（grep で旧名称・旧番号を全洗い出し）

## 適用後
- 適用 → 検証 grep（旧文言の残存 0）→ コンパイル error 0 をワンセットで行う
- 数値を含む編集は `/verify-numbers`
