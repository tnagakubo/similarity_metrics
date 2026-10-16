# =============================================================================
# nABCD with Multiple Normalizers (Phase 1)
# Authors: Mike Ross (Methodologist), Katrina Bennett (Technical Writer)
# Date: 2026-05-10
#
# Purpose:
#   Extend canonical compute_nABCD() (W1 / IQR_pooled) with 5 normalizer choices
#   for the Track B "Normalizer Choice Justification" simulation study.
#
# Normalizers (all computed on POOLED c(x, y)):
#   - IQR     : IQR(pooled), R default type=7  (canonical, current paper)
#   - Range   : max(pooled) - min(pooled)
#   - Q95Q5   : quantile(pooled, 0.95) - quantile(pooled, 0.05)
#   - SD      : sd(pooled)
#   - MAD     : median(|pooled - median(pooled)|), c=1 (UNSCALED)
#
# Returns NA_real_ when normalizer == 0 (degenerate case).
#
# Sourcing this file also sources simulation_manuscript_v2.R for wasserstein1()
# and the canonical compute_nABCD().
# =============================================================================

# --- Source canonical kernel (only if not already loaded) -------------------
# IMPORTANT: simulation_manuscript_v2.R auto-launches a full simulation if
# SKIP_SIMULATION does not exist in the global env. Set it before sourcing.
if (!exists("wasserstein1", mode = "function") ||
    !exists("compute_nABCD", mode = "function")) {
  if (!exists("SKIP_SIMULATION", envir = .GlobalEnv)) {
    assign("SKIP_SIMULATION", TRUE, envir = .GlobalEnv)
  }
  .here <- tryCatch(dirname(sys.frame(1)$ofile), error = function(e) ".")
  .kernel <- file.path(.here, "simulation_manuscript_v2.R")
  if (!file.exists(.kernel)) .kernel <- "projects/similarity-metric/R/simulation_manuscript_v2.R"
  if (!file.exists(.kernel)) .kernel <- "R/simulation_manuscript_v2.R"
  source(.kernel, local = FALSE, chdir = TRUE)
}

# =============================================================================
# Pooled normalizer dispatcher
# =============================================================================

#' Pooled normalizer for nABCD denominator
#'
#' All normalizers operate on the pooled vector c(x, y).
#'
#' @param pooled  numeric vector of c(x, y)
#' @param normalizer  one of "IQR", "Range", "Q95Q5", "SD", "MAD"
#' @return scalar normalizer value (>= 0); 0 returned as 0 (caller handles)
pooled_normalizer <- function(pooled, normalizer = c("IQR", "Range", "Q95Q5", "SD", "MAD")) {
  normalizer <- match.arg(normalizer)
  switch(normalizer,
    IQR   = IQR(pooled),                                          # type=7 default
    Range = diff(range(pooled)),                                  # max - min
    Q95Q5 = unname(diff(quantile(pooled, c(0.05, 0.95)))),        # 90% inter-quantile range
    SD    = sd(pooled),
    MAD   = median(abs(pooled - median(pooled)))                  # c=1, UNSCALED
  )
}

# =============================================================================
# compute_nABCD_v2: choose normalizer
# =============================================================================

#' Compute nABCD with selectable pooled normalizer
#'
#' nABCD = W_1(F_x, F_y) / X_pooled, where X_pooled is one of {IQR, Range,
#' Q95Q5, SD, MAD} computed on c(x, y).
#'
#' For normalizer = "IQR" this MUST equal compute_nABCD(x, y).
#'
#' @param x,y  numeric samples
#' @param normalizer  see pooled_normalizer()
#' @return scalar nABCD (numeric); NA_real_ if normalizer == 0
compute_nABCD_v2 <- function(x, y, normalizer = c("IQR", "Range", "Q95Q5", "SD", "MAD")) {
  normalizer <- match.arg(normalizer)
  pooled <- c(x, y)
  denom <- pooled_normalizer(pooled, normalizer)
  if (!is.finite(denom) || denom == 0) return(NA_real_)
  wasserstein1(x, y) / denom
}

# =============================================================================
# Vectorized version returning all 5 normalizers at once (efficient)
# =============================================================================

#' Compute nABCD under all 5 normalizers in one pass
#'
#' Reuses W1 computation across normalizer choices. ~5x faster than calling
#' compute_nABCD_v2() five times.
#'
#' @return named numeric vector with names IQR, Range, Q95Q5, SD, MAD
compute_nABCD_all <- function(x, y) {
  pooled <- c(x, y)
  w1 <- wasserstein1(x, y)
  denoms <- c(
    IQR   = IQR(pooled),
    Range = diff(range(pooled)),
    Q95Q5 = unname(diff(quantile(pooled, c(0.05, 0.95)))),
    SD    = sd(pooled),
    MAD   = median(abs(pooled - median(pooled)))
  )
  out <- ifelse(is.finite(denoms) & denoms > 0, w1 / denoms, NA_real_)
  names(out) <- names(denoms)
  out
}

# =============================================================================
# Sanity check: compute_nABCD_v2(., normalizer="IQR") == compute_nABCD(.)
# =============================================================================

.sanity_check_nabcd_v2 <- function(seed = 20260510, tol = 1e-12) {
  set.seed(seed)
  ok <- TRUE
  for (i in 1:20) {
    n <- sample(20:200, 1)
    x <- rnorm(n, 50, 10)
    y <- rnorm(n, 50 + runif(1, -3, 3), 10 * runif(1, 0.7, 1.5))
    a <- compute_nABCD(x, y)
    b <- compute_nABCD_v2(x, y, "IQR")
    c <- compute_nABCD_all(x, y)["IQR"]
    if (!isTRUE(all.equal(a, b, tolerance = tol))) {
      cat("MISMATCH compute_nABCD vs compute_nABCD_v2(IQR):", a, "vs", b, "\n")
      ok <- FALSE
    }
    if (!isTRUE(all.equal(a, unname(c), tolerance = tol))) {
      cat("MISMATCH compute_nABCD vs compute_nABCD_all[IQR]:", a, "vs", c, "\n")
      ok <- FALSE
    }
  }
  if (ok) cat("[Sanity] compute_nABCD_v2(IQR) and compute_nABCD_all[IQR] match canonical compute_nABCD on 20 random datasets.\n")
  invisible(ok)
}

# Run sanity check only when explicitly requested (RUN_SMOKE_TESTS=1)
if (isTRUE(as.logical(Sys.getenv("RUN_SMOKE_TESTS", "FALSE")))) {
  .sanity_check_nabcd_v2()
}
