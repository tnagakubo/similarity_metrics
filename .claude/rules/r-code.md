---
paths:
  - "**/*.R"
  - "**/*.Rmd"
  - "**/*.qmd"
---

# R code rules（R ファイルを触るときだけ読み込まれる）

- R + tidyverse。`set.seed()` を明示し、seed をファイル冒頭で宣言する
- スクリプトは先頭で入力パス・出力パスを変数化し、`here::here()` または project-relative path を使う
- 結果を書き出すときは `sessionInfo()` も同じディレクトリに保存する（再現性）
- 論文の数値は CSV 等の出力から引く。スクリプト内の値を手で転記しない
- 既知の落とし穴: `selection_simulation.R` の `w1_dist` は不等 n を黙って切り詰める。応用側に流用しない。W₁ は CDF 面積形 `compute_w1` を使う
- Figures: width 7", base_size 11, bg white, greyscale `#1A1A1A`。slides 用は `_color` suffix で `#D52B1E`
- caption は「何がプロットされているか」のみ。結果・解釈・閾値は書かない
