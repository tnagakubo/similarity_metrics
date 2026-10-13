---
name: feedback_own_fix_text_and_marker_swallow
description: The team adopts Louis's paste-ready fixes verbatim, so his own fix text must be checked against every CSV cell (2026-10-12: 5 of his fixes were false); and a "% Paragraph revised" marker can swallow manuscript prose (2 sites, in the PDF)
metadata:
  type: feedback
---

**1. My own fix column is evidence-free until I check it.** In INTERNAL_REVIEW_20261012 I attacked the team for adding explanations they had not checked against the CSV. Then I wrote paste-ready fixes the same way, and D-20261012-2 adopted them verbatim. Five were false or overreached:
- the bias/SD "orders them by coverage" claim (S4 left out; S4-100 has the lowest bias/SD and is below nominal);
- "conservative where the CDFs cross" (S6 misses above the upper limit at the nominal rate);
- "both depend on the distance relative to the sampling variability" (the axis I had just refuted);
- "Where SMD is not blind", which reported 4 of the 6 non-blind cells;
- "S3 within MC error" (it is 3.7 MCSE; Katrina caught it).
The E17 "leaves to sponsors and regulators" (m14) also had no source.

**Why:** the lab treats my wording as already reviewed. No second reviewer checks the reviewer, so my errors go into the manuscript with no filter.

**How to apply:** before suggesting any fix sentence with an ordering, a mechanism, a rate or a universal ("orders", "where X", "within MC error", "where SMD is not blind"), tabulate **every** cell of the relevant CSV, never only the cells that illustrate the point. Mark my own suggestions as needing CSV verification, so the team runs /necessity on them too. In /review-fix, tag rows that trace back to my text as [Louis-source].

**2. Marker swallow.** Prose placed on the same line after a `% Paragraph revised ...` comment disappears from the PDF (2026-10-12: l.465 "We therefore treat L as unknown..." and l.577 "...remain clinical judgments"). cascade_check showed both as "(deleted)" and nobody mapped them to a decided cut. Check: every "(deleted)" row must match a cut named in the decision, and pdftotext-grep the restored sentence. [[feedback_fix_explanations_unchecked]] [[feedback_patch_without_cascade]] [[feedback_referee_20261011_patterns]]

**3. Recurrence, round 3 (2026-10-12 17:35, D-20261012-3).** The swallow came back on the "% Sentences revised ... (Louis four-eyes round 3)" marker at l.323. It ate the target-dependence disclosure and the SMD-not-blind sentence, and l.428 lost a sentence the same way. The guard that pinned the disclosure then passed on "0 sentences match", vacuous because the text was gone. The mechanical check: no comment line may contain \numval{, \ref{ or \cite{ (proposed guard G7). Also: in /review-fix, every guard reporting "0 sentence(s) match stem" counts as vacuous until shown otherwise.

**4. Checks the new post hoc sentences failed (round 3, 3 Criticals).**
- Structural: two distinct distributions with equal means have CDFs that must cross, because the integral of (F2-F1) is mu1-mu2. "S6 (mean-matched) whose CDFs do not cross" was false on its face.
- Universals over cells ("wherever the interval undercovers", "in every non-null cell") written for new interval variants: tabulate every cell, n=50 included, and apply the paper's own 2-MCSE rule before accepting "wherever" or "every".
- A cell count of 0.9710 below 0.975 inside a printed range means some cell is below nominal. Find which one before reading "conservative".
