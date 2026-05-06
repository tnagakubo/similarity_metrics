#!/usr/bin/env Rscript
# =============================================================================
# GUSTO-I Preliminary Analysis: All 5 continuous EMs, all pairwise, all anchors
# =============================================================================
suppressPackageStartupMessages({
  library(predtools)
  library(tidyverse)
})

data(gusto)
set.seed(2026)

# --- Helpers -----------------------------------------------------------------
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
  sp <- sqrt(((nx-1)*var(x) + (ny-1)*var(y)) / (nx+ny-2))
  if (sp == 0) return(NA_real_)
  (mean(x) - mean(y)) / sp
}

skewness <- function(x) {
  n <- length(x); m <- mean(x); s <- sd(x)
  if (n < 3 || s == 0) return(NA_real_)
  (sum((x-m)^3)/n) / s^3
}

# --- Variables ---------------------------------------------------------------
em_vars <- c("age", "sysbp", "pulse", "height", "weight")
regions <- sort(unique(gusto$regl))
n_regions <- length(regions)

# --- Region descriptive stats ------------------------------------------------
cat("================================================================\n")
cat("PART 1: Region Descriptive Statistics (all 5 continuous EMs)\n")
cat("================================================================\n\n")

for (v in em_vars) {
  cat(sprintf("--- %s ---\n", v))
  cat(sprintf("%-6s %6s %8s %8s %8s %8s %8s\n",
              "Reg", "N", "Mean", "SD", "Skew", "IQR", "Kurt"))
  for (r in regions) {
    x <- gusto[[v]][gusto$regl == r]
    x <- x[!is.na(x)]
    kurt <- (sum((x - mean(x))^4)/length(x)) / sd(x)^4 - 3
    cat(sprintf("%-6d %6d %8.1f %8.1f %8.2f %8.1f %8.2f\n",
                r, length(x), mean(x), sd(x), skewness(x), IQR(x), kurt))
  }
  # Overall heterogeneity
  means <- sapply(regions, function(r) mean(gusto[[v]][gusto$regl == r], na.rm = TRUE))
  sds <- sapply(regions, function(r) sd(gusto[[v]][gusto$regl == r], na.rm = TRUE))
  skews <- sapply(regions, function(r) skewness(gusto[[v]][gusto$regl == r]))
  cat(sprintf("  CV of means: %.1f%%\n", 100 * sd(means) / mean(means)))
  cat(sprintf("  SD of skewness: %.3f  range: [%.2f, %.2f]\n\n",
              sd(skews), min(skews), max(skews)))
}

# --- All pairwise nABCD and SMD -----------------------------------------------
cat("================================================================\n")
cat("PART 2: All Pairwise nABCD/SMD Summary (120 pairs x 5 vars)\n")
cat("================================================================\n\n")

all_results <- list()
for (v in em_vars) {
  pairs <- combn(regions, 2)
  res <- tibble(
    var = v,
    region_i = pairs[1,], region_j = pairs[2,],
    n_i = NA_integer_, n_j = NA_integer_,
    nABCD = NA_real_, abs_SMD = NA_real_,
    IQR_pooled = NA_real_,
    skew_i = NA_real_, skew_j = NA_real_
  )
  for (k in seq_len(ncol(pairs))) {
    xi <- gusto[[v]][gusto$regl == pairs[1,k]]; xi <- xi[!is.na(xi)]
    xj <- gusto[[v]][gusto$regl == pairs[2,k]]; xj <- xj[!is.na(xj)]
    res$n_i[k] <- length(xi); res$n_j[k] <- length(xj)
    res$nABCD[k] <- compute_nABCD(xi, xj)
    res$abs_SMD[k] <- abs(compute_smd(xi, xj))
    res$IQR_pooled[k] <- IQR(c(xi, xj))
    res$skew_i[k] <- skewness(xi); res$skew_j[k] <- skewness(xj)
  }
  all_results[[v]] <- res

  rho <- cor(res$nABCD, res$abs_SMD, method = "spearman")
  cat(sprintf("%-8s  nABCD: [%.4f, %.4f] med=%.4f  |SMD|: [%.4f, %.4f]  rho_S=%.3f\n",
              v, min(res$nABCD), max(res$nABCD), median(res$nABCD),
              min(res$abs_SMD), max(res$abs_SMD), rho))
}

# --- Anchor-by-anchor pooling analysis ----------------------------------------
cat("\n================================================================\n")
cat("PART 3: Anchor-by-Anchor Pooling Analysis\n")
cat("================================================================\n")
cat("Thresholds: nABCD < 0.05 = 'negligible', |SMD| < 0.1 = 'negligible'\n\n")

# For each EM, for each anchor, determine:
#   - How many partners are "poolable" (nABCD < 0.05)
#   - How many partners are "poolable" (|SMD| < 0.1)
#   - Which partners disagree
#   - rho for this anchor

