# Existing Methods and What This Paper Actually Adds

Created 2026-07-12 on Tak's instruction: *"既存手法を整理して、小宮山が実際に何を提案しているのか、
この論文で新たに提案していることは何か、小宮山を拡大解釈しすぎないように。"*

Source of truth for the Komiyama claims: the chapter text itself,
`knowledge/pdfs/Ch4_Pooling_Strategy/Ch4_Pooling_Strategy.md`
(Komiyama, Hiro, Matsuoka & Yamamoto 2024, DOI 10.1201/9781003109785-4).
Every quotation below is verbatim from that file. **Do not paraphrase from the
summary file; it contained a misreading (see §3).**

---

## 1. The existing-methods map

The literature splits into three groups that answer *different* questions. Conflating
them is how overclaims get made.

| Work | Question it answers | Quantitative machinery it supplies | Does it compare EM *distributions* between regions? |
|---|---|---|---|
| **ICH E17 (2017)** | What is pooling, and why pre-specify it? | none | No. States regions may be pooled if "similar enough" w.r.t. intrinsic/extrinsic factors; supplies no metric, threshold, or procedure. |
| **Quan et al. (2010)** | Are the observed *treatment effects* consistent across regions? | 5 formal consistency definitions + sample-size formulas | No — operates on treatment effects after the trial, not on EM distributions before it. |
| **Song et al. (2025)** (NMPA) | How should a sponsor decide a pooling strategy in practice? | a decision flowchart | No — qualitative; explicitly notes the difficulty of operationalizing "similar enough". |
| **Long et al. (2025)** (NMPA) | How should consistency be evaluated? | FEM / random-effect / Bayesian hierarchical models | No — models treatment effects, not EM distributions. |
| **Komiyama et al. (2024) Ch.4** | **How do we actually form pooled regions from EMs?** | **representative value per EM → Euclidean/Manhattan distance (Lasso-weighted) → hierarchical / k-means clustering → ≤ 4 clusters** | **Partially** — via a *summary* of each region's EM distribution (see §2). This is the closest prior art. |
| SMD (routine practice) | Are two groups balanced on a covariate? | \|mean difference\| / pooled SD | Only through the mean. |
| KS statistic | Do two samples share a distribution? | sup\|F̂₁ − F̂₂\| | Yes — but with no clinical calibration and no link to treatment-effect difference. |

**Consequence.** The gap this paper fills is not "nobody has a quantitative method"
(false — Komiyama has one) and not "Japan is qualitative" (false — both prior
artefacts of abstract-only reading; see `memory/project_e17_3layer_positioning`).
The gap is narrower and defensible: *no existing method compares the **full** EM
distribution and calibrates the comparison **clinically**.*

---

## 2. What Komiyama Ch.4 actually proposes — verbatim

**§4.6 — the three steps.**
1. Identify EMs from early trials / existing data.
2. Judge how far they explain anticipated regional variability.
3. Define pooled regions "based on **similar distribution of the identified effect modifiers**."

**§4.6.1 — the method is clustering.**
> "Cluster analysis is a powerful tool to pool regions. Key components … are
> (1) measuring a distance between regions, (2) grouping regions based on the
> **distance matrix among regions**."

**§4.6.1.1 — how the distance is measured. THIS IS THE LOAD-BEARING SENTENCE:**
> "A simple way to measure a distance between regions is to let a region have
> **a representative value in each candidate parameter of effect modifier** and plot
> regions on the parameter space. The basic methods for distance measures are
> Euclidean and Manhattan distances. In many cases, standardization of each parameter
> … into the standard normal distribution of N(0,1) is needed …"

and, decisively, on the dimension of that space:
> "In case that there are **ten candidate parameters of the effect modifier** … it is
> not a good choice to measure a distance with the same scale on a **ten-dimension
> space**."

→ **One coordinate per effect modifier.** Ten EMs give a ten-dimensional space — not
a twenty- or thirty-dimensional one. The axes of the space are the EMs themselves.

Relevance weighting: coordinates are weighted by their relationship to the endpoint;
**Lasso** is suggested, so non-EM parameters get weight ≈ 0 and drop out.

**§4.6.1.2 — clustering:** hierarchical (dendrogram, choose a cut level) or k-means
(pre-set k).

**§4.6.1.3 — number of pooled regions:** ≤ 4 recommended, justified by
subgroup-multiplicity risk (Alosh et al. 2017; Quan et al. 2010).

