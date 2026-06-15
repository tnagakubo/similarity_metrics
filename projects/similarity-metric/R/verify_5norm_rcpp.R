# =============================================================================
# Verification: Rcpp 5-normalizer bootstrap vs R version
# - Point estimates: should match bit-exact (no RNG involved)
# - CI: bootstrap RNG paths differ between R/C++; should match qualitatively
# - Speed benchmark: cpp vs R per-rep timing
# =============================================================================

SKIP_SIMULATION <- TRUE
suppressPackageStartupMessages({
  library(Rcpp)
})

ROOT <- "projects/similarity-metric/R"
source(file.path(ROOT, "simulation_manuscript_v2.R"), chdir = TRUE)
source(file.path(ROOT, "nabcd_normalizers.R"),       chdir = TRUE)
source(file.path(ROOT, "scenarios_extended.R"),      chdir = TRUE)
source(file.path(ROOT, "run_normalizer_comparison.R"))  # source to load single_rep_all_normalizers

# Compile Rcpp
sourceCpp(file.path(ROOT, "nABCD_5norm_rcpp.cpp"))

cat("==========================================================\n")
cat(" Rcpp 5-normalizer Bootstrap Verification\n")
cat("==========================================================\n\n")

# =============================================================================
# Test 1: Point estimates match bit-exact
# =============================================================================

cat("--- Test 1: Point estimate bit-exactness ---\n")
set.seed(42)
test_cases <- list(
  list(n1 = 50,  n2 = 50,  loc = 0.0),
  list(n1 = 100, n2 = 100, loc = 0.5),
  list(n1 = 200, n2 = 200, loc = 1.0),
  list(n1 = 75,  n2 = 125, loc = 0.3)  # unequal n
)
all_ok <- TRUE
for (i in seq_along(test_cases)) {
  tc <- test_cases[[i]]
  set.seed(100 + i)
  x <- rnorm(tc$n1, 0, 1)
  y <- rnorm(tc$n2, tc$loc, 1)

  # R version: just point estimates
  w1_obs <- wasserstein1(x, y)
  pooled <- c(x, y)
  norm_R <- c(
    IQR   = IQR(pooled),
    Range = diff(range(pooled)),
    Q95Q5 = unname(diff(quantile(pooled, c(0.05, 0.95)))),
    SD    = sd(pooled),
    MAD   = median(abs(pooled - median(pooled)))
  )
  est_R <- w1_obs / norm_R

  # Rcpp version
  res_cpp <- nABCD_bootstrap_5norm_cpp(x, y, B = 10, conf = 0.95)
  est_cpp <- res_cpp$estimate

  diff <- abs(est_R - est_cpp)
  max_diff <- max(diff, na.rm = TRUE)
  ok <- all(diff < 1e-10, na.rm = TRUE)
  all_ok <- all_ok && ok
  cat(sprintf("  Case %d (n1=%d, n2=%d, loc=%.1f): max abs diff = %.2e %s\n",
              i, tc$n1, tc$n2, tc$loc, max_diff,
              if (ok) "[OK]" else "[FAIL]"))
  if (!ok) {
    cat("    R version:   ", paste(sprintf("%.6f", est_R), collapse = " "), "\n")
    cat("    Cpp version: ", paste(sprintf("%.6f", est_cpp), collapse = " "), "\n")
  }
}
cat(sprintf("\nPoint estimate test: %s\n\n", if (all_ok) "[PASS]" else "[FAIL]"))

# =============================================================================
# Test 2: CI qualitative match (different RNG paths, but should be close)
# =============================================================================

cat("--- Test 2: Bootstrap CI qualitative match (B=2000, n=100) ---\n")
set.seed(2026)
x <- rnorm(100, 0, 1)
y <- rnorm(100, 0.5, 1)

# R version (uses sample.int RNG)
set.seed(123)
res_R <- single_rep_all_normalizers(x, y, B = 2000, conf = 0.95)

# Rcpp version (uses R::unif_rand which respects R's RNG state)
set.seed(123)
res_C <- nABCD_bootstrap_5norm_cpp(x, y, B = 2000, conf = 0.95)

cat("Normalizer | est_R    | est_C    | ci_lo_R  | ci_lo_C  | ci_hi_R  | ci_hi_C\n")
cat("-----------|----------|----------|----------|----------|----------|----------\n")
for (norm in c("IQR", "Range", "Q95Q5", "SD", "MAD")) {
  cat(sprintf("%-10s | %.6f | %.6f | %.6f | %.6f | %.6f | %.6f\n",
              norm, res_R$estimate[norm], res_C$estimate[norm],
              res_R$ci_lower[norm], res_C$ci_lower[norm],
              res_R$ci_upper[norm], res_C$ci_upper[norm]))
}
ci_diffs <- abs(c(res_R$ci_lower - res_C$ci_lower,
                  res_R$ci_upper - res_C$ci_upper))
cat(sprintf("\nMax CI bound diff: %.2e (different RNG paths; expect O(0.01))\n\n",
            max(ci_diffs, na.rm = TRUE)))

# =============================================================================
# Test 3: Speed benchmark
# =============================================================================

cat("--- Test 3: Speed benchmark ---\n")
for (n in c(50, 100, 200)) {
  set.seed(1)
  x <- rnorm(n, 0, 1); y <- rnorm(n, 0.5, 1)

  # R version
  t0 <- Sys.time()
  for (i in 1:10) {
    set.seed(i)
    invisible(single_rep_all_normalizers(x, y, B = 1000, conf = 0.95))
  }
  t_R <- as.numeric(difftime(Sys.time(), t0, units = "secs")) / 10

  # Rcpp version
  t0 <- Sys.time()
  for (i in 1:10) {
    set.seed(i)
    invisible(nABCD_bootstrap_5norm_cpp(x, y, B = 1000, conf = 0.95))
  }
  t_C <- as.numeric(difftime(Sys.time(), t0, units = "secs")) / 10

  cat(sprintf("  n=%3d  R: %.4f s/rep  Cpp: %.4f s/rep  Speedup: %.2fx\n",
              n, t_R, t_C, t_R / t_C))
}

cat("\nVerification done.\n")
