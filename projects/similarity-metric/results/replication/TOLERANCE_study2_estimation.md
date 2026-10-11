# Pre-declared comparison tolerances — clean-room replication of Study 2 (estimation), 2026-10-11

Declared by Mike BEFORE Louis's run (RESEARCH_FRAMEWORK S14; /replicate step 3). Canonical: `results/w1_raw_summary.csv`
(n_sim = 10,000, B = 2,000, percentile 95% CI). Replication scale: n_sim = 1,000 per cell, B = 2,000 (same estimator and
interval; reduced replications for compute). Tolerances are 3 × the combined Monte Carlo SE of the two runs.

| column | formula | value |
|---|---|---|
| coverage_pct | $3\sqrt{p(1-p)\,(1/10{,}000 + 1/1{,}000)}$ at $p = 0.95$ (= 0.0217) | **0.025** |
| bias, mean_est | $3\,\sigma_{\max}\sqrt{1/10{,}000 + 1/1{,}000}$ with $\sigma_{\max} = 2.6$ (S6, n = 50; `sd_est`) (= 0.26) | **0.30** |
| rmse, mean_ci_width | same order; the CI-width SD is comparable to `sd_est` | **0.30** |
| true_W1 | exact / quadrature constants | **1e-6** |

A difference beyond tolerance in any cell is a finding to root-cause (implementation, Methods text, or canonical), not noise.
Keys: `scenario, n`. Command (Katrina):
`python3 scripts/compare_results.py results/w1_raw_summary.csv results/replication/study2_estimation_louis.csv --keys scenario,n --columns coverage_pct --tol 0.025`
and the same with `--columns bias,mean_est,rmse,mean_ci_width --tol 0.30`, `--columns true_W1 --tol 1e-6`.
