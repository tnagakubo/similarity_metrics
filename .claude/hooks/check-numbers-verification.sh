#!/bin/bash
# Mike's Gate: Numbers Verification (anti unverified-number)
# Fires on PostToolUse(Write|Edit). When a paper/results file is edited and the
# edit carries quantitative claims (p-values, CIs, percentages, n=, estimates),
# remind that Mike must re-verify the number against its source before it ships.
# Reference: feedback_calculation_verification — "数値計算後は必ず再検証してから報告"
# No jq dependency — raw grep on the hook input JSON.

INPUT=$(cat 2>/dev/null || echo "")

# Only care about manuscript / results files. Skip everything else.
if ! echo "$INPUT" | grep -qiE '\.(tex|md|qmd|Rmd)["\\ ]|nABCD|per_em|paper[/\\]|results' 2>/dev/null; then
  exit 0
fi

# Skip log / coordination / memory files even if .md
if echo "$INPUT" | grep -qiE 'SUITS\.md|MEMORY\.md|memory[/\\]|archives[/\\]|IDEAS_BACKLOG|README' 2>/dev/null; then
  exit 0
fi

# Does the payload actually contain a quantitative claim?
#  p-values / CIs / percentages / sample sizes / =0.xxx style estimates
if echo "$INPUT" | grep -qiE 'p *[<=>] *0|95% *CI|\[[0-9].*,.*[0-9]\]|[0-9]+\.[0-9]+|n *= *[0-9]|[0-9]+%|Delta|Δ' 2>/dev/null; then
  echo "Mike: 数値を含む編集を検出。source (R 出力 / CSV) と突き合わせ、results/NUMBERS_LEDGER.csv に行があるか? 未登録なら /verify-numbers（python3 scripts/numbers_audit.py <tex>）。verifier は producer と別人。(Numbers Verification Gate)" >&2
fi

exit 0
