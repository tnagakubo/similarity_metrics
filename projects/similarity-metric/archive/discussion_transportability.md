# Discussion: Causal Interpretation and Transportability

**Author**: Mike Ross
**Date**: 2026-02-03
**Status**: Draft

---

## 5.X Causal Interpretation: nABCD as a Transportability Metric

### The Transportability Problem

A fundamental challenge in multi-regional clinical trials is determining whether treatment effects observed in one region can be "transported" to another. This question is formalized in the causal inference literature through **transportability theory** (Pearl & Bareinboim, 2011; Bareinboim & Pearl, 2016).

Formally, let $S$ denote the source population (e.g., Region A) and $T$ denote the target population (e.g., Region B). The causal effect in the target population is transportable if:

$$P_T(Y | do(T=t)) = \sum_x P_S(Y | do(T=t), X=x) \cdot P_T(X=x)$$

where $X$ represents effect modifiers whose distributions may differ across populations.

### nABCD and the Transportability Barrier

When transportability holds, the difference in treatment effects between populations can be bounded:

$$|\tau_T - \tau_S| = \left| \int \tau(x) \, d(F_T(x) - F_S(x)) \right| \leq \|\tau\|_\infty \cdot W_1(F_S, F_T)$$

where:
- $\tau(x) = E[Y(1) - Y(0) | X = x]$ is the conditional average treatment effect (CATE)
- $\|\tau\|_\infty = \sup_x |\tau(x)|$ is the maximum effect modification
- $W_1(F_S, F_T)$ is the Wasserstein-1 distance between effect modifier distributions

**Key insight**: The Wasserstein distance provides an upper bound on potential treatment effect heterogeneity. Normalizing by scale (via IQR) yields nABCD:

$$\text{nABCD} = \frac{W_1(F_S, F_T)}{2 \cdot \text{IQR}_{pooled}}$$

### Interpretation for Regional Pooling

This causal framework provides a principled interpretation of nABCD thresholds:

| nABCD | Transportability Interpretation |
|-------|--------------------------------|
| < 0.05 | Minimal transportability barrier; effects highly portable |
| 0.05 - 0.15 | Small barrier; effects likely similar across regions |
| 0.15 - 0.30 | Moderate barrier; heterogeneity possible if X is strong modifier |
| > 0.30 | Large barrier; substantial heterogeneity possible |

### Conservative Nature of nABCD

Importantly, nABCD provides a **necessary but not sufficient** condition for treatment effect heterogeneity:

1. **Small nABCD → Small heterogeneity** (regardless of $\tau(x)$)
   - If effect modifier distributions are similar, treatment effects must be similar
   - This supports regional pooling

2. **Large nABCD → Heterogeneity possible** (depends on $\tau(x)$)
   - Different distributions create *potential* for heterogeneity
   - Actual heterogeneity depends on whether X truly modifies the effect
   - This warrants caution in pooling, but does not prove heterogeneity

This conservative property aligns with regulatory requirements: nABCD can provide **assurance** that pooling is safe (when small) but cannot prove that pooling is unsafe (when large).

### Connection to ICH E17

ICH E17 Section 2.2.5 states that regions may be pooled if subjects are "similar enough with respect to intrinsic and/or extrinsic factors relevant to the disease and/or drug."

Through the transportability lens, nABCD operationalizes "similar enough":
- It quantifies distributional similarity of potential effect modifiers
- It bounds the maximum impact of effect modification on regional heterogeneity
- It provides a scale-free, interpretable metric for regulatory decision-making

---

## References

Bareinboim, E., & Pearl, J. (2016). Causal inference and the data-fusion problem. *Proceedings of the National Academy of Sciences*, 113(27), 7345-7352. DOI: [10.1073/pnas.1510507113](https://doi.org/10.1073/pnas.1510507113)

Hernán, M. A., & VanderWeele, T. J. (2011). Compound treatments and transportability of causal inference. *Epidemiology*, 22(3), 368-377.

Pearl, J., & Bareinboim, E. (2011). Transportability of causal and statistical relations: A formal approach. *Proceedings of the AAAI Conference on Artificial Intelligence*, 25(1), 247-254.

Westreich, D., Edwards, J. K., Lesko, C. R., Stuart, E., & Cole, S. R. (2017). Transportability of trial results using inverse odds of sampling weights. *American Journal of Epidemiology*, 186(8), 1010-1014. DOI: [10.1093/aje/kwx164](https://doi.org/10.1093/aje/kwx164)

---

*Section drafted by Mike Ross | 2026-02-03*
