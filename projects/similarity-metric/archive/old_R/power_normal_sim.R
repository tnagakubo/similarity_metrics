# Power-Normal Distribution Simulation for nABCD
# Author: Katrina Bennett
# Date: 2026-02-03
# Reference: Goto et al. (1979); Maruo & Goto (2013) DOI:10.1007/s00180-012-0303-7

# =============================================================================
# Power-Normal Distribution Functions
# =============================================================================

#' Power-normal density function
#' @param x numeric vector
#' @param mu location parameter
#' @param sigma scale parameter (> 0)
#' @param alpha shape parameter (> 0); alpha=1 gives normal
#' @return density values
dpnorm <- function(x, mu = 0, sigma = 1, alpha = 1) {
  z <- (x - mu) / sigma
  (alpha / sigma) * dnorm(z) * pnorm(z)^(alpha - 1)
}

#' Power-normal CDF
#' @param x numeric vector
#' @param mu location parameter
#' @param sigma scale parameter
#' @param alpha shape parameter; alpha=1 gives normal
#' @return CDF values
ppnorm <- function(x, mu = 0, sigma = 1, alpha = 1) {
  z <- (x - mu) / sigma
  pnorm(z)^alpha
}

#' Power-normal quantile function
#' @param p probability vector
#' @param mu location parameter
#' @param sigma scale parameter
#' @param alpha shape parameter
#' @return quantile values
qpnorm <- function(p, mu = 0, sigma = 1, alpha = 1) {
  mu + sigma * qnorm(p^(1/alpha))
}

#' Random generation from power-normal
#' @param n sample size
#' @param mu location parameter
#' @param sigma scale parameter
#' @param alpha shape parameter
#' @return random sample
rpnorm <- function(n, mu = 0, sigma = 1, alpha = 1) {
  u <- runif(n)
  qpnorm(u, mu, sigma, alpha)
}

# =============================================================================
# nABCD Computation (ECDF-based)
# =============================================================================

#' Compute Wasserstein-1 distance between two samples
#' @param x numeric vector (sample 1)
#' @param y numeric vector (sample 2)
#' @return W1 distance
wasserstein1 <- function(x, y) {
  # Combine and sort all unique values
  all_vals <- sort(unique(c(x, y)))

  # Add endpoints for integration
  x_min <- min(all_vals) - 1
  x_max <- max(all_vals) + 1
  grid <- c(x_min, all_vals, x_max)

  # Compute ECDFs
  Fx <- ecdf(x)
  Fy <- ecdf(y)

  # Numerical integration (step function area)
  w1 <- 0
  for (i in 2:length(grid)) {
    dx <- grid[i] - grid[i-1]
    # Use midpoint for step function
    mid <- (grid[i] + grid[i-1]) / 2
    w1 <- w1 + abs(Fx(mid) - Fy(mid)) * dx
  }

  return(w1)
}

#' Compute pooled IQR
#' @param x numeric vector (sample 1)
#' @param y numeric vector (sample 2)
#' @return pooled IQR
pooled_iqr <- function(x, y) {
  pooled <- c(x, y)
  IQR(pooled)
}

#' Compute nABCD
#' @param x numeric vector (sample 1)
#' @param y numeric vector (sample 2)
#' @return nABCD value
nABCD <- function(x, y) {
  w1 <- wasserstein1(x, y)
  iqr <- pooled_iqr(x, y)
  w1 / (2 * iqr)
}

#' Bootstrap CI for nABCD
#' @param x sample 1
#' @param y sample 2
#' @param B number of bootstrap replicates
#' @param conf confidence level
#' @return list with estimate, CI, SE
nABCD_bootstrap <- function(x, y, B = 1000, conf = 0.95) {
  n <- length(x)
  m <- length(y)

  # Point estimate
  est <- nABCD(x, y)

  # Bootstrap
  boot_vals <- numeric(B)
  for (b in 1:B) {
    x_star <- sample(x, n, replace = TRUE)
    y_star <- sample(y, m, replace = TRUE)
    boot_vals[b] <- nABCD(x_star, y_star)
  }

  # Percentile CI
  alpha <- 1 - conf
  ci <- quantile(boot_vals, c(alpha/2, 1 - alpha/2))
  ci[1] <- max(0, ci[1])  # nABCD >= 0

  list(
    estimate = est,
    ci_lower = unname(ci[1]),
    ci_upper = unname(ci[2]),
    se = sd(boot_vals),
    boot_samples = boot_vals
  )
}

