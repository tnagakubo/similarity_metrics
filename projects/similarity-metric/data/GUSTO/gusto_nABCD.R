#!/usr/bin/env Rscript
# =============================================================================
# GUSTO-I Dataset: nABCD vs SMD Analysis by Region
# =============================================================================
# Purpose: Compute pairwise nABCD and SMD for continuous variables across
#          16 regions in the GUSTO-I trial to demonstrate how nABCD captures
#          distributional differences that SMD may miss.
#
# Dataset: GUSTO-I (Global Utilization of Streptokinase and TPA for Occluded
#          Arteries), N=40,830 patients, 16 regions (regl: coded 1-16)
#
# Variables: age, sysbp, pulse, height, weight
# =============================================================================

suppressPackageStartupMessages({
  library(predtools)
  library(tidyverse)
})

# Manual skewness (avoid moments dependency)
skewness <- function(x, na.rm = FALSE) {
  if (na.rm) x <- x[!is.na(x)]
  n <- length(x)
  m <- mean(x)
  s <- sd(x)
  (sum((x - m)^3) / n) / s^3
}

# --- Load data ---------------------------------------------------------------
data(gusto)
cat("=== GUSTO-I Dataset: nABCD Analysis ===\n")
cat("N =", nrow(gusto), "patients across", length(unique(gusto$regl)), "regions\n\n")

# --- Helper functions --------------------------------------------------------
compute_w1 <- function(x, y) {
  ecdf1 <- ecdf(x); ecdf2 <- ecdf(y)
  pooled <- sort(c(x, y))
  vals <- ecdf1(pooled) - ecdf2(pooled)
  diffs <- diff(pooled)
  sum(abs(vals[-length(vals)]) * diffs)
}

compute_nABCD <- function(x, y) {
  w1 <- compute_w1(x, y)
  iqr_p <- IQR(c(x, y), na.rm = TRUE)
  if (iqr_p == 0) return(NA)
  w1 / iqr_p
}

compute_smd <- function(x, y) {
  nx <- length(x); ny <- length(y)
  sp <- sqrt(((nx - 1) * sd(x)^2 + (ny - 1) * sd(y)^2) / (nx + ny - 2))
  if (sp == 0) return(NA)
  (mean(x) - mean(y)) / sp
}

# --- Variables to analyse ----------------------------------------------------
vars <- c("age", "sysbp", "pulse", "height", "weight")
regions <- sort(unique(gusto$regl))
n_regions <- length(regions)
pairs <- combn(regions, 2)
n_pairs <- ncol(pairs)

cat("Regions:", paste(regions, collapse = ", "), "\n")
cat("Number of pairwise comparisons: C(", n_regions, ",2) =", n_pairs, "\n\n")

# =============================================================================
# 1. Per-region summary statistics
# =============================================================================
cat("=" %>% strrep(72), "\n")
cat("SECTION 1: Per-Region Summary Statistics\n")
cat("=" %>% strrep(72), "\n\n")

region_summary <- gusto %>%
  group_by(regl) %>%
  summarise(
    N = n(),
    across(all_of(vars), list(
      mean = ~mean(.x, na.rm = TRUE),
      sd   = ~sd(.x, na.rm = TRUE),
      med  = ~median(.x, na.rm = TRUE),
      skew = ~skewness(.x, na.rm = TRUE)
    ), .names = "{.col}_{.fn}")
  )

for (v in vars) {
  cat(sprintf("\n--- %s ---\n", toupper(v)))
  sub <- region_summary %>%
    select(regl, N, starts_with(paste0(v, "_"))) %>%
    rename_with(~str_remove(.x, paste0(v, "_")), starts_with(paste0(v, "_")))
  print(as.data.frame(sub), digits = 3, row.names = FALSE)
}

# =============================================================================
# 2 & 3. Pairwise nABCD and SMD for each variable
# =============================================================================
cat("\n\n", "=" %>% strrep(72), "\n")
cat("SECTION 2: Pairwise nABCD and SMD (", n_pairs, " pairs per variable)\n")
cat("=" %>% strrep(72), "\n")

results_list <- list()

