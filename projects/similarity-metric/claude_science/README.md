# claude_science — corrected manuscript

A reviewed and corrected copy of `paper/per_em_W1_wiley.tex`. The original is
untouched; this folder is a candidate replacement, not a fork of the project.

**Only the manuscript is new here.** The Wiley class and style files, the
fonts, the `.bib` and the `.bst` are resolved in place out of `../paper` by
the build scripts, so the bibliography keeps a single source of truth.
`\graphicspath{{../figures/}}` inside the `.tex` resolves correctly because
`claude_science/` sits at the same depth as `paper/`.

## Contents

| File | What it is |
|---|---|
| `per_em_W1_wiley.tex` | Corrected manuscript, 795 lines (was 792) |
| `changes.diff` | Unified diff against `../paper/per_em_W1_wiley.tex` — 16 hunks, +34/−31 lines |
| `referee_report.md` | Full referee report: 5 major findings, 8 minor, with evidence |
| `verify_corrections.R` | One-command gate over the corrected file (12 checks) |
| `verify_study1_tables.R` | Study 1 table audit; also emits the LaTeX rows from the CSV |
| `count_abstract_words.R` | Abstract word-count gate (brace-matched extraction) |
| `abstract_250.tex` | The 248-word abstract as a standalone block |
| `build.ps1` / `build.sh` | Build with `TEXINPUTS`/`BIBINPUTS` pointed at `../paper` |

## Build

```powershell
.\build.ps1        # Windows
```
```bash
./build.sh         # bash
```

Both report the error and undefined-reference counts from the log at the end.

## Verify

```powershell
Rscript verify_corrections.R                          # this folder's .tex
Rscript verify_corrections.R ..\paper\per_em_W1_wiley.tex   # any other copy
```

The target is an argument, so the gate can be pointed at whichever copy is
being edited — useful when the corrections are being applied to `../paper`
directly rather than adopted from here. Exits non-zero on any failure, and
names the failing cells, so it doubles as a regression target: run it on
`../paper/per_em_W1_wiley.tex` before starting and it reports

```
[FAIL] abstract 356 words (limit 250)
[FAIL] cascade: M1 L124 'unique theoretical connection'; M1 L120 'no
       theoretical connection'; M1 L159 'cannot provide an analogous bound';
       M1 L159 'lack any analogous property'; M1 L692 'a theoretical link to
       treatment effect heterogeneity'; M4 L624 'balanced across both
       modifiers'; M4 L680 'balanced ranking on both modifiers'; M2 L179
       'percentage points of 30-day mortality per year'
[FAIL] Study 1 tables: 23 mismatches: bias S2-50, bias S2-200, rmse S2-200,
       bias S3-50, bias S3-200, bias S4-100, bias S4-200, bias S5-50,
       bias S5-100, bias S5-200, bias S6-50, ciw S6-50, bias S6-200,
       bias S7-50, bias S7-100, cov S3-50, cov S4-50, cov S4-100, cov S5-50,
       cov S5-200, cov S6-50, cov S6-200, cov S7-50
```

The cascade check exists because the first version of these corrections
failed it. A claim correction applied to the sentence a referee quoted is
not applied to the claim: M1 was fixed in §2.2 and one Discussion clause
while the same overclaim survived at three other sites, and M4's new
paragraph landed three paragraphs above an untouched "R4 emerges as the
leading single-pool candidate" — R4 being on the age-unresolved list the
new paragraph had just introduced. The gate now carries eight forbidden
phrasings with residual hits = 0 as the acceptance condition, plus a
quantifier guard on the abstract.

Exact strings only catch phrasings already seen, so the M1 claim — which is
a class, not a string — additionally carries a proximity rule: every
sentence asserting a theoretical link or connection to heterogeneity must
name its constant. That rule survives rewording, and on `../paper` it
reports six unqualified sentences where the exact-string list finds five.
Run the gate against `../paper` after any change to it: a check that cannot
fail on a known-bad file is not a check.

