## GUSTO-I Application Section: Story Construction for Regions 9-16
## Each region as anchor: pooling assessment, story outline, quality score

library(dplyr)
library(tidyr)

dat <- read.csv("C:/Users/hrd13/Documents/Gak/0 Study/800Claude/20260210_SIM/similarity_metrics/projects/similarity-metric/data/GUSTO/gusto_smd_misleading.csv",
                stringsAsFactors = FALSE)

threshold <- 0.05

# Region characteristics
region_info <- data.frame(
  region = 1:16,
  N = c(2188, 2952, 2030, 2876, 1909, 1585, 3150, 2916,
        3123, 1717, 2491, 4352, 2297, 3437, 2576, 1231),
  sysbp_mean = c(NA, NA, NA, NA, NA, NA, NA, NA,
                 125.7, 128.5, 126.0, 126.1, 130.2, 128.6, 127.9, 136.5),
  sysbp_skew = c(NA, NA, NA, NA, NA, NA, NA, NA,
                 0.29, 0.04, 0.25, 0.28, 0.36, 0.49, 0.38, 0.04),
  age_mean = c(NA, NA, NA, NA, NA, NA, NA, NA,
               60.7, 58.9, 61.5, 61.1, 61.3, 60.9, 60.8, 61.7),
  age_skew = c(NA, NA, NA, NA, NA, NA, NA, NA,
               -0.17, -0.10, -0.07, -0.10, -0.34, -0.12, -0.12, -0.37)
)

# Clinical calibration parameters (from FTT 1994)
L_mean <- 0.0003  # per year
L_max  <- 0.0005  # per year

# Function to compute Delta_max from nABCD for age
# nABCD represents the normalized area between CDFs
# Delta_max = nABCD / L  (in absolute risk scale)
# For age: nABCD is the distributional distance; clinical impact = nABCD * range * L
# Actually: Delta_max = integral |F-G| * L_max * range_of_age
# Simpler: Delta_max_clinical = nABCD * L (as proportion of max treatment effect difference)
# The nABCD for age can be converted: if age SD ~ 12 years,
# then the W1 distance ~ nABCD * (max - min) and Delta_max = W1 * L
# For simplicity: Delta_max = nABCD * sd_pooled * L * sqrt(2*pi)
# Actually the proper calculation:
# nABCD = W1 / (range), so W1 = nABCD * range
# For normal-ish: range ~ 6*SD, so W1 ~ nABCD * 6 * SD
# Delta_max = W1 * L = nABCD * 6 * SD * L

# But let's use a simpler direct interpretation:
# nABCD directly gives the normalized distributional difference
# Delta_max (max impact on treatment effect) = nABCD * L_age_scale
# where L_age_scale converts nABCD to clinical scale
# Following the paper framework: Delta_max = nABCD (already in [0,1] scale)
# and the clinical threshold is Delta_max < clinically acceptable difference

# For the paper application:
# nABCD(age) with L: clinical impact = nABCD * L * effective_range
# Let's define effective_range for age as ~60 years (range of adult AMI patients, roughly 30-90)
age_range <- 60  # effective range in years

anchors <- 9:16

