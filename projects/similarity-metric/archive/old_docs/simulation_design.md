# Simulation Design for SEMD Validation

## Objectives

1. Verify theoretical properties of SEMD
2. Establish practical thresholds for poolability
3. Compare SEMD performance with existing metrics

## Scenarios

### Scenario 1: BMI Distribution (Japan vs US)
- **Effect modifier**: Body weight / BMI
- **Region 1 (Japan)**: BMI ~ N(23.5, 3.5²)
- **Region 2 (US)**: BMI ~ N(29.1, 6.0²)
- **Effect modification function**: g(x) = β₁ * (x - 25) (weight-dependent PK)
- **True treatment effect**: HR = 0.7 in reference population

### Scenario 2: CYP2C19 Polymorphism
- **Effect modifier**: Metabolizer status (PM, IM, EM, UM)
- **Region 1 (Japan)**: PM=18%, IM=45%, EM=35%, UM=2%
- **Region 2 (Caucasian)**: PM=3%, IM=25%, EM=65%, UM=7%
- **Effect modification function**: g(category) = categorical effect
- **True treatment effect**: Varies by metabolizer status

### Scenario 3: No Effect Modification (Control)
- **Distributions differ** between regions
- **g(x) = 0** for all x
- **Expected**: SEMD = 0, pooled estimate unbiased

### Scenario 4: Identical Distributions (Control)
- **f₁ = f₂** (same distribution)
- **g(x) ≠ 0** (effect modification exists)
- **Expected**: SEMD = 0, pooled estimate unbiased

## Metrics to Compute

For each scenario:
1. **True SEMD** (analytical)
2. **Estimated SEMD** (from simulated data)
3. **Pooled treatment effect estimate** (combined regions)
4. **Bias** = E[pooled estimate] - true effect
5. **Coverage probability** of 95% CI
6. **Type I error / Power** for hypothesis test

## Sample Sizes

- Region 1: n₁ = 200, 500, 1000
- Region 2: n₂ = 200, 500, 1000
- Replications: 1000 per scenario

## Comparator Metrics

- Kullback-Leibler divergence
- Wasserstein distance (p=1, p=2)
- Total variation distance
- Overlap coefficient

## Implementation

- Language: R
- Packages: tidyverse, survival, ggplot2
- Reproducibility: Set seed, document all parameters

## TODO
- [ ] Finalize parameter values
- [ ] Write R simulation functions
- [ ] Create visualization templates
- [ ] Set up parallel computing

---
*Draft by Katrina | Last updated: 2026-02-01*
