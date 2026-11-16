# Referee recomputation (2026-11-14): closed-form truths and every in-text number derivable from the result CSVs.
# Run from the project root: Rscript review_response/referee/20261114/recompute_sim_tables.R
out_dir <- "review_response/referee/20261114"

cat("=== Scenario truths ===\n")
w1_int <- function(F1, F2, lo, hi) integrate(function(x) abs(F1(x) - F2(x)), lo, hi, subdivisions = 5000L, rel.tol = 1e-10)$value
F0 <- function(x) pnorm(x, 50, 10)
mul <- log(50) - 0.5^2 / 2
cat("mu_log S6 =", mul, " SD S6 =", 50 * sqrt(exp(0.25) - 1), "\n")
truth <- c(
  S2 = w1_int(F0, function(x) pnorm(x, 52, 10), -100, 200),
  S3 = w1_int(F0, function(x) pnorm(x, 55, 10), -100, 200),
  S4 = w1_int(F0, function(x) pnorm(x, 60, 10), -100, 200),
  S5 = w1_int(F0, function(x) pnorm(x, 50, 15), -150, 250),
  S5closed = sqrt(2 / pi) * 5,
  S6 = w1_int(F0, function(x) plnorm(x, mul, 0.5), -100, 0) + w1_int(F0, function(x) plnorm(x, mul, 0.5), 0, 1000),
  S7 = w1_int(F0, function(x) pnorm(x, 55, 15), -150, 250),
  S7closed = 5 * ((2 * pnorm(1) - 1) + 2 * dnorm(1)))
print(round(truth, 6))
sds <- c(S3 = 5, S4 = 10, S5 = truth[["S5"]], S6 = truth[["S6"]], S7 = truth[["S7"]]) / 10
cat("W1 in SD units (S3-S7):", round(sds, 3), " range:", range(sds), "\n")

cat("\n=== Estimation study (results/w1_raw_summary.csv) ===\n")
s <- read.csv("results/w1_raw_summary.csv")
s$mcse_cov <- sqrt(s$coverage_pct * (1 - s$coverage_pct) / s$n_valid)
s$mcse_cov95 <- sqrt(0.95 * 0.05 / s$n_valid)
s$z_below <- (0.95 - s$coverage_pct) / s$mcse_cov
s$z_below95 <- (0.95 - s$coverage_pct) / s$mcse_cov95
s$mcse_bias <- s$sd_est / sqrt(s$n_valid)
print(s[, c("scenario", "n", "true_W1", "bias", "coverage_pct", "mcse_cov", "z_below", "z_below95", "mcse_bias")], digits = 4)
sub <- s[s$scenario %in% paste0("S", 3:7) & s$n >= 100, ]
cat("S3-S7 n>=100 coverage range:", range(sub$coverage_pct), "\n")
cat("cells > 2 MCSE (at p-hat) below 0.95:", sum(sub$z_below > 2), paste(sub$scenario[sub$z_below > 2], sub$n[sub$z_below > 2]), "\n")
cat("cells > 2 MCSE (at 0.95) below 0.95:", sum(sub$z_below95 > 2), "\n")
cat("max MCSE coverage (all 21):", max(s$mcse_cov), "; max MCSE bias:", max(s$mcse_bias), "\n")
cat("max bias S3-S7 n=200:", max(s$bias[s$scenario %in% paste0("S", 3:7) & s$n == 200]), "\n")
cat("bias/SD n=100:", round(setNames(s$bias / s$sd_est, paste(s$scenario, s$n))[s$n == 100], 3), "\n")

cat("\n=== Miss sides / null 95th percentiles (results/study1_miss_side.csv) ===\n")
m <- read.csv("results/study1_miss_side.csv")
m$upper_cov <- 1 - m$miss_above
print(m, digits = 4)
mm <- m[grepl("^S[3-7]-(100|200)$", m$cell), ]
cat("upper-limit coverage S3-S7 n>=100 range:", range(mm$upper_cov), "\n")
cat("max miss_above in S2,S5,S7:", max(m$miss_above[grepl("^S[257]-", m$cell)]), "\n")
cat("NOTE true_W1 used in miss-side file for S6/S7:", m$true_W1[m$cell == "S6-50"], m$true_W1[m$cell == "S7-50"],
    " vs exact", truth[["S6"]], truth[["S7"]], "\n")

cat("\n=== Extension (results/w1_raw_ext_summary.csv) ===\n")
e <- read.csv("results/w1_raw_ext_summary.csv")
nn <- e[e$true_W1 > 0, ]
cat("non-null cells:", nrow(nn), " coverage range:", range(nn$coverage), " max MCSE cov:", max(e$mcse_coverage), " reps:", range(e$n_reps), "\n")
print(e[, c("cell", "n1", "n2", "n_reps", "true_W1", "bias", "coverage", "mcse_coverage", "upper_coverage")], digits = 4)
cat("E5 cov - 0.95 in MCSE:", (e$coverage[e$cell == "E5_S2_1000"] - 0.95) / e$mcse_coverage[e$cell == "E5_S2_1000"],
    "; E6:", (e$coverage[grepl("^E6", e$cell)] - 0.95) / e$mcse_coverage[grepl("^E6", e$cell)], "\n")

cat("\n=== Required n (results/required_n_selection.csv, threshold 0.9) ===\n")
r <- read.csv("results/required_n_selection.csv", stringsAsFactors = FALSE)
r9 <- r[r$threshold == 0.9 & r$method %in% c("W1", "KS", "SMD"), ]
print(r9[, c("set", "method", "required_n", "status", "max_auc", "value_at_2000", "required_n_lower", "required_n_upper")])
cat("cells:", length(unique(r9$set)), "\n")
cat("SMD not reached:", sum(r9$method == "SMD" & r9$status != "reached"), "\n")
cat("W1 not reached:", sum(r9$method == "W1" & r9$status != "reached"), "; KS not reached:", sum(r9$method == "KS" & r9$status != "reached"), "\n")
blind <- r9[r9$method == "SMD" & r9$status != "reached", ]
cat("SMD max_auc in blind cells:", range(blind$max_auc), " value_at_2000:", range(blind$value_at_2000), "\n")
a <- read.csv("results/derived/selection_cell_auc_range.csv", stringsAsFactors = FALSE)
print(head(a, 40))
