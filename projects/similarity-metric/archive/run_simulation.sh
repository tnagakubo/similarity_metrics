#!/bin/bash
# =============================================================================
# nABCD Simulation Runner
# Created by: Donna Paulsen
# Date: 2026-02-07
# Purpose: One-command execution of all simulation tasks
# =============================================================================

set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$PROJECT_DIR"

echo "========================================"
echo "nABCD Simulation Suite"
echo "Project: $PROJECT_DIR"
echo "========================================"
echo ""

# Parse arguments
QUICK_MODE=false
FULL_MODE=false
FIGURES_ONLY=false
VALIDATE_ONLY=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --quick)
      QUICK_MODE=true
      shift
      ;;
    --full)
      FULL_MODE=true
      shift
      ;;
    --figures)
      FIGURES_ONLY=true
      shift
      ;;
    --validate)
      VALIDATE_ONLY=true
      shift
      ;;
    --help)
      echo "Usage: ./run_simulation.sh [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  --quick      Run quick simulation (n_reps=50, B=200)"
      echo "  --full       Run full simulation (n_reps=500, B=1000)"
      echo "  --figures    Generate figures only"
      echo "  --validate   Run validation only"
      echo "  --help       Show this help"
      echo ""
      echo "Default: --quick"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

# Default to quick mode
if ! $QUICK_MODE && ! $FULL_MODE && ! $FIGURES_ONLY && ! $VALIDATE_ONLY; then
  QUICK_MODE=true
fi

# =============================================================================
# Step 1: Simulation
# =============================================================================

if ! $FIGURES_ONLY && ! $VALIDATE_ONLY; then
  echo "Step 1: Running Simulation"
  echo "-------------------------"

  if $QUICK_MODE; then
    echo "Mode: QUICK (n_reps=50, B=200)"
    Rscript -e "
SKIP_SIMULATION <- TRUE
source('R/simulation_manuscript.R')
results <- run_full_simulation(n_reps = 50, B = 200, seed = 42)
save_results(results\$summary_table)
validate_results(results\$summary_table)
"
  elif $FULL_MODE; then
    echo "Mode: FULL (n_reps=500, B=1000)"
    echo "Estimated time: 15-20 minutes"
    Rscript -e "
SKIP_SIMULATION <- TRUE
source('R/simulation_manuscript.R')
results <- run_full_simulation(n_reps = 500, B = 1000, seed = 42)
save_results(results\$summary_table)
validate_results(results\$summary_table)
"
  fi

  echo ""
fi

# =============================================================================
# Step 2: Figures
# =============================================================================

if ! $VALIDATE_ONLY; then
  echo "Step 2: Generating Figures"
  echo "--------------------------"

  Rscript -e "
source('R/figures_paper.R')
generate_all_figures()
"

  echo ""
  echo "Figures saved to: figures/"
  ls -la figures/*.png 2>/dev/null || echo "No PNG files found"
  echo ""
fi

# =============================================================================
# Step 3: Validation
# =============================================================================

echo "Step 3: Validation Check"
echo "------------------------"

if [ -f "data/simulation_results.csv" ]; then
  Rscript -e "
SKIP_SIMULATION <- TRUE
source('R/simulation_manuscript.R')
results <- read.csv('data/simulation_results.csv')
validate_results(results)
"
else
  echo "WARNING: simulation_results.csv not found"
  echo "Run with --quick or --full first"
fi

echo ""
echo "========================================"
echo "Simulation Suite Complete"
echo "========================================"
