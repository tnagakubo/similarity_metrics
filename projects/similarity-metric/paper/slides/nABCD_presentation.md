---
marp: true
size: 16:9
paginate: true
header: "Mar 1, 2026"
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

1. **Background** &mdash; ICH E17 and the regulatory gap
2. **Methods** &mdash; Heterogeneity bound, nABCD definition, clinical calibration
3. **Simulation Study** &mdash; Bias, coverage, nABCD vs. SMD
4. **Application** &mdash; Hypothetical thrombolytic MRCT using IST-3 data
5. **Discussion** &mdash; Estimation-centered philosophy and future directions

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

Recent regulatory guidance highlights this gap:
- Song et al. (2025): NMPA perspective on ICH E17 pooling operationalization
- Long et al. (2025): Basic considerations for consistency evaluation under E17

---

<style scoped>
section { font-size: 25px; line-height: 1.5; }
</style>

# Our Approach

<div class="block">
<div class="block-title">Research Question</div>
<div class="block-content">

How can we estimate distributional similarity in a **scale-free** manner, and translate that estimate into **clinically interpretable** information about potential treatment effect heterogeneity?

</div>
</div>

### Design Philosophy
- **Estimation**, not hypothesis testing &mdash; quantify the difference, don't just accept/reject
- **Clinical calibration** &mdash; translate distributional differences into the outcome scale
- **Scope**: Continuous effect modifiers only (categorical/mixed-type EMs require alternative distances)

<div class="alertblock">
<div class="block-title">Key Principle</div>
<div class="block-content">

Provide regulatory scientists with **quantitative tools that inform deliberation**, not binary accept/reject rules.

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

<style scoped>
section { font-size: 23px; line-height: 1.4; }
</style>

# Derivation: Three Steps

### Step 1 &mdash; $W_1$ as CDF area

$$W_1(F_1, F_2) = \int_{-\infty}^{\infty} |F_1(x) - F_2(x)| \, dx$$

### Step 2 &mdash; Kantorovich&ndash;Rubinstein duality

$$W_1(F_1, F_2) = \sup_{\|f\|_{\text{Lip}} \leq 1} \left| \int f \, dF_1 - \int f \, dF_2 \right|$$

$W_1$ equals the worst-case expected difference over **all 1-Lipschitz functions**.

### Step 3 &mdash; Apply to CATE function

If $\tau(x)$ has Lipschitz constant $L$, then $g(x) = \tau(x)/L$ satisfies $\|g\|_{\text{Lip}} \leq 1$:

$$\frac{1}{L}\,|\bar{\tau}_1 - \bar{\tau}_2| = \left|\int g \, dF_1 - \int g \, dF_2\right| \leq W_1(F_1, F_2) \quad \Rightarrow \quad |\bar{\tau}_1 - \bar{\tau}_2| \leq L \cdot W_1 \quad \blacksquare$$

---

# Why $W_1$ &mdash; And Only $W_1$

| Distance | K-R Duality | Heterogeneity Bound | Symmetric | Always Finite |
|----------|:-----------:|:-------------------:|:---------:|:-------------:|
| $W_1$ | **Yes** | **Constructible** | Yes | Yes |
| $W_2$ | No | Not available | Yes | Yes |
| KL divergence | No | Not available | **No** | **No** |

<div class="alertblock">
<div class="block-title">Why alternatives fail</div>
<div class="block-content">

**$W_2$**: Its dual involves *convex* functions, not Lipschitz &mdash; cannot bound CATE heterogeneity.
**KL**: Asymmetric ($D_{KL}(P \| Q) \neq D_{KL}(Q \| P)$) and diverges when empirical supports don't overlap.

$W_1$ is not a preference &mdash; it is the **unique choice** enabling the heterogeneity bound.

</div>
</div>

---

# The Bound Is Tight, Not Loose

<div class="block">
<div class="block-title">Two reasons the upper bound is the right tool</div>
<div class="block-content">

**1. Regulatory conservatism.** &ensp; False-positive pooling (treating different populations as similar) is the dangerous error. An upper bound provides a worst-case guarantee &mdash; appropriate for regulatory safety decisions.

**2. K-R optimality.** &ensp; There exists a 1-Lipschitz function that *achieves* the supremum. The bound is the **tightest possible** given only Lipschitz smoothness of $\tau(x)$ &mdash; not a rough approximation, but the mathematical optimum.

</div>
</div>

> The bound answers: *"Given what we know about CATE smoothness, what is the worst that could happen?"*

---

<style scoped>
section { font-size: 25px; line-height: 1.4; }
</style>

# nABCD Definition

<div class="block">
<div class="block-title">Definition</div>
<div class="block-content">

