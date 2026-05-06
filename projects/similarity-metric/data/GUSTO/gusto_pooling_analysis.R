#!/usr/bin/env Rscript
# =============================================================================
# GUSTO-I: Pooling Partner Selection via nABCD
# =============================================================================
# Purpose: Demonstrate "pooling partner selection" scenario using GUSTO-I data
#   - Region A as anchor -> find most similar regions by EM distribution
#   - Compare nABCD vs SMD rankings
#   - Bootstrap CI for anchor region pairs
#
# Author: Mike Ross (Methodologist) / Katrina Bennett (Technical Writer)
# Date: 2026-04-05
# =============================================================================

suppressPackageStartupMessages({
  library(predtools)
  library(tidyverse)
})

set.seed(42)

# --- Helper functions --------------------------------------------------------
skewness <- function(x, na.rm = FALSE) {
  if (na.rm) x <- x[!is.na(x)]
  n <- length(x)
  m <- mean(x)
  s <- sd(x)
  if (s == 0) return(NA_real_)
  (sum((x - m)^3) / n) / s^3
}

compute_w1 <- function(x, y) {
  all_vals <- sort(c(x, y))
  n <- length(all_vals)
  if (n < 2) return(0)
  Fx <- ecdf(x)
  Fy <- ecdf(y)
  mids <- (all_vals[-n] + all_vals[-1]) / 2
  diffs <- diff(all_vals)
  sum(abs(Fx(mids) - Fy(mids)) * diffs)
}

compute_nABCD <- function(x, y) {
  pooled <- c(x, y)
  iqr_p <- IQR(pooled, na.rm = TRUE)
  if (iqr_p == 0) return(NA_real_)
  compute_w1(x, y) / iqr_p
}

compute_smd <- function(x, y) {
  nx <- length(x); ny <- length(y)
  sp <- sqrt(((nx - 1) * var(x, na.rm = TRUE) + (ny - 1) * var(y, na.rm = TRUE)) / (nx + ny - 2))
  if (sp == 0) return(NA_real_)
  (mean(x, na.rm = TRUE) - mean(y, na.rm = TRUE)) / sp
}

# Vectorized bootstrap CI for nABCD (percentile method)
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
  if (length(boot_vals) < 10) return(list(estimate = est, lower = NA, upper = NA, se = NA))

  alpha <- 1 - conf
  ci <- quantile(boot_vals, c(alpha / 2, 1 - alpha / 2))
  ci[1] <- max(0, ci[1])
  list(estimate = est, lower = unname(ci[1]), upper = unname(ci[2]), se = sd(boot_vals))
}

# --- Load data ---------------------------------------------------------------
data(gusto)
cat("=============================================================================\n")
cat("GUSTO-I Pooling Partner Selection Analysis\n")
cat("=============================================================================\n\n")
cat("N =", nrow(gusto), "patients across", length(unique(gusto$regl)), "regions\n\n")

vars <- c("age", "sysbp", "pulse", "height", "weight")
regions <- sort(unique(gusto$regl))
n_regions <- length(regions)

# =============================================================================
# SECTION 1: Sample size by region
# =============================================================================
cat("=============================================================================\n")
cat("SECTION 1: Sample Size by Region\n")
cat("=============================================================================\n\n")

region_n <- gusto %>%
  group_by(regl) %>%
  summarise(N = n(), .groups = "drop") %>%
  arrange(N)

cat(sprintf("%-8s  %8s\n", "Region", "N"))
cat(strrep("-", 20), "\n")
for (i in seq_len(nrow(region_n))) {
  cat(sprintf("%-8d  %8d\n", region_n$regl[i], region_n$N[i]))
}
cat("\n")

# Identify anchor: smallest region (simulating small-sample country)
anchor <- region_n$regl[1]
anchor_n <- region_n$N[1]
cat(sprintf("Anchor region selected: Region %d (N=%d) — smallest sample size\n", anchor, anchor_n))
cat("Rationale: Simulates a small-sample country seeking pooling partners\n\n")

# Also show descriptive stats for anchor
cat("Anchor region descriptive statistics:\n")
anchor_data <- gusto %>% filter(regl == anchor)
for (v in vars) {
  x <- anchor_data[[v]]
  x <- x[!is.na(x)]
  cat(sprintf("  %-8s: N=%d, mean=%.1f, sd=%.1f, median=%.1f, IQR=%.1f, skew=%.2f\n",
              v, length(x), mean(x), sd(x), median(x), IQR(x), skewness(x, na.rm = TRUE)))
}
cat("\n")

# =============================================================================
# SECTION 2: Full pairwise nABCD matrix (all 16 regions, all 5 variables)
# =============================================================================
cat("=============================================================================\n")
cat("SECTION 2: Pairwise nABCD and SMD (all region pairs)\n")
cat("=============================================================================\n\n")

