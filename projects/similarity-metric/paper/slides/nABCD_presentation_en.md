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
    --accent1: #003818;
    --accent2: #008539;
    --text-main: #000000;
    --text-light: #505050;
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
    font-size: 48px;
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

# Quantifying Effect Modifier Similarity for Regional Pooling in MRCTs

##

Tak Nagakubo

---

# Agenda

1. **Background**: MRCTs, ICH E17, and limitations of existing measures
2. **Methods**: nABCD definition, theoretical foundation, and clinical calibration
3. **Simulation**: Estimation performance across 8 scenarios
4. **Application**: IST-1 (Case A) / IST-3 (Case B)
5. **Discussion**: Key findings and practical recommendations

---

<!-- _class: section -->

# Background

---

# MRCTs and ICH E17

- **MRCTs** (Multi-Regional Clinical Trials) are the standard paradigm for global drug development
- ICH E17 (2017) established principles for planning MRCTs, assuming generalizable treatment effects
- Regulatory authorities expect demonstration of **treatment effect consistency** in regional subpopulations

### The Need for Regional Pooling

- Individual regional sample sizes are often insufficient for consistency assessment
- ICH E17 describes pooling based on **effect modifier distributional similarity**
- However, no quantitative methodology is provided

> The criterion for "similar enough" is absent
> --- Implementation gap in ICH E17

---

# What Is an Effect Modifier?

**Effect modifier**: a baseline patient characteristic for which treatment benefit differs across subgroups

### Example: Age as an effect modifier

- If younger patients respond better, age is an effect modifier
- Even if the drug works identically at the individual level, different patient compositions yield different regional average treatment effects

### Regional Average Treatment Effect

$$
\bar{\tau}_r = \int \tau(x) \, dF_r(x)
$$

$\tau(x)$: CATE (conditional average treatment effect), $F_r$: effect modifier distribution in region $r$

---

# Limitations of Existing Measures

| Measure | Strength | Limitation |
|---------|----------|------------|
| **SMD** | Scale-free, easy to interpret | **Location (mean) only**. Ignores variance and shape |
| **KS statistic** | Compares full distribution | Lacks clinical interpretability; no link to treatment effects |
| **KL divergence** | Density-based | Asymmetric, unstable with small samples, can diverge to $\infty$ |

### The Blind Spot of SMD

$$
N(50, 5^2) \text{ vs } N(50, 15^2) \implies \text{SMD} = 0
$$

A threefold difference in variance is completely invisible to SMD

---

<!-- _class: section -->

# Methods

---

# Definition of nABCD

### Wasserstein-1 Distance (Earth Mover's Distance)

$$
W_1(F, G) = \int_{-\infty}^{\infty} |F(x) - G(x)| \, dx
$$

Geometric interpretation: **total area between two CDFs**

### nABCD: Normalized Area Between Cumulative Distributions

$$
\text{nABCD}(F_1, F_2) = \frac{W_1(F_1, F_2)}{2 \cdot \text{IQR}_{\text{pooled}}}
$$

- $\text{IQR}_{\text{pooled}}$: interquartile range of the pooled distribution
- Factor of 2 calibrates so that a 1-IQR location shift yields nABCD $= 0.5$
- **Scale-free**: interpretation does not depend on measurement units

---

# Three Requirements Satisfied by nABCD

### Req. 1: Beyond location differences

- $W_1$ responds to differences in location, variance, and skewness
- Captures scale and shape differences that SMD misses

### Req. 2: Clinical interpretability

- IQR normalization yields a scale-free index
- Reference benchmarks enable initial assessment

### Req. 3: Theoretical link to treatment effects

- Kantorovich-Rubinstein duality provides an upper bound on treatment effect heterogeneity
- This property is unique to $W_1$ (not available for $W_2$, KS, or KL)

---

# Theoretical Foundation: Link to Treatment Effect Heterogeneity

### Kantorovich-Rubinstein Duality

$$
W_1(F_1, F_2) = \sup_{\|f\|_{\text{Lip}} \leq 1} \left|\int f \, dF_1 - \int f \, dF_2\right|
$$

### Heterogeneity Bound (Proposition 2)

If the CATE $\tau(x)$ is Lipschitz continuous with constant $L$:

$$
|\bar{\tau}_1 - \bar{\tau}_2| \leq 2L \cdot \text{IQR}_{\text{pooled}} \cdot \text{nABCD}(F_1, F_2)
$$

- $L$: upper bound on treatment effect change per unit change in the effect modifier
- **A quantitative bridge from distributional distance to treatment effect differences**

---

# Clinical Calibration: $\Delta_{\max}$

### Maximum Potential Treatment Effect Difference

$$
\Delta_{\max} = 2L \cdot \text{IQR}_{\text{pooled}} \cdot \text{nABCD}(F_1, F_2)
$$

### Calibration Procedure

