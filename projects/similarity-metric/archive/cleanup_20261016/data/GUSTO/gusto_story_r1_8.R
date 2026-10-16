##############################################################################
# GUSTO-I Application Section: Story Construction for Regions 1-8 as Anchor
# Computes pooling tables, story outlines, and quality scores
##############################################################################

library(dplyr)
library(tidyr)

# --- Read data ---
dat <- read.csv("C:/Users/hrd13/Documents/Gak/0 Study/800Claude/20260210_SIM/similarity_metrics/projects/similarity-metric/data/GUSTO/gusto_smd_misleading.csv",
                stringsAsFactors = FALSE)

threshold <- 0.05

# Region characteristics
region_info <- data.frame(
  region = 1:16,
  N = c(2188, 2952, 2030, 2876, 1909, 1585, 3150, 2916,
        3123, 1717, 2491, 4352, 2297, 3437, 2576, 1231),
  sysbp_mean = c(129.0, 132.8, 129.2, 130.1, 130.4, 129.1, 127.5, 132.4,
                 NA, NA, NA, NA, NA, NA, NA, NA),
  age_mean = c(60.5, 62.4, 62.8, 60.7, 60.1, 60.5, 60.0, 60.2,
               NA, NA, NA, NA, NA, NA, NA, NA),
  sysbp_skew = c(0.26, 0.26, 0.09, 0.47, 1.32, 0.03, 0.35, 0.20,
                 NA, NA, NA, NA, NA, NA, NA, NA),
  age_skew = c(-0.05, -0.31, -0.22, -0.14, -0.26, -0.16, -0.13, -0.17,
               NA, NA, NA, NA, NA, NA, NA, NA)
)

# --- Build wide table: for each (i, j) pair, get nABCD for age and sysbp ---
age_dat <- dat %>% filter(variable == "age") %>%
  select(region_i, region_j, nABCD_age = nABCD)
sysbp_dat <- dat %>% filter(variable == "sysbp") %>%
  select(region_i, region_j, nABCD_sysbp = nABCD)

paired <- full_join(age_dat, sysbp_dat, by = c("region_i", "region_j"))

# nABCD is symmetric: ensure we have both directions
paired_rev <- paired %>%
  rename(region_i = region_j, region_j = region_i)
paired_all <- bind_rows(paired, paired_rev) %>%
  distinct(region_i, region_j, .keep_all = TRUE)

# --- Clinical calibration parameters ---
L_mean_age <- 0.0003   # per year
L_max_age  <- 0.0005   # per year

# --- Function: compute Delta_max from nABCD ---
# nABCD approximates W1 / (pooled_sd). For age, W1 ~ nABCD * pooled_sd (in years).
# Delta_max = L * W1 (approximate absolute difference in outcome scale)
# We need pooled SD for age; approximate from data
get_pooled_sd <- function(anchor, partner, variable) {
  row <- dat %>% filter(variable == !!variable,
                        ((region_i == anchor & region_j == partner) |
                         (region_i == partner & region_j == anchor)))
  if (nrow(row) == 0) return(NA)
  row <- row[1, ]
  # pooled SD ~ mean of sd_i and sd_j (approximate)
  (row$sd_i + row$sd_j) / 2
}

