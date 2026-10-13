# Referee recomputation of the patient-level bootstrap rank intervals (Table 8) and the Spearman intervals (Discussion). Own seed; B = 1000.
g <- read.csv("data/gusto.csv")
w1f <- function(x, y) { x <- sort(x); y <- sort(y); z <- sort(c(x, y)); k <- z[-length(z)]
  sum(diff(z) * abs(findInterval(k, x) / length(x) - findInterval(k, y) / length(y))) }
P <- setdiff(sort(unique(g$regl)), 8); ems <- c("age", "sysbp")
idx <- split(seq_len(nrow(g)), g$regl)
smd <- function(x, y) abs(mean(x) - mean(y)) / sqrt(((length(x) - 1) * var(x) + (length(y) - 1) * var(y)) / (length(x) + length(y) - 2))
set.seed(777); B <- 1000
RK <- array(NA, c(B, length(P), 2)); rho <- numeric(B); rws <- matrix(NA, B, 2)
for (b in 1:B) {
  ii <- lapply(idx, function(i) i[sample.int(length(i), length(i), replace = TRUE)])
  for (j in 1:2) { v <- ems[j]; a <- g[[v]][ii[["8"]]]
    w <- sapply(P, function(p) w1f(a, g[[v]][ii[[as.character(p)]]]))
    s <- sapply(P, function(p) smd(a, g[[v]][ii[[as.character(p)]]]))
    RK[b, , j] <- rank(w); rws[b, j] <- cor(rank(w), rank(s)); if (j == 1) wa <- w else rho[b] <- cor(rank(wa), rank(w)) }
}
ri <- read.csv("results/gusto_rank_intervals.csv")
for (j in 1:2) { q <- t(apply(RK[, , j], 2, quantile, c(.025, .975), type = 1))
  o <- ri[ri$em == ems[j], ]; o <- o[order(o$partner), ]
  print(data.frame(em = ems[j], partner = P, ref_lo = q[, 1], ref_hi = q[, 2], ms_obs = o$rank_obs, ms_lo = o$rank_lo, ms_hi = o$rank_hi), row.names = FALSE) }
cat("Spearman age vs sbp bootstrap 95%:", quantile(rho, c(.025, .975), type = 1), "\n")
cat("Spearman W1 vs SMD age:", quantile(rws[, 1], c(.025, .975), type = 1), " sbp:", quantile(rws[, 2], c(.025, .975), type = 1), "\n")
