# Evidence coverage — similarity-metric

evidence_coverage: 53 result files, 14 unbilled (largest results/threshold_sim_summary.csv 8383 KB); CLAIMS rows 43, evidence paths missing in 1; graphics missing 0, figures unused 13; R scripts unmentioned 61/88; exploratory leaks 0

Billing documents scanned: CLAIMS.md, PROTOCOL_real_data_survey.md, PROTOCOL_silhouette_extension.md, PROTOCOL_study1_identification.md, R/make_derived_numbers.R, R/make_paper_tables.R, R/verify_5norm_rcpp.R, R/verify_all.R, R/verify_study1_app_numbers.R, R/verify_study2_figures.R, R/verify_true_values.R, paper/numbers_registry.csv, paper/per_em_W1_wiley.tex, paper/supplement_L_clinical_lit.md, paper/supplement_normalizer_comparison.tex, paper/supplement_path_alpha.tex, paper/supplement_real_data_survey.tex, results/GUSTO_RANK_INTERVALS_PROVENANCE.md, results/NUMBERS_LEDGER.csv, results/REPLICATION_20261011.md, results/STUDY1_PROVENANCE.md

## 1. Result files — billed by the manuscript, a supplement, or any lifecycle document?

| file | KB | manuscript | supplement | any doc |
|---|---:|:-:|:-:|:-:|
| results/threshold_sim_summary.csv | 8383 | — | — | ❌ unbilled |
| results/w1_raw_simulation_partial.rds | 4623 | — | — | ❌ unbilled |
| results/threshold_sim_operating.csv | 44 | — | — | ❌ unbilled |
| results/anchor_vs_clustering_tau.csv | 21 | — | — | ❌ unbilled |
| results/anchor_vs_clustering_group_100k.csv | 6 | — | — | ❌ unbilled |
| results/anchor_vs_clustering_group.csv | 6 | — | — | ❌ unbilled |
| results/clustering_nok_clinical.csv | 5 | — | — | ❌ unbilled |
| results/threshold_boot_summary.csv | 4 | — | — | ❌ unbilled |
| results/gusto_lub_slack.csv | 1 | — | — | ❌ unbilled |
| results/gusto_lub_scaling.csv | 1 | — | — | ❌ unbilled |
| results/app_all_methods_procedures.csv | 1 | — | — | ❌ unbilled |
| results/clustering_nok_truth.csv | 0 | — | — | ❌ unbilled |
| results/clustering_nok_truth_ext.csv | 0 | — | — | ❌ unbilled |
| results/w1_raw_truth.rds | 0 | — | — | ❌ unbilled |
| results/real_data_survey_pairs.csv | 219 | — | ✅ | ✅ |
| results/selection_sim_summary_ext.csv | 101 | — | — | ✅ |
| results/selection_sim_summary.csv | 51 | — | — | ✅ |
| results/clustering_sim_summary_ext.csv | 24 | — | — | ✅ |
| results/clustering_sim_summary.csv | 13 | — | — | ✅ |
| results/derived/selection_cell_auc_range.csv | 11 | — | — | ✅ |
| results/derived/selection_error_rates.csv | 9 | — | — | ✅ |
| results/NUMBERS_LEDGER.csv | 8 | — | — | ✅ |
| results/clustering_nok_silhouette_ext.csv | 7 | — | — | ✅ |
| results/required_n_clustering.csv | 5 | — | — | ✅ |
| results/app_all_methods_distances.csv | 4 | — | — | ✅ |
| results/clustering_nok_clinical_ext.csv | 4 | — | — | ✅ |
| results/derived/derived_scalars.csv | 3 | — | — | ✅ |
| results/w1_raw_summary_mctruth_20260517.csv | 2 | — | — | ✅ |
| results/clustering_sim_config_ext.csv | 2 | — | — | ✅ |
| results/replication/study2_estimation_louis.csv | 2 | — | — | ✅ |
| results/selection_sim_config_ext.csv | 2 | — | — | ✅ |
| results/required_n_selection_floor.csv | 2 | — | — | ✅ |
| results/study2_mcse.csv | 2 | — | — | ✅ |
| results/clustering_sim_config.csv | 1 | — | — | ✅ |
| results/real_data_survey_summary.csv | 1 | — | ✅ | ✅ |
| results/selection_sim_config.csv | 1 | — | — | ✅ |
| results/derived/required_n_separation.csv | 1 | — | — | ✅ |
| results/gusto_w1_clustering.csv | 1 | — | — | ✅ |
| results/derived/study2_coverage_vs_mcse.csv | 1 | — | — | ✅ |
| results/gusto_rank_intervals.csv | 1 | — | — | ✅ |
| results/app_all_methods_ranks.csv | 1 | — | — | ✅ |
| results/required_n_clustering_floor.csv | 0 | — | — | ✅ |
| results/derived/set4_true_distances.csv | 0 | — | — | ✅ |
| results/gusto_rank_spearman_boot.csv | 0 | — | — | ✅ |
| results/w1_raw_simulation.rds | 4619 | ✅ | — | ✅ |
| results/anchor_vs_clustering_tau_100k.csv | 21 | ✅ | — | ✅ |
| results/required_n_selection.csv | 19 | ✅ | — | ✅ |
| results/clustering_nok_silhouette.csv | 9 | ✅ | — | ✅ |
| results/gusto_operability.csv | 4 | ✅ | — | ✅ |
| results/w1_raw_summary.csv | 2 | ✅ | — | ✅ |
| results/gusto_lstar_intervals.csv | 2 | ✅ | — | ✅ |
| results/gusto_r8_w1_per_pair.csv | 2 | ✅ | ✅ | ✅ |
| results/study1_miss_side.csv | 1 | ✅ | — | ✅ |

