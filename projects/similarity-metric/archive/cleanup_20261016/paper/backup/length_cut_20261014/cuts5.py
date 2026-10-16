from cuts4 import C, CUTS

# ---------------- wave 4: items chosen by Harvey (menu 1-7) ----------------
C(id="H1", sec="Introduction", tier="F",
  start=r"""The extent to which the relevant effect modifiers are known varies across development programmes.""",
  end=r"""however the candidates were identified.""",
  new=r"""""",
  claims="C-02 (context only); Harvey menu 1",
  surv="komiyama2024 is cited in Sec. 1 paragraph 5 and Sec. 5; the 'framework operates on whichever candidates the sponsor specifies' scope statement is lost")
C(id="H2a", sec="Application", tier="F",
  start=r"""The choice of source region for the null is not neutral:""",
  end=r"""on the same side of its 95th percentile.""",
  new=r"""""",
  claims="C-12; Harvey menu 2",
  surv="one clause added to the permutation sentence of Sec. 4.2 (H2b)")
C(id="H2b", sec="Application", tier="R2c",
  start=r"""so the anchor-resampled floor is retained as the display reference.""",
  end=r"""so the anchor-resampled floor is retained as the display reference.""",
  new=r"""and drawing the null from the partner's own distribution instead of the anchor's leaves every distance on the same side of its 95th percentile, so the anchor-resampled floor is retained as the display reference.""",
  claims="C-12", surv="same sentence (the fact survives in one clause)")
C(id="H3", sec="Application", tier="F",
  start=r"""The two candidate effect modifiers produce different patterns of distributional difference.""",
  end=r"""the two candidate effect modifiers differ.""",
  new=r"""""",
  claims="C-11; Harvey menu 3",
  surv="point estimates and CIs in Table 8; 'rankings differ' stated by the rank-interval and R2/R9 contrast paragraphs and Sec. 5")
C(id="H4", sec="Discussion", tier="R3n", r3=True,
  start=r"""The distributional assessment and its calibration are separable:""",
  end=r"""but does not change them.""",
  new=r"""""",
  mk=r"""'The distributional assessment and its calibration are separable: the identification and efficiency results of the preceding paragraph are properties of the distance itself and hold whether or not L_clinical is available; clinical calibration adds an outcome-scale reading but does not change them.' -> paragraph deleted (Harvey menu 4; Sec. 2.4 states the two calibration pathways and Sec. 5 paragraph 1 states what the distance does without them)""",
  claims="none", surv="Sec. 2.4 (forward calibration when L known; reverse comparison when unknown)")
C(id="H5", sec="Simulation", tier="R2c",
  start=r"""unequal regional sizes (100 against 300; 200 against 1{,}000), a heavy-tailed reference distribution""",
  end=r"""as systolic blood pressure is recorded).""",
  new=r"""unequal regional sizes, a heavy-tailed reference distribution, integer-grid data, $n = 1{,}000$ per region and the application's operating point (the cells are described in the note to Table~\ref{tab:study2_ext}).""",
  claims="C-09; Harvey menu 5",
  surv="Table 5 note (every size, the t3 scaling and 5-unit shift, the integer rounding, the S3/S5 contrasts, the 0.2 SD operating-point cells); the prior-look clause and every coverage number stay in the paragraph")
C(id="H6", sec="Methods", tier="R3n", r3=True,
  start=r"""More precisely, it is biased upward at every sample size: since $E\,\hat{F}_r(x) = F_r(x)$""",
  end=r"""displaced upward (Section~\ref{sec:sim_results}).""",
  new=r"""More precisely, it is biased upward at every sample size, $E\,\widehat{W}_1 \geq W_1$ (Appendix~\ref{app:proof1}), and the percentile interval does not correct this bias, so near the boundary the whole interval is displaced upward (Section~\ref{sec:sim_results}).""",
  mk=r"""'it is biased upward at every sample size: since E F_r(x) = F_r(x), Jensen's inequality gives E|F1hat - F2hat| >= |F1 - F2| at every x, and integrating (the integrand is non-negative, so no further condition is needed) E W1hat >= W1 for all n1, n2; the percentile interval does not correct this bias, ...' -> 'biased upward at every sample size, E W1hat >= W1 (Appendix A.1), and the percentile interval does not correct this bias, ...' [the pointwise-Jensen / non-negative-integrand sentence is moved verbatim to Appendix A.1; the enrolled-sample sentence is unchanged] (Harvey menu 6)""",
  claims="C-45", surv="Appendix A.1 (Jensen derivation, verbatim); the statement and the enrolled-sample bound stay in Sec. 2.3")
C(id="H7", sec="Methods", tier="R3n", r3=True,
  start=r"""these exceed the prognostic age gradient implied by the 30-day mortality that Lee et al.\ report for GUSTO-I,""",
  end=r"""per year, though not the sum""",
  new=r"""these exceed the average prognostic age gradient implied by the 30-day mortality that Lee et al.\ report for GUSTO-I (at most about $6.5 \times 10^{-3}$ per year; Appendix~\ref{app:ks_bound}),\cite{lee1995} though not the sum""",
  mk=r"""'these exceed the prognostic age gradient implied by the 30-day mortality that Lee et al. report for GUSTO-I, 1.1% below 45 years and 20.5% above 75 years, a rise of 19.4 percentage points over at least three decades and hence an average gradient of at most about 6.5e-3 per year, though not the sum of two arm-level gradients ...' -> 'these exceed the average prognostic age gradient implied by the 30-day mortality that Lee et al. report for GUSTO-I (at most about 6.5e-3 per year; Appendix A.3), though not the sum of two arm-level gradients ...' [the 1.1%/20.5%/19.4-point arithmetic moves to a sentence in Appendix A.3; the 'reference point rather than a guarantee' qualifier stays] (Harvey menu 7)""",
  claims="C-25", surv="Appendix A.3 (1.1%, 20.5%, 19.4 points, three decades, 6.5e-3); lee1995 cited in 2.4 and A.3")
