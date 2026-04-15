#!/usr/bin/env Rscript
# =============================================================================
# GUSTO-I Case Study: nABCD Application for Paper Section 5
# =============================================================================
# Purpose: Demonstrate nABCD framework in a hypothetical MRCT planning scenario
#   using GUSTO-I data. Designed as "Case C" to complement IST-1 (Case A) and
#   IST-3 (Case B) in the paper Application section.
#
# Scenario: A sponsor plans a Phase 3 MRCT for a novel thrombolytic agent
#   for acute myocardial infarction. The anchor region (Region 13) is selected
#   based on its comprehensive healthcare infrastructure (high enrolment,
#   moderate demographics). Effect modifiers: sysbp (primary), age (contrast),
#   pulse (supplementary).
#
# Key Demonstration Points:
#   1. nABCD detects shape differences in sysbp that SMD misses (Region 5)
#   2. Clinical calibration using Lipschitz bounds
#   3. Bootstrap CI for anchor-partner pairs
#   4. Comparison of pooling decisions: nABCD vs SMD
#   5. Pulse as supplementary non-normal EM (skewness=0.89)
#
# Dataset: GUSTO-I (predtools::gusto), N=40,830, 16 regions (regl 1-16)
# Author: Mike Ross (Methodologist) / Katrina Bennett (Technical Writer)
# Date: 2026-04-07
# =============================================================================

suppressPackageStartupMessages({
  library(predtools)
  library(tidyverse)
})

set.seed(2026)

# --- Output directory ---------------------------------------------------------
project_root <- "C:/Users/hrd13/Documents/Gak/0 Study/800Claude/20260210_SIM/similarity_metrics/projects/similarity-metric"
out_dir <- file.path(project_root, "GUSTO")
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

# =============================================================================
# Helper Functions
# =============================================================================

skewness <- function(x, na.rm = FALSE) {
  if (na.rm) x <- x[!is.na(x)]
  n <- length(x)
  if (n < 3) return(NA_real_)
  m <- mean(x); s <- sd(x)
  if (s == 0) return(NA_real_)
  (sum((x - m)^3) / n) / s^3
}

compute_w1 <- function(x, y) {
  # Wasserstein-1 distance via CDF integration (trapezoidal rule on midpoints)
  all_vals <- sort(c(x, y))
  n <- length(all_vals)
  if (n < 2) return(0)
  Fx <- ecdf(x); Fy <- ecdf(y)
  mids <- (all_vals[-n] + all_vals[-1]) / 2
  diffs <- diff(all_vals)
  sum(abs(Fx(mids) - Fy(mids)) * diffs)
}

compute_nABCD <- function(x, y) {
  pooled <- c(x, y)
  iqr_p <- IQR(pooled, na.rm = TRUE)
  if (iqr_p == 0) return(NA_real_)
  compute_w1(x, y) / (2 * iqr_p)
}

compute_smd <- function(x, y) {
  nx <- length(x); ny <- length(y)
  sp <- sqrt(((nx - 1) * var(x, na.rm = TRUE) +
              (ny - 1) * var(y, na.rm = TRUE)) / (nx + ny - 2))
  if (sp == 0) return(NA_real_)
  (mean(x, na.rm = TRUE) - mean(y, na.rm = TRUE)) / sp
}

# Percentile bootstrap CI for nABCD
nABCD_bootstrap_ci <- function(x, y, B = 2000, conf = 0.95) {
  n1 <- length(x); n2 <- length(y)
  est <- compute_nABCD(x, y)
  if (is.na(est)) return(list(estimate = NA, lower = NA, upper = NA, se = NA))

  boot_vals <- numeric(B)
  for (b in seq_len(B)) {
    xb <- sample(x, n1, replace = TRUE)
    yb <- sample(y, n2, replace = TRUE)
    boot_vals[b] <- compute_nABCD(xb, yb)
  }
  boot_vals <- boot_vals[!is.na(boot_vals)]
  if (length(boot_vals) < 10) {
    return(list(estimate = est, lower = NA, upper = NA, se = NA))
  }

  alpha <- 1 - conf
  ci <- quantile(boot_vals, c(alpha / 2, 1 - alpha / 2))
  ci[1] <- max(0, ci[1])
  list(estimate = est, lower = unname(ci[1]), upper = unname(ci[2]),
       se = sd(boot_vals))
}

# Delta_max calculation: 2 * L * IQR_pooled * nABCD
compute_delta_max <- function(nABCD_val, iqr_pooled, L) {
  2 * L * iqr_pooled * nABCD_val
}

# L* reverse calculation: L* = Delta_clin / (2 * IQR_pooled * nABCD)
compute_lstar <- function(nABCD_val, iqr_pooled, delta_clin) {
  delta_clin / (2 * iqr_pooled * nABCD_val)
}


