# Referee report — *Quantifying Effect Modifier Similarity for Regional Pooling in Multi-Regional Clinical Trials*

Target: *Statistics in Medicine*. Reviewed against `paper/per_em_W1_wiley.tex` (792 lines) and the recorded analysis outputs in `results/` and `data/`.

## Revision 2 — after the cascade review

The first version of these corrections was itself reviewed and failed on two
counts, both now fixed. Recorded here because the report's M1, M4 and minor-8
entries below describe the finding, not the full extent of the repair.

**Patch without cascade.** M1 was corrected in the §2.2 derivation and one
Discussion clause; the identical overclaim survived at three further sites —
§2.2's opening ("its *unique* theoretical connection to treatment effect
heterogeneity"), §2.1's EDF sentence ("have *no theoretical connection* to
treatment effect heterogeneity", four lines above the corrected sentence, so
the paragraph contradicted itself), and the Discussion gap recap. M4's new
paragraph landed three paragraphs above an untouched "R4 emerges as the
leading single-pool candidate … balanced across both modifiers", repeated in
the Discussion — and R4 is on the age-unresolved list that same paragraph had
just introduced. All five sites are now corrected, and `verify_corrections.R`
carries the eight forbidden phrasings with residual hits = 0 as an acceptance
condition.

**Compression dropped the qualifiers.** The 356 → 248 abstract inverted two
quantifiers and deleted a third:

| Claim as compressed | Falsifying cell |
|---|---|
| SMD and RV distances at chance "**wherever** discordance lay in distributional shape or displaced rare subgroups" | Table 5, Set 4 symmetric severity: RV2 = 76, RV3 = 83; asymmetric severity: RV3 = 41, beating $W_1$ at 67 |
| "at smaller sample sizes … than the Kolmogorov–Smirnov statistic" | Set 4 bulk-shift control: KS 333 vs $W_1$ 377; clustering Set 2: KS 83 vs $W_1$ 156 |
| coverage "across seven scenarios" with "**for non-negligible distributional differences**" deleted | S1 coverage structurally 0; S2 = 0.703 at $n = 50$ |

