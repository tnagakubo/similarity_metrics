---
name: feedback-sim-app-seam-holes
description: Recurring holes at the Study 1 / Application seam of the per-EM W1 paper — generic sigma=10 results relabelled in years, n>=100 "reliable" vs own 5x-margin width, cross-EM IQR comparison after "precludes", labels on partners instead of (partner, EM) distances
metadata:
  type: feedback
---

2026-09-27 queue #22-#38 review found these; check them first whenever Study 1 or §4 is touched.

1. Generic sigma=10 scenario numbers borrowed into GUSTO units ("4.96 years", L_UB,age applied to S3), and the same worked example written twice (#24 and #26).
2. "We recommend n >= 100 for reliable estimation and inference" sits one paragraph after the paper's own statement that the Delta_max CI width at n=100 is 5x the 1%pt margin. Ask "reliable for what?" (bias and coverage only).
3. The approved §2.2 says cross-EM W1 comparison is not meaningful, yet the application compares EMs via pooled IQR. Grep "in proportion" / "IQR" in §4.
4. The resolved/unresolved label is attached to a "partner" although it belongs to a (partner, EM) distance.
5. The team tells readers to read "how large" from the upper percentile CL exactly where §2.3 says the naive bootstrap is inconsistent (near F1=F2). Defence: near-boundary misses fall on the lower side (my quick S2 n=50 check: 32% below lower, 0% above upper). Needs a paper-grade miss-side output from the Study 1 script.
6. Evidence asymmetry between age and SBP: FTT's "irrespective of age, sex, blood pressure" covers both.

**Why:** these were all produced by V6-BRIDGE/ERRFIX edits patching sentences locally without re-reading neighbours.
**How to apply:** at the Sim→App seam, grep for units, the n>=100 claim, IQR, "partner unresolved", and "upper confidence limit".

Related: [[feedback-point-vs-upper-cl-and-bridge-residue]]
