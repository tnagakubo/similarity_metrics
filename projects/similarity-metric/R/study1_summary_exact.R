# =============================================================================
# Study 1 — re-summarise the canonical W1 raw simulation with EXACT truths
# Author: Mike Ross (Methodologist)
# Date: 2026-09-21
#
# Purpose
#   Recompute the Study 1 operating-characteristic summary from the canonical
#   per-replicate output (`$rep_data` of w1_raw_simulation.rds, May-17 run),
#   replacing the Monte-Carlo reference values for S6 and S7 with exact
#   numerical-quadrature values of
#
#       W_1(F_1, F_2) = \int_{-\infty}^{\infty} |F_1(t) - F_2(t)| dt
#
#   (the CDF-area form; see `compute_w1`, never `w1_dist`).
#
# Truth per scenario (see TRUTH table below)
#   S1-S4 : exact, |mu_1 - mu_2| for equal-variance normals
#   S5    : closed form sqrt(2/pi) * |sigma_1 - sigma_2| = sqrt(2/pi) * 5
#   S6,S7 : numerical quadrature of the CDF-area integral (this script verifies
#           the stored constants by re-integrating; assertion tolerance 1e-6)
#
# Reproducibility
#   NO set.seed(): this script performs no random number generation. It only
#   summarises an existing per-replicate matrix. Re-running it on the same rds
#   is bit-for-bit deterministic.
#   sessionInfo() is written next to the outputs.
#
# Inputs  (project-relative)
#   projects/similarity-metric/results/w1_raw_simulation.rds   [canonical]
#   projects/similarity-metric/results/w1_raw_summary.csv      [previous, MC truth]
#
# Outputs (project-relative)
#   projects/similarity-metric/results/w1_raw_summary_mctruth_20260517.csv
#       byte-for-byte copy of the previous MC-truth summary (backup, never
#       overwritten once it exists)
#   projects/similarity-metric/results/w1_raw_summary.csv      [NEW, exact truth]
#   projects/similarity-metric/results/study1_latex_rows.tex   [paper table rows]
#   projects/similarity-metric/results/STUDY1_PROVENANCE.md
#   projects/similarity-metric/results/study1_summary_exact_sessionInfo.txt
#
# Column semantics (mirrors summarize_cell() in w1_raw_simulation.R exactly)
#   mean_est      = mean(est)
#   bias          = mean(est) - truth
#   rmse          = sqrt(mean((est - truth)^2))          [n denominator]
#   sd_est        = sd(est)                              [n-1 denominator]
#   mean_ci_width = mean(ci_upper - ci_lower)
#   coverage_pct  = mean(ci_lower <= truth & truth <= ci_upper)   [proportion,
#                   NOT a percentage, despite the historical column name]
#   n_valid       = sum(!is.na(est))
# =============================================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(tidyr)
  library(tibble)
  library(readr)
  library(purrr)
})

# ---- Paths -----------------------------------------------------------------
find_project_root <- function() {
  # 1) script location (Rscript --file=... or source(); two levels up from R/)
  args  <- commandArgs(trailingOnly = FALSE)
  f_arg <- sub("^--file=", "", args[grepl("^--file=", args)])
  if (length(f_arg) > 0 && file.exists(f_arg)) {
    return(normalizePath(dirname(dirname(f_arg)), winslash = "/"))
  }
  ofile <- tryCatch(sys.frame(1)$ofile, error = function(e) NULL)
  if (!is.null(ofile)) {
    return(normalizePath(dirname(dirname(ofile)), winslash = "/"))
  }
  # 2) fall back to cwd-relative resolution
  here <- normalizePath(getwd(), winslash = "/", mustWork = FALSE)
  target <- file.path("projects", "similarity-metric")
  if (dir.exists(file.path(here, target))) {
    return(normalizePath(file.path(here, target), winslash = "/"))
  }
  here
}

