# Are the simulations necessary, and are they the minimum?

Assessed against `paper/per_em_W1_wiley.tex` (2026-09-21 19:15) and the
recorded outputs in `results/`. The test applied to each study: **which
reported conclusion fails if this simulation is deleted?** A simulation that
binds no conclusion is confirmatory, not necessary.

## Verdict

| Simulation | Reps | Binds a conclusion? | Verdict |
|---|---|---|---|
| Study 2 — selection (AUC, false pooling, harm) | 10,000 / 3,000 | Yes — the only evidence for blind / partial / recovering | **Necessary** |
| Study 2 — clustering (ARI) | 5,000 / 2,000 | Yes — independent scoring currency; rules out a measure×task interaction | **Necessary** |
| Study 1 — estimation, S1 S2 S5 S6 | 10,000 | Yes (see below) | **Necessary** |
| Study 1 — estimation, S3 S4 S7 | 10,000 | No | **Confirmatory** |
| Procedure comparison (anchor vs clustering) | 100,000 | Yes — but the conclusion drawn is misstated | **Necessary, claim wrong** |
| Threshold simulation (`threshold_sim_summary.csv`, 8.6 MB) | — | Cited nowhere in the manuscript or supplements | **Unreported** |
| Independent replication (`louis_independent_replication.R`) | — | Cited nowhere | **Unreported** |

Nothing essential is missing. The programme is over-produced at the margin,
not under-powered.

## Study 1 — three of seven scenarios bind nothing

Study 1 supports exactly four statements. For each, the scenario that
*determines* it:

| Reported statement | Binding scenario |
|---|---|
| "we recommend $n \geq 100$ per region" | **S2** (coverage 0.703 at $n=50$), runner-up **S5** (0.862) |
| "coverage near-nominal for non-negligible differences at $n \geq 100$" | **S5** (0.917 at $n=100$ — the worst of S3–S7) |
| boundary behaviour / the null floor of §2.5 | **S1** (only scenario at the boundary) |
| "bias small relative to each scenario's $W_1$" | **S2** (relative bias 0.087 at $n=200$, the largest) |

Plus **S6**, which binds by construction: it is the only scenario in which
the difference is one of *shape*, and shape-blindness is the paper's central
claim about SMD. No other scenario substitutes for it.

That leaves **S3, S4, S7**. S3 and S4 are pure location shifts alongside S2,
and they do carry something S2 alone does not — the gradient showing that the
boundary effect decays as the true value moves away from zero (relative bias
at $n=50$: 0.495 → 0.035 → 0.003). Keeping *one* of the two preserves the
gradient; keeping both does not add to it.

**S7 is the weakest case.** Billed in Table 2 as "the most realistic MRCT
pattern", it is statistically interpolative between S3 and S5:

| | $n=50$ | $n=100$ | $n=200$ |
|---|---|---|---|
| coverage: S3 / **S7** / S5 | 0.951 / **0.929** / 0.862 | 0.951 / **0.935** / 0.917 | 0.948 / **0.943** / 0.946 |
| rel. \|bias\|: S3 / **S7** / S5 | 0.035 / **0.109** / 0.208 | 0.010 / **0.058** / 0.099 | 0.004 / **0.033** / 0.047 |

Five of the six statistics fall strictly between S3's and S5's; the sixth
(coverage at $n=200$) sits 1.3 Monte Carlo SE below the band, i.e. inside
noise. S7 is a realism check, and worth keeping as one — but it should not be
presented as evidence, because it cannot change a conclusion that S3 and S5
have not already fixed.

**Recommendation.** Keep all seven if space allows — the compute is trivial
(the whole of Study 1 ran in 32 minutes). But Tables 4–6 currently spend three
full tables on 21 cells to support four statements. Promote S1, S2, S5, S6 to
the main tables and move S3, S4, S7 to a supplement, or keep all seven and
say plainly which ones are load-bearing. The reader should not have to
reverse-engineer which scenario earns its place.

## The procedure comparison: necessary, and the conclusion is wrong

This study is the one the structural review recommends promoting out of the
Discussion. It is genuinely necessary — but not for the reason the manuscript
gives.

The manuscript states (§5, line 699):

> anchor-wise screening violated the pool-wide requirement in 61–68% of
> replications, and the rate **did not fall with sample size** across
> $n = 25$ to $400$, as expected of a structural rather than a sampling
> limitation.

The recorded output (`results/anchor_vs_clustering_tau_100k.csv`) contradicts
the middle clause. In every cell in the quoted band the rate falls:

| Cell | $n=25$ | $n=400$ | change | in MC SE |
|---|---|---|---|---|
| Set 1 Gaussian, $\tau = 8.00$ | 0.636 | 0.533 | −0.103 | 235 |
| Set 1 Gaussian, $\tau = 9.20$ | 0.642 | 0.447 | −0.195 | 443 |
| Set 2 Log-normal, $\tau = 15.20$ | 0.661 | 0.613 | −0.048 | 109 |

Monte Carlo SE is 0.00044, so these are not noise — the largest decline is
30% of the starting value.

The companion claim is correct: clustering's residual breach "declined from
16% at $n=25$ to below 1% at $n=400$" matches the worst cell exactly (0.157 →
0.0095).

**What the simulation actually shows** is better than what is claimed. Anchor
screening declines with $n$ but converges to a **non-zero plateau** (0.45–0.61
at $n=400$); diameter-controlled clustering decays toward zero (0.0095 worst
cell, most cells < 0.001). That contrast — non-zero asymptote versus decay to
zero — is precisely the structural-versus-sampling distinction, and it is
exactly what cannot be obtained without simulation. The triangle-inequality
argument in the same paragraph establishes that two partners within $\tau$ of
the anchor may lie $2\tau$ apart, but it cannot say how often that matters;
only the simulation can, and only the plateau makes the point.

Rewriting the clause to "declined with sample size but converged to a
non-zero plateau of 45–61%, unlike the diameter-controlled procedure, whose
breach rate decayed toward zero" is both correct and a stronger claim.

Note also that "61–68%" is a range across cells at differing $n$, not a range
at fixed $n$. Quoting it alongside "did not fall with sample size" reads as
though it were the latter.

## Two studies are in the repository but nowhere in the paper

`results/threshold_sim_summary.csv` is 8.6 MB — the largest result file in the
project — with companions `threshold_sim_operating.csv` and
`threshold_boot_summary.csv`. Neither the manuscript nor any of the three
supplement files mentions a threshold simulation.
`R/louis_independent_replication.R` likewise has no textual home.

These are not defects in the paper; they are unbilled work. Either they
support a claim that should cite them, or they were exploratory and should be
recorded as such in the repository README so a future reader does not assume
the paper omitted a result.

## Summary answer

**Necessary:** yes. Every study in the paper except three Study 1 scenarios
binds a conclusion, and the two Study 2 tasks are not redundant with each
other. Nothing essential is absent.

**Minimal:** not quite. Three of seven estimation scenarios are confirmatory,
and one of them (S7) is provably interpolative. The cost is paper real
estate — three tables and ~990 words — rather than compute.

**The real problem is not the number of simulations but what is claimed from
one of them.** The procedure comparison's headline is contradicted by its own
output, in the one paragraph where a simulation result appears without a
table to check it against. That is the argument for moving it into §3 as a
proper study.
