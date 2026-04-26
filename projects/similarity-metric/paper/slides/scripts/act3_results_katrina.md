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

We designed seven scenarios anchored to clinical reality. Scenarios S1 through S4 test pure location shifts — identical to the kind of mean differences you would capture with a standardized mean difference. S1 is the null: perfectly identical populations. S2 represents a small real-world gap. S4 represents a large one — nearly one full standard deviation.

Then we add what SMD cannot see. S5 tests a pure scale difference: same mean, 50% wider spread. S6 models high-skew data with a log-normal, mimicking biomarkers with a coefficient of variation around 53%. S7 combines location and scale shifts simultaneously.

Each scenario ran 10,000 replications at three sample sizes: 50, 100, and 200 per region. Bootstrap confidence intervals used 2,000 replications. The true nABCD values span from zero to 0.37, giving us a representative range of what practitioners would encounter in real MRCTs.

**Key points to emphasize**:
- Seven scenarios cover the full space: location, scale, skew, combined
- True nABCD values are anchored to clinically motivated distributions
- Three sample sizes chosen to capture the n=50 (small region) to n=200 (mature registry) range
- S5 and S6 are the critical SMD-blind scenarios — keep them in mind for the next slide

---

## Slide: Bias Results

**Duration**: ~1.5 minutes

**Script**:
Let's look at bias first. The general pattern is encouraging: as sample size increases, bias decreases toward zero for most scenarios.

At n=100, the most important threshold for practice, non-null scenarios excluding S4 all show bias below 0.02 in absolute terms. To put that in context, that is smaller than the width of a typical bootstrap confidence interval for these settings. For S3, S5, S6, and S7 — which represent the practically relevant range — the estimator is essentially unbiased by n=100.

S4 deserves special attention. With a true nABCD of 0.37 — the large location shift — we see persistent negative bias around minus 0.04 even at n=200. This is a known property of empirical process estimators for the L1 distance: when the true value is far from the boundary at zero, the bounded nature of the statistic introduces a modest downward pull. It does not invalidate inference; it means that for large distributional differences, nABCD is slightly conservative — it understates the gap.

The null scenario S1 shows the most striking positive bias, particularly at n=50: plus 0.09. This is expected. When the true value is zero, the estimator can only overestimate. The practical implication is that small samples near the null will produce inflated estimates. This is the primary motivation for our n≥100 recommendation.

**Key points to emphasize**:
- n≥100 is the practical threshold for bias below 0.02 in non-null scenarios
- S4 negative bias is a conservative property: nABCD understates large differences
- Null positive bias at small n is structural, not a flaw — it motivates the n≥100 recommendation
- S6 (skew/log-normal) is well-behaved across all sample sizes — important for real-world lab values

---

## Slide: Coverage and Precision

**Duration**: ~1.5 minutes

**Script**:
Now coverage — the probability that the 95% percentile bootstrap interval actually contains the true nABCD.

The headline result: at n≥100, coverage is between 0.87 and 0.98 across all seven scenarios. That is adequate for the inferential goals of a regulatory submission.

Two scenarios require explanation. S2, the small location shift with true nABCD of 0.07, shows coverage of only 0.67 at n=50 and 0.90 at n=100. This near-null behavior reflects the theoretical prediction from del Barrio's asymptotic theory: when the two distributions are very close, the Hadamard derivative of the W1 functional becomes non-linear, and standard bootstrap consistency does not fully apply. Coverage recovers to nominal by n=200.

S4, the large location shift, shows the reverse problem: coverage degrades from 0.93 at n=50 to 0.73 at n=200. This is not a failure of the bootstrap — it reflects the persistent negative bias we just saw. As n grows, the confidence interval tightens around the biased estimate, pulling coverage down.

The standout performer is S6, the log-normal skew scenario: near-nominal coverage of 0.95 across all three sample sizes. Given that skewed lab values are precisely the distributions where shape differences matter most clinically, this is the result that matters most for practice.

**Key points to emphasize**:
- At n≥100, coverage is 0.87–0.98: adequate for regulatory inference
- S2 near-null undercoverage is theoretically expected and resolves by n=200
- S6 skew scenario achieves near-nominal coverage even at n=50 — best practical news
- Formal recommendation: n≥100 per region for reliable inference

---

## Slide: nABCD vs SMD: Sensitivity Comparison

**Duration**: ~1.5 minutes

