# Literature Review: Key Papers

## Category 1: ICH E17 Guidelines

### 1. ICH E17 Guideline (2017)
**Title**: General Principles for Planning and Design of Multi-Regional Clinical Trials
**Source**: ICH Harmonised Guideline
**Key points**:
- Defines intrinsic/extrinsic ethnic factors
- Requires prospective identification of effect modifiers
- Framework for regional consistency evaluation
**Relevance**: Primary regulatory context for our work

### 2. Tanaka et al. (2012)
**Title**: [To be filled - ICH E5 implementation]
**Key points**: Historical context from ICH E5 to E17
**Relevance**: Evolution of MRCT guidance

## Category 2: Distribution Similarity Metrics

### 3. Kullback & Leibler (1951)
**Title**: On Information and Sufficiency
**Source**: Annals of Mathematical Statistics
**Key points**: KL divergence definition, asymmetry
**Relevance**: Baseline comparator metric

### 4. Villani (2008)
**Title**: Optimal Transport: Old and New
**Key points**: Wasserstein distance, Earth Mover's Distance
**Relevance**: Transport-based similarity metric

### 5. Overlap Coefficient Literature
**Title**: [To be identified]
**Key points**: Bhattacharyya coefficient, overlap measures
**Relevance**: Overlap-based comparator

## Category 3: MRCT Statistical Methods

### 6. Chen et al. (2012)
**Title**: Consistency in MRCT
**Source**: Statistics in Medicine
**Key points**: Regional consistency evaluation methods
**Relevance**: Current statistical approaches

### 7. Quan et al. (2017)
**Title**: Sample Size for MRCT
**Key points**: Regional sample size allocation
**Relevance**: Planning phase considerations

### 8. Ikeda & Bretz (2022)
**Title**: [To be confirmed]
**Key points**: Recent MRCT methodology
**Relevance**: State of the art

## Category 4: Bootstrap & Asymptotic Theory (URGENT - for Theorem 3)

### 9. Bickel & Freedman (1981) ✅ OBTAINED
**Title**: Some Asymptotic Theory for the Bootstrap
**Source**: Annals of Statistics, 9(6), 1196-1217
**DOI**: [10.1214/aos/1176345637](https://doi.org/10.1214/aos/1176345637)
**Summary**: See `knowledge/summaries/Bickel_Freedman_1981.md`
**Key points**:
- Establishes conditions for bootstrap consistency
- Covers empirical distribution and smooth functionals
- Section 3: von Mises functionals (Theorem 3.1)
- Section 6: Counter-examples when bootstrap fails
**Relevance**: **Critical for Theorem 3 proof** - justifies bootstrap for SEMD

### 10. Dümbgen (1993) ✅ OBTAINED
**Title**: On nondifferentiable functions and the bootstrap
**Source**: Probability Theory and Related Fields, 95, 125-140
**DOI**: [10.1007/BF01197342](https://doi.org/10.1007/BF01197342)
**Summary**: See `knowledge/summaries/Dumbgen_1993.md`
**Key points**:
- Naive bootstrap fails for non-smooth functionals → converges to random limit
- Rescaled bootstrap: subsample $m$ with $m/n \to 0$ (Proposition 2)
- Directional Hadamard differentiability condition (B2)
- Test inversion method for robust confidence sets (Section 3)
- Example 2.2: Minimum distance functionals (related to SEMD)
**Relevance**: **Critical** - addresses non-smoothness of |f1-f2|, justifies Assumption A4

### 11. van der Vaart & Wellner (1996) 🔴 NEED PDF
**Title**: Weak Convergence and Empirical Processes
**Source**: Springer (Chapter 3.9 specifically)
**Key points**:
- Functional delta method
- Hadamard differentiability
- Bootstrap for functionals
**Relevance**: **Critical** - Theorem 3.9.11 for bootstrap consistency

### 12. Bickel & Rosenblatt (1973) ✅ OBTAINED
**Title**: On some global measures of the deviations of density function estimates
**Source**: Annals of Statistics, 1(6), 1071-1095
**DOI**: [10.1214/aos/1176342558](https://doi.org/10.1214/aos/1176342558)
**Summary**: See `knowledge/summaries/Bickel_Rosenblatt_1973.md`
**Key points**:
- Uniform convergence of KDE: $\sup_x |\hat{f}(x) - f(x)| = O_p(\sqrt{\log n / (nh)})$
- Theorem 4.1: Integrated squared error asymptotics
- Bandwidth requirement: $h = n^{-\delta}$, $1/5 < \delta < 1/2$
**Relevance**: **Important** - foundation for Theorem 1 (asymptotic normality)

### 13. Devroye & Győrfi (1985) 🟡 NEED PDF
**Title**: Nonparametric Density Estimation: The L1 View
**Source**: Wiley
**Key points**:
- L1 density estimation theory
- Total variation distance estimation
- Convergence rates
**Relevance**: **Important** - SEMD is a weighted L1 functional

### 14. Hall (1992) 🟢 Nice to have
**Title**: The Bootstrap and Edgeworth Expansion
**Source**: Springer
**Key points**:
- Higher-order accuracy of bootstrap
- Edgeworth corrections
- Refined bootstrap theory
**Relevance**: Could improve CI accuracy (future work)

---

## Category 5: Effect Modification

### 15. VanderWeele & Knol (2014)
**Title**: Interpretation of Subgroup Analyses
**Source**: Epidemiology
**Key points**: Effect modification vs interaction
**Relevance**: Conceptual foundation

### 16. Regulatory Guidance on Subgroups
**Title**: [EMA/FDA guidelines]
**Key points**: Pre-specification requirements
**Relevance**: Regulatory expectations

---

## Summary: PDF Status

| Priority | Count | Status |
|----------|-------|--------|
| ✅ OBTAINED | 3 | Bickel&Freedman (1981), Bickel&Rosenblatt (1973), Dümbgen (1993) |
| 🔴 HIGH (Theorem 3) | 1 | NEED PDF - vdVaart&Wellner |
| 🟡 MEDIUM | 1 | NEED PDF - Devroye&Győrfi |
| 🟢 LOW | 1 | Nice to have - Hall 1992 |
| ✅ Available | 4+ | ICH E17, Chen et al., etc. |

## TODO
- [x] Categorize papers by relevance
- [x] Identify missing PDFs
- [x] Prioritize for Theorem proofs
- [x] Process Bickel & Freedman (1981) PDF
- [x] Process Bickel & Rosenblatt (1973) PDF
- [x] Process Dümbgen (1993) PDF ← **NEW**
- [ ] **REQUEST 2 PDFs from Tak** (vdVaart&Wellner, Devroye&Győrfi)
- [ ] Complete full citations for all papers
- [x] Write detailed summaries - 3 completed (see `knowledge/summaries/`)

---
*Draft by Rachel | Last updated: 2026-02-01 03:00*
