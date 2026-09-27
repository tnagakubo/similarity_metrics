# PROTOCOL — Real-data survey: do W₁ and existing measures order region pairs differently?

Registered 2026-09-26 (Tak: Option C「探すなら選り好みしない調査。結果はそのまま Supplement」). Phase 2 gate: no confirmatory run before this file is saved. Deviations are appended in §8 with reasons; nothing is deleted.

## 0. Disclosure of prior look (honesty clause)
Before this protocol, an exploratory scan (`scratchpad/disagree_scan.R`, 2026-09-26 15:40) was run on the same three datasets: W₁ in overall-SD units vs |SMD|, all region pairs with n ≥ 100, 13 EMs. It reported Spearman 0.839–0.996 and 5 IST-1 pairs with SMD < 0.1 and W₁ > 0.2 SD, without a null-floor check. The thresholds in §3 (SMD < 0.1) were therefore chosen after that look. For this reason the **primary** outcome is threshold-free (rank correlation), and the threshold-based count is **secondary**. The exploratory output is not reported as a result.

## 1. Claim (Harvey)
In the trial IPD available to us, how often W₁ orders region pairs differently from the standardized mean difference and the Kolmogorov–Smirnov statistic, reported for every dataset and every continuous candidate effect modifier without selection.

## 2. What the study licenses / does not license (Mike, fixed in advance)
**Licenses**
- A frequency statement restricted to these three trials: agreement between W₁ and SMD/KS orderings, and the number of region pairs whose difference SMD calls negligible while W₁ resolves it against the null floor.
- Whether regional differences in these trials go beyond location (SD ratio as a descriptor).

**Does not license**
- That W₁ is right and SMD wrong (or the reverse) in any disagreeing pair — real data have no ground truth. Identification claims rest on Study 2 only.
- Generalization to registries, RWE, or other disease areas. Trial eligibility criteria homogenize baseline distributions; the survey says nothing about populations outside these trials.
- Any pooling judgment, partner set, or threshold (per the paper's principle: quantify, do not decide).

## 3. Design (Mike)
**Datasets (all trial IPD on disk; none excluded by result)**
| Dataset | Source | Grouping | Continuous EMs (all available) |
|---|---|---|---|
| GUSTO-I | `predtools::gusto` (N = 40,830; identical to `data/gusto.csv`) | `regl` (16 regions, as in the paper) | age, sysbp, pulse, height, weight |
| IST-3 | `data/IST3/ist3_full_vars.csv` | `country`, excluding the pooled category "OTHER" (not a region) | age, nihss, treatdelay, sbp, weight |
| IST-1 | `data/IST/IST_corrected.csv` | `COUNTRY` | AGE, RSBP, RDELAY |

- **Excluded**: CRASH-2 — `data/CRASH2/crash2.rds` is an HTML page (failed download), not data. Binary/categorical variables (out of the paper's scope). GUSTO `ste` (12-level count) — ordinal with few levels.
- **Region inclusion**: n ≥ 100 non-missing values for the EM (the paper's Study 1 estimation criterion). Applied per EM. Missing values dropped per EM.
- **Pairs**: all unordered pairs of included regions (no anchor), per EM.

**Measures (who owns what)**
- W₁ — exact CDF-area form, same function as `R/gusto_operability_check.R::compute_w1`. Reported in EM units and divided by the EM's overall SD (across included regions) for cross-EM comparability.
- |SMD| — absolute mean difference over the pooled SD √((s₁² + s₂²)/2) (Austin 2011; existing).
- KS — sup |F̂₁ − F̂₂| (existing).
- RV1 (Komiyama et al.) is not run separately: on a single continuous EM its ordering equals that of |SMD| up to the roster standardization (shown in the paper, Spearman 1.000). RV2/RV3 are our extensions and are not included.

**Null floor per pair**: B = 1,000 replications; both resamples drawn with replacement from the pooled sample of the two regions, at the two regions' sizes (symmetric; no anchor in this survey). A pair is **resolved** if observed W₁ > the 95th percentile. Seed 2026; each pair's RNG stream is set by `set.seed(2026 + pair_index)` so results are bit-reproducible regardless of parallel scheduling.

## 4. Outcomes (defined before the run)
- **Primary** (per dataset × EM): Spearman rank correlation between W₁ and |SMD| across all pairs; the same between W₁ and KS.
- **Secondary** (per dataset × EM):
  - count of pairs with |SMD| < 0.1 (conventional negligible-imbalance cut, Austin 2009) **and** W₁ resolved against its null floor;
  - count of pairs with |SMD| < 0.1 and W₁ not resolved;
  - maximum SD ratio across pairs (descriptor of beyond-location differences).
- Every dataset × EM row is reported, including rows with no disagreement.

## 5. Louis's attack and the answers
- *Circularity*: no θ is specified, nothing is scored against a W₁-defined truth → no KR-duality circularity.
- *Cherry-picking*: every dataset on disk and every continuous EM is included; the only exclusions are listed in §3 with non-result reasons.
- *"Resolved" misread as "W₁ is right"*: resolved means only that W₁ detects a difference from no difference; §2 forbids reading it as correctness.
- *Threshold chosen after a look*: disclosed in §0; primary outcome is threshold-free.
- *Multiple pairs share regions (non-independence)*: outcomes are descriptive counts and correlations; no p-values or CIs across pairs are reported.
- *Whatever the result*: near-complete agreement supports Discussion ¶4 ("in location-dominated data the contribution is calibration"); disagreements are reported as frequencies without a correctness claim. Either way the claim in §1 holds.

## 6. Outputs (Katrina)
- Script: `R/real_data_survey.R` (single writer)
- `results/real_data_survey_pairs.csv` — one row per dataset × EM × pair: n₁, n₂, W₁ (units), W₁/SD, |SMD|, KS, SD ratio, null q95, resolved
- `results/real_data_survey_summary.csv` — one row per dataset × EM (outcomes of §4)
- `results/real_data_survey.log` — seed, B, sessionInfo, run time
- Supplement: `paper/supplement_real_data_survey.tex` — one table (the summary, all rows) + a short description of §3; no figure. Caption states what is tabulated only.
- Main text: at most one sentence in Discussion ¶4 pointing to the Supplement — **new prose, goes to paragraph review**.

## 7. Go / No-Go (Jessica)
Go. Conditions: the §0 disclosure stays in the Supplement text in one sentence; nothing in the main text claims W₁ is "better" on real data.

## 8. Deviations
- 2026-09-26 run (12.0 min, 1,503 pairs): executed as specified; no deviation.
- Post hoc (labelled as such in the Supplement): the secondary count mixes an effect-size cut (SMD < 0.1) with detectability (resolution grows with n). To read it, the Supplement adds two descriptors not in §4 — the median regional n per trial and the largest W1/SD among the counted pairs (GUSTO-I 0.19, IST-1 0.31). No outcome was dropped or redefined.
- Supplement label E is provisional (main text currently cites Supplements A and D only).
- 2026-09-26 18:10: Supplement label changed E → C (team decision: former Supplement B, an uncited empirical illustration, is dropped; D → B, E → C).