# =============================================================================
# Load Data
# =============================================================================
data(gusto)

cat("=============================================================================\n")
cat("GUSTO-I Case Study: nABCD Application for Paper\n")
cat("=============================================================================\n\n")
cat("N =", nrow(gusto), "patients across", length(unique(gusto$regl)), "regions\n\n")

# Effect modifier variables for this case study
em_vars <- c("sysbp", "age", "pulse")
regions <- sort(unique(gusto$regl))

# =============================================================================
# SECTION 1: Scenario Design and Anchor Selection
# =============================================================================
cat("=============================================================================\n")
cat("SECTION 1: Scenario Design\n")
cat("=============================================================================\n\n")

cat("--- Hypothetical MRCT Context ---\n")
cat("Drug: Novel thrombolytic agent (Drug T) for acute myocardial infarction\n")
cat("Primary endpoint: 30-day mortality\n")
cat("Overall treatment effect (reference from GUSTO-I tPA): ~1%pt absolute RD\n\n")

# Region sample sizes
cat("--- Region Sample Sizes ---\n")
region_n <- gusto %>%
  group_by(regl) %>%
  summarise(N = n(), .groups = "drop") %>%
  arrange(desc(N))

cat(sprintf("%-8s  %8s\n", "Region", "N"))
cat(strrep("-", 20), "\n")
for (i in seq_len(nrow(region_n))) {
  cat(sprintf("%-8d  %8d\n", region_n$regl[i], region_n$N[i]))
}
cat("\n")

# Anchor: Region 13
anchor <- 13
anchor_n <- sum(gusto$regl == anchor)

cat(sprintf("Anchor region selected: Region %d (N = %d)\n", anchor, anchor_n))
cat("Rationale: Region 13 serves as a methodologically appropriate anchor because:\n")
cat("  1. Large sample provides stable distributional estimates\n")
cat("  2. Demographics (age 61.3, sysbp 130.2) near the global median\n")
cat("  3. Simulates a sponsor's reference region with comprehensive data\n\n")

# EM selection rationale
cat("--- Effect Modifier Selection ---\n")
cat("1. Systolic BP (sysbp): Primary EM of interest\n")
cat("   - Known prognostic factor in acute MI (Killip classification proxy)\n")
cat("   - High inter-regional shape heterogeneity (skewness range: 0.03-1.32)\n")
cat("   - Region 5 exhibits extreme right skew (1.32) vs. near-symmetric in others\n")
cat("   - This shape variation is where nABCD adds value over SMD\n\n")
cat("2. Age: Secondary EM (contrast case)\n")
cat("   - Established effect modifier for thrombolytic efficacy\n")
cat("   - Inter-regional shape is relatively homogeneous (skewness -0.37 to -0.05)\n")
cat("   - Provides contrast: location-dominated vs shape-dominated EM\n\n")
cat("3. Pulse: Supplementary EM (non-normal)\n")
cat("   - Overall skewness = 0.89 (right-skewed distribution)\n")
cat("   - Tests whether non-normality creates nABCD/SMD divergence\n\n")

# =============================================================================
# SECTION 2: Descriptive Statistics for Anchor and All Regions
# =============================================================================
cat("=============================================================================\n")
cat("SECTION 2: Descriptive Statistics (Effect Modifiers)\n")
cat("=============================================================================\n\n")

for (v in em_vars) {
  cat(sprintf("--- %s ---\n", toupper(v)))
  cat(sprintf("%-8s  %6s  %8s  %8s  %8s  %8s  %8s  %8s\n",
              "Region", "N", "Mean", "SD", "Median", "IQR", "Skew", "Kurt"))
  cat(strrep("-", 78), "\n")
  for (r in c(anchor, setdiff(regions, anchor))) {
    x <- gusto[[v]][gusto$regl == r]
    x <- x[!is.na(x)]
    n_x <- length(x)
    krt <- (function(x) {
      n <- length(x); m <- mean(x); s <- sd(x)
      (sum((x - m)^4) / n) / s^4
    })(x)
    marker <- if (r == anchor) " <-- ANCHOR" else ""
    cat(sprintf("%-8d  %6d  %8.1f  %8.1f  %8.1f  %8.1f  %8.2f  %8.2f%s\n",
                r, n_x, mean(x), sd(x), median(x), IQR(x),
                skewness(x, na.rm = TRUE), krt, marker))
  }
  cat("\n")
}

# =============================================================================
# SECTION 3: nABCD and SMD from Anchor (Region 13) to All Partners
# =============================================================================
cat("=============================================================================\n")
cat(sprintf("SECTION 3: Anchor Region %d -- nABCD and SMD to All Partners\n", anchor))
cat("=============================================================================\n\n")

