## Ambiguities
## ===========================================================================
## Clean-room replication of Study 2 (estimation properties of W1-hat) by Louis.
## Read: projects/similarity-metric/review_response/METHODS_ONLY_20261011.tex ONLY
## (Estimation section, equation (estimator); Study 2 design and Table
## tab:scenarios). Nothing else in R/, results/, the manuscript, SUITS.md or
## CLAIMS.md was opened. Each place the text under-specifies the
## implementation, and what this script does about it (worst first):
##
## A1 [Major] What the CI bootstrap resamples. The text says "nonparametric
##    percentile bootstrap with B = 2,000 replicates" and, for the two-sample
##    setting, "the ordinary nonparametric bootstrap", but never says what is
##    resampled or at what size. Chosen (most literal for two independent
##    samples): each region resampled independently, with replacement, at its
##    own size n_r; W1-hat recomputed on each pair of resamples. Resample sizes
##    are stated only for the null floor ("two independent resamples, of the
##    two regions' actual sizes, from one region's empirical distribution"),
##    which is a different (H0) construction. Rejected readings: resampling the
##    pooled sample (that is the null floor); resampling index pairs
##    i -> (x1_i, x2_i) (possible only because n1 = n2 here; it couples the two
##    regions' resampling counts).
## A2 [Major] Coverage at the boundary, S1 (W1 = 0). "Proportion of 95%
##    bootstrap CIs containing the true value" is implemented as the closed
##    interval L <= W1 <= U. With continuous data the two regions' resamples
##    have disjoint supports, so every bootstrap W1* > 0, L > 0, and S1
##    coverage is structurally 0 under ANY two-sided percentile rule. The text
##    does not say whether S1 coverage is reported, excluded, or computed on a
##    different interval (e.g. one-sided [0, U]); it only says the naive
##    bootstrap is not consistent at F1 = F2. Implemented literally.
## A3 [Minor] Percentile rule. No quantile definition is given. Chosen: the
##    cited Efron & Tibshirani (1993) interval [G^-1(0.025), G^-1(0.975)],
##    G = ECDF of the B bootstrap replicates, i.e. the 50th and 1,950th order
##    statistics for B = 2,000 (= R quantile type 1). R's default type 7 is
##    computed as a sensitivity printed to the log only; not in the CSV.
## A4 [Minor] Precision of the true W1. The table gives 2-dp values (S5 3.99,
##    S6 12.16, S7 5.83); the note gives the S5 closed form
##    sqrt(2/pi)*|sigma1 - sigma2| = 3.98942 and quadrature for S6/S7. Which
##    precision enters bias / RMSE / coverage is not stated. Used the table
##    values as given (caller's instruction). They are recomputed from the
##    note as a printed DIAGNOSTIC of the table only, never used in results.
## A5 [Minor] S6 log-normal location. Table: LogN(3.787, 0.5^2); note:
##    mu_log = log 50 - sigma_log^2/2 "= 3.787". Chosen: the defining formula
##    (3.787023; mean exactly 50, as the note states). Shift vs 3.787: ~0.001.
## A6 [Minor] Independence structure. Not stated whether the sample sizes use
##    nested samples or the scenarios share random numbers. Chosen: every
##    scenario x n cell is an independent stream with its own seed; within a
##    replication the draw order is x1, x2, region-1 bootstrap indices,
##    region-2 bootstrap indices.
## A7 [Minor] Seed / RNG. Text: "R version 4.5.1", no seed, no RNG kind, so
##    only distributional (not bitwise) agreement is testable. Declared here:
##    Mersenne-Twister / Inversion / Rejection; cell seed = BASE_SEED + 100*s + j.
##    This run used R 4.3.3.
## A8 [Minor] Replications. Text: 10,000 per cell, "Monte Carlo standard
##    errors below 0.005 for all reported proportions". This run: 1,000
##    (pre-agreed reduced replication), so the MCSE of a coverage near 0.95 is
##    about 0.007. The text gives no MCSE for bias, RMSE or CI width; they are
##    printed to the run log, not written to the CSV.
## A9 [Minor] Measures not defined in the text (the caller's): sd_est = sd()
##    (n - 1 divisor); n_valid = replications with a finite W1-hat and finite
##    CI limits; every measure is computed over those. coverage_pct is a
##    PROPORTION (caller's instruction), despite the column name.
## A10 [Note: implementation choice, not an ambiguity] Vectorised bootstrap.
##    The equation is evaluated on the sorted ORIGINAL pooled sample, a
##    refinement of each bootstrap pooled sample's distinct values. An undrawn
##    original point splits an interval on which |F1* - F2*| is constant, so
##    |d|a + |d|b = |d|(a + b) and the finite sum is unchanged (and the
##    difference is 0 outside the resample's range). The quantile closed form
##    is NOT used. Every point estimate uses the literal ecdf() implementation;
##    the vectorised path is checked against it on all B resamples of
##    replication 1 and on resamples 1 and B of every replication of every
##    cell (stop() if any |difference| > 1e-9).
## ===========================================================================

