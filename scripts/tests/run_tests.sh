#!/bin/bash
# run_tests.sh — regression tests for scripts/ and .claude/hooks/ (no R required).
# Usage: bash scripts/tests/run_tests.sh      (exit 1 on any failure)
set -u
cd "$(git rev-parse --show-toplevel 2>/dev/null || pwd)" || exit 1
F=scripts/tests/fixtures; PASS=0; FAIL=0
ok()   { PASS=$((PASS+1)); echo "  ok   $1"; }
bad()  { FAIL=$((FAIL+1)); echo "  FAIL $1"; [ -n "${2:-}" ] && echo "       $2"; }
expect_count() { if [ "$2" = "$3" ]; then ok "$1"; else bad "$1" "expected $3, got $2"; fi; }

echo "lint_suits.py"
OUT=$(python3 scripts/lint_suits.py $F/suits_bad.md --all)
expect_count "last name detected"         "$(echo "$OUT" | grep -c "last name 'Ross'")" 1
expect_count "keigo in Harvey detected"   "$(echo "$OUT" | grep -c 'Harvey uses keigo')" 1
expect_count "firm name not flagged"      "$(echo "$OUT" | grep -c "last name 'Pearson'\|last name 'Specter'\|last name 'Litt'")" 0
expect_count "Donna scribe detected"      "$(echo "$OUT" | grep -c 'Donna only reports')" 1
expect_count "unknown speaker detected"   "$(echo "$OUT" | grep -c "unknown speaker label '\*\*Bob\*\*'")" 1
expect_count "scene order detected"       "$(echo "$OUT" | grep -c 'scene order')" 1
expect_count "Jessica clean (no keigo)"   "$(echo "$OUT" | grep -c 'Jessica uses keigo')" 0
expect_count "strict exit code"           "$(python3 scripts/lint_suits.py $F/suits_bad.md --all --strict >/dev/null; echo $?)" 1
expect_count "live SUITS.md parses"       "$(python3 scripts/lint_suits.py SUITS.md --scenes 1 >/dev/null; echo $?)" 0

echo "numbers_audit.py"
OUT=$(python3 scripts/numbers_audit.py $F/paper.tex --ledger $F/ledger.csv --all)
expect_count "ledger match 0.948"         "$(echo "$OUT" | grep -c '✅.*0.948')" 1
expect_count "ledger match 1,503"         "$(echo "$OUT" | grep -c '✅.*1,503')" 1
expect_count "unsourced 0.012"            "$(echo "$OUT" | grep -cE '❓ +L +[0-9]+ +0\.012 ')" 1
expect_count "sample size 200 reported (prose int ≥ 10)" "$(echo "$OUT" | grep -cE '❓ +L +[0-9]+ +200 ')" 1
expect_count "unsourced 2.33 (math)"      "$(echo "$OUT" | grep -c '❓.*2.33')" 1
expect_count "year 2017 excluded"         "$(echo "$OUT" | grep -c '2017')" 0
expect_count "version 0.0.3 excluded"     "$(echo "$OUT" | grep -c '0\.0\.3\|❓.*0\.3 ')" 0
expect_count "small math int 50 excluded"  "$(echo "$OUT" | grep -cE '❓ +L +[0-9]+ +50 ')" 0
expect_count "strict exit code"           "$(python3 scripts/numbers_audit.py $F/paper.tex --ledger $F/ledger.csv --strict >/dev/null; echo $?)" 1

echo "cite_audit.py"
OUT=$(python3 scripts/cite_audit.py $F/paper.tex $F/paper.bib)
expect_count "missing key reported"       "$(echo "$OUT" | grep -c 'missingkey')" 1
expect_count "uncited entry reported"     "$(echo "$OUT" | grep -c 'uncited2020')" 1
expect_count "techreport without DOI listed as acceptable" "$(echo "$OUT" | grep -c 'iche17.*techreport.*acceptable')" 1
expect_count "strict exit code"           "$(python3 scripts/cite_audit.py $F/paper.tex $F/paper.bib --strict >/dev/null; echo $?)" 1

echo "check_r_reproducibility.sh"
OUT=$(bash scripts/check_r_reproducibility.sh $F/bad.R $F/good.R)
expect_count "bad.R: seed missing"        "$(echo "$OUT" | grep 'bad.R' | grep -c 'draws-without-seed')" 1
expect_count "bad.R: absolute path"       "$(echo "$OUT" | grep 'bad.R' | grep -c 'abspath')" 1
expect_count "bad.R: sessionInfo missing" "$(echo "$OUT" | grep 'bad.R' | grep -c 'writes-results-no-sessionInfo')" 1
expect_count "good.R: clean"              "$(echo "$OUT" | grep 'good.R' | grep -c '❌\|⚠️')" 0
expect_count "strict exit code"           "$(STRICT=1 bash scripts/check_r_reproducibility.sh $F/bad.R >/dev/null; echo $?)" 1

echo "check_consistency.sh / check_all.sh"
expect_count "consistency runs"           "$(bash scripts/check_consistency.sh --quiet >/dev/null; echo $?)" 0
expect_count "check_all runs (stdout)"    "$(bash scripts/check_all.sh --out - >/dev/null; echo $?)" 0

echo "hooks"
expect_count "lint-suits hook silent for non-SUITS edit" "$(echo '{"tool_input":{"file_path":"/x/y/paper.tex"}}' | bash .claude/hooks/lint-suits.sh 2>&1 | wc -l | tr -d ' ')" 0
expect_count "r-repro hook flags bad.R"   "$(echo "{\"tool_input\":{\"file_path\":\"$PWD/$F/bad.R\"}}" | bash .claude/hooks/check-r-reproducibility.sh 2>&1 | grep -c 'draws-without-seed')" 1
expect_count "protocol hook warns for unregistered sim script" "$(echo '{"tool_input":{"command":"Rscript projects/fixture-proj/R/run_simulation.R"}}' | bash .claude/hooks/pre-run-protocol-check.sh 2>&1 | grep -c 'PROTOCOL')" 1
expect_count "protocol hook silent for verify script" "$(echo '{"tool_input":{"command":"Rscript projects/fixture-proj/R/verify_simulation.R"}}' | bash .claude/hooks/pre-run-protocol-check.sh 2>&1 | wc -l | tr -d ' ')" 0
# the dangerous command is assembled at runtime so this file never contains the literal pattern
DANGER="rm -rf"; DANGER="$DANGER ~"
expect_count "safety hook blocks home deletion" "$(printf '{"tool_input":{"command":"%s"}}' "$DANGER" | bash .claude/hooks/pre-bash-safety.sh >/dev/null 2>&1; echo $?)" 2
expect_count "settings.json parses"       "$(python3 -c 'import json;json.load(open(".claude/settings.json"))' && echo 0)" 0

echo
echo "passed $PASS, failed $FAIL"
[ "$FAIL" -eq 0 ]
