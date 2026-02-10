# =============================================================================
# nABCD Complete Pipeline - R Script
# Author: Donna Paulsen
# Date: 2026-02-07
# Purpose: One-script execution of all simulation and figure generation
# Usage: source("R/run_all.R")
# =============================================================================
setwd("C:/Users/hrd13/Documents/Gak/0 Study/800Claude/20260201_SUITS/projects/similarity-metric")

cat("========================================\n")
cat("nABCD Complete Pipeline\n")
cat("========================================\n\n")

# =============================================================================
# Configuration
# =============================================================================


# Mode: "quick" for testing, "full" for publication
MODE <- "full" # Change to "full" for final results

# Parameters
PARAMS <- list(
  quick = list(n_reps = 50, B = 200),
  full = list(n_reps = 500, B = 1000)
)

# Seed for reproducibility
SEED <- 42

cat("Mode:", toupper(MODE), "\n")
cat("Replications:", PARAMS[[MODE]]$n_reps, "\n")
cat("Bootstrap samples:", PARAMS[[MODE]]$B, "\n\n")

# =============================================================================
# Step 1: Run Simulation
# =============================================================================

cat("Step 1: Running Simulation\n")
cat("--------------------------\n")

# Source simulation code
SKIP_SIMULATION <- TRUE
source("R/simulation_manuscript_v2.R")

# Run simulation
start_time <- Sys.time()
results <- run_full_simulation(
  n_reps = PARAMS[[MODE]]$n_reps,
  B = PARAMS[[MODE]]$B,
  seed = SEED
)
end_time <- Sys.time()

cat(
  "\nSimulation completed in:",
  round(difftime(end_time, start_time, units = "mins"), 1), "minutes\n"
)

# Save results
save_results(results$summary_table)

cat("\n")

# =============================================================================
# Step 2: Validate Results
# =============================================================================

cat("Step 2: Validating Results\n")
cat("--------------------------\n")

validation <- validate_results(results$summary_table)

cat("\n")

# =============================================================================
# Step 3: Generate Figures
# =============================================================================

cat("Step 3: Generating Figures\n")
cat("--------------------------\n")

source("R/figures_paper.R")
generate_all_figures()

cat("\n")

# =============================================================================
# Step 4: Summary Report
# =============================================================================

cat("Step 4: Summary Report\n")
cat("----------------------\n")

cat("\n=== Final Results ===\n")
print(results$summary_table)

cat("\n=== Files Generated ===\n")
cat("Data: data/simulation_results.csv\n")
cat("Figures:\n")
fig_files <- list.files("figures", pattern = "\\.(png|pdf)$", full.names = TRUE)
for (f in fig_files) cat("  ", f, "\n")

cat("\n========================================\n")
cat("Pipeline Complete!\n")
cat("========================================\n")

# =============================================================================
# Quick Reference
# =============================================================================
#
# To run quick test:
#   MODE <- "quick"
#   source("R/run_all.R")
#
# To run full simulation:
#   MODE <- "full"
#   source("R/run_all.R")
#
# Or directly edit MODE at line 18 and run:
#   source("R/run_all.R")
#
# =============================================================================
