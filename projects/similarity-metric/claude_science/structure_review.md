# Structural review — *Quantifying Effect Modifier Similarity for Regional Pooling in MRCTs*

Reviewed against `paper/per_em_W1_wiley.tex` as of 2026-09-21 19:15
(805 lines, sha256 `C11677D24BF7FBCD`). Measurements are de-TeX prose word
counts with float environments, captions and the code listing excluded.

## What is structurally sound

Worth stating first, because these are the things that usually go wrong and
here do not.

- **Float placement is correct throughout.** All 15 floats are cited in the
  text *before* they are defined (drift −4 to −35 lines), which is what LaTeX
  wants. No float is uncited and no float is defined before its first mention.
- **Cross-references resolve.** 42 `\ref` against 55 labels, zero undefined;
  25 `\cite` keys all present in the `.bib`.
- **The Methods subsection order is right**: existing measures → definition →
  estimation → calibration → operability. Each subsection depends only on its
  predecessors.
- **§2.5 (operability) earns its place.** It is not padding: it establishes a
  necessary condition that §4.2 then shows failing for one of the two
  modifiers, which is a genuine result and the paper's most original small
  contribution.

## Problem 1 — the manuscript is roughly twice its venue's length

| Section | Prose words | Venue-typical | Over by |
|---|---|---|---|
| 1 Introduction | 917 | 500–800 | 1.1× |
| 2 Methods | 2,782 | 1,000–2,000 | 1.4× |
| 3 Simulation studies | 3,057 | 1,000–1,500 | 2.0× |
| 4 Application | 3,363 | 1,000–1,500 | 2.2× |
| 5 Discussion | 2,252 | 600–1,000 | 2.3× |
| **Total** | **12,371** | **4,000–6,000** | **2.1×** |

Methods running long is normal for a methodology paper. §3 + §4 at 6,420
words — more than a complete typical paper, before the Discussion — is not.
This is not a trimming problem; it is a consequence of Problems 2 and 3.

## Problem 2 — a simulation study is reported in the Discussion

The Discussion's fourth paragraph (line 699) is 348 words carrying **nine
numeric results**: violation rates of 61–68% for anchor-wise screening,
unchanged across *n* = 25–400; complete-linkage residual breach falling from
16% to below 1%; a 100,000-replication design recorded in the source comment
as `R/anchor_vs_clustering_simulation.R`.

This is a third simulation study. It has no entry in §3, no table, no figure,
and no ADEMP description, yet it carries the paper's sharpest structural
claim — that procedure choice follows the estimand, and that anchor screening
*structurally* under-protects a shared pooled region. A reader looking for
the evidence behind the paper's procedure recommendation will not find it
where evidence lives.

Every other paragraph in the Discussion carries 0–2 numbers. This one is an
outlier by a factor of four, which is the diagnostic.

## Problem 3 — four arguments are split across sections

| Argument | Currently | Words | Should be |
|---|---|---|---|
| Procedure choice (anchor screen vs diameter-controlled clustering) | §4.6 (GUSTO diameters) + §5 (the simulation) | 500 + 348 | one §3.3 study + a short §4.6 paragraph |
| The three gaps | §2.1 states them; §5 ¶1 closes them; §5 ¶5 closes them again | 357 + 166 + 282 | stated once, closed once |
| $\rho = W_1/(D_{\rm KS}\sigma_{\rm EM})$ | §4.6 final paragraph, as a post-hoc device | 150 | §2.2, where it is the crossover criterion |
| $W_1$ reference code | Appendix B (24 lines) **and** promised in Supporting Information | — | supplement only |

The gap duplication is the cheapest 400 words in the paper: §5 ¶1 and §5 ¶5
both enumerate SMD-is-location-only / KS-has-no-clinical-scale /
KL-is-asymmetric and both conclude that $W_1$ addresses all three. One of
them should go.

