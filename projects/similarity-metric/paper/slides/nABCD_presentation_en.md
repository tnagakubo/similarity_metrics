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
3. **Simulation**: Estimation performance across 7 scenarios
4. **Application**: Hypothetical thrombolytic MRCT using GUSTO-I
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
- Captures scale and skewness differences that SMD misses

### Req. 2: Scale-free interpretation

- IQR normalization yields a unit-independent index
- Estimation-centered: bootstrap CI + sensitivity, not fixed thresholds

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

# Clinical Calibration: Two Pathways

### Pathway 1: $L$ available — $\Delta_{\max}$

$$
\Delta_{\max} = 2L \cdot \text{IQR}_{\text{pooled}} \cdot \text{nABCD}(F_1, F_2)
$$

- Worst-case regional treatment effect difference on the **clinical scale**
- Confirmatory or post-hoc evaluation when $L$ is estimable

### Pathway 2: $L$ unknown — $L^*$ reverse calculation

$$
L^* = \frac{\Delta_{\text{clin}}}{2 \cdot \text{IQR}_{\text{pooled}} \cdot \text{nABCD}}
$$

- $\Delta_{\text{clin}}$: clinically important difference (e.g., NI margin)
- $L^*$ above plausible range: distributional difference unlikely to be clinically concerning
- **Primary calibration tool at the planning stage**, where $L$ is typically unavailable

### Estimation-Centered Design

- No fixed nABCD cutoff
- Quantitative inputs (point estimate + bootstrap CI + $L^*$) support sponsor judgment

---

<!-- _class: section -->

# Simulation

---

# Simulation Design

### Seven Scenarios

| ID | Description | Distribution 1 | Distribution 2 | True nABCD |
|----|-------------|-----------------|-----------------|------------|
| S1 | Null (identical) | $N(50, 10^2)$ | $N(50, 10^2)$ | 0.000 |
| S2 | Location 0.2$\sigma$ | $N(50, 10^2)$ | $N(52, 10^2)$ | 0.073 |
| S3 | Location 0.5$\sigma$ | $N(50, 10^2)$ | $N(55, 10^2)$ | 0.180 |
| S4 | Location 1.0$\sigma$ | $N(50, 10^2)$ | $N(60, 10^2)$ | 0.328 |
| S5 | Scale 1.5x | $N(50, 10^2)$ | $N(50, 15^2)$ | 0.122 |
| S6 | Skew (Log-normal) | $N(50, 10^2)$ | LogN | 0.304 |
| S7 | Location + Scale | $N(50, 10^2)$ | $N(55, 15^2)$ | 0.175 |

$n = 50, 100, 200$ per region; 10,000 replications; $B = 2{,}000$ bootstrap resamples

---

# Simulation Results: Bias and Coverage

### Bias ($n = 100$)

- True nABCD $\geq 0.1$: bias $< 0.02$
- S3 (0.5$\sigma$): +0.003, S4 (1.0$\sigma$): +0.003 --- negligible
- Near-boundary scenarios (S1): larger positive bias (non-negativity constraint)

### Coverage Probability (95% CI, $n = 100$)

| Scenario | $n = 50$ | $n = 100$ | $n = 200$ |
|----------|----------|-----------|-----------|
| S3 (0.5$\sigma$) | 0.947 | 0.951 | 0.947 |
| S4 (1.0$\sigma$) | 0.950 | 0.950 | 0.957 |
| S6 (Skew) | 0.953 | 0.954 | 0.954 |
| S7 (Loc+Scale) | 0.917 | 0.935 | 0.944 |

**Recommendation**: $n \geq 100$ per region for reliable estimation and inference

---

# nABCD vs SMD: Sensitivity Comparison ($n = 100$)

| Scenario | nABCD (mean $\pm$ SD) | SMD (mean $\pm$ SD) | Implication |
|----------|----------------------|--------------------|----|
| S3 (Location) | $0.183 \pm 0.048$ | $0.50 \pm 0.14$ | Both detect |
| S5 (Scale only) | $0.136 \pm 0.033$ | $0.00 \pm 0.14$ | **Only nABCD detects** |
| S6 (Skew only) | $0.312 \pm 0.048$ | $0.00 \pm 0.14$ | **Only nABCD detects** |

### Key Finding

- Location shift: SMD and nABCD provide equivalent information
- **Scale and skewness**: SMD remains at zero --- only nABCD detects
- S6 is particularly striking: a large distributional difference (nABCD $= 0.31$) is entirely invisible to SMD

---

<!-- _class: section -->

# Application

---

# Application: Hypothetical Thrombolytic MRCT (GUSTO-I)

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

# nABCD Results: Region 8 vs 15 Partners

### Age nABCD

- Range: **0.011 (R5, R7) -- 0.076 (R3)** — narrow
- 11 of 15 partners $< 0.040$

### SBP nABCD

- Range: **0.015 (R2) -- 0.110 (R9)** — wider than Age
- Most partners cluster in 0.050--0.110

### Bootstrap CIs

- Mid-rank CIs overlap → ranking confidence varies
- CI widths reported alongside point estimates to convey precision

---

# R2 vs R9: Why Joint Evaluation Is Essential

### Contrasting Pattern

| | R2 | R9 |
|---|----|----|
| nABCD$_{\text{age}}$ | **0.061** (2nd largest) | 0.017 (4th smallest) |
| nABCD$_{\text{SBP}}$ | **0.015** (smallest) | **0.110** (largest) |

### Implication

- A single effect modifier produces **opposite conclusions**
- R2: best on SBP, near-worst on Age
- R9: good on Age, worst on SBP
- **All candidate effect modifiers must be evaluated jointly**

---

# Leading Pooling Candidates: R4, R6, R13

### Joint Assessment

- **R4, R6, R13** rank low on both candidate effect modifiers
- All six nABCD values lie in lower portions of observed ranges
  - Age: 0.011--0.076 → R4, R6, R13 in lower portion
  - SBP: 0.015--0.110 → R4, R6, R13 in lower portion
- Required $L^*$ values fall near lower end of clinically plausible range for thrombolysis class evidence

### Sponsor Implication (soft prioritization)

> "the sponsor may reasonably prioritize R4, R6, and R13 as the leading candidates for pooling with Region 8"

- Quantitative inputs supporting prioritization, not a binary verdict
- Final judgment rests with sponsor in consultation with clinical / regulatory advisors

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
- **R4, R6, R13** emerged as leading candidates — low on both modifiers, plausible $L^*$

---

# Interpretation: Two Implications

### Implication 1: Evaluate all candidate effect modifiers jointly

- R2 vs R9 contrast: a partner similar on one modifier may not be on another
- Restricting to a subset risks omitting modifiers that later compromise consistency

### Implication 2: Partner selection cannot rest on nABCD alone

- $L^*$ varies markedly across partners and modifiers
- Same nABCD carries different clinical weight depending on partner-specific differences
- R4, R6, R13 emerged as leading candidates because of **both** low nABCD **and** clinically plausible $L^*$

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
\boxed{|\bar{\tau}_1 - \bar{\tau}_2| \leq 2L \cdot \text{IQR}_{\text{pooled}} \cdot \text{nABCD}}
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