Unbilled: **14** file(s). Each is either evidence a claim should cite, or exploratory work to be labelled as such in README / an `exploratory/` folder (never silently omitted).

## 2. Figures

Included graphics: 4; missing on disk: none ✅
Figures on disk never included (non-colour stems): fig_clustering_ari, fig_gusto_dendrogram, fig_required_n_ari, fig_selection_auc_by_type, fig_selection_auc_set4, fig_selection_false_pooling, fig_selection_harm, fig_threshold_sensitivity, slide_bias, slide_estimation_quality, slide_gusto_r8_scatter, slide_scenario_overview, w1_raw_oc

## 3. CLAIMS.md — evidence paths on disk

Rows: 43; rows with a missing evidence path: 1; simulation/application rows citing no file path: C-39
- ❌ C-31: paper/generated/tab_study2_ari.tex

## 4. Exploratory leak — manuscript references under exploratory/

none ✅

## 5. R scripts mentioned nowhere (manuscript, registry, protocols, provenance, verify scripts)

analyze_anchor_vs_clustering.R, analyze_validation.R, anchor_vs_clustering_simulation.R, check_normality.R, check_partial.R, check_progress.R, clean_partial_redesign.R, compare_e1_grid2_setup.R, compare_rcpp_vs_r.R, compute_redesign_truth.R, cross_em_generators.R, cross_em_invariance.R, cross_em_visualize.R, export_redesign_tables.R, fig2_bar_chart.R, fig_normalizer_evidence.R, figures_paper.R, figures_paper_W1.R, figures_required_n.R, figures_selection.R, figures_threshold.R, gusto_lub_sensitivity.R, inspect_per_scenario.R, inspect_redesign_full.R, inspect_results_detailed.R, inspect_results_v2.R, louis_independent_replication.R, regen_all_slide_figs.R, regen_combo.R, regen_fig1_fig2.R, regen_fig1_only.R, regen_fig2_only.R, regen_forest.R, regen_paper_figs.R, regen_redesign_figs.R, regen_scatter.R, regen_simulation_results.R, run_all.R, run_full_sim.R, run_normality_check.R, run_redesign_simulation.R, run_sim_500.R, run_validation_simulation.R, scenarios_redesign.R, scenarios_validation.R, study2_mcse.R, summarize_results.R, test_scatter_options.R, threshold_bootstrap_simulation.R, threshold_simulation.R, triangle_inequality_check.R, triangle_verify.R, true_normalizers.R, validate_figures.R, validate_selection.R, validate_threshold.R, validate_threshold_boot.R, w1_raw_figs.R, w1_raw_report.R, w1_raw_smoke_test.R, w1_verify_louis.R
