# Mechanical checks — similarity-metric (2026-10-11 10:26, commit 0d70baf)

All advisory. Red items are gates for `/phase next` and `/submission-check` (RESEARCH_FRAMEWORK §6).

## 1. Consistency (state ↔ script ↔ manuscript)
```
  - similarity-metric: Phase 8 but no review_response/RESPONSE_TRACKER.md (/respond-reviewers init, or /decide that no letter is needed for a simulated review)
  - similarity-metric: CLAIMS.md has 39 row(s), all pending (/claims init → check)
Donna: consistency check — 2 finding(s) above.
```

## 2. SUITS.md character lint (all scenes)
```
Donna: SUITS.md lint — clean (all scenes).
  speakers: Donna 9, Harvey 10, Jessica 7, Katrina 8, Louis 6, Mike 7, Rachel 4
```

## 3. Numbers audit — per_em_W1_wiley.tex
```
Mike: numbers audit of per_em_W1_wiley.tex — 107 numeric tokens, 105 sourced, 2 unsourced (2 distinct values). Ledger: projects/similarity-metric/results/NUMBERS_LEDGER.csv (27 rows)
```
Detail: `python3 scripts/numbers_audit.py projects/similarity-metric/paper/per_em_W1_wiley.tex` · ledger `projects/similarity-metric/results/NUMBERS_LEDGER.csv`

## 4. Citation audit — per_em_W1_wiley.tex vs per_em_W1_wiley.bib
```
- cited keys: **25** · bib entries: **44** · cited-but-missing: **0** · uncited: **19** · cited without DOI: **1** · malformed DOI: **0** · duplicate DOI: **0** · duplicate keys: **0**
```
Detail: `/cite-check` → `projects/similarity-metric/review_response/CITATION_AUDIT_20261011.md`

## 5. R reproducibility lint — projects/similarity-metric/R
```
Mike: R reproducibility lint (86 file(s))
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
| PROTOCOL_*.md | ✅ | 1 file(s) |
| SIMULATION_FINDINGS*.md | ❌ | 0 file(s) |
| results/NUMBERS_LEDGER.csv | ✅ | 27 row(s) |
| results/REPRODUCTION_*.md | ❌ | 0 report(s) |
| review_response/CITATION_AUDIT_*.md | ❌ | 0 audit(s) |
| CLAIMS.md rows | — | supported 0 · pending 39 |
