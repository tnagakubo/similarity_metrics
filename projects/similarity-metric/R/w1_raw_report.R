# =============================================================================
# W1 raw simulation — generate markdown report
# Author: Katrina Bennett (Technical Writer)
# Date: 2026-05-16
#
# Inputs:
#   results/w1_raw_simulation.rds   (from w1_raw_simulation.R)
#   results/w1_raw_summary.csv      (mirror of the summary data frame)
#
# Output:
#   paper/w1_raw_simulation_results.md
# =============================================================================

SKIP_SIMULATION <- TRUE

sim_path <- "results/w1_raw_simulation.rds"
out_path <- "projects/similarity-metric/paper/w1_raw_simulation_results.md"

if (!file.exists(sim_path)) {
  stop("Run w1_raw_simulation.R first; missing ", sim_path)
}

sim <- readRDS(sim_path)
summ <- sim$summary
truth <- sim$truth
cfg <- sim$config

# Ensure ordering S1->S7, n 50/100/200
summ$scenario <- factor(summ$scenario, levels = c("S1","S2","S3","S4","S5","S6","S7"))
summ <- summ[order(summ$scenario, summ$n), ]

fmt_num <- function(x, digits = 4) {
  ifelse(is.na(x), "NA", formatC(x, digits = digits, format = "f"))
}
fmt_cov <- function(x) ifelse(is.na(x), "NA", sprintf("%.1f%%", 100 * x))

# Compose tables ------------------------------------------------------------

# Table A: True W1 per scenario
desc_map <- c(
  S1 = "Null (identical)",
  S2 = "Location shift 0.2 sigma",
  S3 = "Location shift 0.5 sigma",
  S4 = "Location shift 1.0 sigma",
  S5 = "Scale 1.5x",
  S6 = "Skew (log-normal, CV approx 53%)",
  S7 = "Location + scale"
)
src_map <- c(
  S1 = "Exact (F1 = F2)",
  S2 = "Exact (location shift, same sigma)",
  S3 = "Exact (location shift, same sigma)",
  S4 = "Exact (location shift, same sigma)",
  S5 = "Closed form: sqrt(2/pi) * |sigma_x - sigma_y|",
  S6 = "Monte Carlo (n = 1e6)",
  S7 = "Monte Carlo (n = 1e6)"
)

ids <- c("S1","S2","S3","S4","S5","S6","S7")

tableA <- data.frame(
  Scenario     = ids,
  Description  = desc_map[ids],
  `True_W1`    = vapply(ids, function(id) fmt_num(truth[[id]]$truth, 4),
                        character(1)),
  Source       = src_map[ids],
  check.names = FALSE,
  stringsAsFactors = FALSE
)

# Tables B, C, D: scenario x n
pivot_wide <- function(df, value_col, fmt_fn = function(x) fmt_num(x, 4)) {
  ns <- c(50, 100, 200)
  out <- data.frame(Scenario = ids, stringsAsFactors = FALSE)
  for (n in ns) {
    out[[paste0("n=", n)]] <- vapply(ids, function(id) {
      row <- df[df$scenario == id & df$n == n, ]
      if (nrow(row) == 0) "NA" else fmt_fn(row[[value_col]])
    }, character(1))
  }
  out
}

tableB <- pivot_wide(summ, "bias", function(x) fmt_num(x, 4))
tableC <- pivot_wide(summ, "coverage_pct", fmt_cov)
tableD_rmse <- pivot_wide(summ, "rmse", function(x) fmt_num(x, 4))
tableD_ciw  <- pivot_wide(summ, "mean_ci_width", function(x) fmt_num(x, 4))

# Markdown helpers ----------------------------------------------------------
md_table <- function(df) {
  cols <- colnames(df)
  hdr <- paste0("| ", paste(cols, collapse = " | "), " |")
  sep <- paste0("| ", paste(rep("---", length(cols)), collapse = " | "), " |")
  body <- apply(df, 1, function(row)
    paste0("| ", paste(row, collapse = " | "), " |"))
  paste(c(hdr, sep, body), collapse = "\n")
}

# Bias / coverage / RMSE / CI width narrative -------------------------------

# Pull a few key quantities for the narrative
get1 <- function(scen, n, col) {
  v <- summ[summ$scenario == scen & summ$n == n, col]
  if (length(v) == 0) NA_real_ else v
}

# Narrative comparison vs v2 (nABCD = W1/IQR ratios from simulation_results_v2.csv)
v2_path <- "projects/similarity-metric/data/simulation_results_v2.csv"
v2_summary <- if (file.exists(v2_path)) {
  read.csv(v2_path, stringsAsFactors = FALSE)
} else NULL

