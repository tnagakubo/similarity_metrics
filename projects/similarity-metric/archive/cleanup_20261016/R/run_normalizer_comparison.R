# =============================================================================
# Normalizer Comparison Simulation Pipeline (Phase 5)
# Authors: Mike Ross (Methodologist), Katrina Bennett (Technical Writer)
# Date: 2026-05-10
#
# Two grids:
#   Grid 1 (Standard) : 5 normalizers x 9 scenarios (S1-S9) x 3 sample sizes
#                       = 135 cells
#   Grid 2 (Cross-EM) : 5 normalizers x 3 EMs x 3 delta_sigma x 3 sample sizes
#                       = 135 cells
#
# Per cell: n_reps Monte Carlo reps + B bootstrap replicates per rep.
#
# Defaults (full run): n_reps = 10000, B = 1000.
# CLI flags:
#   --test       small validation (100 reps, B=200, single n, single scenario)
#   --reps=N     override Monte Carlo reps
#   --boot=B     override bootstrap reps
#   --grid=1|2|both   choose grid
#   --cores=K    override worker count
#
# Outputs (RDS):
#   results/normalizer_comparison_grid1.rds
#   results/normalizer_comparison_grid2.rds
#   results/normalizer_comparison_partial.rds  (live partial)
#   results/true_nabcd_per_normalizer.rds       (Phase 2 output)
#   results/true_nabcd_cross_em.rds             (Cross-EM true values)
# =============================================================================

# ---- Suppress kernel auto-run -----------------------------------------------
SKIP_SIMULATION <- TRUE
suppressPackageStartupMessages({
  library(parallel)
})

ROOT <- tryCatch(dirname(sys.frame(1)$ofile), error = function(e) ".")
if (!file.exists(file.path(ROOT, "simulation_manuscript_v2.R"))) {
  ROOT <- "projects/similarity-metric/R"
}
source(file.path(ROOT, "simulation_manuscript_v2.R"), chdir = TRUE)
source(file.path(ROOT, "nabcd_normalizers.R"),       chdir = TRUE)
source(file.path(ROOT, "scenarios_extended.R"),      chdir = TRUE)
source(file.path(ROOT, "cross_em_generators.R"),     chdir = TRUE)
source(file.path(ROOT, "true_normalizers.R"),        chdir = TRUE)

NORMALIZERS <- c("IQR", "Range", "Q95Q5", "SD", "MAD")

# ---- CLI argument parsing ---------------------------------------------------
parse_args <- function(args = commandArgs(trailingOnly = TRUE)) {
  out <- list(
    test  = FALSE,
    reps  = 10000L,
    boot  = 1000L,
    grid  = "both",
    cores = max(1L, parallel::detectCores() - 2L),
    rcpp  = FALSE
  )
  reps_set <- FALSE; boot_set <- FALSE
  for (a in args) {
    if (a == "--test") out$test <- TRUE
    else if (a == "--rcpp") out$rcpp <- TRUE
    else if (grepl("^--reps=",  a)) { out$reps  <- as.integer(sub("^--reps=",  "", a)); reps_set <- TRUE }
    else if (grepl("^--boot=",  a)) { out$boot  <- as.integer(sub("^--boot=",  "", a)); boot_set <- TRUE }
    else if (grepl("^--grid=",  a)) out$grid  <- sub("^--grid=",  "", a)
    else if (grepl("^--cores=", a)) out$cores <- as.integer(sub("^--cores=", "", a))
  }
  if (out$test) {
    if (!reps_set) out$reps <- 100L
    if (!boot_set) out$boot <- 200L
  }
  out
}

OPTS <- parse_args()

# =============================================================================
# Single rep (all-normalizer): for one (x, y) draw, return point estimate +
# percentile bootstrap CI per normalizer.
# =============================================================================

