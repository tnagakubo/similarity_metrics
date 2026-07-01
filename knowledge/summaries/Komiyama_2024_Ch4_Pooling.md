# Komiyama, Hiro, Matsuoka & Yamamoto (2024) — Ch.4 "Pooling Strategies"

## Citation
Komiyama, O., Hiro, S., Matsuoka, N. & Yamamoto, H. (2024). "Pooling Strategies." Chapter 4 in *[Multi-Regional Clinical Trials / ICH E17 volume]*, CRC Press / Routledge.
DOI: [10.1201/9781003109785-4](https://doi.org/10.1201/9781003109785-4)

**Provenance**: Authors are Japanese ICH E17 Task Force members. This is the published book-chapter form of the work memory references as 小宮山 TF (cf. `E17_TF_report.pdf`). Prefer this chapter (clean DOI) for citation. See [[ICH_E17_JP_workshops_pooling_review]], [[Quan_2010]], [[Singh_2024_E17_5years]].

## Why this chapter matters to our paper
It is the **most direct prior art** for our W₁ effect-modifier-similarity framework: a named E17 authority that **operationalizes pooling via a concrete quantitative distance + clustering recipe**. Our gap claim must be scoped against *this* method precisely — not against a strawman of "Japan has no quantitative method" (memory flags 「定量ゼロ／日本=定性」 as a past abstract-reading artifact — do NOT regress to it).

## What Ch4 actually proposes (§4.6 "How to Pool")
A 3-step recipe, then a concrete statistical method:
1. Identify effect modifiers (EMs) from early trials / existing data (prognostic or predictive factors).
2. Judge how far they explain anticipated regional variability.
3. Define pooled regions/subpopulations by **similar distribution of the identified EMs**.

**§4.6.1.1 — How to measure a distance between regions:**
- Give each region a **representative value** per candidate EM parameter; plot regions in parameter space.
- Distance = **Euclidean / Manhattan** (or Pearson / cosine / Spearman correlation distance), usually after standardizing each parameter to N(0,1).
- **Weighting by EM relevance**: weight parameters by their relationship to the response endpoint. Explicitly suggests **Lasso regression** — non-EM parameters get weight ≈ 0 and drop out of the clustering. → *Ch4 already solves "which EMs matter."*

**§4.6.1.2 — Clustering:** hierarchical (dendrogram, pick a cut level) or k-means (pre-set k).

**§4.6.1.3 — Number of pooled regions:** ≤ 4 recommended. Justified by subgroup-multiplicity risk: Alosh et al. (2017, *Stat Med* 36:1334) — P(≥1 spuriously negative subgroup) >26% at ≥5 subgroups (90% power, effect 0.25); Quan et al. (2010) — >4 regions degrades consistency demonstration. **This is the cluster-COUNT question.**

**§4.6.1.4 — Interpretation:** subgroup analysis by pooled regions = stratification by EM-distance clusters. On whether a pooled-region point estimate transfers to a member country: *"There is not a simple answer... we should evaluate the magnitude of the impact of the effect modifiers... and interpret if these differences are **clinically meaningful or not**."* → **names the clinical-meaningfulness judgment but supplies no metric for it.**

## Figures
- **Fig 4.1** (= E17 Fig 2a): plots severity as **bell-curve DISTRIBUTIONS** for Region I vs II; caption: pool "countries or regions with **similar distribution** of disease severity." The concept is explicitly *distributional*.
- Fig 4.2: effect modification schematic (effect of exposure varies by level of a third variable).
- Fig 4.3: **hierarchy of factors** — geography → ethnicity → E5 intrinsic/extrinsic → *true* EM. Coarser factors are surrogates/composites of true EMs (e.g., body weight as phenotype of genetics/diet). True-EM exemplar: EGFR mutation for gefitinib (NSCLC).
- Fig 4.4: what is plannable scales with how much EM knowledge exists at planning stage.

## The gap, scoped precisely (3 seams for our paper)

**Seam 1 — Concept is distributional, the method *as operationalized* is not (ILLUSTRATION ONLY — NOT the novelty pillar).** Fig 4.1 and the §4.6 step-3 language say "similar **distribution**," but §4.6.1.1 *as operationalized* reduces each region to a **representative value** per EM, then takes Euclidean distance — collapsing the distribution to a low-order moment.
- **Discriminating illustration (= our S5, scale-only — CORRECTED 2026-06-27):** equal means, different variances — in the live paper this is **S5** (N(50,10²) vs N(50,15²), W₁/IQR = 0.244), NOT S8 (paper has only S1–S7; S7 = location+scale shifts the mean so Euclidean ≠ 0 — not a clean discriminator; S8 = Outlier mixture in `figures_paper.R`, a different system). With *mean-only* representative values, Ch4's Euclidean = 0 here; W₁ > 0. This is the **same moment-collapse blind spot as SMD**, already shown at line 97 (N(50,5²) vs N(50,15²), SMD = 0) and tab:smd S5 row ("Only ρ̂ detects").
- ⚠️ **DO NOT make S5 the novelty pillar (Louis, 2026-06-27 meeting).** §4.6.1.1 says "representative value in each candidate **parameter**" — NOT restricted to the mean; §4.6.1.4 actually uses distributional summaries (proportion male/younger) as axes. A Komiyama-aware reviewer patches the variance case in one line ("add SD as a coordinate"). S5=0 is faithful to their *example*, wrong about their *method* → trivially patchable → invites "incremental over Komiyama." Keep S5 as illustration vs **SMD** (legitimate, line 469-i), not as the Komiyama rebuttal.
- Frame Path α (per-EM W₁) as a **distance between distributions**, NOT a relevance-weighting improvement — Lasso (§4.6.1.1) already does relevance weighting. No novelty there.
- Phrase the limitation as "**as operationalized with representative values**," NOT "they are incapable" (standardization = cross-parameter N(0,1) scaling, not within-region dispersion; Lasso = selection, not dispersion — so the limitation holds, but only as an operationalization claim).

**The two TEXT-PROOF novelty pillars (where the Komiyama contrast actually anchors):**
- **(a) Whole-distribution capture without pre-specifying which moment matters.** W₁ needs no moment enumeration; any moment-list method risks missing an unenumerated feature (tails, bimodality). 
- **(b) Theoretical link to regional treatment-effect difference via Δ_max bound (Prop. 1).** mean+SD Euclidean has no such link. This is paper requirement (iii)/line 469-(ii) — anchor the Komiyama contrast here, extending the "absent in … KS statistic" list to representative-value distance methods.

**Seam 2 — Clinical meaningfulness is named but not operationalized.** §4.6.1.4 explicitly asks whether EM differences are "clinically meaningful or not" but gives **no method to decide**. **Δ_max is exactly that operationalization**: a clinically calibrated threshold on the EM-distance scale. Wording for the paper: *"Ch4 calls for a clinical-meaningfulness judgment of EM differences but provides no metric to operationalize it; we supply one."* (Stronger and unassailable vs. "they ignored it.")

**Seam 3 — Distance-threshold vs cluster-count are different unanswered questions.** §4.6.1.3's ≤4 answers *how many* clusters. It does **not** answer *how close is close enough* (where to cut, what distance = "similar enough"). Δ_max answers the **distance-threshold** question only — keep these two distinct; do not conflate Δ_max with the ≤4 rule.

## One-line positioning
Ch4 supplies a concrete quantitative pooling recipe (representative value + Euclidean, Lasso-weighted, hierarchical clustering) but **names** the clinical-meaningfulness and distance-threshold problems without operationalizing them. Our W₁ framework differs on two text-proof grounds: **(a)** it captures the whole distribution without pre-specifying which moment matters, and **(b)** it links distributional distance to regional treatment-effect difference via the Δ_max bound — a link absent from representative-value Euclidean distance. The equal-mean/unequal-variance case (S5) illustrates the moment-collapse shared by SMD and *mean-only* representative values, but is an illustration vs SMD, NOT the Komiyama novelty pillar (patchable).

## DECISION — Team meeting 2026-06-27 (Harvey synthesis, Jessica approved; pending Tak go)
Reflect Ch4 into `per_em_W1_wiley.tex` with **minimal, narrowed** edits — no new figure (Katrina), text-only:
1. **Intro (line 69)**: KEEP "The ICH E17 *guideline* provides no specific metric/threshold/procedure" (true — Komiyama is a separate book chapter, not the guideline). Add Komiyama beside Song/Long as the **most concrete existing proposal**, scoping its 2 limits (representative-value → location-only blind spot like SMD; §4.6.1.4 names clinical-meaningfulness without a metric). Soften "lacks a standardized quantitative methodology" → "lacks a **standardized, clinically-calibrated** methodology."
2. **Discussion (line 469-ii)**: extend "absent in … KS statistic" to include **representative-value distance methods** — anchor the Komiyama contrast on the Δ_max treatment-effect link (pillar b).
3. **Discussion (line 483)**: "a quantitative tool where one was **previously absent**" → "where no **standardized, clinically-calibrated** tool was previously available."
4. **Citation**: book chapter clean DOI `10.1201/9781003109785-4` into bib (Rule 2.6). `E17_TF_report.pdf` (p.25 self-admission「類似度を定める明確な基準がなく」) only if quoting that line directly. EN/JA sync (Rule 2.7) required after EN edit.
Do **not** touch Results/tables; S5 row in tab:smd stays, referenced as illustration vs SMD only.

## Tags
ICH E17, pooling strategy, pooled regions, pooled subpopulations, effect modifier, cluster analysis, Euclidean distance, Lasso, Wasserstein, gap claim, Komiyama, Japanese TF, S5, Delta_max, moment-collapse, treatment-effect link

---
*Processed by Rachel | Reframed after 2026-06-27 team meeting (Louis adversarial pass) — novelty pillars are (a) no-moment-pre-specification + (b) Δ_max treatment-effect link; S5 demoted to illustration vs SMD. Validated against memory `project_e17_3layer_positioning`.*
