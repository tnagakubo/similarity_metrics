# Referee recomputation of the GUSTO-I application (Tables 6-9 and prose numbers). Base R only.
# Run from project root: Rscript review_response/referee/20261012/ref_app.R
g <- read.csv("data/gusto.csv")
cat("N =", nrow(g), " regions =", length(unique(g$regl)), " NA age:", sum(is.na(g$age)), " NA sysbp:", sum(is.na(g$sysbp)), "\n")
w1 <- function(x, y) { v <- sort(unique(c(x, y))); F1 <- ecdf(x); F2 <- ecdf(y); k <- v[-length(v)]; sum(diff(v) * abs(F1(k) - F2(k))) }
# one-sided parts: A12 = int (F1-F2)_+, A21 = int (F2-F1)_+
w1parts <- function(x, y) { v <- sort(unique(c(x, y))); F1 <- ecdf(x); F2 <- ecdf(y); k <- v[-length(v)]; d <- F1(k) - F2(k)
  c(pos = sum(diff(v) * pmax(d, 0)), neg = sum(diff(v) * pmax(-d, 0))) }
skw <- function(x) { m <- mean(x); mean((x - m)^3) / mean((x - m)^2)^1.5 }
a <- g[g$regl == 8, ]
cat(sprintf("R8 n=%d age mean %.1f sd %.1f skew %.2f | sbp mean %.1f sd %.1f skew %.2f\n", nrow(a), mean(a$age), sd(a$age), skw(a$age), mean(a$sysbp), sd(a$sysbp), skw(a$sysbp)))
cat("sysbp==0:", sum(g$sysbp == 0), " age>100:", sum(g$age > 100), " age range:", range(g$age), " sbp range:", range(g$sysbp), "\n")
cat("lip products: age 0.01*range =", 0.01 * diff(range(g$age)), " sbp 0.002*range =", 0.002 * diff(range(g$sysbp)), "\n")
P <- setdiff(sort(unique(g$regl)), 8)
pp <- read.csv("results/gusto_r8_w1_per_pair.csv"); pp <- pp[order(pp$partner), ]
ops <- read.csv("results/gusto_operability.csv")
set.seed(20261012); B <- 2000
out <- NULL
for (p in P) {
  b <- g[g$regl == p, ]
  row <- data.frame(partner = p, n = nrow(b))
  for (v in c("age", "sysbp")) {
    x <- a[[v]]; y <- b[[v]]
    est <- w1(x, y); pr <- w1parts(x, y); dmu <- abs(mean(x) - mean(y))
    bt <- replicate(B, w1(sample(x, replace = TRUE), sample(y, replace = TRUE)))
    nl <- replicate(B, w1(sample(x, length(x), replace = TRUE), sample(x, length(y), replace = TRUE)))
    sp <- sqrt(((length(x) - 1) * var(x) + (length(y) - 1) * var(y)) / (length(x) + length(y) - 2))
    row[[paste0("W1_", v)]] <- est
    row[[paste0("lo_", v)]] <- unname(quantile(bt, 0.025)); row[[paste0("hi_", v)]] <- unname(quantile(bt, 0.975))
    row[[paste0("q95null_", v)]] <- unname(quantile(nl, 0.95))
    row[[paste0("absdmu_", v)]] <- dmu
    row[[paste0("monoBound_", v)]] <- (est + dmu) / 2       # sharp bound / L over monotone L-Lipschitz CATEs
    row[[paste0("posPart_", v)]] <- pr["pos"]; row[[paste0("negPart_", v)]] <- pr["neg"]
    row[[paste0("absSMD_", v)]] <- dmu / sp
    row[[paste0("sdratio_", v)]] <- sd(y) / sd(x)
  }
  out <- rbind(out, row)
}
cat("\nPartner n range:", range(out$n), "\n")
cmp <- data.frame(partner = out$partner,
  dW1age = out$W1_age - pp$W1_age, dW1sbp = out$W1_sysbp - pp$W1_sysbp,
  loAge_ref = round(out$lo_age, 2), loAge_ms = round(pp$ci_lower_age, 2), hiAge_ref = round(out$hi_age, 2), hiAge_ms = round(pp$ci_upper_age, 2),
  loSbp_ref = round(out$lo_sysbp, 2), loSbp_ms = round(pp$ci_lower_sysbp, 2), hiSbp_ref = round(out$hi_sysbp, 2), hiSbp_ms = round(pp$ci_upper_sysbp, 2))
