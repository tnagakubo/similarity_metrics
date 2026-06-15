# =============================================================================
# W1 (Wasserstein-1) raw simulation — Path α operating characteristics
# Author: Katrina Bennett (Technical Writer)
# Date: 2026-05-16
#
# Purpose:
#   Path α framework uses Delta_max = L_clinical * W_1 (no normalization).
#   v2 simulation reported nABCD = W1/IQR_pooled operating characteristics;
#   this script re-reports operating characteristics of the SAMPLE W1
#   estimator (original variable units) for scenarios S1–S7.
#
# Scenarios (v2 §3.1, no normalization):
#   S1: F1=F2=N(50,10^2)              → W1_true = 0 (exact)
#   S2: N(50,10^2) vs N(52,10^2)      → W1_true = 2 (exact, location shift)
#   S3: N(50,10^2) vs N(55,10^2)      → W1_true = 5 (exact)
#   S4: N(50,10^2) vs N(60,10^2)      → W1_true = 10 (exact)
#   S5: N(50,10^2) vs N(50,15^2)      → W1_true = sqrt(2/pi) * 5 ≈ 3.989 (closed form)
#   S6: N(50,10^2) vs LogN(meanlog=log(50)-sigma_ln^2/2, sigma_ln=0.5)
#                                      → W1_true via MC, n=1e6
#   S7: N(50,10^2) vs N(55,15^2)      → W1_true via MC, n=1e6
#
# Design:
#   n_per_group ∈ {50, 100, 200}
#   n_reps      = 10000 Monte Carlo
#   B           = 2000  percentile bootstrap
#   conf        = 0.95
#
# Outputs:
#   results/w1_raw_simulation.rds         — full per-replicate output (list)
#   results/w1_raw_simulation_partial.rds — per-cell partial (resume support)
#   results/w1_raw_summary.csv            — summary table
#   paper/w1_raw_simulation_results.md    — markdown narrative
# =============================================================================

SKIP_SIMULATION <- TRUE
suppressPackageStartupMessages({
  library(parallel)
  library(Rcpp)
})

ROOT <- tryCatch(dirname(sys.frame(1)$ofile), error = function(e) ".")
if (!file.exists(file.path(ROOT, "simulation_manuscript_v2.R"))) {
  candidates <- c("R", "projects/similarity-metric/R", ".")
  hit <- candidates[file.exists(file.path(candidates, "simulation_manuscript_v2.R"))]
  if (length(hit) == 0L) {
    stop("Cannot locate simulation_manuscript_v2.R (cwd=", getwd(), ")")
  }
  ROOT <- hit[1]
}
ROOT_ABS <- normalizePath(ROOT)
source(file.path(ROOT, "simulation_manuscript_v2.R"), chdir = TRUE)
source(file.path(ROOT, "scenarios_extended.R"),      chdir = TRUE)

CPP_FILE <- normalizePath(file.path(ROOT, "W1_raw_rcpp.cpp"))
Rcpp::sourceCpp(CPP_FILE)

# ---- CLI ------------------------------------------------------------------
parse_args <- function(args = commandArgs(trailingOnly = TRUE)) {
  out <- list(
    test  = FALSE,
    reps  = 10000L,
    boot  = 2000L,
    cores = max(1L, parallel::detectCores() - 2L)
  )
  for (a in args) {
    if (a == "--test") out$test <- TRUE
    else if (grepl("^--reps=",  a)) out$reps  <- as.integer(sub("^--reps=",  "", a))
    else if (grepl("^--boot=",  a)) out$boot  <- as.integer(sub("^--boot=",  "", a))
    else if (grepl("^--cores=", a)) out$cores <- as.integer(sub("^--cores=", "", a))
  }
  if (out$test) { out$reps <- 200L; out$boot <- 500L }
  out
}
OPTS <- parse_args()

