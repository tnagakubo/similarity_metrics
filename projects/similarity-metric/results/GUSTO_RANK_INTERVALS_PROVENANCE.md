# GUSTO-I rank intervals — provenance of `results/gusto_rank_intervals.csv` and `results/gusto_rank_spearman_boot.csv`

Generated: 2026-10-11 (Mike, producer; run finished just after midnight, 2026-10-12 JST)
Producing script: `projects/similarity-metric/R/gusto_rank_intervals.R` (uncommitted at generation; parent commit `fad1010`)

## Origin and prior-look disclosure (RESEARCH_FRAMEWORK S8)

- This analysis is **not** in a pre-registered protocol. It was added on 2026-10-11 after Major comment M4 of the cold referee
  (`review_response/REFEREE_20261011.md`), and the lab decided to add it in `DECISIONS.md` D-20261011-11, judgement 3.
- **Prior look**: the referee had already computed similar intervals (`review_response/referee/20261011/r05_rank_uncertainty_and_misc.R`,
  seed 5, output `r05_rank_uncertainty_and_misc.txt`: Spearman [-0.518, 0.039]). The lab therefore saw the size of the intervals
  before writing this script. This script re-implements the analysis independently: it does not source the referee's code, it uses the
  lab's canonical `compute_w1` and its own seed, and it was not tuned after the referee's output was seen. The statistic and the
  resampling design were fixed by M4's question (how uncertain are the ranks Table 5 already prints). The run was not chosen among
  alternatives.
- What is being quantified is the uncertainty of statistics the manuscript already reports: the Table 5 ranks and the age-versus-SBP
  rank correlation. No new claim is selected from the output.

## Canonical run

| Item | Value |
|------|-------|
| Input | `data/gusto.csv` (40,830 patients, 16 regions); `results/gusto_r8_w1_per_pair.csv` (point estimates → observed ranks) |
| Bootstrap B | 1,000 |
| Seed / RNG | `set.seed(20261011)`, `RNGkind("Mersenne-Twister", "Inversion", "Rejection")`, sequential (no parallel) |
| Resampling | patients resampled with replacement within each region, sample sizes kept; regions resampled in sorted order; Region 8 (anchor) is resampled once per replicate and shared by all 15 partners |
| W1 | `compute_w1` copied verbatim from `R/fig3_w1_axis.R` (CDF-area form, eq. (8)); the script asserts that it reproduces `gusto_r8_w1_per_pair.csv` to within 1e-10 |
| Interval | percentile, `quantile(type = 1)` (inverse empirical CDF) at 0.025 / 0.975, so the rank limits are attained integers |
| R version / packages | `results/gusto_rank_intervals_sessionInfo.txt` (base R only) |
| Run time | about 70 s |

## Definitions

- $W_{pv}$ is $W_1(F_{R8,v}, F_{p,v})$ for partner $p$ and modifier $v \in \{\text{age}, \text{SBP}\}$. $\mathrm{rank}_{pv}$ is the rank of $W_{pv}$ among the 15 partners, where 1 is the closest.
- `rank_obs` is the rank of the point estimates. It is identical to the Table 5 Rank column; `make_paper_tables.R` asserts this.
- `rank_lo` and `rank_hi` are the 2.5th and 97.5th percentiles of $\mathrm{rank}^{*b}_{pv}$, $b = 1..B$.
- `rho_obs` is Spearman's correlation between the 15 point-estimate distances on age and on SBP. It has the same value as `derived_scalars.csv` `gusto_spearman_w1age_vs_w1sbp`.
- `rho_lo` and `rho_hi` are the 2.5th and 97.5th percentiles of $\rho^{*b}$, the Spearman correlation between the replicate-$b$ age ranks and SBP ranks.
- Estimand scope: these intervals cover patient-level sampling variability with the 15 regions held fixed. They do not treat the regions as a sample from a super-population. That is the difference from the Bonett–Wright interval in `derived_scalars.csv`, which this analysis replaces in §5 (referee Minor 10).

## Column semantics

