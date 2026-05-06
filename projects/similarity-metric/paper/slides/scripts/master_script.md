# nABCD Presentation — Master Speaker Script

**Total slides**: 29 (+ 5 section dividers = 34 pages)
**Estimated time**: ~36 minutes (target: compress to 25 min for JSM)
**Date**: 2026-03-03 (updated 2026-04-25 to align with §5 Discussion redesign and GUSTO-I application)

| Act | Presenter | Slides | Time |
|-----|-----------|:------:|:----:|
| Opening | Harvey | 2 | ~1.5 min |
| Act 1: Background | Rachel | 4 | ~6.5 min |
| Act 2: Methods | Mike | 7 | ~14 min |
| Act 3: Simulation | Katrina | 4 | ~6 min |
| Act 4: Application (GUSTO-I) | Katrina | 6 | ~9 min |
| Act 5: Discussion | Harvey | 6 | ~7.5 min |
| **Total** | | **29** | **~44.5 min** |

---

# OPENING — Harvey Specter

---

## Slide 1: Title

**Duration**: ~60 seconds

**Script**:

Every year, sponsors invest hundreds of millions of dollars pooling data across regions in multi-regional clinical trials. And every year, the same question arises in regulatory review rooms: are these populations similar enough to pool?

That question has existed since ICH E17 was published in 2017. What has not existed — until now — is a principled, quantitative answer.

We have been working with visual inspection, with standardized mean differences that ignore variance and shape, and with goodness-of-fit statistics that give you a p-value but nothing you can put on a clinical scale. None of these tell you what regulators actually need to know: if these populations differ in their effect modifier distributions, what is the worst-case impact on treatment effect estimates?

This paper introduces nABCD — a normalized, Wasserstein-based coefficient for distributional comparison — built from first principles to answer exactly that question.

**Key points to emphasize**:
- Open with the regulatory stakes, not the statistics
- "Principled, quantitative answer" signals this is a solution, not incremental
- End the hook before the outline — do not preview results

---

## Slide 2: Outline

**Duration**: ~30 seconds

**Script**:

Here is the architecture of the talk.

We begin with the regulatory gap — what ICH E17 requires and what it does not provide. We then develop the methodology: the heterogeneity bound, the nABCD definition, and dual-pathway clinical calibration through Delta-max and the L-star reverse calculation. The simulation study follows, covering bias, coverage, and a direct comparison with the standardized mean difference. We then work through a hypothetical thrombolytic MRCT grounded in publicly available GUSTO-I individual patient data, where two candidate effect modifiers — age and systolic blood pressure — produce markedly different partner rankings, demonstrating that all candidate modifiers must be evaluated jointly. And we close with discussion — what we delivered, what remains, and what practitioners should do with this framework starting now.

Thirty-two slides. Let's move.

**Key points to emphasize**:
- Strictly functional — no motivational commentary
- "Ranking divergence + leading candidates" preview plants a hook for Section 4
- "Let's move" signals pace and confidence

---

# ACT 1: BACKGROUND — Rachel Zane

---

## Slide 3: ICH E17: Regional Pooling

**Duration**: ~2 minutes

**Script**:

Let me set the regulatory context for this work.

Multi-regional clinical trials — MRCTs — are now the standard model for global drug development. The fundamental statistical challenge in an MRCT is this: can we pool data across regions, or do regional differences in patient populations make pooling scientifically unjustifiable?

ICH E17, the international harmonized guideline on MRCTs adopted in 2017, provides the governing framework here. Section 2.2.5 of that guideline states — and I'm quoting directly — that regions may be pooled "if subjects are thought to be *similar enough* with respect to intrinsic and extrinsic factors relevant to the disease and/or drug under study."

That phrase "similar enough" is doing a great deal of work. ICH E17 explicitly grounds the pooling justification in the *similarity of factor distributions* across regions. The guideline even lists what those factors include: age, body weight, genetic polymorphisms, disease severity — these are the intrinsic patient characteristics — and medical practice, diet, and standard of care on the extrinsic side.

The problem, as you can see on this slide, is that ICH E17 stops there. It articulates the criterion for pooling in words, but provides **no specific metric, no threshold, and no formal procedure** for operationalizing that criterion. "Similar enough" has no unit. And that is precisely the methodological gap that motivates our work.

**Key points to emphasize**:
- ICH E17 (2017) is the governing international guideline for MRCTs
- The direct quote from Section 2.2.5 names "similar enough" without specifying a metric
- This is a real regulatory gap — it affects submissions to FDA, EMA, PMDA, and NMPA

---

## Slide 4: Why Effect Modifiers Matter

**Duration**: ~1.5 minutes

**Script**:

So why does the distribution of patient characteristics matter at all for treatment effect comparison across regions? Let me be precise about the mechanism.