PROJECT_ROOT <- find_project_root()
RESULTS_DIR  <- file.path(PROJECT_ROOT, "results")

IN_RDS        <- file.path(RESULTS_DIR, "w1_raw_simulation.rds")
IN_CSV_PREV   <- file.path(RESULTS_DIR, "w1_raw_summary.csv")
OUT_CSV       <- file.path(RESULTS_DIR, "w1_raw_summary.csv")
OUT_CSV_BAK   <- file.path(RESULTS_DIR, "w1_raw_summary_mctruth_20260517.csv")
OUT_TEX       <- file.path(RESULTS_DIR, "study1_latex_rows.tex")
OUT_PROV      <- file.path(RESULTS_DIR, "STUDY1_PROVENANCE.md")
OUT_SESSION   <- file.path(RESULTS_DIR, "study1_summary_exact_sessionInfo.txt")

stopifnot(file.exists(IN_RDS))

message("[paths] project root : ", PROJECT_ROOT)
message("[paths] canonical rds: ", IN_RDS)

# ---- Truth ------------------------------------------------------------------
# W1 as the CDF-area integral. For S6 the lower support of the log-normal is 0,
# so the integral is split at 0: for t < 0 the log-normal CDF is exactly 0 and
# the integrand reduces to F_normal(t). A naive single (-Inf, Inf) call is
# fragile because the integrand is non-smooth at t = 0.
quad_w1_normal_lognormal <- function(mu, sigma, meanlog, sdlog) {
  neg <- integrate(function(t) pnorm(t, mu, sigma),
                   -Inf, 0, rel.tol = 1e-12)$value
  pos <- integrate(function(t) abs(pnorm(t, mu, sigma) -
                                     plnorm(t, meanlog, sdlog)),
                   0, Inf, subdivisions = 10000L, rel.tol = 1e-12)$value
  neg + pos
}
quad_w1_normal_normal <- function(m1, s1, m2, s2) {
  integrate(function(t) abs(pnorm(t, m1, s1) - pnorm(t, m2, s2)),
            -Inf, Inf, subdivisions = 10000L, rel.tol = 1e-12)$value
}

SIGMA_LN <- 0.5
MU_LN    <- log(50) - SIGMA_LN^2 / 2          # = 3.787023...

TRUTH <- tibble::tribble(
  ~scenario, ~truth,               ~truth_source,
  "S1",      0,                    "exact (F1 = F2)",
  "S2",      2,                    "exact |mu1 - mu2|, equal variance",
  "S3",      5,                    "exact |mu1 - mu2|, equal variance",
  "S4",      10,                   "exact |mu1 - mu2|, equal variance",
  "S5",      sqrt(2 / pi) * 5,     "closed form sqrt(2/pi)*|sigma1 - sigma2|",
  "S6",      12.159806,            "numerical quadrature of int |F1 - F2| dt",
  "S7",      5.833155,             "numerical quadrature of int |F1 - F2| dt"
)

# Verify the two quadrature constants by re-integration (P4: never recall,
# always re-run).
q_s6 <- quad_w1_normal_lognormal(50, 10, MU_LN, SIGMA_LN)
q_s7 <- quad_w1_normal_normal(50, 10, 55, 15)
message(sprintf("[truth] S6 quadrature = %.10f  (stored %.6f, diff %.3e)",
                q_s6, TRUTH$truth[TRUTH$scenario == "S6"],
                abs(q_s6 - TRUTH$truth[TRUTH$scenario == "S6"])))
message(sprintf("[truth] S7 quadrature = %.10f  (stored %.6f, diff %.3e)",
                q_s7, TRUTH$truth[TRUTH$scenario == "S7"],
                abs(q_s7 - TRUTH$truth[TRUTH$scenario == "S7"])))
stopifnot(abs(q_s6 - TRUTH$truth[TRUTH$scenario == "S6"]) < 1e-6,
          abs(q_s7 - TRUTH$truth[TRUTH$scenario == "S7"]) < 1e-6)

