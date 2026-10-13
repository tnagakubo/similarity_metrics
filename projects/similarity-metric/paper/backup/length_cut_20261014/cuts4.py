from cuts3 import C, CUTS

# ---------------- wave 3 ----------------
C(id="I10", sec="Introduction", tier="R3d",
  start=r""" Unlike the standardized mean difference, $W_1$ responds to differences in variance and shape as well as location.""",
  end=r"""responds to differences in variance and shape as well as location.""",
  new=r"""""",
  claims="C-19, C-04", surv="the preceding paragraph of Sec. 1 (SMD captures only location; variance and shape), Sec. 2.2 ('Unlike the standardized mean difference, W1 responds to differences in variance, skewness, and other distributional features')")
C(id="M17", sec="Methods", tier="R3n", r3=True,
  start=r"""which is one reason the bounds are illustrative and $L^*$ is reported for every pair. Conclusions drawn from the bounds are conditional on them;""",
  end=r"""Alternative specification strategies include the deft estimator of Fisher et al.\cite{fisher2017}""",
  new=r"""which is one reason the bounds are illustrative. Conclusions drawn from the bounds are conditional on them; because $L^*$ is reported for every region pair, any alternative bound can be compared against it directly.""",
  mk=r"""'...which is one reason the bounds are illustrative and L* is reported for every pair. Conclusions drawn from the bounds are conditional on them; because L* is reported for every region pair, any alternative bound can be compared against it directly. Alternative specification strategies include the deft estimator of Fisher et al.' -> the repeated 'L* is reported for every pair' clause and the last sentence dropped (fisher2017 stays cited in the paragraph on the average slope)""",
  claims="C-24, C-25", surv="same paragraph; fisher2017 cited in the slope paragraph of Sec. 2.4")
C(id="S25", sec="Simulation", tier="R2c",
  start=r"""Consistent with the estimation-centered framework, we evaluated the operating characteristics of the sample Wasserstein-1 estimator $\widehat{W}_1$ for the population value $W_1$, reported in the original units of the effect modifier:""",
  end=r"""reported in the original units of the effect modifier:""",
  new=r"""We evaluated the operating characteristics of the sample estimator $\widehat{W}_1$ for the population value $W_1$, in the original units of the effect modifier:""",
  claims="none", surv="same sentence")
C(id="A10", sec="Application", tier="F",
  start=r""" Quantifying how each region differs from Region~8 mirrors the input a sponsor would bring to a pooling judgment as described in ICH E17.\cite{iche17}""",
  end=r"""as described in ICH E17.\cite{iche17}""",
  new=r"""""",
  claims="C-01", surv="Sec. 1 paragraph 2 and Sec. 5 (ICH E17 describes pooling in terms of the similarity of effect modifier distributions)")
C(id="A11", sec="Application", tier="R2d",
  start=r"""applied separately to each pair), that is, when it is one the estimator would produce with appreciable probability from two samples of identical distributions.""",
  end=r"""from two samples of identical distributions.""",
  new=r"""applied separately to each pair).""",
  claims="C-12, C-42", surv="Sec. 2.3 ('is one the estimator would produce with appreciable probability from identical distributions')")
C(id="A12", sec="Application", tier="R2c",
  start=r"""Before interpreting the distances reported in Section~\ref{sec:app_nabcd}, we computed the null floor of Section~\ref{sec:estimation} for each candidate partner, from two independent resamples, with replacement, from Region~8's (R8) empirical distribution""",
  end=r"""recomputing $\widehat{W}_1$ over $2{,}000$ repetitions, separately for each partner.""",
  new=r"""Before interpreting the distances of Section~\ref{sec:app_nabcd}, we computed the null floor of Section~\ref{sec:estimation} separately for each candidate partner, from two independent resamples, with replacement, of Region~8's (R8) empirical distribution at sizes $n_{\text{R8}} = \numval{nR8floor}$ and $n_{\text{partner}}$, recomputing $\widehat{W}_1$ over $2{,}000$ repetitions.""",
  claims="C-12", surv="same sentence")
C(id="A13", sec="Application", tier="R3n", r3=True,
  start=r"""Following Section~\ref{sec:inference}, we read $L^*$ against illustrative bounds that are the sponsor's clinical inputs""",
  end=r"""on the 30-day mortality scale.""",
  new=r"""""",
  mk=r"""'Following Section 2.4, we read L* against illustrative bounds that are the sponsor's clinical inputs, informed by the class-level evidence cited there: L_UB,age = 1e-2 per year (10%pt per decade) and L_UB,SBP = 2e-3 per mmHg (2%pt per 10 mmHg) on the 30-day mortality scale.' -> paragraph deleted (the same two bounds are stated in Sec. 2.4 and in the note of Table 9; the references to 'Section 4.4' for the bounds are repointed to Section 2.4)""",
  claims="C-25, C-36", surv="Sec. 2.4 (L_UB values and evidence), Table 9 note (both bounds)")
C(id="A14", sec="Application", tier="F",
  start=r"""with most partners below 1.5 years. For SBP, point estimates span from""",
  end=r"""with most partners below 1.5 years. For SBP, point estimates span from""",
  new=r"""with most partners below 1.5 years; for SBP, from""",
  claims="C-11", surv="same sentence")
