# =============================================================================
# nABCD Simulation Study - Manuscript Version
# Author: Mike Ross
# Date: 2026-02-07
# Purpose: Generate validated simulation results matching LaTeX manuscript
# =============================================================================

library(stats)

# =============================================================================
# Core Functions
# =============================================================================

#' Compute Wasserstein-1 distance between two samples
#' @param x numeric vector (sample 1)
#' @param y numeric vector (sample 2)
#' @return W1 distance
wasserstein1 <- function(x, y) {
  # Combine and sort all unique values
  all_vals <- sort(unique(c(x, y)))
  n_vals <- length(all_vals)

  if (n_vals < 2) return(0)

  # Compute ECDFs
  Fx <- ecdf(x)
  Fy <- ecdf(y)

  # Numerical integration using step function
  w1 <- 0
  for (i in 1:(n_vals - 1)) {
    dx <- all_vals[i + 1] - all_vals[i]
    mid <- (all_vals[i] + all_vals[i + 1]) / 2
    w1 <- w1 + abs(Fx(mid) - Fy(mid)) * dx
  }

  return(w1)
}

#' Compute nABCD
#' @param x sample 1
#' @param y sample 2
#' @return nABCD value
compute_nABCD <- function(x, y) {
  w1 <- wasserstein1(x, y)
  iqr_pooled <- IQR(c(x, y))
  if (iqr_pooled == 0) return(NA)
  w1 / (2 * iqr_pooled)
}

#' Bootstrap CI for nABCD
#' @param x sample 1
#' @param y sample 2
#' @param B number of bootstrap replicates
#' @param conf confidence level
#' @return list with estimate, CI bounds
nABCD_bootstrap <- function(x, y, B = 1000, conf = 0.95) {
  n1 <- length(x)
  n2 <- length(y)

  # Point estimate
  est <- compute_nABCD(x, y)

  # Bootstrap
  boot_vals <- numeric(B)
  for (b in 1:B) {
    x_star <- sample(x, n1, replace = TRUE)
    y_star <- sample(y, n2, replace = TRUE)
    boot_vals[b] <- compute_nABCD(x_star, y_star)
  }

  # Remove NAs
  boot_vals <- boot_vals[!is.na(boot_vals)]

  # Percentile CI
  alpha <- 1 - conf
  ci <- quantile(boot_vals, c(alpha/2, 1 - alpha/2), na.rm = TRUE)
  ci[1] <- max(0, ci[1])  # nABCD >= 0

  list(
    estimate = est,
    ci_lower = unname(ci[1]),
    ci_upper = unname(ci[2]),
    se = sd(boot_vals, na.rm = TRUE)
  )
}

# =============================================================================
# Theoretical nABCD Calculation (for Normal distributions)
# =============================================================================

#' Compute true nABCD for two Normal distributions
#' W1(N(mu1,s1), N(mu2,s2)) has closed form when s1=s2
#' General case requires numerical integration
compute_true_nABCD_normal <- function(mu1, sigma1, mu2, sigma2, n_points = 10000) {
  # Use Monte Carlo integration for general case
  set.seed(12345)
  n_mc <- 100000

  # Generate large samples
  x1 <- rnorm(n_mc, mu1, sigma1)
  x2 <- rnorm(n_mc, mu2, sigma2)

  # Compute W1 via numerical integration over grid
  x_range <- range(c(x1, x2))
  x_grid <- seq(x_range[1] - 3*max(sigma1, sigma2),
                x_range[2] + 3*max(sigma1, sigma2),
                length.out = n_points)

  F1 <- pnorm(x_grid, mu1, sigma1)
  F2 <- pnorm(x_grid, mu2, sigma2)

  dx <- diff(x_grid)[1]
  w1 <- sum(abs(F1 - F2)) * dx

  # Pooled IQR (theoretical)
  pooled <- c(x1, x2)
  iqr_pooled <- IQR(pooled)

  w1 / (2 * iqr_pooled)
}

# =============================================================================
# Scenario Definitions (Matching Manuscript Table 3)
# =============================================================================

