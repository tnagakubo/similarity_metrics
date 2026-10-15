---
name: recount-csv-claims
description: Counts and directions quoted in briefs/reviews about results CSVs get inverted; always re-derive from the CSV before attacking or defending
metadata:
  type: feedback
---

Re-derive every count/direction about a results CSV myself before using it — whether it comes from an external reviewer or from the team's own brief.

**Why:** 2026-10-14 practitioner-review meeting: the brief said the reviewer was wrong on age (L* lower > L_UB only R5, R7); the CSV (gusto_lstar_intervals.csv) showed the reviewer was right on age and wrong on SBP (7 above / 3 below / 5 straddle, not "almost all above"). Same pattern as the 2026-10-12 residual-review Critical findings (fix explanations not checked against CSV).

**How to apply:** In any /review or meeting, open the CSV and recount before writing the finding; state which side of the claim is wrong. Related recurring weaknesses of this team:
- Proposals that re-introduce deleted constructs under new names (tau_clin = Delta_clin/L_UB, L_UB-sensitivity "eligibility"; DECISIONS l.266, tex l.324). Check DECISIONS before accepting a "new" figure/reading rule.
- Provenance of illustrative inputs: NUMBERS_LEDGER rows 20/21/36 show L_UB = Delta_clin / tau (old threshold) and Delta_clin's locator is a code line, not a clinical source — while §2.4 says FTT/Lee "inform" L_UB.
- Guards pinned on one phrasing miss paraphrases (REF2-M2 stem "fewer patients than KS" does not catch the abstract's "needing fewer patients in N of 13 cells").
- Cut plans (2026-10-15 ESSENCE_CUT_PLAN) target guard-pinned qualifiers and protocol-promised sentences, and their "insurance" one-liners are written without checking the source (insurance C said the bulk-shift control leaves the subgroups out — tex l.318 says the whole population shifts; insurance D dropped the winsorizing 4/30 ranks and R8 being the most heaped region). For any cut review: grep every require/proximity guard pattern to a line, check each insurance sentence against tex/CSV, and ask for an omission clause + protocol Deviations entry (not retention) for registered results that leave the text. Watch for guards that pass vacuously after paraphrase (LR3-G6 abstract collapsible since D-20261014-2).
