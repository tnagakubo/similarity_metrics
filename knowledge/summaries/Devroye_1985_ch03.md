# Devroye & Győrfi (1985) - Chapter 3: Consistency

## Citation
Devroye, L. & Győrfi, L. (1985). *Nonparametric Density Estimation: The L₁ View*. New York: Wiley.
ISBN: 0-471-81646-9

## Overview

Chapter 3 establishes the fundamental consistency results for density estimation in the L₁ norm. The main result (Theorem 1) provides **necessary and sufficient conditions** for L₁ consistency of kernel estimates, showing that all types of convergence (in probability, a.s., exponential) are equivalent.

## Key Notation

- $J_n = \int |f_n(x) - f(x)| dx$ (L₁ error)
- $f_n(x) = (nh^d)^{-1} \sum_{i=1}^n K\left(\frac{x - X_i}{h}\right)$ (kernel estimate)
- $g_h(x) = E(f_n(x)) = \int h^{-d} K\left(\frac{x-y}{h}\right) f(y) dy$ (expected value)
- $\mu_n$ = empirical measure, $\mu$ = true probability measure

## Main Results

### Theorem 1 (Kernel Estimate Consistency)

**Let $K$ be a nonnegative Borel measurable function on $\mathbb{R}^d$ with $\int K = 1$. Then the following statements are equivalent:**

(i) $J_n \to 0$ in probability as $n \to \infty$, some $f$
(ii) $J_n \to 0$ in probability as $n \to \infty$, **all** $f$
(iii) $J_n \to 0$ almost surely as $n \to \infty$, **all** $f$
(iv) $J_n \to 0$ **exponentially** as $n \to \infty$ (i.e., $\exists r, n_0 > 0$ such that $P(J_n \geq \varepsilon) \leq e^{-rn}$, $n \geq n_0$), **all** $f$
(v) $\lim_{n \to \infty} h = 0$ and $\lim_{n \to \infty} nh^d = \infty$

**Remark**: Condition (v) implies $P(J_n \geq \varepsilon) \leq e^{-rn\varepsilon^2}$ for all $\varepsilon \in (0,1)$ and $n \geq n_0$.

### Theorem 2 (Histogram Estimate Consistency)

**Assume the sequence of partitions $\mathscr{P}_n$ satisfies $\bigcap_{n=1}^\infty \sigma\left(\bigcup_{m=n}^\infty \mathscr{P}_m\right) = \mathscr{B}$. Then the following are equivalent:**

(i) $J_n \to 0$ in probability, all $f$
(ii) $J_n \to 0$ almost surely, all $f$
(iii) $J_n \to 0$ exponentially, all $f$ (exponent independent of $f$ and partition)
(iv) For all $A \in \mathscr{B}$ with $0 < \lambda(A) < \infty$, $\exists n_0$ such that $A_n \in \sigma(\mathscr{P}_n)$ with $\lambda(A \Delta A_n) < \varepsilon$, $n \geq n_0$; **and** $\sup_{M>0, \text{finite } C} \limsup_{n \to \infty} \lambda\left(\bigcup_{j: \lambda(A_{nj} \cap C) \leq M/n} A_{nj} \cap C\right) = 0$

### Theorem 3 (Relative Stability - Histogram)

Assume for the histogram estimate of Section 3, there exists a constant $\eta > 0$ such that for all $\varepsilon > 0$ and some $n_0$:
$$A_n(\varepsilon) = \sum_{\mu(A_{nj}) \leq \varepsilon} \mu(A_{nj}) \geq \eta, \quad n \geq n_0$$

Then the variation of the histogram estimate is **relatively stable in probability**:
$$\frac{\int |f_n - E(f_n)|}{E\left(\int |f_n - E(f_n)|\right)} \to 1 \quad \text{in probability}$$

### Theorem 4 (Relative Stability - Kernel)

Consider the kernel estimate with kernel $K(x) = I_{[-1/2, 1/2]^d}$ and smoothing factor $h \to 0$. Then the variation is relatively stable in probability.

