# SEMD: Methods Draft

## Definition

**Definition 1 (SEMD)**

Let $f_1, f_2$ be the probability density functions of an effect modifier $X$ in regions 1 and 2, respectively. Let $g: \mathcal{X} \to \mathbb{R}$ be the effect modification function. The Similarity of Effect Modifier Distribution (SEMD) is defined as:

$$\text{SEMD}(f_1, f_2; g) = \int_{\mathcal{X}} |f_1(x) - f_2(x)| \cdot |g(x)| \, dx$$

## Theoretical Properties

**Property 1: Non-negativity**
$$\text{SEMD} \geq 0$$

**Property 2: Identity**
$$f_1 = f_2 \Rightarrow \text{SEMD} = 0$$

**Property 3: Symmetry**
$$\text{SEMD}(f_1, f_2; g) = \text{SEMD}(f_2, f_1; g)$$

**Property 4: Zero under no effect modification**
$$g(x) = 0 \text{ for all } x \Rightarrow \text{SEMD} = 0$$

## Scaling Options

### Option A: Normalized SEMD
$$\text{SEMD}^* = \frac{\text{SEMD}}{\int |g(x)| \cdot \max(f_1, f_2) \, dx}$$

Range: $[0, 1]$

### Option B: Interpretable units
Define $g(x)$ on log-hazard ratio scale.
Then SEMD represents "upper bound of expected treatment effect difference".

## Estimation

### Definition 2 (SEMD Estimator)

Given samples $X_{1,1}, \ldots, X_{1,n_1}$ from region 1 and $X_{2,1}, \ldots, X_{2,n_2}$ from region 2.

**Kernel Density Estimation (KDE) approach:**

Let $\hat{f}_k(x) = \frac{1}{n_k h_k} \sum_{i=1}^{n_k} K\left(\frac{x - X_{k,i}}{h_k}\right)$ for $k = 1, 2$

where $K(\cdot)$ is a kernel function (e.g., Gaussian) and $h_k$ is the bandwidth.

**Plug-in Estimator:**
$$\widehat{\text{SEMD}}_n = \int_{\mathcal{X}} |\hat{f}_1(x) - \hat{f}_2(x)| \cdot |g(x)| \, dx$$

In practice, computed via numerical integration over a grid $x_1, \ldots, x_J$:
$$\widehat{\text{SEMD}}_n \approx \sum_{j=1}^{J} |\hat{f}_1(x_j) - \hat{f}_2(x_j)| \cdot |g(x_j)| \cdot \Delta x$$

## Asymptotic Properties

**Assumption A1 (Regularity):** $f_1, f_2$ are continuous with bounded support.

**Assumption A2 (Bandwidth):** $h_k \to 0$ and $n_k h_k \to \infty$ as $n_k \to \infty$.

**Assumption A3 (Effect modification function):** $g$ is known and bounded.

**Assumption A4 (Non-degeneracy):** $f_1(x) \neq f_2(x)$ almost everywhere on $\{x: g(x) \neq 0\}$.

**Theorem 1 (Asymptotic Normality):**
Under Assumptions A1-A4, as $n_1, n_2 \to \infty$:
$$\sqrt{n}(\widehat{\text{SEMD}}_n - \text{SEMD}) \xrightarrow{d} N(0, \sigma^2)$$

where $n = n_1 + n_2$ and $\sigma^2$ is given in Theorem 2.

*Proof sketch:*
1. By Bickel & Rosenblatt (1973), KDE satisfies uniform convergence: $\sup_x |\hat{f}_k(x) - f_k(x)| = O_p(\sqrt{\log n / (nh)})$
2. Under A4, $|f_1(x) - f_2(x)|$ is differentiable a.e., allowing application of delta method
3. Standard CLT for weighted integrals yields normality
*Full proof in Appendix A.*

**Theorem 2 (Asymptotic Variance):**
Under Assumptions A1-A4, the asymptotic variance is:
$$\sigma^2 = \lim_{n \to \infty} n \cdot \text{Var}(\widehat{\text{SEMD}}_n) = \sigma_1^2 + \sigma_2^2$$

where for $k = 1, 2$:
$$\sigma_k^2 = \frac{1}{\lambda_k} \int_{\mathcal{X}} \text{sgn}^2(f_1(x) - f_2(x)) \cdot g^2(x) \cdot f_k(x) \cdot R(K) \, dx$$

