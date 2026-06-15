# =============================================================================
# A/B Comparison: Rcpp vs R for S1 n=50, n_reps=10000, B=1000
# Author: Mike Ross (Methodologist)
# Date: 2026-05-10
#
# Purpose: Verify that Rcpp-based pipeline produces bias / coverage estimates
# statistically indistinguishable from the original R-vectorized pipeline,
# at the n_reps=10000 aggregate level. Reuses the existing R-version cell
# (S1 n=50) from results/normalizer_comparison_grid1_partial.rds and runs
# the Rcpp version with matching seed.
#
# Acceptance: |bias diff| < 0.01 AND |coverage diff| < 0.005 across 5 norms.
# =============================================================================

SKIP_SIMULATION <- TRUE
suppressPackageStartupMessages({
  library(parallel)
  library(Rcpp)
})

ROOT <- "projects/similarity-metric/R"
options(nabcd.use_rcpp = TRUE)

# Compile Rcpp on master
Rcpp::sourceCpp(file.path(ROOT, "nABCD_5norm_rcpp.cpp"))

# Source helpers + pipeline (SKIP_SIMULATION blocks main())
source(file.path(ROOT, "simulation_manuscript_v2.R"), chdir = TRUE)
source(file.path(ROOT, "nabcd_normalizers.R"),       chdir = TRUE)
source(file.path(ROOT, "scenarios_extended.R"),      chdir = TRUE)
source(file.path(ROOT, "true_normalizers.R"),        chdir = TRUE)
source(file.path(ROOT, "run_normalizer_comparison.R"))

# Re-affirm option (in case sourcing reset it)
options(nabcd.use_rcpp = TRUE)
stopifnot(exists("nABCD_bootstrap_5norm_cpp"))

cat("==========================================================\n")
cat(" A/B Comparison: Rcpp vs R, S1 n=50, n_reps=10000, B=1000\n")
cat("==========================================================\n\n")

# --- Read existing R-version cell ---
partial_file <- "results/normalizer_comparison_grid1_partial.rds"
partial <- readRDS(partial_file)
r_cell_summary <- NULL
r_elapsed <- NA_real_
for (c in partial$cells) {
  if (identical(c$scenario, "S1") && identical(c$n, 50)) {
    r_cell_summary <- c$summary
    r_elapsed <- c$elapsed_s
    cat(sprintf("[ab] R version (existing): elapsed = %.1fs\n", c$elapsed_s))
    break
  }
}
if (is.null(r_cell_summary)) stop("S1 n=50 not found in partial RDS")

# --- True values for S1 (load existing if available, must compute scenarios_v2 either way) ---
cat("[ab] computing scenario truth meta (compute_true_values_v2) ...\n")
scenarios_v2 <- compute_true_values_v2(scenarios_v2, n_mc = 1e6, seed = 12345)

true_file <- "results/true_nabcd_per_normalizer.rds"
if (file.exists(true_file)) {
  cat(sprintf("[ab] loading existing true values from %s\n", true_file))
  true_df <- readRDS(true_file)
} else {
  cat("[ab] computing true values for all scenarios ...\n")
  true_df <- compute_all_true_normalizers(
    scenarios_v2, n_mc = 1e6, seed_base = 12345, verbose = FALSE
  )
}
truth_named <- setNames(
  true_df$true_nABCD[true_df$scenario == "S1"][match(NORMALIZERS,
    true_df$normalizer[true_df$scenario == "S1"])],
  NORMALIZERS
)
cat("[ab] truth (S1):\n"); print(truth_named)

# --- Run Rcpp version with matching seed (run_grid1 uses seed_base + 1000*k,
#     k=1 for S1 n=50, seed_base=42 → seed = 1042) ---
cat("[ab] launching Rcpp version (5 cores, seed=1042) ...\n")
cl <- setup_cluster(5L)
on.exit(if (!is.null(cl)) try(parallel::stopCluster(cl), silent = TRUE), add = TRUE)

t0 <- Sys.time()
cell <- run_cell(scenarios_v2[["S1"]], n_per_group = 50L,
                 n_reps = 10000L, B = 1000L,
                 cluster = cl, seed = 42L + 1000L * 1L)
cpp_elapsed <- as.numeric(difftime(Sys.time(), t0, units = "secs"))
cat(sprintf("[ab] Rcpp elapsed: %.1fs (R: %.1fs, speedup: %.2fx)\n",
            cpp_elapsed, r_elapsed, r_elapsed / cpp_elapsed))

cpp_summary <- summarize_cell(cell, truth_named)

# --- Detailed comparison table ---
cat("\n--- Per-normalizer comparison ---\n")
keys <- c("mean_est", "bias", "rmse", "sd_est", "mean_ci_width", "coverage_pct")
cat(sprintf("%-6s %-14s %12s %12s %14s\n",
            "Norm", "Metric", "R", "Cpp", "abs(diff)"))
cat(strrep("-", 64), "\n", sep = "")
for (norm in NORMALIZERS) {
  for (k in keys) {
    rv <- r_cell_summary[r_cell_summary$normalizer == norm, k]
    cv <- cpp_summary[cpp_summary$normalizer == norm, k]
    cat(sprintf("%-6s %-14s %12.6f %12.6f %14.4e\n",
                norm, k, rv, cv, abs(rv - cv)))
  }
}

# --- Acceptance criteria ---
cat("\n--- Acceptance: |bias diff| < 0.01, |coverage diff| < 0.005 ---\n")
crit <- list()
ok_overall <- TRUE
for (norm in NORMALIZERS) {
  rb <- r_cell_summary[r_cell_summary$normalizer == norm, "bias"]
  cb <- cpp_summary[cpp_summary$normalizer == norm, "bias"]
  rc <- r_cell_summary[r_cell_summary$normalizer == norm, "coverage_pct"]
  cc <- cpp_summary[cpp_summary$normalizer == norm, "coverage_pct"]
  bias_diff <- abs(rb - cb)
  cov_diff  <- abs(rc - cc)
  ok <- (bias_diff < 0.01) && (cov_diff < 0.005)
  ok_overall <- ok_overall && ok
  crit[[norm]] <- list(bias_diff = bias_diff, coverage_diff = cov_diff, ok = ok)
  cat(sprintf("%-10s |bias diff|=%.4f  |cov diff|=%.4f  %s\n",
              norm, bias_diff, cov_diff,
              if (ok) "[OK]" else "[FAIL]"))
}
cat(sprintf("\nOverall: %s\n",
            if (ok_overall) "[PASS — Rcpp can mix with R cells]"
            else "[FAIL — investigate before mixing]"))

# --- Save ---
out <- list(
  scenario = "S1", n = 50, n_reps = 10000L, B = 1000L, seed = 1042L,
  r_summary = r_cell_summary, r_elapsed_s = r_elapsed,
  cpp_summary = cpp_summary, cpp_elapsed_s = cpp_elapsed,
  speedup = r_elapsed / cpp_elapsed,
  criteria = crit, ok = ok_overall,
  timestamp = Sys.time()
)
saveRDS(out, "results/rcpp_ab_S1_n50.rds")
cat("\nSaved: results/rcpp_ab_S1_n50.rds\n")
