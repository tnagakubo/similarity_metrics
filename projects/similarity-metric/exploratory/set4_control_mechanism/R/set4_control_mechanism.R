# EXPLORATORY — exploratory/set4_control_mechanism (not pre-registered; see README.md). Not cited by the manuscript.
# Question (D-20261012-2, Louis C4): does the Set 4 anchor mixture inflate the sampling SD of W1-hat
# (null mean ~ int sqrt(F(1-F)) dx) so that, for a pure shift delta in {2,3}, KS separates better than W1,
# whereas on N(50,10^2) W1 separates at least as well?
# DGM copied from R/selection_simulation.R::ext_c / build_set4 (s0 = 10, st = 8): anchor =
#   0.05 N(10, 8^2) + 0.90 N(50, 10^2) + 0.05 N(90, 8^2); bulk_shift S1/S2 = same mixture with mu0 = 52/53,
#   i.e. the whole mixture translated by delta. Here the shifted sample is drawn as anchor_sampler(n) + delta
#   (equal in distribution).
# W1 = CDF-area convention (compute_w1 of R/fig3_w1_axis.R, copied verbatim and used to verify the fast path).
# Seeds: set.seed(SEED + cell offset), serial. sessionInfo saved to results/.
suppressWarnings(RNGkind("Mersenne-Twister", "Inversion", "Rejection"))
SEED   <- 20261012L
N_SIM  <- 2000L
B_MC   <- 500L          # Monte Carlo bootstrap over replicates, for MCSE only (not inference)
N_GRID <- c(100L, 200L, 400L)
DELTAS <- c(2, 3)

args <- commandArgs(trailingOnly = FALSE)
script <- sub("^--file=", "", grep("^--file=", args, value = TRUE))
here <- if (length(script) == 1L) normalizePath(file.path(dirname(script), "..")) else
        normalizePath(file.path("projects", "similarity-metric", "exploratory", "set4_control_mechanism"))
stopifnot(dir.exists(here))
RES <- file.path(here, "results"); FIG <- file.path(here, "figures")
dir.create(RES, showWarnings = FALSE); dir.create(FIG, showWarnings = FALSE)
t0 <- Sys.time()

# ---- DGM (structure of ext_c, verbatim mixture) ------------------------------
ext_c <- function(mu0, eL, dL, eH, dH, s0 = 10, st = 8) {
  w <- c(eL, 1 - eL - eH, eH); m <- c(mu0 - dL, mu0, mu0 + dH); s <- c(st, s0, st)
  list(sampler = function(n) {
         k <- as.vector(rmultinom(1L, n, w))
         c(rnorm(k[1], m[1], s[1]), rnorm(k[2], m[2], s[2]), rnorm(k[3], m[3], s[3]))
       },
       cdf = function(t) w[1]*pnorm(t, m[1], s[1]) + w[2]*pnorm(t, m[2], s[2]) + w[3]*pnorm(t, m[3], s[3]))
}
bases <- list(
  gauss = list(label = "(a) N(50, 10^2)", sampler = function(n) rnorm(n, 50, 10),
               cdf = function(t) pnorm(t, 50, 10)),
  set4  = c(list(label = "(b) Set 4 anchor mixture"), ext_c(50, 0.05, 40, 0.05, 40))
)

# ---- statistics --------------------------------------------------------------
compute_w1 <- function(x, y) {           # verbatim from R/fig3_w1_axis.R
  all_vals <- sort(c(x, y)); n <- length(all_vals)
  if (n < 2) return(0)
  Fx <- ecdf(x); Fy <- ecdf(y)
  mids <- (all_vals[-n] + all_vals[-1]) / 2; diffs <- diff(all_vals)
  sum(abs(Fx(mids) - Fy(mids)) * diffs)
}
# one pass over the pooled sort (equal n): W1 = sum |F_x - F_y| * gaps, KS = max |F_x - F_y| (exact lattice k/n)
stat2 <- function(x, y) {
  n <- length(x); stopifnot(length(y) == n)
  z <- c(x, y); o <- order(z); zs <- z[o]
  ci <- cumsum(ifelse(o <= n, 1L, -1L))           # n * (F_x - F_y) after each pooled atom, integer
  c(w1 = sum(abs(ci[-2L * n]) * diff(zs)) / n, ks = max(abs(ci)) / n)
}
# verification of the fast path against compute_w1 and ks.test
set.seed(SEED - 1L)
for (r in 1:20) {
  x <- bases$set4$sampler(150); y <- bases$set4$sampler(150) + 2
  s <- stat2(x, y)
  stopifnot(abs(s[["w1"]] - compute_w1(x, y)) < 1e-10,
            abs(s[["ks"]] - unname(suppressWarnings(ks.test(x, y))$statistic)) < 1e-12)
}
cat("[check] fast path == compute_w1 and ks.test on 20 reps\n")

draw <- function(base, n, delta, nsim) {
  out <- matrix(NA_real_, nsim, 2, dimnames = list(NULL, c("w1", "ks")))
  for (r in seq_len(nsim)) out[r, ] <- stat2(base$sampler(n), base$sampler(n) + delta)
  out
}

