#!/usr/bin/env Rscript
# =============================================================================
# w1_raw_simulation_ext.R — Study 2 extension (PROTOCOL_study2_extension.md, pre-registered 2026-10-12)
# Author: Mike Ross (Methodologist), 2026-10-12
#
# External review M8 (review_response/EXTERNAL_REVIEW_20261012.md): Study 2 covered n <= 200, equal n, normal reference.
# This script moves one direction at a time: unequal n (E1), heavy tails t3 (E2), integer grid (E3), large n (E4).
# Same estimator and bootstrap as Study 2: W1_raw_bootstrap_cpp in R/W1_raw_rcpp.cpp (unchanged), B = 2000, conf = 0.95.
#
# Seeds: seed base 20261012. Cell k: RNGkind("L'Ecuyer-CMRG"); set.seed(20261012 + 1000 k); replicate i draws from the
#   i-th substream (parallel::nextRNGSubStream), assigned to .Random.seed inside the worker -> bit-reproducible regardless
#   of the number of workers and of dynamic load balancing (deviation from Study 2, which was not bit-reproducible).
# Outputs (ONLY these four files; all project-relative under results/):
#   results/w1_raw_ext_summary.csv     — performance measures + MCSE per cell (rewritten after every cell)
#   results/w1_raw_ext_simulation.rds  — per-replicate estimate / ci_lower / ci_upper per cell + config (rewritten after every
#                                        cell; resume support: completed cells are skipped on re-run)
#   results/w1_raw_ext_sessionInfo.txt — sessionInfo()
#   results/STUDY2_EXT_PROVENANCE.md   — provenance, written at the end from the run itself
# Usage: Rscript projects/similarity-metric/R/w1_raw_simulation_ext.R [--cores=6] [--test]
#   --test: 50 reps, B = 200, writes to tempdir() only (never to results/)
# =============================================================================
suppressPackageStartupMessages({ library(parallel); library(Rcpp) })

proj <- if (file.exists("R/W1_raw_rcpp.cpp")) "." else "projects/similarity-metric"
stopifnot(file.exists(file.path(proj, "R", "W1_raw_rcpp.cpp")))
CPP_FILE <- normalizePath(file.path(proj, "R", "W1_raw_rcpp.cpp"))

args  <- commandArgs(trailingOnly = TRUE)
TEST  <- "--test" %in% args
CORES <- { a <- grep("^--cores=", args, value = TRUE); if (length(a)) as.integer(sub("^--cores=", "", a)) else 6L }
RESULTS_DIR <- if (TEST) tempdir() else file.path(proj, "results")
OUT_CSV  <- file.path(RESULTS_DIR, "w1_raw_ext_summary.csv")
OUT_RDS  <- file.path(RESULTS_DIR, "w1_raw_ext_simulation.rds")
OUT_SI   <- file.path(RESULTS_DIR, "w1_raw_ext_sessionInfo.txt")
OUT_PROV <- file.path(RESULTS_DIR, "STUDY2_EXT_PROVENANCE.md")

SEED_BASE <- 20261012
B_BOOT    <- if (TEST) 200L else 2000L
CONF      <- 0.95
T3_SCALE  <- 10 / sqrt(3)            # t3 variance 3 -> SD of (10/sqrt(3)) t3 is 10

# Rounded to the nearest 10 (E6, added 2026-10-12 by amendment, referee M5): lattice 10j, CDF at 10j is Phi((10j + 5 - mu)/10);
# W1 = sum_j 10 |F_50(10j) - F_52(10j)|. The two rounded laws are stochastically ordered, so this also equals the mean difference.
jj <- -100:100
W1_ROUND10_TRUTH <- sum(10 * abs(pnorm((10 * jj + 5 - 50) / 10) - pnorm((10 * jj + 5 - 52) / 10)))

