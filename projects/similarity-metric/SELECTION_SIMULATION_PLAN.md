# Simulation Study Plan — Pooling-Partner Selection and Pooled-Region Formation

**Question (Tak):** Under virtual scenarios where several countries each have their
own effect-modifier (EM) distribution — some similar to an anchor, some not — can a
distributional metric (W₁) recover the truly-similar countries *more correctly than*
competing methods?

Two **task formulations**, because the literature contains both (Tak, 2026-07-12):

- **Part 1 — anchor-centric selection.** One anchor region; rank the candidates by
  anchor-to-candidate distance and pool the nearest. This uses only the anchor's row
  of the distance matrix. Corresponds to "which regions may be pooled into the
  pivotal region?"
- **Part 2 — pooled-region formation by clustering.** No anchor; build the FULL
  pairwise distance matrix over all countries and partition them by clustering.
  This is exactly Komiyama et al. (2024) Ch.4 §4.6.1.2.

**Competitors.** Earlier versions compared only distance *metrics* (W₁ / SMD / KS).
That is insufficient: a reviewer will ask why the comparison omits the concrete
existing *procedure*. We therefore add the representative-value (RV) distance of
Komiyama et al. (2024) Ch.4 §4.6.1.1 — and we must be precise about what that
chapter does and does not say (Tak, 2026-07-12: 「小宮山を拡大解釈しすぎないように」;
full audit in `EXISTING_METHODS_AND_NOVELTY.md`).

**What Ch.4 says.** "Let a region have **a representative value in each candidate
parameter of effect modifier** and plot regions on the parameter space", then take a
Euclidean/Manhattan distance after standardizing each coordinate to N(0,1) across
regions. "Candidate parameter of effect modifier" means **the candidate EM itself**,
not a parameter of its distribution — proved twice in the chapter: *"ten candidate
parameters of the effect modifier … on a **ten-dimension space**"* (one axis per EM),
and the §4.6.1.4 worked example whose axes are *"the proportion of male patients and
that of younger patients"* (one summary number per EM). **The chapter never discusses
the spread or shape of a within-region EM distribution.**

Hence, for a single continuous EM:

- **RV1 = (mean)** — **this is Ch.4's recipe as written.** Its distance is a function
  of the location summary alone, so it inherits SMD's blind spot exactly. This is the
  only variant the paper may attribute to Komiyama et al.
- **RV2 = (mean, SD)** — an extension **Ch.4 does not propose**. We grant it in
  advance because it is the natural reviewer rebuttal ("just add another summary").
- **RV3 = (mean, SD, skew)** — likewise **not** proposed in Ch.4; pre-empts "then add
  another moment."

> ⚠️ An earlier internal note (2026-06-27) misread "parameter" as *distributional*
> parameter and labelled RV2 as "Komiyama's method". That was wrong and is corrected
> here. **Never call RV2/RV3 Komiyama's method** — doing so cites them for a claim
> they never made.

**Framework:** ADEMP (Morris, White & Crowther 2019, *Stat Med* 38:2074–2102,
DOI: 10.1002/sim.8086). Scope = **Q_metric** (recovery of true EM-distributional
similarity from finite samples). No outcome/CATE model is used, and **no θ (treatment
effect as a function of the EM) is posited** — deliberately.

### Why no θ, and why there is no "Part 3" (Tak, 2026-07-12 — a scope decision, not an omission)

It is tempting to add an effect-tracking study: posit an explicit Lipschitz θ, compute
the true regional effect difference |E_A θ − E_B θ|, and check that W₁ tracks it. **We
do not, for three reasons, and the first is decisive.**

1. **It would be verifying a premise, not a claim.** An effect modifier *is*, by
   definition, a characteristic for which the treatment benefit differs across its
   levels. "Regions with different EM distributions have different average treatment
   effects" therefore **follows from the object being an EM at all** — it is the
   setting of the problem, not a proposition this paper argues for. A simulation that
   confirms it confirms a definition. (Whether the EM–effect relationship is *known* or
   *unknown* varies by programme; what does not vary is that, given an EM, a
   distributional difference implies an effect difference.)
2. **It would destroy the generality of the result.** The Kantorovich–Rubinstein bound
   holds for **every** 1-Lipschitz θ — the paper never has to name the dose–response
   shape. Simulate one, and the conclusion becomes conditional on that shape, inviting
   exactly the question we can currently answer with "any Lipschitz θ".
3. **Circularity.** By KR duality, W₁ = sup over 1-Lipschitz θ of |E_A θ − E_B θ|. A θ
   chosen freely makes W₁ optimal *by definition*, so "W₁ tracks the effect difference
   best" would be a restatement of the theorem, not evidence for it. Escaping that
   requires pre-specifying several θ shapes including a saturating one — at which point
   the study is testing the shape of θ, which is a different paper.

**What this scope buys, and what it costs.** The simulation shows that W₁ is **never
blind** where the competitors are — an identification claim about the metric. It does
not, and does not need to, re-derive that EM differences move treatment effects. The one
honest consequence to disclose (see Reporting plan): where θ **saturates**, the
KR bound remains **valid but loose**, so W₁ over-flags. That is a *conservative* error —
it errs toward not pooling — and in a regulatory setting a conservative bound is the
intended behaviour, not a defect.

**Design principle (Tak, realism):** All countries within a scenario set share the
**same distributional family** — a single endpoint cannot be Gaussian in nine
regions and log-normal in one. Four scenario sets, each aimed at a specific
competitor:

- **Set 1 — Gaussian world:** every country Normal; discordance in location / scale.
- **Set 2 — Skewed world:** every country log-normal (a realistic skewed biomarker,
  e.g. ALT); discordance in location / dispersion-and-shape.
- **Set 3 — Mixture world (moment-matched):** every country a two-component Gaussian
  mixture (e.g. a genotype sub-population — fast/slow metabolisers — whose mixing
  proportion differs by region). Every candidate matches the anchor **exactly on
  mean (50) and SD (10)**; only the shape differs. **Target: the moment-based methods
  (SMD, RV).**
