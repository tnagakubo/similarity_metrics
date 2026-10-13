# GUSTO-I implausible-record sensitivity and SBP digit preference — provenance of `results/gusto_sensitivity_outliers.csv`, `results/gusto_sensitivity_outliers_summary.csv`, `results/gusto_sbp_digit_preference.csv`

Generated: 2026-10-12 (Mike, producer; verifier to be Katrina or Louis)
Producing script: `projects/similarity-metric/R/gusto_sensitivity_outliers.R` (uncommitted at generation; parent commit `fad1010`)

## Origin and prior-look disclosure (RESEARCH_FRAMEWORK S8)

- **Exploratory, not pre-registered.** Added 2026-10-12 after the external review (`review_response/EXTERNAL_REVIEW_20261012.md`,
  M7(c): six SBP = 0 records and three age > 100 records used as recorded; digit preference).
- Prior look: the as-recorded W1 values, ranks and null-floor verdicts were known. The two variants (exclusion; winsorisation at the
  pooled 1st/99th percentile) and the digit definitions were fixed by the reviewer's wording before any variant was computed; no
  alternative cut-off was tried.
- Licenses: statements of how much the 30 W1 values, their ranks and the anchor-drawn null-floor classifications move when the nine
  implausible records are excluded or the tails winsorised, and how SBP terminal-digit shares differ across regions. Does not license:
  attributing any part of a regional W1 to digit preference (not decomposed here), or any data-cleaning rule.

## Canonical run

| Item | Value |
|------|-------|
| Data | `predtools::gusto`, complete cases on age and sysbp (40,830; 16 regions), as `R/gusto_operability_check.R` |
| Records flagged | sysbp == 0: 6 (R1, R6, R10, R11, R12 × 2); age > 100: 3 (R3, R8, R12). R8 (anchor) holds one age > 100 record and no SBP = 0 |
| Variants | (a) as recorded; (b) per-EM exclusion (SBP = 0 from the SBP analysis only, age > 100 from the age analysis only; age anchor n = 2,915); (c) per-EM winsorisation at the pooled 16-region 1st/99th percentile, quantile type 7: age [34.01, 85.03] years, SBP [76, 190] mmHg |
| W1 | `compute_w1` verbatim from `R/gusto_operability_check.R` (CDF-area form); (a) asserted equal to `gusto_r8_w1_per_pair.csv` and to `gusto_operability.csv` `w1_obs` (< 1e-12) |
| Null floor | the `gusto_operability_check.R` loop run verbatim: `set.seed(20260821)`, B = 2,000, alpha = 0.05, EM order age then sysbp, anchor-drawn then partner-drawn floor per partner. (a) asserted to reproduce every column of `gusto_operability.csv` (< 1e-12, verdicts identical); (b) is the same loop with the same seed on the (b) samples. Not recomputed for (c) |
| RNG | `RNGkind("Mersenne-Twister", "Inversion", "Rejection")` (the R >= 3.6 default the operability script ran under) |
| sessionInfo | `results/gusto_sensitivity_outliers_sessionInfo.txt` |
| Run time | about 42 min (two full operability loops) |

## Definitions

- `abs_change_b` / `abs_change_c` = |W1 under (b)/(c) − W1 under (a)|, in the EM's unit (years, mmHg).
- `rank_*` = rank of W1 among the 15 partners within the EM (1 = closest); a rank change is any partner whose rank differs from (a).
- `margin_*` = W1 − q95 of the anchor-drawn null; `resolved_anchor_*` ⇔ margin > 0.
- Caveat on (b) floors: the sample sizes change, so the RNG stream diverges from (a) after the first changed draw; a flip under (b)
  would mix the outlier effect with Monte Carlo noise in q95. None occurred; the smallest |margin| under (b) is age R14 (0.049, (a) 0.050).
- Digit preference: `p_digit0` = share of sysbp with sysbp %% 10 == 0; `p_digit05` = share with sysbp %% 5 == 0 (sysbp is integer-valued,
  asserted). `_excl0` columns drop SBP = 0; the registry uses the `_excl0` values (min / max / R8 identical to the as-recorded ones).

## Result summary (from the CSVs)

- Exclusion: max |ΔW1| age 0.015 years, SBP 0.075 mmHg; ranks: one swap among the 30 (SBP R3 4→5, R6 5→4), i.e. 2 rank changes;
  null-floor classifications changed: 0 of 30.
- Winsorisation: max |ΔW1| age 0.054 years, SBP 0.627 mmHg (R5, 3.372 → 2.745); 4 SBP rank changes (R3 4→6, R5 6→4, R14 10→9, R16 9→10).
- Terminal digit 0: 19.9 % (R15) to 79.5 % (R8, the anchor, the maximum); digit 0 or 5: 26.5 % to 92.0 % (R8 89.3 %).

## Re-run

    cd projects/similarity-metric && Rscript R/gusto_sensitivity_outliers.R    # about 42 min
