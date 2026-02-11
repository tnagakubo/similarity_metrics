# =============================================================================
# nABCD Simulation Study - Version 2 (Optimized + future.apply)
# Authors: Mike Ross (C-5, optimization), Katrina Bennett (C-3 BCa)
# Date: 2026-02-08
#
# Post External Review Fixes:
#   C-3: BCa bootstrap (bias-corrected & accelerated)
#   C-5: Equivalence power (upper CI < delta) + detection power
#   C-4: B unified (default 2000)
#   M-4: RMSE, SD reported
#
# Parallelization: future.apply (Bengtsson 2021, R Journal)
#   - Cross-platform (no manual Unix/Windows branching)
#   - L'Ecuyer-CMRG RNG via future.seed = TRUE
#   - plan(multisession) for PSOCK workers
# =============================================================================

library(stats)
library(future.apply)

# =============================================================================
# Core Functions (Vectorized)
# =============================================================================

#' Wasserstein-1 distance - VECTORIZED
#' Uses sorted order statistics and vectorized ecdf evaluation
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

#' Compute nABCD - optimized
compute_nABCD <- function(x, y) {
  pooled <- c(x, y)
  iqr_pooled <- IQR(pooled)
  if (iqr_pooled == 0) return(NA_real_)
  wasserstein1(x, y) / (2 * iqr_pooled)
}

# =============================================================================
# [C-3] BCa Bootstrap - Optimized (Katrina)
# =============================================================================

