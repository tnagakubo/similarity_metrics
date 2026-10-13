# GUSTO-I null floor as a permutation test — provenance of `results/gusto_null_floor_permutation.csv` and `_summary.csv`

Generated: 2026-10-12 (Mike, producer; verifier to be Katrina or Louis)
Producing script: `projects/similarity-metric/R/gusto_null_floor_permutation.R` (uncommitted at generation; parent commit `fad1010`)

## Origin and prior-look disclosure (RESEARCH_FRAMEWORK S8)

- **Exploratory, not pre-registered.** Added 2026-10-12 after the external review (`review_response/EXTERNAL_REVIEW_20261012.md`, M5:
  "null floor as a permutation test on the pooled sample; multiplicity over 30 tests").
- Prior look: the anchor-resampling verdicts (`results/gusto_operability.csv`) were known before this script was written. The test,
  the statistic (W1-hat), K and the 0.05 level were fixed by the reviewer's question and the existing procedure; nothing was tuned.
- Licenses: a statement of whether the 30 resolved / unresolved classifications depend on the choice between the anchor-drawn null and
  the pooled-permutation null, and how many pairs pass a Bonferroni level. Does not license: reading "unresolved" as evidence of
  similarity (absence of a detected difference), or any pooling rule (`memory/feedback_quantify_not_decide.md`).

## Canonical run

| Item | Value |
|------|-------|
| Data | `predtools::gusto`, complete cases on age and sysbp (40,830; 16 regions), as `R/gusto_operability_check.R` |
| Pairs | 2 EMs (age, sysbp) × 15 partners vs Region 8 = 30 |
| Permutations K | 2,000 per pair |
| Seed / RNG | `set.seed(20261012)`, `RNGkind("Mersenne-Twister", "Inversion", "Rejection")`, sequential; pairs in order age R1..R16, then sysbp |
| Statistic | W1-hat, CDF-area form (`compute_w1` verbatim from `R/gusto_operability_check.R`); permutations use the exact cumulative-count form on the once-sorted pooled sample, asserted equal to `compute_w1` on the observed pair and on the first 5 permutations of every pair (< 1e-9) |
| sessionInfo | `results/gusto_null_floor_permutation_sessionInfo.txt` |
| Run time | about 95 s |

## Definitions

- H0: F_R8 = F_p (exchangeability of the pooled n_8 + n_p values). Each permutation relabels the pooled sample keeping n_8 and n_p.
- One-sided p = (1 + #{k : T*_k ≥ T_obs}) / (K + 1); smallest attainable value 1/2001 = 0.0005. **[推測]** that adding 1 to numerator
  and denominator keeps the test valid at finite K, and its attribution to Phipson & Smyth (2010) DOI 10.2202/1544-6115.1585, are
  not verified against an original (not in `knowledge/`); `/ground` + `/cite-check` before either is written into Methods.
- For pairs with 0 exceedances the reported p = 1/2001 is a floor (p ≤ 1/2001), and `p_perm_mcse` is not a meaningful SE there.
- `nPermBonf` (19) depends on the permutation draw: age R13 has 3 exceedances (just above the cut of 2), age R11 and sysbp R13 have 1,
  so another seed could plausibly give 18–20.
- `unresolved_perm` ⇔ p > 0.05; `unresolved_anchor` ⇔ `resolved_anchor == FALSE` in `gusto_operability.csv` (W1-hat ≤ 95th percentile
  of the anchor-drawn null, seed 20260821, B = 2,000). The two procedures have different nulls (pooled exchangeability vs both
  samples drawn from R8's empirical distribution); agreement is an empirical finding, not an identity.
- `bonf_sig` ⇔ p < 0.05/30 = 0.001667, i.e. at most 2 exceedances out of 2,000.
- `p_perm_mcse` = sqrt(p(1 − p)/K), Monte Carlo SE of the permutation p-value given the data.

## Result summary (from the CSV)

All 30 classifications agree (7 unresolved under both: age R1, R4, R5, R7, R9, R15; sysbp R2). 19 pairs have p < 0.05/30.
Pairs near a boundary: age R13 (3 exceedances, p = 0.0020, MCSE 0.0010) sits just above the Bonferroni level; age R11 and sysbp R13
(1 exceedance each, p = 0.0010) just below it; age R6 (p = 0.019) and age R14 (p = 0.030) are the nearest to 0.05 on the resolved side.

## Re-run

    cd projects/similarity-metric && Rscript R/gusto_null_floor_permutation.R
