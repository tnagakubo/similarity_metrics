# PROTOCOL — Estimated-k clustering at GUSTO-I sample sizes, and its application to GUSTO-I

Registered 2026-09-27, before any output of this run was seen.
Instruction (Tak, 2026-09-27): the paper identifies, by simulation, which method correctly identifies pooling regions, then applies that method to GUSTO-I. Selection is by ranking only. Clustering is kept and applied if the simulation validates it. Each effect modifier is analysed separately; no rule for combining effect modifiers is specified.

## 1. Claim (Harvey)

With the number of groups estimated rather than supplied, average-linkage clustering on the W₁ distance matrix recovers the true regional groups at per-region sample sizes like GUSTO-I's. If the simulation does not support this claim, the paper does not make it.

## 2. Design (Mike)

**What already exists.** `R/clustering_nok_simulation.R`, Rule A:
- 12 regions in 3 true groups of 4.
- Four worlds (Set 1 Gaussian, Set 2 log-normal, Set 3 mixture, Set 4 extremes), with rosters sourced from `R/clustering_simulation.R`.
- Average linkage; k̂ is the value in 2..6 that maximises the average silhouette.
- Scored by ARI against the construction labels.
- 2,000 reps at n = 25–400.
- Result at n = 400 for W₁: ARI is 1.000 / 0.965 / 0.524 / 0.817 and P(k̂ = 3) is 1.00 / 0.92 / 0.01 / 0.48 (Set 1 / 2 / 3 / 4).

**What this run adds.**
- Same script and same code path, no changes to the method.
- Grid n = 600, 1000, 1500, 2000 per region, 2,000 reps.
- `--tag=_ext --base-seed=56000000`. The base seed differs from the original 55000000, so no cell reuses a seed from the original run.
- Rule B (clinical τ cut, from the decision era) still runs because the script computes it. Its output is not used.

**Measures.**
- W₁, KS and SMD: two-sample distances (existing measures, plus ours).
- RV1: the one-representative-value-per-effect-modifier reading of Komiyama et al. applied to one continuous effect modifier (our operationalisation).
- RV2 and RV3: our extensions, not Komiyama's.

**Outcomes.** ARI (chance = 0), P(k̂ = 3), and the modal k̂, per world × n × measure.

**Success criterion for W₁ (fixed now).** At n = 2,000, the grid point closest to the GUSTO-I partner sizes (1,231–4,352; median about 2,500), in **all four** worlds:
- mean ARI ≥ 0.80, **and**
- P(k̂ = 3) ≥ 0.80.

The criterion requires all four worlds because the world GUSTO-I resembles is not known in advance.

**What this study licenses.** If the criterion is met, the paper may say that the estimated-k W₁ clustering recovered the true groups in all simulated worlds at n = 2,000.

**What it does not license:**
- Anything about unequal regional sizes. The simulation uses equal n; GUSTO-I does not.
- More than 12 regions or other k ranges.
- Worlds with no group structure. Silhouette over k ≥ 2 always returns at least two groups, so the simulation cannot show that the method recognises when no groups exist.
- Multiple effect modifiers.
- Correctness of any GUSTO-I partition. GUSTO-I has no ground truth.

## 3. GUSTO-I branches, fixed before the run (Mike / Harvey)

The pipeline is fixed as follows:
- CDF-area `compute_w1`. Do **not** use `w1_dist` from `selection_simulation.R`, which truncates to equal n.
- All 16 regions, pairwise W₁ matrix, per effect modifier (age, SBP) separately.
- `hclust(method = "average")`, k̂ in 2..6 by the **same** `pick_k_silhouette` function the simulation uses. It is sourced from that script, not copied.

Branches:
- **Criterion met.** Report, per effect modifier, the dendrogram, k̂, the average silhouette at k̂, and the partition (which regions share Region 8's group). State the §2 limits alongside the partition: equal n in the simulation, the ≥ 2-group constraint, and no ground truth.
- **Criterion not met.** Report, per effect modifier, the dendrogram only, with no cut. State that the step of estimating the number of groups is not supported by the simulation at these sizes.
- **Mixed outcome** (met at n = 2,000 in some worlds only): treated as **not met**.

Disclosure: a decision-era script (`R/application_all_methods.R`) produced a silhouette result on GUSTO-I (k̂ = 2 on SBP), and the team has seen it. The branches above were fixed without reference to it. The new case script does not use that script's τ screen, its complete-linkage cut, or its AND rule.

## 4. Attack (Louis)

- **Circularity.** Truth is the construction label, not any distance, so W₁ is not optimal by definition. This is not the KR-duality trap.
- **Silhouette cannot say "no groups".** This is a real limit. It is written into §2 (not licensed) and must be stated wherever a GUSTO-I partition is shown.
- **Set 3 may still fail at n = 2,000.** Silhouette favours k = 2 when one group separates strongly. If so, the no-cut branch applies. It must not be argued away by choosing a world after the fact.
- **Equal n versus GUSTO's unequal n.** This is a stated limit. No claim is made about it.

## 5. Outputs (Katrina)

**Simulation outputs:**
- `results/clustering_nok_silhouette_ext.csv`
- `results/clustering_nok_clinical_ext.csv` (not used)
- `results/clustering_nok_ext.log`

**GUSTO-I case:**
- script: `R/gusto_w1_clustering.R`
- `results/gusto_w1_clustering.csv` (per effect modifier: k̂, silhouette, region → cluster, or the merge heights if no cut)
- `figures/fig_gusto_dendrogram.pdf`: width 7", base_size 11, white background, greyscale `#1A1A1A`. The caption states what is plotted only.

**Gates:**
- Extend `R/verify_study2_figures.R` (identification gate) with the n = 2,000 criterion check.
- Extend `R/verify_study1_app_numbers.R` with the case outputs.

## 6. Go / No-Go (Jessica)

Go.
- The criterion and both branches are fixed before the run.
- Deviations from this protocol are appended below with reasons, never deleted.

## Deviations

(none yet)

## Result (appended 2026-09-27 15:45, after the run; nothing above was changed)

Run: `Rscript R/clustering_nok_simulation.R --n-grid=600,1000,1500,2000 --reps=2000 --base-seed=56000000 --tag=_ext`. Finished at 15:42:53 with exit 0.
Output: `results/clustering_nok_silhouette_ext.csv`.

W₁ at n = 2,000:

| World | ARI | P(k̂ = 3) |
|---|---|---|
| Set 1 | 1.000 | 1.000 |
| Set 2 | 1.000 | 1.000 |
| **Set 3** | **0.646** | **0.260** |
| Set 4 | 0.998 | 0.986 |

**The criterion is not met.** Set 3 fails both conditions. The modal k̂ is 2 at every n, and P(k̂ = 3) rises only slowly, from 0.007 at n = 600 to 0.26 at n = 2,000.

→ The **no-cut branch** applies, as fixed in §3. GUSTO-I is reported as per-effect-modifier W₁ dendrograms without a cut:
- `results/gusto_w1_clustering.csv` (merge heights)
- `figures/fig_gusto_dendrogram.pdf`

The script ran with `--branch=nocut`.

No deviation from the protocol.

## Decision after the result (appended 2026-09-27 19:55)

Tak decided that clustering is not reported in the paper. Neither the simulation nor the GUSTO-I dendrograms are included, and there is no Discussion sentence either.

**Why.** The number of groups could not be estimated reliably, so clustering was not shown to identify pooling regions. An uncut dendrogram adds nothing beyond the W₁ ranking.

**What is kept.** The run, its outputs and `R/gusto_w1_clustering.R` stay on disk as a record of the check.