### Theorem 5 (Almost Sure Bounds - Cubic Histogram)

Let $f_n$ be the cubic histogram estimate in $\mathbb{R}^d$ based on positive constants $a_i$, $1 \leq i \leq d$, and scaling factor $h$ where $\lim h = 0$, $\lim nh^d = \infty$. Let $c$ be the constant of Lemma 8. Then for all $\varepsilon \in (0,1)$ there exists $n_0 > 0$ such that for $n \geq n_0$:
$$P\left(\frac{J_n}{E(J_n)} \geq 1 + \frac{\sqrt{20}}{c\int\sqrt{f}(1-\varepsilon)}\right) \leq 3\exp\left(-\frac{4}{5}\left(\prod_{i=1}^d a_i h^d(1-\varepsilon)\right)^{-1}\right)$$

If also $\lim_{n \to \infty} h^d \log(n) = 0$, then:
$$\limsup_{n \to \infty} \frac{J_n}{E(J_n)} \leq 1 + \frac{\sqrt{20}}{c\int\sqrt{f}} \quad \text{almost surely}$$

## Key Lemmas

### Lemma 1 (Multinomial Distribution Inequality)
Let $(X_1, \ldots, X_k)$ be a multinomial $(n, p_1, \ldots, p_k)$ random vector. For $\varepsilon \in (0,1)$ and all $k$ satisfying $k/n \leq \varepsilon^2/20$:
$$P\left(\sum_{i=1}^k |X_i - E(X_i)| \geq n\varepsilon\right) \leq 3e^{-n\varepsilon^2/25}$$

### Lemma 2
For any density $f$ on $\mathbb{R}^d$, and any absolutely integrable function $K$ with $\int K(x) dx = 1$, (iv) holds whenever $\lim h = 0$ and $\lim nh^d = \infty$.

### Lemma 3
Let $K$ and $f$ be densities on $\mathbb{R}^d$. If $J_n \to 0$ in probability as $n \to \infty$, then $\lim h = 0$ and $\lim nh^d = \infty$.

### Lemma 6 (Variation Bounds)
For any density $f$ on $\mathbb{R}^d$ and any density estimate $f_n$:
$$\max\left(\int |f - E(f_n)|, \frac{1}{2}\int |f_n - E(f_n)|\right) \leq \int |f_n - f| \leq \int |f_n - E(f_n)| + \int |f - E(f_n)|$$

### Lemma 7
If the variation of a density estimate is relatively stable in probability, that is:
$$\frac{\int |f_n - E(f_n)|}{E\left(\int |f_n - E(f_n)|\right)} \to 1 \quad \text{in probability}$$
then $P(J_n/E(J_n) \notin (\frac{1}{4} - \varepsilon, 3 + \varepsilon)) \to 0$ as $n \to \infty$, all $\varepsilon > 0$.

### Lemma 8 (Binomial Deviation Inequality)
Let $X$ be a binomial $(n, p)$ random variable with $p \leq \frac{1}{2}$. Then:
$$E\left(\left(p - \frac{X}{n}\right)_+\right) \geq \begin{cases} p/e^2 & \text{if } p < 1/n \\ c\sqrt{p/n} & \text{if } p \geq 1/n \end{cases}$$
where $c = (\sqrt{4\pi} e^{13/6})^{-1}$ is a universal constant.

### Lemma 9 (Geffroy)
Let $p_1, p_2, p_3$ be a probability vector, and let $X_1, X_2, X_3$ be multinomial $(n, p_1, p_2, p_3)$ random vector. Then:
$$E\left(\left(p_1 - \frac{X_1}{n}\right)_+\left(p_2 - \frac{X_2}{n}\right)_+\right) \leq E\left(\left(p_1 - \frac{X_1}{n}\right)_+\right) E\left(\left(p_2 - \frac{X_2}{n}\right)_+\right)$$

### Lemma 10
Let $Z_1, Z_2, \ldots, Z_n$ be a sequence of nonnegative random variables with $E(Z_n) \neq 0$ for all $n$, and $E(Z_n^2) < \infty$. Then $Z_n/E(Z_n) \to 1$ in probability whenever:
$$\lim_{n \to \infty} \frac{E(Z_n^2)}{(E(Z_n))^2} = 1$$