The key concept is the **effect modifier** — a baseline characteristic where the treatment benefit differs systematically across subgroups. Mathematically, if we denote the conditional average treatment effect as tau of x, where x is the baseline characteristic, then the *regional* average treatment effect is simply the integral of tau(x) against the distribution of x in that region.

This equation tells us something important: even if the drug's biological effect is identical at the individual patient level — same tau(x) for any given patient — two regions with **different patient distributions** will observe **different average treatment effects**. Not because the drug behaves differently, but because the *patient mix* differs.

A concrete example: suppose younger patients derive greater benefit. A region enrolling younger patients on average will report a larger treatment effect estimate. That difference is entirely attributable to the composition of the patient population, not to any pharmacological difference.

This is the mechanism ICH E17 is concerned about. And quantifying it requires us to measure how different those patient distributions actually are.

**Key points to emphasize**:
- tau-bar_r = integral of tau(x) dF_r(x) — regional differences arise from F_r, not tau(x)
- This is a compositional effect, not a pharmacological one
- This mechanism is what ICH E17's pooling criterion is designed to control for

---

## Slide 5: Limitations of Current Approaches

**Duration**: ~1.5 minutes

**Script**:

So what tools do practitioners currently use to assess this distributional similarity? The honest answer is: not much.

The most common approach in regulatory submissions is **visual inspection** — comparing histograms or summary tables. That is inherently subjective and not reproducible. Two statisticians looking at the same forest plot may reach different conclusions about whether two distributions are "similar enough."

The next most commonly cited tool is the **standardized mean difference**, or SMD. This is familiar territory — it is the same measure used in propensity score diagnostics for covariate balance. The problem is that SMD only captures differences in location, in the mean. Two distributions can have identical means but differ substantially in variance or distributional shape, and SMD will register zero difference. For effect modifiers with non-linear CATE functions, those shape and scale differences are precisely what drives treatment effect heterogeneity.

The **Kolmogorov-Smirnov statistic** is sometimes mentioned as an alternative. It does capture distributional differences beyond location, but it operates on a dimensionless [0,1] scale with no clinically interpretable meaning. Telling a regulatory team that K-S equals 0.15 gives them no way to assess whether that constitutes a problem.

This gap has not gone unnoticed. Two recent papers from the Chinese NMPA perspective — Song and colleagues in 2025, and Long and colleagues, also in 2025 — both highlight the absence of quantitative tools for operationalizing ICH E17's pooling criterion. They document that this is a real, active gap in regulatory practice. Our paper directly addresses what they identify as missing.

**Key points to emphasize**:
- SMD's blindness to scale and shape is structural, not a minor limitation
- Song et al. (2025) DOI: 10.1007/s43441-025-00744-8
- Long et al. (2025) DOI: 10.1007/s43441-024-00717-z
- This locates our contribution in a live regulatory debate

---

## Slide 6: Our Approach

**Duration**: ~1.5 minutes

**Script**:

This brings us to our central research question: how can we estimate distributional similarity in a *scale-free* manner, and then translate that estimate into *clinically interpretable* information about potential treatment effect heterogeneity?

I want to highlight two choices that define our design philosophy, because they distinguish this work from prior proposals.

First, we take an **estimation-centered** approach, not a testing approach. We do not ask "are the distributions different?" with a binary yes-or-no answer. We ask "how different are they, and what does that difference imply for the magnitude of potential treatment effect heterogeneity?" ICH E17 itself cautions against rigid binary criteria — it explicitly recommends context-dependent judgment. Estimation supports that judgment; binary testing forecloses it.

Second, we insist on **clinical calibration**. A pure distributional metric is still abstract to a regulatory audience. We want to translate whatever similarity score we compute back into the clinical outcome scale — into the same units as the treatment effect and the non-inferiority margin. That is what makes the tool actionable.

I should also be clear about scope: our method is designed for **continuous effect modifiers**. Categorical effect modifiers require different distance structures, and we note that as a direction for future work.

The goal is to provide regulatory scientists with quantitative tools that *inform* deliberation, not replace it with an algorithm. With that philosophy in mind, let me turn to the Methods section, where Mike will walk you through the mathematical foundations.

**Key points to emphasize**:
- Estimation vs testing has regulatory backing in ICH E17's language about context-dependence
- Clinical calibration is what makes the metric actionable, not merely academic
- Scope limitation to continuous EMs is intentional and explicit
- Clean handoff to Methods

---

# ACT 2: METHODS — Mike Ross

---

## Slide 7: The Heterogeneity Bound

**Duration**: ~2 minutes

**Script**:

So let me start by showing you the central result that motivates everything we're going to do. The entire nABCD framework rests on a single inequality.

We have two regions. Each region has a patient population described by the distribution F_r of some baseline effect modifier — age, systolic blood pressure, lab biomarkers, whatever the relevant characteristic is. The average treatment effect in region r is the integral of the CATE function tau(x) against that distribution. Even if the drug works identically at the individual level — tau(x) is the same everywhere — if the patient compositions F_1 and F_2 differ, the regional averages tau-bar_1 and tau-bar_2 can diverge.

