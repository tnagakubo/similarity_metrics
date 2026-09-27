---
name: recurring-holes
description: Recurring structural weaknesses of the per-EM W1 paper team — enumeration drift, joint-vs-marginal overclaim, ledger decisions recorded without reasons
metadata:
  type: feedback
---
Holes this team reopens; check first on every review.

1. Enumeration drift: the "three gaps" list existed in 3 different versions at once (2026-09-23: §2.1 L120 vs Discussion ¶1 L691 vs ¶5 L712). Grep every enumerated list against its cited source.
2. Per-EM marginal bound sold as a joint guarantee (AND rule, "conservative max Δ_max"). Marginal W1 does not bound joint W1; the joint claim needs additive separability, and it also leaks into the abstract.
3. Ledger rejections recorded only as "conflicts with decision X", with no reason. A later reversal has nothing to rebut, so treat it as reopening the decision, not as a rebuttal.
4. Evidence tables that look like two independent confirmations but are identical (the two-currency table, 40/40 cells). Demand a CSV check before anything counts as corroboration.

**Why:** these were found in the v5 restructure review (2026-09-23), and each one repeats an earlier pattern.
**How to apply:** check these four before writing any verdict. See [[circular-kr]] for the θ-simulation ban.
