# Referee recomputation 02 -- Study 2 (Section 3.2, Tables 2-4 of the estimation study, registry ranges)
# Base R only. Run from the project root:
#   Rscript review_response/referee/20261011/r02_study2.R
# Recomputes every cell of tab_bias / tab_coverage / tab_precision from the per-replicate
# file results/w1_raw_simulation.rds using the quadrature truths, independently of the
# authors' summary step; recomputes the true W1 values; recomputes the miss-side shares
# against the quadrature truth; and expresses every coverage cell in Monte Carlo SE units.
OUT <- "review_response/referee/20261011"
sink(file.path(OUT, "r02_study2.txt"), split = TRUE)

## ---- true W1 by quadrature (independent) ----
f6 <- function(t) abs(pnorm(t, 50, 10) - plnorm(t, log(50) - 0.125, 0.5))
s6 <- integrate(function(t) pnorm(t, 50, 10), -Inf, 0, rel.tol = 1e-12)$value +
      integrate(f6, 0, Inf, rel.tol = 1e-12, subdivisions = 5000L)$value
s7 <- integrate(function(t) abs(pnorm(t, 50, 10) - pnorm(t, 55, 15)), -Inf, Inf, rel.tol = 1e-12, subdivisions = 5000L)$value
# quantile-form cross-check
q6 <- integrate(function(u) abs(qnorm(u, 50, 10) - qlnorm(u, log(50) - 0.125, 0.5)), 0, 1, rel.tol = 1e-10, subdivisions = 5000L)$value
q7 <- integrate(function(u) abs(qnorm(u, 50, 10) - qnorm(u, 55, 15)), 0, 1, rel.tol = 1e-10, subdivisions = 5000L)$value
truth <- c(S1 = 0, S2 = 2, S3 = 5, S4 = 10, S5 = sqrt(2 / pi) * 5, S6 = s6, S7 = s7)
cat(sprintf("true W1: S5 %.6f | S6 %.6f (quantile form %.6f) | S7 %.6f (quantile form %.6f)\n", truth["S5"], s6, q6, s7, q7))
mu6 <- log(50) - 0.125
cat(sprintf("S6 lognormal: mu_log %.4f mean %.4f sd %.4f cv %.4f skew %.4f\n", mu6, exp(mu6 + 0.125),
            50 * sqrt(exp(0.25) - 1), sqrt(exp(0.25) - 1), (exp(0.25) + 2) * sqrt(exp(0.25) - 1)))

## ---- per-replicate recomputation ----
x <- readRDS("results/w1_raw_simulation.rds")
cat("rds embedded truths (S6, S7):", x$summary$true_W1[x$summary$scenario == "S6"][1], x$summary$true_W1[x$summary$scenario == "S7"][1], "\n")
rows <- lapply(names(x$rep_data), function(k) {
  d <- x$rep_data[[k]]; sc <- sub("-.*", "", k); n <- as.integer(sub(".*-", "", k)); t <- truth[[sc]]
  e <- d[, "estimate"]; L <- d[, "ci_lower"]; U <- d[, "ci_upper"]
  cov <- mean(L <= t & t <= U)
  data.frame(scenario = sc, n = n, bias = mean(e) - t, rmse = sqrt(mean((e - t)^2)), width = mean(U - L),
             coverage = cov, mcse_cov = sqrt(cov * (1 - cov) / length(e)),
             z_vs_0.95 = (cov - 0.95) / sqrt(0.95 * 0.05 / length(e)),
             miss_below = mean(L > t), miss_above = mean(U < t), q95 = quantile(e, 0.95, names = FALSE),
             mcse_bias = sd(e) / sqrt(length(e)))
})
r <- do.call(rbind, rows)
a <- read.csv("results/w1_raw_summary.csv")
r$d_bias <- signif(r$bias - a$bias, 3); r$d_cov <- signif(r$coverage - a$coverage_pct, 3)
r$d_rmse <- signif(r$rmse - a$rmse, 3); r$d_width <- signif(r$width - a$mean_ci_width, 3)
cat("\n== Study 2 cells recomputed from per-replicate data with quadrature truth (d_ = mine - w1_raw_summary.csv) ==\n")
print(r, row.names = FALSE, digits = 4)

