#!/usr/bin/env Rscript
# study2_mcse.R — single writer of results/study2_mcse.csv: Monte Carlo standard errors of every Study 2 performance
# measure (bias, RMSE, mean CI width, coverage), computed from the canonical per-replicate output
# results/w1_raw_simulation.rds ($rep_data, the 2026-05-17 run summarised by R/study1_summary_exact.R).
# Formulas (Morris, White & Crowther 2019, Stat Med 38:2074, Table 6; n = number of valid replications):
#   MCSE(bias)      = sd(est) / sqrt(n)
#   MCSE(RMSE)      = sd((est - theta)^2) / (sqrt(n) * 2 * RMSE)        (delta method from MCSE(MSE) = sd((est-theta)^2)/sqrt(n))
#   MCSE(mean width)= sd(upper - lower) / sqrt(n)
#   MCSE(coverage)  = sqrt(p (1 - p) / n)
# Deterministic: no RNG. The summaries themselves stay in w1_raw_summary.csv (single writer study1_summary_exact.R).
# Usage: Rscript projects/similarity-metric/R/study2_mcse.R   (from the repo root or the project dir)
proj <- if (file.exists("results/w1_raw_summary.csv")) "." else "projects/similarity-metric"
IN_RDS <- file.path(proj, "results", "w1_raw_simulation.rds")
IN_CSV <- file.path(proj, "results", "w1_raw_summary.csv")
OUT    <- file.path(proj, "results", "study2_mcse.csv")
sim <- readRDS(IN_RDS); rep_data <- sim$rep_data
summ <- read.csv(IN_CSV, stringsAsFactors = FALSE)
rows <- lapply(seq_len(nrow(summ)), function(i) {
  key <- paste(summ$scenario[i], summ$n[i], sep = "-"); stopifnot(key %in% names(rep_data))
  m <- rep_data[[key]]; est <- m[, "estimate"]; lo <- m[, "ci_lower"]; hi <- m[, "ci_upper"]
  ok <- !is.na(est) & !is.na(lo) & !is.na(hi); est <- est[ok]; lo <- lo[ok]; hi <- hi[ok]
  n <- length(est); theta <- summ$true_W1[i]
  rmse <- sqrt(mean((est - theta)^2)); p <- mean(lo <= theta & theta <= hi)
  stopifnot(abs(rmse - summ$rmse[i]) < 1e-9, abs(p - summ$coverage_pct[i]) < 1e-12, n == summ$n_valid[i])
  data.frame(scenario = summ$scenario[i], n = summ$n[i], n_valid = n,
             mcse_bias = sd(est) / sqrt(n),
             mcse_rmse = sd((est - theta)^2) / (sqrt(n) * 2 * rmse),
             mcse_ci_width = sd(hi - lo) / sqrt(n),
             mcse_coverage = sqrt(p * (1 - p) / n), stringsAsFactors = FALSE)
})
out <- do.call(rbind, rows)
write.csv(out, OUT, row.names = FALSE)
writeLines(capture.output(sessionInfo()), file.path(proj, "results", "study2_mcse_sessionInfo.txt"))
cat(sprintf("study2_mcse: wrote %s (%d rows)\n", OUT, nrow(out)))
print(round(apply(out[, 4:7], 2, max), 4))