$$\text{nABCD}(F_1, F_2) = \frac{W_1(F_1, F_2)}{2 \cdot \text{IQR}_{\text{pooled}}}$$

IQR normalization $\Rightarrow$ **scale-free**, robust to outliers. &ensp; $\text{nABCD} \geq 0$ (provided $\text{IQR}_{\text{pooled}} > 0$), equality iff $F_1 = F_2$.
**Why IQR?** Interpretable (central 50% spread), familiar to clinicians. $Q_n$ higher breakdown unnecessary for population-level data.

</div>
</div>

<div class="block">
<div class="block-title">Heterogeneity Bound (Proposition 2)</div>
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

<style scoped>
section { font-size: 24px; line-height: 1.4; }
</style>

# Estimation and Inference

### Point estimator

$$
\widehat{\text{nABCD}} = \frac{\sum_{k=1}^{n_1+n_2-1} |\hat{F}_1(x_{(k)}) - \hat{F}_2(x_{(k)})| \cdot (x_{(k+1)} - x_{(k)})}{2 \cdot \widehat{\text{IQR}}_{\text{pooled}}}
$$

- Computational complexity: $O((n_1 + n_2) \log(n_1 + n_2))$

### Inference
- **Percentile bootstrap** ($B = 2{,}000$) &mdash; BCa overcorrects for bounded statistic

### Asymptotic theory (del Barrio et al. 1999)
- $W_1$ = $L_1$ distance between CDFs $\Rightarrow$ $\sqrt{n}$-convergence to Brownian bridge functional
- **$F_1 \neq F_2$**: Hadamard derivative is **linear** $\Rightarrow$ bootstrap consistent
- **$F_1 \approx F_2$**: derivative becomes non-linear $\Rightarrow$ modest undercoverage possible

---

<!-- _class: section -->

# 3. Simulation Study

---

<style scoped>
section { font-size: 23px; line-height: 1.5; }
table { font-size: 0.9em; }
</style>

# Simulation Design

### Scenarios (S1&ndash;S8)

| ID | Type | Clinical Motivation | Distribution 2 | True nABCD |
|----|------|---------------------|-----------------|------------|
| S1 | Null | Identical populations | $N(50, 10^2)$ | 0.000 |
| S2 | Location 0.2$\sigma$ | Age: EU vs US | $N(52, 10^2)$ | 0.074 |
| S3 | Location 0.5$\sigma$ | BMI: Japan vs EU | $N(55, 10^2)$ | 0.186 |
| S4 | Location 1.0$\sigma$ | BMI: Japan vs US | $N(60, 10^2)$ | 0.372 |
| S5 | Scale 1.5$\times$ | HbA1c: strict vs broad | $N(50, 15^2)$ | 0.148 |
| S6 | Shape (Gamma) | Lab values: eGFR | Gamma(25, 0.5) | 0.067 |
| S7 | Skew (log-normal) | ALT (CV $\approx$ 53%) | LogN($\sigma$=0.5) | 0.302 |
| S8 | Location + Scale | BMI: Japan vs US | $N(55, 15^2)$ | 0.175 |

- Distribution 1 is always $N(50, 10^2)$. Sample sizes: $n = 50, 100, 200$. 10,000 reps, $B = 2{,}000$.

---

<style scoped>
section { font-size: 23px; line-height: 1.5; }
table { font-size: 0.9em; }
</style>

# Bias Results

| Scenario | True nABCD | $n=50$ | $n=100$ | $n=200$ |
|----------|-----------|--------|---------|---------|
| S1 (Null) | 0.000 | +0.093 | +0.066 | +0.047 |
| S2 (0.2$\sigma$) | 0.074 | +0.039 | +0.018 | +0.007 |
| S3 (0.5$\sigma$) | 0.186 | +0.004 | **&minus;0.003** | &minus;0.004 |
| S4 (1.0$\sigma$) | 0.372 | &minus;0.038 | &minus;0.041 | &minus;0.043 |
| S5 (Scale) | 0.148 | +0.001 | &minus;0.012 | &minus;0.019 |
| S6 (Gamma) | 0.067 | +0.029 | +0.003 | &minus;0.015 |
| S7 (Skew) | 0.302 | +0.019 | +0.009 | +0.005 |
| S8 (Loc+Scale) | 0.175 | +0.024 | +0.011 | +0.006 |

- Non-null (excl. S4): **bias < 0.02** at $n \geq 100$ &ensp;|&ensp; S4: persistent &minus;0.04 (bounded statistic) &ensp;|&ensp; S7/S8: well-behaved

---