| file | column | definition |
|---|---|---|
| gusto_rank_intervals.csv | partner | GUSTO-I region number (`regl`), Region 8 excluded |
| | em | `age` or `sysbp` |
| | rank_obs / rank_lo / rank_hi | integers 1–15, as defined above |
| gusto_rank_spearman_boot.csv | stat, value | `rho_obs`, `rho_lo`, `rho_hi`, `B` |
| | stat (added 2026-10-12) | `rho_w1_smd_{age,sbp}_{obs,lo,hi}`: Spearman(W1, \|SMD\|) over the 15 partners, observed and type-1 2.5th / 97.5th bootstrap percentiles |

## Consumers

- `R/make_paper_tables.R` → `paper/generated/tab_gusto_nabcd.tex`. Resolved cells print `rank [lo, hi]`. Cells unresolved against the null floor keep the shared dagger range (e.g. `1--6$^\dagger$`).
- `paper/numbers_registry.csv` keys `spearmanAgeVsSbpBootLo` and `spearmanAgeVsSbpBootHi`.

## Reproducibility statement

- Re-run from the repo root: `Rscript projects/similarity-metric/R/gusto_rank_intervals.R`. With the same seed and R ≥ 3.6 (sample.kind "Rejection") the output is bit-identical.
- Check against an independent implementation: the referee's r05 (seed 5) agrees within Monte Carlo error. Every rank limit differs by at most 1 position. Example: R2 age is [12, 15] there and [13, 15] here. The Spearman interval is [-0.518, 0.039] there and [-0.514, 0.021] here. Cite the generated values, not the referee's.

## Addendum 2026-10-12: Spearman(W1, |SMD|) intervals (Louis's residual review M5, D-20261012-2)

- **What was added.** The same bootstrap loop (B = 1,000, seed 20261011, the same resamples) now also records, per replicate and per
  modifier, Spearman's correlation between the 15 partners' $\widehat W_1$ and $|\mathrm{SMD}|$ to Region 8. $|\mathrm{SMD}|$ is `smd_s`
  copied verbatim from `R/application_all_methods.R`: $|\bar x_p - \bar x_{R8}| / s_{\text{pooled}}$ with
  $s^2_{\text{pooled}} = ((n_1-1)s_1^2 + (n_2-1)s_2^2)/(n_1+n_2-2)$. It is the definition behind `app_all_methods_ranks.csv`
  `spearman_vs_W1` (registry `spearmanW1SMDage` / `spearmanW1SMDsbp`). The script asserts that the observed values reproduce that file to 1e-12.
  New rows: `rho_w1_smd_age_obs` 0.8964, `_lo` 0.7036, `_hi` 0.9893; `rho_w1_smd_sbp_obs` 0.9536, `_lo` 0.9036, `_hi` 0.9929. The percentile is type 1, with no bias correction.
- **Existing outputs unchanged.** The SMD step draws no random numbers. `gusto_rank_intervals.csv` is byte-identical before and after the change (`cmp`).
  The first five lines of `gusto_rank_spearman_boot.csv` (header, `rho_obs`, `rho_lo`, `rho_hi`, `B`) are byte-identical too. sessionInfo was re-saved.
- **Prior look.** These intervals were added after Louis's 2026-10-12 internal review M5 (`review_response/INTERNAL_REVIEW_20261012.md`)
  and before the manuscript sentence citing them was written. The point estimates (0.90 / 0.95) were already reported. The analysis is not in
  a pre-registered protocol and it quantifies the uncertainty of statistics already printed. No alternative was tried and none was selected.
- **Consumers.** Registry keys `spearmanW1SMDageLo`, `spearmanW1SMDageHi`, `spearmanW1SMDsbpLo`, `spearmanW1SMDsbpHi` (.2f).
- **Scope caveat.** The SMD here (n−1-weighted pooled SD, 15 partners vs Region 8) is not the survey's `compute_smd` (`R/real_data_survey.R`,
  $\sqrt{(s_1^2+s_2^2)/2}$, all region pairs) behind `surveySpearmanMin/Max`. The two sets of numbers answer different rows and must not be mixed.
