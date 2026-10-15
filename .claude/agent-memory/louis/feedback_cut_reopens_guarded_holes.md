---
name: cut-reopens-guarded-holes
description: 2026-10-15 essence cut (D-20261015-1) — compressed/insurance sentences reopened holes that existing CLAIM_GUARDS were built to block, by paraphrase; regex guards passed vacuously
metadata:
  type: feedback
---

A length cut that "condenses" a guarded sentence reopens the guarded hole in new words, and the regex guard passes.
Seen 2026-10-15 (D-20261015-1 review-fix):
- Insurance J (my own list): "each is sharp within its own class, and the bounds differ in their constant" — L*W2 is not sharp in any class (sup over Lipschitz is L*W1) and has the SAME constant L. Exactly what REF-M1-forbid-constant-distinguishes was written for; its pattern ("What distinguishes equation") missed the paraphrase.
- Basic interval: "covered less ... from n=100 ... and more near the boundary" — CSV: more only at S1 and S2 n=50; S2 n=100/200 far worse; S6 n=200 not less. LR3-G3 note already said "S2-50 only"; regex ("in every non-null cell (") missed it.
- Kept bridge sentence "below the smallest non-null distance of the original Study 2 design" was false since 10-13 (S2 = 0.2 SD, GUSTO max 0.30, 6/30 above). Nobody re-checked a sentence marked "kept".
- EXT-M6 guard anchored on a parenthetical survived while the inequality |dtau| <= W_d itself was deleted.
- A decision adopted 24 h earlier (D-20261014-2: binary/ordinal C-50, |b| C-51, means-only lower bound) silently undone by the cut.

**Why:** cutters compress example-specific comparisons into universal clauses, and guards match strings, not claims. My own insurance wording was not CSV/maths-checked before I mandated it.
**How to apply:** in every /review-fix of a cut: (1) re-derive each insurance sentence I demanded (maths) and re-check it cell by cell (CSV) — mine included; (2) for each guard whose note describes the hole, read the new sentence against the note, not the regex; (3) treat "kept" sentences in edited paragraphs as new text; (4) diff the cut against decisions of the last 48 h (DECISIONS.md) for silent reversals. Related: [[own-fix-text-and-marker-swallow]], [[compression-drops-qualifier]], [[fix-explanations-unchecked]].

Second incident, same day (D-20261015-2, "figures back, text out"):
- Restoring a figure was used as licence to drop the numbers the figure cannot show: MCSE of the Set 4 reversal, the 0.2 SD scope of the extension bridge, and the bias/SD qualifier that a Limitations sentence cites by section. The figure is not a carrier for a claim that needs a number plus SE.
- DECISIONS said "all insurance sentences kept" while the basic-interval insurance was deleted. CLAIMS rows were marked "narrowed" only in the log; the Claim column still held deleted wording. Check both against the text, not the log.
- A compressed "curves cross" kept the verb and dropped "point estimates only, intervals overlap".
**How to apply (added):** when a cut cites a figure as the replacement, list every number+SE the old sentence carried and ask whether the figure shows it. Grep the Limitations and Discussion for "(Section X)" pointers into the cut paragraph. Diff the DECISIONS "kept" list against the insurance list of the previous decision.
