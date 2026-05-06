# Act 2: Methods — Speaker Scripts
**Presenter**: Mike Ross (Methodologist)
**Section**: 2. Methods (Slides 6–12 of full deck)
**Audience**: JSM / ISCB — statisticians with clinical trials background
**Total estimated time**: ~14 minutes

---

## Slide: The Heterogeneity Bound

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
- W_1 appears because of K-R duality — this is not a design choice but a mathematical necessity
- L is the CATE Lipschitz constant: how fast can the individual treatment effect change as the baseline covariate changes?
- The bound can be evaluated from pre-trial baseline data alone

---

## Slide: Derivation: Three Steps

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
- Step 1 is a geometric fact: W_1 = area between CDFs
- Step 2 is the K-R duality: W_1 = supremum of expectation differences over 1-Lipschitz functions — this is an exact equality, not an inequality
- Step 3 is just normalization: tau(x)/L is a valid 1-Lipschitz function to substitute
- The proof completes in three lines; the intellectual content is entirely in the K-R duality
- This derivation is from first principles — no heuristics, no approximations

---

## Slide: Why W₁ — And Only W₁

**Duration**: ~2 minutes

**Script**:

Now I want to directly address the question you might be thinking: why not W_2, which is more commonly used in optimal transport theory? Or KL divergence, which is popular in machine learning? Could we have built this framework around a different distance?

The answer is no — and it is not a matter of taste. It is a mathematical necessity.

Look at the table on the slide. W_1 satisfies K-R duality, meaning it admits the Lipschitz supremum representation. W_2 does not. The dual representation of W_2 involves convex functions, not Lipschitz functions. A convex function can change arbitrarily fast in regions where the data does not live — so you cannot bound the CATE integral using W_2 without additional structural assumptions that we are not willing to impose. The heterogeneity bound simply does not exist in the W_2 case.

KL divergence fails for two independent reasons. First, it is asymmetric: the divergence from F_1 to F_2 is not the same as from F_2 to F_1, which creates an arbitrary directional choice that has no clinical justification. Second, and more practically, KL divergence diverges to infinity whenever the empirical supports do not fully overlap — which happens routinely in finite trial samples. A metric that is infinite for perfectly reasonable data configurations is not a usable clinical tool.

Total variation distance does have a Lipschitz-type dual, but only for bounded functions. That gives a weaker bound, and it throws away geometric information about how far apart the distributions are in the covariate space.

So W_1 is not the most fashionable choice or our personal preference. It is the unique distance that enables the heterogeneity bound through K-R duality. That uniqueness is the foundation the entire nABCD framework is built on.

**Key points to emphasize**:
- W_2 dual involves convex functions, not Lipschitz — so it cannot bound CATE integrals directly
- KL divergence is asymmetric AND can diverge to infinity with non-overlapping supports — both are fatal flaws for regulatory use
- W_1 is not a preference: it is the unique choice with the K-R Lipschitz duality that enables the bound
- The phrase "W_1 — and only W_1" is the correct framing; alternatives are not suboptimal, they are simply incompatible with this derivation

---

## Slide: The Bound Is Tight, Not Loose

**Duration**: ~1.5 minutes

**Script**:

I want to preempt what I expect will be the most natural statistical objection to this framework: "You are using an upper bound. Isn't that inherently conservative? Doesn't the true treatment effect difference almost always end up much smaller than your bound suggests?"

The objection is understandable, but I want to be precise about what it would mean for the bound to be "loose."

There are two separate questions here. First: is the mathematical bound itself tight? Second: will the bound be binding in any particular application?

On the first question — yes, the bound is mathematically tight. By the K-R duality, there exists a 1-Lipschitz function that actually achieves the supremum. In other words, for the bound |tau-bar_1 - tau-bar_2| ≤ L times W_1 to hold with equality, there needs to exist a CATE function with Lipschitz constant exactly L whose integral difference between the two distributions achieves W_1. Such a function exists — it is not a hypothetical. So the bound is not a rough approximation. It is the tightest possible statement you can make given only the information that tau is L-Lipschitz.

On the second question — whether the CATE in a specific trial achieves the worst case — that depends on the actual biology. For most drugs, the true CATE is smoother than its Lipschitz constant might suggest. This is why we recommend sensitivity analysis over L rather than treating Delta-max as a point prediction.

But — and this is crucial for the regulatory context — the appropriate error to guard against in pooling decisions is the false positive: treating distinct populations as equivalent when they are not. An upper bound that guarantees the worst-case scenario, rather than a central estimate that might be wrong half the time, is exactly the right tool for that purpose.

**Key points to emphasize**:
- The bound is mathematically tight: a CATE function achieving equality exists by K-R construction
- "Tight" means optimal given only Lipschitz smoothness — not loose in any mathematical sense
- Whether it is binding in practice depends on biology, which is why sensitivity analysis over L is recommended
- For regulatory purposes, an upper bound on a safety-relevant quantity is the correct inferential object

---

## Slide: nABCD Definition

**Duration**: ~2 minutes

**Script**:

Now that we have the bound, let me show you the normalized statistic we actually compute and report.

The nABCD is W_1 divided by the pooled IQR. Each design choice here is deliberate.

Why normalize at all? W_1 is in the original units of the covariate — years for age, kilograms per square meter for BMI, percent for HbA1c. If you want to compare the degree of distributional difference across different effect modifiers in a single trial, or across trials in different disease areas, you need a dimensionless number. Normalization by a spread measure gives you that.