# ---- Cells (protocol section 3 D; order = execution order k) ---------------------------------------------------------
# reps: 10000 where the projected wall time at 10000 reps is <= 4 min, else 5000 (fixed in the protocol before any run)
cells <- list(
  list(cell = "E2a_t3_null",          group = "E2 heavy tails", n1 = 100,  n2 = 100,  dgm = "t3",    mu2 = 50, sd2 = 10, theta = 0,                 reps = 10000),
  list(cell = "E2b_t3_shift",         group = "E2 heavy tails", n1 = 100,  n2 = 100,  dgm = "t3",    mu2 = 55, sd2 = 10, theta = 5,                 reps = 10000),
  list(cell = "E3a_grid_100",         group = "E3 integer grid", n1 = 100, n2 = 100,  dgm = "round", mu2 = 55, sd2 = 10, theta = 5,                 reps = 10000),
  list(cell = "E3b_grid_200",         group = "E3 integer grid", n1 = 200, n2 = 200,  dgm = "round", mu2 = 55, sd2 = 10, theta = 5,                 reps = 10000),
  list(cell = "E1a_unequal_100_300",  group = "E1 unequal n",   n1 = 100,  n2 = 300,  dgm = "normal", mu2 = 55, sd2 = 10, theta = 5,                reps = 10000),
  list(cell = "E1b_unequal_200_1000", group = "E1 unequal n",   n1 = 200,  n2 = 1000, dgm = "normal", mu2 = 55, sd2 = 10, theta = 5,                reps = 5000),
  list(cell = "E4a_S3_1000",          group = "E4 large n",     n1 = 1000, n2 = 1000, dgm = "normal", mu2 = 55, sd2 = 10, theta = 5,                reps = 5000),
  list(cell = "E4b_S5_1000",          group = "E4 large n",     n1 = 1000, n2 = 1000, dgm = "normal", mu2 = 50, sd2 = 15, theta = sqrt(2 / pi) * 5, reps = 5000),
  # Amendment 2026-10-12 (Harvey, cold referee M5: GUSTO distances 0.03-0.30 SD, unequal n, SBP heaped on multiples of 10);
  # registered before these cells ran; 2000 reps (coverage MCSE about 0.0049).
  list(cell = "E5_S2_1000",           group = "E5/E6 small distance", n1 = 1000, n2 = 1000, dgm = "normal", mu2 = 52, sd2 = 10, theta = 2,      reps = 2000),
  list(cell = "E6_S2_2900_1200_r10",  group = "E5/E6 small distance", n1 = 2900, n2 = 1200, dgm = "round10", mu2 = 52, sd2 = 10, theta = W1_ROUND10_TRUTH, reps = 2000),
  list(cell = "E3c_grid_1000",         group = "E3 integer grid", n1 = 1000, n2 = 1000, dgm = "round", mu2 = 55, sd2 = 10, theta = 5,                 reps = 2000)
)
if (TEST) for (k in seq_along(cells)) cells[[k]]$reps <- 50L

# ---- DGM: draw_sample() — region 1 is always the reference (mean 50, SD 10) ------------------------------------------
draw_sample <- function(cl) {
  switch(cl$dgm,
    normal = list(x = rnorm(cl$n1, 50, 10), y = rnorm(cl$n2, cl$mu2, cl$sd2)),
    t3     = list(x = 50 + T3_SCALE * rt(cl$n1, df = 3), y = cl$mu2 + T3_SCALE * rt(cl$n2, df = 3)),
    round  = list(x = round(rnorm(cl$n1, 50, 10)), y = round(rnorm(cl$n2, cl$mu2, cl$sd2))),
    round10 = list(x = 10 * round(rnorm(cl$n1, 50, 10) / 10), y = 10 * round(rnorm(cl$n2, cl$mu2, cl$sd2) / 10)),
    stop("unknown dgm ", cl$dgm))
}

# ---- Truth checks (protocol section 3 D) -----------------------------------------------------------------------------
# Rounded population: CDF at integer k is Phi((k + 1/2 - mu)/10); W1 on the unit lattice = sum_k |F_50(k) - F_55(k)|.
kk <- -200:300
w1_round_truth <- sum(abs(pnorm((kk + 0.5 - 50) / 10) - pnorm((kk + 0.5 - 55) / 10)))
stopifnot(abs(w1_round_truth - 5) < 1e-10)
stopifnot(abs(W1_ROUND10_TRUTH - 1.9999999919) < 1e-9, abs(W1_ROUND10_TRUTH - sum(10 * abs(pnorm((10 * (-1000:1000) + 5 - 50) / 10) - pnorm((10 * (-1000:1000) + 5 - 52) / 10)))) < 1e-12)
# Equal-mean normals, closed form sqrt(2/pi)|s1 - s2|, cross-checked by quadrature of |F1 - F2|.
w1_s5_quad <- integrate(function(t) abs(pnorm(t, 50, 10) - pnorm(t, 50, 15)), -Inf, 50, rel.tol = 1e-12)$value +
              integrate(function(t) abs(pnorm(t, 50, 10) - pnorm(t, 50, 15)), 50, Inf, rel.tol = 1e-12)$value
