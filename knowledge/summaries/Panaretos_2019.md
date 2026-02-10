# Panaretos & Zemel 2019 - Statistical Aspects of Wasserstein Distances

## Citation
Panaretos, V.M. & Zemel, Y. (2019) "Statistical Aspects of Wasserstein Distances" *Annual Review of Statistics and Its Application*, 6:405-431.
DOI: [10.1146/annurev-statistics-030718-104938](https://doi.org/10.1146/annurev-statistics-030718-104938)

## Summary

This is a comprehensive review article covering the statistical aspects of Wasserstein distances (also known as optimal transport distances). The authors provide a snapshot of the main concepts in Wasserstein distances and optimal transportation, covering their use in asymptotic theory, statistical inference, and as objects of inference themselves. The review organizes the statistical uses of Wasserstein distances into three broad categories: (1) as a tool in asymptotic theory, (2) as a methodological tool for inference, and (3) as the parameter space itself in functional data analysis.

## Key Contributions

1. **Unified Review**: First comprehensive statistical review of Wasserstein distances
2. **Three-Category Framework**: Organized statistical uses into asymptotic tools, inference tools, and parameter spaces
3. **Historical Context**: Traces origins from Monge (1781) through Kantorovich (1942) to modern applications
4. **Explicit Formulas**: Provides closed-form expressions for special cases

## Methods

### Wasserstein-p Distance Definition
$$W_p(\mu, \nu) = \inf_{X \sim \mu, Y \sim \nu} (\mathbb{E}\|X - Y\|^p)^{1/p}, \quad p \geq 1$$

### One-Dimensional Case (Explicit Formula)
For $d = 1$ with distribution functions $F_X$ and $F_Y$:
$$W_p(X, Y) = \|F_X^{-1} - F_Y^{-1}\|_p = \left(\int_0^1 |F_X^{-1}(\alpha) - F_Y^{-1}(\alpha)|^p \, d\alpha\right)^{1/p}$$

### Wasserstein-1 Distance (Special Case)
$$W_1(X, Y) = \int_{\mathbb{R}} |F_X(t) - F_Y(t)| \, dt$$

This is the **area between CDFs** - directly relevant to nABCD!

### Gaussian Case (W₂)
For $X \sim N(m_1, \Sigma_1)$ and $Y \sim N(m_2, \Sigma_2)$:
$$W_2^2(X, Y) = \|m_1 - m_2\|^2 + \text{tr}[\Sigma_1 + \Sigma_2 - 2(\Sigma_1^{1/2}\Sigma_2\Sigma_1^{1/2})^{1/2}]$$

## Key Equations

### Convergence Rate
For empirical measure $\mu_n$ to true measure $\mu$:
- **One-dimensional**: $\mathbb{E}[W_p(\mu_n, \mu)] = O(n^{-1/2})$
- **Multi-dimensional ($d \geq 3$)**: $\mathbb{E}[W_p(\mu_n, \mu)] = O(n^{-1/d})$ (curse of dimensionality)

### Central Limit Theorem (Univariate)
Under regularity conditions:
$$\sqrt{n}(W_1(F_n, F) - \mathbb{E}W_1(F_n, F)) \xrightarrow{d} N(0, \sigma^2)$$

## Relevance to nABCD

**Critical connection**: The Wasserstein-1 distance $W_1(F, G) = \int |F(x) - G(x)| dx$ is exactly the numerator of nABCD before IQR normalization.

Key insights for our work:
1. **One-dimensional case is tractable**: Explicit formula via CDF area
2. **ECDF consistency**: $W_1(F_n, F) \to 0$ a.s. at rate $n^{-1/2}$
3. **Bootstrap validity**: Discussed in context of Dümbgen (1993) and Sommerfeld & Munk (2018)
4. **Normalization approaches**: Various normalizations discussed for scale-free comparisons

## Bootstrap and Inference

The review discusses that:
- Naive bootstrap may not be consistent in general (citing Dümbgen 1993)
- **Directional bootstrap** approaches can achieve consistency
- For one-dimensional case, standard bootstrap performs better
- Sommerfeld & Munk (2018) provide detailed bootstrap analysis

## Limitations Noted

1. Multivariate case suffers from curse of dimensionality
2. Computational complexity increases with dimension
3. Bootstrap consistency requires careful treatment

## Tags
Wasserstein distance, optimal transport, empirical process, bootstrap, central limit theorem, Fréchet mean, goodness-of-fit, review article, nABCD foundation

---
*Processed by Rachel Zane | 2026-02-02*
*Priority: P1 - Essential for nABCD theoretical foundation*
