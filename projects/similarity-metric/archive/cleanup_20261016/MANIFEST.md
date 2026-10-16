# Cleanup Archive Manifest — 2026-10-16

**作成**: Donna Paulsen (Project Manager)
**理由**: Tak 指示「ファイルの整理。不要なものは archive」。per-EM W₁ 原稿（D-20261016-1 時点）のパイプラインからどこからも参照されないファイルを集約。
**判定法**: 全ファイル（651 本）の basename を、live 文書（`paper/per_em_W1_wiley.tex`・`CLAIMS.md`・`CLAIM_GUARDS.toml`・`LAB_STATUS.md`・`PAPER_LOGIC.md`・`PROTOCOL_*.md`・`results/*PROVENANCE*.md`・`results/NUMBERS_LEDGER.csv`・`paper/numbers_registry.csv`・`R/make_*.R`・`R/verify_*.R`・現行 figure writer・`scripts/`・`.github/workflows/`・`.claude/`・`memory/`・`CLAUDE.md`・`RESEARCH_FRAMEWORK.md`）で grep。参照ゼロ、または参照元が「v6 で削除」「D-20260927-2 で投稿物から外した」等の履歴記述のみのものを対象にした。
**復元**: 下表の「元パス」に `git mv` で戻すだけ。tracked ファイルは `git mv` で移動したので履歴は連続している。
**ゲート（移動後）**: `ci_ratchet.sh` PASS（numbers unsourced 0 = baseline、results unbilled 13 → 5、R lint errors 22 → 1）、`numbers_audit.py` 105/105 sourced、`evidence_coverage.py` の CLAIMS evidence path 欠落は移動前と同じ 2 件（C-08・C-49、本整理と無関係）、`check_consistency.sh` の nested agent-memory 指摘は解消。

## 移動一覧

