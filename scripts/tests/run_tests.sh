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

echo "numbers_registry.py (decimal half-even, agg, modifiers, apply/check)"
REG=$F/proj_fixture/paper/numbers_registry.csv; PTEX=$F/proj_fixture/paper/paper.tex
expect_count "tie 0.9425 → 0.942 (half-even)"  "$(python3 scripts/numbers_registry.py value $REG covS1n50)" 0.942
expect_count "tie 0.9285 → 0.928"              "$(python3 scripts/numbers_registry.py value $REG covS1n100)" 0.928
expect_count "abs modifier"                    "$(python3 scripts/numbers_registry.py value $REG biasS1n50abs)" 0.013
expect_count "math-minus modifier"             "$(python3 scripts/numbers_registry.py value $REG biasS1n50m)" '$-0.013$'
expect_count "range agg"                       "$(python3 scripts/numbers_registry.py value $REG covRangeS1)" "0.93--0.94"
expect_count "sum + LaTeX thousands"           "$(python3 scripts/numbers_registry.py value $REG nTotal)" '3{,}533'
expect_count "scale 100 percent"               "$(python3 scripts/numbers_registry.py value $REG covS2n50pct)" 70.3
expect_count "verify-draft all match"          "$(python3 scripts/numbers_registry.py verify-draft $REG --tex $PTEX | grep -c '⚠️')" 0
TMPT=$(mktemp); cp $PTEX $TMPT
expect_count "apply replaces 4 tokens"         "$(python3 scripts/numbers_registry.py apply $REG --tex $TMPT --out $TMPT.out | grep -oE '[0-9]+ replaced' | grep -oE '^[0-9]+')" 4
expect_count "apply leaves \\numval in text"    "$(grep -c 'numval{covS1n50}' $TMPT.out)" 1
TMPM=$(mktemp)
python3 scripts/numbers_registry.py build $REG --out $TMPM >/dev/null
expect_count "check PASS vs own build"         "$(python3 scripts/numbers_registry.py check $REG --macros $TMPM --tex $TMPT.out >/dev/null; echo $?)" 0
if command -v Rscript >/dev/null 2>&1; then
  TMPR=$(mktemp)
  Rscript scripts/make_numbers_macros.R $REG $TMPR >/dev/null 2>&1
  expect_count "R generator agrees with Python"  "$(python3 scripts/numbers_registry.py check $REG --macros $TMPR >/dev/null; echo $?)" 0
  expect_count "R output byte-identical"         "$(cmp -s $TMPM $TMPR && echo same || echo differ)" same
else
  echo "  skip R generator tests (Rscript not installed)"
fi
rm -f $TMPT $TMPT.out $TMPM

echo "protocol_compile.py"
TMPP=$(mktemp -d); cp -r $F/proj_fixture/. $TMPP/
expect_count "dry run validates"               "$(python3 scripts/protocol_compile.py $TMPP/PROTOCOL_example_study.md --dry-run >/dev/null; echo $?)" 0
python3 scripts/protocol_compile.py $TMPP/PROTOCOL_example_study.md >/dev/null
expect_count "R skeleton written"              "$([ -f $TMPP/R/example_study.R ] && echo 1 || echo 0)" 1
expect_count "provenance + findings written"   "$([ -f $TMPP/results/EXAMPLE_STUDY_PROVENANCE.md ] && [ -f $TMPP/SIMULATION_FINDINGS_example_study.md ] && echo 1 || echo 0)" 1
expect_count "MCSE formulas present"           "$(grep -c 'sqrt(cov \* (1 - cov) / nsim)' $TMPP/R/example_study.R)" 1
expect_count "n_sim too small is rejected"     "$(sed 's/^n_sim: 2000/n_sim: 500/' $TMPP/PROTOCOL_example_study.md > $TMPP/PROTOCOL_small.md; python3 scripts/protocol_compile.py $TMPP/PROTOCOL_small.md --dry-run >/dev/null; echo $?)" 1
if command -v Rscript >/dev/null 2>&1; then
  expect_count "generated R parses"            "$(Rscript -e "invisible(parse('$TMPP/R/example_study.R'))" >/dev/null 2>&1; echo $?)" 0
fi

echo "extract_methods.py / compare_results.py"
TMPE=$(mktemp)
python3 scripts/extract_methods.py $F/methods_paper.tex --out $TMPE --also "Appendix" >/dev/null
expect_count "methods extracted, intro excluded" "$(grep -c 'Intro text' $TMPE)" 0
expect_count "comments stripped"               "$(grep -c 'secret' $TMPE)" 0
expect_count "input lines dropped"             "$(grep -c '\\\\input' $TMPE)" 0
expect_count "appendix included"               "$(grep -c 'Proof' $TMPE)" 1
expect_count "compare PASS within tol"         "$(python3 scripts/compare_results.py $F/canonical.csv $F/candidate_ok.csv --keys scenario,n --tol 1e-6 >/dev/null; echo $?)" 0
expect_count "compare FAIL on diff + missing row" "$(python3 scripts/compare_results.py $F/canonical.csv $F/candidate_bad.csv --keys scenario,n --tol 1e-6 >/dev/null; echo $?)" 1
rm -f $TMPE

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
