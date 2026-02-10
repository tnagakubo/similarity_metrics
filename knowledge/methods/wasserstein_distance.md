# Wasserstein Distance (Optimal Transport Distance)

## Definition

The **Wasserstein-p distance** between probability measures $\mu$ and $\nu$ on $\mathbb{R}^d$ is:

$$W_p(\mu, \nu) = \left(\inf_{\gamma \in \Gamma(\mu, \nu)} \int_{\mathbb{R}^d \times \mathbb{R}^d} \|x - y\|^p \, d\gamma(x, y)\right)^{1/p}$$

where $\Gamma(\mu, \nu)$ is the set of all couplings (joint distributions) with marginals $\mu$ and $\nu$.

## Alternative Names
- **Mallows distance** (statistics)
- **Earth mover's distance** (computer science)
- **Monge-Kantorovich distance** (mathematics)
- **Optimal transport distance** (general)

## One-Dimensional Case

For univariate distributions with CDFs $F$ and $G$:

### Wasserstein-p via Quantile Functions
$$W_p(F, G) = \left(\int_0^1 |F^{-1}(u) - G^{-1}(u)|^p \, du\right)^{1/p}$$

### Wasserstein-1 via CDFs (ABCD)
$$W_1(F, G) = \int_{-\infty}^{\infty} |F(x) - G(x)| \, dx$$

**This is the Area Between Cumulative Distributions (ABCD)!**

## Properties

1. **Metric**: $W_p$ is a true metric on $\mathcal{P}_p(\mathbb{R}^d)$
2. **Metrizes weak convergence**: $W_p(\mu_n, \mu) \to 0$ iff $\mu_n \to \mu$ weakly and $p$-th moments converge
3. **Interpolation**: Geodesics in Wasserstein space correspond to optimal transport maps
4. **Scale equivariance**: $W_p(aX, aY) = |a| \cdot W_p(X, Y)$

## Empirical Estimation

For samples $X_1, \ldots, X_n \sim F$ and $Y_1, \ldots, Y_m \sim G$:

### One-Dimensional Estimator
$$\hat{W}_1(F_n, G_m) = \int_{-\infty}^{\infty} |F_n(x) - G_m(x)| \, dx$$

Computed efficiently via sorted order statistics.

### Computational Complexity
- **1D case**: $O((n+m) \log(n+m))$ (sorting)
- **General case**: $O(N^3 \log N)$ via linear programming

## Asymptotic Theory

### Convergence Rate (1D)
$$\mathbb{E}[W_1(F_n, F)] = O(n^{-1/2})$$

### Central Limit Theorem (del Barrio et al., 1999)
Under $\Lambda_{2,1}(X) < \infty$:
$$\sqrt{n} \cdot W_1(F_n, F) \xrightarrow{d} \int_0^1 |B(t)| \, dQ(t)$$

where $B$ is a Brownian bridge and $Q = F^{-1}$.

### Two-Sample CLT
$$\sqrt{\frac{nm}{n+m}} \cdot W_1(F_n, G_m) \xrightarrow{d} \text{limit distribution}$$

## Special Cases

### Gaussian Distributions
For $X \sim N(\mu_1, \sigma_1^2)$ and $Y \sim N(\mu_2, \sigma_2^2)$:

$$W_2^2(X, Y) = (\mu_1 - \mu_2)^2 + (\sigma_1 - \sigma_2)^2$$

$$W_1(X, Y) = |\mu_1 - \mu_2| \cdot \Phi\left(\frac{|\mu_1 - \mu_2|}{\sigma_1 + \sigma_2}\right) + (\sigma_1 + \sigma_2) \cdot \phi\left(\frac{|\mu_1 - \mu_2|}{\sigma_1 + \sigma_2}\right) \cdot \sqrt{2}$$

For equal variance ($\sigma_1 = \sigma_2 = \sigma$):
$$W_1(X, Y) \approx 0.80 \cdot |\mu_1 - \mu_2|$$

### Location-Scale Families
If $Y = aX + b$:
$$W_1(X, Y) = |a-1| \cdot \mathbb{E}|X| + |b|$$

## Comparison with Other Distances

| Distance | Captures | Scale-free | Interpretable |
|----------|----------|------------|---------------|
| KS statistic | Max CDF difference | No | Limited |
| Total Variation | Max probability diff | Yes | Limited |
| Wasserstein-1 | Integrated CDF diff | No | Yes (work to transform) |
| nABCD | Normalized W₁ | Yes | Yes |

## Implementation in R

```r
# Wasserstein-1 distance for univariate samples
wasserstein1 <- function(x, y) {
  # Combined and sorted unique values
  all_vals <- sort(unique(c(x, y)))

  # Empirical CDFs at all points
  Fx <- ecdf(x)(all_vals)
  Fy <- ecdf(y)(all_vals)

  # Numerical integration (trapezoidal)
  dx <- diff(c(min(all_vals) - 1, all_vals))
  sum(abs(Fx - Fy) * dx)
}

# Alternative using order statistics
wasserstein1_quantile <- function(x, y) {
  n <- length(x)
  m <- length(y)

  # Interpolate to common grid
  p <- seq(0, 1, length.out = max(n, m) * 10)
  qx <- quantile(x, p, type = 1)
  qy <- quantile(y, p, type = 1)

  mean(abs(qx - qy))
}
```

## References

- del Barrio, E., Giné, E. & Matrán, C. (1999) DOI: [10.1214/aop/1022677394](https://doi.org/10.1214/aop/1022677394)
- Panaretos, V.M. & Zemel, Y. (2019) DOI: [10.1146/annurev-statistics-030718-104938](https://doi.org/10.1146/annurev-statistics-030718-104938)
- Sommerfeld, M. & Munk, A. (2018) DOI: [10.1111/rssb.12236](https://doi.org/10.1111/rssb.12236)
- Villani, C. (2008) *Optimal Transport: Old and New*

---
*Method file created by Mike Ross | 2026-02-02*
