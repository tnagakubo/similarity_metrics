#!/bin/bash
# run_tests.sh — regression tests for scripts/ and .claude/hooks/ (no R required).
# Usage: bash scripts/tests/run_tests.sh      (exit 1 on any failure)
set -u
export PYTHONIOENCODING=utf-8   # Windows cp932 consoles cannot print the report glyphs
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

OUT=$(python3 scripts/numbers_audit.py $F/paper_prec.tex --ledger $F/ledger_prec.csv --all)
expect_count "coarse ledger 0.5 does not absorb 0.46"  "$(echo "$OUT" | grep -cE '❓ +L +[0-9]+ +0\.46 ')" 1
expect_count "precise ledger 0.9425 sources text 0.942 (half-even)" "$(echo "$OUT" | grep -cE '✅ +L +[0-9]+ +0\.942 ')" 1
expect_count "exact ledger 0.5 sources text 0.5"       "$(echo "$OUT" | grep -cE '✅.*[^0-9.]0\.5 ')" 1

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
AREG=$F/apply_fixture/paper/numbers_registry.csv; ATEX=$(mktemp); cp $F/apply_fixture/paper/paper.tex $ATEX
python3 scripts/numbers_registry.py apply $AREG --tex $ATEX --out $ATEX.out >/dev/null
expect_count "apply: 3 same-valued tokens on one line → 3 distinct keys in text order" "$(sed -n 1p $ATEX.out | grep -oE 'numval\{w1(T1|P2|S2)\}' | tr '\n' ' ')" 'numval{w1T1} numval{w1P2} numval{w1S2} '
expect_count "apply: token 1,047 found as 1{,}047"   "$(grep -c 'numval{nT1}' $ATEX.out)" 1
expect_count "apply: literal 333 untouched"           "$(grep -c ' 333\.' $ATEX.out)" 1
rm -f $ATEX $ATEX.out
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
expect_count "verify: skeleton agrees with protocol" "$(python3 scripts/protocol_compile.py $TMPP/PROTOCOL_example_study.md --verify >/dev/null; echo $?)" 0
cp $TMPP/R/example_study.R $TMPP/R/drift.R; sed -i 's/^SEED      <- 2026$/SEED      <- 2027/' $TMPP/R/drift.R
expect_count "verify: seed drift detected"          "$(python3 scripts/protocol_compile.py $TMPP/PROTOCOL_example_study.md --verify R/drift.R >/dev/null; echo $?)" 1
expect_count "verify: drift row named"              "$(python3 scripts/protocol_compile.py $TMPP/PROTOCOL_example_study.md --verify R/drift.R | grep -c '❌ seed')" 1
expect_count "n_sim too small is rejected"     "$(sed 's/^n_sim: 2000/n_sim: 500/' $TMPP/PROTOCOL_example_study.md > $TMPP/PROTOCOL_small.md; python3 scripts/protocol_compile.py $TMPP/PROTOCOL_small.md --dry-run >/dev/null; echo $?)" 1
if command -v Rscript >/dev/null 2>&1; then
  RP=$(command -v cygpath >/dev/null 2>&1 && cygpath -m "$TMPP" || echo "$TMPP")   # MSYS: R needs a Windows path
  expect_count "generated R parses"            "$(Rscript -e "invisible(parse('$RP/R/example_study.R'))" >/dev/null 2>&1; echo $?)" 0
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

