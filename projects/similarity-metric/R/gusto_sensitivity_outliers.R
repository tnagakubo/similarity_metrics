#!/usr/bin/env Rscript
# gusto_sensitivity_outliers.R -- single writer of results/gusto_sensitivity_outliers.csv,
# results/gusto_sensitivity_outliers_summary.csv and results/gusto_sbp_digit_preference.csv
#
# EXPLORATORY sensitivity, added 2026-10-12 after the external review (review_response/EXTERNAL_REVIEW_20261012.md, M7(c):
# SBP = 0 and age > 100 records; digit preference). Not pre-registered. See results/GUSTO_SENSITIVITY_OUTLIERS_PROVENANCE.md.
#
# Data: predtools::gusto, complete cases on age and sysbp (40,830 patients, 16 regions), exactly as R/gusto_operability_check.R.
# Anchor Region 8, 15 partners, EMs age and sysbp. Variants (per EM, never a joint row filter):
#   (a) as recorded
#   (b) exclusion: sysbp == 0 dropped from the SBP analysis only; age > 100 dropped from the age analysis only.
#       Region 8 itself holds one age > 100 record, so the age anchor shrinks to 2,915; R8 has no sysbp == 0.
#   (c) winsorisation of each EM at the 1st / 99th percentile (quantile type 7) of the pooled 16-region sample of that EM.
# W1: compute_w1 copied verbatim from R/gusto_operability_check.R (CDF-area form; identical to R/fig3_w1_axis.R, which wrote
# results/gusto_r8_w1_per_pair.csv). Asserted: variant (a) reproduces gusto_r8_w1_per_pair.csv and gusto_operability.csv
# w1_obs to 1e-12.
# Ranks: rank of W1 among the 15 partners within EM (1 = closest); rank change = rank differs from variant (a).
# Null floor (variants (a) and (b)): the gusto_operability_check.R loop run verbatim -- set.seed(20260821) once, EM order age
# then sysbp, per partner the anchor-drawn floor then the partner-drawn floor, B = 2,000, alpha = 0.05; resolved <=> W1 > q95.
# Variant (a) must reproduce gusto_operability.csv exactly (asserted); variant (b) reruns the identical loop with the same
# seed on the (b) data. Because n changes under (b), the RNG stream diverges after the first changed draw: a floor flip under
# (b) mixes the outlier effect with Monte Carlo noise in q95, so the margin W1 - q95 is written for (a) and (b).
# Digit preference: per region, share of sysbp values whose terminal digit is 0 (sysbp %% 10 == 0) and 0 or 5
# (sysbp %% 5 == 0); sysbp is integer-valued in GUSTO-I (asserted). Computed as recorded and excluding sysbp == 0.
SEED   <- 20260821L      # the seed of R/gusto_operability_check.R (null floors are re-drawn with it)
B      <- 2000L
ALPHA  <- 0.05
ANCHOR <- 8L
proj    <- if (file.exists("results/w1_raw_summary.csv")) "." else "projects/similarity-metric"
IN_OP   <- file.path(proj, "results", "gusto_operability.csv")
IN_PP   <- file.path(proj, "results", "gusto_r8_w1_per_pair.csv")
OUT_CSV <- file.path(proj, "results", "gusto_sensitivity_outliers.csv")
OUT_DIG <- file.path(proj, "results", "gusto_sbp_digit_preference.csv")
OUT_SUM <- file.path(proj, "results", "gusto_sensitivity_outliers_summary.csv")
OUT_SI  <- file.path(proj, "results", "gusto_sensitivity_outliers_sessionInfo.txt")
suppressWarnings(RNGkind("Mersenne-Twister", "Inversion", "Rejection"))
suppressPackageStartupMessages(library(predtools))

compute_w1 <- function(x, y) {   # verbatim from R/gusto_operability_check.R
  a <- sort(c(x, y)); n <- length(a); if (n < 2) return(0)
  Fx <- ecdf(x); Fy <- ecdf(y); m <- (a[-n] + a[-1]) / 2
  sum(abs(Fx(m) - Fy(m)) * diff(a))
}
null_floor <- function(src, n1, n2, B, alpha) {   # verbatim from R/gusto_operability_check.R
  v <- numeric(B)
  for (b in seq_len(B)) {
    v[b] <- compute_w1(sample(src, n1, replace = TRUE),
                       sample(src, n2, replace = TRUE))
  }
  c(mean = mean(v), q = unname(quantile(v, 1 - alpha, names = FALSE)))
}

