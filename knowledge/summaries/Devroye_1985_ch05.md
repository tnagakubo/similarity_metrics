# Devroye & Győrfi (1985) - Chapter 5: Rates of Convergence in L₁

## Citation
Devroye, L. & Győrfi, L. (1985). *Nonparametric Density Estimation: The L₁ View*. New York: Wiley.
ISBN: 0-471-81646-9

## Overview

Chapter 5 provides **exact asymptotic expressions** for the expected L₁ error $E(J_n)$ of kernel and histogram density estimates. This is the central theoretical chapter establishing achievable rates that match the lower bounds from Chapter 4. The key result is that $E(J_n) = O(n^{-2/5})$ for kernel estimates with optimal bandwidth.

## Key Notation

- $f_n(x) = (nh)^{-1} \sum_{i=1}^n K\left(\frac{x - X_i}{h}\right)$ (kernel estimate)
- $J_n = \int |f_n(x) - f(x)| dx$ (L₁ error)
- $\alpha = \sqrt{\int K^2}$, $\beta = \sqrt{\int x^2 K}$
- $A(K) = (\alpha^4 \beta)^{1/5} = \left(\int K^2\right)^{2/5} \left(\int x^2 K\right)^{1/5}$
- $B(f) = \left(\frac{1}{2}\left(\int \sqrt{f}\right)^4 \int |f''|\right)^{1/5}$
- $B^*(f) = \left(\frac{1}{2}\left(\int \sqrt{f}\right)^4 \sup_{h>0} \int |(f * \phi_h)''|\right)^{1/5}$

## Function $\psi(u)$

The key function describing the exact asymptotic behavior:
$$\psi(u) = \sqrt{\frac{2}{\pi}} \left(u \int_0^u e^{-x^2/2} dx + e^{-u^2/2}\right), \quad u \geq 0$$

**Properties:**
- $\max\left(u, \sqrt{\frac{2}{\pi}}\right) \leq \psi(u) \leq u + \sqrt{\frac{2}{\pi}}$
- $\psi'(u) = \sqrt{\frac{2}{\pi}} \int_0^u e^{-x^2/2} dx \geq 0$ (monotone increasing)
- $\psi''(u) \geq 0$ (convex)
- $\lim_{u \to 0} \psi(u) = \sqrt{\frac{2}{\pi}}$

## Main Results

### Theorem 1 (Kernel Estimate - Upper Bound)

**For all $f$ in $\mathscr{F}$ having compact support, the kernel estimate defined by (1)-(3) satisfies:**

$$E(J_n) = J(n, h) + o\left(h^2 + (nh)^{-1/2}\right)$$

**where:**
$$J(n, h) = \int \frac{\alpha\sqrt{f}}{\sqrt{nh}} \psi\left(\sqrt{nh^5} \frac{\beta |f''|}{2\alpha\sqrt{f}}\right)$$

**Also:**
$$J(n, h) \leq \sqrt{\frac{2}{\pi}} \frac{\alpha \int \sqrt{f}}{\sqrt{nh}} + \frac{\beta}{2} h^2 \int |f''|$$

**When $f$ has compact support:**
$$E(J_n) \leq \sqrt{\frac{2}{\pi}} \frac{\alpha \int \sqrt{f}}{\sqrt{nh}} + \frac{\beta}{2} h^2 \sup_{a>0} \int |(f * \phi_a)''| + o((nh)^{-1/2})$$

**In particular:**
$$\limsup_{n \to \infty} \inf_h n^{2/5} E(J_n) \leq C^* A(K) B^*(f)$$

**where:**
$$C^* = 5(8\pi)^{-2/5} = 1.3768102\cdots$$

**Optimal bandwidth:**
$$h = \left[\frac{\alpha}{2\beta} \frac{\int \sqrt{f}}{\sup_{a>0} \int |(f * \phi_a)''|} \sqrt{\frac{2}{\pi}}\right]^{2/5} n^{-1/5}$$