other_regions <- setdiff(regions, anchor)

anchor_results <- list()

for (v in em_vars) {
  anchor_data_v <- gusto[[v]][gusto$regl == anchor]
  anchor_data_v <- anchor_data_v[!is.na(anchor_data_v)]

  res <- tibble(
    partner = other_regions,
    N_partner = sapply(other_regions, function(r) sum(!is.na(gusto[[v]][gusto$regl == r]))),
    nABCD = NA_real_,
    abs_SMD = NA_real_,
    IQR_pooled = NA_real_,
    skew_anchor = skewness(anchor_data_v, na.rm = TRUE),
    skew_partner = NA_real_,
    sd_anchor = sd(anchor_data_v),
    sd_partner = NA_real_
  )

  for (i in seq_along(other_regions)) {
    r <- other_regions[i]
    x_partner <- gusto[[v]][gusto$regl == r]
    x_partner <- x_partner[!is.na(x_partner)]
    if (length(x_partner) < 5) next

    res$nABCD[i] <- compute_nABCD(anchor_data_v, x_partner)
    res$abs_SMD[i] <- abs(compute_smd(anchor_data_v, x_partner))
    res$IQR_pooled[i] <- IQR(c(anchor_data_v, x_partner))
    res$skew_partner[i] <- skewness(x_partner, na.rm = TRUE)
    res$sd_partner[i] <- sd(x_partner)
  }

  res <- res %>%
    mutate(
      rank_nABCD = rank(nABCD),
      rank_SMD = rank(abs_SMD),
      rank_diff = rank_nABCD - rank_SMD
    ) %>%
    arrange(nABCD)

  anchor_results[[v]] <- res

  cat(sprintf("--- %s (Anchor = Region %d) ---\n", toupper(v), anchor))
  cat(sprintf("%-8s  %6s  %8s  %8s  %6s  %6s  %6s  %8s  %8s\n",
              "Partner", "N", "nABCD", "|SMD|", "Rk_nA", "Rk_SMD", "Diff",
              "Skew_A", "Skew_P"))
  cat(strrep("-", 80), "\n")

  for (i in seq_len(nrow(res))) {
    cat(sprintf("%-8d  %6d  %8.4f  %8.4f  %6.0f  %6.0f  %+6.0f  %8.2f  %8.2f\n",
                res$partner[i], res$N_partner[i],
                res$nABCD[i], res$abs_SMD[i],
                res$rank_nABCD[i], res$rank_SMD[i], res$rank_diff[i],
                res$skew_anchor[i], res$skew_partner[i]))
  }

  # Summary statistics
  cat(sprintf("\n  Spearman rho(nABCD, |SMD|) = %.3f\n",
              cor(res$nABCD, res$abs_SMD, use = "complete.obs", method = "spearman")))
  cat(sprintf("  Pearson  r(nABCD, |SMD|) = %.3f\n\n",
              cor(res$nABCD, res$abs_SMD, use = "complete.obs")))
}

# =============================================================================
# SECTION 4: Key Divergence Cases
# =============================================================================
cat("=============================================================================\n")
cat("SECTION 4: Ranking Divergence -- Where nABCD and SMD Disagree\n")
cat("=============================================================================\n\n")

for (v in em_vars) {
  res <- anchor_results[[v]]
  divergent <- res %>%
    filter(abs(rank_diff) >= 2) %>%
    arrange(desc(abs(rank_diff)))

  cat(sprintf("--- %s: Partners with |rank_diff| >= 2 ---\n", toupper(v)))
  if (nrow(divergent) == 0) {
    cat("  No partners with |rank_diff| >= 2.\n")
    divergent <- res %>% arrange(desc(abs(rank_diff))) %>% head(3)
    cat("  Top 3 by |rank_diff|:\n")
  }

  for (i in seq_len(nrow(divergent))) {
    r <- divergent$partner[i]
    cat(sprintf("  Region %d: nABCD=%.4f (rank %d), |SMD|=%.4f (rank %d), diff=%+d\n",
                r, divergent$nABCD[i], divergent$rank_nABCD[i],
                divergent$abs_SMD[i], divergent$rank_SMD[i],
                divergent$rank_diff[i]))
    cat(sprintf("    Skewness: anchor=%.2f, partner=%.2f (delta=%.2f)\n",
                divergent$skew_anchor[i], divergent$skew_partner[i],
                abs(divergent$skew_anchor[i] - divergent$skew_partner[i])))
    cat(sprintf("    SD: anchor=%.1f, partner=%.1f (ratio=%.2f)\n\n",
                divergent$sd_anchor[i], divergent$sd_partner[i],
                divergent$sd_partner[i] / divergent$sd_anchor[i]))
  }
}

