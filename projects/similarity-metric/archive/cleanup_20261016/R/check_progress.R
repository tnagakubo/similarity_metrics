# =============================================================================
# W1 raw simulation — in-flight progress monitor
#
# Reads the per-cell partial output written by w1_raw_simulation.R and prints
# how many of the 21 (scenario x n) cells are done, plus an ETA.
#
# 2026-09-22: paths are resolved relative to THIS script's location (the
# repo-root results/ tree was archived to archives/results_root_20260516/, so
# the old cwd-relative "results/..." path silently reported "(no partial yet)").
# No random number generation here, nothing is written.
# =============================================================================

find_project_root <- function() {
  # script location (Rscript --file=... or source(); two levels up from R/)
  args  <- commandArgs(trailingOnly = FALSE)
  f_arg <- sub("^--file=", "", args[grepl("^--file=", args)])
  if (length(f_arg) > 0 && file.exists(f_arg)) {
    return(normalizePath(dirname(dirname(f_arg)), winslash = "/"))
  }
  ofile <- tryCatch(sys.frame(1)$ofile, error = function(e) NULL)
  if (!is.null(ofile)) {
    return(normalizePath(dirname(dirname(ofile)), winslash = "/"))
  }
  here   <- normalizePath(getwd(), winslash = "/", mustWork = FALSE)
  target <- file.path("projects", "similarity-metric")
  if (dir.exists(file.path(here, target))) {
    return(normalizePath(file.path(here, target), winslash = "/"))
  }
  here
}

PROJECT_ROOT <- find_project_root()
p <- file.path(PROJECT_ROOT, "results", "w1_raw_simulation_partial.rds")

cat("[partial] ", p, "\n", sep = "")
if (!file.exists(p)) { cat("(no partial yet)\n"); quit() }
x <- readRDS(p)
n <- length(x$cells)
cat(sprintf("[progress] %d / 21 cells done\n", n))
if (n > 0) {
  for (c in x$cells) {
    cat(sprintf("  %s n=%3d   bias=%+.4f  cov=%.3f  rmse=%.4f  ciw=%.4f  (%.1fs)\n",
                c$scenario, c$n,
                c$summary$bias, c$summary$coverage_pct,
                c$summary$rmse, c$summary$mean_ci_width,
                c$elapsed_s))
  }
  tot <- sum(sapply(x$cells, function(c) c$elapsed_s))
  if (n > 0 && n < 21) {
    cat(sprintf("[ETA] %.1fs per cell avg, %.1f min remaining\n",
                tot / n,
                (21 - n) * tot / n / 60))
  }
}