with $\lambda_k = \lim n_k/n$ (limiting proportion of region $k$) and $R(K) = \int K^2(u) du$.

*Proof sketch:*
1. Variance decomposition across regions (independence)
2. For each region, apply variance formula for KDE: $\text{Var}(\hat{f}_k(x)) \approx f_k(x) R(K) / (n_k h_k)$
3. Propagate through weighted integral using delta method
*Full proof in Appendix A.*

## Bootstrap Inference

### Theorem 3 (Bootstrap Consistency)

**Assumption A5 (Smoothness):** The kernel $K$ is Lipschitz continuous with bounded support.

Under Assumptions A1-A5, the nonparametric bootstrap is consistent for SEMD:
$$\sup_t \left| P^*(\sqrt{n}(\widehat{\text{SEMD}}^*_n - \widehat{\text{SEMD}}_n) \leq t) - P(\sqrt{n}(\widehat{\text{SEMD}}_n - \text{SEMD}) \leq t) \right| \xrightarrow{p} 0$$

where $P^*$ denotes the bootstrap probability measure.

*Proof sketch:*
1. SEMD can be expressed as a functional $T(F_1, F_2)$ of the distribution functions
2. Under A4, this functional is Hadamard differentiable at $(F_1, F_2)$ (Dümbgen, 1993)
3. By the functional delta method for bootstrap (van der Vaart & Wellner, 1996, Theorem 3.9.11), bootstrap consistency follows
4. The KDE plug-in does not affect first-order asymptotics under A2
*Full proof in Appendix B.*

### Confidence Interval Construction

Given bootstrap consistency (Theorem 3), we use nonparametric bootstrap for inference.

**Algorithm 1 (Bootstrap CI for SEMD)**

```
Input: Data from regions 1 and 2, B = number of bootstrap replicates
Output: 95% confidence interval for SEMD

For b = 1 to B:
    1. Resample n₁ observations with replacement from region 1 → X₁*
    2. Resample n₂ observations with replacement from region 2 → X₂*
    3. Compute KDE: f̂₁*(x) and f̂₂*(x)
    4. Compute SEMD*(b) = ∫ |f̂₁*(x) - f̂₂*(x)| · |g(x)| dx
End

Compute percentile CI:
  Lower = 2.5th percentile of {SEMD*(1), ..., SEMD*(B)}
  Upper = 97.5th percentile of {SEMD*(1), ..., SEMD*(B)}

Return [Lower, Upper]
```

## Bandwidth Selection

Use Silverman's rule of thumb:
$$h_k = 0.9 \cdot \min\left(\hat{\sigma}_k, \frac{IQR_k}{1.34}\right) \cdot n_k^{-1/5}$$

Or cross-validation for more precise selection.

## Key References for Proofs

- Bickel, P.J. & Rosenblatt, M. (1973). On some global measures of the deviations of density function estimates. *Annals of Statistics*.
- Devroye, L. & Győrfi, L. (1985). *Nonparametric Density Estimation: The L1 View*. Wiley.
- Dümbgen, L. (1993). On nondifferentiable functions and the bootstrap. *Probability Theory and Related Fields*.
- van der Vaart, A.W. & Wellner, J.A. (1996). *Weak Convergence and Empirical Processes*. Springer.
- Hall, P. (1992). *The Bootstrap and Edgeworth Expansion*. Springer.
- Bickel, P.J. & Freedman, D.A. (1981). Some asymptotic theory for the bootstrap. *Annals of Statistics*.

## TODO
- [x] Derive estimator for SEMD
- [x] Define confidence interval (bootstrap)
- [x] State Theorem 1 (Asymptotic Normality) with proof sketch
- [x] State Theorem 2 (Asymptotic Variance) with explicit formula
- [x] State Theorem 3 (Bootstrap Consistency) with proof sketch
- [ ] Write full proofs in Appendix A (Theorems 1-2)
- [ ] Write full proofs in Appendix B (Theorem 3)
- [ ] Prove Properties 1-4 formally
- [ ] Implement R functions
- [ ] Validate bootstrap coverage via simulation

---
*Draft by Mike | Last updated: 2026-02-01 02:00*
