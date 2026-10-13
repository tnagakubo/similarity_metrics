> **EXPLORATORY — not pre-registered, not citable from the manuscript.** Promote via /protocol.

# ist1_case_study — Can IST-1 carry the paper's application instead of GUSTO-I?

- **Date**: 2026-10-12  **Owner**: Mike (code), Harvey (scenario), Louis (attack), Donna (record)
- **Tak's instruction (verbatim, 2026-10-12 15:47)**:
  > IST-1での事例検討を試してみる。
  > - 論文で掲げている状況と同じように考えられる仮想的シナリオを作る
  > - 仮想的シナリオに沿って併合地域を選択する
  > IST-1での事例検討が完了したら、GUSTOとの事例検討としての質を比較・検討する。どちらを論文の事例として載せるのにふさわしいか検討する。
- **Question**: Using the manuscript's §4 procedure unchanged, does IST-1 (real country names, 36 countries, no sample-size floor — Tak 11:09) give an application of higher quality than GUSTO-I (16 anonymised regions)? "Quality" is judged on: real regions, era, number of partners, how many distances resolve against the null floor, rank-interval width, whether partner orderings differ across effect modifiers, and whether a sourced clinical slope exists.
- **What changes if answered**: Yes → `/decide` to replace §4 (GUSTO-I → IST-1), then `/protocol ist1_application` before any number enters the manuscript. No → GUSTO-I stays; IST-1 remains the reviewer-response reserve (`review_response/CASE_STUDY_CANDIDATES_20261012.md`).

## Hypothetical scenario (parallel to manuscript §4.1)
A sponsor is developing a novel antithrombotic agent (Drug S) for acute ischaemic stroke and plans a Phase 3 MRCT. At the planning stage it uses IPD from IST-1 (International Stroke Trial, 1991–1996, N = 19,435, aspirin × heparin factorial, 36 countries; Edinburgh DataShare, ODC-By) as stand-ins for the national populations the new trial would enrol. Candidate effect modifiers suggested by the Phase 2 programme: age (years), systolic blood pressure at randomisation (mmHg), and delay from stroke onset to randomisation (hours; IST-1 window ≤ 48 h). No quantitative prior on the clinical slope L is available, so the L* reverse-calculation pathway is used for all three (Δ_clin = 1 %pt on the absolute 6-month death-or-dependency scale). Illustrative bounds L_UB are **not** set here (🔍 would need sources; GUSTO's came from FTT / Lee 1995).

**Anchor**: a regulatory market where locally relevant efficacy evidence is expected. Primary: **USA** (n = 131 in IST-1 — a single-country cohort of the size an MRCT actually produces). Sensitivity: **Japan** (n = 9, the small-anchor limit) and **UK** (n = 6,257, the large-anchor comparison). Partners: all 35 other countries, no sample-size floor. The anchor choice is Mike's; change `ANCHORS` in the script to try another.

## Procedure (identical to §4 / `R/gusto_*.R`; functions copied verbatim)
Per anchor × EM × partner: Ŵ₁ (exact CDF-area form), percentile bootstrap 95 % CI, anchor-drawn null floor (two resamples of the two actual sizes from the anchor's EDF; one-sided 5 %), resolved flag, rank by Ŵ₁ with 95 % rank interval from patient-level bootstrap within every country, L* = Δ_clin / Ŵ₁ with interval, |SMD|, Spearman(Ŵ₁, |SMD|), Spearman between EM orderings with bootstrap interval. B: primary anchor CI 2,000 / null 2,000 / rank 1,000; sensitivity anchors 500 / 500 / —.

## Outputs
`results/ist1_<anchor>_w1_per_pair.csv`, `results/ist1_USA_rank_intervals.csv`, `results/ist1_USA_rank_spearman_boot.csv`, `results/ist1_USA_w1_vs_smd.csv`, `results/ist1_country_n.csv`, `results/ist1_summary.md` (tables written by the script — no number typed), `results/gusto_vs_ist1_descriptors.csv` (same descriptors computed from the canonical GUSTO CSVs, read-only), `figures/ist1_USA_forest.png`, `results/sessionInfo.txt`.

## Promotion condition
Only via `/protocol ist1_application` with §0 prior-look disclosure ("exploratory run of 2026-10-12 seen"). Nothing here enters `paper/`, `numbers_registry.csv` or `NUMBERS_LEDGER.csv`.
