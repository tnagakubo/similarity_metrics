---
# Machine-readable half of the protocol — compiled by `python3 scripts/protocol_compile.py PROTOCOL_{study}.md`
# into R/{study}.R (seed, grid, performance measures with Monte Carlo SE, outputs), results/{STUDY}_PROVENANCE.md
# and SIMULATION_FINDINGS_{study}.md. The prose sections below remain the registered protocol.
study: example_study            # identifier → R/example_study.R
claim_id: C-01                  # CLAIMS.md row this study supports
seed: 2026
n_sim: 2000                     # >= p(1-p)/eps^2 for the coverage target below (0.95*0.05/0.005^2 = 1900)
target_mcse: {coverage: 0.005}
estimand: "W1(F1,F2) = int |F1(t) - F2(t)| dt"
truth: {method: closed_form, note: "exact for location shifts; quadrature (rel.tol 1e-12) otherwise"}
dgm:
  - {name: S1, description: "N(50,10^2) vs N(50,10^2)", params: {mu1: 50, sd1: 10, mu2: 50, sd2: 10}, true_value: 0}
  - {name: S2, description: "N(50,10^2) vs N(52,10^2)", params: {mu1: 50, sd1: 10, mu2: 52, sd2: 10}, true_value: 2}
n_grid: [50, 100, 200]
methods:
  - {name: W1,  owner: ours,     fn: estimate_w1,  ci: percentile_bootstrap, B: 2000, description: "CDF-area W1 with percentile bootstrap CI"}
  - {name: SMD, owner: existing, fn: estimate_smd, description: "Austin 2011 standardized mean difference, as written"}
measures: [bias, empse, mse, coverage, ci_width]
outputs: {summary_csv: results/example_study_summary.csv, per_rep_rds: results/example_study.rds, log: results/example_study.log}
parallel: {workers: 1, rng: per_task_seed}
prior_look: none                # or: "scratchpad/scan.R 2026-09-26 — see §0"
---

# PROTOCOL — example_study (test fixture)

## 0. Prior look
なし