**§4.6.1.4 — the worked example. This settles what "representative value" means:**
> "if there are two factors (e.g., **gender and age**) that impacted the treatment
> response, we can classify all regions into four pooled regions … Please note that
> this classification is considered as the distribution of the patient population in a
> region. In case that **the proportion of male patients and that of younger patients
> are similar**, then these regions can be pooled."

→ The coordinates are *the proportion of male patients* and *the proportion of younger
patients*: **one summary number per EM**. No spread. No shape. No second moment.

**§4.6.1.4 — and the question they raise but do not answer:**
> "Can we equate point estimates of treatment effect(s) for a certain pooled region to
> those for individual country or region included in the pooled region? … **There is
> not a simple answer**, but … we should evaluate the magnitude of the impact of the
> effect modifiers … and interpret if these differences are **clinically meaningful or
> not**."

→ They *name* the clinical-meaningfulness judgment and supply **no metric** for it.

---

## 3. What Komiyama does NOT propose — the over-reading we must not commit

> ⚠️ **Correction of a prior internal misreading (Louis, 2026-06-27; carried into
> `knowledge/summaries/Komiyama_2024_Ch4_Pooling.md` Seam 1 and into the simulation).**
> That note read "representative value in each candidate **parameter**" as *parameter
> of the distribution* (mean, SD, …) and concluded that a Komiyama-aware reviewer could
> "patch the variance case in one line by adding SD as a coordinate."
> **The chapter does not say this.** "Candidate parameter of effect modifier" means the
> candidate EM itself (gender, age, BMI …) — as the ten-EM/ten-dimension sentence and
> the gender/age worked example both confirm.

Therefore, in the paper we must **not** write, imply, or simulate any of the following
as *Komiyama's method*:

| ❌ Do not attribute to Komiyama | ✅ What is actually true |
|---|---|
| "Komiyama uses (mean, SD) coordinates" | Ch.4 gives each EM **one** representative value. |
| "Komiyama can add skewness as a coordinate" | Ch.4 never discusses moments of an EM's within-region distribution. |
| "Komiyama's method captures spread" | It captures whatever the single chosen summary captures — a proportion, a mean. Spread is not represented. |

Equally, we must **not** understate them:

| ❌ Do not claim | ✅ What is actually true |
|---|---|
| "No quantitative pooling method exists" | Ch.4 supplies a complete, concrete recipe. |
| "They ignore relevance of EMs" | Lasso weighting handles exactly that — better than we do. We have no EM-selection method. |
| "They ignore how many pools to form" | §4.6.1.3 answers it (≤ 4) with cited justification. We do not. |
| "They are unaware the concept is distributional" | §4.6 step 3 and Fig 4.1 are explicitly distributional. The *concept* is distributional; the *operationalization* summarizes. |

**The honest one-line statement of the gap:**
> Ch.4 defines pooled regions by *similar distribution* of the EMs, but operationalizes
> that similarity by reducing each region's EM distribution to a single representative
> value per modifier and taking a Euclidean distance in EM space. Two regions whose
> distributions differ in spread, shape, or tails — but agree on the chosen summary —
> are at distance zero. Ch.4 also asks whether an EM difference is "clinically
> meaningful or not" and provides no metric to decide.

---

## 4. What this paper proposes that is new

Stated against the prior art above, **not** against a strawman.

| # | Contribution | Whose gap it fills | Not claimed |
|---|---|---|---|
| **(a)** | Compare the **whole** within-region EM distribution via $W_1$, with **no pre-specification of which moment matters** | Ch.4's representative value; SMD's mean | Not a *relevance-weighting* improvement — Lasso (§4.6.1.1) already does that, and does it better than anything we offer. |
| **(b)** | **Clinical calibration**: $\Delta_{\max} = L_{\text{clinical}} \cdot W_1$ turns a distance into a bound on the regional treatment-effect difference, giving an operational answer to "how close is close enough" | §4.6.1.4 names this question and leaves it open ("there is not a simple answer") | Not a claim that Ch.4 was wrong to leave it open — only that we now supply the metric. |
| **(c)** | **Theoretical link** distance → treatment-effect difference (Kantorovich–Rubinstein bound) | Absent from representative-value Euclidean distance **and** from the KS statistic | This, and not simulation performance, is what separates $W_1$ from KS. |
| **(d)** | **Per-EM resolution with a joint (AND) criterion**, instead of collapsing EMs into one aggregate distance | Ch.4 aggregates via Lasso-weighted distance; GUSTO-I shows age and SBP distances are nearly uncorrelated ($r = 0.13$), so aggregation can mask an incompatibility on one modifier | Complementary, not a refutation: aggregation is reasonable when a single pooled ranking is wanted. |

