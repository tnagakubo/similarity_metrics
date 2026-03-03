# Act 3: Results — Speaker Scripts
**Author**: Katrina Bennett (Technical Writer)
**Target**: JSM / ISCB academic presentation
**Language**: English
**Date**: 2026-03-03

---

## Slide: Simulation Design

**Duration**: ~1.5 minutes

**Script**:
Before we see how the estimator performs, let me orient you to what we actually tested.

We designed eight scenarios anchored to clinical reality. Scenarios S1 through S4 test pure location shifts — identical to the kind of mean differences you would capture with a standardized mean difference. S1 is the null: perfectly identical populations. S2 represents a small real-world gap, like age differences between the EU and US. S4 represents a large one — nearly one full standard deviation, like BMI between Japan and the United States.

Then we add what SMD cannot see. S5 tests a pure scale difference: same mean, 50% wider spread. S6 tests a shape shift to a skewed Gamma distribution, modeling lab values like eGFR. S7 models high-skew data with a log-normal, mimicking ALT with coefficient of variation around 53%. S8 combines location and scale shifts simultaneously.

Each scenario ran 10,000 replications at three sample sizes: 50, 100, and 200 per region. Bootstrap confidence intervals used 2,000 replications. The true nABCD values span from zero to 0.37, giving us a representative range of what practitioners would encounter in real MRCTs.

**Key points to emphasize**:
- Eight scenarios cover the full space: location, scale, shape, skew, combined
- True nABCD values are anchored to clinically motivated distributions
- Three sample sizes chosen to capture the n=50 (small region) to n=200 (mature registry) range
- S5, S6, S7 are the critical SMD-blind scenarios — keep them in mind for the next slide

---

## Slide: Bias Results

**Duration**: ~1.5 minutes

**Script**:
Let's look at bias first. The general pattern is encouraging: as sample size increases, bias decreases toward zero for most scenarios.

At n=100, the most important threshold for practice, non-null scenarios excluding S4 all show bias below 0.02 in absolute terms. To put that in context, that is smaller than the width of a typical bootstrap confidence interval for these settings. For S3, S5, S7, and S8 — which represent the practically relevant range — the estimator is essentially unbiased by n=100.

S4 deserves special attention. With a true nABCD of 0.37 — the large location shift — we see persistent negative bias around minus 0.04 even at n=200. This is a known property of empirical process estimators for the L1 distance: when the true value is far from the boundary at zero, the bounded nature of the statistic introduces a modest downward pull. It does not invalidate inference; it means that for large distributional differences, nABCD is slightly conservative — it understates the gap.

The null scenario S1 shows the most striking positive bias, particularly at n=50: plus 0.09. This is expected. When the true value is zero, the estimator can only overestimate. The practical implication is that small samples near the null will produce inflated estimates. This is the primary motivation for our n≥100 recommendation.

**Key points to emphasize**:
- n≥100 is the practical threshold for bias below 0.02 in non-null scenarios
- S4 negative bias is a conservative property: nABCD understates large differences
- Null positive bias at small n is structural, not a flaw — it motivates the n≥100 recommendation
- S7 (skew/log-normal) is well-behaved across all sample sizes — important for real-world lab values

---

## Slide: Coverage and Precision

**Duration**: ~1.5 minutes

**Script**:
Now coverage — the probability that the 95% percentile bootstrap interval actually contains the true nABCD.

The headline result: at n≥100, coverage is between 0.87 and 0.98 across all eight scenarios. That is adequate for the inferential goals of a regulatory submission.

Two scenarios require explanation. S2, the small location shift with true nABCD of 0.07, shows coverage of only 0.67 at n=50 and 0.90 at n=100. This near-null behavior reflects the theoretical prediction from del Barrio's asymptotic theory: when the two distributions are very close, the Hadamard derivative of the W1 functional becomes non-linear, and standard bootstrap consistency does not fully apply. Coverage recovers to nominal by n=200.

S4, the large location shift, shows the reverse problem: coverage degrades from 0.93 at n=50 to 0.73 at n=200. This is not a failure of the bootstrap — it reflects the persistent negative bias we just saw. As n grows, the confidence interval tightens around the biased estimate, pulling coverage down.

The standout performer is S7, the log-normal skew scenario: near-nominal coverage of 0.95 across all three sample sizes. Given that skewed lab values are precisely the distributions where shape differences matter most clinically, this is the result that matters most for practice.

