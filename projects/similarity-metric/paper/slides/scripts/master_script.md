# nABCD Presentation — Master Speaker Script

**Total slides**: 29 (+ 5 section dividers = 34 pages)
**Estimated time**: ~36 minutes (target: compress to 25 min for JSM)
**Date**: 2026-03-03

| Act | Presenter | Slides | Time |
|-----|-----------|:------:|:----:|
| Opening | Harvey | 2 | ~1.5 min |
| Act 1: Background | Rachel | 4 | ~6.5 min |
| Act 2: Methods | Mike | 7 | ~14 min |
| Act 3: Simulation | Katrina | 4 | ~6 min |
| Act 4: Application | Katrina | 7 | ~9.5 min |
| Act 5: Discussion | Harvey | 5 | ~6 min |
| **Total** | | **29** | **~43.5 min** |

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

We begin with the regulatory gap — what ICH E17 requires and what it does not provide. We then develop the methodology: the heterogeneity bound, the nABCD definition, and clinical calibration through Delta-max. The simulation study follows, covering bias, coverage, and a direct comparison with the standardized mean difference. We then work through a Type 2 diabetes MRCT application, where the ranking of effect modifiers by distributional distance is reversed by clinical calibration. And we close with discussion — what we delivered, what remains, and what practitioners should do with this framework starting now.

Thirty-two slides. Let's move.

**Key points to emphasize**:
- Strictly functional — no motivational commentary
- "Ranking reversal" preview plants a hook for Section 4
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

The key concept is the **effect modifier** — a baseline characteristic where the treatment benefit differs systematically across subgroups. Mathematically, if we denote the conditional average treatment effect as tau of x, where x is the patient characteristic, then the *regional* average treatment effect is simply the integral of tau(x) against the distribution of x in that region.

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

I should also be clear about scope: our method is designed for **continuous effect modifiers**. Categorical or mixed-type EMs require different distance structures, and we note that as a direction for future work.

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

We have two regions. Each region has a patient population described by the distribution F_r of some baseline effect modifier — age, BMI, HbA1c, whatever the relevant characteristic is. The average treatment effect in region r is the integral of the CATE function tau(x) against that distribution. Even if the drug works identically at the individual level — tau(x) is the same everywhere — if the patient compositions F_1 and F_2 differ, the regional averages tau-bar_1 and tau-bar_2 can diverge.

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

The nABCD is W_1 divided by twice the pooled IQR. Each design choice here is deliberate.

Why normalize at all? W_1 is in the original units of the covariate — years for age, kilograms per square meter for BMI, percent for HbA1c. If you want to compare the degree of distributional difference across different effect modifiers in a single trial, you need a dimensionless number.

Why IQR and not standard deviation? Two reasons. First, IQR is robust to outliers and heavy tails — it measures the spread of the central 50% of the distribution. We reviewed the robustness literature, including Rousseeuw and Croux (1993) who established that Q_n has higher breakdown point than IQR, but Q_n is less familiar to clinical reviewers and the higher breakdown protection is not necessary for population-level regulatory data. IQR has the right balance of robustness and interpretability. Second, IQR is already familiar to clinicians.

Why factor of 2 in the denominator? With the factor of 2, when both distributions are normal and differ only in location by delta standard deviations, nABCD is approximately 0.37 times the standardized mean difference. This creates a useful calibration relationship with a metric practitioners already understand.

The resulting nABCD is dimensionless, always non-negative, and equals zero if and only if the two distributions are identical. And by substituting back into the heterogeneity bound, we get: Delta-max equals 2L times IQR times nABCD.

**Key points to emphasize**:
- Normalization needed for cross-EM comparability
- IQR: robust + familiar (Q_n has higher breakdown but unnecessary here)
- Factor of 2: calibrates nABCD ≈ 0.37 × SMD for normal location-shift

---

## Slide 12: Clinical Calibration: Δ_max

**Duration**: ~2 minutes

**Script**:

This is, in my view, the genuinely unique contribution of our framework. Every methodological choice we have made up to this point has been in service of this slide.

