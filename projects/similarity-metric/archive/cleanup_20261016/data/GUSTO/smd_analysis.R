# SMD analysis for GUSTO Region 8 anchor
# Compare SMD-based similarity ranking with nABCD ranking
library(predtools)
data(gusto)

anchor <- 8
partners <- sort(setdiff(unique(gusto$regl), anchor))
vars <- c("age", "sysbp")

results <- data.frame()
for (v in vars) {
  x_a <- gusto[[v]][gusto$regl == anchor]
  for (p in partners) {
    x_p <- gusto[[v]][gusto$regl == p]
    n1 <- length(x_a); n2 <- length(x_p)
    s1 <- sd(x_a); s2 <- sd(x_p)
    s_pooled <- sqrt(((n1 - 1) * s1^2 + (n2 - 1) * s2^2) / (n1 + n2 - 2))
    smd <- (mean(x_a) - mean(x_p)) / s_pooled
    results <- rbind(results, data.frame(
      variable = v, partner = p,
      mean_anchor = mean(x_a), mean_partner = mean(x_p),
      sd_pooled = s_pooled, smd = smd, abs_smd = abs(smd),
      stringsAsFactors = FALSE
    ))
  }
}

cat("--- Age: ranked by |SMD| ascending (smaller = more similar) ---\n")
age_res <- results[results$variable == "age", ]
age_res <- age_res[order(abs(age_res$smd)), ]
age_res$rank_smd <- seq_len(nrow(age_res))
print(age_res, digits = 4, row.names = FALSE)

cat("\n--- SBP: ranked by |SMD| ascending ---\n")
sbp_res <- results[results$variable == "sysbp", ]
sbp_res <- sbp_res[order(abs(sbp_res$smd)), ]
sbp_res$rank_smd <- seq_len(nrow(sbp_res))
print(sbp_res, digits = 4, row.names = FALSE)

# Comparison: SMD ranking vs nABCD ranking (from gusto_r8_results.csv)
csv_path <- "C:/Users/hrd13/Documents/Gak/0 Study/800Claude/20260210_SIM/similarity_metrics/projects/similarity-metric/data/GUSTO/gusto_r8_results.csv"
if (file.exists(csv_path)) {
  nabcd <- read.csv(csv_path)
  cat("\n--- Combined: nABCD ranks vs SMD ranks ---\n")
  combined <- merge(
    nabcd[, c("partner", "nABCD_age", "nABCD_sysbp", "rank_age", "rank_sysbp")],
    rbind(
      transform(age_res, var = "age"),
      transform(sbp_res, var = "sbp")
    )[, c("partner", "var", "smd", "abs_smd", "rank_smd")],
    by = "partner"
  )
  combined_age <- combined[combined$var == "age", c("partner", "nABCD_age", "rank_age", "smd", "abs_smd", "rank_smd")]
  combined_age <- combined_age[order(combined_age$rank_age), ]
  cat("\n[Age] Partners ordered by nABCD rank, with SMD rank shown:\n")
  print(combined_age, digits = 4, row.names = FALSE)

  combined_sbp <- combined[combined$var == "sbp", c("partner", "nABCD_sysbp", "rank_sysbp", "smd", "abs_smd", "rank_smd")]
  combined_sbp <- combined_sbp[order(combined_sbp$rank_sysbp), ]
  cat("\n[SBP] Partners ordered by nABCD rank, with SMD rank shown:\n")
  print(combined_sbp, digits = 4, row.names = FALSE)

  cat("\n--- Rank correlation (Spearman) ---\n")
  cat("Age:", cor(combined_age$rank_age, combined_age$rank_smd, method = "spearman"), "\n")
  cat("SBP:", cor(combined_sbp$rank_sysbp, combined_sbp$rank_smd, method = "spearman"), "\n")
}

cat("\nDone.\n")
