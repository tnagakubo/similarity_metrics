---
marp: true
size: 16:9
paginate: true
header: "2026"
footer: "nABCD: Effect Modifier Similarity for MRCTs"
style: |
  /* ============================================
     Marp Slide Template
     - Accent Color 1: #1E3A5F (Deep Navy)
     - Accent Color 2: #199be6
     ============================================ */

  @import url('https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@100..900&display=swap');

  :root {
    --accent1: #D52B1E;
    --accent2: #d47e78;
    --text-main: #000000;
    --text-light: #505050;
    --bg-light: #E8ECF0;
    --bw: 10px;
    --footer-space: 24px;
  }

  /* ---- Base slide ---- */
  section {
    font-family: 'Noto Sans JP', sans-serif;
    color: var(--text-main);
    border: none;
    padding: 90px 60px 46px 60px;
    font-size: 22px;
    line-height: 1.3;
    position: relative;
    background-color: white;
    background-image:
      linear-gradient(var(--accent1), var(--accent1)),
      linear-gradient(var(--accent1), var(--accent1)),
      linear-gradient(var(--accent1), var(--accent1)),
      linear-gradient(var(--accent1), var(--accent1));
    background-position:
      0 0,
      0 0,
      100% 0,
      0 calc(100% - var(--footer-space));
    background-size:
      100% var(--bw),
      var(--bw) calc(100% - var(--footer-space)),
      var(--bw) calc(100% - var(--footer-space)),
      100% var(--bw);
    background-repeat: no-repeat;
  }

  section::before {
    display: none;
  }

  section h1 {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    box-sizing: border-box;
    background: var(--accent1);
    color: white;
    font-size: 44px;
    font-weight: 700;
    padding: 18px 60px 14px;
    margin: 0;
    line-height: 1.4;
    z-index: 2;
  }

  section h2 {
    color: var(--accent1);
    font-size: 36px;
    font-weight: 700;
    border-bottom: 3px solid var(--accent2);
    padding-bottom: 6px;
    margin-bottom: 20px;
  }

  section h3 {
    color: var(--accent2);
    font-size: 28px;
    font-weight: 700;
  }

  header {
    font-family: 'Noto Sans JP', sans-serif;
    position: absolute;
    top: auto;
    bottom: 4px;
    left: 20px;
    right: auto;
    font-size: 14px;
    color: var(--text-light);
    letter-spacing: 0.02em;
    z-index: 2;
  }

  footer {
    font-family: 'Noto Sans JP', sans-serif;
    position: absolute;
    top: auto;
    bottom: 4px;
    left: 0;
    right: 0;
    width: 100%;
    font-size: 14px;
    color: var(--text-light);
    text-align: center;
    letter-spacing: 0.02em;
    z-index: 2;
  }

  section::after {
    font-family: 'Noto Sans JP', sans-serif;
    position: absolute;
    bottom: 4px;
    right: 20px;
    top: auto;
    left: auto;
    width: auto;
    height: auto;
    font-size: 14px;
    color: var(--text-light);
    background: none;
    padding: 0;
    text-align: right;
    z-index: 2;
  }

  section strong {
    color: var(--accent2);
    font-weight: 700;
  }

  section ul, section ol {
    line-height: 1.4;
    margin-left: 10px;
  }

  section li {
    line-height: 1.4;
    margin-bottom: 4px;
  }

  section p {
    line-height: 1.3;
  }

  section li::marker {
    color: var(--accent1);
  }

  section table {
    border-collapse: collapse;
    width: 100%;
    font-size: 26px;
    margin: 16px 0;
  }

  section table th {
    background: var(--accent1);
    color: white;
    font-weight: 700;
    padding: 10px 16px;
    text-align: left;
  }

  section table td {
    padding: 8px 16px;
    border-bottom: 1px solid #E0E0E0;
  }

  section table tr:nth-child(even) td {
    background: var(--bg-light);
  }

  section code {
    font-size: 24px;
    background: var(--bg-light);
    border: 1px solid #E0E0E0;
    border-radius: 4px;
    padding: 2px 6px;
  }

  section pre {
    background: #1E1E2E;
    border-radius: 8px;
    padding: 20px;
    border-left: 4px solid var(--accent2);
  }

  section pre code {
    background: none;
    border: none;
    color: #CDD6F4;
    font-size: 22px;
    padding: 0;
  }

  section blockquote {
    border-left: 4px solid var(--accent2);
    padding: 12px 20px;
    margin: 16px 0;
    background: var(--bg-light);
    font-style: italic;
    color: var(--text-light);
  }

  section img {
    max-height: 60%;
    border-radius: 4px;
    display: block;
    margin: 0 auto;
  }

  /* ---- Density variants (per-slide override) ---- */
  section.compact { font-size: 18px; }
  section.relaxed { font-size: 26px; }

  /* ---- Beamer-style block (generic callout) ---- */
  section .block {
    margin: 12px 0 0 0;
    border-radius: 6px;
    overflow: hidden;
    border: 1px solid #E0E0E0;
  }

  section .block + p,
  section .block + .block {
    margin-top: 0;
  }

  section .block-title {
    background: var(--accent2);
    color: white;
    padding: 6px 14px;
    font-weight: 700;
    font-size: 22px;
  }

  section .block-body {
    padding: 8px 14px;
    background: var(--bg-light);
  }

  section .block-body > *:first-child {
    margin-top: 0;
  }

  section .block-body > *:last-child {
    margin-bottom: 0;
  }

  /* ---- Title slide ---- */
  section.title {
    background: var(--accent1);
    color: white;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: flex-start;
    text-align: left;
    padding: 60px;
  }

  section.title h1 {
    position: static;
    background: transparent;
    color: white;
    font-size: 86px;
    font-weight: 900;
    margin: 0 0 20px 0;
    padding: 0;
    line-height: 1.3;
    border: none;
  }

  section.title h2 {
    font-size: 68px;
    font-weight: 400;
    border: none;
    margin: 0 0 40px 0;
    padding: 0;
  }

  section.title p {
    font-size: 42px;
    margin: 4px 0;
    align-self: flex-end;
  }

  section.title::before {
    display: none;
  }

  section.title header,
  section.title footer {
    display: none;
  }

  section.title::after {
    display: none;
  }

  /* ---- Section divider ---- */
  section.section {
    background: var(--accent1);
    color: white;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: flex-start;
    text-align: left;
    padding: 60px;
  }

  section.section h1 {
    position: static;
    background: transparent;
    color: white;
    font-size: 72px;
    margin: 0;
    padding: 0 0 16px 0;
    border-bottom: 4px solid var(--accent2);
  }

  section.section h2 {
    font-size: 60px;
    font-weight: 400;
    border: none;
  }

  section.section header,
  section.section footer {
    display: none;
  }

  section.section::after {
    display: none;
  }

  /* ---- Two-column layout ---- */
  section.cols {
    display: grid;
    grid-template-columns: 1fr 1fr;
    grid-template-rows: 1fr;
    gap: 0 40px;
  }

  section.cols h1 {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    box-sizing: border-box;
  }

  /* ---- End slide ---- */
  section.end {
    background: var(--accent1);
    color: white;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    text-align: center;
  }

  section.end h1 {
    position: static;
    background: transparent;
    color: white;
    font-size: 48px;
    margin: 0;
    padding: 0;
  }

  section.end p {
    color: rgba(255, 255, 255, 0.7);
    font-size: 26px;
  }

  section.end::before {
    display: none;
  }

  section.end header,
  section.end footer {
    display: none;
  }

  section.end::after {
    display: none;
  }