The $\rho$ placement is the most interesting. §4.6 introduces $\rho$ as the
"effective width, in SD units, of the range over which the two CDFs
separate", then explicitly bounds its role: it "explains, after the fact, why
the measures agreed" and "is not a pre-screening rule". But $W_1/D_{\rm KS}$
is exactly one side of the criterion that decides which of the two bounds in
§2.2 is tighter — the $W_1$ bound holds when the CDF-separation width does
not exceed the CATE-variation width $\mathrm{TV}(\tau)/L$. Moved to §2.2,
$\rho$ stops being a post-hoc curiosity and becomes the theoretical quantity
that governs the bound comparison, which also repairs the derivation gap
noted separately in the referee report.

## Problem 4 — the Study 2 / Study 1 inversion is still unresolved

§3 presents Study 2 before Study 1 and spends 211 words of preamble
explaining why, plus a sentence at the head of §3.2 ("Study 2 compared
decisions; Study 1 characterizes the estimator those decisions rely on") and
another at the end of §3.2.2 pointing back. That is roughly 250 words spent
managing an ordering the reader did not ask for, and a reviewer has already
flagged it (queue item R3.1, 18 occurrences).

The dependency runs the other way from the presentation: Study 2's selection
task uses $\widehat W_1$, whose properties Study 1 establishes. Presenting
estimation first removes the preamble entirely. The counter-argument in the
text — that partner selection is the deliverable, so its comparison is
primary — is about *importance*, not *dependency*, and importance is what the
abstract and Discussion are for.

## Problem 5 — supplement labelling is incomplete

The manuscript cites **Supplement A** and **Supplement D**. There is no B or
C anywhere in the text. Three supplement files exist in `paper/`
(`supplement_normalizer_comparison.tex`, `supplement_path_alpha.tex`,
`supplement_L_clinical_lit.md`), and their names do not map onto the A/D
labels used in the text. A reader who looks for Supplement B will not find
it, and a production editor will query it.

Separately, Appendix A.1 proves non-negativity and the identity of
indiscernibles for $W_1$ — standard metric properties for which the paper
already cites Villani. Half a page for results no referee will contest.

## Proposed restructure

Same content, different homes. Target ~8,350 words, still long for the venue
but defensible for a methods paper with two applications.

1. **§1 Introduction** 917 → 750. The effect-modifier tutorial paragraph
   (line 66, "A region with predominantly younger patients would show larger
   benefits…") is textbook for this readership; two sentences suffice.
2. **§2 Methods** 2,782 → 2,000. Move the three-equivalent-representations
   exposition and the normalization-redundancy digression to Supplement A
   (which already exists for exactly this). Bring $\rho$ *in* from §4.6 as
   the bound-crossover criterion — this section gets shorter and stronger.
3. **§3 Simulation studies** 3,057 → 2,400, reordered: §3.1 Estimation
   (present Study 1 first, deleting the 211-word preamble), §3.2 Decision
   performance, **§3.3 Procedure comparison** — the 100k-replication study
   promoted out of the Discussion with a proper design paragraph and one
   table.
4. **§4 Application** 3,363 → 2,200. §4.6 is the largest subsection in the
   paper (1,238 words, longer than the Introduction) and is doing three jobs:
   measure comparison, procedure comparison, and the $\rho$ diagnostic. Keep
   the first, reduce the second to the GUSTO pool diameters now that §3.3
   carries the argument, and move the third to §2.2.
5. **§5 Discussion** 2,252 → 1,000. Delete one of the two gap-closing
   paragraphs; the simulation paragraph leaves with §3.3. What remains is
   interpretation, limitations, and the `¶D` limitation subsection the
   project's own queue still lists as unwritten.
6. **Appendices.** Drop A.1 (cite Villani), keep A.2 (asymptotics, which is
   load-bearing for the bootstrap justification), move Appendix B's code to
   the supplement the Supporting Information section already promises.
7. **Supplements.** Relabel A–C to match the three existing files and fix the
   two in-text citations, or renumber the citations to A and B.

## What this buys

The Discussion stops carrying evidence, so it can carry judgment. The
procedure recommendation — arguably the paper's most actionable finding, since
it tells a sponsor which of two published approaches to use and why — moves
from a Discussion aside to a named study with a table. And §2.2's bound
comparison acquires the quantity that governs it instead of leaving $\rho$
stranded two sections later.
