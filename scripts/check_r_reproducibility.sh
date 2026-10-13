#!/bin/bash
# check_r_reproducibility.sh — static reproducibility lint for R scripts (Mike's gate, Phase 3).
# Usage: bash scripts/check_r_reproducibility.sh [file.R ...] | [directory]
#        (default: every projects/*/R/*.R and projects/*/exploratory/*/R/*.R)
# Advisory: prints one table row per file; exit 0 always unless STRICT=1 and findings exist.
#
# Checks (static, no R needed):
#   seed      set.seed() present when the script draws random numbers (rnorm/runif/sample/sample.int/rbinom/rexp/rgamma/rbeta/rt/rchisq/rlnorm/rpois/boot)
#   parRNG    parallel code (parLapply/mclapply/future/foreach) also sets a reproducible stream
#             (clusterSetRNGStream / RNGkind("L'Ecuyer-CMRG") / future.seed / registerDoRNG), or seeds per task
#             inside the worker (set.seed(base + task_index), as real_data_survey.R does) — known hole: w1_raw_simulation.R
#   abspath   absolute or machine-specific paths (C:/, /c/Users, /home/, /Users/, setwd())
#   sessinfo  scripts that write results (write.csv/write_csv/saveRDS/ggsave/write.table/sink) also record sessionInfo()
#   install   install.packages() inside an analysis script (belongs in renv / setup, not in the pipeline)
#   hardcode  numeric literals typed into the manuscript must come from CSV; here we only flag `rm(list = ls())` (hides state bugs)
set -u
cd "$(git rev-parse --show-toplevel 2>/dev/null || pwd)" || exit 0

FILES=()
if [ "$#" -eq 0 ]; then
  while IFS= read -r f; do FILES+=("$f"); done < <(ls projects/*/R/*.R projects/*/exploratory/*/R/*.R 2>/dev/null)   # exploratory sandboxes obey the same rules
else
  for a in "$@"; do
    if [ -d "$a" ]; then
      while IFS= read -r f; do FILES+=("$f"); done < <(find "$a" -maxdepth 2 -name '*.R' -o -maxdepth 2 -name '*.Rmd' -o -maxdepth 2 -name '*.qmd' 2>/dev/null | sort)
    elif [ -f "$a" ]; then
      FILES+=("$a")
    fi
  done
fi
[ "${#FILES[@]}" -eq 0 ] && { echo "check_r_reproducibility: no R files"; exit 0; }

FINDINGS=0
printf 'Mike: R reproducibility lint (%d file(s))\n' "${#FILES[@]}"
printf '%-48s %-6s %-7s %-8s %-9s %-8s %s\n' "file" "seed" "parRNG" "abspath" "sessinfo" "install" "notes"
for f in "${FILES[@]}"; do
  notes=""
  draws=$(grep -cE '\b(rnorm|runif|sample|sample\.int|rbinom|rexp|rgamma|rbeta|rt|rchisq|rlnorm|rpois|rmultinom|boot)\s*\(' "$f" 2>/dev/null || true)
  seed=$(grep -cE 'set\.seed\s*\(' "$f" 2>/dev/null || true)
  par=$(grep -cE '\b(parLapply|parLapplyLB|parSapply|mclapply|future_map|future_lapply|foreach|clusterApply)\b' "$f" 2>/dev/null || true)
  parrng=$(grep -cE "clusterSetRNGStream|L'Ecuyer|future\.seed|registerDoRNG|%dorng%|RNGkind" "$f" 2>/dev/null || true)
  abspath=$(grep -nE '([A-Za-z]:[/\\]|/c/Users|/home/[a-z]|/Users/|setwd\s*\()' "$f" 2>/dev/null | grep -vE '^\s*#' | head -1 || true)
  writes=$(grep -cE '\b(write\.csv|write_csv|write\.table|saveRDS|write_rds|ggsave|sink|writeLines)\s*\(' "$f" 2>/dev/null || true)
  sess=$(grep -cE 'sessionInfo\s*\(|session_info\s*\(' "$f" 2>/dev/null || true)
  inst=$(grep -cE 'install\.packages\s*\(' "$f" 2>/dev/null | tr -d '[:space:]' || true)
  rmls=$(grep -cE 'rm\s*\(\s*list\s*=\s*ls\s*\(' "$f" 2>/dev/null || true)
  # verdicts
  if [ "${draws:-0}" -gt 0 ] && [ "${seed:-0}" -eq 0 ]; then s="❌"; notes="$notes draws-without-seed;"; FINDINGS=$((FINDINGS+1)); elif [ "${draws:-0}" -gt 0 ]; then s="✅"; else s="—"; fi
  if [ "${par:-0}" -gt 0 ] && [ "${parrng:-0}" -eq 0 ] && [ "${draws:-0}" -gt 0 ]; then
    if [ "${seed:-0}" -gt 0 ]; then p="⚠️"; notes="$notes parallel:confirm-per-task-seeding;"; else p="❌"; notes="$notes parallel-RNG-not-reproducible;"; FINDINGS=$((FINDINGS+1)); fi
  elif [ "${par:-0}" -gt 0 ]; then p="✅"; else p="—"; fi
  if [ -n "$abspath" ]; then a="❌"; notes="$notes abspath@$(echo "$abspath" | cut -d: -f1);"; FINDINGS=$((FINDINGS+1)); else a="✅"; fi
  if [ "${writes:-0}" -gt 0 ] && [ "${sess:-0}" -eq 0 ]; then si="⚠️"; notes="$notes writes-results-no-sessionInfo;"; else si=$([ "${writes:-0}" -gt 0 ] && echo "✅" || echo "—"); fi
  if [ "${inst:-0}" -gt 0 ]; then ins="❌"; notes="$notes install.packages-in-script;"; FINDINGS=$((FINDINGS+1)); else ins="✅"; fi
  if [ "${rmls:-0}" -gt 0 ]; then notes="$notes rm(list=ls());"; fi
  printf '%-48s %-6s %-7s %-8s %-9s %-8s %s\n' "$(basename "$f")" "$s" "$p" "$a" "$si" "$ins" "$notes"
done
echo
echo "Legend: ✅ ok · ❌ fix before the Phase 3 gate · ⚠️ advisory · — not applicable"
echo "Rule: outputs that feed the manuscript carry sessionInfo() (or renv.lock) beside them; seeds are declared at the top of the script."
if [ "${STRICT:-0}" = "1" ] && [ "$FINDINGS" -gt 0 ]; then exit 1; fi
exit 0