---

<!-- _class: title -->
<!-- _paginate: false -->

# Quantifying Effect Modifier Similarity for Regional Pooling in Multi-Regional Clinical Trials

##

Tak Nagakubo

---

# Agenda

1. **Introduction**: Regional pooling, methodological gap, and our aim
2. **Methods**: nABCD definition, theoretical foundation, and clinical calibration
3. **Simulation**: Estimation performance across 7 scenarios
4. **Application**: Hypothetical thrombolytic MRCT using GUSTO-I
5. **Discussion**: Key findings and practical recommendations

---

<!-- _class: section -->

# Introduction

---

# Regional Pooling: A Practical Challenge

### Why pooling is needed

- MRCTs assess treatment effect consistency across regions
- Individual regional sample sizes are often too small alone
- ICH E17 strategy: pool regions with similar **effect modifier** distributions
  (effect modifier = baseline characteristic for which treatment benefit differs across subgroups)
- This paper focuses on **continuous effect modifiers** (e.g., age, baseline severity, laboratory values)

### The challenge for sponsors

- At the **planning stage**, sponsors must select pooling partners with evidence that two regions are "similar enough"

<div class="block">
<div class="block-title">Cautionary example: Secukinumab MRCT (Matsushima 2024)</div>
<div class="block-body">

