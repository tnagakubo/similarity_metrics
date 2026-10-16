from cuts2 import C, CUTS

# ---------------- wave 2: further compression ----------------
# --- Methods ---
C(id="M12", sec="Methods", tier="R3n", r3=True,
  mk="The reason to prefer equation (heterogeneity_bound) to the KS bound is therefore not sharpness, which each has within its own class, but the constant: L_clinical is a change in treatment effect per unit of the effect modifier ..., whereas TV(tau) is the total excursion ... clinically stated only for a monotone CATE; and among all bounds with the constant L_clinical, the equation is the smallest valid one, because the bound is sharp for that class (Appendix A.3) -> deleted (Neither bound dominates the other in general (Appendix A.3) stays). Surviving: opening paragraph of Sec. 2.2 (three reasons: per-unit clinical slope as its constant; valid for every CATE in the class, sharp when the slope is the only restriction), Sec. 2.1 (TV constant clinically stated only for a monotone CATE), last sentence of Appendix A.3 (every valid bound with the constant L is at least L W1)",
  start=r"""The reason to prefer equation~(\ref{eq:heterogeneity_bound}) to the Kolmogorov--Smirnov bound is therefore not sharpness""",
  end=r"""because the bound is sharp for that class (Appendix~\ref{app:ks_bound}). """,
  new=r"""""",
  claims="C-15, C-16",
  surv="'per-unit clinical slope as its constant' and 'valid for every CATE in the class, sharp when the slope is the only restriction' are in the opening paragraph of Sec. 2.2 and in Sec. 2.1 (TV(tau) clinically stated only for a monotone CATE); 'every valid bound with the constant L is at least L W1' is the last sentence of Appendix A.3")
C(id="M13", sec="Methods", tier="R3n", r3=True,
  start=r"""However, each of these approaches has limitations when applied to comparing effect modifier distributions across regions. SMD captures only location differences and is blind to variance and shape.""",
  end=r"""developed in the following subsections, satisfy all three requirements.""",
  new=r"""Each of these approaches has limitations for comparing effect modifier distributions across regions. SMD captures only location and is blind to variance and shape. EDF-based statistics such as the KS statistic capture full distributional differences but lack a clinically interpretable scale, and the bound on treatment effect heterogeneity they admit is governed by the total variation of the CATE, a constant that is clinically stated only for a monotone CATE (Section~\ref{sec:nabcd_metric}). KL divergence is asymmetric, can diverge to infinity when empirical distributions do not fully overlap, and requires density estimation that is impractical with small regional samples. None of these measures offers a bound on regional treatment effect differences whose constant is a per-unit clinical slope, the kind of quantity that treatment-by-covariate interaction analyses estimate. These gaps motivate a measure that (i) captures distributional features beyond location, (ii) provides a clinically interpretable scale, and (iii) offers such a bound; the Wasserstein-1 distance and its clinical calibration, developed next, satisfy all three.""",
  mk=r"""'However, each of these approaches has limitations when applied to ... SMD captures only location differences ... KL divergence is asymmetric---comparing region A to region B yields a different value than comparing B to A---can diverge ... These gaps motivate ...(iii) offers such a bound. The Wasserstein-1 distance ..., developed in the following subsections, satisfy all three requirements.' -> same content, 'KL asymmetric' explanation clause and connecting words dropped, last two sentences joined with a semicolon""",
  claims="C-14, C-15", surv="same paragraph (all three requirements, all three limitations, TV(tau) constant)")
C(id="M14", sec="Methods", tier="R3n", r3=True,
  start=r"""A property of $W_1$ central to our framework is that it carries the units of the underlying effect modifier.""",
  end=r"""(Section~\ref{sec:discussion} elaborates on this scope choice).""",
  new=r"""$W_1$ carries the units of the underlying effect modifier in each of the three equivalent forms of equation~(\ref{eq:wasserstein}): the CDF form integrates a dimensionless difference of probabilities over $x$, the quantile form differences of quantiles, and the coupling form distances $|x - y|$. $W_1(F_1, F_2)$ is therefore expressed on the original scale of the effect modifier, which supports direct clinical interpretation: a regional $W_1 = 5$~mmHg in systolic blood pressure means that optimally transporting one distribution onto the other moves probability mass an average distance of 5~mmHg. The same logic precludes a meaningful direct comparison of $W_1$ values across effect modifiers measured on different scales, so we restrict attention to per-effect-modifier assessment (Section~\ref{sec:discussion} elaborates on this scope choice).""",
  mk=r"""'A property of W1 central to our framework is that it carries the units of the underlying effect modifier. In each of the three equivalent forms ..., W1 carries the units of X: ... Consequently, W1 is expressed on the original scale ... This dimensional alignment supports ... we therefore restrict attention in this paper to ...' -> opening and 'Consequently' sentences merged into one, same units statement, example and scope restriction""",
  claims="C-04", surv="same paragraph (units in all three forms, original scale, 5 mmHg example, per-modifier scope)")
C(id="M15", sec="Methods", tier="F",
  start=r"""(ties are pervasive when an effect modifier is recorded on a coarse grid, as with systolic blood pressure recorded in whole mmHg in Section~\ref{sec:application}).""",
  end=r"""in whole mmHg in Section~\ref{sec:application}).""",
  new=r"""(ties are pervasive for coarsely recorded modifiers, such as systolic blood pressure in whole mmHg in Section~\ref{sec:application}).""",
  claims="C-22", surv="same sentence")