data(gusto, package = "predtools")
g <- gusto[!is.na(gusto$age) & !is.na(gusto$sysbp), ]
regs <- sort(unique(g$regl)); rn <- paste0("R", regs)
anch <- paste0("R", ANCHOR); partners <- setdiff(rn, anch)
EMS <- c("age", "sysbp")

split_em <- function(v, keep, transform = identity) {
  S <- lapply(regs, function(r) transform(g[[v]][g$regl == r & keep])); names(S) <- rn; S
}
wins <- function(v) {
  q <- unname(quantile(g[[v]], c(0.01, 0.99), type = 7))
  function(z) pmin(pmax(z, q[1]), q[2])
}
samples <- list(
  a = list(age = split_em("age", TRUE), sysbp = split_em("sysbp", TRUE)),
  b = list(age = split_em("age", g$age <= 100), sysbp = split_em("sysbp", g$sysbp != 0)),
  c = list(age = split_em("age", TRUE, wins("age")), sysbp = split_em("sysbp", TRUE, wins("sysbp"))))
wq <- rbind(age = quantile(g$age, c(0.01, 0.99), type = 7), sysbp = quantile(g$sysbp, c(0.01, 0.99), type = 7))

run_floor <- function(S2) {   # operability loop, verbatim order
  set.seed(SEED)
  out <- list()
  for (em in EMS) {
    S <- S2[[em]]; src_a <- S[[anch]]; n_a <- length(src_a)
    for (p in partners) {
      n_p <- length(S[[p]])
      w1  <- compute_w1(src_a, S[[p]])
      fa  <- null_floor(src_a,  n_a, n_p, B, ALPHA)
      fp  <- null_floor(S[[p]], n_a, n_p, B, ALPHA)
      out[[length(out) + 1L]] <- data.frame(em = em, region = p, n_anchor = n_a, n_partner = n_p, w1_obs = w1,
        null_mean_anchor = fa[["mean"]], null_q95_anchor = fa[["q"]],
        null_mean_partner = fp[["mean"]], null_q95_partner = fp[["q"]],
        resolved_anchor = w1 > fa[["q"]], resolved_partner = w1 > fp[["q"]], stringsAsFactors = FALSE)
    }
  }
  do.call(rbind, out)
}
t0 <- Sys.time()
fl_a <- run_floor(samples$a)
op <- read.csv(IN_OP, stringsAsFactors = FALSE)
stopifnot(identical(op$em, fl_a$em), identical(op$region, fl_a$region),
          identical(op$resolved_anchor, fl_a$resolved_anchor), identical(op$resolved_partner, fl_a$resolved_partner))
for (cc in c("w1_obs", "null_mean_anchor", "null_q95_anchor", "null_mean_partner", "null_q95_partner"))
  stopifnot(max(abs(op[[cc]] - fl_a[[cc]])) < 1e-12)
cat("variant (a) reproduces gusto_operability.csv (", format(Sys.time() - t0), ")\n")
fl_b <- run_floor(samples$b)

