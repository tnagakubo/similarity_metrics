# Appendix B: True nABCD Values (CORRECTED)

**Corrected by**: Louis Litt
**Date**: 2026-02-03
**Method**: Monte Carlo with 10⁷ samples, **Pooled IQR** (correct definition)

---

## Critical Correction Notice

The original Appendix B contained an error: it labeled IQR values as "pooled" but actually used **individual IQR** (the average of each group's IQR).

For scenarios with location shifts, pooled IQR is larger than individual IQR because the mixture distribution has higher variance. This led to **overestimated true nABCD values** in the original document.

---

## Corrected True nABCD Values

| Scenario | Region A | Region B | W₁ | IQR (pooled) | nABCD (CORRECT) | Old Value | Error |
|----------|----------|----------|-----|--------------|-----------------|-----------|-------|
| S01 | N(50, 10²) | N(50, 10²) | ~0 | 13.49 | **0.000** | 0.000 | — |
| S02 | Γ(25, 0.5) | Γ(25, 0.5) | ~0 | 13.39 | **0.000** | 0.000 | — |
| S03 | N(50, 10²) | N(52, 10²) | 2.00 | 13.54 | **0.074** | 0.074 | ~0 |
| S04 | N(50, 10²) | N(55, 10²) | 5.00 | 13.93 | **0.180** | 0.186 | -0.006 |
| S05 | N(50, 10²) | N(60, 10²) | 10.00 | **15.25** | **0.327** | 0.372 | **-0.045** |
| S06 | N(50, 10²) | N(50, 15²) | 4.01 | **16.36** | **0.123** | 0.148 | **-0.025** |
| S08 | N(50, 10²) | Γ(25, 0.5) | 0.65 | 13.45 | **0.024** | 0.067 | **-0.043** |

---

## Why Pooled IQR Differs from Individual IQR

### For Location Shift (S05 example)

When pooling N(50, 10) and N(60, 10):

**Individual IQR approach** (WRONG for true value):
- IQR(N(50,10)) = 13.49
- IQR(N(60,10)) = 13.49
- Average = 13.49

**Pooled IQR approach** (CORRECT):
- Pooled distribution is a mixture: 0.5·N(50,10) + 0.5·N(60,10)
- Mixture variance = σ² + (Δμ)²/4 = 100 + 25 = 125
- Mixture SD = 11.18
- Pooled IQR ≈ 15.08

### Impact on nABCD

- W₁ = 10 (same in both cases)
- nABCD (individual) = 10 / (2 × 13.49) = 0.371
- nABCD (pooled) = 10 / (2 × 15.25) = 0.328

**Difference = 0.043**, which matches the reported "negative bias" in simulation.

---

## Implications for Simulation Results

### S05 Re-interpretation

| n | Mean Est | Old True | Old Bias | **New True** | **New Bias** |
|---|----------|----------|----------|--------------|--------------|
| 50 | 0.331 | 0.372 | -0.041 | **0.327** | **+0.004** |
| 100 | 0.329 | 0.372 | -0.043 | **0.327** | **+0.002** |
| 200 | 0.328 | 0.372 | -0.044 | **0.327** | **+0.001** |

**Conclusion**: The estimator is essentially **unbiased**.

### Coverage Re-interpretation

The low coverage at S05 (0.69 at n=200) was because the CI correctly concentrated around the true value (~0.328), but we evaluated coverage against the wrong value (0.372).

With corrected true value, coverage is expected to be **nominal (~0.95)**.

---

## Errata for Original Appendix A

The original Appendix A stated:

> A.2 Normal Distributions (Different Variance)
> W₁(X, Y) = √[(μ₁-μ₂)² + (σ₁-σ₂)²]

This is **incorrect**. This formula is for **W₂ (Wasserstein-2 distance)**, not W₁.

The Wasserstein-1 distance for normal distributions does not have a simple closed form when variances differ. Use Monte Carlo or numerical integration.

---

**Corrected by Louis Litt | 2026-02-03**

*"The first draft had errors. This draft fixes them. That's how science works."*
