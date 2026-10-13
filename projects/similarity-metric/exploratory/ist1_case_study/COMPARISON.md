> **EXPLORATORY — not pre-registered, not citable from the manuscript.** Numbers below are read from `results/ist1_summary.md` (script-written) and the canonical GUSTO CSVs; none is typed from memory.

# GUSTO-I vs IST-1 as the paper's application — lab assessment (2026-10-12 16:50)

Tak's instruction: 「IST-1での事例検討が完了したら、GUSTOとの事例検討としての質を比較・検討する。どちらを論文の事例として載せるのにふさわしいか検討する。」

## 1. What the IST-1 run showed (anchor USA, n = 131; 35 partners, n from 2 to 6,257)

| descriptor | GUSTO-I (anchor R8, 15 partners, n 1,231–4,352) | IST-1 (anchor USA, 35 partners, n 2–6,257) |
|---|---|---|
| regions | 16, anonymised | 36, real country names |
| era | 1990–93 | 1991–96 |
| candidate EMs | age, SBP | age, SBP, onset-to-randomisation delay |
| resolved against null floor | age 9 / 15, SBP 14 / 15 | age 23 / 35, SBP 12 / 35, delay 25 / 35 |
| resolved on every EM / on none | — | 10 / 4 (the 4: Finland 85, Sri Lanka 20, Romania 18, Japan 9) |
| mean rank-interval width (positions) | age 6.7 of 15, SBP 5.0 of 15 | age 12.5 of 35, SBP 17.7 of 35, delay 13.5 of 35 |
| rank intervals ≤ 5 positions wide | age 4 / 15, SBP 8 / 15 | age 5 / 35, SBP 1 / 35, delay 5 / 35 |
| Spearman between EM orderings | age–SBP −0.30 [−0.51, 0.02] | age–SBP 0.04 [−0.09, 0.26]; age–delay 0.06 [−0.09, 0.22]; SBP–delay 0.15 [−0.09, 0.38] |
| Spearman W₁ vs \|SMD\| | age 0.90, SBP 0.95 (registry `spearmanW1SMDage` / `spearmanW1SMDsbp`, from `results/app_all_methods_ranks.csv`) | age 0.98, SBP 0.81, delay 0.91 |
| sourced bound L_UB for the calibration step | yes (FTT 1994, GUSTO 1993, Lee 1995) | none found (🔍) |
| boundary artefact (CI lower limit above the point estimate) | not visible in Table 5 | age 2 / 35 (Singapore, Sri Lanka) |
| partner with n = 2 | — | France: most distant on age (17.7 y [15.0, 20.9], resolved) — a 2-patient region "resolved" as distant |

Anchor sensitivity: Japan (n = 9) resolves almost nothing (age 2, SBP 0, delay 15 of 35; 18 partners unresolved on every EM); UK (n = 6,257) resolves age 29, SBP 15, delay 23.

Resolution tracks partner size: partners resolved on all three EMs have median n = 636; on none, median n = 19.

## 2. Where IST-1 is the better case
1. **Real regions.** The anchor is a named regulatory market (USA), partners are countries; the §4.1 sentence "regions are anonymized" disappears, and Asia (Hong Kong, Singapore, India, Japan) is in the table. The illustration reads like an ICH E17 planning exercise rather than a numbered-region exercise.
2. **Realistic sample sizes.** n = 131 anchor and partners from 9 to 6,257 are what an MRCT planner actually holds (Tak 11:09). The null-floor machinery of §4.2 then does visible work: the four partners unresolved on every EM are the four smallest, and the Japan-anchor run shows the small-anchor limit.
3. **Per-EM orderings genuinely disagree.** All three Spearman intervals cover zero; the Discussion's "a single aggregated distance could mask differences" point is stronger than GUSTO's −0.30.
4. **Three EMs, one with a mechanism.** Onset-to-treatment delay is the effect modifier the stroke literature documents for reperfusion (Emberson 2014 for alteplase; IST-1 itself is aspirin/heparin, so the slope would still be illustrative).

## 3. Where GUSTO-I is the better case
1. **The calibration step is complete.** §4.4 compares L* with sourced bounds (FTT / Lee 1995). IST-1 has no L_UB on disk; without it the case stops at L* and the A3 aim ("Δ_max = L·W₁ による読み方") is only half illustrated. Rachel could search for stroke analogues (age gradient of death/dependency in IST-1 or in OCSP-type cohorts), but that is new literature work and the bound would still be illustrative.
2. **Orderings resolve.** With 35 partners of very unequal size, rank intervals average 12–18 of 35 positions; only 1–5 partners per EM have a rank interval of ≤ 5 positions. GUSTO's 15 partners of 1,231–4,352 give 4–8 of 15. The ranking table (Table 5's main point) becomes mostly "unresolved" in IST-1.
3. **No degenerate regions.** France (n = 2) is the most distant partner on age and SBP; a 2-patient "region" being ranked, and resolved on age, is the first thing a referee will circle. Dropping France reintroduces a floor by the back door; keeping it needs a sentence the paper does not currently have. Two percentile intervals exclude their own point estimate (Singapore, Sri Lanka), the boundary bias the paper already discloses but which Table 5 never displays.
4. **Era is not improved** (1991–96 vs 1990–93), and the trial drugs (aspirin, heparin) are further from a plausible "Drug S" than GUSTO's thrombolytics are from "Drug T".
5. **Cost.** 35 of 153 registry keys, 8 R scripts, 4 tables, Fig 3, Discussion ¶2–¶4, the rank-interval and L* machinery, and the cold referee's pass on §4 would all be redone; the §4 numbers would need `/protocol ist1_application` first (prior-look disclosure: this run).

## 4. Harvey's assessment
IST-1 wins on realism (real countries, realistic n, Asian regions, a cleaner "orderings disagree" finding) and loses on what §4 exists to show under Aim A3: a calibration read against a sourced bound, and a ranking that resolves. Both of its losses are structural to the dataset (no L_UB literature; 35 unequal regions), not fixable by a different anchor — the UK anchor resolves more distances but is the least plausible "market requiring local evidence". The France n = 2 row is a referee magnet either way.

**Recommendation: keep GUSTO-I as the manuscript's application.** Carry IST-1 as the reviewer-response reserve with one specific use: if a referee attacks the anonymised regions or the large-region sample sizes, this run answers in one paragraph (real countries, n = 131 anchor, same conclusions: W₁ ≈ |SMD| ordering, per-EM orderings disagree, small distances read at the upper limit). Do not add it as a second case now (two-dataset problem, no-supplement rule).

**If Tak prefers IST-1**: the path is `/decide` (supersedes D-2026-04-10's "GUSTO over IST"), Rachel grounds an L_UB for stroke (age, SBP, delay) or the paper states explicitly that the calibration stops at L*, a sentence on the n = 2 and n = 9 regions, then `/protocol ist1_application` with this run disclosed as a prior look, then the §4 rebuild.

## 5. Louis — what a referee would attack in the IST-1 version
- "You ranked a region of two patients." (France.)
- "Your anchor has 131 patients and your Study 2 says n ≥ 100 is the estimation criterion — the SBP distances have a median CI width of 7.2 mmHg against a median null floor of 6.7 mmHg; most of Table 5 would be unresolved."
- "Where is L_UB? Section 2.4 says the comparison with L_UB is the calibration; you only report L*."
- "Why USA as the anchor for an ICH E17 illustration? The small-region markets in E17 discussions are Japan and China; Japan has nine patients here and nothing resolves."
