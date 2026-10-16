import sys
sys.path.insert(0, r"C:\tmp\kb"); sys.path.insert(0, "scripts")
import kit
T = open(sys.argv[1], encoding="utf8").read()
base = kit.sect_words(T)
M = [
 ("roadmap", "Introduction", "The remainder of this paper is organized as follows.", "limitations, and future directions.", "", "pure deletion (approved paragraph)"),
 ("D16 additive clause", "Discussion", "Finally, the bound is per effect modifier: for a CATE additive across modifiers,", "marginal distances do not control the joint distance.", "", "narrows C-21; conflicts with brief (g)"),
 ("separable paragraph", "Discussion", "The distributional assessment and its calibration are separable:", "but does not change them.", "", "approved paragraph; sole carrier of the separability statement"),
 ("intro P4 (known/unknown modifiers)", "Introduction", "The extent to which the relevant effect modifiers are known varies", "however the candidates were identified.", "", "context paragraph; komiyama2024 stays cited"),
 ("4.2 source-of-null paragraph", "Application", "The choice of source region for the null is not neutral:", "on the same side of its 95th percentile.", "", "robustness statement of the null floor"),
 ("MOVE Set 4 check -> Appendix", "Simulation", "A check registered after an exploratory look", "the control is reported as a loss for $W_1$.", r"A registered check of this reversal is reported in Appendix~\ref{app:ks_bound}.", "relocation (C-49 mechanism, 8 numerals)"),
 ("MOVE 4.1 post hoc sensitivity -> Appendix", "Application", "Excluding these records changes", "and the step CDFs of Appendix~\\ref{app:asymptotic} apply.", r"The sensitivity of the distances, ranks and null-floor classifications to these records, to winsorizing and to the heaping of SBP readings (post hoc) is reported in Appendix~\ref{app:ks_bound}.", "relocation"),
 ("MOVE 2.4 Lee derivation -> Appendix", "Methods", "a rise of 19.4 percentage points over at least three decades", "which is one reason the bounds are illustrative.", r"a reference point rather than a guarantee (derivation in Appendix~\ref{app:ks_bound}).", "relocation (C-25)"),
 ("MOVE 2.3 Jensen bias -> Appendix", "Methods", "More precisely, it is biased upward at every sample size:", "whatever the sampling error of $\\widehat{W}_1$ as an estimate of $W_1$.", r"More precisely, it is biased upward at every sample size, $E\,\widehat{W}_1 \geq W_1$ (Appendix~\ref{app:asymptotic}), and the percentile interval does not correct this bias; for the enrolled samples the bound holds exactly with the empirical distributions.", "relocation (C-45)"),
 ("MOVE basic-interval sentence -> Appendix (Table 4 stays)", "Simulation", "The basic (reflected) interval", "were not pre-specified.", r"The basic (reflected) interval trades coverage away from the boundary for coverage at it (Table~\ref{tab:study2_intervals}; computed post hoc, not pre-specified).", "relocation/compression of a 10-12 post hoc sentence (rule 2 exposure)"),
 ("extension paragraph to 2 sentences", "Simulation", "added cells outside the original design:", "as systolic blood pressure is recorded).", r"added cells outside the original design (Table~\ref{tab:study2_ext}).", "10-13 paragraph; the cell list moves to the table note"),
 ("MOVE monotone factor sentence 4.4 -> Appendix", "Application", r"If the CATE were additionally assumed monotone, equation~(\ref{eq:mono_bound}) would replace", "and $L^*$ would be larger by the reciprocal.", r"The factor by which the monotone bound would shrink $\Delta_{\max}$ in this application is given in Appendix~\ref{app:ks_bound}.", "relocation (C-46, 10-12 sentence; 4 numerals)"),
 ("Discussion RWE paragraph", "Discussion", "Because $W_1$, like other covariate-distribution measures, requires only baseline", "before any regional data from the new trial exist.", "", "C-39 carrier (Sec. 4 opening states the stand-in assumption)"),
 ("4.3 first descriptive paragraph", "Application", "The two candidate effect modifiers produce different patterns of distributional difference.", "The rankings of partners by the two candidate effect modifiers differ.", "", "C-11 carrier; estimates stand in Table 8"),
]
for name, sec, s, e, new, note in M:
    if T.count(s) != 1:
        print("FAIL start", name, T.count(s)); continue
    si = T.index(s); ei = T.find(e, si)
    if ei < 0:
        print("FAIL end", name); continue
    T2 = T[:si] + new + T[ei + len(e):]
    a = kit.sect_words(T2)
    print("%-42s %-13s %+4d   %s" % (name, sec, a["TOTAL"] - base["TOTAL"], note))