pp <- read.csv(IN_PP, stringsAsFactors = FALSE)
rows <- list()
for (em in EMS) {
  w <- sapply(c("a", "b", "c"), function(vr) vapply(partners, function(p)
    compute_w1(samples[[vr]][[em]][[anch]], samples[[vr]][[em]][[p]]), 0))
  ref <- pp[[paste0("W1_", em)]][match(as.integer(sub("R", "", partners)), pp$partner)]
  stopifnot(max(abs(w[, "a"] - ref)) < 1e-12)
  rk <- apply(w, 2, rank)
  fa <- fl_a[fl_a$em == em, ]; fb <- fl_b[fl_b$em == em, ]
  stopifnot(identical(fa$region, partners), identical(fb$region, partners), max(abs(fb$w1_obs - w[, "b"])) < 1e-12)
  rows[[em]] <- data.frame(em = em, region = partners,
    n_anchor_a = length(samples$a[[em]][[anch]]),
    n_partner_a = vapply(partners, function(p) length(samples$a[[em]][[p]]), 0L),
    n_anchor_b = length(samples$b[[em]][[anch]]),
    n_partner_b = vapply(partners, function(p) length(samples$b[[em]][[p]]), 0L),
    w1_a = w[, "a"], w1_b = w[, "b"], w1_c = w[, "c"],
    abs_change_b = abs(w[, "b"] - w[, "a"]), abs_change_c = abs(w[, "c"] - w[, "a"]),
    rank_a = rk[, "a"], rank_b = rk[, "b"], rank_c = rk[, "c"],
    q95_anchor_a = fa$null_q95_anchor, q95_anchor_b = fb$null_q95_anchor,
    margin_a = w[, "a"] - fa$null_q95_anchor, margin_b = w[, "b"] - fb$null_q95_anchor,
    resolved_anchor_a = fa$resolved_anchor, resolved_anchor_b = fb$resolved_anchor,
    resolved_partner_b = fb$resolved_partner,
    winsor_lo = wq[em, 1], winsor_hi = wq[em, 2], stringsAsFactors = FALSE, row.names = NULL)
}
out <- do.call(rbind, rows)
stopifnot(all(out$rank_a == round(out$rank_a)), all(out$rank_b == round(out$rank_b)), all(out$rank_c == round(out$rank_c)))
write.csv(out, OUT_CSV, row.names = FALSE)

q <- function(name, value) data.frame(quantity = name, value = value, stringsAsFactors = FALSE)
summ <- rbind(
  q("w1_max_change_excl_age",   max(out$abs_change_b[out$em == "age"])),
  q("w1_max_change_excl_sbp",   max(out$abs_change_b[out$em == "sysbp"])),
  q("w1_max_change_winsor_age", max(out$abs_change_c[out$em == "age"])),
  q("w1_max_change_winsor_sbp", max(out$abs_change_c[out$em == "sysbp"])),
  q("n_rank_changes_excl",   sum(out$rank_b != out$rank_a)),
  q("n_rank_changes_winsor", sum(out$rank_c != out$rank_a)),
  q("n_floor_changes_excl",  sum(out$resolved_anchor_b != out$resolved_anchor_a)),
  q("n_sbp_zero", sum(g$sysbp == 0)), q("n_age_over_100", sum(g$age > 100)))

stopifnot(all(g$sysbp == round(g$sysbp)))
dig <- do.call(rbind, lapply(regs, function(r) {
  s <- g$sysbp[g$regl == r]; s0 <- s[s != 0]
  data.frame(region = paste0("R", r), n = length(s), n_excl0 = length(s0),
             p_digit0 = mean(s %% 10 == 0), p_digit05 = mean(s %% 5 == 0),
             p_digit0_excl0 = mean(s0 %% 10 == 0), p_digit05_excl0 = mean(s0 %% 5 == 0), stringsAsFactors = FALSE)
}))
write.csv(dig, OUT_DIG, row.names = FALSE)
summ <- rbind(summ,
  q("sbp_digit0_min_excl0", min(dig$p_digit0_excl0)), q("sbp_digit0_max_excl0", max(dig$p_digit0_excl0)),
  q("sbp_digit0_r8_excl0", dig$p_digit0_excl0[dig$region == anch]),
  q("sbp_digit05_min_excl0", min(dig$p_digit05_excl0)), q("sbp_digit05_max_excl0", max(dig$p_digit05_excl0)),
  q("sbp_digit05_r8_excl0", dig$p_digit05_excl0[dig$region == anch]),
  q("sbp_digit0_min_asrec", min(dig$p_digit0)), q("sbp_digit0_max_asrec", max(dig$p_digit0)),
  q("sbp_digit0_r8_asrec", dig$p_digit0[dig$region == anch]))
write.csv(summ, OUT_SUM, row.names = FALSE)
writeLines(capture.output(sessionInfo()), OUT_SI)

print(out[, c("em", "region", "w1_a", "w1_b", "w1_c", "rank_a", "rank_b", "rank_c", "margin_a", "margin_b",
              "resolved_anchor_a", "resolved_anchor_b")], digits = 4, row.names = FALSE)
print(dig, digits = 4, row.names = FALSE)
print(summ, digits = 6, row.names = FALSE)
cat("winsor limits (1st, 99th pct)\n"); print(wq)
