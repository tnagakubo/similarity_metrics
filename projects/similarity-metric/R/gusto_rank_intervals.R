#!/usr/bin/env Rscript
# gusto_rank_intervals.R — single writer of results/gusto_rank_intervals.csv and results/gusto_rank_spearman_boot.csv:
# patient-level bootstrap uncertainty of the Table 5 ranks (partners ordered by W1 to Region 8 within each modifier) and of
# Spearman's correlation between the age ordering and the SBP ordering.
#
# Added 2026-10-11 after the cold referee's Major 4 (review_response/REFEREE_20261011.md; DECISIONS.md D-20261011-11 judgement 3).
# Prior look disclosed: the referee computed similar intervals in review_response/referee/20261011/r05_rank_uncertainty_and_misc.R
# (seed 5). This script is an independent re-implementation in the lab's style with its own seed; it does not source the referee's
# code. See results/GUSTO_RANK_INTERVALS_PROVENANCE.md.
#
# Definition (estimand and interval):
#   For partner p and modifier v, W_pv = W1(F_{R8,v}, F_{p,v}); rank_pv = rank of W_pv among the 15 partners (1 = closest).
#   rank_obs = rank of the point estimates in results/gusto_r8_w1_per_pair.csv (exactly the Rank column of Table 5).
#   Bootstrap replicate b = 1..B: resample patients with replacement within every region (sizes kept); Region 8 is resampled
#   ONCE per replicate and shared by the 15 partners (so the replicate ranks share the anchor's sampling error, as the observed
#   ranks do). Recompute W1-hat for all 15 partners on age and on sysbp, rank within each modifier.
#   rank_lo / rank_hi = 2.5th / 97.5th percentiles of the B bootstrap ranks, quantile type 1 (inverse empirical CDF), so the
#   limits are attained ranks (integers). Spearman: rho_b = cor(age ranks, SBP ranks) of replicate b; rho_lo / rho_hi = type-1
#   2.5th / 97.5th percentiles; rho_obs = Spearman of the point estimates. Percentile intervals; no bias correction.
#   The interval reflects patient-level sampling only (the partners are the 15 regions of the trial, not a sample of regions).
#
# W1: compute_w1 of R/fig3_w1_axis.R (the script that wrote results/gusto_r8_w1_per_pair.csv) — CDF-area form, sum over
# consecutive pooled order statistics of |F1 - F2| x gap (zero gaps contribute 0, so this equals the sum over distinct values,
# eq. (8) / Appendix B). Not selection_simulation.R::w1_dist (truncates unequal n; .claude/rules/r-code.md).
# 2026-10-12 (Louis's residual review M5, D-20261012-2): the SAME loop also records, per replicate, Spearman's correlation
# between the 15 partners' W1 and |SMD| to Region 8 for age and for SBP (rho_w1_smd_{age,sbp}_{obs,lo,hi}). |SMD| is smd_s of
# R/application_all_methods.R (pooled SD with n - 1 weights), the definition behind app_all_methods_ranks.csv spearman_vs_W1.
# The SMD step consumes no random numbers, so the resamples and every pre-existing output value are unchanged.
# Usage: Rscript projects/similarity-metric/R/gusto_rank_intervals.R   (from the repo root or the project dir)
SEED <- 20261011L
B    <- 1000L
proj <- if (file.exists("results/w1_raw_summary.csv")) "." else "projects/similarity-metric"
IN_DATA <- file.path(proj, "data", "gusto.csv")
IN_PP   <- file.path(proj, "results", "gusto_r8_w1_per_pair.csv")
IN_AMR  <- file.path(proj, "results", "app_all_methods_ranks.csv")
OUT_RK  <- file.path(proj, "results", "gusto_rank_intervals.csv")
OUT_RHO <- file.path(proj, "results", "gusto_rank_spearman_boot.csv")
OUT_SI  <- file.path(proj, "results", "gusto_rank_intervals_sessionInfo.txt")
suppressWarnings(RNGkind("Mersenne-Twister", "Inversion", "Rejection"))
set.seed(SEED)

compute_w1 <- function(x, y) {   # verbatim from R/fig3_w1_axis.R
  all_vals <- sort(c(x, y))
  n <- length(all_vals)
  if (n < 2) return(0)
  Fx <- ecdf(x); Fy <- ecdf(y)
  mids  <- (all_vals[-n] + all_vals[-1]) / 2
  diffs <- diff(all_vals)
  sum(abs(Fx(mids) - Fy(mids)) * diffs)
}

smd_s <- function(sx, sy) {   # verbatim from R/application_all_methods.R
  n1 <- length(sx); n2 <- length(sy)
  sp <- sqrt(((n1 - 1) * var(sx) + (n2 - 1) * var(sy)) / (n1 + n2 - 2))
  abs(mean(sx) - mean(sy)) / sp
}

