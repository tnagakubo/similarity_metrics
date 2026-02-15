# SEMD Practical Thresholds Proposal

## Issue 4 Resolution: "SEMD < ? means similar"

### Background

Dr. Whitfield (external review) raised a critical practical question: ICH E17 requires "similar enough" but SEMD produces a continuous value. Regulators need actionable thresholds.

### Proposed Threshold Framework

| SEMD Value | Category | ICH E17 Interpretation | Pooling Decision |
|------------|----------|------------------------|------------------|
| **< 0.10** | Very Similar | "Similar enough with respect to intrinsic/extrinsic factors" | **Pool without restriction** |
| **0.10 - 0.20** | Similar | Minor distributional differences | **Pool acceptable** |
| **0.20 - 0.35** | Moderate | Noticeable but not substantial differences | **Pool with sensitivity analysis** |
| **0.35 - 0.50** | Substantial | "Clinically relevant differences may exist" | **Separate analysis recommended** |
| **> 0.50** | Large | Distributions fundamentally different | **Do not pool** |

### Calibration Against Known Distributions

To give intuitive meaning to these thresholds:

| Comparison | True SEMD | Category |
|------------|-----------|----------|
| N(0,1) vs N(0,1) | 0.00 | Identical |
| N(0,1) vs N(0.2,1) | ~0.10 | Very Similar |
| N(0,1) vs N(0.5,1) | ~0.20 | Similar |
| N(0,1) vs N(0.8,1) | ~0.32 | Moderate |
| N(0,1) vs N(1.0,1) | ~0.38 | Substantial |
| N(0,1) vs N(0,1.5) | ~0.18 | Similar |
| N(0,1) vs N(0,2.0) | ~0.27 | Moderate |

### Relationship to Treatment Effect Heterogeneity

The key insight linking SEMD to treatment effect differences:

**Proposition**: If the effect modification function $g(x)$ represents log-hazard ratio modification, then:
$$|\text{Regional Effect Difference}| \leq \text{SEMD}$$

This provides an **upper bound interpretation**:
- SEMD < 0.10 → Regional treatment effects differ by at most 10% on log-HR scale
- SEMD < 0.20 → Regional treatment effects differ by at most 20% on log-HR scale

### ICH E17 Alignment

From ICH E17 Section 2.2.5:
> "Regions may be pooled for randomisation and/or analysis if subjects are thought to be **similar enough** with respect to intrinsic and/or extrinsic factors"

Our threshold proposal operationalizes "similar enough":
- **Similar enough** = SEMD < 0.20
- **Marginal** = SEMD 0.20-0.35 (requires justification)
- **Not similar enough** = SEMD > 0.35

### Regulatory Presentation

For regulatory submissions, we recommend:

1. **Primary Analysis**: Report SEMD point estimate with 95% CI
2. **Threshold Assessment**: State whether SEMD < 0.20 (or chosen threshold)
3. **Sensitivity**: If 0.10 < SEMD < 0.35, conduct sensitivity analysis with and without pooling
4. **Justification**: If pooling despite SEMD > 0.20, provide clinical rationale

### Example Statement for Regulatory Submission

> "The SEMD between Japanese and non-Japanese patients for [effect modifier] was 0.15 (95% CI: 0.08, 0.22). This falls below the pre-specified threshold of 0.20, indicating that the distributions of this effect modifier are sufficiently similar to support pooling of regional data for the primary efficacy analysis, consistent with ICH E17 guidance."

### Context-Dependent Thresholds (Tak's Critique)

**Key Insight**: A single threshold is insufficient. The clinical importance of the effect modifier should determine the strictness of the threshold.

| Clinical Importance | Examples | Recommended Threshold | Rationale |
|---------------------|----------|----------------------|-----------|
| **Critical** | CYP2D6 polymorphism, renal function, cardiac status | SEMD < **0.10** | Small distributional differences can cause large treatment effect variations |
| **Important** | Age, BMI, concomitant medications | SEMD < **0.15** | Moderate biological influence on drug response |
| **Moderate** | Smoking history, alcohol intake | SEMD < **0.20** | Limited direct pharmacological impact |
| **Minor** | Education level, income, urban/rural | SEMD < **0.30** | No direct biological mechanism |

**Determining Clinical Importance**:

1. **Expert Elicitation**: Clinical panel rates each effect modifier on 1-4 scale
2. **Data-Driven**: Use historical trial data to estimate treatment effect variability by factor
3. **Literature-Based**: RERI (Relative Excess Risk due to Interaction) from VanderWeele & Knol (2014)

**Recommendation**: Default threshold = **0.15** (conservative). Adjust based on specific effect modifier and regulatory discussion.

### Sample Size Requirements

KDE-based SEMD requires adequate sample size for reliable inference:

| Purpose | Minimum n per region | Rationale |
|---------|---------------------|-----------|
| Exploratory (point estimate only) | n ≥ **50** | KDE stability |
| Inference (Bootstrap CI) | n ≥ **100** | Coverage near nominal |
| High-precision inference | n ≥ **200** | SE(SEMD) < 0.05 |

**Phase III Context**: Most MRCTs achieve n ≥ 100 per major region, making SEMD feasible.

**Small Sample Alternatives** (n < 50):
1. Parametric approximation assuming normality
2. Empirical CDF-based SEMD (discrete version)
3. Bayesian approach with informative priors

### Limitations and Caveats

1. **Threshold choice is context-dependent**: The 0.15-0.20 threshold is a reasonable default but should be adjusted based on clinical importance of the effect modifier.

2. **Multiple effect modifiers**: When assessing multiple effect modifiers, consider:
   - Bonferroni-type adjustment for multiple comparisons
   - Maximum SEMD across modifiers as conservative summary

3. **g(x) specification matters**: Thresholds assume meaningful effect modification function. If g(x) = 1 (unweighted L₁ distance), interpretation is purely distributional.

4. **Sample size**: Ensure n ≥ 100 per region for reliable bootstrap inference.

---

*Prepared by Harvey Specter | 2026-02-02*
*Updated with context-dependent thresholds per Tak's critique | 2026-02-02 21:00*
*Issue 4 Resolution for External Review*
