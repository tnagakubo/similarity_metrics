# =============================================================================
# Cross-EM Data Generators (Phase 4)
# Authors: Mike Ross (Methodologist), Katrina Bennett (Technical Writer)
# Date: 2026-05-10
#
# Three Effect Modifiers (EMs) with realistic clinical shapes:
#
#   age        : F1 = N(60, 15^2)         F2 = N(60 + Δσ * 15, 15^2)
#   sbp        : F1 = 140 + 20 * t_5 / sqrt(5/3)   (scaled t-5, sd ≈ 20)
#                F2 = same shifted by Δσ * 20
#   creatinine : F1 = LogN(meanlog=0, sdlog=0.5)
#                F2 = LogN(meanlog=Δσ*0.5, sdlog=0.5)
#
# Δσ ∈ {0.25, 0.5, 1.0}
#
# Note on SBP scaling:
#   t with df=5 has variance df/(df-2) = 5/3.  t_5 / sqrt(5/3) has variance 1.
#   Multiplying by 20 yields sd ≈ 20.  Adding 140 gives mean = 140.
# =============================================================================

CROSS_EM_LIST <- c("age", "sbp", "creatinine")
DELTA_SIGMA_LIST <- c(0.25, 0.5, 1.0)

#' Generate a paired sample (x1, x2) for a given EM and Δσ.
#'
#' @param em  one of "age", "sbp", "creatinine"
#' @param delta_sigma  numeric in {0.25, 0.5, 1.0} (or any positive value)
#' @param n   sample size per group
#' @return list(x1 = numeric(n), x2 = numeric(n))
generate_cross_em_data <- function(em, delta_sigma, n) {
  em <- match.arg(em, CROSS_EM_LIST)
  switch(em,
    age = {
      x1 <- rnorm(n, mean = 60, sd = 15)
      x2 <- rnorm(n, mean = 60 + delta_sigma * 15, sd = 15)
    },
    sbp = {
      df <- 5
      sd_ratio <- sqrt(df / (df - 2))   # = sqrt(5/3) ~ 1.291
      x1 <- 140 + 20 * (rt(n, df = df) / sd_ratio)
      x2 <- 140 + delta_sigma * 20 + 20 * (rt(n, df = df) / sd_ratio)
    },
    creatinine = {
      x1 <- rlnorm(n, meanlog = 0,                sdlog = 0.5)
      x2 <- rlnorm(n, meanlog = delta_sigma * 0.5, sdlog = 0.5)
    }
  )
  list(x1 = x1, x2 = x2)
}

#' Build a "scenario-like" list (compatible with compute_true_for_scenario())
#' for a (em, delta_sigma) pair.
make_cross_em_scenario <- function(em, delta_sigma) {
  em <- match.arg(em, CROSS_EM_LIST)
  list(
    name     = sprintf("CrossEM:%s,delta=%g", em, delta_sigma),
    clinical = sprintf("Cross-EM generator (%s, delta_sigma=%g)", em, delta_sigma),
    dist1 = switch(em,
      age        = function(n) rnorm(n, 60, 15),
      sbp        = local({df <- 5; sr <- sqrt(df/(df-2));
                          function(n) 140 + 20 * (rt(n, df) / sr)}),
      creatinine = function(n) rlnorm(n, 0, 0.5)
    ),
    dist2 = switch(em,
      age        = local({d <- delta_sigma; function(n) rnorm(n, 60 + d*15, 15)}),
      sbp        = local({df <- 5; sr <- sqrt(df/(df-2)); d <- delta_sigma;
                          function(n) 140 + d*20 + 20 * (rt(n, df) / sr)}),
      creatinine = local({d <- delta_sigma; function(n) rlnorm(n, d*0.5, 0.5)})
    ),
    true_nABCD = NA
  )
}

#' Build the full Cross-EM scenario list (3 EMs × 3 Δσ = 9 scenarios)
build_cross_em_scenarios <- function() {
  out <- list()
  for (em in CROSS_EM_LIST) {
    for (d in DELTA_SIGMA_LIST) {
      key <- sprintf("%s_d%s", em, gsub("\\.", "p", format(d)))
      out[[key]] <- make_cross_em_scenario(em, d)
    }
  }
  out
}

# =============================================================================
# Smoke test
# =============================================================================
if (isTRUE(as.logical(Sys.getenv("RUN_SMOKE_TESTS", "FALSE")))) {
  set.seed(1)
  for (em in CROSS_EM_LIST) {
    for (d in DELTA_SIGMA_LIST) {
      dat <- generate_cross_em_data(em, d, 1000)
      cat(sprintf("  %s d=%g: mean(x1)=%.2f sd(x1)=%.2f mean(x2)=%.2f sd(x2)=%.2f\n",
                  em, d, mean(dat$x1), sd(dat$x1), mean(dat$x2), sd(dat$x2)))
    }
  }
}
