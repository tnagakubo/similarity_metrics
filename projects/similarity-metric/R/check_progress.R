p <- "results/w1_raw_simulation_partial.rds"
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