# ---- Summarise --------------------------------------------------------------
# Byte-identical to summarize_cell() in w1_raw_simulation.R.
summarize_cell_exact <- function(mat, truth) {
  est <- mat[, "estimate"]; lo <- mat[, "ci_lower"]; hi <- mat[, "ci_upper"]
  tibble::tibble(
    true_W1       = truth,
    mean_est      = mean(est, na.rm = TRUE),
    bias          = mean(est, na.rm = TRUE) - truth,
    rmse          = sqrt(mean((est - truth)^2, na.rm = TRUE)),
    sd_est        = sd(est, na.rm = TRUE),
    mean_ci_width = mean(hi - lo, na.rm = TRUE),
    coverage_pct  = mean(lo <= truth & truth <= hi, na.rm = TRUE),
    n_valid       = sum(!is.na(est))
  )
}

sim          <- readRDS(IN_RDS)
rep_data     <- sim$rep_data
SCENARIO_IDS <- c("S1", "S2", "S3", "S4", "S5", "S6", "S7")
SAMPLE_SIZES <- c(50L, 100L, 200L)

grid <- expand.grid(n = SAMPLE_SIZES, scenario = SCENARIO_IDS,
                    stringsAsFactors = FALSE)[, c("scenario", "n")]

summary_df <- purrr::pmap_dfr(grid, function(scenario, n) {
  key <- paste(scenario, n, sep = "-")
  stopifnot(key %in% names(rep_data))
  truth <- TRUTH$truth[TRUTH$scenario == scenario]
  summarize_cell_exact(rep_data[[key]], truth) |>
    tibble::add_column(scenario = scenario, n = n, .before = 1)
}) |>
  dplyr::select(scenario, n, true_W1, mean_est, bias, rmse, sd_est,
                mean_ci_width, coverage_pct, n_valid)

# ---- Sanity: S1-S5 must reproduce the previous CSV to ~1e-13 ----------------
prev <- readr::read_csv(IN_CSV_PREV, show_col_types = FALSE)
num_cols <- c("true_W1", "mean_est", "bias", "rmse", "sd_est",
              "mean_ci_width", "coverage_pct", "n_valid")
chk <- dplyr::inner_join(
  summary_df  |> dplyr::filter(scenario %in% c("S1", "S2", "S3", "S4", "S5")),
  prev        |> dplyr::filter(scenario %in% c("S1", "S2", "S3", "S4", "S5")),
  by = c("scenario", "n"), suffix = c("_new", "_old")
)
max_abs_diff <- max(vapply(num_cols, function(cc) {
  max(abs(chk[[paste0(cc, "_new")]] - chk[[paste0(cc, "_old")]]))
}, numeric(1)))
message(sprintf("[check] S1-S5 max |new - previous| over all columns = %.3e",
                max_abs_diff))
if (max_abs_diff > 1e-13) {
  stop("S1-S5 recomputation does not reproduce the previous CSV to 1e-13; ",
       "column semantics differ. max diff = ", max_abs_diff)
}

# ---- Backup the previous (MC-truth) summary, then write the new one ---------
if (!file.exists(OUT_CSV_BAK)) {
  ok <- file.copy(IN_CSV_PREV, OUT_CSV_BAK, overwrite = FALSE, copy.date = TRUE)
  stopifnot(ok)
  message("[backup] ", basename(IN_CSV_PREV), " -> ", basename(OUT_CSV_BAK))
} else {
  message("[backup] already present, left untouched: ", basename(OUT_CSV_BAK))
}

write.csv(as.data.frame(summary_df), OUT_CSV, row.names = FALSE)
message("[save] ", OUT_CSV)

