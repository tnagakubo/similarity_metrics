# =============================================================================
# Extended Scenario Definitions S1-S9 (Phase 3)
# Authors: Mike Ross (Methodologist)
# Date: 2026-05-10
#
# - S1-S7 imported from canonical scenarios in simulation_manuscript_v2.R
#   (without modification — canonical reference)
# - S8 (Outlier) : 0.99*N(0,1) + 0.01*Bern(±5) mixture, F2 = same shifted 0.5σ
#   Note on σ choice: scale of mixture component is 1, so a "0.5σ" location
#   shift is 0.5 in the same units (mean shift of 0.5).
# - S9 (Gamma)   : Gamma(shape=2, scale=1) vs Gamma(shape=2, scale=1.5)
#
# S6 Skew-Normal moment-match note:
#   Canonical S6 uses LOG-NORMAL (rlnorm) with sigma_ln=0.5, NOT skew-normal.
#   For the brief's "moment-match check" we expose a separate helper
#   make_skewnormal_moment_matched() which uses sn::cp2dp() to convert
#   centered-parameters (mean, sd, skewness) → direct parameters (xi, omega,
#   alpha) for any future SN-based scenario. S6 itself is left untouched
#   (log-normal kept as the canonical biomarker shape).
# =============================================================================

# --- Source canonical kernel & guard against auto-run ------------------------
if (!exists("SKIP_SIMULATION", envir = .GlobalEnv)) {
  assign("SKIP_SIMULATION", TRUE, envir = .GlobalEnv)
}
if (!exists("wasserstein1", mode = "function") ||
    !exists("compute_nABCD", mode = "function") ||
    !exists("scenarios", mode = "list")) {
  .dir_here <- tryCatch(dirname(sys.frame(1)$ofile), error = function(e) ".")
  .kernel <- file.path(.dir_here, "simulation_manuscript_v2.R")
  if (!file.exists(.kernel)) .kernel <- "projects/similarity-metric/R/simulation_manuscript_v2.R"
  source(.kernel, local = FALSE, chdir = TRUE)
}

# =============================================================================
# Skew-Normal moment-matched generator (helper, uses sn::cp2dp)
# =============================================================================

#' Make a skew-normal sampler with target (mean, sd, skewness)
#'
#' Uses sn::cp2dp() to convert from centered parameters (CP) — which are
#' (mean, sd, gamma1) — to direct parameters (DP = xi, omega, alpha) used
#' by sn::rsn().
#'
#' Skewness gamma1 is constrained to |gamma1| < 0.9952719... for SN; we clamp.
#'
#' @return function(n) returning n SN draws with the requested moments.
make_skewnormal_moment_matched <- function(mean = 0, sd = 1, skewness = 1.0) {
  if (!requireNamespace("sn", quietly = TRUE)) {
    stop("Package 'sn' is required for moment-matched Skew-Normal scenarios.")
  }
  gamma1_max <- 0.9952718  # SN skewness upper bound (one-sided)
  g <- max(-gamma1_max, min(gamma1_max, skewness))
  dp <- sn::cp2dp(c(mean = mean, s.d. = sd, gamma1 = g), family = "SN")
  function(n) sn::rsn(n, xi = dp[["xi"]], omega = dp[["omega"]], alpha = dp[["alpha"]])
}

# =============================================================================
# S8: Outlier scenario (contamination mixture)
# =============================================================================

#' Sampler for the outlier mixture: 0.99 * N(loc, 1) + 0.01 * Bernoulli(±5)
#'
#' The 1% contamination is at ±5 (sign uniform), recentered to add `loc`
#' shift to the bulk mean (matches Tak's spec: "F2 same mixture shifted 0.5σ").
sample_outlier_mixture <- function(n, loc = 0) {
  is_outlier <- rbinom(n, size = 1, prob = 0.01)
  bulk    <- rnorm(n, mean = loc, sd = 1)
  outlier <- (2 * rbinom(n, size = 1, prob = 0.5) - 1) * 5 + loc  # ±5 + loc
  ifelse(is_outlier == 1, outlier, bulk)
}

# =============================================================================
# Build extended scenario list scenarios_v2
# =============================================================================

# Pull canonical S1-S7 (object 'scenarios' from simulation_manuscript_v2.R)
.canonical_scenarios <- scenarios

scenarios_v2 <- c(
  .canonical_scenarios,
  list(
    S8 = list(
      name     = "Outlier mixture (location 0.5)",
      clinical = "Heavy-tailed contamination (~1% outliers at ±5), location shift 0.5",
      dist1    = function(n) sample_outlier_mixture(n, loc = 0),
      dist2    = function(n) sample_outlier_mixture(n, loc = 0.5),
      true_nABCD = NA  # filled by compute_true_values_v2()
    ),
    S9 = list(
      name     = "Gamma scale shift",
      clinical = "Gamma(shape=2, scale=1) vs Gamma(shape=2, scale=1.5)",
      dist1    = function(n) rgamma(n, shape = 2, scale = 1.0),
      dist2    = function(n) rgamma(n, shape = 2, scale = 1.5),
      true_nABCD = NA
    )
  )
)

# =============================================================================
# Compute true nABCD (IQR baseline) for the extended scenarios
# =============================================================================

#' Compute true_nABCD (under IQR pooled normalizer) for each scenario via MC.
#' Reuses canonical compute_true_values() if scenarios share the same NA slots.
compute_true_values_v2 <- function(scenario_list = scenarios_v2,
                                    n_mc = 1e6, seed = 12345) {
  set.seed(seed)
  for (id in names(scenario_list)) {
    if (is.na(scenario_list[[id]]$true_nABCD)) {
      x <- scenario_list[[id]]$dist1(n_mc)
      y <- scenario_list[[id]]$dist2(n_mc)
      scenario_list[[id]]$true_nABCD <- round(compute_nABCD(x, y), 4)
    }
  }
  scenario_list
}

# =============================================================================
# Quick smoke test when run directly
# =============================================================================

if (isTRUE(as.logical(Sys.getenv("RUN_SMOKE_TESTS", "FALSE")))) {
  cat("Scenarios v2:", paste(names(scenarios_v2), collapse = ", "), "\n")
  set.seed(1)
  for (id in c("S8", "S9")) {
    sc <- scenarios_v2[[id]]
    x <- sc$dist1(1000); y <- sc$dist2(1000)
    cat(sprintf("  %s: mean(x)=%.3f sd(x)=%.3f mean(y)=%.3f sd(y)=%.3f nABCD~%.3f\n",
                id, mean(x), sd(x), mean(y), sd(y), compute_nABCD(x, y)))
  }
  # SN moment-match smoke test
  if (requireNamespace("sn", quietly = TRUE)) {
    sn_gen <- make_skewnormal_moment_matched(mean = 0, sd = 1, skewness = 0.6)
    z <- sn_gen(1e5)
    cat(sprintf("  SN(0,1,0.6): mean=%.4f sd=%.4f skew=%.4f\n",
                mean(z), sd(z),
                mean(((z - mean(z)) / sd(z))^3)))
  }
}
