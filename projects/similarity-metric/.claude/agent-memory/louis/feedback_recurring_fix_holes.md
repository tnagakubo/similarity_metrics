---
name: recurring-fix-holes
description: Recurring holes this team opens when applying review fixes to the per-EM W1 manuscript; check these first in every /review-fix
metadata:
  type: feedback
---

Recurring weaknesses seen in /review-fix (latest: D-20261114-1, 2026-11-14):

1. **Records not updated with the manuscript.** Comments in the .tex cite a decision ID (e.g. D-20261114-1) that has no entry in DECISIONS.md, and CLAIMS.md rows keep the old wording (C-36 "%pt", C-37 "predominantly") or stay "retracted" while the text resurrects the claim (C-28 log-scale SMD). Always grep DECISIONS.md / CLAIMS.md for the decision ID and for each new sentence.
2. **Re-adding a result without removing its "not reported" disclosure.** The omission sentence (C-40, §3.1.1) still lists the item that a new sentence now reports. Grep the omission list whenever a result comes back.
3. **Qualifier scoped too narrowly or too broadly.** "No simulated cell" when only the estimation study is meant (Set 4 identification cells sit at 0.12-0.19 SD); "several resolved age distances" when 8/9 age and 9/14 SBP are in range. Check every "no/several/all" against the CSV.
4. **Per-modifier limitation stated as "does not bound the sum"** — false for additive CATE (sum of bounds is a bound); the defensible claim is "does not bound the sum by Delta_clin". Contradicts the W_d paragraph of §5.
5. **"lowers/tightens" for monotone or bounded-scale restrictions** — they *can* lower; equality holds when CDFs do not cross (App. A.2).
6. **Admissibility arguments resting on a group-average risk** (Lee 1995 20.5% for >75 y) where the argument needs the supremum of baseline risk over the support (SBP support includes SBP = 0 records).
7. **Typed result labels** (partner lists R2, R3, R16...) next to generated counts — the counts are guarded, the names are not; borderline intervals (age R1 upper 1.035 vs line 1) can flip with bootstrap MC error.

**Why:** gates (guards, numbers, build) all pass while these holes stay open; they are only found by reading CSVs and the ledgers.
**How to apply:** in every /review-fix, run these seven checks before anything else.
