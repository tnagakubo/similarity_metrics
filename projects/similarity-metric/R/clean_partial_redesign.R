# Remove cells with n_valid == 0 (failed worker) from redesign partial RDS
fp <- "results/normalizer_comparison_redesign_partial.rds"
p <- readRDS(fp)
cat("Before:", length(p$cells), "cells\n")
keep <- vapply(p$cells, function(c) {
  any(c$summary$n_valid > 0)
}, logical(1))
removed_idx <- which(!keep)
if (length(removed_idx) > 0) {
  cat("Removing failed cells:\n")
  for (i in removed_idx) {
    c <- p$cells[[i]]
    cat(sprintf("  [%d] %s n=%d (n_valid=%d)\n",
                i, c$scenario, c$n, c$summary$n_valid[1]))
  }
}
p$cells <- p$cells[keep]
saveRDS(p, fp)
cat("After:", length(p$cells), "cells (saved)\n")