# ---- Scenarios (S1-S7) with W1 truth --------------------------------------
SCENARIO_IDS <- c("S1", "S2", "S3", "S4", "S5", "S6", "S7")
SAMPLE_SIZES <- c(50L, 100L, 200L)

# Closed-form W1 for same-location different-σ normals:
#   X ~ N(0, σ_x^2), Y ~ N(0, σ_y^2) ⇒ W1(X, Y) = sqrt(2/pi) * |σ_x - σ_y|
w1_normal_scale_diff <- function(sx, sy) sqrt(2 / pi) * abs(sx - sy)

# Compute population W1 (exact where available, MC where not)
compute_true_W1 <- function(n_mc = 1e6, seed = 12345) {
  set.seed(seed)
  out <- list()
  for (id in SCENARIO_IDS) {
    sc <- scenarios_v2[[id]]
    truth_exact <- NA_real_
    truth_mc <- NA_real_

    # Exact values where the closed form is tractable
    if (id == "S1") truth_exact <- 0
    else if (id == "S2") truth_exact <- 2
    else if (id == "S3") truth_exact <- 5
    else if (id == "S4") truth_exact <- 10
    else if (id == "S5") truth_exact <- w1_normal_scale_diff(10, 15)
    # S6 and S7 require MC

    # MC value (always computed, as a check; used as primary for S6, S7)
    x <- sc$dist1(n_mc); y <- sc$dist2(n_mc)
    truth_mc <- wasserstein1(x, y)

    out[[id]] <- list(
      scenario     = id,
      description  = sc$name,
      truth_exact  = truth_exact,
      truth_mc     = truth_mc,
      truth        = if (is.na(truth_exact)) truth_mc else truth_exact
    )
    cat(sprintf("[truth] %s: exact=%s  MC=%s  used=%.4f\n",
                id,
                if (is.na(truth_exact)) "NA" else sprintf("%.4f", truth_exact),
                sprintf("%.4f", truth_mc),
                out[[id]]$truth))
  }
  out
}

# ---- Per-rep / per-cell ----------------------------------------------------
single_rep_w1 <- function(rep_id, scenario, n_per_group, B, conf = 0.95) {
  na_res <- list(estimate = NA_real_, ci_lower = NA_real_, ci_upper = NA_real_)
  out <- tryCatch({
    x <- scenario$dist1(n_per_group)
    y <- scenario$dist2(n_per_group)
    W1_raw_bootstrap_cpp(x, y, B = as.integer(B), conf = conf)
  }, error = function(e) na_res)
  if (rep_id %% 1000L == 0L) gc(verbose = FALSE, full = TRUE)
  c(out$estimate, out$ci_lower, out$ci_upper)
}

run_cell <- function(scenario, n_per_group, n_reps, B, conf = 0.95,
                     cluster = NULL, seed = 42) {
  # Build self-contained worker: scenario/n/B/conf baked into its closure env.
  # On PSOCK workers, parLapplyLB serializes the closure (including the
  # enclosing env) to each worker, so they see the right scenario/n/B.
  # The cpp function W1_raw_bootstrap_cpp is sourced fresh on each worker
  # via setup_cluster(); we look it up by name to avoid serializing the
  # master's (worker-invalid) .Call pointer.
  worker_env <- new.env(parent = globalenv())
  worker_env$scenario     <- scenario
  worker_env$n_per_group  <- n_per_group
  worker_env$B            <- B
  worker_env$conf         <- conf
  worker <- function(rep_id) {
    na_res <- c(estimate = NA_real_, ci_lower = NA_real_, ci_upper = NA_real_)
    out <- tryCatch({
      x <- scenario$dist1(n_per_group)
      y <- scenario$dist2(n_per_group)
      # Look up the worker's locally compiled Rcpp function (not the
      # master's stale function-with-broken-.Call pointer)
      cpp_fn <- get("W1_raw_bootstrap_cpp", envir = .GlobalEnv,
                    mode = "function")
      r <- cpp_fn(x, y, B = as.integer(B), conf = conf)
      c(estimate = r$estimate, ci_lower = r$ci_lower, ci_upper = r$ci_upper)
    }, error = function(e) na_res)
    if (rep_id %% 1000L == 0L) gc(verbose = FALSE, full = TRUE)
    out
  }
  environment(worker) <- worker_env

  if (!is.null(cluster)) {
    parallel::clusterSetRNGStream(cluster, iseed = seed)
    res_list <- tryCatch(
      parallel::parLapplyLB(cluster, seq_len(n_reps), worker,
                             chunk.size = max(1L, n_reps %/% (length(cluster) * 8L))),
      error = function(e) {
        message(sprintf("[run_cell] worker error: %s; sequential fallback",
                        conditionMessage(e)))
        set.seed(seed)
        lapply(seq_len(n_reps), worker)
      }
    )
  } else {
    set.seed(seed)
    res_list <- lapply(seq_len(n_reps), worker)
  }
  mat <- do.call(rbind, res_list)
  colnames(mat) <- c("estimate", "ci_lower", "ci_upper")
  mat
}

