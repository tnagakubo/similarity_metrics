# =============================================================================
# Re-inspection addressing Tak's two critiques (2026-05-10):
#   (1) CI width / RMSE direct comparison across normalizers is invalid because
#       true_nABCD scale differs per normalizer.
#   (2) Cross-EM's real question is EM-invariance — does the same delta_sigma
#       give similar nABCD across (age, sbp, creatinine)?
# =============================================================================
g1 <- readRDS("results/normalizer_comparison_grid1.rds")
g2 <- readRDS("results/normalizer_comparison_grid2.rds")
true_g1 <- readRDS("results/true_nabcd_per_normalizer.rds")
true_g2 <- readRDS("results/true_nabcd_cross_em.rds")

NORMS <- c("IQR", "Q95Q5", "SD", "MAD", "Range")

# =============================================================================
# Part 1: Scale-invariant comparison (relative metrics)
# =============================================================================
# rel_bias = bias / true_nABCD
# rel_rmse = rmse / true_nABCD
# rel_ci_width = mean_ci_width / true_nABCD
# Exclude S1 (true_nABCD ~ 0 ⇒ rel metrics undefined)

g1$rel_bias     <- g1$bias / g1$true_nABCD
g1$rel_rmse     <- g1$rmse / g1$true_nABCD
g1$rel_ci_width <- g1$mean_ci_width / g1$true_nABCD

g1_nonzero <- g1[g1$scenario != "S1", ]

cat("========================================================\n")
cat(" PART 1: Scale-invariant metrics (Grid 1, S2-S9, all n)\n")
cat("========================================================\n")
cat(" rel_X = X / true_nABCD\n")
cat(" Lower = better for rel_bias / rel_rmse / rel_ci_width\n\n")

for (metric in c("rel_bias", "rel_rmse", "rel_ci_width")) {
  agg <- aggregate(g1_nonzero[[metric]], by = list(normalizer = g1_nonzero$normalizer),
                    FUN = mean, na.rm = TRUE)
  names(agg)[2] <- metric
  ord <- order(agg[[metric]])
  cat(sprintf("\n%s (best -> worst):\n", metric))
  for (i in ord) {
    cat(sprintf("  %-6s %.4f\n", agg$normalizer[i], agg[[metric]][i]))
  }
}

# Coverage already scale-invariant
cat("\ncoverage_pct (Grid 1, S2-S9, closer to 0.95 = better):\n")
agg_cov <- aggregate(g1_nonzero$coverage_pct,
                      by = list(normalizer = g1_nonzero$normalizer),
                      FUN = mean, na.rm = TRUE)
names(agg_cov)[2] <- "coverage_pct"
ord_cov <- order(abs(agg_cov$coverage_pct - 0.95))
for (i in ord_cov) {
  cat(sprintf("  %-6s %.4f\n", agg_cov$normalizer[i], agg_cov$coverage_pct[i]))
}

# Detailed table by normalizer × n (S2-S9 averaged)
cat("\n\n=== Relative metrics by normalizer × sample size (S2-S9 averaged) ===\n")
for (norm in NORMS) {
  cat(sprintf("\n--- %s ---\n", norm))
  sub <- g1_nonzero[g1_nonzero$normalizer == norm, ]
  by_n <- aggregate(cbind(rel_bias, rel_rmse, rel_ci_width, coverage_pct) ~ n,
                     data = sub, FUN = mean, na.rm = TRUE)
  print(by_n, row.names = FALSE)
}

# =============================================================================
# Part 2: EM-invariance check (Grid 2)
# =============================================================================
# For each delta_sigma ∈ {0.25, 0.5, 1.0}, compare true_nABCD across (age, sbp, creatinine).
# A normalizer is EM-invariant if CV (sd/mean) of the 3 true_nABCD values is small.
#
# Mapping: scenario name → (EM, delta_sigma)
#   age_d0p25 → (age, 0.25), age_d0p5 → (age, 0.5), age_d1 → (age, 1.0)
#   sbp_*: same
#   creatinine_*: same

