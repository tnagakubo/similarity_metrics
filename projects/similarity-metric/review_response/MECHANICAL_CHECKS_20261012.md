# Mechanical checks — similarity-metric (2026-10-12 00:47, commit fad1010)

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
Donna: SUITS.md lint — clean (all scenes).
  speakers: Donna 26, Harvey 30, Jessica 14, Katrina 26, Louis 23, Mike 25, Rachel 10
```

## 3. Numbers audit — per_em_W1_wiley.tex
```
Mike: numbers audit of per_em_W1_wiley.tex — 118 numeric tokens, 118 sourced, 0 unsourced (0 distinct values). Ledger: projects\similarity-metric\results\NUMBERS_LEDGER.csv (35 rows)
```
Detail: `python3 scripts/numbers_audit.py projects/similarity-metric/paper/per_em_W1_wiley.tex` · ledger `projects/similarity-metric/results/NUMBERS_LEDGER.csv`

## 4. Citation audit — per_em_W1_wiley.tex vs per_em_W1_wiley.bib
```
- cited keys: **25** · bib entries: **45** · cited-but-missing: **0** · uncited: **20** · cited without DOI: **1** · malformed DOI: **0** · duplicate DOI: **0** · duplicate keys: **0**
```
Detail: `/cite-check` → `projects/similarity-metric/review_response/CITATION_AUDIT_20261012.md`

## 5. R reproducibility lint — projects/similarity-metric/R
```
Mike: R reproducibility lint (89 file(s))
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
| LITERATURE_SEARCH_LOG.md | ❌ | template in templates/ |
| LAB_STATUS.md | ✅ | |
| PROTOCOL_*.md | ✅ | 3 file(s) |
| SIMULATION_FINDINGS*.md | ❌ | 0 file(s) |
| results/NUMBERS_LEDGER.csv | ✅ | 35 row(s) |
| results/REPRODUCTION_*.md | ❌ | 0 report(s) |
| review_response/CITATION_AUDIT_*.md | ❌ | 0 audit(s) |
| protocol ↔ code: PROTOCOL_study1_identification.md | ⚠️ | study1_identification ↔ R/selection_simulation.R: 10/21 agree — DRIFT (advisory: post_hoc protocol) |
| CLAIMS.md rows | — | supported 3 · pending 29 |
## 7. Claim guards (review findings -> executable, mutation-tested)
```
claim_guards: 30 guards, 0 FAIL, 0 vacuous (pass on known_bad), 5 without known_bad — projects/similarity-metric/paper/per_em_W1_wiley.tex
```
Detail: `python3 scripts/claim_guards.py projects/similarity-metric/CLAIM_GUARDS.toml --mutation` · seeded by `/referee` and `/review`

## 8. Structure audit — per_em_W1_wiley.tex
```
structure_audit: per_em_W1_wiley.tex — main text 9937 words (1.7× venue upper), abstract 247/250, floats 14 (0 placement issues), evidence-outside-Results paragraphs 3, duplicate sentence pairs 0, sections over budget 4
```
Detail: `/structure` → `projects/similarity-metric/review_response/STRUCTURE_AUDIT_20261012.md`

## 9. Evidence coverage — unbilled results, CLAIMS evidence paths, figures
```
evidence_coverage: 53 result files, 14 unbilled (largest results/threshold_sim_summary.csv 8383 KB); CLAIMS rows 43, evidence paths missing in 0; graphics missing 0, figures unused 13; R scripts unmentioned 61/88; exploratory leaks 0
```
Detail: `/necessity` → `projects/similarity-metric/review_response/EVIDENCE_COVERAGE_20261012.md`

