# Chapter 2: Methods

**Authors**: Mike Ross, Rachel Zane
**Date**: 2026-02-05
**Target**: Statistics in Medicine
**Word Count Target**: 1,500-2,000 words

---

## 2.1 Effect Modifiers and Regional Treatment Effects

An effect modifier (EM) is a baseline patient characteristic for which the treatment effect varies across subgroups. Formally, let the conditional average treatment effect (CATE) be denoted as a function of the effect modifier value. When this function is non-constant, the average treatment effect observed in any region depends on the distribution of the EM in that region.

Consider a simple example: if age modifies treatment effect such that younger patients benefit more, then a region with a younger patient population will observe a larger average treatment effect than a region with an older population, even if the drug mechanism is identical. This relationship motivates ICH E17's emphasis on EM distributional similarity as a basis for regional pooling decisions.

To formalize this intuition, let the CATE function be bounded with Lipschitz constant L. The difference in regional average treatment effects can be bounded by:

$$|\bar{\tau}_1 - \bar{\tau}_2| \leq L \cdot W_1(F_1, F_2)$$

where $W_1(F_1, F_2)$ denotes the Wasserstein-1 distance between EM distributions in regions 1 and 2. This bound establishes that distributional differences in EMs, as measured by the Wasserstein distance, directly constrain the potential for treatment effect heterogeneity across regions.

## 2.2 The Wasserstein-1 Distance