Unassessed regional imbalance in CRP+/MRI- status → apparent treatment effect inconsistency at analysis.

</div>
</div>

---

# Methodological Gap and Research Objectives

### The gap

- ICH E17 provides no specific metric, threshold, or procedure for "similar enough"
- The standard tool for **continuous covariates** is the Standardized Mean Difference (SMD), which is **blind** to differences in variance and shape
- → No quantitative evidence base for partner selection

### Objectives

- Develop a quantitative index that captures distributional similarity beyond means
- Deliver a practitioner-facing tool for the **planning stage** of an MRCT

---

<!-- _class: section -->

# Methods

---

# Existing Approaches and Their Limitations

<div class="block">
<div class="block-title">SMD — blind to variance and shape</div>
<div class="block-body">

Mean difference / pooled SD. $N(50, 5^2)$ vs $N(50, 15^2)$ → SMD = 0 despite a 3× difference in spread.

</div>
</div>

<div class="block">
<div class="block-title">Kolmogorov–Smirnov — no link to treatment effects</div>
<div class="block-body">

$\sup_x |F_1(x) - F_2(x)|$ captures full shape, but no theoretical bridge to clinical scale.

</div>
</div>

<div class="block">
<div class="block-title">KL divergence — asymmetric, can diverge</div>
<div class="block-body">

$\int p \log(p/q)\,dx$ requires density estimation; diverges with non-overlapping supports.

</div>
</div>

### Three requirements

1. **Beyond location** (variance, shape)
2. **Clinically interpretable scale**
3. **Theoretical link to treatment effect heterogeneity**

---

# Defining nABCD: Wasserstein-1 over IQR

<div class="block">
<div class="block-title">Wasserstein-1 distance</div>
<div class="block-body">

The total area between two CDFs — captures differences in **location, variance, and shape**.

$$
W_1(F, G) = \int |F(x) - G(x)| \, dx
$$

</div>
</div>

<div class="block">
<div class="block-title">nABCD: scale-free dissimilarity</div>
<div class="block-body">

Normalized by the pooled IQR — a one-IQR location shift yields nABCD = 1.0.

$$
\text{nABCD}(F_1, F_2) = \frac{W_1(F_1, F_2)}{\text{IQR}_{\text{pooled}}}
$$

</div>
</div>

![h:250px](../../figures/fig1_nabcd_definition_color.png)

---

# Theoretical Foundation: Heterogeneity Bound

### Kantorovich-Rubinstein Duality

$$
W_1(F_1, F_2) = \sup_{\|f\|_{\text{Lip}} \leq 1} \left|\int f \, dF_1 - \int f \, dF_2\right|
$$

<div class="block">
<div class="block-title">Heterogeneity Bound (Proposition 2)</div>
<div class="block-body">

If the CATE $\tau(x)$ is Lipschitz continuous with constant $L$:

$$
|\bar{\tau}_1 - \bar{\tau}_2| \leq L \cdot \text{IQR}_{\text{pooled}} \cdot \text{nABCD}(F_1, F_2)
$$

