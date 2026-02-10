# Chapter 5: Discussion

**Author**: Harvey Specter
**Date**: 2026-02-05
**Target**: Statistics in Medicine
**Word Count Target**: 600-800 words

---

## 5.1 Summary of Contributions

This paper addresses a methodological gap in the implementation of ICH E17 guidelines for multi-regional clinical trials. We developed and validated nABCD, a normalized metric for comparing effect modifier distributions across regions. Our contributions include:

1. **A principled metric**: nABCD combines the Wasserstein-1 distance with IQR normalization, capturing full distributional differences in a scale-free manner
2. **Theoretical foundation**: We established the connection between nABCD and potential treatment effect heterogeneity, providing a principled basis for regulatory decision-making
3. **Rigorous validation**: Simulation studies demonstrated satisfactory statistical properties at sample sizes typical in MRCT regional subgroups
4. **Practical guidance**: Interpretive benchmarks aligned with ICH E17 principles enable transparent communication between sponsors and regulators

## 5.2 Advantages over Existing Methods

The nABCD metric addresses limitations of current approaches to distributional comparison:

**Compared to standardized mean difference (SMD)**: While SMD is widely used for baseline covariate comparison, it captures only location differences. Our simulations demonstrated that SMD fails to detect differences in variance or shape—precisely the types of differences that may drive treatment effect heterogeneity. nABCD detected scale differences (S06) and shape differences (S08) where SMD showed no effect.

**Compared to Kolmogorov-Smirnov statistic**: The KS statistic lacks an interpretable scale for regulatory decision-making. nABCD's normalization by IQR provides intuitive benchmarks (negligible, small, moderate, large) that facilitate communication and pre-specification in statistical analysis plans.

**Compared to visual inspection**: Histogram or density comparisons are subjective and not reproducible. nABCD provides an objective, quantitative summary that can be pre-specified and audited.

## 5.3 Connection to Transportability

The nABCD metric connects to the broader literature on transportability and external validity in causal inference. When treatment effect heterogeneity exists, differences in effect modifier distributions between populations can lead to different average treatment effects, even under identical causal mechanisms.

Our theoretical result (Proposition 2) establishes that nABCD bounds the potential treatment effect difference attributable to EM distributional differences. This connection provides a principled interpretation: low nABCD implies that any observed heterogeneity is unlikely to be explained by EM distribution differences alone.

This framing aligns with regulatory interest in understanding *why* regional differences might occur and whether pooling assumptions are defensible.

## 5.4 Practical Recommendations

Based on our simulation results, we offer the following guidance for MRCT practitioners:

**Sample size**: We recommend n ≥ 100 per region for reliable point estimation and confidence intervals, and n ≥ 200 per region when formal hypothesis testing is required.

**Threshold selection**: The default threshold δ = 0.15 corresponds to "acceptably similar" distributions and implies bounded heterogeneity attributable to EM differences. Sponsors may adjust this threshold based on the clinical context and the importance of the specific effect modifier.

**Decision framework**:

| nABCD | 95% CI Upper | Recommendation |
|-------|--------------|----------------|
| < 0.10 | < 0.15 | Pool regions |
| 0.10 – 0.20 | < 0.25 | Pool with sensitivity analysis |
| > 0.20 | — | Separate analysis recommended |

**Multiple effect modifiers**: When multiple EMs are assessed, we recommend reporting nABCD for each and using clinical judgment to weight their importance. A formal multivariate extension is a direction for future research.

## 5.5 Limitations

Several limitations should be acknowledged:

1. **Continuous variables only**: The current formulation applies to continuous effect modifiers. Extension to categorical or mixed-type variables requires further development.

2. **Univariate comparison**: nABCD evaluates each EM separately. Joint distributional comparison across multiple correlated EMs is not addressed.

3. **Positive bias under null**: The nABCD estimator shows positive bias when distributions are identical, due to the non-negative nature of the Wasserstein distance. This inflates Type I error at small sample sizes and motivates our recommendation of n ≥ 200 for hypothesis testing.

4. **Bootstrap computation**: While computationally efficient, bootstrap confidence intervals require adequate sample sizes for validity. Alternative inference approaches (e.g., asymptotic methods) may be explored.

## 5.6 Conclusion

The nABCD metric fills a methodological gap in ICH E17 implementation by providing an objective, interpretable measure for comparing effect modifier distributions. By quantifying "similar enough," nABCD enables transparent documentation in regulatory submissions, pre-specification of pooling criteria, and principled sensitivity analyses.

We recommend nABCD as a complement to existing similarity assessments for supporting regional pooling decisions in multi-regional clinical trials. Open-source R code is available to facilitate adoption.

---

**Word count**: ~750 words

*Drafted by Harvey Specter | 2026-02-05*
