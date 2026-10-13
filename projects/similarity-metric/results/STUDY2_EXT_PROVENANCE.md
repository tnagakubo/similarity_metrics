# STUDY2_EXT — provenance of `results/w1_raw_ext_summary.csv`

Generated: 2026-10-12 18:42:25 JST by `projects/similarity-metric/R/w1_raw_simulation_ext.R` (written at the end of the run; do not edit by hand)

## Canonical run

| Item | Value |
|------|-------|
| Per-replicate source | `results/w1_raw_ext_simulation.rds` (`$cells[[cell]]$mat`: estimate, ci_lower, ci_upper) |
| Protocol | `PROTOCOL_study2_extension.md` (pre-registered 2026-10-12, before any replicate) |
| Replications / bootstrap B | per cell (10,000 or 5,000; column `n_reps`) / 2000, conf 0.95, percentile |
| Seed / RNG stream | L'Ecuyer-CMRG; cell k: `set.seed(20261012 + 1000 k)`; replicate i: i-th `nextRNGSubStream`, set as `.Random.seed` in the worker (bit-reproducible for any worker count) |
| Workers | 6 (PSOCK, `parLapplyLB`) |
| Estimator | `W1_raw_bootstrap_cpp` in `R/W1_raw_rcpp.cpp` (unchanged from Study 2) |
| Gate | C++ point estimate vs independent R CDF-area sum, 40 draws (unequal n; 20 with integer-rounded ties): max abs diff 6.22e-15 |
| R version / packages | `results/w1_raw_ext_sessionInfo.txt` |
| Run time | started 2026-10-12 16:41:13 JST, finished 2026-10-12 18:42:25 JST; invocations (resume) at 2026-10-12 17:55:24 JST |

## Per-cell wall time

| k | cell | n1 | n2 | n_reps | elapsed (s) | elapsed (min) |
|---|---|---|---|---|---|---|
| 1 | E2a_t3_null | 100 | 100 | 10000 | 165.2 | 2.8 |
| 2 | E2b_t3_shift | 100 | 100 | 10000 | 186.4 | 3.1 |
| 3 | E3a_grid_100 | 100 | 100 | 10000 | 165.0 | 2.8 |
| 4 | E3b_grid_200 | 200 | 200 | 10000 | 299.4 | 5.0 |
| 5 | E1a_unequal_100_300 | 100 | 300 | 10000 | 448.1 | 7.5 |
| 6 | E1b_unequal_200_1000 | 200 | 1000 | 5000 | 817.3 | 13.6 |
| 7 | E4a_S3_1000 | 1000 | 1000 | 5000 | 1065.7 | 17.8 |
| 8 | E4b_S5_1000 | 1000 | 1000 | 5000 | 1161.3 | 19.4 |
| 9 | E5_S2_1000 | 1000 | 1000 | 2000 | 567.6 | 9.5 |
| 10 | E6_S2_2900_1200_r10 | 2900 | 1200 | 2000 | 1689.1 | 28.2 |
| 11 | E3c_grid_1000 | 1000 | 1000 | 2000 | 561.7 | 9.4 |
| | total | | | | 7126.8 | 118.8 |

## Reference (true) values

| cell | definition | true value | how obtained |
|---|---|---|---|
| E1a, E1b, E4a | N(50,10^2) vs N(55,10^2) | 5 | exact (location shift) |
| E2a | scaled t3 vs the same | 0 | exact |
| E2b | 50 + (10/sqrt 3) t3 vs 55 + (10/sqrt 3) t3 | 5 | exact (location shift); quadrature check 5.00000000 |
| E3a, E3b | round(N(50,10^2)) vs round(N(55,10^2)) | 5 | exact (integer shift of the rounded law); discretized-CDF sum over k = -200..300: 5.000000000000 |
| E4b | N(50,10^2) vs N(50,15^2) | 3.9894228 | closed form sqrt(2/pi)*5; quadrature (rel.tol 1e-12) 3.9894228040 |
| E5 | N(50,10^2) vs N(52,10^2) | 2 | exact (location shift) |
| E6 | 10 round(X/10), X ~ N(50,10^2) vs N(52,10^2) | 1.9999999919 | discretized-CDF sum on the 10-unit lattice, j = -100..100 (equal to j = -1000..1000 within 1e-12) |

## Column semantics

All performance columns are proportions (not percent) or original units; `mcse_*` = Monte Carlo SE (R/study2_mcse.R formulas).
`coverage` = P(L <= theta <= U) of the 95% percentile interval; `upper_coverage` = P(theta <= U), U = 0.975 bootstrap quantile (one-sided 97.5%);
`bias_over_sd` = bias / sd_est. For E2a (theta = 0) both coverage columns are structural (about 0 and exactly 1) and are not reported in tab_study2_ext.

## Reproducibility statement

- Re-run: `Rscript projects/similarity-metric/R/w1_raw_simulation_ext.R --cores=6` (resumes from the rds; delete the rds for a fresh run).
- Bit-reproducible per replicate (per-replicate substreams); the table generator `R/make_paper_tables.R` is deterministic.
