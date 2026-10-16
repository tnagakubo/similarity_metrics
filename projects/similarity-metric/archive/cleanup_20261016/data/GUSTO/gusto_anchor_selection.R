library(tidyverse)
d <- read_csv("C:/Users/hrd13/Documents/Gak/0 Study/800Claude/20260210_SIM/similarity_metrics/projects/similarity-metric/data/GUSTO/gusto_smd_misleading.csv", show_col_types=FALSE)

age <- d %>% filter(variable == "age")
sbp <- d %>% filter(variable == "sysbp")
regions <- 1:16

# Region sample sizes
region_n <- c(2188,2952,2030,2876,1909,1585,3150,2916,3123,1717,2491,4352,2297,3437,2576,1231)

cat("================================================================\n")
cat("Anchor Selection: age + sysbp combined assessment\n")
cat("================================================================\n\n")

# For each anchor, compute:
# - age: poolable partners (nABCD < 0.05), non-poolable, range of nABCD
# - sysbp: same
# - BOTH: poolable in both
# - Discordant: poolable in one EM but not the other
# - nABCD spread (interesting if there's a gradient, not all similar)

results <- list()
for (anc in regions) {
  # age pairs
  a <- age %>% filter(region_i == anc | region_j == anc) %>%
    mutate(partner = ifelse(region_i == anc, region_j, region_i)) %>%
    select(partner, nABCD_age = nABCD, SMD_age = abs_SMD)

  # sysbp pairs
  s <- sbp %>% filter(region_i == anc | region_j == anc) %>%
    mutate(partner = ifelse(region_i == anc, region_j, region_i)) %>%
    select(partner, nABCD_sysbp = nABCD, SMD_sysbp = abs_SMD)

  combined <- inner_join(a, s, by = "partner")

  pool_age <- combined %>% filter(nABCD_age < 0.05) %>% pull(partner)
  pool_sbp <- combined %>% filter(nABCD_sysbp < 0.05) %>% pull(partner)
  pool_both <- intersect(pool_age, pool_sbp)

  # Discordant: one EM says pool, other says don't
  age_only <- setdiff(pool_age, pool_sbp)  # age OK but sysbp NO
  sbp_only <- setdiff(pool_sbp, pool_age)  # sysbp OK but age NO
  neither <- setdiff(regions[regions != anc], union(pool_age, pool_sbp))

  results[[anc]] <- tibble(
    anchor = anc,
    N = region_n[anc],
    pool_age = length(pool_age),
    pool_sbp = length(pool_sbp),
    pool_both = length(pool_both),
    age_only = length(age_only),
    sbp_only = length(sbp_only),
    neither = length(neither),
    discordant = length(age_only) + length(sbp_only),
    range_nABCD_age = sprintf("%.3f-%.3f", min(combined$nABCD_age), max(combined$nABCD_age)),
    range_nABCD_sbp = sprintf("%.3f-%.3f", min(combined$nABCD_sysbp), max(combined$nABCD_sysbp)),
    max_nABCD_age = max(combined$nABCD_age),
    max_nABCD_sbp = max(combined$nABCD_sysbp)
  )
}

res_df <- bind_rows(results)

cat(sprintf("%-5s %5s %6s %6s %6s %6s %6s %6s %6s %16s %16s\n",
  "Anc","N","p_age","p_sbp","p_both","a_only","s_only","neith","disc",
  "range_age","range_sbp"))
for (i in seq_len(nrow(res_df))) {
  r <- res_df[i,]
  cat(sprintf("%-5d %5d %6d %6d %6d %6d %6d %6d %6d %16s %16s\n",
    r$anchor, r$N, r$pool_age, r$pool_sbp, r$pool_both,
    r$age_only, r$sbp_only, r$neither, r$discordant,
    r$range_nABCD_age, r$range_nABCD_sbp))
}

