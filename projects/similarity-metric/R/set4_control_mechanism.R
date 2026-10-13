#!/usr/bin/env Rscript
# set4_control_mechanism.R — production single writer for PROTOCOL_set4_control_mechanism.md.
# Copied from exploratory/set4_control_mechanism/R/set4_control_mechanism.R (which is left as is). Changes from the
# exploratory version: n_sim 4,000; fresh per-cell seed offsets (>= 20000, disjoint from the exploratory offsets); AUC and
# paired Delta-AUC MCSE by DeLong components (analytic, no replicate bootstrap); separation index and Study 1 bridge removed.
# Question: does the Set 4 anchor inflate the null SD of W1-hat relative to N(50,10^2) while leaving D_KS unchanged, and
# does the paired AUC ordering W1 vs KS reverse between the two anchors at the control shifts delta = 2, 3?
# DGM: R/selection_simulation.R ext_c / build_set4 (s0 = 10, st = 8). Anchor = 0.05 N(10,8^2) + 0.90 N(50,10^2) +
# 0.05 N(90,8^2); bulk_shift S1/S2 = mu0 52/53 = the whole mixture translated, drawn here as anchor + delta.
# W1 = CDF-area convention (compute_w1 of R/fig3_w1_axis.R, copied verbatim and used to verify the one-pass stat2).
# Outputs (results/): set4_control_mechanism.csv, set4_null_sd_ratios.csv, set4_integrals.csv,
#   set4_control_mechanism_per_rep.rds, set4_control_mechanism.log, set4_control_mechanism_sessionInfo.txt
# Usage: Rscript projects/similarity-metric/R/set4_control_mechanism.R   (from the repo root or the project dir)
suppressWarnings(RNGkind("Mersenne-Twister", "Inversion", "Rejection"))
SEED   <- 20261012
N_SIM  <- 4000
N_GRID <- c(100, 200, 400)
DELTAS <- c(2, 3)
PROTOCOL <- "PROTOCOL_set4_control_mechanism.md"

proj <- if (file.exists("results/w1_raw_summary.csv")) "." else "projects/similarity-metric"
stopifnot(file.exists(file.path(proj, PROTOCOL)))
RES <- file.path(proj, "results")
OUT_CSV   <- file.path(RES, "set4_control_mechanism.csv")
OUT_RATIO <- file.path(RES, "set4_null_sd_ratios.csv")
OUT_INT   <- file.path(RES, "set4_integrals.csv")
OUT_RDS   <- file.path(RES, "set4_control_mechanism_per_rep.rds")
OUT_LOG   <- file.path(RES, "set4_control_mechanism.log")
OUT_SI    <- file.path(RES, "set4_control_mechanism_sessionInfo.txt")
t0 <- Sys.time()

# ---- DGM ---------------------------------------------------------------------------------------------------
ext_c <- function(mu0, eL, dL, eH, dH, s0 = 10, st = 8) {
  w <- c(eL, 1 - eL - eH, eH); m <- c(mu0 - dL, mu0, mu0 + dH); s <- c(st, s0, st)
  list(sampler = function(n) {
         k <- as.vector(rmultinom(1L, n, w))
         c(rnorm(k[1], m[1], s[1]), rnorm(k[2], m[2], s[2]), rnorm(k[3], m[3], s[3]))
       },
       cdf = function(t) w[1]*pnorm(t, m[1], s[1]) + w[2]*pnorm(t, m[2], s[2]) + w[3]*pnorm(t, m[3], s[3]))
}
bases <- list(
  gauss = list(sampler = function(n) rnorm(n, 50, 10), cdf = function(t) pnorm(t, 50, 10)),
  mix   = ext_c(50, 0.05, 40, 0.05, 40)
)

