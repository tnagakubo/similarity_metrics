# Four-eyes verification, D-20261012-2 (verifier: Katrina; producer: Mike)
Independent recomputation from raw CSVs (one-off R, /tmp/v.R; Mike's scripts not called). Rounding at printed precision.

| key | printed | recomputed | match |
|---|---|---|---|
| biasOverSdS3n100 | 0.04 | 0.03738 | yes |
| biasOverSdS5n100 | 0.38 | 0.37782 | yes |
| biasOverSdS7n100 | 0.24 | 0.24188 | yes |
| biasRatioS1n50to200 | 1.96 | 1.95544 | yes |
| reqnRatioKSoverW1Set4symsev | 25 | 1047/42 = 24.929 | yes |
| dmaxWidthS3n100overMargin | 5 | 0.01*4.96463*100/1 = 4.9646 | yes |
| dmaxWidthS3n100pct | 5.0 | 4.9646 | yes |
| reqnSMDSet1loc | 30 | 30 | yes |
| reqnW1Set1loc | 33 | 33 | yes |
| reqnKSSet1loc | 39 | 39 | yes |
| reqnSMDSet2loc | 134 | 134 | yes |
| reqnW1Set2loc | 129 | 129 | yes |
| reqnKSSet2loc | 157 | 157 | yes |
| reqnSMDSet1comb | 67 | 67 | yes |
| reqnW1Set1comb | 35 | 35 | yes |
| reqnSMDSet2comb | 529 | 529 | yes |
| reqnW1Set2comb | 60 | 60 | yes |
| surveySpearmanMin | 0.839 | 0.83929 (13 rows) | yes |
| surveySpearmanMax | 0.996 | 0.99643 | yes |
| spearmanW1SMDageLo | 0.70 | CSV rho_w1_smd_age_lo 0.70357 | yes (CSV) |
| spearmanW1SMDageHi | 0.99 | CSV 0.98929 | yes (CSV) |
| spearmanW1SMDsbpLo | 0.90 | CSV 0.90357 | yes (CSV) |
| spearmanW1SMDsbpHi | 0.99 | CSV 0.99286 | yes (CSV) |

Registry rows point at the correct stat rows (rho_w1_smd_{age,sbp}_{lo,hi}); not re-bootstrapped.

## Observed Spearman (own computation, 15 partners vs R8, n=2916 in R8)
| quantity | CSV | recomputed |
|---|---|---|
| rho_w1_smd_age_obs | 0.896429 | 0.896429 |
| rho_w1_smd_sbp_obs | 0.953571 | 0.953571 |

Intervals contain observed values (age [0.704, 0.989] ∋ 0.896; SBP [0.904, 0.993] ∋ 0.954). B = 1000 recorded in the CSV.

## Statement checks (§3.2)
1. "in S3 and S4 [bias] was within Monte Carlo error from n = 100": S4 yes; S3 NO.
| scenario | n | bias | 2 x bias MCSE | bias/MCSE |
|---|---|---|---|---|
| S3 | 50 | 0.1754 | 0.0364 | 9.63 |
| S3 | 100 | 0.0510 | 0.0273 | 3.74 |
| S3 | 200 | 0.0213 | 0.0197 | 2.17 |
| S4 | 50 | 0.0336 | 0.0396 | 1.69 |
| S4 | 100 | -0.0134 | 0.0284 | -0.94 |
| S4 | 200 | 0.0051 | 0.0201 | 0.51 |
S3 exceeds 2 MCSE at n = 100 and n = 200; S4 is within from n = 50. The wording holds for S4 only (or S3 only "negligible vs SD": bias/SD = 0.04).

2. bias(50)/bias(200): S2 5.68, S5 4.43, S6 3.40, S7 3.31 (n^-1 predicts 4; S1 = 1.96, n^-1/2 predicts 2). "close to n^-1" is loose: the range is 3.3 to 5.7.
