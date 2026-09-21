---
name: feedback-compression-drops-the-qualifier
description: Recurring team weakness - when a passage is shortened (abstract, summary, opening paragraph), the scope qualifier is the first casualty and an existential claim silently becomes universal
metadata:
  type: feedback
---

When any passage is **shortened**, check the surviving claim's quantifier against the evidence table, not against the longer version's overall meaning. Compression is where P5 (claim-evidence proportionality) breaks in this project.

**Why:** 2026-09-21, an external referee compressed the abstract 356 → 248 words and inverted two quantifiers.
- Body (correct, existential): "every summary-based competitor is at chance ... **in at least one** clinically plausible world." Abstract (false, universal): "SMD and representative-value distances stayed at chance ... **wherever** discordance lay in distributional shape or displaced rare subgroups" — contradicted by the paper's own Table 5 (Set 4 asymmetric severity: RV3 = 41, and RV3 beats W1 at 67).
- "at smaller sample sizes ... than the Kolmogorov-Smirnov statistic" — contradicted by the bulk-shift control cell (KS 333 vs W1 377) and by clustering Set 2 (KS 83 vs W1 156), both of which the body reports honestly as losses.
- The qualifier "**for non-negligible distributional differences**" was dropped from the coverage sentence, so the abstract claimed satisfactory coverage "across seven scenarios" when S1 coverage is structurally 0 and S2 is 0.703 at n=50.

**How to apply:** for every shortened claim, name the table cell that would falsify it and check that cell. Watch specifically for: universal adverbs (`wherever`, `every`, `always`) replacing `in at least one`; comparative claims against a named competitor that the body reports losing to somewhere; and the deletion of a restricting prepositional phrase. Related: [[feedback-patch-without-cascade]].