ms <- read.csv("results/study1_miss_side.csv")
r$auth_miss_above <- ms$miss_above; r$auth_miss_below <- ms$miss_below
cat("\n== miss side: recomputed with quadrature truth vs results/study1_miss_side.csv (which uses the rds-embedded MC truth for S6/S7) ==\n")
print(r[, c("scenario", "n", "miss_below", "auth_miss_below", "miss_above", "auth_miss_above")], row.names = FALSE)
cat(sprintf("max miss_above over S2,S5,S7 (quadrature truth): %.4f ; authors' file: %.4f\n",
            max(r$miss_above[r$scenario %in% c("S2", "S5", "S7")]), max(ms$miss_above[grepl("^S[257]-", ms$cell)])))
cat(sprintf("cells with miss_above > 0.025: %s\n", paste(sprintf("%s-%d (%.4f)", r$scenario, r$n, r$miss_above)[r$miss_above > 0.025], collapse = ", ")))

## ---- registry ranges ----
s37 <- r[r$scenario %in% paste0("S", 3:7) & r$n >= 100, ]
cat(sprintf("\ncoverage S3-S7, n>=100: %.4f - %.4f\n", min(s37$coverage), max(s37$coverage)))
cat(sprintf("cells in S3-S7, n>=100 more than 2 MCSE below 0.95: %s\n",
            paste(sprintf("%s-%d (%.4f, z = %.1f)", s37$scenario, s37$n, s37$coverage, s37$z_vs_0.95)[s37$z_vs_0.95 < -2], collapse = "; ")))
cat(sprintf("all non-null cells more than 2 MCSE below 0.95: %d of 18\n", sum(r$z_vs_0.95[r$scenario != "S1"] < -2)))
nn <- r[r$scenario != "S1" & r$n == 100, ]; cat(sprintf("CI width at n=100, S2-S7: %.3f - %.3f\n", min(nn$width), max(nn$width)))
cat(sprintf("max bias S3-S7 at n=200: %.4f (%s)\n", max(r$bias[r$scenario %in% paste0("S", 3:7) & r$n == 200]),
            r$scenario[r$scenario %in% paste0("S", 3:7) & r$n == 200][which.max(r$bias[r$scenario %in% paste0("S", 3:7) & r$n == 200])]))
n200 <- r[r$n == 200, ]; cat(sprintf("RMSE at n=200: min %.3f (%s) max %.3f (%s)\n", min(n200$rmse), n200$scenario[which.min(n200$rmse)], max(n200$rmse), n200$scenario[which.max(n200$rmse)]))
cat(sprintf("Delta_max CI width example: 0.01 * %.4f = %.5f\n", r$width[r$scenario == "S3" & r$n == 100], 0.01 * r$width[r$scenario == "S3" & r$n == 100]))

## ---- bias decay ratios (text: S1, S2 'diminished slowly'; S3-S7 'diminished with sample size') ----
cat("\n== bias ratio per doubling of n (b(50)/b(100), b(100)/b(200)); sqrt(2) = 1.414 is the n^-1/2 rate ==\n")
for (sc in paste0("S", 1:7)) { b <- r$bias[r$scenario == sc]; cat(sprintf("%s: %.3f %.3f %.3f | ratios %.2f %.2f\n", sc, b[1], b[2], b[3], b[1] / b[2], b[2] / b[3])) }

## ---- signal-to-noise index of each Study 2 cell: sqrt(n/2) * W1 / sigma_1 (equal n, sigma_1 = 10) ----
r$snr <- sqrt(r$n / 2) * truth[r$scenario] / 10
cat("\n== coverage against the local signal-to-noise index sqrt(n_eff) * W1 / sigma (n_eff = n/2) ==\n")
print(r[order(r$snr), c("scenario", "n", "snr", "coverage", "miss_below", "miss_above")], row.names = FALSE, digits = 3)
sink()
writeLines(capture.output(sessionInfo()), file.path(OUT, "r02_sessionInfo.txt"))
