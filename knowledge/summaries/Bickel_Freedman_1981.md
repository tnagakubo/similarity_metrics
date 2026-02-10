# Bickel & Freedman (1981) - Summary

## Citation
Bickel, P.J. & Freedman, D.A. (1981). Some Asymptotic Theory for the Bootstrap. *The Annals of Statistics*, 9(6), 1196-1217.

**DOI**: [10.1214/aos/1176345637](https://doi.org/10.1214/aos/1176345637)

## Abstract
Efron's "bootstrap" method of distribution approximation is shown to be asymptotically valid in a large number of situations, including t-statistics, the empirical and quantile processes, and von Mises functionals. Some counter-examples are also given, to show that the approximation does not always succeed.

## Key Results for SEMD Project

### Theorem 2.1 (Bootstrap for the Mean)
For i.i.d. random variables $X_1, X_2, \ldots, X_n$ with finite positive variance $\sigma^2$:
- The conditional distribution of $\sqrt{m}(\mu_m^* - \mu_n)$ converges weakly to $N(0, \sigma^2)$
- The bootstrap pivot $Q_n^*$ mimics the behavior of $Q_n$

**Key conditions:**
- $s_n^2 \to \sigma^2$ almost surely (sample variance converges)

### Theorem 2.2 (Multidimensional Extension)
For random variables in $\mathbb{R}^k$:
- The conditional distribution of $\sqrt{m}(\bar{X}_m^* - \bar{X}_n)$ converges to $N(0, \Sigma)$
- The empirical variance-covariance matrix converges to the theoretical one

### Section 3: Von Mises Functionals (CRITICAL for SEMD)

For functionals of the form:
$$g(F_n) = n^{-2} \sum_{i<j} [\omega(X_i, X_j) - \int \omega(x,y) dG(x) dG(y)]$$

**Theorem 3.1**: If conditions (3.15) and (3.16) hold:
$$n^{1/2}\{g(F_n) - g(F)\} \text{ tends weakly to } N(0, \sigma^2)$$

where $\sigma^2$ is given by equation (3.18).

**Bootstrap validity**: The bootstrap distribution of $g(G_n) - g(F_n)$ approximates the distribution of $g(F_n) - g(F)$.

### Section 4: Bootstrapping the Empirical Process

**Theorem 4.1**: Along almost all sample sequences, given $(X_1, \ldots, X_n)$, $W_{nm}$ converges weakly to $B(F)$ (Brownian bridge).

**Corollary 4.1**: Confidence bands for $F$ can be constructed even when $F$ has discrete components.

### Section 6: Counter-Examples

Important: Bootstrap can fail when:
- Convergence is not uniform on neighborhoods (condition 6.1a fails)
- For maximum spacings when $F$ is uniform on $(0, \theta)$

## Relevance to SEMD

### Direct Application
1. **SEMD as a functional**: SEMD can be viewed as $T(F_1, F_2) = \int |f_1(x) - f_2(x)| \cdot |g(x)| dx$
2. **Two-sample extension**: Results extend to two independent samples
3. **Bootstrap justification**: Theorem 3.1 provides framework for bootstrap consistency

### Key Insight for Theorem 3 (Bootstrap Consistency)
The paper establishes that for "smooth" functionals (Gâteaux differentiable), bootstrap is consistent. For SEMD:
- Need to verify Hadamard differentiability (related to Gâteaux)
- The absolute value $|f_1 - f_2|$ creates non-smoothness at $f_1 = f_2$
- Under Assumption A4 ($f_1 \neq f_2$ a.e.), this is avoided

### Quote for Citation
> "The bootstrap distribution of $g(G_n) - g(F_n)$ approximates the sampling distribution of $g(F_n) - g(F)$, provided certain regularity conditions hold." (p. 1200)

## Technical Notes

### Mallows Metric $d_2$
Used to establish convergence:
$$d_2(G, H)^2 = E\{(X-Y)^2\}$$
where infimum is over all joint distributions of $X, Y$ with marginals $G, H$.

### Key References from Paper
- Efron, B. (1979). Bootstrap methods: another look at the jackknife. *Ann. Statist.* 7, 1-26.
- von Mises, R. (1947). On the asymptotic distribution of differentiable statistical functions.

## Detailed Results (from Image Reading 2026-02-02)

### Section 2: Bootstrap for the Mean

**Pivotal Quantity**: $Q_n = \sqrt{n}(\mu_n - \mu)/s_n$

**Theorem 2.1**: For i.i.d. $X_1, \ldots, X_n$ with finite mean $\mu$ and variance $\sigma^2$:
- (a) Conditional distribution of $\sqrt{m}(\mu_m^* - \mu_n)$ converges weakly to $N(0, \sigma^2)$
- (b) $s_n^* \to \sigma$ in conditional probability

**Convergence notion**: $G_n \Rightarrow G$ in $\Gamma_2$ iff $\int h^2 dG_n \to \int h^2 dG$ and $\int \theta(h) dG_n \to \int \theta(h) dG$ for all bounded continuous $\theta$.

### Section 3: Von Mises Functionals (Key for SEMD)

**Definition (3.8)**: Gâteaux derivative
$$\dot{g}(F)(G-F) = \frac{\partial}{\partial\epsilon}g(F + \epsilon(G-F))|_{\epsilon=0} = \int \psi(x, F) dG(x)$$

**Condition (3.9)**: $\int \psi(x, F) dF(x) = 0$

**Taylor Approximation (3.10)**:
$$g(F_n) - g(F) = \dot{g}_F(F_n - F) + \Delta_n(F_n, F)$$

where $\Delta_n(F_n, F) = o_p(g_F(F_n - F))$.

**Theorem 3.1**: If (3.15) $\int \omega^2(x,y) dF(x) dF(y) < \infty$ and (3.16) $\int \omega^2(x,x) dF(x) < \infty$ hold, then:
$$n^{1/2}\{g(G_n) - g(F_n)\} \text{ converges weakly to } N(0, \sigma^2)$$

where $\sigma^2 = 4\left[\int\left\{\int \omega(x,y) dF(y)\right\}^2 dF(x) - g^2(F)\right]$ (Eq. 3.18)

### Section 4: Empirical Process Bootstrap

**Lemma 4.1** (Komlós-Major-Tusnády): There exist independent uniform $U_1, \ldots, U_m$ and Brownian bridge $B$ on $[0,1]$ such that:
$$P\{\|B_m - B\| \geq K_1\epsilon_m\} \leq K_1\epsilon_m$$
where $\epsilon_m = (\log m)/m^{1/2}$.

**Levy's Modulus of Continuity (4.1-4.2)**:
$$\omega(\delta, f) = \sup\{|f(s) - f(t)|: |t-s| \leq \delta\}$$
$$h(\delta) = \left(\delta \log \frac{1}{\delta}\right)^{1/2} \text{ for } 0 \leq \delta \leq \frac{1}{2}$$

**Theorem 4.1**: Along almost all sample sequences, $W_{nm}$ converges weakly to $B(F)$.

**Corollary 4.2**: For nondegenerate $F$ and $0 < a < 1$:
$$P\{n^{1/2}\sup_x |F_{nm}(x) - F_n(x)| \leq c_a(F_n) | X_1, \ldots, X_n\} \to 1-a$$

### Section 5: Quantile Process

**Definition**: $Q_n(t) = n^{1/2}\{F_n^{-1}(t) - F^{-1}(t)\}$

**Theorem 5.1**: If $F$ has continuous positive density $f$ on $R$, then given $(X_1, \ldots, X_n)$, $Q_n$ converges weakly to $B/(f \circ F^{-1})$ in the sense of weak convergence for probability measures on $D[t_0, t_1]$.

**Proposition 5.1** (Median): If $F$ has unique median $\mu$ and positive derivative $f$ in a neighborhood of $\mu$:
$$n^{1/2}(m^* - m) \text{ converges weakly to } N\left(0, \frac{1}{4f^2(\mu)}\right)$$

### Section 6: Counter-Examples

**Counter-example 1** (U-statistic with $\omega(x,x) = e^{1/x}$):
- Conditional distribution converges to Poisson($\nu$) - 1, not Normal
- Bootstrap fails due to lack of uniform convergence

**Counter-example 2** (Maximum spacings):
- For $F$ uniform on $(0, \theta)$, bootstrap for $n(X_{(n)} - X_{(n-k+1)})$ fails
- Conditional distribution does not have weak limits

### Section 8: Mathematical Appendix

**Mallows Metric** (Lemma 8.2): For real line with $\|x\| = |x|$:
$$d_p(F, G) = \left\{\int_0^1 |F^{-1}(t) - G^{-1}(t)|^p dt\right\}^{1/p}$$

**Lemma 8.3**: $d_p(\alpha_n, \alpha) \to 0$ iff:
- (a) $\alpha_n \to \alpha$ weakly
- (b) $\int \|x\|^p \alpha_n(dx) \to \int \|x\|^p \alpha(dx)$

**Lemma 8.11** (Brownian Bridge): If $B$ is the Brownian bridge and $T$ is a closed subset of $[0,1]$ which contains points other than 0 and 1, then $\sup_T |B(t)|$ has a continuous distribution.

### Simulation (Section 9)

Data: 6,672 Americans aged 18-79, systolic blood pressure
- Mean: 130.3 mmHg, SD: 23.2 mmHg
- Skewness: 1.3, Kurtosis: 2.4

**Result**: Bootstrap distribution closely follows theoretical distribution (Figure 1).

### Complete Reference List (from paper)

1. Berk (1966) - Limiting behavior of posterior distributions
2. Bickel (1969) - Contributions to order statistics
3. Bickel & Freedman (1981) - Bootstrapping regression models
4. Billingsley (1968) - Convergence of Probability Measures
5. Dobrushin (1970) - Describing random variables by conditional distributions
6. Doob (1949) - Heuristic approach to Kolmogorov-Smirnov
7. Efron (1979) - Bootstrap methods: another look at the jackknife
8. Fillipova (1962) - Mises' theorem on functionals of empirical distribution
9. Freedman (1971) - Brownian Motion and Diffusion
10. Freedman (1981) - Bootstrapping regression models
11. Hausdorff (1957) - Set Theory
12. Hoeffding (1948) - Class of statistics with asymptotically normal distributions
13. Komlós, Major, Tusnády (1975) - Approximation of partial sums
14. Major (1978) - Invariance principle for sums of independent random variables
15. Mallows (1972) - Note on asymptotic joint normality
16. Mises (1947) - Asymptotic distribution of differentiable statistical functions
17. Pyke & Shorack (1968) - Weak convergence of two-sample empirical process
18. Reeds (1976) - Definition of von Mises functionals (Thesis)
19. Singh (1981) - Asymptotic accuracy of Efron's bootstrap
20. Stigler (1973) - Asymptotic distribution of trimmed mean
21. Tanaka (1973) - Inequality for functional of probability distribution
22. Vallender (1973) - Calculation of Vasershtein distance

---
*Summary by Rachel | Image-based update 2026-02-02 | For SEMD Project*