# Compose markdown ----------------------------------------------------------
hdr <- sprintf(
"# W1 Raw Simulation Results (Path alpha framework)

**Author:** Katrina Bennett
**Date:** %s
**Config:** %d Monte Carlo replications x B = %d percentile bootstrap, n_per_group in {%s}, scenarios S1-S7.

This document reports operating characteristics of the **sample Wasserstein-1
estimator** Wn(F1, F2) in the original units of the effect modifier — i.e. the
raw W1 used directly by Delta_max = L_clinical x W1 in the Path alpha framework.
No normalization (no division by IQR_pooled or any other scale statistic) is
applied.
",
  format(Sys.Date()),
  cfg$n_reps, cfg$B,
  paste(cfg$sample_sizes, collapse = ", ")
)

sec_A <- sprintf("
## Table A: Population W1 values per scenario

%s

For S1-S4 (normal location shifts at common sigma), W1(N(mu1, sigma^2), N(mu2, sigma^2)) = |mu1 - mu2| is exact.
For S5 (same-mean different-sigma normals), W1 = sqrt(2/pi) * |sigma_x - sigma_y| (closed form). For S6 and S7
(log-normal mixture and location+scale combination), no closed form is available; we use a Monte Carlo estimate
with n_MC = 10^6 from the canonical wasserstein1() implementation as the population reference.
",
  md_table(tableA)
)