- $L$: upper bound on treatment effect change per unit change in the effect modifier
- **A quantitative bridge from distributional distance to treatment effect differences**

</div>
</div>

---

# Estimation

### Empirical estimator

$$
\widehat{\text{nABCD}} = \frac{\sum_{k=1}^{n_1+n_2-1} |\hat{F}_1(x_{(k)}) - \hat{F}_2(x_{(k)})| \cdot (x_{(k+1)} - x_{(k)})}{\widehat{\text{IQR}}_{\text{pooled}}}
$$

- Computation: $O((n_1+n_2) \log(n_1+n_2))$ — sort dominates

### Inference: Percentile bootstrap

- Asymptotic distribution non-standard: $\sqrt{n}\, W_1(\hat{F}_n, F) \xrightarrow{d} \int |B(F)|\, dx$ — Brownian bridge (del Barrio 1999)
- No universal critical values → **percentile bootstrap** ($B = 2{,}000$ resamples)
- Consistent for $F_1 \neq F_2$ via Hadamard derivative linearity (Sommerfeld 2018)
- Convergence rate $\sqrt{n_1 n_2 / (n_1 + n_2)}$
- Boundary case $F_1 = F_2$: parameter space edge — addressed in simulation

---

# Clinical Calibration: Two Pathways

<div class="block">
<div class="block-title">Pathway 1: When L is available — Δmax</div>
<div class="block-body">

$$
\Delta_{\max} = L \cdot \text{IQR}_{\text{pooled}} \cdot \text{nABCD}(F_1, F_2)
$$

- Worst-case regional treatment effect difference on the **clinical scale**
- Confirmatory or post-hoc evaluation when $L$ is estimable

</div>
</div>

<div class="block">
<div class="block-title">Pathway 2: When L is unknown — L* reverse calculation</div>
<div class="block-body">

$$
L^* = \frac{\Delta_{\text{clin}}}{\text{IQR}_{\text{pooled}} \cdot \text{nABCD}}
$$

- $\Delta_{\text{clin}}$: clinically important difference (e.g., NI margin)
- $L^*$ above plausible range: distributional difference unlikely to be clinically concerning
- **Primary calibration tool at the planning stage**, where $L$ is typically unavailable

</div>
</div>

### Estimation-Centered Design

- No fixed nABCD cutoff
- Quantitative inputs (point estimate + bootstrap CI + $L^*$) support sponsor judgment

---

<!-- _class: section -->

# Simulation

---

# Simulation Design: Seven Scenarios

| ID | Description | Distribution 1 | Distribution 2 | True nABCD |
|----|-------------|-----------------|-----------------|------------|
| S1 | Null (identical) | $N(50, 10^2)$ | $N(50, 10^2)$ | 0.000 |
| S2 | Location 0.2$\sigma$ | $N(50, 10^2)$ | $N(52, 10^2)$ | 0.146 |
| S3 | Location 0.5$\sigma$ | $N(50, 10^2)$ | $N(55, 10^2)$ | 0.358 |
| S4 | Location 1.0$\sigma$ | $N(50, 10^2)$ | $N(60, 10^2)$ | 0.656 |
| S5 | Scale 1.5x | $N(50, 10^2)$ | $N(50, 15^2)$ | 0.244 |
| S6 | Skew (Log-normal) | $N(50, 10^2)$ | LogN | 0.606 |
| S7 | Location + Scale | $N(50, 10^2)$ | $N(55, 15^2)$ | 0.347 |

$n = 50, 100, 200$ per region; 10,000 replications; $B = 2{,}000$ bootstrap resamples

---

# Simulation Design: Scenario Overview

![h:480px](../../figures/slide_scenario_overview_color.png)

*Distribution pairs for scenarios S1--S7 — covering null, pure location shifts, scale-only, skewness, and combined location+scale differences*

---

# Simulation Results: Bias and Coverage

### Bias ($n = 100$)

- True nABCD $\geq 0.1$: bias $< 0.02$ (S3, S4: +0.003 — negligible)
- Near-boundary (S1): larger positive bias from non-negativity constraint

