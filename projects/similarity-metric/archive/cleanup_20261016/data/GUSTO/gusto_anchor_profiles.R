#!/usr/bin/env Rscript
# =============================================================================
# GUSTO-I: Anchor-by-anchor profile analysis
# For each of 16 regions as anchor, summarize nABCD/SMD to 15 partners
# =============================================================================
suppressPackageStartupMessages({
  library(tidyverse)
})

all_pw <- read_csv(
  "C:/Users/hrd13/Documents/Gak/0 Study/800Claude/20260210_SIM/similarity_metrics/projects/similarity-metric/data/GUSTO/gusto_all_pairwise.csv",
  show_col_types = FALSE
)

regions <- 1:16
em_vars <- c("sysbp", "age")

for (v in em_vars) {
  cat(sprintf("\n========== %s: Anchor-by-Anchor Profile ==========\n\n", toupper(v)))

  pw <- all_pw %>% filter(var == v)

  # For each anchor, extract 15 partner pairs
  anchor_summaries <- list()

  for (anc in regions) {
    # Get pairs involving this anchor
    pairs <- pw %>%
      filter(region_i == anc | region_j == anc) %>%
      mutate(
        partner = ifelse(region_i == anc, region_j, region_i)
      ) %>%
      arrange(nABCD)

    rho <- cor(pairs$nABCD, pairs$abs_SMD, method = "spearman")
    r_pear <- cor(pairs$nABCD, pairs$abs_SMD)

    # Count pairs where nABCD and SMD disagree on "negligible" (<0.05 nABCD, <0.1 SMD)
    pairs <- pairs %>%
      mutate(
        nABCD_negl = nABCD < 0.05,
        SMD_negl = abs_SMD < 0.1,
        disagree = nABCD_negl != SMD_negl
      )

    n_disagree <- sum(pairs$disagree)

    # nABCD says negligible but SMD doesn't (or vice versa)
    nabcd_only_negl <- sum(pairs$nABCD_negl & !pairs$SMD_negl)
    smd_only_negl <- sum(!pairs$nABCD_negl & pairs$SMD_negl)

    # Rank divergence
    pairs <- pairs %>%
      mutate(
        rank_nABCD = rank(nABCD),
        rank_SMD = rank(abs_SMD),
        rank_diff = rank_nABCD - rank_SMD
      )
    max_rank_div <- pairs %>% slice_max(abs(rank_diff), n = 1)

    anchor_summaries[[as.character(anc)]] <- tibble(
      anchor = anc,
      n_anchor = pairs$n_i[1],  # approximate
      median_nABCD = median(pairs$nABCD),
      mean_nABCD = mean(pairs$nABCD),
      max_nABCD = max(pairs$nABCD),
      min_nABCD = min(pairs$nABCD),
      rho_spearman = rho,
      r_pearson = r_pear,
      n_disagree = n_disagree,
      nabcd_only_negl = nabcd_only_negl,
      smd_only_negl = smd_only_negl,
      max_rank_div_partner = max_rank_div$partner[1],
      max_rank_div_val = max_rank_div$rank_diff[1]
    )
  }

  summary_df <- bind_rows(anchor_summaries)

  # Print summary table
  cat(sprintf("%-6s %6s %8s %8s %8s %8s %6s %8s %8s\n",
              "Anchor", "N", "med_nAB", "max_nAB", "rho_S", "rho_P", "disag", "maxRD_p", "maxRD_v"))
  for (i in seq_len(nrow(summary_df))) {
    s <- summary_df[i,]
    cat(sprintf("%-6d %6d %8.4f %8.4f %8.3f %8.3f %6d %8d %8d\n",
                s$anchor, s$n_anchor, s$median_nABCD, s$max_nABCD,
                s$rho_spearman, s$r_pearson, s$n_disagree,
                s$max_rank_div_partner, s$max_rank_div_val))
  }

  # Identify most interesting anchors
  cat("\n--- Story potential ---\n")

  # Lowest rho (most divergence between nABCD and SMD)
  low_rho <- summary_df %>% arrange(rho_spearman) %>% head(3)
  cat("Lowest Spearman rho (most nABCD vs SMD divergence):\n")
  for (i in seq_len(nrow(low_rho))) {
    cat(sprintf("  Region %d: rho=%.3f, max_nABCD=%.4f, disagree=%d\n",
                low_rho$anchor[i], low_rho$rho_spearman[i],
                low_rho$max_nABCD[i], low_rho$n_disagree[i]))
  }

  # Highest max nABCD (largest distributional difference from anchor)
  high_max <- summary_df %>% arrange(desc(max_nABCD)) %>% head(3)
  cat("Highest max nABCD (most heterogeneous anchor):\n")
  for (i in seq_len(nrow(high_max))) {
    cat(sprintf("  Region %d: max_nABCD=%.4f, rho=%.3f\n",
                high_max$anchor[i], high_max$max_nABCD[i],
                high_max$rho_spearman[i]))
  }

  # Most disagreements
  high_dis <- summary_df %>% arrange(desc(n_disagree)) %>% head(3)
  cat("Most disagreements (nABCD vs SMD on negligible):\n")
  for (i in seq_len(nrow(high_dis))) {
    cat(sprintf("  Region %d: disagree=%d (nABCD_only_negl=%d, SMD_only_negl=%d)\n",
                high_dis$anchor[i], high_dis$n_disagree[i],
                high_dis$nabcd_only_negl[i], high_dis$smd_only_negl[i]))
  }

  cat("\n")

  # For top 3 interesting anchors, show detailed partner profile
  interesting <- unique(c(low_rho$anchor[1:2], high_dis$anchor[1]))

  for (anc in interesting) {
    cat(sprintf("\n--- Anchor = Region %d: Detailed Partner Profile ---\n", anc))
    pairs <- pw %>%
      filter(region_i == anc | region_j == anc) %>%
      mutate(partner = ifelse(region_i == anc, region_j, region_i)) %>%
      mutate(
        rank_nABCD = rank(nABCD),
        rank_SMD = rank(abs_SMD),
        rank_diff = rank_nABCD - rank_SMD
      ) %>%
      arrange(nABCD)

    cat(sprintf("%-8s %8s %8s %6s %6s %6s %8s %8s\n",
                "Partner", "nABCD", "|SMD|", "rk_nAB", "rk_SMD", "rk_dif", "skew_i", "skew_j"))
    for (j in seq_len(nrow(pairs))) {
      p <- pairs[j,]
      cat(sprintf("%-8d %8.4f %8.4f %6.0f %6.0f %6.0f %8.2f %8.2f\n",
                  p$partner, p$nABCD, p$abs_SMD,
                  p$rank_nABCD, p$rank_SMD, p$rank_diff,
                  p$skew_i, p$skew_j))
    }
  }
}