for (anchor in anchors) {
  cat("=" |> rep(80) |> paste(collapse = ""), "\n")
  cat(sprintf("REGION %d AS ANCHOR (N=%d)\n", anchor, region_info$N[anchor]))
  cat("=" |> rep(80) |> paste(collapse = ""), "\n\n")

  # Get all pairs involving this anchor
  age_dat <- dat %>%
    filter(variable == "age") %>%
    filter(region_i == anchor | region_j == anchor) %>%
    mutate(partner = ifelse(region_i == anchor, region_j, region_i))

  sysbp_dat <- dat %>%
    filter(variable == "sysbp") %>%
    filter(region_i == anchor | region_j == anchor) %>%
    mutate(partner = ifelse(region_i == anchor, region_j, region_i))

  # Build pooling table
  pool_tbl <- data.frame(partner = 1:16) %>%
    filter(partner != anchor) %>%
    left_join(age_dat %>% select(partner, nABCD_age = nABCD), by = "partner") %>%
    left_join(sysbp_dat %>% select(partner, nABCD_sysbp = nABCD), by = "partner") %>%
    mutate(
      pool_age = ifelse(nABCD_age < threshold, "YES", "NO"),
      pool_sysbp = ifelse(nABCD_sysbp < threshold, "YES", "NO"),
      overall = case_when(
        pool_age == "YES" & pool_sysbp == "YES" ~ "BOTH_POOL",
        pool_age == "YES" & pool_sysbp == "NO"  ~ "AGE_ONLY",
        pool_age == "NO"  & pool_sysbp == "YES" ~ "SBP_ONLY",
        TRUE ~ "NEITHER"
      )
    )

  # Print pooling table
  cat("--- Pooling Decision Table ---\n")
  cat(sprintf("%-8s %10s %10s %8s %8s %12s\n",
              "Partner", "nABCD_age", "nABCD_sbp", "Age_OK", "SBP_OK", "Overall"))
  cat(strrep("-", 62), "\n")
  for (i in 1:nrow(pool_tbl)) {
    r <- pool_tbl[i, ]
    cat(sprintf("R%-7d %10.5f %10.5f %8s %8s %12s\n",
                r$partner, r$nABCD_age, r$nABCD_sysbp,
                r$pool_age, r$pool_sysbp, r$overall))
  }

  # Summary counts
  n_both <- sum(pool_tbl$overall == "BOTH_POOL")
  n_age_only <- sum(pool_tbl$overall == "AGE_ONLY")
  n_sbp_only <- sum(pool_tbl$overall == "SBP_ONLY")
  n_neither <- sum(pool_tbl$overall == "NEITHER")
  n_discordant <- n_age_only + n_sbp_only

  cat(sprintf("\nSummary: BOTH_POOL=%d, AGE_ONLY=%d, SBP_ONLY=%d, NEITHER=%d\n",
              n_both, n_age_only, n_sbp_only, n_neither))
  cat(sprintf("Discordant cases: %d (AGE_ONLY=%d, SBP_ONLY=%d)\n\n",
              n_discordant, n_age_only, n_sbp_only))

  # nABCD gradient analysis
  age_range_val <- range(pool_tbl$nABCD_age)
  sbp_range_val <- range(pool_tbl$nABCD_sysbp)
  cat(sprintf("nABCD gradient: age [%.4f - %.4f], sysbp [%.4f - %.4f]\n",
              age_range_val[1], age_range_val[2],
              sbp_range_val[1], sbp_range_val[2]))

  # Clinical calibration for age: Delta_max
  cat("\n--- Age: Clinical Calibration (Delta_max) ---\n")
  cat(sprintf("L_mean = %.4f/yr, L_max = %.4f/yr, effective age range = %d yr\n",
              L_mean, L_max, age_range))
  cat(sprintf("%-8s %10s %12s %12s %8s\n",
              "Partner", "nABCD_age", "Dmax_Lmean", "Dmax_Lmax", "Concern"))
  cat(strrep("-", 54), "\n")

  pool_tbl <- pool_tbl %>%
    mutate(
      # W1 approximation: nABCD * effective_range (in years of age difference)
      # Delta_max = W1 * L = nABCD * age_range * L
      dmax_lmean = nABCD_age * age_range * L_mean,
      dmax_lmax  = nABCD_age * age_range * L_max,
      # Clinical concern if Delta_max > 0.5% (0.005) absolute risk difference
      concern_lmean = ifelse(dmax_lmean > 0.005, "HIGH", "LOW"),
      concern_lmax  = ifelse(dmax_lmax > 0.005, "HIGH", "LOW")
    )

  for (i in 1:nrow(pool_tbl)) {
    r <- pool_tbl[i, ]
    cat(sprintf("R%-7d %10.5f %12.6f %12.6f %8s\n",
                r$partner, r$nABCD_age, r$dmax_lmean, r$dmax_lmax, r$concern_lmax))
  }

  # L* sensitivity analysis for sysbp
  cat("\n--- SysBP: L* Sensitivity Analysis ---\n")
  cat("L* = threshold / (nABCD * effective_range_sbp)\n")
  cat("If true L < L*, pooling is safe despite nABCD >= 0.05\n")
  sbp_eff_range <- 80  # effective range for sysbp (roughly 80-200 mmHg -> 120 range, conservative 80)
  # For each non-poolable sysbp partner, what L* would make it acceptable?
  # Clinical threshold for treatment effect difference: 0.005 (0.5% absolute risk)
  clin_threshold <- 0.005

  cat(sprintf("%-8s %10s %12s %20s\n",
              "Partner", "nABCD_sbp", "L*_needed", "Interpretation"))
  cat(strrep("-", 54), "\n")

  non_pool_sbp <- pool_tbl %>% filter(pool_sysbp == "NO")
  if (nrow(non_pool_sbp) > 0) {
    for (i in 1:nrow(non_pool_sbp)) {
      r <- non_pool_sbp[i, ]
      # L* such that nABCD * sbp_range * L* = clinical_threshold
      lstar <- clin_threshold / (r$nABCD_sysbp * sbp_eff_range)
      interp <- ifelse(lstar > 0.001, "Likely safe (L* large)",
                 ifelse(lstar > 0.0001, "Moderate concern",
                        "Stringent L needed"))
      cat(sprintf("R%-7d %10.5f %12.6f %20s\n",
                  r$partner, r$nABCD_sysbp, lstar, interp))
    }
  } else {
    cat("All partners poolable for sysbp -- no L* analysis needed.\n")
  }

  # Also show poolable partners for reference
  pool_sbp <- pool_tbl %>% filter(pool_sysbp == "YES")
  if (nrow(pool_sbp) > 0) {
    cat(sprintf("\n(Poolable sysbp partners: R%s -- no L* needed)\n",
                paste(pool_sbp$partner, collapse = ", R")))
  }

  # Story construction
  cat("\n--- STORY CONSTRUCTION ---\n\n")

  # Anchor characteristics
  ri <- region_info[region_info$region == anchor, ]
  cat(sprintf("Para 1 (Scenario): Region %d (N=%d) as anchor.\n", anchor, ri$N))
  if (!is.na(ri$age_mean)) {
    cat(sprintf("  Age: mean=%.1f, skew=%.2f; SysBP: mean=%.1f, skew=%.2f\n",
                ri$age_mean, ri$age_skew, ri$sysbp_mean, ri$sysbp_skew))
  }

  # Characterize anchor
  anchor_char <- "typical"
  if (!is.na(ri$sysbp_mean) && ri$sysbp_mean > 133) anchor_char <- "high-SBP outlier"
  if (!is.na(ri$age_skew) && abs(ri$age_skew) > 0.3) anchor_char <- paste0(anchor_char, ", skewed-age")
  if (!is.na(ri$N) && ri$N < 1500) anchor_char <- paste0(anchor_char, ", small-N")
  cat(sprintf("  Characterization: %s\n", anchor_char))

  # Para 2
  cat(sprintf("\nPara 2 (nABCD Summary): %d/15 partners poolable on BOTH EMs.\n", n_both))
  cat(sprintf("  %d poolable on age only, %d on sysbp only, %d on neither.\n",
              n_age_only, n_sbp_only, n_neither))
  n_pool_age <- sum(pool_tbl$pool_age == "YES")
  n_pool_sbp <- sum(pool_tbl$pool_sysbp == "YES")
  cat(sprintf("  Age: %d/15 poolable. SysBP: %d/15 poolable.\n", n_pool_age, n_pool_sbp))

  # Para 3: Age clinical calibration
  cat(sprintf("\nPara 3 (Age Clinical Calibration):\n"))
  max_dmax <- max(pool_tbl$dmax_lmax, na.rm = TRUE)
  cat(sprintf("  Max Delta_max (L_max=0.0005): %.6f\n", max_dmax))
  cat(sprintf("  Even worst-case age difference yields Delta_max = %.4f%%\n", max_dmax * 100))
  if (max_dmax < 0.01) {
    cat("  Conclusion: All age-based nABCD values are clinically negligible.\n")
    cat("  -> Even non-poolable age partners have minimal clinical impact.\n")
  } else {
    cat("  Some partners show non-trivial clinical impact from age differences.\n")
  }

  # Para 4: SysBP L* sensitivity
  cat(sprintf("\nPara 4 (SysBP L* Sensitivity):\n"))
  if (nrow(non_pool_sbp) > 0) {
    lstar_vals <- clin_threshold / (non_pool_sbp$nABCD_sysbp * sbp_eff_range)
    cat(sprintf("  %d non-poolable sysbp partners.\n", nrow(non_pool_sbp)))
    cat(sprintf("  L* range: [%.6f, %.6f]\n", min(lstar_vals), max(lstar_vals)))
    cat(sprintf("  If true L_sbp < %.6f, ALL would become acceptable.\n", min(lstar_vals)))
    cat(sprintf("  If true L_sbp < %.6f, SOME would become acceptable.\n", max(lstar_vals)))
  } else {
    cat("  All partners poolable for sysbp. L* analysis is moot.\n")
  }

  # Para 5: Discordant cases
  cat(sprintf("\nPara 5 (Discordant Cases):\n"))
  if (n_discordant > 0) {
    disc <- pool_tbl %>% filter(overall %in% c("AGE_ONLY", "SBP_ONLY"))
    for (i in 1:nrow(disc)) {
      r <- disc[i, ]
      cat(sprintf("  R%d: %s (age=%.4f, sysbp=%.4f) -- %s\n",
                  r$partner, r$overall, r$nABCD_age, r$nABCD_sysbp,
                  ifelse(r$overall == "AGE_ONLY",
                         "age similar but sysbp distributions differ",
                         "sysbp similar but age distributions differ")))
    }
    cat(sprintf("  Key narrative: %d regions show EM-specific poolability.\n", n_discordant))
    cat("  This demonstrates why multi-EM assessment is essential.\n")
  } else {
    cat("  No discordant cases -- all partners consistent across EMs.\n")
    cat("  Narrative: pooling decisions are robust to EM choice.\n")
  }

  # Para 6: Recommendation
  cat(sprintf("\nPara 6 (Pooling Recommendation):\n"))
  both_partners <- pool_tbl %>% filter(overall == "BOTH_POOL")
  if (nrow(both_partners) > 0) {
    total_N_pooled <- sum(region_info$N[both_partners$partner]) + ri$N
    cat(sprintf("  Recommend pooling with R%s\n",
                paste(both_partners$partner, collapse = ", R")))
    cat(sprintf("  Pooled sample size: N=%d (anchor) + %d (partners) = %d\n",
                ri$N,
                sum(region_info$N[both_partners$partner]),
                total_N_pooled))
  } else {
    cat("  No partners poolable on both EMs. Region must stand alone or\n")
    cat("  justify pooling via clinical calibration / L* arguments.\n")
  }

  # Quality assessment
  cat("\n--- STORY QUALITY ASSESSMENT ---\n")

  score_balance <- 0
  total <- 15
  # Ideal: mix of outcomes (not all one category)
  entropy_like <- -sum(sapply(c(n_both, n_age_only, n_sbp_only, n_neither), function(x) {
    p <- x / total
    if (p > 0) p * log(p) else 0
  }))
  # Max entropy for 4 categories: log(4) = 1.386
  score_balance <- min(5, round(entropy_like / 1.386 * 5, 1))

  score_discordant <- min(5, round(n_discordant / 4 * 5, 1))

  # Gradient: range of nABCD values
  age_spread <- diff(age_range_val)
  sbp_spread <- diff(sbp_range_val)
  avg_spread <- (age_spread + sbp_spread) / 2
  score_gradient <- min(5, round(avg_spread / 0.10 * 5, 1))

  # Clinical calibration interest
  dmax_spread <- max(pool_tbl$dmax_lmax) - min(pool_tbl$dmax_lmax)
  score_calib <- min(5, round(dmax_spread / 0.002 * 5, 1))

  # L* analysis interest: more non-poolable sbp = more material
  score_lstar <- if (nrow(non_pool_sbp) >= 3 && nrow(non_pool_sbp) <= 10) {
    min(5, round(nrow(non_pool_sbp) / 5 * 4, 1))
  } else if (nrow(non_pool_sbp) > 0) {
    2
  } else {
    1
  }

  # Anchor typicality (moderate is best; extreme or perfectly average both interesting)
  score_anchor <- 3  # default
  if (!is.na(ri$sysbp_mean)) {
    if (ri$sysbp_mean > 133) score_anchor <- 5  # extreme = very interesting
    else if (abs(ri$sysbp_mean - 128) < 2) score_anchor <- 3  # typical
    else score_anchor <- 4  # slightly distinctive
  }
  if (!is.na(ri$N) && ri$N < 1500) score_anchor <- score_anchor + 0.5
  if (!is.na(ri$age_skew) && abs(ri$age_skew) > 0.3) score_anchor <- score_anchor + 0.5
  score_anchor <- min(5, score_anchor)

  overall_score <- round(mean(c(score_balance, score_discordant, score_gradient,
                                 score_calib, score_lstar, score_anchor)), 1)

  cat(sprintf("  Balance (poolable/non-poolable mix):   %.1f / 5\n", score_balance))
  cat(sprintf("  Discordant cases (number & quality):   %.1f / 5\n", score_discordant))
  cat(sprintf("  nABCD gradient (spread of values):     %.1f / 5\n", score_gradient))
  cat(sprintf("  Clinical calibration interest:         %.1f / 5\n", score_calib))
  cat(sprintf("  L* sensitivity interest:               %.1f / 5\n", score_lstar))
  cat(sprintf("  Anchor characterization interest:      %.1f / 5\n", score_anchor))
  cat(sprintf("  *** OVERALL SCORE: %.1f / 5 ***\n", overall_score))

  cat("\n\n")
}

