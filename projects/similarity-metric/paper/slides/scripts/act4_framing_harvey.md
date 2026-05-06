# Act 4: Framing & Opening/Closing
## Speaker Scripts — Harvey Specter
### JSM/ISCB Level Academic Presentation

> These scripts cover the Title slide, Outline, Discussion section (Section 5), and the End slide.
> They are designed to be delivered with authority and economy of language.
> Total target: 7–8 minutes across these slides, contributing to a 25–30 minute talk.

---

## Slide: Title — nABCD: Quantifying Effect Modifier Similarity for Regional Pooling in Multi-Regional Clinical Trials

**Duration**: ~60 seconds

**Script**:

Every year, sponsors invest hundreds of millions of dollars pooling data across regions in multi-regional clinical trials. And every year, the same question arises in regulatory review rooms: are these populations similar enough to pool?

That question has existed since ICH E17 was published in 2017. What has not existed — until now — is a principled, quantitative answer.

We have been working with visual inspection, with standardized mean differences that ignore variance and shape, and with goodness-of-fit statistics that give you a p-value but nothing you can put on a clinical scale. None of these tell you what regulators actually need to know: if these populations differ in their effect modifier distributions, what is the worst-case impact on treatment effect estimates?

This paper introduces nABCD — a normalized, Wasserstein-based coefficient for distributional comparison — built from first principles to answer exactly that question.

**Key points to emphasize**:
- Open with the regulatory stakes, not the statistics. Establish that this is a real, costly, unresolved problem.
- The phrase "principled, quantitative answer" signals that what follows is not incremental — it is a solution.
- End the hook before going to the outline. Do not preview results here.

---

## Slide: Outline

**Duration**: ~30 seconds

**Script**:

Here is the architecture of the talk.

We begin with the regulatory gap — what ICH E17 requires and what it does not provide. We then develop the methodology: the heterogeneity bound, the nABCD definition, and clinical calibration through Delta-max. The simulation study follows, covering bias, coverage, and a direct comparison with the standardized mean difference. We then work through a Type 2 diabetes MRCT application, where the ranking of effect modifiers by distributional distance is reversed by clinical calibration. And we close with discussion — what we delivered, what remains, and what practitioners should do with this framework starting now.

Thirty-two slides. Let's move.

**Key points to emphasize**:
- Keep this strictly functional. The audience does not need motivational commentary at the outline stage.
- "Let's move" signals pace and confidence — this is not a slow-moving methodological exercise.
- The phrase "ranking reversal" in the application preview plants a hook that pays off in Section 4.

---

## Slide: Four Contributions

**Duration**: ~90 seconds

**Script**:

Let me be direct about what this paper delivers. Four things.

First: full distributional comparison. The standardized mean difference is blind to variance and shape. In three of our simulation scenarios — pure scale difference, gamma-distributed shape difference, log-normal skew — SMD returns exactly zero. It detects nothing. nABCD, grounded in the Wasserstein-1 distance, captures location, scale, and shape in a single number. That is not a refinement of SMD. It is a replacement.

Second: scale-free estimation. The IQR normalization means nABCD is dimensionless — you can compare BMI against HbA1c against age in the same framework, on the same scale, with bootstrap confidence intervals that are reliable at sample sizes of 100 per region and above.

Third: clinical calibration. This is the contribution that changes the conversation. nABCD alone tells you how different the distributions are. Delta-max tells you what that difference means for treatment effects — in the same units as your primary endpoint, measured against your non-inferiority margin. That is what a regulatory scientist needs in a review meeting.

Fourth: sensitivity analysis. Because the CATE sensitivity parameter L is not always known precisely, the framework naturally accommodates that uncertainty. You do not commit to a single number. You answer the question: at what value of L does this distributional difference begin to matter? That is a more honest and more informative answer than any binary test can provide.

Four contributions. Each stands on its own. Together they operationalize what ICH E17 has been asking for since 2017.

**Key points to emphasize**:
- Enumerate with authority. Do not hedge ("we hope," "we believe").
- The "replacement, not refinement" framing for SMD is important — position this work at the frontier, not as a modest addition.
- End with the explicit ICH E17 callback to close the loop opened in the introduction.

---

## Slide: Recommendations for Practitioners

**Duration**: ~90 seconds

**Script**:

This is the practical section. What do you actually do with this framework?

Five steps.

Step one: compute nABCD with bootstrap confidence intervals for each candidate effect modifier. You need at least 100 observations per region for reliable coverage. Below that, positive bias is material and confidence intervals are not trustworthy. Plan your sample sizes accordingly.

Step two: do not stop at the nABCD value. Translate it. Use the Delta-max formula — L times the pooled IQR times nABCD — to put the distributional difference on your clinical scale. A large nABCD is not inherently alarming. A large Delta-max relative to your non-inferiority margin is.