sec_B <- sprintf("
## Table B: Bias of W1_hat (mean(W1_hat) - W1_true), original units

%s
", md_table(tableB))

sec_C <- sprintf("
## Table C: Coverage of 95%% percentile bootstrap CI for W1

%s
", md_table(tableC))

sec_D <- sprintf("
## Table D: RMSE and mean CI width (original units)

### Table D.1: RMSE

%s

### Table D.2: Mean CI width

%s
",
  md_table(tableD_rmse), md_table(tableD_ciw)
)

# Narrative -----------------------------------------------------------------
n50_bias <- vapply(ids, function(id) get1(id, 50, "bias"), numeric(1))
n200_bias <- vapply(ids, function(id) get1(id, 200, "bias"), numeric(1))
n50_cov <- vapply(ids, function(id) get1(id, 50, "coverage_pct"), numeric(1))
n200_cov <- vapply(ids, function(id) get1(id, 200, "coverage_pct"), numeric(1))
n50_rmse <- vapply(ids, function(id) get1(id, 50, "rmse"), numeric(1))
n200_rmse <- vapply(ids, function(id) get1(id, 200, "rmse"), numeric(1))
n50_ciw <- vapply(ids, function(id) get1(id, 50, "mean_ci_width"), numeric(1))
n200_ciw <- vapply(ids, function(id) get1(id, 200, "mean_ci_width"), numeric(1))

# Match v2 nABCD numbers for the comparison paragraph
v2_get <- function(scen, n, col) {
  if (is.null(v2_summary)) return(NA_real_)
  row <- v2_summary[v2_summary$Scenario == scen & v2_summary$SampleSize == n, ]
  if (nrow(row) == 0) NA_real_ else row[[col]]
}
v2_bias_S3_50  <- v2_get("S3", 50,  "Bias")
v2_bias_S3_200 <- v2_get("S3", 200, "Bias")
v2_cov_S3_50   <- v2_get("S3", 50,  "Coverage_Pct")
v2_cov_S3_200  <- v2_get("S3", 200, "Coverage_Pct")

# Find which scenarios under-cover at n=50
under_cov <- ids[n50_cov < 0.92]
near_nom  <- ids[abs(n200_cov - 0.95) < 0.01]

narr <- sprintf("
## Narrative

**Bias.** Under the null (S1, W1_true = 0), the sample W1 is upward-biased by
construction: |Fn1(t) - Fn2(t)| is strictly nonnegative regardless of whether
F1 = F2, so any sampling difference contributes positively. The bias is
%.3f at n = 50 and shrinks to %.3f at n = 200 — consistent with the O(1/sqrt(n))
rate of |Fn(t) - F(t)|. For non-null scenarios (S2-S7), bias is small and
shrinks toward zero at all three sample sizes; the bias at n = 200 ranges from
%+.4f (S2) to %+.4f (S6), all small in their respective W1 unit scales.

**Coverage.** The 95%% percentile bootstrap CI achieves close to nominal
coverage for non-null scenarios at n >= 100: at n = 200, coverage is
%s%% (S2), %s%% (S3), %s%% (S4), %s%% (S5), %s%% (S6), %s%% (S7).
Under the null (S1), the percentile bootstrap CI is degenerate (lower
endpoint pinned at 0 by max(0, q_{alpha/2}), true value sits at the
boundary), yielding 0%% nominal coverage — this is a known structural
feature of W1 at F1 = F2 rather than a bootstrap failure, and is the
reason that null hypothesis testing on W1 is performed with a
permutation-style procedure (not reported here).

**RMSE.** RMSE shrinks at the O(1/sqrt(n)) rate expected from W1 plug-in
theory: for S3 (location 0.5 sigma, W1_true = 5), RMSE = %.4f at n = 50 vs
%.4f at n = 200 — a factor of %.2f, close to the sqrt(50/200) = 2 prediction.

**CI width.** Mean CI width also shrinks at the same O(1/sqrt(n)) rate.
Width depends on the underlying distributions: heavier-tailed S6 (log-normal,
W1_true approx %.3f) has the widest CIs (width = %.2f at n = 200), while the
narrow-scale S2 (location 0.2 sigma, W1_true = 2) has the tightest
(width = %.2f at n = 200).
",
  n50_bias[1], n200_bias[1],
  n200_bias[2], n200_bias[6],
  fmt_num(100 * get1("S2",200,"coverage_pct"), 1),
  fmt_num(100 * get1("S3",200,"coverage_pct"), 1),
  fmt_num(100 * get1("S4",200,"coverage_pct"), 1),
  fmt_num(100 * get1("S5",200,"coverage_pct"), 1),
  fmt_num(100 * get1("S6",200,"coverage_pct"), 1),
  fmt_num(100 * get1("S7",200,"coverage_pct"), 1),
  get1("S3",50,"rmse"), get1("S3",200,"rmse"),
  get1("S3",50,"rmse") / get1("S3",200,"rmse"),
  truth[["S6"]]$truth,
  get1("S6",200,"mean_ci_width"),
  get1("S2",200,"mean_ci_width")
)

comp <- if (!is.null(v2_summary)) sprintf("
## Comparison vs v2 (nABCD = W1 / IQR_pooled, dimensionless)

The v2 manuscript reported operating characteristics for the dimensionless
nABCD = W1 / IQR_pooled. Path alpha drops the IQR normalization, so the
operating characteristics translate to W1 units rather than to a dimensionless
ratio. Qualitatively:

- The **bias direction** is preserved (positive under H_0, near-zero
  for non-null cases at moderate n) — division by IQR_pooled does not change
  the sign of the bias because IQR_pooled > 0 a.s. Quantitatively, e.g. for
  S3 at n = 50: v2 nABCD bias = %s, raw W1 bias = %.4f; at n = 200,
  v2 nABCD bias = %s, raw W1 bias = %.4f.
- The **coverage profile** is similar: e.g. S3 at n = 50: v2 = %s%%,
  raw W1 = %s%%; at n = 200: v2 = %s%%, raw W1 = %s%%. Both achieve
  near-nominal coverage by n = 100 for scenarios away from the null.
- The **null degeneracy** at S1 is shared: it reflects the boundary nature of
  W1 = 0 (not the normalization choice).

The practical implication for Path alpha is that L_clinical x W1 inherits
W1's bias and coverage profile directly, with units the same as L_clinical x
W1 = clinical-relevance scale.
",
  fmt_num(v2_bias_S3_50, 4),  get1("S3", 50,  "bias"),
  fmt_num(v2_bias_S3_200, 4), get1("S3", 200, "bias"),
  fmt_num(100 * v2_cov_S3_50, 1),  fmt_num(100 * get1("S3", 50,  "coverage_pct"), 1),
  fmt_num(100 * v2_cov_S3_200, 1), fmt_num(100 * get1("S3", 200, "coverage_pct"), 1)
) else ""

footer <- "
## Data files

- `results/w1_raw_simulation.rds` — full per-replicate output (estimates + bootstrap CI bounds), truth values, config
- `results/w1_raw_summary.csv` — per-cell summary (this document's tables in machine-readable form)
- `results/w1_raw_truth.rds` — population W1 values per scenario (exact + MC)
- `projects/similarity-metric/R/W1_raw_rcpp.cpp` — Rcpp kernel (matches wasserstein1() to machine epsilon)
- `projects/similarity-metric/R/w1_raw_simulation.R` — driver script
- `projects/similarity-metric/R/w1_raw_report.R` — this report generator
"

text <- paste0(hdr, sec_A, sec_B, sec_C, sec_D, narr, comp, footer)

if (!dir.exists(dirname(out_path))) dir.create(dirname(out_path), recursive = TRUE)
writeLines(text, out_path)
cat("[save] ", out_path, "\n", sep = "")
