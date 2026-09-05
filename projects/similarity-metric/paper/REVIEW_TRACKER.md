> **RETIRED 2026-09-05 (Tak).** Sentence-level tracking was superseded by the paragraph-review process (per `memory/feedback_review_process.md`: paragraph unit, not sentence unit); progress lives in SUITS.md and PAPER_OUTLINE_BILINGUAL.md. Kept for history; no longer maintained. 0/29 rows were processed under the old nABCD wording.

# Sentence-by-Sentence Review Tracker

> レビュー方法: 各文に対して Tak が判定を下す
> - **OK** → 承認（次の文へ）
> - **修正指示** → 修正後に再提示
> - **削除** → 文を削除
> - **保留** → 後で再検討

---

## Section 1: Introduction

### ¶1 — Opening (L62)

| # | Status | Sentence |
|---|--------|----------|
| S1 | ⏳ | Multi-regional clinical trials (MRCTs), conducted across multiple countries or regulatory regions under a single protocol, have become the standard paradigm for global pharmaceutical development. |
| S2 | ⏳ | This approach offers substantial benefits: accelerated timelines, broader generalizability, and earlier access to new therapies for patients worldwide. |
| S3 | ⏳ | The International Council for Harmonisation (ICH) E17 guideline, adopted in 2017, established principles for planning and designing MRCTs, with a central assumption that treatment effects are generalizable across the target population. |

### ¶2 — Regional Pooling (L64)

| # | Status | Sentence |
|---|--------|----------|
| S4 | ⏳ | A key strategy for enhancing the ability to assess regional consistency in treatment outcomes is the regional pooling approach, wherein regions with similar patient characteristics are grouped for analysis. |
| S5 | ⏳ | The ICH E17 guideline explicitly recommends that pooling decisions be based on the similarity of effect modifier (EM) distributions: |
| S6 | ⏳ | [ICH E17 Quote: "Regions may be pooled for randomisation and/or analysis if subjects are thought to be similar enough with respect to intrinsic and/or extrinsic factors relevant to the disease and/or drug under study." (Section 2.2.5)] |

### ¶3 — EM Explanation (L70)

| # | Status | Sentence |
|---|--------|----------|
| S7 | ⏳ | An effect modifier is a baseline patient characteristic---such as age, disease severity, or genetic marker---for which the treatment benefit differs across subgroups. |
| S8 | ⏳ | For example, if younger patients respond better to treatment than older patients, age is an effect modifier. |
| S9 | ⏳ | When such heterogeneity exists, even if the drug works identically at the individual level, regions with different patient compositions may observe different average treatment effects. |
| S10 | ⏳ | A region with predominantly younger patients would show larger benefits than a region with predominantly older patients, not because the drug works differently, but because the patient mix differs. |
| S11 | ⏳ | This fundamental relationship underscores why EM distributional similarity is critical to the validity of regional pooling. |

### ¶4 — Gap Statement (L72)

| # | Status | Sentence |
|---|--------|----------|
| S12 | ⏳ | Despite the regulatory importance of EM distributional similarity, current practice lacks a standardized quantitative methodology. |
| S13 | ⏳ | The ICH E17 guideline provides no specific metric, threshold, or statistical procedure for determining when distributions are "similar enough." |
| S14 | ⏳ | Recent regulatory guidance has highlighted this gap. |
| S15 | ⏳ | Song et al., writing from the China NMPA perspective on ICH E17 implementation, note the challenge of operationalizing pooling criteria without quantitative tools. |
| S16 | ⏳ | Long et al. further discuss basic considerations for consistency evaluation under ICH E17. |

### ¶5 — Small-Sample Problem (L74)

| # | Status | Sentence |
|---|--------|----------|
| S17 | ⏳ | This absence of quantitative tools is particularly acute for small-sample regions requiring pooling partners at the planning stage. |
| S18 | ⏳ | Regulatory authorities such as Japan's PMDA and China's NMPA require demonstration of treatment effect consistency in regional subpopulations, yet regional enrolment in global MRCTs is often limited, making direct demonstration of consistency difficult. |
| S19 | ⏳ | In these settings, pooling with countries sharing similar EM distributions is a key strategy for achieving adequate regional assessment, but the pooling rationale requires quantitative evidence that partner regions' patient populations are "similar enough." |
| S20 | ⏳ | Matsushima et al.'s PMDA workshop report documented that regional imbalance in CRP-positive/MRI-negative status caused apparent inconsistency in the secukinumab MRCT, demonstrating the practical consequences when EM distributional differences are not assessed quantitatively at the planning stage. |
| S21 | ⏳ | The nABCD framework directly addresses this need by providing a quantitative basis for identifying suitable pooling partners---using any available baseline distributional data---before the trial begins. |

### ¶6 — Existing Tools' Limitations (L76)

| # | Status | Sentence |
|---|--------|----------|
| S22 | ⏳ | Although general-purpose comparison tools such as the standardized mean difference are routinely applied to baseline covariates, no quantitative methodology has been specifically developed for assessing EM distributional similarity in the MRCT pooling context (Table 1). |
| S23 | ⏳ | The standardized mean difference fundamentally cannot detect differences in variance or distributional shape---precisely the types of differences that may drive treatment effect heterogeneity through effect modification. |

### Table 1

| # | Status | Item |
|---|--------|------|
| T1 | ⏳ | Caption: "General-purpose tools applied to distributional comparison and their limitations for EM similarity assessment in MRCT pooling." |
| T2 | ⏳ | Row 1: Visual inspection → Subjective, not reproducible |
| T3 | ⏳ | Row 2: SMD → Captures only location, ignores scale and shape |
| T4 | ⏳ | Row 3: KS statistic → No interpretable scale for decision-making |

### ¶7 — Proposal (L91)

| # | Status | Sentence |
|---|--------|----------|
| S24 | ⏳ | This paper addresses the methodological gap by proposing the normalized Area Between Cumulative Distributions (nABCD) as a quantitative index for assessing EM distributional similarity across regions. |
| S25 | ⏳ | nABCD is defined as the Wasserstein-1 distance between two cumulative distribution functions, normalized by the pooled interquartile range to achieve scale-free interpretation. |
| S26 | ⏳ | Unlike SMD, nABCD captures differences in variance, shape, and skewness simultaneously. |
| S27 | ⏳ | The emphasis is on estimation and clinical interpretation, not hypothesis testing. |
| S28 | ⏳ | We focus on continuous effect modifiers, for which the Wasserstein distance provides a natural and theoretically grounded measure of distributional dissimilarity. |

### ¶8 — Paper Outline (L93)

| # | Status | Sentence |
|---|--------|----------|
| S29 | ⏳ | The remainder of this paper is organized as follows. Section 2 presents the methodological framework, including the index definition, clinical calibration, and estimation procedure. Section 3 describes a simulation study. Section 4 demonstrates the framework using publicly available individual patient data. Section 5 discusses implications, limitations, and future directions. |

---

## Progress

- Section 1: 0/29 reviewed
- Section 2: not started
- Section 3: not started
- Section 5: not started
- Appendix: not started