| このフォルダ内 | 元パス | 件数 | 理由 |
|---|---|---:|---|
| `docs/RESTRUCTURE_PLAN_20260922.md`, `RESTRUCTURE_v3_clean_slate.md`, `RESTRUCTURE_v4_six_steps.md`, `RESTRUCTURE_v5_team.md`, `RESTRUCTURE_v6_no_decision.md` | `projects/similarity-metric/` | 5 | 2026-09-22〜26 の再構成計画。v6 は実行済み（原稿に反映、原則は `memory/feedback_quantify_not_decide.md`）。memory 2 本の Source パスを本フォルダに更新 |
| `docs/REVIEW_QUEUE_v6.md` | `projects/similarity-metric/` | 1 | 段落レビュー台帳 50/50 完了（D-20260927-1）。`LAB_STATUS.md` の artifacts 表のパスを更新 |
| `paper/supplement_L_clinical_lit.md`, `supplement_normalizer_comparison.tex`, `supplement_path_alpha.{tex,pdf}`, `supplement_real_data_survey.{tex,pdf}` | `paper/` | 6 | Supplement は付けない（Tak 2026-09-27、D-20260927-2、`memory/feedback_no_process_supplements.md`）。`CLAIMS.md` C-25 の履歴パスを本フォルダに更新。`PROTOCOL_real_data_survey.md` §出力の supplement 行は事前登録文のため書き換えず（本 manifest が所在） |
| `paper/per_em_W1_draft_20260926_with_supplements.pdf` | `paper/` | 1 | 09-26 時点の draft PDF。現行は `paper/output/per_em_W1_wiley.pdf`（build.sh 出力） |
| `paper/plot_simulation_results.R` | `paper/` | 1 | nABCD 期（04-25）の作図 script。現行 figure writer は `R/fig2_bar_chart.R` / `R/fig3_w1_axis.R` / `R/figures_paper_W1.R` / `R/figures_required_n.R` |
| `paper/backup/` | `paper/backup/` | 15 | 09-27 レビュー前 snapshot と 10-14 length-cut 作業一式（python cut scripts + `per_em_W1_wiley_pre_cut_20261014.tex`）。pre_cut tex は `review_response/known_bad/per_em_W1_wiley_20261014_before_cut.tex` と md5 一致（guard の known_bad 側が正本） |
| `R/` (65 files) | `R/` | 65 | nABCD 期（02〜05 月）の simulation engine・normalizer 比較・triangle inequality・regen_* figure writers・inspect/scenarios/run_* 一式、07-20 の threshold / anchor-vs-clustering / validate_* 系（v6 で削除された判定規則の simulation）、`figures_paper.R`（nABCD combo writer、09-22 に regen_* を archive 済みの本体）、`gusto_lub_sensitivity.R`（L_UB 感度、v6 で削除）、`w1_raw_figs.R` / `w1_raw_report.R` / `check_progress.R` / `w1_raw_smoke_test.R`（Study 1 raw sim の補助、canonical は `study1_summary_exact.R`）、`RESUME_INSTRUCTIONS.md`。詳細は末尾の一覧 |
| `results/anchor_vs_clustering_{group,group_100k,tau,tau_100k}.csv` + 2 logs | `results/` | 6 | anchor-vs-clustering（outline 3.1.4）は v6 で削除（`CLAIMS.md` 2026-09-26 行）。原稿 l.389 のコメントは 08-30 の判断記録として残置 |
| `results/gusto_lub_{scaling,slack}.csv` + log | `results/` | 3 | L_UB 感度分析（v6 で削除） |
| `results/threshold_{boot_summary,sim_operating,sim_summary}.csv` | `results/` | 3 | threshold simulation（判定規則、v6 で削除）。`threshold_sim_summary.csv` 8.4 MB は Claude Science 指摘の最大 unbilled |
| `figures/fig_clustering_ari*`, `fig_selection_{auc_by_type,auc_set4,false_pooling,harm}*`, `fig_threshold_sensitivity*`, `fig_required_n_ari*` | `figures/` | 28 | 原稿が `\includegraphics` しない figure（現行は fig1 / fig2 / fig3 / fig_required_n_auc の 4 本 + protocol が指す `fig_gusto_dendrogram.pdf`）。writer（`R/figures_selection.R`, `R/figures_required_n.R`）は live なので再実行すれば再生成される |
| `figures/slide_*` | `figures/` | 16 | 2026-05 GSC / 07-03 セミナー用 slide figure（nABCD 期 `figures_paper.R` 出力）。発表済み |
| `figures/w1_raw_oc.{pdf,png}` | `figures/` | 2 | `w1_raw_figs.R`（archive）の診断図 |
| `GUSTO/` | `projects/similarity-metric/GUSTO/` | 12 | 04-07 の nABCD case study 出力（Region 13 anchor）。現行 GUSTO 出力は `results/gusto_*` |
| `data/GUSTO/*.R` (16) + `gusto_all_pairwise.csv`, `gusto_smd_misleading.csv`, 3 PDFs | `data/GUSTO/` | 21 | nABCD 期の探索 script と出力。`data/gusto.csv`（原データ）と `data/GUSTO/gusto_r8_results.csv`（live 参照あり）は残置 |
| `data/IST/ist1_global_nABCD.R` | `data/IST/` | 1 | nABCD 期。原データ `IST_corrected.csv` / `IST_variables.csv` は残置 |
| `data/IST3/*.R` (5) + `CYP2C19_PM_prevalence_by_country.md`, `EGFR_mutation_prevalence_by_country.md` | `data/IST3/` | 7 | nABCD 期の case study script と 03-07 の有病率メモ。原データ `ist3.dat` / `ist3.sas` / `ist3_*_vars.csv` は残置 |
| `data/application_params.csv`, `DHS_access_plan.md`, `simulation_results_v2_corrected.csv` | `data/` | 3 | 02-07 の仮想 application、未使用の DHS 取得計画、`simulation_results_v2.csv` と md5 一致の重複 |
| `claude_science/neyman_smooth/` | `claude_science/neyman_smooth/` | 18 | 09-22 の Neyman smooth test 側線研究（参照ゼロ、`IDEAS_BACKLOG.md` にも無し）。`claude_science/` 本体（README・referee_report・verify_corrections.R）は `CLAIM_GUARDS.toml` が参照するため残置 |
| `review_response/lit_prognostic_predictive_L.md`, `memo_technical_L_and_scope.md`, `presentation_proposals.md`, `tmp_floor_sensitivity.R` | `review_response/` | 4 | 09-06 の L（Lipschitz 定数）メモ群。L* は D-20261016-1 で引退。日付付きの review 記録（`*_2026MMDD.md`、`known_bad/`、`referee/`）はすべて残置 |

## 削除（アーカイブせず）

| パス | 理由 |
|---|---|
| `paper/supplement_path_alpha.log`, `paper/supplement_real_data_survey.{aux,bbl,blg,log}` | gitignore 済みの compile 中間物（本体は上表で archive） |
| `projects/similarity-metric/.claude/agent-memory/louis/` | 入れ子 agent memory（`check_consistency.sh` 指摘）。`feedback_recount_csv_claims.md` を root `.claude/agent-memory/louis/` へ `git mv`、index 行を root `MEMORY.md` に追記したうえで空 index を `git rm` |
| `projects/similarity-metric/paper/.claude/` | 空の入れ子 agent-memory ディレクトリ |

