from cuts1 import C, CUTS

# ---------------- SIMULATION ----------------
C(id="S01", sec="Simulation", tier="R2d",
  start=r"""Study 1 compared the measures' ability to discriminate; Study 2 characterizes the estimator on which the calibration relies: bias, variability, and coverage probability of bootstrap confidence intervals for $\widehat{W}_1$.""",
  end=r"""bootstrap confidence intervals for $\widehat{W}_1$.""",
  new=r"""""",
  claims="none", surv="Sec. 3 opening paragraph ('Study 2 evaluates estimation performance: bias, variability, and coverage probability of bootstrap confidence intervals') and the Study 2 Design estimand list")
C(id="S02", sec="Simulation", tier="R2c",
  start=r"""Because the two studies answer different questions, they produce different sample-size statements. Study 1's required sample sizes are discrimination statements:""",
  end=r"""are not interchangeable with these.""",
  new=r"""Study 1's required sample sizes are discrimination statements, the per-region sample size at which a measure's area under the receiver operating characteristic curve (AUC) reaches at least 0.9, which for $\widehat{W}_1$ ranges from \numval{reqnW1minSets34} to \numval{reqnW1maxSets34} across the cells of Sets 3 and 4; Study 2's estimation statements (Section~\ref{sec:sim_results}) are not interchangeable with these.""",
  claims="C-08", surv="same sentence (both numerals, AUC definition and the not-interchangeable label kept)")
C(id="S03", sec="Simulation", tier="F",
  start=r"""Giving every measure the same $k$ removes threshold choice from the comparison entirely; supplying $k$ is itself an oracle, and the application chooses no $k$ but reads the ordering with the clinical calibration (Section~\ref{sec:application}).""",
  end=r"""(Section~\ref{sec:application}).""",
  new=r"""Giving every measure the same $k$ removes threshold choice from the comparison, though supplying $k$ is itself an oracle that the application does not use (Section~\ref{sec:application}).""",
  claims="C-48", surv="same sentence (oracle k acknowledged)")
C(id="S04", sec="Simulation", tier="R2c",
  start=r"""Two kinds of number appear in it, and they answer different questions. Reading down the $W_1$ column""",
  end=r"""on the same data-generating process.""",
  new=r"""In the symmetric-severity cell, for example, $W_1$ reaches the target at $n = \numval{reqnW1Set4symsevB}$ and the KS statistic at $n = \numval{reqnKSSet4symsev}$, a \numval{reqnRatioKSoverW1Set4symsev}-fold difference on the same data-generating process, and $W_1$'s own requirement ranges across the task from \numval{reqnW1Set4symsev} (symmetric severity) to \numval{reqnW1maxSets34b} (shape-symmetric mixtures) in Sets 3 and 4.""",
  claims="C-08", surv="same sentence (all five numerals kept; the 'two kinds of number' label is kept in the Sec. 3 opening paragraph)")
C(id="S08", sec="Simulation", tier="R2c",
  start=r"""Table~\ref{tab:bias} presents the bias of $\widehat{W}_1$ across scenarios and sample sizes, in the original units of the effect modifier (scenarios are specified with $\sigma = 10$). The estimator showed positive bias under the null hypothesis (S1), with bias decreasing from""",
  end=r"""the bias at $n = 200$ is about half that at $n = 50$ (Table~\ref{tab:bias}).""",
  new=r"""Table~\ref{tab:estimation} presents bias, coverage, RMSE and mean CI width of $\widehat{W}_1$ across scenarios and sample sizes, in the original units of the effect modifier (scenarios are specified with $\sigma = 10$). The estimator showed positive bias under the null scenario (S1), decreasing from \numval{biasS1n50} at $n=50$ to \numval{biasS1n200} at $n=200$: the finite-sample bias of Section~\ref{sec:estimation} ($E\,\widehat{W}_1 \geq W_1$), at its largest when the true value equals zero ($F_1 = F_2$ almost everywhere). The estimator remains consistent ($\widehat{W}_1 \to 0$ as $n \to \infty$ under the null), and the bias fell at a rate consistent with $n^{-1/2}$: at $n = 200$ it is about half that at $n = 50$.""",
  claims="C-17, C-23, C-32", surv="same paragraph + merged Table 3")
C(id="S09", sec="Simulation", tier="R2c",
  start=r"""For scenarios near the boundary (S1, S2), positive bias was larger relative to the true value---the upward bias of Section~\ref{sec:estimation}, which is largest relative to the true value when that value is close to zero.""",
  end=r"""when that value is close to zero.""",
  new=r"""Near the boundary (S1, S2) the positive bias was larger relative to the true value, as expected from the upward bias of Section~\ref{sec:estimation}.""",
  claims="C-17", surv="same sentence")
