# Reduced simulation (500 reps) — ~2.5 hours with Rcpp + 7 workers
# For quick validation. Full 10,000 can be run overnight with run_full_sim.R
# Usage: Rscript run_sim_500.R

SKIP_SIMULATION <- TRUE
source("R/simulation_manuscript_v2.R")

cat("\n========================================\n")
cat("nABCD Simulation (500 reps, corrected true values)\n")
cat("========================================\n\n")

N_REPS <- 500
B_BOOT <- 2000
SEED   <- 42

results <- run_full_simulation_v2(n_reps = N_REPS, B = B_BOOT, seed = SEED)
print(results$summary_table)

save_results_v2(results$summary_table, "data/simulation_results_v2_500reps.csv")

cat("\n=== 500-REP SIMULATION COMPLETE ===\n")
cat("Timestamp:", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n")