Step three: report Delta-max and its confidence interval alongside your treatment effect and clinical margins. This is what belongs in your submission package, in your clinical study report, in your regulatory briefing document.

Step four: run sensitivity analyses across a plausible range of L values. Identify the break-even L — the value at which Delta-max first exceeds your clinical margin. That number is the anchor for your regulatory argument.

Step five: use the reference benchmarks only when you cannot estimate L from prior data or subgroup analyses. The benchmarks are a fallback, not a first choice. I will say more about them on the next slide.

The bottom line: on Monday morning, pick your most important effect modifiers, compute their nABCD values, and run the Delta-max calibration. You will know more about your pooling decision in two hours than you would from a week of visual inspection.

**Key points to emphasize**:
- "Step one through five" structure is deliberate — give the audience a workflow they can reproduce.
- The "Monday morning" framing makes this immediately actionable, not academic.
- The preview of the benchmarks slide creates continuity.

---

## Slide: Reference Benchmarks

**Duration**: ~75 seconds

**Script**:

Now about those benchmarks.

The table you see — negligible below 0.10, small up to 0.30, moderate up to 0.60, large above 0.60 — these are reference points, not thresholds. This distinction is not a disclaimer. It is the core design principle.

Here is why a fixed threshold would be wrong. Take the BMI example from our application. Japan versus the US: nABCD equals 1.02 — by any benchmark table, that is large, alarming, a reason to pause pooling. But BMI is a weak effect modifier for this drug class. When you apply Delta-max with L equal to 0.02, the implied treatment effect difference is 0.16 percent — less than half the non-inferiority margin. There is no clinical concern.

A fixed threshold rule would have generated a false alarm. Delta-max tells the truth.

The benchmarks assume moderate CATE sensitivity. They are appropriate for exploratory, screening-level assessments when L data are unavailable. They are not a substitute for calibration when L can be estimated.

The hierarchy is this: Delta-max first, always. Benchmarks only when Delta-max cannot be computed.

And one more thing: ICH E17 itself avoids binary rules for good reason. The guideline says similarity is context-dependent. Our framework is designed to respect that. These benchmarks are the one concession to convenience in an otherwise calibration-first methodology — and they should be used with that awareness.

**Key points to emphasize**:
- Inoculate against misuse up front — audiences remember the warning at the slide, not a footnote in the paper.
- The BMI reversal example is the strongest available illustration. Use it.
- The hierarchy ("Delta-max first, always") is a memorable one-liner for this slide.

---

## Slide: Limitations and Future Work

**Duration**: ~75 seconds

**Script**:

We will be honest about the boundaries of this work, because knowing them precisely is what enables the next step.

Three limitations that matter in practice.

First: continuous effect modifiers only. The Wasserstein-1 framework as developed here requires continuous distributions. Categorical covariates — treatment-by-region interaction indicators, binary comorbidity flags — need a different distance. That extension is tractable and is the first item on the research agenda.

Second: univariate evaluation. We assess each effect modifier independently. In practice, effect modifiers can be correlated, and a multivariate distributional comparison would capture joint distributional structure that pairwise analysis misses. Multivariate Wasserstein distances exist and are computationally feasible — this is the natural generalization.

Third: positive bias at small n under the null. When distributions are identical, the empirical estimator is upward biased at small samples. This is a known property of Wasserstein estimators. The bias is material below n equals 100, which is why that is our recommended minimum. Bias correction methods for bounded statistics are an active area and are directly applicable here.

None of these are fatal. They are precisely defined. And precisely defined limitations are the raw material for the next set of results.

The field has waited eight years for a quantitative answer to ICH E17's pooling question. This framework provides a rigorous foundation for that answer, and an explicit map of what remains.

**Key points to emphasize**:
- Reframe limitations as "precisely defined boundaries" — this signals intellectual honesty without apology.
- Three, not four. The fourth point on L estimation belongs in Delta-max discussion, not here.
- The "eight years" callback to ICH E17's 2017 publication reinforces the contribution's significance.
- End with a forward-looking statement, not a list of problems.

---

## Slide: Thank You

**Duration**: ~45 seconds

**Script**:

Let me leave you with one sentence.

nABCD measures the distance between effect modifier distributions and translates that distance into clinical scale — an estimation-centered framework that closes the implementation gap ICH E17 left open.

That is what this is. Not a test. Not a binary verdict. A measurement, calibrated to the problem at hand.

The R package is open source. The methodology is fully reproducible. If you work on multi-regional trials — as a biostatistician, a regulatory scientist, or a clinical pharmacologist — this framework is ready to use.

Thank you. I am happy to take your questions.

**Key points to emphasize**:
- One sentence. Say it slowly and clearly. Let it land.
- "Not a test. Not a binary verdict. A measurement." — three-part rhythm for emphasis and recall.
- The call to action (open source, reproducible) is the last thing before questions — make it easy for people to follow up.
- Do not summarize the whole talk. The audience was there.