C(id="S10", sec="Simulation", tier="R2c",
  start=r"""Table~\ref{tab:coverage} presents coverage probabilities of the 95\% bootstrap confidence intervals. For the non-null scenarios S3--S7 at $n \geq 100$, coverage ranged over \numval{covRangeS3toS7N100up2dp}: S3 (""",
  end=r"""and S7 (\numval{covS7rangeN100up}); of these ten cells,""",
  new=r"""For the non-null scenarios S3--S7 at $n \geq 100$ (Table~\ref{tab:estimation}), coverage ranged over \numval{covRangeS3toS7N100up2dp}; of these ten cells,""",
  claims="C-09, C-17", surv="merged Table 3 (all S3-S7 coverage cells); range, MCSE count and the lowest cell (S5, n=100) kept in the sentence")
C(id="S11", sec="Simulation", tier="R2c",
  start=r"""S4 (1.0$\sigma$ location shift) showed coverage of \numval{covS4rangeAllN} across sample sizes, with no degradation at larger $n$, within two Monte Carlo standard errors of 0.95 only at $n = 200$. S5 (scale) showed undercoverage""",
  end=r"""improving to \numval{covS2n200} at $n=200$.""",
  new=r"""S4 (1.0$\sigma$ location shift) showed coverage of \numval{covS4rangeAllN} across sample sizes, with no degradation at larger $n$, within two Monte Carlo standard errors of 0.95 only at $n = 200$. S5 (scale) and S2 (small location shift, near the boundary) showed undercoverage at $n=50$ (\numval{covS5n50} and \numval{covS2n50}) that improved to \numval{covS5n200} and \numval{covS2n200} at $n=200$.""",
  claims="C-09, C-17", surv="same paragraph")
C(id="S12", sec="Simulation", tier="R2c",
  start=r"""Coverage for S1 (null) is shown as zero in Figure~\ref{fig:simulation}(B) because""",
  end=r"""Coverage for S1 (null) is shown as zero in Figure~\ref{fig:simulation}(B) because""",
  new=r"""Coverage for S1 (null) is zero (Table~\ref{tab:estimation}, Figure~\ref{fig:simulation}(B)) because""",
  claims="C-17", surv="same sentence (S1 zero coverage now also a table cell)")
C(id="S13", sec="Simulation", tier="R2c",
  start=r"""against 2.5\% nominal, and the shortfall came from intervals lying above the true value. In S2, S5 and S7, where coverage falls short, the upper confidence limit is therefore a conservative reading of how large a difference could be;""",
  end=r"""how large a difference could be;""",
  new=r"""against 2.5\% nominal. The upper confidence limit is therefore a conservative reading of how large a difference could be in S2, S5 and S7;""",
  claims="C-17", surv="same sentence (miss-from-below and the S6 contrast kept)")
C(id="S15", sec="Simulation", tier="R2c",
  start=r"""The mean CI width pattern across scenarios and sample sizes is shown in Figure~\ref{fig:simulation}(C). Table~\ref{tab:precision} presents the RMSE and mean CI width across scenarios, in the original units of the effect modifier. RMSE decreased consistently with increasing $n$,""",
  end=r"""RMSE decreased consistently with increasing $n$,""",
  new=r"""RMSE decreased consistently with increasing $n$ (Table~\ref{tab:estimation}),""",
  claims="C-32", surv="same sentence; merged Table 3")
C(id="S16", sec="Simulation", tier="R2c",
  start=r"""Mean CI width narrowed with $n$, with CIs at""",
  end=r"""Mean CI width narrowed with $n$, with CIs at""",
  new=r"""Mean CI width narrowed with $n$ (Figure~\ref{fig:simulation}(C)), with CIs at""",
  claims="C-32", surv="same sentence")

# ---------------- APPLICATION ----------------
C(id="A01", sec="Application", tier="F",
  start=r"""A sponsor is developing a novel thrombolytic agent (Drug~T) for AMI and is planning a Phase~3 MRCT across multiple regions. At the planning stage, the sponsor uses IPD from GUSTO-I""",
  end=r"""At the planning stage, the sponsor uses IPD from GUSTO-I""",
  new=r"""A sponsor developing a novel thrombolytic agent (Drug~T) for AMI plans a Phase~3 MRCT across multiple regions and uses IPD from GUSTO-I""",
  claims="C-10, C-39", surv="same sentence")
