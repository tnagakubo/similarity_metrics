# Referee recomputation of Study 2 (Tables 1-4 + prose) and Study 1 (Table 5 + prose) from results/ CSVs. Base R only.
s <- read.csv("results/w1_raw_summary.csv"); m <- read.csv("results/study2_mcse.csv"); ms <- read.csv("results/study1_miss_side.csv")
s$cov <- s$coverage_pct; if (max(s$cov) > 1) s$cov <- s$cov / 100
cat("coverage scale max:", max(s$coverage_pct), "\n")
r3 <- function(x) sprintf("%.3f", x)
cat("\nTable bias (3dp):\n"); print(xtabs(round(bias, 3) ~ scenario + n, s))
cat("\nTable coverage (3dp):\n"); print(xtabs(round(cov, 3) ~ scenario + n, s))
cat("\nRMSE (2dp):\n"); print(xtabs(round(rmse, 2) ~ scenario + n, s)); cat("\nCI width (2dp):\n"); print(xtabs(round(mean_ci_width, 2) ~ scenario + n, s))
# MCSE
s$mcse_cov <- sqrt(s$cov * (1 - s$cov) / s$n_valid); s$mcse_bias <- s$sd_est / sqrt(s$n_valid)
cat("\nmax MCSE bias", max(s$mcse_bias), " max mcse cov", max(s$mcse_cov), " (binomial at 0.5:", sqrt(.25 / 1e4), ")\n")
cat("check vs study2_mcse.csv: max|d| bias", max(abs(s$mcse_bias - m$mcse_bias)), "\n")
nn <- s[s$scenario %in% paste0("S", 3:7) & s$n >= 100, ]
nn$z <- (nn$cov - 0.95) / sqrt(0.95 * 0.05 / nn$n_valid); nn$zown <- (nn$cov - 0.95) / nn$mcse_cov
cat("\nS3-S7 n>=100 coverage range:", range(nn$cov), "\n"); print(nn[, c("scenario", "n", "cov", "z", "zown")], row.names = FALSE)
cat("cells below 2 MCSE (own):", sum(nn$zown < -2), " (nominal-MCSE):", sum(nn$z < -2), "\n")
# bias / sd at n=100
b100 <- s[s$n == 100, ]; cat("\nbias/sd n=100:\n"); print(data.frame(b100$scenario, round(b100$bias / b100$sd_est, 3)), row.names = FALSE)
# bias ratio n200/n50
br <- sapply(split(s, s$scenario), function(d) d$bias[d$n == 200] / d$bias[d$n == 50]); cat("\nbias(200)/bias(50):\n"); print(round(br, 3))
# bias in S4 within MCSE?
s4 <- s[s$scenario == "S4", ]; cat("S4 |bias|/mcse:", round(abs(s4$bias) / s4$mcse_bias, 2), "\n")
# truth
cat("\nTrue W1: S5 closed form", sqrt(2 / pi) * 5, "\n")
mul <- log(50) - 0.5^2 / 2
f6 <- function(t) abs(pnorm(t, 50, 10) - plnorm(t, mul, 0.5))
S6 <- integrate(f6, -Inf, 0)$value + integrate(f6, 0, 50)$value + integrate(f6, 50, 200)$value + integrate(f6, 200, Inf)$value
f7 <- function(t) abs(pnorm(t, 50, 10) - pnorm(t, 55, 15))
S7 <- integrate(f7, -Inf, 0)$value + integrate(f7, 0, 200)$value + integrate(f7, 200, Inf)$value
cat("S6 quad", S6, " S7 quad", S7, " muLog", mul, " S6 sd", 50 * sqrt(exp(.25) - 1), " cv", 100 * sqrt(exp(.25) - 1), " skew", (exp(.25) + 2) * sqrt(exp(.25) - 1), "\n")
cat("MC truths used in miss-side: S6", ms$true_W1[ms$cell == "S6-100"], " S7", ms$true_W1[ms$cell == "S7-100"], "\n")
cat("max miss_above S2,S5,S7:", max(ms$miss_above[grepl("^S[257]-", ms$cell)]), " S2 miss_above:", ms$miss_above[grepl("^S2-", ms$cell)], "\n")
print(ms, row.names = FALSE)
cat("\nDelta_max width S3 n=100: 0.01*", s$mean_ci_width[s$scenario == "S3" & s$n == 100], "=", 0.01 * s$mean_ci_width[s$scenario == "S3" & s$n == 100], "\n")
cat("CI width n=100 non-null range:", range(s$mean_ci_width[s$n == 100 & s$scenario != "S1"]), "\n")
cat("bias/W1 at n=50 S5:", s$bias[s$scenario=="S5"&s$n==50]/s$true_W1[s$scenario=="S5"&s$n==50], "\n")
# monotone sharp bound for Study 2 scenarios: (W1 + |dmu|)/2
cat("\nMonotone-class sharp bound / W1 (=(W1+|dmu|)/(2W1)): S5", (3.989423 + 0) / (2 * 3.989423), " S6", (12.159806 + 0) / (2 * 12.159806), " S7", (5.833155 + 5) / (2 * 5.833155), " S3", 1, "\n")
# ---------------- Study 1
rq <- read.csv("results/required_n_selection.csv")
t9 <- rq[rq$threshold == 0.9 & rq$method %in% c("W1", "KS", "SMD"), ]
w <- reshape(t9[, c("set", "method", "required_n", "required_n_lower", "required_n_upper", "status")], idvar = "set", timevar = "method", direction = "wide")
w$sep <- with(w, ifelse(required_n_upper.W1 < required_n_lower.KS | (is.na(required_n_upper.W1) & required_n.W1 <= 25 & 25 < required_n_lower.KS), "W1 fewer",
              ifelse(required_n_upper.KS < required_n_lower.W1, "KS fewer", "overlap")))
