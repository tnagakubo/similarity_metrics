# =============================================================================
# Validation simulation runner — all 4 experiments (Tak 2026-05-11)
# Total cells (approx):
#   E1: 9 scenarios × 3 n = 27
#   E2: 5 scenarios × 3 n = 15
#   E3: 7 scenarios × 3 n = 21
#   E4: 9 scenarios × 1 n = 9
#   Total ≈ 72 cells, ~75-90 min with Rcpp + 5 cores.
# Output: results/normalizer_comparison_validation.rds
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
source(file.path(ROOT, "scenarios_validation.R"),    chdir = TRUE)
source(file.path(ROOT, "true_normalizers.R"),        chdir = TRUE)
source(file.path(ROOT, "run_normalizer_comparison.R"))
options(nabcd.use_rcpp = TRUE)
stopifnot(exists("nABCD_bootstrap_5norm_cpp"))

# =============================================================================
# Setup_cluster needs scenarios_validation.R on workers
# =============================================================================
setup_cluster_validation <- function(n_cores) {
  if (n_cores <= 1L) return(NULL)
  cat(sprintf("[cluster] starting PSOCK with %d workers (validation)...\n", n_cores))
  cl <- parallel::makeCluster(n_cores, type = "PSOCK")
  parallel::clusterEvalQ(cl, {
    SKIP_SIMULATION <- TRUE
    suppressPackageStartupMessages({
      if (requireNamespace("Rfast", quietly = TRUE)) library(Rfast)
    })
  })
  parallel::clusterCall(cl, function(root) {
    SKIP_SIMULATION <<- TRUE
    source(file.path(root, "simulation_manuscript_v2.R"), chdir = TRUE)
    source(file.path(root, "nabcd_normalizers.R"),       chdir = TRUE)
    source(file.path(root, "scenarios_validation.R"),    chdir = TRUE)
    suppressPackageStartupMessages(library(Rcpp))
    Rcpp::sourceCpp(file.path(root, "nABCD_5norm_rcpp.cpp"))
    options(nabcd.use_rcpp = TRUE)
    invisible(TRUE)
  }, root = normalizePath(ROOT))
  parallel::clusterExport(cl,
    varlist = c("single_rep_all_normalizers", "NORMALIZERS"),
    envir = .GlobalEnv)
  cl
}

# =============================================================================
# Cell runner with SMD tracking (reuse from run_redesign_simulation.R)
# =============================================================================
run_cell_v <- function(scenario, n_per_group, n_reps, B, conf = 0.95,
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
    res_list <- parallel::parLapplyLB(cluster, seq_len(n_reps), worker,
        chunk.size = max(1L, n_reps %/% (length(cluster) * 8L)))
  } else {
    set.seed(seed)
    res_list <- lapply(seq_len(n_reps), worker)
  }

  est_mat <- do.call(rbind, lapply(res_list, `[[`, "estimate"))
  lo_mat  <- do.call(rbind, lapply(res_list, `[[`, "ci_lower"))
  hi_mat  <- do.call(rbind, lapply(res_list, `[[`, "ci_upper"))
  smd_vec <- vapply(res_list, function(r) r$smd_est, numeric(1))
  list(estimate = est_mat, ci_lower = lo_mat, ci_upper = hi_mat, smd_est = smd_vec)
}

# =============================================================================
# Compute truth on master (lightweight, no cluster needed)
# =============================================================================
compute_truth_inline <- function(scenario, n_mc = 1e6, seed = 12345) {
  set.seed(seed)
  x <- scenario$dist1(n_mc)
  y <- scenario$dist2(n_mc)
  pooled <- c(x, y)
  w1 <- wasserstein1(x, y)
  denoms <- c(
    IQR   = IQR(pooled),
    Range = diff(range(pooled)),
    Q95Q5 = unname(diff(quantile(pooled, c(0.05, 0.95)))),
    SD    = sd(pooled),
    MAD   = median(abs(pooled - median(pooled)))
  )
  true_n <- ifelse(denoms > 0, w1 / denoms, NA_real_)
  pop_smd <- (mean(y) - mean(x)) / sqrt((var(x) + var(y)) / 2)
  list(true_nABCD = setNames(true_n, names(denoms)),
       true_W1    = w1,
       pop_smd    = pop_smd)
}

