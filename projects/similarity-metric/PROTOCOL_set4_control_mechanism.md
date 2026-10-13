---
# Machine-readable half (protocol_compile.py). Confirmatory run registered AFTER one exploratory look and one referee check (section 0).
study: set4_control_mechanism
code: R/set4_control_mechanism.R      # production single writer (copied from exploratory/set4_control_mechanism/R/, fresh seed offsets)
claim_id: C-08                        # the bulk-shift control sentence of C-08 (KS fewer patients in the Set 4 control); CLAIMS.md
post_hoc: false
seed: 20261012                        # base seed; per-cell seed = SEED + 20000 + 1000*base + 100*n_index + 10*delta_index (null: delta_index 0)
n_sim: 4000
target_mcse: {auc_diff: 0.005, sd_ratio: 0.04}
estimand: "For base distributions G in {N(50,10^2), Set 4 anchor mixture} and n per region: (i) the null SD ratio rho_W = SD_mix(W1hat)/SD_gauss(W1hat) and rho_KS = SD_mix(D_KS)/SD_gauss(D_KS), where W1hat and D_KS are computed on two independent samples of size n from G; (ii) for a shift delta, AUC_T = P(T(X, Y+delta) > T(X', Y')) + 1/2 P(=) for T in {W1hat, D_KS}, and the paired difference Delta_AUC = AUC_W1 - AUC_KS (the two statistics evaluated on the same pairs); (iii) the deterministic constant I(G) = integral sqrt(F_G(1-F_G)) dx and its ratio I_mix / I_gauss"
truth: {method: closed_form, note: "W1(G, G+delta) = delta for both bases (pure translation); population D_KS = max_t |F_G(t) - F_G(t - delta)| on a 400,001-point grid; I(G) by adaptive quadrature (integrate, rel.tol 1e-10). The null SD and the AUC have no closed form: they are the simulated estimands"}
dgm:
  - {name: gauss, description: "N(50, 10^2) — the Set 1 anchor"}
  - {name: mix,   description: "Set 4 anchor: 0.05 N(10, 8^2) + 0.90 N(50, 10^2) + 0.05 N(90, 8^2) (R/selection_simulation.R ext_c, s0 = 10, st = 8); shifted sample = anchor + delta, equal in distribution to ext_c with mu0 = 50 + delta (bulk_shift S1/S2)"}
deltas: [2, 3]
n_grid: [100, 200, 400]
methods:
  - {name: W1, owner: ours,     fn: stat2, description: "Wasserstein-1 distance, CDF-area form (equal n): sum |F_x - F_y| x gaps over the pooled sort; asserted equal to compute_w1 of R/fig3_w1_axis.R"}
  - {name: KS, owner: existing, fn: stat2, description: "two-sample Kolmogorov-Smirnov statistic max |F_x - F_y| (exact lattice k/n); asserted equal to ks.test()$statistic"}
measures: [empse]                     # the compiled measure: Monte Carlo SD of each statistic (null and shifted)
extra_measures: [sd_ratio, auc, auc_diff_paired]   # not known to protocol_compile.py; MCSE formulas in section 3 P
outputs: {summary_csv: results/set4_control_mechanism.csv, sd_ratio_csv: results/set4_null_sd_ratios.csv, integrals_csv: results/set4_integrals.csv, per_rep_rds: results/set4_control_mechanism_per_rep.rds, log: results/set4_control_mechanism.log}
parallel: {workers: 1, rng: per_cell_seed}
prior_look: "yes — exploratory run with the same design at n_sim = 2,000 (2026-10-12 ~16:20, exploratory/set4_control_mechanism/) and the cold referee's independent check at shift 2.5 (review_response/referee/20261012/ref_tailweight.log); see section 0"
---

# PROTOCOL — Set 4 control mechanism: why the KS statistic needs fewer patients than W₁ in the bulk-shift control

