# Quick verification: compute true nABCD values via Monte Carlo
# and run minimal simulation to confirm S4 coverage fix
# Usage: Rscript verify_true_values.R

cat("=== nABCD True Value Verification ===\n\n")

# Source the main simulation (but skip full run)
SKIP_SIMULATION <- TRUE
source("R/simulation_manuscript_v2.R")

# Compute true values
set.seed(12345)
cat("--- Monte Carlo true nABCD (n = 10^6) ---\n")
scenarios <- compute_true_values(scenarios)

cat("\n--- Summary ---\n")
for (id in names(scenarios)) {
  cat(sprintf("  %s: true_nABCD = %.4f  (%s)\n",
              id, scenarios[[id]]$true_nABCD, scenarios[[id]]$name))
}

# Compare with old hardcoded values
old_vals <- c(S1=0, S2=0.074, S3=0.186, S4=0.372, S5=0.148, S6=0.067, S7=NA, S8=NA)
cat("\n--- Comparison with old hardcoded values ---\n")
cat(sprintf("  %-4s  %-10s  %-10s  %-10s\n", "ID", "Old", "New(MC)", "Diff"))
for (id in names(scenarios)) {
  new_val <- scenarios[[id]]$true_nABCD
  old_val <- old_vals[id]
  diff_val <- if (!is.na(old_val)) new_val - old_val else NA
  cat(sprintf("  %-4s  %-10s  %-10.4f  %-10s\n",
              id,
              ifelse(is.na(old_val), "NA(MC)", sprintf("%.4f", old_val)),
              new_val,
              ifelse(is.na(diff_val), "-", sprintf("%+.4f", diff_val))))
}

# Quick simulation for S4 only (50 reps) to verify coverage improvement
cat("\n\n=== Quick S4 Verification (50 reps, B=2000) ===\n")

n_cores <- max(1, parallelly::availableCores() - 1)
plan(multisession, workers = n_cores)
cat("Workers:", nbrOfWorkers(), "\n")

for (n in c(50, 100, 200)) {
  cat(sprintf("\n  S4, n=%d: ", n))
  res <- run_scenario_v2(scenarios[["S4"]], n_per_group = n,
                          n_reps = 50, B = 2000)
  s <- res$summary
  cat(sprintf("Bias=%+.4f  RMSE=%.4f  Cov_Pct=%.3f\n",
              s$bias, s$rmse, s$cov_pct))
}

plan(sequential)
cat("\n=== DONE ===\n")
