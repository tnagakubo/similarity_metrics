# Introduction: Regulatory Gap Section

**Author**: Rachel Zane
**Date**: 2026-02-03

---

## 1.2 The Regulatory Gap: Quantifying "Similar Enough"

### ICH E17 Framework

The ICH E17 guideline (2017) establishes the regulatory framework for multi-regional clinical trials, introducing the concept of regional pooling based on effect modifier distributions:

> "Regions may be pooled for randomisation and/or analysis if subjects are thought to be **similar enough** with respect to intrinsic and/or extrinsic factors relevant to the disease and/or drug under study." (ICH E17, Section 2.2.5)

The guideline further specifies that:

> "The pooling strategy should be justified based on the distribution of the intrinsic and extrinsic factors known to affect the treatment response."

### The Unmet Need

Despite this clear directive, ICH E17 provides **no quantitative methodology** for assessing distributional similarity. Sponsors and regulators are left without:

1. **A specific metric** for comparing effect modifier distributions across regions
2. **Interpretable thresholds** for determining "similar enough"
3. **Statistical inference procedures** for uncertainty quantification

Recent regulatory perspectives have highlighted this gap. Song et al. (2025), writing from the China NMPA perspective on ICH E17 implementation, note:

> "It is extremely challenging to identify the true EMs. When the true EMs cannot be identified, we choose instead the region pooling strategy to understand whether differences across East Asian population exists."

Their proposed decision flowchart for pooling strategy explicitly requires assessment of whether there is "evidence of differences" across populations—yet no quantitative criterion is provided.

### Current Practice and Its Limitations

In current practice, distributional similarity is often assessed through:

| Method | Limitation |
|--------|------------|
| Visual inspection (histograms, density plots) | Subjective, not reproducible |
| Standardized mean difference (SMD) | Captures only location, ignores scale/shape |
| Kolmogorov-Smirnov statistic | No interpretable scale, limited power |
| Informal expert judgment | Not transparent to regulators |

The standardized mean difference (SMD), while widely used for baseline covariate comparisons, fundamentally **cannot detect** differences in variance or distributional shape—precisely the types of differences that may drive treatment effect heterogeneity through effect modification.

### nABCD: Filling the Gap

The normalized Area Between Cumulative Distributions (nABCD) addresses this regulatory gap by providing:

1. **A principled metric** based on the Wasserstein-1 distance, capturing full distributional differences
2. **Scale-free normalization** via the interquartile range, enabling cross-variable comparison
3. **Interpretable benchmarks** aligned with regulatory decision-making:

| nABCD | Interpretation | Regulatory Implication |
|-------|----------------|------------------------|
| < 0.05 | Negligible difference | Strong support for pooling |
| 0.05 – 0.15 | Small difference | Pooling acceptable |
| 0.15 – 0.30 | Moderate difference | Pooling with sensitivity analysis |
| > 0.30 | Large difference | Separate analysis recommended |

4. **Bootstrap inference** for confidence intervals, providing the uncertainty quantification required for regulatory decision-making

### Positioning Statement

nABCD is not intended to replace clinical judgment or comprehensive benefit-risk assessment. Rather, it provides **an objective, reproducible component** of the evidence base supporting regional pooling decisions under ICH E17. By quantifying "similar enough," nABCD enables:

- **Transparent documentation** in regulatory submissions
- **Pre-specification** of pooling criteria in statistical analysis plans
- **Sensitivity analyses** exploring the impact of pooling assumptions

---

## References

ICH E17 Expert Working Group. (2017). General Principles for Planning and Design of Multi-Regional Clinical Trials (E17). International Council for Harmonisation.

Song, J., et al. (2025). Basic Considerations for Data Pooling Strategy in Multi-Regional Clinical Trials (MRCTs). *Therapeutic Innovation & Regulatory Science*, 59:359-364. DOI: [10.1007/s43441-025-00744-8](https://doi.org/10.1007/s43441-025-00744-8)

---

*Section drafted by Rachel Zane | 2026-02-03*
