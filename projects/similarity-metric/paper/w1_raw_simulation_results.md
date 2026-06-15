# W1 Raw Simulation Results (Path alpha framework)

**Author:** Katrina Bennett
**Date:** 2026-05-16
**Config:** 10000 Monte Carlo replications x B = 2000 percentile bootstrap, n_per_group in {50, 100, 200}, scenarios S1-S7.

This document reports operating characteristics of the **sample Wasserstein-1
estimator** Wn(F1, F2) in the original units of the effect modifier — i.e. the
raw W1 used directly by Delta_max = L_clinical x W1 in the Path alpha framework.
No normalization (no division by IQR_pooled or any other scale statistic) is
applied.

## Table A: Population W1 values per scenario

| Scenario | Description | True_W1 | Source |
| --- | --- | --- | --- |
| S1 | Null (identical) | 0.0000 | Exact (F1 = F2) |
| S2 | Location shift 0.2 sigma | 2.0000 | Exact (location shift, same sigma) |
| S3 | Location shift 0.5 sigma | 5.0000 | Exact (location shift, same sigma) |
| S4 | Location shift 1.0 sigma | 10.0000 | Exact (location shift, same sigma) |
| S5 | Scale 1.5x | 3.9894 | Closed form: sqrt(2/pi) * |sigma_x - sigma_y| |
| S6 | Skew (log-normal, CV approx 53%) | 12.1532 | Monte Carlo (n = 1e6) |
| S7 | Location + scale | 5.8454 | Monte Carlo (n = 1e6) |

For S1-S4 (normal location shifts at common sigma), W1(N(mu1, sigma^2), N(mu2, sigma^2)) = |mu1 - mu2| is exact.
For S5 (same-mean different-sigma normals), W1 = sqrt(2/pi) * |sigma_x - sigma_y| (closed form). For S6 and S7
(log-normal mixture and location+scale combination), no closed form is available; we use a Monte Carlo estimate
with n_MC = 10^6 from the canonical wasserstein1() implementation as the population reference.

## Table B: Bias of W1_hat (mean(W1_hat) - W1_true), original units

| Scenario | n=50 | n=100 | n=200 |
| --- | --- | --- | --- |
| S1 | 2.4629 | 1.7594 | 1.2597 |
| S2 | 0.9897 | 0.4716 | 0.1733 |
| S3 | 0.1737 | 0.0509 | 0.0202 |
| S4 | 0.0337 | -0.0093 | 0.0035 |
| S5 | 0.8287 | 0.3892 | 0.1885 |
| S6 | 0.3821 | 0.2096 | 0.1164 |
| S7 | 0.6244 | 0.3255 | 0.1810 |

## Table C: Coverage of 95% percentile bootstrap CI for W1

| Scenario | n=50 | n=100 | n=200 |
| --- | --- | --- | --- |
| S1 | 0.0% | 0.0% | 0.0% |
| S2 | 70.3% | 90.4% | 94.7% |
| S3 | 95.0% | 95.1% | 94.8% |
| S4 | 94.2% | 94.4% | 94.8% |
| S5 | 86.3% | 91.7% | 94.5% |
| S6 | 94.6% | 94.2% | 94.6% |
| S7 | 92.8% | 93.6% | 94.5% |

## Table D: RMSE and mean CI width (original units)

### Table D.1: RMSE

| Scenario | n=50 | n=100 | n=200 |
| --- | --- | --- | --- |
| S1 | 2.6251 | 1.8710 | 1.3364 |
| S2 | 1.6025 | 1.1279 | 0.8554 |
| S3 | 1.8348 | 1.3657 | 0.9845 |
| S4 | 1.9809 | 1.4237 | 1.0040 |
| S5 | 1.6427 | 1.1079 | 0.7713 |
| S6 | 2.6121 | 1.8648 | 1.2901 |
| S7 | 2.0020 | 1.4426 | 1.0117 |

### Table D.2: Mean CI width

| Scenario | n=50 | n=100 | n=200 |
| --- | --- | --- | --- |
| S1 | 4.1873 | 2.9355 | 2.0726 |
| S2 | 4.6690 | 3.5736 | 2.8376 |
| S3 | 6.2187 | 4.9646 | 3.7710 |
| S4 | 7.5181 | 5.4540 | 3.8891 |
| S5 | 5.6468 | 4.1008 | 2.9720 |
| S6 | 9.7403 | 7.0419 | 5.0319 |
| S7 | 6.9726 | 5.2724 | 3.8739 |

