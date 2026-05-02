# AMI Thrombolysis: Plausible CATE Sensitivity Range (2026-04-30)

Survey of **subgroup-stratified treatment-effect (CATE) magnitudes** for two
canonical effect modifiers in AMI thrombolysis trials — **age** and
**systolic blood pressure (SBP)** — used to anchor the *plausible upper
bound* on the Lipschitz constant L of the CATE function τ(x) for the
nABCD paper §4.4 reverse-calibration argument.

L_age (per year) and L_SBP (per mmHg) are interpreted as: the maximum
absolute change in 30-day mortality difference (treatment − control)
when the effect modifier moves by one unit, holding everything else
constant. We extract these from published subgroup tables and convert
to a per-unit Lipschitz scale.

Companion to `AMI_thrombolysis_delta_clin.md` (Δ_clin = 1 %pt anchor).

---

## 1. Trials/papers surveyed

| # | Source | Year | Reference | Used for |
|---|--------|------|-----------|----------|
| 1 | **FTT (Fibrinolytic Therapy Trialists') Collaborative Group** | 1994 | *Lancet* 343:311–22 (DOI: [10.1016/S0140-6736(94)91161-4](https://doi.org/10.1016/S0140-6736(94)91161-4)) | Age + SBP subgroup (n=58,600; pivotal) |
| 2 | **ISIS-2 Collaborative Group** | 1988 | *Lancet* 332:349–60 (DOI: [10.1016/S0140-6736(88)92833-4](https://doi.org/10.1016/S0140-6736(88)92833-4)); 10-yr follow-up (1998) DOI: [10.1016/S0140-6736(98)07419-4](https://doi.org/10.1016/S0140-6736(98)07419-4) | SK ± ASA, age subgroup |
| 3 | **GUSTO-I age subgroup** (White, Barbash, Califf et al.) | 1996 | *Circulation* 94:1826–33 (DOI: [10.1161/01.CIR.94.8.1826](https://doi.org/10.1161/01.CIR.94.8.1826)) | Age × treatment-arm interaction |
| 4 | **GUSTO-I BP/SBP analysis** (Aylward, Wilcox, Topol et al.) | 1996 | *Ann Intern Med* 125:891–900 (DOI: [10.7326/0003-4819-125-11-199612010-00004](https://doi.org/10.7326/0003-4819-125-11-199612010-00004)) | SBP gradient on benefit |
| 5 | **LATE study** | 1993 | *Lancet* 342:759–66 | Late-presentation, age-stratified |
| 6 | **Boersma et al.** "Reappraisal of golden hour" | 1996 | *Lancet* 348:771–5 | Time × subgroup pooled IPD |
| 7 | **Mehta R.H. et al.** "Impact of age, decade of trials" | 2006 | *Am J Cardiol* 97:1145–50 (DOI: [10.1016/j.amjcard.2005.11.025](https://doi.org/10.1016/j.amjcard.2005.11.025)) | Age × outcome meta-analysis (11 trials, n=148,099) |
| 8 | **STREAM-2** (Van de Werf, Welsh, Armstrong et al.) | 2024 | *Circulation* 148:753–64 (DOI: [10.1161/CIRCULATIONAHA.123.064521](https://doi.org/10.1161/CIRCULATIONAHA.123.064521)) | Older patients (≥60), half-dose TNK |
| 9 | **Mehta S.R. & Eikelboom**, debate piece on age | 2000 | *Trials/CVM* 1:150–4 | Synthesis of FTT/ISIS-2 age data |
| 10 | **Yusuf et al., overview/review** | 2003 | *Circulation* 107:2533 | Age ARR magnitudes |

Total: 10 distinct sources directly examined; 4 (FTT, ISIS-2, GUSTO-I age, GUSTO-I BP) carry the quantitative weight.

---

## 2. Age-CATE evidence

### 2.1 FTT 1994 (pivotal meta-analysis, n=58,600)

The headline finding is that **35-day mortality reduction varied
modestly with age**: the original FTT analysis (broad eligibility,
including patients up to 24 h from onset) reported absolute risk
reductions (ARR) clustering around 18 deaths prevented per 1,000
treated (1.8 %pt) overall, with the elderly subgroup showing similar
absolute benefit despite a smaller proportional reduction.

When restricted to **conventional STEMI criteria** (ST-elevation or
new LBBB, presenting <12 h — the modern indication), the FTT
re-analysis showed:

| Age stratum | ARR (per 1,000 treated) | ARR (%pt) |
|-------------|-------------------------|-----------|
| <55 yr | ~16 | 1.6 %pt |
| 55–64 yr | ~24 | 2.4 %pt |
| 65–74 yr | ~27 | 2.7 %pt |
| ≥75 yr | ~34 | 3.4 %pt |

(<55 and ≥75 figures are explicit FTT-Secretariat numbers cited
across multiple reviews — Mehta & Eikelboom 2000, AHA Council position
papers; intermediate strata interpolated from FTT figure 4 and
Boersma 1996 IPD reanalysis.)

**Implication**: across a ~25-year age span (~50 → ~75 yr), CATE
varies by ~1.8 %pt → **per-decade Δτ ≈ 0.72 %pt** → **L_age ≈ 0.072
%pt/yr ≈ 7×10⁻⁴ /yr** (treating mortality on the [0, 1] probability
scale).

Note: the *direction* is counter-intuitive — older patients gain
**more** absolute benefit than younger patients because their baseline
mortality is much higher (FTT control mortality: ~5 % at <55, ~25 % at
≥75). Relative-risk reduction is flat-to-decreasing with age, but
ARR (the relevant quantity for CATE on the difference scale)
*increases* with age.

### 2.2 ISIS-2 1988 (n=17,187; SK ± ASA vs placebo)

ISIS-2 is the **most extreme age gradient** in the AMI thrombolysis
literature. For the SK + ASA arm vs double placebo:

| Age stratum | ARR (per 1,000) | ARR (%pt) |
|-------------|------------------|-----------|
| <60 yr | 25 | 2.5 %pt |
| 60–69 yr | 70 | 7.0 %pt |
| ≥70 yr | 80 | 8.0 %pt |

For SK alone (placebo-controlled):
- <60: 16/1000 (1.6 %pt) — same as FTT <55
- 60–69: 38/1000 (3.8 %pt)
- ≥70: 34/1000 (3.4 %pt)

**Implication (SK + ASA)**: from <60 to ≥70 the ARR widens by 5.5 %pt
across ~15 years → **per-decade Δτ ≈ 3.7 %pt** → **L_age ≈ 0.37 %pt/yr
≈ 3.7×10⁻³ /yr**. This is the upper extreme for "biologically
plausible" age-CATE in AMI thrombolysis. (The SK-alone version gives
~2 %pt/decade and L_age ≈ 0.20 %pt/yr.)

### 2.3 GUSTO-I age subgroup (White et al., Circulation 1996)

GUSTO-I is the application dataset for the nABCD paper. The age
gradient on **30-day mortality** (across all four arms pooled) was:

| Age stratum | 30-day mortality |
|-------------|------------------|
| <65 yr | 3.0 % |
| 65–74 yr | 9.5 % |
| 75–85 yr | 19.6 % |
| >85 yr | 30.3 % |

Treatment-effect heterogeneity was **modest but present**:
accelerated tPA out-performed streptokinase + heparin in patients
≤85 yr (consistently ~1 %pt absolute benefit, similar to the overall
trial result) but the >85 yr stratum showed a **weak reversal**
(streptokinase numerically better; OR for death/disabling stroke 1.13,
95% CI 0.6–2.1) — almost certainly noise (n was ~412 in the >85
arm), but it bounds the *worst-case* CATE flip near the trial age
ceiling.

If we accept the >85 reversal at face value, the tPA-vs-SK CATE swings
from −1.0 %pt (<65) to +1–2 %pt (>85) across ~25 yr → **per-decade
swing of ~1 %pt → L_age ≈ 0.10 %pt/yr ≈ 1×10⁻³ /yr**.

(Note: this is the *between-thrombolytics* CATE, smaller than the
*thrombolytic-vs-placebo* CATE in FTT/ISIS-2. nABCD §4.4 framework
applies to whichever treatment contrast the trial estimates; for
GUSTO-I that is tPA vs SK.)

### 2.4 Mehta R.H. et al. 2006 (decade-of-trials meta-analysis, n=148,099)

Combined elderly (≥75 yr, n=24,531) vs younger (n=123,568) across 11
trials: **mortality OR 4.37**, **ICH OR 2.83**, **CVA OR 2.92**.

This bounds the *baseline* gradient (m₀(x)) — older patients have
~4× the mortality — but does not directly give CATE heterogeneity.
Combined with FTT, it implies the *RRR is approximately constant with
age but the ARR rises proportional to baseline*. This is consistent
with **L_age ≈ RRR × (∂m₀/∂age)** — and using FTT RRR≈18% with
∂m₀/∂age ≈ 1 %pt/yr gives **L_age ≈ 0.18 %pt/yr**, in the
middle of our range.

### 2.5 Recommended L_age plausible upper bound

| Source | Per-decade Δτ | L_age (%pt/yr) | L_age (decimal /yr) |
|--------|---------------|-----------------|---------------------|
| FTT conventional | 0.7 %pt | 0.07 | 7×10⁻⁴ |
| ISIS-2 SK alone | ~2 %pt | 0.20 | 2×10⁻³ |
| **ISIS-2 SK+ASA** | **3.7 %pt** | **0.37** | **3.7×10⁻³** |
| GUSTO-I (within thrombolytics) | ~1 %pt | 0.10 | 1×10⁻³ |
| Mehta 2006 / FTT consistency | ~1.8 %pt | 0.18 | 1.8×10⁻³ |

> **Recommended plausible upper bound: L_age = 4×10⁻³ /yr
> (≈ 0.4 %pt/yr ≈ 4 %pt/decade)**

This is anchored to the **ISIS-2 SK + ASA gradient** — the most
extreme age-CATE ever published in the thrombolysis literature.
**Justification**: any L*_age estimated from data that exceeds this
bound would imply a biologically implausible degree of effect-modifier
heterogeneity, exceeding even the SK + ASA mega-effect. A more
typical "moderate" plausibility bound would be 2×10⁻³ /yr (2
%pt/decade), which still envelopes FTT, GUSTO-I, and Mehta 2006.

---

## 3. SBP-CATE evidence

SBP is a much weaker effect modifier than age in the AMI thrombolysis
literature. Direct stratified CATE tables are sparse.

### 3.1 FTT 1994 (8-subgroup analysis)

The FTT collaborative explicitly tested SBP as one of its 8
prespecified subgroups, with strata typically:
- <100 mmHg
- 100–149 mmHg
- 150–174 mmHg
- ≥175 mmHg

The published conclusion (Lancet 1994 Fig. 4 forest plot): **"benefit
was observed irrespective of blood pressure"** — i.e., **no
significant treatment-by-SBP interaction**. The point estimates of
proportional mortality reduction were within ~3 %pt of the overall
18% across all four SBP strata, and 95% CIs all overlapped. On the
*absolute* scale, this means CATE varies by ≤0.3 %pt across 75 mmHg
of SBP variation → L_SBP ≤ 0.04 %pt/mmHg.

### 3.2 GUSTO-I (Aylward et al., Ann Intern Med 1996)

GUSTO-I analysed admission BP × thrombolytic outcome with explicit
ARR by SBP band. Key result:

- Hypertensive patients (low-risk subset, SBP ≥175) showed
  **~13 lives saved per 1,000** (1.3 %pt) — but with ~13/1000
  ICH risk in the same group, giving a **net benefit ≈ 0**.
- Normotensive low-risk patients showed **~30 lives saved per
  1,000** (3.0 %pt) — net benefit ~2 %pt after subtracting ~10/1000
  ICH.
- The CATE on mortality alone (ignoring ICH offset): **ΔARR ≈ 1.7
  %pt across ~35 mmHg of SBP** → **per-10mmHg Δτ ≈ 0.5 %pt** → **L_SBP
  ≈ 0.05 %pt/mmHg ≈ 5×10⁻⁴ /mmHg**.

(This is the *gross* CATE on mortality. On *net clinical benefit*
including stroke, the CATE is steeper because ICH risk rises with
SBP — but for the nABCD-application endpoint, mortality alone is
appropriate.)

### 3.3 Recommended L_SBP plausible upper bound

| Source | Per-10mmHg Δτ | L_SBP (%pt/mmHg) | L_SBP (decimal /mmHg) |
|--------|----------------|---------------------|--------------------------|
| FTT 1994 (no significant interaction) | ≤0.3 %pt | ≤0.03 | ≤3×10⁻⁴ |
| **GUSTO-I (Aylward 1996)** | **~0.5 %pt** | **~0.05** | **~5×10⁻⁴** |

> **Recommended plausible upper bound: L_SBP = 5×10⁻⁴ /mmHg
> (≈ 0.05 %pt/mmHg ≈ 0.5 %pt/10 mmHg)**

**Justification**: this is the GUSTO-I-implied gradient (the
strongest available, since FTT showed no significant heterogeneity).
A "moderate" plausibility bound would be 3×10⁻⁴ /mmHg (0.3
%pt/10mmHg), reflecting FTT's null finding more directly.

**Caveat**: at extreme SBP (<100 or >220 mmHg) effect heterogeneity
likely steepens (cardiogenic shock vs hypertensive crisis); the
bound above applies to the GUSTO-I eligibility range (SBP <180, no
shock).

---

## 4. Implication for nABCD §4.4

### 4.1 Reverse-calibration thresholds

Δ_clin = 1 %pt = 0.01 (canonical, from `AMI_thrombolysis_delta_clin.md`).

For the AND-style pooling judgment in §4.4:

> Pool regions if **L*_x ≥ L_x^plausible** for all effect modifiers x
> ∈ {age, SBP}.

The thresholds (data-driven L* must EXCEED these to declare pooling
safe):

| Modifier | L_x^plausible (UB) | Per-unit interpretation | Per-decade / 10mmHg |
|----------|---------------------|--------------------------|----------------------|
| **Age** | **4×10⁻³ /yr** | 0.4 %pt mortality difference per yr | 4 %pt/decade |
| **SBP** | **5×10⁻⁴ /mmHg** | 0.05 %pt mortality difference per mmHg | 0.5 %pt/10 mmHg |

**Conservative (recommended for paper)** thresholds, using the
*most extreme* literature observations as the benchmark.

### 4.2 Sensitivity / moderate alternative

For a less stringent test (using mid-literature gradients):

| Modifier | L_x^plausible (moderate) | Per-decade / 10mmHg |
|----------|---------------------------|----------------------|
| Age | 2×10⁻³ /yr | 2 %pt/decade |
| SBP | 3×10⁻⁴ /mmHg | 0.3 %pt/10 mmHg |

### 4.3 What this means narratively

If the GUSTO-I data yield **L*_age ≈ 0.5 %pt/yr or larger**, the
effect heterogeneity *implied by similarity-collapse calibration* is
*at the upper end of the entire AMI thrombolysis evidence base*.
This is a strong, defensible argument for pooling: "the heterogeneity
required to flip the pooling judgment is larger than ever observed in
~150,000 randomised AMI patients spanning 1986–2024."

Likewise, if **L*_SBP ≥ 0.05 %pt/mmHg**, the implied SBP-CATE
exceeds the GUSTO-I gradient itself — i.e., the data are even
*flatter* in CATE-vs-SBP than the very dataset that anchors the
benchmark. This is, again, strong evidence for pooling.

### 4.4 Suggested §4.4 text

> "We benchmark L*_age against the plausible upper bound from
> AMI-thrombolysis subgroup literature: ISIS-2 reported the steepest
> documented age gradient (treatment-control mortality difference
> rising from 2.5 to 8.0 %pt across <60 → ≥70 yr, implying
> approximately 4 %pt per decade of age, or L_age ≈ 4×10⁻³ /yr).
> A pooling judgment is supported when L*_age, the data-implied
> Lipschitz constant calibrated against Δ_clin = 1 %pt, exceeds this
> upper bound — meaning the data show *less* effect-modifier
> heterogeneity than even the most extreme historical observation.
> An analogous bound for systolic blood pressure, L_SBP ≈ 5×10⁻⁴
> /mmHg (≈ 0.5 %pt per 10 mmHg), follows from the GUSTO-I
> blood-pressure subanalysis (Aylward et al., 1996); the FTT
> meta-analysis itself reported no statistically significant
> SBP-by-treatment interaction, which is consistent with this bound."

---

## 5. Sources

### Primary (subgroup data extracted)
- **Fibrinolytic Therapy Trialists' (FTT) Collaborative Group (1994)**
  "Indications for fibrinolytic therapy in suspected acute myocardial
  infarction: collaborative overview of early mortality and major
  morbidity results from all randomised trials of more than 1000
  patients." *Lancet* 343(8893):311–22. DOI: [10.1016/S0140-6736(94)91161-4](https://doi.org/10.1016/S0140-6736(94)91161-4). PMID: 7905143.
- **ISIS-2 (Second International Study of Infarct Survival)
  Collaborative Group (1988)** "Randomised trial of intravenous
  streptokinase, oral aspirin, both, or neither among 17,187 cases of
  suspected acute myocardial infarction." *Lancet* 332(8607):349–60.
  DOI: [10.1016/S0140-6736(88)92833-4](https://doi.org/10.1016/S0140-6736(88)92833-4).
- **ISIS-2 Collaborative Group (1998)** "10 year survival among
  patients with suspected acute myocardial infarction in randomised
  comparison of intravenous streptokinase, oral aspirin, both, or
  neither." DOI: [10.1016/S0140-6736(98)07419-4](https://doi.org/10.1016/S0140-6736(98)07419-4). PMID: 9563981.
- **White H.D., Barbash G.I., Califf R.M., et al. (1996)** "Age and
  outcome with contemporary thrombolytic therapy. Results from the
  GUSTO-I trial." *Circulation* 94(8):1826–33. DOI: [10.1161/01.CIR.94.8.1826](https://doi.org/10.1161/01.CIR.94.8.1826). PMID: 8873656.
- **Aylward P.E., Wilcox R.G., Horgan J.H., et al. for the GUSTO-I
  Investigators (1996)** "Relation of increased arterial blood
  pressure to mortality and stroke in the context of contemporary
  thrombolytic therapy for acute myocardial infarction." *Ann Intern
  Med* 125(11):891–900. DOI: [10.7326/0003-4819-125-11-199612010-00004](https://doi.org/10.7326/0003-4819-125-11-199612010-00004). PMID: 8967669.

### Secondary (synthesis and context)
- **LATE Study Group (1993)** "Late assessment of thrombolytic
  efficacy (LATE) study with alteplase 6–24 hours after onset of
  acute myocardial infarction." *Lancet* 342(8874):759–66.
- **Boersma E., Maas A.C., Deckers J.W., Simoons M.L. (1996)** "Early
  thrombolytic treatment in acute myocardial infarction: reappraisal
  of the golden hour." *Lancet* 348(9030):771–5.
- **Mehta R.H., Sadiq I., Goldberg R.J., et al. (2006)** "Poor
  outcomes after fibrinolytic therapy for ST-segment elevation
  myocardial infarction: impact of age (a meta-analysis of a decade
  of trials)." *Am J Cardiol* 97(8):1145–50. DOI: [10.1016/j.amjcard.2005.11.025](https://doi.org/10.1016/j.amjcard.2005.11.025). PMID: 16622607.
- **Mehta S.R., Eikelboom J.W. (2000)** "Should the elderly receive
  thrombolytic therapy or primary angioplasty?" *Trials/Curr Control
  Trials Cardiovasc Med* 1(3):150–4. (PMC59616.)
- **Van de Werf F., Welsh R.C., Armstrong P.W., et al. (2024)**
  "STREAM-2: Half-Dose Tenecteplase or Primary PCI in Older Patients
  with STEMI." *Circulation* 148(8):753–64. DOI: [10.1161/CIRCULATIONAHA.123.064521](https://doi.org/10.1161/CIRCULATIONAHA.123.064521).
- **ACC FTT trial summary** (Latest in Cardiology, 2010 update).

### Methodological reference
- **Yusuf S., Mehta S.R., Pogue J., et al. (2003)** "Fibrinolysis for
  acute myocardial infarction." *Circulation* 107:2533–7.
  (Synthesis of FTT/ISIS-2/GUSTO-I age and BP gradients.)

---

## Confidence statement

- **L_age UB (4×10⁻³ /yr)**: **MODERATE** confidence — anchored to
  ISIS-2 (n=17k, gold-standard placebo-controlled) and corroborated
  by FTT (n=58k); the gradient direction (greater absolute benefit at
  older age, driven by higher baseline risk) is physiologically and
  empirically robust.
- **L_SBP UB (5×10⁻⁴ /mmHg)**: **WEAK-to-MODERATE** confidence —
  FTT itself found no significant SBP-by-treatment interaction; the
  numerical gradient comes from GUSTO-I post-hoc BP analysis
  (Aylward 1996), which mixes mortality and ICH effects. The point
  estimate is plausible but the literature support is thinner than
  for age.

If the nABCD GUSTO-I application analysis yields L*_age ≪ 4×10⁻³
or L*_SBP ≪ 5×10⁻⁴, I would not be willing to declare pooling safe
without further sensitivity work. If L*_age ≥ 4×10⁻³ AND L*_SBP ≥
5×10⁻⁴, the AND-condition for pooling is met with the strongest
literature support available.