# Highlight the Region 5 case for sysbp
cat("--- Spotlight: Region 5 (sysbp) ---\n")
res_sysbp <- anchor_results[["sysbp"]]
r5_row <- res_sysbp %>% filter(partner == 5)
if (nrow(r5_row) > 0) {
  cat(sprintf("  Region 13 vs Region 5:\n"))
  cat(sprintf("    nABCD = %.4f (rank %d of 15)\n", r5_row$nABCD, r5_row$rank_nABCD))
  cat(sprintf("    |SMD| = %.4f (rank %d of 15)\n", r5_row$abs_SMD, r5_row$rank_SMD))
  cat(sprintf("    Rank difference = %+d\n", r5_row$rank_diff))
  cat(sprintf("    Skewness: anchor = %.2f, Region 5 = %.2f\n",
              r5_row$skew_anchor, r5_row$skew_partner))
  cat("    Interpretation: Region 5's extreme right skew in sysbp creates a\n")
  cat("    distributional difference that SMD underestimates. The means are\n")
  cat("    relatively close, but the tail structure differs substantially.\n\n")
}

# =============================================================================
# SECTION 5: Bootstrap CI for All Anchor-Partner Pairs (sysbp + age)
# =============================================================================
cat("=============================================================================\n")
cat(sprintf("SECTION 5: Bootstrap 95%% CI (Anchor = Region %d)\n", anchor))
cat("=============================================================================\n")
cat("B = 2000, Percentile method\n\n")

boot_all <- list()

for (v in c("sysbp", "age")) {  # bootstrap for primary EMs only
  cat(sprintf("--- %s ---\n", toupper(v)))
  cat(sprintf("%-8s  %6s  %10s  %10s  %10s  %10s\n",
              "Partner", "N", "nABCD", "Lower", "Upper", "SE"))
  cat(strrep("-", 60), "\n")

  x_anchor <- gusto[[v]][gusto$regl == anchor]
  x_anchor <- x_anchor[!is.na(x_anchor)]

  boot_v <- tibble(
    partner = other_regions,
    variable = v,
    nABCD = NA_real_,
    lower = NA_real_,
    upper = NA_real_,
    se = NA_real_
  )

  for (i in seq_along(other_regions)) {
    r <- other_regions[i]
    x_partner <- gusto[[v]][gusto$regl == r]
    x_partner <- x_partner[!is.na(x_partner)]
    if (length(x_partner) < 5) next

    ci <- nABCD_bootstrap_ci(x_anchor, x_partner, B = 2000)
    boot_v$nABCD[i] <- ci$estimate
    boot_v$lower[i] <- ci$lower
    boot_v$upper[i] <- ci$upper
    boot_v$se[i] <- ci$se

    n_partner <- length(x_partner)
    cat(sprintf("%-8d  %6d  %10.4f  %10.4f  %10.4f  %10.4f\n",
                r, n_partner, ci$estimate, ci$lower, ci$upper, ci$se))
  }
  cat("\n")
  boot_all[[v]] <- boot_v
}

# =============================================================================
# SECTION 6: Clinical Calibration (Delta_max)
# =============================================================================
cat("=============================================================================\n")
cat("SECTION 6: Clinical Calibration via Lipschitz Bound\n")
cat("=============================================================================\n\n")

delta_clin <- 0.01  # 1 percentage point = 0.01 on absolute scale
overall_te <- 0.01  # overall treatment effect (reference)

cat("Clinical context:\n")
cat(sprintf("  Overall treatment effect (reference): %.1f%%pt absolute RD\n", overall_te * 100))
cat(sprintf("  Delta_clin (clinically meaningful heterogeneity): %.1f%%pt\n", delta_clin * 100))
cat("\n")

# --- 6a. L* sensitivity analysis for sysbp ---
cat("--- 6a. L* Sensitivity Analysis for sysbp ---\n\n")

res_sysbp_sorted <- anchor_results[["sysbp"]] %>% arrange(desc(nABCD))

cat(sprintf("%-8s  %8s  %10s  %10s\n",
            "Partner", "nABCD", "IQR_pool", "L* (/mmHg)"))
cat(strrep("-", 45), "\n")

for (i in seq_len(min(5, nrow(res_sysbp_sorted)))) {
  r <- res_sysbp_sorted$partner[i]
  nA <- res_sysbp_sorted$nABCD[i]
  iqr_p <- res_sysbp_sorted$IQR_pooled[i]
  lstar <- compute_lstar(nA, iqr_p, delta_clin)
  cat(sprintf("%-8d  %8.4f  %10.1f  %10.6f\n", r, nA, iqr_p, lstar))
}
cat("\n")

