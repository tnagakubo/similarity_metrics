# R Code Directory

R scripts and C++ source for the per-EM W₁ manuscript (`paper/per_em_W1_wiley.tex`).
Every script runs from the project root (`projects/similarity-metric/`) and writes to `results/`, `figures/` or `paper/generated/`.
One writer per output file; each production script saves a `*_sessionInfo.txt` beside its result and is listed in the matching `results/*_PROVENANCE.md`.

The nABCD-era engine (`simulation_manuscript_v2.R`, `nABCD_rcpp.cpp`, `run_*.R`, `regen_*.R`, …) and the pre-v6 decision-rule simulations (`threshold_*`, `anchor_vs_clustering_*`, `validate_*`) were archived on 2026-10-16 → `archive/cleanup_20261016/R/` (see its `MANIFEST.md`). Earlier figure writers that would overwrite fig2 / fig3 are in `archive/R_nABCD_20260922/` and `archive/R_superseded_20260922/`.

## Manuscript generators (run by CI — `.github/workflows/r-and-tex.yml`)

| Script | Writes | Notes |
|---|---|---|
| `make_paper_tables.R` | `paper/generated/tab_*.tex` | Single writer of every data table (Study 2 estimation, Study 1 identification, GUSTO-I application) |
| `make_derived_numbers.R` | `results/derived/*.csv` | Quantities the prose cites that no result CSV holds as one cell (ranges, ratios, bounds); feeds `paper/numbers_registry.csv` |
| `verify_study1_app_numbers.R` | `results/verify_study1_app.log` | Numbers gate for the identification study and the GUSTO-I application |
| `verify_study2_figures.R` | `results/verify_study2.log` | Numbers gate for the simulation section (Study 2) |

## Simulations (pre-registered; `PROTOCOL_*.md`)

| Script | Protocol | Writes |
|---|---|---|
| `w1_raw_simulation.R` + `W1_raw_rcpp.cpp` | — (2026-05-16 base run, S1–S7; provenance in `results/STUDY1_PROVENANCE.md`) | `results/w1_raw_simulation.rds`, `w1_raw_truth.rds` |
| `study1_summary_exact.R` | — (re-summarises the canonical run with exact truths) | `results/w1_raw_summary.csv` (canonical), `study1_latex_rows.tex` |
| `study1_miss_side.R` | — | `results/study1_miss_side.csv` (side of CI misses) |
| `w1_raw_simulation_ext.R` | `PROTOCOL_study2_extension.md` | `results/w1_raw_ext_simulation.rds`, `w1_raw_ext_summary.csv` |
| `study2_mcse.R` | `PROTOCOL_study2_extension.md` | `results/study2_mcse.csv` (Monte Carlo SE of every performance measure) |
| `study2_interval_variants.R` | — | `results/study2_interval_variants.csv` |
| `selection_simulation.R` | `PROTOCOL_study1_identification.md` | `results/selection_sim_summary{,_ext}.csv`, `selection_sim_config{,_ext}.csv` |
| `clustering_simulation.R`, `clustering_nok_simulation.R` | `PROTOCOL_study1_identification.md`, `PROTOCOL_silhouette_extension.md` | `results/clustering_sim_summary{,_ext}.csv`, `clustering_nok_*` |
| `required_n.R` | `PROTOCOL_study1_identification.md` | `results/required_n_{selection,clustering}.csv` |
| `set4_control_mechanism.R` | `PROTOCOL_set4_control_mechanism.md` | `results/set4_control_mechanism.csv`, `set4_integrals.csv`, `set4_null_sd_ratios.csv` |
| `validate_plan.R` | — | Checks the selection / clustering configuration against the registered plan |
| `real_data_survey.R` | `PROTOCOL_real_data_survey.md` | `results/real_data_survey_{pairs,summary}.csv` |

## GUSTO-I application

| Script | Writes |
|---|---|
| `fig3_w1_axis.R` | `results/gusto_r8_w1_per_pair.csv` (Region 8 pairwise Ŵ₁ + percentile bootstrap CI) and Figure 3 |
| `gusto_operability_check.R` | `results/gusto_operability.csv` (null floor of Ŵ₁ per partner) |
| `gusto_null_floor_permutation.R` | `results/gusto_null_floor_permutation{,_summary}.csv` |
| `gusto_rank_intervals.R` | `results/gusto_rank_intervals.csv`, `gusto_rank_spearman_boot.csv` |
| `gusto_sensitivity_outliers.R` | `results/gusto_sensitivity_outliers{,_summary}.csv`, `gusto_sbp_digit_preference.csv` |
| `gusto_lstar_table.R` | `results/gusto_lstar_intervals.csv` (L* retired in D-20261016-1 and its table is no longer generated; the script stays because `make_derived_numbers.R` parses `DELTA_CLIN` from it and `results/NUMBERS_LEDGER.csv` cites it as the source of Δ_clin; `verify_study1_app_numbers.R` keeps the CSV identities) |
| `gusto_w1_clustering.R` | `results/gusto_w1_clustering.csv`, `figures/fig_gusto_dendrogram.pdf` (silhouette extension) |
| `application_all_methods.R` | `results/app_all_methods_{distances,ranks,procedures}.csv` |
| `gusto_case_study.R` | 2026-05 nABCD-era case study; kept because `results/NUMBERS_LEDGER.csv` cites it as a source locator |

## Figures (`figures/`, paper standard: width 7", base_size 11, greyscale; `_color` for slides)

| Script | Figure |
|---|---|
| `figures_paper_W1.R` | Figure 1 (`fig1_w1_definition`) and the shared theme |
| `fig2_bar_chart.R` | Figure 2 (`fig2_simulation_results`), reads `results/w1_raw_summary.csv` |
| `fig3_w1_axis.R` | Figure 3 (`fig3_gusto_r8_forest`) |
| `figures_required_n.R` (shares the theme of `figures_selection.R`) | `fig_required_n_auc` (in the manuscript) and `fig_required_n_ari` (output archived 2026-10-16) |
| `figures_selection.R` | Selection / clustering figures; the manuscript no longer includes them (outputs archived 2026-10-16) |

## Replication

| Script | Notes |
|---|---|
| `replication/study2_estimation_louis.R` | Clean-room re-implementation from the Methods text (`/replicate`, `results/REPLICATION_20261011.md`) |
| `louis_independent_replication.R` | 2026-05 nABCD-era clean-room replication; cited by `RESEARCH_FRAMEWORK.md` as the pattern |

## Data

| File | Description |
|---|---|
| `data/gusto.csv` | GUSTO-I IPD (also `predtools::gusto`); `data/GUSTO/gusto_r8_results.csv` is the Region 8 result table |
| `data/IST/`, `data/IST3/`, `data/CRASH2/` | IST-1, IST-3, CRASH-2 raw data + dictionaries (case-study candidates; `exploratory/ist1_case_study/`) |
| `data/simulation_results_v2.csv`, `R/data/simulation_results_v2.csv` | nABCD-era simulation output, cited by `CLAIMS.md` history rows |

## Dependencies

- **R packages**: stats, parallel, future.apply, ggplot2, dplyr, tidyr, readr, patchwork, Rcpp
- **Lint**: `bash scripts/check_r_reproducibility.sh projects/similarity-metric/R` (declared seed, project-relative paths, sessionInfo)
