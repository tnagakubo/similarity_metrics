library(tidyverse)
d <- read_csv("C:/Users/hrd13/Documents/Gak/0 Study/800Claude/20260210_SIM/similarity_metrics/projects/similarity-metric/data/GUSTO/gusto_smd_misleading.csv", show_col_types=FALSE)

cat("=== SMD says POOL but nABCD says DO NOT POOL ===\n")
cat("Condition: |SMD| < 0.1 AND nABCD >= 0.05\n\n")

mis <- d %>% filter(abs_SMD < 0.1, nABCD >= 0.05) %>% arrange(desc(ratio))
cat(sprintf("Total: %d cases\n\n", nrow(mis)))
cat(sprintf("%-8s %4s %4s %8s %8s %8s %8s %8s\n", "Var","Ri","Rj","nABCD","|SMD|","ratio","skew_d","sd_rat"))
for (i in seq_len(nrow(mis))) {
  r <- mis[i,]
  cat(sprintf("%-8s %4d %4d %8.4f %8.4f %8.2f %8.2f %8.2f\n",
    r$variable, r$region_i, r$region_j, r$nABCD, r$abs_SMD,
    r$ratio, r$skew_diff, r$sd_ratio))
}

cat("\n=== nABCD says POOL but SMD says DO NOT POOL ===\n")
cat("Condition: nABCD < 0.05 AND |SMD| >= 0.1\n\n")
rev <- d %>% filter(nABCD < 0.05, abs_SMD >= 0.1) %>% arrange(desc(abs_SMD))
cat(sprintf("Total: %d cases\n", nrow(rev)))
if (nrow(rev) > 0) {
  for (i in seq_len(min(15, nrow(rev)))) {
    r <- rev[i,]
    cat(sprintf("%-8s %4d %4d  nABCD=%.4f  |SMD|=%.4f\n",
      r$variable, r$region_i, r$region_j, r$nABCD, r$abs_SMD))
  }
}

cat("\n=== Disagreement Summary by Variable ===\n")
cat(sprintf("%-8s %12s %12s %8s\n", "Var", "SMD_mislead", "nABCD_loose", "Agree"))
for (v in c("age","sysbp","pulse","height","weight")) {
  dv <- d %>% filter(variable == v)
  smd_mis <- sum(dv$abs_SMD < 0.1 & dv$nABCD >= 0.05)
  nab_loose <- sum(dv$nABCD < 0.05 & dv$abs_SMD >= 0.1)
  agree <- 120 - smd_mis - nab_loose
  cat(sprintf("%-8s %12d %12d %8d\n", v, smd_mis, nab_loose, agree))
}

# Anchor-level: for each anchor, which partners differ?
cat("\n=== Anchor-Level Pooling Comparison (all 5 vars) ===\n")
cat("For each anchor: SMD_pool = |SMD|<0.1, nABCD_pool = nABCD<0.05\n")
cat("'SMD_only' = SMD says pool but nABCD says don't (dangerous!)\n\n")

regions <- 1:16
for (v in c("age","sysbp","pulse","height","weight")) {
  dv <- d %>% filter(variable == v)
  cat(sprintf("--- %s ---\n", toupper(v)))

  for (anc in regions) {
    pairs <- dv %>% filter(region_i == anc | region_j == anc) %>%
      mutate(partner = ifelse(region_i == anc, region_j, region_i))

    smd_pool <- pairs %>% filter(abs_SMD < 0.1) %>% pull(partner)
    nab_pool <- pairs %>% filter(nABCD < 0.05) %>% pull(partner)
    smd_only <- setdiff(smd_pool, nab_pool)  # dangerous: SMD says OK but nABCD says NO
    nab_only <- setdiff(nab_pool, smd_pool)  # nABCD more lenient

    if (length(smd_only) > 0) {
      cat(sprintf("  Anc=%2d: SMD_only_pool={%s} <- SMD MISLEADING\n",
        anc, paste(smd_only, collapse=",")))
      # Show details for these dangerous pairs
      for (p in smd_only) {
        row <- pairs %>% filter(partner == p)
        cat(sprintf("           Partner %d: nABCD=%.4f |SMD|=%.4f skew_d=%.2f sd_rat=%.2f\n",
          p, row$nABCD, row$abs_SMD, row$skew_diff, row$sd_ratio))
      }
    }
  }
  cat("\n")
}

# Multi-variable: partners that are SMD-misleading in 2+ variables
cat("=== Multi-Variable SMD Misleading ===\n")
cat("Partners where SMD misleads for 2+ variables from same anchor\n\n")
for (anc in regions) {
  misleading_by_var <- list()
  for (v in c("age","sysbp","pulse","height","weight")) {
    dv <- d %>% filter(variable == v)
    pairs <- dv %>% filter(region_i == anc | region_j == anc) %>%
      mutate(partner = ifelse(region_i == anc, region_j, region_i))
    smd_pool <- pairs %>% filter(abs_SMD < 0.1) %>% pull(partner)
    nab_pool <- pairs %>% filter(nABCD < 0.05) %>% pull(partner)
    smd_only <- setdiff(smd_pool, nab_pool)
    if (length(smd_only) > 0) misleading_by_var[[v]] <- smd_only
  }

  if (length(misleading_by_var) >= 2) {
    all_partners <- unique(unlist(misleading_by_var))
    for (p in all_partners) {
      vars_affected <- names(misleading_by_var)[sapply(misleading_by_var, function(x) p %in% x)]
      if (length(vars_affected) >= 2) {
        cat(sprintf("  Anchor %d -> Partner %d: SMD misleading in %s\n",
          anc, p, paste(vars_affected, collapse=", ")))
      }
    }
  }
}
