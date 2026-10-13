#!/bin/bash
# lab_doctor.sh — is the lab's machinery actually wired and runnable on this machine?
# Checks the toolchain (python3 in isolated mode, PyYAML, tomllib, Rscript, pdflatex), the hook wiring
# (settings.json ↔ .claude/hooks), skills and agents (frontmatter, read-only agents really read-only),
# CI workflows (every script they call exists), ratchet baselines, and the regression-test count.
# Usage: bash scripts/lab_doctor.sh [--strict] [--quiet]
#   advisory (exit 0) unless --strict, which exits 1 on any ❌. --quiet prints only ❌/⚠️ lines and the summary.
set -u
export PYTHONIOENCODING=utf-8
cd "$(git rev-parse --show-toplevel 2>/dev/null || pwd)" || exit 0
STRICT=0; QUIET=0
for a in "$@"; do case "$a" in --strict) STRICT=1 ;; --quiet) QUIET=1 ;; esac; done
BAD=0; WARN=0; N=0
ok()   { N=$((N+1)); [ $QUIET -eq 1 ] || echo "  ✅ $*"; }
warn() { N=$((N+1)); WARN=$((WARN+1)); echo "  ⚠️ $*"; }
bad()  { N=$((N+1)); BAD=$((BAD+1));   echo "  ❌ $*"; }

[ $QUIET -eq 1 ] || echo "Donna: lab doctor ($(date '+%Y-%m-%d %H:%M'))"
# ---- toolchain -------------------------------------------------------------------------------------------------
if command -v python3 >/dev/null 2>&1; then
  PYV=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:3])))' 2>/dev/null)
  ok "python3 $PYV ($(command -v python3))"
  if python3 -I -c 'import encodings' >/dev/null 2>&1; then ok "python3 -I (isolated mode) works"
  else bad "python3 -I fails — the interpreter finds its stdlib only through the registry/PATH; reinstall Python so that python.exe and Lib/ live together"; fi
  PREFIX=$(python3 -c 'import sys; print(sys.prefix.replace("\\", "/").lower())' 2>/dev/null)
  HERE=$( (pwd -W 2>/dev/null || pwd) | tr 'A-Z' 'a-z')
  case "$PREFIX" in "$HERE"*) bad "python3's sys.prefix is the working directory ($PREFIX): broken install, and \$PWD/Lib is on sys.path (a planted module there would import)" ;; *) ok "python3 prefix $PREFIX" ;; esac
  python3 -c 'import yaml' >/dev/null 2>&1 && ok "PyYAML (protocol_compile.py)" || bad "PyYAML missing — pip install pyyaml (protocol_compile.py and 5 regression tests need it)"
  python3 -c 'import tomllib' >/dev/null 2>&1 && ok "tomllib (claim_guards.py, Python ≥ 3.11)" || bad "tomllib missing — Python ≥ 3.11 required for claim_guards.py"
else bad "python3 not on PATH"; fi
if command -v Rscript >/dev/null 2>&1; then ok "Rscript $(Rscript -e 'cat(as.character(getRversion()))' 2>/dev/null)"; else warn "Rscript not found — R generators, replication and the R-vs-Python macro test are skipped"; fi
if command -v pdflatex >/dev/null 2>&1; then ok "pdflatex ($(command -v pdflatex))"; else warn "pdflatex not found — paper/build.sh cannot run here"; fi
command -v cygpath >/dev/null 2>&1 && ok "MSYS shell (cygpath present; tests convert paths for Rscript)" || true

# ---- hooks: settings.json ↔ .claude/hooks ------------------------------------------------------------------------
if python3 -c 'import json,sys; json.load(open(".claude/settings.json", encoding="utf-8"))' >/dev/null 2>&1; then ok ".claude/settings.json parses"
else bad ".claude/settings.json does not parse"; fi
REFD=$(grep -oE '\.claude/hooks/[A-Za-z0-9_.-]+\.sh' .claude/settings.json | sort -u)
for h in $REFD; do
  if [ ! -f "$h" ]; then bad "hook referenced in settings.json is missing: $h"
  elif [ ! -x "$h" ] && ! head -1 "$h" | grep -q '^#!'; then bad "hook has no shebang and is not executable: $h"
  else ok "hook wired: $(basename "$h")"; fi