**Registered**: 2026-10-12 (before the production run; after the exploratory look disclosed in §0)
**Project**: `projects/similarity-metric/` **Claim ID**: `CLAIMS.md` C-08 (the bulk-shift control clause) **Decision**: D-20261012-2 (Louis C4) → Jessica Go (2026-10-12)
**Framework**: ADEMP (Morris, White & Crowther 2019 *Statistics in Medicine* 38:2074–2102, DOI: [10.1002/sim.8086](https://doi.org/10.1002/sim.8086))

---

## 0. Prior-look disclosure (honesty clause)

| Date / time | Event | Before or after seeing results | Evidence |
|---|---|---|---|
| 2026-10-12 (morning) | Louis C4 proposed the mechanism: the 5% subgroups at ±40 inflate the sampling variability of Ŵ₁, while D_KS is distribution-free. D-20261012-2 kept the mechanism out of the manuscript because nobody had checked it | before | `DECISIONS.md` D-20261012-2 C4 |
| 2026-10-12 ~16:20 | **Exploratory run** (Mike). Same two bases, δ ∈ {2, 3}, n ∈ {100, 200, 400}, n_sim = 2,000, seed 20261012 with cell offsets 100–5999. Results: null SD ratio 1.52–1.59 for Ŵ₁ and 1.00–1.03 for D_KS. Paired ΔAUC(W₁ − KS) was +0.005 to +0.035 for the Gaussian base and −0.012 to −0.028 for the mixture | **after** — the production design and estimands were fixed after these results were seen | `exploratory/set4_control_mechanism/results/*.csv`, README |
| 2026-10-12 | **Referee check** (cold referee, independent code), shift 2.5. n = 200: Gaussian AUC W₁ 0.913 vs KS 0.884; Set 4 family 0.811 vs 0.839 | after | `review_response/referee/20261012/ref_tailweight.log` |
| 2026-10-12 | This protocol: n_sim raised to 4,000, **fresh seed offsets** (≥ 20000, disjoint from the exploratory offsets) so that no production replicate repeats an exploratory one. The separation index and the Study 1 bridge were dropped, because they are not estimands here. The paired AUC MCSE is now analytic (DeLong), where the exploratory run used a replicate bootstrap | after | this file, `R/set4_control_mechanism.R` |

**Consequence.** The run is confirmatory only for the precision of the estimates, not for the direction of the effects: the directions were already seen twice. The manuscript must not present the mechanism as a prediction that was tested blind. The exploratory CSVs are not cited.

## 1. Claim (Harvey)
In the Set 4 bulk-shift control, the KS statistic reaches the selection target with fewer patients than W₁. In the pure location cells of Sets 1–2, W₁ does. The candidate explanation is that the remote 5% subgroups of the Set 4 anchor inflate the sampling SD of Ŵ₁ but not of D_KS (distribution-free under the null). The protocol quantifies the inflation (ρ_W, ρ_KS) and the resulting paired AUC difference on the two anchors at the two control shifts.

## 2. Licenses / does not license (Mike)
**Licenses**
- Reporting ρ_W, ρ_KS, I_mix/I_gauss, the four AUCs and ΔAUC with MCSE for the two anchors, δ ∈ {2, 3} and n ∈ {100, 200, 400}.
- If, at n = 200 and δ = 2, ΔAUC is positive for the Gaussian anchor and negative for the mixture, each by more than 2 MCSE, and ρ_W − 1 > 2·MCSE(ρ_W) while |ρ_KS − 1| ≤ 2·MCSE(ρ_KS): one sentence in R2 (Study 1). The sentence states that, for the same shift, the Set 4 anchor raises the null SD of Ŵ₁ by ρ_W while leaving that of D_KS unchanged, and that the paired AUC ordering reverses between the two anchors. If the criterion fails, the manuscript keeps the fact-only sentence of D-20261012-2 C4.

**Does not license**
- Any general rule about when KS or W₁ is preferable. That efficiency question is outside A1 (idea I-20261012-2 candidate).
- Any claim that the null SD scales exactly with I(G). The exploratory SD ratio sat below the integral ratio. The integral may be quoted as the first-order scale of the null **mean** (§3 E; own derivation on disk in the exploratory README).
- Claims for other shifts, bases or unequal n.
- Any pooling threshold or procedure (`memory/feedback_quantify_not_decide.md`).

## 3. ADEMP

### A — Aims
Quantify whether the Set 4 anchor inflates the null sampling SD of Ŵ₁ relative to N(50, 10²) while leaving that of D_KS unchanged, and whether the paired AUC ordering of W₁ and KS reverses between the two anchors at the Set 4 control shifts.

### D — Data-generating mechanisms
Front matter `dgm`. For each base G, n ∈ {100, 200, 400} and δ ∈ {2, 3}:
- **null pairs**: (X, Y) iid samples of size n from G;
- **shifted pairs**: (X, Y + δ).

The null cell at a given (G, n) is shared by δ = 2 and δ = 3, so the two contrasts are correlated. This is recorded in the CSV.

### E — Estimands
- ρ_W(n) = SD_mix(Ŵ₁)/SD_gauss(Ŵ₁) under the null; ρ_KS(n) likewise for D_KS.
- AUC_T(G, n, δ) = P(T_shift > T_null) + ½P(=).
- ΔAUC(G, n, δ) = AUC_W1 − AUC_KS.
- I(G) = ∫√(F_G(1 − F_G))dx; I(N(50, 10²)) = 10·I(N(0, 1)) serves as a check.
- Reference only, not a claim: the first-order null mean E Ŵ₁ ≈ √(4/(πn))·I(G). The one-sample CLT behind it is del Barrio, Giné & Matrán 1999, DOI [10.1214/aop/1022677394](https://doi.org/10.1214/aop/1022677394); the two-sample step is Mike's own derivation.

### M — Methods
Ŵ₁ (CDF-area form, equal n) and D_KS, computed in one pass over the pooled sort (`stat2`). The script asserts on 20 replicates that `stat2` equals `compute_w1` and `ks.test`.

### P — Performance measures and Monte Carlo SE (R = n_sim = 4,000)
- **SD** s of a statistic: MCSE(s) = √((m₄ − s⁴)/(4s²R)), with m₄ the 4th central moment.
- **SD ratio** ρ = s_mix/s_gauss (independent cells): MCSE(ρ) = ρ·√((MCSE(s_mix)/s_mix)² + (MCSE(s_gauss)/s_gauss)²).
- **AUC** (Mann–Whitney, ties ½), with DeLong components:
  - V10_i = (#null < a_i + ½ #ties)/R for each shifted replicate i;
  - V01_j = (#shifted > u_j + ½ #ties)/R for each null replicate j;
  - MCSE(AUC) = √(var(V10)/R + var(V01)/R).
- **Paired ΔAUC**: the same formula applied to the differences V10ᵂ − V10ᴷˢ and V01ᵂ − V01ᴷˢ. The two statistics share their replicates.
- **Mean** of a statistic: MCSE = s/√R.
- **Target.** MCSE(ΔAUC) ≤ 0.005 and MCSE(ρ) ≤ 0.04. Scaling the exploratory MCSEs at R = 2,000 (ΔAUC ≤ 0.0065, ρ ≤ 0.050) by √(1/2) gives ≤ 0.0046 and ≤ 0.036 at R = 4,000.

## 4. Outcomes
The §2 criterion is evaluated at the headline cell, n = 200 and δ = 2 (the Set 4 control shift S1). All other cells are reported as a grid, with no selection among them.

## 5. Louis's attacks and responses
1. "You saw the answer twice before registering." True, and disclosed in §0. Registration fixes the precision, the seed and the sentence that may be written; it does not create blindness.
2. "Picking the headline cell after the fact." The headline cell is fixed here as n = 200, δ = 2, because S1 is the smaller Set 4 control shift and n = 200 lies inside the 333/377 bracket of Study 1. The full grid is printed in the CSV.
3. "AUC on independent pairs is not the Study 1 estimand." Correct. This protocol does not re-estimate the Study 1 required n. It explains the ordering, which the exploratory bridge reproduced under the Study 1 estimand.
4. "The circularity of KR duality." It does not apply: no θ is placed. The estimand is the sampling behaviour of two distances under a pure translation (`memory/project_no_effect_tracking_sim.md`).

## 6. Outputs (Katrina)
- `results/set4_control_mechanism.csv`, in long form. It has rows for (base, n, delta, statistic ∈ {w1, ks, w1_minus_ks}). For `w1_minus_ks` only the `auc` and `auc_mcse` columns are filled, and they hold ΔAUC and its paired MCSE.
- `results/set4_null_sd_ratios.csv` and `results/set4_integrals.csv`.
- `results/set4_control_mechanism_per_rep.rds`, `results/set4_control_mechanism.log` and `results/set4_control_mechanism_sessionInfo.txt`.
- `results/SET4_CONTROL_MECHANISM_PROVENANCE.md`.
- Manuscript numbers go through `R/make_derived_numbers.R` §11 → `results/derived/derived_scalars.csv` → `paper/numbers_registry.csv`.

## 7. Go / No-Go (Jessica)
Go given 2026-10-12 (relayed by Harvey). Let me be clear: one sentence in R2 if §2's criterion holds, and nothing beyond §2.

## 8. Deviations
(none yet)