C(id="A02", sec="Application", tier="R2c",
  start=r"""For this illustrative exercise, the sponsor identifies two candidate effect modifiers for Drug~T's treatment effect in AMI: age and systolic blood pressure (SBP). Drug~T's Phase~2 programme has suggested age and SBP as candidate effect modifiers on the basis of exploratory analyses and biological plausibility, but the precision of these analyses is insufficient for numerical estimation of $L_{\text{clinical}}$.""",
  end=r"""insufficient for numerical estimation of $L_{\text{clinical}}$.""",
  new=r"""For this illustrative exercise, the sponsor takes age and systolic blood pressure (SBP) as the candidate effect modifiers for Drug~T, suggested by exploratory Phase~2 analyses and biological plausibility whose precision is insufficient for numerical estimation of $L_{\text{clinical}}$.""",
  claims="C-25", surv="same sentence")
C(id="A03", sec="Application", tier="R2c",
  start=r"""The sponsor selects Region~8 as the anchor region---representing, for instance, a regulatory market where local efficacy evidence is required. Region~8 comprises $n = \numval{nR8}$ patients in GUSTO-I, with baseline characteristics summarized in Table~\ref{tab:gusto_r8}; the anchor role, not its size, is what the exercise illustrates.""",
  end=r"""is what the exercise illustrates.""",
  new=r"""The sponsor selects Region~8 as the anchor region, representing for instance a regulatory market where local efficacy evidence is required; it comprises $n = \numval{nR8}$ patients (Table~\ref{tab:gusto_r8}), and the anchor role, not its size, is what the exercise illustrates.""",
  claims="C-10", surv="same sentence")
C(id="A04", sec="Application", tier="R2c",
  start=r"""we computed the null floor of Section~\ref{sec:estimation} for each candidate partner. For each partner we drew two independent resamples""",
  end=r"""as its dependence on both sample sizes requires. We call an observed distance unresolved when it lies at or below the 95th percentile of its null distribution---a one-sided test of $F_1 = F_2$ at level 0.05, applied separately to each pair---a reference point for reading the estimate: the observed distance is then one the estimator would produce""",
  new=r"""we computed the null floor of Section~\ref{sec:estimation} for each candidate partner, from two independent resamples, with replacement, from Region~8's (R8) empirical distribution at sizes $n_{\text{R8}} = \numval{nR8floor}$ and $n_{\text{partner}}$, recomputing $\widehat{W}_1$ over $2{,}000$ repetitions, separately for each partner. We call an observed distance unresolved when it lies at or below the 95th percentile of its null distribution (a one-sided test of $F_1 = F_2$ at level 0.05, applied separately to each pair), that is, when it is one the estimator would produce""",
  claims="C-12, C-42", surv="same paragraph + Sec. 2.3 (construction of the null floor)")
C(id="A05", sec="Application", tier="F",
  start=r"""Because the null is drawn from one region's distribution, the choice of which region is not neutral:""",
  end=r"""so the finding does not depend on which of the two sources is used.""",
  new=r"""The choice of source region for the null is not neutral: drawing from the anchor asks what $\widehat{W}_1$ would look like if the partner were distributed as R8 is, which is the null appropriate when the partner's data are to inform the anchor. Repeating the computation with each partner's own distribution as the source leaves every distance on the same side of its 95th percentile.""",
  claims="C-12", surv="same paragraph (invariance to the source kept)")
C(id="A06", sec="Application", tier="R2c",
  start=r"""The practical consequence of the null floor here is that the small age distances of the six partners unresolved at level 0.05 are not evidence of a difference;""",
  end=r"""are not evidence of a difference;""",
  new=r"""The small age distances of the six partners unresolved at level 0.05 are therefore not evidence of a difference;""",
  claims="C-12", surv="same sentence")
C(id="A07", sec="Application", tier="R2c",
  start=r"""Table~\ref{tab:gusto_nabcd} presents the results. Figure~\ref{fig:gusto_forest} displays these results as a forest plot with bootstrap CIs, with partners ordered by ascending $\widehat{W}_1$ within each panel.""",
  end=r"""ascending $\widehat{W}_1$ within each panel.""",
  new=r"""Table~\ref{tab:gusto_nabcd} and Figure~\ref{fig:gusto_forest} (a forest plot) present the results.""",
  claims="C-11", surv="Figure 3 caption states the ordering and the CIs")