- **Set 4 — Extremes world (rare displaced mass):** every country a bulk population
  plus a rare severely-low and a rare severely-high subgroup. Regions differ in **how
  severe** and **how many** their extreme patients are. **Target: KS.**

**The layered argument, and why it is forced rather than lazy.** Set 3 blinds the
moment methods but leaves W₁ and KS side by side — and KS is older and simpler, so a
reviewer will ask "then why not just use KS?" Set 4 answers that. **No single scenario
blinds both**, and this is not for want of trying: a cell that blinds KS *and* the SD
simultaneously is **impossible in this family**, because variance responds to
displacement quadratically while W₁ responds linearly, so matching the SD forces the
bulk to collapse — which is itself a large, narrow CDF gap, and KS reappears (0.213).
Hence: **Set 3 kills the moment methods, Set 4 kills KS, and W₁ is the only metric that
survives both.**

**Why Set 3 is not optional.** Sets 1 and 2 are both **two-parameter families**:
(mean, SD) determines the whole distribution, so a fair RV2 method (our extension, not Ch.4) can
detect *every* discordant country there — including the log-normal "shape" ones,
whose skewness is a deterministic function of (mean, SD). (Audit: Set 2's Dp1 holds
mean = 50 but moves SD 20 → 30; the SD axis alone separates it.) Against a fair
RV2 baseline, W₁ therefore has **no structural advantage in Sets 1–2**, and we
report that honestly. The question a moment-list method cannot answer is *which*
moments must be enumerated. Set 3 answers it: the symmetric-mixture countries match
the anchor on mean, SD **and skewness**, so even RV3 is blind, while
W₁ and KS see the CDF gap. Set 3 is a **stress test / worst case**, not a claim that
moment-matching is typical — the "identical mean *and* SD" construction is
deliberately adversarial, and is labelled as such.

---

## Table 1 — ADEMP overview

