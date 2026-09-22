# Archived superseded figure writer (2026-09-22, Tak's decision)

`regen_fig3_forest.R` は fig3 を ρ̂ 軸（dimensionless ratio W1/IQR_pooled、入力 `data/GUSTO/gusto_r8_results.csv`）で描き、live の `fig3_gusto_r8_forest{,_color}.{pdf,png}` を上書きする writer。
Tak の 2026-05-17 決定により fig3 の軸は raw Ŵ₁（years / mmHg）であり、その単一 source は `R/fig3_w1_axis.R`（GUSTO-I IPD から Ŵ₁ と percentile bootstrap CI を再計算）なので、本 script を実行すると現行 fig3 が旧 ρ̂ 軸版に置き換わる。
このため 2026-09-22 に archive した（同日 `R/figures_paper_W1.R` からも ρ̂ 軸の fig3 writer を除去済み）。
