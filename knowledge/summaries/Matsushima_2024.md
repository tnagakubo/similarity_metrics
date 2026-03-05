# Matsushima et al. (2024) - Workshop Report: MRCT Case Studies with ICH E17

## Citation
Matsushima N, Otsuba Y, Aoi Y, Nakamura R, Kaneko S, Asakawa T, Matsusaka N, Watabe K, Komiyama O, Yamamoto H, Ando Y (2024) "Summary Report of a Public Workshop: Case Studies of Multi-Regional Clinical Trial Incorporating Concept of the ICH E17 Guideline" *Clinical Pharmacology & Therapeutics* 115(5):965-970
DOI: [10.1002/cpt.3163](https://doi.org/10.1002/cpt.3163)

## Summary

A public workshop was held by PMDA (Japan), JPMA, and industry stakeholders in 2022 to
deepen practical understanding of ICH E17 and promote effective implementation. This
mini-review summarizes case studies (presented by PMDA and by industry) examining how
effect modifiers were evaluated and how consistency of treatment effects was assessed in
MRCTs submitted for regulatory approval in Japan.

The paper proposes a **3-layer approach** for holistic consistency evaluation, which aligns
closely with ICH E17 principles:
- **Layer 1**: Evaluate consistency in the overall pooled population
- **Layer 2**: Identify effect modifiers via subgroup analyses; determine if they explain
  regional differences
- **Layer 3**: Evaluate benefit-risk balance for each country/region based on the local
  distribution of identified effect modifiers

## Key Contributions

1. **Operationalizes ICH E17 via 4 concrete case studies** (secukinumab, pertuzumab,
   palbociclib, blonanserin), each illustrating a different challenge in MRCT consistency
2. **3-layer approach** for systematic consistency evaluation — from population-level
   consistency → effect modifier identification → country-specific benefit-risk assessment
3. **5-dimensional consistency assessment framework**: biological plausibility, internal
   consistency, external consistency, clinical relevance, statistical uncertainty
4. **Regulatory perspective from PMDA**: emphasizes the need for predefined subgroup
   analyses and comprehensive CTD documentation of holistic consistency evaluations

## Case Studies Summary

### Case 1: Secukinumab (ASAS studies, axial spondyloarthritis)
- Approved in Japan 2020; 2 large Phase 3 studies (n≈3,000+, ~13 Japanese patients)
- Effect modifiers: CRP+/MRI- status, concomitant biologics use
- Japan inconsistency driven partly by imbalance in CRP+/MRI- participants
- After accounting for effect modifiers, ASAS40 response rates became consistent
- **Key lesson**: Regional imbalance in biomarker subgroups can explain apparent
  inconsistency; does NOT invalidate overall results

### Case 2: Pertuzumab (CLEOPATRA, HER2+ metastatic breast cancer)
- Approved Japan 2013; Phase 3, ~808 total, ~53 Japanese patients
- Effect modifiers: disease characteristics, prior treatment, tumor biology
- HR ≈ 0.69 in Japanese subpopulation vs. similar in overall
- Subgroup analyses confirmed consistent efficacy; no meaningful regional heterogeneity
- **Key lesson**: When disease biology is well-characterized, effect modifiers are
  biologically plausible and consistency is well-supported

### Case 3: Palbociclib (PALOMA-3, HR+/HER2− advanced breast cancer)
- NDA completed based on overall analysis + 2 additional Japanese-specific analyses
- ~521 total, ~35 Japanese patients; limited sample size, imbalance in stratification factors
- HR ≈ 0.62 (95% CI: 0.32–1.10) in Japan vs. overall HR ≈ 0.5
- **Key lesson**: Small Japanese subpopulation → high statistical uncertainty; holistic
  evaluation including biological plausibility and external consistency essential

### Case 4: Blonanserin transdermal patches (D4904020, schizophrenia)
- Phase 3, ~580 total; PANSS total score as primary endpoint
- Smaller effect in Japan than overall; region 2 showed different pattern
- After thorough review including scientific evidence and regional factors, the difference
  could not be attributed to identifiable effect modifiers
- **Key lesson**: Not all regional differences can be explained by effect modifiers; when
  no biological explanation exists, assessment requires careful clinical judgment

## Methods / Framework

### 3-Layer Approach
```
Layer 1: Overall population consistency
         ↓ (if inconsistency observed)
Layer 2: Subgroup analysis to identify effect modifiers
         → What factors explain the regional difference?
         → Are these factors distributed differently across regions?
         ↓ (effect modifiers identified or excluded)
Layer 3: Country/region-specific benefit-risk evaluation
         → Given local EM distribution, what is the expected treatment effect?
```

### 5 Dimensions of Consistency (Table 2)
| Dimension | Description |
|-----------|-------------|
| Biological plausibility | Is there a mechanistic reason for regional differences? |
| Internal consistency | Are subgroup results consistent within this trial? |
| External consistency | Are results consistent with prior trials / other populations? |
| Clinical relevance | Are observed differences clinically meaningful? |
| Statistical uncertainty | Is the precision adequate for the subgroup of interest? |

## Key Equations / Formulas
None (qualitative/regulatory workshop report)

## Key Quotes

> "The pooling strategy should be justified based on the distribution of the intrinsic and
> extrinsic factors known to affect the treatment response"

> "Therefore, the 3-layer approach, which first evaluates the results of the overall
> population, then searches for effect modifiers based on the results of subgroup analyses,
> and last evaluates benefit-risk balance in each country, is useful for consistency
> evaluation and discussing the benefit-risk balance in Japan and in other countries or
> regions."

> "When the factor is identified at the design stage, interpretation of the results from
> subgroup analysis based on the factors have greater confidence, and when the factor is not
> defined at the design stage, interpretation of the result requires careful attention."

> "Common Technical Documents (CTDs) of NDAs should include a holistic evaluation of
> consistency, including the interpretation of effect modifiers and details of the analyses
> conducted for consistency evaluation."

## Relevance to nABCD Paper

**This paper is directly relevant to our work as regulatory justification.**

1. **Identifies the quantification gap**: The 3-layer approach explicitly requires evaluating
   whether effect modifier (EM) *distributions* differ between regions (Layer 2→3 transition),
   but provides no quantitative tool for this. nABCD fills this gap.

2. **Validates the importance of EM distribution similarity**: "The pooling strategy should
   be justified based on the distribution of [...] factors known to affect treatment response"
   — our nABCD quantifies exactly this distributional similarity.

3. **Motivates pre-trial vs. post-hoc use**: The paper emphasizes predefined EM analysis;
   nABCD can be used pre-trial (design stage) to quantify expected EM distribution similarity.

4. **Provides clinical context for calibration**: The 4 case studies (especially Case 1,
   secukinumab) illustrate the clinical magnitudes of EM distribution differences that
   matter. These can inform Delta_max calibration.

5. **Japan-specific perspective**: Confirms PMDA's requirement for Japan-specific
   consistency evaluation, supporting the need for a metric that quantifies EM similarity
   for any target region.

## References in Paper (Selected)
- ICH E17 (2017) General Principles for MRCT
- Quan et al. (2010) Assessment of consistency in MRCTs — already in KB
- Baselga et al. (2012) CLEOPATRA trial (N Engl J Med 366:109-119)
- Turner et al. (2015) PALOMA-3 palbociclib trial

## Tags
#MRCT #ICH-E17 #effect-modifiers #regional-consistency #pooling-strategy
#PMDA #Japan #3-layer-approach #consistency-framework #case-studies
#secukinumab #pertuzumab #palbociclib #blonanserin
#benefit-risk #regulatory #quantification-gap