single_rep_all_normalizers <- function(x, y, B = 1000, conf = 0.95) {
  # Dispatch to Rcpp when enabled (verified bit-exact for point estimates,
  # CI within ~O(0.01) due to RNG path ordering — see verify_5norm_rcpp.R).
  if (isTRUE(getOption("nabcd.use_rcpp", FALSE)) &&
      exists("nABCD_bootstrap_5norm_cpp", inherits = TRUE)) {
    res <- nABCD_bootstrap_5norm_cpp(x, y, B = as.integer(B), conf = conf)
    return(list(estimate = res$estimate,
                ci_lower = res$ci_lower,
                ci_upper = res$ci_upper))
  }

  n1 <- length(x); n2 <- length(y); n_total <- n1 + n2
  pooled <- c(x, y)

  # Point estimates per normalizer (reuse W1)
  w1_obs <- wasserstein1(x, y)
  denom_obs <- c(
    IQR   = IQR(pooled),
    Range = diff(range(pooled)),
    Q95Q5 = unname(diff(quantile(pooled, c(0.05, 0.95)))),
    SD    = sd(pooled),
    MAD   = median(abs(pooled - median(pooled)))
  )
  est <- ifelse(is.finite(denom_obs) & denom_obs > 0,
                w1_obs / denom_obs, NA_real_)
  names(est) <- NORMALIZERS

  # Bootstrap matrices: x_raw, y_raw of dim n1 x B / n2 x B
  x_raw <- matrix(x[sample.int(n1, n1 * B, replace = TRUE)], nrow = n1)
  y_raw <- matrix(y[sample.int(n2, n2 * B, replace = TRUE)], nrow = n2)

  # Sort columns (use Rfast::colSort if available else apply-sort)
  csort <- if (exists("col_sort", envir = .GlobalEnv)) get("col_sort", envir = .GlobalEnv)
           else if (requireNamespace("Rfast", quietly = TRUE)) Rfast::colSort
           else function(m) apply(m, 2, sort)
  x_s <- csort(x_raw); y_s <- csort(y_raw)

  # W1 per bootstrap (equal n: vectorized colMeans)
  if (n1 == n2) {
    w1_boot <- colMeans(abs(x_s - y_s))
  } else {
    w1_boot <- vapply(seq_len(B), function(b)
      wasserstein1(x_raw[, b], y_raw[, b]), numeric(1))
  }

  # Pooled bootstrap matrix for denominators
  pooled_raw <- rbind(x_raw, y_raw)             # n_total x B
  pooled_s   <- csort(pooled_raw)

  # IQR bootstrap (type=7 quantile from sorted vector)
  h1 <- (n_total - 1) * 0.25 + 1
  h3 <- (n_total - 1) * 0.75 + 1
  f1 <- floor(h1); f3 <- floor(h3)
  q1 <- pooled_s[f1, ] + (h1 - f1) * (pooled_s[f1 + 1L, ] - pooled_s[f1, ])
  q3 <- pooled_s[f3, ] + (h3 - f3) * (pooled_s[f3 + 1L, ] - pooled_s[f3, ])
  iqr_boot <- q3 - q1

  # Range
  range_boot <- pooled_s[n_total, ] - pooled_s[1L, ]

  # Q95-Q5
  h05 <- (n_total - 1) * 0.05 + 1
  h95 <- (n_total - 1) * 0.95 + 1
  f05 <- floor(h05); f95 <- floor(h95)
  q05 <- pooled_s[f05, ] + (h05 - f05) * (pooled_s[f05 + 1L, ] - pooled_s[f05, ])
  q95 <- if (f95 < n_total) {
    pooled_s[f95, ] + (h95 - f95) * (pooled_s[f95 + 1L, ] - pooled_s[f95, ])
  } else {
    pooled_s[n_total, ]
  }
  q9505_boot <- q95 - q05

  # SD
  sd_boot <- sqrt(.colMeans((pooled_raw - rep(.colMeans(pooled_raw, n_total, B),
                                              each = n_total))^2,
                            n_total, B) * n_total / (n_total - 1))

  # MAD: c=1, median of |x - median(x)|
  # median per column from sorted matrix
  if (n_total %% 2L == 1L) {
    med_pooled <- pooled_s[(n_total + 1L) / 2L, ]
  } else {
    med_pooled <- 0.5 * (pooled_s[n_total / 2L, ] + pooled_s[n_total / 2L + 1L, ])
  }
  abs_dev <- abs(pooled_raw - rep(med_pooled, each = n_total))
  abs_dev_s <- csort(abs_dev)
  if (n_total %% 2L == 1L) {
    mad_boot <- abs_dev_s[(n_total + 1L) / 2L, ]
  } else {
    mad_boot <- 0.5 * (abs_dev_s[n_total / 2L, ] + abs_dev_s[n_total / 2L + 1L, ])
  }

  # nABCD per normalizer per bootstrap
  alpha <- 1 - conf; lo <- alpha / 2; hi <- 1 - alpha / 2
  ci_lo <- numeric(length(NORMALIZERS)); ci_hi <- numeric(length(NORMALIZERS))
  names(ci_lo) <- NORMALIZERS; names(ci_hi) <- NORMALIZERS

  for (norm in NORMALIZERS) {
    den_boot <- switch(norm,
      IQR   = iqr_boot,
      Range = range_boot,
      Q95Q5 = q9505_boot,
      SD    = sd_boot,
      MAD   = mad_boot
    )
    valid <- is.finite(den_boot) & den_boot > 0
    vals <- rep(NA_real_, B)
    vals[valid] <- w1_boot[valid] / den_boot[valid]
    vals <- vals[!is.na(vals)]
    if (length(vals) < 10L) {
      ci_lo[norm] <- NA_real_; ci_hi[norm] <- NA_real_
    } else {
      qq <- quantile(vals, c(lo, hi))
      ci_lo[norm] <- max(0, unname(qq[1]))
      ci_hi[norm] <- unname(qq[2])
    }
  }

  list(estimate = est, ci_lower = ci_lo, ci_upper = ci_hi)
}

