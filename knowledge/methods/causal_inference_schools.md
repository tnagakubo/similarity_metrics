# Causal Inference: Schools of Thought

**Author**: Mike Ross
**Date**: 2026-02-03
**Status**: Reference

---

## Overview

Causal inference has four major frameworks, each with distinct philosophies, notations, and strengths.

---

## 1. Potential Outcomes Framework (Rubin Causal Model)

**Founders**: Donald Rubin, Guido Imbens (1970s-)

### Core Concepts

- **Potential outcomes**: $Y_i(1)$, $Y_i(0)$ for each unit
- **Fundamental problem**: Only one potential outcome observed per unit
- **ATE**: $\tau = E[Y(1) - Y(0)]$

### Key Assumptions

1. **SUTVA** (Stable Unit Treatment Value Assumption)
   - No interference between units
   - Treatment is well-defined

2. **Ignorability** (Unconfoundedness)
   - $(Y(1), Y(0)) \perp T | X$
   - No unmeasured confounding given X

3. **Positivity** (Overlap)
   - $0 < P(T=1|X=x) < 1$ for all x

### Methods

- Randomization inference
- Propensity score matching
- Inverse probability weighting
- Regression adjustment

### Key References

- Rubin, D. B. (1974). Estimating causal effects of treatments in randomized and nonrandomized studies. *Journal of Educational Psychology*, 66(5), 688-701.
- Imbens, G. W., & Rubin, D. B. (2015). *Causal Inference for Statistics, Social, and Biomedical Sciences*. Cambridge University Press.

---

## 2. Structural Causal Models / DAGs (Pearl)

**Founder**: Judea Pearl (1990s-2000s)

### Core Concepts

- **DAG** (Directed Acyclic Graph): Visual representation of causal structure
- **Structural equations**: $Y := f_Y(Pa_Y, U_Y)$
- **Intervention**: $do(X=x)$ - setting X to value x
- **Causal effect**: $P(Y|do(X=x))$

### Key Tools

1. **d-separation**: Conditional independence from graph structure
2. **Backdoor criterion**: Sufficient adjustment sets for confounding
3. **Front-door criterion**: Identification through mediators
4. **do-calculus**: Three rules for converting interventional to observational

### Transportability

Pearl & Bareinboim (2011, 2014) extended SCM to address:
- When can effects learned in one population apply to another?
- Selection diagrams with S-nodes

### Key References

- Pearl, J. (2009). *Causality: Models, Reasoning, and Inference* (2nd ed.). Cambridge University Press.
- Pearl, J., Glymour, M., & Jewell, N. P. (2016). *Causal Inference in Statistics: A Primer*. Wiley.

---

## 3. G-Methods (Robins)

**Founder**: James Robins (1986-)

### Core Concepts

Designed for **time-varying treatments and confounding**:
- Treatment at multiple time points: $\bar{A} = (A_0, A_1, ..., A_K)$
- Time-varying confounders: $\bar{L} = (L_0, L_1, ..., L_K)$
- Confounders affected by prior treatment

### Methods

#### G-computation (G-formula)
$$E[Y(\bar{a})] = \sum_{\bar{l}} E[Y|\bar{A}=\bar{a}, \bar{L}=\bar{l}] \prod_t P(L_t|\bar{A}_{t-1}, \bar{L}_{t-1})$$

#### Inverse Probability Weighting (IPW)
$$E[Y(\bar{a})] = E\left[\frac{I(\bar{A}=\bar{a})Y}{\prod_t P(A_t|\bar{A}_{t-1}, \bar{L}_t)}\right]$$

#### Doubly Robust Estimation
Combines G-computation and IPW; consistent if either model is correct.

#### Marginal Structural Models (MSM)
$$E[Y(\bar{a})] = m(\bar{a}; \beta)$$

Estimated via IPW.

### Key References

- Robins, J. M. (1986). A new approach to causal inference in mortality studies. *Mathematical Modelling*, 7, 1393-1512.
- Hernán, M. A., & Robins, J. M. (2020). *Causal Inference: What If*. Chapman & Hall/CRC. [Free online](https://www.hsph.harvard.edu/miguel-hernan/causal-inference-book/)

---

## 4. Structural Equation Models (SEM)

**Founders**: Sewall Wright (path analysis, 1920s), later social sciences

### Core Concepts

- Linear equations relating variables
- Path coefficients as effect sizes
- Latent variables

### Example
$$Y = \beta_1 X + \beta_2 Z + \epsilon$$

### Strengths
- Latent variable modeling
- Widespread in psychology, social sciences
- Good software (lavaan, Mplus, AMOS)

### Limitations
- Often assumes linearity
- Causal identification less rigorous than SCM
- Conflates estimation with identification

---

## Comparison Table

| Aspect | Rubin (PO) | Pearl (DAG) | Robins (G) | SEM |
|--------|------------|-------------|------------|-----|
| **Primary focus** | Estimand definition | Identification | Estimation | Modeling |
| **Notation** | Y(1), Y(0) | do(X), DAG | G-formula, IPW | Path coefficients |
| **Time-varying** | Difficult | Possible | **Specialty** | Difficult |
| **Mediation** | Possible | **Specialty** | Possible | Specialty |
| **Graphical** | Optional | **Central** | Compatible | Path diagrams |
| **Medical statistics** | **Mainstream** | Growing | Influential | Limited |

---

## Current Consensus in Medical Statistics

> **"Use DAGs to think, potential outcomes to define, G-methods to estimate"**
> — Hernán & Robins (2020)

### Typical Workflow

1. **Design phase**: Draw DAG to clarify causal structure and identify confounders
2. **Estimand definition**: Use potential outcomes notation
3. **Estimation**: Apply propensity scores, IPW, or doubly robust methods

### Regulatory Context

- **ICH E9(R1)** (2019) introduced "estimands" framework
- Potential outcomes terminology now standard in regulatory submissions
- ATE, ATT, CATE defined in PO terms

---

## Relevance to nABCD

nABCD can be positioned within this hybrid framework:

1. **DAG**: Selection diagram showing S → X, where S is region and X is effect modifier
2. **Potential outcomes**: $\tau(x) = E[Y(1) - Y(0)|X=x]$ (CATE)
3. **Transportability**: $|\tau_T - \tau_S| \leq \|\tau\|_\infty \cdot W_1(F_S, F_T)$
4. **nABCD**: Scale-free measure of $W_1$, bounding transportability barrier

---

*Reference document by Mike Ross | 2026-02-03*
