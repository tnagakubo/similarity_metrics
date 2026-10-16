# Export redesign results as wide-format tables (CSV + console markdown)
g <- readRDS("results/normalizer_comparison_redesign.rds")
true_df <- readRDS("results/true_redesign.rds")
smd_df  <- readRDS("results/smd_redesign.rds")

NORMS <- c("IQR", "Q95Q5", "SD", "MAD", "Range", "SMD")
# N6 (Outlier 20%) excluded 2026-05-11 (unrealistic setting, Tak directive)
SCENS <- c("N1", "N2", "N3", "N4", "N5", "N7", "N8")
g <- g[g$scenario != "N6", ]

# Long-format full table for CSV export
out_long <- g[, c("scenario", "n", "normalizer", "true_nABCD",
                   "mean_est", "bias", "rmse", "sd_est",
                   "mean_ci_width", "coverage_pct", "n_valid")]
out_long <- out_long[order(match(out_long$scenario, SCENS),
                              out_long$n,
                              match(out_long$normalizer, NORMS)), ]
write.csv(out_long, "results/redesign_full_table.csv", row.names = FALSE)
cat("Saved: results/redesign_full_table.csv (", nrow(out_long), "rows)\n\n")

# Console: per-scenario × n table (one block per scenario)
fmt <- function(x) if (is.na(x)) "  -- " else sprintf("%7.4f", x)
fmt_pct <- function(x) if (is.na(x)) "  -- " else sprintf("%5.1f%%", 100 * x)

for (sc in SCENS) {
  cat(sprintf("\n========================================\n"))
  cat(sprintf(" %s (population SMD = %.4f)\n",
              sc, smd_df$population_smd[smd_df$scenario == sc]))
  cat(sprintf("========================================\n"))
  for (nv in c(50L, 100L, 200L)) {
    cat(sprintf("\n  n = %d:\n", nv))
    cat(sprintf("  | %-6s | %8s | %8s | %8s | %8s | %8s | %7s |\n",
                "Norm", "true", "mean", "bias", "rmse", "ci_w", "cov"))
    cat(sprintf("  |%s|%s|%s|%s|%s|%s|%s|\n",
                "--------", "----------", "----------", "----------",
                "----------", "----------", "---------"))
    sub <- g[g$scenario == sc & g$n == nv, ]
    sub <- sub[match(NORMS, sub$normalizer), ]
    for (i in seq_len(nrow(sub))) {
      r <- sub[i, ]
      cat(sprintf("  | %-6s | %s | %s | %s | %s | %s | %s |\n",
                  r$normalizer,
                  fmt(r$true_nABCD),
                  fmt(r$mean_est),
                  fmt(r$bias),
                  fmt(r$rmse),
                  fmt(r$mean_ci_width),
                  fmt_pct(r$coverage_pct)))
    }
  }
}
