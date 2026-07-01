---
description: Mike re-verifies every quantitative claim in the manuscript against its source
model: opus
---

# Research Lab: Verify Numbers (Numbers Verification Gate — active half)

Mike leads an evidence-traceability pass over the manuscript. Every number that
appears in the paper must trace back to a reproducible source (R output, data,
or an explicit hand calculation that is itself re-derived). This is the active
counterpart to the `check-numbers-verification.sh` hook.

Reference: `memory/feedback_calculation_verification.md` —「数値計算後は必ず再検証してから報告」.
Distinct from ARS `citation-check` (which audits *references*, not *numbers*).

## Execution

1. **Mike**: Extract every quantitative claim from the target file
   (p-values, CIs, point estimates, n, percentages, Δ_max, thresholds, counts).
2. **Mike**: For each claim, locate its source:
   - R script + the exact line / object that produces it
   - dataset value, or
   - hand calculation — then **re-derive it independently** (Rule: never trust the first computation).
3. **Mike**: Classify each claim:
   - ✅ Verified (source found, value matches)
   - ⚠️ Mismatch (source value ≠ paper value) → **flag loudly**
   - ❓ Unsourced (no traceable origin) → **flag loudly**
4. **Mike**: Re-check every threshold comparison / boolean / sort / unit conversion
   (the categories `feedback_calculation_verification` calls out).
5. **Donna**: Add scene to SUITS.md with the verification table.

## Output: Verification Table

| # | Claim (paper) | Source | Re-derived | Status |
|---|---------------|--------|-----------|--------|
| 1 | p < 0.001     | R: `fit$p` L42 | 0.0003 | ✅ |
| 2 | 95% CI [a,b]  | …      | …         | ⚠️/❓/✅ |

Any ⚠️ or ❓ blocks "submission-ready" until resolved.

## SUITS.md Scene (add at TOP)

```markdown
### [YYYY-MM-DD HH:MM] Scene: Numbers Verification — Mike traces every digit

**INT. PEARSON SPECTER LITT - BULLPEN - DAY**

*Mike spreads the R output beside the manuscript, cross-checking line by line.*

**Mike**: （電卓を置いて）
「{N} 個の数値を全部 source に当てた。{V} 件 verified、{F} 件は要修正だ。"I got it!"」

**Donna**: （頷いて）
「{F} 件が片付くまで submission-ready とは言わせないわ。」

---
```