C(id="M16", sec="Methods", tier="F",
  start=r"""Because the quantiles of this limiting distribution depend on the unknown $F$, no universal critical values are available.""",
  end=r"""no universal critical values are available.""",
  new=r"""Its quantiles depend on the unknown $F$, so no universal critical values are available.""",
  claims="C-22", surv="same sentence")

# --- Simulation ---
C(id="S17", sec="Simulation", tier="B",
  start=r"""On the log-normal world, SMD computed on the log scale is also run;""",
  end=r"""a harm measure based on""",
  new=r"""Under the registered protocol the simulation also evaluated three representative-value distances built from one to three regional moments, SMD computed on the log scale in the log-normal world, a harm measure based on""",
  claims="C-28 (only carrier removed: Harvey's claim decision D-20261014-1 (b), B-tier; C-40 wording already lists the log-scale SMD as not reported)",
  surv="C-40 omission declaration (now lists the log-scale SMD); C-28 is retracted by this cut and must be marked in CLAIMS.md by Harvey")
C(id="S18", sec="Simulation", tier="R2c",
  start=r"""compares the sampling variability of $\widehat{W}_1$ under the two anchors: for the same two-unit shift at $n = 200$ per region, the Set 4 anchor population, whose two 5\% subgroups lie 40 units from the centre, multiplies""",
  end=r"""the Set 4 anchor population, whose two 5\% subgroups lie 40 units from the centre, multiplies""",
  new=r"""compares the two anchors: for the same two-unit shift at $n = 200$ per region, the Set 4 anchor population multiplies""",
  claims="C-49", surv="Design (Set 4 anchor: two 5% subgroups 40 units from the centre); 'null sampling standard deviation of W1hat' stays in the sentence")
C(id="S19", sec="Simulation", tier="F",
  start=r"""reflecting sample sizes typical in MRCT regional subgroups. We performed""",
  end=r"""reflecting sample sizes typical in MRCT regional subgroups. We performed""",
  new=r"""We performed""",
  claims="none", surv="n = 50, 100, 200 is the design constant (NUMBERS_LEDGER); the 'typical' remark had no source")
C(id="S20", sec="Simulation", tier="R2c",
  start=r"""Study~2 was run in R with the bootstrap implemented in C++ via Rcpp; replications were distributed over a PSOCK cluster with L'Ecuyer--CMRG random-number streams seeded per cell""",
  end=r"""the reported summaries are reproducible to Monte Carlo error.""",
  new=r"""Study~2 was run in R with the bootstrap in C++ via Rcpp, replications distributed over a PSOCK cluster with L'Ecuyer--CMRG random-number streams seeded per cell (\texttt{clusterSetRNGStream}, seed $42 + 1{,}000k$ for cell $k = 1, \ldots, 21$, scenarios in order and $n$ within scenario); because replicates are assigned to workers dynamically, individual replicates are not bit-reproducible, and the summaries are reproducible to Monte Carlo error.""",
  claims="none (reproducibility)", surv="same sentence (seed, stream, RNG, bit-reproducibility qualifier kept)")
C(id="S21", sec="Simulation", tier="R2c",
  start=r"""For the non-null scenarios away from the boundary (S3--S7), bias was small relative to each scenario's true $W_1$ and diminished with sample size; at $n = 200$ it was at most""",
  end=r"""as expected away from the boundary, where the limit of $\widehat{W}_1 - W_1$ is centred.""",
  new=r"""For the non-null scenarios away from the boundary (S3--S7), bias was small relative to each scenario's true $W_1$ and diminished with sample size: at $n = 200$ it was at most \numval{biasMaxS3toS7n200} (S7) (Figure~\ref{fig:simulation}(A)), and in S4 it was within Monte Carlo error at every $n$. Near the boundary (S1, S2) the positive bias was larger relative to the true value, as expected from the upward bias of Section~\ref{sec:estimation}. Under the null (S1), where the limit of $\widehat{W}_1$ is not centred, the bias fell at the $n^{-1/2}$ rate; in the other non-null scenarios (S2, S3, S5--S7; S4's bias is within Monte Carlo error) it fell faster, the bias at $n = 200$ being at most one third of that at $n = 50$ (Table~\ref{tab:bias}), as expected away from the boundary, where the limit of $\widehat{W}_1 - W_1$ is centred.""",
  claims="C-17, C-32", surv="same paragraph (all numbers, rate statements and qualifiers kept)")
C(id="S22", sec="Simulation", tier="R2d",
  start=r"""because with continuous data every bootstrap replicate of $\widehat{W}_1$ is positive, and at $F_1 = F_2$ the naive bootstrap is not consistent (Section~\ref{sec:estimation}); whether""",
  end=r"""(Section~\ref{sec:estimation}); whether""",
  new=r"""because with continuous data every bootstrap replicate of $\widehat{W}_1$ is positive; whether""",
  claims="C-22, C-23", surv="Sec. 2.3 and Appendix A.2 ('at F1 = F2 the naive bootstrap is not consistent')")