<style scoped>
section { font-size: 23px; line-height: 1.5; }
table { font-size: 0.9em; }
</style>

# Coverage and Precision

| Scenario | $n=50$ | $n=100$ | $n=200$ |
|----------|--------|---------|---------|
| S2 (0.2$\sigma$) | 0.672 | 0.895 | **0.949** |
| S3 (0.5$\sigma$) | **0.956** | **0.950** | **0.949** |
| S4 (1.0$\sigma$) | **0.929** | 0.867 | 0.731 |
| S5 (Scale) | **0.963** | **0.976** | **0.939** |
| S6 (Gamma) | 0.573 | **0.945** | **0.996** |
| S7 (Skew) | **0.953** | **0.954** | **0.951** |
| S8 (Loc+Scale) | 0.916 | 0.932 | 0.939 |

<div class="block">
<div class="block-title">Key Findings</div>
<div class="block-content">

- Coverage **0.87&ndash;0.98** at $n \geq 100$ &ensp;|&ensp; S7: **near-nominal across all** $n$
- Recommendation: **$n \geq 100$ per region** for reliable inference

</div>
</div>

---

# nABCD vs SMD: Sensitivity Comparison

| Scenario | nABCD (mean $\pm$ SD) | SMD (mean $\pm$ SD) | Implication |
|----------|----------------------|---------------------|-------------|
| S3 (Location) | $0.184 \pm 0.049$ | $0.50 \pm 0.14$ | Both detect |
| S5 (Scale only) | $0.136 \pm 0.033$ | $0.00 \pm 0.14$ | **Only nABCD** |
| S6 (Shape only) | $0.070 \pm 0.024$ | $0.00 \pm 0.14$ | **Only nABCD** |
| S7 (Skew only) | $0.311 \pm 0.047$ | $0.00 \pm 0.14$ | **Only nABCD** |

<div class="alertblock">
<div class="block-title">SMD Blindness</div>
<div class="block-content">

SMD is **blind** to variance and shape differences. nABCD captures the **full distributional difference** that can drive treatment effect heterogeneity through non-linear CATE functions.

</div>
</div>

---

<!-- _class: section -->

# 4. Application: Hypothetical Thrombolytic MRCT

---

# Hypothetical Scenario

A sponsor developing a **novel thrombolytic** (drug A) for acute ischaemic stroke is planning a **Phase 3 MRCT**.

- Candidate EMs identified from **Emberson et al. (2014)** IPD meta-analysis ($n = 6{,}756$):
  - **NIHSS** (interaction $p = 0.06$) &mdash; strong candidate
  - **Age** (interaction $p = 0.53$) &mdash; weak candidate
- Drug A same pharmacological class as alteplase &rarr; similar EM profiles assumed
- IST-3 public IPD used as **historical reference** for country-level EM distributions

<div class="alertblock">
<div class="block-title">Key framing</div>
<div class="block-content">

nABCD is **one piece of evidence** supporting pooling decisions, not a standalone criterion.

</div>
</div>

---

<style scoped>
section { font-size: 24px; line-height: 1.5; }
table { font-size: 0.85em; }
</style>

# IST-3: Study Overview

**Third International Stroke Trial** (IST-3 collaborative group, *Lancet* 2012)
- 3,035 patients, 8 countries, alteplase vs control within 6h of onset
- Primary outcome: OHS 0&ndash;2 at 6 months &mdash; adjusted OR 1.13 (0.95&ndash;1.35, $p=0.181$)

**Confirmed EMs for alteplase** (Emberson et al., *Lancet* 2014; IPD meta-analysis, 9 trials, $n=6{,}756$):

| EM | Type | Interaction $p$ (Emberson) | IST-3 subgroup $p$ |
|----|------|---------------------------|---------------------|
| Treatment delay | Continuous (hours) | **0.016** | Benefit greatest &lt;3h |
| Age | Continuous (years) | 0.53 | 0.027 (IST-3 alone) |
| NIHSS | Continuous (score) | 0.06 | **0.003** |

<div class="alertblock">
<div class="block-title">Why IST-3 as historical reference?</div>
<div class="block-content">

Public IPD with country data + continuous EMs + prior effect modification evidence from Emberson meta-analysis = ideal historical reference for demonstrating nABCD in a planning context.

</div>
</div>

---

<style scoped>
section { font-size: 22px; line-height: 1.4; }
table { font-size: 0.85em; }
</style>

# IST-3: Country-Level Patient Characteristics

