# nABCD Independent Verification Notes

**Author**: Mike Ross
**Date**: 2026-02-03
**Purpose**: Independent verification of Tak's draft simulation values

---

## Summary

We performed independent Monte Carlo verification of the "true nABCD" values reported in Tak's draft. **A discrepancy was found in scenario S05.**

---

## Verification Method

1. Generate n = 1,000,000 samples from each distribution
2. Compute W₁ using sorted sample differences: `mean(abs(sort(x) - sort(y)))`
3. Compute pooled IQR: `IQR(c(x, y))`
4. Compute nABCD = W₁ / (2 × IQR_pooled)

---

## Results

| Scenario | Description | Tak's Value | Our Value | Difference | Status |
|----------|-------------|-------------|-----------|------------|--------|
| S01 | Null (same) | 0 | 0.0007 | ~0 | ✅ Match |
| S03 | 0.2 SD shift | 0.074 | 0.073 | 0.001 | ✅ Match |
| S05 | 1.0 SD shift | 0.372 | 0.328 | **0.044** | ❌ Discrepancy |

---

## Analysis of S05 Discrepancy

### The Issue

For S05 (μ₁=50, σ₁=10 vs μ₂=60, σ₂=10):

- **W₁ (Monte Carlo)**: 9.98
- **Pooled IQR**: 15.23
- **nABCD**: 9.98 / (2 × 15.23) = 0.328

### Why Pooled IQR is Larger

When we pool N(50,10) and N(60,10):
- The pooled distribution is a **mixture**
- The mixture has higher variance than individual components
- Specifically: Var(mixture) = σ² + (Δμ)²/4 when mixing 50-50

For σ=10 and Δμ=10:
- Individual IQR: 10 × 1.349 = 13.49
- Pooled IQR: √(100 + 25) × 1.349 ≈ 15.08 (theoretical), 15.23 (empirical)

### Hypothesis

Tak's draft value of 0.372 may have used:
- Individual IQR (13.49) instead of pooled IQR, OR
- A different IQR definition

Check: 9.98 / (2 × 13.49) = 0.370 ≈ 0.372 ✅

**This suggests Tak's code may use individual IQR rather than pooled IQR.**

---

## Implications

### If "pooled IQR" is the intended definition:

1. Tak's draft values need recalculation
2. The threshold interpretations may need adjustment
3. S05 coverage issues (0.69 at n=200) may be due to this discrepancy

### If "individual IQR" is intended:

1. The paper should clarify which IQR is used
2. The formula should be explicit: $\text{nABCD} = \frac{W_1}{2 \times \text{IQR}_{\text{individual}}}$
3. Rationale for this choice should be provided

---

## Resolution: Individual IQR Identified

**Additional verification confirms**: Tak's draft uses **individual IQR average**, not pooled IQR.

| Scenario | Tak | Pooled IQR | Individual IQR | Match |
|----------|-----|------------|----------------|-------|
| S01 | 0.000 | 0.001 | 0.001 | Both ~0 |
| S03 | 0.074 | 0.073 | **0.074** | Individual ✅ |
| S05 | 0.372 | 0.328 | **0.370** | Individual ✅ |
| S07 | 0.111 | 0.122 | **0.118** | Individual ≈ ✅ |

**Definition discrepancy**: The draft states "pooled IQR" but implementation appears to use individual IQR average.

---

## Code Review Results (2026-02-03 02:45)

**Tak shared simulation code**: `/mnt/c/Users/hrd13/Documents/Gak/0 Study/800Claude/20260130_SUITS/projects/ich-e17-pooling/work/code/R/nabcd.R`

### Key Finding: Implementation vs True Values Mismatch

**Implementation (`nabcd.R`)** uses **pooled IQR**:
```r
compute_iqr_pooled <- function(x, y) {
  IQR(c(x, y))  # Pooled IQR ✅
}
```

**But `true_nabcd` values are hardcoded** and appear to have been calculated with **individual IQR**:

| Scenario | Hardcoded true | MC (Pooled) | MC (Individual) | Match |
|----------|----------------|-------------|-----------------|-------|
| S03 | 0.074 | 0.073 | **0.074** | Individual |
| S05 | 0.372 | 0.328 | **0.370** | Individual |

