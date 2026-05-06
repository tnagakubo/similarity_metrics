# =============================================================================
# Louis Litt - Independent Replication of nABCD Simulation Study
# =============================================================================
# Purpose: Independently verify true nABCD values and simulation properties
#          reported in the EN paper (nABCD_wiley.tex)
#
# This is a CLEAN-ROOM replication: all functions written from scratch,
# no sourcing of existing project code.
#
# Date: 2026-04-04
# Validator: Louis Litt (Internal Critic)
# =============================================================================

cat("============================================================\n")
cat(" Louis Litt - Independent nABCD Replication\n")
cat(" 'You just got Litt up!'\n")
cat("============================================================\n\n")

set.seed(2026)

# =============================================================================
# PART 0: Independent Core Function Implementations
# =============================================================================

# Wasserstein-1 distance via numerical integration of |F(x) - G(x)|
# Using the midpoint rule on the combined sorted grid
louis_W1 <- function(x, y) {
  grid <- sort(c(x, y))
  ng <- length(grid)
  if (ng < 2) return(0)

  # Midpoints for better integration accuracy
  midpts <- (grid[-ng] + grid[-1]) / 2
  widths <- diff(grid)

  # Empirical CDFs evaluated at midpoints
  Fx <- ecdf(x)
  Gy <- ecdf(y)

  sum(abs(Fx(midpts) - Gy(midpts)) * widths)
}

# Alternative W1 for equal-sized sorted samples: quantile identity
# W1(F,G) = integral_0^1 |F^{-1}(u) - G^{-1}(u)| du
#          = (1/n) * sum |x_(i) - y_(i)| for equal-sized samples
louis_W1_quantile <- function(x_sorted, y_sorted) {
  mean(abs(x_sorted - y_sorted))
}

# IQR of pooled (mixture) sample
louis_mixture_IQR <- function(x, y) {
  pooled <- c(x, y)
  IQR(pooled)  # R default: type=7
}

# nABCD = W1(F1, F2) / IQR_mixture
louis_nABCD <- function(x, y) {
  iqr_mix <- louis_mixture_IQR(x, y)
  if (iqr_mix == 0) return(NA_real_)
  louis_W1(x, y) / iqr_mix
}

# =============================================================================
# PART 1: Verify W1 implementations agree
# =============================================================================

cat("=== PART 1: W1 Implementation Cross-Check ===\n\n")
set.seed(100)
test_x <- rnorm(500, 50, 10)
test_y <- rnorm(500, 55, 10)

w1_integral <- louis_W1(test_x, test_y)
w1_quantile <- louis_W1_quantile(sort(test_x), sort(test_y))

cat(sprintf("  W1 (midpoint integration): %.8f\n", w1_integral))
cat(sprintf("  W1 (quantile identity):    %.8f\n", w1_quantile))
cat(sprintf("  Absolute difference:       %.2e\n", abs(w1_integral - w1_quantile)))
cat(sprintf("  Relative difference:       %.2e\n", abs(w1_integral - w1_quantile) / w1_integral))

# Analytical check: W1(N(mu1,s), N(mu2,s)) = |mu1-mu2| for equal variance
cat("\n  Analytical check: W1(N(50,10), N(55,10)) should be ~5.0\n")
set.seed(101)
big_x <- rnorm(1e6, 50, 10)
big_y <- rnorm(1e6, 55, 10)
w1_big <- louis_W1_quantile(sort(big_x), sort(big_y))
cat(sprintf("  W1 (n=10^6): %.4f (expected: 5.0000)\n\n", w1_big))

# =============================================================================
# PART 2: Define Scenarios Independently
# =============================================================================

cat("=== PART 2: Scenario Definitions ===\n\n")

# S6 log-normal parametrization derivation:
# LogNormal(mu_ln, sigma_ln): mean = exp(mu_ln + sigma_ln^2/2)
# CV = sqrt(exp(sigma_ln^2) - 1)
# For CV ~ 0.53: sigma_ln^2 = log(1 + CV^2) = log(1 + 0.53^2) = log(1.2809) ~ 0.2476
#   -> sigma_ln ~ 0.498 ~ 0.5
# With sigma_ln = 0.5: CV = sqrt(exp(0.25) - 1) = sqrt(0.2840) = 0.5331
# For mean = 50: mu_ln = log(50) - sigma_ln^2/2 = log(50) - 0.125