## study2_estimation_louis.R -- base R only.
## Usage: Rscript R/replication/study2_estimation_louis.R [n_sim] [out_dir]
##   n_sim   replications per cell (default 1000 = pre-agreed reduced run)
##   out_dir output directory (default <project>/results/replication)
## Outputs: study2_estimation_louis.csv, study2_estimation_louis_sessionInfo.txt

## ---- Settings (seed declared here) -----------------------------------------
BASE_SEED     <- 20261011L           # cell seed = BASE_SEED + 100 * s + j (A7)
N_SIM_DEFAULT <- 1000L               # text: 10,000; pre-agreed reduced run (A8)
B             <- 2000L               # text: B = 2,000 bootstrap replicates
CONF          <- 0.95                # text: 95% percentile bootstrap CI
N_GRID        <- c(50L, 100L, 200L)  # text: n = 50, 100, 200 per region
TOL_CHECK     <- 1e-9                # literal vs vectorised agreement (A10)

args  <- commandArgs(trailingOnly = TRUE)
n_sim <- if (length(args) >= 1L) as.integer(args[[1L]]) else N_SIM_DEFAULT
stopifnot(!is.na(n_sim), n_sim >= 2L)
file_arg  <- grep("^--file=", commandArgs(trailingOnly = FALSE), value = TRUE)
proj_root <- if (length(file_arg) == 1L) {
  normalizePath(file.path(dirname(sub("^--file=", "", file_arg)), "..", ".."))
} else {
  getwd()                            # interactive use: start R in the project root
}
out_dir <- if (length(args) >= 2L) args[[2L]] else file.path(proj_root, "results", "replication")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
out_csv  <- file.path(out_dir, "study2_estimation_louis.csv")
out_sess <- file.path(out_dir, "study2_estimation_louis_sessionInfo.txt")

## ---- Data-generating mechanisms (Table tab:scenarios and its note) ---------
MU_LOG_S6 <- log(50) - 0.5^2 / 2     # note: mu_log = log 50 - sigma_log^2 / 2 (A5)
r_region1 <- function(n) rnorm(n, mean = 50, sd = 10)  # Distribution 1, every scenario
scenarios <- list(                                     # Distribution 2; true W1 as given (A4)
  S1 = list(r2 = function(n) rnorm(n, 50, 10), true_W1 = 0.00),
  S2 = list(r2 = function(n) rnorm(n, 52, 10), true_W1 = 2.00),
  S3 = list(r2 = function(n) rnorm(n, 55, 10), true_W1 = 5.00),
  S4 = list(r2 = function(n) rnorm(n, 60, 10), true_W1 = 10.00),
  S5 = list(r2 = function(n) rnorm(n, 50, 15), true_W1 = 3.99),
  S6 = list(r2 = function(n) rlnorm(n, meanlog = MU_LOG_S6, sdlog = 0.5), true_W1 = 12.16),
  S7 = list(r2 = function(n) rnorm(n, 55, 15), true_W1 = 5.83)
)

## ---- Estimator: equation (estimator), literal ------------------------------
## W1hat = sum_{k=1}^{m-1} |F1hat(x_(k)) - F2hat(x_(k))| * (x_(k+1) - x_(k)),
## F_r-hat the right-continuous ECDF of region r; x_(1) < ... < x_(m) the m
## distinct values of the pooled sample.
w1_hat <- function(x1, x2) {
  xk <- sort(unique(c(x1, x2)))           # distinct pooled values
  m  <- length(xk)
  if (m < 2L) return(0)
  F1 <- ecdf(x1)(xk)                      # #{x1 <= x_(k)} / n1
  F2 <- ecdf(x2)(xk)                      # #{x2 <= x_(k)} / n2
  sum(abs(F1[-m] - F2[-m]) * diff(xk))    # k = 1, ..., m - 1
}

