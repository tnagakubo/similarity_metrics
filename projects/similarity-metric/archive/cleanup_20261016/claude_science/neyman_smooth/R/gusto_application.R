## ---------------------------------------------------------------------------
## gusto_application.R
## Illustration of the Neyman smooth two-sample test on GUSTO-I patient data.
##
## A. Randomised contrast (accelerated t-PA vs SK), continuous variable with
##    heavy digit-preference ties -> behaviour of the test under a true null.
## B. A contrast with negligible standardised mean difference but a real
##    difference in shape -> what a location-only test misses.
## C. Resampling power study at trial-realistic sample sizes on that contrast.
## ---------------------------------------------------------------------------

source("R/neyman_smooth_2sample.R")

GUSTO <- file.path(
  "C:/Users/hrd13/Documents/Gak/0 Study/800Claude/20260210_SIM",
  "similarity_metrics/projects/similarity-metric/data/gusto.csv")

g <- read.csv(GUSTO, stringsAsFactors = FALSE)
CONT <- c("age", "pulse", "sysbp", "height", "weight")

## ===========================================================================
## A. Randomised contrast: t-PA vs SK
## ===========================================================================

A_res <- do.call(rbind, lapply(CONT, function(v) {
  x <- g[[v]][g$tx == "SK"]
  y <- g[[v]][g$tx == "tPA"]
  x <- x[is.finite(x)]; y <- y[is.finite(y)]
  st <- smooth_test_2sample(x, y, d = 4, selection = "BIC",
                            calibrate = "permutation", B = 2000, seed = 1,
                            data.name = paste(v, "SK vs tPA"))
  data.frame(variable = v, m = length(x), n = length(y),
             n_distinct = length(unique(c(x, y))),
             smd = (mean(y) - mean(x)) /
               sqrt((var(x) * (length(x) - 1) + var(y) * (length(y) - 1)) /
                      (length(x) + length(y) - 2)),
             Z1 = st$Z[1], Z2 = st$Z[2], Z3 = st$Z[3], Z4 = st$Z[4],
             k_sel = st$k_selected, W = st$statistic, p_smooth = st$p.value,
             p_t = t.test(y, x)$p.value,
             p_wilcox = suppressWarnings(wilcox.test(y, x)$p.value),
             stringsAsFactors = FALSE)
}))

## ===========================================================================
## B. Screen region pairs for "small SMD but different shape"
## ===========================================================================

reg_n <- table(g$regl)
regs <- as.integer(names(reg_n)[reg_n >= 400])

## Recording granularity must match between the two groups: if one region
## records a variable on a coarser grid than the other, the tie pattern alone
## perturbs the high-order components.  `p_integer` is the proportion of values
## recorded as whole units.
p_int <- function(z) mean(abs(z - round(z)) < 1e-8)

screen <- list()
for (v in CONT) {
  for (i in seq_along(regs)) for (j in seq_along(regs)) if (i < j) {
    x <- g[[v]][g$regl == regs[i]]; y <- g[[v]][g$regl == regs[j]]
    x <- x[is.finite(x)]; y <- y[is.finite(y)]
    if (min(length(x), length(y)) < 400) next
    sp <- sqrt((var(x) * (length(x) - 1) + var(y) * (length(y) - 1)) /
                 (length(x) + length(y) - 2))
    smd <- (mean(y) - mean(x)) / sp
    st <- smooth_test_2sample(x, y, d = 4, selection = "fixed",
                              calibrate = "asymptotic")
    screen[[length(screen) + 1L]] <- data.frame(
      variable = v, r1 = regs[i], r2 = regs[j],
      m = length(x), n = length(y), smd = smd,
      Z1 = st$Z[1], Z2 = st$Z[2], Z3 = st$Z[3], Z4 = st$Z[4],
      W4 = st$W[4], W_beyond_loc = st$W[4] - st$W[1],
      gran_gap = abs(p_int(x) - p_int(y)),
      stringsAsFactors = FALSE)
  }
}
screen <- do.call(rbind, screen)
screen$abs_smd <- abs(screen$smd)
write.csv(screen, "results/gusto_region_screen.csv", row.names = FALSE)

