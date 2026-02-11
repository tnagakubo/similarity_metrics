# =============================================================================
# nABCD Complete Pipeline - R Script
# Author: Donna Paulsen
# Date: 2026-02-11
# Purpose: One-script execution of all simulation and figure generation
# Usage: Rscript R/run_all.R  (from project root)
# =============================================================================

# Use script directory to set project root
SCRIPT_DIR <- if (interactive()) {
  "."
} else {
  tryCatch(
    dirname(dirname(normalizePath(commandArgs(trailingOnly = FALSE)[
      grep("--file=", commandArgs(trailingOnly = FALSE))]))),
    error = function(e) "."
  )
}
setwd(SCRIPT_DIR)
cat("Working directory:", getwd(), "\n")

cat("========================================\n")
cat("nABCD Complete Pipeline\n")
cat("========================================\n\n")

# =============================================================================
# Configuration
# =============================================================================

# Mode: "quick" for testing, "full" for publication
MODE <- "full" # Change to "quick" for testing

# Parameters
PARAMS <- list(
  quick = list(n_reps = 50, B = 200),
  full  = list(n_reps = 10000, B = 2000)
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

# Source simulation code (skip auto-execution)
SKIP_SIMULATION <- TRUE
source("R/simulation_manuscript_v2.R")

# Run simulation
start_time <- Sys.time()
results <- run_full_simulation_v2(
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
save_results_v2(results$summary_table)

cat("\n")

# =============================================================================
# Step 2: Validate Results
# =============================================================================

cat("Step 2: Validating Results\n")
cat("--------------------------\n")

validate_results <- function(summary_table) {
  n_scenarios <- length(unique(summary_table$Scenario))
  n_sizes <- length(unique(summary_table$SampleSize))
  cat("  Scenarios:", n_scenarios, "\n")
  cat("  Sample sizes:", n_sizes, "\n")
  cat("  Total rows:", nrow(summary_table), "\n")

  # Check bias at n >= 100
  bias_check <- summary_table[summary_table$SampleSize >= 100 &
                              summary_table$Scenario != "S01", ]
  max_abs_bias <- max(abs(bias_check$Bias), na.rm = TRUE)
  cat("  Max |Bias| at n>=100 (non-null):", round(max_abs_bias, 4), "\n")

  invisible(summary_table)
}

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
cat("Data: data/simulation_results_v2.csv\n")
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
#   MODE <- "quick"; source("R/run_all.R")
#
# To run full simulation (10,000 reps):
#   MODE <- "full"; source("R/run_all.R")
#
# =============================================================================
