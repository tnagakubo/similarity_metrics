#!/usr/bin/env Rscript
# gusto_null_floor_permutation.R -- single writer of results/gusto_null_floor_permutation.csv and
# results/gusto_null_floor_permutation_summary.csv
#
# EXPLORATORY sensitivity, added 2026-10-12 after the external review (review_response/EXTERNAL_REVIEW_20261012.md, M5:
# the null floor read as a test; multiplicity). Not pre-registered. See results/GUSTO_NULL_FLOOR_PERMUTATION_PROVENANCE.md.
#
# For each (EM, partner) pair, 2 EMs x 15 partners vs Region 8 (predtools::gusto, complete cases, as R/gusto_operability_check.R):
#   H0: F_R8 = F_p (exchangeability of the pooled n_8 + n_p values). Statistic T = W1-hat(R8 sample, partner sample).
#   Permutation k = 1..K (K = 2,000): randomly relabel the pooled sample keeping the group sizes n_8 and n_p; T*_k.
#   One-sided p = (1 + #{k: T*_k >= T_obs}) / (K + 1).  "unresolved" <=> p > 0.05.
#   Compared with the anchor-resampling classification of results/gusto_operability.csv (unresolved <=> W1 <= q95 of the
#   anchor-drawn null, i.e. resolved_anchor == FALSE). The two procedures have different nulls (pooled exchangeability vs
#   both samples drawn from R8's empirical distribution), so disagreement is a finding, not an error.
#   Multiplicity remark: number of pairs with p < 0.05 / 30. With K = 2,000 the smallest attainable p is 1/2001.
#   MCSE of p (given the data): sqrt(p (1 - p) / K).
# W1 of a permuted labelling, fast exact form: with the pooled sample sorted once (a_1 <= ... <= a_N) and lab_i = 1 for the
# R8 label, W1 = sum_{i<N} | cumsum(lab)_i / n_8 - cumsum(1 - lab)_i / n_p | (a_{i+1} - a_i). This equals compute_w1 (the
# CDF-area form of R/gusto_operability_check.R) including ties, because a zero gap contributes 0 and at a positive gap the
# cumulative counts equal the ECDFs at the midpoint. Asserted against compute_w1 on the observed pair and on 5 permutations
# per pair.
SEED  <- 20261012L
K     <- 2000L
ALPHA <- 0.05
ANCHOR <- 8L
proj    <- if (file.exists("results/w1_raw_summary.csv")) "." else "projects/similarity-metric"
IN_OP   <- file.path(proj, "results", "gusto_operability.csv")
OUT_CSV <- file.path(proj, "results", "gusto_null_floor_permutation.csv")
OUT_SUM <- file.path(proj, "results", "gusto_null_floor_permutation_summary.csv")
OUT_SI  <- file.path(proj, "results", "gusto_null_floor_permutation_sessionInfo.txt")
suppressWarnings(RNGkind("Mersenne-Twister", "Inversion", "Rejection"))
set.seed(SEED)
suppressPackageStartupMessages(library(predtools))

compute_w1 <- function(x, y) {   # verbatim from R/gusto_operability_check.R
  a <- sort(c(x, y)); n <- length(a); if (n < 2) return(0)
  Fx <- ecdf(x); Fy <- ecdf(y); m <- (a[-n] + a[-1]) / 2
  sum(abs(Fx(m) - Fy(m)) * diff(a))
}
w1_lab <- function(gap, lab, n1, n2) {   # lab in pooled sorted order; 1 = anchor
  N <- length(lab); c1 <- cumsum(lab)[-N]
  sum(abs(c1 / n1 - ((1:(N - 1)) - c1) / n2) * gap)
}

data(gusto, package = "predtools")
g <- gusto[!is.na(gusto$age) & !is.na(gusto$sysbp), ]
regs <- sort(unique(g$regl)); rn <- paste0("R", regs)
anch <- paste0("R", ANCHOR); partners <- setdiff(rn, anch)
op <- read.csv(IN_OP, stringsAsFactors = FALSE)

rows <- list()
for (em in c("age", "sysbp")) {
  x <- g[[em]][g$regl == ANCHOR]
  for (p in partners) {
    y <- g[[em]][g$regl == as.integer(sub("R", "", p))]
    n1 <- length(x); n2 <- length(y)
    pool <- c(x, y); o <- order(pool); a <- pool[o]; gap <- diff(a)
    lab0 <- c(rep(1L, n1), rep(0L, n2))
    t_obs <- compute_w1(x, y)
    stopifnot(abs(w1_lab(gap, lab0[o], n1, n2) - t_obs) < 1e-9)
    tstar <- numeric(K)
    for (k in seq_len(K)) {
      lab <- sample(lab0)                       # random relabelling of the pooled values, sizes kept
      tstar[k] <- w1_lab(gap, lab[o], n1, n2)
      if (k <= 5L) stopifnot(abs(tstar[k] - compute_w1(pool[lab == 1L], pool[lab == 0L])) < 1e-9)
    }
    pv <- (1 + sum(tstar >= t_obs)) / (K + 1)
    r_op <- op[op$em == em & op$region == p, ]
    stopifnot(nrow(r_op) == 1, abs(r_op$w1_obs - t_obs) < 1e-12)
    rows[[length(rows) + 1L]] <- data.frame(em = em, region = p, n_anchor = n1, n_partner = n2, w1_obs = t_obs,
      perm_mean = mean(tstar), perm_q95 = unname(quantile(tstar, 0.95)), n_exceed = sum(tstar >= t_obs),
      p_perm = pv, p_perm_mcse = sqrt(pv * (1 - pv) / K),
      unresolved_perm = pv > ALPHA, unresolved_anchor = !r_op$resolved_anchor,
      agree = (pv > ALPHA) == !r_op$resolved_anchor, bonf_sig = pv < ALPHA / 30,
      null_q95_anchor = r_op$null_q95_anchor, stringsAsFactors = FALSE)
  }
}
out <- do.call(rbind, rows)
write.csv(out, OUT_CSV, row.names = FALSE)
summ <- data.frame(quantity = c("n_pairs", "n_perm_agree", "n_perm_disagree", "n_perm_bonf", "n_perm_unresolved",
                                "n_anchor_unresolved", "K", "alpha_bonf"),
                   value = c(nrow(out), sum(out$agree), sum(!out$agree), sum(out$bonf_sig), sum(out$unresolved_perm),
                             sum(out$unresolved_anchor), K, ALPHA / 30))
write.csv(summ, OUT_SUM, row.names = FALSE)
writeLines(capture.output(sessionInfo()), OUT_SI)
print(out[, c("em", "region", "w1_obs", "perm_q95", "null_q95_anchor", "n_exceed", "p_perm", "p_perm_mcse",
              "unresolved_perm", "unresolved_anchor", "agree", "bonf_sig")], digits = 4, row.names = FALSE)
print(summ, row.names = FALSE)