### Coverage Probability (95% CI)

| Scenario | $n = 50$ | $n = 100$ | $n = 200$ |
|----------|----------|-----------|-----------|
| S3 (0.5$\sigma$) | 0.947 | 0.951 | 0.947 |
| S4 (1.0$\sigma$) | 0.950 | 0.950 | 0.957 |
| S6 (Skew) | 0.953 | 0.954 | 0.954 |
| S7 (Loc+Scale) | 0.917 | 0.935 | 0.944 |

**Recommendation**: $n \geq 100$ per region for reliable estimation and inference

---

# Estimation Properties: Visual Summary

![h:380px](../../figures/fig2_simulation_results_color.png)

*Bias (A), coverage (B), and CI width (C) across scenarios S1--S7 and sample sizes $n = 50, 100, 200$*

---

# nABCD vs SMD: Sensitivity ($n = 100$)

| Scenario | nABCD (mean $\pm$ SD) | SMD (mean $\pm$ SD) | Implication |
|----------|----------------------|--------------------|----|
| S3 (Location) | $0.366 \pm 0.096$ | $0.50 \pm 0.14$ | Both detect |
| S5 (Scale only) | $0.272 \pm 0.066$ | $0.00 \pm 0.14$ | **Only nABCD detects** |
| S6 (Skew only) | $0.624 \pm 0.096$ | $0.00 \pm 0.14$ | **Only nABCD detects** |

### Key Finding

- Location shift: SMD and nABCD provide equivalent information
- **Scale and skewness**: SMD remains at zero --- only nABCD detects
- S6 is particularly striking: a large distributional difference (nABCD $= 0.62$) is entirely invisible to SMD

---

<!-- _class: section -->

# Application

---

# Application: Thrombolytic MRCT (GUSTO-I)

### Setting

- Phase 3 MRCT for a novel thrombolytic agent (Drug T) in AMI
- GUSTO-I (public IPD; $N = 40{,}830$, 16 anonymized regions) used as a distributional source
- GUSTO-I is not an MRCT and regions are anonymized — methodological illustration only

### Anchor Region

- **Region 8** ($n = 2{,}916$) designated as the small-sample anchor
- Remaining 15 partner regions evaluated as pooling candidates

### Two Candidate Effect Modifiers

- **Age** and **SBP** (systolic blood pressure)
- Per-unit CATE slope ($L$) unavailable a priori for either
  - Age: FTT meta-analysis (1994) reports only "irrespective of age"
  - SBP: no quantitative class-level CATE sensitivity
- **$L^*$ reverse calculation** applied for both

---

# nABCD Results: R8 vs Partners

### Age nABCD

- Range: **0.022 (R5, R7) -- 0.151 (R3)** — narrow; 11 of 15 partners $< 0.080$

### SBP nABCD

- Range: **0.030 (R2) -- 0.219 (R9)** — wider; most cluster in 0.100--0.220

### Bootstrap CIs

- Mid-rank CIs overlap → varying ranking confidence; widths reported alongside point estimates

---

# Region 8 vs Partners: Forest Plot

![h:480px](../../figures/fig3_gusto_r8_forest_color.png)

*Forest plots of nABCD with 95% bootstrap CIs — age (A) and SBP (B)*

---

# R2 vs R9: Why Evaluate Jointly

| | R2 | R9 |
|---|----|----|
| nABCD$_{\text{age}}$ | **0.122** (2nd largest) | 0.033 (4th smallest) |
| nABCD$_{\text{SBP}}$ | **0.030** (smallest) | **0.219** (largest) |

### Implication

- A single effect modifier → **opposite conclusions**; R2 best on SBP, near-worst on Age; R9 good on Age, worst on SBP
- **Evaluate all candidate effect modifiers jointly**

---

# Leading Candidate: R4 (Six Eligible)

### Plausible Upper Bounds for $L$

