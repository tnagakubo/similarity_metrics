# Dümbgen (1993) - On Nondifferentiable Functions and the Bootstrap

## Citation
Dümbgen, L. (1993). On nondifferentiable functions and the bootstrap. *Probability Theory and Related Fields*, 95, 125-140.
DOI: [10.1007/BF01197342](https://doi.org/10.1007/BF01197342)

## Summary

This paper addresses a fundamental problem in bootstrap theory: when the functional of interest φ is **not differentiable**, the naive bootstrap fails. Dümbgen investigates statistical problems where standard bootstrap methods fail due to non-differentiability, proposes the "rescaled bootstrap" as one alternative (which also has limitations), and develops a robust confidence set construction method based on inverting tests.

The key insight is that for functionals satisfying only **directional (Hadamard) differentiability** rather than full Fréchet differentiability, the naive bootstrap estimator converges to a *random* limit distribution rather than the correct fixed limit. This is because the derivative Φ is nonlinear, causing the bootstrap distribution to depend on the random realization.

## Key Contributions

1. **Characterization of Bootstrap Failure**: Shows precisely why naive bootstrap fails for non-smooth functionals - the bootstrap distribution converges to a random measure $M_{(Δ+B)}$ rather than the target $M_{(0)}$

2. **Rescaled Bootstrap**: Proposes modification using subsample size $m = m(n)$ with $m \to \infty$, $m/n \to 0$:
   $$\tilde{M}_n = \mathscr{L}_{X \sim \hat{L}_n}(\Phi_m(X, \sqrt{m/n}\hat{\Delta}_n))$$
   - Works when $t_n = t$ (constant parameter)
   - Fails under local alternatives ($\Delta \neq 0$)

3. **Robust Confidence Sets via Test Inversion**: Develops computer-intensive method that:
   - Tests each hypothetical parameter ξ for plausibility
   - Uses random finite subset $\hat{\Xi}_n$ of parameter space
   - Constructs confidence bound $\hat{R}_n$ from accepted tests

4. **Directional Differentiability Condition (B2)**:
   $$\lim_{r \downarrow 0, x' \to x} r^{-1}(\phi(t + rx') - \phi(t)) = \Phi(x) \quad \forall x \in X_o$$
   where $\Phi$ is continuous, positive homogeneous, but **nonlinear** in general

## Main Results

### Proposition 1 (Naive Bootstrap Failure)
Under A1-2 and B1-2:
- $\Phi_n(\hat{\Delta}_n) - \Phi_n(\Delta_n) \xrightarrow{d} \Phi(B, \Delta)$
- Bootstrap estimator $\hat{M}_n f \xrightarrow{d} M_{(\Delta+B)} f$ (random limit!)

### Proposition 2 (Rescaled Bootstrap)
The rescaled bootstrap $\tilde{M}_n$ converges weakly to $M_{(0)}$ in probability.
- Correct for $\Delta = 0$
- Incorrect for $\Delta \neq 0$ unless Φ is linear

### Theorem 1 (Robust Confidence Sets - Lower Bound)
Under conditions A1-3, C1, D1:
$$\limsup_{n \to \infty} P_n\{\Phi_n(\Delta_n) \notin \hat{C}_n\} \leq \Pr\{S \circ \Phi(B) \geq q(0)\}$$

### Theorem 2 (Upper Bound)
Under A1-3, C2, D1-2, the confidence bound $\hat{R}_n$ is stochastically bounded.

## Examples

### Example 2.1: Eigenvalues of Covariance Matrix
- $\phi(x)$ = ordered eigenvalues of symmetric matrix $x$
- Lipschitz continuous, positive homogeneous
- **Differentiable iff all eigenvalues distinct**
- Classic counterexample (Beran & Srivastava, 1985)

### Example 2.2: Minimum Distance Functionals
- $\phi(x) = \inf_{\theta \in \Theta} \|q_\theta - x\|$
- Lipschitz continuous with constant 1
- Non-differentiable at boundary of parametric family

## Technical Framework