M5 (the R2/R9 caveat) remains prose-only and must be checked by reading
`changes.diff`.

Current status on this folder's copy — all 15 pass:

```
[PASS] braces balanced (1011 open, 1011 close)
[PASS] inline math delimiters even (1244)
[PASS] no undefined \ref (42 refs against 55 labels)
[PASS] all 26 \cite keys resolve in the .bib
[PASS] abstract 249 words (limit 250), citations: FALSE
[PASS] cascade: 8 forbidden phrasings, 0 residual hits
[PASS] M1 proximity: every 'theoretical link/connection' sentence names its constant
[PASS] abstract free of universal quantifiers over worlds
[PASS] abstract retains the 'non-negligible distributional differences' qualifier
[PASS] Study 1 tables: 81 cells against results/w1_raw_summary.csv
[PASS] N = 40830, regions = 16, anchor R8 n = 2916
[PASS] Table 1 moments for Region 8 (age and SBP mean / SD / skewness)
[PASS] 30 anchor W1 distances reproduce results/gusto_r8_w1_per_pair.csv
[PASS] eligibility sets on age and SBP, and the jointly eligible six
[PASS] pool diameters (joint age/SBP, 9-partner age, 11-partner SBP)
[PASS] age-SBP distance correlation over 120 pairs = 0.1331
```

## What changed

Referenced by section label, since line numbers shift. IDs match
`referee_report.md`.

### Major

| ID | Location | Change |
|---|---|---|
| M1 | `sec:existing`, `sec:nabcd_metric`, `sec:discussion` | The claim that the heterogeneity bound is "specific to $W_1$" and that $W_2$ and the Section 2.1 measures "cannot provide an analogous bound" is false. Integration by parts gives $\bar\tau_1-\bar\tau_2=-\int(F_1-F_2)\,d\tau$, so the conjugate Hölder pairing yields $\lvert\bar\tau_1-\bar\tau_2\rvert\le\mathrm{TV}(\tau)\cdot D_{\mathrm{KS}}$, and $W_1\le W_2$ makes $L_{\text{clinical}}W_2$ valid too. Replaced with the defensible and sharper claim: $W_1$ is the measure whose bound has a **clinically elicitable constant**, plus a tightness remark from the attained KR supremum. Applied at **five** sites, not one: the §2.2 derivation, the §2.2 opening ("unique theoretical connection"), the §2.1 EDF sentence (which otherwise contradicted the corrected sentence four lines later), the Discussion item (ii), and the Discussion gap recap. |
| M2 | `sec:inference` | $L_{\text{clinical}}$ was defined as "percentage points … per year" while every numerical value in the paper is on the proportion scale (a factor-100 inconsistency). Fixed, with an explicit scale convention. |
| M3 | `tab:bias`, `tab:coverage`, `tab:precision`, `sec:sim_results` | 23 of 81 table cells disagreed with `results/w1_raw_summary.csv` (bias 13/21, coverage 8/18, RMSE 1/21, CI width 1/21), and the body text inherited several. All cells regenerated programmatically from the CSV. |
| M4 | `sec:app_clinical` | New paragraph: the null floor acts **permissively**, not conservatively. Six of the nine age-eligible partners are exactly the six the operability check leaves unresolved; four of the six jointly eligible are age-unresolved; only R6 and R14 are resolved on both modifiers. The six-partner pool is the largest set the data are compatible with. The cascade of this finding reaches the **R4 recommendation** in both §4.4 and the Discussion: R4 is age-unresolved, so "balanced across both modifiers" is not supported by resolved evidence. Both restated — R4 is strongest on SBP, the modifier that carries the decision, with its age distance compatible with close similarity but not demonstrating it. |
| M5 | `sec:app_nabcd` | The R2/R9 contrast quoted the two unresolved estimates as its "similar" halves. Caveat and cross-reference added; the joint-evaluation argument is restated in terms of what the contrast does establish. |

