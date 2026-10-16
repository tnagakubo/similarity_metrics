# =============================================================================
# Cross-EM EM-invariance Re-analysis (Task #6, Tak directive 2026-05-11)
#
# Question: For each delta_sigma in {0.25, 0.5, 1.0}, do the 3 EMs
#   (age, sbp, creatinine) yield similar nABCD values for each normalizer?
# Lower CV of true_nABCD across 3 EMs at fixed delta_sigma = more EM-invariant.
# Critical for normalizer decision (Tak's Q1: multi-EM target).
#
# Uses existing results/normalizer_comparison_grid2.rds (no re-simulation needed).
# =============================================================================
g2      <- readRDS("results/normalizer_comparison_grid2.rds")
true_g2 <- readRDS("results/true_nabcd_cross_em.rds")

NORMS <- c("IQR", "Q95Q5", "SD", "MAD", "Range")

# Parse scenario name: e.g. age_d0p25 -> (EM=age, delta=0.25)
parse_em <- function(s) {
  m <- regmatches(s, regexec("^([a-z]+)_d(.+)$", s))[[1]]
  if (length(m) != 3) return(c(EM = NA, delta = NA))
  c(EM = m[2], delta = gsub("p", ".", m[3]))
}

# Annotate both data frames
for (df_name in c("g2", "true_g2")) {
  df <- get(df_name)
  parsed <- sapply(df$scenario, parse_em)
  df$EM    <- parsed["EM",   ]
  df$delta <- as.numeric(parsed["delta", ])
  assign(df_name, df)
}

cat("==========================================================\n")
cat(" Cross-EM EM-invariance Analysis (Truth + Sample levels)\n")
cat("==========================================================\n")

# =============================================================================
# Part 1: True nABCD EM-invariance — CV across 3 EMs at fixed delta_sigma
# =============================================================================
cat("\n--- Part 1: TRUE nABCD per (delta x EM x normalizer) ---\n")

for (norm in NORMS) {
  cat(sprintf("\n=== %s ===\n", norm))
  sub <- true_g2[true_g2$normalizer == norm, c("EM", "delta", "true_nABCD")]
  wide <- reshape(sub, idvar = "delta", timevar = "EM", direction = "wide")
  wide <- wide[order(wide$delta), ]
  mat  <- as.matrix(wide[, -1])
  cv   <- apply(mat, 1, function(r) sd(r) / mean(r))
  wide$mean_nABCD <- apply(mat, 1, mean)
  wide$CV     <- round(cv, 4)
  rownames(wide) <- NULL
  # Pretty column names
  names(wide) <- gsub("^true_nABCD\\.", "", names(wide))
  print(wide, row.names = FALSE)
}

# Summary: mean CV across 3 deltas per normalizer
cat("\n=== EM-invariance summary (mean CV across 3 delta values) ===\n")
cv_sum <- data.frame(normalizer = NORMS,
                     mean_CV_truth = NA_real_)
for (i in seq_along(NORMS)) {
  norm <- NORMS[i]
  sub <- true_g2[true_g2$normalizer == norm, ]
  cvs <- c()
  for (d in unique(sub$delta)) {
    vals <- sub$true_nABCD[sub$delta == d]
    cvs <- c(cvs, sd(vals) / mean(vals))
  }
  cv_sum$mean_CV_truth[i] <- mean(cvs)
}
cv_sum <- cv_sum[order(cv_sum$mean_CV_truth), ]
print(cv_sum, row.names = FALSE)
cat("\nLower CV = more EM-invariant = better for cross-EM comparison\n")

# =============================================================================
# Part 2: Sample-level EM-invariance — CV of mean_est across 3 EMs (n=200)
# =============================================================================
cat("\n\n--- Part 2: SAMPLE mean_est per (delta x EM x normalizer) at n=200 ---\n")

for (norm in NORMS) {
  cat(sprintf("\n=== %s ===\n", norm))
  sub <- g2[g2$normalizer == norm & g2$n == 200, c("EM", "delta", "mean_est")]
  wide <- reshape(sub, idvar = "delta", timevar = "EM", direction = "wide")
  wide <- wide[order(wide$delta), ]
  mat  <- as.matrix(wide[, -1])
  cv   <- apply(mat, 1, function(r) sd(r) / mean(r))
  wide$mean    <- apply(mat, 1, mean)
  wide$CV  <- round(cv, 4)
  rownames(wide) <- NULL
  names(wide) <- gsub("^mean_est\\.", "", names(wide))
  print(wide, row.names = FALSE)
}

cat("\n=== Sample-level EM-invariance summary (mean CV across 3 delta values, n=200) ===\n")
cv_sample <- data.frame(normalizer = NORMS, mean_CV_sample = NA_real_)
for (i in seq_along(NORMS)) {
  norm <- NORMS[i]
  sub <- g2[g2$normalizer == norm & g2$n == 200, ]
  cvs <- c()
  for (d in unique(sub$delta)) {
    vals <- sub$mean_est[sub$delta == d]
    cvs <- c(cvs, sd(vals) / mean(vals))
  }
  cv_sample$mean_CV_sample[i] <- mean(cvs)
}
cv_sample <- cv_sample[order(cv_sample$mean_CV_sample), ]
print(cv_sample, row.names = FALSE)

# =============================================================================
# Part 3: Decision table — combine truth-CV, sample-CV, coverage
# =============================================================================
cat("\n\n--- Part 3: Combined decision metrics ---\n")

# Coverage averaged across all 27 cells (per normalizer)
cov_sum <- aggregate(coverage_pct ~ normalizer, data = g2,
                      FUN = mean, na.rm = TRUE)

decision <- merge(cv_sum, cv_sample, by = "normalizer")
decision <- merge(decision, cov_sum, by = "normalizer")
decision <- decision[order(decision$mean_CV_truth), ]
rownames(decision) <- NULL
cat("\nNormalizer decision table:\n")
print(decision, row.names = FALSE)
cat("\nInterpretation:\n")
cat("- mean_CV_truth:  Population-level EM-invariance (lower = better)\n")
cat("- mean_CV_sample: Sample-level reproducibility (lower = better)\n")
cat("- coverage_pct:   95% CI calibration (closer to 0.95 = better)\n")

saveRDS(decision, "results/cross_em_decision.rds")
cat("\nSaved: results/cross_em_decision.rds\n")