# ---- statistics --------------------------------------------------------------------------------------------
compute_w1 <- function(x, y) {           # verbatim from R/fig3_w1_axis.R (reference implementation)
  all_vals <- sort(c(x, y)); n <- length(all_vals)
  if (n < 2) return(0)
  Fx <- ecdf(x); Fy <- ecdf(y)
  mids <- (all_vals[-n] + all_vals[-1]) / 2; diffs <- diff(all_vals)
  sum(abs(Fx(mids) - Fy(mids)) * diffs)
}
stat2 <- function(x, y) {                # one pass over the pooled sort, equal n: W1 (CDF area) and KS (exact lattice k/n)
  n <- length(x); stopifnot(length(y) == n)
  z <- c(x, y); o <- order(z); zs <- z[o]
  ci <- cumsum(ifelse(o <= n, 1L, -1L))
  c(w1 = sum(abs(ci[-2L * n]) * diff(zs)) / n, ks = max(abs(ci)) / n)
}
set.seed(SEED - 1L)
for (r in 1:20) {
  x <- bases$mix$sampler(150); y <- bases$mix$sampler(150) + 2; s <- stat2(x, y)
  stopifnot(abs(s[["w1"]] - compute_w1(x, y)) < 1e-10,
            abs(s[["ks"]] - unname(suppressWarnings(ks.test(x, y))$statistic)) < 1e-12)
}
draw <- function(base, n, delta, nsim) {
  out <- matrix(NA_real_, nsim, 2, dimnames = list(NULL, c("w1", "ks")))
  for (r in seq_len(nsim)) out[r, ] <- stat2(base$sampler(n), base$sampler(n) + delta)
  out
}

# ---- performance measures and MCSE (protocol section 3 P) ---------------------------------------------------
sd_mcse <- function(v) { s <- sd(v); m4 <- mean((v - mean(v))^4); sqrt((m4 - s^4) / (4 * s^2 * length(v))) }
delong <- function(alt, nul) {           # AUC (ties 1/2) and its DeLong components
  m <- length(alt); k <- length(nul); rc <- rank(c(alt, nul))
  v10 <- (rc[seq_len(m)] - rank(alt)) / k          # (#null below a_i + ties/2) / k
  v01 <- 1 - (rc[m + seq_len(k)] - rank(nul)) / m  # (#alt above u_j + ties/2) / m
  list(auc = mean(v10), v10 = v10, v01 = v01, mcse = sqrt(var(v10) / m + var(v01) / k))
}

# ---- integrals and population values -----------------------------------------------------------------------
iF <- function(cdf) integrate(function(t) { p <- cdf(t); sqrt(pmax(p * (1 - p), 0)) }, -150, 250,
                              subdivisions = 5000L, rel.tol = 1e-10)
int_std <- integrate(function(t) sqrt(pnorm(t) * pnorm(-t)), -15, 15, subdivisions = 5000L, rel.tol = 1e-12)$value
true_ks <- function(cdf, d) { g <- seq(-150, 250, length.out = 400001L); max(abs(cdf(g) - cdf(g - d))) }
ig <- lapply(bases, function(b) iF(b$cdf))
ints <- data.frame(base = names(bases),
                   int_sqrtF1F = vapply(ig, `[[`, 0, "value"), abs_error = vapply(ig, `[[`, 0, "abs.error"),
                   check_10x_std_normal = c(10 * int_std, NA_real_),
                   sd_population = c(10, sqrt(0.9 * 100 + 0.1 * 64 + 0.1 * 40^2)), row.names = NULL)
stopifnot(abs(ints$int_sqrtF1F[1] - ints$check_10x_std_normal[1]) < 1e-6)
ints$ratio_to_gauss <- ints$int_sqrtF1F / ints$int_sqrtF1F[1]
write.csv(ints, OUT_INT, row.names = FALSE)

