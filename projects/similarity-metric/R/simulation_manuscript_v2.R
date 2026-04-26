# =============================================================================
# nABCD Simulation Study - Version 2 (Refreshed Scenarios)
# Authors: Mike Ross (Methodologist), Katrina Bennett (Technical Writer)
# Date: 2026-02-14
#
# Scenario Design Principles:
#   - Each scenario motivated by real MRCT distributional patterns
#   - Contiguous IDs (S1-S7), no gaps
#   - S6 (log-normal skew), S7 (location + scale combined)
#   - Power-normal/log-normal captures biomarker skewness
#
# Estimation-centered: Bias, RMSE, Coverage, CI Width (primary)
# Detection/Equivalence power retained as supplementary
#
# Parallelization: future.apply (Bengtsson 2021, R Journal)
# =============================================================================

library(stats)
library(future.apply)

# =============================================================================
# Acceleration Detection (Rcpp > Rfast > base R)
# =============================================================================

USE_RCPP  <- FALSE
USE_RFAST <- FALSE
RCPP_FILE <- NULL  # Absolute path — shared with workers for lazy-compile

# Try Rcpp (fastest: entire bootstrap in C++)
if (requireNamespace("Rcpp", quietly = TRUE)) {
  script_dir <- tryCatch(dirname(sys.frame(1)$ofile), error = function(e) ".")
  rcpp_file <- file.path(script_dir, "nABCD_rcpp.cpp")
  if (!file.exists(rcpp_file))
    rcpp_file <- "R/nABCD_rcpp.cpp"
  if (file.exists(rcpp_file)) {
    tryCatch({
      Rcpp::sourceCpp(rcpp_file)
      USE_RCPP <- TRUE
      RCPP_FILE <- normalizePath(rcpp_file)  # absolute path for workers
      cat("[Accel] Rcpp loaded — full C++ bootstrap active\n")
      cat("[Accel] RCPP_FILE:", RCPP_FILE, "\n")
    }, error = function(e) {
      cat("[Accel] Rcpp compile failed:", conditionMessage(e), "\n")
    })
  }
}

# Try Rfast (faster column sort than apply)
if (!USE_RCPP && requireNamespace("Rfast", quietly = TRUE)) {
  USE_RFAST <- TRUE
  cat("[Accel] Rfast loaded — fast column sort active\n")
}

if (!USE_RCPP && !USE_RFAST)
  cat("[Accel] Base R mode (install Rcpp+Rtools or Rfast for speed)\n")

# Column sort dispatcher
col_sort <- if (USE_RFAST) Rfast::colSort else function(m) apply(m, 2, sort)

# --- Worker-side lazy Rcpp compilation ---
# future_lapply workers are separate R processes. They receive USE_RCPP=TRUE
# and RCPP_FILE from the main session (exported as globals), but the compiled
# shared library is NOT loaded in workers. This helper compiles once per worker.
ensure_rcpp_in_worker <- function(rcpp_path) {
  if (!is.null(rcpp_path) &&
      !isTRUE(.GlobalEnv$.rcpp_worker_ready) &&
      requireNamespace("Rcpp", quietly = TRUE)) {
    tryCatch({
      Rcpp::sourceCpp(rcpp_path)
      .GlobalEnv$.rcpp_worker_ready <- TRUE
    }, error = function(e) {
      # Compilation failed in worker — fall back to R
      .GlobalEnv$.rcpp_worker_ready <- FALSE
    })
  }
  isTRUE(.GlobalEnv$.rcpp_worker_ready)
}

# =============================================================================
# Core Functions (Vectorized)
# =============================================================================

#' Wasserstein-1 distance - VECTORIZED
wasserstein1 <- function(x, y) {
  all_vals <- sort(c(x, y))
  n <- length(all_vals)
  if (n < 2) return(0)

  Fx <- ecdf(x)
  Fy <- ecdf(y)

  mids <- (all_vals[-n] + all_vals[-1]) / 2
  diffs <- diff(all_vals)

  sum(abs(Fx(mids) - Fy(mids)) * diffs)
}

#' Compute nABCD
compute_nABCD <- function(x, y) {
  pooled <- c(x, y)
  iqr_pooled <- IQR(pooled)
  if (iqr_pooled == 0) return(NA_real_)
  wasserstein1(x, y) / (2 * iqr_pooled)
}

# =============================================================================
# Fast Helpers (equal-sized samples)
# =============================================================================