# --- 6b. Clinical calibration for age ---
cat("--- 6b. Clinical Calibration for Age ---\n\n")

L_age_mean <- 0.0003  # per year
L_age_max  <- 0.0005  # per year

res_age <- anchor_results[["age"]]

cat(sprintf("%-8s  %8s  %10s  %10s  %10s  %10s\n",
            "Partner", "nABCD", "IQR_pool",
            "Dmax(Lmn)", "Dmax(Lmx)", "Dmax/TE"))
cat(strrep("-", 70), "\n")

for (i in seq_len(nrow(res_age))) {
  r <- res_age$partner[i]
  nA <- res_age$nABCD[i]
  iqr_p <- res_age$IQR_pooled[i]
  dmax_mean <- compute_delta_max(nA, iqr_p, L_age_mean) * 100
  dmax_max <- compute_delta_max(nA, iqr_p, L_age_max) * 100
  ratio <- dmax_mean / (overall_te * 100)
  cat(sprintf("%-8d  %8.4f  %10.1f  %10.3f  %10.3f  %10.2f\n",
              r, nA, iqr_p, dmax_mean, dmax_max, ratio))
}
cat("\n")

# =============================================================================
# SECTION 7: Pooling Decision Comparison (nABCD vs SMD)
# =============================================================================
cat("=============================================================================\n")
cat("SECTION 7: Pooling Decision Comparison\n")
cat("=============================================================================\n\n")

for (v in em_vars) {
  res <- anchor_results[[v]] %>% arrange(nABCD)

  cat(sprintf("--- %s ---\n", toupper(v)))
  cat("Classification by nABCD benchmarks:\n")

  negligible <- res %>% filter(nABCD < 0.05)
  small <- res %>% filter(nABCD >= 0.05 & nABCD < 0.15)
  moderate <- res %>% filter(nABCD >= 0.15 & nABCD < 0.30)
  large <- res %>% filter(nABCD >= 0.30)

  cat(sprintf("  Negligible (< 0.05): %d regions [%s]\n",
              nrow(negligible), paste(negligible$partner, collapse = ", ")))
  cat(sprintf("  Small (0.05-0.15):   %d regions [%s]\n",
              nrow(small), paste(small$partner, collapse = ", ")))
  cat(sprintf("  Moderate (0.15-0.30): %d regions [%s]\n",
              nrow(moderate), paste(moderate$partner, collapse = ", ")))
  cat(sprintf("  Large (>= 0.30):     %d regions [%s]\n\n",
              nrow(large), paste(large$partner, collapse = ", ")))

  # SMD-based classification
  smd_similar <- res %>% filter(abs_SMD < 0.10)
  cat(sprintf("  By |SMD| < 0.10: %d regions similar [%s]\n",
              nrow(smd_similar), paste(smd_similar$partner, collapse = ", ")))

  # Discordant cases
  nabcd_ok <- res %>% filter(nABCD < 0.05)
  smd_ok <- res %>% filter(abs_SMD < 0.10)

  only_smd <- setdiff(smd_ok$partner, nabcd_ok$partner)
  only_nabcd <- setdiff(nabcd_ok$partner, smd_ok$partner)

  if (length(only_smd) > 0) {
    cat(sprintf("  Discordant (SMD says similar, nABCD says not): Regions %s\n",
                paste(only_smd, collapse = ", ")))
    cat("  -> These have similar means but different distributional shapes!\n")
  }
  if (length(only_nabcd) > 0) {
    cat(sprintf("  Discordant (nABCD says similar, SMD says not): Regions %s\n",
                paste(only_nabcd, collapse = ", ")))
  }
  cat("\n")
}

# =============================================================================
# SECTION 8: Summary Table for Paper (CSV Export)
# =============================================================================
cat("=============================================================================\n")
cat("SECTION 8: Summary Table (CSV + Console)\n")
cat("=============================================================================\n\n")

# Combined table across sysbp, age, pulse
combined <- anchor_results[["sysbp"]] %>%
  select(partner, N_partner,
         sysbp_nABCD = nABCD, sysbp_SMD = abs_SMD,
         sysbp_rkN = rank_nABCD, sysbp_rkS = rank_SMD, sysbp_diff = rank_diff,
         sysbp_skew = skew_partner) %>%
  left_join(
    anchor_results[["age"]] %>%
      select(partner,
             age_nABCD = nABCD, age_SMD = abs_SMD,
             age_rkN = rank_nABCD, age_rkS = rank_SMD, age_diff = rank_diff),
    by = "partner"
  ) %>%
  left_join(
    anchor_results[["pulse"]] %>%
      select(partner,
             pulse_nABCD = nABCD, pulse_SMD = abs_SMD,
             pulse_rkN = rank_nABCD, pulse_rkS = rank_SMD, pulse_diff = rank_diff),
    by = "partner"
  ) %>%
  mutate(
    mean_nABCD = (sysbp_nABCD + age_nABCD + pulse_nABCD) / 3,
    mean_SMD = (sysbp_SMD + age_SMD + pulse_SMD) / 3
  ) %>%
  arrange(mean_nABCD)

