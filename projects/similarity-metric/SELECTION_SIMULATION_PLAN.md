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
similarity from finite samples). No outcome/CATE model is used; the link from
distributional closeness to treatment-effect difference is carried by the
Kantorovich–Rubinstein bound in the paper's theory section, **not** by this
simulation. Δ_max — the property that separates W₁ from KS — is therefore **not
tested here**, and no claim of W₁-over-KS may rest on this simulation.

**Design principle (Tak, realism):** All countries within a scenario set share the
**same distributional family** — a single endpoint cannot be Gaussian in nine
regions and log-normal in one. Three scenario sets:

- **Set 1 — Gaussian world:** every country Normal; discordance in location / scale.
- **Set 2 — Skewed world:** every country log-normal (a realistic skewed biomarker,
  e.g. ALT); discordance in location / dispersion-and-shape.
- **Set 3 — Mixture world (moment-matched):** every country a two-component Gaussian
  mixture (e.g. a genotype sub-population — fast/slow metabolisers — whose mixing
  proportion differs by region). Every candidate matches the anchor **exactly on
  mean (50) and SD (10)**; only the shape differs.

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
| **A — Aims** | Show W₁ recovers the true poolable set (countries sharing the anchor's EM distribution) from finite samples with higher precision and lower false-pooling than SMD and KS; characterise where each method succeeds/fails by discordance type, in **both** a symmetric (Gaussian) and a skewed (log-normal) world. |
| **D — Data-generating mechanisms** | Two 10-country sets, each = 1 anchor + 9 candidates, all from one family (Set 1 Gaussian, Table 2a; Set 2 log-normal, Table 2b). EM sampled i.i.d.; sample size `n` per country varied. |
| **E — Estimand / target** | The **true poolable set** S* = {candidates drawn from the anchor's population}, fixed **by construction** (metric-independent → non-circular). |
| **M — Methods** | Selection rules ranking candidates by anchor-to-candidate distance (Table 3): W₁, SMD, KS. In Set 2, SMD is reported on both the raw and the log scale (log-transform is standard practice for skewed data). |
| **P — Performance measures** | Threshold-free, ranking-based (Table 4): precision@k, false-pooling@k, AUC per discordance type. |

---

## Table 2a — Set 1, Gaussian world (anchor = N(50, 10²))

| Country | EM distribution | Construction label (= truth) | Discordance type | Δmean | true W₁ | SMD-detectable? |
|---|---|---|---|---|---|---|
| A0 | N(50, 10²) | anchor | — | — | — | — |
| G1–G3 | N(50, 10²) | **MATCH** (poolable) | — | 0 | 0.00 | — |
| L1 | N(55, 10²) | discordant | location (0.5σ) | 5 | 5.00 | yes |
| L2 | N(58, 10²) | discordant | location (0.8σ) | 8 | 8.00 | yes |
| V1 | N(50, 16²) | discordant | scale (1.6×) | 0 | 4.79 | **no** |
| V2 | N(50, 20²) | discordant | scale (2.0×) | 0 | 7.98 | **no** |
| X1 | N(56, 14²) | discordant | location + scale | 6 | 6.23 | partial |
| X2 | N(54, 13²) | discordant | location + scale (mild) | 4 | 4.4 | partial |

Symmetric family → no shape/skew discordance (Gaussians cannot skew); that role
belongs to Set 2. SMD's blind spot here is **scale** (V1, V2).

---

## Table 2b — Set 2, Skewed world (anchor = LogN, mean 50, CV 0.40; sd 20, median 46.4, skew 1.26)

| Country | EM distribution | Construction label (= truth) | Discordance type | Δmean | true W₁ | SMD (raw / log) detects? |
|---|---|---|---|---|---|---|
| A0 | LogN(mean 50, CV 0.40) | anchor | — | — | — | — |
| G1–G3 | LogN(mean 50, CV 0.40) | **MATCH** (poolable) | — | 0 | 0.00 | — |
| Lm1 | LogN(mean 55, CV 0.40) | discordant | location (median shift) | 5 | 5.00 | yes / yes |
| Lm2 | LogN(mean 58, CV 0.40) | discordant | location (median shift) | 8 | 8.00 | yes / yes |
| Dp1 | LogN(mean 50, CV 0.60) | discordant | dispersion + shape | 0 | 6.74 | **no** / weak (~0.17) |
| Dp2 | LogN(mean 50, CV 0.85) | discordant | dispersion + shape | 0 | 13.91 | **no** / weak |
| Cx  | LogN(mean 55, CV 0.65) | discordant | location + dispersion | 5 | 9.60 | partial / partial |

Constructed by fixing the mean and varying CV: raising CV at fixed mean lowers the
median and raises skew (Dp1 skew 2.02, Dp2 skew 3.16), so raw SMD (Δmean = 0) is
blind. **Log-scale SMD** picks up only a tiny residual mean shift (~0.17 for Dp1) and
stays blind to the dispersion → shows the failure is structural, not a missing
transform. W₁ and KS resolve all discordance types.

⚠️ **But note what a *fair* RV baseline does here.** Raising CV at fixed mean also
moves the SD (20 → 30 → 42.5). RV2 separates Dp1/Dp2 on the SD axis alone.
Set 2 defeats *SMD*, not Komiyama. Hence Set 3.

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

## Table 2d — Part 2 roster (clustering): 12 countries, 3 true groups of 4

| Set | Group A (×4) | Group B (×4) | Group C (×4) | Can RV2 separate the groups? |
|---|---|---|---|---|
| Set 1 Gaussian | N(50, 10²) | N(58, 10²) | N(50, 20²) | yes (groups differ in mean or SD) |
| Set 2 Log-normal | mean 50, CV 0.40 | mean 58, CV 0.40 | mean 50, CV 0.85 | yes (SD 20 / 23 / 42) |
| Set 3 Mixture | w=0.50, d=6 | w=0.50, d=19 | w=0.85, d=19 | **no** — all 12 countries have mean 50, SD 10 |

In Set 3 groups A and B are additionally skew-matched (both 0), so RV3
cannot separate A from B either.

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

| Item | Setting |
|---|---|
| Scenario set (family) | Set 1 Gaussian, Set 2 log-normal — reported separately |
| Sample size per country `n` | {25, 50, 75, 100} (equal across countries; small-n emphasis — realistic regional subgroups) |
| Discordance types | Set 1: location, scale, combined · Set 2: location, dispersion/shape, combined — all present, **each reported separately** |
| Monte Carlo repetitions | 10{,}000 per configuration (proportion MC SE ≤ 0.005; reported per estimate) |
| Tie-breaking | ties in a method's distances broken at **random** under the cell seed, not by roster order (matches are listed first, so roster-order ties would spuriously flatter the correct answer — bites KS at small n where its statistic is discrete) |
| Seeding / reproducibility | per-cell seed set inside `run_cell`, serial execution ⇒ **bit-reproducible** (contrast: the per-EM W₁ operating-characteristic sim is aggregate-reproducible only, due to `parLapplyLB` + per-worker RNG) |
| Dependencies | pure base R (`rnorm`/`rlnorm`/`sort`/`ks.test`/`integrate`); W₁ estimator equals the canonical integral-of-\|F₁−F₂\| to machine precision |
| True distributional references | analytic (numerical integration of \|F_A − F_B\|; grid sup for KS) |
| Fixed | anchor distribution; roster composition |
| Full-study extensions | multiple anchors; vary \|S*\|; add "near-match" countries (within-tolerance) for graded discrimination |

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
   RV2 is expected to match or beat W₁, and Part 2/Set 2 is expected to
   favour KS. These cells are pre-declared, not discovered post hoc, and are reported
   with the same prominence as Set 3. `validate_figures.R` asserts them as CLAIM
   checks, so silently dropping them breaks the build.

---

## Production results

Part 1: 10,000 reps (`results/selection_sim_summary.csv`).
Part 2: 5,000 reps (`results/clustering_sim_summary.csv`). MC SE ≤ 0.005 throughout.

### Part 1 — selection, combined-type AUC at n = 100

| Set | W₁ | KS | **RV1 (Ch.4)** | RV2 | RV3 | SMD | SMD(log) |
|---|---|---|---|---|---|---|---|
| 1 Gaussian | 0.985 | 0.957 | **0.951** | **0.988** | 0.847 | 0.947 | — |
| 2 Log-normal | **0.950** | 0.802 | **0.657** | 0.895 | 0.839 | 0.648 | 0.500 |
| 3 Mixture | **0.699** | 0.676 | **0.503** | 0.494 | 0.638 | 0.504 | — |

### Part 2 — clustering, adjusted Rand index at n = 100

| Set | W₁ | KS | **RV1 (Ch.4)** | RV2 | RV3 | SMD |
|---|---|---|---|---|---|---|
| 1 Gaussian | 0.995 | 0.983 | **0.489** | **0.996** | 0.620 | 0.452 |
| 2 Log-normal | 0.642 | **0.850** | **0.343** | 0.614 | 0.448 | 0.334 |
| 3 Mixture | **0.526** | 0.503 | **−0.000** | 0.018 | 0.131 | −0.000 |

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

### Reading

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
4. Therefore the honest split is **distribution-based (W₁, KS) vs moment-based (SMD,
   RV)**, not "W₁ beats everything." W₁-over-KS does **not** follow from this
   simulation — in Part 2/Set 2 KS clusters *better* than W₁ — and rests instead on
   Δ_max (clinical calibration in EM units), which this simulation does not test.

**On W₁'s scale-sensitivity (one property, two faces — state it once).** W₁ lives on
the EM's raw scale. That is *why* it detects scale/dispersion discordance where
moment-methods fail (Set 1), and *why* an intrinsically high-spread group (Set 2
group C, SD ≈ 42) has large within-group distances and clusters loosely under average
linkage. Normalising W₁ would not fix Part 2 anyway: `hclust` + `cutree` are invariant
to a global rescale of the distance matrix, so a global normalisation leaves ARI
bit-identical; a per-country normalisation would erase the very scale information that
beats SMD/RV in Set 1.

**Figures** (`figures/`, paper standard: `theme_bw` base 11, width 7", white bg,
greyscale + `_color` slide variant; identity encoded by colour + linetype + shape):
- `fig_selection_auc_by_type` — Part 1. AUC vs n, faceted family × discordance type
  (3 × 3), 0.5 chance/blind reference line.
- `fig_selection_false_pooling` — Part 1. false-pooling@k vs n, one panel per family.
- `fig_clustering_ari` — Part 2. Adjusted Rand index vs n, one panel per family,
  0 = chance reference. **This is the decisive figure**: in Set 3 the RV and SMD
  series sit on the zero line.

**Tables.** Replace/augment the detection table (`tab:smd`, metric *values*) with a
decision-consequence table (false-pooling / AUC by type at each n) across the three
families, plus an ARI table for Part 2.

*Code:* `R/selection_simulation.R` (Part 1), `R/clustering_simulation.R` (Part 2),
`R/figures_selection.R` (all figures); validated by `R/validate_selection.R` and
`R/validate_figures.R` (the latter asserts both figure fidelity **and** the
qualitative claims above, including the ones where W₁ loses).
