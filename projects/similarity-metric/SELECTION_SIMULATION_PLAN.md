# Simulation Study Plan — Pooling-Partner Selection

**Question (Tak):** Under virtual scenarios where several countries each have their
own effect-modifier (EM) distribution — some similar to an anchor, some not — can a
distributional metric (W₁) select the truly-similar countries as pooling partners
*more correctly than* competing methods (SMD, KS)?

**Framework:** ADEMP (Morris, White & Crowther 2019, *Stat Med* 38:2074–2102,
DOI: 10.1002/sim.8086). Scope = **Q_metric** (recovery of true EM-distributional
similarity from finite samples). No outcome/CATE model is used; the link from
distributional closeness to treatment-effect difference is carried by the
Kantorovich–Rubinstein bound in the paper's theory section, not by this simulation.

**Design principle (Tak, realism):** All countries within a scenario set share the
**same distributional family** — a single endpoint cannot be Gaussian in nine
regions and log-normal in one. Skewness is therefore studied in its own
consistent-family world, not as a lone outlier. Two scenario sets:

- **Set 1 — Gaussian world:** every country Normal; discordance in location / scale.
- **Set 2 — Skewed world:** every country log-normal (a realistic skewed biomarker,
  e.g. ALT); discordance in location / dispersion-and-shape.

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

---

## Table 3 — Methods compared

| Method | Anchor-to-candidate distance | Sees | Blind to |
|---|---|---|---|
| **W₁** | Sample Wasserstein-1, `(1/n)Σ|x₍ᵢ₎−y₍ᵢ₎|` (equal n) | full distribution | — |
| **SMD (raw)** | \|mean(x)−mean(y)\| / pooled SD | location (mean) only | scale, shape |
| **SMD (log)** — Set 2 only | same on log-transformed data | location on log scale | dispersion/shape |
| **KS** | sup\|F̂_x − F̂_y\| | full distribution (sup-norm) | weaker on tail mass than W₁ |

Selection = rank the 9 candidates by the method's distance; the `k` nearest are the
proposed pooling partners.

---

## Table 4 — Performance measures (threshold-free)

| Measure | Definition | Direction | Rationale |
|---|---|---|---|
| **precision@k** | fraction of the k = \|S*\| nearest that are true matches | higher better | recovery of the poolable set |
| **false-pooling@k** | P(≥1 discordant enters the top-k, displacing a match) | lower better | the safety-relevant error |
| **AUC per discordance type** | P(a true-match distance < a type-t discordant distance) | 1 = perfect, 0.5 = blind | isolates which discordance each method resolves |

Metrics live on incommensurable scales, so **only within-method rankings are used** —
no shared or per-metric distance threshold.

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

1. **Metric-free truth.** The poolable set is a designer-set binary label (same
   population as anchor: yes/no), *not* "smallest true W₁" — the latter would rig it.
2. **Balanced types, reported separately.** All discordance types are present; the
   location types are a built-in control (SMD detects location, so all methods should
   score ≈1 there). Cherry-picking only SMD-blind types is prohibited.
3. **Steelman the competitor (Set 2).** SMD is given its standard-practice
   log-transform. The claim survives even the fair version of the rival.

---

## Production results (10{,}000 reps, random tie-break; `results/selection_sim_summary.csv`)

**Set 1 (Gaussian)** — false-pooling@3 (W₁ / SMD / KS):

| n | W₁ | SMD | KS |
|---|---|---|---|
| 25 | 0.575 | 0.936 | 0.833 |
| 50 | 0.286 | 0.907 | 0.617 |
| 75 | 0.152 | 0.900 | 0.446 |
| 100 | 0.085 | 0.895 | 0.330 |

Scale-type AUC: SMD ≈ 0.50 at every n (structurally blind); W₁ 0.93 → 1.00; KS 0.72 → 0.93.

**Set 2 (log-normal)** — false-pooling@3 (W₁ / SMD / SMD_log / KS):

| n | W₁ | SMD | SMD_log | KS |
|---|---|---|---|---|
| 25 | 0.841 | 0.976 | 0.971 | 0.939 |
| 100 | 0.438 | 0.951 | 0.940 | 0.703 |

Shape-type AUC (n=100): W₁ 0.981 / SMD **0.507** / SMD_log 0.801 / KS 0.932.
Combined-type AUC (n=100): SMD_log **0.500** — log-transform trades the raw-dispersion
blind spot for a new one when a raw-mean increase and a dispersion increase cancel in
the log-mean (disclosed, not tuned).

**Reading.** Relative order W₁ > KS > SMD holds at every $n$ in both families.
Raw SMD recovers ~half the matches and false-pools ~0.90–0.95 **without improving as
$n$ grows**, because scale/shape discordants share the anchor's mean; log-SMD only
partially rescues shape and not the combined case. Absolute performance falls at small
$n$ and in the skewed world (even W₁ false-pools 0.84 at $n=25$ in Set 2), so reliable
single-EM selection needs adequate $n$ (Gaussian ≥ 75–100; skewed ≥ 150–200).

---

## Reporting plan

- Replace/augment the detection table (`tab:smd`, metric *values*) with a
  **decision-consequence** table (false-pooling / AUC by type at each n), for both families.
- Figures (`figures/fig_selection_*`, paper standard: `theme_bw` base 11, greyscale
  + colour slide variant, identity encoded by colour + linetype + shape):
  (i) `fig_selection_false_pooling` — false-pooling@k vs n, one panel per family;
  (ii) `fig_selection_auc_by_type` — AUC vs n by method, faceted family × discordance
  type, with a 0.5 chance/blind reference line (SMD sits on it for scale/shape;
  log-SMD sits on it for the combined case).
- State scope (Q_metric) and the W₁≈KS caveat explicitly. W₁-over-KS, if seen, rests on
  theory (Δ_max = L·W₁ calibration, EM-unit interpretability), not on this roster.

*Code:* `R/selection_simulation.R` (driver), `R/figures_selection.R` (figures);
validated by `R/validate_selection.R` and `R/validate_figures.R`.
