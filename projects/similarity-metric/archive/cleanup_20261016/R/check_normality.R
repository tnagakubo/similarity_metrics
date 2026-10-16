# =============================================================================
# Analyze raw estimates for asymptotic normality
# Reads: results/normality_check_raw.rds
# Output: results/normality_results.rds + figures (QQ plot)
# =============================================================================
suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
  library(tidyr)
  library(patchwork)
})

raw <- readRDS("results/normality_check_raw.rds")
NORMS <- c("IQR", "Q95Q5", "SD", "MAD", "Range")

cat("==========================================================\n")
cat(" Asymptotic Normality Analysis\n")
cat("==========================================================\n")

# --- Per-cell × normalizer: z-score, normality tests ---
analysis_rows <- list()
qq_data       <- list()

for (cell_id in names(raw)) {
  cell <- raw[[cell_id]]
  est_mat <- cell$estimate
  for (norm in NORMS) {
    if (!(norm %in% colnames(est_mat))) next
    est <- est_mat[, norm]
    est <- est[!is.na(est)]
    if (length(est) < 100) next
    true <- cell$truth[[norm]]
    sd_e <- sd(est)
    z    <- (est - true) / sd_e

    # Tests
    sw <- tryCatch(shapiro.test(sample(z, min(5000, length(z)))),
                    error = function(e) list(p.value = NA))
    ks <- tryCatch(ks.test(z, "pnorm"), error = function(e) list(p.value = NA))

    sk <- mean((z - mean(z))^3) / sd(z)^3
    kt <- mean((z - mean(z))^4) / sd(z)^4

    # Asymptotic CI coverage: est ± 1.96 sd_e includes true?
    asy_cov <- mean((est - 1.96 * sd_e) <= true & true <= (est + 1.96 * sd_e),
                     na.rm = TRUE)

    # Bootstrap CI coverage from the raw CI matrices
    lo  <- cell$ci_lower[, norm]
    hi  <- cell$ci_upper[, norm]
    boot_cov <- mean(lo <= true & true <= hi, na.rm = TRUE)

    analysis_rows[[length(analysis_rows) + 1L]] <- data.frame(
      cell        = cell_id,
      scenario    = cell$scenario,
      n           = cell$n,
      normalizer  = norm,
      true_nABCD  = true,
      mean_est    = mean(est),
      sd_est      = sd_e,
      skewness    = sk,
      kurtosis    = kt,
      shapiro_p   = sw$p.value,
      ks_p        = ks$p.value,
      asym_coverage = asy_cov,
      boot_coverage = boot_cov,
      n_valid     = length(est),
      stringsAsFactors = FALSE
    )

    # QQ data (theoretical vs empirical quantiles)
    qq_data[[length(qq_data) + 1L]] <- data.frame(
      cell = cell_id, scenario = cell$scenario, n = cell$n, normalizer = norm,
      theoretical = qnorm(ppoints(length(z))),
      empirical   = sort(z),
      stringsAsFactors = FALSE
    )
  }
}

results_df <- do.call(rbind, analysis_rows)
qq_df      <- do.call(rbind, qq_data)

# --- Console report ---
cat("\n=== Per-cell × normalizer normality summary ===\n")
cat(sprintf("%-10s %-6s %8s %8s %9s %9s %9s %9s\n",
            "Cell", "Norm", "skew", "kurt(3=norm)", "Shapiro p", "KS p", "asym_cov", "boot_cov"))
for (i in seq_len(nrow(results_df))) {
  r <- results_df[i, ]
  cat(sprintf("%-10s %-6s %+8.3f %8.3f %9.3g %9.3g %8.1f%% %8.1f%%\n",
              r$cell, r$normalizer,
              r$skewness, r$kurtosis,
              r$shapiro_p, r$ks_p,
              r$asym_coverage * 100, r$boot_coverage * 100))
}

cat("\n--- Decision rule ---\n")
cat("Asymptotic normal if: |skew|<0.3, 2.5<kurt<3.5, p>0.05, asym_cov ~ 95%\n")

# --- QQ plot figure ---
qq_df$cell_label  <- factor(qq_df$cell,
                              levels = unique(qq_df$cell))
qq_df$normalizer  <- factor(qq_df$normalizer, levels = NORMS)

p <- ggplot(qq_df, aes(x = theoretical, y = empirical)) +
  geom_abline(slope = 1, intercept = 0, color = "red", linetype = "dashed") +
  geom_point(alpha = 0.4, size = 0.3) +
  facet_grid(cell_label ~ normalizer, scales = "free_y") +
  theme_bw(base_size = 9) +
  labs(x = "Theoretical N(0,1) quantile", y = "Empirical z = (est - true) / sd_est",
       title = "Asymptotic Normality Check (n_reps=10000, n_per_group=200)")

OUTPUT_DIR <- "projects/similarity-metric/figures"
ggsave(file.path(OUTPUT_DIR, "fig_normality_qq.png"), p,
       width = 10, height = 8, dpi = 200, bg = "white")
ggsave(file.path(OUTPUT_DIR, "fig_normality_qq.pdf"), p,
       width = 10, height = 8, bg = "white")
cat("\nSaved: figures/fig_normality_qq.png and .pdf\n")

saveRDS(list(summary = results_df, qq_data = qq_df),
        "results/normality_results.rds")
cat("Saved: results/normality_results.rds\n")