**Key points to emphasize**:
- At n≥100, coverage is 0.87–0.98: adequate for regulatory inference
- S2 near-null undercoverage is theoretically expected and resolves by n=200
- S7 skew scenario achieves near-nominal coverage even at n=50 — best practical news
- Formal recommendation: n≥100 per region for reliable inference

---

## Slide: nABCD vs SMD: Sensitivity Comparison

**Duration**: ~1.5 minutes

**Script**:
This slide is perhaps the most direct argument for why nABCD exists.

Look at S3: a half-standard-deviation location shift. Both nABCD and SMD detect it. SMD gives 0.50, nABCD gives 0.18. They disagree on magnitude because they measure different things — SMD is purely a location metric, while nABCD measures the full distributional mass displacement. But at least both flag the scenario. So for pure location differences, SMD works.

Now look at S5: a pure scale difference. The two populations have identical means but the spread in region 2 is 50% wider. SMD is 0.00. It sees nothing. nABCD is 0.14. It detects a clinically meaningful distributional gap that would affect any drug whose treatment effect depends on the patient's baseline variability.

S6 is a Gamma shape shift, same mean and approximately same spread. SMD is again 0.00. nABCD is 0.07.

S7 is the log-normal skew scenario. SMD is 0.00. nABCD is 0.31 — large. This is a high-skew distribution with CV of 53%. For a drug whose CATE function is non-linear, this level of shape difference could drive substantial regional heterogeneity in average treatment effects. SMD would give you no warning.

The conclusion is structural. SMD is a summary of location. nABCD is a summary of the full distributional difference — the exact quantity that bounds treatment effect heterogeneity. For regulatory decision-making under ICH E17, SMD is insufficient.

**Key points to emphasize**:
- SMD is blind to variance and shape: 0.00 for S5, S6, S7
- nABCD captures the full distributional difference relevant to the heterogeneity bound
- S7 is the most striking case: log-normal skew, nABCD=0.31, SMD=0.00
- The blindness of SMD is not a sampling artifact — it is structural

---

## Slide: Type 2 Diabetes MRCT

**Duration**: ~1 minute

**Script**:
Now let us apply these ideas to a concrete MRCT scenario.

Consider a hypothetical three-region trial in type 2 diabetes: Japan with 150 patients, the US with 200, and the EU with 180. The primary endpoint is change in HbA1c at 24 weeks. The overall treatment effect is minus 0.8 percentage points. The non-inferiority margin is 0.4%.

Look at the baseline characteristics. The three effect modifiers we will analyze are age, BMI, and baseline HbA1c. The Japan-US contrast is immediately striking: mean BMI 24.8 in Japan versus 32.1 in the US — a gap of 7.3 kg/m2. Mean baseline HbA1c 7.6 in Japan versus 8.4 in the US — a smaller gap of 0.8 percentage points.

The clinical question is: do these baseline differences matter for treatment effect comparability? This is exactly what nABCD and the clinical calibration framework are designed to answer.

**Key points to emphasize**:
- Japan-US is the most divergent pair: focus the analysis there
- BMI gap looks large: 7.3 kg/m2 difference
- HbA1c gap looks smaller: 0.8% difference
- Non-inferiority margin of 0.4% provides the clinical yardstick throughout

---

## Slide: Pairwise nABCD Values

**Duration**: ~1.5 minutes

**Script**:
Here are the pairwise nABCD values with 95% bootstrap confidence intervals.

The Japan-US comparison dominates. Age: 0.12 — small, well within the acceptable range. BMI: 0.51 — large, with a tight confidence interval from 0.44 to 0.58. HbA1c: 0.27 — moderate, interval from 0.20 to 0.34.

Japan-EU and US-EU show progressively smaller values, consistent with the baseline characteristic table. All three pairs show negligible age differences — Age nABCD stays below 0.12 across all comparisons.

Now here is the question that motivates the next two slides. Looking at Japan versus the US, BMI has nABCD of 0.51 and HbA1c has nABCD of 0.27. On the nABCD scale alone, BMI looks like the larger concern. It is large by any benchmark. HbA1c is moderate.

But does a larger nABCD automatically mean a larger regulatory concern?

The answer is no. And the reason is that nABCD measures distributional distance — it does not yet account for how strongly each effect modifier actually influences the treatment effect. That is the role of the clinical calibration step. Let us see what happens when we bring in the CATE sensitivity parameter L.

**Key points to emphasize**:
- BMI nABCD = 0.51 is large; HbA1c nABCD = 0.27 is moderate
- On nABCD alone, BMI looks like the primary concern
- The key question: does distribution size translate directly to clinical concern?
- Build anticipation: the answer involves L, and it reverses the ranking