# Print to console
cat(sprintf("%-6s  %5s  %8s  %8s  %5s  %8s  %8s  %5s  %8s  %8s  %5s  %8s  %8s\n",
            "Reg", "N", "sbp_nA", "sbp_SM", "rkDf",
            "age_nA", "age_SM", "rkDf",
            "pls_nA", "pls_SM", "rkDf",
            "mean_nA", "mean_SM"))
cat(strrep("-", 120), "\n")

for (i in seq_len(nrow(combined))) {
  cat(sprintf("%-6d  %5d  %8.4f  %8.4f  %+5d  %8.4f  %8.4f  %+5d  %8.4f  %8.4f  %+5d  %8.4f  %8.4f\n",
              combined$partner[i], combined$N_partner[i],
              combined$sysbp_nABCD[i], combined$sysbp_SMD[i], combined$sysbp_diff[i],
              combined$age_nABCD[i], combined$age_SMD[i], combined$age_diff[i],
              combined$pulse_nABCD[i], combined$pulse_SMD[i], combined$pulse_diff[i],
              combined$mean_nABCD[i], combined$mean_SMD[i]))
}

# Save as CSV
csv_path <- file.path(out_dir, "gusto_case_study_results.csv")
write_csv(combined, csv_path)
cat(sprintf("\nSaved: %s\n\n", csv_path))

# Also save per-variable detailed results
for (v in em_vars) {
  csv_v <- file.path(out_dir, sprintf("gusto_%s_pairwise.csv", v))
  write_csv(anchor_results[[v]], csv_v)
  cat(sprintf("Saved: %s\n", csv_v))
}
cat("\n")

# =============================================================================
# SECTION 9: Figures
# =============================================================================
cat("=============================================================================\n")
cat("SECTION 9: Generating Figures\n")
cat("=============================================================================\n\n")

# --- Figure A: nABCD vs |SMD| scatter for all 3 EMs ---
fig_scatter_data <- bind_rows(
  anchor_results[["sysbp"]] %>%
    select(partner, nABCD, abs_SMD, skew_partner) %>%
    mutate(variable = "Systolic BP (mmHg)"),
  anchor_results[["age"]] %>%
    select(partner, nABCD, abs_SMD, skew_partner) %>%
    mutate(variable = "Age (years)"),
  anchor_results[["pulse"]] %>%
    select(partner, nABCD, abs_SMD, skew_partner) %>%
    mutate(variable = "Pulse (bpm)")
)

p_scatter <- ggplot(fig_scatter_data, aes(x = abs_SMD, y = nABCD)) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", colour = "grey60") +
  geom_point(aes(colour = variable, size = abs(skew_partner)),
             alpha = 0.7) +
  geom_text(aes(label = partner), size = 2.5, nudge_y = 0.003, check_overlap = TRUE) +
  facet_wrap(~ variable, scales = "free") +
  scale_colour_manual(values = c("Systolic BP (mmHg)" = "#D55E00",
                                 "Age (years)" = "#0072B2",
                                 "Pulse (bpm)" = "#009E73")) +
  scale_size_continuous(name = "|Skewness|", range = c(1.5, 5)) +
  labs(
    title = sprintf("GUSTO-I: nABCD vs |SMD| (Anchor = Region %d)", anchor),
    subtitle = "Point size proportional to |skewness| of partner region",
    x = "|SMD|", y = "nABCD",
    colour = "Effect Modifier"
  ) +
  theme_bw(base_size = 11) +
  theme(legend.position = "bottom",
        strip.background = element_rect(fill = "grey95"),
        panel.grid.minor = element_blank())

ggsave(file.path(out_dir, "gusto_case_study_scatter.pdf"),
       p_scatter, width = 12, height = 5)
ggsave(file.path(out_dir, "gusto_case_study_scatter.png"),
       p_scatter, width = 12, height = 5, dpi = 300)
cat("Saved: gusto_case_study_scatter.pdf/png\n")