summarize_cell <- function(mat, truth) {
  est <- mat[, "estimate"]; lo <- mat[, "ci_lower"]; hi <- mat[, "ci_upper"]
  bias <- mean(est, na.rm = TRUE) - truth
  rmse <- sqrt(mean((est - truth)^2, na.rm = TRUE))
  sd_e <- sd(est, na.rm = TRUE)
  ciw  <- mean(hi - lo, na.rm = TRUE)
  cov  <- mean(lo <= truth & truth <= hi, na.rm = TRUE)
  data.frame(
    true_W1       = truth,
    mean_est      = mean(est, na.rm = TRUE),
    bias          = bias,
    rmse          = rmse,
    sd_est        = sd_e,
    mean_ci_width = ciw,
    coverage_pct  = cov,
    n_valid       = sum(!is.na(est)),
    stringsAsFactors = FALSE
  )
}

# ---- Cluster setup --------------------------------------------------------
setup_cluster <- function(n_cores) {
  if (n_cores <= 1L) return(NULL)
  cat(sprintf("[cluster] starting PSOCK with %d workers...\n", n_cores))
  cl <- parallel::makeCluster(n_cores, type = "PSOCK")
  parallel::clusterEvalQ(cl, {
    SKIP_SIMULATION <- TRUE
    suppressPackageStartupMessages({ library(Rcpp) })
  })
  parallel::clusterCall(cl, function(root, cpp_file) {
    SKIP_SIMULATION <<- TRUE
    source(file.path(root, "simulation_manuscript_v2.R"), chdir = TRUE)
    source(file.path(root, "scenarios_extended.R"),      chdir = TRUE)
    Rcpp::sourceCpp(cpp_file)
    invisible(TRUE)
  }, root = ROOT_ABS, cpp_file = CPP_FILE)
  # Do NOT export W1_raw_bootstrap_cpp from master — its .Call pointer is
  # invalid in workers. Each worker compiled its own via sourceCpp above.
  cl
}

