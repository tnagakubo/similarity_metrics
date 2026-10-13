# Wave 1 cuts. Each cut: id, tier, start (unique anchor), end (anchor after start, inclusive), new, claims, surv, r3 (needs Tak veto), mk (marker text)
# tier: F = free text (no 2026-10-12/13 revision, not Tak-approved); R2c = paragraph carries a 2026-10-12/13 marker, compressed with every number/qualifier/citation surviving (in prose or in a table/appendix);
#       R2d = deletion of a sentence that duplicates another in substance; R3d = pure deletion of repeated content in a Tak-approved paragraph; R3n = needs new connecting wording (Tak's veto)
CUTS = []
def C(**k):
    CUTS.append(k)

# ---------------- INTRODUCTION ----------------
C(id="I01", sec="Introduction", tier="F",
  start=r"""yet individual regional sample sizes in global MRCTs are often insufficient for such demonstration.""",
  end=r"""similarity of effect modifier distributions.\cite{iche17}""",
  new=r"""yet individual regional sample sizes in global MRCTs are often insufficient for that purpose. Regional pooling, in which regions with similar patient characteristics are grouped for analysis, is a key strategy for enhancing the assessment of regional consistency, and the ICH E17 guideline describes pooling decisions in terms of the similarity of effect modifier distributions.\cite{iche17}""",
  claims="C-01, C-18", surv="same claim content in the same paragraph (both citations kept)")
C(id="I02", sec="Introduction", tier="F",
  start=r"""An effect modifier is a baseline patient characteristic---such as age""",
  end=r"""are outside the present scope.""",
  new=r"""An effect modifier is a baseline patient characteristic, such as age, disease severity or a genetic marker, for which the treatment benefit differs across subgroups. Where it exists, regions with different patient compositions may observe different average treatment effects even if the drug works identically at the individual level: a region with predominantly younger patients would show larger benefits than one with predominantly older patients because the patient mix differs, not the drug. The similarity of the full effect modifier distribution, not only its average level, therefore matters for regional pooling. We focus on continuous effect modifiers such as age and disease severity scores; categorical effect modifiers raise distinct considerations and are outside the present scope.""",
  claims="C-19", surv="same paragraph (definition, non-constant-CATE mechanism, full-distribution point, scope); C-19 also carried by Intro P7-P8 and Methods opening")
C(id="I03", sec="Introduction", tier="F",
  start=r"""The extent to which the relevant effect modifiers are known varies across development programmes""",
  end=r"""and is agnostic to how the candidates were identified.""",
  new=r"""The extent to which the relevant effect modifiers are known varies across development programmes.\cite{komiyama2024} For some treatments, mechanism or prior trials identify a specific modifier in advance, such as a genetic marker known to determine response; more often, at the planning stage, the modifiers are only partially understood, and the sponsor proceeds from candidates suggested by biological plausibility or earlier-phase data, or from regional and ethnic factors that stand in as surrogates.\cite{komiyama2024} The framework developed here operates on whichever candidate effect modifiers the sponsor specifies: it quantifies the cross-regional distributional similarity of each candidate, orders regions by it, and calibrates it clinically, however the candidates were identified.""",
  claims="C-02 (context only)", surv="same paragraph")
C(id="I04", sec="Introduction", tier="F",
  start=r"""Song et al., writing on the NMPA's implementation of ICH E17""",
  end=r"""citing the reference volume discussed next.\cite{song2025}""",
  new=r"""Song et al., on the NMPA's implementation of ICH E17, identify the pooling strategy as an area where ambiguity remains and describe, when several effect modifiers are considered, clustering populations on distances defined from the correlation between effect modifiers and endpoints.\cite{song2025}""",
  claims="C-20", surv="same sentence (Song content kept; 'citing the reference volume discussed next' dropped)")
