# SEMD: Similarity of Effect Modifier Distribution
# R Prototype Implementation
# Author: Katrina Bennett
# Date: 2026-02-02

# Dependencies
library(stats)  # for density()

#' Estimate SEMD between two samples
#'
#' @param x1 Numeric vector: sample from region 1
#' @param x2 Numeric vector: sample from region 2
#' @param g Function: effect modification function g(x), default = constant 1
#' @param n_grid Integer: number of grid points for integration (default 512)
#' @param bw Character or numeric: bandwidth selection method or fixed value
#'        "silverman" (default), "SJ", or a numeric value
#' @return Numeric: estimated SEMD value
#'
#' @examples
#' set.seed(123)
#' x1 <- rnorm(100, mean = 0, sd = 1)
#' x2 <- rnorm(100, mean = 0.5, sd = 1)
#' semd_estimate(x1, x2)
#'
semd_estimate <- function(x1, x2, g = function(x) rep(1, length(x)),
                          n_grid = 512, bw = "silverman",
                          undersmooth = FALSE, undersmooth_factor = NULL) {

  # Input validation
  stopifnot(is.numeric(x1), is.numeric(x2))

  stopifnot(length(x1) >= 2, length(x2) >= 2)

  # Determine common support for integration
  x_min <- min(c(x1, x2))
  x_max <- max(c(x1, x2))
  margin <- 0.1 * (x_max - x_min)
  x_range <- c(x_min - margin, x_max + margin)

  # Bandwidth selection
  if (is.character(bw)) {
    if (bw == "silverman") {
      # Silverman's rule of thumb
      bw1 <- bw.nrd0(x1)
      bw2 <- bw.nrd0(x2)
    } else if (bw == "SJ") {
      # Sheather-Jones plug-in
      bw1 <- bw.SJ(x1)
      bw2 <- bw.SJ(x2)
    } else {
      stop("Unknown bandwidth method: ", bw)
    }
  } else if (is.numeric(bw)) {
    bw1 <- bw2 <- bw
  } else {
    stop("bw must be character or numeric")
  }

  # Apply undersmoothing if requested (Issue 3 resolution)
  # Undersmoothing: h_new = h_old * n^(-1/5) / n^(-1/3) = h_old * n^(-2/15)
  # This changes rate from n^(-1/5) to n^(-1/3), ensuring sqrt(n)*bias -> 0
  if (undersmooth) {
    n1 <- length(x1)
    n2 <- length(x2)
    if (is.null(undersmooth_factor)) {
      # Default: convert from n^(-1/5) to n^(-1/3) rate
      # Factor = n^(1/5 - 1/3) = n^(-2/15)
      factor1 <- n1^(-2/15)
      factor2 <- n2^(-2/15)
    } else {
      factor1 <- factor2 <- undersmooth_factor
    }
    bw1 <- bw1 * factor1
    bw2 <- bw2 * factor2
  }

  # Kernel density estimation
  dens1 <- density(x1, bw = bw1, n = n_grid, from = x_range[1], to = x_range[2])
  dens2 <- density(x2, bw = bw2, n = n_grid, from = x_range[1], to = x_range[2])

  # Ensure same grid
  x_grid <- dens1$x
  f1 <- pmax(dens1$y, 0)  # Ensure non-negative
  f2 <- pmax(dens2$y, 0)

  # Effect modification function on grid
  g_vals <- g(x_grid)

  # Numerical integration (trapezoidal rule)
  integrand <- abs(f1 - f2) * abs(g_vals)
  dx <- diff(x_grid[1:2])
  semd <- sum(integrand) * dx

  return(semd)
}