#' BCa Bootstrap CI for nABCD
#' @param x sample 1
#' @param y sample 2
#' @param B number of bootstrap replicates (C-4: default 2000)
#' @param conf confidence level
#' @return list with estimate, percentile CI, BCa CI, se
nABCD_bootstrap_bca <- function(x, y, B = 2000, conf = 0.95) {
  n1 <- length(x)
  n2 <- length(y)
  est <- compute_nABCD(x, y)

  # --- Bootstrap replicates (vectorized) ---
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

  # --- Percentile CI ---
  pct_ci <- quantile(boot_vals, c(alpha / 2, 1 - alpha / 2))
  pct_ci[1] <- max(0, pct_ci[1])

  # --- BCa: Bias correction z0 ---
  z0 <- qnorm(mean(boot_vals < est))

  # --- BCa: Acceleration via jackknife (vectorized) ---
  jack_x <- vapply(seq_len(n1), function(i) compute_nABCD(x[-i], y), numeric(1))
  jack_y <- vapply(seq_len(n2), function(j) compute_nABCD(x, y[-j]), numeric(1))
  jack_vals <- c(jack_x, jack_y)
  jack_vals <- jack_vals[!is.na(jack_vals)]

  jack_mean <- mean(jack_vals)
  d <- jack_mean - jack_vals
  denom <- 6 * (sum(d^2))^(3 / 2)
  acc <- if (abs(denom) < 1e-15) 0 else sum(d^3) / denom

  # --- BCa: Adjusted quantiles ---
  z_lo <- qnorm(alpha / 2)
  z_hi <- qnorm(1 - alpha / 2)

  adj_lo <- pnorm(z0 + (z0 + z_lo) / (1 - acc * (z0 + z_lo)))
  adj_hi <- pnorm(z0 + (z0 + z_hi) / (1 - acc * (z0 + z_hi)))

  # Clamp
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
# Scenario Definitions
# =============================================================================

scenarios <- list(
  S01 = list(name = "Null",
    dist1 = function(n) rnorm(n, 50, 10),
    dist2 = function(n) rnorm(n, 50, 10),
    true_nABCD = 0.000),
  S03 = list(name = "Location 0.2s",
    dist1 = function(n) rnorm(n, 50, 10),
    dist2 = function(n) rnorm(n, 52, 10),
    true_nABCD = 0.074),
  S04 = list(name = "Location 0.5s",
    dist1 = function(n) rnorm(n, 50, 10),
    dist2 = function(n) rnorm(n, 55, 10),
    true_nABCD = 0.186),
  S05 = list(name = "Location 1.0s",
    dist1 = function(n) rnorm(n, 50, 10),
    dist2 = function(n) rnorm(n, 60, 10),
    true_nABCD = 0.372),
  S06 = list(name = "Scale 1.5x",
    dist1 = function(n) rnorm(n, 50, 10),
    dist2 = function(n) rnorm(n, 50, 15),
    true_nABCD = 0.148),
  S08 = list(name = "Shape",
    dist1 = function(n) rnorm(n, 50, 10),
    dist2 = function(n) rgamma(n, shape = 25, rate = 0.5),
    true_nABCD = 0.067)
)

# =============================================================================
# [C-5] Simulation Runner with BOTH test directions (Mike)
# =============================================================================

#' Single replication
single_rep <- function(rep_id, scenario, n_per_group, B) {
  x <- scenario$dist1(n_per_group)
  y <- scenario$dist2(n_per_group)
  nABCD_bootstrap_bca(x, y, B = B)
}

#' Run simulation for one scenario
run_scenario_v2 <- function(scenario, n_per_group, n_reps = 500, B = 2000,
                            delta_equiv = 0.15, delta_detect = 0.05) {

  n_cores <- nbrOfWorkers()
  cat("    [", n_reps, "reps x B=", B, ", workers=", n_cores, "]\n")

  # --- Run replications (future.apply handles parallelization) ---
  res_list <- future_lapply(seq_len(n_reps), single_rep,
                            scenario = scenario,
                            n_per_group = n_per_group,
                            B = B,
                            future.seed = TRUE)

  # --- Extract results ---
  estimates  <- vapply(res_list, `[[`, numeric(1), "estimate")
  pct_lower  <- vapply(res_list, `[[`, numeric(1), "pct_lower")
  pct_upper  <- vapply(res_list, `[[`, numeric(1), "pct_upper")
  bca_lower  <- vapply(res_list, `[[`, numeric(1), "bca_lower")
  bca_upper  <- vapply(res_list, `[[`, numeric(1), "bca_upper")

  true_val <- scenario$true_nABCD

  # --- Point estimation (M-4) ---
  bias    <- mean(estimates, na.rm = TRUE) - true_val
  rmse    <- sqrt(mean((estimates - true_val)^2, na.rm = TRUE))
  sd_est  <- sd(estimates, na.rm = TRUE)

  # --- CI Width ---
  ci_widths <- pct_upper - pct_lower
  mean_ci_width <- mean(ci_widths, na.rm = TRUE)

  # --- Coverage ---
  if (true_val > 0) {
    cov_pct <- mean(pct_lower <= true_val & true_val <= pct_upper, na.rm = TRUE)
    cov_bca <- mean(bca_lower <= true_val & true_val <= bca_upper, na.rm = TRUE)
  } else {
    cov_pct <- NA_real_
    cov_bca <- NA_real_
  }

  # --- [C-5] Detection Power: H0: nABCD <= delta_detect ---
  #     Reject if lower CI > delta_detect
  detect_pwr_pct <- mean(pct_lower > delta_detect, na.rm = TRUE)
  detect_pwr_bca <- mean(bca_lower > delta_detect, na.rm = TRUE)

  # --- [C-5] Equivalence Power: H0: nABCD >= delta_equiv ---
  #     Reject if upper CI < delta_equiv
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
                                   n_cores = NULL) {
  sample_sizes <- c(50, 100, 200)
  scenario_ids <- c("S01", "S03", "S04", "S05", "S06", "S08")

  # --- Set up parallel backend ---
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

  summary_table <- data.frame()

  cat("=== nABCD Simulation v2 (future.apply) ===\n")
  cat("Reps:", n_reps, "| B:", B, "| Workers:", nbrOfWorkers(), "\n")
  cat("Fixes: C-3(BCa) C-5(equiv) C-4(B) M-4(RMSE)\n")
  cat("RNG: L'Ecuyer-CMRG via future.seed\n")
  cat("Start:", format(Sys.time(), "%H:%M:%S"), "\n\n")

  for (sc_id in scenario_ids) {
    sc <- scenarios[[sc_id]]
    cat("--- Scenario", sc_id, ":", sc$name, "(true =", sc$true_nABCD, ") ---\n")

    for (n in sample_sizes) {
      cat("  n =", n, ":")
      t0 <- proc.time()[3]

      res <- run_scenario_v2(sc, n_per_group = n, n_reps = n_reps, B = B)
      s <- res$summary
      elapsed <- round(proc.time()[3] - t0, 1)

      cat("    Bias=", sprintf("%+.4f", s$bias),
          " RMSE=", sprintf("%.4f", s$rmse),
          " SD=", sprintf("%.4f", s$sd_est),
          " CIw=", sprintf("%.4f", s$mean_ci_width), "\n")
      cat("    Cov  Pct=", sprintf("%.3f", ifelse(is.na(s$cov_pct), -1, s$cov_pct)),
          " BCa=", sprintf("%.3f", ifelse(is.na(s$cov_bca), -1, s$cov_bca)), "\n")
      cat("    Det  Pct=", sprintf("%.3f", s$detect_pwr_pct),
          " BCa=", sprintf("%.3f", s$detect_pwr_bca), "\n")
      cat("    Eqv  Pct=", sprintf("%.3f", s$equiv_pwr_pct),
          " BCa=", sprintf("%.3f", s$equiv_pwr_bca),
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

# Alias for backward compatibility with run_all.R
save_results <- save_results_v2

# =============================================================================
# Main Execution
# =============================================================================

if (interactive() || !exists("SKIP_SIMULATION")) {
  cat("\n========================================\n")
  cat("nABCD Simulation v2\n")
  cat("========================================\n\n")

  # --- Adjust these for quick vs full ---
  N_REPS <- 10000  # Quick: 50,  Full: 10000
  B_BOOT <- 2000   # Quick: 500, Full: 2000
  SEED   <- 42

  results <- run_full_simulation_v2(n_reps = N_REPS, B = B_BOOT, seed = SEED)
  print(results$summary_table)
  save_results_v2(results$summary_table)

  cat("\n=== DONE ===\n")
}
