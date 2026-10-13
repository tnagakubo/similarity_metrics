# Study 1/2 interval variants — provenance of `results/study2_interval_variants.csv`

Generated: 2026-10-12 (Mike, producer; verifier to be Katrina or Louis)
Producing script: `projects/similarity-metric/R/study2_interval_variants.R` (uncommitted at generation; parent commit `fad1010`)

## Origin and prior-look disclosure (RESEARCH_FRAMEWORK S8)

- **Exploratory, not pre-registered.** Added 2026-10-12 after the external review
  (`review_response/EXTERNAL_REVIEW_20261012.md`, M4(b)(c)(d)). No protocol in `PROTOCOL_*.md` §7 covers it.
- Prior look: the lab had seen `w1_raw_summary.csv` (two-sided percentile coverage) and `study1_miss_side.csv` (miss side) before
  writing this script. The variants (one-sided upper limit, basic interval) were named by the reviewer, not chosen after looking at
  their values. The script re-summarises existing replications; nothing was re-simulated or tuned.
- Licenses: describing how the stored percentile limits perform when read as a one-sided upper limit, and how the reflected
  (basic) interval built from the same limits would have performed, on the Study 1 grid. Does not license: any claim about the
  bias-corrected point estimate (not computable, below), or about grids/designs outside S1–S7 × n ∈ {50, 100, 200}.

## Input

| Item | Value |
|------|-------|
| Per-replicate source | `results/w1_raw_simulation.rds`, `$rep_data[["S{k}-{n}"]]`: 10,000 × 3 matrix (`estimate`, `ci_lower`, `ci_upper`); percentile 95% CI, B = 2,000 (see `STUDY1_PROVENANCE.md`) |
| Truth | `results/w1_raw_summary.csv` `true_W1` (exact; S6/S7 by quadrature). Never `x$summary` / `x$truth` |
| Seed | 20261012 declared; **not consumed** (no random numbers are drawn) |
| sessionInfo | `results/study2_interval_variants_sessionInfo.txt` |

## Definitions (per cell; t = true W1, θ̂ = estimate, [L, U] = stored percentile limits, R = 10,000)

- `cov_pct` = mean(L ≤ t ≤ U). Asserted equal to `w1_raw_summary.csv` `coverage_pct` (difference < 1e-12) and `width_pct` equal to `mean_ci_width`.
- `cov_upper` = mean(t ≤ U): coverage of U read as a one-sided 97.5% upper limit.
- `miss_below` = mean(t < L); `miss_above` = mean(t > U); identity `cov_pct = 1 − miss_below − miss_above` asserted per cell.
- Basic (reflected) interval [L_b, U_b] = [max(0, 2θ̂ − U), max(0, 2θ̂ − L)]; `cov_basic` = mean(L_b ≤ t ≤ U_b); `width_basic` = mean(U_b − L_b);
  `trunc_basic` = mean(2θ̂ − U < 0), the share of replications whose basic lower limit was truncated to 0.
- MCSE of a proportion p: sqrt(p(1 − p)/R); MCSE of a mean width: sd(width)/sqrt(R).
- `bc_available = FALSE`: the bias-corrected estimate 2θ̂ − mean(θ*) **cannot be computed** — the rds stores no bootstrap mean and no bootstrap replicate per replication.

## Caveats a reader must keep

- Under S1 (t = 0) `cov_upper` = 1 trivially (U > 0 always). The registry rows `covUpperS1n50` / `covUpperS1n200` carry no
  information about the interval's quality; they only document the identity. S2 also gives 1.0000 at every n in this run (empirical, not an identity). `covUpperMin/MaxS3toS7N100up` are printed to 4 dp (0.9710 / 0.9999) so that S5-100 is not read as exact coverage.
- Under S1 `cov_basic` equals `trunc_basic` exactly (t = 0 is covered iff L_b = 0, i.e. iff 2θ̂ ≤ U), so the basic interval's S1
  coverage is produced by the truncation at 0, not by the reflection.
- Cross-check with `study1_miss_side.csv`: equal (< 1e-12) for S1–S5. For S6/S7 that file was computed against the old Monte Carlo
  truths (`x$summary$true_W1`), so it differs from the exact-truth values here in the 4th decimal (e.g. S7-100 miss_below 0.0577
  here vs 0.0565 there). This CSV uses the exact truths; `study1_miss_side.csv` was not modified (the manuscript reads it).

## Re-run

    cd projects/similarity-metric && Rscript R/study2_interval_variants.R    # < 5 s, deterministic