**Script**:
This slide is perhaps the most direct argument for why nABCD exists.

Look at S3: a half-standard-deviation location shift. Both nABCD and SMD detect it. SMD gives 0.50, nABCD gives 0.18. They disagree on magnitude because they measure different things — SMD is purely a location metric, while nABCD measures the full distributional mass displacement. But at least both flag the scenario. So for pure location differences, SMD works.

Now look at S5: a pure scale difference. The two populations have identical means but the spread in region 2 is 50% wider. SMD is 0.00. It sees nothing. nABCD is 0.14. It detects a clinically meaningful distributional gap that would affect any drug whose treatment effect depends on the patient's baseline variability.

S6 is the log-normal skew scenario. SMD is 0.00. nABCD is 0.31 — large. This is a high-skew distribution with CV of 53%. For a drug whose CATE function is non-linear, this level of shape difference could drive substantial regional heterogeneity in average treatment effects. SMD would give you no warning.

The conclusion is structural. SMD is a summary of location. nABCD is a summary of the full distributional difference — the exact quantity that bounds treatment effect heterogeneity. For regulatory decision-making under ICH E17, SMD is insufficient.

**Key points to emphasize**:
- SMD is blind to variance and shape: 0.00 for S5 and S6
- nABCD captures the full distributional difference relevant to the heterogeneity bound
- S6 is the most striking case: log-normal skew, nABCD=0.31, SMD=0.00
- The blindness of SMD is not a sampling artifact — it is structural

---

## Slide: Hypothetical Thrombolytic MRCT (GUSTO-I)

**Duration**: ~1 minute

**Script**:
Now let us apply these ideas to a concrete planning scenario.

We are planning a Phase 3 MRCT for a novel thrombolytic agent — Drug T — in acute myocardial infarction. We need a distributional source for our regional populations, and we use GUSTO-I: a 40,830-patient public IPD dataset with 16 anonymized regions. GUSTO-I is not itself an MRCT, and the regions carry no geographic labels. So this is a methodological illustration — not an endorsement of GUSTO-I-era distributions as current references.

We designate Region 8 — sample size 2,916 — as the small-sample anchor. The remaining 15 regions are evaluated as pooling partners. The two candidate effect modifiers are age and systolic blood pressure. Per-unit CATE slope, our L parameter, is unavailable a priori for either: the FTT meta-analysis reports only "irrespective of age," and no quantitative class-level CATE sensitivity exists for SBP. So we apply the L-star reverse-calculation pathway for both.

**Key points to emphasize**:
- GUSTO-I is a public IPD source, not a real MRCT
- Two candidate effect modifiers: age and SBP
- L unavailable a priori → L-star pathway is the primary calibration tool
- Region 8 as small-sample anchor; 15 partners evaluated

---

## Slide: nABCD Results — Region 8 vs 15 Partners

**Duration**: ~1.5 minutes

**Script**:
Here are the nABCD point estimates and 95% percentile bootstrap CIs for all 15 partner regions, on both candidate effect modifiers.

For age, the range is narrow: 0.011 at the lowest pair to 0.076 at the highest. Eleven of the fifteen partners sit below 0.040.

For SBP, the range is wider: 0.015 to 0.110. Most partners cluster between 0.050 and 0.110.

I want to note the role of the bootstrap confidence intervals. At mid-rank, partner CIs overlap, which means the ranking carries genuine uncertainty. We report point estimates with CI widths so the audience knows exactly how confident the ordering can be at each position. This is what an estimation-centered framework looks like in practice.

**Key points to emphasize**:
- Age range narrower than SBP range — geographic heterogeneity in SBP exceeds age in GUSTO-I
- Mid-rank CIs overlap — ranking confidence varies
- Reporting point estimate + CI width is core to the estimation-centered design

---

## Slide: R2 vs R9 — Why Joint Evaluation Is Essential

**Duration**: ~2 minutes

**Script**:
This is the first of two slides containing the central application message. Look at R2 versus R9.

R2 has age nABCD of 0.061 — the second largest age value in the table. But R2 has SBP nABCD of 0.015 — the smallest in the table.

R9 inverts this. Age nABCD is 0.017 — fourth smallest. SBP nABCD is 0.110 — the largest.

If we ranked partners by age alone, R9 looks attractive and R2 looks like one to avoid. If we ranked by SBP alone, R2 looks ideal and R9 looks worst. A single effect modifier produces opposite conclusions.