stopifnot(abs(w1_s5_quad - sqrt(2 / pi) * 5) < 1e-8)
# t3 location shift: quadrature of |F(t) - F(t - 5)| for the scaled t3 (closed form |delta| = 5).
ft3 <- function(t, mu) pt((t - mu) / T3_SCALE, df = 3)
w1_t3_quad <- integrate(function(t) abs(ft3(t, 50) - ft3(t, 55)), -Inf, Inf, rel.tol = 1e-10, subdivisions = 1000L)$value
stopifnot(abs(w1_t3_quad - 5) < 1e-6)
cat(sprintf("[truth] rounded-population W1 = %.12f; S5 quadrature = %.10f (closed form %.10f); t3 shift quadrature = %.8f\n",
            w1_round_truth, w1_s5_quad, sqrt(2 / pi) * 5, w1_t3_quad))

# ---- Gate: point estimate of the C++ (incl. the unequal-n branch, new to Study 2) vs an independent R CDF-area sum ----
Rcpp::sourceCpp(CPP_FILE)
w1_ref <- function(x, y) { t <- sort(unique(c(x, y))); d <- abs(ecdf(x)(t) - ecdf(y)(t)); sum(d[-length(t)] * diff(t)) }
RNGkind("L'Ecuyer-CMRG"); set.seed(SEED_BASE - 1)   # gate stream, distinct from every cell stream
gate <- t(vapply(1:40, function(i) {
  n1 <- c(37L, 100L, 200L, 100L)[(i - 1) %% 4 + 1]; n2 <- c(113L, 300L, 1000L, 100L)[(i - 1) %% 4 + 1]
  x <- rnorm(n1, 50, 10); y <- rnorm(n2, 55, 10)
  if (i > 20) { x <- round(x); y <- round(y) }      # heavy ties
  c(cpp = W1_raw_bootstrap_cpp(x, y, B = 1L, conf = CONF)$estimate, ref = w1_ref(x, y))
}, numeric(2)))
stopifnot(max(abs(gate[, "cpp"] - gate[, "ref"])) < 1e-10)
cat(sprintf("[gate] C++ point estimate vs R CDF-area sum: 40 draws (unequal n, rounded ties), max |diff| = %.2e\n",
            max(abs(gate[, "cpp"] - gate[, "ref"]))))

# ---- Performance measures with MCSE (formulas of R/study2_mcse.R; Morris et al. 2019 Table 6) --------------------------
summarize_ext <- function(mat, theta) {
  est <- mat[, "estimate"]; lo <- mat[, "ci_lower"]; hi <- mat[, "ci_upper"]
  ok <- !is.na(est) & !is.na(lo) & !is.na(hi); est <- est[ok]; lo <- lo[ok]; hi <- hi[ok]; n <- length(est)
  rmse <- sqrt(mean((est - theta)^2)); p <- mean(lo <= theta & theta <= hi); pu <- mean(theta <= hi)
  data.frame(true_W1 = theta, n_valid = n, mean_est = mean(est), bias = mean(est) - theta, mcse_bias = sd(est) / sqrt(n),
             rmse = rmse, mcse_rmse = sd((est - theta)^2) / (sqrt(n) * 2 * rmse), sd_est = sd(est),
             bias_over_sd = (mean(est) - theta) / sd(est),
             coverage = p, mcse_coverage = sqrt(p * (1 - p) / n),
             upper_coverage = pu, mcse_upper_coverage = sqrt(pu * (1 - pu) / n),
             mean_ci_width = mean(hi - lo), mcse_ci_width = sd(hi - lo) / sqrt(n), stringsAsFactors = FALSE)
}

# ---- Cluster ------------------------------------------------------------------------------------------------------------
cl <- NULL
if (CORES > 1L) {
  cat(sprintf("[cluster] PSOCK, %d workers (compiling the C++ on each)\n", CORES))
  cl <- makeCluster(CORES, type = "PSOCK")
  clusterCall(cl, function(cpp) { suppressPackageStartupMessages(library(Rcpp)); Rcpp::sourceCpp(cpp); RNGkind("L'Ecuyer-CMRG"); TRUE }, CPP_FILE)
  on.exit(try(stopCluster(cl), silent = TRUE), add = TRUE)
}

