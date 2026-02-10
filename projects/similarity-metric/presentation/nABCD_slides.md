# nABCD: A Scale-Free Metric for Comparing Effect Modifier Distributions in MRCTs

**Presentation Slides**
**Author**: Mike Ross
**Date**: 2026-02-05

---

## Slide 1: Title

# nABCD
## A Normalized Metric for Comparing Effect Modifier Distributions in Multi-Regional Clinical Trials

*Supporting ICH E17 Regional Pooling Decisions*

---

## Slide 2: The Problem

### ICH E17 Says "Similar Enough" — But How Similar?

> "Regions may be pooled if subjects are thought to be **similar enough** with respect to intrinsic and/or extrinsic factors..."
> — ICH E17 (2017)

**The Gap**:
- No quantitative metric specified
- No threshold for "similar enough"
- No statistical inference procedure

**Current Practice**:
| Method | Limitation |
|--------|------------|
| Visual inspection | Subjective |
| SMD | Location only |
| KS statistic | No interpretable scale |

---

## Slide 3: Why Does This Matter?

### Effect Modifiers Drive Regional Heterogeneity

**[FIGURE 1: Conceptual diagram]**

```
Region A: Younger patients → Higher response
Region B: Older patients → Lower response
         ↓
Same drug, different average effects
```

**Key Insight**: Even if the drug works identically, different patient compositions lead to different regional outcomes.

---

## Slide 4: Our Solution — nABCD

### Normalized Area Between Cumulative Distributions

**[FIGURE 2: Visual definition of nABCD]**

```
        1.0 |     ___-------
            |    /   Shaded area
CDF     0.5 |   /    = W₁ distance
            |  /___----
        0.0 |______________
              x values
```

$$\text{nABCD} = \frac{\text{Area between CDFs}}{2 \times \text{IQR}_{\text{pooled}}}$$

**Interpretation**: Distributional difference in units of spread

---

## Slide 5: Why nABCD?

### Four Key Advantages

| Feature | nABCD | SMD | KS |
|---------|-------|-----|-----|
| Full distribution | ✓ | ✗ | ✓ |
| Scale-free | ✓ | ✓ | ✗ |
| Interpretable | ✓ | ✓ | ✗ |
| Detects scale diff | ✓ | ✗ | ✓ |

**Bottom line**: nABCD combines the best of both worlds

---

## Slide 6: Interpretive Benchmarks

### Practical Guidelines for Decision-Making

| nABCD | Interpretation | Action |
|-------|----------------|--------|
| < 0.05 | Negligible | Pool |
| 0.05–0.15 | Small | Pool |
| 0.15–0.30 | Moderate | Pool + Sensitivity |
| > 0.30 | Large | Separate analysis |

**Threshold δ = 0.15**: Boundary of "acceptably similar"

---

## Slide 7: Simulation Results — Bias

### Point Estimation Performance

**[FIGURE 3: Bias by sample size]**

| Scenario | n=50 | n=100 | n=200 |
|----------|------|-------|-------|
| Location 0.5σ | 0.002 | 0.000 | -0.006 |
| Scale 1.5× | 0.003 | -0.015 | -0.018 |
| Shape diff | 0.025 | 0.000 | -0.015 |

**Key Finding**: Bias < 0.02 at n ≥ 100

---

## Slide 8: Simulation Results — Power

### Detection Capability

**[FIGURE 4: Power curves]**

| True nABCD | n=100 Power |
|------------|-------------|
| 0.074 | 33% |
| 0.186 | 97% |
| 0.372 | 100% |

**Key Finding**: Power > 97% for nABCD ≥ 0.15 at n = 100

---

## Slide 9: nABCD vs SMD

### The Critical Difference

**[FIGURE 5: Scale difference scenario]**

```
Scenario: Same mean, different variance
- SMD = 0 (no location shift)
- nABCD = 0.15 (detects scale difference!)
```

| Scenario | nABCD | SMD |
|----------|-------|-----|
| Location shift | ✓ | ✓ |
| Scale difference | ✓ | ✗ |
| Shape difference | ✓ | ✗ |

