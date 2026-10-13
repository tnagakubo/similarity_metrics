# Four-eyes verification, round 3b (verifier: Katrina; producer: Mike B), 2026-10-12

Recomputed from raw inputs with one-off code (not Mike's scripts); decimal half-even at printed precision.

| key | printed | recomputed | match |
|---|---|---|---|
| covUpperMinS3toS7N100up | 0.9710 | 0.9710 (S4-100) | yes |
| covUpperMaxS3toS7N100up | 0.9999 | 0.9999 (S5-100) | yes |
| covBasicRangeS3toS7N100up | 0.870--0.948 | 0.8695 (S3-100) -- 0.9477 (S6-200) | yes (lo--hi; width 0.078) |
| covBasicS1n50 | 0.867 | 0.8666 | yes |
| covBasicS3n100 | 0.870 | 0.8695 -> 0.870 (half-even) | yes |
| covBasicS5n100 | 0.886 | 0.8857 | yes |
| truncBasicS1n50 | 0.867 | 0.8666 | yes |
| sbpDigit0Min | 19.9 | 19.9146 | yes |
| sbpDigit0Max | 79.5 | 79.4582 (region 8) | yes |
| sbpDigit0R8 | 79.5 | 79.4582 | yes |
| w1MaxChangeExclAge | 0.02 | 0.01512 | yes |
| w1MaxChangeExclSbp | 0.07 | 0.07458 | yes |
| w1MaxChangeWinsorSbp | 0.63 | 0.62680 | yes |
| nRankChangesExcl | 2 | 2 (SBP only: R3 rank 4->5, R6 5->4; age 0) | yes |
| nFloorChangesExcl | 0 | CSV 0 (not rerun) | yes |
| nPermAgree | 30 | 30 | yes |
| nPermDisagree | 0 | 0 | yes |
| nPermBonf | 19 | 19 (p<0.05/30; = n_exceed<=2) | yes |

Notes
- Identity cov = 1 - P(true<L) - P(true>U): max abs deviation over all 21 cells 1.1e-16.
- SBP digit-0 min/max/R8 identical (to 6 digits) with and without sysbp == 0 records, as Mike claims. Max is attained by R8.
- W1 = CDF-area; age>100 (3 records) and sysbp==0 (6 records) exclusion changes <= 0.02 yr / 0.07 mmHg. nRankChangesExcl = 2 counts the two tied-swap ranks (R3 <-> R6) of the 30 ranks.
- The sensitivity CSV/summary registry rows point at the right cells; printed = CSV at printed precision.

Miss sides (P(true<L), P(true>U)), 10000 replications
- S4-100: 0.0261, 0.0290 (cov 0.9449) -- both sides.
- S6-100: 0.0316, 0.0263 (cov 0.9421) -- both sides.
