## verify_study1_tables.R ------------------------------------------------
## Audits the Study 1 tables (tab:bias, tab:coverage, tab:precision) in
## per_em_W1_wiley.tex against the recorded simulation output, and emits
## corrected LaTeX rows generated FROM that output rather than transcribed
## by hand -- hand transcription is what introduced the discrepancies this
## script detects.
##
## Authoritative source: results/w1_raw_summary.csv
##   (cross-checked against results/w1_raw_simulation.rds$summary and
##    recomputed from $rep_data; all three agree)

audit_study1 <- function(root) {
  ws <- read.csv(file.path(root, "results/w1_raw_summary.csv"))
  rownames(ws) <- paste0(ws$scenario, "-", ws$n)
  ws
}

## Independent recomputation from the per-replication estimates, to confirm
## the summary CSV is itself faithful to the replication data.
recompute_from_reps <- function(root, ws) {
  rds <- readRDS(file.path(root, "results/w1_raw_simulation.rds"))
  out <- do.call(rbind, lapply(names(rds$rep_data), function(k) {
    s <- strsplit(k, "-")[[1]][1]
    M <- rds$rep_data[[k]]
    W <- rds$truth[[s]]$truth
    data.frame(cell = k,
               bias = mean(M[, "estimate"]) - W,
               rmse = sqrt(mean((M[, "estimate"] - W)^2)),
               ciw  = mean(M[, "ci_upper"] - M[, "ci_lower"]),
               cov  = mean(M[, "ci_lower"] <= W & W <= M[, "ci_upper"]))
  }))
  rownames(out) <- out$cell
  k <- rownames(ws)
  data.frame(cell = k,
             d_bias = ws[k, "bias"]          - out[k, "bias"],
             d_rmse = ws[k, "rmse"]          - out[k, "rmse"],
             d_ciw  = ws[k, "mean_ci_width"] - out[k, "ciw"],
             d_cov  = ws[k, "coverage_pct"]  - out[k, "cov"])
}

## Exact population W_1 for every scenario. S6 and S7 are recorded in the
## simulation as Monte Carlo approximations (truth_exact is NA for both);
## the quantile-form integral W_1 = \int_0^1 |F_1^{-1}(u) - F_2^{-1}(u)| du
## evaluates them deterministically by quadrature.
exact_truth <- function() {
  sigma_ln <- 0.5; mu_ln <- log(50) - sigma_ln^2 / 2
  qint <- function(q2) integrate(function(u) abs(qnorm(u, 50, 10) - q2(u)),
                                 0, 1, subdivisions = 4000L, rel.tol = 1e-10)$value
  c(S1 = 0, S2 = 2, S3 = 5, S4 = 10,
    S5 = sqrt(2 / pi) * 5,
    S6 = qint(function(u) qlnorm(u, mu_ln, sigma_ln)),
    S7 = qint(function(u) qnorm(u, 55, 15)))
}

fmt <- function(x, dig) formatC(round(x, dig), format = "f", digits = dig)

latex_bias_rows <- function(ws) {
  lab <- c(S1 = "S1 (Null)", S2 = "S2 (0.2$\\sigma$)", S3 = "S3 (0.5$\\sigma$)",
           S4 = "S4 (1.0$\\sigma$)", S5 = "S5 (Scale)", S6 = "S6 (Skew)",
           S7 = "S7 (Loc+Scale)")
  tw <- c(S1 = "0.00", S2 = "2.00", S3 = "5.00", S4 = "10.00",
          S5 = "3.99", S6 = "12.15", S7 = "5.85")
  vapply(names(lab), function(s) {
    v <- vapply(c(50, 100, 200), function(n) {
      b <- ws[paste0(s, "-", n), "bias"]
      x <- fmt(b, 3)
      if (b < 0) paste0("$-", sub("^-", "", x), "$") else x
    }, character(1))
    sprintf("%s & %s & %s & %s & %s \\\\", lab[[s]], tw[[s]], v[1], v[2], v[3])
  }, character(1), USE.NAMES = FALSE)
}

latex_coverage_rows <- function(ws) {
  lab <- c(S2 = "S2 (0.2$\\sigma$)", S3 = "S3 (0.5$\\sigma$)", S4 = "S4 (1.0$\\sigma$)",
           S5 = "S5 (Scale)", S6 = "S6 (Skew)", S7 = "S7 (Loc+Scale)")
  vapply(names(lab), function(s) {
    v <- fmt(vapply(c(50, 100, 200),
                    function(n) ws[paste0(s, "-", n), "coverage_pct"], numeric(1)), 3)
    sprintf("%s & %s & %s & %s \\\\", lab[[s]], v[1], v[2], v[3])
  }, character(1), USE.NAMES = FALSE)
}

latex_precision_rows <- function(ws) {
  lab <- c(S1 = "S1 (Null)", S2 = "S2 (0.2$\\sigma$)", S3 = "S3 (0.5$\\sigma$)",
           S4 = "S4 (1.0$\\sigma$)", S5 = "S5 (Scale)", S6 = "S6 (Skew)",
           S7 = "S7 (Loc+Scale)")
  vapply(names(lab), function(s) {
    r <- fmt(vapply(c(50, 100, 200), function(n) ws[paste0(s, "-", n), "rmse"],
                    numeric(1)), 2)
    w <- fmt(vapply(c(50, 100, 200), function(n) ws[paste0(s, "-", n), "mean_ci_width"],
                    numeric(1)), 2)
    sprintf("%s & %s & %s & %s & %s & %s & %s \\\\",
            lab[[s]], r[1], r[2], r[3], w[1], w[2], w[3])
  }, character(1), USE.NAMES = FALSE)
}

compare <- function(ws, printed, col, dig, label) {
  k <- names(printed)
  rec <- round(ws[k, col], dig)
  bad <- which(abs(rec - printed) > 1e-9)
  cat(sprintf("%-22s %2d / %2d cells disagree\n", label, length(bad), length(printed)))
  if (length(bad))
    data.frame(cell = k[bad], manuscript = printed[bad], recorded = rec[bad],
               row.names = NULL)
  else NULL
}