# ---- LaTeX rows for the paper tables ---------------------------------------
LABELS <- c(S1 = "S1 (Null)", S2 = "S2 (0.2$\\sigma$)", S3 = "S3 (0.5$\\sigma$)",
            S4 = "S4 (1.0$\\sigma$)", S5 = "S5 (Scale)", S6 = "S6 (Skew)",
            S7 = "S7 (Loc+Scale)")

# Negative numbers are wrapped in math mode so the minus renders as U+2212.
fmt <- function(x, dp) {
  s <- formatC(abs(x), format = "f", digits = dp)
  ifelse(x < 0, paste0("$-", s, "$"), s)
}
wide <- function(df, col) {
  df |>
    dplyr::select(scenario, n, val = {{ col }}) |>
    tidyr::pivot_wider(names_from = n, values_from = val,
                       names_prefix = "n")
}

tex <- character(0)
add <- function(...) tex <<- c(tex, ...)

bias_w <- wide(summary_df, bias)
tw     <- summary_df |> dplyr::distinct(scenario, true_W1)
add("% ---- tab:bias rows (bias 3 dp; True W1 2 dp) ----")
for (s in SCENARIO_IDS) {
  r <- bias_w[bias_w$scenario == s, ]
  add(sprintf("%s & %s & %s & %s & %s \\\\",
              LABELS[[s]],
              formatC(tw$true_W1[tw$scenario == s], format = "f", digits = 2),
              fmt(r$n50, 3), fmt(r$n100, 3), fmt(r$n200, 3)))
}

cov_w <- wide(summary_df, coverage_pct)
add("", "% ---- tab:coverage rows (S2-S7, 3 dp) ----")
for (s in SCENARIO_IDS[-1]) {
  r <- cov_w[cov_w$scenario == s, ]
  add(sprintf("%s & %s & %s & %s \\\\",
              LABELS[[s]], fmt(r$n50, 3), fmt(r$n100, 3), fmt(r$n200, 3)))
}

rmse_w <- wide(summary_df, rmse)
ciw_w  <- wide(summary_df, mean_ci_width)
add("", "% ---- tab:precision rows (RMSE then mean CI width, 2 dp) ----")
for (s in SCENARIO_IDS) {
  a <- rmse_w[rmse_w$scenario == s, ]
  b <- ciw_w[ciw_w$scenario == s, ]
  add(sprintf("%s & %s & %s & %s & %s & %s & %s \\\\",
              LABELS[[s]],
              fmt(a$n50, 2), fmt(a$n100, 2), fmt(a$n200, 2),
              fmt(b$n50, 2), fmt(b$n100, 2), fmt(b$n200, 2)))
}
writeLines(tex, OUT_TEX)
message("[save] ", OUT_TEX)
cat("\n", paste(tex, collapse = "\n"), "\n\n", sep = "")

