# Knowledge Base Index

## Directories

| Directory | Contents |
|-----------|----------|
| pdfs/ | Original PDF files |
| summaries/ | Paper summaries |
| methods/ | Mathematical methods |
| quotes/ | Quotable passages |

## Commands

| Command | Description |
|---------|-------------|
| `/process-paper` | Add single PDF |
| `/process-papers` | Batch add PDFs |
| `/search-kb` | Search knowledge base |
| `/read` | Read paper at level |
| `/cite` | Get citation |
| `/request-paper` | Request from Tak |
| `/list-requests` | Show pending requests |

---

## Papers Processed

| # | Paper | DOI | PDF | Summary | Category |
|---|-------|-----|-----|---------|----------|
| 1 | Bickel & Freedman (1981) "Some Asymptotic Theory for the Bootstrap" | [10.1214/aos/1176345637](https://doi.org/10.1214/aos/1176345637) | ✅ | ✅ | Bootstrap Theory |
| 2 | Bickel & Rosenblatt (1973) "On Some Global Measures of the Deviations of Density Function Estimates" | [10.1214/aos/1176342558](https://doi.org/10.1214/aos/1176342558) | ✅ | ✅ | KDE Asymptotics |
| 3 | Dümbgen (1993) "On nondifferentiable functions and the bootstrap" | [10.1007/BF01197342](https://doi.org/10.1007/BF01197342) | ✅ | ✅ | Non-smooth Bootstrap |
| 4 | Devroye & Győrfi (1985) *Nonparametric Density Estimation: The L₁ View* Ch.3 | ISBN: 0-471-81646-9 | ✅ | ✅ | L₁ Consistency |
| 5 | Devroye & Győrfi (1985) *Nonparametric Density Estimation: The L₁ View* Ch.4 | ISBN: 0-471-81646-9 | ✅ | ✅ | Lower Bounds |
| 6 | Devroye & Győrfi (1985) *Nonparametric Density Estimation: The L₁ View* Ch.5 | ISBN: 0-471-81646-9 | ✅ | ✅ | Rates of Convergence |
| 7 | ICH E17 (2017) "General Principles for Planning and Design of Multi-Regional Clinical Trials" | [ICH](https://database.ich.org/sites/default/files/E17_Guideline.pdf) | ✅ | ✅ | Regulatory/MRCT |
| 8 | VanderWeele & Knol (2014) "A Tutorial on Interaction" | [10.1515/em-2013-0005](https://doi.org/10.1515/em-2013-0005) | ✅ | ✅ | Effect Modification |
| 9 | Quan et al. (2010) "Assessment of Consistency of Treatment Effects in MRCTs" | [10.1177/009286150904400509](https://doi.org/10.1177/009286150904400509) | ✅ | ✅ | Regional Consistency |
| 10 | Ikeda & Bretz (2010) "Sample size and proportion of Japanese patients in multi-regional trials" | [10.1002/pst.455](https://doi.org/10.1002/pst.455) | ✅ | ✅ | Sample Size/MRCT |
| 11 | Panaretos & Zemel (2019) "Statistical Aspects of Wasserstein Distances" | [10.1146/annurev-statistics-030718-104938](https://doi.org/10.1146/annurev-statistics-030718-104938) | ✅ | ✅ | Wasserstein Theory |
| 12 | del Barrio, Giné & Matrán (1999) "Central Limit Theorems for Wasserstein Distance" | [10.1214/aop/1022677394](https://doi.org/10.1214/aop/1022677394) | ✅ | ✅ | Wasserstein CLT |
| 13 | Sommerfeld & Munk (2018) "Inference for Empirical Wasserstein Distances on Finite Spaces" | [10.1111/rssb.12236](https://doi.org/10.1111/rssb.12236) | ✅ | ✅ | Wasserstein Bootstrap |
| 14 | Rousseeuw & Croux (1993) "Alternatives to the Median Absolute Deviation" | [10.1080/01621459.1993.10476408](https://doi.org/10.1080/01621459.1993.10476408) | ✅ | ✅ | Robust Scale Estimation |
| 15 | Song et al. (2025) "Basic Considerations for Data Pooling Strategy in MRCTs" | [10.1007/s43441-025-00744-8](https://doi.org/10.1007/s43441-025-00744-8) | ✅ | ✅ | MRCT Pooling/China |

## Papers Pending

| # | Paper | DOI | Status |
|---|-------|-----|--------|
| 8 | van der Vaart & Wellner (1996) *Weak Convergence and Empirical Processes* | ISBN: 978-0387946405 | Not needed (covered by existing refs) |
| 9 | Hall (1992) *The Bootstrap and Edgeworth Expansion* | ISBN: 978-0412035203 | Nice to have |
| ~~10~~ | ~~VanderWeele & Knol (2014)~~ | ✅ Processed | ~~Recommended~~ |
| ~~11~~ | ~~Quan et al. (2010)~~ | ✅ Processed | ~~Recommended~~ |

---

## Summary Files

| File | Paper | Key Topics |
|------|-------|------------|
| `summaries/Bickel_Freedman_1981.md` | Bickel & Freedman (1981) | Bootstrap theory, von Mises functionals, Theorem 2.1, 2.2, 3.1 |
| `summaries/Bickel_Rosenblatt_1973.md` | Bickel & Rosenblatt (1973) | KDE uniform convergence, confidence bands, quadratic functionals |
| `summaries/Dumbgen_1993.md` | Dümbgen (1993) | Non-differentiable functionals, directional Hadamard derivatives, rescaled bootstrap |
| `summaries/Devroye_1985_ch03.md` | Devroye & Győrfi (1985) Ch.3 | L₁ consistency, kernel/histogram estimates, Theorem 1 (equivalence of convergence modes) |
| `summaries/Devroye_1985_ch04.md` | Devroye & Győrfi (1985) Ch.4 | Lower bounds, minimax rates, Assouad's lemma, slow convergence theorem |
| `summaries/Devroye_1985_ch05.md` | Devroye & Győrfi (1985) Ch.5 | Rates n⁻²/⁵ for kernel, exact asymptotics, optimal bandwidth, bias-variance trade-off |
| `summaries/ICH_E17_2017.md` | ICH E17 (2017) | MRCT framework, regional consistency, pooling strategy, intrinsic/extrinsic factors, effect modifiers |
| `summaries/VanderWeele_Knol_2014.md` | VanderWeele & Knol (2014) | Effect modification, additive/multiplicative interaction, RERI, synergy index, qualitative interaction |
| `summaries/Quan_2010.md` | Quan et al. (2010) | 5 definitions of consistency, sample size formulas, MRCT assessment, regional treatment effects |
| `summaries/Ikeda_Bretz_2010.md` | Ikeda & Bretz (2010) | Japanese patient proportion, Method 1 critique, new hypothesis test approach, bivariate normal |
| `summaries/Panaretos_2019.md` | Panaretos & Zemel (2019) | Wasserstein distance review, optimal transport, W₁ formula, statistical inference |
| `summaries/Barrio_1999.md` | del Barrio et al. (1999) | CLT for Wasserstein distance, ABCD, Brownian bridge limit, moment conditions |
| `summaries/Sommerfeld_2018.md` | Sommerfeld & Munk (2018) | Bootstrap for Wasserstein, directional Hadamard, two-sample inference |
| `summaries/Rousseeuw_1993.md` | Rousseeuw & Croux (1993) | MAD alternatives, Sn/Qn estimators, robust scale, IQR comparison |
| `summaries/Song_2025.md` | Song et al. (2025) | China NMPA perspective, pooling flowchart, East Asia pooling, EM identification |

---

## Key Results by Topic

### Bootstrap Consistency (for SEMD Theorem 3)
- **Bickel & Freedman (1981) Section 3**: Von Mises functionals, smooth statistical functionals
- **Dümbgen (1993)**: Non-differentiable functionals, directional Hadamard differentiability
- **Key condition**: Gâteaux/Hadamard differentiability of the functional
- **Counter-examples (Section 6)**: Bootstrap fails when uniformity conditions fail
- **Rescaled bootstrap**: Works for non-smooth functionals under constant parameter (Dümbgen Prop. 2)

### KDE Asymptotics (for SEMD Theorem 1)
- **Bickel & Rosenblatt (1973) Corollary**: Uniform convergence rate
- **Key result**: $\sup_x |\hat{f}(x) - f(x)| = O_p(\sqrt{\log n / (nh)})$

### L₁ Consistency (for SEMD Theorem 1)
- **Devroye & Győrfi (1985) Ch.3 Theorem 1**: Necessary and sufficient conditions
- **Key result**: $\int|\hat{f} - f| \to 0$ iff $h \to 0$ and $nh^d \to \infty$
- **Exponential convergence**: $P(J_n \geq \varepsilon) \leq e^{-rn\varepsilon^2}$

### Lower Bounds (for understanding limitations)
- **Devroye & Győrfi (1985) Ch.4 Theorem 1**: Slow convergence theorem
- **Key result**: For ANY estimate, some densities make convergence arbitrarily slow
- **Minimax rate**: $n^{-s/(2s+1)}$ for s-times differentiable densities

### Rates of Convergence (for SEMD Theorem 1)
- **Devroye & Győrfi (1985) Ch.5 Theorems 1-2**: Exact asymptotics for $E(J_n)$
- **Key result**: $E(J_n) = O(n^{-2/5})$ for kernel with optimal $h$
- **Optimal bandwidth**: $h_{opt} \propto n^{-1/5}$

### Asymptotic Variance (for SEMD Theorem 2)
- **Bickel & Rosenblatt (1973) Theorem 4.1**: Integrated squared error asymptotics
- **Key formula**: Variance involves $R(K) = \int K^2(u) du$

### Regulatory Framework (for SEMD Introduction & Motivation)
- **ICH E17 (2017) Section 2.2.1**: Effect modifiers = intrinsic/extrinsic factors causing regional variability
- **ICH E17 (2017) Section 2.2.5**: Pooling strategy must be justified by factor distribution similarity
- **Key quote**: "The pooling strategy should be justified based on the distribution of the intrinsic and extrinsic factors known to affect the treatment response"
- **Consistency definition**: "A lack of clinically relevant differences between treatment effects"

### Effect Modification Theory (for SEMD Conceptual Foundation)
- **VanderWeele & Knol (2014)**: Comprehensive tutorial on interaction/effect modification
- **Additive interaction**: $IC = p_{11} - p_{10} - p_{01} + p_{00}$
- **RERI**: $RERI_{RR} = RR_{11} - RR_{10} - RR_{01} + 1$
- **Key insight**: Interaction can be present on one scale but absent on another
- **Treatment targeting**: "identify subgroups in which the intervention is likely to have the largest effect"

### Regional Consistency Assessment (Complementary to SEMD)
- **Quan et al. (2010)**: 5 formal definitions of consistency
- **Definition 1**: $\hat{\delta}_i > \pi \hat{\delta}$ (regional effect > proportion of overall)
- **Definition 4**: No significant treatment-by-region interaction
- **Sample size formulas**: For each definition
- **Key insight**: Tests observed effect consistency; SEMD addresses *why* effects might differ
- **Connection**: Similar effect modifier distributions → Treatment effects more likely consistent

### Japanese Patient Sample Size (MHLW Context)
- **Ikeda & Bretz (2010)**: Analysis of MHLW "Basic Principles on Global Clinical Trials"
- **Method 1**: $D_J / D_{ALL} > \omega$ with 80% probability
- **New approach**: Hypothesis test with threshold $\phi$
- **Key formula**: $p \geq (z_{1-\phi} + z_{1-\gamma})^2 / (z_{1-\alpha} + z_{1-\beta})^2$
- **Practical result**: ~22-29% Japanese patients needed for 80% consistency probability
- **SEMD connection**: Provides pre-trial justification for assuming $\delta_J = \delta_{ALL}$

### Wasserstein Distance Theory (for nABCD Foundation)
- **Panaretos & Zemel (2019)**: Comprehensive review of statistical aspects
- **Key formula**: $W_1(F, G) = \int |F(x) - G(x)| dx$ = ABCD
- **del Barrio et al. (1999)**: CLT for Wasserstein distance
- **Limit distribution**: $\sqrt{n} W_1(F_n, F) \xrightarrow{d} \int_0^1 |B(t)| dQ(t)$ (NOT Gaussian)
- **Sommerfeld & Munk (2018)**: Bootstrap for Wasserstein
- **Key insight**: Naive bootstrap may fail; directional bootstrap needed for consistency
- **nABCD connection**: nABCD = $W_1(F, G) / (2 \cdot \text{IQR}_{pooled})$

### Robust Scale Estimation (for nABCD Normalization)
- **Rousseeuw & Croux (1993)**: MAD alternatives with higher efficiency
- **$Q_n$ estimator**: 50% breakdown, 82% efficiency (vs IQR: 25%, 37%)
- **Potential improvement**: $Q_n$-normalized nABCD for better small-sample performance
- **Trade-off**: IQR more interpretable, $Q_n$ more robust and efficient

### MRCT Pooling Practice (Regulatory Application)
- **Song et al. (2025)**: China NMPA implementation of ICH E17
- **Pooling flowchart**: Decision tree for regional vs subpopulation pooling
- **Gap identified**: Quantitative metric for "similar enough" - nABCD fills this!
- **East Asia context**: Japan-China-Korea pooling considerations

---

## Cross-References to SEMD Paper

| SEMD Section | Key Reference | Location in Reference |
|--------------|---------------|----------------------|
| Theorem 1 (Asymptotic Normality) | Bickel & Rosenblatt (1973) | Eq. 2.6-2.7, Proposition 2.1 |
| Theorem 2 (Asymptotic Variance) | Bickel & Rosenblatt (1973) | Theorem 4.1, Eq. 4.9-4.10 |
| Theorem 3 (Bootstrap Consistency) | Bickel & Freedman (1981) | Section 3, Theorem 3.1 |
| Theorem 3 (Non-smooth case) | Dümbgen (1993) | Proposition 2, Condition B2 |
| Assumption A4 (Non-degeneracy) | Bickel & Freedman (1981), Dümbgen (1993) | Section 6; Example 2.1 |
| Introduction (Regulatory motivation) | ICH E17 (2017) | Section 2.2.1, 2.2.5, Glossary |
| Pooling justification | ICH E17 (2017) | Section 2.2.5 "Pooled Regions and Pooled Subpopulations" |

---

## Methods

### Uniform Convergence of KDE
See: `summaries/Bickel_Rosenblatt_1973.md`
- Rate: $O_p((\log n / nh)^{1/2})$
- Requires: $h \to 0$, $nh \to \infty$

### Bootstrap for Functionals
See: `summaries/Bickel_Freedman_1981.md`
- Applicable to Gâteaux differentiable functionals
- Need uniformity in neighborhoods

---

## Tags

| Tag | Papers |
|-----|--------|
| #bootstrap | Bickel & Freedman (1981), Dümbgen (1993) |
| #kde | Bickel & Rosenblatt (1973), Devroye & Győrfi (1985) Ch.3, Ch.5 |
| #asymptotics | All |
| #functional | Bickel & Freedman (1981), Dümbgen (1993) |
| #uniform-convergence | Bickel & Rosenblatt (1973) |
| #non-differentiable | Dümbgen (1993) |
| #hadamard | Dümbgen (1993) |
| #L1-convergence | Devroye & Győrfi (1985) Ch.3, Ch.4, Ch.5 |
| #lower-bounds | Devroye & Győrfi (1985) Ch.4 |
| #rates | Devroye & Győrfi (1985) Ch.4, Ch.5 |
| #minimax | Devroye & Győrfi (1985) Ch.4 |
| #optimal-bandwidth | Devroye & Győrfi (1985) Ch.5 |
| #MRCT | ICH E17 (2017) |
| #regional-consistency | ICH E17 (2017) |
| #effect-modifiers | ICH E17 (2017) |
| #pooling-strategy | ICH E17 (2017) |
| #intrinsic-factors | ICH E17 (2017) |
| #extrinsic-factors | ICH E17 (2017) |
| #regulatory | ICH E17 (2017) |
| #effect-modification | VanderWeele & Knol (2014) |
| #interaction | VanderWeele & Knol (2014) |
| #RERI | VanderWeele & Knol (2014) |
| #additive-interaction | VanderWeele & Knol (2014) |
| #multiplicative-interaction | VanderWeele & Knol (2014) |
| #qualitative-interaction | VanderWeele & Knol (2014) |
| #treatment-heterogeneity | VanderWeele & Knol (2014), ICH E17 (2017), Quan et al. (2010) |
| #regional-consistency | ICH E17 (2017), Quan et al. (2010) |
| #consistency-definition | Quan et al. (2010) |
| #sample-size | Quan et al. (2010), Ikeda & Bretz (2010) |
| #Japanese-patients | Ikeda & Bretz (2010) |
| #MHLW-guidance | Ikeda & Bretz (2010) |
| #bivariate-normal | Ikeda & Bretz (2010) |
| #wasserstein | Panaretos & Zemel (2019), del Barrio et al. (1999), Sommerfeld & Munk (2018) |
| #optimal-transport | Panaretos & Zemel (2019) |
| #ABCD | del Barrio et al. (1999) |
| #nABCD | Panaretos & Zemel (2019), del Barrio et al. (1999), Sommerfeld & Munk (2018) |
| #CLT | del Barrio et al. (1999) |
| #directional-bootstrap | Sommerfeld & Munk (2018), Dümbgen (1993) |
| #robust-scale | Rousseeuw & Croux (1993) |
| #IQR | Rousseeuw & Croux (1993) |
| #Qn-estimator | Rousseeuw & Croux (1993) |
| #China-NMPA | Song et al. (2025) |
| #East-Asia-pooling | Song et al. (2025) |

---

## Methods Files

| File | Topic | Key Content |
|------|-------|-------------|
| `methods/wasserstein_distance.md` | Wasserstein/Optimal Transport Distance | Definition, 1D formula, asymptotic theory, R implementation |

---
*Last updated: 2026-02-02 23:30 | Maintained by Rachel*
