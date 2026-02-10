# Sommerfeld & Munk 2018 - Inference for Empirical Wasserstein Distances on Finite Spaces

## Citation
Sommerfeld, M. & Munk, A. (2018) "Inference for Empirical Wasserstein Distances on Finite Spaces" *Journal of the Royal Statistical Society: Series B (Statistical Methodology)*, 80(1):219-238.
DOI: [10.1111/rssb.12236](https://doi.org/10.1111/rssb.12236)

## Summary

This paper derives the asymptotic distribution of empirical Wasserstein distances for probability measures supported on finitely many points. The key innovation is using **directional Hadamard differentiability** (not standard Hadamard differentiability) to establish limit theorems. The authors show that the naive bootstrap is NOT consistent, but introduce a **directional bootstrap** that achieves consistency.

## Key Contributions

1. **CLT for finite-space Wasserstein**: First distributional limits for Wasserstein on discrete spaces
2. **Directional Hadamard differentiability**: Key technical tool enabling the delta method
3. **Bootstrap failure**: Proved naive bootstrap inconsistency
4. **Directional bootstrap**: Introduced consistent bootstrap alternative
5. **Two-sample inference**: Extended to comparing two distributions

## Methods

### Wasserstein Distance on Finite Spaces
For probability vectors $\mathbf{r}, \mathbf{s} \in \mathcal{P}_{\mathcal{X}}$ on finite space $\mathcal{X} = \{x_1, \ldots, x_N\}$:
$$W_p(\mathbf{r}, \mathbf{s}) = \left\{\min_{\pi \in \Pi(\mathbf{r}, \mathbf{s})} \sum_{x, x' \in \mathcal{X}} d^p(x, x') \pi_{x,x'}\right\}^{1/p}$$

where $\Pi(\mathbf{r}, \mathbf{s})$ is the set of all couplings with marginals $\mathbf{r}$ and $\mathbf{s}$.

### Main CLT Result (Theorem 1)
Under the null hypothesis $\mathbf{r} = \mathbf{s}$:
$$\left(\frac{nm}{n+m}\right)^{1/(2p)} W_p(\hat{\mathbf{r}}_n, \hat{\mathbf{s}}_m) \Rightarrow \left(\max_{\mathbf{u} \in \Phi_p^*} \langle\mathbf{G}, \mathbf{u}\rangle\right)^{1/p}$$

where $\mathbf{G}$ is a mean-zero Gaussian random vector and $\Phi_p^*$ is the convex set of dual solutions.

### Key Insight: Non-Linear Derivative
The Wasserstein distance is **directionally Hadamard differentiable** with a **non-linear** derivative. This means:
- Standard delta method does NOT apply
- Naive bootstrap is NOT consistent
- Non-standard delta method with directional derivatives is required

## Directional Hadamard Differentiability

### Definition
A map $\phi: \mathbb{D} \to \mathbb{E}$ is directionally Hadamard differentiable at $\theta$ if there exists a continuous map $\phi'_\theta: \mathbb{D} \to \mathbb{E}$ such that:
$$\frac{\phi(\theta + t_n h_n) - \phi(\theta)}{t_n} \to \phi'_\theta(h)$$
for all $t_n \downarrow 0$ and $h_n \to h$.

### Wasserstein Case
For Wasserstein distance, the derivative is:
$$\phi'_{\mathbf{r}}(h) = \max_{\mathbf{u} \in \Phi_p^*} \langle h, \mathbf{u} \rangle$$

This is the maximum over a convex set - **non-linear** unless $\Phi_p^*$ is a singleton.

## Bootstrap Analysis

### Naive Bootstrap FAILS
**Theorem (Bootstrap Inconsistency)**: The naive $(n$ out of $n)$ bootstrap is NOT consistent for $W_p(\hat{\mathbf{r}}_n, \mathbf{r})$ when the derivative is non-linear.

Intuition: Bootstrap samples $\hat{\mathbf{r}}_n^*$ satisfy $\hat{\mathbf{r}}_n^* \neq \hat{\mathbf{r}}_n$ almost surely, so bootstrap operates at wrong point.

### Directional Bootstrap IS Consistent
The **directional bootstrap**:
1. Resample the underlying empirical process derivative
2. Apply the non-linear directional derivative
3. Achieves consistency for the Wasserstein distance

### Exception: Under the Null $\mathbf{r} = \mathbf{s}$
For the two-sample case comparing $F$ to $G$:
- If $F = G$ (null), naive bootstrap **can** work because derivative direction is correct
- If $F \neq G$ (alternative), naive bootstrap may still work in practice

## Relevance to nABCD

**Critical implications for bootstrap CI**:

1. **One-dimensional case is special**:
   - On $\mathbb{R}$, Wasserstein distance via CDFs has better properties
   - del Barrio et al. (1999) results apply

2. **Two-sample inference**:
   - For comparing $F_n$ vs $G_m$: $W_1(F_n, G_m)$
   - Rate: $\sqrt{nm/(n+m)}$
   - Bootstrap validity depends on whether $F = G$

3. **nABCD bootstrap**:
   - Percentile bootstrap should work under most practical conditions
   - Dümbgen (1993) condition ensures linearity of derivative
   - At moderate sample sizes, bias in bootstrap may exist but CI coverage often acceptable

### Practical Recommendation
For nABCD inference with n ≥ 50 per group:
- Percentile bootstrap CI generally performs well
- Under the alternative ($F \neq G$), coverage may be slightly conservative
- For small samples, consider directional bootstrap or simulation-based CI

## Key Technical Points

1. **Directional vs Standard Hadamard**: Wasserstein has directional but not standard differentiability
2. **Non-Gaussian limits**: Limit distributions are typically NOT Gaussian
3. **Convex optimization**: Wasserstein distance is optimal value of linear program
4. **Dümbgen (1993) connection**: Conditions for linear derivative ensure naive bootstrap works

## Applications Discussed

1. Fingerprint verification
2. Metagenomics (microbial community comparison)
3. Hypothesis testing for distributional equality

## Tags
Wasserstein distance, bootstrap, directional Hadamard differentiability, finite spaces, two-sample test, central limit theorem, optimal transport, nABCD inference

---
*Processed by Rachel Zane | 2026-02-02*
*Priority: P2 - Bootstrap theory for nABCD*
