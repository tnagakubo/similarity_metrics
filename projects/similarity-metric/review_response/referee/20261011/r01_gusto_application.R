# Referee recomputation 01 -- GUSTO-I application (Section 4, Tables 4-7, Discussion numbers)
# Base R only. Run from the project root:
#   Rscript review_response/referee/20261011/r01_gusto_application.R
# Reads data/gusto.csv and (for comparison only) results/gusto_r8_w1_per_pair.csv,
# results/gusto_operability.csv, results/gusto_lstar_intervals.csv, results/app_all_methods_ranks.csv.
# Independent W1 implementation (findInterval form of eq. (8)); bootstrap and null floor
# re-run with the seeds the authors' scripts declare, in the same RNG call order, so that
# agreement can be checked to floating precision rather than to Monte Carlo error.
OUT <- "review_response/referee/20261011"
sink(file.path(OUT, "r01_gusto_application.txt"), split = TRUE)
suppressWarnings(RNGkind("Mersenne-Twister", "Inversion", "Rejection"))

g <- read.csv("data/gusto.csv")
cat("N =", nrow(g), "| regions =", length(unique(g$regl)), "| NA age/sysbp:", sum(is.na(g$age)), sum(is.na(g$sysbp)), "\n")
r8 <- g[g$regl == 8, ]
skew_m <- function(v) { m <- mean(v); mean((v - m)^3) / mean((v - m)^2)^1.5 }   # moment skewness (population form)
skew_s <- function(v) { m <- mean(v); s <- sd(v); mean(((v - m) / s)^3) }      # sd-standardised form
cat(sprintf("R8 n = %d\n", nrow(r8)))
for (v in c("age", "sysbp")) cat(sprintf("R8 %-5s mean %.3f sd %.3f skew(moment) %.4f skew(sd-std) %.4f\n",
                                         v, mean(r8[[v]]), sd(r8[[v]]), skew_m(r8[[v]]), skew_s(r8[[v]])))

## ---- W1 by eq. (8): sum over distinct pooled values of |F1 - F2| * gap ----
w1 <- function(x, y) {
  a <- sort(unique(c(x, y))); m <- length(a)
  if (m < 2) return(0)
  F1 <- findInterval(a[-m], sort(x)) / length(x)
  F2 <- findInterval(a[-m], sort(y)) / length(y)
  sum(abs(F1 - F2) * diff(a))
}
ks <- function(x, y) { a <- sort(unique(c(x, y)))
  max(abs(findInterval(a, sort(x)) / length(x) - findInterval(a, sort(y)) / length(y))) }

partners <- setdiff(sort(unique(g$regl)), 8)
pt <- data.frame(partner = partners, n = as.vector(table(g$regl)[as.character(partners)]))
for (v in c("age", "sysbp")) pt[[paste0("W1_", v)]] <- sapply(partners, function(p) w1(r8[[v]], g[[v]][g$regl == p]))
cat(sprintf("partner n range: %d - %d\n", min(pt$n), max(pt$n)))

## ---- percentile bootstrap, same seed and call order as R/fig3_w1_axis.R ----
set.seed(2026)
for (v in c("age", "sysbp")) {
  lo <- hi <- numeric(length(partners))
  xa <- r8[[v]]
  for (i in seq_along(partners)) {
    xp <- g[[v]][g$regl == partners[i]]
    bv <- numeric(2000)
    for (b in 1:2000) bv[b] <- w1(sample(xa, length(xa), replace = TRUE), sample(xp, length(xp), replace = TRUE))
    q <- quantile(bv, c(0.025, 0.975), names = FALSE)
    lo[i] <- q[1]; hi[i] <- q[2]
  }
  pt[[paste0("lo_", v)]] <- lo; pt[[paste0("hi_", v)]] <- hi
}
auth <- read.csv("results/gusto_r8_w1_per_pair.csv"); auth <- auth[match(pt$partner, auth$partner), ]
cmp <- data.frame(partner = paste0("R", pt$partner), n = pt$n,
  W1age = round(pt$W1_age, 4), d_W1age = signif(pt$W1_age - auth$W1_age, 3),
  CIage = sprintf("[%.3f, %.3f]", pt$lo_age, pt$hi_age),
  d_lo = signif(pt$lo_age - auth$ci_lower_age, 3), d_hi = signif(pt$hi_age - auth$ci_upper_age, 3),
  W1sbp = round(pt$W1_sysbp, 4), d_W1sbp = signif(pt$W1_sysbp - auth$W1_sysbp, 3),
  CIsbp = sprintf("[%.3f, %.3f]", pt$lo_sysbp, pt$hi_sysbp),
  d_lo_s = signif(pt$lo_sysbp - auth$ci_lower_sysbp, 3), d_hi_s = signif(pt$hi_sysbp - auth$ci_upper_sysbp, 3))
