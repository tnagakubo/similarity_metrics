---
marp: true
size: 16:9
paginate: true
header: "July 3, 2026"
footer: ""
style: |
  /* ============================================
     Marp Slide Template — Poster_GSC_TN port
     Accent: #D52B1E (red), #d47e78 (coral)
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

  section::before { display: none; }

  section h1 {
    position: absolute;
    top: 0; left: 0; right: 0;
    box-sizing: border-box;
    background: var(--accent1);
    color: white;
    font-size: 40px;
    font-weight: 700;
    padding: 18px 60px 14px;
    margin: 0;
    line-height: 1.4;
    z-index: 2;
  }

  section h2 {
    color: var(--accent1);
    font-size: 32px;
    font-weight: 700;
    border-bottom: 3px solid var(--accent2);
    padding-bottom: 6px;
    margin-bottom: 16px;
  }

  section h3 {
    color: var(--accent2);
    font-size: 26px;
    font-weight: 700;
  }

  header {
    font-family: 'Noto Sans JP', sans-serif;
    position: absolute;
    top: auto; bottom: 4px; left: 20px; right: auto;
    font-size: 14px;
    color: var(--text-light);
    z-index: 2;
  }

  footer {
    font-family: 'Noto Sans JP', sans-serif;
    position: absolute;
    top: auto; bottom: 4px; left: 0; right: 0;
    width: 100%;
    font-size: 14px;
    color: var(--text-light);
    text-align: center;
    z-index: 2;
  }

  section::after {
    font-family: 'Noto Sans JP', sans-serif;
    position: absolute;
    bottom: 4px; right: 20px; top: auto; left: auto;
    width: auto; height: auto;
    font-size: 14px;
    color: var(--text-light);
    background: none;
    padding: 0;
    text-align: right;
    z-index: 2;
  }

  section strong { color: var(--accent2); font-weight: 700; }
  section ul, section ol { line-height: 1.4; margin-left: 10px; }
  section li { line-height: 1.4; margin-bottom: 4px; }
  section li::marker { color: var(--accent1); }

  section img {
    max-height: 60%;
    border-radius: 4px;
    display: block;
    margin: 0 auto;
  }

  /* Beamer-style block */
  section .block {
    margin: 12px 0 0 0;
    border-radius: 6px;
    overflow: hidden;
    border: 1px solid #E0E0E0;
  }

  section .block + .block { margin-top: 8px; }

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

  section .block-body > *:first-child { margin-top: 0; }
  section .block-body > *:last-child { margin-bottom: 0; }

  /* Title slide */
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
    font-size: 56px;
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
    font-size: 28px;
    margin: 6px 0;
    color: white;
  }

  section.title .affil {
    font-size: 20px;
    margin-top: 16px;
    color: rgba(255,255,255,0.85);
  }

  section.title::before, section.title header,
  section.title footer, section.title::after { display: none; }

  /* Section divider */
  section.section {
    background: var(--accent1);
    color: white;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: flex-start;
    padding: 60px;
  }

  section.section h1 {
    position: static;
    background: transparent;
    color: white;
    font-size: 64px;
    margin: 0;
    padding: 0 0 16px 0;
    border-bottom: 4px solid var(--accent2);
  }

  section.section header, section.section footer,
  section.section::after { display: none; }

  /* Two-column */
  section.cols {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 0 30px;
  }

  section.cols h1 {
    position: absolute;
    top: 0; left: 0; right: 0;
    grid-column: 1 / -1;
  }

  /* End slide */
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

  section.end p { color: rgba(255,255,255,0.7); font-size: 26px; }
  section.end::before, section.end header,
  section.end footer, section.end::after { display: none; }

---

<!-- _class: title -->
<!-- _paginate: false -->

# Quantifying Effect Modifiers Similarity for Regional Pooling Strategy in Multi-Regional Clinical Trials

## 
Takashi Nagakubo

---

# Outline

1. **Introduction**: Background and objectives
2. **Methods**: nABCD definition, theoretical foundation, and clinical calibration
3. **Simulation**: Estimation performance across 7 scenarios
4. **Application**: Hypothetical thrombolytic MRCT using GUSTO-I
5. **Discussion**: Key findings and future work

---
# Background and Objectives

## Background

- Treatment effect consistency across regions is assessed in MRCTs
- Individual regional sample sizes are often too small alone for consistency assessment
- **ICH E17 strategy**: pool regions with similar **effect modifier (EM)** distributions
- At the **planning stage**, sponsors must select pooling partners with evidence that regions are "similar enough"

## Objectives

- Develop a **quantitative index** that captures distributional similarity
- Deliver a **practitioner-facing tool** for the planning stage of an MRCT

---

<!-- _class: section -->

# Methods

---

# Dissimilarity Index: nABCD

<div class="block">
<div class="block-title">Wasserstein-1 distance</div>
<div class="block-body">

$$
W_1(F_1, F_2) = \int |F_1(x) - F_2(x)|\, dx
$$

The total area between two CDFs — captures **location, scale, and shape** differences.

</div>
</div>

<div class="block">
<div class="block-title">nABCD: normalized Area Between Cumulative Distributions</div>
<div class="block-body">

$$
\text{nABCD}(F_1, F_2) = \frac{W_1(F_1, F_2)}{\text{IQR}_{\text{pooled}}}
$$

Scale-free dissimilarity; a 1-IQR location shift yields nABCD = 1.0.

</div>
</div>

![h:240px](../figures/fig1_nabcd_definition_color.png)

---

# Heterogeneity Bound

### Kantorovich–Rubinstein Duality

$$
W_1(F_1, F_2) = \sup_{\|f\|_{\text{Lip}} \leq 1} \left|\int f\, dF_1 - \int f\, dF_2\right|
$$

