#!/bin/bash
# check_consistency.sh — Donna's cross-file consistency check (state ↔ script ↔ manuscript).
# Usage: bash scripts/check_consistency.sh [--quiet]
# Advisory (exit 0). Prints only findings unless --verbose.
#
#  1. Phase line: SUITS.md Current Status  ==  projects/*/LAB_STATUS.md
#  2. LAB_STATUS.md "Updated" older than the last commit touching that project's paper/ → stale
#  3. Manuscript: \ref{} to a label that is never \label{}ed; duplicate \label{}
#  4. Lifecycle artifacts present per project (CLAIMS.md, DECISIONS.md, PROTOCOL_*.md, results/NUMBERS_LEDGER.csv)
#  5. Memory files referenced by the system (CLAUDE.md, RESEARCH_FRAMEWORK.md, .claude/**, agents/, templates/)
#     that are missing from the versioned memory/ directory → the principle lives only in a local auto-memory
#  6. SUITS.md line count vs the 1000-line archive rule
#  7. Inference markers ([推測] / 🔍要根拠) in manuscripts or CLAIMS.md (S21, scripts/ground_audit.py);
#     IDEAS_BACKLOG.md present at the root with unique I-YYYYMMDD-n ids (S23)
set -u
cd "$(git rev-parse --show-toplevel 2>/dev/null || pwd)" || exit 0
VERBOSE=1; [ "${1:-}" = "--quiet" ] && VERBOSE=0
N=0
say() { N=$((N+1)); echo "  - $*"; }

# 1 & 2 & 4: per project
SUITS_PHASE=$(grep -m1 -E '^\*\*Phase\*\*' SUITS.md 2>/dev/null | sed -E 's/^\*\*Phase\*\*: *//; s/ *(→|->|（|\().*$//' | sed -E 's/[[:space:]]+$//')
for st in projects/*/LAB_STATUS.md; do
  [ -f "$st" ] || continue
  proj=$(dirname "$st"); name=$(basename "$proj")
  LAB_PHASE=$(grep -m1 -E '^\*\*Phase\*\*' "$st" | sed -E 's/^\*\*Phase\*\*: *//' | sed -E 's/[[:space:]]+$//')
  if [ -n "$SUITS_PHASE" ] && [ -n "$LAB_PHASE" ]; then
    # compare the leading phase number only (text after it may differ in wording)
    sp=$(echo "$SUITS_PHASE" | grep -oE '^[0-9]+'); lp=$(echo "$LAB_PHASE" | grep -oE '^[0-9]+')
    if [ "$sp" != "$lp" ]; then say "Phase mismatch: SUITS.md says '$SUITS_PHASE', $st says '$LAB_PHASE' (Donna: align them; /phase)"; fi
  fi
  UPD=$(grep -m1 -E '^\*\*Updated\*\*' "$st" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}')
  LASTPAPER=$(git log -1 --format=%cs -- "$proj/paper" 2>/dev/null)
  if [ -n "$UPD" ] && [ -n "$LASTPAPER" ] && [[ "$UPD" < "$LASTPAPER" ]]; then
    say "$name: LAB_STATUS.md Updated=$UPD but paper/ last committed $LASTPAPER → state file may be stale"
  fi
  for art in CLAIMS.md DECISIONS.md; do
    [ -f "$proj/$art" ] || say "$name: missing $art (templates/$(echo $art | tr 'A-Z' 'a-z' | sed 's/\.md$//')_template.md; /claims init, /decide)"
  done
  ls "$proj"/PROTOCOL_*.md >/dev/null 2>&1 || say "$name: no PROTOCOL_*.md — simulation/analysis protocols must be pre-registered (/protocol)"
  [ -f "$proj/results/NUMBERS_LEDGER.csv" ] || say "$name: results/NUMBERS_LEDGER.csv missing — numbers gate has no ledger (/verify-numbers)"
  # 3: manuscript refs
  for tex in "$proj"/paper/*.tex; do
    [ -f "$tex" ] || continue
    case "$(basename "$tex")" in supplement*|*template*) continue;; esac
    python3 - "$tex" <<'PY' | while IFS= read -r l; do say "$l"; done
import re,sys
from pathlib import Path
p=Path(sys.argv[1]); t=p.read_text(encoding='utf-8',errors='replace')
t=re.sub(r'(?<!\\)%.*','',t)
labels=re.findall(r'\\label\{([^}]+)\}',t)
refs=set(re.findall(r'\\(?:eq|auto|c|C|page)?ref\*?\{([^}]+)\}',t))
dup=sorted({l for l in labels if labels.count(l)>1})
miss=sorted(r for r in refs if r not in set(labels))
if miss: print(f"{p.name}: \\ref to undefined label(s): {', '.join(miss)}")
if dup: print(f"{p.name}: duplicate \\label(s): {', '.join(dup)}")
PY
  done
done

# 5: memory references
MISSING_MEM=$(grep -rhoE 'memory/[A-Za-z0-9_]+\.md' CLAUDE.md RESEARCH_FRAMEWORK.md .claude/agents .claude/skills .claude/rules .claude/hooks agents templates 2>/dev/null \
  | sed 's#^memory/##' | sort -u | while read -r m; do [ -f "memory/$m" ] || echo "$m"; done)
if [ -n "$MISSING_MEM" ]; then
  say "memory files referenced by the system but not versioned in memory/: $(echo "$MISSING_MEM" | tr '\n' ' ')(principles live only in a local auto-memory → version them)"
fi

# 5b: subagent memory split across nested .claude dirs (sessions started from a subdirectory)
NESTED=$(find projects -type d -path '*/.claude/agent-memory/*' 2>/dev/null | head -5)
if [ -n "$NESTED" ]; then
  say "nested subagent memory under projects/ (start Claude Code from the repo root; merge into .claude/agent-memory/): $(echo "$NESTED" | tr '\n' ' ')"
fi

# 5c: phase-specific artifacts
for st in projects/*/LAB_STATUS.md; do
  [ -f "$st" ] || continue
  proj=$(dirname "$st"); name=$(basename "$proj")
  ph=$(grep -m1 -E '^\*\*Phase\*\*' "$st" | grep -oE '[0-9]+' | head -1)
  if [ "${ph:-x}" = "8" ] && [ ! -f "$proj/review_response/RESPONSE_TRACKER.md" ]; then
    say "$name: Phase 8 but no review_response/RESPONSE_TRACKER.md (/respond-reviewers init, or /decide that no letter is needed for a simulated review)"
  fi
  if [ -f "$proj/CLAIMS.md" ]; then
    tot=$(grep -cE '^\| C-[0-9]+ \|' "$proj/CLAIMS.md"); pend=$(grep -cE '^\| C-[0-9]+ \|.*\| pending \|' "$proj/CLAIMS.md")
    [ "$tot" -gt 0 ] && [ "$pend" -eq "$tot" ] && say "$name: CLAIMS.md has $tot row(s), all pending (/claims init → check)"
  fi
