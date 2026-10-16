# =============================================================================
# Validation scenarios for normalizer evaluation methodology (Tak 2026-05-11)
# Four experiments to fill the audit gaps:
#   E1: Pure EM-invariance (standardized 3 EMs)
#   E2: Multi-shape sensitivity (same SMD, different F2 shape)
#   E3: Outlier breakdown curve (0%, 1%, 2%, 3%, 5%, 7%, 10%)
#   E4: Monotonicity sweep (delta = 0, 0.1, 0.2, 0.3, 0.5, 0.7, 1.0, 1.5, 2.0)
# =============================================================================

if (!exists("SKIP_SIMULATION", envir = .GlobalEnv)) {
  assign("SKIP_SIMULATION", TRUE, envir = .GlobalEnv)
}
if (!exists("wasserstein1", mode = "function") ||
    !exists("compute_nABCD", mode = "function")) {
  .dir_here <- tryCatch(dirname(sys.frame(1)$ofile), error = function(e) ".")
  .kernel <- file.path(.dir_here, "simulation_manuscript_v2.R")
  if (!file.exists(.kernel)) .kernel <- "projects/similarity-metric/R/simulation_manuscript_v2.R"
  source(.kernel, local = FALSE, chdir = TRUE)
}

# Helpers (some reused from scenarios_redesign.R)
sample_t_std <- function(n, df = 5) rt(n, df = df) / sqrt(df / (df - 2))
sample_gamma_std <- function(n, shape = 0.5, scale = 2) {
  g <- rgamma(n, shape = shape, scale = scale)
  (g - shape * scale) / sqrt(shape * scale^2)
}
# Bimodal Gaussian mixture, standardized to (mean=0, var=1)
sample_bimodal_std <- function(n, sep = 2) {
  # 0.5 * N(-a, s^2) + 0.5 * N(+a, s^2) with a, s chosen for var=1
  # var = a^2 + s^2.  Choose a=sep/2, s=sqrt(1 - a^2)
  a <- sep / 2
  s <- sqrt(max(1 - a^2, 0.05))
  side <- 2 * rbinom(n, 1, 0.5) - 1
  rnorm(n, mean = side * a, sd = s)
}
sample_outlier_pct <- function(n, loc = 0, p = 0.05, mag = 10) {
  is_out <- rbinom(n, 1, p)
  bulk   <- rnorm(n, loc, 1)
  out    <- (2 * rbinom(n, 1, 0.5) - 1) * mag + loc
  ifelse(is_out == 1, out, bulk)
}

# =============================================================================
# Experiment 1 (E1): Pure EM-invariance
# Each EM is standardized to (mean=0, var=1) intrinsically;
# F2 is F1 shifted by delta in the same standardized unit (so effective shift
# is the same across EMs).  Three EMs differ only in distribution shape.
# =============================================================================
build_e1 <- function() {
  out <- list()
  for (d in c(0.25, 0.5, 1.0)) {
    out[[sprintf("E1_gauss_d%g",     d)]] <- list(
      name = sprintf("E1 Gaussian std (d=%g)", d),
      goal = "E1: Pure EM-inv — Gaussian intrinsic",
      dist1 = function(n) rnorm(n, 0, 1),
      dist2 = local({dd <- d; function(n) rnorm(n, dd, 1)}),
      true_nABCD = NA
    )
    out[[sprintf("E1_t5_d%g", d)]] <- list(
      name = sprintf("E1 t(5) std (d=%g)", d),
      goal = "E1: Pure EM-inv — t-5 intrinsic",
      dist1 = function(n) sample_t_std(n, df = 5),
      dist2 = local({dd <- d; function(n) sample_t_std(n, df = 5) + dd}),
      true_nABCD = NA
    )
    out[[sprintf("E1_gamma_d%g", d)]] <- list(
      name = sprintf("E1 Gamma(0.5) std (d=%g)", d),
      goal = "E1: Pure EM-inv — Gamma intrinsic",
      dist1 = function(n) sample_gamma_std(n, shape = 0.5, scale = 2),
      dist2 = local({dd <- d; function(n) sample_gamma_std(n, shape = 0.5, scale = 2) + dd}),
      true_nABCD = NA
    )
  }
  out
}