The bound says: if the CATE function tau(x) is Lipschitz continuous with constant L, then the difference in regional average treatment effects is bounded above by L times W_1 of F_1 and F_2.

The W_1 here is the Wasserstein-1 distance — the Earth Mover's Distance. Geometrically it is exactly the total area between the two cumulative distribution functions. It captures location, scale, and shape differences simultaneously.

This gives us a fundamentally useful object. We can compute W_1 from baseline covariate data alone, before the trial is analyzed. And L, the CATE sensitivity, can be informed by prior knowledge or subgroup analyses. Together, they give an upper bound on how different the regional treatment effects can possibly be, given what we know about the patient distributions.

The key constraint I want you to hold in mind: this requires W_1, and specifically W_1. I'll explain exactly why in two slides.

**Key points to emphasize**:
- The bound connects observable baseline distributions to unobservable treatment effect heterogeneity
- W_1 appears because of K-R duality — not a design choice but a mathematical necessity
- The bound can be evaluated from pre-trial baseline data alone

---

## Slide 8: Derivation: Three Steps

**Duration**: ~3 minutes

**Script**:

I want to walk through the derivation in detail, because the logic here is genuinely elegant, and understanding it will clarify every design decision we made downstream.

There are exactly three steps.

Step one: recognize W_1 as the L1 distance between CDFs. In one dimension, W_1(F_1, F_2) is simply the integral of the absolute difference of the two cumulative distribution functions. This is the area you see when you plot two CDFs and shade between them. This representation is what allows efficient computation — you sort the pooled data, compute the Riemann sum, and you're done in O(n log n) time. So step one is: W_1 is a geometric object, an area between curves.

Step two is the critical step. The Kantorovich-Rubinstein duality theorem tells us that W_1 has a second, equivalent representation as a supremum over all 1-Lipschitz functions f: W_1(F_1, F_2) equals the supremum over all f with Lipschitz norm at most 1, of the absolute difference in expectations of f under F_1 versus F_2.

What does this mean in plain terms? It means that W_1 is precisely the worst-case difference in expected values over all functions that change at rate at most 1 per unit of covariate. This is not an approximation or a bound — it is an exact equality. W_1 measures how much two distributions can disagree in their expected behavior, if you restrict to smooth functions.

Step three is just substitution. Our CATE function tau(x) has Lipschitz constant L. So the normalized function g(x) = tau(x) / L has Lipschitz norm exactly 1. We are allowed to plug g into the K-R supremum. That gives us the absolute difference of (tau-bar_1 / L) and (tau-bar_2 / L) is at most W_1. Multiply both sides by L, and we have our bound.

The proof is literally three lines. But the K-R duality in step two is doing the heavy lifting, and it is the reason the entire framework is built around W_1 and not any other distance.

**Key points to emphasize**:
- Step 1: geometric fact — W_1 = area between CDFs
- Step 2: K-R duality — exact equality, not an inequality or approximation
- Step 3: substitution — tau(x)/L is a valid 1-Lipschitz function
- The intellectual content is entirely in the K-R duality

---

## Slide 9: Why W₁ — And Only W₁

**Duration**: ~2 minutes

**Script**:

Now I want to directly address the question you might be thinking: why not W_2, which is more commonly used in optimal transport theory? Or KL divergence, which is popular in machine learning? Could we have built this framework around a different distance?

The answer is no — and it is not a matter of taste. It is a mathematical necessity.

Look at the table on the slide. W_1 satisfies K-R duality, meaning it admits the Lipschitz supremum representation. W_2 does not. The dual representation of W_2 involves convex functions, not Lipschitz functions. A convex function can change arbitrarily fast in regions where the data does not live — so you cannot bound the CATE integral using W_2 without additional structural assumptions that we are not willing to impose. The heterogeneity bound simply does not exist in the W_2 case.

KL divergence fails for two independent reasons. First, it is asymmetric: the divergence from F_1 to F_2 is not the same as from F_2 to F_1, which creates an arbitrary directional choice that has no clinical justification. Second, and more practically, KL divergence diverges to infinity whenever the empirical supports do not fully overlap — which happens routinely in finite trial samples. A metric that is infinite for perfectly reasonable data configurations is not a usable clinical tool.

So W_1 is not the most fashionable choice or our personal preference. It is the unique distance that enables the heterogeneity bound through K-R duality. That uniqueness is the foundation the entire nABCD framework is built on.

**Key points to emphasize**:
- W_2 dual involves convex functions — cannot bound CATE integrals
- KL is asymmetric AND can diverge to infinity — both are fatal
- W_1 is the unique choice — alternatives are incompatible, not suboptimal

---

## Slide 10: The Bound Is Tight, Not Loose

**Duration**: ~1.5 minutes

**Script**:

I want to preempt what I expect will be the most natural objection: "You are using an upper bound. Isn't that inherently conservative? Doesn't the true treatment effect difference almost always end up much smaller?"

There are two separate questions here. First: is the mathematical bound itself tight? Second: will the bound be binding in any particular application?

On the first question — yes, the bound is mathematically tight. By the K-R duality, there exists a 1-Lipschitz function that actually achieves the supremum. For the bound to hold with equality, there needs to exist a CATE function with Lipschitz constant exactly L whose integral difference achieves W_1. Such a function exists — it is not a hypothetical. So the bound is the tightest possible statement you can make given only the information that tau is L-Lipschitz.

On the second question — whether the CATE in a specific trial achieves the worst case — that depends on the actual biology. This is why we recommend sensitivity analysis over L rather than treating Delta-max as a point prediction.

But — and this is crucial for the regulatory context — the appropriate error to guard against in pooling decisions is the false positive: treating distinct populations as equivalent when they are not. An upper bound that guarantees the worst-case scenario is exactly the right tool for that purpose.

**Key points to emphasize**:
- Tight = optimal given Lipschitz smoothness only
- Whether it is binding depends on biology → sensitivity analysis
- For regulatory safety, an upper bound is the correct inferential object

---

## Slide 11: nABCD Definition

**Duration**: ~2 minutes

**Script**:

Now that we have the bound, let me show you the normalized statistic we actually compute and report.

The nABCD is W_1 divided by the pooled IQR. Each design choice here is deliberate.

Why normalize at all? W_1 is in the original units of the covariate — years for age, mmHg for systolic blood pressure, units of any continuous biomarker. If you want to compare the degree of distributional difference across different effect modifiers in a single trial, you need a dimensionless number.

Why IQR and not standard deviation? Two reasons. First, IQR is robust to outliers and heavy tails — it measures the spread of the central 50% of the distribution. We reviewed the robustness literature, including Rousseeuw and Croux (1993) who established that Q_n has higher breakdown point than IQR, but Q_n is less familiar to clinical reviewers and the higher breakdown protection is not necessary for population-level regulatory data. IQR has the right balance of robustness and interpretability. Second, IQR is already familiar to clinicians.

Why divide by IQR (without an extra factor)? This calibrates nABCD so that a one-IQR pure location shift yields nABCD = 1.0 — a direct and intuitive scale anchor for clinical reviewers.

The resulting nABCD is dimensionless, always non-negative, and equals zero if and only if the two distributions are identical. And by substituting back into the heterogeneity bound, we get: Delta-max equals L times IQR times nABCD.

**Key points to emphasize**:
- Normalization needed for cross-EM comparability
- IQR: robust + familiar (Q_n has higher breakdown but unnecessary here)
- Calibration: 1-IQR location shift yields nABCD = 1.0

---

## Slide 12: Clinical Calibration: Δ_max

**Duration**: ~2 minutes

**Script**:

This is, in my view, the genuinely unique contribution of our framework. Every methodological choice we have made up to this point has been in service of this slide.

The question that regulators actually need to answer is not "are the distributions different?" — we can see from the baseline tables that they are always somewhat different. The question is "does the distributional difference matter for this drug in this disease?" And that requires translating from the covariate space into the outcome space.

Delta-max does exactly that. It is equal to L times IQR_pooled times nABCD, and it lives in the units of the clinical endpoint — percentage points of risk difference, hazard ratio on the log scale, whatever the trial is measuring.

The procedure has five steps. First, compute nABCD with bootstrap confidence intervals for each candidate effect modifier. Second, estimate L from prior knowledge: published subgroup analyses, dose-response data, meta-analyses, or pharmacokinetic reasoning. Third, compute Delta-max and propagate the confidence interval linearly. Fourth, compare against clinically meaningful thresholds — the treatment effect, the non-inferiority margin, a minimum clinically important difference. Fifth, conduct sensitivity analysis over a plausible range of L values.

That fifth step is important. If you cannot pin down L precisely, you can compute the "breakeven L*" — the value of L at which Delta-max would equal your clinical threshold. Then you ask the medical question: do we think the CATE could change at that rate? This reframes an abstract statistical question as a clinical judgment call, which is exactly where regulatory deliberation should sit.

**Key points to emphasize**:
- Delta-max is in outcome units — the bridge from abstract to clinical
- Five-step procedure is practical with standard trial data
- Breakeven L* converts the problem into a clinical judgment question

---

## Slide 13: Estimation and Inference

**Duration**: ~1.5 minutes

**Script**:

Let me now describe how we compute nABCD and attach an uncertainty interval to it.

The point estimator is a Riemann sum of the empirical CDF differences, divided by the pooled empirical IQR. You sort all pooled observations, evaluate the jump in each empirical CDF at each order statistic, and sum the products of absolute CDF differences and interval widths. This runs in O(n log n) time after sorting.