C(id="I05", sec="Introduction", tier="F",
  start=r"""each region is given a representative value for each candidate effect modifier, the values are typically standardized, and distances such as the Euclidean distance between regions are weighted for relevance""",
  end=r"""and does not evaluate the approach.\cite{komiyama2024} Two gaps remain.""",
  new=r"""each region is given a representative value for each candidate, the values are typically standardized, and distances such as the Euclidean distance are weighted for relevance, for instance through a Lasso regression on the outcome; the chapter notes that the selection of the distance measure is one of the key decisions, and does not evaluate the approach.\cite{komiyama2024} Two gaps remain.""",
  claims="C-02", surv="same sentence (all elements of C-02 kept)")
C(id="I06", sec="Introduction", tier="F",
  start=r"""and any finite set of summaries requires deciding in advance which distributional features are relevant, rather than comparing the full distributions directly.""",
  end=r"""rather than comparing the full distributions directly.""",
  new=r"""and any finite set of summaries requires deciding in advance which distributional features are relevant.""",
  claims="C-03", surv="same sentence (finite-set-of-summaries point kept)")
C(id="I07", sec="Introduction", tier="R2c",
  start=r"""These gaps bear on the planning stage, when the pooling strategy for small-sample regions is specified. In the PREVENT trial""",
  end=r"""so assessing their similarity requires more than comparing means.""",
  new=r"""In the PREVENT trial of secukinumab in non-radiographic axial spondyloarthritis, a workshop report by Matsushima et al.\ describes a post hoc pooling in which countries with a similar distribution of effect modifiers were clustered into five pooled regions, with treatment differences that varied slightly with the distribution of CRP and MRI positivity and sex across them; the report attributes the inconsistent result in the Japanese subgroup to imbalanced treatment assignment and a small sample size rather than to effect modifiers.\cite{matsushima2024} Forming pooled regions from effect modifier distributions is the step that a distance between regional distributions would quantify; that case involved binary characteristics, whereas continuous effect modifiers can differ in shape and spread as well as in level.""",
  claims="C-20", surv="same paragraph: Matsushima facts, attribution to assignment/sample size, 'step a distance would quantify' kept (bridge sentence and the restated 'requires more than comparing means' dropped; the latter is Intro P8)")
C(id="I08", sec="Introduction", tier="R3d",
  start=r""" Geometrically, $W_1$ equals the area between the two cumulative distribution functions.""",
  end=r"""area between the two cumulative distribution functions.""",
  new=r"""""",
  claims="C-04 (area-between-CDFs is stated in Sec. 2.2 and Fig. 1)", surv="Methods Sec. 2.2 ('the area between the two CDFs', Figure 1)")
C(id="I09", sec="Introduction", tier="R3n", r3=True,
  start=r"""Section~\ref{sec:methods} presents the methodological framework: existing measures and their limitations""",
  end=r"""discusses implications, limitations, and future directions.""",
  new=r"""Section~\ref{sec:methods} presents the framework, Section~\ref{sec:simulation} two simulation studies of identification and estimation, Section~\ref{sec:application} an illustration with publicly available individual patient data from the GUSTO-I trial, and Section~\ref{sec:discussion} implications, limitations, and future directions.""",
  mk=r"""roadmap sentences listing the contents of Sections 2-4 (existing measures ... clinical calibration; two simulation studies, evaluating identification and estimation properties; illustrates the framework) -> one clause per section""",
  claims="none", surv="every section is still named and ordered")

# ---------------- METHODS ----------------
C(id="M01", sec="Methods", tier="F",
  start=r"""An effect modifier is a factor for which the treatment effect varies across subgroups. Formally, let the conditional average treatment effect""",
  end=r"""Formally, let the conditional average treatment effect""",
  new=r"""Let the conditional average treatment effect""",
  claims="C-19", surv="Intro P3 defines the effect modifier")
