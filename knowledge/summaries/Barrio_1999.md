# del Barrio, Giné & Matrán 1999 - Central Limit Theorems for Wasserstein Distance

## Citation
del Barrio, E., Giné, E. & Matrán, C. (1999) "Central Limit Theorems for the Wasserstein Distance Between the Empirical and the True Distributions" *The Annals of Probability*, 27(2):1009-1071.
DOI: [10.1214/aop/1022677394](https://doi.org/10.1214/aop/1022677394)

## Summary

This seminal paper establishes central limit theorems for the Wasserstein-1 distance (L₁ norm of the empirical process) between empirical and true distribution functions. The authors derive rates of convergence and distributional limit theorems for $d_1(F_n, F)$ under various moment conditions, providing the theoretical foundation for inference on Wasserstein distances.

## Key Contributions

1. **Complete CLT characterization**: First complete description of first-order asymptotics for Wasserstein distance
2. **Moment conditions**: Identified exact conditions ($\Lambda_{2,1}(X) < \infty$) for CLT to hold
3. **Normalizing sequences**: Determined optimal normalizing constants $b_n$
4. **Brownian bridge connection**: Linked Wasserstein distance asymptotics to Brownian bridge

## Methods

### Wasserstein-1 Distance (Kantorovich Distance)
$$d_1(P_1, P_2) := \inf\left\{\int |x - y| \, d\mu(x, y) : \mu \in \mathscr{P}(\mathbb{R}^2) \text{ with marginals } P_1, P_2\right\}$$

### Equivalent Representations
For CDFs $F_1$, $F_2$ with quantile functions $Q_1$, $Q_2$:
$$d_1(P_1, P_2) = \int_0^1 |Q_2(t) - Q_1(t)| \, dt = \int_{-\infty}^{\infty} |F_2(t) - F_1(t)| \, dt$$

**This is the ABCD (Area Between Cumulative Distributions)!**

### Empirical CDF
$$F_n(t) = \frac{1}{n} \sum_{i=1}^{n} I_{X_i \leq t}$$

## Key Theorems

### Theorem 1.1 (Main CLT)
Let $X, X_i, i \in \mathbb{N}$, be i.i.d. random variables with differentiable distribution function $F$ and quantile function $Q$. Assume $X \in DA_{\alpha}(a_n)$ for some $1 < \alpha \leq 2$. Let $B(t)$ be a Brownian bridge. Then:

**(a) Case $\alpha = 2$**: If $\int_{-\infty}^{\infty} \sqrt{F(t)(1-F(t))} \, dt < \infty$, then:
$$\sqrt{n} \int_{-\infty}^{\infty} |F_n(t) - F(t)| \, dt \xrightarrow{d} \int_0^1 |B(t)| \, dQ(t)$$

**(a2)** If $X$ is symmetric with positive density and $\Pr\{|X| > t\} \simeq 1/t^2$, then:
$$\frac{n}{\sqrt{D}a_n} \left(\int_{-\infty}^{\infty} |F_n(t) - F(t)| \, dt - \mathbb{E}\int_{-\infty}^{\infty} |F_n(t) - F(t)| \, dt\right) \xrightarrow{d} g$$

where $g$ is standard normal.

### Theorem 2.1 (Stochastic Boundedness)
The sequence $\|\sum_{i=1}^{\infty} Y_i / \sqrt{n}\|_{L_1}$ is stochastically bounded if and only if $\Lambda_{2,1}(X) < \infty$.

### Key Condition
$$\Lambda_{2,1}(X) := \int_0^{\infty} \sqrt{\Pr\{|X| > t\}} \, dt < \infty$$

This is equivalent to $\int_{-\infty}^{\infty} \sqrt{F(t)(1-F(t))} \, dt < \infty$.

## Key Equations

### Convergence to Brownian Bridge
$$\sqrt{n}(F_n - F) \xrightarrow{\mathscr{L}} \mathbb{B} \circ F$$

where $\mathbb{B}$ is a Brownian bridge on $[0,1]$.

### Limit Distribution
Under the CLT conditions:
$$\sqrt{n} \cdot d_1(F_n, F) \xrightarrow{d} \int_0^1 |B(t)| \, dQ(t)$$

The limit is **NOT Gaussian** in general - it's a weighted integral of the absolute value of a Brownian bridge.

## Relevance to nABCD

**Foundational importance**: This paper proves the CLT for the numerator of nABCD.

Key implications:
1. **Rate**: $d_1(F_n, F) = O_P(n^{-1/2})$ under moment conditions
2. **Non-Gaussian limit**: The limit distribution is not normal, complicating inference
3. **Bootstrap justification**: Results support bootstrap-based inference
4. **Two-sample extension**: Natural extension to $d_1(F_n, G_m)$ for comparing two empirical distributions

### For nABCD specifically:
- Numerator: $W_1(F_n, G_m) = \int |F_n(x) - G_m(x)| dx$
- Convergence: $\sqrt{nm/(n+m)} \cdot W_1(F_n, G_m) \xrightarrow{d}$ limit distribution
- Bootstrap validity: Percentile bootstrap CI shown to have good coverage

## Technical Notes

1. **Domain of Attraction**: Results depend on whether $X \in DA_{\alpha}(a_n)$ with $\alpha \in (1, 2]$
2. **Heavy Tails**: Special treatment needed for $\alpha < 2$ (infinite variance case)
3. **Centering**: Uncentered vs centered statistics have different limits
4. **Normalization**: Various normalizing sequences $b_n$ depending on moment conditions

## Limitations

1. One-dimensional theory only
2. Limit distribution not Gaussian (complicates CI construction)
3. Heavy-tail cases require different normalizations

## Tags
Wasserstein distance, central limit theorem, empirical process, Brownian bridge, L1 norm, domain of attraction, nABCD theory, ABCD

---
*Processed by Rachel Zane | 2026-02-02*
*Priority: P1 - Essential CLT foundation for nABCD*