# ---- performance measures + MCSE -------------------------------------------
sd_mcse <- function(v) { s <- sd(v); m4 <- mean((v - mean(v))^4); sqrt((m4 - s^4) / (4 * s^2 * length(v))) }
auc_rank <- function(alt, nul) {          # Mann-Whitney with average ranks = ties scored 0.5
  na <- length(alt); nn <- length(nul); rk <- rank(c(alt, nul))
  (sum(rk[seq_len(na)]) - na * (na + 1) / 2) / (na * nn)
}
sep_fun <- function(alt, nul) (mean(alt) - mean(nul)) / sqrt((var(alt) + var(nul)) / 2)

# ---- integrals and true distances -------------------------------------------
iF <- function(cdf) integrate(function(t) { p <- cdf(t); sqrt(pmax(p * (1 - p), 0)) },
                              -150, 250, subdivisions = 5000L, rel.tol = 1e-10)$value
int_std <- integrate(function(t) sqrt(pnorm(t) * pnorm(-t)), -15, 15, subdivisions = 5000L, rel.tol = 1e-12)$value
true_ks <- function(cdf, d) { g <- seq(-150, 250, length.out = 400001L); max(abs(cdf(g) - cdf(g - d))) }
ints <- data.frame(base = names(bases), label = vapply(bases, `[[`, "", "label"),
                   int_sqrtF1F = vapply(bases, function(b) iF(b$cdf), 0),
                   check_10x_std_normal = c(10 * int_std, NA),
                   sd_population = c(10, sqrt(0.9 * 100 + 0.1 * 64 + 0.1 * 40^2)))
ints$ratio_to_gauss <- ints$int_sqrtF1F / ints$int_sqrtF1F[1]
write.csv(ints, file.path(RES, "integrals.csv"), row.names = FALSE)

# ---- main loop -----------------------------------------------------------------
rows <- list(); diffs <- list(); raw_null <- list(); ib <- 0L
for (bn in names(bases)) {
  ib <- ib + 1L; b <- bases[[bn]]
  for (j in seq_along(N_GRID)) {
    n <- N_GRID[j]
    set.seed(SEED + 100L * ib + j)                       # null cell (shared by both deltas)
    nul <- draw(b, n, 0, N_SIM)
    raw_null[[paste(bn, n)]] <- nul
    for (k in seq_along(DELTAS)) {
      dl <- DELTAS[k]
      set.seed(SEED + 1000L + 100L * ib + 10L * j + k)   # alternative cell
      alt <- draw(b, n, dl, N_SIM)
      for (st in c("w1", "ks")) {
        a <- alt[, st]; u <- nul[, st]
        bs <- replicate(B_MC, { ia <- sample.int(N_SIM, replace = TRUE); iu <- sample.int(N_SIM, replace = TRUE)
                                c(sep_fun(a[ia], u[iu]), auc_rank(a[ia], u[iu])) })
        rows[[length(rows) + 1L]] <- data.frame(
          base = bn, n = n, delta = dl, statistic = st,
          mean_null = mean(u), mean_null_mcse = sd(u) / sqrt(N_SIM),
          mean_alt  = mean(a), mean_alt_mcse  = sd(a) / sqrt(N_SIM),
          sd_null = sd(u), sd_null_mcse = sd_mcse(u),
          sd_alt  = sd(a), sd_alt_mcse  = sd_mcse(a),
          separation = sep_fun(a, u), separation_mcse = sd(bs[1, ]),
          auc = auc_rank(a, u), auc_mcse = sd(bs[2, ]),
          auc_normal_approx = pnorm(sep_fun(a, u) / sqrt(2)),
          true_value = if (st == "w1") dl else true_ks(b$cdf, dl),
          null_mean_theory = if (st == "w1") sqrt(4 / (pi * n)) * ints$int_sqrtF1F[ib] else NA_real_)
      }
      # paired MCSE of AUC(W1) - AUC(KS) and separation(W1) - separation(KS): both statistics come from
      # the same pairs, so resample replicate indices jointly (Monte Carlo bootstrap, not inference)
      set.seed(SEED + 3000L + 100L * ib + 10L * j + k)
      dd <- replicate(B_MC, { ia <- sample.int(N_SIM, replace = TRUE); iu <- sample.int(N_SIM, replace = TRUE)
        c(auc_rank(alt[ia, "w1"], nul[iu, "w1"]) - auc_rank(alt[ia, "ks"], nul[iu, "ks"]),
          sep_fun(alt[ia, "w1"], nul[iu, "w1"]) - sep_fun(alt[ia, "ks"], nul[iu, "ks"])) })
      diffs[[length(diffs) + 1L]] <- data.frame(
        base = bn, n = n, delta = dl,
        auc_diff_w1_minus_ks = auc_rank(alt[, "w1"], nul[, "w1"]) - auc_rank(alt[, "ks"], nul[, "ks"]),
        auc_diff_mcse = sd(dd[1, ]),
        sep_diff_w1_minus_ks = sep_fun(alt[, "w1"], nul[, "w1"]) - sep_fun(alt[, "ks"], nul[, "ks"]),
        sep_diff_mcse = sd(dd[2, ]))
      cat(sprintf("[cell] %s n=%d delta=%g done (%.1fs)\n", bn, n, dl, as.numeric(Sys.time() - t0, units = "secs")))
    }
  }
}
res <- do.call(rbind, rows)
write.csv(do.call(rbind, diffs), file.path(RES, "auc_sep_differences.csv"), row.names = FALSE)
write.csv(res, file.path(RES, "set4_control_mechanism.csv"), row.names = FALSE)