done
for f in .claude/hooks/*.sh; do echo "$REFD" | grep -qx "$f" || warn "hook file not referenced by settings.json (orphan): $f"; done

# ---- skills and agents -------------------------------------------------------------------------------------------
NS=0
for d in .claude/skills/*/; do
  s="${d}SKILL.md"; NS=$((NS+1))
  if [ ! -f "$s" ]; then bad "skill directory without SKILL.md: $d"; continue; fi
  head -1 "$s" | grep -q '^---$' || bad "SKILL.md without frontmatter: $s"
  grep -qE '^(name|description):' "$s" || bad "SKILL.md frontmatter lacks name/description: $s"
done
ok "$NS skill directories checked"
for a in .claude/agents/*.md; do
  head -1 "$a" | grep -q '^---$' || bad "agent without frontmatter: $a"
  grep -qE '^name:' "$a" || bad "agent frontmatter lacks name: $a"
done
for ro in louis jessica; do
  a=".claude/agents/$ro.md"; [ -f "$a" ] || continue
  T=$(grep -E '^tools:' "$a" | head -1)
  if echo "$T" | grep -qE '\b(Edit|Write|NotebookEdit)\b' && ! grep -qE '^disallowedTools:.*\b(Edit|Write)\b' "$a"; then bad "read-only agent $ro lists Edit/Write in tools: $T"; fi
done
ok "read-only agents (louis, jessica) carry no Edit/Write"
# referee: Write is allowed (its own output dir) but only because the blind-list hook confines it; Edit never
if [ -f .claude/agents/referee.md ]; then
  grep -E '^tools:' .claude/agents/referee.md | grep -qE '\bEdit\b' && bad "referee agent lists Edit in tools (it must not touch the manuscript)"
  grep -q 'referee-blind.sh' .claude/settings.json && ok "referee blind list is a PreToolUse hook (referee-blind.sh wired)" || bad "referee-blind.sh is not wired in settings.json — the referee's blind list is a request, not a tool scope"
fi
# persona source for every member agent
for a in .claude/agents/*.md; do
  b=$(basename "$a" .md); case "$b" in louis-replication|referee) continue ;; esac
  [ -f "agents/$b.md" ] || warn "member agent $b has no persona source agents/$b.md"
done

# ---- CI workflows call scripts that exist ------------------------------------------------------------------------
for w in .github/workflows/*.yml; do
  [ -f "$w" ] || continue
  for s in $(grep -oE 'scripts/[A-Za-z0-9_./-]+\.(py|sh|R)' "$w" | sort -u); do
    [ -f "$s" ] && ok "$(basename "$w") → $s" || bad "$(basename "$w") calls a missing script: $s"
  done
done
# ---- ratchet baselines -------------------------------------------------------------------------------------------
for d in projects/*/; do
  ls "$d"paper/*.tex >/dev/null 2>&1 || continue
  p=$(basename "$d")
  for b in numbers_unsourced r_lint_errors results_unbilled; do
    [ -f "scripts/baseline/${p}_${b}.txt" ] && ok "baseline ${p}_${b} = $(tr -d '[:space:]' < "scripts/baseline/${p}_${b}.txt")" || warn "no ratchet baseline scripts/baseline/${p}_${b}.txt (bash scripts/ci_ratchet.sh --update)"
  done
done
# ---- regression tests exist and match the documented count ---------------------------------------------------------
if [ -f scripts/tests/run_tests.sh ]; then
  NT=$(grep -cE '^\s*expect_count ' scripts/tests/run_tests.sh)
  DOC=$(grep -oE '回帰テスト [0-9]+ 件' RESEARCH_FRAMEWORK.md | grep -oE '[0-9]+' | sort -n | tail -1)
  if [ -n "$DOC" ] && [ "$DOC" != "$NT" ]; then warn "run_tests.sh has $NT expect_count calls but RESEARCH_FRAMEWORK.md says $DOC (update the doc)"; else ok "regression tests: $NT expect_count calls (doc agrees)"; fi
fi
echo "lab_doctor: $N checks, $BAD ❌, $WARN ⚠️"
[ $STRICT -eq 1 ] && [ $BAD -gt 0 ] && exit 1
exit 0