C(id="M02", sec="Methods", tier="F",
  start=r"""Because treatment effects in clinical trials are typically summarized as mean differences, SMD provides a scale-free comparison directly relevant to the quantities that drive clinical decision-making. However, by construction SMD captures""",
  end=r"""However, by construction SMD captures""",
  new=r"""By construction, SMD captures""",
  claims="C-14 (SMD location-only is kept)", surv="the location-only statement and the N(50,5^2)/N(50,15^2) example are kept")
C(id="M03", sec="Methods", tier="R3n", r3=True,
  start=r"""whose slope changes sign at every crossing of the two CDFs; the Kolmogorov--Smirnov bound is likewise sharp within its own class, by a step CATE of height $\mathrm{TV}(\tau)$ at the point where $|F_1 - F_2|$ is largest. Sharpness over a class""",
  end=r"""is largest. Sharpness over a class""",
  new=r"""whose slope changes sign at every crossing of the two CDFs; the Kolmogorov--Smirnov bound is likewise sharp within its own class (Appendix~\ref{app:ks_bound}). Sharpness over a class""",
  mk=r"""the Kolmogorov--Smirnov bound is likewise sharp within its own class, by a step CATE of height TV(tau) at the point where |F1 - F2| is largest -> ... within its own class (Appendix A.3) [the step-CATE sentence is moved to A.3 verbatim]""",
  claims="C-15, C-16", surv="Appendix A.3 (step CATE of height TV(tau) at the point where |F1-F2| is largest); one-clause pointer in 2.2")
C(id="M04", sec="Methods", tier="R3n", r3=True,
  start=r"""A bound on the magnitude of $\tau$ itself tightens it further: on a support $[a, b]$""",
  end=r"""attains the bound at all. $\Delta_{\max} = L_{\text{clinical}} W_1$ is therefore a conservative upper bound by construction;""",
  new=r"""A bound on the magnitude of $\tau$ itself tightens it further, and over the recorded supports of Section~\ref{sec:application} the attaining $\tau^*$ would require effects beyond the baseline risks (Appendix~\ref{app:ks_bound}). $\Delta_{\max} = L_{\text{clinical}} W_1$ is therefore a conservative upper bound by construction;""",
  mk=r"""on a support [a,b] the attaining tau* ranges over up to L(b-a), which on the risk-difference scale is lipRangeAge for age and lipRangeSbp for SBP ... exceeding the highest 30-day mortality Lee et al. report (20.5% above 75 years) ...; for distributions with unbounded support no CATE bounded on the outcome scale attains the bound at all -> one clause plus the pointer; the whole sentence (derivation, both lipRange numerals, supports qualifier, Lee et al. comparison, unbounded-support caveat) is moved verbatim to Appendix A.3""",
  claims="C-05, C-16", surv="Appendix A.3 (verbatim sentence: derivation, both lipRange numerals, supports qualifier, Lee et al. comparison, unbounded-support caveat)")
C(id="M05", sec="Methods", tier="R3d",
  start=r"""Neither bound dominates the other in general; the comparison is given in Appendix~\ref{app:ks_bound}.""",
  end=r"""the comparison is given in Appendix~\ref{app:ks_bound}.""",
  new=r"""Neither bound dominates the other in general (Appendix~\ref{app:ks_bound}).""",
  claims="C-15", surv="same sentence")
C(id="M06", sec="Methods", tier="R2c",
  start=r"""The right-hand side of equation~(\ref{eq:heterogeneity_bound}) involves $W_1$ in its original measurement units, multiplied by a clinical slope $L_{\text{clinical}}$;""",
  end=r"""is mathematically redundant once equation~(\ref{eq:heterogeneity_bound}) is used for clinical calibration.""",
  new=r"""The right-hand side of equation~(\ref{eq:heterogeneity_bound}) involves $W_1$ in its original measurement units multiplied by a clinical slope $L_{\text{clinical}}$, so no further normalization is required for a clinically interpretable bound and we adopt $W_1$ in its original units throughout; normalizing by a within-effect-modifier scale measure such as the pooled interquartile range is redundant once the bound is used for calibration (Section~\ref{sec:inference}).""",
  claims="C-04", surv="same paragraph; derivation of the redundancy is in Sec. 2.4 (equation delta_max paragraph)")
