#!/bin/bash
# Rachel & Donna: Paper EN/JA synchronization reminder (Rule 2.7)
# Fires on PostToolUse(Write|Edit). Generic: for any manuscript under
# projects/*/paper/, remind only when a Japanese counterpart actually exists
# on disk. If the JA version has been deliberately removed (see
# memory/project_ja_paper_deleted.md) the hook stays silent.
# No jq dependency — raw grep on the hook input JSON.

INPUT=$(cat 2>/dev/null || echo "")

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd)" || exit 0
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." 2>/dev/null && pwd)" || exit 0

# Extract the edited path (first "file_path":"..." occurrence), tolerate \\ and /
EDITED=$(printf '%s' "$INPUT" | grep -oE '"file_path" *: *"[^"]+"' | head -1 | sed -E 's/.*: *"//; s/"$//; s#\\\\#/#g')
[ -z "$EDITED" ] && exit 0

case "$EDITED" in
  *projects/*/paper/*.tex|*projects/*/paper/*.md) ;;
  *) exit 0 ;;
esac

BASE=$(basename "$EDITED")
DIR=$(dirname "$EDITED")
STEM="${BASE%.*}"

# EN edited (.tex) -> look for a JA counterpart *_ja.md in the same folder
if [ "${BASE##*.}" = "tex" ]; then
  JA=$(ls "$DIR"/*_ja.md 2>/dev/null | head -1)
  if [ -n "$JA" ]; then
    echo "Rachel: EN版 ($BASE) が更新されました。JA版 ($(basename "$JA")) も同期してください。(Rule 2.7)" >&2
  fi
  exit 0
fi

# JA edited (*_ja.md) -> look for the EN .tex in the same folder
case "$STEM" in
  *_ja)
    EN=$(ls "$DIR"/*.tex 2>/dev/null | grep -v supplement | head -1)
    if [ -n "$EN" ]; then
      echo "Rachel: JA版 ($BASE) が更新されました。EN版 ($(basename "$EN")) も同期してください。(Rule 2.7)" >&2
    fi
    ;;
esac

exit 0