scenarios <- list(
  S01 = list(
    name = "Null",
    dist1 = function(n) rnorm(n, mean = 50, sd = 10),
    dist2 = function(n) rnorm(n, mean = 50, sd = 10),
    true_nABCD = 0.000,
    description = "N(50,10²) vs N(50,10²)"
  ),
  S03 = list(
    name = "Location 0.2σ",
    dist1 = function(n) rnorm(n, mean = 50, sd = 10),
    dist2 = function(n) rnorm(n, mean = 52, sd = 10),
    true_nABCD = 0.074,
    description = "N(50,10²) vs N(52,10²)"
  ),
  S04 = list(
    name = "Location 0.5σ",
    dist1 = function(n) rnorm(n, mean = 50, sd = 10),
    dist2 = function(n) rnorm(n, mean = 55, sd = 10),
    true_nABCD = 0.186,
    description = "N(50,10²) vs N(55,10²)"
  ),
  S05 = list(
    name = "Location 1.0σ",
    dist1 = function(n) rnorm(n, mean = 50, sd = 10),
    dist2 = function(n) rnorm(n, mean = 60, sd = 10),
    true_nABCD = 0.372,
    description = "N(50,10²) vs N(60,10²)"
  ),
  S06 = list(
    name = "Scale 1.5×",
    dist1 = function(n) rnorm(n, mean = 50, sd = 10),
    dist2 = function(n) rnorm(n, mean = 50, sd = 15),
    true_nABCD = 0.148,
    description = "N(50,10²) vs N(50,15²)"
  ),
  S08 = list(
    name = "Shape",
    dist1 = function(n) rnorm(n, mean = 50, sd = 10),
    dist2 = function(n) {
      # Gamma with same mean=50 and approximately same variance
      # shape = (mean/sd)^2, rate = mean/var
      # For mean=50, sd~10: shape=25, rate=0.5
      rgamma(n, shape = 25, rate = 0.5)
    },
    true_nABCD = 0.067,
    description = "N(50,10²) vs Gamma(shape=25,rate=0.5)"
  )
)

# =============================================================================
# Run Simulation
# =============================================================================

#' Run simulation for one scenario
run_scenario <- function(scenario, n_per_group, n_reps = 500, B = 1000,
                         threshold = 0.05, seed = 42) {
  set.seed(seed)

  results <- data.frame(
    rep = 1:n_reps,
    estimate = numeric(n_reps),
    ci_lower = numeric(n_reps),
    ci_upper = numeric(n_reps),
    se = numeric(n_reps)
  )

  for (i in 1:n_reps) {
    # Generate samples
    x <- scenario$dist1(n_per_group)
    y <- scenario$dist2(n_per_group)

    # Compute nABCD with bootstrap CI
    res <- nABCD_bootstrap(x, y, B = B)

    results$estimate[i] <- res$estimate
    results$ci_lower[i] <- res$ci_lower
    results$ci_upper[i] <- res$ci_upper
    results$se[i] <- res$se

    if (i %% 100 == 0) cat("    Rep", i, "/", n_reps, "\n")
  }

  # Compute summary statistics
  true_val <- scenario$true_nABCD

  bias <- mean(results$estimate, na.rm = TRUE) - true_val

  # Coverage (for non-null scenarios)
  if (true_val > 0) {
    coverage <- mean(results$ci_lower <= true_val & true_val <= results$ci_upper,
                     na.rm = TRUE)
  } else {
    coverage <- NA
  }

  # Power: reject H0 (nABCD <= threshold) when true nABCD > threshold
  if (true_val > threshold) {
    power <- mean(results$ci_lower > threshold, na.rm = TRUE)
  } else if (true_val == 0) {
    # Type I error rate
    power <- mean(results$ci_lower > threshold, na.rm = TRUE)
  } else {
    power <- NA
  }

  list(
    results = results,
    summary = list(
      mean_estimate = mean(results$estimate, na.rm = TRUE),
      sd_estimate = sd(results$estimate, na.rm = TRUE),
      bias = bias,
      coverage = coverage,
      power = power
    )
  )
}