pairs <- combn(regions, 2)
n_pairs <- ncol(pairs)
cat("Total pairwise comparisons:", n_pairs, "\n\n")

all_results <- list()

for (v in vars) {
  res <- tibble(
    region_i = pairs[1, ],
    region_j = pairs[2, ],
    nABCD = NA_real_,
    SMD = NA_real_,
    abs_SMD = NA_real_
  )

  for (k in seq_len(n_pairs)) {
    xi <- gusto[[v]][gusto$regl == pairs[1, k]]
    xj <- gusto[[v]][gusto$regl == pairs[2, k]]
    xi <- xi[!is.na(xi)]
    xj <- xj[!is.na(xj)]
    if (length(xi) < 5 || length(xj) < 5) next
    res$nABCD[k] <- compute_nABCD(xi, xj)
    res$SMD[k] <- compute_smd(xi, xj)
    res$abs_SMD[k] <- abs(res$SMD[k])
  }

  all_results[[v]] <- res
  cat(sprintf("--- %s ---\n", toupper(v)))
  cat(sprintf("  nABCD range: [%.4f, %.4f], median=%.4f\n",
              min(res$nABCD, na.rm = TRUE), max(res$nABCD, na.rm = TRUE),
              median(res$nABCD, na.rm = TRUE)))
  cat(sprintf("  |SMD| range: [%.4f, %.4f], median=%.4f\n",
              min(res$abs_SMD, na.rm = TRUE), max(res$abs_SMD, na.rm = TRUE),
              median(res$abs_SMD, na.rm = TRUE)))
}

# =============================================================================
# SECTION 3: Anchor region rankings (nABCD vs SMD)
# =============================================================================
cat("\n=============================================================================\n")
cat(sprintf("SECTION 3: Anchor Region %d — Pooling Partner Rankings\n", anchor))
cat("=============================================================================\n\n")

other_regions <- setdiff(regions, anchor)

for (v in vars) {
  res <- all_results[[v]]

  # Extract pairs involving anchor
  anchor_pairs <- res %>%
    filter(region_i == anchor | region_j == anchor) %>%
    mutate(
      partner = ifelse(region_i == anchor, region_j, region_i),
      rank_nABCD = rank(nABCD),
      rank_absSMD = rank(abs_SMD),
      rank_diff = rank_nABCD - rank_absSMD
    ) %>%
    arrange(nABCD)

  cat(sprintf("--- %s (Anchor = Region %d, N=%d) ---\n", toupper(v), anchor, anchor_n))
  cat(sprintf("%-8s  %8s  %8s  %8s  %6s  %6s  %6s\n",
              "Partner", "N_partner", "nABCD", "|SMD|", "Rk_nA", "Rk_SMD", "Diff"))
  cat(strrep("-", 65), "\n")

  for (i in seq_len(nrow(anchor_pairs))) {
    partner_n <- sum(gusto$regl == anchor_pairs$partner[i])
    cat(sprintf("%-8d  %8d  %8.4f  %8.4f  %6.0f  %6.0f  %+6.0f\n",
                anchor_pairs$partner[i],
                partner_n,
                anchor_pairs$nABCD[i],
                anchor_pairs$abs_SMD[i],
                anchor_pairs$rank_nABCD[i],
                anchor_pairs$rank_absSMD[i],
                anchor_pairs$rank_diff[i]))
  }
  cat("\n")
}

# =============================================================================
# SECTION 4: Multivariate summary — average nABCD across all EM variables
# =============================================================================
cat("=============================================================================\n")
cat(sprintf("SECTION 4: Multivariate Pooling Score (Anchor = Region %d)\n", anchor))
cat("=============================================================================\n")
cat("Average nABCD and |SMD| across all 5 EM variables per partner region\n\n")

multi_score <- tibble(partner = other_regions)

for (v in vars) {
  res <- all_results[[v]]
  anchor_sub <- res %>%
    filter(region_i == anchor | region_j == anchor) %>%
    mutate(partner = ifelse(region_i == anchor, region_j, region_i))

  multi_score <- multi_score %>%
    left_join(anchor_sub %>% select(partner, nABCD, abs_SMD) %>%
                rename(!!paste0(v, "_nABCD") := nABCD,
                       !!paste0(v, "_absSMD") := abs_SMD),
              by = "partner")
}

nABCD_cols <- paste0(vars, "_nABCD")
SMD_cols <- paste0(vars, "_absSMD")

multi_score <- multi_score %>%
  rowwise() %>%
  mutate(
    mean_nABCD = mean(c_across(all_of(nABCD_cols)), na.rm = TRUE),
    mean_absSMD = mean(c_across(all_of(SMD_cols)), na.rm = TRUE)
  ) %>%
  ungroup() %>%
  mutate(
    rank_nABCD = rank(mean_nABCD),
    rank_absSMD = rank(mean_absSMD),
    rank_diff = rank_nABCD - rank_absSMD
  ) %>%
  arrange(mean_nABCD)