#' W1 for equal-sized SORTED samples: exact via quantile identity
#' W1(F,G) = integral|F^{-1}(u) - G^{-1}(u)|du = mean(|x_(i) - y_(i)|)
wasserstein1_equal <- function(x_sorted, y_sorted) {
  mean(abs(x_sorted - y_sorted))
}

#' IQR from pre-sorted vector (quantile type=7, matches R default)
iqr_from_sorted <- function(x_sorted, n) {
  h1 <- (n - 1) * 0.25 + 1
  h3 <- (n - 1) * 0.75 + 1
  f1 <- floor(h1); f3 <- floor(h3)
  q1 <- x_sorted[f1] + (h1 - f1) * (x_sorted[f1 + 1L] - x_sorted[f1])
  q3 <- x_sorted[f3] + (h3 - f3) * (x_sorted[f3 + 1L] - x_sorted[f3])
  q3 - q1
}

# =============================================================================
# Vectorized Bootstrap CI (FAST — primary)
# =============================================================================

#' Vectorized bootstrap CI for nABCD
#' ~50x faster than replicate-based approach:
#'   - sort-based W1 (no ecdf object creation)
#'   - matrix sort + colMeans (eliminates 2000 R function calls per rep)
#'   - BCa optional (off by default; paper uses Percentile as primary)
nABCD_bootstrap_fast <- function(x, y, B = 2000, conf = 0.95,
                                 compute_bca = FALSE) {
  n1 <- length(x)
  n2 <- length(y)
  equal_n <- (n1 == n2)
  n_total <- n1 + n2
  null_res <- list(estimate = NA_real_, pct_lower = NA_real_,
                   pct_upper = NA_real_, bca_lower = NA_real_,
                   bca_upper = NA_real_, se = NA_real_)

  # --- Original estimate ---
  pooled_s <- sort(c(x, y))
  iqr_p <- iqr_from_sorted(pooled_s, n_total)
  if (iqr_p == 0) return(null_res)

  if (equal_n) {
    est <- wasserstein1_equal(sort(x), sort(y)) / (2 * iqr_p)
  } else {
    est <- wasserstein1(x, y) / (2 * iqr_p)
  }

  # --- Vectorized bootstrap (matrix ops, no R loop) ---
  x_raw <- matrix(x[sample.int(n1, n1 * B, replace = TRUE)], nrow = n1)
  y_raw <- matrix(y[sample.int(n2, n2 * B, replace = TRUE)], nrow = n2)

  # Sort each column (Rfast::colSort if available, else apply)
  x_s <- col_sort(x_raw)
  y_s <- col_sort(y_raw)

  # W1 per bootstrap: vectorized colMeans for equal n
  if (equal_n) {
    w1_boot <- colMeans(abs(x_s - y_s))
  } else {
    w1_boot <- vapply(seq_len(B), function(b)
      wasserstein1(x_raw[, b], y_raw[, b]), numeric(1))
  }

  # IQR per bootstrap: sort pooled columns, extract quantiles
  pooled_s_boot <- col_sort(rbind(x_raw, y_raw))
  h1 <- (n_total - 1) * 0.25 + 1
  h3 <- (n_total - 1) * 0.75 + 1
  f1 <- floor(h1); f3 <- floor(h3)
  q1_boot <- pooled_s_boot[f1, ] +
    (h1 - f1) * (pooled_s_boot[f1 + 1L, ] - pooled_s_boot[f1, ])
  q3_boot <- pooled_s_boot[f3, ] +
    (h3 - f3) * (pooled_s_boot[f3 + 1L, ] - pooled_s_boot[f3, ])
  iqr_boot <- q3_boot - q1_boot

  # nABCD per bootstrap
  valid <- iqr_boot > 0
  boot_vals <- rep(NA_real_, B)
  boot_vals[valid] <- w1_boot[valid] / (2 * iqr_boot[valid])
  boot_vals <- boot_vals[!is.na(boot_vals)]
  B_valid <- length(boot_vals)

  if (B_valid < 10) return(null_res)

  # Percentile CI (primary)
  alpha <- 1 - conf
  pct_ci <- quantile(boot_vals, c(alpha / 2, 1 - alpha / 2))
  pct_ci[1] <- max(0, pct_ci[1])

  # BCa (optional — skip by default for speed)
  bca_lo <- NA_real_; bca_hi <- NA_real_
  if (compute_bca) {
    z0 <- qnorm(mean(boot_vals < est))
    jack_x <- vapply(seq_len(n1), function(i)
      compute_nABCD(x[-i], y), numeric(1))
    jack_y <- vapply(seq_len(n2), function(j)
      compute_nABCD(x, y[-j]), numeric(1))
    jack_vals <- c(jack_x, jack_y)
    jack_vals <- jack_vals[!is.na(jack_vals)]
    jack_mean <- mean(jack_vals)
    d <- jack_mean - jack_vals
    denom <- 6 * (sum(d^2))^(3 / 2)
    acc <- if (abs(denom) < 1e-15) 0 else sum(d^3) / denom
    z_lo <- qnorm(alpha / 2); z_hi <- qnorm(1 - alpha / 2)
    adj_lo <- pnorm(z0 + (z0 + z_lo) / (1 - acc * (z0 + z_lo)))
    adj_hi <- pnorm(z0 + (z0 + z_hi) / (1 - acc * (z0 + z_hi)))
    eps <- 1 / (B_valid + 1)
    adj_lo <- max(eps, min(adj_lo, 1 - eps))
    adj_hi <- max(eps, min(adj_hi, 1 - eps))
    bca_ci <- quantile(boot_vals, c(adj_lo, adj_hi))
    bca_lo <- max(0, unname(bca_ci[1]))
    bca_hi <- unname(bca_ci[2])
  }

  list(estimate  = est,
       pct_lower = unname(pct_ci[1]), pct_upper = unname(pct_ci[2]),
       bca_lower = bca_lo, bca_upper = bca_hi,
       se = sd(boot_vals))
}