# =============================================================================
# Summarize cell (extends summarize_cell to include SMD row)
# =============================================================================
summarize_cell_v <- function(cell_out, truth_named, true_smd) {
  out <- summarize_cell(cell_out, truth_named)
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
# Main
# =============================================================================
main_v <- function(n_reps = 10000L, B = 1000L,
                     cores = 5L, seed_base = 42L,
                     partial_file = "results/normalizer_comparison_validation_partial.rds",
                     final_file = "results/normalizer_comparison_validation.rds",
                     truth_file = "results/true_validation.rds",
                     smd_file = "results/smd_validation.rds") {

  cat("==========================================================\n")
  cat(" Validation Simulation — 4 Experiments (E1-E4)\n")
  cat("==========================================================\n")
  if (!dir.exists("results")) dir.create("results", recursive = TRUE)

  scen_ids <- names(scenarios_validation)
  total_cells <- sum(sapply(scen_ids, function(s) length(sample_sizes_for(s))))
  cat(sprintf(" scenarios=%d, total cells=%d, reps=%d, B=%d, cores=%d\n",
              length(scen_ids), total_cells, n_reps, B, cores))
  cat(sprintf(" started: %s\n", format(Sys.time())))

  # --- Compute / load truth ---
  if (file.exists(truth_file)) {
    cat("[truth] loading existing truth file\n")
    truth_all <- readRDS(truth_file)
    smd_all   <- readRDS(smd_file)
  } else {
    cat("[truth] computing population truth + SMD (MC 10^6)\n")
    truth_all <- list()
    smd_all   <- data.frame(scenario = character(), population_smd = numeric(),
                             stringsAsFactors = FALSE)
    for (i in seq_along(scen_ids)) {
      sc_id <- scen_ids[i]
      cat(sprintf("  [truth %d/%d] %s\n", i, length(scen_ids), sc_id))
      tr <- compute_truth_inline(scenarios_validation[[sc_id]],
                                    n_mc = 1e6, seed = 12345 + i)
      truth_all[[sc_id]] <- tr$true_nABCD
      smd_all <- rbind(smd_all,
                        data.frame(scenario = sc_id,
                                    population_smd = tr$pop_smd,
                                    stringsAsFactors = FALSE))
    }
    saveRDS(truth_all, truth_file)
    saveRDS(smd_all,   smd_file)
  }

  # --- Cluster ---
  cl <- setup_cluster_validation(cores)
  on.exit({ if (!is.null(cl)) try(parallel::stopCluster(cl), silent = TRUE) }, add = TRUE)

  # --- Resume ---
  if (file.exists(partial_file)) {
    partial <- readRDS(partial_file)
    cat(sprintf("[validation] resuming — %d cells already done\n",
                length(partial$cells)))
  } else {
    partial <- list(grid = "validation", started = Sys.time(), cells = list())
  }
  cell_done <- function(sc_id, n) {
    for (c in partial$cells) {
      if (identical(c$scenario, sc_id) && identical(c$n, n)) return(TRUE)
    }
    FALSE
  }

  rows <- lapply(partial$cells, function(c) c$summary)

  k <- 0L
  for (sc_id in scen_ids) {
    sc <- scenarios_validation[[sc_id]]
    truth_named <- truth_all[[sc_id]]
    true_smd <- smd_all$population_smd[smd_all$scenario == sc_id]
    for (n in sample_sizes_for(sc_id)) {
      k <- k + 1L
      if (cell_done(sc_id, as.integer(n))) {
        cat(sprintf("[validation %d/%d] %s n=%d ... already done, skip\n",
                    k, total_cells, sc_id, n))
        next
      }
      cat(sprintf("[validation %d/%d] %s n=%d ... ", k, total_cells, sc_id, n))
      tcell <- Sys.time()
      cell <- run_cell_v(sc, n_per_group = as.integer(n),
                          n_reps = n_reps, B = B,
                          cluster = cl, seed = seed_base + 1000L * k)
      summ <- summarize_cell_v(cell, truth_named, true_smd)
      summ$scenario <- sc_id
      summ$n        <- as.integer(n)
      summ$grid     <- "Validation"
      rows[[length(rows) + 1L]] <- summ
      el <- as.numeric(difftime(Sys.time(), tcell, units = "secs"))
      cat(sprintf("done (%.1fs, n_valid=%d)\n", el, summ$n_valid[1]))

      partial$cells[[length(partial$cells) + 1L]] <- list(
        scenario = sc_id, n = as.integer(n), summary = summ, elapsed_s = el
      )
      saveRDS(partial, partial_file)

      # Recycle cluster
      try(parallel::stopCluster(cl), silent = TRUE)
      cl <- setup_cluster_validation(cores)
    }
  }

  out <- do.call(rbind, rows)
  rownames(out) <- NULL
  saveRDS(out, final_file)
  cat(sprintf("\n[validation] saved: %s\n", final_file))
  cat(sprintf("[done] finished: %s\n", format(Sys.time())))
  invisible(out)
}

if (sys.nframe() == 0L) {
  main_v()
}
