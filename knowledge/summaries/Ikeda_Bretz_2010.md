# Ikeda & Bretz (2010) - Sample Size and Proportion of Japanese Patients in Multi-Regional Trials

## Citation
Ikeda, K. & Bretz, F. (2010). "Sample size and proportion of Japanese patients in multi-regional trials." *Pharmaceutical Statistics*, 9(3): 207-216.
DOI: [10.1002/pst.455](https://doi.org/10.1002/pst.455)

## Overview

This paper addresses a critical practical problem in multi-regional clinical trials: **How many Japanese patients are needed to demonstrate consistency** between the Japanese subpopulation and the entire study population? The authors analyze the Japanese MHLW guidance on "Basic Principles on Global Clinical Trials" and derive closed-form expressions for the probability of showing a consistent result. They also propose an **alternative method with better operating characteristics**.

## Background: Japanese Regulatory Context

The Japanese Ministry of Health, Labour and Welfare (MHLW) guidance [7] introduces two methods for determining the Japanese sample size:

### Method 1 (MHLW Guidance)
Requires that the number of Japanese patients is sufficiently large to ensure:
$$D_J / D_{ALL} > \omega$$
with probability of at least 80%, where:
- $D_J$ = observed treatment effect in Japanese patients
- $D_{ALL}$ = observed treatment effect in all patients
- $\omega$ = pre-specified threshold (typically 0.5)

### Method 2 (MHLW Guidance)
Requires that the sample size is sufficiently large to demonstrate a consistent trend for all individual regions.

## Key Notation

| Symbol | Meaning |
|--------|---------|
| $D_J$ | Observed treatment effect in Japanese patients |
| $D_{ALL}$ | Observed treatment effect in all patients |
| $D_{NJ}$ | Observed treatment effect in non-Japanese patients |
| $\delta$ | True treatment effect (assumed same across populations) |
| $\sigma^2$ | Common variance |
| $n_a, n_b$ | Sample sizes in treatment groups $a$ and $b$ |
| $p$ | Proportion of Japanese patients |
| $\omega$ | Consistency threshold (typically 0.5) |
| $\eta_A$ | Probability of detecting significant overall effect |
| $\eta_B$ | Probability of showing consistent result (Method 1) |
| $\eta_C$ | Joint probability of $\eta_A$ and consistent result |
| $\eta_D$ | Conditional probability of consistency given overall significance |

## Main Results

### Joint Distribution of $(D_{ALL}, D_J)$

The vector $\mathbf{d} = (D_{ALL}, D_J)'$ follows a bivariate normal distribution:
$$\mathbf{d} \sim \mathcal{N}(\boldsymbol{\delta}, \boldsymbol{\Sigma})$$

where:
$$\boldsymbol{\delta} = (\delta_{ALL}, \delta_J)', \quad \delta_{ALL} = p\delta_J + (1-p)\delta_{NJ}$$

$$\boldsymbol{\Sigma} = \frac{n_a + n_b}{n_a n_b} \begin{pmatrix} 1 & \frac{1}{p} \\ \frac{1}{p} & 1 \end{pmatrix}$$

### Probability of Consistent Result (Method 1)

$$\eta_B = \Pr(D_J / D_{ALL} > \omega) \approx \Phi\left(\frac{\delta(1-\omega)\sqrt{n_a n_b p}}{\sigma\sqrt{(n_a + n_b)(p\omega^2 - 2p\omega + 1)}}\right)$$

where $\Phi(\cdot)$ is the standard normal CDF.

### Joint Probability of Overall Significance and Consistency

$$\eta_C = \Pr\left(\frac{D_J}{D_{ALL}} > \omega \text{ and } \frac{D_{ALL}}{\sigma}\sqrt{\frac{n_a n_b}{n_a + n_b}} > z_{1-\alpha}\right)$$

This requires evaluation of bivariate normal probabilities.

### Required Proportion of Japanese Patients

For a given power $1-\gamma$, the required proportion $p$ is approximately:
$$p \approx \frac{z_{1-\gamma}^2 (n_a + n_b)}{\delta^2 (1-\omega)^2 n_a n_b - z_{1-\gamma}^2 \sigma^2 \omega (n_a + n_b)(\omega - 2)}$$

Simplifying when using the sample size formula:
$$p \approx \frac{z_{1-\gamma}^2}{(1-\omega)^2 (z_{1-\alpha} + z_{1-\beta})^2 - z_{1-\gamma}^2 \omega(\omega - 2)}$$

## New Approach (Section 3)

### Problem with Method 1
The authors identify a **notable property** (undesirable): Even when $D_{ALL}$ and $D_J$ fall in certain regions, Method 1 would fail to show consistency despite:
- Achieving statistical significance for the entire population
- Observing better results in both populations than expected

### New Method: Hypothesis Test Approach

Instead of requiring $D_J / D_{ALL} > \omega$, use a hypothesis test:
- $H_J$: $\delta_J \leq 0$ (no beneficial effect in Japanese)
- $K_J$: $\delta_J > 0$ (beneficial effect in Japanese)

**Consistency criterion**: If the associated p-value is less than or equal to a threshold $\phi$, consistency is claimed.

### Probability of Consistent Result (New Approach)

$$\eta'_B = \Pr\left(\frac{D_J}{\sigma}\sqrt{\frac{n_a n_b}{n_a + n_b}} > z_{1-\phi}\right) = \Phi((z_{1-\alpha} + z_{1-\beta})\sqrt{p} - z_{1-\phi})$$

### Required Proportion (New Approach)

$$p \geq \frac{(z_{1-\phi} + z_{1-\gamma})^2}{(z_{1-\alpha} + z_{1-\beta})^2}$$

**Key advantage**: For a fixed $\phi$, the required number of Japanese patients remains unchanged regardless of power.

### Choice of $\phi$

To match the strictness of Method 1 with $\omega = 0.5$:
- For $\alpha = 0.025$ and $\omega = 0.5$: $\phi = 0.25$ gives similar strictness
- This requires 22.5-28.6% Japanese patients to achieve $\eta_B = 0.8$
- New approach requires 21.9-29.3% Japanese patients for 80-90% power

## Numerical Results

### Table I: Probability of Consistent Result (%)

| Power | Method | $\eta_A$ | $\eta_B$ | $\eta'_B$ | $\eta_C$ | $\eta'_C$ | $\eta_D$ | $\eta'_D$ |
|-------|--------|----------|----------|-----------|----------|-----------|----------|-----------|
| 0.80 | New | 79.89 | 79.29 | 68.61 | 85.88 | - | - | - |
| 0.80 | Method 1 | 79.89 | 79.92 | 66.58 | 83.34 | - | - | - |
| 0.90 | New | 89.93 | 80.57 | 75.40 | 83.84 | - | - | - |
| 0.90 | Method 1 | 89.93 | 80.02 | 73.47 | 81.70 | - | - | - |

### Table II: False-Positive Error Rates (%)

When there is no effect ($\delta_J = \delta_{NJ} = 0$):
- New approach: 25.00% (for $\phi = 0.25$)
- Method 1: ~25-30%

When effect exists only in non-Japanese ($\delta_J = 0, \delta_{NJ} = 1$):
- New approach has comparable or lower false-positive rates

## Key Findings

1. **Method 1 has an undesirable property**: Can fail to show consistency even when both populations show better-than-expected results

2. **New approach advantages**:
   - Better operating characteristics (higher $\eta_C$ and $\eta_D$)
   - Smaller false-positive error rates
   - Larger probabilities of showing consistent results
   - Required Japanese sample size independent of overall power

3. **Practical recommendation**: Use $\phi = 0.25$ in the new approach to match Method 1 strictness with $\omega = 0.5$

4. **Japanese proportion needed**: Approximately 22-29% of total sample size for 80% probability of consistency

## Relevance to SEMD Project

### Connection to Regional Consistency

Ikeda & Bretz focus on the **sample size problem** for demonstrating consistency in Japanese subpopulations. This complements:
- **Quan et al. (2010)**: Formal definitions of consistency
- **SEMD**: Quantifies *why* consistency should be expected (similar effect modifier distributions)

### Key Insight for SEMD

The paper assumes $\delta_{ALL} = \delta_J = \delta_{NJ} = \delta$ (same true effect across populations). SEMD provides a **pre-trial justification** for this assumption:
- If SEMD is small → effect modifier distributions are similar
- Similar distributions → treatment effects likely similar
- Similar effects → Ikeda & Bretz's consistency criteria more likely satisfied

### Practical Application

SEMD can be used in the **planning stage** to:
1. Justify the assumption of similar treatment effects
2. Support the choice of consistency threshold $\omega$
3. Inform sample size allocation decisions

## References

1. ICH E5: Q&A for the ICH-E5 Guideline on Ethnic Factors
2. MHLW (2007): Basic Principles on Global Clinical Trials
3. Quan et al. (2010): Sample size considerations for Japanese patients
4. Uesaka H. (2009): Sample size allocation to regions
5. Kawai et al. (2008): Approach to rationalize partitioning sample size
6. Genz & Bretz (2009): Computation of Multivariate Normal and t Probabilities

## Tags
sample size, Japanese patients, multi-regional trial, MRCT, consistency, Method 1, MHLW guidance, regional consistency, bridging study, bivariate normal

---
*Processed by Rachel | 2026-02-02*
*Key reference for SEMD paper - provides sample size methodology that SEMD pre-trial justification can support*