The question that regulators actually need to answer is not "are the distributions different?" — we can see from the baseline tables that they are always somewhat different. The question is "does the distributional difference matter for this drug in this disease?" And that requires translating from the covariate space into the outcome space.

Delta-max does exactly that. It is equal to 2L times IQR_pooled times nABCD, and it lives in the units of the clinical endpoint — percentage points of HbA1c reduction, millimeters of mercury for blood pressure, whatever the trial is measuring.

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

The point estimator is a Riemann sum of the empirical CDF differences, divided by twice the pooled empirical IQR. You sort all pooled observations, evaluate the jump in each empirical CDF at each order statistic, and sum the products of absolute CDF differences and interval widths. This runs in O(n log n) time after sorting.

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

We designed eight scenarios anchored to clinical reality. Scenarios S1 through S4 test pure location shifts — identical to the kind of mean differences you would capture with a standardized mean difference. S1 is the null: perfectly identical populations. S2 represents a small real-world gap, like age differences between the EU and US. S4 represents a large one — nearly one full standard deviation, like BMI between Japan and the United States.

Then we add what SMD cannot see. S5 tests a pure scale difference: same mean, 50% wider spread. S6 tests a shape shift to a skewed Gamma distribution, modeling lab values like eGFR. S7 models high-skew data with a log-normal, mimicking ALT with coefficient of variation around 53%. S8 combines location and scale shifts simultaneously.

Each scenario ran 10,000 replications at three sample sizes: 50, 100, and 200 per region. Bootstrap confidence intervals used 2,000 replications. The true nABCD values span from zero to 0.37, giving us a representative range of what practitioners would encounter in real MRCTs.

**Key points to emphasize**:
- S5, S6, S7 are the critical SMD-blind scenarios
- True nABCD range 0.000–0.372 covers the practical range
- 10,000 reps × 3 sample sizes × 8 scenarios = comprehensive evaluation

---

## Slide 15: Bias Results

**Duration**: ~1.5 minutes

**Script**:

Let's look at bias first. The general pattern is encouraging: as sample size increases, bias decreases toward zero for most scenarios.

At n=100, the most important threshold for practice, non-null scenarios excluding S4 all show bias below 0.02 in absolute terms. To put that in context, that is smaller than the width of a typical bootstrap confidence interval. For S3, S5, S7, and S8 — the practically relevant range — the estimator is essentially unbiased by n=100.

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

The headline result: at n≥100, coverage is between 0.87 and 0.98 across all eight scenarios. That is adequate for regulatory submissions.

S2, the small location shift with true nABCD of 0.07, shows coverage of only 0.67 at n=50 and 0.90 at n=100. This near-null behavior reflects the theoretical prediction from del Barrio's asymptotic theory: when distributions are very close, the Hadamard derivative becomes non-linear. Coverage recovers to nominal by n=200.

S4 shows the reverse problem: coverage degrades from 0.93 at n=50 to 0.73 at n=200. This reflects the persistent negative bias — as n grows, the confidence interval tightens around the biased estimate.

The standout performer is S7, the log-normal skew scenario: near-nominal coverage of 0.95 across all three sample sizes. Given that skewed lab values are the distributions where shape differences matter most clinically, this is the result that matters most for practice.

**Key points to emphasize**:
- At n≥100: coverage 0.87–0.98 — adequate for regulatory inference
- S7 achieves near-nominal even at n=50 — best practical news
- Recommendation: n≥100 per region

---

## Slide 17: nABCD vs SMD: Sensitivity Comparison

**Duration**: ~1.5 minutes

**Script**:

This slide is perhaps the most direct argument for why nABCD exists.

Look at S3: a half-standard-deviation location shift. Both nABCD and SMD detect it. SMD gives 0.50, nABCD gives 0.18. They disagree on magnitude because they measure different things. But at least both flag the scenario.

Now look at S5: a pure scale difference. The two populations have identical means but the spread in region 2 is 50% wider. SMD is 0.00. It sees nothing. nABCD is 0.14. It detects a clinically meaningful distributional gap.

