#!/bin/bash
# Mike's Gate: protocol before results (Phase 2 → 3). Fires on PreToolUse(Bash).
# If the command runs an R script whose name says it GENERATES results (sim / simulation /
# run_ / survey / experiment / study / bootstrap), check that some PROTOCOL_*.md in that
# project mentions the script. If none does, remind (advisory, exit 0): pre-register first,
# or label the run exploratory and keep its output out of the manuscript.
# Post-hoc tools (verify_ / check_ / inspect_ / figures / regen / export / analyze / summarize) are skipped.
INPUT=$(cat 2>/dev/null || echo "")
CMD=$(printf '%s' "$INPUT" | grep -oE '"command" *: *"([^"\\]|\\.)*"' | head -1 | sed -E 's/^"command" *: *"//; s/"$//; s#\\\\#/#g; s#\\"#"#g')
[ -z "$CMD" ] && exit 0
echo "$CMD" | grep -qE '(^|[^A-Za-z])(Rscript|R -f|R CMD BATCH|quarto render|source\()' || exit 0
cd "$(git rev-parse --show-toplevel 2>/dev/null || pwd)" || exit 0
for s in $(echo "$CMD" | grep -oE '[A-Za-z0-9_./-]*projects/[A-Za-z0-9_-]+/R/[A-Za-z0-9_]+\.R' | sort -u); do
  base=$(basename "$s")
  echo "$base" | grep -qiE '(sim|simulation|run_|survey|experiment|study|bootstrap)' || continue
  echo "$base" | grep -qiE '^(verify|check|inspect|figures|regen|export|analyze|analyse|summarize|summarise|plot|fig)' && continue
  proj=$(echo "$s" | sed -E 's#.*(projects/[A-Za-z0-9_-]+)/R/.*#\1#')
  if ! grep -lq -- "$base" "$proj"/PROTOCOL_*.md 2>/dev/null; then
    echo "Mike: $base は PROTOCOL_*.md で事前登録されていない。confirmatory run なら先に /protocol。探索的なら出力は scratchpad に置き、論文の数値には使わないこと（RESEARCH_FRAMEWORK Phase 2 gate）" >&2
  fi
done
exit 0
