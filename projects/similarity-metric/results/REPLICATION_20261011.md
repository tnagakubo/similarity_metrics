# Clean-room replication — Study 2 (estimation properties of $\widehat{W}_1$), 2026-10-11

**Gate**: RESEARCH_FRAMEWORK S14 (`/replicate`). **Roles**: Mike declared the tolerances before the run
(`results/replication/TOLERANCE_study2_estimation.md`); Louis re-implemented the estimator from the Methods text alone
(`review_response/METHODS_ONLY_20261011.tex`; no project code, no results); Katrina compared; Mike root-caused.

## Setup

| Item | Canonical | Replication |
|---|---|---|
| File | `results/w1_raw_summary.csv` | `results/replication/study2_estimation_louis.csv` |
| Script | `R/w1_raw_simulation.R` + `R/study1_summary_exact.R` (Rcpp, parallel) | `R/replication/study2_estimation_louis.R` (base R, serial) |
| Replications per cell | 10,000 | 1,000 (pre-agreed reduced run) |
| Bootstrap | percentile, $B = 2{,}000$, 95% | percentile, $B = 2{,}000$, 95% (type-1 quantiles; type-7 as sensitivity) |
| Grid | S1–S7 × $n \in \{50, 100, 200\}$ | same |
| Seed / RNG | per-worker streams (see STUDY1_PROVENANCE.md) | `BASE_SEED = 20261011`, cell seed = base + 100·s + j; Mersenne-Twister |
| Runtime | — | 585 s elapsed, R 4.3.3, single core |

Tolerances (declared): coverage 0.025; bias, mean_est, rmse, mean_ci_width 0.30; true_W1 $10^{-6}$. Keys `scenario, n`.

## Comparison (`scripts/compare_results.py`, 21 of 21 cells matched)

| Report | Columns | max \|diff\| (worst cell) | Verdict |
|---|---|---|---|
| `results/replication/compare_coverage_20261011.md` | coverage_pct | 0.0090 (S6, n = 100) | ✅ PASS |
| `results/replication/compare_moments_20261011.md` | bias, mean_est, rmse, mean_ci_width | 0.099 (S4, n = 50), 0.099, 0.091 (S6, n = 100), 0.076 (S6, n = 50) | ✅ PASS |
| `results/replication/compare_truth_20261011.md` | true_W1 | 0.003155 (S7) | ❌ FAIL — explained below |

**Root cause of the true_W1 failure (Mike)**: the Methods text gives the true $W_1$ of S5–S7 to two decimals (3.99, 12.16, 5.83);
the canonical CSV carries 3.989423, 12.159806 and 5.833155. Louis used the printed values, as the text invites (his ambiguity A4).
The estimator is unaffected; `bias` in the replication is measured against the rounded truth, which shifts it by at most 0.0032 —
inside the 0.30 tolerance, but a systematic offset, not noise. **Action**: the Methods section must give the exact values (or the
closed forms / quadrature definitions already in `results/STUDY1_PROVENANCE.md`) — a text change for Tak.

**Verdict**: every estimator and interval property that the paper reports (bias, mean estimate, RMSE, mean CI width, coverage)
is reproduced from the Methods text alone within the pre-declared tolerance; the only failure is a rounding convention of the text.

## What the Methods text did not determine (Louis's ambiguities, `R/replication/study2_estimation_louis.R` lines 1–72)

| ID | Severity | Ambiguity | Louis's choice |
|---|---|---|---|
| A1 | **Major** | "nonparametric percentile bootstrap with $B = 2{,}000$" — what is resampled in the two-sample setting is not stated | independent resampling with replacement within each region, size $n_r$ (stratified) |
| A2 | **Major** | S1 (true $W_1 = 0$): with continuous data every bootstrap replicate is positive, so no two-sided percentile interval covers 0; whether S1 coverage is reported, excluded or measured one-sided is not stated | closed interval $L \le W_1 \le U$; S1 coverage = 0 at every $n$ |
| A3 | minor | percentile quantile rule undefined | type 1 (order statistics 50 and 1,950); type 7 differs by ≤ 0.004 in coverage, ≤ 0.02 in width |
| A4 | minor | true $W_1$ printed to 2 dp | used as printed (the FAIL above) |
| A5 | minor | S6 $\mu_{\log}$: 3.787 or $\log 50 - 0.125$ | the formula |
| A6 | minor | order of draws within a replication | $x_1, x_2$, then bootstrap indices |
| A7 | minor | seed and RNG kind not given (only "R 4.5.1") | own seed; only distributions are comparable, never bitwise results |
| A8 | minor | 10,000 replications | 1,000 by prior agreement |
| A9 | minor | `sd_est`, `n_valid` undefined in the text | $n-1$ SD; replications with finite estimate and limits |
| A10 | — | vectorised bootstrap on the sorted pooled sample (implementation choice) | cross-checked against the literal formula: differences ≤ 1.1e-14 |

Minor text findings from the clean room: (a) the Study 2 subsection carries `\label{sec:study1}`; (b) "Monte Carlo standard errors
below 0.005" is an *at most* (equality at $p = 0.5$), and no MCSE is given for bias, RMSE or CI width (in the replication, S3 at
$n = 200$: bias 0.0047 with MCSE 0.032); (c) S6 is labelled "Skew" although its SD is 26.6 against 10 — a scale *and* shape contrast.
Schema note: `coverage_pct` holds proportions in both files; the column name contradicts `.claude/rules/protocol-and-results.md`
and should be renamed when the canonical summary is next regenerated (single writer `R/study1_summary_exact.R`).

Louis's independent warning (from his run alone): S2 at $n = 50$ coverage 0.711 (MCSE 0.014) and S5 0.862 agree with the
canonical 0.703 and 0.862; S1's mean estimate at $n = 50$ (2.45) exceeds S2's true value (2.00), i.e. the null floor sits above
the smallest non-null signal at that sample size — coverage statements in Results should be conditioned on $n$ and on the null floor.

## Files

- `R/replication/study2_estimation_louis.R`, `results/replication/study2_estimation_louis.csv`,
  `results/replication/study2_estimation_louis_sessionInfo.txt`, `results/replication/study2_estimation_louis_run.log`
- `results/replication/compare_{coverage,moments,truth}_20261011.md` (this comparison), `results/replication/TOLERANCE_study2_estimation.md`