for (v in vars) {
  cat(sprintf("\n--- %s ---\n", toupper(v)))

  res <- tibble(
    region_i = pairs[1, ],
    region_j = pairs[2, ],
    nABCD    = NA_real_,
    SMD      = NA_real_,
    abs_SMD  = NA_real_
  )

  for (k in seq_len(n_pairs)) {
    xi <- gusto[[v]][gusto$regl == pairs[1, k]]
    xj <- gusto[[v]][gusto$regl == pairs[2, k]]
    res$nABCD[k]   <- compute_nABCD(xi, xj)
    res$SMD[k]     <- compute_smd(xi, xj)
    res$abs_SMD[k] <- abs(res$SMD[k])
  }

  results_list[[v]] <- res

  # Summary
  cat(sprintf("  nABCD  : min=%.4f  median=%.4f  max=%.4f\n",
              min(res$nABCD, na.rm = TRUE),
              median(res$nABCD, na.rm = TRUE),
              max(res$nABCD, na.rm = TRUE)))
  cat(sprintf("  |SMD|  : min=%.4f  median=%.4f  max=%.4f\n",
              min(res$abs_SMD, na.rm = TRUE),
              median(res$abs_SMD, na.rm = TRUE),
              max(res$abs_SMD, na.rm = TRUE)))

  # Top 5 most divergent pairs by nABCD
  cat("  Top 5 pairs by nABCD:\n")
  top5 <- res %>% arrange(desc(nABCD)) %>% head(5)
  for (r in seq_len(nrow(top5))) {
    cat(sprintf("    Region %2d vs %2d : nABCD=%.4f  |SMD|=%.4f\n",
                top5$region_i[r], top5$region_j[r],
                top5$nABCD[r], top5$abs_SMD[r]))
  }
}

# =============================================================================
# 4. Correlation between |SMD| and nABCD
# =============================================================================
cat("\n\n", "=" %>% strrep(72), "\n")
cat("SECTION 3: Pearson Correlation between |SMD| and nABCD\n")
cat("=" %>% strrep(72), "\n\n")

cor_table <- tibble(variable = character(), pearson_r = numeric(), rank_cor = numeric())

for (v in vars) {
  res <- results_list[[v]]
  r_pearson <- cor(res$abs_SMD, res$nABCD, use = "complete.obs")
  r_spearman <- cor(res$abs_SMD, res$nABCD, use = "complete.obs", method = "spearman")
  cor_table <- bind_rows(cor_table, tibble(variable = v, pearson_r = r_pearson, rank_cor = r_spearman))
  cat(sprintf("  %-8s: Pearson r = %.4f   Spearman rho = %.4f\n", v, r_pearson, r_spearman))
}

# =============================================================================
# 5. Divergence identification: where nABCD and SMD disagree most
# =============================================================================
cat("\n\n", "=" %>% strrep(72), "\n")
cat("SECTION 4: Divergence Between nABCD and |SMD| Rankings\n")
cat("=" %>% strrep(72), "\n")
cat("(Pairs where nABCD rank - |SMD| rank is large indicate shape differences)\n\n")

for (v in vars) {
  res <- results_list[[v]] %>%
    mutate(
      rank_nABCD = rank(-nABCD),
      rank_SMD   = rank(-abs_SMD),
      rank_diff  = rank_nABCD - rank_SMD
    )

  # Pairs where nABCD ranks much higher (more divergent) than SMD
  high_nABCD <- res %>% arrange(rank_diff) %>% head(3)
  # Pairs where SMD ranks much higher than nABCD
  high_SMD <- res %>% arrange(desc(rank_diff)) %>% head(3)

  cat(sprintf("--- %s ---\n", toupper(v)))
  cat("  nABCD detects more than SMD (shape/spread difference):\n")
  for (r in seq_len(nrow(high_nABCD))) {
    cat(sprintf("    Region %2d vs %2d : nABCD=%.4f (rank %3.0f)  |SMD|=%.4f (rank %3.0f)  diff=%+.0f\n",
                high_nABCD$region_i[r], high_nABCD$region_j[r],
                high_nABCD$nABCD[r], high_nABCD$rank_nABCD[r],
                high_nABCD$abs_SMD[r], high_nABCD$rank_SMD[r],
                high_nABCD$rank_diff[r]))
  }
  cat("  SMD detects more than nABCD (pure location shift):\n")
  for (r in seq_len(nrow(high_SMD))) {
    cat(sprintf("    Region %2d vs %2d : nABCD=%.4f (rank %3.0f)  |SMD|=%.4f (rank %3.0f)  diff=%+.0f\n",
                high_SMD$region_i[r], high_SMD$region_j[r],
                high_SMD$nABCD[r], high_SMD$rank_nABCD[r],
                high_SMD$abs_SMD[r], high_SMD$rank_SMD[r],
                high_SMD$rank_diff[r]))
  }
  cat("\n")
}

# =============================================================================
# 6. Region-level divergence profile
# =============================================================================
cat("\n", "=" %>% strrep(72), "\n")
cat("SECTION 5: Region Divergence Profile\n")
cat("=" %>% strrep(72), "\n")
cat("(Mean nABCD and |SMD| for each region across all its pairwise comparisons)\n\n")

region_profile <- tibble(region = regions)

