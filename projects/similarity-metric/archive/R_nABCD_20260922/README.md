# Archived nABCD-era fig2 writers (2026-09-22, Tak's decision)

`regen_fig1_fig2_combined.R` / `regen_fig2_simulation.R` は旧 nABCD 期の `fig_combo_simulation()`（`R/figures_paper.R`）で `fig2_simulation_results{,_color}.{pdf,png}` を上書きする writer。
現行 fig2 の単一 source は `R/fig2_bar_chart.R`（`generate_fig2_bars()`, canonical CSV `results/w1_raw_summary.csv` を読む grouped bar chart）であり、これらを実行すると canonical figure が nABCD 期の combo 図に置き換わるため archive した。
`regen_fig1_fig2_combined.R` の fig1 出力名は旧 `fig1_nabcd_definition*` で現行 fig1（`fig1_w1_definition*`, `R/figures_paper_W1.R`）とは別物なので、archive によって live figure は一つも孤立しない。
