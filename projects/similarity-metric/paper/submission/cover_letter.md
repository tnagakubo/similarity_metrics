# Cover Letter

---

[Date]

**Editor-in-Chief**
Statistics in Medicine
Wiley

---

**Re: Submission of Original Article**
**Title: Quantifying Effect Modifier Similarity for Regional Pooling in Multi-Regional Clinical Trials**

---

Dear Editor,

We are pleased to submit our manuscript entitled "Quantifying Effect Modifier Similarity for Regional Pooling in Multi-Regional Clinical Trials" for consideration as an Original Article in *Statistics in Medicine*.

## Why Statistics in Medicine?

This manuscript addresses a methodological gap at the intersection of biostatistics and regulatory science—a core focus of your journal. The ICH E17 guideline recommends regional pooling in multi-regional clinical trials based on similarity of effect modifier distributions, yet provides no quantitative methodology. *Statistics in Medicine* has a strong tradition of publishing methods that bridge statistical theory and regulatory practice, making it the ideal venue for this work.

## Summary of Contributions

We develop and validate nABCD (normalized Area Between Cumulative Distributions), a planning-stage dissimilarity index for comparing effect modifier distributions across regions. Our key contributions include:

1. **A principled dissimilarity index** based on the Wasserstein-1 distance, capturing full distributional differences (location, scale, and shape) that are missed by the standardized mean difference

2. **Scale-free estimation** through IQR normalization with percentile bootstrap confidence intervals, enabling comparison across effect modifiers measured on different scales

3. **Clinical calibration framework** connecting distributional differences to potential treatment effect heterogeneity ($\Delta_{\max}$) through the Kantorovich–Rubinstein duality, with sensitivity analysis over the CATE sensitivity parameter

4. **Data-source flexibility**: Because nABCD requires only baseline EM distributions, it can be computed from any representative population data source—prior trials, disease registries, electronic health records, or real-world evidence databases

5. **Comprehensive validation** through simulation studies (eight scenarios) and application to two publicly available stroke trial datasets (IST-1, 31 countries; IST-3, 8 countries), demonstrating both EM-unknown and EM-identified planning scenarios

## Relevance and Timeliness

With the increasing globalization of clinical trials, regulatory agencies worldwide are implementing ICH E17. Recent publications from both the China NMPA (Song et al. 2025) and the broader regulatory community (Long et al. 2025) have highlighted the lack of quantitative tools for operationalizing pooling recommendations. Our framework provides this missing tool, with the practical advantage that it can leverage the growing availability of real-world evidence databases for MRCT planning. Open-source R code is provided to facilitate immediate adoption.

## Statements

- This manuscript has not been published previously and is not under consideration elsewhere
- All authors have approved the submitted version
- The authors declare no conflicts of interest
- [Funding statement if applicable]

We believe this work will be of significant interest to your readership of biostatisticians, clinical trialists, and regulatory scientists. We look forward to your consideration.

Sincerely,

[Corresponding Author Name]
[Title, Affiliation]
[Email]

---

*Cover letter for Statistics in Medicine submission*
