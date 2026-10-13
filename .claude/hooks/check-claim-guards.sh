#!/bin/bash
export PYTHONIOENCODING=utf-8   # Windows cp932 consoles cannot print the report glyphs
# Louis's Gate: claim guards (review findings compiled into executable checks). Fires on PostToolUse(Write|Edit).
# When the manuscript named in a project's CLAIM_GUARDS.toml ([meta].tex) is edited, run scripts/claim_guards.py
# and surface failing guards (and the count of OPEN = pending findings). Advisory only (exit 0). No jq dependency.
# Only .tex is checked: texprose's abstract extraction and % comment stripping are LaTeX-specific, so a .qmd
# would produce false FAILs on abstract-scoped guards. Other .tex files in paper/ (cover letter, response) are
# not the guarded manuscript and are skipped.
INPUT=$(cat 2>/dev/null || echo "")
EDITED=$(printf '%s' "$INPUT" | grep -oE '"file_path" *: *"[^"]+"' | head -1 | sed -E 's/.*: *"//; s/"$//; s#\\\\#/#g')
[ -z "$EDITED" ] && exit 0
case "$EDITED" in
  *.tex) ;;
  *) exit 0 ;;
esac
case "$EDITED" in
  */paper/*) ;;
  *) exit 0 ;;
esac
case "$EDITED" in
  *numbers_macros*|*/generated/*|*supplement*|*template*) exit 0 ;;
esac
cd "$(git rev-parse --show-toplevel 2>/dev/null || pwd)" || exit 0
PROJ=$(dirname "$(dirname "$EDITED")")
TOML="$PROJ/CLAIM_GUARDS.toml"
[ -f "$TOML" ] || exit 0
# Is the edited file the guarded manuscript? ([meta].tex, relative to the TOML's directory)
META_TEX=$(grep -m1 -E '^tex *= *"' "$TOML" | sed -E 's/^tex *= *"//; s/".*$//')
if [ -n "$META_TEX" ]; then
  case "$EDITED" in
    *"$META_TEX") ;;
    *) exit 0 ;;
  esac
fi
ERR=$(mktemp)
OUT=$(python3 scripts/claim_guards.py "$TOML" --tex "$EDITED" 2>"$ERR")
if [ -z "$OUT" ]; then
  echo "Louis: claim_guards.py が走らなかった → $(head -3 "$ERR" | tr '\n' ' ')" >&2
  rm -f "$ERR"; exit 0
fi
rm -f "$ERR"
HEAD=$(printf '%s\n' "$OUT" | sed -n '1p')
case "$HEAD" in
  *" 0 FAIL"*)
    case "$HEAD" in
      *OPEN*) echo "Louis: guards 0 FAIL — $(printf '%s' "$HEAD" | grep -oE '[0-9]+ OPEN[^,]*')（pending の所見。修正が入ったら pending を外す）" >&2 ;;
    esac
    exit 0 ;;
esac
echo "Louis: claim guard が落ちた → $HEAD" >&2
printf '%s\n' "$OUT" | grep -A1 '^\[FAIL' | grep -v '^--$' | head -8 | sed 's/^/  /' >&2
echo "  （python3 scripts/claim_guards.py $TOML で全件。直すか、DECISIONS.md に理由を書いて guard を外す）" >&2
exit 0