# =============================================================================
# BCa Bootstrap CI for nABCD (original — kept for reference/validation)
# =============================================================================

nABCD_bootstrap_bca <- function(x, y, B = 2000, conf = 0.95) {
  n1 <- length(x)
  n2 <- length(y)
  est <- compute_nABCD(x, y)

  boot_vals <- replicate(B, {
    compute_nABCD(sample(x, n1, replace = TRUE),
                  sample(y, n2, replace = TRUE))
  })
  boot_vals <- boot_vals[!is.na(boot_vals)]
  B_valid <- length(boot_vals)

  if (B_valid < 10) {
    return(list(estimate = est,
                pct_lower = NA, pct_upper = NA,
                bca_lower = NA, bca_upper = NA, se = NA))
  }

  alpha <- 1 - conf

  # Percentile CI
  pct_ci <- quantile(boot_vals, c(alpha / 2, 1 - alpha / 2))
  pct_ci[1] <- max(0, pct_ci[1])

  # BCa: Bias correction z0
  z0 <- qnorm(mean(boot_vals < est))

  # BCa: Acceleration via jackknife
  jack_x <- vapply(seq_len(n1), function(i) compute_nABCD(x[-i], y), numeric(1))
  jack_y <- vapply(seq_len(n2), function(j) compute_nABCD(x, y[-j]), numeric(1))
  jack_vals <- c(jack_x, jack_y)
  jack_vals <- jack_vals[!is.na(jack_vals)]

  jack_mean <- mean(jack_vals)
  d <- jack_mean - jack_vals
  denom <- 6 * (sum(d^2))^(3 / 2)
  acc <- if (abs(denom) < 1e-15) 0 else sum(d^3) / denom

  # BCa: Adjusted quantiles
  z_lo <- qnorm(alpha / 2)
  z_hi <- qnorm(1 - alpha / 2)

  adj_lo <- pnorm(z0 + (z0 + z_lo) / (1 - acc * (z0 + z_lo)))
  adj_hi <- pnorm(z0 + (z0 + z_hi) / (1 - acc * (z0 + z_hi)))

  eps <- 1 / (B_valid + 1)
  adj_lo <- max(eps, min(adj_lo, 1 - eps))
  adj_hi <- max(eps, min(adj_hi, 1 - eps))

  bca_ci <- quantile(boot_vals, c(adj_lo, adj_hi))
  bca_ci[1] <- max(0, bca_ci[1])

  list(estimate  = est,
       pct_lower = unname(pct_ci[1]), pct_upper = unname(pct_ci[2]),
       bca_lower = unname(bca_ci[1]), bca_upper = unname(bca_ci[2]),
       se = sd(boot_vals))
}