S6 is a Gamma shape shift, same mean and approximately same spread. SMD is again 0.00. nABCD is 0.07.

S7 is the log-normal skew scenario. SMD is 0.00. nABCD is 0.31 — large. This is a high-skew distribution with CV of 53%. For a drug whose CATE function is non-linear, this level of shape difference could drive substantial regional heterogeneity. SMD would give you no warning.

The conclusion is structural. SMD is a summary of location. nABCD is a summary of the full distributional difference — the exact quantity that bounds treatment effect heterogeneity. For regulatory decision-making under ICH E17, SMD is insufficient.

**Key points to emphasize**:
- SMD = 0.00 for S5, S6, S7 — structurally blind, not a sampling artifact
- S7 is the most striking: nABCD = 0.31, SMD = 0.00
- nABCD captures the quantity that bounds heterogeneity; SMD does not

---

# ACT 4: APPLICATION — Katrina Bennett

---

## Slide 18: Type 2 Diabetes MRCT

**Duration**: ~1 minute

**Script**:

Now let us apply these ideas to a concrete MRCT scenario.

Consider a hypothetical three-region trial in type 2 diabetes: Japan with 150 patients, the US with 200, and the EU with 180. The primary endpoint is change in HbA1c at 24 weeks. The overall treatment effect is minus 0.8 percentage points. The non-inferiority margin is 0.4%.

Look at the baseline characteristics. The three effect modifiers we will analyze are age, BMI, and baseline HbA1c. The Japan-US contrast is immediately striking: mean BMI 24.8 in Japan versus 32.1 in the US — a gap of 7.3 kg/m². Mean baseline HbA1c 7.6 in Japan versus 8.4 in the US — a smaller gap of 0.8 percentage points.

The clinical question is: do these baseline differences matter for treatment effect comparability? This is exactly what nABCD and clinical calibration are designed to answer.

**Key points to emphasize**:
- Japan-US is the most divergent pair
- BMI gap looks large (7.3 kg/m²); HbA1c gap looks smaller (0.8%)
- NI margin of 0.4% is the clinical yardstick throughout

---

## Slide 19: Pairwise nABCD Values

**Duration**: ~1.5 minutes

**Script**:

Here are the pairwise nABCD values with 95% bootstrap confidence intervals.

The Japan-US comparison dominates. Age: 0.12 — small, well within the acceptable range. BMI: 0.51 — large, with a tight confidence interval from 0.44 to 0.58. HbA1c: 0.27 — moderate, interval from 0.20 to 0.34.

Now here is the question that motivates the next two slides. Looking at Japan versus the US, BMI has nABCD of 0.51 and HbA1c has nABCD of 0.27. On the nABCD scale alone, BMI looks like the larger concern. It is large by any benchmark. HbA1c is moderate.

But does a larger nABCD automatically mean a larger regulatory concern?

The answer is no. And the reason is that nABCD measures distributional distance — it does not yet account for how strongly each effect modifier actually influences the treatment effect. That is the role of the clinical calibration step. Let us see what happens when we bring in the CATE sensitivity parameter L.

**Key points to emphasize**:
- BMI nABCD = 0.51 (large); HbA1c nABCD = 0.27 (moderate)
- On nABCD alone, BMI looks like the primary concern
- Build anticipation: the answer involves L, and it reverses the ranking

---

## Slide 20: Clinical Calibration: Japan vs. US

**Duration**: ~1.5 minutes

**Script**:

Now we apply the clinical calibration formula. Delta-max equals two times L times IQR-pooled times nABCD.

For Age: nABCD is 0.12, but L is 0.01 — age has almost no influence on treatment effect for this drug class. Delta-max comes out to 0.03%. Negligible. Well under 10% of the non-inferiority margin.

For BMI: nABCD is 0.51 — the largest in the table. But L is 0.02. BMI is a weak effect modifier. Even with the enormous distributional gap, Delta-max is only 0.16%. That is 40% of the non-inferiority margin. Below the threshold of clinical concern.