### Implications

1. **S05 negative bias (-0.044)** is NOT a property of the estimator, but rather a **definition mismatch**
2. **S05 coverage (0.69)** is low because the "true value" is wrong, not because the CI is miscalibrated
3. All simulation metrics (bias, coverage) need **recalculation** with consistent true values

### Corrected True Values (Pooled IQR)

| Scenario | Old true | New true (Pooled) | Difference |
|----------|----------|-------------------|------------|
| S01 | 0.000 | ~0.000 | — |
| S03 | 0.074 | **0.073** | -0.001 |
| S04 | 0.186 | ~0.186 | ~0 |
| S05 | 0.372 | **0.328** | **-0.044** |
| S06 | 0.148 | TBD | — |

---

## Design Document Review (2026-02-03 02:55)

**Tak shared**: `simulation_design_v1.md` (authored by Louis Litt)

### Smoking Gun: Appendix B

The design document contains the "true nABCD" calculations:

```
| S05 | N(50,100) | N(60,100) | W₁=10.000 | IQR(pooled)=13.49 | nABCD=0.372 |
```

**The Error:**
- Document says "IQR (pooled)" but uses **13.49**
- 13.49 = IQR of N(μ, σ=10) = 10 × 1.349 (individual IQR!)
- True pooled IQR for mixture of N(50,10) and N(60,10) = **~15.08**

**Calculation Verification:**
- Document: 10 / (2 × 13.49) = 0.371 ≈ **0.372** ✅ matches
- Correct: 10 / (2 × 15.08) = **0.332** (matches our Monte Carlo)

### Additional Error: Appendix A

```
A.2 Normal Distributions (Different Variance)
W₁(X, Y) = √[(μ₁-μ₂)² + (σ₁-σ₂)²]
```

**This is the W₂ (Wasserstein-2) formula, NOT W₁!**
W₁ does not have a closed form for general normal distributions.

---

## Summary of Issues Found

| Issue | Location | Severity | Impact |
|-------|----------|----------|--------|
| IQR terminology confusion | Appendix B | **Critical** | All true values wrong |
| W₁ vs W₂ formula error | Appendix A | Medium | Theoretical inconsistency |
| Negative bias claim | Results | **Critical** | False conclusion |
| Undercoverage at S05 | Results | **Critical** | False conclusion |

---

## Corrected Simulation Interpretation

If true nABCD values are recalculated with proper pooled IQR:

| Scenario | Old true | New true | Old bias | New bias |
|----------|----------|----------|----------|----------|
| S05 | 0.372 | **0.328** | -0.044 | **~0** |

The estimator is likely **unbiased** and bootstrap CI achieves **nominal coverage**.

---

## Remaining Questions for Tak

1. ~~What IQR definition does your simulation code use?~~ **ANSWERED: Pooled IQR (correct)**
2. ~~Is "pooled IQR" in the text a typo?~~ **ANSWERED: Design doc error**
3. ~~How were the hardcoded `true_nabcd` values calculated?~~ **ANSWERED: Used individual IQR 13.49, mislabeled as "pooled"**
4. **NEW**: Who wrote Appendix B? Was it pre-existing before Louis's review?
5. **NEW**: Should we correct and re-run, or document as lessons learned?

---

## R Code Used

```r
set.seed(42)
n_large <- 1e6

# S05: 1.0 SD shift
x <- rnorm(n_large, 50, 10)
y <- rnorm(n_large, 60, 10)

W1 <- mean(abs(sort(x) - sort(y)))
IQR_pooled <- IQR(c(x, y))
IQR_individual <- (IQR(x) + IQR(y)) / 2

cat("W1:", W1, "\n")
cat("IQR (pooled):", IQR_pooled, "\n")
cat("IQR (individual avg):", IQR_individual, "\n")
cat("nABCD (pooled):", W1 / (2 * IQR_pooled), "\n")
cat("nABCD (individual):", W1 / (2 * IQR_individual), "\n")
```

---

*Notes prepared by Mike Ross | 2026-02-03*