# --- Main analysis for each anchor region 1-8 ---
for (anchor in 1:8) {

  partners <- setdiff(1:16, anchor)
  anchor_data <- paired_all %>% filter(region_i == anchor, region_j %in% partners)

  # Merge and classify
  tbl <- anchor_data %>%
    arrange(region_j) %>%
    mutate(
      pool_age = ifelse(nABCD_age < threshold, "POOL", "NO"),
      pool_sysbp = ifelse(nABCD_sysbp < threshold, "POOL", "NO"),
      overall = case_when(
        pool_age == "POOL" & pool_sysbp == "POOL" ~ "BOTH_POOL",
        pool_age == "POOL" & pool_sysbp == "NO"   ~ "AGE_ONLY",
        pool_age == "NO"   & pool_sysbp == "POOL" ~ "SBP_ONLY",
        TRUE ~ "NEITHER"
      )
    )

  # --- Print pooling table ---
  cat("================================================================\n")
  cat(sprintf("REGION %d AS ANCHOR (N = %d)\n", anchor, region_info$N[anchor]))
  cat("================================================================\n\n")

  cat("--- Pooling Decision Table ---\n")
  cat(sprintf("%-10s %10s %12s %10s %12s %12s\n",
              "Partner", "nABCD_age", "nABCD_sysbp", "Pool_age", "Pool_sysbp", "Overall"))
  cat(paste(rep("-", 72), collapse = ""), "\n")

  for (i in seq_len(nrow(tbl))) {
    r <- tbl[i, ]
    cat(sprintf("Region %-3d %10.5f %12.5f %10s %12s %12s\n",
                r$region_j, r$nABCD_age, r$nABCD_sysbp,
                r$pool_age, r$pool_sysbp, r$overall))
  }

  # --- Summary counts ---
  n_both   <- sum(tbl$overall == "BOTH_POOL")
  n_age    <- sum(tbl$overall == "AGE_ONLY")
  n_sbp    <- sum(tbl$overall == "SBP_ONLY")
  n_neither <- sum(tbl$overall == "NEITHER")
  n_discord <- n_age + n_sbp

  cat(sprintf("\nSummary: BOTH_POOL=%d, AGE_ONLY=%d, SBP_ONLY=%d, NEITHER=%d\n",
              n_both, n_age, n_sbp, n_neither))
  cat(sprintf("Discordant cases: %d\n\n", n_discord))

  # --- nABCD gradient ---
  age_vals <- sort(tbl$nABCD_age)
  sysbp_vals <- sort(tbl$nABCD_sysbp)
  cat(sprintf("nABCD(age) range:   [%.5f, %.5f], IQR=[%.5f, %.5f]\n",
              min(age_vals), max(age_vals),
              quantile(age_vals, 0.25), quantile(age_vals, 0.75)))
  cat(sprintf("nABCD(sysbp) range: [%.5f, %.5f], IQR=[%.5f, %.5f]\n\n",
              min(sysbp_vals), max(sysbp_vals),
              quantile(sysbp_vals, 0.25), quantile(sysbp_vals, 0.75)))

  # --- Clinical calibration for age (Delta_max) ---
  cat("--- Age: Clinical Calibration (Delta_max) ---\n")
  cat(sprintf("%-10s %10s %12s %14s %14s\n",
              "Partner", "nABCD_age", "W1_approx", "Dmax(L_mean)", "Dmax(L_max)"))
  cat(paste(rep("-", 65), collapse = ""), "\n")

  for (i in seq_len(nrow(tbl))) {
    r <- tbl[i, ]
    pooled_sd <- get_pooled_sd(anchor, r$region_j, "age")
    W1_approx <- r$nABCD_age * pooled_sd  # approximate W1 in years
    Dmax_mean <- L_mean_age * W1_approx
    Dmax_max  <- L_max_age * W1_approx
    cat(sprintf("Region %-3d %10.5f %12.3f %14.6f %14.6f\n",
                r$region_j, r$nABCD_age, W1_approx, Dmax_mean, Dmax_max))
  }

  # --- sysbp: L* sensitivity analysis ---
  cat("\n--- Sysbp: L* Sensitivity Analysis ---\n")
  cat("L* values: 0.0001, 0.0003, 0.0005, 0.001 per mmHg\n")
  L_star_vals <- c(0.0001, 0.0003, 0.0005, 0.001)

  cat(sprintf("%-10s %12s %10s", "Partner", "nABCD_sysbp", "W1_approx"))
  for (L in L_star_vals) cat(sprintf(" %12s", paste0("Dmax(", L, ")")))
  cat("\n")
  cat(paste(rep("-", 10 + 12 + 10 + length(L_star_vals) * 13), collapse = ""), "\n")

  for (i in seq_len(nrow(tbl))) {
    r <- tbl[i, ]
    pooled_sd <- get_pooled_sd(anchor, r$region_j, "sysbp")
    W1_approx <- r$nABCD_sysbp * pooled_sd
    cat(sprintf("Region %-3d %12.5f %10.3f", r$region_j, r$nABCD_sysbp, W1_approx))
    for (L in L_star_vals) {
      Dmax <- L * W1_approx
      cat(sprintf(" %12.6f", Dmax))
    }
    cat("\n")
  }

  # --- Story outline ---
  cat("\n--- Story Outline for Application Section ---\n\n")

  # Para 1
  ri <- region_info[anchor, ]
  cat(sprintf("PARA 1 (Scenario): Region %d (N=%d", anchor, ri$N))
  if (!is.na(ri$age_mean)) {
    cat(sprintf(", age_mean=%.1f", ri$age_mean))
    if (!is.na(ri$sysbp_mean)) cat(sprintf(", sysbp_mean=%.1f", ri$sysbp_mean))
    if (!is.na(ri$sysbp_skew)) cat(sprintf(", sysbp_skew=%.2f", ri$sysbp_skew))
  }
  cat(") as anchor.\n")

  # Characterize typicality
  if (!is.na(ri$sysbp_skew)) {
    if (abs(ri$sysbp_skew) > 1.0) {
      cat("  -> Extreme: highly skewed sysbp distribution.\n")
    } else if (abs(ri$sysbp_skew) < 0.15) {
      cat("  -> Near-symmetric sysbp distribution.\n")
    } else {
      cat("  -> Moderate sysbp skewness.\n")
    }
  }

  # Para 2
  cat(sprintf("\nPARA 2 (nABCD Summary): %d/15 partners poolable on BOTH EMs,\n", n_both))
  cat(sprintf("  %d on age only, %d on sysbp only, %d on neither.\n", n_age, n_sbp, n_neither))

  # Age gradient description
  n_age_pool <- sum(tbl$pool_age == "POOL")
  n_sysbp_pool <- sum(tbl$pool_sysbp == "POOL")
  cat(sprintf("  Age: %d/15 poolable. Sysbp: %d/15 poolable.\n", n_age_pool, n_sysbp_pool))

  # Para 3
  cat("\nPARA 3 (Age Clinical Calibration): FTT-based L estimates.\n")
  cat("  L_mean=0.0003/yr, L_max=0.0005/yr.\n")
  # Find the borderline case (nABCD closest to 0.05)
  borderline_age <- tbl %>% mutate(dist = abs(nABCD_age - threshold)) %>%
    arrange(dist) %>% slice(1)
  pooled_sd_bl <- get_pooled_sd(anchor, borderline_age$region_j, "age")
  W1_bl <- borderline_age$nABCD_age * pooled_sd_bl
  cat(sprintf("  Borderline partner: Region %d (nABCD=%.5f, W1~%.2f yr)\n",
              borderline_age$region_j, borderline_age$nABCD_age, W1_bl))
  cat(sprintf("  -> Delta_max(L_mean)=%.6f, Delta_max(L_max)=%.6f\n",
              L_mean_age * W1_bl, L_max_age * W1_bl))

  # Para 4
  cat("\nPARA 4 (Sysbp L* Sensitivity): L unknown, so sweep L*.\n")
  borderline_sysbp <- tbl %>% mutate(dist = abs(nABCD_sysbp - threshold)) %>%
    arrange(dist) %>% slice(1)
  pooled_sd_bl2 <- get_pooled_sd(anchor, borderline_sysbp$region_j, "sysbp")
  W1_bl2 <- borderline_sysbp$nABCD_sysbp * pooled_sd_bl2
  cat(sprintf("  Borderline partner: Region %d (nABCD=%.5f, W1~%.2f mmHg)\n",
              borderline_sysbp$region_j, borderline_sysbp$nABCD_sysbp, W1_bl2))
  cat(sprintf("  -> At L*=0.0005: Delta_max=%.6f\n", 0.0005 * W1_bl2))

  # Para 5
  cat("\nPARA 5 (Discordant Cases):\n")
  discord <- tbl %>% filter(overall %in% c("AGE_ONLY", "SBP_ONLY"))
  if (nrow(discord) > 0) {
    for (d in seq_len(nrow(discord))) {
      dr <- discord[d, ]
      cat(sprintf("  Region %d: %s (age=%.5f, sysbp=%.5f)\n",
                  dr$region_j, dr$overall, dr$nABCD_age, dr$nABCD_sysbp))
    }
    cat("  -> Illustrates that poolability is EM-specific, not region-global.\n")
  } else {
    cat("  No discordant cases (all concordant).\n")
  }

  # Para 6
  cat("\nPARA 6 (Recommendation): ")
  if (n_both >= 8) {
    cat("Strong pooling potential — majority of partners poolable on both EMs.\n")
  } else if (n_both >= 4) {
    cat("Moderate pooling — selective partners available, discordance highlights EM-specific assessment.\n")
  } else {
    cat("Limited pooling — few partners poolable on both; region may be distributional outlier.\n")
  }

  # --- Story quality score ---
  cat("\n--- Story Quality Evaluation ---\n")

  # 1. Balance (ideally 4-11 BOTH_POOL out of 15)
  balance_score <- if (n_both >= 4 & n_both <= 11) 5
                   else if (n_both >= 2 & n_both <= 13) 3
                   else 1
  cat(sprintf("  1. Pool/non-pool balance: BOTH_POOL=%d/15 -> score=%d/5\n",
              n_both, balance_score))

  # 2. Discordant cases (more is better for illustration)
  discord_score <- if (n_discord >= 4) 5
                   else if (n_discord >= 2) 4
                   else if (n_discord >= 1) 3
                   else 1
  cat(sprintf("  2. Discordant cases: %d -> score=%d/5\n", n_discord, discord_score))

  # 3. nABCD gradient (range of values)
  age_range <- max(age_vals) - min(age_vals)
  sysbp_range <- max(sysbp_vals) - min(sysbp_vals)
  grad_score <- if (age_range > 0.08 & sysbp_range > 0.08) 5
                else if (age_range > 0.05 | sysbp_range > 0.05) 3
                else 2
  cat(sprintf("  3. nABCD gradient: age_range=%.4f, sysbp_range=%.4f -> score=%d/5\n",
              age_range, sysbp_range, grad_score))

  # 4. Clinical calibration meaningfulness
  # Check if borderline Delta_max with L_max is in a meaningful range (e.g., 0.0001-0.01)
  Dmax_bl <- L_max_age * W1_bl
  calib_score <- if (Dmax_bl > 0.0005 & Dmax_bl < 0.01) 5
                 else if (Dmax_bl > 0.0001) 4
                 else 3
  cat(sprintf("  4. Clinical calibration: borderline Dmax(L_max)=%.6f -> score=%d/5\n",
              Dmax_bl, calib_score))

  # 5. L* sensitivity interest
  # If sysbp nABCD values span across the threshold, L* analysis is more interesting
  sysbp_cross <- any(tbl$nABCD_sysbp < threshold) & any(tbl$nABCD_sysbp >= threshold)
  lstar_score <- if (sysbp_cross & n_discord >= 2) 5
                 else if (sysbp_cross) 4
                 else 2
  cat(sprintf("  5. L* sensitivity interest: cross_threshold=%s -> score=%d/5\n",
              sysbp_cross, lstar_score))

  # 6. Anchor typicality
  # Prefer moderate (not too typical, not too extreme)
  if (!is.na(ri$sysbp_skew)) {
    anchor_score <- if (abs(ri$sysbp_skew) > 1.0) 5  # extreme = very interesting
                    else if (abs(ri$sysbp_skew) > 0.3) 4  # moderate
                    else if (abs(ri$sysbp_skew) < 0.1) 3  # very typical (OK as baseline)
                    else 3
  } else {
    anchor_score <- 3
  }
  cat(sprintf("  6. Anchor characteristics: sysbp_skew=%.2f -> score=%d/5\n",
              ifelse(is.na(ri$sysbp_skew), NA, ri$sysbp_skew), anchor_score))

  # Overall
  overall_score <- round(mean(c(balance_score, discord_score, grad_score,
                                calib_score, lstar_score, anchor_score)), 1)
  cat(sprintf("  OVERALL: %.1f / 5.0\n", overall_score))

  cat("\n\n")
}