- $L_{\text{age,UB}} = 1\times10^{-2}$ /yr; $L_{\text{SBP,UB}} = 2\times10^{-3}$ /mmHg (class-level evidence; GUSTO-I, FTT 1994)
- A partner is **eligible** on a modifier if $L^* > L_{\text{UB}}$

### Joint Eligibility

- **Six partners jointly eligible** on both modifiers: **R1, R4, R5, R6, R14, R15**
- **R4** is the **leading single-pool candidate** — 3rd-lowest age (0.031) and 4th-lowest SBP (0.084); balanced across both modifiers
- R5 has lowest age nABCD (0.022) but only 6th-lowest on SBP — asymmetric profile

> Quantitative inputs; final judgment with clinical/regulatory advisors

---

<!-- _class: section -->

# Discussion

---

# Summary of Findings

### Simulation

- Percentile bootstrap is **reliable** at moderate sample sizes for non-negligible distributional differences
- Positive bias and zero coverage at the null / near-boundary define the **lower limit of reliable inference**

### GUSTO-I Application

- Two candidate effect modifiers (Age, SBP) produced **markedly different partner rankings**
- Some partners ranked similar on one but dissimilar on the other
- **Six partners** (R1, R4, R5, R6, R14, R15) emerged as **jointly eligible**; **R4** is the leading single-pool candidate

---

# Interpretation: Two Implications

### Implication 1: Evaluate all candidate effect modifiers jointly

- R2 vs R9 contrast: a partner similar on one modifier may not be on another
- Restricting to a subset risks omitting modifiers that later compromise consistency

### Implication 2: Partner selection cannot rest on nABCD alone

- $L^*$ varies markedly across partners and modifiers
- Same nABCD carries different clinical weight depending on partner-specific differences
- Six partners (R1, R4, R5, R6, R14, R15) emerged as **jointly eligible**; **R4** stood out as leading single-pool candidate due to balanced ranking on both modifiers

> Pooling judgments require **distributional ranking + clinical calibration** across all candidates

---

# Strengths: Dual-Pathway Calibration

### Strength 1: Adapts to the evidence state

- Planning stage with $L$ unknown: $L^*$ reverse-calculation as primary calibration
- Confirmatory stage with $L$ available: $\Delta_{\max}$ provides complementary clinical-scale calibration
- No fixed nABCD cutoff imposed

### Strength 2: Distributional value is invariant

- nABCD captures **scale and skewness** differences invisible to SMD
- This property holds **regardless of whether $L$ is available**
- Clinical calibration **enhances**, not replaces, the distributional assessment

---

# Practical Recommendations

1. Compute **nABCD + bootstrap CI** for every candidate effect modifier ($n \geq 100$ per region)

2. When $L$ is estimable: translate to **$\Delta_{\max}$** with bootstrap CI

3. When $L$ is unknown: compute **$L^*$** at pre-specified $\Delta_{\text{clin}}$ values

4. Report alongside **overall treatment effect and non-inferiority margin** to support deliberation

5. Multiple effect modifiers: conservative (maximum $\Delta_{\max}$, smallest $L^*$) or totality-of-evidence approach

### Policy Advantage

- nABCD requires only baseline distributions → applicable to **trials, registries, EHR, RWE**
- Aligns with ICH E6(R3) RWE promotion

---

# Future Work and Closing

### Future Work

- Extension to **categorical effect modifiers**
- Upstream identification of which baseline characteristics constitute relevant effect modifiers — a non-trivial problem deserving dedicated investigation
- Multivariate extensions and small-sample bias correction

### The Principal Contribution

$$
\boxed{|\bar{\tau}_1 - \bar{\tau}_2| \leq L \cdot \text{IQR}_{\text{pooled}} \cdot \text{nABCD}}
$$

- nABCD + bootstrap CI + clinical calibration ($\Delta_{\max}$ or $L^*$)
- Transforms the **previously qualitative** judgment of "similar enough"
- Into a **reproducible quantitative basis** for sponsor judgment
- Filling the methodological gap left by ICH E17

---

<!-- _class: end -->
<!-- _paginate: false -->

# Thank You

Questions welcome

Tak Nagakubo