#' Run full simulation study
run_full_simulation <- function(n_reps = 500, B = 1000, seed = 42) {
  sample_sizes <- c(50, 100, 200)
  scenario_ids <- c("S01", "S03", "S04", "S05", "S06", "S08")

  all_results <- list()
  summary_table <- data.frame()

  cat("=== nABCD Simulation Study ===\n")
  cat("Replications:", n_reps, "| Bootstrap:", B, "\n\n")

  for (sc_id in scenario_ids) {
    sc <- scenarios[[sc_id]]
    cat("Scenario", sc_id, ":", sc$name, "\n")
    cat("  ", sc$description, "\n")
    cat("  True nABCD =", sc$true_nABCD, "\n")

    for (n in sample_sizes) {
      cat("  n =", n, "per group:\n")

      res <- run_scenario(sc, n_per_group = n, n_reps = n_reps, B = B, seed = seed)

      cat("    Bias:", round(res$summary$bias, 3), "\n")
      cat("    Coverage:", round(res$summary$coverage, 3), "\n")
      cat("    Power:", round(res$summary$power, 3), "\n")

      # Store results
      key <- paste(sc_id, n, sep = "_n")
      all_results[[key]] <- res

      # Add to summary table
      summary_table <- rbind(summary_table, data.frame(
        Scenario = sc_id,
        SampleSize = n,
        TrueNABCD = sc$true_nABCD,
        Bias = round(res$summary$bias, 3),
        Coverage = round(res$summary$coverage, 3),
        Power = round(res$summary$power, 3)
      ))
    }
    cat("\n")
  }

  list(
    all_results = all_results,
    summary_table = summary_table
  )
}

#' Save results to CSV
save_results <- function(summary_table, filepath = "data/simulation_results.csv") {
  write.csv(summary_table, filepath, row.names = FALSE)
  cat("Results saved to:", filepath, "\n")
}

# =============================================================================
# Main Execution
# =============================================================================

if (interactive() || !exists("SKIP_SIMULATION")) {
  cat("\n========================================\n")
  cat("nABCD Manuscript Simulation Study\n")
  cat("========================================\n\n")

  # Run simulation (adjust n_reps for speed vs accuracy)
  # Full run: n_reps = 500, B = 1000
  # Quick test: n_reps = 100, B = 500

  results <- run_full_simulation(n_reps = 500, B = 1000, seed = 42)

  # Display summary
  cat("\n=== Summary Table ===\n")
  print(results$summary_table)

  # Save to CSV
  save_results(results$summary_table)

  cat("\n=== Simulation Complete ===\n")
}

# =============================================================================
# Validation Check
# =============================================================================

validate_results <- function(summary_table) {
  cat("\n=== Validation Check ===\n")

  # Expected values from manuscript
  expected <- data.frame(
    Scenario = c("S01", "S01", "S01", "S03", "S03", "S03",
                 "S04", "S04", "S04", "S05", "S05", "S05",
                 "S06", "S06", "S06", "S08", "S08", "S08"),
    SampleSize = rep(c(50, 100, 200), 6),
    ExpBias = c(0.091, 0.066, 0.048,   # S01
                0.038, 0.014, 0.006,   # S03
                0.002, 0.000, -0.006,  # S04
                -0.041, -0.043, -0.044, # S05
                0.003, -0.015, -0.018, # S06
                0.025, 0.000, -0.015)  # S08
  )

  merged <- merge(summary_table, expected, by = c("Scenario", "SampleSize"))
  merged$BiasDiff <- abs(merged$Bias - merged$ExpBias)

  cat("Maximum bias discrepancy:", max(merged$BiasDiff), "\n")

  if (max(merged$BiasDiff) < 0.05) {
    cat("✅ VALIDATION PASSED: Results within tolerance\n")
  } else {
    cat("⚠️ VALIDATION WARNING: Some discrepancies detected\n")
    print(merged[merged$BiasDiff > 0.02, ])
  }

  invisible(merged)
}

# =============================================================================
# Usage
# =============================================================================
#
# # Full simulation (takes ~10-20 minutes)
# source("R/simulation_manuscript.R")
#
# # Quick test
# SKIP_SIMULATION <- TRUE
# source("R/simulation_manuscript.R")
# results <- run_full_simulation(n_reps = 50, B = 200, seed = 42)
#
# # Validate against manuscript values
# validate_results(results$summary_table)
# =============================================================================
