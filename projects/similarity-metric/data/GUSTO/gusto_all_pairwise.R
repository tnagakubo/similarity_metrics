#!/usr/bin/env Rscript
# =============================================================================
# GUSTO-I: All Pairwise nABCD and SMD (16 regions, 120 pairs)
# =============================================================================
suppressPackageStartupMessages({
  library(predtools)
  library(tidyverse)
})

data(gusto)

# --- Helper functions --------------------------------------------------------
compute_w1 <- function(x, y) {
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
  compute_w1(x, y) / iqr_p
}

compute_smd <- function(x, y) {
  nx <- length(x); ny <- length(y)
  sp <- sqrt(((nx - 1) * var(x) + (ny - 1) * var(y)) / (nx + ny - 2))
  if (sp == 0) return(NA_real_)
  (mean(x) - mean(y)) / sp
}

skewness <- function(x) {
  n <- length(x); m <- mean(x); s <- sd(x)
  if (n < 3 || s == 0) return(NA_real_)
  (sum((x - m)^3) / n) / s^3
}

# --- Region descriptive stats ------------------------------------------------
regions <- sort(unique(gusto$regl))
em_vars <- c("sysbp", "age")

cat("=== Region Descriptive Statistics ===\n\n")
for (v in em_vars) {
  cat(sprintf("--- %s ---\n", toupper(v)))
  cat(sprintf("%-8s %6s %8s %8s %8s %8s\n", "Region", "N", "Mean", "SD", "Skew", "IQR"))
  for (r in regions) {
    x <- gusto[[v]][gusto$regl == r]
    x <- x[!is.na(x)]
    cat(sprintf("%-8d %6d %8.1f %8.1f %8.2f %8.1f\n",
                r, length(x), mean(x), sd(x), skewness(x), IQR(x)))
  }
  cat("\n")
}

# --- All pairwise nABCD and SMD -----------------------------------------------
cat("=== All Pairwise Comparisons (120 pairs) ===\n\n")

results <- list()
for (v in em_vars) {
  pairs <- combn(regions, 2)
  res <- tibble(
    var = v,
    region_i = pairs[1,],
    region_j = pairs[2,],
    n_i = NA_integer_,
    n_j = NA_integer_,
    nABCD = NA_real_,
    abs_SMD = NA_real_,
    IQR_pooled = NA_real_,
    skew_i = NA_real_,
    skew_j = NA_real_,
    mean_i = NA_real_,
    mean_j = NA_real_,
    sd_i = NA_real_,
    sd_j = NA_real_
  )

  for (k in seq_len(ncol(pairs))) {
    ri <- pairs[1, k]; rj <- pairs[2, k]
    xi <- gusto[[v]][gusto$regl == ri]; xi <- xi[!is.na(xi)]
    xj <- gusto[[v]][gusto$regl == rj]; xj <- xj[!is.na(xj)]
    res$n_i[k] <- length(xi)
    res$n_j[k] <- length(xj)
    res$nABCD[k] <- compute_nABCD(xi, xj)
    res$abs_SMD[k] <- abs(compute_smd(xi, xj))
    res$IQR_pooled[k] <- IQR(c(xi, xj))
    res$skew_i[k] <- skewness(xi)
    res$skew_j[k] <- skewness(xj)
    res$mean_i[k] <- mean(xi)
    res$mean_j[k] <- mean(xj)
    res$sd_i[k] <- sd(xi)
    res$sd_j[k] <- sd(xj)
  }
  results[[v]] <- res
}

all_results <- bind_rows(results)

# --- Summary per variable -----------------------------------------------------
for (v in em_vars) {
  res <- results[[v]]
  cat(sprintf("--- %s: 120 pairwise comparisons ---\n", toupper(v)))
  cat(sprintf("  nABCD:  min=%.4f  median=%.4f  mean=%.4f  max=%.4f\n",
              min(res$nABCD), median(res$nABCD), mean(res$nABCD), max(res$nABCD)))
  cat(sprintf("  |SMD|:  min=%.4f  median=%.4f  mean=%.4f  max=%.4f\n",
              min(res$abs_SMD), median(res$abs_SMD), mean(res$abs_SMD), max(res$abs_SMD)))

  rho <- cor(res$nABCD, res$abs_SMD, method = "spearman")
  r_pearson <- cor(res$nABCD, res$abs_SMD)
  cat(sprintf("  Correlation nABCD vs |SMD|: Spearman=%.3f, Pearson=%.3f\n", rho, r_pearson))

  # Max nABCD pair
  idx_max <- which.max(res$nABCD)
  cat(sprintf("  Max nABCD pair: Region %d vs %d (nABCD=%.4f, |SMD|=%.4f)\n",
              res$region_i[idx_max], res$region_j[idx_max],
              res$nABCD[idx_max], res$abs_SMD[idx_max]))
  cat(sprintf("    skew_i=%.2f, skew_j=%.2f, mean_i=%.1f, mean_j=%.1f\n",
              res$skew_i[idx_max], res$skew_j[idx_max],
              res$mean_i[idx_max], res$mean_j[idx_max]))

  # Top 10 by nABCD
  cat("\n  Top 10 pairs by nABCD:\n")
  top10 <- res %>% arrange(desc(nABCD)) %>% head(10)
  cat(sprintf("  %-5s %-5s %8s %8s %8s %8s %10s\n",
              "Reg_i", "Reg_j", "nABCD", "|SMD|", "skew_i", "skew_j", "skew_diff"))
  for (i in seq_len(nrow(top10))) {
    cat(sprintf("  %-5d %-5d %8.4f %8.4f %8.2f %8.2f %10.2f\n",
                top10$region_i[i], top10$region_j[i],
                top10$nABCD[i], top10$abs_SMD[i],
                top10$skew_i[i], top10$skew_j[i],
                abs(top10$skew_i[i] - top10$skew_j[i])))
  }

  # Largest rank divergence (nABCD rank vs SMD rank)
  res <- res %>%
    mutate(rank_nABCD = rank(-nABCD),
           rank_SMD = rank(-abs_SMD),
           rank_diff = rank_nABCD - rank_SMD)

  cat("\n  Largest rank divergence (nABCD rank - SMD rank):\n")
  divergent <- res %>% arrange(desc(abs(rank_diff))) %>% head(5)
  cat(sprintf("  %-5s %-5s %8s %8s %8s %8s %10s\n",
              "Reg_i", "Reg_j", "nABCD", "|SMD|", "rnk_nAB", "rnk_SMD", "diff"))
  for (i in seq_len(nrow(divergent))) {
    cat(sprintf("  %-5d %-5d %8.4f %8.4f %8.0f %8.0f %10.0f\n",
                divergent$region_i[i], divergent$region_j[i],
                divergent$nABCD[i], divergent$abs_SMD[i],
                divergent$rank_nABCD[i], divergent$rank_SMD[i],
                divergent$rank_diff[i]))
  }
  cat("\n")
}

# --- Save CSV -----------------------------------------------------------------
out_dir <- dirname(normalizePath(".", mustWork = TRUE))
# Save to GUSTO directory
write_csv(all_results,
  "C:/Users/hrd13/Documents/Gak/0 Study/800Claude/20260210_SIM/similarity_metrics/projects/similarity-metric/data/GUSTO/gusto_all_pairwise.csv")
cat("Saved: gusto_all_pairwise.csv\n")
