---
paths:
  - "projects/**/paper/**/*.tex"
  - "projects/**/paper/**/*.md"
  - "projects/**/PAPER_OUTLINE*.md"
---

# Paper-writing rules（原稿ファイルを触るときだけ読み込まれる）

Source of truth: `templates/review_checklist.md`（Tak の 5 原則 + S 節）と `memory/feedback_tak_feedback_patterns.md`。主張の正本は `projects/{project}/CLAIMS.md`。

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

## 数値は生成する（Option B, 2026-10-11）
- CSV から引ける数値を手で打たない。`paper/numbers_registry.csv` に行を足し、`\numval{key}`（LaTeX）/ `` `r num("key")` ``（Quarto）で参照する
- 表は single writer（`R/make_paper_tables.R` の型）が `paper/generated/*.tex` に **tabular 全体**を書き、原稿は `\input{generated/tab_x}` する（行だけの `\input` は `\bottomrule` の `\noalign` を壊す）
- 丸めは decimal round-half-even（`scripts/r/numbers_registry.R` / `numbers_registry.py`）。`formatC` / `sprintf` を直接使わない — 0.9425 が機械によって 0.942 と 0.943 に割れた
- 原稿を変えたら `numbers_registry.py check … --tex` と `build.sh` を回す。`\numval{}` の未定義 key は compile error

## 主張・数値・不確かさ
- 原稿に書く主張は `CLAIMS.md` の行に対応させる。台帳に無い主張は書かない（先に `/claims add`）
- 推定値には CI か SE、simulation の性能指標には Monte Carlo SE を付ける。点推定だけの数値を書かない
- estimand は記号と式で定義する。命題・定理は仮定を明示し、仮定が落ちる場合を limitations に書く
- protocol 外の解析は "exploratory" と明記する。confirmatory に見せない
- 「論文は違いを定量化するだけ。判定規則は規定しない」（`memory/feedback_quantify_not_decide.md`）— 判定・閾値・手続きの推奨を書かない

## 適用後
- 適用 → 検証 grep（旧文言の残存 0）→ コンパイル error 0 をワンセットで行う
- 数値を含む編集は `/verify-numbers`（`results/NUMBERS_LEDGER.csv` に行、verifier ≠ producer）
- 引用を足したら `/cite-check`（原典の verbatim で支えられるか）