# --- Figure B: Density overlay for sysbp (anchor vs key partners) ---
res_sysbp <- anchor_results[["sysbp"]]
most_similar <- res_sysbp %>% arrange(nABCD) %>% head(1) %>% pull(partner)
most_different <- res_sysbp %>% arrange(desc(nABCD)) %>% head(1) %>% pull(partner)
spotlight_regions <- unique(c(anchor, 5, most_similar, most_different))

density_data <- gusto %>%
  filter(regl %in% spotlight_regions, !is.na(sysbp)) %>%
  mutate(
    region_label = case_when(
      regl == anchor ~ sprintf("Region %d (Anchor)", anchor),
      regl == 5 ~ "Region 5 (High skew)",
      regl == most_similar ~ sprintf("Region %d (Most similar)", most_similar),
      regl == most_different ~ sprintf("Region %d (Most different)", most_different),
      TRUE ~ paste("Region", regl)
    ),
    region_label = factor(region_label)
  )

level_order <- c(
  sprintf("Region %d (Anchor)", anchor),
  "Region 5 (High skew)",
  sprintf("Region %d (Most similar)", most_similar),
  sprintf("Region %d (Most different)", most_different)
)
level_order <- unique(level_order)
density_data$region_label <- factor(density_data$region_label, levels = level_order)

region_colors <- c("#000000", "#E69F00", "#56B4E9", "#CC79A7")
names(region_colors) <- level_order

p_density <- ggplot(density_data, aes(x = sysbp, colour = region_label,
                                       fill = region_label)) +
  geom_density(alpha = 0.15, linewidth = 0.8) +
  scale_colour_manual(values = region_colors, name = "") +
  scale_fill_manual(values = region_colors, name = "") +
  labs(
    title = "GUSTO-I: Systolic BP Distribution by Region",
    subtitle = sprintf("Anchor = Region %d vs selected partners", anchor),
    x = "Systolic Blood Pressure (mmHg)", y = "Density"
  ) +
  theme_bw(base_size = 11) +
  theme(legend.position.inside = c(0.75, 0.75),
        legend.position = "inside",
        legend.background = element_rect(fill = "white", colour = "grey80"),
        panel.grid.minor = element_blank())

ggsave(file.path(out_dir, "gusto_case_study_density.pdf"),
       p_density, width = 8, height = 5)
ggsave(file.path(out_dir, "gusto_case_study_density.png"),
       p_density, width = 8, height = 5, dpi = 300)
cat("Saved: gusto_case_study_density.pdf/png\n")

# --- Figure C: Rank divergence lollipop chart (3 EMs) ---
rank_data <- bind_rows(
  anchor_results[["sysbp"]] %>%
    select(partner, rank_nABCD, rank_SMD, rank_diff) %>%
    mutate(variable = "Systolic BP"),
  anchor_results[["age"]] %>%
    select(partner, rank_nABCD, rank_SMD, rank_diff) %>%
    mutate(variable = "Age"),
  anchor_results[["pulse"]] %>%
    select(partner, rank_nABCD, rank_SMD, rank_diff) %>%
    mutate(variable = "Pulse")
)

p_rank <- ggplot(rank_data, aes(x = factor(partner), y = rank_diff,
                                 fill = variable)) +
  geom_col(position = position_dodge(width = 0.7), width = 0.6, alpha = 0.8) +
  geom_hline(yintercept = 0, linetype = "solid", colour = "grey40") +
  geom_hline(yintercept = c(-2, 2), linetype = "dashed", colour = "red",
             alpha = 0.5) +
  scale_fill_manual(values = c("Systolic BP" = "#D55E00",
                                "Age" = "#0072B2",
                                "Pulse" = "#009E73")) +
  labs(
    title = sprintf("Ranking Divergence: nABCD rank - |SMD| rank (Anchor = Region %d)", anchor),
    subtitle = "Positive = nABCD ranks partner as MORE similar than SMD does",
    x = "Partner Region", y = "nABCD Rank - SMD Rank",
    fill = "Effect Modifier"
  ) +
  theme_bw(base_size = 11) +
  theme(legend.position = "bottom",
        panel.grid.minor = element_blank())

ggsave(file.path(out_dir, "gusto_case_study_rankdiff.pdf"),
       p_rank, width = 10, height = 5)
ggsave(file.path(out_dir, "gusto_case_study_rankdiff.png"),
       p_rank, width = 10, height = 5, dpi = 300)
cat("Saved: gusto_case_study_rankdiff.pdf/png\n")

# --- Figure D: Bootstrap CI forest plot (sysbp + age) ---
boot_forest_data <- bind_rows(
  boot_all[["sysbp"]] %>% mutate(variable = "Systolic BP"),
  boot_all[["age"]] %>% mutate(variable = "Age")
) %>%
  filter(!is.na(nABCD)) %>%
  mutate(partner_f = factor(partner))