For HbA1c: nABCD is 0.27 — smaller than BMI. But L is 0.30. Baseline HbA1c is a strong predictor of treatment response to glucose-lowering therapy. Delta-max is 0.24%. That is 30% of the overall treatment effect, and 60% of the non-inferiority margin.

So the ranking has reversed. The variable that looked smaller by nABCD — HbA1c — produces the larger Delta-max. The variable that looked largest — BMI — turns out to be the lesser concern.

**Key points to emphasize**:
- Age: Δ_max = 0.03% — negligible
- BMI: nABCD = 0.51 but L = 0.02 → Δ_max = 0.16% — manageable
- HbA1c: nABCD = 0.27 but L = 0.30 → Δ_max = 0.24% — 60% of margin
- The reversal is caused entirely by L

---

## Slide 21: Key Insight: Same nABCD, Different Impact

**Duration**: ~1 minute

**Script**:

Let me make this contrast explicit.

BMI has nABCD of 0.51 and L of 0.02. The distribution of BMI is dramatically different between Japan and the US. But for this drug class, BMI has almost no causal influence on how much the treatment works. The large distributional gap multiplies against a near-zero sensitivity, and the result is a Delta-max of only 0.16%.

HbA1c has nABCD of 0.27 and L of 0.30. The distribution is moderately different. But baseline HbA1c is the defining predictor of glycemic treatment response. A moderate distributional gap multiplied by a large sensitivity yields Delta-max of 0.24% — 60% of the non-inferiority margin.

This is the core message. The clinical meaning of nABCD is not intrinsic to the number. It depends entirely on the treatment context — specifically, how sensitively the drug's effect responds to that particular characteristic. nABCD is necessary for the assessment, but L is the translation key.

**Key points to emphasize**:
- Two dimensions: distributional distance × CATE sensitivity
- Delta-max is the clinically interpretable quantity; nABCD alone is not sufficient
- This is by design, matching ICH E17's context-dependent philosophy

---

## Slide 22: Why the Ranking Reverses

**Duration**: ~2 minutes

**Script**:

Let us slow down and understand the mechanism, because it has important implications.

L is a multiplier. It is the Lipschitz constant of the conditional average treatment effect function — roughly speaking, how many units of treatment effect change per unit change in the effect modifier. A large L means the drug is highly sensitive to that characteristic. A small L means relatively insensitive.

For BMI: the physical gap between Japan and the US is enormous. Average BMI of 24.8 versus 32.1. The nABCD of 0.51 reflects not just this location difference but also the difference in spread and shape. By any distributional measure, Japan and the US are very different on BMI. But the L for BMI here is 0.02 — meaning that for every 1 kg/m² difference in BMI, the treatment effect changes by only 0.02 percentage points. Multiply 0.51 times 0.02 times the IQR, and the clinical signal is small.

For HbA1c: the distributional gap is moderate — nABCD of 0.27. The mean difference is only 0.8%. But the L of 0.30 tells us that for every 1% difference in baseline HbA1c, the expected treatment effect changes by 0.30%. That is a strong sensitivity. Despite the smaller nABCD, the clinical consequence is larger.

The breakeven point is when Delta-max equals the non-inferiority margin. For HbA1c with nABCD of 0.27 and IQR of 1.5%, that breakeven — L-star — occurs at 0.49. Below that value, pooling is compatible with the non-inferiority criterion. Above it, caution is warranted.

**Key points to emphasize**:
- L is the multiplier: large L means the drug "cares about" that characteristic
- BMI: huge gap × tiny L = small impact
- HbA1c: moderate gap × large L = the primary concern
- L* = 0.49 is the breakeven — interpretable and communicable

---

## Slide 23: Sensitivity Analysis: HbA1c (Japan vs. US)

**Duration**: ~1.5 minutes

**Script**:

Because L is estimated — not known precisely — we present a sensitivity table showing Delta-max as a function of L for HbA1c Japan versus the US.

nABCD is fixed at 0.27 and IQR at 1.5% for all rows.