## ---- Bootstrap replicates of the same equation, vectorised (A1, A10) -------
## idx1 / idx2: nb consecutive blocks of n1 / n2 indices drawn with replacement
## within region 1 / region 2. On the sorted pooled original sample,
## n1*n2*(F1* - F2*) at position k is the running sum of count * jump, with
## jump = +n2 (region-1 point) or -n1 (region-2 point): integers, exact.
block_offsets <- function(size, N, nb) rep.int((seq_len(nb) - 1L) * N, rep.int(size, nb))
w1_hat_boot <- function(x1, x2, idx1, idx2, nb,
                        off1 = block_offsets(length(x1), length(x1) + length(x2), nb),
                        off2 = block_offsets(length(x2), length(x1) + length(x2), nb)) {
  n1 <- length(x1); n2 <- length(x2); N <- n1 + n2
  z    <- c(x1, x2)
  o    <- order(z)                        # sorted pooled sample: z[o]
  rk   <- integer(N); rk[o] <- seq_len(N) # sorted position of each observation
  gap  <- c(diff(z[o]), 0)                # x_(k+1) - x_(k); 0 after the maximum
  jump <- ifelse(o <= n1, n2, -n1)
  cnt  <- tabulate(c(rk[idx1] + off1, rk[n1 + idx2] + off2), nbins = N * nb)
  D    <- cumsum(cnt * jump)              # each block sums to n1*n2 - n2*n1 = 0,
                                          # so the running sum restarts at 0
  v <- abs(D) * gap
  dim(v) <- c(N, nb)
  colSums(v) / (n1 * n2)
}

## ---- Percentile interval (Efron & Tibshirani 1993; A3) ---------------------
K_LO <- as.integer(ceiling(round(B * (1 - CONF) / 2, 6)))        # 50:   G^-1(0.025)
K_HI <- as.integer(ceiling(round(B * (1 - (1 - CONF) / 2), 6)))  # 1950: G^-1(0.975)
pct_ci <- function(tb) {
  s <- sort.int(tb, partial = c(K_LO, K_HI))
  c(s[K_LO], s[K_HI])
}

## ---- One scenario x n cell -------------------------------------------------
run_cell <- function(s, j, n_sim) {
  sc   <- scenarios[[s]]; tr <- sc$true_W1
  n    <- N_GRID[j]
  seed <- BASE_SEED + 100L * s + j
  set.seed(seed, kind = "Mersenne-Twister", normal.kind = "Inversion",
           sample.kind = "Rejection")
  t0  <- proc.time()[["elapsed"]]
  off <- block_offsets(n, 2L * n, B)
  est <- lo <- hi <- lo7 <- hi7 <- rep(NA_real_, n_sim)
  dev_max <- 0; qform_max <- 0
  for (r in seq_len(n_sim)) {
    x1   <- r_region1(n)
    x2   <- sc$r2(n)
    idx1 <- sample.int(n, n * B, replace = TRUE)   # B resamples of region 1
    idx2 <- sample.int(n, n * B, replace = TRUE)   # B resamples of region 2
    est[r] <- w1_hat(x1, x2)                       # point estimate, literal
    tb <- w1_hat_boot(x1, x2, idx1, idx2, B, off, off)
    ci <- pct_ci(tb)
    lo[r] <- ci[1L]; hi[r] <- ci[2L]
    q7 <- quantile(tb, c((1 - CONF) / 2, 1 - (1 - CONF) / 2), type = 7, names = FALSE)
    lo7[r] <- q7[1L]; hi7[r] <- q7[2L]
    ## verification: vectorised path vs literal equation on the actual resamples
    chk <- if (r == 1L) seq_len(B) else c(1L, B)
    lit <- vapply(chk, function(b) {
      blk <- (b - 1L) * n + seq_len(n)
      w1_hat(x1[idx1[blk]], x2[idx2[blk]])
    }, numeric(1))
    dev <- max(abs(lit - tb[chk]),
               abs(est[r] - w1_hat_boot(x1, x2, seq_len(n), seq_len(n), 1L)))
    if (!is.finite(dev) || dev > TOL_CHECK)
      stop(sprintf("vectorised bootstrap != equation: %s n=%d r=%d dev=%g",
                   names(scenarios)[s], n, r, dev))
    dev_max <- max(dev_max, dev)
    if (r == 1L)
      stopifnot(identical(ci, quantile(tb, c(0.025, 0.975), type = 1, names = FALSE)))
    ## diagnostic of the text's "three forms are equivalent" (quantile form, n1 = n2)
    qform_max <- max(qform_max, abs(est[r] - mean(abs(sort(x1) - sort(x2)))))
  }
  ok <- is.finite(est) & is.finite(lo) & is.finite(hi)
  nv <- sum(ok); e <- est[ok]; w <- hi[ok] - lo[ok]
  cover <- mean(lo[ok] <= tr & tr <= hi[ok])       # closed interval (A2)
  rmse  <- sqrt(mean((e - tr)^2))
  list(
    row = data.frame(scenario = names(scenarios)[s], n = n, true_W1 = tr,
                     mean_est = mean(e), bias = mean(e) - tr, rmse = rmse,
                     sd_est = sd(e), mean_ci_width = mean(w),
                     coverage_pct = cover, n_valid = nv),
    diag = data.frame(scenario = names(scenarios)[s], n = n, seed = seed,
                      mcse_bias = sd(e) / sqrt(nv),
                      mcse_rmse = sd((e - tr)^2) / (2 * rmse * sqrt(nv)),
                      mcse_width = sd(w) / sqrt(nv),
                      mcse_cov = sqrt(cover * (1 - cover) / nv),
                      cov_type7 = mean(lo7[ok] <= tr & tr <= hi7[ok]),
                      width_type7 = mean(hi7[ok] - lo7[ok]),
                      max_dev_literal = dev_max, max_dev_qform = qform_max,
                      secs = proc.time()[["elapsed"]] - t0)
  )
}

