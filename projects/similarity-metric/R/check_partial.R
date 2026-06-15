p <- readRDS("results/normalizer_comparison_redesign_partial.rds")
cat("Total cells:", length(p$cells), "\n\n")
for (i in seq_along(p$cells)) {
  c <- p$cells[[i]]
  s <- c$summary
  iqr_est <- s$mean_est[s$normalizer == "IQR"]
  iqr_valid <- s$n_valid[s$normalizer == "IQR"]
  cat(sprintf("[%2d] %s n=%d  elapsed=%6.1fs  IQR mean_est=%.4f  n_valid=%d\n",
              i, c$scenario, c$n, c$elapsed_s, iqr_est, iqr_valid))
}