# ---- Provenance -------------------------------------------------------------
rds_mtime <- format(file.info(IN_RDS)$mtime, "%Y-%m-%d %H:%M:%S %Z")
prov <- c(
  "# Study 1 — provenance of `w1_raw_summary.csv`",
  "",
  sprintf("Generated: %s", format(Sys.time(), "%Y-%m-%d %H:%M:%S %Z")),
  sprintf("Producing script: `projects/similarity-metric/R/%s`",
          "study1_summary_exact.R"),
  "",
  "## Canonical run",
  "",
  "| Item | Value |",
  "|------|-------|",
  "| Per-replicate source | `projects/similarity-metric/results/w1_raw_simulation.rds` |",
  sprintf("| rds mtime | %s |", rds_mtime),
  sprintf("| Simulation started / finished | %s / %s |",
          format(sim$config$started), format(sim$config$finished)),
  sprintf("| Replications per cell | %s |", format(sim$config$n_reps, big.mark = ",")),
  sprintf("| Bootstrap resamples B | %s |", format(sim$config$B, big.mark = ",")),
  "| Bootstrap CI type | percentile, 95% |",
  "| Grid | S1–S7 × n ∈ {50, 100, 200} |",
  "",
  "The repo-root `results/` tree holds an earlier (2026-05-16) run of the same",
  "design. It is NOT canonical. All Study 1 numbers in the manuscript are to be",
  "read from the project tree CSV named above.",
  "",
  "## Reference (true) W1 values",
  "",
  "W1 is the CDF-area functional",
  "",
  "    W1(F1, F2) = int_{-inf}^{inf} |F1(t) - F2(t)| dt",
  "",
  "| Scenario | Distribution 1 | Distribution 2 | True W1 | Source |",
  "|---|---|---|---|---|",
  "| S1 | N(50, 10^2) | N(50, 10^2) | 0 | exact (F1 = F2) |",
  "| S2 | N(50, 10^2) | N(52, 10^2) | 2 | exact, \\|mu1 - mu2\\| (equal variance) |",
  "| S3 | N(50, 10^2) | N(55, 10^2) | 5 | exact, \\|mu1 - mu2\\| (equal variance) |",
  "| S4 | N(50, 10^2) | N(60, 10^2) | 10 | exact, \\|mu1 - mu2\\| (equal variance) |",
  sprintf("| S5 | N(50, 10^2) | N(50, 15^2) | %.9f | closed form sqrt(2/pi)*\\|sigma1 - sigma2\\| |",
          sqrt(2 / pi) * 5),
  sprintf("| S6 | N(50, 10^2) | LogN(%.6f, 0.5^2) | 12.159806 | numerical quadrature |", MU_LN),
  "| S7 | N(50, 10^2) | N(55, 15^2) | 5.833155 | numerical quadrature |",
  "",
  sprintf("Quadrature re-verified at generation time: S6 = %.10f, S7 = %.10f",
          q_s6, q_s7),
  "(`stats::integrate`, rel.tol = 1e-12). The S6 integral is split at t = 0",
  "because the log-normal support is (0, inf); on t < 0 the integrand reduces",
  "to F_normal(t) and contributes 5.3e-07.",
  "",
  "## What changed relative to the previous summary",
  "",
  "S6 and S7 previously used Monte-Carlo reference values (n_MC = 1e6):",
  "12.1532169638 and 5.8454086175. Those are superseded by the quadrature",
  "values above. S1–S5 truths are unchanged, so their rows are identical.",
  "",
  "**The rds is retained unmodified as the per-replicate source, but its",
  "embedded `$summary` and `$truth` elements still carry the old Monte-Carlo",
  "values for S6/S7 and must NOT be used.** `w1_raw_summary.csv` is the single",
  "source of truth for Study 1 summary numbers, including for figure code.",
  "",
  "Previous (MC-truth) summary preserved byte-for-byte at",
  "`projects/similarity-metric/results/w1_raw_summary_mctruth_20260517.csv`.",
  "",
  "## Column semantics",
  "",
  "| Column | Definition |",
  "|---|---|",
  "| `mean_est` | mean of the 10,000 replicate estimates |",
  "| `bias` | `mean_est - true_W1` |",
  "| `rmse` | sqrt(mean((est - true_W1)^2)), n denominator |",
  "| `sd_est` | sd(est), n-1 denominator |",
  "| `mean_ci_width` | mean(ci_upper - ci_lower) |",
  "| `coverage_pct` | proportion of CIs containing `true_W1` (a proportion, not a percentage) |",
  "| `n_valid` | number of non-missing estimates |",
  "",
  "## Reproducibility",
  "",
  "The script performs no random number generation (it only summarises an",
  "existing per-replicate matrix), so no `set.seed()` is declared and re-runs",
  "are deterministic. `sessionInfo()` is written to",
  "`study1_summary_exact_sessionInfo.txt` in this directory."
)
writeLines(prov, OUT_PROV)
message("[save] ", OUT_PROV)

writeLines(capture.output(sessionInfo()), OUT_SESSION)
message("[save] ", OUT_SESSION)

message("[done]")