## ---- Diagnostic only: the table's true W1 recomputed from its own note -----
w1_pop <- function(F1, F2, lo, hi) {
  f  <- function(t) F1(t) - F2(t)
  g  <- seq(lo, hi, length.out = 20001L); v <- f(g)
  i  <- which(v[-1L] * v[-length(v)] < 0)
  xr <- vapply(i, function(k) uniroot(f, g[c(k, k + 1L)], tol = 1e-13)$root, numeric(1))
  br <- c(-Inf, sort(c(lo, xr, hi)), Inf)
  sum(vapply(seq_len(length(br) - 1L), function(k)
    integrate(function(t) abs(f(t)), br[k], br[k + 1L], rel.tol = 1e-10,
              subdivisions = 2000L)$value, numeric(1)))
}
true_check <- data.frame(
  scenario  = names(scenarios),
  table     = vapply(scenarios, `[[`, numeric(1), "true_W1"),
  from_note = c(0, 2, 5, 10, sqrt(2 / pi) * abs(10 - 15),
                w1_pop(function(t) pnorm(t, 50, 10),
                       function(t) plnorm(t, MU_LOG_S6, 0.5), 0, 300),
                w1_pop(function(t) pnorm(t, 50, 10),
                       function(t) pnorm(t, 55, 15), -100, 200)))

## ---- Run all 7 x 3 cells ---------------------------------------------------
cat(sprintf("Study 2 clean-room replication | n_sim = %d | B = %d | BASE_SEED = %d | CI order stats %d, %d\n",
            n_sim, B, BASE_SEED, K_LO, K_HI))
t_all <- proc.time()[["elapsed"]]
rows <- list(); diags <- list()
for (s in seq_along(scenarios)) {
  for (j in seq_along(N_GRID)) {
    cell <- run_cell(s, j, n_sim)
    rows[[length(rows) + 1L]]   <- cell$row
    diags[[length(diags) + 1L]] <- cell$diag
    cat(sprintf("  %s n=%3d  %6.1f s  max|vectorised - literal| = %.1e\n",
                names(scenarios)[s], N_GRID[j], cell$diag$secs, cell$diag$max_dev_literal))
  }
}
elapsed <- proc.time()[["elapsed"]] - t_all
results <- do.call(rbind, rows)
write.csv(results, out_csv, row.names = FALSE, quote = FALSE)

cat("\nResults (written to the CSV):\n")
print(results, digits = 6, row.names = FALSE)
cat("\nDiagnostics (log only): MCSE, type-7 percentile sensitivity (A3), checks (A10)\n")
print(do.call(rbind, diags), digits = 4, row.names = FALSE)
cat("\nTable true W1 vs its own note (diagnostic only, not used in results; A4):\n")
print(true_check, digits = 7, row.names = FALSE)
cat(sprintf("\nTotal elapsed: %.1f s\nWrote: %s\n", elapsed, out_csv))

writeLines(c(
  "study2_estimation_louis.R -- clean-room replication of Study 2 (Louis)",
  paste("finished:", format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z")),
  sprintf("n_sim = %d per cell; B = %d; CI = order statistics %d and %d of B (quantile type 1)",
          n_sim, B, K_LO, K_HI),
  sprintf("BASE_SEED = %d; cell seed = BASE_SEED + 100*s + j (s = 1..7 for S1..S7; j = 1..3 for n = 50, 100, 200)",
          BASE_SEED),
  paste("RNGkind:", paste(RNGkind(), collapse = " / ")),
  sprintf("elapsed: %.1f s", elapsed),
  "",
  capture.output(sessionInfo())
), out_sess)
