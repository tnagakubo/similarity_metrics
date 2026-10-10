---
name: feedback-patch-without-cascade
description: Recurring team weakness - a claim is corrected in one location and the identical claim survives in 2-4 others; always grep the claim's keywords across the whole file before accepting a fix
metadata:
  type: feedback
---

On any **claim-level** correction (not typo-level), grep the claim's keywords across the entire manuscript before accepting the fix. A correction applied to one sentence is not applied to the claim.

**Why:** documented recurrence in this project.
- 2026-09-21, external referee M1 ("the heterogeneity bound is specific to W1" is false): the fix was applied to the §2.2 paragraph and to one Discussion clause, but the same overclaim survived at three other sites in the same file — §2.2 opening ("its *unique* theoretical connection to treatment effect heterogeneity"), §2.1 two sentences above the edited sentence ("EDF statistics ... have *no theoretical connection* to treatment effect heterogeneity"), and Discussion §5.1 ("the KS statistic ... lack ... a theoretical link to treatment effect heterogeneity"). The corrected §2.1 paragraph then contradicted itself within four sentences.
- Same referee, M4 (null floor is permissive → conservative reading is {R6,R14}): the new §4.4 paragraph landed three paragraphs above an untouched "R4 emerges as the leading single-pool candidate", and the Discussion repeated the R4 claim. R4 is on the referee's own age-unresolved list.
- Earlier instance recorded in `templates/review_checklist.md` C1: §4 rewritten IST-3 → GUSTO-I, old numbers left in four Discussion paragraphs, two §3 calibration examples and the Data availability statement.

**How to apply:** before adopting any claim correction, run C1 Cross-Section Cascade Check with an explicit grep list built from the claim's load-bearing words (here: `unique`, `specific to`, `no theoretical connection`, `analogous`, `R4`, `six partners`). Residual hits = 0 is the acceptance condition, same as the compile-error-0 gate. Applies with extra force to **externally supplied diffs**, which patch the sentence a referee quoted and nothing else. See [[feedback-compression-drops-the-qualifier]].