cat("\n== W1 and 95% percentile CI, recomputed vs results/gusto_r8_w1_per_pair.csv (d_ = mine - authors') ==\n")
print(cmp, row.names = FALSE)

## ---- ranks (Table 5) ----
pt$rank_age <- rank(pt$W1_age); pt$rank_sbp <- rank(pt$W1_sysbp)
cat("\n== ranks by point estimate ==\n"); print(pt[, c("partner", "rank_age", "rank_sbp")], row.names = FALSE)
cat(sprintf("R6 - R5 SBP W1 difference: %.5f mmHg\n", pt$W1_sysbp[pt$partner == 6] - pt$W1_sysbp[pt$partner == 5]))
cat(sprintf("R3, R6, R5 SBP W1: %.4f %.4f %.4f (ranks 4-6 span %.4f mmHg)\n",
            pt$W1_sysbp[pt$partner == 3], pt$W1_sysbp[pt$partner == 6], pt$W1_sysbp[pt$partner == 5],
            diff(range(pt$W1_sysbp[pt$partner %in% c(3, 5, 6)]))))

## ---- L* (Table 7) and position relative to L_UB ----
D <- 0.01; LUB <- c(age = 0.01, sysbp = 0.002)
for (v in c("age", "sysbp")) {
  Ls <- D / pt[[paste0("W1_", v)]]; Llo <- D / pt[[paste0("hi_", v)]]; Lhi <- D / pt[[paste0("lo_", v)]]
  pos <- ifelse(Llo > LUB[[v]], "above", ifelse(Lhi < LUB[[v]], "below", "contains"))
  cat(sprintf("\n== L* for %s (Delta_clin = 0.01, L_UB = %g) ==\n", v, LUB[[v]]))
  print(data.frame(partner = paste0("R", pt$partner), Lstar = round(Ls, 5), lower = round(Llo, 5), upper = round(Lhi, 5),
                   vs_LUB = pos, W1_threshold_equiv = round(D / LUB[[v]], 3)), row.names = FALSE)
  cat("counts:", paste(names(table(pos)), table(pos), collapse = "; "), "\n")
}
la <- read.csv("results/gusto_lstar_intervals.csv")
cat(sprintf("\nauthors' R1 SBP L* lower limit: %.6f (L_UB 0.002); margin %.2e\n", la$lstar_sbp_lower[la$partner == "R1"],
            la$lstar_sbp_lower[la$partner == "R1"] - 0.002))

## ---- Monte Carlo error of the 97.5th bootstrap percentile for R1 SBP (does B = 2000 resolve 'just above'?) ----
set.seed(1)
xa <- r8$sysbp; xp <- g$sysbp[g$regl == 1]
rep_hi <- replicate(20, { bv <- replicate(2000, w1(sample(xa, replace = TRUE), sample(xp, replace = TRUE)))
                          quantile(bv, 0.975, names = FALSE) })
cat(sprintf("R1 SBP: 20 independent B=2000 upper limits: mean %.3f sd %.4f; implied L* lower limit %.5f (sd %.6f); share of runs with L*_lower <= 0.002: %.2f\n",
            mean(rep_hi), sd(rep_hi), mean(D / rep_hi), sd(D / rep_hi), mean(D / rep_hi <= 0.002)))