## Contrast used for illustration: negligible standardised mean difference,
## matched recording granularity, largest signal beyond the location component.
cand <- subset(screen, abs_smd < 0.05 & gran_gap < 0.05)
cand <- cand[order(-cand$W_beyond_loc), ]
B_pick <- cand[1, ]

## Counter-example retained as a caveat: same screen but with a large
## granularity gap, where the high-order components partly reflect a
## difference in how the variable was recorded rather than in the population.
caveat <- screen[order(-screen$W_beyond_loc), ]
caveat <- caveat[caveat$abs_smd < 0.05 & caveat$gran_gap > 0.2, ][1, ]

xB <- g[[B_pick$variable]][g$regl == B_pick$r1]
yB <- g[[B_pick$variable]][g$regl == B_pick$r2]
xB <- xB[is.finite(xB)]; yB <- yB[is.finite(yB)]
B_test <- smooth_test_2sample(
  xB, yB, d = 4, selection = "BIC", calibrate = "permutation",
  B = 5000, seed = 2,
  data.name = sprintf("%s, region %d vs %d", B_pick$variable,
                      B_pick$r1, B_pick$r2))

## ===========================================================================
## C. Resampling power at trial-realistic sample sizes on the B contrast
## ===========================================================================

set.seed(99)
NREP_C <- 2000L
sizes_C <- c(50L, 100L, 200L)
C_res <- do.call(rbind, lapply(sizes_C, function(nn) {
  ## exact critical values conditional on the pooled empirical distribution:
  ## draw both groups from the POOLED sample to get the correct null with ties
  pooled <- c(xB, yB)
  cr_sm <- numeric(0); cr_ad <- numeric(0); cr_w <- numeric(0)
  null_sm <- matrix(NA_real_, 4000L, 3L)   # W1, W4, W_sel
  null_ad <- numeric(4000L)
  for (b in seq_len(4000L)) {
    s <- sample(pooled, 2 * nn)
    a <- s[1:nn]; bb <- s[(nn + 1):(2 * nn)]
    st <- smooth_test_2sample(a, bb, d = 4, selection = "BIC",
                              calibrate = "asymptotic")
    null_sm[b, ] <- c(st$W[1], st$W[4], st$statistic)
    null_ad[b] <- ad2_stat(a, bb)
  }
  cr <- apply(null_sm, 2L, quantile, 0.95)
  cr_ad <- quantile(null_ad, 0.95)

  rej <- matrix(FALSE, NREP_C, 6L)
  for (r in seq_len(NREP_C)) {
    a <- sample(xB, nn); bb <- sample(yB, nn)
    st <- smooth_test_2sample(a, bb, d = 4, selection = "BIC",
                              calibrate = "asymptotic")
    rej[r, 1] <- t.test(bb, a)$p.value < 0.05
    rej[r, 2] <- st$W[1] > cr[1]
    rej[r, 3] <- suppressWarnings(ks.test(a, bb)$p.value) < 0.05
    rej[r, 4] <- ad2_stat(a, bb) > cr_ad
    rej[r, 5] <- st$W[4] > cr[2]
    rej[r, 6] <- st$statistic > cr[3]
  }
  data.frame(n_per_arm = nn,
             test = c("t-test (Welch)", "Wilcoxon", "Kolmogorov-Smirnov",
                      "Anderson-Darling", "Smooth k=4",
                      "Smooth data-driven (BIC)"),
             power = colMeans(rej),
             mc_se = sqrt(colMeans(rej) * (1 - colMeans(rej)) / NREP_C),
             stringsAsFactors = FALSE)
}))

write.csv(A_res, "results/gusto_randomised_arms.csv", row.names = FALSE)
write.csv(C_res, "results/gusto_resampling_power.csv", row.names = FALSE)
saveRDS(list(A = A_res, B_pick = B_pick, B_test = B_test, C = C_res,
             xB = xB, yB = yB, screen = screen, caveat = caveat,
             p_t = t.test(yB, xB)$p.value,
             p_w = suppressWarnings(wilcox.test(yB, xB))$p.value),
        "results/gusto_application.rds")