cat(sprintf("%-8s  %8s  %10s  %10s  %6s  %6s  %6s\n",
            "Partner", "N", "mean_nABCD", "mean|SMD|", "Rk_nA", "Rk_SMD", "Diff"))
cat(strrep("-", 70), "\n")
for (i in seq_len(nrow(multi_score))) {
  partner_n <- sum(gusto$regl == multi_score$partner[i])
  cat(sprintf("%-8d  %8d  %10.4f  %10.4f  %6.0f  %6.0f  %+6.0f\n",
              multi_score$partner[i],
              partner_n,
              multi_score$mean_nABCD[i],
              multi_score$mean_absSMD[i],
              multi_score$rank_nABCD[i],
              multi_score$rank_absSMD[i],
              multi_score$rank_diff[i]))
}

# =============================================================================
# SECTION 5: Cases where nABCD and SMD rankings diverge
# =============================================================================
cat("\n=============================================================================\n")
cat("SECTION 5: Ranking Divergence Analysis (nABCD vs SMD)\n")
cat("=============================================================================\n")
cat("Partners where nABCD and |SMD| rankings differ substantially\n\n")

divergent <- multi_score %>%
  filter(abs(rank_diff) >= 3) %>%
  arrange(desc(abs(rank_diff)))

if (nrow(divergent) > 0) {
  cat("Partners with |rank_diff| >= 3:\n\n")
  for (i in seq_len(nrow(divergent))) {
    r <- divergent$partner[i]
    cat(sprintf("  Region %d: nABCD rank=%d, SMD rank=%d, diff=%+d\n",
                r, divergent$rank_nABCD[i], divergent$rank_absSMD[i],
                divergent$rank_diff[i]))
    # Show per-variable detail
    for (v in vars) {
      nA <- divergent[[paste0(v, "_nABCD")]][i]
      smd_val <- divergent[[paste0(v, "_absSMD")]][i]
      cat(sprintf("    %-8s: nABCD=%.4f, |SMD|=%.4f\n", v, nA, smd_val))
    }
    # Show shape difference
    anchor_vals <- gusto[[vars[1]]][gusto$regl == anchor]
    partner_vals <- gusto[[vars[1]]][gusto$regl == r]
    anchor_vals <- anchor_vals[!is.na(anchor_vals)]
    partner_vals <- partner_vals[!is.na(partner_vals)]
    cat(sprintf("    Skewness(anchor age)=%.2f vs Skewness(partner age)=%.2f\n",
                skewness(anchor_vals, na.rm = TRUE), skewness(partner_vals, na.rm = TRUE)))
    cat(sprintf("    SD(anchor age)=%.1f vs SD(partner age)=%.1f\n\n",
                sd(anchor_vals, na.rm = TRUE), sd(partner_vals, na.rm = TRUE)))
  }
} else {
  cat("No partners with |rank_diff| >= 3 found. Relaxing to >= 2:\n\n")
  divergent <- multi_score %>%
    filter(abs(rank_diff) >= 2) %>%
    arrange(desc(abs(rank_diff)))
  for (i in seq_len(nrow(divergent))) {
    r <- divergent$partner[i]
    cat(sprintf("  Region %d: nABCD rank=%d, SMD rank=%d, diff=%+d\n",
                r, divergent$rank_nABCD[i], divergent$rank_absSMD[i],
                divergent$rank_diff[i]))
  }
}

# Per-variable divergence detail
cat("\nPer-variable rank correlation (Spearman) between nABCD and |SMD| rankings:\n")
for (v in vars) {
  res <- all_results[[v]]
  anchor_sub <- res %>%
    filter(region_i == anchor | region_j == anchor)
  rho <- cor(anchor_sub$nABCD, anchor_sub$abs_SMD, use = "complete.obs", method = "spearman")
  cat(sprintf("  %-8s: rho = %.3f\n", v, rho))
}

# =============================================================================
# SECTION 6: Bootstrap CI for anchor pairs (top 5 + bottom 5)
# =============================================================================
cat("\n=============================================================================\n")
cat(sprintf("SECTION 6: Bootstrap 95%% CI for nABCD (Anchor = Region %d)\n", anchor))
cat("=============================================================================\n")
cat("B = 2000 bootstrap replicates, Percentile method\n")
cat("Computing for top-5 most similar and top-5 most different partners...\n\n")

# Select top 5 similar and top 5 different
top5_similar <- head(multi_score$partner, 5)
top5_different <- tail(multi_score$partner, 5)
boot_partners <- unique(c(top5_similar, top5_different))

boot_results <- list()

