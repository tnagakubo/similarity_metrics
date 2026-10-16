# =============================================================================
# Sample-level simulation for redesigned scenarios N1-N8
# - Tracks nABCD (5 normalizers) + sample SMD per rep
# - Uses Rcpp 5-normalizer bootstrap (verified 29x speedup)
# - 8 scenarios × 3 sample sizes (50/100/200) = 24 cells
# - n_reps = 10000, B = 1000 per rep
# Output:
#   results/normalizer_comparison_redesign.rds
#   results/normalizer_comparison_redesign_partial.rds (live)
# =============================================================================

SKIP_SIMULATION <- TRUE
suppressPackageStartupMessages({
  library(parallel)
  library(Rcpp)
})

ROOT <- "projects/similarity-metric/R"
options(nabcd.use_rcpp = TRUE)

# Compile Rcpp on master
Rcpp::sourceCpp(file.path(ROOT, "nABCD_5norm_rcpp.cpp"))

source(file.path(ROOT, "simulation_manuscript_v2.R"), chdir = TRUE)
source(file.path(ROOT, "nabcd_normalizers.R"),       chdir = TRUE)
source(file.path(ROOT, "scenarios_redesign.R"),      chdir = TRUE)
source(file.path(ROOT, "true_normalizers.R"),        chdir = TRUE)
source(file.path(ROOT, "run_normalizer_comparison.R"))

options(nabcd.use_rcpp = TRUE)
stopifnot(exists("nABCD_bootstrap_5norm_cpp"))

# =============================================================================
# Cell runner with SMD tracking
# =============================================================================

run_cell_with_smd <- function(scenario, n_per_group, n_reps, B, conf = 0.95,
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
      res <- single_rep_all_normalizers(x, y, B = B, conf = conf)
      res$smd_est <- (mean(y) - mean(x)) / sqrt((var(x) + var(y)) / 2)
      res
    }, error = function(e) {
      list(estimate = na_vec, ci_lower = na_vec, ci_upper = na_vec,
           smd_est = NA_real_)
    })
    if (rep_id %% 500L == 0L) gc(verbose = FALSE, full = TRUE)
    out
  }
  environment(worker) <- worker_env

  if (!is.null(cluster)) {
    parallel::clusterSetRNGStream(cluster, iseed = seed)
    res_list <- tryCatch(
      parallel::parLapplyLB(cluster, seq_len(n_reps), worker,
                             chunk.size = max(1L, n_reps %/% (length(cluster) * 8L))),
      error = function(e) {
        message(sprintf("[run_cell] worker error: %s; falling back to sequential",
                        conditionMessage(e)))
        set.seed(seed)
        lapply(seq_len(n_reps), worker)
      }
    )
  } else {
    set.seed(seed)
    res_list <- lapply(seq_len(n_reps), worker)
  }

  est_mat <- do.call(rbind, lapply(res_list, `[[`, "estimate"))
  lo_mat  <- do.call(rbind, lapply(res_list, `[[`, "ci_lower"))
  hi_mat  <- do.call(rbind, lapply(res_list, `[[`, "ci_upper"))
  smd_vec <- vapply(res_list, function(r) r$smd_est, numeric(1))
  list(estimate = est_mat, ci_lower = lo_mat, ci_upper = hi_mat,
       smd_est = smd_vec)
}

summarize_cell_with_smd <- function(cell_out, true_nabcd_named, true_smd) {
  out <- summarize_cell(cell_out, true_nabcd_named)
  smd_est <- cell_out$smd_est
  smd_row <- data.frame(
    normalizer    = "SMD",
    true_nABCD    = true_smd,
    mean_est      = mean(smd_est, na.rm = TRUE),
    bias          = mean(smd_est, na.rm = TRUE) - true_smd,
    rmse          = sqrt(mean((smd_est - true_smd)^2, na.rm = TRUE)),
    sd_est        = sd(smd_est, na.rm = TRUE),
    mean_ci_width = NA_real_,
    coverage_pct  = NA_real_,
    n_valid       = sum(!is.na(smd_est)),
    stringsAsFactors = FALSE
  )
  rbind(out, smd_row)
}

# =============================================================================
# Cell-done check (resume support)
# =============================================================================

.cell_done_redesign <- function(partial, sc_id, n) {
  for (c in partial$cells) {
    if (identical(c$scenario, sc_id) && identical(c$n, n)) return(TRUE)
  }
  FALSE
}