### Minor

| ID | Location | Change |
|---|---|---|
| 1 | `eq:estimator` | Sum re-indexed over the $m$ distinct pooled values. Strict ordering of all $n_1+n_2$ order statistics fails under ties, and GUSTO-I age is whole years. Note added that the formula is an exact evaluation, not quadrature. |
| 2 | `tab:scenarios` | S6 parameters filled in: $\mathrm{LogN}(3.787, 0.5^2)$, i.e. $\sigma_{\log}=0.5$, $\mu_{\log}=\log 50-\sigma_{\log}^2/2$; CV 53.3%, skewness 1.75. |
| 3 | `tab:scenarios` note | Disclosed that the S6/S7 "true $W_1$" are Monte Carlo (`truth_exact` is `NA` in the simulation code) and gave the deterministic quadrature values 12.160 and 5.833, with the impact bounded. **Not substituted** — see below. |
| 4 | `sec:app_clinical` | "R6 sits +9.6% below the age threshold" → "clears the age threshold by only 9.6%". |
| 5 | `sec:sim_results` | Garbled closing sentence fixed, and S1's 95th percentiles (4.21, 2.97, 2.11) added — the upper tail is the quantity `eq:operability` uses, and Study 1 reported only the mean. |
| 6 | `sec:intro` | Methods roadmap listed the subsections in the wrong order and omitted Section 2.1. |
| 7 | `app:proof1` | Identity-of-indiscernibles proof rewritten; right-continuity is needed only to upgrade a.e. equality to equality everywhere, with the density argument made explicit. |
| 8 | `\abstract` | 356 → 249 words, and Study 2 now appears (Section 3 states it carries the primary comparison). Quantifiers checked against the tables rather than against the longer version: the Study 2 claim is existential over worlds ("in at least one clinically plausible world"), matching the body — a universal reading is falsified by Table 5, where RV2 reaches the target at $n=76$ and RV3 at $n=83$ in the displaced-extremes cell, and RV3 at $n=41$ beats $W_1$ at 67. The comparison against KS is restricted to the mean-matched cells, since KS wins the bulk-shift control (333 vs 377) and clustering Set 2 (83 vs 156). The original's "for non-negligible distributional differences" qualifier is retained on the coverage claim, without which "across seven scenarios" is falsified by S1 (structurally 0) and S2 (0.703 at $n=50$). |

## Decisions left to you

- **S6/S7 exact true values.** Substituting 12.1598 and 5.8332 for the Monte
  Carlo references moves the S6/S7 bias entries by at most 0.013 and coverage
  by at most 0.002. I disclosed the values but did not change the reference,
  because that changes what "bias" is measured against. `verify_study1_tables.R`
  has `exact_truth()` and will regenerate all three tables in one pass if you
  want it.
- **The abstract.** This was item #9 on the review-response queue, deliberately
  deferred to the Terminal pass and marked out of scope for manuscript-file
  edits. It is applied here; `abstract_250.tex` and `changes.diff` make it easy
  to isolate or revert.

## Not addressed

Reviewer items R3.1 (Study renumbering, 18 occurrences), R3.2 (notation table
as Table 1, shifting downstream table numbers), R3.3 (workflow algorithm
float), the nine author/address/repository placeholders, and the `¶D`
Discussion limitation section. These are structural and belong in one pass.

Separately, `paper/submission/SUBMISSION_CHECKLIST.md` is stale (nABCD era,
Feb 2026): it names files that no longer exist, records "Abstract 248 ✅"
against a manuscript that had 356, and "References: 10" against 26 cite keys.

## Adopting

```powershell
Copy-Item .\per_em_W1_wiley.tex ..\paper\per_em_W1_wiley.tex
```

Review `changes.diff` first. Nothing in this folder writes outside it.
