# Two-Sample Asymptotic Theory for nABCD

**Author**: Mike Ross
**Date**: 2026-02-03

---

## 3.X Two-Sample Central Limit Theorem

### Setting

Let $X_1, \ldots, X_n \stackrel{iid}{\sim} F$ and $Y_1, \ldots, Y_m \stackrel{iid}{\sim} G$ be independent samples from two populations. Let $F_n$ and $G_m$ denote their respective empirical distribution functions. The nABCD statistic compares these distributions via the Wasserstein-1 distance:

$$\text{nABCD}(F_n, G_m) = \frac{W_1(F_n, G_m)}{2 \cdot \widehat{\text{IQR}}_{\text{pooled}}}$$

where $W_1(F_n, G_m) = \int_{-\infty}^{\infty} |F_n(x) - G_m(x)| \, dx$.

### Two-Sample Wasserstein CLT

The asymptotic behavior of the two-sample Wasserstein distance is established by the following result:

**Theorem (Two-Sample CLT for $W_1$).**
*Let $F$ and $G$ be distribution functions on $\mathbb{R}$ with finite first moments. Assume $\Lambda_{2,1}(F) < \infty$ and $\Lambda_{2,1}(G) < \infty$, where*

$$\Lambda_{2,1}(H) = \int_0^{\infty} \sqrt{\Pr_H\{|X| > t\}} \, dt$$

*Let $n, m \to \infty$ with $n/(n+m) \to \lambda \in (0, 1)$. Then:*

$$\sqrt{\frac{nm}{n+m}} \left( W_1(F_n, G_m) - W_1(F, G) \right) \xrightarrow{d} Z$$

*where $Z$ is a centered random variable with distribution depending on $F$, $G$, and $\lambda$.*

**References:**
- del Barrio, E., Giné, E. & Matrán, C. (1999). Central limit theorems for the Wasserstein distance between the empirical and the true distributions. *The Annals of Probability*, 27(2), 1009-1071. DOI: [10.1214/aop/1022677394](https://doi.org/10.1214/aop/1022677394)
- Munk, A. & Czado, C. (1998). Nonparametric validation of similar distributions and assessment of goodness of fit. *Journal of the Royal Statistical Society: Series B*, 60(1), 223-241. DOI: [10.1111/1467-9868.00121](https://doi.org/10.1111/1467-9868.00121)

### Special Case: $F = G$ (Null Hypothesis)

Under the null hypothesis of equal distributions:

$$\sqrt{\frac{nm}{n+m}} \cdot W_1(F_n, G_m) \xrightarrow{d} \int_0^1 |B_\lambda(t)| \, dQ(t)$$

where $B_\lambda$ is a Brownian bridge with variance $\lambda(1-\lambda)$ at each point, and $Q = F^{-1}$ is the common quantile function.

### Bootstrap Validity

For confidence interval construction, we employ the nonparametric percentile bootstrap. Resampling is performed independently from each sample:

1. Draw $X_1^*, \ldots, X_n^* \stackrel{iid}{\sim} F_n$
2. Draw $Y_1^*, \ldots, Y_m^* \stackrel{iid}{\sim} G_m$
3. Compute $\text{nABCD}^* = \text{nABCD}(F_n^*, G_m^*)$
4. Repeat $B$ times to obtain bootstrap distribution

**Theorem (Bootstrap Consistency).**
*Under the moment conditions above and for $n/(n+m) \to \lambda$, the bootstrap distribution of $\sqrt{nm/(n+m)}(W_1(F_n^*, G_m^*) - W_1(F_n, G_m))$ converges to the same limit as the original statistic, conditional on the data, in probability.*

This result follows from Sommerfeld & Munk (2018) for finite spaces and extends to the continuous case under the stated regularity conditions.

**Reference:**
- Sommerfeld, M. & Munk, A. (2018). Inference for empirical Wasserstein distances on finite spaces. *Journal of the Royal Statistical Society: Series B*, 80(1), 219-238. DOI: [10.1111/rssb.12236](https://doi.org/10.1111/rssb.12236)

### Convergence Rate

The effective sample size for the two-sample problem is $n_{\text{eff}} = nm/(n+m)$. For balanced designs ($n = m$), this gives $n_{\text{eff}} = n/2$, implying:

$$\text{SE}(\text{nABCD}) = O\left(\sqrt{\frac{1}{n_{\text{eff}}}}\right) = O\left(\sqrt{\frac{n+m}{nm}}\right)$$

### Sample Size Recommendations

Based on simulation studies (Section 4) and the asymptotic theory:

| Purpose | Minimum per group | Rationale |
|---------|-------------------|-----------|
| Point estimation | $n, m \geq 50$ | Bias < 0.02 for most scenarios |
| Inference (95% CI) | $n, m \geq 100$ | Coverage within [0.93, 0.97] |
| Hypothesis testing | $n, m \geq 200$ | Type I error well-controlled |

---

*Section drafted by Mike Ross | 2026-02-03*