1. Compute nABCD + bootstrap CI for each candidate effect modifier
2. Estimate $L$ from prior evidence (e.g., subgroup analyses)
3. Compute $\Delta_{\max}$ --- the worst-case treatment effect difference
4. Derive bootstrap CI for $\Delta_{\max}$ from the nABCD CI
5. Report alongside overall treatment effect and non-inferiority margin

> Not a fixed threshold, but an **estimation-centered approach** supporting context-dependent clinical judgment

---

# When $L$ Is Unknown: Sensitivity Analysis

### Reverse Calculation ($L^*$ Sensitivity Analysis)

$$
L^* = \frac{\Delta_{\text{clin}}}{2 \cdot \text{IQR}_{\text{pooled}} \cdot \text{nABCD}}
$$

- $\Delta_{\text{clin}}$: clinically important treatment effect difference (e.g., overall effect, NI margin)
- If $L^*$ exceeds plausible range, the distributional difference is unlikely to be clinically concerning
- If $L^*$ is small, mitigation strategies for distributional heterogeneity are warranted

### Reference Benchmarks

| nABCD Range | Distributional Magnitude | Guidance |
|-------------|--------------------------|----------|
| $< 0.05$ | Negligible | Clinical calibration unlikely to reveal meaningful $\Delta_{\max}$ |
| $0.05$--$0.15$ | Small | Calibration recommended if $L$ is available |
| $0.15$--$0.30$ | Moderate | Calibration important; interpret in clinical context |
| $> 0.30$ | Large | Calibration essential before pooling deliberation |

---

<!-- _class: section -->

# Simulation

---

# Simulation Design

### Eight Scenarios

| ID | Description | Distribution 1 | Distribution 2 | True nABCD |
|----|-------------|-----------------|-----------------|------------|
| S1 | Null (identical) | $N(50, 10^2)$ | $N(50, 10^2)$ | 0.000 |
| S2 | Location 0.2$\sigma$ | $N(50, 10^2)$ | $N(52, 10^2)$ | 0.073 |
| S3 | Location 0.5$\sigma$ | $N(50, 10^2)$ | $N(55, 10^2)$ | 0.180 |
| S4 | Location 1.0$\sigma$ | $N(50, 10^2)$ | $N(60, 10^2)$ | 0.328 |
| S5 | Scale 1.5x | $N(50, 10^2)$ | $N(50, 15^2)$ | 0.122 |
| S6 | Shape (Gamma) | $N(50, 10^2)$ | Gamma$(25, 0.5)$ | 0.024 |
| S7 | Skew (Log-normal) | $N(50, 10^2)$ | LogN | 0.304 |
| S8 | Location + Scale | $N(50, 10^2)$ | $N(55, 15^2)$ | 0.175 |

$n = 50, 100, 200$ per region; 10,000 replications; $B = 2{,}000$ bootstrap resamples

---

# Simulation Results: Bias and Coverage

### Bias ($n = 100$)

- True nABCD $\geq 0.1$: bias $< 0.02$
- S3 (0.5$\sigma$): +0.003, S4 (1.0$\sigma$): +0.003 --- negligible
- Near-boundary scenarios (S1, S6): larger positive bias (non-negativity constraint)

### Coverage Probability (95% CI, $n = 100$)

| Scenario | $n = 50$ | $n = 100$ | $n = 200$ |
|----------|----------|-----------|-----------|
| S3 (0.5$\sigma$) | 0.947 | 0.951 | 0.947 |
| S4 (1.0$\sigma$) | 0.950 | 0.950 | 0.957 |
| S7 (Skew) | 0.953 | 0.954 | 0.954 |
| S8 (Loc+Scale) | 0.917 | 0.935 | 0.944 |

**Recommendation**: $n \geq 100$ per region for reliable estimation and inference

---

# nABCD vs SMD: Sensitivity Comparison ($n = 100$)

| Scenario | nABCD (mean $\pm$ SD) | SMD (mean $\pm$ SD) | Implication |
|----------|----------------------|--------------------|----|
| S3 (Location) | $0.183 \pm 0.048$ | $0.50 \pm 0.14$ | Both detect |
| S5 (Scale only) | $0.136 \pm 0.033$ | $0.00 \pm 0.14$ | **Only nABCD detects** |
| S6 (Shape only) | $0.070 \pm 0.025$ | $0.00 \pm 0.14$ | **Only nABCD detects** |
| S7 (Skew only) | $0.312 \pm 0.048$ | $0.00 \pm 0.14$ | **Only nABCD detects** |

### Key Finding

- Location shift: SMD and nABCD provide equivalent information
- **Scale, shape, skewness**: SMD remains at zero --- only nABCD detects
- S7 is particularly striking: a large distributional difference (nABCD $= 0.31$) is entirely invisible to SMD

---

<!-- _class: section -->

# Application

---

# Application: Two Planning Scenarios

### Hypothetical Scenario

Planning a Phase 3 MRCT for a novel thrombolytic agent (drug A)

### Case A: Effect Modifier Unknown (IST-1)

- IST-1: 31 countries, 19,435 patients (1991--1996)
- No significant treatment x effect modifier interaction (all $p > 0.05$)
- $L$ not estimable --- use **$L^*$ sensitivity analysis**

