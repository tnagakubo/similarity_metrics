# Full simulation re-run with corrected true values
# All S1-S6 now use Monte Carlo (mixture IQR), not hardcoded (component IQR)
# Usage: Rscript run_full_sim.R

SKIP_SIMULATION <- TRUE
source("R/simulation_manuscript_v2.R")

cat("\n========================================\n")
cat("nABCD Full Simulation (Corrected True Values)\n")
cat("========================================\n\n")

N_REPS <- 10000
B_BOOT <- 2000
SEED   <- 42

results <- run_full_simulation_v2(n_reps = N_REPS, B = B_BOOT, seed = SEED)
print(results$summary_table)

# Save to new file (preserve old results for comparison)
save_results_v2(results$summary_table, "data/simulation_results_v2_corrected.csv")

# Also overwrite the main file
save_results_v2(results$summary_table, "data/simulation_results_v2.csv")

cat("\n=== FULL SIMULATION COMPLETE ===\n")
cat("Timestamp:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n")
