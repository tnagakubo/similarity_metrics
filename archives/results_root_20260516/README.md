# archives/results_root_20260516/ — 旧 repo-root `results/`（Study 1, 2026-05-16 12:56 run）

- 中身: `w1_raw_simulation.rds` / `w1_raw_simulation_partial.rds` / `w1_raw_summary.csv` / `w1_raw_truth.rds`（いずれも 2026-05-16 12:56 の run、S6/S7 の truth は Monte-Carlo 近似）
- 位置づけ: 2026-09-21 まで論文の Study 1 表（tab:bias / tab:coverage / tab:precision）が参照していた run
- 現在の canonical: `projects/similarity-metric/results/`（2026-05-17 run、S6/S7 は exact quadrature truth）。Tak's decision 2026-09-21 による切り替え。Provenance は `projects/similarity-metric/results/STUDY1_PROVENANCE.md`
- **canonical ではない**。数値の引用・図の生成には使わないこと。provenance 保存のためだけに残す
- 移動元: repo root `results/`（`git mv`、mtime 保持）。root に置かれていたのは `projects/similarity-metric/R/w1_raw_simulation.R` が cwd 相対で `results/` に書き出す実装のため
