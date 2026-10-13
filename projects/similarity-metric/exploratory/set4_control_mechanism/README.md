> **EXPLORATORY — not pre-registered, not citable from the manuscript.** Promote via /protocol.

# set4_control_mechanism — Why does KS beat W₁ in the Set 4 bulk-shift control but not in the Set 1/2 location cells?

- **Date**: 2026-10-12  **Owner**: Mike (code, numbers), Harvey (question, D-20261012-2), Louis (hypothesis, C4), Donna (record)
- **Status**: exploratory run done. The verdict and number tables went to Harvey in Mike's hand-back (the subagent harness blocks report files). Donna or Harvey writes `report.md` from that text if it is wanted on disk. Nothing here goes into the manuscript, `paper/numbers_registry.csv`, or `results/NUMBERS_LEDGER.csv`.

## Question
In Study 1, `results/required_n_selection.csv` shows KS reaching AUC 0.9 before W₁ in the Set 4 bulk-shift control (333 vs 377; rows 183 and 243). In the pure location cells W₁ gets there first: Set 1, 33 vs 39 (rows 48 and 3); Set 2, 129 vs 157 (rows 111 and 57). Louis's hypothesis (C4) has two parts. The two 5% tail components at ±40 inflate the sampling variability of Ŵ₁, whose null scale is about ∫√(F(1−F))dx. D_KS is distribution-free. So for δ = 2 or 3 the signal-to-noise ratio of Ŵ₁ falls relative to KS. D-20261012-2 kept this explanation out of the manuscript because nobody had checked it (S21).

## Design (minimal; no bootstrap inference)
- Base distributions:
  - (a) N(50, 10²).
  - (b) the Set 4 anchor 0.05·N(10, 8²) + 0.90·N(50, 10²) + 0.05·N(90, 8²). This is `ext_c(…, s0 = 10, st = 8)` in `R/selection_simulation.R`. The shifted sample is anchor + δ, which has the same distribution as `ext_c` with mu0 = 50 + δ, the S1/S2 construction.
- δ ∈ {2, 3}, n ∈ {100, 200, 400} per region, n_sim = 2,000 independent pairs per cell, for both anchor vs shifted and anchor vs anchor. The null draws at a given (base, n) are shared by δ = 2 and δ = 3, so those two contrasts are correlated.
- Statistics: Ŵ₁ is the CDF-area `compute_w1`, checked against the one-pass implementation on 20 reps. D_KS is checked against `ks.test`.
- Measures, all with MCSE:
  - mean and SD of each statistic under the null and under the shift;
  - separation = (mean_alt − mean_null) / √((SD_alt² + SD_null²)/2);
  - AUC (Mann–Whitney, ties 0.5);
  - paired differences W₁ − KS;
  - ∫√(F(1−F))dx by numerical integration;
  - the Study 1 AUC estimand as a bridge (one shared anchor sample per rep, 3 matches × {δ = 2, 3}, `auc_pairs`).
- Decision rule, fixed in the design step before the run. This README was written after the run.
  - **Support**: in (a) W₁ is at least as good as KS, and in (b) KS beats W₁, at the same (δ, n), by more than about 2 MCSE.
  - **Refute**: KS already beats W₁ in (a) at δ = 2, 3.
  - **Open**: anything else.
- Seeds: `SEED = 20261012`, with `set.seed(SEED + cell offset)` per cell, run serially. Runtime is about 4.6 min.

## Files
- `R/set4_control_mechanism.R` writes the simulation results: `results/set4_control_mechanism.csv`, `results/auc_sep_differences.csv`, `results/null_sd_ratios.csv`, `results/integrals.csv`, `results/study1_estimand_bridge.csv`, `results/sessionInfo.txt` and `figures/auc_by_n.{pdf,png}`.
- `R/decompose.R` does post-processing only (no RNG) and writes `results/decomposition.csv` and `results/sessionInfo_decompose.txt`.
- `report.md` is not written yet (see Status).

Figure `figures/auc_by_n.pdf` plots the AUC of W₁ and KS for shifted vs unshifted pairs against n per region. Panels are base distribution (columns) × δ (rows). Error bars are ±2 MCSE.

## Conditions for promotion to /protocol
Two scopes. (i) One sentence explaining the existing Set 4 control row of Table 2 would sit in R2 (Study 1). It needs `PROTOCOL_set4_control_mechanism.md` before it can enter. (ii) The general efficiency question (when the sup-norm wins) is outside A1 and goes to the backlog line below. §0 of that protocol must disclose this run as a prior look (S8). A separate route is to scope it out through `/idea`.

## Idea line for IDEAS_BACKLOG.md (Donna transfers; the ID is a candidate because concurrent sessions may already have taken -2)
| I-20261012-2 (candidate) | 2026-10-12 | D-20261012-2 Louis C4 → `projects/similarity-metric/exploratory/set4_control_mechanism/` | For a pure location shift, does the ordering of W₁ and KS in sample size to discrimination follow the noise of Ŵ₁ (null mean ∝ ∫√(F(1−F))dx, inflated by heavy or remote tails) while KS stays distribution-free? That would characterize when the sup-norm discriminates a shift with fewer patients. | R2 only claims that W₁ is not blind (identification). Comparing the efficiency of W₁ and KS against shifts is a power or efficiency question outside A1. The manuscript states only the fact (D-20261012-2 C4) | A protocol with a family of base distributions graded by ∫√(F(1−F))dx at fixed SD; MCSE on paired AUC differences; the asymptotic null law of √n·Ŵ₁ = ∫\|B(F)\| (del Barrio, Giné & Matrán 1999, DOI 10.1214/aop/1022677394, `knowledge/summaries/Barrio_1999.md` — Rachel to verify the passage in the original) | 💡 Incubating | Mike |

## Derivation on disk: approximate null mean of Ŵ₁ (Mike, own derivation; one-sample law from del Barrio, Giné & Matrán 1999)
- Under H₀ with equal n, F_n − G_n at each t has mean 0 and variance 2F(t)(1−F(t))/n. By the pointwise CLT it is approximately N(0, v(t)).
- E|N(0, v)| = √(2v/π). Therefore E|F_n(t) − G_n(t)| ≈ √(4F(t)(1−F(t))/(πn)).
- By Fubini, E Ŵ₁ = ∫E|F_n − G_n|dt ≈ √(4/(πn))·∫√(F(1−F))dt. This requires ∫√(F(1−F)) < ∞, which is the condition of the one-sample CLT (√n∫|F_n − F| → ∫|B(F)|; DOI 10.1214/aop/1022677394, `knowledge/summaries/Barrio_1999.md`).
- The two-sample step and the approximation of the mean are mine and are not taken from the paper.
- The derivation does not fix the SD of Ŵ₁. The SD depends on the covariance of B∘F and is not a function of the integral alone.