done

# 7: evidence before inference (S21) and the ideas backlog (S23) — Tak 2026-10-12
GFILES=""
for proj in projects/*/; do
  [ -d "$proj" ] || continue
  for tex in "$proj"paper/*.tex; do [ -f "$tex" ] || continue; case "$(basename "$tex")" in *template*) continue;; esac; GFILES="$GFILES $tex"; done
  [ -f "$proj/CLAIMS.md" ] && GFILES="$GFILES $proj/CLAIMS.md"
done
if [ -n "$GFILES" ]; then
  GOUT=$(python3 scripts/ground_audit.py $GFILES 2>/dev/null | grep -vE '^ground_audit:' )
  if [ -n "$GOUT" ]; then
    say "inference markers in manuscript/claims (write nothing on inference — /ground first): $(echo "$GOUT" | wc -l | tr -dc '0-9') line(s), e.g. $(echo "$GOUT" | head -1)"
  fi
fi
if [ ! -f IDEAS_BACKLOG.md ]; then
  say "IDEAS_BACKLOG.md missing at the repo root — paper ideas that leave the current scope have nowhere to go (/idea)"
else
  DUPI=$(grep -oE '^\| I-[0-9]{8}-[0-9]+ ' IDEAS_BACKLOG.md | sort | uniq -d | tr -d '| ' | tr '\n' ' ')
  [ -n "$DUPI" ] && say "IDEAS_BACKLOG.md: duplicate idea id(s): $DUPI"
fi

# 6: SUITS size
L=$(wc -l < SUITS.md 2>/dev/null | tr -dc '0-9'); L=${L:-0}
[ "$L" -ge 900 ] && say "SUITS.md is $L lines (archive at 1000; /archive)"

if [ "$N" -gt 0 ]; then
  echo "Donna: consistency check — $N finding(s) above."
else
  [ "$VERBOSE" -eq 1 ] && echo "Donna: consistency check — clean."
fi
exit 0