run_cell <- function(cell, k) {
  RNGkind("L'Ecuyer-CMRG"); set.seed(SEED_BASE + 1000L * k)
  seeds <- vector("list", cell$reps); s <- .Random.seed
  for (i in seq_len(cell$reps)) { s <- nextRNGSubStream(s); seeds[[i]] <- s }
  env <- new.env(parent = globalenv()); env$cell <- cell; env$seeds <- seeds; env$B <- B_BOOT; env$conf <- CONF
  env$draw_sample <- draw_sample; env$T3_SCALE <- T3_SCALE
  worker <- function(i) {
    assign(".Random.seed", seeds[[i]], envir = globalenv())
    d <- draw_sample(cell)
    fn <- get("W1_raw_bootstrap_cpp", envir = globalenv(), mode = "function")   # worker-local compiled function
    r <- fn(d$x, d$y, B = as.integer(B), conf = conf)
    c(estimate = r$estimate, ci_lower = r$ci_lower, ci_upper = r$ci_upper)
  }
  environment(worker) <- env
  environment(env$draw_sample) <- env
  res <- if (is.null(cl)) lapply(seq_len(cell$reps), worker) else
    parLapplyLB(cl, seq_len(cell$reps), worker, chunk.size = max(1L, cell$reps %/% (length(cl) * 8L)))
  m <- do.call(rbind, res); colnames(m) <- c("estimate", "ci_lower", "ci_upper"); m
}

# ---- Main loop (resume from OUT_RDS) ------------------------------------------------------------------------------------
config <- list(protocol = "PROTOCOL_study2_extension.md", seed_base = SEED_BASE, B = B_BOOT, conf = CONF, workers = CORES,
               cells = do.call(rbind, lapply(cells, function(z) as.data.frame(z[c("cell", "n1", "n2", "dgm", "mu2", "sd2", "theta", "reps")]))),
               gate_max_abs_diff = max(abs(gate[, "cpp"] - gate[, "ref"])), w1_round_truth = w1_round_truth)
out <- if (!TEST && file.exists(OUT_RDS)) readRDS(OUT_RDS) else list(config = config, started = Sys.time(), cells = list())
# Resume: the cells already in the rds must be the leading rows of the current cell table (cells may only be appended,
# as by the 2026-10-12 amendment); every invocation is logged.
n_old <- nrow(out$config$cells)
stopifnot(n_old <= nrow(config$cells), isTRUE(all.equal(out$config$cells, config$cells[seq_len(n_old), , drop = FALSE], check.attributes = FALSE)), out$config$B == B_BOOT)
out$config <- config
out$invocations <- c(out$invocations, list(Sys.time()))
for (k in seq_along(cells)) {
  cc <- cells[[k]]
  if (!is.null(out$cells[[cc$cell]])) { cat(sprintf("[cell %d/%d] %s: done earlier, skipped\n", k, length(cells), cc$cell)); next }
  cat(sprintf("[cell %d/%d] %s n1=%d n2=%d reps=%d B=%d ... ", k, length(cells), cc$cell, as.integer(cc$n1), as.integer(cc$n2), as.integer(cc$reps), B_BOOT)); flush.console()
  t0 <- Sys.time(); mat <- run_cell(cc, k); el <- as.numeric(difftime(Sys.time(), t0, units = "secs"))
  sm <- cbind(data.frame(cell = cc$cell, group = cc$group, k = k, n1 = cc$n1, n2 = cc$n2, n_reps = cc$reps, B = B_BOOT,
                         seed = SEED_BASE + 1000L * k, stringsAsFactors = FALSE),
              summarize_ext(mat, cc$theta), data.frame(elapsed_s = round(el, 1), workers = CORES))
  out$cells[[cc$cell]] <- list(summary = sm, mat = mat, elapsed_s = el, finished = Sys.time())
  cat(sprintf("done (%.1f s)\n", el))
  saveRDS(out, OUT_RDS)
  write.csv(do.call(rbind, lapply(out$cells, `[[`, "summary")), OUT_CSV, row.names = FALSE)
}
out$finished <- Sys.time(); saveRDS(out, OUT_RDS)
summ <- do.call(rbind, lapply(out$cells, `[[`, "summary")); rownames(summ) <- NULL
write.csv(summ, OUT_CSV, row.names = FALSE)
writeLines(capture.output(sessionInfo()), OUT_SI)