At L equals 0.10, Delta-max is 0.08%, just 10% of the treatment effect. No concern. At L equals 0.20, Delta-max is 0.16%, still well below the margin. At our point estimate of L equals 0.30, Delta-max is 0.24%.

As L increases to 0.40, Delta-max reaches 0.32% — 80% of the non-inferiority margin. At L equals 0.50, Delta-max is 0.41%, which exceeds the 0.4% margin.

The breakeven is at L-star equals 0.49. This is the answer to the regulator's question: "At what level of CATE sensitivity does the Japan-US HbA1c difference become incompatible with pooling under the non-inferiority criterion?"

The answer is 0.49. Whether L actually reaches that level is a scientific question that prior data and pharmacological reasoning can inform. The framework does not answer that question for the regulator — it provides the exact context in which they need to answer it.

**Key points to emphasize**:
- L* = 0.49: the breakeven where Δ_max equals the NI margin
- The table is transparent: regulators can substitute their own L estimate
- Sensitivity analysis as a communication tool, not just a robustness check

---

## Slide 24: Estimation, Not Testing

**Duration**: ~1.5 minutes

**Script**:

I want to close the results section with an explanation of why we deliberately chose estimation over hypothesis testing.

There are three specific reasons.

First, ICH E17 explicitly avoids binary rules on similarity. The guideline says similarity is context-dependent. A single threshold cannot serve all diseases, all drug classes, and all regulatory contexts simultaneously. An estimation framework naturally accommodates this.

Second, L is uncertain. A test result collapses all of this uncertainty into a p-value, hiding the fact that the conclusion could change substantially if L were different. The sensitivity table makes that uncertainty explicit and visible.

Third, the decision boundary is context-specific. A non-inferiority trial with margin 0.4% and a superiority trial with expected effect 0.8% face fundamentally different clinical stakes — even with identical nABCD values. Estimation, by reporting Delta-max against the clinical margin, handles this naturally. Testing cannot.

The recommended reporting is: nABCD with 95% confidence interval, Delta-max with 95% confidence interval, and the full sensitivity range. Regulatory judgment informed by evidence — not ruled by algorithm.

**Key points to emphasize**:
- Testing = binary; estimation = quantified + uncertainty-aware
- ICH E17's context-dependence is incompatible with universal test thresholds
- Same nABCD, different implications in NI vs superiority trials

---

# ACT 5: DISCUSSION — Harvey Specter

---

## Slide 25: Four Contributions

**Duration**: ~90 seconds

**Script**:

Let me be direct about what this paper delivers. Four things.

First: full distributional comparison. The standardized mean difference is blind to variance and shape. In three of our simulation scenarios — pure scale, gamma shape, log-normal skew — SMD returns exactly zero. nABCD, grounded in the Wasserstein-1 distance, captures location, scale, and shape in a single number. That is not a refinement of SMD. It is a replacement.

Second: scale-free estimation. The IQR normalization means nABCD is dimensionless — you can compare BMI against HbA1c against age in the same framework, with bootstrap confidence intervals reliable at n=100 and above.

Third: clinical calibration. This is the contribution that changes the conversation. nABCD alone tells you how different the distributions are. Delta-max tells you what that difference means for treatment effects — in the same units as your primary endpoint, measured against your non-inferiority margin.

Fourth: sensitivity analysis. Because L is not always known precisely, the framework naturally accommodates that uncertainty. You answer the question: at what value of L does this distributional difference begin to matter?

Four contributions. Each stands on its own. Together they operationalize what ICH E17 has been asking for since 2017.

**Key points to emphasize**:
- "Replacement, not refinement" for SMD — position at the frontier
- Clinical calibration is the contribution that changes the conversation
- ICH E17 callback closes the loop from the introduction

---

## Slide 26: Recommendations for Practitioners

**Duration**: ~90 seconds

**Script**:

This is the practical section. What do you actually do with this framework?

Five steps.

Step one: compute nABCD with bootstrap confidence intervals for each candidate effect modifier. You need at least 100 observations per region. Below that, positive bias is material and confidence intervals are not trustworthy.

