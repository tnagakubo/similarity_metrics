## ---------------------------------------------------------------------------
## simulation_power.R
## Size and power of the Neyman smooth two-sample test against the usual
## primary-endpoint tests, under distributional alternatives that occur in
## clinical trials.
##
## All rank-based tests are calibrated with EXACT distribution-free critical
## values (simulated once per (m, n): under H0 with continuous data the null
## law of every rank statistic depends only on the sample sizes).
## ---------------------------------------------------------------------------

source("R/neyman_smooth_2sample.R")

ALPHA  <- 0.05
NREP   <- 5000L
BNULL  <- 25000L
SIZES  <- c(50L, 100L, 200L)
DMAX   <- 4L

## --- data-generating mechanisms -------------------------------------------
## Each returns list(x = control, y = treatment)

rsn <- function(n, alpha) {                 # standardised skew-normal
  d <- alpha / sqrt(1 + alpha^2)
  z <- d * abs(rnorm(n)) + sqrt(1 - d^2) * rnorm(n)
  (z - d * sqrt(2 / pi)) / sqrt(1 - 2 * d^2 / pi)
}

SCEN <- list(
  S0_null_normal = list(
    label = "Null: N(0,1) vs N(0,1)",
    gen = function(m, n) list(x = rnorm(m), y = rnorm(n))),
  S0b_null_lognormal = list(
    label = "Null: lognormal vs lognormal",
    gen = function(m, n) list(x = rlnorm(m), y = rlnorm(n))),
  S1_location = list(
    label = "Location shift (delta = 0.35 SD)",
    gen = function(m, n) list(x = rnorm(m), y = rnorm(n, 0.35))),
  S2_heavytail_loc = list(
    label = "Location shift, heavy tails (t3, delta = 0.35)",
    gen = function(m, n) list(x = rt(m, 3), y = rt(n, 3) + 0.35)),
  S3_scale_only = list(
    label = "Scale only (SD 1.0 vs 1.6, equal mean & median)",
    gen = function(m, n) list(x = rnorm(m), y = rnorm(n, 0, 1.6))),
  S4_responder = list(
    label = "Responder subgroup (25% shifted by 1.6 SD)",
    gen = function(m, n) {
      r <- rbinom(n, 1, 0.25)
      list(x = rnorm(m), y = rnorm(n, 1.6 * r))
    }),
  S5_shape_only = list(
    label = "Shape only (skew-normal, equal mean & SD)",
    gen = function(m, n) list(x = rnorm(m), y = rsn(n, 6))),
  S6_lognormal_shift = list(
    label = "Right-skewed endpoint, lognormal shift (0.25 on log scale)",
    gen = function(m, n) list(x = rlnorm(m), y = rlnorm(n, 0.25))),
  S7_stabilising = list(
    label = "Mean shift 0.2 with variance reduction (SD 1.0 vs 0.6)",
    gen = function(m, n) list(x = rnorm(m), y = rnorm(n, 0.2, 0.6)))
)

## --- exact distribution-free null critical values --------------------------

null_crit <- function(m, n, d, B, seed = 20260922L) {
  eng <- smooth_engine(m, n, d)
  set.seed(seed)
  sm <- matrix(NA_real_, B, d + 2L)
  ad <- numeric(B)
  for (b in seq_len(B)) {
    x <- rnorm(m); y <- rnorm(n)
    sm[b, ] <- eng$stats(x, y)
    ad[b] <- ad2_stat(x, y)
  }
  list(eng = eng,
       W    = apply(sm[, seq_len(d), drop = FALSE], 2L,
                    quantile, probs = 1 - ALPHA),
       Wsel = unname(quantile(sm[, d + 1L], 1 - ALPHA)),
       AD   = unname(quantile(ad, 1 - ALPHA)))
}

## --- main loop -------------------------------------------------------------

run_all <- function() {
  out <- list()
  for (nn in SIZES) {
    message("=== n per arm = ", nn, " : calibrating null ...")
    cr <- null_crit(nn, nn, DMAX, BNULL)
    eng <- cr$eng
    for (sc in names(SCEN)) {
      message("    scenario ", sc)
      set.seed(1000L + nn)
      rej <- matrix(FALSE, NREP, 7L)
      ksel <- integer(NREP)
      gen <- SCEN[[sc]]$gen
      for (r in seq_len(NREP)) {
        dat <- gen(nn, nn)
        s <- eng$stats(dat$x, dat$y)
        rej[r, 1] <- t.test(dat$y, dat$x)$p.value < ALPHA          # Welch t
        rej[r, 2] <- s[1] > cr$W[1]                                # Wilcoxon
        rej[r, 3] <- suppressWarnings(
          ks.test(dat$x, dat$y)$p.value) < ALPHA                   # KS
        rej[r, 4] <- ad2_stat(dat$x, dat$y) > cr$AD                # AD
        rej[r, 5] <- s[2] > cr$W[2]                                # smooth k=2
        rej[r, 6] <- s[4] > cr$W[4]                                # smooth k=4
        rej[r, 7] <- s[5] > cr$Wsel                                # smooth BIC
        ksel[r] <- s[6]
      }
      out[[length(out) + 1L]] <- data.frame(
        scenario = sc, label = SCEN[[sc]]$label, n_per_arm = nn,
        test = c("t-test (Welch)", "Wilcoxon", "Kolmogorov-Smirnov",
                 "Anderson-Darling", "Smooth k=2", "Smooth k=4",
                 "Smooth data-driven (BIC)"),
        power = colMeans(rej),
        mc_se = sqrt(colMeans(rej) * (1 - colMeans(rej)) / NREP),
        mean_k_selected = mean(ksel),
        stringsAsFactors = FALSE)
    }
  }
  do.call(rbind, out)
}

t0 <- Sys.time()
sim <- run_all()
message("elapsed: ", format(Sys.time() - t0))
write.csv(sim, "results/power_summary.csv", row.names = FALSE)
saveRDS(sim, "results/power_summary.rds")
message("done")
