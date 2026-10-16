library(tidyverse)
d <- read_csv("C:/Users/hrd13/Documents/Gak/0 Study/800Claude/20260210_SIM/similarity_metrics/projects/similarity-metric/data/GUSTO/gusto_smd_misleading.csv", show_col_types=FALSE)

sbp <- d %>% filter(variable == "sysbp") %>%
  mutate(rank_nABCD = rank(-nABCD),
         rank_SMD = rank(-abs_SMD),
         rank_diff = rank_nABCD - rank_SMD)

cat("================================================================\n")
cat("SYSBP Deep Dive: All 120 Pairwise Comparisons\n")
cat("================================================================\n\n")

# Full table sorted by nABCD
cat("--- All pairs sorted by nABCD (descending) ---\n")
cat(sprintf("%-4s %-4s %8s %8s %6s %8s %8s %8s %8s %6s %6s %6s\n",
  "Ri","Rj","nABCD","|SMD|","ratio","skew_i","skew_j","sd_i","sd_j","rk_n","rk_S","rk_d"))
s <- sbp %>% arrange(desc(nABCD))
for (i in seq_len(nrow(s))) {
  r <- s[i,]
  cat(sprintf("%-4d %-4d %8.4f %8.4f %6.2f %8.2f %8.2f %8.1f %8.1f %6d %6d %6d\n",
    r$region_i, r$region_j, r$nABCD, r$abs_SMD, r$ratio,
    r$skew_i, r$skew_j, r$sd_i, r$sd_j,
    r$rank_nABCD, r$rank_SMD, r$rank_diff))
}

# Region 5 specific analysis
cat("\n================================================================\n")
cat("Region 5 (skewness=1.32) — All 15 pairs involving Region 5\n")
cat("================================================================\n\n")
r5 <- sbp %>% filter(region_i == 5 | region_j == 5) %>%
  mutate(partner = ifelse(region_i == 5, region_j, region_i),
         partner_skew = ifelse(region_i == 5, skew_j, skew_i)) %>%
  arrange(nABCD)

cat(sprintf("%-6s %8s %8s %6s %10s %10s %8s\n",
  "Partn","nABCD","|SMD|","ratio","skew_part","skew_diff","sd_rat"))
for (i in seq_len(nrow(r5))) {
  r <- r5[i,]
  cat(sprintf("%-6d %8.4f %8.4f %6.2f %10.2f %10.2f %8.2f\n",
    r$partner, r$nABCD, r$abs_SMD, r$ratio,
    r$partner_skew, r$skew_diff, r$sd_ratio))
}

# Pooling comparison for Region 5 as anchor
cat("\n--- Region 5 as anchor: pooling decisions ---\n")
cat(sprintf("%-6s %8s %8s %10s %10s %10s\n",
  "Partn","nABCD","|SMD|","nABCD_pool","SMD_pool","disagree"))
for (i in seq_len(nrow(r5))) {
  r <- r5[i,]
  np <- r$nABCD < 0.05
  sp <- r$abs_SMD < 0.1
  dis <- ifelse(np != sp, ifelse(sp & !np, "SMD_MISLEAD", "nABCD_lenient"), "")
  cat(sprintf("%-6d %8.4f %8.4f %10s %10s %10s\n",
    r$partner, r$nABCD, r$abs_SMD,
    ifelse(np, "POOL", "NO"), ifelse(sp, "POOL", "NO"), dis))
}

# Varying thresholds for sysbp
cat("\n================================================================\n")
cat("Threshold Sensitivity: sysbp\n")
cat("================================================================\n\n")

nab_thresholds <- c(0.03, 0.04, 0.05, 0.06, 0.07)
smd_thresholds <- c(0.05, 0.10, 0.15, 0.20)

cat("SMD misleading count (SMD < threshold says pool, nABCD >= threshold says don't):\n")
cat(sprintf("%-12s", "nABCD_thresh"))
for (st in smd_thresholds) cat(sprintf(" SMD<%.2f", st))
cat("\n")

for (nt in nab_thresholds) {
  cat(sprintf("nABCD>=%.2f ", nt))
  for (st in smd_thresholds) {
    cnt <- sum(sbp$abs_SMD < st & sbp$nABCD >= nt)
    cat(sprintf(" %7d", cnt))
  }
  cat("\n")
}

cat("\nnABCD lenient count (nABCD < threshold says pool, SMD >= threshold says don't):\n")
cat(sprintf("%-12s", "nABCD_thresh"))
for (st in smd_thresholds) cat(sprintf(" SMD>=%.2f", st))
cat("\n")

for (nt in nab_thresholds) {
  cat(sprintf("nABCD<%.2f  ", nt))
  for (st in smd_thresholds) {
    cnt <- sum(sbp$nABCD < nt & sbp$abs_SMD >= st)
    cat(sprintf(" %7d", cnt))
  }
  cat("\n")
}

# Each anchor: pooling count comparison
cat("\n================================================================\n")
cat("Anchor-by-Anchor Pooling Count: sysbp\n")
cat("================================================================\n\n")
cat(sprintf("%-6s %6s %6s %6s %10s %45s\n",
  "Anchor","N","pool_n","pool_S","diff","SMD_only_pool (misleading)"))
for (anc in 1:16) {
  pairs <- sbp %>% filter(region_i == anc | region_j == anc) %>%
    mutate(partner = ifelse(region_i == anc, region_j, region_i))
  n_anc <- ifelse(anc <= 8,
    c(2188,2952,2030,2876,1909,1585,3150,2916)[anc],
    c(3123,1717,2491,4352,2297,3437,2576,1231)[anc-8])
  pool_n <- pairs %>% filter(nABCD < 0.05) %>% pull(partner) %>% sort()
  pool_s <- pairs %>% filter(abs_SMD < 0.1) %>% pull(partner) %>% sort()
  smd_only <- setdiff(pool_s, pool_n)
  nab_only <- setdiff(pool_n, pool_s)
  cat(sprintf("%-6d %6d %6d %6d %10d %45s\n",
    anc, n_anc, length(pool_n), length(pool_s),
    length(pool_n) - length(pool_s),
    ifelse(length(smd_only) > 0, paste("R", paste(smd_only, collapse=",R")), "-")))
}

# Region 16 special: it's outlier in mean but not in shape
cat("\n================================================================\n")
cat("Region 16 Analysis (highest mean=136.5, lowest SD=21.7)\n")
cat("================================================================\n\n")
r16 <- sbp %>% filter(region_i == 16 | region_j == 16) %>%
  mutate(partner = ifelse(region_i == 16, region_j, region_i)) %>%
  arrange(nABCD)
cat(sprintf("%-6s %8s %8s %6s %8s %8s\n", "Partn","nABCD","|SMD|","ratio","skew_p","sd_p"))
for (i in seq_len(nrow(r16))) {
  r <- r16[i,]
  ps <- ifelse(r$region_i == 16, r$skew_j, r$skew_i)
  psd <- ifelse(r$region_i == 16, r$sd_j, r$sd_i)
  cat(sprintf("%-6d %8.4f %8.4f %6.2f %8.2f %8.1f\n",
    r$partner, r$nABCD, r$abs_SMD, r$ratio, ps, psd))
}
cat("Region 16: skew=0.04, SD=21.7 -> low skew, low SD, high mean\n")
cat("All partners have nABCD >= 0.07. NO partners are poolable by nABCD.\n")
cat("SMD: only Region 2 (|SMD|=0.16) and 8 (|SMD|=0.18) are closest.\n")