# =============================================================================
# Simulation Scenarios (Power-Normal)
# =============================================================================

# Dr. Goto's Power-Normal Distribution
# alpha = 1: Normal (symmetric)
# alpha > 1: Right-skewed
# alpha < 1: Left-skewed

# -----------------------------------------------------------------------------
# Section 4.1: Systematic Scenarios (Methodological Validation)
# -----------------------------------------------------------------------------

systematic_scenarios <- list(
  # Symmetric scenarios (baseline comparison with original)
  S01 = list(name = "Null: Normal vs Normal",
             alpha1 = 1, alpha2 = 1, mu1 = 50, mu2 = 50, sigma1 = 10, sigma2 = 10,
             true_nABCD = 0),

  # Power-normal scenarios (NEW - addressing Louis's critique)
  S09 = list(name = "Null: Right-skewed (same)",
             alpha1 = 2, alpha2 = 2, mu1 = 50, mu2 = 50, sigma1 = 10, sigma2 = 10,
             true_nABCD = 0),

  S10 = list(name = "Alt: Right-skewed (different alpha)",
             alpha1 = 2, alpha2 = 3, mu1 = 50, mu2 = 50, sigma1 = 10, sigma2 = 10,
             true_nABCD = NA),  # To be computed via Monte Carlo

  S11 = list(name = "Null: Left-skewed (same)",
             alpha1 = 0.5, alpha2 = 0.5, mu1 = 50, mu2 = 50, sigma1 = 10, sigma2 = 10,
             true_nABCD = 0),

  S12 = list(name = "Alt: Opposite skew",
             alpha1 = 0.5, alpha2 = 2, mu1 = 50, mu2 = 50, sigma1 = 10, sigma2 = 10,
             true_nABCD = NA),  # To be computed via Monte Carlo

  S13 = list(name = "Alt: Mild vs Strong right-skew",
             alpha1 = 1.5, alpha2 = 3, mu1 = 50, mu2 = 50, sigma1 = 10, sigma2 = 10,
             true_nABCD = NA)   # To be computed via Monte Carlo
)

# -----------------------------------------------------------------------------
# Section 4.2: Realistic Scenarios (Clinical Relevance)
# Based on actual effect modifiers in MRCTs
# -----------------------------------------------------------------------------

realistic_scenarios <- list(
  # R01: BMI - Japan vs US/EU
  # Japan: mean ~23, slight right-skew

  # US/EU: mean ~28, more right-skew, higher variance
  R01 = list(name = "BMI: Japan vs US",
             alpha1 = 1.5, alpha2 = 2.0,
             mu1 = 23, mu2 = 28,
             sigma1 = 3, sigma2 = 5,
             true_nABCD = NA,
             clinical_context = "Body mass index comparison"),

  # R02: Age in elderly population
  # Japan: older, slight left-skew (ceiling effect)
  # US: younger mean, more symmetric
  R02 = list(name = "Age: Japan vs US (elderly)",
             alpha1 = 0.8, alpha2 = 1.0,
             mu1 = 72, mu2 = 68,
             sigma1 = 8, sigma2 = 10,
             true_nABCD = NA,
             clinical_context = "Age distribution in elderly disease population"),

  # R03: eGFR in CKD population
  # Both left-skewed (upper limit ~120), different means
  R03 = list(name = "eGFR: Renal impairment",
             alpha1 = 0.7, alpha2 = 0.8,
             mu1 = 45, mu2 = 50,
             sigma1 = 15, sigma2 = 18,
             true_nABCD = NA,
             clinical_context = "Kidney function in CKD patients"),

  # R04: HbA1c in diabetes
  # Right-skewed, different location and scale
  R04 = list(name = "HbA1c: Diabetes",
             alpha1 = 1.8, alpha2 = 2.0,
             mu1 = 7.5, mu2 = 8.2,
             sigma1 = 1.2, sigma2 = 1.5,
             true_nABCD = NA,
             clinical_context = "Glycemic control in diabetic patients"),

  # R05: Baseline disease severity (e.g., CDAI in Crohn's)
  # Moderate right-skew, regional enrollment differences
  R05 = list(name = "Disease severity score",
             alpha1 = 1.5, alpha2 = 1.8,
             mu1 = 280, mu2 = 320,
             sigma1 = 80, sigma2 = 100,
             true_nABCD = NA,
             clinical_context = "Baseline severity in inflammatory disease")
)