### Case B: Effect Modifier Identified (IST-3)

- IST-3: 8 countries, 3,035 patients (2000--2012)
- NIHSS: interaction $p = 0.001$, $L$ estimable
- Use **clinical calibration** to compute $\Delta_{\max}$

---

# Case A: IST-1 --- Geographic Distributional Heterogeneity

### Distribution Patterns Across 31 Countries (Age)

- **Maximum nABCD**: India--UK = 0.565 (approx. 4x the IST-3 maximum)
- Asian countries: India (0.375) > Singapore (0.205) > Hong Kong (0.121)
- Geographic clustering reflects demographic and healthcare access patterns

### $L^*$ Sensitivity Analysis (India--UK)

- nABCD $= 0.565$: the $L^*$ needed to produce $\Delta_{\max} = 2$%pt is approx. $0.005$/year
- A **small age-related interaction** could produce clinically meaningful heterogeneity
- Explicit mitigation strategies (stratified randomization, protocol restrictions) are warranted

> Small $L^*$ = high risk from distributional heterogeneity

---

# Case B: IST-3 --- nABCD vs SMD in Real Data

### nABCD Summary (28 pairs)

| Effect Modifier | Median | Max | Max pair |
|----------------|--------|-----|----------|
| Age | 0.103 | 0.285 | SE--BE |
| NIHSS | 0.101 | 0.240 | PL--PT |
| Delay | 0.098 | 0.195 | SE--AU |

### SMD Misses This Case

Norway--Portugal (treatment delay):
- Means: 4.34 vs 4.33 h
- **SMD = 0.007** (nearly identical)
- **nABCD = 0.069** (detects shape difference)
- Norway: extreme right tail (skewness 6.76); Portugal: compact distribution (skewness $-0.23$)

---

# Case B: Clinical Calibration Results

### NIHSS vs Age: A Critical Contrast

| | NIHSS | Age |
|---|-------|-----|
| Interaction $p$ | **0.001** | 0.614 |
| $L_{\text{mean}}$ | 0.00950/pt | 0.00065/yr |
| nABCD (max) | 0.240 | 0.285 |
| $\Delta_{\max}$ ($L_{\text{mean}}$) | **5.02%pt** | 0.47%pt |
| $\Delta_{\max}$ ($L_{\max}$) | **7.37%pt** | 0.65%pt |

Overall treatment effect RD $\approx$ +1.5%pt

### Core Finding

- Age has the **larger** nABCD (0.285 > 0.240)
- Yet $\Delta_{\max}$ for NIHSS is **more than 10x larger**
- **Distributional distance ranking $\neq$ clinical impact ranking**

---

<!-- _class: section -->

# Discussion

---

# Key Findings: Three Advantages of nABCD

### 1. Captures Distributional Differences That SMD Misses

- Simulation: S5 (scale), S6 (shape), S7 (skew) --- SMD $\approx 0$ but nABCD detects
- IST-3: Norway--Portugal (treatment delay) confirms the same pattern in real data

### 2. Theoretical Link to Treatment Effect Heterogeneity

- Heterogeneity bound provides a quantitative bridge to $\Delta_{\max}$
- This property is unique to $W_1$ (unavailable for KS statistic, KL divergence)

### 3. Objective, Reproducible Inference

- Bootstrap CI enables formal statistical inference
- Quantitative and reproducible, unlike visual inspection

---

# Practical Recommendations

1. Compute **nABCD + bootstrap CI** for each candidate effect modifier ($n \geq 100$ per region)

2. When $L$ is estimable: report **$\Delta_{\max}$** and its CI on the clinical scale
   - Present both $L_{\max}$ (conservative bound) and $L_{\text{mean}}$ (realistic estimate)

3. When $L$ is unknown: use **reference benchmarks** for initial assessment + $L^*$ sensitivity analysis

4. Report $\Delta_{\max}$ **alongside** the overall treatment effect and non-inferiority margin

5. For multiple effect modifiers: conservative judgment based on maximum $\Delta_{\max}$,
   or a totality-of-evidence approach across all $\Delta_{\max}$ values

> Not a fixed threshold, but **context-dependent clinical judgment**
> --- Implementing ICH E17's "similar enough"

---

# Summary

### The Gap Filled by nABCD

- Addresses the **lack of quantitative methodology** in ICH E17
- Applicable at the planning stage (computable from prior trials, registries, RWE data)
- $\Delta_{\max}$ calibration supports **evidence-based and clinically grounded** pooling decisions

### Central Message

$$
\boxed{|\bar{\tau}_1 - \bar{\tau}_2| \leq 2L \cdot \text{IQR}_{\text{pooled}} \cdot \text{nABCD}}
$$

**Distributional distance ranking $\neq$ clinical impact ranking**

--- nABCD magnitude alone is not sufficient; clinical calibration is the key to pooling decisions

---

<!-- _class: end -->
<!-- _paginate: false -->

# Thank You

Questions welcome

Tak Nagakubo
