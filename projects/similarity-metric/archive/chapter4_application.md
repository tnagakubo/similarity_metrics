# Chapter 4: Application

**Author**: Katrina Bennett
**Date**: 2026-02-05
**Target**: Statistics in Medicine
**Word Count Target**: 800-1,000 words

---

## 4.1 Motivating Example

We illustrate the application of nABCD using a hypothetical multi-regional clinical trial in type 2 diabetes. The trial enrolled patients from three regions: Japan (n = 150), United States (n = 200), and European Union (n = 180). The primary endpoint was change in HbA1c at 24 weeks.

Based on prior literature and regulatory guidance, three baseline covariates were identified as potential effect modifiers: age, body mass index (BMI), and baseline HbA1c. The sponsor sought to determine whether regional pooling was appropriate for the primary analysis.

## 4.2 Data Description

**Table 1: Baseline Characteristics by Region**

| Characteristic | Japan (n=150) | US (n=200) | EU (n=180) |
|----------------|---------------|------------|------------|
| Age, mean (SD) | 62.3 (10.2) | 58.7 (11.5) | 60.1 (10.8) |
| BMI, mean (SD) | 24.8 (3.2) | 32.1 (5.8) | 29.4 (4.9) |
| Baseline HbA1c, mean (SD) | 7.6 (0.9) | 8.4 (1.3) | 8.1 (1.1) |
| Female, n (%) | 58 (38.7) | 92 (46.0) | 76 (42.2) |

Visual inspection of density plots suggested that BMI distributions differed substantially between Japan and the Western regions, while age distributions appeared more similar.

## 4.3 nABCD Analysis

We computed pairwise nABCD values with 95% bootstrap confidence intervals (B = 2,000) for each effect modifier.

**Table 2: Pairwise nABCD Values (95% CI)**

| Effect Modifier | Japan vs US | Japan vs EU | US vs EU |
|-----------------|-------------|-------------|----------|
| Age | 0.12 (0.07–0.18) | 0.08 (0.04–0.13) | 0.05 (0.02–0.09) |
| BMI | **0.51 (0.44–0.58)** | **0.38 (0.31–0.45)** | 0.18 (0.12–0.24) |
| Baseline HbA1c | 0.27 (0.20–0.34) | 0.19 (0.13–0.26) | 0.10 (0.05–0.16) |

### Interpretation

**Age**: All pairwise nABCD values fell below 0.15, indicating negligible to small differences. The 95% CI upper bounds were all below 0.20. Conclusion: Age distributions are sufficiently similar across all regions to support pooling.

**BMI**: The Japan-US comparison yielded nABCD = 0.51 (95% CI: 0.44–0.58), classified as a large difference. The Japan-EU comparison also showed a large difference (0.38). The US-EU comparison was moderate (0.18). Conclusion: BMI distributions differ substantially, particularly between Japan and Western regions.

**Baseline HbA1c**: Japan-US showed a medium-large difference (0.27), while other comparisons were small to moderate. Conclusion: Some heterogeneity exists, warranting sensitivity analysis.

## 4.4 Pooling Decision

Based on the nABCD analysis, we applied the decision framework from Section 2.6:

**Table 3: Pooling Recommendations by Effect Modifier**

| Effect Modifier | Max nABCD | Recommendation |
|-----------------|-----------|----------------|
| Age | 0.12 | Pool all regions |
| BMI | 0.51 | Separate analysis for Japan vs West |
| Baseline HbA1c | 0.27 | Pool with sensitivity analysis |

### Clinical Consideration

BMI is a well-established effect modifier for glucose-lowering agents, with evidence suggesting differential efficacy by obesity status. The large nABCD for BMI between Japan and Western regions reflects known epidemiological differences: mean BMI in Japanese diabetic populations is substantially lower than in Western populations.

Given the magnitude of BMI distributional differences and its clinical relevance as an effect modifier, the analysis plan was modified as follows:

1. **Primary analysis**: Pool US and EU (nABCD for BMI = 0.18, acceptable)
2. **Japan**: Analyzed separately with results reported descriptively
3. **Sensitivity analysis**: Pooled analysis across all three regions with BMI-stratified subgroup analysis
4. **Consistency assessment**: Treatment-by-region interaction test performed

## 4.5 Results Presentation

**Figure 1** (described): Cumulative distribution functions for BMI by region, with shaded areas representing the Wasserstein distance. The figure visually demonstrates the separation between Japan and Western distributions.

**Table 4: Summary for Regulatory Submission**

| Comparison | Effect Modifier | nABCD | 95% CI | Decision |
|------------|-----------------|-------|--------|----------|
| Japan vs US | Age | 0.12 | 0.07–0.18 | Similar |
| Japan vs US | BMI | 0.51 | 0.44–0.58 | Different |
| Japan vs US | HbA1c | 0.27 | 0.20–0.34 | Borderline |
| US vs EU | Age | 0.05 | 0.02–0.09 | Similar |
| US vs EU | BMI | 0.18 | 0.12–0.24 | Acceptable |
| US vs EU | HbA1c | 0.10 | 0.05–0.16 | Similar |

This table format enables transparent communication with regulatory agencies, documenting the quantitative basis for pooling decisions.

## 4.6 Discussion

The hypothetical example demonstrates several practical aspects of nABCD application:

1. **Multiple comparisons**: With three regions, pairwise comparisons identify which specific regional pairs drive heterogeneity

2. **Effect modifier prioritization**: Not all EMs showed equal heterogeneity; age was similar across regions while BMI was not

3. **Flexible pooling**: The analysis supported partial pooling (US + EU) rather than all-or-none decisions

4. **Regulatory transparency**: nABCD values with confidence intervals provide auditable documentation for pooling justification

5. **Integration with clinical judgment**: Statistical similarity (low nABCD) combined with clinical relevance of the EM guided the final decision

---

**Word count**: ~900 words

*Drafted by Katrina Bennett | 2026-02-05*