sigma_ln_s6 <- 0.5
mu_ln_s6 <- log(50) - sigma_ln_s6^2 / 2
cv_s6 <- sqrt(exp(sigma_ln_s6^2) - 1)

cat(sprintf("  S6 LogNormal params: mu_ln = %.6f, sigma_ln = %.4f\n", mu_ln_s6, sigma_ln_s6))
cat(sprintf("  S6 E[X] = exp(mu_ln + sigma_ln^2/2) = exp(%.6f) = %.4f\n",
            mu_ln_s6 + sigma_ln_s6^2/2, exp(mu_ln_s6 + sigma_ln_s6^2/2)))
cat(sprintf("  S6 CV = %.4f (target: ~0.53)\n\n", cv_s6))

# Define all scenario generators
louis_scenarios <- list(
  S1 = list(
    label = "Null (identical)",
    gen1 = function(n) rnorm(n, 50, 10),
    gen2 = function(n) rnorm(n, 50, 10)
  ),
  S2 = list(
    label = "Location shift 0.2*sigma",
    gen1 = function(n) rnorm(n, 50, 10),
    gen2 = function(n) rnorm(n, 52, 10)
  ),
  S3 = list(
    label = "Location shift 0.5*sigma",
    gen1 = function(n) rnorm(n, 50, 10),
    gen2 = function(n) rnorm(n, 55, 10)
  ),
  S4 = list(
    label = "Location shift 1.0*sigma",
    gen1 = function(n) rnorm(n, 50, 10),
    gen2 = function(n) rnorm(n, 60, 10)
  ),
  S5 = list(
    label = "Scale 1.5x",
    gen1 = function(n) rnorm(n, 50, 10),
    gen2 = function(n) rnorm(n, 50, 15)
  ),
  S6 = list(
    label = "Skew (LogNormal, CV~53%)",
    gen1 = function(n) rnorm(n, 50, 10),
    gen2 = function(n) rlnorm(n, meanlog = mu_ln_s6, sdlog = sigma_ln_s6)
  ),
  S7 = list(
    label = "Location + Scale",
    gen1 = function(n) rnorm(n, 50, 10),
    gen2 = function(n) rnorm(n, 55, 15)
  )
)

# =============================================================================
# PART 3: Compute True nABCD via Monte Carlo (n_MC = 10^6)
# =============================================================================

cat("=== PART 3: True nABCD via Monte Carlo (n_MC = 10^6) ===\n\n")

n_MC <- 1e6

# Run MC computation with MULTIPLE seeds for robustness
seeds <- c(12345, 54321, 99999, 77777, 42)

n_sc <- length(louis_scenarios)
all_mc_results <- matrix(NA, nrow = length(seeds), ncol = n_sc)
colnames(all_mc_results) <- names(louis_scenarios)

for (s_idx in seq_along(seeds)) {
  set.seed(seeds[s_idx])
  for (sc_idx in seq_along(louis_scenarios)) {
    sc <- louis_scenarios[[sc_idx]]
    x_mc <- sc$gen1(n_MC)
    y_mc <- sc$gen2(n_MC)
    all_mc_results[s_idx, sc_idx] <- louis_nABCD(x_mc, y_mc)
  }
}

# Report per-seed results and average
cat("  Per-seed results (5 independent runs, each n=10^6):\n")
cat(sprintf("  %-6s", "Seed"))
for (nm in colnames(all_mc_results)) cat(sprintf(" %8s", nm))
cat("\n")

for (s_idx in seq_along(seeds)) {
  cat(sprintf("  %-6d", seeds[s_idx]))
  for (sc_idx in seq_len(n_sc)) {
    cat(sprintf(" %8.4f", all_mc_results[s_idx, sc_idx]))
  }
  cat("\n")
}

mc_mean <- colMeans(all_mc_results)
mc_sd   <- apply(all_mc_results, 2, sd)

cat(sprintf("\n  %-6s", "Mean"))
for (v in mc_mean) cat(sprintf(" %8.4f", v))
cat(sprintf("\n  %-6s", "SD"))
for (v in mc_sd) cat(sprintf(" %8.4f", v))
cat("\n")

