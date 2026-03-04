# Act 1: Background — Speaker Scripts

**Presenter**: Rachel Zane
**Section**: 1. Background (Slides 3–6)
**Total estimated time**: ~6–8 minutes
**Audience**: Biostatisticians and regulatory scientists (JSM / ISCB)

---

## Slide: ICH E17: Regional Pooling

**Duration**: ~2 minutes

**Script**:

Let me set the regulatory context for this work.

Multi-regional clinical trials — MRCTs — are now the standard model for global drug development. The fundamental statistical challenge in an MRCT is this: can we pool data across regions, or do regional differences in patient populations make pooling scientifically unjustifiable?

ICH E17, the international harmonized guideline on MRCTs adopted in 2017, provides the governing framework here. Section 2.2.5 of that guideline states — and I'm quoting directly — that regions may be pooled "if subjects are thought to be *similar enough* with respect to intrinsic and extrinsic factors relevant to the disease and/or drug under study."

That phrase "similar enough" is doing a great deal of work. ICH E17 explicitly grounds the pooling justification in the *similarity of factor distributions* across regions. The guideline even lists what those factors include: age, body weight, genetic polymorphisms, disease severity — these are the intrinsic patient characteristics — and medical practice, diet, and standard of care on the extrinsic side.

The problem, as you can see on this slide, is that ICH E17 stops there. It articulates the criterion for pooling in words, but provides **no specific metric, no threshold, and no formal procedure** for operationalizing that criterion. "Similar enough" has no unit. And that is precisely the methodological gap that motivates our work.

**Key points to emphasize**:
- ICH E17 (2017) is the governing international guideline for MRCTs
- The guideline explicitly requires similarity of intrinsic/extrinsic factor distributions to justify pooling
- The direct quote from Section 2.2.5 names "similar enough" without specifying a metric or threshold
- This is a real regulatory gap, not a hypothetical one — it affects submissions to FDA, EMA, PMDA, and NMPA

---

## Slide: Why Effect Modifiers Matter

**Duration**: ~1.5 minutes

**Script**:

So why does the distribution of patient characteristics matter at all for treatment effect comparison across regions? Let me be precise about the mechanism.

The key concept is the **effect modifier** — a baseline characteristic where the treatment benefit differs systematically across subgroups. Mathematically, if we denote the conditional average treatment effect as tau of x, where x is the patient characteristic, then the *regional* average treatment effect is simply the integral of tau(x) against the distribution of x in that region.

This equation tells us something important: even if the drug's biological effect is identical at the individual patient level — same tau(x) for any given patient — two regions with **different patient distributions** will observe **different average treatment effects**. Not because the drug behaves differently, but because the *patient mix* differs.

A concrete example: suppose younger patients derive greater benefit. A region enrolling younger patients on average will report a larger treatment effect estimate. That difference is entirely attributable to the composition of the patient population, not to any pharmacological difference.

This is the mechanism ICH E17 is concerned about. And quantifying it requires us to measure how different those patient distributions actually are.

**Key points to emphasize**:
- The equation tau-bar_r = integral of tau(x) dF_r(x) makes explicit that regional differences in average treatment effects arise from differences in the distribution F_r
- This is a *compositional* effect, not a pharmacological one — the drug works the same but the patients differ
- This mechanism is precisely what ICH E17's pooling criterion is designed to control for

---

## Slide: Limitations of Current Approaches

**Duration**: ~1.5 minutes

**Script**:

So what tools do practitioners currently use to assess this distributional similarity? The honest answer is: not much.

The most common approach in regulatory submissions is **visual inspection** — comparing histograms or summary tables. That is inherently subjective and not reproducible. Two statisticians looking at the same forest plot may reach different conclusions about whether two distributions are "similar enough."

The next most commonly cited tool is the **standardized mean difference**, or SMD. This is familiar territory — it is the same measure used in propensity score diagnostics for covariate balance. The problem is that SMD only captures differences in location, in the mean. Two distributions can have identical means but differ substantially in variance or distributional shape, and SMD will register zero difference. For effect modifiers with non-linear CATE functions, those shape and scale differences are precisely what drives treatment effect heterogeneity.

The **Kolmogorov-Smirnov statistic** is sometimes mentioned as an alternative. It does capture distributional differences beyond location, but it operates on a dimensionless [0,1] scale with no clinically interpretable meaning. Telling a regulatory team that K-S equals 0.15 gives them no way to assess whether that constitutes a problem.

This gap has not gone unnoticed. Two recent papers from the Chinese NMPA perspective — Song and colleagues in 2025, published in *Therapeutic Innovation and Regulatory Science*, DOI 10.1007/s43441-025-00744-8 — and Long and colleagues, also in 2025, DOI 10.1007/s43441-024-00717-z — both highlight the absence of quantitative tools for operationalizing ICH E17's pooling criterion. They document that this is a real, active gap in regulatory practice. Our paper directly addresses what they identify as missing.

**Key points to emphasize**:
- The three methods in the table (visual inspection, SMD, K-S) each have a specific, identifiable failure mode
- SMD's blindness to scale and shape is not a minor limitation — it is a structural problem for non-linear CATE functions
- Song et al. (2025) and Long et al. (2025) are recent regulatory-facing papers that independently identify this same methodological gap
- This locates our contribution in a live regulatory debate, not an academic exercise

---

## Slide: Our Approach

**Duration**: ~1.5 minutes

**Script**:

This brings us to our central research question, which you can see in the blue block on this slide: how can we estimate distributional similarity in a *scale-free* manner, and then translate that estimate into *clinically interpretable* information about potential treatment effect heterogeneity?

I want to highlight two choices that define our design philosophy, because they distinguish this work from prior proposals.

First, we take an **estimation-centered** approach, not a testing approach. We do not ask "are the distributions different?" with a binary yes-or-no answer. We ask "how different are they, and what does that difference imply for the magnitude of potential treatment effect heterogeneity?" ICH E17 itself cautions against rigid binary criteria — it explicitly recommends context-dependent judgment. Estimation supports that judgment; binary testing forecloses it.

Second, we insist on **clinical calibration**. A pure distributional metric is still abstract to a regulatory audience. We want to translate whatever similarity score we compute back into the clinical outcome scale — into the same units as the treatment effect and the non-inferiority margin. That is what makes the tool actionable.

I should also be clear about scope: our method is designed for **continuous effect modifiers**. Categorical or mixed-type EMs require different distance structures, and we note that as a direction for future work.

The goal, as stated at the bottom of this slide, is to provide regulatory scientists with quantitative tools that *inform* deliberation, not replace it with an algorithm. With that philosophy in mind, let me turn to the Methods section, where Mike will walk you through the mathematical foundations.

**Key points to emphasize**:
- The distinction between estimation and testing is philosophically important and has regulatory backing in ICH E17's own language about context-dependence
- Clinical calibration — translating back to the outcome scale — is what makes the metric actionable rather than merely academic
- The scope limitation to continuous EMs is intentional and explicit, not an oversight
- End with a clear handoff to the Methods section

---

*Rachel Zane | Background Section Scripts | 2026-03-03*
*References: ICH E17 (2017), Song et al. (2025) DOI: 10.1007/s43441-025-00744-8, Long et al. (2025) DOI: 10.1007/s43441-024-00717-z*