g  <- read.csv(IN_DATA, stringsAsFactors = FALSE)
pp <- read.csv(IN_PP, stringsAsFactors = FALSE)
anchor <- 8L
partners <- sort(setdiff(unique(g$regl), anchor))
stopifnot(length(partners) == 15, setequal(partners, pp$partner))
pp <- pp[match(partners, pp$partner), ]
ems <- c("age", "sysbp")
pt_col <- c(age = "W1_age", sysbp = "W1_sysbp")

# data/gusto.csv must reproduce the point estimates written from predtools::gusto (otherwise the ranks are not Table 5's)
obs <- sapply(ems, function(v) vapply(partners, function(p) compute_w1(g[[v]][g$regl == anchor], g[[v]][g$regl == p]), 0))
for (v in ems) stopifnot(max(abs(obs[, v] - pp[[pt_col[[v]]]])) < 1e-10)
rank_obs <- sapply(ems, function(v) rank(pp[[pt_col[[v]]]]))
stopifnot(all(rank_obs == round(rank_obs)))   # no ties among the point estimates
# observed Spearman(W1, |SMD|) must reproduce app_all_methods_ranks.csv (registry spearmanW1SMDage / spearmanW1SMDsbp)
smd_obs <- sapply(ems, function(v) vapply(partners, function(p) smd_s(g[[v]][g$regl == anchor], g[[v]][g$regl == p]), 0))
rho_ws_obs <- sapply(ems, function(v) cor(obs[, v], smd_obs[, v], method = "spearman"))
amr <- read.csv(IN_AMR, stringsAsFactors = FALSE)
for (v in ems) stopifnot(abs(rho_ws_obs[[v]] - amr$spearman_vs_W1[amr$em == v & amr$method == "SMD"]) < 1e-12)

# bootstrap: regions resampled in a fixed sorted order; Region 8 once per replicate
idx <- split(seq_len(nrow(g)), g$regl)
idx <- idx[as.character(sort(as.integer(names(idx))))]
RK  <- array(NA_real_, c(B, length(partners), length(ems)), dimnames = list(NULL, partners, ems))
rho_b <- numeric(B)
rho_ws_b <- matrix(NA_real_, B, length(ems), dimnames = list(NULL, ems))
for (b in seq_len(B)) {
  ii <- lapply(idx, function(i) i[sample.int(length(i), length(i), replace = TRUE)])
  for (v in ems) {
    xa <- g[[v]][ii[[as.character(anchor)]]]
    w  <- vapply(partners, function(p) compute_w1(xa, g[[v]][ii[[as.character(p)]]]), 0)
    RK[b, , v] <- rank(w)
    sm <- vapply(partners, function(p) smd_s(xa, g[[v]][ii[[as.character(p)]]]), 0)   # no RNG
    rho_ws_b[b, v] <- cor(w, sm, method = "spearman")
  }
  rho_b[b] <- cor(RK[b, , "age"], RK[b, , "sysbp"], method = "spearman")
}

out <- do.call(rbind, lapply(ems, function(v) {
  q <- t(apply(RK[, , v], 2, quantile, probs = c(0.025, 0.975), type = 1, names = FALSE))
  data.frame(partner = partners, em = v, rank_obs = as.integer(rank_obs[, v]), rank_lo = q[, 1], rank_hi = q[, 2])
}))
stopifnot(all(out$rank_lo == round(out$rank_lo)), all(out$rank_hi == round(out$rank_hi)), all(out$rank_lo <= out$rank_hi))
out$rank_lo <- as.integer(out$rank_lo); out$rank_hi <- as.integer(out$rank_hi)
write.csv(out, OUT_RK, row.names = FALSE)

rho_obs <- cor(pp$W1_age, pp$W1_sysbp, method = "spearman")
rq <- quantile(rho_b, c(0.025, 0.975), type = 1, names = FALSE)
wq <- sapply(ems, function(v) quantile(rho_ws_b[, v], c(0.025, 0.975), type = 1, names = FALSE))
write.csv(data.frame(stat = c("rho_obs", "rho_lo", "rho_hi", "B",
                              "rho_w1_smd_age_obs", "rho_w1_smd_age_lo", "rho_w1_smd_age_hi",
                              "rho_w1_smd_sbp_obs", "rho_w1_smd_sbp_lo", "rho_w1_smd_sbp_hi"),
                     value = c(rho_obs, rq[1], rq[2], B,
                               rho_ws_obs[["age"]], wq[1, "age"], wq[2, "age"],
                               rho_ws_obs[["sysbp"]], wq[1, "sysbp"], wq[2, "sysbp"])), OUT_RHO, row.names = FALSE)
writeLines(c(sprintf("seed = %d; B = %d; RNGkind = %s", SEED, B, paste(RNGkind(), collapse = " / ")), capture.output(sessionInfo())), OUT_SI)
cat(sprintf("gusto_rank_intervals: wrote %s (%d rows) and %s; rho_obs %.4f [%.4f, %.4f]\n", OUT_RK, nrow(out), OUT_RHO, rho_obs, rq[1], rq[2]))