Why IQR and not standard deviation? Two reasons. First, IQR is robust to outliers and heavy tails — it measures the spread of the central 50% of the distribution. In clinical populations where extreme values are common, this matters. We reviewed the robustness literature, including Rousseeuw and Croux (1993) who established that Q_n has higher breakdown point than IQR, but Q_n is less familiar to clinical reviewers and the higher breakdown protection is not necessary for population-level regulatory data. IQR has the right balance of robustness and interpretability. Second, IQR is already familiar to clinicians — they think in terms of the interquartile range routinely.

Why divide by IQR (without an extra factor)? This calibrates nABCD so that a one-IQR pure location shift yields nABCD = 1.0 — a direct and intuitive scale anchor for clinical reviewers.

The resulting nABCD is dimensionless, always non-negative, and equals zero if and only if the two distributions are identical. And by substituting W_1 = IQR times nABCD back into the heterogeneity bound, we get the clean form: Delta-max equals L times IQR times nABCD.

**Key points to emphasize**:
- Normalization is necessary to compare across effect modifiers with different units
- IQR chosen for interpretability and robustness; Q_n has higher breakdown but is unnecessary and less familiar for this context
- Calibration: 1-IQR location shift yields nABCD = 1.0
- The definition makes nABCD the natural unit for expressing regulatory similarity

---

## Slide: Clinical Calibration: Δ_max

**Duration**: ~2 minutes

**Script**:

This is, in my view, the genuinely unique contribution of our framework. Every methodological choice we have made up to this point has been in service of this slide.

The question that regulators and clinical teams actually need to answer is not "are the distributions different?" — we can see from the baseline tables that they are always somewhat different. The question is "does the distributional difference matter for this drug in this disease?" And that requires translating from the covariate space into the outcome space.

Delta-max does exactly that. It is equal to L times IQR_pooled times nABCD, and it lives in the units of the clinical endpoint — percentage points of HbA1c reduction, millimeters of mercury for blood pressure, whatever the trial is measuring.

The procedure has five steps. First, compute nABCD with bootstrap confidence intervals for each candidate effect modifier — and I will say more about the bootstrap in a moment. Second, estimate L from prior knowledge: published subgroup analyses, dose-response data, meta-analyses, or pharmacokinetic reasoning about why the drug's effect would vary with this particular covariate. Third, compute Delta-max and propagate the confidence interval from nABCD linearly through. Fourth, compare Delta-max against clinically meaningful thresholds — the overall treatment effect, the non-inferiority margin, a minimum clinically important difference. Fifth, conduct sensitivity analysis over a plausible range of L values, particularly when L is uncertain.

That fifth step is important. If you cannot pin down L precisely, you can instead compute the "breakeven L*" — the value of L at which Delta-max would equal your clinical threshold of concern. Then you ask the medical question: do we think the CATE in this patient population could change at that rate? This reframes an abstract statistical question as a clinical judgment call, which is exactly where regulatory deliberation should sit.

**Key points to emphasize**:
- Delta-max is in outcome units — this is the bridge from abstract distributional distance to clinical meaning
- The five-step procedure is practical and implementable with standard data available at trial design
- Sensitivity analysis over L is not an afterthought — it is a core part of the framework for handling L uncertainty
- Breakeven L* converts the problem into a clinical judgment question, which is appropriate for regulatory contexts

---

## Slide: Estimation and Inference

**Duration**: ~1.5 minutes

**Script**:

Let me now describe how we compute nABCD and attach an uncertainty interval to it.

The point estimator is a Riemann sum of the empirical CDF differences, divided by the pooled empirical IQR. You sort all pooled observations, evaluate the jump in each empirical CDF at each order statistic, and sum the products of absolute CDF differences and interval widths. This converges to the true W_1 and runs in O(n_1 + n_2) log time after sorting.

For inference, we use the percentile bootstrap with B equals 2,000 resamples. I want to be explicit about why we chose the percentile bootstrap over BCa — the bias-corrected and accelerated bootstrap. BCa applies an acceleration correction that is designed for statistics with standard-normal limiting distributions. But nABCD is bounded below at zero, and near the null where both distributions are nearly identical, the sampling distribution of the estimator is right-skewed. BCa overcorrects in this regime, producing systematically too-wide intervals. The percentile bootstrap, despite having less theoretical sophistication, outperforms BCa for bounded statistics near the boundary in simulation. This is documented in our simulation results.

The asymptotic theory supporting bootstrap consistency comes from del Barrio, Cuesta-Albertos, and Matran (1999), who established that W_1, viewed as the L_1 distance between empirical CDFs, converges at root-n rate to a Brownian bridge functional. The key distinction is: when F_1 and F_2 are genuinely different, the Hadamard derivative of the functional is linear, and the standard bootstrap is consistent. When the distributions are nearly identical — the near-null case — the derivative becomes non-linear, and some undercoverage of nominally 95% intervals is possible. Our simulations confirm modest undercoverage at small n when the true nABCD is close to zero, which is why we recommend n of at least 100 per region for reliable inference.

With those theoretical foundations in place, let me now show you what the simulations reveal about finite-sample performance.

**Key points to emphasize**:
- Point estimator is a Riemann sum of empirical CDF differences — O(n log n), no distributional assumptions
- Percentile bootstrap outperforms BCa for this bounded statistic near the null boundary
- del Barrio et al. (1999) provides the asymptotic justification: root-n CLT via Brownian bridge
- Near-null undercoverage is expected from theory and confirmed in simulation; n ≥ 100 per region recommendation follows from this
- [Transition] "Let us now look at exactly how the estimator and confidence intervals perform in the eight simulation scenarios we designed to cover the range of clinical situations you might encounter."

---

*End of Act 2 — Methods scripts*
*Next: `act3_simulation_katrina.md`*