### Theorem 2 (Kernel Estimate - Lower Bound)

**For all $f$, the kernel estimate defined by (1) and (2) satisfies:**

$$\liminf_{n \to \infty} \inf_h n^{2/5} E(J_n) \geq C \cdot A(K) \cdot B^*(f)$$
$$\geq C \cdot C_1 \cdot A(K)$$
$$\geq C \cdot C_1 \cdot C_2 = C_3$$

**where:**
- $C = \inf_u \frac{\psi(u)}{u^{1/5}} = 1.028493\cdots$ (universal constant)
- $C_1 = \inf_f B^*(f) = \left(\frac{2^9}{3^4}\right)^{1/5} = 1.4459624\cdots$
- $C_2 = \inf_{K \text{ even}} A(K) = \left(\frac{9}{125}\right)^{1/5} = 0.59083538\cdots$

**Key insight**: The upper bound constant $C^*$ is only about **35% larger** than the lower bound constant $C$.

### Theorem 3 (Minimum of $B^*(f)$)

The infimum of $B^*(f)$ over all densities is:
$$C_1 = \left(\frac{2^9}{3^4}\right)^{1/5} = 1.4459624\cdots$$

This is **attained for the isosceles triangular density** (easiest to estimate).

### Theorem 5 (Histogram Estimate - Upper Bound)

**Let $f \in \mathscr{F}$ have compact support. For the histogram estimate defined by (6) and (3), we have:**

$$E(J_n) = J(n, h) + o\left(h + \frac{1}{\sqrt{nh}}\right)$$

**where:**
$$J(n, h) = \int \sqrt{\frac{f}{nh}} \psi\left(\frac{h}{2}|z_n|\sqrt{\frac{nh}{f}}\right)$$

### Theorem 6 (Histogram Estimate - Exact Asymptotic)

**Let $f \in \mathscr{F}$ have compact support. For the histogram estimate:**

$$E(J_n) = J(n, h) + o\left(h + \frac{1}{\sqrt{nh}}\right)$$

**where:**
$$J(n, h) = \int \sqrt{\frac{f}{nh}} \psi\left(\frac{h}{2}|z_n|\sqrt{\frac{nh}{f}}\right)$$

**In particular:**
$$\limsup_{n \to \infty} \inf_h n^{1/3} E(J_n) \leq C_H^* B_H(f)$$

**where $C_H^* = (27/4\pi)^{1/3} = 1.290381\cdots$**

**Key comparison**: Histogram rate is $n^{-1/3}$, kernel rate is $n^{-2/5}$ - kernel is better.

### Theorem 9

**For all $f \in \mathscr{F}$, $B_H^*(f) = B_H(f)$. For all $f$, $B_H^*(f) \geq 1$, and this bound is attained for the uniform density on [0,1].**

### Theorem 10 (Uniform Upper Bound)

**Let $K$ be a bounded density with compact support, and let $h$ satisfy (3). Then for the kernel estimate (1) and all $f$ with compact support:**

$$E(J_n) \leq \sqrt{\frac{2}{\pi}} \frac{\alpha \int \sqrt{f}}{\sqrt{nh}} + h\gamma \sup_{a>0} \int |(f * \phi_a)'| + o((nh)^{-1/2})$$

**Furthermore:**
$$\limsup_{n \to \infty} \inf_h n^{1/3} E(J_n) \leq C_1^* A_1(K) B_H^*(f)$$

**where $C_1^* = \frac{3}{\pi^{1/3}} = 2.0483522\cdots$**

### Theorem 17 (Achievability of $1/\sqrt{n}$ Rate)

**Let $s \geq 3$ be an integer, and let $T$ and $C$ be large enough so that $A_{T,s,C}$ is nonempty. Then the trapezoidal kernel estimate $f_n$ with smoothing factor $h$ chosen fixed as in (23) and $k = g_1$ satisfies:**