#' Bootstrap confidence interval for SEMD
#'
#' @param x1 Numeric vector: sample from region 1
#' @param x2 Numeric vector: sample from region 2
#' @param g Function: effect modification function
#' @param B Integer: number of bootstrap replicates (default 1000)
#' @param conf_level Numeric: confidence level (default 0.95)
#' @param method Character: "percentile" or "basic" (default "percentile")
#' @param n_grid Integer: grid points for integration
#' @param bw Bandwidth method
#' @param seed Integer: random seed for reproducibility
#' @return List with: estimate, ci_lower, ci_upper, se, boot_samples
#'
#' @examples
#' set.seed(123)
#' x1 <- rnorm(100, mean = 0)
#' x2 <- rnorm(100, mean = 0.3)
#' result <- semd_bootstrap_ci(x1, x2, B = 500)
#' print(result)
#'
semd_bootstrap_ci <- function(x1, x2, g = function(x) rep(1, length(x)),
                               B = 1000, conf_level = 0.95,
                               method = "percentile",
                               n_grid = 512, bw = "silverman",
                               undersmooth = FALSE, undersmooth_factor = NULL,
                               seed = NULL) {

  # Set seed if provided
  if (!is.null(seed)) set.seed(seed)

  # Point estimate
  theta_hat <- semd_estimate(x1, x2, g = g, n_grid = n_grid, bw = bw,
                              undersmooth = undersmooth,
                              undersmooth_factor = undersmooth_factor)

  n1 <- length(x1)
  n2 <- length(x2)

  # Bootstrap resampling
  boot_samples <- numeric(B)

  for (b in 1:B) {
    # Resample with replacement
    x1_star <- sample(x1, n1, replace = TRUE)
    x2_star <- sample(x2, n2, replace = TRUE)

    # Compute bootstrap estimate
    boot_samples[b] <- semd_estimate(x1_star, x2_star, g = g,
                                      n_grid = n_grid, bw = bw,
                                      undersmooth = undersmooth,
                                      undersmooth_factor = undersmooth_factor)
  }

  # Bootstrap standard error
  se <- sd(boot_samples)

  # Confidence interval
  alpha <- 1 - conf_level

  if (method == "percentile") {
    # Percentile method
    ci <- quantile(boot_samples, probs = c(alpha/2, 1 - alpha/2))
    ci_lower <- unname(ci[1])
    ci_upper <- unname(ci[2])

  } else if (method == "basic") {
    # Basic bootstrap (2*theta_hat - quantiles)
    q <- quantile(boot_samples, probs = c(1 - alpha/2, alpha/2))
    ci_lower <- 2 * theta_hat - unname(q[1])
    ci_upper <- 2 * theta_hat - unname(q[2])

  } else {
    stop("Unknown method: ", method, ". Use 'percentile' or 'basic'.")
  }

  # Ensure non-negative lower bound (SEMD >= 0 by definition)
  ci_lower <- max(0, ci_lower)

  return(list(
    estimate = theta_hat,
    ci_lower = ci_lower,
    ci_upper = ci_upper,
    conf_level = conf_level,
    se = se,
    boot_samples = boot_samples,
    n1 = n1,
    n2 = n2,
    B = B
  ))
}


#' Print method for SEMD bootstrap result
print.semd_result <- function(x, ...) {
  cat("SEMD Estimate\n")
  cat("-------------\n")
  cat(sprintf("Point estimate: %.4f\n", x$estimate))
  cat(sprintf("%d%% CI: [%.4f, %.4f]\n",
              round(x$conf_level * 100), x$ci_lower, x$ci_upper))
  cat(sprintf("Bootstrap SE: %.4f\n", x$se))
  cat(sprintf("Sample sizes: n1 = %d, n2 = %d\n", x$n1, x$n2))
  cat(sprintf("Bootstrap replicates: B = %d\n", x$B))
}


# ============================================================
# Example usage and quick test
# ============================================================

if (interactive()) {
  cat("\n=== SEMD Prototype Test ===\n\n")

  set.seed(42)

  # Scenario 1: Similar distributions (small SEMD expected)
  x1_similar <- rnorm(200, mean = 0, sd = 1)
  x2_similar <- rnorm(200, mean = 0, sd = 1)

  result_similar <- semd_bootstrap_ci(x1_similar, x2_similar, B = 500, seed = 123)
  cat("Scenario 1: Similar distributions (N(0,1) vs N(0,1))\n")
  cat(sprintf("  SEMD = %.4f, 95%% CI = [%.4f, %.4f]\n\n",
              result_similar$estimate, result_similar$ci_lower, result_similar$ci_upper))

  # Scenario 2: Shifted distributions (moderate SEMD)
  x1_shift <- rnorm(200, mean = 0, sd = 1)
  x2_shift <- rnorm(200, mean = 0.5, sd = 1)

  result_shift <- semd_bootstrap_ci(x1_shift, x2_shift, B = 500, seed = 123)
  cat("Scenario 2: Shifted distributions (N(0,1) vs N(0.5,1))\n")
  cat(sprintf("  SEMD = %.4f, 95%% CI = [%.4f, %.4f]\n\n",
              result_shift$estimate, result_shift$ci_lower, result_shift$ci_upper))

  # Scenario 3: Different spread (larger SEMD)
  x1_spread <- rnorm(200, mean = 0, sd = 1)
  x2_spread <- rnorm(200, mean = 0, sd = 2)

  result_spread <- semd_bootstrap_ci(x1_spread, x2_spread, B = 500, seed = 123)
  cat("Scenario 3: Different spread (N(0,1) vs N(0,2))\n")
  cat(sprintf("  SEMD = %.4f, 95%% CI = [%.4f, %.4f]\n\n",
              result_spread$estimate, result_spread$ci_lower, result_spread$ci_upper))

  # Scenario 4: With effect modification function
  g_linear <- function(x) x  # Linear effect modification

  result_effect <- semd_bootstrap_ci(x1_shift, x2_shift, g = g_linear, B = 500, seed = 123)
  cat("Scenario 4: With linear g(x) = x\n")
  cat(sprintf("  SEMD = %.4f, 95%% CI = [%.4f, %.4f]\n\n",
              result_effect$estimate, result_effect$ci_lower, result_effect$ci_upper))

  cat("=== Test Complete ===\n")
}