for (v in vars) {
  res <- results_list[[v]]

  mean_nABCD <- sapply(regions, function(r) {
    idx <- res$region_i == r | res$region_j == r
    mean(res$nABCD[idx], na.rm = TRUE)
  })
  mean_absSMD <- sapply(regions, function(r) {
    idx <- res$region_i == r | res$region_j == r
    mean(res$abs_SMD[idx], na.rm = TRUE)
  })

  region_profile[[paste0(v, "_nABCD")]] <- mean_nABCD
  region_profile[[paste0(v, "_absSMD")]] <- mean_absSMD
}

# Compute overall score (mean across variables)
nABCD_cols <- paste0(vars, "_nABCD")
SMD_cols   <- paste0(vars, "_absSMD")

region_profile <- region_profile %>%
  rowwise() %>%
  mutate(
    overall_nABCD  = mean(c_across(all_of(nABCD_cols))),
    overall_absSMD = mean(c_across(all_of(SMD_cols)))
  ) %>%
  ungroup() %>%
  arrange(desc(overall_nABCD))

cat("Region profiles (sorted by overall mean nABCD):\n\n")
cat(sprintf("%-6s  %8s  %8s  %8s  %8s  %8s  %8s  %8s\n",
            "Region", "N",
            "age_nA", "sysbp_nA", "pulse_nA", "hgt_nA", "wgt_nA",
            "overall"))
cat(strrep("-", 80), "\n")

for (i in seq_len(nrow(region_profile))) {
  r <- region_profile$region[i]
  n <- sum(gusto$regl == r)
  cat(sprintf("%-6d  %8d  %8.4f  %8.4f  %8.4f  %8.4f  %8.4f  %8.4f\n",
              r, n,
              region_profile$age_nABCD[i],
              region_profile$sysbp_nABCD[i],
              region_profile$pulse_nABCD[i],
              region_profile$height_nABCD[i],
              region_profile$weight_nABCD[i],
              region_profile$overall_nABCD[i]))
}

# =============================================================================
# 7. Distribution shape comparison (skewness-based)
# =============================================================================
cat("\n\n", "=" %>% strrep(72), "\n")
cat("SECTION 6: Distribution Shape Profiles (Skewness by Region)\n")
cat("=" %>% strrep(72), "\n\n")

skew_tbl <- gusto %>%
  group_by(regl) %>%
  summarise(
    N = n(),
    across(all_of(vars), ~skewness(.x, na.rm = TRUE), .names = "{.col}_skew")
  ) %>%
  arrange(regl)

cat(sprintf("%-6s  %6s  %8s  %8s  %8s  %8s  %8s\n",
            "Region", "N", "age", "sysbp", "pulse", "height", "weight"))
cat(strrep("-", 64), "\n")
for (i in seq_len(nrow(skew_tbl))) {
  cat(sprintf("%-6d  %6d  %8.3f  %8.3f  %8.3f  %8.3f  %8.3f\n",
              skew_tbl$regl[i], skew_tbl$N[i],
              skew_tbl$age_skew[i], skew_tbl$sysbp_skew[i],
              skew_tbl$pulse_skew[i], skew_tbl$height_skew[i],
              skew_tbl$weight_skew[i]))
}

# =============================================================================
# Summary
# =============================================================================
cat("\n\n", "=" %>% strrep(72), "\n")
cat("SECTION 7: Key Findings Summary\n")
cat("=" %>% strrep(72), "\n\n")

cat("1. Correlation between nABCD and |SMD|:\n")
for (i in seq_len(nrow(cor_table))) {
  cat(sprintf("   %-8s: Pearson=%.3f  Spearman=%.3f\n",
              cor_table$variable[i], cor_table$pearson_r[i], cor_table$rank_cor[i]))
}

cat("\n2. Most 'outlier' regions (highest mean nABCD):\n")
top3 <- head(region_profile, 3)
for (i in seq_len(3)) {
  cat(sprintf("   Region %d: mean nABCD=%.4f, mean |SMD|=%.4f\n",
              top3$region[i], top3$overall_nABCD[i], top3$overall_absSMD[i]))
}

cat("\n3. Variables where nABCD and SMD diverge most:\n")
diverge <- cor_table %>% arrange(pearson_r)
cat(sprintf("   Lowest correlation: %s (Pearson=%.3f) -> shape differences matter most\n",
            diverge$variable[1], diverge$pearson_r[1]))
cat(sprintf("   Highest correlation: %s (Pearson=%.3f) -> mostly location shift\n",
            diverge$variable[nrow(diverge)], diverge$pearson_r[nrow(diverge)]))

cat("\n4. Interpretation:\n")
cat("   - When Pearson(|SMD|, nABCD) is high, differences are mainly location shifts\n")
cat("   - When Pearson(|SMD|, nABCD) is low, nABCD captures shape/spread differences\n")
cat("   - Regions with high mean nABCD across variables are most 'different' overall\n")
cat("   - This demonstrates nABCD's ability to detect distributional heterogeneity\n")
cat("     beyond what SMD captures\n")

cat("\n=== Analysis complete ===\n")