# Rounded to 3 decimals (as reported in paper)
mc_rounded <- round(mc_mean, 3)
cat(sprintf("\n  %-6s", "Round3"))
for (v in mc_rounded) cat(sprintf(" %8.3f", v))
cat("\n\n")

# =============================================================================
# PART 4: Compare to EN and JA Paper Values
# =============================================================================

cat("=== PART 4: Comparison with Paper Values ===\n\n")

en_values <- c(S1=0.000, S2=0.073, S3=0.180, S4=0.328, S5=0.122, S6=0.304, S7=0.175)
ja_values <- c(S1=0.000, S2=0.074, S3=0.186, S4=0.372, S5=0.148, S6=0.302, S7=0.175)

cat(sprintf("  %-4s  %8s  %8s  %8s  %10s  %10s  %s\n",
            "ID", "Louis", "EN", "JA", "Diff_EN", "Diff_JA", "Match"))

match_en <- 0
match_ja <- 0

for (i in seq_len(n_sc)) {
  sc_name <- paste0("S", i)
  louis_val <- mc_rounded[i]
  en_val <- en_values[i]
  ja_val <- ja_values[i]

  diff_en <- abs(louis_val - en_val)
  diff_ja <- abs(louis_val - ja_val)

  # Determine which matches (tolerance: 0.002 for rounding at 3rd decimal)
  tol <- 0.002
  en_ok <- diff_en <= tol
  ja_ok <- diff_ja <= tol

  if (en_ok && !ja_ok) {
    verdict <- "EN CORRECT"
    match_en <- match_en + 1
  } else if (!en_ok && ja_ok) {
    verdict <- "JA CORRECT"
    match_ja <- match_ja + 1
  } else if (en_ok && ja_ok) {
    verdict <- "BOTH OK"
    match_en <- match_en + 1
    match_ja <- match_ja + 1
  } else {
    verdict <- "NEITHER (!)"
  }

  cat(sprintf("  %-4s  %8.3f  %8.3f  %8.3f  %10.4f  %10.4f  %s\n",
              sc_name, louis_val, en_val, ja_val, diff_en, diff_ja, verdict))
}

cat(sprintf("\n  EN matches: %d/%d\n", match_en, n_sc))
cat(sprintf("  JA matches: %d/%d\n\n", match_ja, n_sc))

# =============================================================================
# PART 5: Investigate the EN-vs-JA Discrepancy Mechanism
# =============================================================================

cat("=== PART 5: Discrepancy Analysis (Mixture IQR vs Component IQR) ===\n\n")

# The JA values might use COMPONENT IQR (average of individual IQRs) instead of
# MIXTURE IQR (IQR of the pooled distribution). Let's check.

set.seed(12345)
cat("  Testing hypothesis: JA uses mean of component IQRs, EN uses mixture IQR\n\n")

cat(sprintf("  %-4s  %10s  %10s  %10s  %10s  %10s\n",
            "ID", "W1", "IQR_mix", "IQR_comp", "nABCD_mix", "nABCD_comp"))

for (i in seq_len(n_sc)) {
  sc <- louis_scenarios[[i]]
  x <- sc$gen1(n_MC)
  y <- sc$gen2(n_MC)

  w1 <- louis_W1_quantile(sort(x), sort(y))
  iqr_mix <- IQR(c(x, y))
  iqr_comp <- (IQR(x) + IQR(y)) / 2

  nabcd_mix <- w1 / iqr_mix
  nabcd_comp <- w1 / iqr_comp

  cat(sprintf("  S%-3d  %10.4f  %10.4f  %10.4f  %10.4f  %10.4f\n",
              i, w1, iqr_mix, iqr_comp, nabcd_mix, nabcd_comp))
}

cat("\n  Note: If JA values match nABCD_comp, the JA version used component-average IQR.\n")
cat("  The CORRECT definition (per paper) uses MIXTURE IQR.\n\n")

# =============================================================================
# PART 6: Mini Simulation (500 reps, n=100) - Bias & Coverage
# =============================================================================

cat("=== PART 6: Mini Simulation (500 reps, n=100, B_boot=1000) ===\n\n")