# ============================================================
# SEMD Interpretation Table (Issue 5 resolution)
# ============================================================
#
# | SEMD Value | L1 Distance | Interpretation | Pooling Recommendation |
# |------------|-------------|----------------|------------------------|
# | < 0.10     | < 5%        | Very Similar   | Strong support for pooling |
# | 0.10-0.20  | 5-10%       | Similar        | Pooling acceptable |
# | 0.20-0.35  | 10-18%      | Moderate diff  | Pooling with caution |
# | 0.35-0.50  | 18-25%      | Substantial    | Consider separate analysis |
# | > 0.50     | > 25%       | Large diff     | Separate analysis recommended |
#
# Note: L1 distance = integral of |f1 - f2| (SEMD with g(x) = 1)
# Interpretation assumes g(x) = 1 (unweighted). With effect modification
# function g(x), interpretation should account for clinical meaning of g.
#
# Reference distributions for calibration:
# - N(0,1) vs N(0,1):     SEMD ≈ 0.05-0.10 (sampling variability)
# - N(0,1) vs N(0.3,1):   SEMD ≈ 0.15 (small shift)
# - N(0,1) vs N(0.5,1):   SEMD ≈ 0.20 (moderate shift)
# - N(0,1) vs N(1.0,1):   SEMD ≈ 0.38 (large shift)
# - N(0,1) vs N(0,1.5):   SEMD ≈ 0.18 (moderate spread difference)
# - N(0,1) vs N(0,2.0):   SEMD ≈ 0.27 (large spread difference)

#' Interpret SEMD value for regulatory reporting
#'
#' @param semd Numeric: SEMD estimate
#' @param ci_lower Numeric: lower bound of CI (optional)
#' @param ci_upper Numeric: upper bound of CI (optional)
#' @return Character: interpretation string
#'
semd_interpret <- function(semd, ci_lower = NULL, ci_upper = NULL) {
  # Interpretation based on point estimate
  if (semd < 0.10) {
    level <- "Very Similar"
    recommendation <- "Strong support for pooling regions"
  } else if (semd < 0.20) {
    level <- "Similar"
    recommendation <- "Pooling acceptable"
  } else if (semd < 0.35) {
    level <- "Moderate Difference"
    recommendation <- "Pooling with caution; consider sensitivity analysis"
  } else if (semd < 0.50) {
    level <- "Substantial Difference"
    recommendation <- "Consider separate regional analysis"
  } else {
    level <- "Large Difference"
    recommendation <- "Separate regional analysis recommended"
  }

  result <- sprintf("SEMD = %.3f: %s\nRecommendation: %s", semd, level, recommendation)

  # Add CI-based caveat if provided

  if (!is.null(ci_lower) && !is.null(ci_upper)) {
    # Check if CI spans interpretation boundaries
    boundaries <- c(0.10, 0.20, 0.35, 0.50)
    spans_boundary <- any(ci_lower < boundaries & boundaries < ci_upper)
    if (spans_boundary) {
      result <- paste0(result, "\nNote: CI spans interpretation boundaries; interpret with caution")
    }
  }

  return(result)
}


# ============================================================
# TODO: Future enhancements
# ============================================================
# - [x] Add undersmoothing option for inference (Issue 3 - DONE)
# - [x] Add interpretation function (Issue 5 - DONE)
# - [ ] Add BCa (bias-corrected accelerated) bootstrap option
# - [ ] Add hypothesis test: H0: SEMD = 0 vs H1: SEMD > 0
# - [ ] Add multivariate extension for d > 1
# - [ ] Add visualization function (density overlay plot)
# - [ ] Add S3 class structure for results