C(id="M07", sec="Methods", tier="F",
  start=r"""The estimator $\widehat{W}_1$ inherits the original measurement units of the effect modifier. The asymptotic distribution""",
  end=r"""The asymptotic distribution""",
  new=r"""The asymptotic distribution""",
  claims="C-04", surv="Sec. 2.2 'Consequently, W_1 is expressed on the original scale of the effect modifier' and the abstract")
C(id="M08", sec="Methods", tier="F",
  start=r"""In the two-sample setting, when $\int \sqrt{F_r(1 - F_r)}\,dx < \infty$ for $r = 1, 2$, $n_1/(n_1 + n_2)$ stays away from 0 and 1""",
  end=r"""Convergence occurs at rate $\sqrt{n_1 n_2/(n_1+n_2)}$ (see Appendix~\ref{app:asymptotic} for details).""",
  new=r"""Under the conditions of Appendix~\ref{app:asymptotic}---integrable $\sqrt{F_r(1 - F_r)}$, a sample ratio $n_1/(n_1 + n_2)$ away from 0 and 1, and $\{x : F_1(x) = F_2(x) \in (0,1)\}$ of Lebesgue measure zero, as when the two CDFs cross only at isolated points---the Hadamard derivative of the $L_1$ functional at $F_1 - F_2$ is linear and the ordinary nonparametric bootstrap is consistent by the functional delta method;\cite{fang2019} where the CDFs coincide on an interval, including $F_1 = F_2$, the derivative is non-linear and the naive bootstrap is not consistent,\cite{dumbgen1993,fang2019,sommerfeld2018} and convergence occurs at rate $\sqrt{n_1 n_2/(n_1+n_2)}$.""",
  claims="C-22, C-23", surv="same paragraph + Appendix A.2 (conditions stated in full)")
C(id="M09", sec="Methods", tier="F",
  start=r"""A central feature of $W_1$ is its connection to treatment effect heterogeneity through Proposition~\ref{prop:heterogeneity}. This connection provides the basis for a clinically grounded interpretation framework rather than reliance on fixed numerical cutoffs.""",
  end=r"""rather than reliance on fixed numerical cutoffs.""",
  new=r"""""",
  claims="C-13 (no cutoffs is stated in the next paragraph and in Sec. 2.4 last paragraph)", surv="Sec. 2.4 closing paragraph ('W_1 has no universal cutoff'), abstract")
C(id="M10", sec="Methods", tier="F",
  start=r"""The two pathways---forward calibration via equation~(\ref{eq:delta_max}) when $L_{\text{clinical}}$ is known""",
  end=r"""cover the two evidence states encountered at the MRCT planning stage.""",
  new=r"""""",
  claims="C-06", surv="the two pathways are each stated in the paragraph preceding eq. (lstar) and in this paragraph (delta_max when L known; L* against L_UB when unknown)")
C(id="M11", sec="Methods", tier="F",
  start=r"""By presenting per-pair $\Delta_{\max}$ (or $L^*$) with bootstrap CIs alongside the clinical context""",
  end=r"""it governs how an estimate is displayed and read, not whether regions are pooled.""",
  new=r"""Per-pair $\Delta_{\max}$ (or $L^*$) with bootstrap CIs, presented alongside the clinical context (the overall treatment effect size, the non-inferiority margin, the minimal clinically important difference), are quantitative inputs for sponsor and regulatory judgment, which is not driven by a significance test;\cite{wasserstein2016} the one test, the null floor of Section~\ref{sec:estimation}, governs how an estimate is displayed and read, not whether regions are pooled.""",
  claims="C-13, C-42", surv="same paragraph + Sec. 2.3 (full null-floor test statement)")