C(id="A08", sec="Application", tier="F",
  start=r"""Several partners fall in the middle of each ranking where uncertainty intervals overlap substantially""",
  end=r"""and a bare rank is not read as a resolved order.""",
  new=r"""Several partners fall in the middle of each ranking where uncertainty intervals overlap substantially, and the rank intervals of Table~\ref{tab:gusto_nabcd}, obtained by resampling patients within every region, show how far such a partner can move: a mid-table rank is not resolved against its neighbours (R6 ranks ninth on age and fifth on SBP, and both of its rank intervals span most of the middle of the table), whereas the most distant partners, R2 on age and R9 on SBP, have rank intervals confined to the most distant positions, so a bare rank is not read as a resolved order.""",
  claims="C-43", surv="same paragraph (mid-table half: R6 sentence; distant half: R2/R9); R6 estimates and CI stay in Table 8")
C(id="A09", sec="Application", tier="F",
  start=r"""A ranking based on either candidate effect modifier alone would order these two regions oppositely. """,
  end=r"""would order these two regions oppositely. """,
  new=r"""""",
  claims="C-35", surv="the preceding sentences of the paragraph state the reversal; the next sentence states what it illustrates")

# ---------------- DISCUSSION ----------------
C(id="D01", sec="Discussion", tier="R3n", r3=True,
  start=r"""Its estimation is characterized by Study~2: percentile bootstrap intervals whose coverage was""",
  end=r"""with a characterized boundary behavior near the null (Section~\ref{sec:estimation}).""",
  new=r"""Its estimation is characterized by Study~2 (Section~\ref{sec:sim_results}); the coverage range and the boundary behaviour near the null are reported there.""",
  mk=r"""Its estimation is characterized by Study 2: percentile bootstrap intervals whose coverage was [range] for true distances of about [x] to [y] SD in the location, scale, and combined scale-and-skewness scenarios at n >= 100 per region, below 0.95 beyond Monte Carlo error in [k] of the ten cells, with a characterized boundary behavior near the null (Section 2.3) -> Its estimation is characterized by Study 2 (Section 3.2.2); the coverage range and the boundary behaviour near the null are reported there""",
  claims="C-09", surv="abstract; Sec. 3.2.2 (range, MCSE count, lowest cell); Discussion limitations paragraph (scale of the range, minW1SdS3toS7 to maxW1SdS3toS7 SD, equal sizes)")
C(id="D02", sec="Discussion", tier="R2c",
  start=r"""These methodological findings carry two interpretive implications for pooling assessments, illustrated by the GUSTO-I example""",
  end=r"""and both are reported.""",
  new=r"""These findings carry two implications for pooling assessments, illustrated by the GUSTO-I example (Section~\ref{sec:application}). First, when several candidate effect modifiers are considered, the per-modifier distances need not agree: a partner close to the anchor on one effect modifier can be distant on another, as in the contrast between R2 and R9, so the distance on a modifier left out of the assessment need not be inferable from those included. Second, $W_1$ ranking alone does not convey clinical weight: within one effect modifier $L^* = \Delta_{\text{clin}} / W_1$ is a strictly decreasing function of $W_1$, so calibration does not reorder partners; it compares each partner's $L^*$ with the bound $L_{\text{UB}}$ specified for that modifier, and both are reported.""",
  claims="C-35, C-06", surv="same paragraph")
C(id="D03", sec="Discussion", tier="R2c",
  start=r"""from 1{,}000 patient-level bootstrap replicates that resample within each region and recompute both orderings;""",
  end=r"""recompute both orderings;""",
  new=r"""from the patient-level bootstrap of Table~\ref{tab:gusto_nabcd};""",
  claims="C-11", surv="Table 8 note (1,000 patient-level bootstrap replicates that resample within every region)")
C(id="D04", sec="Discussion", tier="R3n", r3=True,
  start=r"""Of the limitations set out in Section~\ref{sec:existing}, the location-only limitation of SMD is structural, and Study 1 exhibits its consequence:""",
  end=r"""does not, however, mean returning a different answer in every dataset.""",
  new=r"""Of the limitations set out in Section~\ref{sec:existing}, the location-only limitation of SMD is structural and the lack of a clinical scale is addressed by the heterogeneity bound (equation~\ref{eq:delta_max}), while those of KL divergence are avoided by construction, $W_1$ being symmetric, finite for any pair of empirical distributions, and computable from CDFs without density estimation; this does not mean returning a different answer in every dataset.""",
  mk=r"""Of the limitations set out in Section 2.1, the location-only limitation of SMD is structural, and Study 1 exhibits its consequence: in the mean-matched cells, SMD is at chance at every sample size examined while W1 recovers the partner structure (Section 3.1.2); the lack of a clinical scale is addressed by ...; and the limitations of KL divergence are avoided by construction ... Addressing these limitations does not, however, mean returning a different answer in every dataset -> one sentence with the same three limitations (the Study 1 restatement of paragraph 1 (i) dropped)""",
  claims="C-14, C-07", surv="Discussion paragraph 1 (i) states SMD at chance in 7 of 13 cells while W1 reaches the target; Sec. 2.1; Sec. 3.1.2")