# SD ratio (b)/(a) of W1-hat and of KS under the null, next to the integral ratio
rel <- function(v) sd_mcse(v) / sd(v)
ratio <- do.call(rbind, lapply(N_GRID, function(n) {
  g <- raw_null[[paste("gauss", n)]]; s <- raw_null[[paste("set4", n)]]
  rw <- sd(s[, "w1"]) / sd(g[, "w1"]); rk <- sd(s[, "ks"]) / sd(g[, "ks"])
  data.frame(n = n,
             sd_ratio_w1 = rw, sd_ratio_w1_mcse = rw * sqrt(rel(s[, "w1"])^2 + rel(g[, "w1"])^2),
             sd_ratio_ks = rk, sd_ratio_ks_mcse = rk * sqrt(rel(s[, "ks"])^2 + rel(g[, "ks"])^2),
             mean_ratio_w1 = mean(s[, "w1"]) / mean(g[, "w1"]),
             integral_ratio = ints$ratio_to_gauss[2])
}))
write.csv(ratio, file.path(RES, "null_sd_ratios.csv"), row.names = FALSE)

# ---- bridge: the Study 1 AUC estimand (one shared anchor sample per rep; 3 matches x {delta 2, 3};
#      within-rep auc_pairs, ties 0.5) -- does the Set 4 W1/KS ordering appear under this estimand?
auc_pairs <- function(dm, dd) mean(outer(dm, dd, function(a, b) (a < b) + 0.5 * (a == b)))
br <- list(); ib <- 0L
for (bn in names(bases)) {
  ib <- ib + 1L; b <- bases[[bn]]
  for (j in seq_along(N_GRID)) {
    n <- N_GRID[j]; set.seed(SEED + 5000L + 100L * ib + j)
    acc <- matrix(NA_real_, N_SIM, 2, dimnames = list(NULL, c("w1", "ks")))
    for (r in seq_len(N_SIM)) {
      a0 <- b$sampler(n)
      m  <- sapply(1:3, function(i) stat2(a0, b$sampler(n)))
      d  <- sapply(DELTAS, function(dl) stat2(a0, b$sampler(n) + dl))
      acc[r, ] <- c(auc_pairs(m["w1", ], d["w1", ]), auc_pairs(m["ks", ], d["ks", ]))
    }
    for (st in c("w1", "ks"))
      br[[length(br) + 1L]] <- data.frame(base = bn, n = n, statistic = st,
                                         study1_auc = mean(acc[, st]), study1_auc_mcse = sd(acc[, st]) / sqrt(N_SIM))
  }
}
bridge <- do.call(rbind, br)
write.csv(bridge, file.path(RES, "study1_estimand_bridge.csv"), row.names = FALSE)

# ---- figure (paper standard: 7 in, base_size 11, white, greyscale) -------------
suppressPackageStartupMessages(library(ggplot2))
pd <- res; pd$statistic <- factor(ifelse(pd$statistic == "w1", "W1", "KS"), levels = c("W1", "KS"))
pd$base <- factor(ifelse(pd$base == "gauss", "(a) N(50, 10^2)", "(b) Set 4 anchor mixture"))
pd$delta <- factor(paste0("delta = ", pd$delta))
p <- ggplot(pd, aes(n, auc, linetype = statistic, shape = statistic)) +
  geom_line(colour = "#1A1A1A") + geom_point(colour = "#1A1A1A", size = 2) +
  geom_errorbar(aes(ymin = auc - 2 * auc_mcse, ymax = auc + 2 * auc_mcse), width = 12, colour = "#1A1A1A") +
  facet_grid(delta ~ base) + scale_x_continuous(breaks = N_GRID) +
  labs(x = "n per region", y = "AUC (shifted vs unshifted pairs)", linetype = NULL, shape = NULL) +
  theme_bw(base_size = 11) + theme(plot.background = element_rect(fill = "white", colour = NA),
                                   legend.position = "bottom")
ggsave(file.path(FIG, "auc_by_n.pdf"), p, width = 7, height = 5, bg = "white")
ggsave(file.path(FIG, "auc_by_n.png"), p, width = 7, height = 5, dpi = 300, bg = "white")

writeLines(capture.output(sessionInfo()), file.path(RES, "sessionInfo.txt"))
cat(sprintf("[done] %.1f min\n", as.numeric(Sys.time() - t0, units = "mins")))
