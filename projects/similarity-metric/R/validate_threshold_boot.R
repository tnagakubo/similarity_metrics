# =============================================================================
# Validation for Part 1B bootstrap-upper-bound selection rule.
#
# Two jobs:
#   (A) MECHANISM (from the cpp directly, no simulation): the upper bootstrap bound
#       really is an upper bound (>= point estimate) and is monotone in the confidence
#       level. If this fails, the rule is not what we claim.
#   (B) RESULTS (from threshold_boot_summary.csv): the conservative rule is more
#       conservative than the point rule -- lower (or equal) violation, at a
#       sensitivity cost -- and higher confidence levels push both down. These are
#       the properties that make it a violation-control device, not a free lunch.
# =============================================================================
.here <- function(f) {
  p <- c(file.path("R", f), f, file.path("projects/similarity-metric/R", f))
  p <- p[file.exists(p)]; if (!length(p)) stop("cannot find ", f); p[1]
}
source(.here("selection_simulation.R"), chdir = TRUE)   # build_set4, w1_dist
Rcpp::sourceCpp(.here("W1_raw_rcpp.cpp"))               # W1_raw_boot_upper_cpp

ok <- TRUE
chk <- function(name, cond, detail = "") {
  cat(sprintf("[%s] %s%s\n", if (isTRUE(cond)) "PASS" else "FAIL", name,
              if (nzchar(detail)) paste0("  -- ", detail) else "")); if (!isTRUE(cond)) ok <<- FALSE
}

# =============================================================================
# (A) MECHANISM -- the cpp function, exercised directly
# =============================================================================
cat("\n--- (A) upper bound is an upper bound, monotone in level ---\n")
set.seed(1L)
S4 <- build_set4()
xA <- S4$A0$sampler(100L); xT2 <- S4$T2$sampler(100L)
probs <- c(0.80, 0.90, 0.95, 0.975, 0.99)
r <- W1_raw_boot_upper_cpp(xA, xT2, B = 4000L, probs = probs)

chk("point estimate matches base-R w1_dist to machine precision",
    abs(r$estimate - w1_dist(xA, xT2)) < 1e-9,
    sprintf("cpp %.6f vs R %.6f", r$estimate, w1_dist(xA, xT2)))
chk("every upper bound is >= the point estimate",
    all(r$upper >= r$estimate - 1e-9),
    sprintf("estimate %.3f; uppers %s", r$estimate, paste(sprintf("%.3f", r$upper), collapse=" ")))
chk("upper bounds are non-decreasing in the confidence level",
    all(diff(r$upper) >= -1e-9),
    paste(sprintf("%.3f", r$upper), collapse = " "))
chk("bit-reproducible under set.seed (same seed -> identical bounds)",
    { set.seed(1L); xA2 <- S4$A0$sampler(100L); xT2b <- S4$T2$sampler(100L)
      r2 <- W1_raw_boot_upper_cpp(xA2, xT2b, B = 4000L, probs = probs)
      max(abs(r2$upper - r$upper)) < 1e-12 })

# =============================================================================
# (B) RESULTS -- the conservative rule behaves like a violation-control device
# =============================================================================
f <- .here("../results/threshold_boot_summary.csv")
if (!file.exists(f)) {
  cat("\n[skip] (B): results/threshold_boot_summary.csv not found -- run threshold_bootstrap_simulation.R first\n")
} else {
  cat("\n--- (B) point vs bootstrap rule, from the simulation ---\n")
  sm <- read.csv(f, stringsAsFactors = FALSE)
  boot_rules <- sort(unique(sm$rule[grepl("^boot_", sm$rule)]))
  top <- boot_rules[length(boot_rules)]   # highest confidence level present

  # paired by (set, n, tau): the bootstrap rule never violates MORE than the point rule
  # by more than Monte Carlo noise, and usually less.
  w <- reshape(sm[c("set","n","tau_clin","rule","violation","sensitivity")],
               idvar = c("set","n","tau_clin"), timevar = "rule", direction = "wide")
  vp <- w[["violation.point"]]; vb <- w[[paste0("violation.", top)]]
  sp <- w[["sensitivity.point"]]; sb <- w[[paste0("sensitivity.", top)]]

  chk("bootstrap rule violation <= point rule violation (up to MC noise), cellwise",
      all(vb <= vp + 0.02),
      sprintf("max (boot - point) violation = %+.3f over %d cells", max(vb - vp), length(vb)))
  chk("bootstrap rule sensitivity <= point rule sensitivity (it is strictly more conservative)",
      all(sb <= sp + 1e-9),
      sprintf("max (boot - point) sensitivity = %+.3f", max(sb - sp)))
  chk("higher confidence level => lower-or-equal violation (monotone control), cellwise",
      { mono <- TRUE
        for (g in split(sm, list(sm$set, sm$n, sm$tau_clin), drop = TRUE)) {
          b <- g[grepl("^boot_", g$rule), ]; b <- b[order(b$rule), ]
          if (nrow(b) >= 2 && any(diff(b$violation) > 0.02)) mono <- FALSE
        }; mono })

  # THE headline question: is there ANY (strict-tau) cell where the point rule violated
  # badly but a bootstrap level pulls violation to tolerable while keeping useful sensitivity?
  strict <- do.call(rbind, lapply(split(sm, list(sm$set, sm$n), drop = TRUE), function(g) {
    tmin <- min(g$tau_clin); g[abs(g$tau_clin - tmin) < 1e-9, ]
  }))
  pt <- subset(strict, rule == "point")
  worst_pt <- if (nrow(pt)) max(pt$violation) else NA_real_
  band <- subset(strict, grepl("^boot_", rule) & violation <= 0.10 & sensitivity >= 0.20)
  cat(sprintf("    [report] worst point-rule violation at strict tau: %.3f\n", worst_pt))
  cat(sprintf("    [report] strict-tau cells where a bootstrap level gives viol<=0.10 AND sens>=0.20: %d\n",
              nrow(band)))
  if (nrow(band)) {
    for (i in seq_len(nrow(band))) cat(sprintf("             %s n=%d %s: viol=%.3f sens=%.3f\n",
        band$set[i], band$n[i], band$rule[i], band$violation[i], band$sensitivity[i]))
  } else {
    cat("             (none -- honest finding: the upper bound buys control only outside the strict band)\n")
  }
}

cat(sprintf("\n===== BOOTSTRAP-RULE VALIDATION %s =====\n", if (ok) "ALL PASS" else "HAS FAILURES"))
if (!ok) quit(status = 1L)
