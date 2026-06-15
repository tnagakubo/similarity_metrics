# =============================================================================
# Full inspection of redesigned simulation results (N1-N8)
# =============================================================================
g <- readRDS("results/normalizer_comparison_redesign.rds")
true_df <- readRDS("results/true_redesign.rds")
smd_df  <- readRDS("results/smd_redesign.rds")

# Compute scale-invariant metrics where true_nABCD > 0 (skip Null cells)
g$rel_bias     <- ifelse(abs(g$true_nABCD) > 1e-4, g$bias / g$true_nABCD, NA)
g$rel_rmse     <- ifelse(abs(g$true_nABCD) > 1e-4, g$rmse / g$true_nABCD, NA)
g$rel_ci_width <- ifelse(abs(g$true_nABCD) > 1e-4, g$mean_ci_width / g$true_nABCD, NA)

NORMS_FULL  <- c("IQR", "Q95Q5", "SD", "MAD", "Range", "SMD")
SCENARIOS   <- c("N1", "N2", "N3", "N4", "N5", "N6", "N7", "N8")
SCEN_DESC   <- c(
  N1 = "Null (sanity)",
  N2 = "Gaussian loc 0.5sigma (Reference)",
  N3 = "Pure scale 1.5x (Goal 1A: SMD=0)",
  N4 = "Heavy tail t(df=3), matched moments (Goal 1A+2E)",
  N5 = "Outlier 5%, loc 0.5 (Goal 2C mild)",
  N6 = "Outlier 20%, loc 0.5 (Goal 2C severe)",
  N7 = "Heavy skew Gamma(0.5), matched moments (Goal 2D)",
  N8 = "t(df=5)+0.5, same SMD as N2 (Goal 1B)"
)

fmt <- function(x) {
  if (is.na(x)) "    n/a"
  else sprintf("%7.4f", x)
}
fmt_pct <- function(x) {
  if (is.na(x)) "  n/a"
  else sprintf("%5.1f%%", 100 * x)
}

cat("=========================================================================\n")
cat(" Redesign Simulation — Full Per-Scenario Results (n_reps=10000, B=1000)\n")
cat("=========================================================================\n")

for (sc in SCENARIOS) {
  cat(sprintf("\n\n===== %s: %s =====\n", sc, SCEN_DESC[sc]))
  pop_smd <- smd_df$population_smd[smd_df$scenario == sc]
  cat(sprintf("Population SMD = %.4f\n", pop_smd))
  cat("True_nABCD per normalizer:\n")
  truth <- true_df[true_df$scenario == sc, c("normalizer", "true_nABCD")]
  for (nm in NORMS_FULL[1:5]) {
    v <- truth$true_nABCD[truth$normalizer == nm]
    cat(sprintf("  %-6s = %.4f\n", nm, v))
  }

  for (nv in c(50, 100, 200)) {
    cat(sprintf("\n  n = %d:\n", nv))
    sub <- g[g$scenario == sc & g$n == nv, ]
    sub <- sub[match(NORMS_FULL, sub$normalizer), ]
    cat(sprintf("    %-6s  %8s  %8s  %8s  %8s  %7s  %7s  %7s\n",
                "Norm", "true", "mean_est", "bias", "rmse", "rel_bias", "rel_rmse", "cov"))
    for (i in seq_len(nrow(sub))) {
      r <- sub[i, ]
      cat(sprintf("    %-6s  %s  %s  %s  %s  %s  %s  %s\n",
                  r$normalizer,
                  fmt(r$true_nABCD),
                  fmt(r$mean_est),
                  fmt(r$bias),
                  fmt(r$rmse),
                  fmt(r$rel_bias),
                  fmt(r$rel_rmse),
                  fmt_pct(r$coverage_pct)))
    }
  }
}

# Summary across all n: per-scenario × normalizer averaged
cat("\n\n=========================================================================\n")
cat(" SUMMARY (averaged across n=50/100/200 per scenario × normalizer)\n")
cat(" — bias / rel_bias / coverage_pct\n")
cat("=========================================================================\n")

for (sc in SCENARIOS) {
  cat(sprintf("\n--- %s ---\n", sc))
  sub <- g[g$scenario == sc, ]
  agg <- aggregate(cbind(bias, rel_bias, rmse, rel_rmse, coverage_pct) ~ normalizer,
                    data = sub, FUN = mean, na.rm = TRUE)
  agg <- agg[match(NORMS_FULL, agg$normalizer), ]
  cat(sprintf("  %-6s  %9s  %9s  %9s  %9s  %7s\n",
              "Norm", "bias", "rel_bias", "rmse", "rel_rmse", "cov"))
  for (i in seq_len(nrow(agg))) {
    r <- agg[i, ]
    cat(sprintf("  %-6s  %9.4f  %s  %9.4f  %s  %s\n",
                r$normalizer, r$bias,
                fmt(r$rel_bias), r$rmse, fmt(r$rel_rmse),
                fmt_pct(r$coverage_pct)))
  }
}