# ---- main loop (serial; per-cell seeds) ---------------------------------------------------------------------
cell_seed <- function(ib, j, k) SEED + 20000L + 1000L * ib + 100L * j + 10L * k   # k = 0: null cell
rows <- list(); per_rep <- list()
for (ib in seq_along(bases)) {
  bn <- names(bases)[ib]; b <- bases[[bn]]
  for (j in seq_along(N_GRID)) {
    n <- N_GRID[j]
    set.seed(cell_seed(ib, j, 0L)); nul <- draw(b, n, 0, N_SIM)
    per_rep[[sprintf("%s_n%d_null", bn, n)]] <- nul
    for (k in seq_along(DELTAS)) {
      dl <- DELTAS[k]
      set.seed(cell_seed(ib, j, k)); alt <- draw(b, n, dl, N_SIM)
      per_rep[[sprintf("%s_n%d_d%g", bn, n, dl)]] <- alt
      dlg <- list()
      for (st in c("w1", "ks")) {
        a <- alt[, st]; u <- nul[, st]; dlg[[st]] <- delong(a, u)
        rows[[length(rows) + 1L]] <- data.frame(
          base = bn, n = n, delta = dl, statistic = st, n_sim = N_SIM,
          mean_null = mean(u), mean_null_mcse = sd(u) / sqrt(N_SIM),
          mean_shift = mean(a), mean_shift_mcse = sd(a) / sqrt(N_SIM),
          sd_null = sd(u), sd_null_mcse = sd_mcse(u), sd_shift = sd(a), sd_shift_mcse = sd_mcse(a),
          auc = dlg[[st]]$auc, auc_mcse = dlg[[st]]$mcse,
          true_value = if (st == "w1") dl else true_ks(b$cdf, dl),
          null_mean_first_order = if (st == "w1") sqrt(4 / (pi * n)) * ints$int_sqrtF1F[ib] else NA_real_,
          null_seed = cell_seed(ib, j, 0L), shift_seed = cell_seed(ib, j, k), shared_null = TRUE)
      }
      d10 <- dlg$w1$v10 - dlg$ks$v10; d01 <- dlg$w1$v01 - dlg$ks$v01
      blank <- rows[[length(rows)]]; blank[, setdiff(names(blank), c("base", "n", "delta", "n_sim", "null_seed", "shift_seed", "shared_null"))] <- NA
      blank$statistic <- "w1_minus_ks"
      blank$auc <- dlg$w1$auc - dlg$ks$auc
      blank$auc_mcse <- sqrt(var(d10) / N_SIM + var(d01) / N_SIM)
      rows[[length(rows) + 1L]] <- blank
      cat(sprintf("[cell] %s n=%d delta=%g (%.0fs)\n", bn, n, dl, as.numeric(Sys.time() - t0, units = "secs")))
    }
  }
}
res <- do.call(rbind, rows); rownames(res) <- NULL
write.csv(res, OUT_CSV, row.names = FALSE)

rel <- function(v) sd_mcse(v) / sd(v)
ratio <- do.call(rbind, lapply(N_GRID, function(n) {
  g <- per_rep[[sprintf("gauss_n%d_null", n)]]; s <- per_rep[[sprintf("mix_n%d_null", n)]]
  rw <- sd(s[, "w1"]) / sd(g[, "w1"]); rk <- sd(s[, "ks"]) / sd(g[, "ks"])
  data.frame(n = n, n_sim = N_SIM,
             sd_ratio_w1 = rw, sd_ratio_w1_mcse = rw * sqrt(rel(s[, "w1"])^2 + rel(g[, "w1"])^2),
             sd_ratio_ks = rk, sd_ratio_ks_mcse = rk * sqrt(rel(s[, "ks"])^2 + rel(g[, "ks"])^2),
             mean_ratio_w1 = mean(s[, "w1"]) / mean(g[, "w1"]),
             integral_ratio = ints$ratio_to_gauss[2])
}))
write.csv(ratio, OUT_RATIO, row.names = FALSE)

saveRDS(list(config = list(seed = SEED, n_sim = N_SIM, n_grid = N_GRID, deltas = DELTAS, protocol = PROTOCOL),
             per_rep = per_rep), OUT_RDS)
writeLines(c(sprintf("study: set4_control_mechanism"), sprintf("protocol: %s", PROTOCOL), sprintf("seed: %d", SEED),
             sprintf("n_sim: %d", N_SIM), sprintf("run time: %.1f min", as.numeric(Sys.time() - t0, units = "mins")),
             sprintf("finished: %s", format(Sys.time(), "%Y-%m-%d %H:%M:%S"))), OUT_LOG)
writeLines(capture.output(sessionInfo()), OUT_SI)
cat(sprintf("[done] %.1f min\n", as.numeric(Sys.time() - t0, units = "mins")))