print(w[, c("set", "required_n.W1", "required_n_lower.W1", "required_n_upper.W1", "required_n.KS", "required_n_lower.KS", "required_n_upper.KS", "required_n.SMD", "status.SMD", "sep")], row.names = FALSE)
cat("separation counts:"); print(table(w$sep))
sh <- rq[grepl("shape_sym", rq$set) & rq$method %in% c("W1", "KS"), c("set", "method", "threshold", "required_n", "required_n_lower", "required_n_upper")]
print(sh, row.names = FALSE)
cat("W1 range Sets 3-4 (excl. bulk control?):\n"); print(t9[t9$method == "W1" & grepl("Set3|Set4", t9$set), c("set", "required_n")], row.names = FALSE)
# AUC monotonicity and blind range
a1 <- read.csv("results/selection_sim_summary.csv"); a2 <- read.csv("results/selection_sim_summary_ext.csv"); a <- rbind(a1, a2)
cat("measures:", unique(a$measure), "\n")
au <- a[a$measure == "auc", ]
if (nrow(au)) {
  cat("types:", unique(au$type), "\n")
  for (mt in c("W1", "KS")) for (st in unique(au$set)) for (ty in setdiff(unique(au$type[au$set == st]), "overall")) {
    d <- au[au$method == mt & au$set == st & au$type == ty, ]; d <- d[order(d$n), ]
    dec <- which(diff(d$value) < -2 * sqrt(d$mc_se[-1]^2 + d$mc_se[-nrow(d)]^2))
    if (length(dec)) cat(sprintf("non-monotone beyond 2 MCSE: %s %s %s at n=%s\n", mt, st, ty, paste(d$n[dec + 1], collapse = ",")))
    dd <- which(diff(d$value) < 0); if (length(dd)) cat(sprintf("  point decrease: %s %s %s at n=%s (max drop %.4f)\n", mt, st, ty, paste(d$n[dd + 1], collapse = ","), max(-diff(d$value))))
  }
  smd <- au[au$method == "SMD", ]; cat("SMD AUC by cell, range over grid:\n"); print(aggregate(value ~ set + type, smd, function(v) round(range(v), 3)))
}