For inference, we use the percentile bootstrap with B equals 2,000 resamples. I want to be explicit about why we chose percentile over BCa. BCa applies an acceleration correction designed for statistics with standard-normal limiting distributions. But nABCD is bounded below at zero, and near the null, the sampling distribution is right-skewed. BCa overcorrects in this regime, producing systematically too-wide intervals. The percentile bootstrap outperforms BCa for bounded statistics near the boundary.

The asymptotic theory comes from del Barrio, Cuesta-Albertos, and Matran (1999), who established that W_1 converges at root-n rate to a Brownian bridge functional. When F_1 and F_2 are genuinely different, the Hadamard derivative is linear and bootstrap is consistent. When distributions are nearly identical, the derivative becomes non-linear, producing modest undercoverage. This is why we recommend n of at least 100 per region.

With those foundations in place, let me show you what the simulations reveal.

**Key points to emphasize**:
- O(n log n) computation, no distributional assumptions
- Percentile bootstrap outperforms BCa for this bounded statistic
- del Barrio et al. (1999): root-n CLT via Brownian bridge
- n ≥ 100 recommendation follows from near-null undercoverage

---

# ACT 3: SIMULATION — Katrina Bennett

---

## Slide 14: Simulation Design

**Duration**: ~1.5 minutes

**Script**:

Before we see how the estimator performs, let me orient you to what we actually tested.

We designed seven scenarios anchored to clinical reality. Scenarios S1 through S4 test pure location shifts — identical to the kind of mean differences you would capture with a standardized mean difference. S1 is the null: perfectly identical populations. S2 represents a small real-world gap. S4 represents a large one — nearly one full standard deviation.

Then we add what SMD cannot see. S5 tests a pure scale difference: same mean, 50% wider spread. S6 models high-skew data with a log-normal, mimicking biomarkers with a coefficient of variation around 53%. S7 combines location and scale shifts simultaneously.

Each scenario ran 10,000 replications at three sample sizes: 50, 100, and 200 per region. Bootstrap confidence intervals used 2,000 replications. The true nABCD values span from zero to 0.37, giving us a representative range of what practitioners would encounter in real MRCTs.

**Key points to emphasize**:
- S5 and S6 are the critical SMD-blind scenarios
- True nABCD range 0.000–0.372 covers the practical range
- 10,000 reps × 3 sample sizes × 7 scenarios = comprehensive evaluation

---

## Slide 15: Bias Results

**Duration**: ~1.5 minutes

**Script**:

Let's look at bias first. The general pattern is encouraging: as sample size increases, bias decreases toward zero for most scenarios.

At n=100, the most important threshold for practice, non-null scenarios excluding S4 all show bias below 0.02 in absolute terms. To put that in context, that is smaller than the width of a typical bootstrap confidence interval. For S3, S5, S6, and S7 — the practically relevant range — the estimator is essentially unbiased by n=100.

S4 deserves special attention. With a true nABCD of 0.37, we see persistent negative bias around minus 0.04 even at n=200. This is a known property of empirical process estimators for the L1 distance. It means that for large distributional differences, nABCD is slightly conservative — it understates the gap.

The null scenario S1 shows the most striking positive bias, particularly at n=50: plus 0.09. When the true value is zero, the estimator can only overestimate. This is the primary motivation for our n≥100 recommendation.

**Key points to emphasize**:
- n≥100: bias < 0.02 for non-null scenarios
- S4 negative bias is conservative (understates large differences)
- Null positive bias at small n motivates n≥100 recommendation

---

## Slide 16: Coverage and Precision

**Duration**: ~1.5 minutes

**Script**:

Now coverage — the probability that the 95% percentile bootstrap interval actually contains the true nABCD.

The headline result: at n≥100, coverage is between 0.87 and 0.98 across all seven scenarios. That is adequate for regulatory submissions.

S2, the small location shift with true nABCD of 0.07, shows coverage of only 0.67 at n=50 and 0.90 at n=100. This near-null behavior reflects the theoretical prediction from del Barrio's asymptotic theory: when distributions are very close, the Hadamard derivative becomes non-linear. Coverage recovers to nominal by n=200.

S4 shows the reverse problem: coverage degrades from 0.93 at n=50 to 0.73 at n=200. This reflects the persistent negative bias — as n grows, the confidence interval tightens around the biased estimate.

The standout performer is S6, the log-normal skew scenario: near-nominal coverage of 0.95 across all three sample sizes. Given that skewed lab values are the distributions where shape differences matter most clinically, this is the result that matters most for practice.

**Key points to emphasize**:
- At n≥100: coverage 0.87–0.98 — adequate for regulatory inference
- S6 achieves near-nominal even at n=50 — best practical news
- Recommendation: n≥100 per region

---

## Slide 17: nABCD vs SMD: Sensitivity Comparison

**Duration**: ~1.5 minutes

**Script**:

This slide is perhaps the most direct argument for why nABCD exists.

