#!/bin/bash
# check_all.sh — run every mechanical check once and write one report (Donna's entry point).
# Usage: bash scripts/check_all.sh [project-dir] [--out FILE]
#   project-dir defaults to the single projects/* directory that has a paper/*.tex
#   --out defaults to <project>/review_response/MECHANICAL_CHECKS_YYYYMMDD.md ("-" = stdout only)
# Advisory (exit 0). Each section reports counts; the detailed lists come from the individual tools.
set -u
cd "$(git rev-parse --show-toplevel 2>/dev/null || pwd)" || exit 0
PROJ=""; OUT=""
while [ $# -gt 0 ]; do
  case "$1" in
    --out) OUT="$2"; shift 2 ;;
    *) PROJ="$1"; shift ;;
  esac
done
if [ -z "$PROJ" ]; then
  for d in projects/*/; do ls "$d"paper/*.tex >/dev/null 2>&1 && { PROJ="${d%/}"; break; }; done
fi
[ -z "$PROJ" ] && { echo "check_all: no project with paper/*.tex"; exit 0; }
TEX=$(ls "$PROJ"/paper/*.tex 2>/dev/null | grep -vE 'supplement|template' | head -1)
BIB=$(ls "$PROJ"/paper/*.bib 2>/dev/null | head -1)
DATE=$(date +%Y%m%d)
[ -z "$OUT" ] && OUT="$PROJ/review_response/MECHANICAL_CHECKS_${DATE}.md"
TMP=$(mktemp)
{
  echo "# Mechanical checks — $(basename "$PROJ") ($(date '+%Y-%m-%d %H:%M'), commit $(git rev-parse --short HEAD 2>/dev/null))"
  echo
  echo "All advisory. Red items are gates for \`/phase next\` and \`/submission-check\` (RESEARCH_FRAMEWORK §6)."
  echo
  echo "## 1. Consistency (state ↔ script ↔ manuscript)"; echo '```'
  bash scripts/check_consistency.sh; echo '```'; echo
  echo "## 2. SUITS.md character lint (all scenes)"; echo '```'
  python3 scripts/lint_suits.py SUITS.md --all | head -40; echo '```'; echo
  if [ -n "$TEX" ]; then
    echo "## 3. Numbers audit — $(basename "$TEX")"; echo '```'
    python3 scripts/numbers_audit.py "$TEX" | head -1; echo '```'
    echo "Detail: \`python3 scripts/numbers_audit.py $TEX\` · ledger \`$PROJ/results/NUMBERS_LEDGER.csv\`"; echo
  fi
  if [ -n "$TEX" ] && [ -n "$BIB" ]; then
    echo "## 4. Citation audit — $(basename "$TEX") vs $(basename "$BIB")"; echo '```'
    python3 scripts/cite_audit.py "$TEX" "$BIB" | sed -n '3p'; echo '```'
    echo "Detail: \`/cite-check\` → \`$PROJ/review_response/CITATION_AUDIT_${DATE}.md\`"; echo
  fi
  echo "## 5. R reproducibility lint — $PROJ/R"; echo '```'
  R_OUT=$(bash scripts/check_r_reproducibility.sh "$PROJ/R" 2>/dev/null)
  echo "$R_OUT" | sed -n '1p'
  R_ROWS=$(echo "$R_OUT" | grep -vE '^(Mike:|file |Legend:|Rule:)' )
  echo "files with ❌: $(echo "$R_ROWS" | grep -c '❌')   files with ⚠️ only: $(echo "$R_ROWS" | grep -v '❌' | grep -c '⚠️')"
  echo "$R_ROWS" | grep '❌' | awk '{print "  ❌ " $1 "  " $NF}' | head -25
  echo '```'; echo
  echo "## 6. Lifecycle artifacts on disk"; echo
  echo "| artifact | present | note |"; echo "|---|---|---|"
  for a in CLAIMS.md DECISIONS.md LITERATURE_SEARCH_LOG.md LAB_STATUS.md; do
    [ -f "$PROJ/$a" ] && echo "| $a | ✅ | |" || echo "| $a | ❌ | template in templates/ |"
  done
  n=$(ls "$PROJ"/PROTOCOL_*.md 2>/dev/null | wc -l); echo "| PROTOCOL_*.md | $([ "$n" -gt 0 ] && echo ✅ || echo ❌) | $n file(s) |"
  n=$(ls "$PROJ"/SIMULATION_FINDINGS*.md 2>/dev/null | wc -l); echo "| SIMULATION_FINDINGS*.md | $([ "$n" -gt 0 ] && echo ✅ || echo ❌) | $n file(s) |"
  if [ -f "$PROJ/results/NUMBERS_LEDGER.csv" ]; then r=$(($(wc -l < "$PROJ/results/NUMBERS_LEDGER.csv") - 1)); echo "| results/NUMBERS_LEDGER.csv | ✅ | $r row(s) |"; else echo "| results/NUMBERS_LEDGER.csv | ❌ | |"; fi
  n=$(ls "$PROJ"/results/REPRODUCTION_*.md 2>/dev/null | wc -l); echo "| results/REPRODUCTION_*.md | $([ "$n" -gt 0 ] && echo ✅ || echo ❌) | $n report(s) |"
  n=$(ls "$PROJ"/review_response/CITATION_AUDIT_*.md 2>/dev/null | wc -l); echo "| review_response/CITATION_AUDIT_*.md | $([ "$n" -gt 0 ] && echo ✅ || echo ❌) | $n audit(s) |"
  if [ -f "$PROJ/CLAIMS.md" ]; then
    pend=$(grep -cE '^\| C-[0-9]+ \|.*\| pending \|' "$PROJ/CLAIMS.md"); sup=$(grep -cE '^\| C-[0-9]+ \|.*\| supported \|' "$PROJ/CLAIMS.md")
    echo "| CLAIMS.md rows | — | supported $sup · pending $pend |"
  fi
} > "$TMP"
if [ "$OUT" = "-" ]; then cat "$TMP"; else mkdir -p "$(dirname "$OUT")"; cp "$TMP" "$OUT"; cat "$TMP"; echo; echo "Donna: report written → $OUT"; fi
rm -f "$TMP"
exit 0