### Assumptions
- **A1**: $B_n = \sqrt{n}(\hat{t}_n - t_n) \xrightarrow{d} B$ with tight Borel distribution $L$
- **A2**: $\hat{L}_n$ converges weakly to $L$ in probability (bootstrap consistency for base estimator)
- **A3**: supp$(L)$ is a linear subspace of $\mathbf{X}$
- **B1**: $\sqrt{n}(t_n - t) \to \Delta$ for fixed $t, \Delta$
- **B2**: Directional differentiability at $t$
- **C1-C2**: Conditions on random test grid $\hat{\Xi}_n$
- **D1-D2**: Convergence conditions for $\Phi_n$

### Key Insight for SEMD
The absolute value functional $|f_1 - f_2|$ in SEMD is **not Fréchet differentiable** at points where $f_1 = f_2$. This paper provides:

1. **Theoretical justification** for why naive bootstrap might fail for SEMD
2. **Conditions under which rescaled bootstrap works**: when $f_1 \neq f_2$ a.e. (our Assumption A4)
3. **Alternative confidence set construction** when standard bootstrap is unreliable

## Relevance to SEMD Project

### Direct Applications

1. **Theorem 3 Proof Foundation**:
   - SEMD functional $T(F_1, F_2) = \int |f_1 - f_2| \cdot |g| dx$ is only directionally differentiable
   - Assumption A4 ($f_1 \neq f_2$ a.e. on support of $g$) ensures non-degeneracy
   - Rescaled bootstrap applies under constant parameter assumption

2. **Bootstrap Validity Conditions**:
   - Need to verify B2 (directional differentiability) for SEMD
   - Dümbgen's framework explains why we need $f_1 \neq f_2$ assumption

3. **Confidence Set Construction**:
   - If standard bootstrap has issues, test-inversion method provides alternative
   - Computationally intensive but theoretically robust

### Limitations for SEMD
- Dümbgen focuses on fixed parameter sequences
- SEMD in MRCT context may involve local alternatives (different regional distributions)
- May need hybrid approach combining rescaled bootstrap with test inversion

## Key Quotes

> "We investigate a class of statistical problems, where usual bootstrap methods fail, and discuss two alternative solutions."

> "However the functions φ we are interested in are not necessarily differentiable, although they have other regularity properties. One consequence is that the naive bootstrap fails in general."

> "For Δ = 0 this is the correct limit, but otherwise the distributions M_(Δ) and M_(0) can be different, unless Φ is linear."

## Methods Extracted

### Directional Hadamard Derivative
For SEMD with $T(f_1, f_2; g) = \int |f_1 - f_2| |g| dx$:

The directional derivative at $(f_1, f_2)$ in direction $(h_1, h_2)$ is:
$$\Phi(h_1, h_2) = \int \text{sign}(f_1 - f_2)(h_1 - h_2) |g| dx$$

when $f_1 \neq f_2$ a.e. on $\{g \neq 0\}$.

### Rescaled Bootstrap Algorithm
1. Draw bootstrap samples of size $m$ where $m/n \to 0$
2. Compute $\tilde{M}_n = \mathscr{L}(\sqrt{m}(\phi(\hat{t}_n + m^{-1}X) - \phi(\hat{t}_n)))$
3. Use quantiles of $\tilde{M}_n$ for inference

## References (from paper)
- Beran & Srivastava (1985) - Bootstrap for covariance eigenvalues
- Bretagnolle (1983) - Sample size modification
- van der Vaart & Wellner (1989) - Extended Continuous Mapping Theorem
- Gill (1989) - Compact differentiability and von Mises method

## Detailed Results (from Image Reading 2026-02-02)

### Core Framework

**Assumption A1**: $B_n := \sqrt{n}(\hat{t}_n - t_n)$ converges in distribution to $B$, where $L := \mathscr{L}(B)$ is a tight Borel distribution on $\mathbf{X}$

**Assumption A2**: $\hat{L}_n$ converges weakly to $L$ in probability

**Assumption B1**: $\sqrt{n}(t_n - t) \to \Delta$ for fixed points $t, \Delta \in \mathbf{X}$

**Assumption B2**: There exists a linear space $\mathbf{X}_o \subset \mathbf{X}$ containing supp$(L)$ and $\Delta$, and a function $\Phi: \mathbf{X}_o \to \mathbf{Y}$ such that:
$$\lim_{r \downarrow 0, x' \to x} r^{-1}(\phi(t + rx') - \phi(t)) = \Phi(x) \quad \forall x \in \mathbf{X}_o$$

