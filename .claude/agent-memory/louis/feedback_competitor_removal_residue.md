---
name: competitor-removal-residue
description: When a compared method is deleted (RV1-RV3, 2026-09-27), check that sentences it evidenced do not survive as bare assertions, that class-level plurals ("summary-based measures") now rest on one measure, and that the cited source's scope caveat is kept
metadata:
  type: feedback
---
After removing a competitor, the team keeps claims the deleted data used to support (e.g. "adding SD or skewness would not help in Set 3", when RV3 plateaued at 0.78 in combined/shape-skewed) and plural generalizations now backed only by SMD.
They also drop the fairness caveat about the cited source (Komiyama Ch.4 example uses binary proportions, where one value describes the distribution) while keeping the criticism.
**Why:** P5 overclaim + misattribution risk; Komiyama 4.6.1 only "introduces one of the approaches" (Euclidean AND Manhattan, standardization "in many cases"); "clinically meaningful" in 4.6.1.4 refers to treatment-effect differences, not EM distribution differences.
**How to apply:** after any method deletion, grep the claims each deleted row supported; check source-quoting against knowledge/pdfs/Ch4_Pooling_Strategy text. Related: [[point-vs-upper-cl-and-bridge-residue]]
