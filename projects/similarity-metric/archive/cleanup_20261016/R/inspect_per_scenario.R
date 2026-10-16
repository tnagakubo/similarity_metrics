# =============================================================================
# Per-scenario analysis (Tak 2026-05-10): scenarios were designed to test
# different challenges; aggregating across them hides the design intent.
# Show: for each scenario × n, the 5 normalizers' relative metrics + coverage.
# =============================================================================
g1 <- readRDS("results/normalizer_comparison_grid1.rds")
g1$rel_bias     <- g1$bias / g1$true_nABCD
g1$rel_rmse     <- g1$rmse / g1$true_nABCD
g1$rel_ci_width <- g1$mean_ci_width / g1$true_nABCD

NORMS <- c("IQR", "Q95Q5", "SD", "MAD", "Range")
SCENARIOS <- c("S1", "S2", "S3", "S4", "S5", "S6", "S7", "S8", "S9")

# Scenario descriptions (from scenarios_extended.R)
SCEN_DESC <- c(
  S1 = "Null (no difference)",
  S2 = "Small location shift",
  S3 = "Moderate location shift",
  S4 = "Large location shift",
  S5 = "Scale shift",
  S6 = "Log-normal heavy tail",
  S7 = "Location + Scale",
  S8 = "Outlier mixture (1% point mass)",
  S9 = "Asymmetric Gamma"
)

# Per-scenario × n × normalizer table
fmt <- function(x) sprintf("%7.4f", x)
fmt_pct <- function(x) sprintf("%5.1f%%", 100 * x)

cat("=========================================================================\n")
cat(" Per-Scenario × Sample Size analysis (Grid 1)\n")
cat(" Cell layout: rel_bias | rel_rmse | rel_ci_width | coverage\n")
cat("=========================================================================\n")

for (sc in SCENARIOS) {
  cat(sprintf("\n=== %s: %s ===\n", sc, SCEN_DESC[sc]))
  for (nv in c(50, 100, 200)) {
    cat(sprintf("\n  n = %d:\n", nv))
    sub <- g1[g1$scenario == sc & g1$n == nv, ]
    sub <- sub[match(NORMS, sub$normalizer), ]  # order
    cat(sprintf("    %-6s  %8s  %8s  %8s  %8s  %s\n",
                "Norm", "rel_bias", "rel_rmse", "rel_CIw", "cov", "(true_nABCD)"))
    for (i in seq_len(nrow(sub))) {
      r <- sub[i, ]
      # For S1, true_nABCD ~ 0 → rel metrics may be Inf/NA; show special
      if (sc == "S1") {
        cat(sprintf("    %-6s  %8s  %8s  %8s  %8s  (true=%.4f)\n",
                    r$normalizer, "n/a", "n/a", "n/a", fmt_pct(r$coverage_pct),
                    r$true_nABCD))
      } else {
        cat(sprintf("    %-6s  %8s  %8s  %8s  %8s  (true=%.4f)\n",
                    r$normalizer,
                    fmt(r$rel_bias), fmt(r$rel_rmse),
                    fmt(r$rel_ci_width), fmt_pct(r$coverage_pct),
                    r$true_nABCD))
      }
    }
  }
}

# Per-scenario winner by metric (n=200, asymptotic regime)
cat("\n\n=========================================================================\n")
cat(" Per-Scenario winners at n=200 (asymptotic regime)\n")
cat("=========================================================================\n")
for (sc in SCENARIOS) {
  if (sc == "S1") {
    cat(sprintf("\n%s (%s): all normalizers cov=0%% (boundary)\n", sc, SCEN_DESC[sc]))
    next
  }
  sub <- g1[g1$scenario == sc & g1$n == 200, ]
  sub <- sub[match(NORMS, sub$normalizer), ]
  rb <- sub$rel_bias
  rr <- sub$rel_rmse
  rw <- sub$rel_ci_width
  cv <- sub$coverage_pct
  cat(sprintf("\n%s (%s):\n", sc, SCEN_DESC[sc]))
  cat(sprintf("  rel_bias min:    %s (%.4f)\n", sub$normalizer[which.min(rb)], min(rb)))
  cat(sprintf("  rel_rmse min:    %s (%.4f)\n", sub$normalizer[which.min(rr)], min(rr)))
  cat(sprintf("  rel_CIw  min:    %s (%.4f)\n", sub$normalizer[which.min(rw)], min(rw)))
  cat(sprintf("  cov closest 95%%: %s (%.4f)\n",
              sub$normalizer[which.min(abs(cv - 0.95))],
              cv[which.min(abs(cv - 0.95))]))
}
