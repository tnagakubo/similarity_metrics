#!/usr/bin/env Rscript
# make_numbers_macros.R — canonical generator of <project>/paper/numbers_macros.tex from the numbers registry.
# Usage: Rscript scripts/make_numbers_macros.R projects/<p>/paper/numbers_registry.csv [projects/<p>/paper/numbers_macros.tex]
# Deterministic (no RNG). Python cross-check: python3 scripts/numbers_registry.py check <registry> --macros <out>
args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 1) stop("usage: make_numbers_macros.R <registry.csv> [out.tex]")
registry <- args[1]
out <- if (length(args) >= 2) args[2] else file.path(dirname(registry), "numbers_macros.tex")
script_dir <- tryCatch(dirname(sub("--file=", "", grep("--file=", commandArgs(), value = TRUE)[1])), error = function(e) "scripts")
source(file.path(script_dir, "r", "numbers_registry.R"))
reg <- num_registry_load(registry)
root <- .num_env$root
vals <- num_write_macros(reg, out, registry_rel = sub(paste0("^", root, "/?"), "", normalizePath(registry)))
cat(sprintf("make_numbers_macros: %d macro(s) → %s\n", length(vals), out))