Look at S3: a half-standard-deviation location shift. Both nABCD and SMD detect it. SMD gives 0.50, nABCD gives 0.18. They disagree on magnitude because they measure different things. But at least both flag the scenario.

Now look at S5: a pure scale difference. The two populations have identical means but the spread in region 2 is 50% wider. SMD is 0.00. It sees nothing. nABCD is 0.14. It detects a clinically meaningful distributional gap.

S6 is the log-normal skew scenario. SMD is 0.00. nABCD is 0.31 — large. This is a high-skew distribution with CV of 53%. For a drug whose CATE function is non-linear, this level of shape difference could drive substantial regional heterogeneity. SMD would give you no warning.

The conclusion is structural. SMD is a summary of location. nABCD is a summary of the full distributional difference — the exact quantity that bounds treatment effect heterogeneity. For regulatory decision-making under ICH E17, SMD is insufficient.

**Key points to emphasize**:
- SMD = 0.00 for S5 and S6 — structurally blind, not a sampling artifact
- S6 is the most striking: nABCD = 0.31, SMD = 0.00
- nABCD captures the quantity that bounds heterogeneity; SMD does not

---

# ACT 4: APPLICATION — Katrina Bennett

---

## Slide 18: Hypothetical Thrombolytic MRCT (GUSTO-I)

**Duration**: ~1 minute

**Script**:

Now let us apply these ideas to a concrete planning scenario.

We are planning a Phase 3 MRCT for a novel thrombolytic agent — call it Drug T — in acute myocardial infarction. We need a distributional source for our regional populations, and we use GUSTO-I: a 40,830-patient public IPD dataset with 16 anonymized regions. GUSTO-I is not itself an MRCT and the regions carry no geographic labels, so this is a methodological illustration, not an endorsement of GUSTO-I-era distributions as current references.

We designate Region 8 — sample size 2,916 — as the small-sample anchor. The remaining 15 regions are evaluated as pooling partners. The two candidate effect modifiers are age and systolic blood pressure. Per-unit CATE slope, our L parameter, is unavailable a priori for either: the FTT meta-analysis reports only "irrespective of age," and no quantitative class-level CATE sensitivity exists for SBP. So we apply the L-star reverse-calculation pathway for both.

**Key points to emphasize**:
- GUSTO-I is a public IPD source, not a real MRCT
- Two candidate effect modifiers: age and SBP
- L unavailable a priori → L-star pathway is the primary calibration tool

---

## Slide 19: nABCD Results — Region 8 vs 15 Partners

**Duration**: ~1.5 minutes

**Script**:

Here are the nABCD point estimates and 95% percentile bootstrap CIs for all 15 partner regions, on both candidate effect modifiers.

For age, the range is narrow: 0.011 at the lowest pair to 0.076 at the highest. Eleven of the fifteen partners sit below 0.040.

For SBP, the range is wider: 0.015 to 0.110. Most partners cluster between 0.050 and 0.110.

Note the role of the bootstrap confidence intervals. At mid-rank, partner CIs overlap, which means the ranking carries genuine uncertainty. We report point estimates with CI widths so the audience knows exactly how confident the ordering can be at each position. This is what an estimation-centered framework looks like in practice.

**Key points to emphasize**:
- Age range narrower than SBP range
- Mid-rank CIs overlap — ranking confidence varies
- The framework reports uncertainty honestly rather than producing false rankings

---

## Slide 20: R2 vs R9 — Why Joint Evaluation Is Essential

**Duration**: ~2 minutes

**Script**:

This is the first of two slides that contain the central application message. Look at R2 versus R9.

R2 has age nABCD of 0.061 — the second largest age value in the table. But R2 has SBP nABCD of 0.015 — the smallest in the table.

R9 inverts this. Age nABCD is 0.017 — fourth smallest. SBP nABCD is 0.110 — the largest.

If we ranked partners by age alone, R9 looks attractive and R2 looks like one to avoid. If we ranked by SBP alone, R2 looks ideal and R9 looks worst. A single effect modifier produces opposite conclusions.

The implication is direct. When multiple candidate effect modifiers are under consideration, all candidates must be evaluated jointly. Restricting evaluation to a subset risks selecting partners whose distributional differences on the omitted modifiers would later compromise regional consistency.

**Key points to emphasize**:
- R2 and R9 produce opposite rankings depending on which modifier you privilege
- This is not an artifact — it is what real GUSTO-I data show
- Practical rule: evaluate all candidate effect modifiers jointly, not in isolation

---

## Slide 21: Leading Pooling Candidates — R4, R6, R13

**Duration**: ~1.5 minutes

**Script**:

When we apply the joint criterion, three regions emerge: R4, R6, and R13.

These three rank low on both candidate effect modifiers. All six of their nABCD values — three regions times two modifiers — sit in the lower portions of the observed ranges. Age range 0.011 to 0.076: R4, R6, R13 are in the lower portion. SBP range 0.015 to 0.110: R4, R6, R13 are again in the lower portion.

