#!/bin/bash
# ci_ratchet.sh — counts that may only go DOWN (Donna's ratchet). Fails when a count exceeds its baseline.
# Baselines live in scripts/baseline/*.txt (one integer each). Lower them as the team pays down the debt;
# never raise them without a DECISIONS.md entry. Usage: bash scripts/ci_ratchet.sh [--update]
set -u
export PYTHONIOENCODING=utf-8   # Windows cp932 consoles cannot print the report glyphs
cd "$(git rev-parse --show-toplevel 2>/dev/null || pwd)" || exit 1
UPDATE=0; [ "${1:-}" = "--update" ] && UPDATE=1
FAIL=0
check() { # name current baseline-file
  local name="$1" cur="$2" f="$3"
  local base; base=$(cat "$f" 2>/dev/null | tr -dc '0-9'); base=${base:-0}
  if [ "$UPDATE" = "1" ]; then echo "$cur" > "$f"; echo "  set $name baseline = $cur"; return; fi
  if [ "$cur" -gt "$base" ]; then echo "  ❌ $name: $cur > baseline $base ($f)"; FAIL=1
  elif [ "$cur" -lt "$base" ]; then echo "  ✅ $name: $cur (baseline $base — you may lower it: echo $cur > $f)"
  else echo "  ✅ $name: $cur (= baseline)"; fi
}
for proj in projects/*/; do
  proj=${proj%/}; name=$(basename "$proj")
  TEX=$(ls "$proj"/paper/*.tex 2>/dev/null | grep -vE 'supplement|template|numbers_macros' | head -1)
  if [ -n "$TEX" ]; then
    cur=$(python3 scripts/numbers_audit.py "$TEX" | sed -n '1p' | grep -oE '[0-9]+ unsourced' | grep -oE '^[0-9]+'); cur=${cur:-0}
    check "$name numbers unsourced" "$cur" "scripts/baseline/${name}_numbers_unsourced.txt"
  fi
  if [ -d "$proj/results" ]; then
    cur=$(python3 scripts/evidence_coverage.py "$proj" 2>/dev/null | sed -n '3p' | grep -oE '[0-9]+ unbilled' | grep -oE '^[0-9]+'); cur=${cur:-0}
    check "$name results unbilled" "$cur" "scripts/baseline/${name}_results_unbilled.txt"
  fi
  if [ -d "$proj/R" ]; then
    cur=$(bash scripts/check_r_reproducibility.sh "$proj/R" | grep -vE '^(Mike:|file |Legend:|Rule:)' | grep -c '❌'); cur=${cur:-0}
    check "$name R lint errors" "$cur" "scripts/baseline/${name}_r_lint_errors.txt"
  fi
done
[ "$FAIL" -eq 0 ] && echo "ci_ratchet: PASS" || echo "ci_ratchet: FAIL"
exit $FAIL
