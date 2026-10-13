---
name: feedback-fixed-tau-not-kr-circular
description: When declining a specified-CATE (theta) simulation, the reason is "a fixed theta picks the winner", not "KR duality makes W1 optimal by construction" (that holds only for the sup over the Lipschitz class); plus the external-review 2026-10-12 lessons
metadata:
  type: feedback
---
Rule: do not defend the no-theta-simulation decision (Tak 2026-07-12) with "KR duality makes W1 optimal by construction, so it is circular". That is true only for the supremum over the Lipschitz class. For a fixed tau the oracle is the integral of tau against (F1 - F2) itself, and a fixed-tau ranking study is won by whichever measure matches the chosen tau: the mean difference for linear tau, |F1(c) - F2(c)| for a step at c, W1 for the KR maximizer tau*. The scientific reason to decline is that the result is set by the menu of tau, not by any property of the metric.

**Why:** in the 2026-10-12 external review (M3), an editor would have rejected the KR-circularity answer immediately. The advisor caught it before I wrote it.

**How to apply:** for an "SMD blind is correct under linear CATE" attack, concede that the bound is loose by W1/|dmu| under linear tau. Then counter with an attaining plausible shape: tau = L|x - mu| in a scale-only cell gives L*sqrt(2/pi)*|s1 - s2| = L*W1 exactly. Also, the right ruler under linear tau is the raw |dmu|, not SMD.

Other lessons from the same review:
- A hypothetical data-quality attack can be tested in minutes (GUSTO SBP terminal-digit-0 share 0.20-0.80 by region, anchor 0.80). Test it before calling it speculative. Coarsening both regions to a common grid is the defence.
- Check every application distance in SD units against the simulation design range (GUSTO 0.03-0.28 SD vs Study 2 0.4-1.2 SD: zero covered).
- Equivalence-test OC = the miss_above column the lab already has. Look on disk before conceding "new simulation needed".
[[recurring-holes]] [[feedback_own_fix_text_and_marker_swallow]]
