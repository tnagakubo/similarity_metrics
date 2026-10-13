# Referee check of the mechanism behind the Set 4 bulk-shift reversal: tail weight inflates the sampling SD of W1-hat
# (an L1 / mean-type functional) but not of the rank-based KS statistic. Pairwise AUC of (anchor vs shifted) over (anchor vs match).
set.seed(20261012)
w1eq <- function(x, y) mean(abs(sort(x) - sort(y)))             # equal-n W1
ks <- function(x, y) { z <- sort(c(x, y)); max(abs(ecdf(x)(z) - ecdf(y)(z))) }
r_set1 <- function(n, mu = 50) rnorm(n, mu, 10)
r_set4 <- function(n, mu = 50) { k <- as.vector(rmultinom(1, n, c(.05, .9, .05))); c(rnorm(k[1], 10, 8), rnorm(k[2], mu, 10), rnorm(k[3], 90, 8)) }
auc <- function(a, b) mean(outer(a, b, ">") + 0.5 * outer(a, b, "=="))
run <- function(gen, shift, n, R = 1500) {
  st <- replicate(R, { A <- gen(n); G <- gen(n); S <- gen(n, 50 + shift)
    c(w1n = w1eq(A, G), w1s = w1eq(A, S), ksn = ks(A, G), kss = ks(A, S)) })
  c(AUC_W1 = auc(st["w1s", ], st["w1n", ]), AUC_KS = auc(st["kss", ], st["ksn", ]), sdW1null = sd(st["w1n", ]))
}
for (n in c(200, 400)) {
  cat(sprintf("n=%d  Gaussian (Set 1 family), shift 2.5: %s\n", n, paste(names(run(r_set1, 2.5, n)), round(run(r_set1, 2.5, n), 3), collapse = " ")))
  cat(sprintf("n=%d  Set 4 family (5%%+5%% tails at +-40), shift 2.5: %s\n", n, paste(names(run(r_set4, 2.5, n)), round(run(r_set4, 2.5, n), 3), collapse = " ")))
}
cat("total SD: Set1 10 ; Set4", sqrt(.9 * 100 + .1 * (64 + 1600)), "\n")
