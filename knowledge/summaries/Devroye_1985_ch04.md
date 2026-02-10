# Devroye & Győrfi (1985) - Chapter 4: Lower Bounds for Rates of Convergence

## Citation
Devroye, L. & Győrfi, L. (1985). *Nonparametric Density Estimation: The L₁ View*. New York: Wiley.
ISBN: 0-471-81646-9

## Overview

Chapter 4 establishes **lower bounds** for the rate of convergence in L₁ density estimation. These are fundamental impossibility results showing that no density estimate can converge faster than certain rates over broad classes of densities. The key insight is the **slow convergence theorem**: for any density estimate, there exist densities making convergence arbitrarily slow.

## Key Notation

- $J_n = \int |f_n(x) - f(x)| dx$ (L₁ error)
- $\mathscr{F}$ = class of densities
- $m(n, \mathscr{F}) = \inf_{f_n} \sup_{f \in \mathscr{F}} E(\int |f_n - f|)$ (minimax error)
- $D_s(f) = \left(\int |f^{(s)}|\right)^{1/(2s+1)} \left(\int \sqrt{f}\right)^{2s/(2s+1)}$ (smoothness functional)

## Density Classes

- **G**: all densities on [0,1] bounded by 2
- **G∞**: all densities on [0,1] bounded by 2+δ, infinitely differentiable
- **H(g)**: all densities of form $\sum_{i=1}^\infty p_i g(x + x_i)$ where g is fixed, $(p_i)$ probability vector
- **U**: all monotone densities on [0,∞) with peak at 0
- **U∞**: all symmetric unimodal infinitely differentiable densities centered at 0
- **Π(g)**: densities $f(x) = pg(x) + (1-p)g(x+2)$ for $p \in [0,1]$
- **F_{s,r}**: densities on [0,1] with (s-1) continuous derivatives and $D_s(f) \leq r$
- **F_{s,∞}**: densities on [0,1] with (s-1) continuous derivatives and $D_s(f) < \infty$
- **W(0,1,C)**: densities on [0,1] bounded by C with bounded variation
- **BS**: all normal $(0, \sigma^2)$ densities
- **Q_r(g)**: densities $f(x) = 1 + \varepsilon b_i g(x - i/r)$ for $i/r \leq x < (i+1)/r$

## Main Results

### Theorem 1 (Slow Convergence Theorem)

**Let $f_n$ be any density estimate. Then:**

(i) $\inf_n \sup_{f \in \mathscr{F}} E\left(\int |f_n - f|\right) \geq c$

where $c = 1$ for $\mathscr{F} = G, G_\infty$ or $H(g)$, and $c = \frac{1}{8}$ for $\mathscr{F} = U$ or $U_\infty$.

(ii) Let $\{a_n\}$ be a sequence of positive numbers tending to 0. Then, for all $\mathscr{F}$ mentioned in (i):
$$\sup_{f \in \mathscr{F}} \limsup_{n \to \infty} \frac{1}{a_n} E\left(\int |f_n - f|\right) = \infty$$

**Interpretation**: No matter what estimate is used, there exist densities in each class making convergence arbitrarily slow.

### Theorem 2 (Uniform Lower Bound with Smoothness)

**Let $f_n$ be any density estimate. Let g be any density on [0,1] with continuous sth derivative $g^{(s)}$. Then:**

$$\liminf_{n \to \infty} n^{s/(2s+1)} \sup_{f \in H(g)} \frac{E\left(\int |f_n - f|\right)}{D_s(f)} \geq \frac{(s/e(2s+1))^{s/(2s+1)}}{D_s(g)}, \quad \text{all } s \geq 1$$

**Key insight**: The optimal rate $n^{-s/(2s+1)}$ depends on smoothness s.

### Theorem 3 (Bretagnolle and Huber, 1979)

**Let $r^*$ be at least equal to $\left(\frac{1}{4}9^s(s+1)!\right)^{1/(2s+1)}$. For any density estimate $f_n$:**

$$\liminf_{n \to \infty} n^{s/(2s+1)} \sup_{f \in F_{s,r}} E\left(\int |f_n - f|\right) \geq (2e)^{-4}\left(\frac{r}{r^*} - 1\right), \quad \text{all } r > r^*$$

**and**

$$\liminf_{n \to \infty} n^{s/(2s+1)} \sup_{f \in F_{s,\infty}} E\left(\int |f_n - f|\right) = \infty$$

### Theorem 4 (Parametric Family Lower Bound)

**Let $f_n$ be any density estimate and let g be an arbitrary density with support in [0,1]. Then:**