print(cmp, row.names = FALSE)
cat("max |dW1| age", max(abs(cmp$dW1age)), " sbp", max(abs(cmp$dW1sbp)), "\n")
for (v in c("age", "sysbp")) {
  em <- if (v == "age") "age" else "sbp"
  o <- ops[ops$em == ifelse(v == "age", "age", unique(ops$em)[2]), ]
  unres_ref <- out$partner[out[[paste0("W1_", v)]] <= out[[paste0("q95null_", v)]]]
  cat(sprintf("\n%s: null q95 range (referee) %.3f-%.3f ; manuscript %.3f-%.3f ; unresolved (referee) R%s ; manuscript R%s\n", v,
    min(out[[paste0("q95null_", v)]]), max(out[[paste0("q95null_", v)]]), min(o$null_q95_anchor), max(o$null_q95_anchor),
    paste(unres_ref, collapse = ",R"), paste(sub("R", "", o$region[!o$resolved_anchor]), collapse = ",R")))
  marg <- out[[paste0("W1_", v)]] - out[[paste0("q95null_", v)]]
  cat("  closest-to-threshold margins (W1 - q95):", paste(sprintf("R%d %.3f", out$partner, marg)[order(abs(marg))][1:4], collapse = "; "), "\n")
  cat("  partner-source flip check (manuscript csv): resolved_anchor != resolved_partner:", sum(o$resolved_anchor != o$resolved_partner), "\n")
}
# L* from manuscript CIs
lst <- read.csv("results/gusto_lstar_intervals.csv")
chk <- with(merge(lst, transform(pp, partner = paste0("R", partner)), by = "partner"),
  c(max(abs(lstar_age - 0.01 / W1_age)), max(abs(lstar_age_lower - 0.01 / ci_upper_age)), max(abs(lstar_age_upper - 0.01 / ci_lower_age)),
    max(abs(lstar_sbp - 0.01 / W1_sysbp)), max(abs(lstar_sbp_lower - 0.01 / ci_upper_sysbp)), max(abs(lstar_sbp_upper - 0.01 / ci_lower_sysbp))))
cat("\nL* = 0.01/W1 identities, max abs dev:", signif(chk, 3), "\n")
cat("L* age intervals vs LUB 0.01: wholly above:", sum(lst$lstar_age_lower > 0.01), " contain:", sum(lst$lstar_age_lower <= 0.01 & lst$lstar_age_upper >= 0.01), " below:", sum(lst$lstar_age_upper < 0.01), "\n")
cat("L* sbp intervals vs LUB 0.002: wholly above:", sum(lst$lstar_sbp_lower > 0.002), " contain:", sum(lst$lstar_sbp_lower <= 0.002 & lst$lstar_sbp_upper >= 0.002), " below:", sum(lst$lstar_sbp_upper < 0.002), "\n")
# Spearman
rs <- function(u, v) cor(rank(u), rank(v))
cat(sprintf("\nSpearman age vs sbp W1: %.3f ; W1 vs |SMD| age %.3f sbp %.3f ; max SD ratio (max(r,1/r)) age %.3f sbp %.3f\n",
  rs(out$W1_age, out$W1_sysbp), rs(out$W1_age, out$absSMD_age), rs(out$W1_sysbp, out$absSMD_sysbp),
  max(pmax(out$sdratio_age, 1 / out$sdratio_age)), max(pmax(out$sdratio_sysbp, 1 / out$sdratio_sysbp))))
cat("R6-R5 sbp diff:", out$W1_sysbp[out$partner == 6] - out$W1_sysbp[out$partner == 5], "\n")
# Monotone-class sharp bound vs W1
mb <- data.frame(partner = paste0("R", out$partner), W1_age = round(out$W1_age, 2), mono_age = round(out$monoBound_age, 2), ratio_age = round(out$monoBound_age / out$W1_age, 2),
  W1_sbp = round(out$W1_sysbp, 2), mono_sbp = round(out$monoBound_sysbp, 2), ratio_sbp = round(out$monoBound_sysbp / out$W1_sysbp, 2))
print(mb, row.names = FALSE)
cat("ratio (W1+|dmu|)/2 / W1 range: age", range(mb$ratio_age), " sbp", range(mb$ratio_sbp), "\n")
write.csv(out, "review_response/referee/20261012/ref_app_recomputed.csv", row.names = FALSE)
write.csv(mb, "review_response/referee/20261012/ref_monotone_bound.csv", row.names = FALSE)