# =============================================================================
# Scenario Definitions (Refreshed: S1-S7, no gaps)
# =============================================================================
#
# Design principles:
#   1. Each scenario represents a specific, realistic MRCT pattern
#   2. Reference distribution is always N(50, 10^2) (Region 1)
#   3. Region 2 varies to create location, scale, shape, or combined differences
#   4. True nABCD computed via Monte Carlo (n = 1e6)
#
# Clinical motivations:
#   S1: Null — identical populations (reference case)
#   S2: Small age difference (EU vs US, ~2yr in SD=10yr)
#   S3: Moderate BMI difference (Japan vs EU, 0.5 SD)
#   S4: Large BMI difference (Japan vs US, 1.0 SD)
#   S5: Variance difference from inclusion criteria heterogeneity
#   S6: Log-normal biomarkers (ALT) — moderate right skew
#   S7: Combined location + scale (most realistic MRCT pattern)
# =============================================================================

scenarios <- list(
  # NOTE: All true_nABCD values computed via Monte Carlo (n=10^6) using
  # compute_nABCD() which correctly uses MIXTURE (pooled) IQR.
  # Previous hardcoded values used component IQR, causing systematic
  # negative bias for scenarios with location/scale shifts.
  # Fix applied: 2026-03-11 (see archive/appendix_b_corrected.md)
  S1 = list(
    name     = "Null (identical)",
    clinical = "Identical populations across regions",
    dist1    = function(n) rnorm(n, 50, 10),
    dist2    = function(n) rnorm(n, 50, 10),
    true_nABCD = 0  # Exact: identical distributions → W1 = 0
  ),
  S2 = list(
    name     = "Location (0.2 sigma)",
    clinical = "Age: EU vs US (~2yr mean difference, SD=10yr)",
    dist1    = function(n) rnorm(n, 50, 10),
    dist2    = function(n) rnorm(n, 52, 10),
    true_nABCD = NA  # Computed via Monte Carlo below (~0.074)
  ),
  S3 = list(
    name     = "Location (0.5 sigma)",
    clinical = "BMI: Japan vs EU (0.5 SD shift)",
    dist1    = function(n) rnorm(n, 50, 10),
    dist2    = function(n) rnorm(n, 55, 10),
    true_nABCD = NA  # Computed via Monte Carlo below (~0.180)
  ),
  S4 = list(
    name     = "Location (1.0 sigma)",
    clinical = "BMI: Japan vs US (1.0 SD shift)",
    dist1    = function(n) rnorm(n, 50, 10),
    dist2    = function(n) rnorm(n, 60, 10),
    true_nABCD = NA  # Computed via Monte Carlo below (~0.328)
  ),
  S5 = list(
    name     = "Scale (1.5x)",
    clinical = "HbA1c: strict vs broad inclusion criteria",
    dist1    = function(n) rnorm(n, 50, 10),
    dist2    = function(n) rnorm(n, 50, 15),
    true_nABCD = NA  # Computed via Monte Carlo below (~0.123)
  ),
  S6 = list(
    name     = "Skew (log-normal)",
    clinical = "ALT: liver function marker (log-normally distributed, CV ~ 53%)",
    dist1    = function(n) rnorm(n, 50, 10),
    dist2    = function(n) {
      # Log-normal with mean ~ 50, moderate right skew (CV ~ 53%)
      # ALT between-subject CV: 42-72% (Carobene 2013, Clin Chem Lab Med)
      # sigma_ln = 0.5 → CV = sqrt(exp(0.25)-1) ≈ 0.53, skewness ≈ 1.75
      sigma_ln <- 0.5
      mu_ln <- log(50) - sigma_ln^2 / 2
      rlnorm(n, meanlog = mu_ln, sdlog = sigma_ln)
    },
    true_nABCD = NA  # Computed via Monte Carlo below (~0.304)
  ),
  S7 = list(
    name     = "Location + Scale",
    clinical = "BMI: Japan (narrow) vs US (wide, shifted) — most realistic",
    dist1    = function(n) rnorm(n, 50, 10),
    dist2    = function(n) rnorm(n, 55, 15),
    true_nABCD = NA  # Computed via Monte Carlo below (~0.175)
  )
)

# --- Compute true nABCD for scenarios with NA ---
compute_true_values <- function(scenarios, n_mc = 1e6, seed = 12345) {
  set.seed(seed)
  for (id in names(scenarios)) {
    if (is.na(scenarios[[id]]$true_nABCD)) {
      x <- scenarios[[id]]$dist1(n_mc)
      y <- scenarios[[id]]$dist2(n_mc)
      scenarios[[id]]$true_nABCD <- round(compute_nABCD(x, y), 3)
      cat("  ", id, ": true nABCD =", scenarios[[id]]$true_nABCD, "\n")
    }
  }
  scenarios
}

# =============================================================================
# Simulation Runner
# =============================================================================