# --- Final ranking ---
cat("================================================================\n")
cat("FINAL RANKING: Best Anchor Regions for Application Section\n")
cat("================================================================\n\n")

scores <- data.frame(region = integer(), overall = numeric())
for (anchor in 1:8) {
  partners <- setdiff(1:16, anchor)
  anchor_data <- paired_all %>% filter(region_i == anchor, region_j %in% partners)
  tbl <- anchor_data %>%
    arrange(region_j) %>%
    mutate(
      pool_age = ifelse(nABCD_age < threshold, "POOL", "NO"),
      pool_sysbp = ifelse(nABCD_sysbp < threshold, "POOL", "NO"),
      overall = case_when(
        pool_age == "POOL" & pool_sysbp == "POOL" ~ "BOTH_POOL",
        pool_age == "POOL" & pool_sysbp == "NO"   ~ "AGE_ONLY",
        pool_age == "NO"   & pool_sysbp == "POOL" ~ "SBP_ONLY",
        TRUE ~ "NEITHER"
      )
    )

  n_both <- sum(tbl$overall == "BOTH_POOL")
  n_age_o <- sum(tbl$overall == "AGE_ONLY")
  n_sbp_o <- sum(tbl$overall == "SBP_ONLY")
  n_neither <- sum(tbl$overall == "NEITHER")
  n_discord <- n_age_o + n_sbp_o

  ri <- region_info[anchor, ]

  balance_score <- if (n_both >= 4 & n_both <= 11) 5
                   else if (n_both >= 2 & n_both <= 13) 3
                   else 1
  discord_score <- if (n_discord >= 4) 5
                   else if (n_discord >= 2) 4
                   else if (n_discord >= 1) 3
                   else 1
  age_vals <- sort(tbl$nABCD_age)
  sysbp_vals <- sort(tbl$nABCD_sysbp)
  age_range <- max(age_vals) - min(age_vals)
  sysbp_range <- max(sysbp_vals) - min(sysbp_vals)
  grad_score <- if (age_range > 0.08 & sysbp_range > 0.08) 5
                else if (age_range > 0.05 | sysbp_range > 0.05) 3
                else 2

  borderline_age <- tbl %>% mutate(dist = abs(nABCD_age - threshold)) %>%
    arrange(dist) %>% slice(1)
  pooled_sd_bl <- get_pooled_sd(anchor, borderline_age$region_j, "age")
  W1_bl <- borderline_age$nABCD_age * pooled_sd_bl
  Dmax_bl <- L_max_age * W1_bl
  calib_score <- if (Dmax_bl > 0.0005 & Dmax_bl < 0.01) 5
                 else if (Dmax_bl > 0.0001) 4
                 else 3

  sysbp_cross <- any(tbl$nABCD_sysbp < threshold) & any(tbl$nABCD_sysbp >= threshold)
  lstar_score <- if (sysbp_cross & n_discord >= 2) 5
                 else if (sysbp_cross) 4
                 else 2

  anchor_score <- if (!is.na(ri$sysbp_skew) && abs(ri$sysbp_skew) > 1.0) 5
                  else if (!is.na(ri$sysbp_skew) && abs(ri$sysbp_skew) > 0.3) 4
                  else 3

  overall_sc <- round(mean(c(balance_score, discord_score, grad_score,
                             calib_score, lstar_score, anchor_score)), 1)

  scores <- rbind(scores, data.frame(
    region = anchor,
    N = ri$N,
    BOTH = n_both,
    AGE_ONLY = n_age_o,
    SBP_ONLY = n_sbp_o,
    NEITHER = n_neither,
    discord = n_discord,
    score = overall_sc
  ))
}

scores <- scores %>% arrange(desc(score))
cat(sprintf("%-8s %6s %6s %9s %9s %8s %8s %8s\n",
            "Region", "N", "BOTH", "AGE_ONLY", "SBP_ONLY", "NEITHER", "Discord", "Score"))
cat(paste(rep("-", 70), collapse = ""), "\n")
for (i in seq_len(nrow(scores))) {
  s <- scores[i, ]
  cat(sprintf("Region %-2d %5d %6d %9d %9d %8d %8d %8.1f %s\n",
              s$region, s$N, s$BOTH, s$AGE_ONLY, s$SBP_ONLY, s$NEITHER, s$discord, s$score,
              ifelse(i == 1, "<-- BEST", "")))
}

cat("\nDone.\n")