The required L-star values for these three regions also fall near the lower end of what would reasonably be considered clinically plausible for thrombolysis in AMI, given the available class evidence.

The conclusion the paper draws is deliberately calibrated. In its exact language: "the sponsor may reasonably prioritize R4, R6, and R13 as the leading candidates for pooling with Region 8." This is not a binary verdict. It is a quantitative basis for prioritization, which the sponsor combines with clinical and regulatory judgment to arrive at a final decision.

**Key points to emphasize**:
- Joint criterion: low nABCD on both candidate effect modifiers
- L-star plausibility provides the second confirmatory check
- "Reasonably prioritize" — soft prioritization, not binary poolable/not-poolable

---

## Slide 22: Sponsor Judgment, Not Algorithmic Verdict

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

## Slide 23: Estimation, Not Testing

**Duration**: ~1.5 minutes

**Script**:

I want to close the results section with an explanation of why we chose estimation over hypothesis testing.

There are three reasons.

First, ICH E17 explicitly avoids binary rules on similarity. The guideline language is context-dependent. A single threshold cannot serve all diseases, all drug classes, and all regulatory contexts simultaneously. An estimation framework naturally accommodates this.

Second, L is uncertain. A test result collapses that uncertainty into a p-value. The L-star sensitivity calculation makes the uncertainty explicit and clinically interpretable.

Third, the decision boundary is context-specific. A non-inferiority trial and a superiority trial face fundamentally different clinical stakes even with identical nABCD values. Estimation handles this naturally by reporting on the clinical scale. Testing cannot.

The recommended reporting is: nABCD with 95% confidence interval, plus Delta-max with 95% confidence interval when L is available, plus L-star at pre-specified Delta-clin values when L is unknown. Regulatory judgment informed by evidence, not ruled by algorithm.

**Key points to emphasize**:
- Testing = binary; estimation = quantified + uncertainty-aware
- ICH E17's context-dependence is incompatible with universal test thresholds
- Reporting bundle: nABCD CI + Delta-max or L-star + clinical benchmarks

---

# ACT 5: DISCUSSION — Harvey Specter

---

## Slide 24: Summary of Findings

**Duration**: ~90 seconds

**Script**:

Let me summarize what this paper actually shows.

On the simulation side: the percentile bootstrap is reliable at moderate sample sizes for non-negligible distributional differences. Positive bias and zero coverage at the null and near-boundary cases define a lower limit of reliable inference. We recommend n at least 100 per region, and we are explicit that estimates near zero must be interpreted with caution.

On the application side: in GUSTO-I, the two candidate effect modifiers — age and SBP — produced markedly different partner rankings. Some partners ranked similar on one but dissimilar on the other. Three regions, R4, R6, and R13, ranked low on both candidate effect modifiers and emerged as the leading pooling candidates because their L-star values also fell near the lower end of the clinically plausible range for the thrombolysis class.

These are the empirical anchors for everything else we will say.

**Key points to emphasize**:
- Simulation: reliable for non-negligible nABCD at moderate n; null/boundary needs caution
- Application: ranking divergence between age and SBP is the empirical hook
- R4, R6, R13: the joint low-nABCD plus plausible L-star result

---

## Slide 25: Two Implications for Pooling Decisions

**Duration**: ~90 seconds

**Script**:

These observations carry two implications.

First: when multiple candidate effect modifiers are under consideration, all candidates must be evaluated jointly. The R2 versus R9 contrast is the proof. Restricting evaluation to a subset of candidates risks selecting partners whose distributional differences on the omitted modifiers would later compromise consistency.

Second: partner selection cannot rest on nABCD ranking alone. The required CATE sensitivity L-star that would translate a given nABCD into a clinically meaningful Delta-max varies markedly across partners and across candidate effect modifiers. The same nABCD value carries different clinical weight depending on the partner-specific distributional differences. R4, R6, and R13 emerged as leading candidates not solely because their nABCD values were low on both modifiers, but also because the corresponding L-star values fell within ranges that could be defended as clinically plausible.

Pooling judgments therefore require both distributional ranking and clinical calibration, applied across the full set of candidate effect modifiers.

**Key points to emphasize**:
- Implication 1: evaluate all candidate modifiers jointly
- Implication 2: nABCD ranking alone is insufficient — clinical calibration is required
- Both implications come directly from the GUSTO-I data, not from pre-commitment

---

## Slide 26: Strengths — Dual-Pathway Calibration

**Duration**: ~90 seconds

**Script**:

Two principal strengths follow from the dual-pathway calibration.

First: the framework adapts to where the trial sits on the spectrum of CATE sensitivity evidence. At the planning stage, where L is typically unavailable for novel agents, the L-star reverse calculation is the primary calibration tool. When L becomes available — from prior subgroup analyses, class-level meta-analyses, pharmacological reasoning — the Delta-max pathway provides a complementary calibration on the clinical scale. The framework does not impose a fixed nABCD cutoff, and it does not require L to function.

