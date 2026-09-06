# tmp_floor_sensitivity.R -- throwaway verification for review-response memo
# (R2.2b/c). NOT part of the paper pipeline. Recomputes the null floor for the
# marginal partners with (i) an independent seed (seed-stability of q95) and
# (ii) a larger B so that the Bonferroni-style quantile q_{1-0.05/30} is
# estimable. W1 estimator identical to R/gusto_operability_check.R.

suppressPackageStartupMessages({ library(predtools) })

SEED   <- 20260906L                     # deliberately != 20260821 (production seed)
ANCHOR <- 8L
ALPHA  <- 0.05
M      <- 30L                           # 15 partners x 2 EMs
ALPHA_BONF <- ALPHA / M                 # 0.0016667

compute_w1 <- function(x, y) {
  a <- sort(c(x, y)); n <- length(a); if (n < 2) return(0)
  Fx <- ecdf(x); Fy <- ecdf(y); m <- (a[-n] + a[-1]) / 2
  sum(abs(Fx(m) - Fy(m)) * diff(a))
}

null_draws <- function(src, n1, n2, B) {
  v <- numeric(B)
  for (b in seq_len(B)) {
    v[b] <- compute_w1(sample(src, n1, replace = TRUE),
                       sample(src, n2, replace = TRUE))
  }
  v
}

set.seed(SEED)
data(gusto, package = "predtools")
g <- gusto[!is.na(gusto$age) & !is.na(gusto$sysbp), ]
anch_reg <- ANCHOR

# combos: em, region number, B
# B = 10000 where the Bonferroni quantile is needed (marginal RESOLVED verdicts);
# B = 2000 (production size, new seed) for seed-stability of marginal UNRESOLVED.
combos <- list(
  list(em = "age",   r = 6L,  B = 10000L, why = "resolved, ratio 1.118"),
  list(em = "age",   r = 12L, B = 10000L, why = "resolved, ratio 1.390"),
  list(em = "age",   r = 14L, B = 10000L, why = "resolved, ratio 1.076"),
  list(em = "sysbp", r = 13L, B = 10000L, why = "resolved, smallest sbp ratio 1.750"),
  list(em = "age",   r = 1L,  B = 2000L,  why = "unresolved, ratio 0.893"),
  list(em = "age",   r = 9L,  B = 2000L,  why = "unresolved, ratio 0.884"),
  list(em = "age",   r = 15L, B = 2000L,  why = "unresolved, ratio 0.893")
)

cat("em,region,B,w1_obs,null_mean,q95_newseed,q_bonf,resolved_at_q95,resolved_at_qbonf\n")
for (cb in combos) {
  src_a <- g[[cb$em]][g$regl == anch_reg]
  x_p   <- g[[cb$em]][g$regl == cb$r]
  n_a <- length(src_a); n_p <- length(x_p)
  w1  <- compute_w1(src_a, x_p)
  v   <- null_draws(src_a, n_a, n_p, cb$B)
  q95 <- unname(quantile(v, 1 - ALPHA,      names = FALSE))
  qb  <- unname(quantile(v, 1 - ALPHA_BONF, names = FALSE))
  cat(sprintf("%s,R%d,%d,%.4f,%.4f,%.4f,%.4f,%s,%s\n",
              cb$em, cb$r, cb$B, w1, mean(v), q95, qb,
              w1 > q95, w1 > qb))
}
