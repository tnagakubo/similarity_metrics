# Detailed inspection of simulation results
g1 <- readRDS("results/normalizer_comparison_grid1.rds")
g2 <- readRDS("results/normalizer_comparison_grid2.rds")

NORMS <- c("IQR", "Q95Q5", "SD", "MAD", "Range")

fmt <- function(x) sprintf("%7.4f", x)

dump_table <- function(df, label) {
  cat("\n========================================\n")
  cat(" ", label, "\n")
  cat("========================================\n")
  for (norm in NORMS) {
    cat(sprintf("\n--- %s ---\n", norm))
    sub <- df[df$normalizer == norm, ]
    cat(sprintf("%-18s n=%-4s %s %s %s %s\n",
                "scenario", "size", "bias", "rmse", "ci_w", "cov"))
    for (i in seq_len(nrow(sub))) {
      r <- sub[i, ]
      cat(sprintf("%-18s n=%-4d %s %s %s %s\n",
                  r$scenario, r$n,
                  fmt(r$bias), fmt(r$rmse),
                  fmt(r$mean_ci_width), fmt(r$coverage_pct)))
    }
  }
}

dump_table(g1, "Grid 1: Standard scenarios (S1-S9)")
dump_table(g2, "Grid 2: Cross-EM (age, sbp, creatinine)")

# Aggregate: best normalizer per metric
cat("\n\n========================================\n")
cat(" Best normalizer per metric (Grid 1, ranked by mean across all cells)\n")
cat("========================================\n")
for (metric in c("bias", "rmse", "mean_ci_width", "coverage_pct")) {
  agg <- aggregate(g1[[metric]], by = list(normalizer = g1$normalizer),
                    FUN = mean, na.rm = TRUE)
  names(agg)[2] <- metric
  ord <- if (metric == "coverage_pct") {
    # Closer to 0.95 is better for coverage
    order(abs(agg[[metric]] - 0.95))
  } else {
    # Lower is better for bias/rmse/width
    order(agg[[metric]])
  }
  cat(sprintf("\n%s (best -> worst):\n", metric))
  for (i in ord) {
    cat(sprintf("  %-6s %s\n", agg$normalizer[i], fmt(agg[[metric]][i])))
  }
}

# Same for Grid 2
cat("\n\n========================================\n")
cat(" Best normalizer per metric (Grid 2, ranked by mean across all cells)\n")
cat("========================================\n")
for (metric in c("bias", "rmse", "mean_ci_width", "coverage_pct")) {
  agg <- aggregate(g2[[metric]], by = list(normalizer = g2$normalizer),
                    FUN = mean, na.rm = TRUE)
  names(agg)[2] <- metric
  ord <- if (metric == "coverage_pct") {
    order(abs(agg[[metric]] - 0.95))
  } else {
    order(agg[[metric]])
  }
  cat(sprintf("\n%s (best -> worst):\n", metric))
  for (i in ord) {
    cat(sprintf("  %-6s %s\n", agg$normalizer[i], fmt(agg[[metric]][i])))
  }
}

# Special focus: outlier scenario S8 — robustness check
cat("\n\n========================================\n")
cat(" S8 (Outlier mixture) detailed: which normalizer survives?\n")
cat("========================================\n")
s8 <- g1[g1$scenario == "S8", ]
print(s8[, c("normalizer", "n", "bias", "rmse", "mean_ci_width", "coverage_pct")],
      row.names = FALSE)

# S9 (Asymmetric Gamma)
cat("\n--- S9 (Asymmetric Gamma) ---\n")
s9 <- g1[g1$scenario == "S9", ]
print(s9[, c("normalizer", "n", "bias", "rmse", "mean_ci_width", "coverage_pct")],
      row.names = FALSE)

# Coverage convergence with n
cat("\n\n========================================\n")
cat(" Coverage trend with n (Grid 1, averaged across S1-S9)\n")
cat("========================================\n")
for (norm in NORMS) {
  sub <- g1[g1$normalizer == norm, ]
  by_n <- aggregate(sub$coverage_pct, by = list(n = sub$n), FUN = mean, na.rm = TRUE)
  cat(sprintf("%-6s  n=50: %.3f  n=100: %.3f  n=200: %.3f  delta(50->200): %+.3f\n",
              norm,
              by_n$x[by_n$n == 50],
              by_n$x[by_n$n == 100],
              by_n$x[by_n$n == 200],
              by_n$x[by_n$n == 200] - by_n$x[by_n$n == 50]))
}
