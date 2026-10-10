#!/bin/bash
# Mike's Gate: R reproducibility lint (static). Fires on PostToolUse(Write|Edit).
# When an R / Rmd / qmd file is edited, run scripts/check_r_reproducibility.sh on that
# file and surface the row. Advisory only (exit 0). No jq dependency.
INPUT=$(cat 2>/dev/null || echo "")
EDITED=$(printf '%s' "$INPUT" | grep -oE '"file_path" *: *"[^"]+"' | head -1 | sed -E 's/.*: *"//; s/"$//; s#\\\\#/#g')
[ -z "$EDITED" ] && exit 0
case "$EDITED" in
  *.R|*.r|*.Rmd|*.qmd) ;;
  *) exit 0 ;;
esac
cd "$(git rev-parse --show-toplevel 2>/dev/null || pwd)" || exit 0
[ -f "$EDITED" ] || exit 0
OUT=$(bash scripts/check_r_reproducibility.sh "$EDITED" 2>/dev/null | sed -n '3p')
case "$OUT" in
  *"❌"*|*"⚠️"*) echo "Mike: R 再現性チェック → $OUT" >&2 ;;
esac
exit 0
