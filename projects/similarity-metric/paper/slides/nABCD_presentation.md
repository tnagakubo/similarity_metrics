---
marp: true
size: 16:9
paginate: true
header: "Feb 13, 2026"
footer: "Quantifying Effect Modifier Similarity for Regional Pooling in MRCTs"
math: mathjax
style: |
  /* ============================================
     Marp Slide Template
     - Accent Color 1: #1E3A5F (Deep Navy)
     - Accent Color 2: #0da774
     ============================================ */

  @import url('https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@100..900&display=swap');

  :root {
    --accent1: #003638;
    --accent2: #0da774;
    --text-main: #000000;
    --text-light: #303030;
    --bg-light: #F8F9FA;
    --bw: 10px;
    --footer-space: 24px;
  }

  /* ---- Base slide ---- */
  section {
    font-family: 'Noto Sans JP', sans-serif;
    color: var(--text-main);
    border: none;
    padding: 90px 60px 46px 60px;
    font-size: 28px;
    line-height: 1.6;
    position: relative;
    /* Frame drawn with background layers (top/left/right/bottom borders) */
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

  /* ---- Disable default ::before ---- */
  section::before {
    display: none;
  }

  /* ---- Slide title (h1) - covers frame top seamlessly ---- */
  section h1 {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    box-sizing: border-box;
    background: var(--accent1);
    color: white;
    font-size: 42px;
    font-weight: 700;
    padding: 18px 60px 14px;
    margin: 0;
    line-height: 1.4;
    z-index: 2;
  }

  /* ---- H2 ---- */
  section h2 {
    color: var(--accent1);
    font-size: 36px;
    font-weight: 700;
    border-bottom: 3px solid var(--accent2);
    padding-bottom: 6px;
    margin-bottom: 20px;
  }

  /* ---- H3 ---- */
  section h3 {
    color: var(--accent2);
    font-size: 28px;
    font-weight: 700;
  }

  /* ---- Footer left: date (below frame) ---- */
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

  /* ---- Footer center: title (below frame) ---- */
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

  /* ---- Footer right: page number (below frame) ---- */
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

  /* ---- Strong text with accent2 ---- */
  section strong {
    color: var(--accent2);
    font-weight: 700;
  }

  /* ---- Lists ---- */
  section ul, section ol {
    line-height: 1.8;
    margin-left: 10px;
  }

  section li {
    margin-bottom: 4px;
  }

  section li::marker {
    color: var(--accent1);
  }

  /* ---- Tables ---- */
  section table {
    border-collapse: collapse;
    width: 100%;
    font-size: 24px;
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

  /* ---- Code blocks ---- */
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

  /* ---- Blockquote ---- */
  section blockquote {
    border-left: 4px solid var(--accent2);
    padding: 12px 20px;
    margin: 16px 0;
    background: var(--bg-light);
    font-style: italic;
    color: var(--text-light);
  }

  /* ---- Images ---- */
  section img {
    max-height: 60%;
    border-radius: 4px;
  }

  /* ============================================
     Title slide class
     ============================================ */
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
    font-size: 64px;
    font-weight: 900;
    margin: 0 0 20px 0;
    padding: 0;
    line-height: 1.3;
    border: none;
  }

  section.title h2 {
    font-size: 36px;
    font-weight: 400;
    border: none;
    margin: 0 0 40px 0;
    padding: 0;
    color: rgba(255, 255, 255, 0.85);
  }

  section.title p {
    font-size: 32px;
    margin: 4px 0;
    align-self: flex-end;
    color: rgba(255, 255, 255, 0.8);
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

  /* ============================================
     Section divider slide class
     ============================================ */
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

  /* ============================================
     Two-column layout
     ============================================ */
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

  /* ============================================
     End slide class
     ============================================ */
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

  /* ============================================
     Highlight box
     ============================================ */
  section .highlight {
    background: #EBF5FB;
    border: 2px solid var(--accent2);
    border-radius: 8px;
    padding: 16px 24px;
    margin: 12px 0;
  }

  /* ============================================
     Block environments (accent1 / accent2 only)
     ============================================ */
  .block, .alertblock {
    border-radius: 6px;
    margin: 14px 0;
    padding: 0;
    overflow: hidden;
    font-size: 25px;
    line-height: 1.5;
    box-shadow: 0 1px 4px rgba(0, 0, 0, 0.10);
  }

  .block .block-title,
  .alertblock .block-title {
    display: block;
    font-weight: 700;
    font-size: 24px;
    padding: 8px 20px;
    margin: 0;
    color: white;
  }

  .block .block-content,
  .alertblock .block-content {
    padding: 12px 20px;
    margin: 0;
  }

  .block .block-content p,
  .alertblock .block-content p {
    margin: 0;
  }

  /* block (accent1: deep teal — definitions, theorems, results) */
  .block .block-title { background: var(--accent1); }
  .block .block-content { background: #e6f0f0; border: 1px solid #b3d1d2; border-top: none; border-radius: 0 0 6px 6px; }

  /* alertblock (accent2: deep indigo — key points, warnings) */
  .alertblock .block-title { background: var(--accent2); }
  .alertblock .block-content { background: #eceafc; border: 1px solid #c4bfe8; border-top: none; border-radius: 0 0 6px 6px; }

---

<!-- _class: title -->
<!-- _paginate: false -->

# nABCD
## Quantifying Effect Modifier Similarity for Regional Pooling in Multi-Regional Clinical Trials

Author One, Author Two, Author Three

---

# Outline

1. **Background** &mdash; ICH E17 and the methodological gap
2. **Methods** &mdash; The nABCD metric and clinical calibration
3. **Simulation Study** &mdash; Estimation properties
4. **Application** &mdash; Type 2 diabetes MRCT
5. **Discussion** &mdash; Implications and future directions

---

<!-- _class: section -->

# 1. Background

---

# ICH E17: Regional Pooling

The ICH E17 guideline (2017) recommends pooling regions with **similar effect modifier (EM) distributions**:

> "Regions may be pooled for randomisation and/or analysis if subjects are thought to be *similar enough* with respect to intrinsic and/or extrinsic factors relevant to the disease and/or drug under study."
> &mdash; ICH E17, Section 2.2.5

<div class="alertblock">
<div class="block-title">The Problem</div>
<div class="block-content">

ICH E17 provides **no specific metric, threshold, or procedure** for determining when distributions are "similar enough."

</div>
</div>

---

# Why Effect Modifiers Matter

An **effect modifier** is a baseline characteristic where treatment benefit differs across subgroups.

$$
\bar{\tau}_r = \int \tau(x) \, dF_r(x)
$$

- Even if the drug works identically at the individual level...
- Regions with **different patient compositions** observe **different average treatment effects**
- A region with younger patients shows larger benefits &mdash; not because the drug differs, but because the **patient mix** differs

---

# Limitations of Current Approaches

| Method | Limitation |
|--------|------------|
| Visual inspection | Subjective, not reproducible |
| Standardized mean difference (SMD) | Captures **only location**, ignores scale and shape |
| Kolmogorov&ndash;Smirnov statistic | No interpretable scale for decision-making |

<div class="block">
<div class="block-title">Research Question</div>
<div class="block-content">

How can we estimate distributional similarity in a **scale-free** manner, and translate that estimate into **clinically interpretable** information about potential treatment effect heterogeneity?

</div>
</div>

---

<!-- _class: section -->

# 2. Methods

---

# The Heterogeneity Bound

If the CATE function $\tau(x)$ has Lipschitz constant $L$:

$$
|\bar{\tau}_1 - \bar{\tau}_2| \leq L \cdot W_1(F_1, F_2)
$$

The **Wasserstein-1 distance** (Earth Mover's Distance):

$$
W_1(F_1, F_2) = \int_{-\infty}^{\infty} |F(x) - G(x)| \, dx
$$

- **Geometrically**: total area between two CDFs
- Captures location, scale, **and** shape differences
- $W_1$ is required by the Kantorovich&ndash;Rubinstein duality ($W_2$ cannot provide this bound)

---

# nABCD Definition

<div class="block">
<div class="block-title">Definition</div>
<div class="block-content">

$$\text{nABCD}(F_1, F_2) = \frac{W_1(F_1, F_2)}{2 \cdot \text{IQR}_{\text{pooled}}}$$

IQR normalization $\Rightarrow$ **scale-free**, robust to outliers. $\text{nABCD} \geq 0$, with equality iff $F_1 = F_2$.

</div>
</div>

<div class="block">
<div class="block-title">Heterogeneity Bound</div>
<div class="block-content">

$$|\bar{\tau}_1 - \bar{\tau}_2| \leq 2L \cdot \text{IQR}_{\text{pooled}} \cdot \text{nABCD}$$

nABCD directly bounds the **maximum regional treatment effect difference**.
Clinical calibration: $\Delta_{\max} = 2L \cdot \text{IQR}_{\text{pooled}} \cdot \text{nABCD}$

</div>
</div>

---

# Clinical Calibration: $\Delta_{\max}$

The maximum potential treatment effect difference attributable to EM distributional differences:

$$
\Delta_{\max} = 2L \cdot \text{IQR}_{\text{pooled}} \cdot \text{nABCD}(F_1, F_2)
$$

where $L$ = CATE sensitivity (Lipschitz constant of $\tau(x)$)

### Procedure
1. Compute **nABCD** with bootstrap CIs for each EM
2. Estimate **$L$** from prior knowledge / subgroup analyses
3. Compute **$\Delta_{\max}$** and its CI on the clinical scale
4. Compare against treatment effect, non-inferiority margin, etc.
5. Conduct **sensitivity analysis** over plausible $L$ values

---

# Estimation and Inference

### Point estimator

$$
\widehat{\text{nABCD}} = \frac{\sum_{k=1}^{n_1+n_2-1} |\hat{F}_1(x_{(k)}) - \hat{F}_2(x_{(k)})| \cdot (x_{(k+1)} - x_{(k)})}{2 \cdot \widehat{\text{IQR}}_{\text{pooled}}}
$$

- Computational complexity: $O((n_1 + n_2) \log(n_1 + n_2))$

### Inference
- **Percentile bootstrap** with $B = 2{,}000$ replicates
- BCa overcorrects for this bounded statistic &mdash; percentile preferred
- Asymptotic normality holds for $F_1 \neq F_2$ (interior of parameter space)

---

<!-- _class: section -->

# 3. Simulation Study

---

# Simulation Design

### Scenarios (S1&ndash;S8)

| ID | Type | Clinical Motivation | Distribution 2 | True nABCD |
|----|------|---------------------|-----------------|------------|
| S1 | Null | Identical populations | $N(50, 10^2)$ | 0.000 |
| S2 | Location 0.2$\sigma$ | Age: EU vs US | $N(52, 10^2)$ | 0.074 |
| S3 | Location 0.5$\sigma$ | BMI: Japan vs EU | $N(55, 10^2)$ | 0.186 |
| S4 | Location 1.0$\sigma$ | BMI: Japan vs US | $N(60, 10^2)$ | 0.372 |
| S5 | Scale 1.5$\times$ | HbA1c: strict vs broad criteria | $N(50, 15^2)$ | 0.148 |
| S6 | Shape (Gamma) | Lab values: eGFR | Gamma(25, 0.5) | 0.067 |
| S7 | Skew (log-normal) | ALT (CV $\approx$ 53%) | LogN($\sigma$=0.5) | MC |
| S8 | Location + Scale | BMI: Japan vs US (realistic) | $N(55, 15^2)$ | MC |

- Distribution 1 is always $N(50, 10^2)$. Sample sizes: $n = 50, 100, 200$. 10,000 reps, $B = 2{,}000$.

---

# Bias Results

| Scenario | True nABCD | $n=50$ | $n=100$ | $n=200$ |
|----------|-----------|--------|---------|---------|
| S1 (Null) | 0.000 | +0.093 | +0.066 | +0.047 |
| S2 (0.2$\sigma$) | 0.074 | +0.039 | +0.018 | +0.007 |
| S3 (0.5$\sigma$) | 0.186 | +0.004 | **&minus;0.003** | &minus;0.004 |
| S4 (1.0$\sigma$) | 0.372 | &minus;0.038 | &minus;0.041 | &minus;0.043 |
| S5 (Scale) | 0.148 | +0.001 | &minus;0.012 | &minus;0.019 |
| S6 (Gamma) | 0.067 | +0.029 | +0.003 | &minus;0.015 |

- Non-null scenarios (excl. S4): **bias < 0.02** at $n \geq 100$
- S4: persistent negative bias (~&minus;0.04) from bounded statistic
- S7, S8 results pending re-simulation

---

# Coverage and Precision

| Scenario | $n=50$ | $n=100$ | $n=200$ |
|----------|--------|---------|---------|
| S2 (0.2$\sigma$) | 0.672 | 0.895 | **0.949** |
| S3 (0.5$\sigma$) | **0.956** | **0.950** | **0.949** |
| S4 (1.0$\sigma$) | **0.929** | 0.867 | 0.731 |
| S5 (Scale) | **0.963** | **0.976** | **0.939** |
| S6 (Gamma) | 0.573 | **0.945** | **0.996** |

<div class="block">
<div class="block-title">Key Findings</div>
<div class="block-content">

- Coverage **0.87&ndash;0.98** at $n \geq 100$ for most scenarios
- S3 (0.5$\sigma$): exemplary &mdash; bias negligible, coverage nominal, RMSE < 0.05
- Recommendation: **$n \geq 100$ per region** for reliable inference

</div>
</div>

---

# nABCD vs SMD: Sensitivity Comparison

| Scenario | nABCD (mean $\pm$ SD) | SMD (mean $\pm$ SD) | Implication |
|----------|----------------------|---------------------|-------------|
| S3 (Location) | $0.183 \pm 0.049$ | $0.50 \pm 0.14$ | Both detect |
| S5 (Scale only) | $0.136 \pm 0.033$ | $0.00 \pm 0.14$ | **Only nABCD** |
| S6 (Shape only) | $0.070 \pm 0.024$ | $0.00 \pm 0.14$ | **Only nABCD** |

<div class="alertblock">
<div class="block-title">SMD Blindness</div>
<div class="block-content">

SMD is **blind** to variance and shape differences. nABCD captures the **full distributional difference** that can drive treatment effect heterogeneity through non-linear CATE functions.

</div>
</div>

---

<!-- _class: section -->

# 4. Application

---

# Type 2 Diabetes MRCT

Hypothetical MRCT: Japan ($n=150$), US ($n=200$), EU ($n=180$)
Primary endpoint: Change in HbA1c (%) at 24 weeks
Overall treatment effect: **&minus;0.8%** &nbsp; | &nbsp; Non-inferiority margin: **0.4%**

| Characteristic | Japan | US | EU |
|---------------|-------|-----|-----|
| Age, mean (SD) | 62.3 (10.2) | 58.7 (11.5) | 60.1 (10.8) |
| BMI, mean (SD) | 24.8 (3.2) | 32.1 (5.8) | 29.4 (4.9) |
| HbA1c, mean (SD) | 7.6 (0.9) | 8.4 (1.3) | 8.1 (1.1) |

---

# Pairwise nABCD Values

| Effect Modifier | Japan vs. US | Japan vs. EU | US vs. EU |
|----------------|-------------|-------------|----------|
| Age | 0.12 (0.07&ndash;0.18) | 0.08 (0.04&ndash;0.13) | 0.05 (0.02&ndash;0.09) |
| BMI | **0.51** (0.44&ndash;0.58) | 0.38 (0.31&ndash;0.45) | 0.18 (0.12&ndash;0.24) |
| HbA1c | 0.27 (0.20&ndash;0.34) | 0.19 (0.13&ndash;0.26) | 0.10 (0.05&ndash;0.16) |

### Japan&ndash;US shows the largest distributional differences

- BMI: nABCD = **0.51** (large)
- HbA1c: nABCD = **0.27** (moderate)
- But **does a large nABCD always mean trouble?**

---

# Clinical Calibration: Japan vs. US

| EM | nABCD | $L$ | IQR | $\Delta_{\max}$ | vs. margin |
|----|-------|-----|-----|-----------------|------------|
| Age | 0.12 | 0.01 | 14.2 yr | **0.03%** | $\ll 0.4\%$ |
| BMI | 0.51 | 0.02 | 7.8 kg/m$^2$ | **0.16%** | $< 0.4\%$ |
| HbA1c | 0.27 | 0.30 | 1.5% | **0.24%** | $< 0.4\%$ |

$$
\Delta_{\max} = 2L \cdot \text{IQR}_{\text{pooled}} \cdot \text{nABCD}
$$

---

# Key Insight: Same nABCD, Different Impact

<div class="block">
<div class="block-title">BMI (nABCD = 0.51, L = 0.02) &mdash; Weak effect modifier</div>
<div class="block-content">

**Large** distributional difference, but BMI is a **weak** effect modifier for this drug class.
$\Rightarrow$ $\Delta_{\max}$ = 0.16% &mdash; only 20% of treatment effect

</div>
</div>

<div class="alertblock">
<div class="block-title">HbA1c (nABCD = 0.27, L = 0.30) &mdash; Strong effect modifier</div>
<div class="block-content">

**Moderate** distributional difference, but baseline HbA1c is a **strong** effect modifier.
$\Rightarrow$ $\Delta_{\max}$ = 0.24% &mdash; 30% of treatment effect, 60% of margin

</div>
</div>

The clinical meaning of nABCD depends on the EM's CATE sensitivity $L$.

---

# Sensitivity Analysis: HbA1c (Japan vs. US)

nABCD = 0.27, IQR = 1.5%

| $L$ (assumed) | $\Delta_{\max}$ | as % of treatment effect |
|---------------|-----------------|--------------------------|
| 0.10 | 0.08% | 10% |
| 0.20 | 0.16% | 20% |
| 0.30 | 0.24% | 30% |
| 0.40 | 0.32% | 40% |
| 0.50 | 0.41% | 51% |

- At $L^* = 0.49$: $\Delta_{\max}$ equals the non-inferiority margin (0.4%)
- **Transparent view**: at what $L$ does the distributional difference begin to matter?

---

<!-- _class: section -->

# 5. Discussion

---

# Four Contributions

1. **Full distributional comparison**
   $W_1$ captures location, scale, and shape &mdash; unlike SMD

2. **Scale-free estimation**
   IQR normalization enables cross-EM comparisons with bootstrap CIs

3. **Clinical calibration**
   $\Delta_{\max}$ translates nABCD into potential treatment effect heterogeneity on the clinical scale

4. **Sensitivity analysis**
   Framework naturally accommodates uncertainty in $L$, providing richer information than binary testing

---

# Recommendations for Practitioners

1. Compute **nABCD with bootstrap CIs** ($n \geq 100$ per region) for each candidate EM
2. Translate nABCD into **$\Delta_{\max}$** using equation $\Delta_{\max} = 2L \cdot \text{IQR} \cdot \text{nABCD}$
3. Report $\Delta_{\max}$ and its CI alongside treatment effect and clinical margins
4. Conduct **sensitivity analyses** over plausible $L$ values
5. Use reference benchmarks only when $L$ cannot be estimated

---

# Reference Benchmarks

<div class="alertblock">
<div class="block-title">Reference only &mdash; not decision thresholds</div>
<div class="block-content">

| nABCD Range | Interpretation | Suggested Action |
|-------------|---------------|------------------|
| < 0.05 | Negligible | Pooling broadly supportable |
| 0.05&ndash;0.15 | Small | Pooling generally acceptable |
| 0.15&ndash;0.30 | Moderate | Clinical calibration recommended |
| > 0.30 | Large | Clinical calibration essential |

</div>
</div>

- These assume **moderate CATE sensitivity**
- **$\Delta_{\max}$-based calibration is always preferred** over fixed benchmarks
- Context matters: large nABCD + weak EM $\neq$ concern (see BMI example)

---

# Limitations and Future Work

### Current limitations
- Continuous EMs only &mdash; extensions to categorical/mixed-type needed
- Univariate evaluation &mdash; multivariate extension would address EM confounding
- Positive bias at small $n$ under null; negative bias at large true values
- CATE sensitivity $L$ may not always be estimable from prior data

### Future directions
- Multivariate nABCD extensions
- Bias correction methods for small samples
- Empirical calibration of $L$ from historical trial databases
- Longitudinal EM profiles for dynamic similarity assessment

---

<!-- _class: end -->
<!-- _paginate: false -->

# Thank You

nABCD fills a methodological gap in ICH E17 implementation by translating distributional differences into context-specific assessments of potential treatment effect heterogeneity.

Open-source R code available at [repository URL]