## 温存判断（アーカイブ対象外）

- `paper/*.sty`, `WileyNJDv5.cls`, `wileyNJD-AMA.bst`（paper 直下）— `wiley-template/` と重複に見えるが、最終 build log は `./WileyNJDv5.cls` `./NJDnatbib.sty` を読み込んでおり（`NJDnatbib.sty` は template 版と内容が異なる）、**現役**
- `paper/wiley-template/`（Fonts 含む）— `build.sh` の TEXINPUTS が指す原本
- `paper/generated/tab_gusto_lstar_joint.tex`, `tab_gusto_r8.tex`, `tab_operability.tex`, `tab_study2_intervals.tex` — 原稿は `\input` しないが `R/make_paper_tables.R`（単一 writer）が生成し CI が差分を検査。整理するなら script 側（`/necessity` の対象、別件）
- `results/gusto_lstar_intervals.csv`, `R/gusto_lstar_table.R` — L* 引退後も `make_paper_tables.R` / `verify_study1_app_numbers.R` が読む
- `results/clustering_nok_*`, `app_all_methods_procedures.csv`, `w1_raw_truth.rds` — unbilled だが live な protocol script の出力セット（残り unbilled 5 本はこれ）
- `R/gusto_case_study.R`, `R/louis_independent_replication.R` — nABCD 期だが `NUMBERS_LEDGER.csv` / `RESEARCH_FRAMEWORK.md` / `/replicate` skill が参照
- `R/figures_selection.R`, `R/figures_required_n.R`, `R/validate_plan.R`, `R/clustering_*.R`, `R/selection_simulation.R` — protocol / provenance / live figure の writer
- `PAPER_OUTLINE_BILINGUAL.md` — `CLAIMS.md` / `RESEARCH_FRAMEWORK.md` / `verify_study2_figures.R` が参照
- `poster/` — 発表済みだが独立した成果物フォルダ。Tak 判断
- `exploratory/` — S22 の正規の出口
- `review_response/*_2026MMDD.*`, `known_bad/`, `referee/` — レビュー監査証跡、guard が参照
- `archives/cleanup_20260719/` 内の gitignore 済み `.aux/.log` 等 — 触らず

## R/ 移動ファイル一覧（65）

nABCD simulation engine / normalizer: `simulation_manuscript_v2.R`, `nABCD_rcpp.cpp`, `nABCD_5norm_rcpp.cpp`, `nabcd_normalizers.R`, `true_normalizers.R`, `run_all.R`, `run_full_sim.R`, `run_sim_500.R`, `run_normalizer_comparison.R`, `run_normality_check.R`, `run_redesign_simulation.R`, `run_validation_simulation.R`, `scenarios_extended.R`, `scenarios_redesign.R`, `scenarios_validation.R`, `compute_redesign_truth.R`, `clean_partial_redesign.R`, `export_redesign_tables.R`, `analyze_validation.R`, `compare_e1_grid2_setup.R`, `compare_rcpp_vs_r.R`, `verify_5norm_rcpp.R`, `verify_all.R`, `verify_true_values.R`, `w1_verify_louis.R`, `check_normality.R`, `check_partial.R`, `cross_em_generators.R`, `cross_em_invariance.R`, `cross_em_visualize.R`, `fig_normalizer_evidence.R`, `inspect_per_scenario.R`, `inspect_redesign_full.R`, `inspect_results_detailed.R`, `inspect_results_v2.R`, `summarize_results.R`, `triangle_inequality_check.R`, `triangle_verify.R`, `RESUME_INSTRUCTIONS.md`
nABCD 期 figure writers: `figures_paper.R`, `regen_all_slide_figs.R`, `regen_combo.R`, `regen_fig1_fig2.R`, `regen_fig1_only.R`, `regen_fig2_only.R`, `regen_forest.R`, `regen_paper_figs.R`, `regen_redesign_figs.R`, `regen_scatter.R`, `regen_simulation_results.R`, `test_scatter_options.R`
v6 で削除された判定規則の simulation（07-20〜08-30）: `threshold_simulation.R`, `threshold_bootstrap_simulation.R`, `figures_threshold.R`, `validate_threshold.R`, `validate_threshold_boot.R`, `validate_selection.R`, `validate_figures.R`, `anchor_vs_clustering_simulation.R`, `analyze_anchor_vs_clustering.R`, `gusto_lub_sensitivity.R`
Study 1 raw sim 補助: `w1_raw_figs.R`, `w1_raw_report.R`, `w1_raw_smoke_test.R`, `check_progress.R`