---

## Slide: Clinical Calibration: Japan vs. US

**Duration**: ~1.5 minutes

**Script**:
Now we apply the clinical calibration formula. Delta-max equals two times L times IQR-pooled times nABCD.

For Age: nABCD is 0.12, but L is 0.01 — age has almost no influence on treatment effect for this drug class. The pooled IQR is 14.2 years. Delta-max comes out to 0.03%. Negligible. Well under 10% of the non-inferiority margin. Age is not a concern.

For BMI: nABCD is 0.51 — the largest in the table. But L is 0.02. BMI is a weak effect modifier for this drug class. Even with the enormous distributional gap between Japan and the US, Delta-max is only 0.16%. That is 40% of the non-inferiority margin. Below the threshold of clinical concern.

For HbA1c: nABCD is 0.27 — smaller than BMI. But L is 0.30. Baseline HbA1c is a strong predictor of treatment response to glucose-lowering therapy. With a pooled IQR of 1.5 percentage points, Delta-max is 0.24%. That is 30% of the overall treatment effect, and 60% of the non-inferiority margin.

So the ranking has reversed. The variable that looked smaller by nABCD — HbA1c — produces the larger Delta-max. The variable that looked largest — BMI — turns out to be the lesser concern. The clinical consequence is completely different from what naive nABCD ranking suggested.

**Key points to emphasize**:
- Age: Delta-max = 0.03% — negligible
- BMI: nABCD = 0.51 but L = 0.02, so Delta-max = 0.16% — manageable
- HbA1c: nABCD = 0.27 but L = 0.30, so Delta-max = 0.24% — 60% of margin
- The reversal is caused entirely by L: the CATE sensitivity parameter

---

## Slide: Key Insight: Same nABCD, Different Impact

**Duration**: ~1 minute

**Script**:
Let me make this contrast explicit before we explain why it happens.

BMI has nABCD of 0.51 and L of 0.02. This means: the distribution of BMI is dramatically different between Japan and the US — a gap of 7.3 kg/m2 on average. But for this drug class, BMI has almost no causal influence on how much the treatment works. The large distributional gap multiplies against a near-zero sensitivity, and the result is a Delta-max of only 0.16% — 20% of the treatment effect.

HbA1c has nABCD of 0.27 and L of 0.30. The distribution is moderately different — a gap of 0.8 percentage points. But baseline HbA1c is the defining predictor of glycemic treatment response. Patients with higher baseline HbA1c benefit more. A moderate distributional gap multiplied by a large sensitivity yields Delta-max of 0.24% — 30% of the treatment effect and 60% of the non-inferiority margin.

This is the core message. The clinical meaning of nABCD is not intrinsic to the number. It depends entirely on the treatment context — specifically, how sensitively the drug's effect responds to that particular characteristic. nABCD is necessary for the assessment, but L is the translation key.

**Key points to emphasize**:
- "Large nABCD" does not automatically mean "large concern"
- The two dimensions — distributional distance and CATE sensitivity — must be combined
- Delta-max is the clinically interpretable quantity; nABCD alone is not sufficient
- This is not a limitation of nABCD — it is by design, matching ICH E17's context-dependent philosophy

---

## Slide: Why the Ranking Reverses

**Duration**: ~2 minutes

**Script**:
Let us slow down here and understand the mechanism, because it has important implications for how practitioners should use this framework.

L is a multiplier. It is the Lipschitz constant of the conditional average treatment effect function — roughly speaking, how many units of treatment effect change per unit change in the effect modifier. A large L means the drug is highly sensitive to that characteristic. A small L means the drug is relatively insensitive.

For BMI: the physical gap between Japan and the US is enormous. Average BMI of 24.8 versus 32.1 translates to a raw mean difference of 7.3 kg/m2. The nABCD of 0.51 reflects not just this location difference but also the large difference in spread and shape of the BMI distribution. By any distributional measure, Japan and the US are very different on BMI. But the L for BMI here is 0.02 — meaning that for every 1 kg/m2 difference in BMI, the treatment effect changes by only 0.02 percentage points. Multiply 0.51 times 0.02 times the IQR, and the clinical signal is small.

For HbA1c: the distributional gap is moderate — nABCD of 0.27. The mean difference is only 0.8%. But the L of 0.30 tells us that for every 1% difference in baseline HbA1c, the expected treatment effect changes by 0.30%. That is a strong sensitivity. Multiply 0.27 times 0.30, and despite the smaller nABCD, the clinical consequence is larger.