# Story quality scoring
cat("\n================================================================\n")
cat("Story Quality Assessment\n")
cat("================================================================\n")
cat("\nCriteria for good anchor:\n")
cat("  1. Mix of poolable/non-poolable (not all yes or all no)\n")
cat("  2. Discordant pairs (age and sysbp give different conclusions)\n")
cat("  3. Reasonable N (credible as an anchor region)\n")
cat("  4. nABCD gradient (not all clustered at one end)\n\n")

res_df <- res_df %>%
  mutate(
    # Pool mix: ideally 4-10 in BOTH, some in neither
    mix_score = pmin(pool_both, 15 - pool_both),  # higher = more balanced
    # Discordant: more = more interesting
    disc_score = discordant,
    # N: prefer larger
    n_score = ifelse(N >= 2000, 2, ifelse(N >= 1500, 1, 0)),
    # Total
    total_score = mix_score + disc_score * 2 + n_score
  ) %>%
  arrange(desc(total_score))

cat(sprintf("%-5s %5s %6s %6s %6s %6s %6s\n",
  "Anc","N","both","disc","mix_s","disc_s","TOTAL"))
for (i in seq_len(nrow(res_df))) {
  r <- res_df[i,]
  cat(sprintf("%-5d %5d %6d %6d %6d %6d %6d\n",
    r$anchor, r$N, r$pool_both, r$discordant,
    r$mix_score, r$disc_score, r$total_score))
}

# Top 5 candidates: detailed partner tables
cat("\n================================================================\n")
cat("Top Anchor Candidates: Detailed Partner Tables\n")
cat("================================================================\n")

top_anchors <- res_df$anchor[1:5]
for (anc in top_anchors) {
  cat(sprintf("\n--- Anchor = Region %d (N=%d) ---\n", anc, region_n[anc]))

  a <- age %>% filter(region_i == anc | region_j == anc) %>%
    mutate(partner = ifelse(region_i == anc, region_j, region_i)) %>%
    select(partner, nABCD_age = nABCD, SMD_age = abs_SMD,
           skew_age_i = skew_i, skew_age_j = skew_j)
  s <- sbp %>% filter(region_i == anc | region_j == anc) %>%
    mutate(partner = ifelse(region_i == anc, region_j, region_i)) %>%
    select(partner, nABCD_sysbp = nABCD, SMD_sysbp = abs_SMD,
           skew_sbp_i = skew_i, skew_sbp_j = skew_j)

  combined <- inner_join(a, s, by = "partner") %>%
    mutate(
      pool_age = ifelse(nABCD_age < 0.05, "Y", "N"),
      pool_sbp = ifelse(nABCD_sysbp < 0.05, "Y", "N"),
      pool_both = ifelse(pool_age == "Y" & pool_sbp == "Y", "POOL", ""),
      status = case_when(
        pool_age == "Y" & pool_sbp == "Y" ~ "BOTH_POOL",
        pool_age == "Y" & pool_sbp == "N" ~ "AGE_ONLY",
        pool_age == "N" & pool_sbp == "Y" ~ "SBP_ONLY",
        TRUE ~ "NEITHER"
      )
    ) %>%
    arrange(status, nABCD_age)

  cat(sprintf("%-6s %8s %8s %5s %8s %8s %5s %12s\n",
    "Partn","nABCD_a","SMD_a","age?","nABCD_s","SMD_s","sbp?","status"))
  for (j in seq_len(nrow(combined))) {
    r <- combined[j,]
    cat(sprintf("%-6d %8.4f %8.4f %5s %8.4f %8.4f %5s %12s\n",
      r$partner, r$nABCD_age, r$SMD_age, r$pool_age,
      r$nABCD_sysbp, r$SMD_sysbp, r$pool_sbp, r$status))
  }

  # Summary
  cat(sprintf("  Summary: BOTH_POOL=%d, AGE_ONLY=%d, SBP_ONLY=%d, NEITHER=%d\n",
    sum(combined$status == "BOTH_POOL"),
    sum(combined$status == "AGE_ONLY"),
    sum(combined$status == "SBP_ONLY"),
    sum(combined$status == "NEITHER")))
}