echo "claim_guards.py (findings -> guards, mutation test)"
G=$F/guards_fixture/CLAIM_GUARDS.toml
expect_count "good manuscript: 0 FAIL"             "$(python3 scripts/claim_guards.py $G 2>/dev/null | sed -n 1p | grep -c ' 0 FAIL')" 1
OUT=$(python3 scripts/claim_guards.py $G --tex $F/guards_fixture/paper/bad.tex 2>/dev/null)
expect_count "bad manuscript: 5 guards fail"        "$(echo "$OUT" | grep -c '^\[FAIL')" 5
expect_count "forbid ignores a comment line"        "$(python3 scripts/claim_guards.py $G 2>/dev/null | grep -c 'FAIL\] M1-forbid')" 0
expect_count "proximity catches unqualified link"   "$(echo "$OUT" | grep -c 'FAIL\] M1-proximity')" 1
expect_count "abstract scope: universal quantifier" "$(echo "$OUT" | grep -c 'FAIL\] abstract-no-universal')" 1
expect_count "abstract scope: required qualifier"   "$(echo "$OUT" | grep -c 'FAIL\] abstract-keeps-qualifier')" 1
expect_count "pending guard reported OPEN, not FAIL"  "$(echo "$OUT" | grep -c '^\[OPEN\] pending-example')" 1
expect_count "mutation: vacuous guard detected"     "$(python3 scripts/claim_guards.py $G --mutation 2>/dev/null | sed -n 1p | grep -c '1 vacuous')" 1
expect_count "mutation: untested guard listed"      "$(python3 scripts/claim_guards.py $G --mutation 2>/dev/null | grep -c 'no known_bad.*no-known-bad')" 1
expect_count "mutation exit code"                   "$(python3 scripts/claim_guards.py $G --mutation >/dev/null 2>&1; echo $?)" 1
expect_count "strict exit code on bad"              "$(python3 scripts/claim_guards.py $G --tex $F/guards_fixture/paper/bad.tex --strict >/dev/null 2>&1; echo $?)" 1
for t in projects/*/CLAIM_GUARDS.toml; do
  [ -f "$t" ] || continue
  expect_count "live guards pass + no vacuous: $t"  "$(python3 scripts/claim_guards.py "$t" --strict --mutation --quiet >/dev/null 2>&1; echo $?)" 0
done

echo "structure_audit.py"
OUT=$(python3 scripts/structure_audit.py $F/guards_fixture/paper/bad.tex --venue sim 2>/dev/null)
expect_count "float defined before cited"           "$(echo "$OUT" | grep -c 'tab:early.*defined before cited')" 1
expect_count "uncited float"                        "$(echo "$OUT" | grep -c 'fig:orphan.*uncited')" 1
expect_count "evidence outside Results"             "$(echo "$OUT" | sed -n 3p | grep -c 'evidence-outside-Results paragraphs 1')" 1
expect_count "duplicate sentence across sections"   "$(echo "$OUT" | sed -n 3p | grep -oE 'duplicate sentence pairs [0-9]+' | grep -oE '[0-9]+$' | awk '{print ($1>=1)}')" 1
expect_count "supplement letter gap"                "$(echo "$OUT" | grep -c 'gap in the sequence: B')" 1
expect_count "strict exit on bad"                   "$(python3 scripts/structure_audit.py $F/guards_fixture/paper/bad.tex --strict >/dev/null 2>&1; echo $?)" 1
expect_count "strict exit on good"                  "$(python3 scripts/structure_audit.py $F/guards_fixture/paper/good.tex --strict >/dev/null 2>&1; echo $?)" 0

echo "cascade_check.py"
OUT=$(python3 scripts/cascade_check.py --old $F/cascade_old.tex --new $F/cascade_new.tex 2>/dev/null)
expect_count "residue site in Discussion"           "$(echo "$OUT" | grep -c '| Methods, L[0-9]* | Discussion, L')" 1
expect_count "qualifier dropped (at least)"         "$(echo "$OUT" | grep -c "'at least'")" 2
expect_count "quantifier strengthened (wherever)"   "$(echo "$OUT" | grep -c "'wherever'")" 2
expect_count "strict exit code"                     "$(python3 scripts/cascade_check.py --old $F/cascade_old.tex --new $F/cascade_new.tex --strict >/dev/null 2>&1; echo $?)" 1
expect_count "identical versions: clean"            "$(python3 scripts/cascade_check.py --old $F/cascade_new.tex --new $F/cascade_new.tex 2>/dev/null | sed -n 3p | grep -c '0 candidate residue site(s), 0 qualifier drop(s), 0 strengthened')" 1

echo "evidence_coverage.py"
OUT=$(python3 scripts/evidence_coverage.py $F/proj_fixture 2>/dev/null)
expect_count "unbilled result detected"             "$(echo "$OUT" | grep -c 'orphan.csv.*unbilled')" 1
expect_count "billed result (registry) not flagged" "$(echo "$OUT" | grep -c 'summary.csv.*unbilled')" 0
expect_count "brace-expanded missing evidence path" "$(echo "$OUT" | grep -c 'C-02: results/nope.csv, results/nope_ext.csv')" 1
expect_count "repo-root path (knowledge/) checked"  "$(echo "$OUT" | grep -c 'C-03: knowledge/summaries/Nothing_2020.md')" 1
expect_count "strict exit code"                     "$(python3 scripts/evidence_coverage.py $F/proj_fixture --strict >/dev/null 2>&1; echo $?)" 1

echo "ground_audit.py (S21 inference markers)"
OUT=$(python3 scripts/ground_audit.py $F/ground_bad.tex)
expect_count "[推測] detected"             "$(echo "$OUT" | grep -c ':2: \[推測\]:')" 1
expect_count "🔍要根拠 detected"           "$(echo "$OUT" | grep -c ':3: 🔍要根拠:')" 1
expect_count "sourced line not flagged"   "$(echo "$OUT" | grep -c 'panaretos2019')" 0
expect_count "strict exit code"           "$(python3 scripts/ground_audit.py $F/ground_bad.tex --strict >/dev/null; echo $?)" 1
expect_count "clean file exit 0 (strict)" "$(python3 scripts/ground_audit.py $F/good.R --strict >/dev/null; echo $?)" 0
expect_count "IDEAS_BACKLOG ids unique"   "$(grep -oE '^\| I-[0-9]{8}-[0-9]+ ' IDEAS_BACKLOG.md | sort | uniq -d | wc -l | tr -dc '0-9')" 0

echo "check_consistency.sh / check_all.sh"
expect_count "consistency runs"           "$(bash scripts/check_consistency.sh --quiet >/dev/null; echo $?)" 0
expect_count "check_all runs (stdout)"    "$(bash scripts/check_all.sh --out - >/dev/null; echo $?)" 0

echo "lab_doctor.sh"
expect_count "lab doctor runs and summarises"    "$(bash scripts/lab_doctor.sh --quiet | grep -c '^lab_doctor: [0-9]* checks')" 1
expect_count "lab doctor finds every wired hook"  "$(bash scripts/lab_doctor.sh | grep -c 'hook referenced in settings.json is missing')" 0
echo "referee-blind hook (blind list as a tool scope)"
RB=.claude/hooks/referee-blind.sh
expect_count "referee reading SUITS.md is blocked"        "$(printf '%s' '{"agent_type":"referee","tool_name":"Read","tool_input":{"file_path":"SUITS.md"}}' | bash $RB >/dev/null 2>&1; echo $?)" 2
expect_count "referee grepping CLAIMS.md is blocked"      "$(printf '%s' '{"agent_type":"referee","tool_name":"Grep","tool_input":{"pattern":"x","path":"projects/p/CLAIMS.md"}}' | bash $RB >/dev/null 2>&1; echo $?)" 2
expect_count "referee globbing memory/ is blocked"        "$(printf '%s' '{"agent_type":"referee","tool_name":"Glob","tool_input":{"pattern":"memory/*.md"}}' | bash $RB >/dev/null 2>&1; echo $?)" 2
expect_count "referee reading the REFEREE report is blocked" "$(printf '%s' '{"agent_type":"referee","tool_name":"Read","tool_input":{"file_path":"projects/p/review_response/REFEREE_20261011.md"}}' | bash $RB >/dev/null 2>&1; echo $?)" 2
expect_count "referee reading its own output dir passes" "$(printf '%s' '{"agent_type":"referee","tool_name":"Read","tool_input":{"file_path":"projects/p/review_response/referee/20261012/a.R"}}' | bash $RB >/dev/null 2>&1; echo $?)" 0
expect_count "referee reading the manuscript passes"      "$(printf '%s' '{"agent_type":"referee","tool_name":"Read","tool_input":{"file_path":"projects/p/paper/m.tex"}}' | bash $RB >/dev/null 2>&1; echo $?)" 0
expect_count "referee writing outside its dir is blocked" "$(printf '%s' '{"agent_type":"referee","tool_name":"Write","tool_input":{"file_path":"projects/p/paper/m.tex","content":"x"}}' | bash $RB >/dev/null 2>&1; echo $?)" 2
expect_count "referee git log is blocked"                 "$(printf '%s' '{"agent_type":"referee","tool_name":"Bash","tool_input":{"command":"git log --oneline"}}' | bash $RB >/dev/null 2>&1; echo $?)" 2
expect_count "main session reading SUITS.md passes"       "$(printf '%s' '{"tool_name":"Read","tool_input":{"file_path":"SUITS.md"}}' | bash $RB >/dev/null 2>&1; echo $?)" 0
expect_count "louis reading CLAIMS.md passes"             "$(printf '%s' '{"agent_type":"louis","tool_name":"Read","tool_input":{"file_path":"projects/p/CLAIMS.md"}}' | bash $RB >/dev/null 2>&1; echo $?)" 0
echo "hooks"
expect_count "lint-suits hook silent for non-SUITS edit" "$(echo '{"tool_input":{"file_path":"/x/y/paper.tex"}}' | bash .claude/hooks/lint-suits.sh 2>&1 | wc -l | tr -d ' ')" 0
expect_count "r-repro hook flags bad.R"   "$(echo "{\"tool_input\":{\"file_path\":\"$PWD/$F/bad.R\"}}" | bash .claude/hooks/check-r-reproducibility.sh 2>&1 | grep -c 'draws-without-seed')" 1
expect_count "protocol hook warns for unregistered sim script" "$(echo '{"tool_input":{"command":"Rscript projects/fixture-proj/R/run_simulation.R"}}' | bash .claude/hooks/pre-run-protocol-check.sh 2>&1 | grep -c 'PROTOCOL')" 1
expect_count "protocol hook silent for verify script" "$(echo '{"tool_input":{"command":"Rscript projects/fixture-proj/R/verify_simulation.R"}}' | bash .claude/hooks/pre-run-protocol-check.sh 2>&1 | wc -l | tr -d ' ')" 0
# the dangerous command is assembled at runtime so this file never contains the literal pattern
DANGER="rm -rf"; DANGER="$DANGER ~"
expect_count "safety hook blocks home deletion" "$(printf '{"tool_input":{"command":"%s"}}' "$DANGER" | bash .claude/hooks/pre-bash-safety.sh >/dev/null 2>&1; echo $?)" 2
GH=$(mktemp -d); cp -r $F/guards_fixture/. $GH/; sed -i 's#^tex = "paper/good.tex"#tex = "paper/bad.tex"#' $GH/CLAIM_GUARDS.toml   # the hook checks only the manuscript named in [meta].tex
expect_count "claim-guards hook flags the guarded manuscript" "$(echo "{\"tool_input\":{\"file_path\":\"$GH/paper/bad.tex\"}}" | bash .claude/hooks/check-claim-guards.sh 2>&1 | grep -c 'claim guard')" 1
expect_count "claim-guards hook skips a non-manuscript .tex" "$(echo "{\"tool_input\":{\"file_path\":\"$PWD/$F/guards_fixture/paper/bad.tex\"}}" | bash .claude/hooks/check-claim-guards.sh 2>&1 | wc -l | tr -d ' ')" 0
rm -rf $GH
expect_count "claim-guards hook silent without TOML" "$(echo '{"tool_input":{"file_path":"/x/projects/nope/paper/m.tex"}}' | bash .claude/hooks/check-claim-guards.sh 2>&1 | wc -l | tr -d ' ')" 0
expect_count "settings.json parses"       "$(python3 -c 'import json;json.load(open(".claude/settings.json"))' && echo 0)" 0

echo
echo "passed $PASS, failed $FAIL"
[ "$FAIL" -eq 0 ]