# =============================================================================
# Cell runner (one scenario, one n) — MC reps in parallel
# =============================================================================

run_cell <- function(scenario, n_per_group, n_reps, B, conf = 0.95,
                     cluster = NULL, seed = 42) {
  # Build a closure with a clean env (no OPTS / other parent bindings)
  worker_env <- new.env(parent = globalenv())
  worker_env$scenario     <- scenario
  worker_env$n_per_group  <- n_per_group
  worker_env$B            <- B
  worker_env$conf         <- conf
  worker <- function(rep_id) {
    # NA structure if anything fails — never kill the worker
    na_vec <- setNames(rep(NA_real_, length(NORMALIZERS)), NORMALIZERS)
    out <- tryCatch({
      x <- scenario$dist1(n_per_group)
      y <- scenario$dist2(n_per_group)
      single_rep_all_normalizers(x, y, B = B, conf = conf)
    }, error = function(e) {
      list(estimate = na_vec, ci_lower = na_vec, ci_upper = na_vec)
    })
    # Periodic GC to keep worker memory bounded over thousands of reps
    if (rep_id %% 500L == 0L) gc(verbose = FALSE, full = TRUE)
    out
  }
  environment(worker) <- worker_env

  if (!is.null(cluster)) {
    parallel::clusterSetRNGStream(cluster, iseed = seed)
    # Chunked parLapply with worker recycling on failure
    res_list <- tryCatch(
      parallel::parLapplyLB(cluster, seq_len(n_reps), worker,
                             chunk.size = max(1L, n_reps %/% (length(cluster) * 8L))),
      error = function(e) {
        # Worker died — fall back to sequential for this cell
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

  # Aggregate to matrices: reps x normalizers
  est_mat <- do.call(rbind, lapply(res_list, `[[`, "estimate"))
  lo_mat  <- do.call(rbind, lapply(res_list, `[[`, "ci_lower"))
  hi_mat  <- do.call(rbind, lapply(res_list, `[[`, "ci_upper"))
  list(estimate = est_mat, ci_lower = lo_mat, ci_upper = hi_mat)
}

# =============================================================================
# Summarize cell vs true values
# =============================================================================

summarize_cell <- function(cell_out, true_nabcd_named) {
  out <- list()
  for (norm in NORMALIZERS) {
    est <- cell_out$estimate[, norm]
    lo  <- cell_out$ci_lower[, norm]
    hi  <- cell_out$ci_upper[, norm]
    truth <- unname(true_nabcd_named[norm])
    bias <- mean(est, na.rm = TRUE) - truth
    rmse <- sqrt(mean((est - truth)^2, na.rm = TRUE))
    sd_e <- sd(est, na.rm = TRUE)
    ciw  <- mean(hi - lo, na.rm = TRUE)
    cov  <- mean(lo <= truth & truth <= hi, na.rm = TRUE)
    out[[norm]] <- data.frame(
      normalizer = norm,
      true_nABCD = truth,
      mean_est   = mean(est, na.rm = TRUE),
      bias       = bias,
      rmse       = rmse,
      sd_est     = sd_e,
      mean_ci_width = ciw,
      coverage_pct  = cov,
      n_valid       = sum(!is.na(est)),
      stringsAsFactors = FALSE
    )
  }
  do.call(rbind, out)
}

# =============================================================================
# Cluster setup & teardown
# =============================================================================

setup_cluster <- function(n_cores) {
  if (n_cores <= 1L) return(NULL)
  cat(sprintf("[cluster] starting PSOCK with %d workers...\n", n_cores))
  cl <- parallel::makeCluster(n_cores, type = "PSOCK")

  use_rcpp <- isTRUE(getOption("nabcd.use_rcpp", FALSE))

  # Workers need the kernel + helpers
  parallel::clusterEvalQ(cl, {
    SKIP_SIMULATION <- TRUE
    suppressPackageStartupMessages({
      if (requireNamespace("Rfast", quietly = TRUE)) library(Rfast)
    })
  })

  parallel::clusterCall(cl, function(root, use_rcpp) {
    SKIP_SIMULATION <<- TRUE
    source(file.path(root, "simulation_manuscript_v2.R"), chdir = TRUE)
    source(file.path(root, "nabcd_normalizers.R"),       chdir = TRUE)
    source(file.path(root, "scenarios_extended.R"),      chdir = TRUE)
    source(file.path(root, "cross_em_generators.R"),     chdir = TRUE)
    redesign_path <- file.path(root, "scenarios_redesign.R")
    if (file.exists(redesign_path)) {
      source(redesign_path, chdir = TRUE)
    }
    if (isTRUE(use_rcpp)) {
      suppressPackageStartupMessages(library(Rcpp))
      Rcpp::sourceCpp(file.path(root, "nABCD_5norm_rcpp.cpp"))
      options(nabcd.use_rcpp = TRUE)
    }
    invisible(TRUE)
  }, root = normalizePath(ROOT), use_rcpp = use_rcpp)

  # Export the per-rep function (defined at the main script's top level —
  # workers don't see it from sourcing the helpers).
  parallel::clusterExport(cl,
    varlist = c("single_rep_all_normalizers", "NORMALIZERS"),
    envir = .GlobalEnv)

  cl
}

# =============================================================================
# Grid 1: Standard scenarios S1-S9
# =============================================================================

.cell_done <- function(partial, sc_id, n) {
  for (c in partial$cells) {
    if (identical(c$scenario, sc_id) && identical(c$n, n)) return(TRUE)
  }
  FALSE
}

run_grid1 <- function(scenarios_list, true_df,
                      sample_sizes = c(50, 100, 200),
                      n_reps = 10000, B = 1000,
                      cluster = NULL, seed_base = 42,
                      partial_file = "results/normalizer_comparison_grid1_partial.rds",
                      n_cores_for_recycle = NULL) {

  # Resume support: load existing partial if present
  if (file.exists(partial_file)) {
    partial <- readRDS(partial_file)
    if (is.null(partial$grid) || partial$grid != 1) {
      partial <- list(grid = 1, started = Sys.time(), cells = list())
    } else {
      cat(sprintf("[grid1] resuming — %d cells already done\n",
                  length(partial$cells)))
    }
  } else {
    partial <- list(grid = 1, started = Sys.time(), cells = list())
  }

  rows <- lapply(partial$cells, function(c) c$summary)

  scenario_ids <- names(scenarios_list)
  total_cells <- length(scenario_ids) * length(sample_sizes)
  k <- 0L

  for (sc_id in scenario_ids) {
    sc <- scenarios_list[[sc_id]]
    truth_named <- setNames(
      true_df$true_nABCD[true_df$scenario == sc_id][match(NORMALIZERS,
        true_df$normalizer[true_df$scenario == sc_id])],
      NORMALIZERS
    )
    for (n in sample_sizes) {
      k <- k + 1L
      if (.cell_done(partial, sc_id, n)) {
        cat(sprintf("[grid1 %d/%d] %s n=%d ... already done, skip\n",
                    k, total_cells, sc_id, n))
        next
      }
      cat(sprintf("[grid1 %d/%d] %s n=%d ... ", k, total_cells, sc_id, n))
      tcell <- Sys.time()
      cell <- run_cell(sc, n_per_group = n, n_reps = n_reps, B = B,
                       cluster = cluster, seed = seed_base + 1000L * k)
      summ <- summarize_cell(cell, truth_named)
      summ$scenario   <- sc_id
      summ$n          <- n
      summ$grid       <- "Grid1_Standard"
      rows[[length(rows) + 1L]] <- summ
      el <- as.numeric(difftime(Sys.time(), tcell, units = "secs"))
      cat(sprintf("done (%.1fs)\n", el))

      partial$cells[[length(partial$cells) + 1L]] <- list(
        scenario = sc_id, n = n, summary = summ, elapsed_s = el
      )
      saveRDS(partial, partial_file)

      # Recycle cluster every cell to prevent worker memory blow-up
      if (!is.null(cluster) && !is.null(n_cores_for_recycle)) {
        cat("[grid1] recycling cluster ...\n")
        try(parallel::stopCluster(cluster), silent = TRUE)
        cluster <- setup_cluster(n_cores_for_recycle)
        # Caller's cluster handle is now stale; we update the local copy.
        # Return the new cluster at the end? — see below: we expose via attr.
      }
    }
  }

  out <- do.call(rbind, rows)
  rownames(out) <- NULL
  attr(out, "cluster") <- cluster   # caller picks up the (possibly new) cluster
  out
}

# =============================================================================
# Grid 2: Cross-EM
# =============================================================================

run_grid2 <- function(cross_scenarios, true_df,
                      sample_sizes = c(50, 100, 200),
                      n_reps = 10000, B = 1000,
                      cluster = NULL, seed_base = 42 + 1e6,
                      partial_file = "results/normalizer_comparison_grid2_partial.rds",
                      n_cores_for_recycle = NULL) {

  if (file.exists(partial_file)) {
    partial <- readRDS(partial_file)
    if (is.null(partial$grid) || partial$grid != 2) {
      partial <- list(grid = 2, started = Sys.time(), cells = list())
    } else {
      cat(sprintf("[grid2] resuming — %d cells already done\n",
                  length(partial$cells)))
    }
  } else {
    partial <- list(grid = 2, started = Sys.time(), cells = list())
  }

  rows <- lapply(partial$cells, function(c) c$summary)

  ids <- names(cross_scenarios)
  total_cells <- length(ids) * length(sample_sizes)
  k <- 0L

  for (id in ids) {
    sc <- cross_scenarios[[id]]
    truth_named <- setNames(
      true_df$true_nABCD[true_df$scenario == id][match(NORMALIZERS,
        true_df$normalizer[true_df$scenario == id])],
      NORMALIZERS
    )
    for (n in sample_sizes) {
      k <- k + 1L
      if (.cell_done(partial, id, n)) {
        cat(sprintf("[grid2 %d/%d] %s n=%d ... already done, skip\n",
                    k, total_cells, id, n))
        next
      }
      cat(sprintf("[grid2 %d/%d] %s n=%d ... ", k, total_cells, id, n))
      tcell <- Sys.time()
      cell <- run_cell(sc, n_per_group = n, n_reps = n_reps, B = B,
                       cluster = cluster, seed = seed_base + 1000L * k)
      summ <- summarize_cell(cell, truth_named)
      summ$scenario <- id
      summ$n        <- n
      summ$grid     <- "Grid2_CrossEM"
      rows[[length(rows) + 1L]] <- summ
      el <- as.numeric(difftime(Sys.time(), tcell, units = "secs"))
      cat(sprintf("done (%.1fs)\n", el))

      partial$cells[[length(partial$cells) + 1L]] <- list(
        scenario = id, n = n, summary = summ, elapsed_s = el
      )
      saveRDS(partial, partial_file)

      if (!is.null(cluster) && !is.null(n_cores_for_recycle)) {
        cat("[grid2] recycling cluster ...\n")
        try(parallel::stopCluster(cluster), silent = TRUE)
        cluster <- setup_cluster(n_cores_for_recycle)
      }
    }
  }
  out <- do.call(rbind, rows)
  rownames(out) <- NULL
  attr(out, "cluster") <- cluster
  out
}

# =============================================================================
# Main
# =============================================================================

main <- function() {
  cat("==========================================================\n")
  cat(" Normalizer Comparison Pipeline (Phase 5)\n")
  cat("==========================================================\n")
  cat(sprintf(" reps=%d  B=%d  grid=%s  cores=%d  test=%s  rcpp=%s\n",
              OPTS$reps, OPTS$boot, OPTS$grid, OPTS$cores, OPTS$test, OPTS$rcpp))
  cat(sprintf(" started: %s\n", format(Sys.time())))

  if (!dir.exists("results")) dir.create("results", recursive = TRUE)
  if (!dir.exists("logs"))    dir.create("logs",    recursive = TRUE)

  # ---- Rcpp compilation (master) -------------------------------------------
  if (isTRUE(OPTS$rcpp)) {
    cpp_file <- file.path(ROOT, "nABCD_5norm_rcpp.cpp")
    cat(sprintf("[main] Rcpp mode: compiling %s ...\n", cpp_file))
    suppressPackageStartupMessages(library(Rcpp))
    Rcpp::sourceCpp(cpp_file)
    options(nabcd.use_rcpp = TRUE)
    cat("[main] Rcpp compiled, nabcd.use_rcpp = TRUE\n")
  }

  # --- Phase 3 scenarios ---
  scenarios_v2 <- compute_true_values_v2(scenarios_v2, n_mc = 1e6, seed = 12345)

  # --- Phase 2 true values per normalizer ---
  cat("[true-norm] computing population true values per normalizer...\n")
  true_df_grid1 <- compute_all_true_normalizers(
    scenarios_v2, n_mc = 1e6, seed_base = 12345,
    out_file = "results/true_nabcd_per_normalizer.rds", verbose = TRUE
  )
  print(true_df_grid1)

  # --- Cross-EM scenarios ---
  cross_scenarios <- build_cross_em_scenarios()
  cat("[true-norm] cross-EM true values...\n")
  true_df_grid2 <- compute_all_true_normalizers(
    cross_scenarios, n_mc = 1e6, seed_base = 54321,
    out_file = "results/true_nabcd_cross_em.rds", verbose = TRUE
  )

  # --- Cluster ---
  cl <- setup_cluster(OPTS$cores)
  on.exit({
    if (!is.null(cl)) try(parallel::stopCluster(cl), silent = TRUE)
  }, add = TRUE)

  # --- Test mode: probe across (n=50, 100, 200) for timing extrapolation ---
  if (OPTS$test) {
    cat("\n[TEST MODE] S3 across n in {50,100,200}; reps=", OPTS$reps,
        " B=", OPTS$boot, "\n", sep = "")
    truth <- setNames(
      true_df_grid1$true_nABCD[true_df_grid1$scenario == "S3"][
        match(NORMALIZERS, true_df_grid1$normalizer[true_df_grid1$scenario == "S3"])
      ],
      NORMALIZERS
    )
    timings <- list()
    for (n in c(50, 100, 200)) {
      t0 <- Sys.time()
      cell <- run_cell(scenarios_v2[["S3"]], n, n_reps = OPTS$reps,
                       B = OPTS$boot, cluster = cl, seed = 1 + n)
      el <- as.numeric(difftime(Sys.time(), t0, units = "secs"))
      timings[[as.character(n)]] <- list(elapsed_s = el,
                                          per_rep_s = el / OPTS$reps,
                                          summary = summarize_cell(cell, truth))
      cat(sprintf("[TEST] n=%3d  elapsed=%.2fs  (%.4fs/rep)\n",
                  n, el, el / OPTS$reps))
    }
    # extrapolate to full grid (270 cells; assume mean per_rep across 3 n's)
    per_rep_mean <- mean(vapply(timings, function(t) t$per_rep_s, numeric(1)))
    total_cells  <- 9 * 3 + 9 * 3  # Grid1 + Grid2
    full_seconds <- total_cells * (10000L / OPTS$reps) * (OPTS$reps * per_rep_mean) /
                    (parallel::detectCores() / OPTS$cores * 1)  # approx adj
    # simpler: full = total_cells * 10000 reps / cores * per_rep_serial
    # per_rep_mean is parallel-wallclock per rep at OPTS$cores; scale linearly
    full_s_alt <- total_cells * 10000L * per_rep_mean
    cat(sprintf("[TEST] mean per-rep = %.4fs (parallel wallclock @ %d cores)\n",
                per_rep_mean, OPTS$cores))
    cat(sprintf("[TEST] extrapolated full grid (270 cells, 10k reps each): %.1f hours\n",
                full_s_alt / 3600))
    saveRDS(list(timings = timings,
                 per_rep_mean = per_rep_mean,
                 extrapolated_full_hours = full_s_alt / 3600,
                 cores = OPTS$cores),
            "results/test_run_summary.rds")
    cat("[TEST] saved results/test_run_summary.rds\n")
    return(invisible(timings))
  }

  # --- Grid 1 ---
  if (OPTS$grid %in% c("1", "both")) {
    cat("\n=== Grid 1 (Standard, S1-S9) ===\n")
    g1 <- run_grid1(scenarios_v2, true_df_grid1,
                    n_reps = OPTS$reps, B = OPTS$boot, cluster = cl,
                    n_cores_for_recycle = OPTS$cores)
    cl <- attr(g1, "cluster")
    attr(g1, "cluster") <- NULL
    saveRDS(g1, "results/normalizer_comparison_grid1.rds")
    cat("[grid1] saved results/normalizer_comparison_grid1.rds\n")
  }

  # --- Grid 2 ---
  if (OPTS$grid %in% c("2", "both")) {
    cat("\n=== Grid 2 (Cross-EM) ===\n")
    g2 <- run_grid2(cross_scenarios, true_df_grid2,
                    n_reps = OPTS$reps, B = OPTS$boot, cluster = cl,
                    n_cores_for_recycle = OPTS$cores)
    cl <- attr(g2, "cluster")
    attr(g2, "cluster") <- NULL
    saveRDS(g2, "results/normalizer_comparison_grid2.rds")
    cat("[grid2] saved results/normalizer_comparison_grid2.rds\n")
  }

  cat(sprintf("\n[done] finished: %s\n", format(Sys.time())))
}

# Run main() only when invoked directly via Rscript (sys.nframe() == 0).
# When source()'d from another script (e.g. compare_rcpp_vs_r.R,
# verify_5norm_rcpp.R), sys.nframe() > 0 so main() is skipped — and the
# self-set SKIP_SIMULATION above does not interfere with this guard.
if (sys.nframe() == 0L) {
  main()
}