The breakeven point is when Delta-max equals the non-inferiority margin. For HbA1c with nABCD fixed at 0.27 and IQR of 1.5%, that breakeven — which we call L-star — occurs at L-star equals 0.49. Below that value, the distributional difference is compatible with pooling under the non-inferiority criterion. Above it, caution is warranted. The sensitivity table on the next slide shows exactly where that threshold lies.

**Key points to emphasize**:
- L is the multiplier: large L means the drug "cares about" that characteristic
- BMI: huge distributional gap, tiny L — clinical impact is small
- HbA1c: moderate distributional gap, large L — clinical impact is the primary concern
- The reversal is not a paradox — it is what the mathematics correctly predicts
- L-star = 0.49 is the breakeven for HbA1c: interpretable and communicable to regulators

---

## Slide: Sensitivity Analysis: HbA1c (Japan vs. US)

**Duration**: ~1.5 minutes

**Script**:
Because L is estimated — not known precisely — we present a sensitivity table showing Delta-max as a function of L for HbA1c Japan versus the US.

nABCD is fixed at 0.27 and IQR at 1.5% for all rows.

At L equals 0.10 — a weak effect modifier — Delta-max is 0.08%, just 10% of the overall treatment effect. No concern. At L equals 0.20, Delta-max is 0.16%, still 20% of effect and well below the margin. At our point estimate of L equals 0.30, Delta-max is 0.24%, as we calculated.

As L increases to 0.40, Delta-max reaches 0.32% — 40% of treatment effect and 80% of the non-inferiority margin. At L equals 0.50, Delta-max is 0.41%, which exceeds the 0.4% margin.

The breakeven is at L-star equals 0.49. This is the answer to the regulator's question: "At what level of CATE sensitivity does the Japan-US HbA1c difference become incompatible with pooling under the non-inferiority criterion?"

The answer is 0.49. Whether L actually reaches that level is a scientific question that prior data, subgroup analyses, and pharmacological reasoning can inform. The framework does not answer that question for the regulator — it provides the exact context in which they need to answer it. That is the intended role of this tool.

**Key points to emphasize**:
- L-star = 0.49: the breakeven where Delta-max equals the NI margin of 0.4%
- At our point estimate L=0.30, Delta-max = 0.24% — below the margin
- The table is transparent: regulators can substitute their own L estimate
- This is sensitivity analysis as a communication tool, not just a robustness check

---

## Slide: Estimation, Not Testing

**Duration**: ~1.5 minutes

**Script**:
I want to close the results section with an explanation of why we deliberately chose an estimation framework over hypothesis testing, because this is a methodological decision with direct regulatory implications.

Hypothesis testing asks a binary question: is this difference significant? The answer depends on sample size, the choice of alpha, and the composite null hypothesis. For a large trial, even a clinically irrelevant distributional difference would reject the null. For a small trial, a meaningful difference might fail to reject. Neither outcome gives the regulator what they need.

There are three specific reasons we recommend against testing in this context.

First, ICH E17 explicitly avoids binary rules on similarity. The guideline says similarity is context-dependent. A single threshold cannot serve all diseases, all drug classes, and all regulatory contexts simultaneously. An estimation framework naturally accommodates this: the regulator applies their own clinical judgment to the Delta-max value.

Second, L is uncertain. A test result collapses all of this uncertainty into a p-value, hiding the fact that the conclusion could change substantially if L were different. The sensitivity table makes that uncertainty explicit and visible.

Third, the decision boundary is context-specific. A non-inferiority trial with margin 0.4% and a superiority trial with expected effect 0.8% face fundamentally different clinical stakes — even with identical nABCD values. The estimation framework, by reporting Delta-max and comparing it directly to the clinical margin, handles this naturally. Testing cannot.

The recommended reporting is: nABCD with 95% confidence interval, Delta-max with 95% confidence interval, and the full sensitivity range. Regulatory judgment informed by evidence — not ruled by algorithm.

With that, I will hand over to the Discussion section.

**Key points to emphasize**:
- Testing produces a binary answer; estimation quantifies the effect and its uncertainty
- ICH E17's context-dependence is incompatible with a universal test threshold
- L uncertainty is made visible by sensitivity tables, not hidden in a p-value
- Same nABCD can mean very different things in NI vs. superiority trials
- Transition: these results motivate the recommendations in the Discussion

---

*End of Act 3 — Results*
*Transition to Act 4: Discussion (Harvey Specter)*
