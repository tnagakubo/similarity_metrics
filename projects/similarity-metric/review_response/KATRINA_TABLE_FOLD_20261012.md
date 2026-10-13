# KATRINA_TABLE_FOLD_20261012 (D-20261012-2)

## Task 1 — Table 1 folded into Table 2
- R/make_paper_tables.R: tab_study2_required_n.tex no longer written; tab_study2_required_n_mc.tex now 5 columns `lllll` inside `{\footnotesize ... }`.
- Layout: Cell | W1 n [lo, hi] | KS n [lo, hi] | SMD n [lo, hi] or "blind" | "W1 vs KS" (was "Intervals"; separate / overlap logic unchanged). 13 rows, same order.
- W1, KS, Separate cells: identical to the previous file in all 13 rows (checked cell by cell). SMD: reached 30, 67, 134, 529, 530, 489 with intervals; blind in the other 7; the old Table 1 SMD column (530, 489, rest blind) agrees.
- Longest row: 114 characters of source (Set 4, asymmetric severity); longest generated line 345 chars is the % header comment.
- Deleted: paper/generated/tab_study2_required_n.tex.
- cmp vs before: tab_bias, tab_coverage, tab_precision, tab_gusto_r8, tab_operability, tab_gusto_nabcd, tab_gusto_lstar_joint, sessionInfo: byte-identical. Only tab_study2_required_n_mc.tex differs.
- Consumers of the deleted file: only the manuscript \input (line 303, Harvey). No change needed in verify scripts, scripts/, scripts/tests/, .github/workflows/ (r-and-tex.yml uses git diff on generated/*.tex; commit the deletion).
- Not compiled: the manuscript is Harvey's; build.sh to be run after his edit.

## Task 2 — bib
matsushima2024 author line: Otsuba -> Otsubo, Matsusaka -> Matsuoka (verified: knowledge/pdfs/Matsushima_2024.pdf p.1 "Yasuto Otsubo", "Nobushige Matsuoka"). Nothing else changed. ist1_2000 doi 10.1016/S0140-6736(97)04011-7; ist3_2012 doi 10.1016/S0140-6736(12)60768-5 (both present). Note: key ist1_2000 carries a 1997-prefix DOI; Rachel should confirm year.
Also knowledge/summaries/Matsushima_2024.md line 4 still has the wrong surnames (not edited).

## Task 3 — IST provenance
No download record, README or script on disk ties data/IST/IST_corrected.csv or data/IST3/ist3_full_vars.csv to a source (PROTOCOL_real_data_survey.md and R/README.md only list file names). Public source recorded on disk only in review_response/CASE_STUDY_CANDIDATES_20261012.md (reconnaissance, records read from Edinburgh DataShare): IST-1 "International Stroke Trial database (version 2)" DOI 10.7488/ds/104, https://datashare.ed.ac.uk/handle/10283/124, ODC-By v1.0; IST-3 DOI 10.7488/ds/1350, https://datashare.ed.ac.uk/handle/10283/1931; access conflict unresolved (page says no application needed, DUA v2.1 PDF requires proposal). That the local files are those downloads is not on disk.

## Task 4 — verify
R/verify_study2_figures.R: ALL PASS, 134 PASS / 0 FAIL, exit 0. R/verify_study1_app_numbers.R: ALL PASS, 63 PASS / 0 FAIL, exit 0. Logs results/verify_study2.log and results/verify_study1_app.log rewritten. Neither script read the deleted table.
