# =============================================================================
# Scenarios Redesign (N1-N8) — Tak directive 2026-05-10
#
# Design goals:
#   Goal 1: Differentiate nABCD from SMD
#     1A: SMD = 0 but nABCD > 0 (mean-blind scenarios)
#     1B: Same SMD, different distribution shape
#   Goal 2: Differentiate robust normalizers (IQR/Q95Q5/MAD) from SD
#     2C: Outlier contamination breaks SD
#     2D: Skewed distribution with mean != median
#     2E: Heavy tail with finite variance
#
# All scenarios use canonical (mean, var) standardized to (0, 1) for direct
# SMD comparability across scenarios.
# =============================================================================

if (!exists("SKIP_SIMULATION", envir = .GlobalEnv)) {
  assign("SKIP_SIMULATION", TRUE, envir = .GlobalEnv)
}

# --- Source canonical kernel (provides wasserstein1, compute_nABCD) ---------
if (!exists("wasserstein1", mode = "function") ||
    !exists("compute_nABCD", mode = "function")) {
  .dir_here <- tryCatch(dirname(sys.frame(1)$ofile), error = function(e) ".")
  .kernel <- file.path(.dir_here, "simulation_manuscript_v2.R")
  if (!file.exists(.kernel)) .kernel <- "projects/similarity-metric/R/simulation_manuscript_v2.R"
  source(.kernel, local = FALSE, chdir = TRUE)
}

# =============================================================================
# Helpers
# =============================================================================

# Outlier mixture: prob p mass at ±magnitude (sign uniform), bulk N(loc, 1).
# Marginal mean = loc (outlier signs cancel). Marginal var = 1 + p*(magnitude^2 - 1).
sample_outlier_mixture_pct <- function(n, loc = 0, p = 0.05, magnitude = 10) {
  is_out <- rbinom(n, 1, p)
  bulk   <- rnorm(n, loc, 1)
  outlier_sign <- 2 * rbinom(n, 1, 0.5) - 1
  out_val <- outlier_sign * magnitude + loc
  ifelse(is_out == 1, out_val, bulk)
}

# Gamma standardized to (mean = 0, var = 1).
# Gamma(shape, scale): mean = shape*scale, var = shape*scale^2, skew = 2/sqrt(shape).
# shape = 0.5 → skew ≈ 2.83 (extreme right skew).
sample_gamma_standardized <- function(n, shape = 0.5, scale = 2) {
  g  <- rgamma(n, shape = shape, scale = scale)
  mu <- shape * scale
  sg <- sqrt(shape * scale^2)
  (g - mu) / sg
}

# Student t standardized to (mean = 0, var = 1).
# t(df): var = df/(df-2) for df > 2; divide by sqrt(df/(df-2)).
sample_t_standardized <- function(n, df = 3) {
  if (df <= 2) stop("df must be > 2 for finite variance.")
  rt(n, df = df) / sqrt(df / (df - 2))
}

# Population SMD via Monte Carlo (since closed form not always available).
# SMD = (mean_F2 - mean_F1) / sqrt((var_F1 + var_F2) / 2)
compute_population_smd <- function(scenario, n_mc = 1e6, seed = 42) {
  set.seed(seed)
  x <- scenario$dist1(n_mc)
  y <- scenario$dist2(n_mc)
  (mean(y) - mean(x)) / sqrt((var(x) + var(y)) / 2)
}

# =============================================================================
# Scenario definitions
# =============================================================================