The implication is direct. When multiple candidate effect modifiers are under consideration, all candidates must be evaluated jointly. Restricting evaluation to a subset risks selecting partners whose distributional differences on the omitted modifiers would later compromise regional consistency.

**Key points to emphasize**:
- R2 and R9 produce opposite rankings depending on which modifier you privilege
- This is not an artifact — it is what real GUSTO-I data show
- Practical rule: evaluate all candidate effect modifiers jointly

---

## Slide: Leading Pooling Candidates — R4, R6, R13

**Duration**: ~1.5 minutes

**Script**:
When we apply the joint criterion, three regions emerge: R4, R6, and R13.

These three rank low on both candidate effect modifiers. All six of their nABCD values — three regions times two modifiers — sit in the lower portions of the observed ranges. Age range 0.011 to 0.076: R4, R6, R13 are in the lower portion. SBP range 0.015 to 0.110: R4, R6, R13 are again in the lower portion.

The required L-star values for these three regions also fall near the lower end of what would reasonably be considered clinically plausible for thrombolysis in AMI given the available class evidence.

The conclusion the paper draws is deliberately calibrated. In its exact language: "the sponsor may reasonably prioritize R4, R6, and R13 as the leading candidates for pooling with Region 8." This is not a binary verdict. It is a quantitative basis for prioritization, which the sponsor combines with clinical and regulatory judgment to arrive at a final decision.

**Key points to emphasize**:
- Joint criterion: low nABCD on both candidate effect modifiers
- L-star plausibility provides the second confirmatory check
- "Reasonably prioritize" — soft prioritization, not binary poolable/not-poolable

---

## Slide: Sponsor Judgment, Not Algorithmic Verdict

**Duration**: ~1.5 minutes

**Script**:
I want to be precise about what the framework does and does not do.

The framework does not assign poolable or not poolable labels to nABCD values. It does not impose a fixed cutoff. It does not replace sponsor judgment.

What the framework does provide: nABCD point estimates, bootstrap confidence intervals, L-star sensitivities, and joint visualizations of all candidate modifiers. These are quantitative inputs that support deliberation between the sponsor, the clinical advisor, and the regulatory advisor.

For partners outside the leading three — R4, R6, R13 — sponsors who want to consider them can examine partner-specific L-star values and CI widths to evaluate the precision and plausibility of pooling on each candidate effect modifier. The framework supports that exploration without prescribing the answer.

**Key points to emphasize**:
- The framework supplies quantitative inputs, not verdicts
- Sponsor judgment remains the locus of the pooling decision
- Partners outside the leading set are not excluded — their L-star and CI widths are available

---

## Slide: Estimation, Not Testing

**Duration**: ~1.5 minutes

**Script**:
I want to close the results section with an explanation of why we chose estimation over hypothesis testing.

Hypothesis testing asks a binary question: is this difference significant? For a large trial, even a clinically irrelevant distributional difference would reject the null. For a small trial, a meaningful difference might fail to reject. Neither outcome gives the regulator what they need.

There are three specific reasons we recommend against testing in this context.

First, ICH E17 explicitly avoids binary rules on similarity. A single threshold cannot serve all diseases, all drug classes, and all regulatory contexts simultaneously. An estimation framework naturally accommodates this.

Second, L is uncertain. A test result collapses that uncertainty into a p-value. The L-star sensitivity calculation makes the uncertainty explicit and clinically interpretable.

Third, the decision boundary is context-specific. A non-inferiority trial and a superiority trial face fundamentally different clinical stakes — even with identical nABCD values. The estimation framework, by reporting on the clinical scale, handles this naturally. Testing cannot.

The recommended reporting is: nABCD with 95% CI, plus Delta-max with 95% CI when L is available, plus L-star at pre-specified Delta-clin values when L is unknown. Regulatory judgment informed by evidence — not ruled by algorithm.

With that, I will hand over to the Discussion section.

**Key points to emphasize**:
- Testing produces a binary answer; estimation quantifies the effect and its uncertainty
- ICH E17's context-dependence is incompatible with a universal test threshold
- Reporting bundle: nABCD CI + Delta-max or L-star + clinical benchmarks
- Transition: these results motivate the recommendations in the Discussion

---

*End of Act 3 — Results (updated 2026-04-25 to align with GUSTO-I application and §5 Discussion redesign)*
*Transition to Act 4: Discussion (Harvey Specter)*
