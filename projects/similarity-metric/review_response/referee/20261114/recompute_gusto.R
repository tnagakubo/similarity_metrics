# Referee recomputation (2026-11-14): GUSTO-I application, independent implementation (base R only).
# Run from the project root: Rscript review_response/referee/20261114/recompute_gusto.R
out_dir <- "review_response/referee/20261114"
g <- read.csv("data/gusto.csv", stringsAsFactors = FALSE)
cat("N rows =", nrow(g), "; regions =", length(unique(g$regl)), "\n")
cat("NA age =", sum(is.na(g$age)), "; NA sysbp =", sum(is.na(g$sysbp)), "\n")
print(table(g$regl))

# W1 between empirical CDFs, written independently (cumulative label counts over the pooled order)
w1 <- function(x, y) {
  n1 <- length(x); n2 <- length(y)
  o <- order(c(x, y)); z <- c(x, y)[o]
  lab <- c(rep(1, n1), rep(0, n2))[o]
  c1 <- cumsum(lab); k <- seq_along(z)
  d <- abs(c1 / n1 - (k - c1) / n2)
  sum(d[-length(z)] * diff(z))
}
ks <- function(x, y) {
  z <- sort(unique(c(x, y)))
  max(abs(ecdf(x)(z) - ecdf(y)(z)))
}
smd <- function(x, y) {
  n1 <- length(x); n2 <- length(y)
  sp <- sqrt(((n1 - 1) * var(x) + (n2 - 1) * var(y)) / (n1 + n2 - 2))
  abs(mean(x) - mean(y)) / sp
}

anchor <- 8
partners <- setdiff(sort(unique(g$regl)), anchor)
ems <- c(age = "age", sysbp = "sysbp")
set.seed(20261114)
B <- 2000
rows <- list()
for (v in ems) {
  xa <- g[[v]][g$regl == anchor]
  for (p in partners) {
    xp <- g[[v]][g$regl == p]
    est <- w1(xa, xp)
    boot <- replicate(B, w1(sample(xa, replace = TRUE), sample(xp, replace = TRUE)))
    nullv <- replicate(B, w1(sample(xa, length(xa), replace = TRUE), sample(xa, length(xp), replace = TRUE)))
    q95 <- unname(quantile(nullv, 0.95))
    rows[[length(rows) + 1]] <- data.frame(
      em = v, partner = p, n = length(xp), w1 = est,
      lo = unname(quantile(boot, 0.025)), hi = unname(quantile(boot, 0.975)),
      null_q95 = q95, unresolved = est <= q95,
      dmu = abs(mean(xa) - mean(xp)), sd_anchor = sd(xa), sd_ratio = sd(xp) / sd(xa),
      smd = smd(xa, xp), ks = ks(xa, xp),
      range_pair = diff(range(c(xa, xp))))
  }
}
res <- do.call(rbind, rows)
res$w1_over_sd <- res$w1 / res$sd_anchor
res$mono_ratio <- (res$w1 + res$dmu) / (2 * res$w1)
res$dmu_over_w1 <- res$dmu / res$w1
# minimum range of a CATE of slope <= L_UB producing Delta_clin = 0.01 is at least Delta_clin / D_KS (KS bound)
res$min_cate_range_for_1pt <- 0.01 / res$ks
write.csv(res, file.path(out_dir, "recompute_gusto_pairs.csv"), row.names = FALSE)
print(res, digits = 3)

cat("\n--- summaries ---\n")
cat("Unresolved age:", paste0("R", res$partner[res$em == "age" & res$unresolved]), "\n")
cat("Unresolved sbp:", paste0("R", res$partner[res$em == "sysbp" & res$unresolved]), "\n")
wa <- res$w1[res$em == "age"]; ws <- res$w1[res$em == "sysbp"]
cat("Spearman age vs sbp W1:", cor(wa, ws, method = "spearman"), "\n")
cat("Spearman W1 vs SMD age:", cor(wa, res$smd[res$em == "age"], method = "spearman"), "\n")
cat("Spearman W1 vs SMD sbp:", cor(ws, res$smd[res$em == "sysbp"], method = "spearman"), "\n")
cat("W1/SD range:", range(res$w1_over_sd), "\n")
cat("SD ratio range (partner/anchor):", range(res$sd_ratio), " max factor:", max(pmax(res$sd_ratio, 1 / res$sd_ratio)), "\n")
cat("mono ratio age:", range(res$mono_ratio[res$em == "age"]), " sbp:", range(res$mono_ratio[res$em == "sysbp"]), "\n")
cat("dmu/W1 age:", range(res$dmu_over_w1[res$em == "age"]), " sbp:", range(res$dmu_over_w1[res$em == "sysbp"]), "\n")
cat("Recorded support all regions: age", range(g$age), " sbp", range(g$sysbp), "\n")
cat("L_UB * range: age", 0.01 * diff(range(g$age)), " sbp", 0.002 * diff(range(g$sysbp)), "\n")
cat("SBP=0:", sum(g$sysbp == 0), " age>100:", sum(g$age > 100), "\n")
cat("partner n range:", range(res$n[res$em == "age"]), " anchor n:", sum(g$regl == anchor), "\n")
# heaping on multiples of 10
p10 <- tapply(g$sysbp %% 10 == 0, g$regl, mean)
print(round(100 * p10, 1))
# reading against the reference distance (1 yr; 5 mmHg)
ref <- c(age = 1, sysbp = 5)
res$reading <- with(res, ifelse(hi < ref[em], "wholly below", ifelse(lo > ref[em], "wholly above", "contains")))
print(table(res$em, res$reading))
print(res[, c("em", "partner", "w1", "lo", "hi", "unresolved", "reading", "ks", "min_cate_range_for_1pt")], digits = 3)
writeLines(capture.output(sessionInfo()), file.path(out_dir, "recompute_gusto_sessionInfo.txt"))