The body has all three right; the compression is where they were lost. The
abstract is now 249 words with the existential quantifier restored ("in at
least one clinically plausible world"), the KS comparison restricted to the
mean-matched cells, and the original's non-negligible qualifier retained. The
gate checks the latter two mechanically.

## Overall assessment

The contribution is real and clearly delimited: a per-effect-modifier $W_1$ distance retained in original units, a dual-pathway clinical calibration, an operability criterion, and a two-study simulation programme with a GUSTO-I illustration. The writing is disciplined and the paper is unusually honest about its negative results — the GUSTO agreement with SMD, the KS statistic winning the bulk-shift control cell, RV3 beating $W_1$ in the asymmetric-severity cell, and the near-boundary coverage failure are all reported rather than buried.

**Arithmetic verification.** I recomputed the application end-to-end from `data/gusto.csv`. Everything checks:

| Quantity | Manuscript | Recomputed |
|---|---|---|
| $N$, regions | 40,830; 16 | 40,830; 16 |
| Region 8 $n$ | 2,916 | 2,916 |
| R8 age mean / SD / skew | 60.2 / 12.1 / −0.17 | 60.241 / 12.076 / −0.1731 |
| R8 SBP mean / SD / skew | 132.4 / 22.9 / 0.20 | 132.402 / 22.875 / 0.1981 |
| $\widehat W_1$, 15 partners × 2 modifiers | Table 3 | 30/30 match to 2 dp |
| Eligibility sets, joint six | R1,R4,R5,R6,R14,R15 | identical |
| $r$(age, SBP) over 120 pairs | 0.13 | 0.1331 |
| Joint-pool age / SBP diameter | 1.0595 / 4.7243 | 1.0595 / 4.7243 |
| 9-partner age / 11-partner SBP diameter | 1.1093 / 8.9362 | 1.1093 / 8.9362 |
| Breaching pair in joint pool | R1–R6 | R1–R6 |

The Section 4 numerical record is clean. The problems below are in the mathematical claims, in the Study 1 tables, and in one interpretive gap.

---

## Major

### M1. The exclusivity claim for the heterogeneity bound is false as stated

Section 2.2 asserts that the bound $|\bar\tau_1 - \bar\tau_2| \le L_{\text{clinical}} W_1$ "is specific to $W_1$," that $W_2$ "cannot provide an analogous bound," and that the measures of Section 2.1 "similarly lack any analogous property." Section 5 repeats this as a link "that neither empirical-distribution-function statistics such as the Kolmogorov–Smirnov statistic nor representative-value distances possess." Two of these are wrong.

Integration by parts gives, under regularity conditions making the boundary term vanish,
$$\bar\tau_1 - \bar\tau_2 = \int \tau \, d(F_1 - F_2) = -\int (F_1(x) - F_2(x)) \, d\tau(x),$$
so **any** Hölder pairing of $F_1 - F_2$ against the variation of $\tau$ produces a bound. The paper's bound is the $(L^\infty, L^1)$ pairing. The conjugate $(L^1, L^\infty)$ pairing gives
$$|\bar\tau_1 - \bar\tau_2| \le \mathrm{TV}(\tau) \cdot D_{\mathrm{KS}},$$
an exact analogue for the KS statistic with the total variation of $\tau$ as its constant. And since $W_1 \le W_2$ by Jensen, $L_{\text{clinical}} W_2$ is also a valid bound — merely looser.

A referee who knows optimal transport will catch this, and it is the kind of overclaim that costs credibility on an otherwise careful paper. **The fix strengthens the argument.** The defensible claim is not that $W_1$ uniquely admits a bound, but that it uniquely admits one whose *constant is clinically elicitable*: $L_{\text{clinical}}$ is a per-unit slope that treatment-by-covariate interaction analyses report and that the paper's own sensitivity analysis varies, whereas $\mathrm{TV}(\tau)$ is the total excursion of the CATE over the support — reported by no clinical source and unbounded for oscillating $\tau$. The $W_1$ bound is also tight within its class, since the KR supremum is attained. That is a sharper and defensible position, and it reframes the $W_1$-versus-KS comparison as being about calibratability rather than about detection alone — which is exactly what Section 4.6 already shows empirically.

*Applied* in Sections 2.1, 2.2 and 5.

### M2. $L_{\text{clinical}}$ is defined in the wrong units

Section 2.4 defines $L_{\text{clinical}}$ as "percentage points of 30-day mortality per year of age." Every numerical value in the paper is on the **proportion** scale:

- $L_{\text{UB,age}} = 1\times10^{-2}$/yr is glossed in Section 4.4 as "approximately 10%pt per decade" — i.e. 1 pp per year, so $10^{-2}$ is a proportion, not a percentage point. Read as pp/yr it would be 0.1 pp/decade, off by a factor of 100.
- $\tau_{\text{clin}} = \Delta_{\text{clin}}/L_{\text{UB}} = 0.01/0.01 = 1.0$ yr (Table 6) requires $\Delta_{\text{clin}} = 0.01$ as a proportion.
- Section 3.2's worked figure $0.01 \times 4.96 = 0.050$, labelled "(5.0%pt)", is likewise proportion-scale.

The defining sentence is the single inconsistent statement, and it is the one a reader trying to reproduce $\Delta_{\max}$ will use. *Fixed*, with an explicit scale convention added.

### M3. Study 1 tables disagree with the recorded simulation output

Audited against `results/w1_raw_summary.csv` (which I confirmed faithful to `results/w1_raw_simulation.rds$summary` and recomputed from `$rep_data`; max discrepancy $4\times10^{-15}$):

| Table | Disagreeing cells |
|---|---|
| Table 4 (bias) | **13 / 21** |
| Table 5 (coverage) | **8 / 18** |
| Table 6 (RMSE / CI width) | **2 / 42** |

Most are ±0.001, but two are not: S4 at $n=100$ is printed as $-0.009$ against a recorded $-0.013$, and S5 at $n=100$ as 0.389 against 0.393. The body text inherits several: "at $n = 200$ it was at most 0.189 (S5)" (recorded 0.187), "S4: $-0.009$ at $n = 100$", "0.004 at $n=200$" (recorded 0.005), the coverage ranges for S4 and S6, and the S5 coverage figures in both the text and the Table 5 note.

The pattern — only S1 exactly right, errors scattered in the third decimal — indicates hand transcription from an earlier run. *All 81 cells regenerated programmatically from the CSV; the corrected file now audits at 0 mismatches.* `verify_study1_tables.R` reproduces the audit and emits the LaTeX rows, so this failure mode does not recur.

### M4. The null floor acts permissively on the headline conclusion, and this is not stated

This is the most substantive interpretive gap. Section 4.2 establishes that six partners are unresolved on age. Section 4.4 then reports nine age-eligible partners and six jointly eligible. The overlap is not remarked on:

- The six age-eligible-and-unresolved partners are **R1, R4, R5, R7, R9, R15** — i.e. **six of the nine** age-eligible partners are exactly the six the operability check cannot resolve.
- **Four of the six** jointly eligible partners (R1, R4, R5, R15) are age-unresolved.
- Partners resolved on *both* modifiers **and** jointly eligible: **R6 and R14 only.**

The direction matters. An unresolved partner has a small observed distance, and a small distance *passes* the $L^* > L_{\text{UB}}$ screen — so unresolved partners are admitted, not excluded. On age the criterion is therefore doing little work for most of the partners it passes, and the six-partner pool is the largest set the data are compatible with rather than six partners each demonstrated similar on both modifiers. Section 4.2 gestures at this ("conclusions resting on age alone for the six unresolved partners would be conclusions the data do not support") but never connects it to the six-partner result that the abstract and Discussion headline.

*Fixed* with a new paragraph in Section 4.4 quantifying the overlap and naming R6/R14 as the conservative reading.

### M5. The R2/R9 contrast rests on the two unresolved estimates

The contrast is elevated to the Discussion and (previously) the abstract. Its structure is: R2 dissimilar on age / similar on SBP; R9 similar on age / dissimilar on SBP. But R2's SBP distance (0.95 mmHg) is the *single* SBP value Section 4.2 leaves unresolved, and R9 is among the six unresolved on age. Both "similar" halves of the contrast are unresolved; only the two "dissimilar" halves are resolved.

The point survives — a partner dissimilar on one modifier can be indistinguishable from the anchor on the other, which is precisely the argument for joint evaluation — but as written it reads as two sharp similarity estimates. *Fixed* with a cross-reference and restatement of what the contrast does and does not establish.

---

## Minor

1. **Equation (7) is wrong under ties.** The sum is indexed $k = 1,\dots,n_1+n_2-1$ over order statistics asserted to satisfy $x_{(1)} < \cdots < x_{(n_1+n_2)}$. Strict inequality fails whenever values repeat — and age in GUSTO-I is recorded in whole years, so ties are pervasive in the paper's own application. The appendix code is correct (it uses `sort(unique(.))`); the equation is the sloppy one. *Fixed*: sum over the $m$ distinct pooled values, with a note that the result is an exact evaluation of the integral, not a quadrature approximation.

2. **S6's parameters were never given.** Table 2 printed `LogN(μ, σ)`. From `R/simulation_manuscript_v2.R`: $\sigma_{\log} = 0.5$, $\mu_{\log} = \log 50 - \sigma_{\log}^2/2 = 3.787$, giving mean 50, CV 53.3%, skewness 1.75. *Filled in.*

3. **S6 and S7 "true $W_1$" are Monte Carlo, and the code knows it** — `truth_exact` is `NA` for both, with `truth_mc` used as the reference against which bias is computed. Both are available deterministically from the quantile form: **12.1598** (S6, printed 12.15) and **5.8332** (S7, printed 5.85). Using an MC approximation as the reference value contaminates a bias estimate with MC error in the reference; the S7 gap of 0.012 is 7% of that scenario's $n=200$ bias. The shift is small — bias moves by at most 0.013, coverage by at most 0.002 — so I did **not** silently change the estimand. *Disclosed in the Table 2 note with the exact values*; switching to them is your call and I can regenerate all three tables in one pass.

4. **Contradictory sign wording.** "R6 sits $+9.6\%$ below the age threshold" — positive slack and "below" cannot both hold. *Reworded* to "clears the age threshold by only 9.6%."

5. **Garbled sentence** at the end of Section 3.2: "the null floor that diagnostic estimates is the sampling distribution characterized here." *Fixed*, and strengthened — Study 1 reports S1's mean and CI width but never its upper tail, which is the quantity equation (9) actually uses. The 95th percentiles of $\widehat W_1$ under S1 are 4.21, 2.97 and 2.11 at $n = 50, 100, 200$; these are now stated, tying Study 1 to the operability criterion quantitatively.

6. **Section roadmap lists the Methods subsections in the wrong order** (calibration before estimation; Section 2.1 omitted). *Fixed.*

7. **Appendix A.1's identity-of-indiscernibles proof** invokes right-continuity as though it were needed for the almost-everywhere step, where it is only needed to upgrade a.e. equality to equality everywhere. *Rewritten* with the density argument made explicit.

8. **Abstract exceeded the journal limit** — 356 words against 250, and it described only Study 1 despite Section 3 stating that Study 2 carries the primary comparison. *Replaced with a 248-word version that covers both studies.* This was item #9 on your own queue, deferred to the Terminal pass; it is one `git checkout` away from reverting if you would rather keep it there.

## Not addressed (your queue, unchanged)

Reviewer items R3.1 (Study renumbering, 18 occurrences), R3.2 (notation table as Table 1, shifting downstream table numbers), R3.3 (workflow algorithm float), the nine author/address/repository placeholders, and the `¶D` Discussion limitation section. These are structural and better done as one pass.

## Note on the stale submission checklist

`paper/submission/SUBMISSION_CHECKLIST.md` is from the nABCD era (Feb 2026). It names files that no longer exist (`nABCD_wiley.tex`, `fig2_bias.pdf`, `fig4_gusto_r8_forest.pdf`), reports "Abstract 248 ✅" against a manuscript that had 356, and states "References: 10" where the manuscript now cites 26 distinct keys. It should not be used to drive submission.