$\Phi$ is automatically continuous and positive homogeneous, i.e., $\Phi(rx) = r\Phi(x)$ for $r \geq 0$. If $\Phi$ is linear, then $\phi$ is compactly differentiable at $\mathbf{X}_o$ in the sense of Gill (1989).

### Section 2: Naive and Rescaled Bootstrap

**Proposition 1**: Suppose A1-2 and B1-2 hold. Then:
$$\Phi_n(\hat{\Delta}_n) - \Phi_n(\Delta_n) \xrightarrow{d} \Phi(B, \Delta)$$
Further, for any fixed $f \in \mathscr{C}(\mathbf{Y}, [0,1])$:
$$\hat{M}_n f \xrightarrow{d} M_{(\Delta+B)} f \text{ (random variable!)}$$

where $M_{(z)} := \mathscr{L}(\Phi(B, z))$.

**Key insight**: While $\Phi_n(\hat{\Delta}_n) - \Phi_n(\Delta_n)$ has a definite limiting distribution, the bootstrap estimator $\hat{M}_n$ converges to a **random measure**.

**Proposition 2**: Under A1-2 and B1-2, the rescaled bootstrap estimator $\tilde{M}_n$ converges weakly to $M_{(0)}$ **in probability**.

For $\Delta = 0$ this is correct, but for $\Delta \neq 0$, $M_{(\Delta)}$ and $M_{(0)}$ can be different unless $\Phi$ is linear.

### Section 3: Robust Confidence Sets

**Assumption A3**: supp$(L)$ is a linear subspace of $\mathbf{X}$

**Assumption B3**: $t_n \to t$

**Confidence set definition**:
$$C_n = \{y \in \mathbf{Y}: S(\Phi(\hat{\Delta}_n) - y) \leq R_n\}$$

where $S: \mathbf{Y} \to \mathbf{R}$ is Lipschitz continuous.

**Naive bootstrap confidence bound**:
$$\hat{q}_n(\xi) := \sup\{r \in \mathbf{R}: \Pr_{X \sim \hat{L}_n}\{S \circ \Phi_n(X, \xi) \geq r\} \geq \alpha\}$$

**Stochastic procedure**: Test "$\Delta_n = \xi$" for all points $\xi$ in a random finite subset $\hat{\Xi}_n$.

**Conditions C1-C2**:
- **C1**: $\min_{\xi \in \hat{\Xi}_n} \|\xi - \Delta_n - z\| \to_p 0$ for all $z \in \text{supp}(L)$
- **C2**: $\max_{\xi \in \hat{\Xi}_n} \|\xi - \hat{\Delta}_n\| = o_p(\sqrt{n})$

**Theorem 1**: Suppose A1-3, C1, and D1 are satisfied, and define:
$$f^*(x) := \sup\{T(x, z): z \in \text{supp}(L), T(x, z) < q(z)\}$$

If $f: \mathbf{X} \to [-\infty, \infty)$ is upper semicontinuous such that $f \leq f^*$ on supp$(L)$, then:
$$\exp(\hat{R}_n) \geq \exp(f(B_n)) + o_p(1)$$

**Theorem 2**: Suppose A1-3, C2, and D1-2 are satisfied. Let
$$F^*(x) := \sup\{T(x, Z): Z \in \mathscr{Z}, T(x, Z) \leq q(Z)\}$$

Then $F^*$ is bounded from above, and:
$$\hat{R}_n \leq F(B_n) + o_p(1)$$

**Proposition 3**: Suppose A1-3, C1-2, and D3 are satisfied, where $\mathscr{L}(S \circ \Phi_o(B))$ is continuous. Then:
$$\lim_{n \to \infty} P_n\{\Phi_n(\Delta_n) \notin \hat{C}_n\} = 1 - \alpha$$

### Example 2.1: Eigenvalues (continued)

For $\psi(x) := (\log \phi_1(x), \ldots, \log \phi_d(x))$ and $S(y) := \max_{1 \leq i \leq d} |y_i|$:

**Limit function** (when $E_o = E(t)$, i.e., all eigenvalues distinct):
$$\Psi_o(x) := t^{-1}(x_{1,1}, \ldots, x_{d,d})$$

Equation (5):
$$t^{-1}\Phi(\tau^* x \tau, \text{diag}(y) | E) = t^{-1}(\Phi(\text{diag}(y) + \tau^* x \tau | E) - \Phi(\text{diag}(y) | E))$$

**Condition (6)**: Leb$\{x \in \mathbf{X}: \text{some component of } \Psi(x) \text{ equals } \lambda\} = 0$ for all $\lambda \in \mathbf{R}$

### Example 2.2: Minimum Distance (continued)

**Lemma 2**: Let $(s_n)_n$ be a sequence in $\mathbf{X}$ such that $\phi(s_n) = O(\sqrt{n^{-1}})$ and $s_n \to q_\theta$ for some $\theta \in \Theta$. Let $(\theta_n)_n$ be any sequence in $\Theta$ such that $\|q_{\theta_n} - s_n\| \leq \phi(s_n) + n^{-1}$, and define $\pi_n := \sqrt{n}(s_n - q_{\theta_n})$. Then:
$$\sqrt{n}\phi(s_n + \sqrt{n^{-1}}x) - \min_{h \in \mathbf{R}^p} \|D_\theta h - \pi_n - x\| \to 0$$
uniformly in $x$ on bounded subsets of $\mathbf{X}$.

### Appendix: Weak Convergence

**Theorem 3** (van der Vaart & Wellner, 1989): For $n = 1, 2, \ldots$ let $L_n$ be a distribution on a metric space $(\mathbf{X}, d)$ and $g_n$ a function from $\mathbf{X}$ into another metric space $\mathbf{Y}$. Suppose that $L_n$ converges weakly to a tight Borel distribution $L$ on $\mathbf{X}$ and:
$$g_n(x_n) \to g(x) \text{ whenever } x_n \to x \in \mathbf{X}_o \subset \mathbf{X}$$
where $\mathbf{X}_o$ is such that $L(\mathbf{X} \setminus \mathbf{X}_o) = 0$ and $g$ is continuous. Then $L_n \circ g_n^{-1}$ converges weakly to $L \circ g^{-1}$.

### Complete Reference List

1. Beran, R., Millar, P.W.: Stochastic estimation and testing. Ann. Stat. **15**, 1131-1154 (1987)
2. Beran, R., Srivastava, M.S.: Bootstrap tests and confidence regions for functions of a covariance matrix. Ann. Stat. **13**, 95-115 (1985), Correction: Ann. Stat. **15**, 470-471 (1987)
3. Bretagnolle, J.: Lois limites du bootstrap de certaines fonctionnelles. Ann. Inst. Henri Poincaré **19**, 281-296 (1983)
4. Eaton, M.L., Tyler, D.E.: On Wielandt's inequality and its application to the asymptotic distribution of the eigenvalues of a random symmetric matrix. Ann. Stat. **19**, 260-271 (1991)
5. Gill, R.D.: Non- and semi-parametric maximum likelihood estimators and the von Mises method. Scand. J. Stat. **16**, 97-128 (1989)
6. Hoffmann-Jørgensen, J.: Stochastic processes on Polish spaces. (unpublished, 1984)
7. Pollard, D.: The minimum distance method of testing. Metrika **27**, 43-70 (1980)
8. Reeds, J.A.: On the definition of von Mises functionals. Ph.D. dissertation, Harvard University, 1976
9. Vaart, A.W. van der, Wellner, J.A.: Prohorov and continuous mapping theorems in the Hoffmann-Jørgensen weak convergence theory, with applications to convolution and asymptotic minimax theorems. Preprint, 1989 Lecture Notes-Monograph Series, IMS, Hayward

## Tags
bootstrap, nondifferentiable functionals, Hadamard differentiability, directional derivatives, confidence sets, eigenvalues, minimum distance, rescaled bootstrap, test inversion

---
*Processed by Rachel | 2026-02-01*
*Image-based update 2026-02-02*
*Critical reference for SEMD Theorem 3 proof*