single_rep <- function(rep_id, scenario, n_per_group, B,
                       compute_bca = FALSE) {
  x <- scenario$dist1(n_per_group)
  y <- scenario$dist2(n_per_group)

  # Lazy-compile Rcpp in worker process (once per worker, ~5s).
  # Use get() to avoid futures capturing the stale main-session binding
  # of nABCD_bootstrap_cpp (whose .Call pointer is NULL in workers).
  use_cpp <- USE_RCPP && ensure_rcpp_in_worker(RCPP_FILE)

  if (use_cpp) {
    cpp_fn <- get("nABCD_bootstrap_cpp", envir = .GlobalEnv)
    cpp_fn(x, y, B = B, compute_bca = compute_bca)
  } else {
    nABCD_bootstrap_fast(x, y, B = B, compute_bca = compute_bca)
  }
}

run_scenario_v2 <- function(scenario, n_per_group, n_reps = 500, B = 2000,
                            delta_equiv = 0.15, delta_detect = 0.05,
                            compute_bca = FALSE) {

  n_cores <- nbrOfWorkers()
  cat("    [", n_reps, "reps x B=", B, ", workers=", n_cores, "]\n")

  # future.packages ensures Rcpp is loadable in workers for lazy-compile
  pkgs <- if (USE_RCPP) "Rcpp" else character(0)

  res_list <- future_lapply(seq_len(n_reps), single_rep,
                            scenario = scenario,
                            n_per_group = n_per_group,
                            B = B,
                            compute_bca = compute_bca,
                            future.seed = TRUE,
                            future.packages = pkgs)

  estimates  <- vapply(res_list, `[[`, numeric(1), "estimate")
  pct_lower  <- vapply(res_list, `[[`, numeric(1), "pct_lower")
  pct_upper  <- vapply(res_list, `[[`, numeric(1), "pct_upper")
  bca_lower  <- vapply(res_list, `[[`, numeric(1), "bca_lower")
  bca_upper  <- vapply(res_list, `[[`, numeric(1), "bca_upper")

  true_val <- scenario$true_nABCD

  bias    <- mean(estimates, na.rm = TRUE) - true_val
  rmse    <- sqrt(mean((estimates - true_val)^2, na.rm = TRUE))
  sd_est  <- sd(estimates, na.rm = TRUE)

  ci_widths <- pct_upper - pct_lower
  mean_ci_width <- mean(ci_widths, na.rm = TRUE)

  if (true_val > 0) {
    cov_pct <- mean(pct_lower <= true_val & true_val <= pct_upper, na.rm = TRUE)
    cov_bca <- mean(bca_lower <= true_val & true_val <= bca_upper, na.rm = TRUE)
  } else {
    cov_pct <- NA_real_
    cov_bca <- NA_real_
  }

  detect_pwr_pct <- mean(pct_lower > delta_detect, na.rm = TRUE)
  detect_pwr_bca <- mean(bca_lower > delta_detect, na.rm = TRUE)
  equiv_pwr_pct <- mean(pct_upper < delta_equiv, na.rm = TRUE)
  equiv_pwr_bca <- mean(bca_upper < delta_equiv, na.rm = TRUE)

  list(
    estimates = estimates,
    summary = list(
      mean_est = mean(estimates, na.rm = TRUE),
      sd_est = sd_est, bias = bias, rmse = rmse,
      mean_ci_width = mean_ci_width,
      cov_pct = cov_pct, cov_bca = cov_bca,
      detect_pwr_pct = detect_pwr_pct, detect_pwr_bca = detect_pwr_bca,
      equiv_pwr_pct  = equiv_pwr_pct,  equiv_pwr_bca  = equiv_pwr_bca
    )
  )
}

# =============================================================================
# Full Simulation
# =============================================================================