cat("\n\n========================================================\n")
cat(" PART 2: EM-invariance of true_nABCD (Grid 2)\n")
cat("========================================================\n")
cat(" Question: For the same delta_sigma, are true_nABCD values\n")
cat(" similar across (age, sbp, creatinine) for each normalizer?\n")
cat(" Lower CV = more EM-invariant.\n\n")

# Parse scenario name
parse_scenario <- function(s) {
  m <- regmatches(s, regexec("^([a-z]+)_d(.+)$", s))[[1]]
  if (length(m) != 3) return(c(EM = NA, delta_sigma = NA))
  ds <- gsub("p", ".", m[3])
  c(EM = m[2], delta_sigma = ds)
}

true_g2$EM          <- sapply(true_g2$scenario, function(s) parse_scenario(s)["EM"])
true_g2$delta_sigma <- sapply(true_g2$scenario, function(s) parse_scenario(s)["delta_sigma"])

# Print true_nABCD organized as (delta_sigma × EM) per normalizer
for (norm in NORMS) {
  cat(sprintf("\n--- %s ---\n", norm))
  sub <- true_g2[true_g2$normalizer == norm, c("EM", "delta_sigma", "true_nABCD")]
  wide <- reshape(sub, idvar = "delta_sigma", timevar = "EM", direction = "wide")
  # Compute CV
  mat <- as.matrix(wide[, -1])
  cv  <- apply(mat, 1, function(r) sd(r) / mean(r))
  wide$CV <- round(cv, 4)
  wide$delta_sigma <- as.numeric(wide$delta_sigma)
  wide <- wide[order(wide$delta_sigma), ]
  rownames(wide) <- NULL
  print(wide, row.names = FALSE)
}

# Summary: which normalizer is most EM-invariant
cat("\n=== EM-invariance summary (mean CV across 3 delta_sigma) ===\n")
cv_summary <- data.frame(normalizer = character(), mean_CV = numeric())
for (norm in NORMS) {
  sub <- true_g2[true_g2$normalizer == norm, ]
  cvs <- c()
  for (ds in unique(sub$delta_sigma)) {
    vals <- sub$true_nABCD[sub$delta_sigma == ds]
    cvs <- c(cvs, sd(vals) / mean(vals))
  }
  cv_summary <- rbind(cv_summary,
                       data.frame(normalizer = norm, mean_CV = mean(cvs)))
}
cv_summary <- cv_summary[order(cv_summary$mean_CV), ]
cat("Lower mean_CV = more EM-invariant (more valid for cross-EM comparison)\n")
print(cv_summary, row.names = FALSE)

# Estimate-level invariance: do estimated nABCDs (averaged across reps) cluster
# similarly across EMs at same delta_sigma?
cat("\n\n=== Estimate-level EM invariance (Grid 2 mean_est by delta_sigma × EM) ===\n")
g2$EM          <- sapply(g2$scenario, function(s) parse_scenario(s)["EM"])
g2$delta_sigma <- sapply(g2$scenario, function(s) parse_scenario(s)["delta_sigma"])

for (norm in NORMS) {
  cat(sprintf("\n--- %s ---\n", norm))
  sub <- g2[g2$normalizer == norm, ]
  # Average mean_est over n
  agg <- aggregate(mean_est ~ EM + delta_sigma, data = sub, FUN = mean, na.rm = TRUE)
  wide <- reshape(agg, idvar = "delta_sigma", timevar = "EM", direction = "wide")
  mat  <- as.matrix(wide[, -1])
  cv   <- apply(mat, 1, function(r) sd(r) / mean(r))
  wide$CV <- round(cv, 4)
  wide$delta_sigma <- as.numeric(wide$delta_sigma)
  wide <- wide[order(wide$delta_sigma), ]
  rownames(wide) <- NULL
  print(wide, row.names = FALSE)
}
