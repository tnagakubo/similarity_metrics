---
name: nocut-prose-and-sim-scope-leak
description: No-cut dendrogram prose that narrates a k-cut anyway; null-floor-unresolved partner called "closest"; n=100 qualifiers leaking onto n=2000 sentences; required-n efficiency claims irrelevant at the application's n
metadata:
  type: feedback
---
Recurring holes found in the 2026-09-27 flow review (simulation identifies method -> GUSTO-I applies it):

1. "No-cut" dendrogram text still describes blocks ("block of eleven", "these three join the other 13 only at the top") = exactly cutree(k=3) / cutree(k=2). Recompute cutree(hc,2:4) and compare with every block the prose names.
2. A partner unresolved against the null floor (tied rank 1-6 in the table) is named as the anchor's first merge / "closest partner" in the dendrogram prose.
3. A sentence scoped to n=100 placed right after an n=2,000 result reads as n=2,000 and becomes false (P(k correct) near-zero measures vs W1 flips between n=100 and 2,000).
4. "Recovered whenever k supplied" / "ranked true partners first" drop the sample-size qualifier; Table ARI at n=100 is 0.33-0.53 in hard worlds.
5. Bridge "fewer patients than KS" is true in sim but moot at GUSTO n (1,231-4,352 >= KS max required n 1,252).
6. "Pooling regions" defined as regions sharing a distribution = implicit decision rule (conflicts with quantify-not-decide).

**Why:** the team edits one paragraph per flow change and does not re-check neighbouring scopes or recompute from the hclust object.
**How to apply:** on any clustering / ranking text, recompute cutree and null-floor status; check each n-scoped number against the sentence it sits beside. See [[prose-vs-code-metric-and-roster-subset]], [[point-vs-upper-cl-and-bridge-residue]].