Step two: do not stop at the nABCD value. Translate it. Use the Delta-max formula to put the distributional difference on your clinical scale. A large nABCD is not inherently alarming. A large Delta-max relative to your non-inferiority margin is.

Step three: report Delta-max and its confidence interval alongside your treatment effect and clinical margins. This is what belongs in your submission package.

Step four: run sensitivity analyses across a plausible range of L values. Identify the breakeven L*. That number is the anchor for your regulatory argument.

Step five: use the reference benchmarks only when you cannot estimate L from prior data. The benchmarks are a fallback, not a first choice.

The bottom line: on Monday morning, pick your most important effect modifiers, compute their nABCD values, and run the Delta-max calibration. You will know more about your pooling decision in two hours than you would from a week of visual inspection.

**Key points to emphasize**:
- Five-step workflow they can reproduce
- "Monday morning" framing makes it immediately actionable
- Benchmarks are a fallback, not the primary tool

---

## Slide 27: Reference Benchmarks

**Duration**: ~75 seconds

**Script**:

Now about those benchmarks.

The table — negligible below 0.05, small up to 0.15, moderate up to 0.30, large above 0.30 — these are reference points, not thresholds. This distinction is not a disclaimer. It is the core design principle.

Here is why a fixed threshold would be wrong. Take the BMI example. Japan versus the US: nABCD equals 0.51 — by any benchmark, that is large, alarming, a reason to pause pooling. But BMI is a weak effect modifier. When you apply Delta-max with L equal to 0.02, the implied treatment effect difference is 0.16 percent — less than half the margin. There is no clinical concern.

A fixed threshold rule would have generated a false alarm. Delta-max tells the truth.

The hierarchy is this: Delta-max first, always. Benchmarks only when Delta-max cannot be computed.

**Key points to emphasize**:
- Benchmarks are references, not thresholds — core design principle
- BMI reversal example is the strongest illustration
- "Delta-max first, always" — memorable one-liner

---

## Slide 28: Limitations and Future Work

**Duration**: ~75 seconds

**Script**:

We will be honest about the boundaries of this work, because knowing them precisely is what enables the next step.

Three limitations that matter in practice.

First: continuous effect modifiers only. The Wasserstein-1 framework requires continuous distributions. Categorical covariates need a different distance. That extension is tractable and is the first item on the research agenda.

Second: univariate evaluation. We assess each effect modifier independently. A multivariate distributional comparison would capture joint structure that pairwise analysis misses. Multivariate Wasserstein distances exist and are computationally feasible — this is the natural generalization.

Third: positive bias at small n under the null. The bias is material below n equals 100. Bias correction methods for bounded statistics are directly applicable.

None of these are fatal. They are precisely defined. And precisely defined limitations are the raw material for the next set of results.

The field has waited eight years for a quantitative answer to ICH E17's pooling question. This framework provides a rigorous foundation for that answer, and an explicit map of what remains.

**Key points to emphasize**:
- "Precisely defined boundaries" — intellectual honesty without apology
- "Eight years" callback to ICH E17 (2017)
- Forward-looking: limitations = research map

---

## Slide 29: Thank You

**Duration**: ~45 seconds

**Script**:

Let me leave you with one sentence.

nABCD measures the distance between effect modifier distributions and translates that distance into clinical scale — an estimation-centered framework that closes the implementation gap ICH E17 left open.

That is what this is. Not a test. Not a binary verdict. A measurement, calibrated to the problem at hand.

The R package is open source. The methodology is fully reproducible. If you work on multi-regional trials — as a biostatistician, a regulatory scientist, or a clinical pharmacologist — this framework is ready to use.

Thank you. I am happy to take your questions.

**Key points to emphasize**:
- One sentence. Say it slowly. Let it land.
- "Not a test. Not a binary verdict. A measurement." — three-part rhythm
- Open source call to action is the last thing before questions

---

*Master Script compiled by Donna Paulsen | 2026-03-03*
*Sources: act1_background_rachel.md, act2_methods_mike.md, act3_results_katrina.md, act4_framing_harvey.md*