run_full_simulation_v2 <- function(n_reps = 500, B = 2000, seed = 42,
                                   n_cores = NULL, compute_bca = FALSE) {
  sample_sizes <- c(50, 100, 200)
  scenario_ids <- names(scenarios)

  if (is.null(n_cores)) {
    n_cores <- max(1, parallelly::availableCores() - 1)
  }
  if (n_cores > 1) {
    plan(multisession, workers = n_cores)
  } else {
    plan(sequential)
  }
  on.exit(plan(sequential), add = TRUE)

  set.seed(seed)

  # Compute true values for S6, S7
  cat("=== Computing true nABCD values (Monte Carlo) ===\n")
  scenarios <<- compute_true_values(scenarios)

  summary_table <- data.frame()

  cat("\n=== nABCD Simulation v2 (Refreshed Scenarios S1-S7) ===\n")
  cat("Reps:", n_reps, "| B:", B, "| Workers:", nbrOfWorkers(), "\n")
  cat("BCa:", ifelse(compute_bca, "ON", "OFF (Percentile only — faster)"), "\n")
  accel <- if (USE_RCPP) "Rcpp (C++)" else if (USE_RFAST) "Rfast" else "base R"
  cat("Accel:", accel, "\n")
  cat("Scenarios: S1-S7 (Null, Location x3, Scale, LogNormal, Location+Scale)\n")

  # --- Timing calibration (10 reps on first scenario) ---
  cat("Calibrating... ")
  t_cal <- proc.time()[3]
  cal_res <- run_scenario_v2(scenarios[[1]], 100, n_reps = 10, B = B,
                             compute_bca = compute_bca)
  t_per_rep <- (proc.time()[3] - t_cal) / 10
  n_cells <- length(scenario_ids) * length(sample_sizes)
  est_total <- t_per_rep * n_reps * n_cells / nbrOfWorkers()
  cat(sprintf("~%.1f s/rep, estimated total: %.0f min (%.1f hours)\n",
              t_per_rep, est_total / 60, est_total / 3600))

  cat("Start:", format(Sys.time(), "%H:%M:%S"), "\n\n")

  for (sc_id in scenario_ids) {
    sc <- scenarios[[sc_id]]
    cat("--- Scenario", sc_id, ":", sc$name,
        "(true =", sc$true_nABCD, ") ---\n")
    cat("    Clinical:", sc$clinical, "\n")

    for (n in sample_sizes) {
      cat("  n =", n, ":")
      t0 <- proc.time()[3]

      res <- run_scenario_v2(sc, n_per_group = n, n_reps = n_reps, B = B,
                              compute_bca = compute_bca)
      s <- res$summary
      elapsed <- round(proc.time()[3] - t0, 1)

      cat("    Bias=", sprintf("%+.4f", s$bias),
          " RMSE=", sprintf("%.4f", s$rmse),
          " SD=", sprintf("%.4f", s$sd_est),
          " CIw=", sprintf("%.4f", s$mean_ci_width), "\n")
      cat("    Cov  Pct=", sprintf("%.3f", ifelse(is.na(s$cov_pct), -1, s$cov_pct)),
          " BCa=", sprintf("%.3f", ifelse(is.na(s$cov_bca), -1, s$cov_bca)), "\n")
      cat("    Det  Pct=", sprintf("%.3f", s$detect_pwr_pct),
          "  [", elapsed, "s]\n")

      summary_table <- rbind(summary_table, data.frame(
        Scenario = sc_id, SampleSize = n, TrueNABCD = sc$true_nABCD,
        Bias = round(s$bias, 4), RMSE = round(s$rmse, 4), SD = round(s$sd_est, 4),
        MeanCIWidth = round(s$mean_ci_width, 4),
        Coverage_Pct = round(s$cov_pct, 3), Coverage_BCa = round(s$cov_bca, 3),
        DetectPower_Pct = round(s$detect_pwr_pct, 3), DetectPower_BCa = round(s$detect_pwr_bca, 3),
        EquivPower_Pct = round(s$equiv_pwr_pct, 3), EquivPower_BCa = round(s$equiv_pwr_bca, 3),
        stringsAsFactors = FALSE
      ))
    }
    cat("\n")
  }

  cat("End:", format(Sys.time(), "%H:%M:%S"), "\n")
  list(summary_table = summary_table)
}

save_results_v2 <- function(summary_table, filepath = "data/simulation_results_v2.csv") {
  dir.create(dirname(filepath), showWarnings = FALSE, recursive = TRUE)
  write.csv(summary_table, filepath, row.names = FALSE)
  cat("Saved:", filepath, "\n")
}

save_results <- save_results_v2

# =============================================================================
# Main Execution
# =============================================================================

if (interactive() || !exists("SKIP_SIMULATION")) {
  cat("\n========================================\n")
  cat("nABCD Simulation v2 (Refreshed Scenarios)\n")
  cat("========================================\n\n")

  N_REPS <- 10000  # Quick: 50,  Full: 10000
  B_BOOT <- 2000   # Quick: 500, Full: 2000
  SEED   <- 42

  results <- run_full_simulation_v2(n_reps = N_REPS, B = B_BOOT, seed = SEED)
  print(results$summary_table)
  save_results_v2(results$summary_table)

  cat("\n=== DONE ===\n")
}