scenarios_redesign <- list(

  # --- References (N1-N2) ---------------------------------------------------
  N1 = list(
    name     = "Null (sanity)",
    goal     = "Reference: identical distributions",
    smd_target = 0,
    dist1    = function(n) rnorm(n, 0, 1),
    dist2    = function(n) rnorm(n, 0, 1),
    true_nABCD = NA
  ),

  N2 = list(
    name     = "Gaussian location 0.5 sigma",
    goal     = "Reference: Gaussian + same SD; SMD = 0.5; nABCD_SD ≈ SMD by closed form",
    smd_target = 0.5,
    dist1    = function(n) rnorm(n, 0, 1),
    dist2    = function(n) rnorm(n, 0.5, 1),
    true_nABCD = NA
  ),

  # --- Goal 1A: SMD = 0 but nABCD > 0 (mean-blind) -------------------------
  N3 = list(
    name     = "Pure scale (SMD = 0)",
    goal     = "Goal 1A: same mean, sigma 1 vs 1.5; SMD = 0, nABCD > 0",
    smd_target = 0,
    dist1    = function(n) rnorm(n, 0, 1),
    dist2    = function(n) rnorm(n, 0, 1.5),
    true_nABCD = NA
  ),

  N4 = list(
    name     = "Heavy tail t(df=3) (matched mean, var)",
    goal     = "Goal 1A + 2E: SMD = 0, var matched; SD-nABCD ≈ 0, robust-nABCD > 0",
    smd_target = 0,
    dist1    = function(n) rnorm(n, 0, 1),
    dist2    = function(n) sample_t_standardized(n, df = 3),
    true_nABCD = NA
  ),

  # --- Goal 2C: Outlier breakdown of SD -------------------------------------
  N5 = list(
    name     = "Outlier 5% (mild)",
    goal     = "Goal 2C: 5% outliers ±10, location shift 0.5; SD inflated",
    smd_target = NA,  # to be computed
    dist1    = function(n) sample_outlier_mixture_pct(n, loc = 0,   p = 0.05, magnitude = 10),
    dist2    = function(n) sample_outlier_mixture_pct(n, loc = 0.5, p = 0.05, magnitude = 10),
    true_nABCD = NA
  ),

  # N6 (Outlier 20%) removed 2026-05-11 (Tak directive): 20% contamination is
  # not a realistic clinical setting (Maronna 2006 standard sweep is 5-10%),
  # and including it as a main scenario implied the framework was being judged
  # at an unrealistic stress point. Existing simulation results are preserved
  # in results/ as audit trail but excluded from all paper figures/tables.

  # --- Goal 2D: Skewness with mean != median ------------------------------
  N7 = list(
    name     = "Heavy skew Gamma(0.5) (matched mean, var)",
    goal     = "Goal 2D: F1 Gaussian, F2 right-skewed (skew~2.83), matched mean=0 var=1",
    smd_target = 0,
    dist1    = function(n) rnorm(n, 0, 1),
    dist2    = function(n) sample_gamma_standardized(n, shape = 0.5, scale = 2),
    true_nABCD = NA
  ),

  # --- Goal 1B: Same SMD, different shape ---------------------------------
  N8 = list(
    name     = "Same SMD as N2 (0.5), heavy tail t(df=5)",
    goal     = "Goal 1B: F1 N(0,1), F2 t(df=5)+0.5; SMD=0.5 same as N2 but tail heavier",
    smd_target = 0.5,
    dist1    = function(n) rnorm(n, 0, 1),
    dist2    = function(n) sample_t_standardized(n, df = 5) + 0.5,
    true_nABCD = NA
  )
)

# =============================================================================
# Compute true_nABCD per normalizer (uses canonical compute_all_true_normalizers)
# =============================================================================

compute_true_redesign <- function(scenarios = scenarios_redesign,
                                    n_mc = 1e6, seed_base = 12345,
                                    out_file = "results/true_redesign.rds",
                                    verbose = TRUE) {
  if (!exists("compute_all_true_normalizers", mode = "function")) {
    .dir_here <- tryCatch(dirname(sys.frame(1)$ofile), error = function(e) ".")
    .file <- file.path(.dir_here, "true_normalizers.R")
    if (!file.exists(.file)) .file <- "projects/similarity-metric/R/true_normalizers.R"
    source(.file, local = FALSE, chdir = TRUE)
  }
  compute_all_true_normalizers(scenarios, n_mc = n_mc,
                                 seed_base = seed_base,
                                 out_file = out_file,
                                 verbose = verbose)
}

# =============================================================================
# Compute population SMD for each scenario
# =============================================================================

compute_all_smd <- function(scenarios = scenarios_redesign,
                              n_mc = 1e6, seed_base = 99999) {
  out <- data.frame(scenario = character(),
                    population_smd = numeric(),
                    stringsAsFactors = FALSE)
  for (i in seq_along(scenarios)) {
    id <- names(scenarios)[i]
    smd <- compute_population_smd(scenarios[[i]], n_mc = n_mc,
                                    seed = seed_base + i)
    out <- rbind(out, data.frame(scenario = id, population_smd = smd))
  }
  out
}