## Narrative

**Bias.** Under the null (S1, W1_true = 0), the sample W1 is upward-biased by
construction: |Fn1(t) - Fn2(t)| is strictly nonnegative regardless of whether
F1 = F2, so any sampling difference contributes positively. The bias is
2.463 at n = 50 and shrinks to 1.260 at n = 200 — consistent with the O(1/sqrt(n))
rate of |Fn(t) - F(t)|. For non-null scenarios (S2-S7), bias is small and
shrinks toward zero at all three sample sizes; the bias at n = 200 ranges from
+0.1733 (S2) to +0.1164 (S6), all small in their respective W1 unit scales.

**Coverage.** The 95% percentile bootstrap CI achieves close to nominal
coverage for non-null scenarios at n >= 100: at n = 200, coverage is
94.7% (S2), 94.8% (S3), 94.8% (S4), 94.5% (S5), 94.6% (S6), 94.5% (S7).
Under the null (S1), the percentile bootstrap CI is degenerate (lower
endpoint pinned at 0 by max(0, q_{alpha/2}), true value sits at the
boundary), yielding 0% nominal coverage — this is a known structural
feature of W1 at F1 = F2 rather than a bootstrap failure, and is the
reason that null hypothesis testing on W1 is performed with a
permutation-style procedure (not reported here).

**RMSE.** RMSE shrinks at the O(1/sqrt(n)) rate expected from W1 plug-in
theory: for S3 (location 0.5 sigma, W1_true = 5), RMSE = 1.8348 at n = 50 vs
0.9845 at n = 200 — a factor of 1.86, close to the sqrt(50/200) = 2 prediction.

**CI width.** Mean CI width also shrinks at the same O(1/sqrt(n)) rate.
Width depends on the underlying distributions: heavier-tailed S6 (log-normal,
W1_true approx 12.153) has the widest CIs (width = 5.03 at n = 200), while the
narrow-scale S2 (location 0.2 sigma, W1_true = 2) has the tightest
(width = 2.84 at n = 200).

## Comparison vs v2 (nABCD = W1 / IQR_pooled, dimensionless)

The v2 manuscript reported operating characteristics for the dimensionless
nABCD = W1 / IQR_pooled. Path alpha drops the IQR normalization, so the
operating characteristics translate to W1 units rather than to a dimensionless
ratio. Qualitatively:

- The **bias direction** is preserved (positive under H_0, near-zero
  for non-null cases at moderate n) — division by IQR_pooled does not change
  the sign of the bias because IQR_pooled > 0 a.s. Quantitatively, e.g. for
  S3 at n = 50: v2 nABCD bias = 0.0232, raw W1 bias = 0.1737; at n = 200,
  v2 nABCD bias = 0.0051, raw W1 bias = 0.0202.
- The **coverage profile** is similar: e.g. S3 at n = 50: v2 = 94.6%,
  raw W1 = 95.0%; at n = 200: v2 = 94.6%, raw W1 = 94.8%. Both achieve
  near-nominal coverage by n = 100 for scenarios away from the null.
- The **null degeneracy** at S1 is shared: it reflects the boundary nature of
  W1 = 0 (not the normalization choice).

The practical implication for Path alpha is that L_clinical x W1 inherits
W1's bias and coverage profile directly, with units the same as L_clinical x
W1 = clinical-relevance scale.

## Data files

- `results/w1_raw_simulation.rds` — full per-replicate output (estimates + bootstrap CI bounds), truth values, config
- `results/w1_raw_summary.csv` — per-cell summary (this document's tables in machine-readable form)
- `results/w1_raw_truth.rds` — population W1 values per scenario (exact + MC)
- `projects/similarity-metric/R/W1_raw_rcpp.cpp` — Rcpp kernel (matches wasserstein1() to machine epsilon)
- `projects/similarity-metric/R/w1_raw_simulation.R` — driver script
- `projects/similarity-metric/R/w1_raw_report.R` — this report generator