# =============================================================================
# Main pipeline
# =============================================================================

main_redesign <- function(n_reps = 10000L, B = 1000L,
                            sample_sizes = c(50L, 100L, 200L),
                            cores = 5L, seed_base = 42L,
                            partial_file = "results/normalizer_comparison_redesign_partial.rds",
                            final_file = "results/normalizer_comparison_redesign.rds") {

  cat("==========================================================\n")
  cat(" Redesign Simulation (N1-N8) — Rcpp + SMD tracking\n")
  cat("==========================================================\n")
  cat(sprintf(" reps=%d  B=%d  cores=%d  scenarios=%d × n=%d → cells=%d\n",
              n_reps, B, cores, length(scenarios_redesign), length(sample_sizes),
              length(scenarios_redesign) * length(sample_sizes)))
  cat(sprintf(" started: %s\n", format(Sys.time())))

  if (!dir.exists("results")) dir.create("results", recursive = TRUE)

  # Load truth values (precomputed by compute_redesign_truth.R)
  if (!file.exists("results/true_redesign.rds") ||
      !file.exists("results/smd_redesign.rds")) {
    stop("Truth files missing. Run compute_redesign_truth.R first.")
  }
  true_df <- readRDS("results/true_redesign.rds")
  smd_df  <- readRDS("results/smd_redesign.rds")

  # Cluster
  cl <- setup_cluster(cores)
  on.exit({
    if (!is.null(cl)) try(parallel::stopCluster(cl), silent = TRUE)
  }, add = TRUE)

  # Resume
  if (file.exists(partial_file)) {
    partial <- readRDS(partial_file)
    if (!identical(partial$grid, "redesign")) {
      partial <- list(grid = "redesign", started = Sys.time(), cells = list())
    } else {
      cat(sprintf("[redesign] resuming — %d cells already done\n",
                  length(partial$cells)))
    }
  } else {
    partial <- list(grid = "redesign", started = Sys.time(), cells = list())
  }

  rows <- lapply(partial$cells, function(c) c$summary)

  scen_ids <- names(scenarios_redesign)
  total_cells <- length(scen_ids) * length(sample_sizes)
  k <- 0L

  for (sc_id in scen_ids) {
    sc <- scenarios_redesign[[sc_id]]
    truth_named <- setNames(
      true_df$true_nABCD[true_df$scenario == sc_id][match(NORMALIZERS,
        true_df$normalizer[true_df$scenario == sc_id])],
      NORMALIZERS
    )
    true_smd <- smd_df$population_smd[smd_df$scenario == sc_id]

    for (n in sample_sizes) {
      k <- k + 1L
      if (.cell_done_redesign(partial, sc_id, n)) {
        cat(sprintf("[redesign %d/%d] %s n=%d ... already done, skip\n",
                    k, total_cells, sc_id, n))
        next
      }
      cat(sprintf("[redesign %d/%d] %s n=%d ... ", k, total_cells, sc_id, n))
      tcell <- Sys.time()
      cell <- run_cell_with_smd(sc, n_per_group = n, n_reps = n_reps, B = B,
                                  cluster = cl, seed = seed_base + 1000L * k)
      summ <- summarize_cell_with_smd(cell, truth_named, true_smd)
      summ$scenario <- sc_id
      summ$n        <- n
      summ$grid     <- "Redesign"
      rows[[length(rows) + 1L]] <- summ
      el <- as.numeric(difftime(Sys.time(), tcell, units = "secs"))
      cat(sprintf("done (%.1fs)\n", el))

      partial$cells[[length(partial$cells) + 1L]] <- list(
        scenario = sc_id, n = n, summary = summ, elapsed_s = el
      )
      saveRDS(partial, partial_file)

      # Recycle cluster every cell (verified to prevent worker memory blow-up)
      try(parallel::stopCluster(cl), silent = TRUE)
      cl <- setup_cluster(cores)
    }
  }

  out <- do.call(rbind, rows)
  rownames(out) <- NULL
  saveRDS(out, final_file)
  cat(sprintf("\n[redesign] saved: %s\n", final_file))
  cat(sprintf("[done] finished: %s\n", format(Sys.time())))
  invisible(out)
}

# =============================================================================
# Entry point
# =============================================================================

if (sys.nframe() == 0L) {
  main_redesign()
}