# ---- Main -----------------------------------------------------------------
main <- function() {
  cat("==========================================================\n")
  cat(" W1 raw simulation (Path α operating characteristics)\n")
  cat("==========================================================\n")
  cat(sprintf(" reps=%d  B=%d  cores=%d  test=%s\n",
              OPTS$reps, OPTS$boot, OPTS$cores, OPTS$test))
  cat(sprintf(" started: %s\n", format(Sys.time())))

  if (!dir.exists("results")) dir.create("results", recursive = TRUE)

  # --- Truth ---
  cat("\n[truth] computing W1_true (exact + MC n=1e6)...\n")
  truth_list <- compute_true_W1(n_mc = 1e6, seed = 12345)
  truth_df <- do.call(rbind, lapply(truth_list, as.data.frame))
  rownames(truth_df) <- NULL
  print(truth_df)
  saveRDS(truth_list, "results/w1_raw_truth.rds")
  cat("[truth] saved results/w1_raw_truth.rds\n")

  # --- Cluster ---
  cl <- setup_cluster(OPTS$cores)
  on.exit({ if (!is.null(cl)) try(parallel::stopCluster(cl), silent = TRUE) }, add = TRUE)

  # --- Grid: S1-S7 x {50, 100, 200} ---
  partial_file <- "results/w1_raw_simulation_partial.rds"
  if (file.exists(partial_file)) {
    partial <- readRDS(partial_file)
    cat(sprintf("[grid] resuming — %d cells already done\n", length(partial$cells)))
  } else {
    partial <- list(started = Sys.time(), cells = list())
  }
  done_key <- function(c) paste(c$scenario, c$n, sep = "-")
  done_set <- vapply(partial$cells, done_key, character(1))

  cell_rows <- list()
  rep_data  <- list()  # per-cell raw replicate matrix
  for (sc_id in SCENARIO_IDS) {
    sc <- scenarios_v2[[sc_id]]
    truth <- truth_list[[sc_id]]$truth
    for (n in SAMPLE_SIZES) {
      key <- paste(sc_id, n, sep = "-")
      k <- length(cell_rows) + 1L
      total <- length(SCENARIO_IDS) * length(SAMPLE_SIZES)
      if (key %in% done_set) {
        idx <- which(done_set == key)
        cat(sprintf("[grid %d/%d] %s n=%d ... resume from partial\n",
                    k, total, sc_id, n))
        cell <- partial$cells[[idx]]
        cell_rows[[length(cell_rows) + 1L]] <- cell$summary
        rep_data[[key]] <- cell$mat
        next
      }
      cat(sprintf("[grid %d/%d] %s n=%d ... ", k, total, sc_id, n))
      t0 <- Sys.time()
      mat <- run_cell(sc, n_per_group = n, n_reps = OPTS$reps, B = OPTS$boot,
                      cluster = cl, seed = 42L + 1000L * k)
      summ <- summarize_cell(mat, truth)
      summ$scenario <- sc_id
      summ$n        <- n
      el <- as.numeric(difftime(Sys.time(), t0, units = "secs"))
      cat(sprintf("done (%.1fs)  bias=%+.4f  cov=%.3f  rmse=%.4f\n",
                  el, summ$bias, summ$coverage_pct, summ$rmse))
      cell_rows[[length(cell_rows) + 1L]] <- summ
      rep_data[[key]] <- mat
      partial$cells[[length(partial$cells) + 1L]] <- list(
        scenario = sc_id, n = n, summary = summ, mat = mat, elapsed_s = el
      )
      done_set <- c(done_set, key)
      saveRDS(partial, partial_file)
    }
  }

  # --- Save outputs ---
  summary_df <- do.call(rbind, cell_rows)
  summary_df <- summary_df[, c("scenario", "n", "true_W1", "mean_est",
                                "bias", "rmse", "sd_est",
                                "mean_ci_width", "coverage_pct", "n_valid")]
  rownames(summary_df) <- NULL
  print(summary_df)

  out_list <- list(
    truth      = truth_list,
    summary    = summary_df,
    rep_data   = rep_data,
    config     = list(n_reps = OPTS$reps, B = OPTS$boot,
                      sample_sizes = SAMPLE_SIZES,
                      scenarios = SCENARIO_IDS,
                      seed_base = 42L,
                      started = partial$started,
                      finished = Sys.time())
  )
  saveRDS(out_list, "results/w1_raw_simulation.rds")
  cat("[save] results/w1_raw_simulation.rds\n")

  write.csv(summary_df, "results/w1_raw_summary.csv", row.names = FALSE)
  cat("[save] results/w1_raw_summary.csv\n")

  cat(sprintf("\n[done] finished: %s\n", format(Sys.time())))
  invisible(out_list)
}

if (sys.nframe() == 0L) {
  main()
}
