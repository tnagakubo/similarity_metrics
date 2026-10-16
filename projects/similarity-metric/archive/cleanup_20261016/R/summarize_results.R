# Quick summary of normalizer comparison results
g1 <- readRDS("results/normalizer_comparison_grid1.rds")
g2 <- readRDS("results/normalizer_comparison_grid2.rds")

cat("=== Grid 1 structure ===\n")
cat("rows:", nrow(g1), "  cells:", nrow(g1) / 5, "\n")
cat("columns:", paste(names(g1), collapse = ", "), "\n")
cat("scenarios:", paste(unique(g1$scenario), collapse = ", "), "\n")
cat("normalizers:", paste(unique(g1$normalizer), collapse = ", "), "\n")
cat("sample sizes:", paste(unique(g1$n), collapse = ", "), "\n\n")

cat("=== Grid 2 structure ===\n")
cat("rows:", nrow(g2), "  cells:", nrow(g2) / 5, "\n")
cat("scenarios:", paste(unique(g2$scenario), collapse = ", "), "\n\n")

# --- Headline: bias / coverage by normalizer (averaged across scenarios x n) ---
cat("=== Grid 1: per-normalizer mean (averaged across S1-S9 x 3 n) ===\n")
agg_g1 <- aggregate(
  cbind(bias, rmse, mean_ci_width, coverage_pct) ~ normalizer,
  data = g1, FUN = mean, na.rm = TRUE
)
print(agg_g1, row.names = FALSE)

cat("\n=== Grid 2: per-normalizer mean (averaged across 9 EM scenarios x 3 n) ===\n")
agg_g2 <- aggregate(
  cbind(bias, rmse, mean_ci_width, coverage_pct) ~ normalizer,
  data = g2, FUN = mean, na.rm = TRUE
)
print(agg_g2, row.names = FALSE)

# --- Coverage by n: how does CI behavior scale ---
cat("\n=== Grid 1: coverage_pct by normalizer x n ===\n")
cov_n <- aggregate(coverage_pct ~ normalizer + n, data = g1, FUN = mean, na.rm = TRUE)
cov_w <- reshape(cov_n, idvar = "normalizer", timevar = "n", direction = "wide")
print(cov_w, row.names = FALSE)

cat("\n=== Grid 1: bias by normalizer x n ===\n")
bias_n <- aggregate(bias ~ normalizer + n, data = g1, FUN = mean, na.rm = TRUE)
bias_w <- reshape(bias_n, idvar = "normalizer", timevar = "n", direction = "wide")
print(bias_w, row.names = FALSE)
