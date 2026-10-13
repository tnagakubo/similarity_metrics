# Mechanical checks — similarity-metric (2026-10-14 00:59, commit fad1010)

All advisory. Red items are gates for `/phase next` and `/submission-check` (RESEARCH_FRAMEWORK §6).

## 0. Lab doctor (toolchain, hook wiring, skills/agents, CI scripts, baselines)
```
  ❌ python3 -I fails — the interpreter finds its stdlib only through the registry/PATH; reinstall Python so that python.exe and Lib/ live together
  ❌ python3's sys.prefix is the working directory (c:/users/hrd13/documents/gak/0 study/800claude/20260210_sim/similarity_metrics): broken install, and $PWD/Lib is on sys.path (a planted module there would import)
lab_doctor: 47 checks, 2 ❌, 0 ⚠️
```

## 1. Consistency (state ↔ script ↔ manuscript)
```
  - similarity-metric: Phase 8 but no review_response/RESPONSE_TRACKER.md (/respond-reviewers init, or /decide that no letter is needed for a simulated review)
Donna: consistency check — 1 finding(s) above.
```

## 2. SUITS.md character lint (all scenes)
```
Donna: SUITS.md lint — 1 warning(s) in all scenes:
  - L119: scene '二つのレビューを一度に閉じる — batch 1・2a・2b と、生成器 2 本' has no '**INT. PEARSON SPECTER LITT - {LOCATION} - DAY/NIGHT**' line
  speakers: Donna 12, Harvey 10, Jessica 8, Katrina 7, Louis 9, Mike 7, Rachel 4
```

## 3. Numbers audit — per_em_W1_wiley.tex
```
Mike: numbers audit of per_em_W1_wiley.tex — 141 numeric tokens, 141 sourced, 0 unsourced (0 distinct values). Ledger: projects\similarity-metric\results\NUMBERS_LEDGER.csv (51 rows)
```
Detail: `python3 scripts/numbers_audit.py projects/similarity-metric/paper/per_em_W1_wiley.tex` · ledger `projects/similarity-metric/results/NUMBERS_LEDGER.csv`

## 4. Citation audit — per_em_W1_wiley.tex vs per_em_W1_wiley.bib
```
- cited keys: **35** · bib entries: **53** · cited-but-missing: **0** · uncited: **18** · cited without DOI: **2** · malformed DOI: **0** · duplicate DOI: **0** · duplicate keys: **0**
```
Detail: `/cite-check` → `projects/similarity-metric/review_response/CITATION_AUDIT_20261014.md`

## 5. R reproducibility lint — projects/similarity-metric/R
```
Mike: R reproducibility lint (94 file(s))
files with ❌: 22   files with ⚠️ only: 38
  ❌ analyze_validation.R  writes-results-no-sessionInfo;
  ❌ check_normality.R  writes-results-no-sessionInfo;
  ❌ clean_partial_redesign.R  writes-results-no-sessionInfo;
  ❌ compare_e1_grid2_setup.R  writes-results-no-sessionInfo;
  ❌ compute_redesign_truth.R  writes-results-no-sessionInfo;
  ❌ cross_em_invariance.R  writes-results-no-sessionInfo;
  ❌ cross_em_visualize.R  writes-results-no-sessionInfo;
  ❌ export_redesign_tables.R  writes-results-no-sessionInfo;
  ❌ fig_normalizer_evidence.R  writes-results-no-sessionInfo;
  ❌ gusto_case_study.R  writes-results-no-sessionInfo;
  ❌ inspect_per_scenario.R  abspath@39;
  ❌ inspect_redesign_full.R  abspath@43;
  ❌ regen_forest.R  writes-results-no-sessionInfo;
  ❌ regen_redesign_figs.R  writes-results-no-sessionInfo;
  ❌ regen_scatter.R  writes-results-no-sessionInfo;
  ❌ regen_simulation_results.R  writes-results-no-sessionInfo;
  ❌ run_all.R  abspath@28;
  ❌ scenarios_validation.R  draws-without-seed;
  ❌ test_scatter_options.R  writes-results-no-sessionInfo;
  ❌ triangle_inequality_check.R  abspath@513;
  ❌ triangle_verify.R  abspath@81;
  ❌ verify_all.R  abspath@110;
```

## 6. Lifecycle artifacts on disk

| artifact | present | note |
|---|---|---|
| CLAIMS.md | ✅ | |
| DECISIONS.md | ✅ | |
| LITERATURE_SEARCH_LOG.md | ✅ | |
| LAB_STATUS.md | ✅ | |
| PROTOCOL_*.md | ✅ | 5 file(s) |
| SIMULATION_FINDINGS*.md | ❌ | 0 file(s) |
| results/NUMBERS_LEDGER.csv | ✅ | 51 row(s) |
| results/REPRODUCTION_*.md | ❌ | 0 report(s) |
| review_response/CITATION_AUDIT_*.md | ✅ | 1 audit(s) |
| protocol ↔ code: PROTOCOL_set4_control_mechanism.md | ✅ | set4_control_mechanism ↔ R/set4_control_mechanism.R: 8/8 agree — PASS |
| protocol ↔ code: PROTOCOL_study1_identification.md | ⚠️ | study1_identification ↔ R/selection_simulation.R: 10/21 agree — DRIFT (advisory: post_hoc protocol) |
| protocol ↔ code: PROTOCOL_study2_extension.md | ✅ | study2_extension ↔ R/w1_raw_simulation_ext.R: 10/10 agree — PASS |
| CLAIMS.md rows | — | supported 11 · pending 18 |
## 7. Claim guards (review findings -> executable, mutation-tested)
```
claim_guards: 59 guards, 0 FAIL, 3 vacuous (pass on known_bad), 9 without known_bad — projects/similarity-metric/paper/per_em_W1_wiley.tex
```
Detail: `python3 scripts/claim_guards.py projects/similarity-metric/CLAIM_GUARDS.toml --mutation` · seeded by `/referee` and `/review`

## 8. Structure audit — per_em_W1_wiley.tex
```
structure_audit: per_em_W1_wiley.tex — main text 9818 words (1.6× venue upper), abstract 250/250, floats 13 (0 placement issues), evidence-outside-Results paragraphs 2, duplicate sentence pairs 0, sections over budget 4
```
Detail: `/structure` → `projects/similarity-metric/review_response/STRUCTURE_AUDIT_20261014.md`

## 9. Evidence coverage — unbilled results, CLAIMS evidence paths, figures
```
evidence_coverage: 69 result files, 13 unbilled (largest results/threshold_sim_summary.csv 8383 KB); CLAIMS rows 49, evidence paths missing in 4; graphics missing 0, figures unused 13; R scripts unmentioned 60/93; exploratory leaks 0
```
Detail: `/necessity` → `projects/similarity-metric/review_response/EVIDENCE_COVERAGE_20261014.md`