$$\sup_{f \in A_{T,s,C}} \sqrt{n} E\left(\int |f_n - f|\right) \leq \left(\frac{16s}{s-2} \frac{T^{1/2-1/s}}{\pi^{3/2}\sqrt{2}} \left(\frac{C}{2}\right)^{1/s} + \frac{4}{\sqrt{\pi}}\right) \frac{1}{\sqrt{n}}$$

## Key Lemmas

### Lemma 4 (Bias Bounds)
For density $K$ satisfying (2), and $\phi \in \mathscr{F}$ with four continuous derivatives and compact support, $\phi'' \in \mathscr{F}$:

(i) $\int |f * K_h - f| \leq h^2(\beta/2)\int |f''|$, all $f \in \mathscr{F}$, all $h \geq 0$
(ii) $\int |f * K_h - f| \leq h^2(\beta/2)\liminf_{a \to 0} \int |(f * \phi_a)''|$, all $f$, all $h \geq 0$
(iii) $\int |f * K_h - f| \geq h^2[(\beta/2)\int |(f * \phi_a)''| - h^2\beta_1\int |(f * \phi_a)''''|]$, all $h, a > 0$, all $f$

### Lemma 5

$B^*(f)$ is independent of the choice of $\phi$, and for $f$ in $\mathscr{F}$, $B^*(f) = B(f)$.

### Lemma 18 (Bias-Variance Decomposition)

$$E(J_n) = E\left(\int |f_n - E(f_n)|\right) + \int |E(f_n) - f| + \text{interaction term}$$

### Lemma 29 (Characteristic Function Bound)

Let $f$ be a density with characteristic function $\phi$, and let $K$ be a Borel measurable function satisfying $\int K = 1$, $\int |K| < \infty$. Assume $K$ has characteristic function $\psi(t) = \int e^{itx} K(x) dx$, $t \in \mathbb{R}$. Then:
$$\int |f - f * K| \geq \sup_t |\phi(t) - \phi(t)\psi(t)|$$

## Smoothness Functionals

### For Kernel Estimate
$$B^*(f) = \left(\frac{1}{2}\left(\int \sqrt{f}\right)^4 \sup_{h>0} \int |(f * \phi_h)''|\right)^{1/5}$$

### For Histogram Estimate
$$B_H(f) = \left[\frac{1}{2}\left(\int \sqrt{f}\right)^2 \int |f'|\right]^{1/3}$$

## Optimal Kernels

### Epanechnikov Kernel (Minimizes $A(K)$ for even kernels)
$$K(x) = \frac{3}{4}(1 - x^2), \quad |x| \leq 1$$

Takes the value $C_2 = (9/125)^{1/5} = 0.59083538\cdots$

### Bartlett Kernel
$$K(x) = \frac{3}{4}(1 - x^2), \quad |x| \leq 1$$

## Table 1: Values for Common Distributions

| Distribution | $\int\sqrt{f}$ | $\int|f'|$ | $B^*(f)$ | $B_H(f)$ | $c_K(\theta)$ | $c_H(\theta)$ |
|--------------|----------------|------------|----------|----------|---------------|---------------|
| Normal | 1.520 | 0.798 | 1.590 | 1.060 | 1.837 | 1.237 |
| Laplace | 1.682 | 1 | 1.655 | 1.189 | 1.913 | 1.386 |
| Logistic | 1.572 | 1/2 | 1.474 | 0.933 | 1.703 | 1.088 |
| Cauchy | 1.571 | 2/π | 1.507 | 0.981 | 1.742 | 1.144 |
| Student(3) | 1.519 | 0.520 | 1.469 | 0.932 | 1.697 | 1.087 |
| Student(5) | 1.520 | 0.573 | 1.494 | 0.962 | 1.726 | 1.122 |

## Bandwidth Selection

### Optimal h for Kernel Estimate
$$h_{opt} = \left[\frac{\alpha \int\sqrt{f}}{2\beta \sup_{a>0}\int|(f*\phi_a)''|} \sqrt{\frac{2}{\pi}}\right]^{2/5} n^{-1/5}$$

### Optimal h for Histogram Estimate
$$h_{opt} = (\sqrt{8\pi})^{1/3} \hat{\sigma} n^{-1/3}$$

where $\hat{\sigma}$ is a robust estimate of scale (e.g., from IQR).

## Relevance to SEMD Project

### Direct Applications

1. **Rate $n^{-2/5}$ for Kernel Estimates**: This is the achievable rate for smooth densities with second derivatives - justifies SEMD's Theorem 1 rate

2. **Exact Constants**: The constants $C^*$, $C$, $C_1$, $C_2$ allow precise error bounds for SEMD

3. **Bias-Variance Trade-off**: The decomposition $E(J_n) = \text{variance} + \text{bias}$ directly applies to SEMD error analysis

4. **Bandwidth Selection**: The optimal bandwidth formula can guide practical SEMD implementation

### Connection to SEMD

For SEMD = $\int |f_1 - f_2| |g| dx$:
- Triangle inequality: $|\widehat{SEMD} - SEMD| \leq \int |\hat{f}_1 - f_1||g| + \int |\hat{f}_2 - f_2||g|$
- With $|g| \leq M$: Error bounded by $M \cdot (E(J_{n,1}) + E(J_{n,2}))$
- Rate: $O(n^{-2/5})$ for each density estimate

## References

1. Abou-Jaoude, S. (1977). La convergence $L_1$ et $L_\infty$ de certains estimateurs. Thèse, Université Paris VI.
2. Bartlett, M.S. (1963). Statistical estimation of density functions. *Sankhya Series A* **25**, 245-254.
3. Beckenbach, E.F. & Bellman, R. (1965). *Inequalities*. Springer-Verlag.
4. Bretagnolle, J. & Huber, C. (1979). Estimation des densités: risque minimax. *Zeitschrift für Wahrscheinlichkeitstheorie* **47**, 119-137.
5. Davis, K.B. (1975, 1977). Mean square error properties of density estimates. *Annals of Statistics* **3**, 1025-1030; **5**, 530-535.
6. Deheuvels, P. (1977). Estimation non paramétrique de la densité. *Revue de Statistique Appliquée* **25**, 5-42.
7. Epanechnikov, V.A. (1969). Nonparametric estimates of a multivariate probability density. *Theory of Probability and Its Applications* **14**, 153-158.
8. Freedman, D. & Diaconis, P. (1981). On the histogram as a density estimator: $L_2$ theory. *Zeitschrift für Wahrscheinlichkeitstheorie* **57**, 453-476.
9. Haagerup, U. (1978). Les meilleures constantes de l'inégalité de Khintchine. *Comptes Rendus de l'Académie des Sciences de Paris A* **286**, 259-262.
10. Ibragimov, I.A. & Khasminskii, R.Z. (1982). Estimation of distribution density. *Theory of Probability and Its Applications* **27**, 551-562.
11. Rosenblatt, M. (1979). Global measures of deviation for kernel and nearest neighbor density estimates. *Lecture Notes in Mathematics* **757**, 181-190.
12. Szarek (1976). Szarek's inequality.
13. Tapia, R.A. & Thompson, J.R. (1978). *Nonparametric Probability Density Estimation*. Johns Hopkins.
14. Watson, G.S. & Leadbetter, M.R. (1963). On the estimation of the probability density. *Annals of Mathematical Statistics* **34**, 480-491.
15. Young (1976). Best values for $C_p$.

## Tags
L1-convergence, kernel density estimation, histogram, optimal bandwidth, rates of convergence, bias-variance tradeoff, Epanechnikov kernel, exact asymptotics

---
*Processed by Rachel | 2026-02-02*
*Critical reference for SEMD Theorem 1 (Asymptotic Normality) convergence rates*