# =============================================================================
# Experiment 2 (E2): Multi-shape sensitivity (fixed SMD ≈ 0.5)
# All F1 = N(0,1).  F2 varies in shape but matched to SMD=0.5.
# Variance matching: F2 standardized to var=1, then shifted by 0.5.
# =============================================================================
build_e2 <- function() {
  list(
    E2_G1_gauss   = list(
      name = "E2 G1: Gaussian vs Gaussian shifted (reference)",
      goal = "E2: SMD=0.5, F2 Gaussian",
      dist1 = function(n) rnorm(n, 0, 1),
      dist2 = function(n) rnorm(n, 0.5, 1),
      true_nABCD = NA
    ),
    E2_G2_t5 = list(
      name = "E2 G2: Gaussian vs t(5)+0.5",
      goal = "E2: SMD=0.5, F2 heavy tail",
      dist1 = function(n) rnorm(n, 0, 1),
      dist2 = function(n) sample_t_std(n, df = 5) + 0.5,
      true_nABCD = NA
    ),
    E2_G3_gamma = list(
      name = "E2 G3: Gaussian vs Gamma(0.5)std + 0.5",
      goal = "E2: SMD=0.5, F2 skewed",
      dist1 = function(n) rnorm(n, 0, 1),
      dist2 = function(n) sample_gamma_std(n, shape = 0.5, scale = 2) + 0.5,
      true_nABCD = NA
    ),
    E2_G4_bimodal = list(
      name = "E2 G4: Gaussian vs Bimodal+0.5",
      goal = "E2: SMD=0.5, F2 bimodal",
      dist1 = function(n) rnorm(n, 0, 1),
      dist2 = function(n) sample_bimodal_std(n, sep = 1.5) + 0.5,
      true_nABCD = NA
    ),
    E2_G5_t3 = list(
      name = "E2 G5: Gaussian vs t(3)+0.5",
      goal = "E2: SMD=0.5, F2 very heavy tail",
      dist1 = function(n) rnorm(n, 0, 1),
      dist2 = function(n) sample_t_std(n, df = 3) + 0.5,
      true_nABCD = NA
    )
  )
}

# =============================================================================
# Experiment 3 (E3): Outlier breakdown curve
# F1 = (1-p) N(0,1) + p · δ(±10),  F2 = same shifted 0.5
# p = 0%, 1%, 2%, 3%, 5%, 7%, 10%
# =============================================================================
build_e3 <- function() {
  out <- list()
  for (p in c(0, 0.01, 0.02, 0.03, 0.05, 0.07, 0.10)) {
    out[[sprintf("E3_p%02d", as.integer(round(p * 100)))]] <- list(
      name = sprintf("E3 outlier %.0f%%", p * 100),
      goal = sprintf("E3: outlier %g, loc 0.5", p),
      dist1 = local({pp <- p; function(n) sample_outlier_pct(n, loc = 0,   p = pp, mag = 10)}),
      dist2 = local({pp <- p; function(n) sample_outlier_pct(n, loc = 0.5, p = pp, mag = 10)}),
      true_nABCD = NA
    )
  }
  out
}

# =============================================================================
# Experiment 4 (E4): Monotonicity sweep (Gaussian, sigma=1)
# F1 = N(0,1),  F2 = N(d, 1)  for d = 0, 0.1, 0.2, 0.3, 0.5, 0.7, 1.0, 1.5, 2.0
# =============================================================================
build_e4 <- function() {
  out <- list()
  for (d in c(0, 0.1, 0.2, 0.3, 0.5, 0.7, 1.0, 1.5, 2.0)) {
    out[[sprintf("E4_d%g", d)]] <- list(
      name = sprintf("E4 Gaussian d=%g", d),
      goal = sprintf("E4: monotonicity, delta=%g", d),
      dist1 = function(n) rnorm(n, 0, 1),
      dist2 = local({dd <- d; function(n) rnorm(n, dd, 1)}),
      true_nABCD = NA
    )
  }
  out
}

scenarios_validation <- c(build_e1(), build_e2(), build_e3(), build_e4())

cat(sprintf("[scenarios_validation] %d scenarios total: %d E1 + %d E2 + %d E3 + %d E4\n",
            length(scenarios_validation),
            length(build_e1()), length(build_e2()),
            length(build_e3()), length(build_e4())))

# =============================================================================
# Sample-size schedule per experiment (to balance runtime)
# =============================================================================
sample_sizes_for <- function(scenario_id) {
  if (grepl("^E4_", scenario_id)) {
    100L  # E4 only needs one sample size for monotonicity pattern
  } else {
    c(50L, 100L, 200L)
  }
}