Second: nABCD's value as a distributional measure — capturing scale and skewness differences invisible to the standardized mean difference — holds regardless of whether L is available. Clinical calibration enhances the distributional assessment. It does not replace it. So even at the earliest planning stage, before any clinical sensitivity evidence exists, nABCD with its bootstrap CI delivers usable information about distributional similarity.

**Key points to emphasize**:
- Pathway adaptivity: planning vs confirmatory stages
- Distributional measure invariance: nABCD value persists with or without L
- "Enhances, not replaces" — clinical calibration is additive

---

## Slide 27: Practical Recommendations

**Duration**: ~90 seconds

**Script**:

Five steps.

Step one: compute nABCD with bootstrap CI for every candidate effect modifier across region pairs. Use n at least 100 per region for reliable estimation.

Step two: when L is estimable, translate nABCD into Delta-max with bootstrap CI on the clinical scale.

Step three: when L is unknown — typical at the planning stage — compute L-star at pre-specified Delta-clin values, comparing against clinical class evidence.

Step four: report alongside the overall treatment effect and the non-inferiority margin to support deliberation rather than binary decisions.

Step five: when multiple candidate effect modifiers are evaluated, sponsors may adopt a conservative approach based on the maximum Delta-max — or smallest L-star — across all modifiers and pairs. Alternatively, a totality-of-evidence approach in which the full collection, together with bootstrap uncertainty and the reliability of each L estimate, informs holistic judgment. The choice depends on regulatory context.

The framework is particularly relevant for regulatory submissions requiring regional subpopulation consistency. It also offers a distinctive policy advantage: nABCD requires only baseline distributions, so regional data can be assembled from prior trials, registries, electronic health records, or other RWE sources — increasingly relevant as regulatory agencies promote RWE use under ICH E6(R3).

**Key points to emphasize**:
- Five-step workflow that is reproducible
- Conservative versus totality-of-evidence options for multiple modifiers
- Policy advantage: compatibility with diverse data sources including RWE

---

## Slide 28: Limitations

**Duration**: ~75 seconds

**Script**:

The paper is explicit about limitations. Eight items, condensed here to the practical core.

Continuous effect modifiers only. Categorical extensions require further development. Each modifier evaluated separately — multivariate extensions are pending. Positive bias under the null and near-boundary scenarios — true nABCD below approximately 0.05 — inflates estimates and prevents nominal coverage; this is inherent to the non-negative parameter space. We use percentile bootstrap, which is first-order accurate; bias-corrected methods showed inferior performance for this bounded statistic. Clinical calibration requires L estimation — sponsor judgment is needed when L is unknown. The framework provides quantitative inputs but does not prescribe cutoffs. nABCD assesses similarity only with respect to measured effect modifiers — unmeasured heterogeneity drivers are out of scope. When L is carried forward from prior evidence, transferability is a clinical judgment that may benefit from sensitivity analysis. The GUSTO-I data are from 1990 to 1993; the application is methodological illustration, not an endorsement of those distributions as current references.

These are the precisely defined boundaries within which the framework operates.

**Key points to emphasize**:
- Continuous EMs, univariate, near-null bias — the three big methodological limits
- L transferability and unmeasured EMs — the clinical interpretation limits
- GUSTO-I era caveat: methodological illustration, not endorsement

---

## Slide 29: Future Work and Closing

**Duration**: ~75 seconds

**Script**:

Future work has three directions.

The current framework applies to continuous effect modifiers; extension to categorical effect modifiers is the first methodological challenge. The upstream identification of which baseline characteristics constitute relevant effect modifiers in a given trial is itself a non-trivial problem and deserves dedicated investigation — out of scope here, important next. Multivariate extensions for joint evaluation, and bias correction methods for small samples, complete the agenda.

The principal contribution of this paper is to supply a quantitative tool where one was previously absent. nABCD, combined with bootstrap confidence intervals and clinical calibration via Delta-max or L-star, transforms the previously qualitative judgment of "similar enough" into a reproducible, quantitative basis for sponsor judgment. That is what fills the methodological gap left by ICH E17 and enables evidence-based, clinically grounded pooling decisions.

The field has waited eight years for an answer to ICH E17's pooling question. This framework is the answer — rigorous, calibrated, and ready for use.

Thank you. I am happy to take your questions.

**Key points to emphasize**:
- Future work: categorical EMs, EM identification methodology, multivariate extensions
- Closing: previously qualitative → reproducible quantitative basis (the core message)
- Eight-year ICH E17 callback closes the loop from the introduction

---

*Master Script compiled by Donna Paulsen | 2026-03-03*
*Sources: act1_background_rachel.md, act2_methods_mike.md, act3_results_katrina.md, act4_framing_harvey.md*