The Wasserstein-1 distance (also known as the Earth Mover's Distance) between two cumulative distribution functions F and G is defined as:

$$W_1(F, G) = \int_{-\infty}^{\infty} |F(x) - G(x)| \, dx$$

Geometrically, this equals the total area between the two CDFs. The Wasserstein distance has several desirable properties for comparing distributions:

1. **Metric properties**: Non-negativity, symmetry, and triangle inequality
2. **Full distributional comparison**: Captures differences in location, scale, and shape simultaneously
3. **Interpretability**: Represents the minimum "work" required to transform one distribution into another
4. **Sensitivity**: Detects differences that may be missed by moment-based comparisons

Unlike the standardized mean difference (SMD), which only measures location shifts, the Wasserstein distance responds to changes in variance, skewness, and other distributional features.

## 2.3 Definition of nABCD

The **normalized Area Between Cumulative Distributions (nABCD)** is defined as the Wasserstein-1 distance normalized by twice the pooled interquartile range:

$$\text{nABCD}(F_1, F_2) = \frac{W_1(F_1, F_2)}{2 \cdot \text{IQR}_{\text{pooled}}}$$

where the pooled IQR is computed as:

$$\text{IQR}_{\text{pooled}} = Q_{0.75}^{\text{pooled}} - Q_{0.25}^{\text{pooled}}$$

with pooled quantiles computed from the combined sample.

### Rationale for Normalization

The IQR-based normalization serves three purposes:

1. **Scale-free interpretation**: Enables comparison across EMs measured on different scales (e.g., age in years vs. biomarker in ng/mL)
2. **Robustness**: IQR is resistant to outliers, unlike standard deviation
3. **Interpretability**: nABCD expresses distributional differences in units of spread

The factor of 2 in the denominator ensures that when comparing two uniform distributions differing by one IQR in location, nABCD equals 0.5.

### Theoretical Properties

**Proposition 1** (Boundedness). For distributions with finite IQR, nABCD is non-negative. For distributions with non-overlapping supports separated by at least the pooled IQR, nABCD ≥ 0.5.

**Proposition 2** (Connection to heterogeneity). If the CATE function has Lipschitz constant L, then:

$$|\bar{\tau}_1 - \bar{\tau}_2| \leq 2L \cdot \text{IQR}_{\text{pooled}} \cdot \text{nABCD}(F_1, F_2)$$

This bound relates nABCD directly to the maximum possible treatment effect heterogeneity attributable to EM distributional differences.

## 2.4 Estimation

### Point Estimation

Given samples from two regions, nABCD is estimated using empirical distribution functions. Let the combined sorted values from both samples be denoted with corresponding empirical CDFs. The estimator is:

$$\widehat{\text{nABCD}} = \frac{\sum_{j=1}^{n_1+n_2-1} |\hat{F}_1(x_{(j)}) - \hat{F}_2(x_{(j)})| \cdot (x_{(j+1)} - x_{(j)})}{2 \cdot \widehat{\text{IQR}}_{\text{pooled}}}$$

where the numerator computes the area between the empirical CDFs using the trapezoidal rule.

**Computational complexity**: O((n₁ + n₂) log(n₁ + n₂)), dominated by sorting.

### Bootstrap Confidence Intervals

We employ the nonparametric percentile bootstrap for inference:

**Algorithm 1** (Bootstrap CI for nABCD)
```
Input: Samples X₁ (n₁ observations) and X₂ (n₂ observations), B replicates
Output: 95% confidence interval for nABCD

For b = 1 to B:
    1. Resample n₁ observations with replacement from X₁ → X₁*
    2. Resample n₂ observations with replacement from X₂ → X₂*
    3. Compute nABCD*(b) from resampled data
End

Return [2.5th percentile, 97.5th percentile] of {nABCD*(1), ..., nABCD*(B)}
```

We recommend B = 2000 for stable interval estimates.

### Asymptotic Properties

Under standard regularity conditions (finite first moments, continuous distributions), the bootstrap procedure is consistent. The effective sample size for the two-sample problem is n_eff = n₁n₂/(n₁+n₂), implying:

$$\text{SE}(\widehat{\text{nABCD}}) = O\left(\sqrt{\frac{1}{n_{\text{eff}}}}\right)$$

For balanced designs with n observations per region, this yields SE = O(1/√n).

## 2.5 Hypothesis Testing

For regulatory applications, we propose testing practical equivalence rather than exact equality. The null hypothesis of meaningful difference is:

$$H_0: \text{nABCD} \geq \delta \quad \text{vs.} \quad H_1: \text{nABCD} < \delta$$

where δ is a pre-specified threshold for practical significance.

**Decision rule**: Reject H₀ (conclude distributions are similar) if the upper bound of the 95% CI for nABCD falls below δ.

### Recommended Threshold

Based on the heterogeneity bound (Proposition 2) and regulatory considerations, we recommend δ = 0.15 as the default threshold for "acceptably similar" distributions. This value implies:

- Maximum heterogeneity attributable to EM differences: bounded by 0.3 × L × IQR_pooled
- For typical effect sizes and CATE slopes, this represents clinically acceptable variation

## 2.6 Interpretive Guidelines

To facilitate regulatory communication, we propose the following benchmark interpretation:

| nABCD Range | Interpretation | Pooling Recommendation |
|-------------|----------------|------------------------|
| < 0.05 | Negligible difference | Strong support for pooling |
| 0.05 – 0.15 | Small difference | Pooling acceptable |
| 0.15 – 0.30 | Moderate difference | Consider with sensitivity analysis |
| > 0.30 | Large difference | Separate analysis recommended |

These benchmarks are calibrated to the heterogeneity bound and align with the practical significance threshold δ = 0.15.

---

## References

1. Villani C. *Optimal Transport: Old and New*. Springer; 2009.

2. Panaretos VM, Zemel Y. Statistical aspects of Wasserstein distances. *Annu Rev Stat Appl*. 2019;6:405-431.

3. del Barrio E, Giné E, Matrán C. Central limit theorems for the Wasserstein distance between the empirical and the true distributions. *Ann Probab*. 1999;27(2):1009-1071.

4. Sommerfeld M, Munk A. Inference for empirical Wasserstein distances on finite spaces. *J R Stat Soc Series B*. 2018;80(1):219-238.

5. Pearl J, Bareinboim E. Transportability of causal and statistical relations: A formal approach. *Proc AAAI Conf Artif Intell*. 2011;25(1):247-254.

---

**Word count**: ~1,400 words

*Drafted by Mike Ross with literature support from Rachel Zane | 2026-02-05*