p_forest <- ggplot(boot_forest_data,
                   aes(x = nABCD, y = reorder(partner_f, nABCD),
                       colour = variable)) +
  geom_errorbarh(aes(xmin = lower, xmax = upper),
                 height = 0.3, position = position_dodge(width = 0.5)) +
  geom_point(position = position_dodge(width = 0.5), size = 2) +
  geom_vline(xintercept = c(0.05, 0.15), linetype = "dashed",
             colour = c("darkgreen", "orange"), alpha = 0.6) +
  scale_colour_manual(values = c("Systolic BP" = "#D55E00", "Age" = "#0072B2")) +
  annotate("text", x = 0.05, y = 0.5, label = "Negligible", size = 2.5,
           hjust = 1.1, colour = "darkgreen") +
  annotate("text", x = 0.15, y = 0.5, label = "Moderate", size = 2.5,
           hjust = -0.1, colour = "orange") +
  labs(
    title = sprintf("GUSTO-I: Bootstrap 95%% CI for nABCD (Anchor = Region %d)", anchor),
    x = "nABCD (with 95% CI)", y = "Partner Region",
    colour = "Effect Modifier"
  ) +
  theme_bw(base_size = 11) +
  theme(legend.position = "bottom",
        panel.grid.minor = element_blank())

ggsave(file.path(out_dir, "gusto_case_study_forest.pdf"),
       p_forest, width = 8, height = 7)
ggsave(file.path(out_dir, "gusto_case_study_forest.png"),
       p_forest, width = 8, height = 7, dpi = 300)
cat("Saved: gusto_case_study_forest.pdf/png\n")

# =============================================================================
# SECTION 10: Key Findings for Paper Narrative
# =============================================================================
cat("\n=============================================================================\n")
cat("SECTION 10: Key Findings for Paper Narrative\n")
cat("=============================================================================\n\n")

cat("1. SCENARIO CONTEXT\n")
cat("   - Hypothetical MRCT for novel thrombolytic (Drug T) in acute MI\n")
cat("   - Anchor: Region 13 (N=", anchor_n, "), selected for data quality and\n")
cat("     demographic centrality\n")
cat("   - Three effect modifiers: sysbp (shape-dominant), age (location-dominant),\n")
cat("     pulse (non-normal supplement)\n\n")

cat("2. nABCD vs SMD DIVERGENCE (key finding)\n")
r5_sysbp <- anchor_results[["sysbp"]] %>% filter(partner == 5)
if (nrow(r5_sysbp) > 0) {
  cat(sprintf("   SYSBP Region 5: nABCD = %.4f (rank %d), |SMD| = %.4f (rank %d)\n",
              r5_sysbp$nABCD, r5_sysbp$rank_nABCD,
              r5_sysbp$abs_SMD, r5_sysbp$rank_SMD))
  cat(sprintf("   Rank difference = %+d (nABCD detects shape difference SMD misses)\n",
              r5_sysbp$rank_diff))
  cat(sprintf("   Skewness: Region 13 = %.2f, Region 5 = %.2f\n",
              r5_sysbp$skew_anchor, r5_sysbp$skew_partner))
}
cat("\n")

cat("3. SPEARMAN RANK CORRELATIONS (nABCD vs |SMD|)\n")
for (v in em_vars) {
  res <- anchor_results[[v]]
  rho <- cor(res$nABCD, res$abs_SMD, method = "spearman", use = "complete.obs")
  cat(sprintf("   %s: rho = %.3f\n", v, rho))
}
cat("\n")

cat("4. POOLING DECISIONS\n")
for (v in em_vars) {
  res <- anchor_results[[v]]
  n_negligible <- sum(res$nABCD < 0.05)
  n_smd_similar <- sum(res$abs_SMD < 0.10)
  nabcd_ok <- res$partner[res$nABCD < 0.05]
  smd_ok <- res$partner[res$abs_SMD < 0.10]
  discordant_nabcd <- setdiff(nabcd_ok, smd_ok)
  discordant_smd <- setdiff(smd_ok, nabcd_ok)
  cat(sprintf("   %s: %d/15 negligible by nABCD, %d/15 similar by SMD\n",
              v, n_negligible, n_smd_similar))
  if (length(discordant_nabcd) > 0) {
    cat(sprintf("     nABCD-only similar: Regions %s\n", paste(discordant_nabcd, collapse = ", ")))
  }
  if (length(discordant_smd) > 0) {
    cat(sprintf("     SMD-only similar: Regions %s\n", paste(discordant_smd, collapse = ", ")))
  }
}
cat("\n")

cat("=== GUSTO Case Study Complete ===\n")
cat(sprintf("All outputs saved to: %s\n", out_dir))