# ---- Provenance (generated from the run) --------------------------------------------------------------------------------
tm <- function(x) format(x, "%Y-%m-%d %H:%M:%S %Z")
prov <- c(
  "# STUDY2_EXT — provenance of `results/w1_raw_ext_summary.csv`", "",
  sprintf("Generated: %s by `projects/similarity-metric/R/w1_raw_simulation_ext.R` (written at the end of the run; do not edit by hand)", tm(Sys.time())), "",
  "## Canonical run", "", "| Item | Value |", "|------|-------|",
  "| Per-replicate source | `results/w1_raw_ext_simulation.rds` (`$cells[[cell]]$mat`: estimate, ci_lower, ci_upper) |",
  "| Protocol | `PROTOCOL_study2_extension.md` (pre-registered 2026-10-12, before any replicate) |",
  sprintf("| Replications / bootstrap B | per cell (10,000 or 5,000; column `n_reps`) / %d, conf %.2f, percentile |", B_BOOT, CONF),
  sprintf("| Seed / RNG stream | L'Ecuyer-CMRG; cell k: `set.seed(%d + 1000 k)`; replicate i: i-th `nextRNGSubStream`, set as `.Random.seed` in the worker (bit-reproducible for any worker count) |", SEED_BASE),
  sprintf("| Workers | %d (PSOCK, `parLapplyLB`) |", CORES),
  "| Estimator | `W1_raw_bootstrap_cpp` in `R/W1_raw_rcpp.cpp` (unchanged from Study 2) |",
  sprintf("| Gate | C++ point estimate vs independent R CDF-area sum, 40 draws (unequal n; 20 with integer-rounded ties): max abs diff %.2e |", config$gate_max_abs_diff),
  "| R version / packages | `results/w1_raw_ext_sessionInfo.txt` |",
  sprintf("| Run time | started %s, finished %s; invocations (resume) at %s |", tm(out$started), tm(out$finished),
          paste(vapply(out$invocations, tm, ""), collapse = "; ")), "",
  "## Per-cell wall time", "", "| k | cell | n1 | n2 | n_reps | elapsed (s) | elapsed (min) |", "|---|---|---|---|---|---|---|",
  sprintf("| %d | %s | %d | %d | %d | %.1f | %.1f |", summ$k, summ$cell, summ$n1, summ$n2, summ$n_reps, summ$elapsed_s, summ$elapsed_s / 60),
  sprintf("| | total | | | | %.1f | %.1f |", sum(summ$elapsed_s), sum(summ$elapsed_s) / 60), "",
  "## Reference (true) values", "", "| cell | definition | true value | how obtained |", "|---|---|---|---|",
  "| E1a, E1b, E4a | N(50,10^2) vs N(55,10^2) | 5 | exact (location shift) |",
  "| E2a | scaled t3 vs the same | 0 | exact |",
  sprintf("| E2b | 50 + (10/sqrt 3) t3 vs 55 + (10/sqrt 3) t3 | 5 | exact (location shift); quadrature check %.8f |", w1_t3_quad),
  sprintf("| E3a, E3b | round(N(50,10^2)) vs round(N(55,10^2)) | 5 | exact (integer shift of the rounded law); discretized-CDF sum over k = -200..300: %.12f |", w1_round_truth),
  sprintf("| E4b | N(50,10^2) vs N(50,15^2) | %.7f | closed form sqrt(2/pi)*5; quadrature (rel.tol 1e-12) %.10f |", sqrt(2 / pi) * 5, w1_s5_quad),
  "| E5 | N(50,10^2) vs N(52,10^2) | 2 | exact (location shift) |",
  sprintf("| E6 | 10 round(X/10), X ~ N(50,10^2) vs N(52,10^2) | %.10f | discretized-CDF sum on the 10-unit lattice, j = -100..100 (equal to j = -1000..1000 within 1e-12) |", W1_ROUND10_TRUTH), "",
  "## Column semantics", "",
  "All performance columns are proportions (not percent) or original units; `mcse_*` = Monte Carlo SE (R/study2_mcse.R formulas).",
  "`coverage` = P(L <= theta <= U) of the 95% percentile interval; `upper_coverage` = P(theta <= U), U = 0.975 bootstrap quantile (one-sided 97.5%);",
  "`bias_over_sd` = bias / sd_est. For E2a (theta = 0) both coverage columns are structural (about 0 and exactly 1) and are not reported in tab_study2_ext.", "",
  "## Reproducibility statement", "",
  "- Re-run: `Rscript projects/similarity-metric/R/w1_raw_simulation_ext.R --cores=6` (resumes from the rds; delete the rds for a fresh run).",
  "- Bit-reproducible per replicate (per-replicate substreams); the table generator `R/make_paper_tables.R` is deterministic.")
writeLines(prov, OUT_PROV)
print(summ[, c("cell", "n1", "n2", "n_reps", "true_W1", "bias", "mcse_bias", "rmse", "coverage", "mcse_coverage", "upper_coverage", "mean_ci_width", "elapsed_s")])
cat("[done] wrote", OUT_CSV, OUT_RDS, OUT_SI, OUT_PROV, "\n")
