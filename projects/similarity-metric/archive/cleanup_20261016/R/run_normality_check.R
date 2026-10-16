# =============================================================================
# Asymptotic Normality Verification (Tak directive 2026-05-11, Option A)
# Selected cells: N2/N3/N4/N6 × n=200 → save raw estimate matrices
# Output: results/normality_check_raw.rds (list of matrices per cell)
# Subsequent: check_normality.R analyzes via QQ plot, Shapiro-Wilk, KS test.
# =============================================================================

SKIP_SIMULATION <- TRUE
suppressPackageStartupMessages({
  library(parallel)
  library(Rcpp)
})

ROOT <- "projects/similarity-metric/R"
options(nabcd.use_rcpp = TRUE)
Rcpp::sourceCpp(file.path(ROOT, "nABCD_5norm_rcpp.cpp"))

source(file.path(ROOT, "simulation_manuscript_v2.R"), chdir = TRUE)
source(file.path(ROOT, "nabcd_normalizers.R"),       chdir = TRUE)
source(file.path(ROOT, "scenarios_redesign.R"),      chdir = TRUE)
source(file.path(ROOT, "true_normalizers.R"),        chdir = TRUE)
source(file.path(ROOT, "run_normalizer_comparison.R"))
options(nabcd.use_rcpp = TRUE)
stopifnot(exists("nABCD_bootstrap_5norm_cpp"))

# =============================================================================
# Cell runner returning RAW matrices (not summary)
# =============================================================================
run_cell_raw <- function(scenario, n_per_group, n_reps, B, conf = 0.95,
                          cluster = NULL, seed = 42) {
  worker_env <- new.env(parent = globalenv())
  worker_env$scenario     <- scenario
  worker_env$n_per_group  <- n_per_group
  worker_env$B            <- B
  worker_env$conf         <- conf
  worker <- function(rep_id) {
    na_vec <- setNames(rep(NA_real_, length(NORMALIZERS)), NORMALIZERS)
    out <- tryCatch({
      x <- scenario$dist1(n_per_group)
      y <- scenario$dist2(n_per_group)
      single_rep_all_normalizers(x, y, B = B, conf = conf)
    }, error = function(e) {
      list(estimate = na_vec, ci_lower = na_vec, ci_upper = na_vec)
    })
    if (rep_id %% 500L == 0L) gc(verbose = FALSE, full = TRUE)
    out
  }
  environment(worker) <- worker_env

  if (!is.null(cluster)) {
    parallel::clusterSetRNGStream(cluster, iseed = seed)
    res_list <- parallel::parLapplyLB(cluster, seq_len(n_reps), worker,
        chunk.size = max(1L, n_reps %/% (length(cluster) * 8L)))
  } else {
    set.seed(seed)
    res_list <- lapply(seq_len(n_reps), worker)
  }

  est_mat <- do.call(rbind, lapply(res_list, `[[`, "estimate"))
  lo_mat  <- do.call(rbind, lapply(res_list, `[[`, "ci_lower"))
  hi_mat  <- do.call(rbind, lapply(res_list, `[[`, "ci_upper"))
  list(estimate = est_mat, ci_lower = lo_mat, ci_upper = hi_mat)
}

# =============================================================================
# Main
# =============================================================================

selected <- list(
  list(sc = "N2", n = 200L),  # Gaussian ref — should be asymptotic normal
  list(sc = "N3", n = 200L),  # Pure scale (SMD=0) — should be asymptotic normal
  list(sc = "N4", n = 200L),  # Heavy tail t(3) — slow convergence
  list(sc = "N6", n = 200L)   # Outlier 20% — expected to break normality
)

true_df <- readRDS("results/true_redesign.rds")

cat("==========================================================\n")
cat(" Normality Check — Raw Estimates Capture\n")
cat("==========================================================\n")
cat(sprintf(" cells: %d, n_reps=10000, B=1000\n", length(selected)))
cat(sprintf(" started: %s\n", format(Sys.time())))

cl <- setup_cluster(5L)
on.exit({ if (!is.null(cl)) try(parallel::stopCluster(cl), silent = TRUE) }, add = TRUE)

results <- list()
for (idx in seq_along(selected)) {
  item <- selected[[idx]]
  sc_id <- item$sc
  n     <- item$n
  cat(sprintf("[normality %d/%d] %s n=%d ... ", idx, length(selected), sc_id, n))
  t0 <- Sys.time()
  scenario <- scenarios_redesign[[sc_id]]
  cell <- run_cell_raw(scenario, n_per_group = n, n_reps = 10000L, B = 1000L,
                        cluster = cl, seed = 42L + 9999L * idx)
  el <- as.numeric(difftime(Sys.time(), t0, units = "secs"))
  cat(sprintf("done (%.1fs)\n", el))

  truth_named <- setNames(
    true_df$true_nABCD[true_df$scenario == sc_id][match(NORMALIZERS,
      true_df$normalizer[true_df$scenario == sc_id])],
    NORMALIZERS
  )

  results[[sprintf("%s_n%d", sc_id, n)]] <- list(
    scenario = sc_id, n = n, elapsed_s = el,
    truth = truth_named,
    estimate = cell$estimate,
    ci_lower = cell$ci_lower,
    ci_upper = cell$ci_upper
  )

  # Recycle cluster
  try(parallel::stopCluster(cl), silent = TRUE)
  cl <- setup_cluster(5L)
}

saveRDS(results, "results/normality_check_raw.rds")
cat(sprintf("\nSaved: results/normality_check_raw.rds (%d cells)\n", length(results)))
cat(sprintf("[done] finished: %s\n", format(Sys.time())))
