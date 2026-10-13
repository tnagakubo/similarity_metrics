#!/usr/bin/env Rscript
# study2_interval_variants.R — single writer of results/study2_interval_variants.csv
#
# EXPLORATORY sensitivity, added 2026-10-12 after the external review (review_response/EXTERNAL_REVIEW_20261012.md,
# M4(b)(c)(d)). Not pre-registered. See results/STUDY2_INTERVAL_VARIANTS_PROVENANCE.md.
#
# Source: the canonical per-replication matrix of Study 1 (results/w1_raw_simulation.rds, $rep_data[["S{k}-{n}"]],
# 10,000 x 3: estimate, ci_lower, ci_upper; percentile 95% CI with B = 2,000). Nothing is resampled again: the script
# re-summarises the stored (theta-hat, L, U) triples, so no random numbers are drawn and no seed is needed
# (a seed is declared anyway for the reproducibility checker; it is never consumed).
#
# Truth t: results/w1_raw_summary.csv true_W1 (exact; S6/S7 by quadrature, results/STUDY1_PROVENANCE.md).
# NEVER x$summary / x$truth (they still carry the Monte Carlo S6/S7 references).
#
# Per cell (n_valid = 10,000 replications r), with L_r, U_r the stored percentile limits and th_r the estimate:
#   cov_pct      = mean(L <= t & t <= U)                      (must equal w1_raw_summary coverage_pct; asserted)
#   cov_upper    = mean(t <= U)        one-sided 97.5% upper limit (= the upper percentile limit of the 95% CI)
#   miss_below   = mean(t <  L)        interval entirely above t
#   miss_above   = mean(t >  U)        identity: cov_pct = 1 - miss_below - miss_above (asserted)
#   basic interval [Lb, Ub] = [max(0, 2 th - U), max(0, 2 th - L)]  (reflected percentile limits, truncated at 0)
#   cov_basic    = mean(Lb <= t & t <= Ub);  width_basic = mean(Ub - Lb);  trunc_basic = mean(2 th - U < 0)
#   width_pct    = mean(U - L)
#   MCSE of a proportion p: sqrt(p (1 - p) / n_valid); MCSE of a mean width: sd(width) / sqrt(n_valid).
# Bias-corrected point estimate 2 th - mean(th*): NOT computable — the rds does not store the bootstrap mean (or any
# bootstrap replicate) per replication; only estimate, ci_lower, ci_upper. Column bc_available = FALSE records this.
SEED <- 20261012L   # declared, not consumed (no RNG in this script)
set.seed(SEED)

proj    <- if (file.exists("results/w1_raw_summary.csv")) "." else "projects/similarity-metric"
IN_RDS  <- file.path(proj, "results", "w1_raw_simulation.rds")
IN_SUM  <- file.path(proj, "results", "w1_raw_summary.csv")
IN_MS   <- file.path(proj, "results", "study1_miss_side.csv")
OUT_CSV <- file.path(proj, "results", "study2_interval_variants.csv")
OUT_SI  <- file.path(proj, "results", "study2_interval_variants_sessionInfo.txt")

x  <- readRDS(IN_RDS)
sm <- read.csv(IN_SUM, stringsAsFactors = FALSE)
ms <- read.csv(IN_MS, stringsAsFactors = FALSE)
sm$cell <- paste0(sm$scenario, "-", sm$n)
stopifnot(setequal(sm$cell, names(x$rep_data)))

pmcse <- function(p, n) sqrt(p * (1 - p) / n)
rows <- lapply(seq_len(nrow(sm)), function(i) {
  k <- sm$cell[i]; t <- sm$true_W1[i]; d <- x$rep_data[[k]]
  stopifnot(identical(colnames(d), c("estimate", "ci_lower", "ci_upper")), !anyNA(d))
  th <- d[, "estimate"]; L <- d[, "ci_lower"]; U <- d[, "ci_upper"]; n <- length(th)
  Lb <- pmax(0, 2 * th - U); Ub <- pmax(0, 2 * th - L)
  cov  <- mean(L <= t & t <= U); up <- mean(t <= U); below <- mean(t < L); above <- mean(t > U)
  covb <- mean(Lb <= t & t <= Ub)
  stopifnot(abs(cov - (1 - below - above)) < 1e-12, n == sm$n_valid[i])
  data.frame(cell = k, scenario = sm$scenario[i], n = sm$n[i], true_W1 = t, n_reps = n,
             cov_pct = cov, cov_pct_mcse = pmcse(cov, n),
             cov_upper = up, cov_upper_mcse = pmcse(up, n),
             miss_below = below, miss_below_mcse = pmcse(below, n),
             miss_above = above, miss_above_mcse = pmcse(above, n),
             width_pct = mean(U - L), width_pct_mcse = sd(U - L) / sqrt(n),
             cov_basic = covb, cov_basic_mcse = pmcse(covb, n),
             width_basic = mean(Ub - Lb), width_basic_mcse = sd(Ub - Lb) / sqrt(n),
             trunc_basic = mean(2 * th - U < 0), trunc_basic_mcse = pmcse(mean(2 * th - U < 0), n),
             bc_available = FALSE, stringsAsFactors = FALSE)
})
out <- do.call(rbind, rows)

# (i) reproduce w1_raw_summary.csv coverage_pct (to the 4th decimal and in fact exactly) and mean_ci_width
stopifnot(max(abs(out$cov_pct - sm$coverage_pct)) < 5e-5, max(abs(out$cov_pct - sm$coverage_pct)) < 1e-12)
stopifnot(max(abs(out$width_pct - sm$mean_ci_width)) < 1e-10)
# (iii) cross-check study1_miss_side.csv. That file used x$summary$true_W1 (MC truth for S6/S7), so equality is asserted
# for S1-S5 only; S6/S7 differences are printed and recorded in the provenance.
m <- merge(out[, c("cell", "scenario", "miss_below", "miss_above")], ms, by = "cell", suffixes = c("", "_ms"))
stopifnot(nrow(m) == 21)
s15 <- m$scenario %in% paste0("S", 1:5)
stopifnot(max(abs(m$miss_below[s15] - m$miss_below_ms[s15])) < 1e-12,
          max(abs(m$miss_above[s15] - m$miss_above_ms[s15])) < 1e-12)
cat("study1_miss_side.csv vs exact truth, S6/S7 (miss_below, miss_above):\n")
print(m[!s15, c("cell", "miss_below", "miss_below_ms", "miss_above", "miss_above_ms")], digits = 6, row.names = FALSE)

write.csv(out, OUT_CSV, row.names = FALSE)
writeLines(capture.output(sessionInfo()), OUT_SI)
print(out[, c("cell", "true_W1", "cov_pct", "cov_upper", "cov_upper_mcse", "miss_below", "cov_basic", "cov_basic_mcse",
              "width_pct", "width_basic", "trunc_basic")], digits = 4, row.names = FALSE)
cat("[save]", OUT_CSV, "\n")