<div class="block">
<div class="block-title">Heterogeneity Bound</div>
<div class="block-body">

If the CATE $\tau(x)$ is Lipschitz continuous with constant $L$:

$$
|\bar{\tau}_1 - \bar{\tau}_2| \leq L \cdot \text{IQR}_{\text{pooled}} \cdot \text{nABCD}(F_1, F_2)
$$

- $L$: upper bound on treatment effect change per unit change in the EM
- **Theoretical bridge** from distributional distance to treatment effect differences

</div>
</div>

---

# Estimation

### Empirical estimator

$$
\widehat{\text{nABCD}} = \frac{\sum_{k=1}^{n_1+n_2-1} |\hat{F}_1(x_{(k)}) - \hat{F}_2(x_{(k)})| \cdot (x_{(k+1)} - x_{(k)})}{\widehat{\text{IQR}}_{\text{pooled}}}
$$


### Inference: Percentile bootstrap

- Asymptotic distribution non-standard: $\sqrt{n}\, W_1(\hat{F}_n, F) \xrightarrow{d} \int |B(F)|\, dx$ — Brownian bridge (del Barrio 1999)
- No universal critical values → **percentile bootstrap** ($B = 2{,}000$ resamples)
- Boundary case $F_1 = F_2$: parameter space edge — addressed in simulation

---


# Clinical Calibration

<div class="block">
<div class="block-title">Pathway 1 — When L is available</div>
<div class="block-body">

$$
\Delta_{\max} = L \cdot \text{IQR}_{\text{pooled}} \cdot \text{nABCD}
$$

Worst-case regional treatment effect difference on the **clinical scale**.

</div>
</div>

<div class="block">
<div class="block-title">Pathway 2 — When L is unknown</div>
<div class="block-body">

$$
L^* = \frac{\Delta_{\text{clin}}}{\text{IQR}_{\text{pooled}} \cdot \text{nABCD}}
$$

- $\Delta_{\text{clin}}$: clinically important difference
- $L^*$ above plausible range $\Rightarrow$ distributional difference unlikely to be clinically concerning

</div>
</div>

---


# Simulation Design

- Distribution pairs for scenarios (**S1–S7**) covering:
  - Null (S1), location-shift (S2–S4), scale-shift (S5), skewness (S6), combined location+scale (S7)
- **10,000 replications** per scenario × sample size cell
- Sample sizes: **n = 50, 100, 200** per region
- Bootstrap **B = 2,000**, percentile 95% CIs

![h:380px](../figures/slide_scenario_overview_color.png)

---

# Simulation Results

<div class="block">
<div class="block-title">Bias</div>
<div class="block-body">

Bias is **negligible** for non-null scenarios (S3–S7) at $n \geq 100$. At the null (S1), a positive bias persists because the Wasserstein distance is **non-negative**.

</div>
</div>

<div class="block">
<div class="block-title">Coverage</div>
<div class="block-body">

95% bootstrap CI coverage is **0.88–0.96** for non-null scenarios (S3–S7) at $n \geq 100$. At the null (S1), the non-negative bootstrap CI cannot contain zero.

</div>
</div>

<div class="block">
<div class="block-title">CI Width</div>
<div class="block-body">

CI width **shrinks with sample size** as expected.

</div>
</div>

![h:240px](../figures/fig2_simulation_results_color.png)


---

# Application: GUSTO-I

### Goal

A sponsor planning a Phase 3 MRCT for a novel **thrombolytic** in acute myocardial infarction (AMI) must identify pooling partners for a region within a regulatory market. **Age** and **systolic blood pressure (SBP)** are candidate EMs. The goal is to identify regions with similar EM distributions to the anchor region (**Region 8**).

### Data

- **GUSTO-I** individual patient data (**16 anonymized regions**) serves as the distributional source
- Anchor: Region 8; remaining 15 regions evaluated as candidate pooling partners

---

# Application: Joint Eligibility via L*

![h:380px](../figures/fig3_gusto_r8_forest_color.png)

- **Joint eligibility** at $\Delta_{\text{clin}} = 1\%\text{pt}$ with class-level upper bounds ($L_{\text{UB,age}} = 10^{-2}$/yr; $L_{\text{UB,SBP}} = 2{\times}10^{-3}$/mmHg): **6 partners (R1, R4, R5, R6, R14, R15)** emerge as jointly eligible on both EMs
- **R4** is the leading candidate — balanced ranking on both EMs


---

# Findings

1. **Methodological gap filled**: nABCD provides the **quantitative metric** for EM distributional similarity — transforming "sufficiently similar" from qualitative judgement into a reproducible quantitative basis.

2. **Heterogeneity bound**: Via Kantorovich–Rubinstein duality, the maximum CATE difference is bounded — providing the theoretical bridge from distributional distance to treatment effect differences.

3. **Reliable bootstrap inference at moderate n**: Across 7 simulation scenarios, small bias and adequate coverage for non-null distributional differences at $n \geq 100$.

4. **Dual-pathway clinical calibration**: When $L$ is estimable, $\Delta_{\max}$ gives clinical-scale interpretation; when $L$ is unknown, $L^*$ reverse-calculation supports judgement without imposing a fixed nABCD cutoff.

---

# Future Work

1. **Categorical EM extension**
   Current framework focuses on continuous EMs; extension to binary and multi-level categorical EMs requires distinct distance metrics designed for discrete distributions.

2. **Multivariate extension**
   EM evaluation could be extended to joint multivariate distributional comparison via Wasserstein-2 or sliced Wasserstein distances, capturing correlation structure.

3. **Upstream EM identification**
   Which baseline characteristics constitute relevant EMs is a non-trivial pre-step assumed solved in this work; formal methodology deserves dedicated investigation.


