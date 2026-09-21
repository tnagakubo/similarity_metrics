# Study 1 — provenance of `w1_raw_summary.csv`

Generated: 2026-09-21 17:20:45 JST
Producing script: `projects/similarity-metric/R/study1_summary_exact.R`

## Canonical run

| Item | Value |
|------|-------|
| Per-replicate source | `projects/similarity-metric/results/w1_raw_simulation.rds` |
| rds mtime | 2026-05-17 18:54:55 JST |
| Simulation started / finished | 2026-05-17 18:23:03 / 2026-05-17 18:54:55 |
| Replications per cell | 10,000 |
| Bootstrap resamples B | 2,000 |
| Bootstrap CI type | percentile, 95% |
| Grid | S1–S7 × n ∈ {50, 100, 200} |

The repo-root `results/` tree holds an earlier (2026-05-16) run of the same
design. It is NOT canonical. All Study 1 numbers in the manuscript are to be
read from the project tree CSV named above.

## Reference (true) W1 values

W1 is the CDF-area functional

    W1(F1, F2) = int_{-inf}^{inf} |F1(t) - F2(t)| dt

| Scenario | Distribution 1 | Distribution 2 | True W1 | Source |
|---|---|---|---|---|
| S1 | N(50, 10^2) | N(50, 10^2) | 0 | exact (F1 = F2) |
| S2 | N(50, 10^2) | N(52, 10^2) | 2 | exact, \|mu1 - mu2\| (equal variance) |
| S3 | N(50, 10^2) | N(55, 10^2) | 5 | exact, \|mu1 - mu2\| (equal variance) |
| S4 | N(50, 10^2) | N(60, 10^2) | 10 | exact, \|mu1 - mu2\| (equal variance) |
| S5 | N(50, 10^2) | N(50, 15^2) | 3.989422804 | closed form sqrt(2/pi)*\|sigma1 - sigma2\| |
| S6 | N(50, 10^2) | LogN(3.787023, 0.5^2) | 12.159806 | numerical quadrature |
| S7 | N(50, 10^2) | N(55, 15^2) | 5.833155 | numerical quadrature |

Quadrature re-verified at generation time: S6 = 12.1598064983, S7 = 5.8331547059
(`stats::integrate`, rel.tol = 1e-12). The S6 integral is split at t = 0
because the log-normal support is (0, inf); on t < 0 the integrand reduces
to F_normal(t) and contributes 5.3e-07.

## What changed relative to the previous summary

S6 and S7 previously used Monte-Carlo reference values (n_MC = 1e6):
12.1532169638 and 5.8454086175. Those are superseded by the quadrature
values above. S1–S5 truths are unchanged, so their rows are identical.

**The rds is retained unmodified as the per-replicate source, but its
embedded `$summary` and `$truth` elements still carry the old Monte-Carlo
values for S6/S7 and must NOT be used.** `w1_raw_summary.csv` is the single
source of truth for Study 1 summary numbers, including for figure code.

Previous (MC-truth) summary preserved byte-for-byte at
`projects/similarity-metric/results/w1_raw_summary_mctruth_20260517.csv`.

## Column semantics

| Column | Definition |
|---|---|
| `mean_est` | mean of the 10,000 replicate estimates |
| `bias` | `mean_est - true_W1` |
| `rmse` | sqrt(mean((est - true_W1)^2)), n denominator |
| `sd_est` | sd(est), n-1 denominator |
| `mean_ci_width` | mean(ci_upper - ci_lower) |
| `coverage_pct` | proportion of CIs containing `true_W1` (a proportion, not a percentage) |
| `n_valid` | number of non-missing estimates |

## Reproducibility

The script performs no random number generation (it only summarises an
existing per-replicate matrix), so no `set.seed()` is declared and re-runs
are deterministic. `sessionInfo()` is written to
`study1_summary_exact_sessionInfo.txt` in this directory.