---

## Slide 10: Application Example

### Hypothetical Type 2 Diabetes MRCT

**Regions**: Japan (n=150), US (n=200), EU (n=180)

**[FIGURE 6: BMI distributions by region]**

| Effect Modifier | Japan vs US | Interpretation |
|-----------------|-------------|----------------|
| Age | 0.12 | Similar ✓ |
| **BMI** | **0.51** | **Different** ✗ |
| HbA1c | 0.27 | Borderline |

**Decision**: Pool US+EU; Japan separate for BMI-modifying drugs

---

## Slide 11: Practical Recommendations

### Sample Size Guidelines

| Purpose | Minimum n per region |
|---------|---------------------|
| Point estimation | ≥ 100 |
| Hypothesis testing | ≥ 200 |

### Decision Framework

```
If nABCD < 0.15 and CI upper < 0.20 → Pool
If nABCD 0.15-0.30 → Pool with sensitivity
If nABCD > 0.30 → Separate analysis
```

---

## Slide 12: Limitations

### What nABCD Cannot Do (Yet)

1. **Continuous only**: No categorical EMs
2. **Univariate**: Each EM evaluated separately
3. **Positive bias at null**: Need n ≥ 200 for testing
4. **Threshold choice**: δ = 0.15 requires clinical judgment

**Future Work**: Multivariate extension, categorical support

---

## Slide 13: Summary

### nABCD Fills the ICH E17 Gap

✓ **Principled**: Based on Wasserstein distance
✓ **Interpretable**: Scale-free, benchmark guidelines
✓ **Validated**: Simulation studies confirm properties
✓ **Practical**: R code available

> "When they say 'similar enough', now we can measure it."

---

## Slide 14: Take-Home Messages

1. **SMD is not enough** — misses scale and shape differences
2. **nABCD captures full distributional differences** in interpretable units
3. **Use n ≥ 100** for reliable inference
4. **Threshold 0.15** separates "similar" from "different"
5. **Transparent documentation** for regulatory submissions

---

## Slide 15: Thank You

### Questions?

**R Package**: `nABCD` (coming soon)
**Contact**: [author emails]

---

## Appendix Slides

### A1: Mathematical Definition

$$\text{nABCD}(F_1, F_2) = \frac{W_1(F_1, F_2)}{2 \cdot \text{IQR}_{\text{pooled}}}$$

where

$$W_1(F_1, F_2) = \int_{-\infty}^{\infty} |F_1(x) - F_2(x)| \, dx$$

### A2: Bootstrap Algorithm

```r
nABCD_bootstrap <- function(x1, x2, B = 2000) {
  boot_vals <- replicate(B, {
    x1_star <- sample(x1, replace = TRUE)
    x2_star <- sample(x2, replace = TRUE)
    compute_nABCD(x1_star, x2_star)
  })
  quantile(boot_vals, c(0.025, 0.975))
}
```

### A3: Heterogeneity Bound

If CATE function has Lipschitz constant L:

$$|\bar{\tau}_1 - \bar{\tau}_2| \leq 2L \cdot \text{IQR} \cdot \text{nABCD}$$

---

## Figure Specifications (for Katrina)

### Figure 1: Conceptual Diagram
- Effect modification concept
- Regional patient composition → different outcomes

### Figure 2: nABCD Visual Definition
- Two CDFs with shaded area between them
- Annotation showing W₁ = area

### Figure 3: Bias by Sample Size
- Bar chart or line plot
- x-axis: sample size (50, 100, 200)
- y-axis: bias
- Grouped by scenario

### Figure 4: Power Curves
- Line plot
- x-axis: true nABCD
- y-axis: power
- Lines for different sample sizes

### Figure 5: SMD vs nABCD Comparison
- Side-by-side density plots
- Same mean, different variance
- Showing SMD=0 but nABCD>0

### Figure 6: BMI Distribution Example
- Density plots for Japan, US, EU
- Clear visual separation

---

*Slides prepared by Mike Ross | 2026-02-05*
