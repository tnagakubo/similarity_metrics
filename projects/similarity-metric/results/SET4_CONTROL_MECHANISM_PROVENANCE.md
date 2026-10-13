# Set 4 control mechanism — provenance of `results/set4_control_mechanism.csv`, `set4_null_sd_ratios.csv`, `set4_integrals.csv`

Generated: 2026-10-12 16:58 (Mike, producer; verifier to be Katrina or Louis)
Producing script: `projects/similarity-metric/R/set4_control_mechanism.R` (uncommitted at generation; parent commit `fad1010`)
Protocol: `projects/similarity-metric/PROTOCOL_set4_control_mechanism.md` (`protocol_compile.py --verify`: 8/8 PASS)

## Origin and prior-look disclosure (S8)
- Louis C4 (D-20261012-2) raised the mechanism. Two looks preceded the protocol: Mike's exploratory run (2026-10-12 ~16:20, `exploratory/set4_control_mechanism/`, n_sim 2,000) and the cold referee's independent check (`review_response/referee/20261012/ref_tailweight.log`, shift 2.5). Both are disclosed in protocol §0. Jessica gave the Go the same day, relayed by Harvey.
- The production run uses fresh per-cell seed offsets (SEED + 20000 + …), disjoint from the exploratory offsets (100–5999), so no replicate is shared. The exploratory CSVs are **not canonical** and are not cited.

## Run

| Item | Value |
|------|-------|
| Seed | `SEED = 20261012`; per-cell seed = SEED + 20000 + 1000·base + 100·n_index + 10·delta_index (null cell: delta_index 0). Recorded per row (`null_seed`, `shift_seed`) |
| RNG | Mersenne-Twister / Inversion / Rejection, serial |
| n_sim | 4,000 per cell; the null cell at each (base, n) is shared by delta = 2 and 3 (`shared_null = TRUE`) |
| Grid | base ∈ {gauss = N(50,10²), mix = Set 4 anchor 0.05 N(10,8²) + 0.90 N(50,10²) + 0.05 N(90,8²)} × n ∈ {100, 200, 400} × delta ∈ {2, 3} |
| Estimators | `stat2` (one pass, equal n). Asserted on 20 reps against `compute_w1` (R/fig3_w1_axis.R, verbatim) to 1e-10 and `ks.test` to 1e-12 |
| Run time | 1.3 min (`results/set4_control_mechanism.log`) |
| sessionInfo | `results/set4_control_mechanism_sessionInfo.txt` (R 4.5.1 ucrt) |
| Per-replicate values | `results/set4_control_mechanism_per_rep.rds` (`$per_rep[["{base}_n{n}_null" / "_d{delta}"]]`, 4,000 × 2 [w1, ks]) |

## Definitions
- **set4_control_mechanism.csv**: one row per (base, n, delta, statistic ∈ {w1, ks, w1_minus_ks}).
  - Means with MCSE s/√R.
  - SDs with MCSE √((m₄ − s⁴)/(4s²R)).
  - `auc` = Mann–Whitney with ties ½. `auc_mcse` = DeLong √(var(V10)/R + var(V01)/R).
  - Rows with statistic `w1_minus_ks`: `auc` is the paired ΔAUC and `auc_mcse` is the paired DeLong MCSE (differences of the V10/V01 components). All other columns are NA.
  - `true_value`: W₁ = delta; KS = population max |F(t) − F(t − delta)|.
  - `null_mean_first_order` = √(4/(πn))·I(G), Mike's derivation; reference only.
- **set4_null_sd_ratios.csv**: ρ = SD_mix/SD_gauss of each statistic under the null, with MCSE ρ·√(Σ(MCSE/SD)²), from independent cells. `mean_ratio_w1` is reported for comparison with `integral_ratio`.
- **set4_integrals.csv**: I(G) = ∫√(F(1−F))dx by `integrate` over [−150, 250] (rel.tol 1e-10, `abs_error` column). Gauss is checked against 10·I(N(0,1)) (difference < 1e-6, asserted).

## Cross-checks done by the producer
- DeLong paired MCSE for mix, n = 200, delta = 2: 0.00389. A replicate bootstrap (300 resamples, seed 1, from the rds) gives 0.00398.
- Directions agree with the exploratory run and the referee log. The magnitudes differ by Monte Carlo error.

## Downstream
`R/make_derived_numbers.R` §11 → `results/derived/derived_scalars.csv` (quantities `set4_*`, each with a `_mcse` companion) → `paper/numbers_registry.csv` keys `set4NullSdRatioW1n200`, `set4NullSdRatioKSn200`, `set4IntegralRatio`, `set4DeltaAucGaussN200d2`, `set4DeltaAucMixN200d2`, `aucW1GaussN200d2`, `aucKSGaussN200d2`, `aucW1MixN200d2`, `aucKSMixN200d2`.

## Caveats a reader must keep
- These AUCs are for independent pairs at a single delta. They are not the Study 1 selection AUC (shared anchor, pooled across S1/S2), so they do not re-estimate the 333 / 377 required n.
- ρ_W sits below the integral ratio (1.68). The integral is the first-order scale of the null mean, not of the SD (protocol §2, does not license).