# Combine all scenarios
scenarios <- c(systematic_scenarios, realistic_scenarios)

# =============================================================================
# Run Simulation
# =============================================================================

#' Run simulation for one scenario
#' @param scenario list with scenario parameters
#' @param n_per_group sample size per group
#' @param n_reps number of replications
#' @param B bootstrap replicates
#' @param seed random seed
run_scenario <- function(scenario, n_per_group = 100, n_reps = 500, B = 1000, seed = NULL) {
  if (!is.null(seed)) set.seed(seed)

  results <- data.frame(
    rep = 1:n_reps,
    estimate = numeric(n_reps),
    ci_lower = numeric(n_reps),
    ci_upper = numeric(n_reps),
    se = numeric(n_reps)
  )

  for (i in 1:n_reps) {
    # Generate samples
    x <- rpnorm(n_per_group, scenario$mu1, scenario$sigma1, scenario$alpha1)
    y <- rpnorm(n_per_group, scenario$mu2, scenario$sigma2, scenario$alpha2)

    # Compute nABCD with bootstrap CI
    res <- nABCD_bootstrap(x, y, B = B)

    results$estimate[i] <- res$estimate
    results$ci_lower[i] <- res$ci_lower
    results$ci_upper[i] <- res$ci_upper
    results$se[i] <- res$se

    if (i %% 100 == 0) cat("  Rep", i, "/", n_reps, "\n")
  }

  results
}

#' Summarize simulation results
summarize_results <- function(results, true_nABCD = 0) {
  n <- nrow(results)

  # Bias
  bias <- mean(results$estimate) - true_nABCD

  # RMSE
  rmse <- sqrt(mean((results$estimate - true_nABCD)^2))

  # Coverage (if true_nABCD is known)
  if (!is.na(true_nABCD)) {
    coverage <- mean(results$ci_lower <= true_nABCD & true_nABCD <= results$ci_upper)
  } else {
    coverage <- NA
  }

  # Mean SE
  mean_se <- mean(results$se)

  # Mean CI width
  ci_width <- mean(results$ci_upper - results$ci_lower)

  list(
    mean_estimate = mean(results$estimate),
    sd_estimate = sd(results$estimate),
    bias = bias,
    rmse = rmse,
    coverage = coverage,
    mean_se = mean_se,
    ci_width = ci_width
  )
}

# =============================================================================
# Main Execution
# =============================================================================

if (interactive()) {
  cat("\n=== nABCD Power-Normal Simulation ===\n")
  cat("Reference: Goto et al. (1979); Maruo & Goto (2013)\n\n")

  # Run for selected scenarios and sample sizes
  sample_sizes <- c(50, 100, 200)
  scenarios_to_run <- c("S01", "S09", "S10", "S11", "S12", "S13")

  all_results <- list()

  for (sc_name in scenarios_to_run) {
    sc <- scenarios[[sc_name]]
    cat("\n--- Scenario:", sc_name, "-", sc$name, "---\n")
    cat("  alpha1 =", sc$alpha1, ", alpha2 =", sc$alpha2, "\n")

    for (n in sample_sizes) {
      cat("\n  n =", n, "per group:\n")

      res <- run_scenario(sc, n_per_group = n, n_reps = 500, B = 1000, seed = 42)
      summ <- summarize_results(res, sc$true_nABCD)

      cat("    Mean estimate:", round(summ$mean_estimate, 4), "\n")
      cat("    Bias:", round(summ$bias, 4), "\n")
      cat("    Coverage:", round(summ$coverage, 3), "\n")
      cat("    Mean SE:", round(summ$mean_se, 4), "\n")

      all_results[[paste(sc_name, n, sep = "_")]] <- list(
        scenario = sc_name,
        n = n,
        results = res,
        summary = summ
      )
    }
  }

  cat("\n=== Simulation Complete ===\n")
}

# =============================================================================
# Acknowledgment
# =============================================================================
# We thank the pioneering work of Dr. Masashi Goto and colleagues on the
# power-normal distribution, which provides an elegant framework for
# evaluating nABCD performance under varying degrees of skewness.
#
# References:
# - Goto, M., Uesaka, H. & Inoue, T. (1979). Some linear models for power
#   transformed data. 10th International Biometric Conference.
# - Maruo, K. & Goto, M. (2013). Percentile estimation based on the
#   power-normal distribution. Computational Statistics, 28:341-356.
#   DOI: 10.1007/s00180-012-0303-7