C(id="D06", sec="Discussion", tier="R3n", r3=True,
  start=r"""First, the constant is a clinical judgment: $L_{\text{UB}}$ is specified by the sponsor""",
  end=r"""Third, for a CATE that changes steeply""",
  new=r"""First, the constant is a clinical judgment, informed but not determined by prior evidence (Section~\ref{sec:inference}), so conclusions drawn from $\Delta_{\max}$, or from the comparison of $L^*$ with $L_{\text{UB}}$, are conditional on it; the same holds for an $L_{\text{clinical}}$ taken from an estimated average interaction slope, a lower bound on the Lipschitz constant, for which the safety factor of Section~\ref{sec:inference} is a judgment the framework does not supply. Second, for a CATE that changes steeply""",
  mk=r"""First, ... L_UB is specified by the sponsor, ... conditional on it; reporting L* leaves the comparison open to any alternative bound. Second, an L_clinical taken from an estimated average interaction slope is a lower bound on the Lipschitz constant ...; the safety factor of Section 2.4 is a judgment of the same kind as margin discounting, and the framework does not supply its value. Third, ... -> First (merged with Second) ...; Second, ... [two sentences merged, 'Third' renumbered]""",
  claims="C-24, C-25", surv="Sec. 2.4 (judgment, lower bound, safety factor, margin discounting, 'L* reported for every pair so any alternative bound can be compared')")
C(id="D07", sec="Discussion", tier="R3n", r3=True,
  start=r"""The requirement is also local: since $\bar{\tau}_1 - \bar{\tau}_2 = -\int (F_1 - F_2)\,d\tau$""",
  end=r"""because marginal distances do not control the joint distance.""",
  new=r"""The requirement is also local: since $\bar{\tau}_1 - \bar{\tau}_2 = -\int (F_1 - F_2)\,d\tau$, the bound holds with $L_{\text{clinical}}$ replaced by the Lipschitz constant of $\tau$ on $\{x : F_1(x) \neq F_2(x)\}$, so saturation of the CATE outside that range does not loosen it, although for distributions with full support, such as normal distributions, that range is the whole line. Finally, the bound is per effect modifier: for a CATE additive across modifiers, $\tau(x) = \sum_k \tau_k(x_k)$, the per-modifier bounds combine as $|\bar{\tau}_1 - \bar{\tau}_2| \leq \sum_k L_k W_1^{(k)}$ and each per-modifier $\Delta_{\max}$ is the contribution attributable to that modifier, whereas under interaction between modifiers they do not, because marginal distances do not control the joint distance.""",
  mk=r"""'The requirement is also local: ... for distributions with full support, such as normal distributions, that range is the whole line. Finally, the bound is per effect modifier: it assumes the CATE varies with that modifier alone. When the CATE is additive across modifiers, ..., the per-modifier bounds combine as ..., and each per-modifier Delta_max is the contribution attributable to that modifier; under interaction between modifiers they do not, because ...' -> same locality statement and full-support qualifier ('although' replaces the sentence break), 'it assumes the CATE varies with that modifier alone' dropped (it stays in Proposition 1 and the abstract), the two additive sentences joined into one with all formulas and qualifiers kept (C-21 sole carrier)""",
  claims="C-21", surv="same paragraph (locality set, full-support statement, additive sum, per-modifier contribution, interaction qualifier all kept); 'depends on the effect modifier alone' stays in Proposition 1 and the abstract")
C(id="D08", sec="Discussion", tier="R2d",
  start=r"""Beyond the scope and methodological extensions noted above, two further directions warrant investigation. The upstream identification of which baseline characteristics""",
  end=r"""the present framework then quantifies distributional distance on the retained modifiers. Inference tailored""",
  new=r"""Inference tailored""",
  claims="none", surv="Sec. 2.4 (effect modification versus prognosis); the limitations paragraph already leaves categorical and multivariate extensions for future work; bickel1997 and hong2018 kept in the remaining sentence")
