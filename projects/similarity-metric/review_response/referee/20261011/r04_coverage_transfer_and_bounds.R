# Referee check 04 -- (A) does the 'n >= 100 per region' estimation criterion transfer to GUSTO-I-sized
# regions with GUSTO-I-sized age distances? (B) the W1 bound is sharp, and other distances admit bounds
# with the same per-unit constant. Base R only. Run from the project root:
#   Rscript review_response/referee/20261011/r04_coverage_transfer_and_bounds.R
OUT <- "review_response/referee/20261011"
sink(file.path(OUT, "r04_coverage_transfer_and_bounds.txt"), split = TRUE)
suppressWarnings(RNGkind("Mersenne-Twister", "Inversion", "Rejection"))
set.seed(20261011)

## fast exact two-sample W1 for bootstrap resamples: multinomial weights on the sorted originals
prep <- function(x, y) {
  xs <- sort(x); ys <- sort(y); a <- c(xs, ys); o <- order(a); lab <- c(rep(1L, length(xs)), rep(2L, length(ys)))[o]
  list(a = a[o], gap = diff(a[o]), px = which(lab == 1L), py = which(lab == 2L), n1 = length(xs), n2 = length(ys))
}
w1w <- function(P, cx, cy) {   # cx, cy: counts per sorted original
  w1 <- numeric(length(P$a)); w2 <- w1
  w1[P$px] <- cx / P$n1; w2[P$py] <- cy / P$n2
  N <- length(P$a); sum(abs(cumsum(w1)[-N] - cumsum(w2)[-N]) * P$gap)
}
w1 <- function(x, y) { P <- prep(x, y); w1w(P, rep(1, P$n1), rep(1, P$n2)) }
# check against the eq. (8) form on one GUSTO pair
g <- read.csv("data/gusto.csv"); r8 <- g$age[g$regl == 8]; r5 <- g$age[g$regl == 5]
eq8 <- function(x, y) { a <- sort(unique(c(x, y))); m <- length(a)
  sum(abs(findInterval(a[-m], sort(x)) / length(x) - findInterval(a[-m], sort(y)) / length(y)) * diff(a)) }
cat(sprintf("fast W1 check (R8 vs R5 age): %.10f vs eq.(8) %.10f\n", w1(r8, r5), eq8(r8, r5)))

boot_ci <- function(x, y, B) {
  P <- prep(x, y)
  bv <- replicate(B, w1w(P, tabulate(sample.int(P$n1, P$n1, TRUE), P$n1), tabulate(sample.int(P$n2, P$n2, TRUE), P$n2)))
  quantile(bv, c(0.025, 0.975), names = FALSE)
}

## (A) coverage of the 95% percentile interval at GUSTO-I sizes.
## F1 = N(60.2, 12.1^2) (Region 8 age moments), F2 = F1 shifted by delta (true W1 = delta), and a scale
## contrast F2 = N(60.2, (12.1 k)^2) with true W1 = sqrt(2/pi) * 12.1 * |k - 1|.
## n1 = 2916 (R8), n2 = 1909 (R5). reps = 600, B = 600.
reps <- 600; B <- 600; n1 <- 2916; n2 <- 1909; mu <- 60.2; s <- 12.1
neff <- n1 * n2 / (n1 + n2)
run <- function(label, gen2, truth) {
  hit <- lo_miss <- hi_miss <- numeric(reps); est <- numeric(reps)
  for (r in 1:reps) {
    x <- rnorm(n1, mu, s); y <- gen2(n2)
    ci <- boot_ci(x, y, B); est[r] <- w1(x, y)
    hit[r] <- ci[1] <= truth & truth <= ci[2]; lo_miss[r] <- ci[1] > truth; hi_miss[r] <- ci[2] < truth
  }
  cv <- mean(hit)
  cat(sprintf("%-34s true W1 %.3f  snr %.2f | coverage %.3f (MC SE %.3f) | interval above truth %.3f | truth above interval %.3f | mean est %.3f\n",
              label, truth, sqrt(neff) * truth / s, cv, sqrt(cv * (1 - cv) / reps), mean(lo_miss), mean(hi_miss), mean(est)))
}
cat(sprintf("\n(A) n1 = %d, n2 = %d, n_eff = %.0f, sigma = %.1f, reps = %d, B = %d\n", n1, n2, neff, s, reps, B))
for (dl in c(0.2, 0.39, 0.6, 1.0)) run(sprintf("location shift %.2f yr", dl), function(n) rnorm(n, mu + dl, s), dl)
for (k in c(1.03, 1.06)) run(sprintf("scale ratio %.2f", k), function(n) rnorm(n, mu, s * k), sqrt(2 / pi) * s * abs(k - 1))
# the GUSTO-I age snr for each partner, from the observed W1 (biased upward, so an upper bound on the truth's snr)
pp <- read.csv("results/gusto_r8_w1_per_pair.csv")
sn <- data.frame(partner = paste0("R", pp$partner), n = pp$n, W1_age = round(pp$W1_age, 3),
                 snr_age = round(sqrt(2916 * pp$n / (2916 + pp$n)) * pp$W1_age / sd(r8), 2))
