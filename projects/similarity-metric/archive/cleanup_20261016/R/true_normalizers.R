# =============================================================================
# Population (true) Normalizer Pre-Compute (Phase 2)
# Authors: Mike Ross (Methodologist)
# Date: 2026-05-10
#
# Purpose:
#   For each (scenario, normalizer) pair compute the population true value
#       true_nABCD_X = W1(F1, F2) / X_pop(0.5*F1 + 0.5*F2)
#   where X_pop is the population normalizer of the equal-weighted MIXTURE.
#
#   Monte Carlo with n = 1e6 single-shot per scenario, fixed seed.
#
# Output:
#   results/true_nabcd_per_normalizer.rds
#   data.frame(scenario, normalizer, true_W1, true_normalizer, true_nABCD)
# =============================================================================

# --- Source kernels (idempotent; only if not already loaded) ----------------
# Suppress auto-run inside simulation_manuscript_v2.R
if (!exists("SKIP_SIMULATION", envir = .GlobalEnv)) {
  assign("SKIP_SIMULATION", TRUE, envir = .GlobalEnv)
}
if (!exists("wasserstein1", mode = "function") ||
    !exists("compute_nABCD_all", mode = "function") ||
    !exists("scenarios_v2", mode = "list")) {
  .dir_here <- tryCatch(dirname(sys.frame(1)$ofile), error = function(e) NULL)
  .find_file <- function(name) {
    cands <- c(
      if (!is.null(.dir_here)) file.path(.dir_here, name),
      file.path("projects/similarity-metric/R", name),
      file.path("R", name),
      name
    )
    for (p in cands) if (file.exists(p)) return(p)
    stop("Could not locate ", name, " from ", getwd())
  }
  .kernel <- .find_file("simulation_manuscript_v2.R")
  if (!exists("wasserstein1", mode = "function"))    source(.kernel, chdir = TRUE)
  .norms <- .find_file("nabcd_normalizers.R")
  if (!exists("compute_nABCD_all", mode = "function")) source(.norms, chdir = TRUE)
  .scn <- tryCatch(.find_file("scenarios_extended.R"), error = function(e) NULL)
  if (!is.null(.scn) && !exists("scenarios_v2", mode = "list"))
    source(.scn, chdir = TRUE)
}

NORMALIZER_LIST <- c("IQR", "Range", "Q95Q5", "SD", "MAD")

# =============================================================================
# Per-scenario population computation
# =============================================================================

#' Compute population (true) values for one scenario across all 5 normalizers.
#'
#' Strategy:
#'   - Draw n_mc samples from F1 and F2.
#'   - W1 estimated by wasserstein1() on the two empirical samples (n=1e6
#'     gives a near-population value; standard error is O(1/sqrt(n))).
#'   - Each normalizer X_pop is computed on the EMPIRICAL MIXTURE c(x, y),
#'     which is a Monte Carlo estimate of X_pop(0.5*F1 + 0.5*F2).
#'
#' For "Range" the population normalizer of unbounded F is infinite; we
#' compute the empirical Range here, which is the relevant quantity for
#' "true value at large n" comparison. We document the finite-n nature in
#' the paper.
compute_true_for_scenario <- function(scenario, n_mc = 1e6, seed = 12345) {
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
  data.frame(
    normalizer      = names(denoms),
    true_W1         = w1,
    true_normalizer = unname(denoms),
    true_nABCD      = ifelse(denoms > 0, w1 / unname(denoms), NA_real_),
    stringsAsFactors = FALSE
  )
}

# =============================================================================
# Driver: iterate scenarios, save RDS
# =============================================================================

compute_all_true_normalizers <- function(scenario_list,
                                          n_mc = 1e6,
                                          seed_base = 12345,
                                          out_file = "results/true_nabcd_per_normalizer.rds",
                                          verbose = TRUE) {
  if (!dir.exists(dirname(out_file))) dir.create(dirname(out_file), recursive = TRUE)
  rows <- list()
  ids <- names(scenario_list)
  for (i in seq_along(ids)) {
    id <- ids[i]
    if (verbose) cat(sprintf("[true] %s (%d/%d) ...\n", id, i, length(ids)))
    df <- compute_true_for_scenario(scenario_list[[id]],
                                    n_mc = n_mc,
                                    seed = seed_base + i)
    df$scenario <- id
    rows[[id]] <- df[, c("scenario", "normalizer", "true_W1",
                          "true_normalizer", "true_nABCD")]
  }
  out <- do.call(rbind, rows)
  rownames(out) <- NULL
  saveRDS(out, out_file)
  if (verbose) cat("[true] saved:", out_file, "\n")
  invisible(out)
}

# =============================================================================
# Run if invoked directly
# =============================================================================

if (isTRUE(as.logical(Sys.getenv("RUN_TRUE_NORMALIZERS", "FALSE")))) {
  if (!exists("scenarios_v2", mode = "list")) {
    if (file.exists("projects/similarity-metric/R/scenarios_extended.R")) {
      source("projects/similarity-metric/R/scenarios_extended.R")
    } else {
      stop("scenarios_extended.R not found and scenarios_v2 not loaded.")
    }
  }
  out <- compute_all_true_normalizers(scenarios_v2, n_mc = 1e6,
                                      out_file = "results/true_nabcd_per_normalizer.rds")
  print(out)
}