| Element | Specification |
|---|---|
| **A — Aims** | Establish **where each candidate metric is structurally blind**, and show that W₁ is the only one that is never blind. Specifically: (i) characterise each method's recovery of the true pooling structure by discordance type and sample size; (ii) show that representative-value / moment methods carry no information once the enumerated moments are matched (Set 3); (iii) show that KS carries no information once a rare mass is displaced far (Set 4); (iv) report every cell where W₁ is matched or beaten. **Not** aimed at showing W₁ is *right* — that needs a θ and is out of scope (see Framework). |
| **D — Data-generating mechanisms** | Four worlds, one distributional family each (Tables 2a–2d). **Part 1**: 10 countries = 1 anchor + 9 candidates (3 true matches + 6 discordant). **Part 2**: 12 countries = 3 true groups of 4. EM sampled i.i.d.; sample size `n` per country varied. Set 1 Gaussian; Set 2 log-normal; Set 3 two-component Gaussian mixture (moment-matched); Set 4 three-component mixture (bulk + rare low/high extremes). |
| **E — Estimand / target** | **Part 1**: the true poolable set S\* = {candidates drawn from the anchor's population}. **Part 2**: the true partition of the 12 countries into the populations they were drawn from. Both fixed **by construction** (metric-independent → non-circular). |
| **M — Methods** | Distances (Table 3): W₁, KS, SMD (raw; + log in Set 2), and three representative-value variants — **RV1 = (mean)**, which is Komiyama Ch.4 as written, plus **RV2 = (mean, SD)** and **RV3 = (mean, SD, skew)**, which the chapter does **not** propose and which we grant in advance. **Part 1** ranks candidates by anchor-to-candidate distance and takes the k nearest. **Part 2** clusters the full pairwise distance matrix with the algorithm held fixed (average linkage, k = true number of groups) so that only the distance varies. |
| **P — Performance measures** | Threshold-free (Table 4). **Part 1**: AUC per discordance type (primary — k-free and tie-fair), precision@k, false-pooling@k. **Part 2**: adjusted Rand index, exact-recovery rate. All with Monte Carlo SE; no method-vs-method significance tests. |

---

## Table 2a — Set 1, Gaussian world (anchor = N(50, 10²))

All true W₁ / KS below are the values the code actually produces (numerical integration
of |F_A − F_B|; grid sup for KS), verified by `R/validate_plan.R`.

| Country | EM distribution | Construction label (= truth) | Discordance type | Δmean | true W₁ | true KS | SMD-detectable? |
|---|---|---|---|---|---|---|---|
| A0 | N(50, 10²) | anchor | — | — | — | — | — |
| G1–G3 | N(50, 10²) | **MATCH** (poolable) | — | 0 | 0.000 | 0.000 | — |
| L1 | N(55, 10²) | discordant | location (0.5σ) | 5 | 5.000 | 0.197 | yes |
| L2 | N(58, 10²) | discordant | location (0.8σ) | 8 | 8.000 | 0.311 | yes |
| V1 | N(50, 16²) | discordant | scale (1.6×) | **0** | 4.787 | 0.112 | **no** |
| V2 | N(50, 20²) | discordant | scale (2.0×) | **0** | 7.979 | 0.161 | **no** |
| X1 | N(56, 14²) | discordant | location + scale | 6 | 6.234 | 0.231 | partial |
| X2 | N(54, 13²) | discordant | location + scale (mild) | 4 | 4.254 | 0.167 | partial |

Symmetric family → no shape/skew discordance (Gaussians cannot skew); that role
belongs to Set 2. SMD's blind spot here is **scale** (V1, V2), which share the anchor's
mean exactly. RV1 (Ch.4 as written) inherits that blind spot — see Reading §1.

---

## Table 2b — Set 2, Skewed world (anchor = LogN, mean 50, CV 0.40; sd 20, median 46.4, skew 1.26)

SD and skew below are **analytic**, from (mean *m*, CV *c*): SD = *mc*, skew = (*c*² + 3)*c*.
They are not sample estimates — the log-normal's heavy tail makes the sample skewness
noticeably unstable even at 10⁶ draws, so the plan carries the exact values.

| Country | EM distribution | Construction label (= truth) | Discordance type | Δmean | SD | skew | true W₁ | true KS | SMD (raw / log) detects? |
|---|---|---|---|---|---|---|---|---|---|
| A0 | LogN(mean 50, CV 0.40) | anchor | — | — | 20.00 | 1.264 | — | — | — |
| G1–G3 | LogN(mean 50, CV 0.40) | **MATCH** (poolable) | — | 0 | 20.00 | 1.264 | 0.000 | 0.000 | — |
| Lm1 | LogN(mean 55, CV 0.40) | discordant | location | 5 | 22.00 | 1.264 | 5.000 | 0.098 | yes / yes |
| Lm2 | LogN(mean 58, CV 0.40) | discordant | location | 8 | 23.20 | 1.264 | 8.000 | 0.153 | yes / yes |
| Dp1 | LogN(mean 50, CV 0.60) | discordant | dispersion + shape | **0** | 30.00 | 2.016 | 6.744 | 0.132 | **no** / weak |
| Dp2 | LogN(mean 50, CV 0.85) | discordant | dispersion + shape | **0** | 42.50 | 3.164 | 13.950 | 0.245 | **no** / weak |
| Cx1 | LogN(mean 55, CV 0.65) | discordant | location + dispersion | 5 | 35.75 | 2.225 | 9.603 | 0.106 | partial / partial |
| Cx2 | LogN(mean 53, CV 0.55) | discordant | location + dispersion (mild) | 3 | 29.15 | 1.816 | 5.821 | 0.070 | partial / partial |

Constructed by fixing the mean and varying CV: raising CV at fixed mean lowers the
median and raises skew (Dp1 skew 2.02, Dp2 skew 3.16), so raw SMD (Δmean = 0) is
blind. **Log-scale SMD** picks up only a tiny residual mean shift and stays blind to the
dispersion → the failure is structural, not a missing transform. W₁ and KS resolve all
discordance types here.

⚠️ **But note what a *fair* RV baseline does here.** Raising CV at fixed mean also
moves the SD (20 → 30 → 42.5). RV2 separates Dp1/Dp2 on the SD axis alone.
Set 2 defeats *SMD* and *RV1*, not RV2. Hence Set 3.

---

## Table 2c — Set 3, Mixture world (every country: mean 50, SD 10)

Two-component Gaussian mixture `w·N(m₁,s) + (1−w)·N(m₂,s)`, parameterised by the
mixing weight `w` and the component gap `d = m₁ − m₂`, with `s` solved so that the
overall mean and variance hit the anchor's:
`var = s² + w(1−w)d²`, `skew = w(1−w)(1−2w)d³ / var^{1.5}`.
Setting `w = 0.5` forces skew = 0 → those countries match the anchor's **first three
moments**. Moments below verified from 10⁶ draws (`selection_sim.log`).

| Country | w | d | mean | SD | skew | true W₁ | RV2 sees? | RV3 sees? |
|---|---|---|---|---|---|---|---|---|
| A0 | 0.50 | 6 | 50.0 | 10.0 | 0.00 | anchor (≈ unimodal) | — | — |
| G1–G3 | 0.50 | 6 | 50.0 | 10.0 | 0.00 | 0.000 | — | — |
| B1 | 0.50 | 15 | 50.0 | 10.0 | 0.00 | 0.686 | **no** | **no** |
| B2 | 0.50 | 19 | 50.0 | 10.0 | 0.00 | 3.015 | **no** | **no** |
| S1 | 0.75 | 16 | 50.0 | 10.0 | −0.386 | 0.910 | **no** | yes |
| S2 | 0.85 | 19 | 50.0 | 10.0 | −0.614 | 1.262 | **no** | yes |
| C1 | 0.70 | 18 | 50.0 | 10.0 | −0.492 | 1.633 | **no** | yes |
| C2 | 0.80 | 17 | 50.0 | 10.0 | −0.472 | 1.035 | **no** | yes |

B1/B2 are symmetric bimodal (mean, SD **and** skew all equal to the anchor's);
S1/S2 place a minority sub-population low (skew differs); C1/C2 do both.
Because every country shares the anchor's (mean, SD), **RV2 assigns identical
coordinates to all ten countries** — its distance matrix carries no signal at all.

Note the price of the construction: holding (mean, SD) fixed caps how far the shapes
can move, so the true W₁ values here (0.69–3.02) are smaller than Set 1's (4.8–8.0).
The theoretical ceiling under matched (mean, SD) is ≈ 5.35 (a two-point limit).
**Detection is therefore genuinely hard for every method** — the point of Set 3 is the
*qualitative* split (moment-based ≈ chance, distribution-based above it), not a high
absolute score.

---

## Table 2c-bis — Set 4, Extremes world (the W₁-vs-KS test)

Family (one functional form for every country):

$$X \sim (1-\varepsilon_L-\varepsilon_H)\,N(\mu_0,\sigma_0^2) \;+\; \varepsilon_L\,N(\mu_0-\Delta_L,\sigma_t^2) \;+\; \varepsilon_H\,N(\mu_0+\Delta_H,\sigma_t^2)$$

with $\sigma_0 = 10$ (bulk) and $\sigma_t = 8$ (extreme subgroups) fixed across the
world. Anchor: $\mu_0 = 50$, $\varepsilon_L = \varepsilon_H = 0.05$,
$\Delta_L = \Delta_H = 40$.

**The mechanism, in closed form.** When only the extreme *locations* move, the bulk
term cancels exactly and the two lobes of $F_A - F_B$ have disjoint support, so:

$$W_1 = \varepsilon_L\delta_L + \varepsilon_H\delta_H \qquad\text{(linear, unbounded)}$$
$$\mathrm{KS} = \max_{j\in\{L,H\}}\ \varepsilon_j\Big(2\Phi\big(\tfrac{\delta_j}{2\sigma_t}\big)-1\Big) \qquad\text{(saturates at } \varepsilon\text{)}$$

The sup is a **max, not a sum** — KS cannot even accumulate across the two extremes.
$2\Phi(\delta/2\sigma_t)-1 \to 1$ geometrically, so once $\delta \gtrsim 5\sigma_t$, KS
is within 1 % of $\varepsilon$ and **stops responding entirely** while W₁ keeps growing.
Doubling the displacement (±30 → ±60) **doubles W₁ and moves KS by 6 %**. Both formulas
verified against numerical integration to 4 dp.

| Country | role | $\varepsilon_L,\Delta_L$ | $\varepsilon_H,\Delta_H$ | $\mu_0$ | mean | SD | \|Δmean\| | **true W₁** | **true KS** |
|---|---|---|---|---|---|---|---|---|---|
| A0 | anchor | .05, 40 | .05, 40 | 50 | 50.0 | 16.0 | — | — | — |
| G1–G3 | **match** | .05, 40 | .05, 40 | 50 | 50.0 | 16.0 | 0.00 | 0.000 | 0.000 |
| T1 | sym_severity | .05, 70 | .05, 70 | 50 | 50.0 | 24.2 | **0.00** | **3.000** | **0.047** |
| T2 | sym_severity | .05, 100 | .05, 100 | 50 | 50.0 | 33.1 | **0.00** | **6.000** | **0.050** |
| P1 | sym_prevalence | .12, 40 | .12, 40 | 50 | 50.0 | 21.8 | **0.00** | 4.483 | 0.067 |
| P2 | asym_severity | .05, 40 | .05, 100 | 50 | 53.0 | 25.8 | 3.00 | 3.000 | 0.050 |
| S1 | bulk_shift *(control)* | .05, 40 | .05, 40 | 52 | 52.0 | 16.0 | 2.00 | 2.000 | **0.072** |
| S2 | bulk_shift *(control)* | .05, 40 | .05, 40 | 53 | 53.0 | 16.0 | 3.00 | 3.000 | **0.107** |

**Read the |Δmean| column.** T1, T2 and P1 have Δmean = **0 exactly**, yet W₁ > 0 — the
CDFs *cross* (one lobe positive, one negative), so SMD and RV1 have **no coordinate at
all**. This is why a two-sided design is used rather than the obvious one-sided tail:
with a one-sided tail, W₁ turns out to equal |Δmean| identically and a reviewer answers
"then just use the mean."

**The rank inversion (population-level, exact).** KS(S1) = **0.072** > KS(T2) =
**0.050**. KS therefore calls *shifting every patient by 2 units* **more discordant**
than *pushing 10 % of patients 60 units further into both extremes*. W₁ says T2 is
**3× worse** (6.00 vs 2.00) — and by the Kantorovich–Rubinstein bound it *is* 3× worse.

**The theorem behind it (n-free; no simulation, no adversarial θ).**
KS admits no KR-type bound: there is no finite $C$ with $|\Delta\theta| \le C\cdot\mathrm{KS}$
for all 1-Lipschitz θ. *Proof:* take $\theta(x) = x$ — a linear exposure–response, the
most natural clinical form there is. Under tail displacement $|\Delta\theta| = \varepsilon\delta$
while $\mathrm{KS} \le \varepsilon$, so $|\Delta\theta|/\mathrm{KS} \ge \delta \to \infty$. ∎
(Choosing θ adversarially would make W₁ win *by definition* via KR duality; this proof
does not, which is the point.)

**Clinical reading.** eGFR for a renally-cleared drug: a bulk of adequately-functioning
patients plus a rare severely-impaired minority (and, at the other end, augmented renal
clearance). Regions differ in how severe their impaired minority is (5 % at eGFR 40 vs
5 % at eGFR 10) and how many are impaired. Exposure ∝ 1/eGFR, so the exposure–response
slope $L$ is steep **exactly where the rare mass sits** — these are the patients who
accumulate drug and whose benefit–risk inverts. W₁ is measured in mL/min/1.73m², the
units in which Δ_max is elicited; **KS returns 0.05 and cannot be converted into
anything.**

---

## Table 2d — Part 2 roster (clustering): 12 countries, 3 true groups of 4

| Set | Group A (×4) | Group B (×4) | Group C (×4) | Who cannot separate the groups? |
|---|---|---|---|---|
| Set 1 Gaussian | N(50, 10²) | N(58, 10²) | N(50, 20²) | RV1 / SMD (group C shares A's mean) |
| Set 2 Log-normal | mean 50, CV 0.40 | mean 58, CV 0.40 | mean 50, CV 0.85 | RV1 / SMD (same reason) |
| Set 3 Mixture | w=0.50, d=6 | w=0.50, d=19 | w=0.85, d=19 | **all RV variants + SMD** — every country has mean 50, SD 10 (A vs B are skew-matched too, so RV3 fails as well) |
| Set 4 Extremes | ±40 extremes | ±70 extremes | ±100 extremes | **KS** — its population distances are nearly constant off-diagonal (0.047 / 0.050 / 0.047), carrying no cluster structure |

Set 4's W₁ distances form a clean ladder (A–B 3.0, A–C 6.0, B–C 3.0) while KS's matrix
is degenerate — the exact **mirror** of Set 3, where it is the representative-value
coordinates that are identical across all 12 countries.

---

## Table 3 — Methods compared

| Method | Anchor-to-candidate distance | Sees | Blind to |
|---|---|---|---|
| **W₁** | Sample Wasserstein-1, `(1/n)Σ|x₍ᵢ₎−y₍ᵢ₎|` (equal n) | full distribution | — |
| **SMD (raw)** | \|mean(x)−mean(y)\| / pooled SD | location (mean) only | scale, shape |
| **SMD (log)** — Set 2 only | same on log-transformed data | location on log scale | dispersion/shape |
| **KS** | sup\|F̂_x − F̂_y\| | full distribution (sup-norm) | weaker on tail mass than W₁ |
| **RV1 (mean)** — **Komiyama §4.6.1.1 as written** | each country → one representative value; standardized to N(0,1) **across the roster**; Euclidean | location only | scale, shape — **the same blind spot as SMD** |
| **RV2 (mean, SD)** — *our extension, not in Ch.4* | two coordinates, same construction | whatever the two moments encode — in a 2-parameter family, the whole distribution | any feature not spanned by the listed coordinates |
| **RV3 (mean, SD, skew)** — *our extension, not in Ch.4* | three coordinates | + skewness | shape beyond the 3rd moment (e.g. symmetric bimodality); and the extra coordinate costs accuracy where two suffice |

Selection (Part 1) = rank the 9 candidates by the method's distance; the `k` nearest
are the proposed pooling partners. Clustering (Part 2) = cluster the full 12×12
distance matrix.

**Deliberate asymmetry, stated up front.** RV is roster-standardized, KS is bounded
in [0,1], W₁ is on the raw EM scale. This is not an oversight: each method is
implemented as its own source defines it. Standardization is *intrinsic* to the
Komiyama recipe (it is what makes different EM parameters commensurable), whereas W₁
is deliberately left on the EM's clinical scale — that is the property Δ_max
calibrates. Rescaling W₁ to "match" the others would destroy the very quantity the
paper's theory is about.

---

## Table 4 — Performance measures (threshold-free)

| Measure | Definition | Direction | Rationale |
|---|---|---|---|
| **precision@k** | fraction of the k = \|S*\| nearest that are true matches | higher better | recovery of the poolable set |
| **false-pooling@k** | P(≥1 discordant enters the top-k, displacing a match) | lower better | the safety-relevant error |
| **AUC per discordance type** | P(a true-match distance < a type-t discordant distance) | 1 = perfect, 0.5 = blind | isolates which discordance each method resolves |
| **adjusted Rand index** (Part 2) | Hubert–Arabie ARI between the recovered partition and the construction partition | 1 = exact, 0 = chance | recovery of the pooled-region structure |
| **exact recovery** (Part 2) | P(ARI = 1) | higher better | how often the whole partition is right |

Metrics live on incommensurable scales, so **only within-method rankings are used** —
no shared or per-metric distance threshold.

**Part 2 fairness constraint (the reviewer's first objection).** The clustering
ALGORITHM is held fixed across methods — same linkage (average), same number of
clusters (k = the true number of groups) — and **only the distance matrix is
swapped**. Any ARI difference is therefore attributable to the distance, not to
clustering choices. Handing every method the true `k` is *generous to the baselines*:
it gives them the answer to §4.6.1.3 (how many pooled regions) for free.

**Lead with AUC.** AUC is both threshold-free *and* $k$-free, and scores ties fairly.
precision@k / false-pooling@k are reported as the intuitive illustration, with the
explicit caveat that they assume the oracle $k = |S^*|$ is known. Method differences
are reported with Monte Carlo standard errors; **no formal method-vs-method
significance tests** are run — with simulated data any p-value can be manufactured by
adding replications, so effect sizes with MC SE are the honest summary.

---

## Table 5 — Factors and simulation controls

Every row below is **machine-checked against the code** by `R/validate_plan.R` — if the
plan and the implementation disagree, that script fails. The plan is the source of
truth; the code must match it, not the other way round.

| Item | Setting |
|---|---|
| Scenario sets (families) | **Four**, reported separately: Set 1 Gaussian · Set 2 log-normal · Set 3 mixture (moment-matched) · Set 4 extremes (rare displaced mass) |
| Task formulations | **Part 1** anchor-centric selection (10 countries: 1 anchor + 9 candidates, 3 true matches) · **Part 2** pooled-region formation by clustering (12 countries, 3 true groups of 4) |
| Sample size per country `n` | {25, 50, 75, 100} (equal across countries; small-n emphasis — realistic regional subgroups) |
| Methods | W₁ · KS · SMD (raw) · **RV1 (mean) = Ch.4 as written** · RV2 (mean, SD) · RV3 (mean, SD, skew). Set 2 additionally reports SMD on the log scale. |
| Discordance types (Part 1) | Set 1: location, scale, combined · Set 2: location, shape/dispersion, combined · Set 3: shape_sym, shape_skew, combined · Set 4: sym_severity, sym_prevalence, asym_severity, bulk_shift — **each reported separately** |
| Monte Carlo repetitions | **Part 1: 10,000** per cell · **Part 2: 5,000** per cell. Achieved MC SE (reported per estimate): **Part 1 ≤ 0.005** (max 0.0050) · **Part 2 ARI ≤ 0.004** (max 0.0039). The one exception is Part 2's **exact-recovery rate**, a proportion whose SE at 5,000 reps peaks at √(0.25/5000) = **0.0071** near p = 0.5 (observed max 0.0070) — a structural bound, not a deficiency. All headline claims rest on ARI and AUC, whose SEs are within 0.005; exact recovery is reported as a secondary, intuitive measure. |
| Clustering algorithm (Part 2) | `hclust(average linkage)` + `cutree(k = true k)`, **held fixed across methods**; only the distance matrix is swapped. Handing every method the true `k` is deliberately generous to the baselines. |
| Tie-breaking (Part 1) | ties in a method's distances broken at **random** under the cell seed, not by roster order (matches are listed first, so roster-order ties would spuriously flatter the correct answer — bites KS at small n where its statistic is discrete) |
| Seeding / reproducibility | per-cell seed set inside `run_cell`, serial execution ⇒ **bit-reproducible** (contrast: the per-EM W₁ operating-characteristic sim is aggregate-reproducible only, due to `parLapplyLB` + per-worker RNG) |
| Dependencies | pure base R (`rnorm`/`rlnorm`/`rbinom`/`rmultinom`/`sort`/`ks.test`/`integrate`/`hclust`); W₁ estimator equals the canonical integral-of-\|F₁−F₂\| to machine precision |
| True distributional references | analytic (numerical integration of \|F_A − F_B\|; grid sup for KS). Set 4 additionally has **closed forms** for W₁ and KS, verified against the integration to 4 dp. |
| Standardization asymmetry (deliberate) | RV is roster-standardized (intrinsic to Ch.4's recipe — it is what makes different EMs commensurable); KS is bounded in [0,1] by construction; W₁ is left on the EM's raw clinical scale (the quantity Δ_max calibrates). Rescaling W₁ to "match" would destroy what the theory is about. |
| Fixed | anchor distribution; roster composition; the σ constants within each world |
| Full-study extensions (not done) | multiple anchors; vary \|S\*\|; "near-match" countries for graded discrimination |
| **Deliberately out of scope** | An effect-tracking study positing an explicit θ. Not an omission — see "Why no θ" above: it would verify a *premise* (an EM's distribution differing implies its treatment effect differing — true by the definition of an effect modifier), it would make the result conditional on one dose–response shape when the KR bound holds for **all** Lipschitz θ, and by KR duality a freely-chosen θ makes W₁ optimal by construction. |

---

## Non-circularity guards (falsification checks)

1. **Metric-free truth.** The poolable set (Part 1) and the true partition (Part 2)
   are designer-set construction labels (drawn from the anchor's population: yes/no;
   which population each country came from), *not* "smallest true W₁" — the latter
   would rig it.
2. **Balanced types, reported separately.** All discordance types are present; the
   location types are a built-in control (SMD detects location, so all methods should
   score ≈1 there). Cherry-picking only SMD-blind types is prohibited.
3. **Steelman every competitor.** SMD gets its standard-practice log-transform
   (Set 2). Komiyama gets (mean, SD) — not a mean-only strawman — **and** a
   (mean, SD, skew) variant, i.e. the "just add another moment" patch is granted in
   advance rather than argued against. In Part 2 all methods are handed the true
   number of clusters.
4. **Report the cells where W₁ loses.** Sets 1–2 are two-parameter families where
   RV2 is expected to match or beat W₁; Part 2/Set 2 is expected to favour KS; Set 4's
   `bulk_shift` control is expected to favour KS (a tall, narrow CDF gap is the
   sup-norm's home turf); and Set 4's `asym_severity` cell is expected to favour RV3
   (variance scales as Δ², skewness as Δ³). These cells are pre-declared, not
   discovered post hoc, and are reported with the same prominence as the wins.
   `validate_figures.R` asserts them as CLAIM checks, so silently dropping them breaks
   the build.
5. **Set 4 handicaps W₁ on purpose.** The anchor's *own* 5 % contamination inflates
   W₁'s null through binomial tail-count mismatch — the null W₁ rises from 1.74 ± 0.62
   (uncontaminated) to **3.00 ± 1.03**, while KS's null barely moves (0.1182 → 0.1190).
   W₁ is therefore made to work against a ~70 % noisier baseline than it would
   otherwise face, and still wins. This is evidence *against* cherry-picking.
6. **Every set contains a control where the targeted competitor works.** Set 1/2's
   location types (SMD sees them), Set 3's `shape_skew` (RV3 sees it), Set 4's
   `bulk_shift` (KS sees it) and `asym_severity` (SMD and RV3 see it). Cherry-picking
   only the cells that blind the competitor is prohibited — a competitor that is at
   chance *everywhere* would indicate a rigged family, not a real blind spot.

---

## Production results

Part 1: 10,000 reps (`results/selection_sim_summary.csv`).
Part 2: 5,000 reps (`results/clustering_sim_summary.csv`). MC SE ≤ 0.005 throughout.

### Part 2 — clustering, adjusted Rand index at n = 100 (the headline table)

| Set | Target | W₁ | KS | **RV1 (Ch.4)** | RV2 | RV3 | SMD |
|---|---|---|---|---|---|---|---|
| 1 Gaussian | — | 0.995 | 0.983 | **0.489** | **0.996** | 0.620 | 0.452 |
| 2 Log-normal | — | 0.642 | **0.850** | **0.343** | 0.614 | 0.448 | 0.334 |
| 3 Mixture | moment methods | **0.526** | 0.503 | **−0.000** | **0.018** | **0.131** | **−0.000** |
| 4 Extremes | KS | **0.355** | **0.003** | **0.026** | 0.271 | 0.189 | **0.018** |

**Survivors of both Set 3 and Set 4 (ARI > 0.20 in each): W₁, and only W₁.**
KS clears Set 3 (0.503) but collapses in Set 4 (0.003). RV2 clears Set 4 (0.271) but
collapses in Set 3 (0.018). This is asserted directly in `validate_figures.R`, not left
to the reader's eye.

### Part 1 — selection, AUC at n = 100

Sets 1–3, combined-discordance type:

| Set | W₁ | KS | **RV1 (Ch.4)** | RV2 | RV3 | SMD | SMD(log) |
|---|---|---|---|---|---|---|---|
| 1 Gaussian | 0.985 | 0.957 | **0.951** | **0.988** | 0.847 | 0.947 | — |
| 2 Log-normal | **0.950** | 0.802 | **0.657** | 0.895 | 0.839 | 0.648 | 0.500 |
| 3 Mixture | **0.699** | 0.676 | **0.503** | 0.494 | 0.638 | 0.504 | — |

Set 4, by discordance type — note that **KS is at chance on both displaced-extreme
types** and **beats W₁ on the bulk-shift control**:

| Discordance | W₁ | KS | RV1 | RV2 | RV3 | SMD |
|---|---|---|---|---|---|---|
| sym_severity (extremes further out) | **0.972** | **0.511** | 0.620 | 0.921 | 0.912 | **0.502** |
| sym_prevalence (more patients extreme) | **0.903** | 0.680 | 0.566 | 0.774 | 0.716 | **0.503** |
| asym_severity (one extreme further out) | 0.947 | **0.504** | 0.719 | 0.885 | **0.985** | 0.641 |
| bulk_shift *(control — everyone shifts)* | 0.707 | **0.734** | 0.677 | 0.676 | 0.667 | 0.677 |

KS on `sym_severity` runs **0.500 → 0.511** from n = 25 to 100 — **flat**, the same
"gains no information" signature as RV1's fake scale detection — while W₁ runs
**0.837 → 0.972**. And `bulk_shift` is exactly the cell where KS *should* win (a tall,
narrow CDF gap is the sup-norm's home turf): it does, and it is reported.
false-pooling@k at n = 100: **W₁ 0.718 vs KS 0.971, SMD 0.972, RV1 0.953.**

**RV1 — the chapter's recipe as written — tracks SMD almost exactly** (ARI 0.489/0.343/
−0.000 vs SMD 0.452/0.334/−0.000). For a single continuous EM, one representative value
per modifier carries only location information, so Ch.4's distance and the SMD fail in
the same places. **This is the citation-faithful finding.** RV2/RV3 are extensions the
chapter does not propose.

**Set 3, by discordance type (n = 100)** — the decisive cells:

| Discordance | matched moments | W₁ | KS | RV1 | RV2 | RV3 | SMD |
|---|---|---|---|---|---|---|---|
| shape_sym (B1,B2) | mean, SD **and skew** | 0.759 | **0.772** | **0.508** | **0.453** | **0.434** | 0.506 |
| shape_skew (S1,S2) | mean, SD | **0.639** | 0.602 | **0.500** | **0.503** | 0.651 | 0.502 |
| combined (C1,C2) | mean, SD | **0.699** | 0.676 | **0.503** | **0.494** | 0.638 | 0.504 |

RV1 and RV2 sit at chance in **every** Set-3 cell — their coordinates are identical for
all ten countries. RV3 rescues the skewed types (0.65) but is *still* at chance on the
symmetric-bimodal type (0.434): the third moment matches too.

### Does the method LEARN? — ARI gain from n = 25 to n = 100 (Part 2)

The cleanest evidence in the study, because it separates **identification failure** from
**power failure**. A method that is merely under-powered improves as data accumulates. A
method that is structurally blind does not move at all.

| Set | W₁ | KS | RV1 | RV2 | RV3 | SMD |
|---|---|---|---|---|---|---|
| 1 Gaussian | +0.390 | +0.459 | +0.119 | +0.323 | +0.233 | +0.103 |
| 2 Log-normal | +0.310 | +0.416 | +0.193 | +0.341 | +0.262 | +0.184 |
| **3 Mixture** | +0.258 | +0.215 | **+0.001** | **+0.001** | +0.076 | **+0.001** |
| **4 Extremes** | +0.244 | **+0.003** | **+0.005** | +0.127 | +0.066 | **+0.001** |

In Set 3, quadrupling the sample moves RV1, RV2 and SMD by **0.001**. In Set 4 it moves
KS by **0.003**. They are not short of data — **there is no signal in their distance
matrices to find**, and there would be none at n = ∞ either. W₁ gains at least +0.24 in
every world. The same signature appears in Part 1's AUC (Set 4: KS 0.500 → 0.511 while
W₁ goes 0.837 → 0.972; Set 1 scale: RV1 0.623 → 0.619 while W₁ goes 0.932 → 0.997).

**This is what licenses the word "blind" instead of "underpowered".**

### Reading

0. **The headline: Set 3 kills the moment methods, Set 4 kills KS, and W₁ is the only
   metric that survives both.** In Set 3 the representative-value coordinates are
   identical across all 12 countries, so RV recovers no structure (ARI −0.000 / 0.018 /
   0.131) — but KS works (0.503). In Set 4 the KS distances are nearly constant
   off-diagonal, so KS recovers no structure (ARI **0.003**) — but RV2 works (0.271).
   Only W₁ is above 0.20 in both (0.526 and 0.355). The two blind spots are
   **complementary**, and a scenario blinding both is provably unavailable in these
   families — so the layered argument is forced, not lazy.

1. **Ch.4 as written (RV1) has SMD's blind spot.** For one continuous EM its distance
   is a function of the location summary alone. Clustering ARI 0.489 (Set 1) vs W₁ 0.995.
   *Subtlety worth stating precisely:* RV1's Set-1 **scale**-AUC is 0.62, not 0.50 — but
   that is **not detection**. All Set-1 countries share the true mean 50, so RV1's
   *population* distance to the anchor is exactly 0 for the scale countries; the 0.62
   comes from a wider country having a noisier sample mean. For independent
   X∼N(0,s₁), Y∼N(0,s₂), P(|X|<|Y|) = (2/π)·arctan(s₂/s₁) → 0.59 (V1) and 0.64 (V2),
   mean **0.623**, against **0.619** observed. The tell is that RV1's scale-AUC is
   **flat in n** (0.623 → 0.619 from n = 25 to 100) while W₁'s **rises** (0.932 →
   0.997). A method that truly resolved scale would improve with n. RV1 gains no
   information; it is reading its own estimation noise.
2. **Set 3 is the decisive result.** With (mean, SD) matched across all 12 countries,
   RV1 achieves ARI = **−0.000** and RV2 **0.018** — *no* pooled-region structure is
   recovered at any n. W₁ reaches 0.526 and KS 0.503. The split is qualitative:
   **distribution-based methods work; representative-value methods do not run.**
3. **Adding a moment is not a free patch.** On Set 1, RV3 is *worse* than RV2 —
   AUC 0.847 vs 0.988, ARI 0.620 vs 0.996 — because the third coordinate is pure
   estimation noise where two moments suffice. And it does not even buy
   blindness-insurance: on Set 3's symmetric-bimodal type it is still at chance
   (0.434). "Just add another moment" is a bet on a guess, with a measured cost.
4. **Where W₁ does not win — reported, not buried.** On Gaussian data RV2 (our
   extension, *not* Ch.4) edges W₁ out (AUC 0.988 vs 0.985; ARI 0.996 vs 0.995) — as it
   must, since a Gaussian *is* its first two moments. In Part 2 / Set 2, KS clusters
   markedly better than W₁ (ARI 0.850 vs 0.642): the high-CV group C has SD ≈ 42, so its
   within-group W₁ distances are large and average linkage lets the cluster spread,
   whereas KS is bounded in [0,1]. Same property, two faces (see Reporting plan).
5. **SMD's blind spots survive the refactor.** Scale AUC 0.499 (Set 1), shape AUC
   0.507 (Set 2), and log-SMD's combined AUC 0.500 (Set 2) — the log-transform trades
   the raw-dispersion blind spot for a new one when a raw-mean increase and a
   dispersion increase cancel in the log-mean.
6. **Absolute difficulty.** Set 3 is hard for *everyone*: even W₁ false-pools 0.921 at
   n = 100 (matched-moment shape differences produce true W₁ of only 0.69–3.02, versus
   4.8–8.0 in Set 1). The Set-3 claim is about the qualitative gap, not about W₁ making
   moment-matched selection easy.

---

## Reporting plan

**The argument this simulation licenses — and its limits.**

1. Where the EM distribution belongs to a two-parameter family (Sets 1–2), a
   representative-value method with the right coordinates is **as good as W₁, and on
   Gaussian scale-discordance slightly better**. Say so plainly.
2. No method tells you *which* moments to enumerate. Set 3 prices that ignorance:
   with (mean, SD) matched, RV forms **no clusters at all** (ARI ≈ 0); with skewness
   matched too, RV3 is blind as well.
3. **Adding a moment is not free.** On Set 1, RV3 is *worse* than
   RV2 — the irrelevant third coordinate injects estimation noise. So "just
   add another moment" is not a costless patch; it is a bet on a guess.
4. **KS is not a substitute.** Set 4 shows KS at chance where a rare mass is displaced
   far — and the failure is *structural*, not a power problem: KS is capped at the
   contamination fraction ε however far the mass moves, so it assigns the *same*
   distance to a tail displaced 30 units and one displaced 60, **at every n, including
   n = ∞**. It is an identification failure, and it comes with a rank inversion (KS
   rates a 2-unit shift of everyone as worse than pushing 10 % of patients 60 units
   into the extremes). The theorem is the clean statement: **KS admits no
   Kantorovich–Rubinstein-type bound.**
5. **Therefore: Set 3 kills the moment methods; Set 4 kills KS; W₁ is the only metric
   that survives both.** This is the headline claim, and `validate_figures.R` asserts
   it directly (only W₁ has ARI > 0.20 in *both* Set 3 and Set 4).

**On W₁'s scale-sensitivity (one property, three faces — state it once).** W₁ lives on
the EM's raw scale. That is *why* it detects scale/dispersion discordance where
moment-methods fail (Set 1), *why* it sees rare mass displaced far while KS saturates
(Set 4), and *why* an intrinsically high-spread group (Set 2 group C, SD ≈ 42) has large
within-group distances and clusters loosely under average linkage. Normalising W₁ would
not fix Part 2 anyway: `hclust` + `cutree` are invariant to a global rescale of the
distance matrix, so a global normalisation leaves ARI bit-identical; a per-country
normalisation would erase the very scale information that beats SMD/RV in Set 1 and KS
in Set 4.

**Two limitations that must be in the paper, not left for a reviewer to find.**

- **Saturating treatment effect — where the bound goes loose, and why that is the
  intended behaviour.** If θ(x) plateaus beyond a threshold (the extreme patients
  already have maximal, or zero, effect), then moving the tail from ±70 to ±100 changes
  the true |Δθ| by nothing, while W₁ doubles. The KR bound remains **valid** — it is an
  upper bound, and an upper bound cannot be violated by a flatter θ — but it becomes
  **loose**, so W₁ over-flags.
  **This is a conservative error, and conservatism is what an upper bound is for.**
  Δ_max is a worst-case statement: *whatever* the (Lipschitz) dose–response turns out to
  be, the regional effect difference cannot exceed L·W₁. A sponsor who declines to pool
  on that basis loses efficiency; a sponsor who pools because a metric was insensitive
  loses validity. The **error asymmetry** is the honest framing — W₁ errs toward *not
  pooling*, KS errs toward *false pooling* (Set 4 false-pooling@k: KS **0.971** vs W₁
  **0.718**) — and regulators do not weight these equally. Report the looseness; do not
  apologise for it.
- **W₁ is not robust to outliers — the flip side of the sensitivity we are selling.**
  One mis-keyed lab value at 10× moves W₁ by (1/n)·distance, unboundedly; KS moves by at
  most 1/n regardless. This is the single most credible attack from a regulatory
  statistician, and Set 4 makes it *more* salient, not less. Pre-specify a mitigation:
  clinical truncation of the EM to a physiologically plausible range, or a
  trimmed/winsorized W₁.

**A design heuristic worth reporting.** Define ρ = W₁/(KS · σ_EM) — the effective width
of the CDF gap in SD units — and compare it with a pure location shift in the same family
(ρ_trans = 1/(σ·f_max); 2.51 for a Gaussian). Across all cells, **ρ/ρ_trans ≲ 1 ⟹ KS ties
or wins; ≳ 1.7 ⟹ W₁ wins**. This single quantity retrodicts every cell in the study,
including why KS edges W₁ on Set 3's symmetric-bimodal type (ratio 0.76 — a *tall, narrow*
gap is L∞'s home turf). W₁ out-powers KS **iff the CDF gap spans many SDs of the EM** —
which is why displacement into the tails, and nothing else, buys the advantage. (A
second candidate mechanism — many small CDF gaps spread across the bulk — was tested and
**rejected**: it works in the population but collapses at n = 100, exactly as the ρ
heuristic predicts.)

**Figures** (`figures/`, paper standard: `theme_bw` base 11, width 7", white bg,
greyscale + `_color` slide variant; identity encoded by colour + linetype + shape):
- `fig_selection_auc_by_type` — Part 1, Sets 1–3. AUC vs n, faceted family ×
  discordance type (3 × 3), 0.5 chance/blind reference line.
- `fig_selection_auc_set4` — Part 1, Set 4. Its own figure: it asks a different
  question (W₁ vs KS, not which-moment) and has four discordance types. KS sits on the
  0.5 line for the displaced-extreme types and **beats W₁ on the bulk-shift control**.
- `fig_selection_false_pooling` — Part 1. false-pooling@k vs n, one panel per family.
- `fig_clustering_ari` — Part 2. Adjusted Rand index vs n, one panel per family (2 × 2),
  0 = chance reference. **This is the decisive figure**: in Set 3 the RV and SMD series
  sit on the zero line; in Set 4 the KS series sits on the zero line; **the W₁ series is
  the only one above zero in every panel.**

**Tables.** Replace/augment the detection table (`tab:smd`, metric *values*) with a
decision-consequence table (false-pooling / AUC by type at each n) across the four
families, plus an ARI table for Part 2.

*Code:* `R/selection_simulation.R` (Part 1), `R/clustering_simulation.R` (Part 2),
`R/figures_selection.R` (all figures); validated by `R/validate_selection.R` and
`R/validate_figures.R` (the latter asserts figure fidelity, the qualitative claims
above, the headline "only W₁ survives both Set 3 and Set 4", **and** every cell where
W₁ loses).
