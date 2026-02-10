# Rousseeuw & Croux 1993 - Alternatives to the Median Absolute Deviation

## Citation
Rousseeuw, P.J. & Croux, C. (1993) "Alternatives to the Median Absolute Deviation" *Journal of the American Statistical Association*, 88(424):1273-1283.
DOI: [10.1080/01621459.1993.10476408](https://doi.org/10.1080/01621459.1993.10476408)

## Summary

This paper proposes robust alternatives to the Median Absolute Deviation (MAD) for scale estimation. The authors introduce two new scale estimators, $S_n$ and $Q_n$, that have higher efficiency than MAD while maintaining high breakdown point. These estimators are particularly relevant for nABCD as alternatives to IQR for robust normalization.

## Key Contributions

1. **New scale estimators**: $S_n$ and $Q_n$ with 50% breakdown point
2. **Higher efficiency**: $S_n$ has 58% efficiency, $Q_n$ has 82% efficiency (vs MAD's 37%)
3. **Explicit algorithms**: $O(n \log n)$ computation
4. **Robustness analysis**: Influence functions and breakdown points

## Methods

### Median Absolute Deviation (MAD)
$$\text{MAD} = b \cdot \text{med}_i |x_i - \text{med}_j(x_j)|$$

where $b = 1.4826$ for consistency at normal distribution.

- **Breakdown point**: 50% (highest possible)
- **Gaussian efficiency**: Only 37%
- **Problem**: Low efficiency means large variance

### The $S_n$ Estimator
$$S_n = c \cdot \text{med}_i \{\text{med}_j |x_i - x_j|\}$$

where $c = 1.1926$ for consistency at normal distribution.

- **Breakdown point**: 50%
- **Gaussian efficiency**: 58%
- **Computation**: $O(n \log n)$

### The $Q_n$ Estimator
$$Q_n = d \cdot \{|x_i - x_j|; i < j\}_{(k)}$$

where $k = \binom{h}{2} \approx \binom{n/2+1}{2}$ and $d = 2.2219$.

This is the $k$-th order statistic of all pairwise distances.

- **Breakdown point**: 50%
- **Gaussian efficiency**: 82% (much higher!)
- **Computation**: $O(n \log n)$

### Interquartile Range (IQR)
$$\text{IQR} = Q_{0.75} - Q_{0.25}$$

For normal: $\text{IQR} = 1.349 \cdot \sigma$

- **Breakdown point**: 25%
- **Gaussian efficiency**: 37%

## Comparison Table

| Estimator | Breakdown | Efficiency | Complexity |
|-----------|-----------|------------|------------|
| SD | 0% | 100% | $O(n)$ |
| IQR | 25% | 37% | $O(n)$ |
| MAD | 50% | 37% | $O(n)$ |
| $S_n$ | 50% | 58% | $O(n \log n)$ |
| $Q_n$ | 50% | 82% | $O(n \log n)$ |

## Relevance to nABCD

### Current nABCD Definition
$$\text{nABCD} = \frac{W_1(F, G)}{2 \cdot \text{IQR}_{\text{pooled}}}$$

### Potential Improvement
Using $Q_n$ instead of IQR for normalization:
$$\text{nABCD}_{Q_n} = \frac{W_1(F, G)}{2 \cdot Q_{n,\text{pooled}}}$$

**Advantages**:
1. Higher breakdown (50% vs 25%)
2. Higher efficiency (82% vs 37%)
3. Better small-sample performance

### Considerations
1. **Interpretability**: IQR has intuitive meaning ("middle 50%")
2. **Tradition**: IQR widely used in clinical research
3. **Computation**: $Q_n$ slightly more complex
4. **Calibration**: Thresholds would need recalibration

### Recommendation
For nABCD paper:
- **Primary**: Keep IQR (interpretability, tradition)
- **Sensitivity analysis**: Report $Q_n$-normalized version
- **Future work**: Systematic comparison of normalizers

## Key Equations

### Influence Function for $Q_n$
The influence function at the normal distribution is bounded and smooth, ensuring robustness.

### Asymptotic Variance
At normal distribution:
- $\text{Var}(\text{IQR}) / \sigma^2 \approx 2.70 / n$
- $\text{Var}(Q_n) / \sigma^2 \approx 1.22 / n$

So $Q_n$ has variance about 2.2× smaller than IQR.

## Implementation

R code for $Q_n$:
```r
Qn <- function(x) {
  n <- length(x)
  h <- floor(n/2) + 1
  k <- choose(h, 2)
  diffs <- outer(x, x, function(a, b) abs(a - b))
  diffs <- diffs[lower.tri(diffs)]
  2.2219 * sort(diffs)[k]
}
```

(Note: `robustbase::Qn()` provides optimized implementation)

## Tags
robust statistics, scale estimation, breakdown point, efficiency, MAD, IQR, Qn estimator, nABCD normalization

---
*Processed by Rachel Zane | 2026-02-02*
*Priority: P3 - Alternative normalization for nABCD*