(i) For all $n \geq 4$:
$$\sup_{f \in \Pi(g)} \sqrt{n} E\left(\int |f_n - f|\right) \geq 0.030153\cdots$$

(In fact, $\geq (0.0849856\cdots + o(1))/\sqrt{n}$)

(ii) $\sup_{f \in \Pi(g)} \limsup_{n \to \infty} \sqrt{n} E\left(\int |f_n - f|\right) \geq 0.0424928\cdots$

**Interpretation**: Even for simple two-point mixtures, the best rate is $1/\sqrt{n}$.

### Theorem 5 (Assouad's Lemma - General Form)

**Let $r \geq 1$ be an integer, and let $b = (b_1, \ldots, b_r) \in \{-1, 1\}^r$ be a parameter of a family of densities $\{f_b\}$ such that:**

(i) $\int |f_{b^+} - f_{b^-}| \geq 2\alpha$ when $b^+$ and $b^-$ differ only in the ith component
(ii) $\int \sqrt{f_{b^+} f_{b^-}} \geq 1 - \gamma$ when $b^+$ and $b^-$ differ only in the ith component

**Then:**
$$\sup_b E\left(\int |f_n - f_b|\right) \geq \frac{r\alpha}{2}(1 - \gamma)^n$$

### Theorem 6

Under conditions of Theorem 5 with $\int f_{b^+} f_{b^-} = 1 - \gamma^2$:
$$\sup_b E\left(\int |f_n - f_b|\right) \geq \frac{r\alpha}{2}\left(1 - \sqrt{2n\gamma^2}\right)$$

### Theorem 7 (Bounded Variation Class)

**For all $C \geq 288$:**
$$\sup_{f \in W(0,1,C)} E\left(\int |f_n - f|\right) \geq \begin{cases} \left(\frac{1}{32}\left(\frac{30}{23}\right)^{2/5} C^{1/5} + o(1)\right) n^{-2/5} \\ \frac{C}{32}\left(\left(\frac{23nC^2}{30}\right)^{1/5} + 8\right)^{-2}, & n \geq \frac{15C}{368} \end{cases}$$

### Theorem 8 (Step Function Perturbation)

**Let $f_n$ be any density estimate. Let $r \geq 1$ be a fixed integer, and let g be a fixed measurable function on $[0, 1/r)$ with $|g| \leq 1$, $\int_0^{1/r} g = 0$. Let $Q_r(g)$ be the class of densities:**
$$f(x) = 1 + \varepsilon b_i g\left(x - \frac{i}{r}\right), \quad \frac{i}{r} \leq x < \frac{i+1}{r}, \quad i = 0, 1, \ldots, r-1$$

**Then:**
$$\sup_{f \in Q_r(g)} E\left(\int |f_n - f|\right) \geq \frac{r\int |g|}{\sqrt{32n\int g^2}}, \quad n \geq \frac{1}{8\int g^2}$$

**In particular**, if $g = 1$ on $[0, 1/(2r))$ and $g = -1$ on $[1/(2r), 1/r)$, then:
$$\sup_{f \in Q_r(g)} E\left(\int |f_n - f|\right) \geq \sqrt{r/32n}, \quad n \geq r/8$$

**and**
$$\sup_{f \in U \cup Q_r(g)} E\left(\int |f_n - f|\right) \geq \frac{1}{2} \quad \text{for all } n$$

### Theorem 9 (Monotone Density Lower Bound)

**For any density estimate $f_n$:**
$$\liminf_{n \to \infty} n^{1/3} \sup_{f \in U: f(0) \leq B} E\left(\int |f_n - f|\right) \geq \frac{1}{16(2(n/4)^{1/3} + 3)}$$

### Theorem 11

**Let g be infinitely differentiable with support on [0,1], and let $d = 1$. Then:**
$$\liminf_{n \to \infty} n^{ps/(2s+1)} \sup_{f \in H(g)} \frac{E\left(\int |f_n - f|^p\right)}{D_{sp}(f)} \geq \frac{1}{2^{p-1}} \frac{\left(\frac{ps}{2s+1} \cdot \frac{1}{e}\right)^{ps/(2s+1)}}{D_{sp}(g)}$$

for all $p, s \geq 1$, and all density estimates $f_n$.

### Theorem 12 (Boyd and Steele, 1978) - L₂ Lower Bound

**For any density estimate $f_n$, there exists an $f \in BS$ (normal densities) such that:**
$$\limsup_{n \to \infty} nE\left(\int (f_n - f)^2\right) \geq c(f) > 0$$

