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
- 結果生成スクリプトは `PROTOCOL_*.md` §7 に登録してから回す（hook `pre-run-protocol-check.sh` が警告）。探索的実行の出力は scratchpad に置き、論文の数値に使わない
- 性能指標は Monte Carlo SE と一緒に計算して CSV に書く（`templates/protocol_template.md` §3P の式）。$n_{\mathrm{sim}}$ は目標 MCSE から決める
- parallel RNG: `clusterSetRNGStream(cl, seed)` / `RNGkind("L'Ecuyer-CMRG")` / task ごとの `set.seed(base + index)` のいずれかを明示。`w1_raw_simulation.R` の非再現性を繰り返さない
- 論文に使う CSV は single writer。出力の隣に `sessionInfo()`（または `renv::snapshot()` の `renv.lock`）と `*_PROVENANCE.md`
- 絶対パス（`C:/`, `/home/`, `setwd()`）禁止。静的チェック: `bash scripts/check_r_reproducibility.sh <file>`
- 検証用の独立実装（`louis_independent_replication.R` の型）は project code を source しない。clean-room で書く
- 論文に出る数値・表を書くスクリプトは `scripts/r/numbers_registry.R` を source し、丸めは `.num_round_dec()`（decimal half-even）。`formatC(x, "f")` / `sprintf("%.3f")` は binary の丸めで機械依存
- 新しい sim は `/protocol` → `python3 scripts/protocol_compile.py` の骨格から始める。`draw_sample()` と推定量以外（seed・grid・MCSE・出力・provenance）を手で書き直さない