## ---- null floor, same seed and call order as R/gusto_operability_check.R ----
set.seed(20260821L)
nf <- list()
for (v in c("age", "sysbp")) {
  src_a <- r8[[v]]; n_a <- length(src_a)
  for (p in partners) {
    sp <- g[[v]][g$regl == p]; n_p <- length(sp)
    qa <- quantile(replicate(2000, w1(sample(src_a, n_a, replace = TRUE), sample(src_a, n_p, replace = TRUE))), 0.95, names = FALSE)
    qp <- quantile(replicate(2000, w1(sample(sp,    n_a, replace = TRUE), sample(sp,    n_p, replace = TRUE))), 0.95, names = FALSE)
    obs <- w1(src_a, sp)
    nf[[length(nf) + 1]] <- data.frame(em = v, region = paste0("R", p), w1 = obs, q95_anchor = qa, q95_partner = qp,
                                       resolved_anchor = obs > qa, resolved_partner = obs > qp)
  }
}
nf <- do.call(rbind, nf)
op <- read.csv("results/gusto_operability.csv")
nf$d_q95a <- signif(nf$q95_anchor - op$null_q95_anchor[match(paste(nf$em, nf$region), paste(op$em, op$region))], 3)
cat("\n== null floor (anchor source and partner source) ==\n"); print(nf, row.names = FALSE, digits = 4)
for (v in c("age", "sysbp")) { s <- nf[nf$em == v, ]
  cat(sprintf("%s: q95 range %.3f-%.3f | unresolved %d/15: %s | anchor/partner verdicts agree: %s | min margin |w1 - q95a| = %.3f\n",
      v, min(s$q95_anchor), max(s$q95_anchor), sum(!s$resolved_anchor), paste(s$region[!s$resolved_anchor], collapse = " "),
      all(s$resolved_anchor == s$resolved_partner), min(abs(s$w1 - s$q95_anchor)))) }

## ---- rank agreement and dispersion ----
rho <- cor(pt$W1_age, pt$W1_sysbp, method = "spearman")
se <- sqrt((1 + rho^2 / 2) / (15 - 3)); ci <- tanh(atanh(rho) + c(-1, 1) * qnorm(0.975) * se)
se_fz <- 1 / sqrt(15 - 3); ci_fz <- tanh(atanh(rho) + c(-1, 1) * qnorm(0.975) * se_fz)
cat(sprintf("\nSpearman(W1_age, W1_sbp) = %.4f; Bonett-Wright 95%% CI [%.3f, %.3f]; plain Fisher-z CI [%.3f, %.3f]\n", rho, ci[1], ci[2], ci_fz[1], ci_fz[2]))
# exact permutation-free check: how often a random ordering gives rho <= observed (two-sided)
set.seed(7); pr <- replicate(20000, cor(1:15, sample(15), method = "spearman"))
cat(sprintf("permutation P(|rho| >= |obs|) = %.3f\n", mean(abs(pr) >= abs(rho) - 1e-12)))
smd <- function(x, y) abs(mean(x) - mean(y)) / sqrt(((length(x) - 1) * var(x) + (length(y) - 1) * var(y)) / (length(x) + length(y) - 2))
for (v in c("age", "sysbp")) {
  s <- sapply(partners, function(p) smd(r8[[v]], g[[v]][g$regl == p]))
  k <- sapply(partners, function(p) ks(r8[[v]], g[[v]][g$regl == p]))
  cat(sprintf("%s: Spearman(W1, |SMD|) = %.4f ; Spearman(W1, KS) = %.4f\n", v,
              cor(pt[[paste0("W1_", v)]], s, method = "spearman"), cor(pt[[paste0("W1_", v)]], k, method = "spearman")))
}
ar <- read.csv("results/app_all_methods_ranks.csv"); cat("authors' app_all_methods_ranks.csv:\n"); print(ar)
sdr <- sapply(c("age", "sysbp"), function(v) { x <- tapply(g[[v]], g$regl, sd); r <- x[names(x) != "8"] / x[["8"]]; c(max = max(pmax(r, 1 / r)), which = names(r)[which.max(pmax(r, 1 / r))]) })
cat("max SD ratio partner vs R8:\n"); print(sdr)

## ---- SBP recording grid and CDF contact (bootstrap-consistency condition of Section 2.3 / Appendix) ----
s <- g$sysbp
cat(sprintf("\nSBP: %d distinct values; %.1f%% multiples of 10; %.1f%% multiples of 5\n", length(unique(s)), 100 * mean(s %% 10 == 0), 100 * mean(s %% 5 == 0)))
touch <- sapply(partners, function(p) { y <- g$sysbp[g$regl == p]; a <- sort(unique(c(r8$sysbp, y))); a <- a[-length(a)]
  d <- findInterval(a, sort(r8$sysbp)) / nrow(r8) - findInterval(a, sort(y)) / length(y)
  c(sign_changes = sum(diff(sign(d[d != 0])) != 0), exact_zero_intervals = sum(d == 0 & a > min(c(r8$sysbp, y)))) })
colnames(touch) <- paste0("R", partners); cat("SBP: sign changes of F_R8 - F_partner over the pooled grid, and grid intervals with F_R8 = F_partner exactly:\n"); print(touch)
sink()