# VECTORIZED Percentile bootstrap for nABCD
# Uses matrix operations: generate all B bootstrap samples as columns,
# sort columns, then compute W1 and IQR per column via vectorized ops.
louis_bootstrap_vec <- function(x, y, B = 1000, conf = 0.95) {
  n1 <- length(x)
  n2 <- length(y)
  n_total <- n1 + n2

  # Point estimate
  est <- louis_nABCD(x, y)
  if (is.na(est)) return(list(estimate = NA, lower = NA, upper = NA))

  # Generate all bootstrap index matrices at once
  idx_x <- matrix(sample.int(n1, n1 * B, replace = TRUE), nrow = n1, ncol = B)
  idx_y <- matrix(sample.int(n2, n2 * B, replace = TRUE), nrow = n2, ncol = B)

  # Build bootstrap sample matrices
  x_boot <- matrix(x[idx_x], nrow = n1, ncol = B)
  y_boot <- matrix(y[idx_y], nrow = n2, ncol = B)

  # Sort each column (equal n, so quantile identity applies)
  x_sorted <- apply(x_boot, 2, sort)
  y_sorted <- apply(y_boot, 2, sort)

  # W1 per bootstrap = colMeans(|x_sorted - y_sorted|) for equal n
  w1_boot <- colMeans(abs(x_sorted - y_sorted))

  # IQR per bootstrap: sort pooled, extract Q1 and Q3
  pooled_boot <- rbind(x_boot, y_boot)
  pooled_sorted <- apply(pooled_boot, 2, sort)

  # Quantile type=7 indices (R default)
  h1 <- (n_total - 1) * 0.25 + 1
  h3 <- (n_total - 1) * 0.75 + 1
  f1 <- floor(h1); f3 <- floor(h3)
  q1 <- pooled_sorted[f1, ] + (h1 - f1) * (pooled_sorted[f1 + 1L, ] - pooled_sorted[f1, ])
  q3 <- pooled_sorted[f3, ] + (h3 - f3) * (pooled_sorted[f3 + 1L, ] - pooled_sorted[f3, ])
  iqr_boot <- q3 - q1

  # nABCD per bootstrap
  valid <- iqr_boot > 0
  boot_nabcd <- rep(NA_real_, B)
  boot_nabcd[valid] <- w1_boot[valid] / iqr_boot[valid]
  bv <- boot_nabcd[!is.na(boot_nabcd)]

  if (length(bv) < 10) return(list(estimate = est, lower = NA, upper = NA))

  alpha <- 1 - conf
  ci <- quantile(bv, c(alpha/2, 1 - alpha/2))
  ci[1] <- max(0, ci[1])

  list(estimate = est, lower = unname(ci[1]), upper = unname(ci[2]))
}

# Use true values from Part 3 (mean of 5 MC runs) for the simulation
true_vals <- mc_mean

N_REPS <- 500
N_PER_GROUP <- 100
B_BOOT <- 1000

cat(sprintf("  Settings: %d reps, n=%d per group, B=%d bootstrap, percentile CI\n\n",
            N_REPS, N_PER_GROUP, B_BOOT))

sim_results <- data.frame(
  Scenario = character(),
  TrueNABCD = numeric(),
  MeanEst = numeric(),
  Bias = numeric(),
  RMSE = numeric(),
  SD = numeric(),
  Coverage = numeric(),
  MeanCIWidth = numeric(),
  stringsAsFactors = FALSE
)

set.seed(2026)