| Country | $n$ | Age, mean (SD) | Delay, mean (SD) | NIHSS, mean (SD) |
|---------|-----|----------------|-------------------|-------------------|
| UK | 1,447 | 78.0 (12.2) | 4.1 (1.2) | 13.1 (6.9) |
| Poland | 347 | 73.7 (13.1) | 4.6 (1.2) | 9.6 (6.4) |
| Italy | 326 | 75.9 (12.2) | 4.2 (1.1) | 11.1 (6.6) |
| Sweden | 297 | 81.0 (10.8) | 3.8 (1.3) | 10.0 (6.5) |
| Norway | 204 | 76.1 (10.3) | 4.3 (1.8) | 11.9 (6.9) |
| Australia | 179 | 74.7 (13.1) | 4.6 (1.1) | 14.4 (7.5) |
| Portugal | 82 | 79.0 (11.5) | 4.3 (1.2) | 14.8 (6.0) |
| Belgium | 73 | 76.1 (12.4) | 4.0 (1.1) | 10.9 (6.1) |

Key patterns:
- **Age**: Sweden outlier (median 83 yr vs overall 77 yr)
- **NIHSS**: Two clusters &mdash; UK/Australia (high, 13&ndash;15) vs Poland/Sweden (low, 10)
- **Delay**: Sweden fastest (3.8h), Poland/Australia slowest (4.6h)

---

<style scoped>
section { font-size: 24px; line-height: 1.5; }
</style>

# IST-3: nABCD Results (28 pairwise comparisons)

| EM | Min | Median | Mean | Max | Max pair |
|----|-----|--------|------|-----|----------|
| Age | 0.039 | 0.103 | 0.123 | **0.285** | Sweden&ndash;Belgium |
| Delay | 0.026 | 0.087 | 0.097 | 0.195 | Sweden&ndash;Australia |
| NIHSS | 0.027 | 0.101 | 0.113 | 0.240 | Poland&ndash;Portugal |

- All 84 comparisons: nABCD $< 0.30$ (reference: "small" to "moderate")
- **Age has the largest distributional difference** (Sweden&rsquo;s elderly-focused recruitment)
- **But does the largest nABCD mean the most concern?**

---

# nABCD vs SMD: Real-Data Confirmation

Comparing nABCD and SMD across 28 country pairs confirms simulation findings (S5&ndash;S7):

- **Treatment Delay** (confirmed EM, Emberson $p = 0.016$; skewness = 1.21, excess kurtosis = 20.0):
  - Norway&ndash;Portugal: **SMD = 0.007** ($\approx 0$) but **nABCD = 0.069** &mdash; means identical (4.34 vs 4.33h) yet Norway has extreme skew (6.76) and high SD (1.80 vs 1.21)
  - Poland&ndash;Norway: SMD = 0.151 but nABCD = 0.115 (ratio 0.76) &mdash; scale difference captured
- **Pearson $|r|$** (|SMD| vs nABCD): Treatment delay **0.91** < Age 0.95 < NIHSS 0.98
  - Lower correlation = **more distributional information beyond location**

<div class="alertblock">
<div class="block-title">Key insight</div>
<div class="block-content">

nABCD's advantage emerges precisely when EM distributions are **non-normal** (skewed, heavy-tailed). Treatment delay &mdash; the **strongest confirmed EM** &mdash; shows the greatest SMD&ndash;nABCD divergence in real data.

</div>
</div>

---

<style scoped>
section { font-size: 23px; line-height: 1.4; }
</style>

# IST-3: Clinical Calibration

CATE sensitivity $L$ estimated directly from IST-3 IPD (logistic regression: OHS 0&ndash;2 ~ treatment $\times$ EM):

| EM | Interaction $p$ | $L$ (max &vert;dRD/dEM&vert;) | nABCD max | IQR | $\Delta_{\max}$ |
|----|-----------------|-------------------------------|-----------|-----|-----------------|
| Age | 0.614 | 0.00090 /yr | 0.285 | 9&ndash;17 yr | **0.65%pt** |
| Delay | 0.567 | 0.00901 /hr | 0.195 | 1.7&ndash;2.2 hr | **0.77%pt** |
| NIHSS | **0.001** | 0.01398 /score | 0.240 | 10&ndash;12 | **7.37%pt** |

<div class="alertblock">
<div class="block-title">Triple demonstration</div>
<div class="block-content">

| EM | Role | Key finding |
|----|------|-------------|
| NIHSS | Full calibration ($L$ estimable) | nABCD = 0.240 &rarr; $\Delta_{\max}$ = **5.02&ndash;7.37%pt** (clinically meaningful) |
| Age | Planning-stage assessment ($L$ uncertain) | nABCD = 0.285 &rarr; $\Delta_{\max}$ = **0.47&ndash;0.65%pt** (limited impact) |
| Treatment delay | Distributional comparison advantage | SMD $\approx 0$ yet nABCD = **0.069** (skew/kurtosis invisible to SMD) |