## Proof Structure

### Proof of Theorem 1
- $(i) \Rightarrow (v)$: Established in Lemma 3
- $(v) \Rightarrow (iv)$: Established in Lemma 2
- $(iv) \Rightarrow (iii) \Rightarrow (ii) \Rightarrow (i)$: Obvious

### Proof of Theorem 2
- $(i) \Rightarrow (14)$: By Theorem 2.5
- $(iii) \Rightarrow (ii) \Rightarrow (i)$: Obvious
- $(iv) \Rightarrow (iii)$ and $(i) \Rightarrow (15)$: Lemmas 4 and 5

## Relevance to SEMD Project

### Direct Applications

1. **Consistency Conditions**: The bandwidth conditions $h \to 0$, $nh^d \to \infty$ are **necessary and sufficient** for L₁ consistency - this justifies SEMD Assumption A3

2. **Exponential Convergence**: Theorem 1(iv) provides exponential tail bounds for $J_n$, enabling concentration inequalities for SEMD

3. **Equivalence of Convergence Modes**: All forms of consistency are equivalent - we only need to verify one

4. **Relative Stability**: Theorems 3-5 show that for well-behaved estimates, $J_n/E(J_n) \to 1$ - the error is predictable

### Key Insight for SEMD

SEMD involves $\int |f_1(x) - f_2(x)| |g(x)| dx$. Chapter 3 establishes:
- With proper bandwidth: $\int |\hat{f}_k - f_k| \to 0$ exponentially fast
- The triangle inequality then gives: $|\widehat{SEMD} - SEMD| \leq \int |\hat{f}_1 - f_1||g| + \int |\hat{f}_2 - f_2||g|$

## References (from Chapter)

1. Abou-Jaoude, S. (1976a). Sur une condition nécessaire et suffisante de $L_1$-convergence. *Comptes Rendus de l'Académie des Sciences de Paris Série A* **283**, 1107-1110.
2. Abou-Jaoude, S. (1976b). Conditions nécessaires et suffisantes de convergence $L_1$. *Comptes Rendus de l'Académie des Sciences de Paris Série A* **283**, 887-889.
3. Abou-Jaoude, S. (1976c). Loi fonctionnelle du logarithme itéré pour l'estimateur de Parzen. *Comptes Rendus de l'Académie des Sciences de Paris Série A* **282**, 1049-1051.
4. Abou-Jaoude, S. (1977). Contribution à l'étude de l'histogramme et de la densité. Ph.D. Thesis, Université Paris VI.
5. Cacoullos, T. (1966). Estimation of a multivariate density. *Annals of the Institute of Statistical Mathematics* **18**, 179-189.
6. Devroye, L. (1983). The equivalence of weak, strong and complete convergence in $L_1$ for kernel density estimates. *Annals of Statistics* **11**, 896-904.
7. Geffroy, J. (see Abou-Jaoude, 1977, pp. 52-53).
8. Hall, P. (1982). Rates of convergence in the central limit theorem. *Pitman Monographs* 62.
9. Hall, P. (1984). Central limit theorem for integrated square error of multivariate nonparametric density estimators. *Journal of Multivariate Analysis* **14**, 1-16.
10. Hoeffding, W. (1963). Probability inequalities for sums of bounded random variables. *Journal of the American Statistical Association* **58**, 13-30.
11. Parzen, E. (1962). On estimation of a probability density function and mode. *Annals of Mathematical Statistics* **33**, 1065-1076.
12. Rosenblatt, M. (1956). Remarks on some nonparametric estimates of a density function. *Annals of Mathematical Statistics* **27**, 832-837.

## Tags
L1-consistency, kernel density estimation, histogram estimate, exponential convergence, relative stability, bandwidth selection, multinomial inequalities

---
*Processed by Rachel | 2026-02-02*
*Critical reference for SEMD Theorem 1 (Consistency)*