**What we do NOT contribute, and must say so:** EM identification/selection (their
Lasso front-end is better), and the number of pooled regions (§4.6.1.3's ≤ 4 stands;
$\Delta_{\max}$ answers the *distance-threshold* question, which is a different
question — do not conflate the two).

---

## 5. Implications for the simulation (action required)

The simulation currently labels its baselines `KOM` = RV(mean, SD) and `KOM3` =
RV(mean, SD, skew). Per §3, **neither is Komiyama's method**, and the faithful
single-EM implementation — one representative value — is **missing**.

**Done (2026-07-12, commit on `worktree-selection-sim`):**

1. **Added `RV1` = one representative value (the mean)** — this *is* Ch.4's recipe
   applied to a single continuous EM, and the only baseline the paper may legitimately
   call "the representative-value approach of Komiyama et al."
2. **Renamed** `KOM` → `RV2`, `KOM3` → `RV3` everywhere (code, plan, figures,
   validator), described as *extensions we grant in advance* — **never** as Komiyama's
   method.

**Results (production, n = 100).**

| | W₁ | KS | **RV1 (Ch.4)** | RV2 | RV3 | SMD |
|---|---|---|---|---|---|---|
| Clustering ARI, Set 1 Gaussian | 0.995 | 0.983 | **0.489** | 0.996 | 0.620 | 0.452 |
| Clustering ARI, Set 2 Log-normal | 0.642 | 0.850 | **0.343** | 0.614 | 0.448 | 0.334 |
| Clustering ARI, Set 3 Mixture | 0.526 | 0.503 | **−0.000** | 0.018 | 0.131 | −0.000 |

**RV1 tracks SMD almost exactly** (0.489/0.343/−0.000 vs 0.452/0.334/−0.000). One
summary per modifier carries only location information, so Ch.4's distance and the SMD
fail in the same places. This is the citation-faithful finding, and it means the S5
illustration (equal mean, unequal variance) is legitimate against the *actual recipe*,
not only against SMD.

> **Precision note — do not overstate RV1's blindness either.** RV1's Set-1
> **scale**-AUC is 0.62, not 0.50. That is *not* detection: all Set-1 countries share
> the true mean 50, so RV1's *population* distance to the anchor is exactly 0 for the
> scale countries. The 0.62 is an artefact of a wider country having a noisier sample
> mean — for independent X∼N(0,s₁), Y∼N(0,s₂), P(|X|<|Y|) = (2/π)·arctan(s₂/s₁), giving
> 0.59 and 0.64 for V1/V2, mean **0.623** vs **0.619** observed. The signature of "no
> information" is not AUC = 0.5 but **AUC flat in n**: RV1 goes 0.623 → 0.619 from
> n = 25 to 100 while W₁ goes 0.932 → 0.997. Say "carries no information about scale
> and does not improve with n", not "AUC = 0.5".

**Why this strengthens rather than weakens the paper:** we no longer need the reviewer
to accept that Komiyama "could have" used (mean, SD). The argument is now two-tier:
(i) their **actual** recipe has SMD's blind spot — a citation-faithful, unassailable
claim; and (ii) the natural repair a reviewer would propose (RV2, RV3) *also* collapses
in the moment-matched world (ARI 0.018 / 0.131) **and costs accuracy where two moments
suffice** (Set 1: RV3 AUC 0.847 < RV2 0.988). "Just add another moment" is thereby
converted from a rebuttal into a measured cost.

---

## 6. Required edits to `per_em_W1_wiley.tex`

| Line | Current | Problem | Fix |
|---|---|---|---|
| 70 | "it reduces each regional distribution to **one or more** representative values" | "one or more" hedges toward an over-reading; Ch.4 says one per EM | "…assigns each region **a single representative value per candidate effect modifier** (their worked example uses the proportion of male and of younger patients) and measures Euclidean distance in that space" |
| 70 | "…can overlook features that were not pre-specified—such as differences in spread or tail behaviour" | correct, keep | keep; it now follows directly from "a single representative value" |
| 470 (iii)/(ii) | "representative-value distance methods such as Euclidean distance on region-level effect modifier summaries" | accurate | keep |
| 474 | per-EM vs aggregate contrast | accurate | keep |
| 486 | "Lasso offers one front-end for this selection" | accurate and appropriately generous | keep |

No line currently attributes (mean, SD) coordinates to Komiyama, so **the manuscript is
not yet contaminated** — the over-reading lives only in the simulation labels, the
summary file, and SUITS. Fix those before any of this reaches the paper.