</div>
</div>

---

<style scoped>
section { font-size: 25px; line-height: 1.5; }
</style>

# IST-3: What This Tells Us

<div class="block">
<div class="block-title">Age (nABCD = 0.285, $\Delta_{\max}$ = 0.65%pt)</div>
<div class="block-content">

Sweden&rsquo;s median age (83 yr) vs others (77 yr) creates the **largest distributional gap**. But age has near-zero CATE sensitivity ($L = 0.0009$, interaction $p = 0.61$). Excluding Sweden based on age distribution alone would be **unjustified**. For the planning exercise, benchmarks (Table 3) classify this as 'moderate', but even full calibration confirms limited impact.

</div>
</div>

<div class="alertblock">
<div class="block-title">NIHSS (nABCD = 0.240, $\Delta_{\max}$ = 7.37%pt)</div>
<div class="block-content">

Poland (mean NIHSS 9.6) vs Portugal (14.8): **moderate** distributional gap, but NIHSS is a **strong** effect modifier ($L = 0.014$, interaction $p = 0.001$). The potential treatment effect heterogeneity ($\Delta_{\max} = 7.37$%pt) is $\approx 5\times$ the overall treatment effect (RD = 1.5%pt). **This EM demands scrutiny.** Sensitivity analysis ($0.5\times$&ndash;$2\times$ alteplase $L$): $\Delta_{\max}$ = 2.51&ndash;10.04%pt. Clinically meaningful regardless of precise $L$ for drug A.

</div>
</div>

> **Distribution size $\neq$ clinical consequence.**

---

# Estimation, Not Testing

### Why we do not recommend hypothesis testing

<div class="block">
<div class="block-title">Three reasons</div>
<div class="block-content">

**1. ICH E17 avoids binary rules.** &ensp; Similarity is "context-dependent" &mdash; one threshold cannot serve all diseases, drugs, or regulatory contexts.

**2. $L$ is uncertain.** &ensp; A single test result obscures uncertainty in the CATE sensitivity. Sensitivity tables + CIs provide a more transparent and honest assessment.

**3. Decision boundaries are context-specific.** &ensp; NI trial ($\Delta_{\text{clin}} = 0.4\%$) vs. superiority trial ($\Delta_{\text{clin}} = 0.8\%$) &mdash; same nABCD, different conclusions.

</div>
</div>

> Provide nABCD + 95% CI, $\Delta_{\max}$ + 95% CI, and sensitivity ranges &mdash; **regulatory judgment informed by evidence, not ruled by algorithm.**

---

<!-- _class: section -->

# 5. Discussion

---

# Five Contributions

1. **nABCD metric**
   $W_1$ + IQR normalization + bootstrap &mdash; captures full distributional differences SMD misses

2. **Theoretical framework**
   K-R duality connects nABCD to treatment effect heterogeneity

3. **Clinical calibration (conditional tool)**
   $\Delta_{\max}$ translates nABCD into potential heterogeneity &mdash; when $L$ is estimable

4. **Comparative demonstration (IST-3)**
   nABCD captures distributional features invisible to SMD in real data

5. **Triple demonstration**
   Full calibration (NIHSS) + planning-stage assessment (age) + distributional advantage (treatment delay) in one dataset

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

# When Is $L$ Available?

<div class="block">
<div class="block-title">$L$ estimable (full calibration possible)</div>
<div class="block-content">

Prior trials or meta-analyses in the same therapeutic area provide subgroup interaction data.
Example: NIHSS &mdash; Emberson IPD meta-analysis + IST-3 data.

</div>
</div>

<div class="alertblock">
<div class="block-title">$L$ uncertain (planning-stage assessment)</div>
<div class="block-content">

Novel agents or therapeutic areas lacking subgroup analyses. nABCD + reference benchmarks provide **primary assessment**, supplemented by sensitivity analysis over plausible $L$ ranges.

</div>
</div>

> **nABCD's core value** &mdash; capturing distributional differences invisible to SMD &mdash; holds **regardless** of whether $L$ is available.

---

# Limitations and Future Work

### Current limitations
- Continuous EMs only &mdash; extensions to categorical/mixed-type needed
- Univariate evaluation &mdash; multivariate extension would address EM confounding
- Positive bias at small $n$ under null; negative bias at large true values
- CATE sensitivity $L$ may not always be estimable from prior data
- CATE sensitivity $L$ may not transfer across agents in the same class (e.g., alteplase &rarr; drug A)
- IST-3 data from 2000&ndash;2011; demographic shifts may limit applicability

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