# Final ranking
cat("=" |> rep(80) |> paste(collapse = ""), "\n")
cat("FINAL RANKING SUMMARY\n")
cat("=" |> rep(80) |> paste(collapse = ""), "\n\n")

scores <- data.frame(anchor = integer(), overall = numeric())

for (anchor in anchors) {
  age_dat <- dat %>%
    filter(variable == "age", region_i == anchor | region_j == anchor) %>%
    mutate(partner = ifelse(region_i == anchor, region_j, region_i))
  sysbp_dat <- dat %>%
    filter(variable == "sysbp", region_i == anchor | region_j == anchor) %>%
    mutate(partner = ifelse(region_i == anchor, region_j, region_i))

  pool_tbl <- data.frame(partner = 1:16) %>%
    filter(partner != anchor) %>%
    left_join(age_dat %>% select(partner, nABCD_age = nABCD), by = "partner") %>%
    left_join(sysbp_dat %>% select(partner, nABCD_sysbp = nABCD), by = "partner") %>%
    mutate(
      pool_age = ifelse(nABCD_age < threshold, "YES", "NO"),
      pool_sysbp = ifelse(nABCD_sysbp < threshold, "YES", "NO"),
      overall_cat = case_when(
        pool_age == "YES" & pool_sysbp == "YES" ~ "BOTH_POOL",
        pool_age == "YES" & pool_sysbp == "NO"  ~ "AGE_ONLY",
        pool_age == "NO"  & pool_sysbp == "YES" ~ "SBP_ONLY",
        TRUE ~ "NEITHER"
      )
    )

  n_both <- sum(pool_tbl$overall_cat == "BOTH_POOL")
  n_age_only <- sum(pool_tbl$overall_cat == "AGE_ONLY")
  n_sbp_only <- sum(pool_tbl$overall_cat == "SBP_ONLY")
  n_neither <- sum(pool_tbl$overall_cat == "NEITHER")
  n_discordant <- n_age_only + n_sbp_only
  total <- 15

  ri <- region_info[region_info$region == anchor, ]

  age_range_val <- range(pool_tbl$nABCD_age)
  sbp_range_val <- range(pool_tbl$nABCD_sysbp)

  pool_tbl <- pool_tbl %>%
    mutate(dmax_lmax = nABCD_age * age_range * L_max)

  non_pool_sbp <- pool_tbl %>% filter(pool_sysbp == "NO")

  entropy_like <- -sum(sapply(c(n_both, n_age_only, n_sbp_only, n_neither), function(x) {
    p <- x / total; if (p > 0) p * log(p) else 0
  }))
  score_balance <- min(5, round(entropy_like / 1.386 * 5, 1))
  score_discordant <- min(5, round(n_discordant / 4 * 5, 1))
  avg_spread <- (diff(age_range_val) + diff(sbp_range_val)) / 2
  score_gradient <- min(5, round(avg_spread / 0.10 * 5, 1))
  dmax_spread <- max(pool_tbl$dmax_lmax) - min(pool_tbl$dmax_lmax)
  score_calib <- min(5, round(dmax_spread / 0.002 * 5, 1))
  score_lstar <- if (nrow(non_pool_sbp) >= 3 && nrow(non_pool_sbp) <= 10) {
    min(5, round(nrow(non_pool_sbp) / 5 * 4, 1))
  } else if (nrow(non_pool_sbp) > 0) { 2 } else { 1 }
  score_anchor <- 3
  if (!is.na(ri$sysbp_mean)) {
    if (ri$sysbp_mean > 133) score_anchor <- 5
    else if (abs(ri$sysbp_mean - 128) < 2) score_anchor <- 3
    else score_anchor <- 4
  }
  if (!is.na(ri$N) && ri$N < 1500) score_anchor <- score_anchor + 0.5
  if (!is.na(ri$age_skew) && abs(ri$age_skew) > 0.3) score_anchor <- score_anchor + 0.5
  score_anchor <- min(5, score_anchor)

  overall_score <- round(mean(c(score_balance, score_discordant, score_gradient,
                                 score_calib, score_lstar, score_anchor)), 1)

  scores <- rbind(scores, data.frame(anchor = anchor, overall = overall_score,
                                      both = n_both, age_only = n_age_only,
                                      sbp_only = n_sbp_only, neither = n_neither,
                                      discordant = n_discordant))
}

scores <- scores %>% arrange(desc(overall))
cat(sprintf("%-8s %8s %6s %9s %9s %8s %10s\n",
            "Anchor", "Score", "Both", "Age_Only", "SBP_Only", "Neither", "Discordant"))
cat(strrep("-", 62), "\n")
for (i in 1:nrow(scores)) {
  s <- scores[i, ]
  cat(sprintf("R%-7d %8.1f %6d %9d %9d %8d %10d\n",
              s$anchor, s$overall, s$both, s$age_only, s$sbp_only, s$neither, s$discordant))
}

cat("\nRecommendation: Top anchors for Application section showcase.\n")
cat(sprintf("Best anchor from R9-16: Region %d (score=%.1f)\n",
            scores$anchor[1], scores$overall[1]))