cat("\nGUSTO-I age: sqrt(n_eff) * W1_hat / sd(R8) per partner (Study 2's S2 has snr 1.00, 1.41, 2.00 at n = 50, 100, 200):\n")
print(sn[order(sn$snr_age), ], row.names = FALSE)

## (B) sharpness of L * W1 over the Lipschitz-L class, and other bounds with the same constant L.
## Empirical R8 and R2 age distributions.
x <- r8; y <- g$age[g$regl == 2]; L <- 0.01
a <- sort(unique(c(x, y))); m <- length(a)
F1 <- findInterval(a, sort(x)) / length(x); F2 <- findInterval(a, sort(y)) / length(y)
W1 <- sum(abs(F1[-m] - F2[-m]) * diff(a))
# extremal CATE: tau*(t) = L * integral_{a1}^{t} sign(F2 - F1) ds  (1/L-Lipschitz normalised); piecewise linear
sl <- sign(F2[-m] - F1[-m]); tau_star <- L * c(0, cumsum(sl * diff(a)))
tau_at <- function(v) approx(a, tau_star, xout = v, rule = 2)$y
diff_tau <- mean(tau_at(x)) - mean(tau_at(y))
cat(sprintf("\n(B) R8 vs R2 age: W1 = %.4f yr; L * W1 = %.6f; |mean tau*(R8) - mean tau*(R2)| for the extremal L-Lipschitz CATE = %.6f\n",
            W1, L * W1, abs(diff_tau)))
cat(sprintf("    max |slope| of tau* = %.4f (= L): the bound is attained, i.e. L*W1 is the supremum over the Lipschitz-L class\n",
            max(abs(diff(tau_star) / diff(a)))))
Dks <- max(abs(F1 - F2)); rng <- diff(range(c(x, y)))
qs <- seq(0.0005, 0.9995, by = 0.001); W2 <- sqrt(mean((quantile(x, qs, type = 1) - quantile(y, qs, type = 1))^2))
L2cdf <- sqrt(sum((F1[-m] - F2[-m])^2 * diff(a)))
cat(sprintf("    D_KS = %.4f, support width b - a = %.2f yr, W2 ~ %.4f, L2 CDF distance = %.4f\n", Dks, rng, W2, L2cdf))
cat(sprintf("    valid bounds with constant L: L*W1 = %.5f <= L*W2 = %.5f <= ... ; L*(b-a)*D_KS = %.5f ; L*sqrt(b-a)*||F1-F2||_2 = %.5f\n",
            L * W1, L * W2, L * rng * Dks, L * sqrt(rng) * L2cdf))
cat(sprintf("    'required slope' if computed from these: Delta/W1 = %.5f, Delta/W2 = %.5f, Delta/((b-a) D_KS) = %.6f (Delta = 0.01)\n",
            0.01 / W1, 0.01 / W2, 0.01 / (rng * Dks)))
cat("    Only Delta/W1 is the smallest slope at which SOME L-Lipschitz CATE produces Delta (sharpness); the others are slopes\n    at which no L-Lipschitz CATE attains Delta.\n")
sink()
writeLines(capture.output(sessionInfo()), file.path(OUT, "r04_sessionInfo.txt"))
