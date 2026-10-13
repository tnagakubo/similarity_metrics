# Four-eyes verification: Study 2 extension keys (2026-10-13)

Verifier: Mike (producer of the keys: Katrina, 00:35; producer of the CSV/RDS: another Mike instance). Independent one-off R code; rounding is decimal half-even (Python `decimal`) at the printed precision.

## Keys vs `paper/numbers_macros.tex`

| key | source | raw value | half-even | macro | match |
|---|---|---|---|---|---|
| covExtE5 | w1_raw_ext_summary.csv E5_S2_1000 coverage; RDS mat recompute | 0.951 (1902/2000) | 0.951 | 0.951 | yes |
| covUpperExtE5 | same, upper_coverage; RDS recompute | 0.9825 (exact decimal tie) | 0.982 | 0.982 | yes |
| covExtE6 | E6_S2_2900_1200_r10 coverage; RDS recompute | 0.947 | 0.947 | 0.947 | yes |
| covUpperExtE6 | same, upper_coverage; RDS recompute | 0.9775 (exact decimal tie) | 0.978 | 0.978 | yes |
| covExtE1b | E1b_unequal_200_1000 coverage | 0.9408 | 0.941 | 0.941 | yes |
| covExtE2b | E2b_t3_shift coverage; RDS recompute | 0.9214 | 0.921 | 0.921 | yes |
| covExtE3a | E3a_grid_100 coverage | 0.9448 | 0.945 | 0.945 | yes |
| covExtE4b | E4b_S5_1000 coverage | 0.9444 | 0.944 | 0.944 | yes |
| covExtMin | min coverage over 10 cells with true_W1 > 0 (E2b) | 0.9214 | 0.921 | 0.921 | yes |
| covExtMax | max coverage over the 10 non-null cells (E3c_grid_1000) | 0.9515 (exact decimal tie) | 0.952 | 0.952 | yes |
| mcseCovExtMax | max mcse_coverage (E6; same with E2a included) | 0.0050095409 | 0.005 | 0.005 | yes |
| biasExtE2b | E2b bias; RDS recompute mean(est) - 5 | 0.4913791633 | 0.49 | 0.49 | yes |
| nRepsExtMin | min n_reps over 11 cells | 2000 | 2000 | 2000 | yes |
| covBasicS2n50 | study2_interval_variants.csv S2-50 cov_basic | 0.8092 | 0.809 | 0.809 | yes |
| gustoDistSdMin | min over 30 (15 partners x 2 EMs) of W1/SD_R8 | 0.0322846 | 0.03 | 0.03 | yes |
| gustoDistSdMax | max of the same | 0.2974382 | 0.30 | 0.30 | yes |

GUSTO Region 8 (regl == 8): n = 2916, no NA in age/sysbp; sample SD (n-1) age = 12.07624, sysbp = 22.87455. Per-pair W1 taken from results/gusto_r8_w1_per_pair.csv (not recomputed from raw data).

## RDS deep check (`results/w1_raw_ext_simulation.rds`, `$cells[[cell]]$mat` = estimate, ci_lower, ci_upper)

| cell | n_valid | bias | coverage (MCSE) | upper coverage (MCSE) | mean width | = CSV |
|---|---|---|---|---|---|---|
| E5_S2_1000 | 2000 | 0.0339589107 | 0.9510 (0.004827) | 0.9825 (0.002932) | 1.660824 | yes |
| E6_S2_2900_1200_r10 | 2000 | -0.0011491298 | 0.9470 (0.005010) | 0.9775 (0.003316) | 1.369451 | yes |
| E2b_t3_shift | 10000 | 0.4913791633 | 0.9214 (0.002691) | 0.9947 (0.000726) | 4.444190 | yes |

Closed vs open interval: no ties of a limit with the truth, so coverage is identical either way.

## E6 truth

W1 between the 10-unit-rounded N(50,10^2) and N(52,10^2): sum over j = -200..400 of 10 |F1(10j) - F2(10j)|, F_mu(10j) = Phi((10j + 5 - mu)/10) = 1.9999999919010814; stored true_W1 = 1.99999999190108; difference 1.3e-15. Confirmed (continuous value 2; rounding shifts it by about 8e-9).

## Generated table `paper/generated/tab_study2_ext.tex` (3 rows)

| row | table | CSV (rounded) | match |
|---|---|---|---|
| E2b | 100, 100, 10000, 5.00, 0.491, 1.28, 0.921, 0.9947, 4.44 | 5, 0.49138, 1.28204, 0.9214, 0.9947, 4.44419 | yes |
| E5 | 1000, 1000, 2000, 2.00, 0.034, 0.44, 0.951, 0.9825, 1.66 | 2, 0.03396, 0.44018, 0.951, 0.9825, 1.66082 | yes |
| E6 | 2900, 1200, 2000, 2.00, -0.001, 0.35, 0.947, 0.9775, 1.37 | 1.99999999, -0.00115, 0.35418, 0.947, 0.9775, 1.36945 | yes |

## Mismatches

None.

Note (not a mismatch): covUpperExtE5 and covUpperExtE6 are exact decimal ties at 3 dp. Half-even gives 0.982 / 0.978, but the table prints them at 4 dp as 0.9825 / 0.9775. Half-up would give 0.983 for E5. A reader who compares the prose with the table may think one of them is wrong. One fix is to print the prose at 4 dp as well.
