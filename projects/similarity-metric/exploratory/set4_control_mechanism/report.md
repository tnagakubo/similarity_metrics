> **EXPLORATORY — not pre-registered, not citable from the manuscript.** Promote via /protocol.

# Why the KS statistic reaches AUC 0.9 first in the Set 4 bulk-shift control — exploratory check

**Date**: 2026-10-12（D-20261012-2, Louis C4）**Owner**: Mike（run）/ Donna（this file, transcribed from Mike's hand-back because the harness refused the agent's own write）
**Question**: for a pure location shift δ, does the ordering of W₁ and KS in sample size to discrimination follow the sampling noise of Ŵ₁ (which scales with ∫√(F(1−F))dx and is inflated by the remote 5% tails of the Set 4 anchor) while D_KS stays distribution-free?
**Verdict**: **Supported**, with one refinement. Not for the manuscript; the manuscript states the facts only (Table 1: KS first in the Set 4 control, W₁ first in the Sets 1–2 location cells).

## Design（`R/set4_control_mechanism.R`, seed 20261012, n_sim = 2,000 per cell, serial, 4.6 min）
Base (a) N(50, 10²); base (b) the Set 4 anchor mixture (core N(50,10²) 90%, tails N(50±40, 8²) 5% each, from `R/selection_simulation.R` build_set4). Shifts δ ∈ {2, 3}; n ∈ {100, 200, 400} per region; statistics Ŵ₁ (CDF-area) and D_KS; outputs Monte Carlo SD under null and shift, standardized separation, AUC (Mann–Whitney), paired ΔAUC with MCSE (bootstrap of replicates, B = 500), ∫√(F(1−F))dx by numerical integration.

## Key numbers（`results/*.csv`）
- ∫√(F(1−F))dx: (a) 16.147, (b) 27.156, ratio 1.682.
- Null SD ratio (b)/(a): Ŵ₁ 1.52–1.59; KS 1.00–1.03. Null mean ratio Ŵ₁ 1.67–1.68 (≈ the integral ratio).
- Base (a): W₁ separates better than KS in all 6 cells, paired ΔAUC +0.005 to +0.035 (≥ 4.9 MCSE).
- Base (b): KS separates better in all 6 cells, ΔAUC −0.012 to −0.028 (11 of 12 pre-specified 2-MCSE checks met; n = 100, δ = 2 at exactly 2.0 MCSE).
- Decomposition: separation ratio (b)/(a) is 0.71–0.86 for KS and 0.57–0.65 for W₁; the difference comes from the noise ratio (W₁ 1.31–1.33 vs KS 0.99–1.02). KS also loses signal because its estimand shrinks (true D_KS 0.0797 → 0.0717 with bulk weight 0.9); W₁'s true value stays δ.
- Study 1 estimand bridge (anchor shared, 3 matches, δ ∈ {2,3}): (a) W₁ > KS at every n; (b) KS > W₁ at every n, both crossing AUC 0.9 between n = 200 and 400 — consistent with 333 (KS) vs 377 (W₁).
- Refinement: E Ŵ₁ under the null ≈ √(4/(πn)) ∫√(F(1−F))dx (one-sample law from del Barrio, Giné & Matrán 1999, DOI 10.1214/aop/1022677394; two-sample extension is Mike's own derivation in README.md) matches the null mean to within 1%; the null SD ratio falls short of the integral ratio by 2.7–3.5 MCSE at n = 100 and 400, so the proportionality is exact for the location of Ŵ₁ and only approximate for its spread.

## What would have to happen before any of this enters the manuscript
`PROTOCOL_set4_control_mechanism.md` (prior look: this run), a family of base distributions graded by ∫√(F(1−F))dx at fixed SD, estimand = paired ΔAUC and noise ratio, n_sim from a target MCSE of 0.003 on ΔAUC, numbers through `R/make_derived_numbers.R` → registry. The general efficiency question (when does the sup-norm discriminate a shift with fewer patients) is outside Aim A1 → `IDEAS_BACKLOG.md` I-20261012-2.