for (v in vars) {
  cat(sprintf("--- %s ---\n", toupper(v)))
  cat(sprintf("%-8s  %10s  %10s  %10s  %10s\n",
              "Partner", "nABCD", "Lower", "Upper", "SE"))
  cat(strrep("-", 55), "\n")

  for (r in boot_partners) {
    x_anchor <- gusto[[v]][gusto$regl == anchor]
    x_partner <- gusto[[v]][gusto$regl == r]
    x_anchor <- x_anchor[!is.na(x_anchor)]
    x_partner <- x_partner[!is.na(x_partner)]

    if (length(x_anchor) < 5 || length(x_partner) < 5) {
      cat(sprintf("%-8d  %10s  %10s  %10s  %10s\n", r, "NA", "NA", "NA", "NA"))
      next
    }

    ci <- nABCD_bootstrap_ci(x_anchor, x_partner, B = 2000)
    boot_results[[paste(v, r)]] <- ci
    cat(sprintf("%-8d  %10.4f  %10.4f  %10.4f  %10.4f\n",
                r, ci$estimate, ci$lower, ci$upper, ci$se))
  }
  cat("\n")
}

# =============================================================================
# SECTION 7: Comprehensive shape profile comparison
# =============================================================================
cat("=============================================================================\n")
cat("SECTION 7: Shape Profile — Anchor vs All Partners\n")
cat("=============================================================================\n\n")

cat(sprintf("%-8s  %6s", "Region", "N"))
for (v in vars) {
  cat(sprintf("  %8s  %8s  %8s", paste0(v, "_mean"), paste0(v, "_sd"), paste0(v, "_skew")))
}
cat("\n")
cat(strrep("-", 8 + 8 + 5 * (8 + 8 + 8 + 6)), "\n")

for (r in c(anchor, other_regions)) {
  rdata <- gusto %>% filter(regl == r)
  n_r <- nrow(rdata)
  cat(sprintf("%-8d  %6d", r, n_r))
  for (v in vars) {
    x <- rdata[[v]]
    x <- x[!is.na(x)]
    cat(sprintf("  %8.1f  %8.1f  %8.2f", mean(x), sd(x), skewness(x, na.rm = TRUE)))
  }
  if (r == anchor) cat("  <-- ANCHOR")
  cat("\n")
}

# =============================================================================
# SECTION 8: Pooling recommendation
# =============================================================================
cat("\n=============================================================================\n")
cat("SECTION 8: Pooling Recommendation\n")
cat("=============================================================================\n\n")

# Threshold: nABCD < 0.05 considered "similar"
threshold <- 0.05
cat(sprintf("Similarity threshold: nABCD < %.2f\n\n", threshold))

cat("--- Multivariate (average across 5 EM variables) ---\n")
similar <- multi_score %>% filter(mean_nABCD < threshold)
moderate <- multi_score %>% filter(mean_nABCD >= threshold & mean_nABCD < 0.10)
different <- multi_score %>% filter(mean_nABCD >= 0.10)

cat(sprintf("  Similar (nABCD < 0.05): %d regions\n", nrow(similar)))
if (nrow(similar) > 0) {
  cat(sprintf("    Regions: %s\n", paste(similar$partner, collapse = ", ")))
}
cat(sprintf("  Moderate (0.05 <= nABCD < 0.10): %d regions\n", nrow(moderate)))
if (nrow(moderate) > 0) {
  cat(sprintf("    Regions: %s\n", paste(moderate$partner, collapse = ", ")))
}
cat(sprintf("  Different (nABCD >= 0.10): %d regions\n", nrow(different)))
if (nrow(different) > 0) {
  cat(sprintf("    Regions: %s\n", paste(different$partner, collapse = ", ")))
}

# Compare with SMD-based recommendation
cat("\n--- Comparison with SMD-based selection ---\n")
smd_threshold <- 0.10
similar_smd <- multi_score %>% filter(mean_absSMD < smd_threshold)
cat(sprintf("  Similar by |SMD| < 0.10: %d regions (%s)\n",
            nrow(similar_smd), paste(similar_smd$partner, collapse = ", ")))

# Identify discordant cases
if (nrow(similar) > 0 && nrow(similar_smd) > 0) {
  only_nABCD <- setdiff(similar$partner, similar_smd$partner)
  only_SMD <- setdiff(similar_smd$partner, similar$partner)
  if (length(only_nABCD) > 0) {
    cat(sprintf("  Selected by nABCD only: Regions %s\n", paste(only_nABCD, collapse = ", ")))
  }
  if (length(only_SMD) > 0) {
    cat(sprintf("  Selected by SMD only: Regions %s\n", paste(only_SMD, collapse = ", ")))
    cat("  -> These regions may have similar means but different distribution shapes!\n")
  }
}

cat("\n=== Analysis complete ===\n")