for (v in em_vars) {
  cat(sprintf("========== %s ==========\n", toupper(v)))
  pw <- all_results[[v]]

  anchor_table <- tibble()

  for (anc in regions) {
    pairs <- pw %>%
      filter(region_i == anc | region_j == anc) %>%
      mutate(partner = ifelse(region_i == anc, region_j, region_i)) %>%
      arrange(nABCD)

    n_anc <- gusto %>% filter(regl == anc) %>% nrow()
    rho <- cor(pairs$nABCD, pairs$abs_SMD, method = "spearman")

    pool_nABCD <- pairs %>% filter(nABCD < 0.05) %>% pull(partner)
    pool_SMD <- pairs %>% filter(abs_SMD < 0.1) %>% pull(partner)

    # Disagreements
    only_nABCD_pool <- setdiff(pool_nABCD, pool_SMD)  # nABCD says pool, SMD says don't
    only_SMD_pool <- setdiff(pool_SMD, pool_nABCD)     # SMD says pool, nABCD says don't

    anchor_table <- bind_rows(anchor_table, tibble(
      anchor = anc, n = n_anc,
      n_pool_nABCD = length(pool_nABCD),
      n_pool_SMD = length(pool_SMD),
      rho_S = rho,
      pool_nABCD_list = paste(sort(pool_nABCD), collapse=","),
      pool_SMD_list = paste(sort(pool_SMD), collapse=","),
      only_nABCD = paste(sort(only_nABCD_pool), collapse=","),
      only_SMD = paste(sort(only_SMD_pool), collapse=","),
      max_nABCD = max(pairs$nABCD),
      median_nABCD = median(pairs$nABCD)
    ))
  }

  cat(sprintf("%-5s %5s %6s %6s %6s  %-30s %-30s %-15s %-15s\n",
              "Anc", "N", "pool_n", "pool_S", "rho",
              "nABCD_poolable", "SMD_poolable", "only_nABCD", "only_SMD"))
  for (i in seq_len(nrow(anchor_table))) {
    a <- anchor_table[i,]
    cat(sprintf("%-5d %5d %6d %6d %6.3f  %-30s %-30s %-15s %-15s\n",
                a$anchor, a$n, a$n_pool_nABCD, a$n_pool_SMD, a$rho_S,
                a$pool_nABCD_list, a$pool_SMD_list,
                ifelse(a$only_nABCD == "", "-", a$only_nABCD),
                ifelse(a$only_SMD == "", "-", a$only_SMD)))
  }
  cat("\n")
}

# --- Option summary: which anchor gives the best story? -----------------------
cat("================================================================\n")
cat("PART 4: Story Assessment by EM and Anchor\n")
cat("================================================================\n\n")

for (v in em_vars) {
  pw <- all_results[[v]]
  cat(sprintf("--- %s ---\n", toupper(v)))

  for (anc in regions) {
    pairs <- pw %>%
      filter(region_i == anc | region_j == anc) %>%
      mutate(partner = ifelse(region_i == anc, region_j, region_i))

    rho <- cor(pairs$nABCD, pairs$abs_SMD, method = "spearman")

    pool_nABCD <- sum(pairs$nABCD < 0.05)
    pool_SMD <- sum(pairs$abs_SMD < 0.1)
    diff_pooling <- abs(pool_nABCD - pool_SMD)

    # Rank divergence
    pairs <- pairs %>%
      mutate(rk_n = rank(nABCD), rk_s = rank(abs_SMD), rk_d = rk_n - rk_s)
    max_rk_d <- max(abs(pairs$rk_d))

    cat(sprintf("  Anc=%2d  rho=%.3f  pool_nABCD=%2d  pool_SMD=%2d  diff=%d  maxRankDiv=%d\n",
                anc, rho, pool_nABCD, pool_SMD, diff_pooling, max_rk_d))
  }
  cat("\n")
}

# --- Three-option comparison --------------------------------------------------
cat("================================================================\n")
cat("PART 5: Three Options Comparison\n")
cat("================================================================\n")
cat("Option 1: age + sysbp (two EMs)\n")
cat("Option 2: age only\n")
cat("Option 3: sysbp only\n\n")

for (anc in regions) {
  cat(sprintf("--- Anchor = Region %d (N=%d) ---\n", anc,
              sum(gusto$regl == anc)))

  for (v in c("age", "sysbp")) {
    pw <- all_results[[v]]
    pairs <- pw %>%
      filter(region_i == anc | region_j == anc) %>%
      mutate(partner = ifelse(region_i == anc, region_j, region_i)) %>%
      arrange(nABCD)
    pool <- pairs %>% filter(nABCD < 0.05) %>% pull(partner)
    cat(sprintf("  %s: poolable = {%s} (%d/15)\n", v,
                paste(sort(pool), collapse=","), length(pool)))
  }

  # Combined: partner poolable only if BOTH age AND sysbp < 0.05
  pw_age <- all_results[["age"]] %>%
    filter(region_i == anc | region_j == anc) %>%
    mutate(partner = ifelse(region_i == anc, region_j, region_i)) %>%
    select(partner, nABCD_age = nABCD)
  pw_sbp <- all_results[["sysbp"]] %>%
    filter(region_i == anc | region_j == anc) %>%
    mutate(partner = ifelse(region_i == anc, region_j, region_i)) %>%
    select(partner, nABCD_sysbp = nABCD)
  combined <- inner_join(pw_age, pw_sbp, by = "partner")
  both_pool <- combined %>% filter(nABCD_age < 0.05 & nABCD_sysbp < 0.05) %>% pull(partner)
  cat(sprintf("  BOTH:  poolable = {%s} (%d/15)\n\n",
              paste(sort(both_pool), collapse=","), length(both_pool)))
}