for (sc_idx in seq_len(n_sc)) {
  sc_name <- paste0("S", sc_idx)
  sc <- louis_scenarios[[sc_idx]]
  true_val <- true_vals[sc_idx]

  cat(sprintf("  Running %s (%s, true=%.4f)...\n", sc_name, sc$label, true_val))
  flush.console()

  estimates <- numeric(N_REPS)
  lower_ci <- numeric(N_REPS)
  upper_ci <- numeric(N_REPS)

  t0 <- proc.time()[3]

  for (r in 1:N_REPS) {
    x <- sc$gen1(N_PER_GROUP)
    y <- sc$gen2(N_PER_GROUP)

    res <- louis_bootstrap_vec(x, y, B = B_BOOT)
    estimates[r] <- res$estimate
    lower_ci[r] <- res$lower
    upper_ci[r] <- res$upper
  }

  elapsed <- round(proc.time()[3] - t0, 1)

  # Compute metrics
  mean_est <- mean(estimates, na.rm = TRUE)
  bias <- mean_est - true_val
  rmse <- sqrt(mean((estimates - true_val)^2, na.rm = TRUE))
  sd_est <- sd(estimates, na.rm = TRUE)

  # Coverage (skip S1 where true~0)
  if (true_val > 0.001) {
    coverage <- mean(lower_ci <= true_val & true_val <= upper_ci, na.rm = TRUE)
  } else {
    coverage <- NA
  }

  ci_width <- mean(upper_ci - lower_ci, na.rm = TRUE)

  sim_results <- rbind(sim_results, data.frame(
    Scenario = sc_name,
    TrueNABCD = round(true_val, 4),
    MeanEst = round(mean_est, 4),
    Bias = round(bias, 4),
    RMSE = round(rmse, 4),
    SD = round(sd_est, 4),
    Coverage = round(coverage, 3),
    MeanCIWidth = round(ci_width, 4),
    stringsAsFactors = FALSE
  ))

  cat(sprintf("    Bias=%+.4f  RMSE=%.4f  SD=%.4f  Cov=%.3f  CIw=%.4f  [%.1fs]\n",
              bias, rmse, sd_est,
              ifelse(is.na(coverage), -1, coverage),
              ci_width, elapsed))
}

cat("\n--- Full Simulation Results Table ---\n")
print(sim_results, row.names = FALSE)

# =============================================================================
# PART 7: Final Verdict
# =============================================================================

cat("\n")
cat("============================================================\n")
cat(" PART 7: LOUIS LITT'S INDEPENDENT VERDICT\n")
cat("============================================================\n\n")

# Restate comparison
cat("True nABCD values (Louis MC mean of 5 seeds, n=10^6 each):\n")
for (i in seq_len(n_sc)) {
  sc_name <- paste0("S", i)
  cat(sprintf("  %s: %.4f (rounded: %.3f)\n", sc_name, mc_mean[i], mc_rounded[i]))
}

cat("\nEN paper values: ")
cat(paste(sprintf("%.3f", en_values), collapse=", "))
cat("\nJA paper values: ")
cat(paste(sprintf("%.3f", ja_values), collapse=", "))
cat("\nLouis values:    ")
cat(paste(sprintf("%.3f", mc_rounded), collapse=", "))
cat("\n")

# Final determination
cat("\n--- DETERMINATION ---\n\n")

for (i in seq_len(n_sc)) {
  sc_name <- paste0("S", i)
  en_match <- abs(mc_rounded[i] - en_values[i]) <= 0.002
  ja_match <- abs(mc_rounded[i] - ja_values[i]) <= 0.002

  status <- if (en_match && ja_match) "BOTH MATCH"
            else if (en_match) "EN CORRECT"
            else if (ja_match) "JA CORRECT"
            else "DISCREPANT"

  cat(sprintf("  %s: Louis=%.3f  EN=%.3f  JA=%.3f  -> %s\n",
              sc_name, mc_rounded[i], en_values[i], ja_values[i], status))
}

cat("\n--- SIMULATION QUALITY CHECK ---\n\n")

# Check bias: should be small relative to true value
cat("  Bias check (expect |bias| < 0.01 for most scenarios):\n")
for (i in 1:nrow(sim_results)) {
  bias_ok <- abs(sim_results$Bias[i]) < 0.01
  cat(sprintf("    %s: Bias=%+.4f  %s\n",
              sim_results$Scenario[i], sim_results$Bias[i],
              ifelse(bias_ok, "OK", "NOTABLE")))
}

cat("\n  Coverage check (expect ~0.95 for S2-S7):\n")
for (i in 1:nrow(sim_results)) {
  if (!is.na(sim_results$Coverage[i])) {
    cov_ok <- sim_results$Coverage[i] >= 0.90 && sim_results$Coverage[i] <= 0.99
    cat(sprintf("    %s: Coverage=%.3f  %s\n",
                sim_results$Scenario[i], sim_results$Coverage[i],
                ifelse(cov_ok, "OK", "CHECK")))
  }
}

cat("\n============================================================\n")
cat(" End of Louis Litt's Independent Replication\n")
cat(" 'Results speak louder than promises.'\n")
cat("============================================================\n")