where $c(f)$ is a constant depending only upon $f$.

## Key Lemmas

### Lemma 1 (Testing Lower Bound)

For densities $f_0, f_1$ and any test $\delta_n$:
$$P_{f_0}(\delta_n = 1) + P_{f_1}(\delta_n = 0) \geq \int \min(f_0^n, f_1^n) = \left(\int \sqrt{f_0 f_1}\right)^n$$

### Lemma 2 (Hellinger Affinity)

If $\int \sqrt{f_0 f_1} = 1 - \gamma$ and $\int |f_0 - f_1| = 2\alpha$, then:
$$E_{f_0}\left(\int |f_n - f_0|\right) + E_{f_1}\left(\int |f_n - f_1|\right) \geq 2\alpha(1 - \gamma)^n$$

## Proof Techniques

1. **Randomization over density families**: Construct families with binary parameters
2. **Information-theoretic bounds**: Use Hellinger affinity and testing theory
3. **Assouad's Lemma**: Convert estimation to multiple hypothesis testing
4. **ε-entropy and ε-capacity**: Kolmogorov-Tikhomirov (1961) metric entropy bounds

## Relevance to SEMD Project

### Key Insights

1. **Minimax Rates**: The optimal rate $n^{-s/(2s+1)}$ for densities with s continuous derivatives justifies bandwidth choices in SEMD

2. **No Free Lunch**: Theorem 1 shows that for **any** estimate, some densities make convergence arbitrarily slow - we cannot escape smoothness assumptions

3. **Parametric vs Nonparametric**: Theorem 4 shows even simple parametric families have $1/\sqrt{n}$ rate, which is achieved by the bootstrap

4. **Role of $\int\sqrt{f}$**: The functional $D_s(f)$ includes $\int\sqrt{f}$, connecting to Hellinger distance - relevant for SEMD's absolute difference structure

### Application to SEMD

- SEMD involves $\int |f_1 - f_2| |g|$ - the L₁ structure means these lower bounds apply
- For smooth densities (Assumption A2), the rate $n^{-s/(2s+1)}$ is achievable
- The $\sqrt{n}$ rate for the bootstrap in Theorem 3 of SEMD paper is consistent with these bounds

## References

1. Assouad, P. (1983). Deux remarques sur l'estimation. *Comptes Rendus de l'Académie des Sciences de Paris* **296**, 1021-1024.
2. Birgé, L. (1980). Thèse, 3ᵉ partie, Université Paris VII.
3. Birgé, L. (1983a). Approximation dans les espaces métriques et théorie de l'estimation. *Zeitschrift für Wahrscheinlichkeitstheorie* **65**, 181-237.
4. Birgé, L. (1983b). On estimating a density using Hellinger distance. Report MSRI 045-83, UC Berkeley.
5. Boyd, D.W. & Steele, J.M. (1978). Lower bounds for nonparametric density estimation rates. *Annals of Statistics* **6**, 932-934.
6. Bretagnolle, J. & Huber, C. (1979). Estimation des densités: risque minimax. *Zeitschrift für Wahrscheinlichkeitstheorie* **47**, 119-137.
7. Deheuvels, P. (1977a,b). Estimation non paramétrique de la densité. *Publications de l'Institut de Statistique de l'Université de Paris* **22**, 1-23.
8. Devroye, L. (1983). On arbitrarily slow rates of global convergence. *Zeitschrift für Wahrscheinlichkeitstheorie* **62**, 475-483.
9. Farrell, R.H. (1967, 1972). On the lack of a uniformly consistent sequence of estimators. *Annals of Mathematical Statistics* **38**, 471-474.
10. Ibragimov, I.A. & Khasminskii, R.Z. (1981). *Statistical Estimation: Asymptotic Theory*. Springer.
11. Kiefer, J. (1982). Survey of lower bounds literature.
12. Kolmogorov, A.N. & Tikhomirov, V.M. (1961). ε-entropy and ε-capacity of sets in functional spaces. *American Mathematical Society Translations* **17**, 277-364.
13. Stone, C.J. (1980). Optimal rates of convergence for nonparametric estimators. *Annals of Statistics* **8**, 1348-1360.
14. Wahba, G. (1975). Optimal convergence properties of variable knot, kernel, and orthogonal series methods.

## Tags
lower bounds, minimax rates, slow convergence, Assouad's lemma, density estimation, information theory, ε-entropy, optimal rates

---
*Processed by Rachel | 2026-02-02*
*Critical reference for SEMD convergence rate analysis*
