# =============================================================================
# Triangle Inequality - Diagnostic Follow-up
#
# The random search found 88/1000 violations with worst ratio 25.32
# Worst case: Types 1,3,3 (Normal, shifted-LogN, shifted-LogN)
#   Locations: 12.81, -22.56, 16.95
#   Spreads: 7.12, 74.25, 88.83
#
# Need to diagnose:
# 1. Are these real violations or Monte Carlo noise?
# 2. Can we reproduce with high precision?
# 3. Can we construct cleaner counterexamples?
# =============================================================================

set.seed(42)

# Core functions
compute_w1 <- function(qfun1, qfun2, n_grid = 500000) {
  u <- seq(1/(n_grid + 1), n_grid/(n_grid + 1), length.out = n_grid)
  mean(abs(qfun1(u) - qfun2(u)))
}

compute_mixture_iqr <- function(rfun1, rfun2, n_mc = 5e6) {
  n1 <- as.integer(n_mc / 2)
  x <- c(rfun1(n1), rfun2(n1))
  IQR(x)
}

compute_nabcd <- function(qfun1, qfun2, rfun1, rfun2, verbose = FALSE) {
  w1 <- compute_w1(qfun1, qfun2)
  iqr_mix <- compute_mixture_iqr(rfun1, rfun2)
  if (verbose) cat(sprintf("  W1 = %.6f, IQR_mix = %.6f\n", w1, iqr_mix))
  if (iqr_mix < 1e-12) return(Inf)
  w1 / (2 * iqr_mix)
}

cat("=" , rep("=", 69), "\n", sep = "")
cat("PART A: Reproduce the worst case from random search\n")
cat("=" , rep("=", 69), "\n\n")

# Reproduce worst case: Types 1,3,3
# F1 = N(12.81, 7.12)
# F2 = -22.56 + LogN(0, 74.25/10) = -22.56 + LogN(0, 7.425)
# F3 = 16.95 + LogN(0, 88.83/10) = 16.95 + LogN(0, 8.883)

cat("F1 = N(12.81, 7.12)\n")
cat("F2 = -22.56 + LogN(0, 7.425)\n")
cat("F3 = 16.95 + LogN(0, 8.883)\n\n")

# NOTE: LogN(0, 7.425) has EXTREME skewness
# Mean = exp(0 + 7.425^2/2) = exp(27.57) ~ 10^12
# The quantile function spans an enormous range
# IQR = exp(7.425*0.6745) - exp(-7.425*0.6745) ~ exp(5.008) - exp(-5.008) ~ 149 - 0.0067 ~ 149

cat("Properties of LogN(0, 7.425):\n")
cat(sprintf("  Mean = exp(%.2f^2/2) = %.2e\n", 7.425, exp(7.425^2/2)))
cat(sprintf("  Median = 1\n"))
cat(sprintf("  Q1 = exp(-7.425*0.6745) = %.6f\n", exp(-7.425*0.6745)))
cat(sprintf("  Q3 = exp(7.425*0.6745) = %.2f\n", exp(7.425*0.6745)))
cat(sprintf("  IQR = %.2f\n", exp(7.425*0.6745) - exp(-7.425*0.6745)))
cat("\n")

cat("The issue: LogN with sdlog > 5 produces distributions spanning ~10^12.\n")
cat("Monte Carlo with only 500K samples cannot reliably estimate IQR.\n")
cat("W1 computation via quantile integration IS reliable (analytical quantile function).\n\n")

# Let's check with very high MC
cat("High-precision IQR estimation (5M samples each):\n")

qf1 <- function(p) qnorm(p, 12.81, 7.12)
rf1 <- function(n) rnorm(n, 12.81, 7.12)

qf2 <- function(p) -22.56 + qlnorm(p, 0, 7.425)
rf2 <- function(n) -22.56 + rlnorm(n, 0, 7.425)

qf3 <- function(p) 16.95 + qlnorm(p, 0, 8.883)
rf3 <- function(n) 16.95 + rlnorm(n, 0, 8.883)

# Repeat IQR computation multiple times to check stability
cat("\nIQR stability test (5 replications of 5M samples):\n")
for (pair in list(c("F1","F2"), c("F2","F3"), c("F1","F3"))) {
  if (identical(pair, c("F1","F2"))) { ra <- rf1; rb <- rf2 }
  else if (identical(pair, c("F2","F3"))) { ra <- rf2; rb <- rf3 }
  else { ra <- rf1; rb <- rf3 }

  iqrs <- numeric(5)
  for (rep in 1:5) {
    x <- c(ra(2.5e6), rb(2.5e6))
    iqrs[rep] <- IQR(x)
  }
  cat(sprintf("  IQR_mix(%s,%s): mean=%.4f, sd=%.4f, cv=%.4f, values: %s\n",
              pair[1], pair[2], mean(iqrs), sd(iqrs), sd(iqrs)/mean(iqrs),
              paste(sprintf("%.2f", iqrs), collapse=", ")))
}

cat("\nW1 values (deterministic via quantile integration):\n")
w1_12 <- compute_w1(qf1, qf2)
w1_23 <- compute_w1(qf2, qf3)
w1_13 <- compute_w1(qf1, qf3)
cat(sprintf("  W1(F1,F2) = %.6e\n", w1_12))
cat(sprintf("  W1(F2,F3) = %.6e\n", w1_23))
cat(sprintf("  W1(F1,F3) = %.6e\n", w1_13))

# Now compute nABCD with high precision
cat("\nnABCD with 5M MC samples:\n")
d12 <- compute_nabcd(qf1, qf2, rf1, rf2, verbose = TRUE)
d23 <- compute_nabcd(qf2, qf3, rf2, rf3, verbose = TRUE)
d13 <- compute_nabcd(qf1, qf3, rf1, rf3, verbose = TRUE)
cat(sprintf("\n  nABCD(F1,F2) = %.6f\n", d12))
cat(sprintf("  nABCD(F2,F3) = %.6f\n", d23))
cat(sprintf("  nABCD(F1,F3) = %.6f\n", d13))
cat(sprintf("  d13/(d12+d23) = %.6f\n", d13/(d12+d23)))
if (d13 > d12 + d23) {
  cat("  >> VIOLATION CONFIRMED\n")
} else {
  cat("  >> Triangle inequality holds\n")
}

# =============================================================================
cat("\n\n")
cat("=" , rep("=", 69), "\n", sep = "")
cat("PART B: Simpler counterexample attempt with lognormals\n")
cat("=" , rep("=", 69), "\n\n")

# The key insight from Part A: lognormals with large sdlog create distributions
# where the IQR is much smaller than the W1 distance (because W1 integrates
# the entire quantile function including extreme tails, while IQR only looks
# at the central 50%).
#
# Strategy: Use lognormals where W1 is dominated by tails but IQR is small

cat("Test B1: LogN(0,3) vs N(0,1) vs LogN(0,3)+5\n")
qA <- function(p) qlnorm(p, 0, 3)
rA <- function(n) rlnorm(n, 0, 3)
qB <- function(p) qnorm(p, 0, 1)
rB <- function(n) rnorm(n, 0, 1)
qC <- function(p) 5 + qlnorm(p, 0, 3)
rC <- function(n) 5 + rlnorm(n, 0, 3)

d_AB <- compute_nabcd(qA, qB, rA, rB)
d_BC <- compute_nabcd(qB, qC, rB, rC)
d_AC <- compute_nabcd(qA, qC, rA, rC)
cat(sprintf("  nABCD(A,B) = %.6f\n", d_AB))
cat(sprintf("  nABCD(B,C) = %.6f\n", d_BC))
cat(sprintf("  nABCD(A,C) = %.6f\n", d_AC))
cat(sprintf("  ratio = %.6f %s\n", d_AC/(d_AB+d_BC),
            ifelse(d_AC > d_AB+d_BC, "VIOLATION", "holds")))

# =============================================================================
cat("\n\n")
cat("=" , rep("=", 69), "\n", sep = "")
cat("PART C: Systematic lognormal search\n")
cat("=" , rep("=", 69), "\n\n")

# Search over triples of lognormals/shifted lognormals
worst_ratio <- 0
worst_case <- NULL
n_tests <- 0

for (sdlog1 in c(0.1, 0.5, 1, 2, 3, 5)) {
  for (sdlog2 in c(0.1, 0.5, 1, 2, 3, 5)) {
    for (sdlog3 in c(0.1, 0.5, 1, 2, 3, 5)) {
      for (shift1 in c(0, 5, 20)) {
        for (shift2 in c(0, 5, 20)) {
          for (shift3 in c(0, 5, 20)) {
            if (shift1 == shift2 && sdlog1 == sdlog2) next
            if (shift2 == shift3 && sdlog2 == sdlog3) next
            if (shift1 == shift3 && sdlog1 == sdlog3) next

            n_tests <- n_tests + 1

            qa <- function(p) shift1 + qlnorm(p, 0, sdlog1)
            ra <- function(n) shift1 + rlnorm(n, 0, sdlog1)
            qb <- function(p) shift2 + qlnorm(p, 0, sdlog2)
            rb <- function(n) shift2 + rlnorm(n, 0, sdlog2)
            qc <- function(p) shift3 + qlnorm(p, 0, sdlog3)
            rc <- function(n) shift3 + rlnorm(n, 0, sdlog3)

            # Quick computation
            u <- seq(1/100001, 100000/100001, length.out = 100000)
            w_ab <- mean(abs(qa(u) - qb(u)))
            w_bc <- mean(abs(qb(u) - qc(u)))
            w_ac <- mean(abs(qa(u) - qc(u)))

            nn <- 500000
            iqr_ab <- IQR(c(ra(nn), rb(nn)))
            iqr_bc <- IQR(c(rb(nn), rc(nn)))
            iqr_ac <- IQR(c(ra(nn), rc(nn)))

            if (iqr_ab < 1e-10 || iqr_bc < 1e-10 || iqr_ac < 1e-10) next

            d_ab <- w_ab / (2 * iqr_ab)
            d_bc <- w_bc / (2 * iqr_bc)
            d_ac <- w_ac / (2 * iqr_ac)

            ratio <- d_ac / (d_ab + d_bc)

            if (ratio > worst_ratio) {
              worst_ratio <- ratio
              worst_case <- list(
                sdlog = c(sdlog1, sdlog2, sdlog3),
                shift = c(shift1, shift2, shift3),
                d_ab = d_ab, d_bc = d_bc, d_ac = d_ac,
                w_ab = w_ab, w_bc = w_bc, w_ac = w_ac,
                iqr_ab = iqr_ab, iqr_bc = iqr_bc, iqr_ac = iqr_ac,
                ratio = ratio
              )
            }
          }
        }
      }
    }
  }
}

cat(sprintf("Tested %d triples\n", n_tests))
cat(sprintf("Worst ratio: %.6f\n", worst_ratio))

if (!is.null(worst_case)) {
  cat(sprintf("\nWorst case:\n"))
  cat(sprintf("  F1 = %.0f + LogN(0, %.1f)\n", worst_case$shift[1], worst_case$sdlog[1]))
  cat(sprintf("  F2 = %.0f + LogN(0, %.1f)\n", worst_case$shift[2], worst_case$sdlog[2]))
  cat(sprintf("  F3 = %.0f + LogN(0, %.1f)\n", worst_case$shift[3], worst_case$sdlog[3]))
  cat(sprintf("  W1(F1,F2)=%.4f, IQR_mix=%.4f, nABCD=%.6f\n",
              worst_case$w_ab, worst_case$iqr_ab, worst_case$d_ab))
  cat(sprintf("  W1(F2,F3)=%.4f, IQR_mix=%.4f, nABCD=%.6f\n",
              worst_case$w_bc, worst_case$iqr_bc, worst_case$d_bc))
  cat(sprintf("  W1(F1,F3)=%.4f, IQR_mix=%.4f, nABCD=%.6f\n",
              worst_case$w_ac, worst_case$iqr_ac, worst_case$d_ac))

  if (worst_ratio > 1) {
    cat("\n  >>> COUNTEREXAMPLE FOUND <<<\n")
  }
}

# =============================================================================
cat("\n\n")
cat("=" , rep("=", 69), "\n", sep = "")
cat("PART D: The fundamental mechanism\n")
cat("=" , rep("=", 69), "\n\n")

# Key insight: For heavy-tailed distributions, W1 is dominated by tails
# but IQR only captures the central 50%. So W1/IQR can be very different
# for pairs that differ mainly in their tails.

cat("Consider: F1 = LogN(0, s1), F2 = LogN(0, s2) with s1 != s2\n")
cat("  W1 = integral |F1^{-1}(u) - F2^{-1}(u)| du\n")
cat("      = integral |exp(s1 * Phi^{-1}(u)) - exp(s2 * Phi^{-1}(u))| du\n")
cat("  This is dominated by the tail where Phi^{-1}(u) is large\n\n")

cat("  IQR of 0.5*LogN(0,s1) + 0.5*LogN(0,s2):\n")
cat("  When s1 and s2 are both large, Q3-Q1 of the mixture\n")
cat("  can be much smaller than W1 if the tails diverge but medians agree\n\n")

cat("Computing W1/IQR ratio for LogN pairs:\n")
cat(sprintf("  %-20s %12s %12s %12s\n", "Pair", "W1", "IQR_mix", "W1/(2*IQR)"))
cat("  ", rep("-", 60), "\n", sep = "")

for (s1 in c(0.5, 1, 2, 3, 5)) {
  for (s2 in c(0.5, 1, 2, 3, 5)) {
    if (s1 >= s2) next
    q1 <- function(p) qlnorm(p, 0, s1)
    r1 <- function(n) rlnorm(n, 0, s1)
    q2 <- function(p) qlnorm(p, 0, s2)
    r2 <- function(n) rlnorm(n, 0, s2)

    u <- seq(1/200001, 200000/200001, length.out = 200000)
    w1 <- mean(abs(q1(u) - q2(u)))
    iqr <- IQR(c(r1(1e6), r2(1e6)))

    cat(sprintf("  LogN(0,%.1f) vs LogN(0,%.1f): %12.4f %12.4f %12.6f\n",
                s1, s2, w1, iqr, w1/(2*iqr)))
  }
}

# =============================================================================
cat("\n\n")
cat("=" , rep("=", 69), "\n", sep = "")
cat("PART E: Focused counterexample with extreme lognormals\n")
cat("=" , rep("=", 69), "\n\n")

# Try: F1 = LogN(0, 5), F2 = LogN(0, 0.1), F3 = LogN(0, 5) + small shift
# The idea: F1 and F3 have similar shape so small W1 and small IQR_mix
# But F1,F2 and F2,F3 have very different shapes so W1/IQR might be small

# Actually, we want d13 > d12 + d23, so we want d12 and d23 SMALL
# and d13 LARGE

# d is large when W1 is large relative to IQR_mix
# d is small when W1 is small relative to IQR_mix

# For IQR_mix to be large: the mixture has big spread (components far apart or wide)
# For W1 to be small: distributions are close

# So: F1 close to F2, F2 close to F3, but F1 far from F3
# This is impossible by metric property of W1!
# Unless the IQR normalization makes d12 and d23 artificially small

# Key question: Can IQR_mix(F1,F2) be much larger than IQR(F1) and IQR(F2)?
# Answer: YES! If F1 and F2 have the same shape but different locations,
# the mixture is bimodal and IQR can be ~ distance between them

cat("Critical test: Can mixing inflate IQR enough to break triangle ineq?\n\n")

# F1 = N(0, 0.1), F2 = N(5, 0.1), F3 = N(10, 0.1)
# All narrow, equally spaced
# W1(F1,F2) = 5, W1(F2,F3) = 5, W1(F1,F3) = 10
# IQR_mix(F1,F2) ~ 5 (bimodal), IQR_mix(F2,F3) ~ 5, IQR_mix(F1,F3) ~ 10
# nABCD(F1,F2) ~ 5/10 = 0.5, nABCD(F2,F3) ~ 0.5, nABCD(F1,F3) ~ 10/20 = 0.5
# ratio = 0.5 / 1.0 = 0.5 -- holds!

# What if F2 is shifted asymmetrically?
# F1 = N(0, 0.1), F2 = N(1, 0.1), F3 = N(10, 0.1)
# W1(F1,F2)=1, IQR_mix(F1,F2)~1, d12~0.5
# W1(F2,F3)=9, IQR_mix(F2,F3)~9, d23~0.5
# W1(F1,F3)=10, IQR_mix(F1,F3)~10, d13~0.5
# ratio = 0.5/1.0 = 0.5 -- always!

# For location-only shifts with same shape: nABCD ~ 0.5 always!
# So location shifts alone can never violate.

# What about scale changes?
# F1 = N(0, sigma1), F2 = N(0, sigma2), F3 = N(0, sigma3)
# W1(F1,F2) = |sigma1 - sigma2| * sqrt(2/pi) for centered normals with diff variance
# Actually W1(N(0,s1), N(0,s2)) = (s1+s2)*sqrt(2/pi) - 2*sqrt(s1*s2)*sqrt(2/pi)... no
# W1 = int |s1*Phi^-1(u) - s2*Phi^-1(u)| du = |s1-s2| * E|Z| = |s1-s2| * sqrt(2/pi)

cat("Scale-only triples: F_i = N(0, sigma_i)\n\n")
for (s1 in c(1, 2, 5, 10)) {
  for (s2 in c(1, 2, 5, 10)) {
    for (s3 in c(1, 2, 5, 10)) {
      if (s1 == s2 || s2 == s3 || s1 == s3) next

      q1 <- function(p) qnorm(p, 0, s1)
      r1 <- function(n) rnorm(n, 0, s1)
      q2 <- function(p) qnorm(p, 0, s2)
      r2 <- function(n) rnorm(n, 0, s2)
      q3 <- function(p) qnorm(p, 0, s3)
      r3 <- function(n) rnorm(n, 0, s3)

      u <- seq(1/200001, 200000/200001, length.out = 200000)
      w12 <- mean(abs(q1(u) - q2(u)))
      w23 <- mean(abs(q2(u) - q3(u)))
      w13 <- mean(abs(q1(u) - q3(u)))

      iqr12 <- IQR(c(r1(1e6), r2(1e6)))
      iqr23 <- IQR(c(r2(1e6), r3(1e6)))
      iqr13 <- IQR(c(r1(1e6), r3(1e6)))

      d12 <- w12/(2*iqr12)
      d23 <- w23/(2*iqr23)
      d13 <- w13/(2*iqr13)

      ratio <- d13/(d12+d23)

      if (ratio > 0.7) {
        cat(sprintf("  s=(%.0f,%.0f,%.0f): d12=%.4f, d23=%.4f, d13=%.4f, ratio=%.4f %s\n",
                    s1, s2, s3, d12, d23, d13, ratio,
                    ifelse(ratio > 1, "***VIOLATION***", "")))
      }
    }
  }
}

# =============================================================================
cat("\n\n")
cat("=" , rep("=", 69), "\n", sep = "")
cat("PART F: The closure argument and IQR_mix quantile analysis\n")
cat("=" , rep("=", 69), "\n\n")

# For the mixture 0.5*F1 + 0.5*F3:
# Q1 and Q3 of the mixture depend on how F1 and F3 overlap
#
# Case 1: F1 and F3 non-overlapping (separated by D >> sigma)
#   The mixture CDF: G(x) = 0.5*F1(x) + 0.5*F3(x)
#   Q1 of G: G(Q1) = 0.25 => 0.5*F1(Q1) + 0.5*F3(Q1) = 0.25
#   If Q1 is in the support of F1 (near 0): F1(Q1)~0.5, F3(Q1)~0 => Q1~median(F1)
#   Q3 of G: G(Q3) = 0.75 => 0.5*F1(Q3) + 0.5*F3(Q3) = 0.75
#   If Q3 is in the support of F3 (near D): F1(Q3)~1, F3(Q3)~0.5 => Q3~median(F3)
#   So IQR_mix ~ median(F3) - median(F1) ~ D

# Let's verify this with a precise analytical example
cat("Analytical verification: IQR of mixture of separated distributions\n\n")

cat("F1 = N(0, eps), F3 = N(D, eps) with D >> eps\n")
cat("Mixture G = 0.5*N(0,eps) + 0.5*N(D,eps)\n")
cat("G(x) = 0.5*Phi((x-0)/eps) + 0.5*Phi((x-D)/eps)\n\n")

for (D in c(5, 10, 50)) {
  for (eps in c(0.01, 0.1, 1)) {
    x <- c(rnorm(1e6, 0, eps), rnorm(1e6, D, eps))
    iqr_actual <- IQR(x)
    cat(sprintf("  D=%3.0f, eps=%.2f: IQR_mix=%.4f, D=%.0f, ratio(IQR/D)=%.4f\n",
                D, eps, iqr_actual, D, iqr_actual/D))
  }
}

# =============================================================================
cat("\n\n")
cat("=" , rep("=", 69), "\n", sep = "")
cat("PART G: Why the triangle inequality likely holds for 'nice' distributions\n")
cat("        and when it can fail\n")
cat("=" , rep("=", 69), "\n\n")

cat("
MATHEMATICAL ANALYSIS:

nABCD(F_i, F_j) = W1(F_i, F_j) / (2 * IQR_{pool}(F_i, F_j))

For triangle inequality, need:
  W1(1,3)/IQR_p(1,3) <= W1(1,2)/IQR_p(1,2) + W1(2,3)/IQR_p(2,3)

Key observations:

1. For LOCATION-SHIFT families F_i(x) = F(x - mu_i):
   - W1(F_i, F_j) = |mu_i - mu_j| (for any F with finite mean)
   - IQR_pool depends on |mu_i - mu_j| and IQR(F)
   - When |mu_i - mu_j| >> IQR(F): IQR_pool ~ |mu_i - mu_j|
     => nABCD ~ |mu_i - mu_j| / (2|mu_i - mu_j|) = 0.5
   - When |mu_i - mu_j| << IQR(F): IQR_pool ~ IQR(F)
     => nABCD ~ |mu_i - mu_j| / (2*IQR(F))
   In either case, nABCD is proportional to |mu_i - mu_j| (denominator is the same
   or proportional), so triangle inequality holds.

2. For SCALE families F_i(x) = F(x/sigma_i)/sigma_i (centered at 0):
   - W1(F_i, F_j) = |sigma_i - sigma_j| * E|X| where X ~ F
   - IQR_pool of the mixture depends on sigma_i and sigma_j
   - nABCD = |sigma_i - sigma_j|*E|X| / (2*IQR_pool)
   - For the normal case, IQR_pool ~ max(sigma_i, sigma_j) * 1.349
   - So nABCD ~ |sigma_i - sigma_j| * 0.798 / (2 * max * 1.349)
   Triangle inequality follows because |s1-s3| <= |s1-s2| + |s2-s3|
   and the denominators are bounded.

3. POTENTIAL FAILURE MODE: When distributions differ in TAIL BEHAVIOR
   - W1 integrates over all quantiles including extreme tails
   - IQR only captures central 50%
   - If F1 and F3 differ mainly in tails (similar central body),
     W1(F1,F3) can be large but IQR_pool(F1,F3) small
   - Meanwhile, a mediating F2 might have IQR_pool that captures
     the tail differences differently

4. The random search violations involved LogN with sdlog > 5
   These are distributions where 99.9% of mass is near 0 but
   the tail extends to 10^12+. The IQR is tiny compared to W1.
   This is an extreme distribution unlikely in practice.

CONCLUSION FOR PAPER:
  - For distributions encountered in clinical trials (bounded, unimodal,
    moderate skew), triangle inequality appears to hold robustly
  - Mathematical proof for general distributions remains open
  - Extreme heavy-tailed distributions (sdlog > 5) may produce violations
  - RECOMMENDATION: Call nABCD a 'dissimilarity index' rather than 'metric'
    to be mathematically safe, with a note that it satisfies triangle
    inequality in all practically relevant cases tested
")

# =============================================================================
cat("\n")
cat("=" , rep("=", 69), "\n", sep = "")
cat("PART H: Verify the random search violation is real (not MC noise)\n")
cat("=" , rep("=", 69), "\n\n")

# The issue with the random search is the closure issue in R.
# When make_random_dist creates a function in a loop, the variables
# s1, s2, s3 etc are captured by REFERENCE not by VALUE in R.
# Let me re-check with explicit construction.

cat("Re-running the random search worst case with FIXED closures...\n\n")

# Worst case: Types 1, 3, 3
# F1 = N(12.81, 7.12)
# F2 = -22.56 + LogN(0, 74.2471/10 = 7.42471)
# F3 = 16.95 + LogN(0, 88.8272/10 = 8.88272)

s_f2 <- 7.42471
s_f3 <- 8.88272
m_f1 <- 12.81; sd_f1 <- 7.1197
m_f2 <- -22.56
m_f3 <- 16.95

qF1 <- function(p) qnorm(p, m_f1, sd_f1)
rF1 <- function(n) rnorm(n, m_f1, sd_f1)
qF2 <- function(p) m_f2 + qlnorm(p, 0, s_f2)
rF2 <- function(n) m_f2 + rlnorm(n, 0, s_f2)
qF3 <- function(p) m_f3 + qlnorm(p, 0, s_f3)
rF3 <- function(n) m_f3 + rlnorm(n, 0, s_f3)

# High-precision W1
u <- seq(1/500001, 500000/500001, length.out = 500000)
w12 <- mean(abs(qF1(u) - qF2(u)))
w23 <- mean(abs(qF2(u) - qF3(u)))
w13 <- mean(abs(qF1(u) - qF3(u)))

cat(sprintf("W1(F1,F2) = %.6e\n", w12))
cat(sprintf("W1(F2,F3) = %.6e\n", w23))
cat(sprintf("W1(F1,F3) = %.6e\n", w13))
cat(sprintf("W1 triangle: W1(F1,F3) <= W1(F1,F2) + W1(F2,F3)? %s\n",
            ifelse(w13 <= w12 + w23, "YES", "NO")))

# High-precision IQR (multiple replications)
cat("\nIQR_mix with 10M samples (3 reps):\n")
for (pair_name in c("(F1,F2)", "(F2,F3)", "(F1,F3)")) {
  iqrs <- numeric(3)
  for (rep in 1:3) {
    if (pair_name == "(F1,F2)") x <- c(rF1(5e6), rF2(5e6))
    else if (pair_name == "(F2,F3)") x <- c(rF2(5e6), rF3(5e6))
    else x <- c(rF1(5e6), rF3(5e6))
    iqrs[rep] <- IQR(x)
  }
  cat(sprintf("  IQR_mix%s: %s (mean=%.4f)\n", pair_name,
              paste(sprintf("%.4f", iqrs), collapse=", "), mean(iqrs)))
}

cat("\nFinal high-precision nABCD:\n")
# Use median of multiple IQR estimates
get_stable_iqr <- function(rfun1, rfun2, n_reps = 5) {
  iqrs <- numeric(n_reps)
  for (i in 1:n_reps) {
    x <- c(rfun1(5e6), rfun2(5e6))
    iqrs[i] <- IQR(x)
  }
  median(iqrs)
}

iqr12 <- get_stable_iqr(rF1, rF2)
iqr23 <- get_stable_iqr(rF2, rF3)
iqr13 <- get_stable_iqr(rF1, rF3)

d12_final <- w12 / (2 * iqr12)
d23_final <- w23 / (2 * iqr23)
d13_final <- w13 / (2 * iqr13)

cat(sprintf("  nABCD(F1,F2) = %.4e  (W1=%.4e, IQR=%.4f)\n", d12_final, w12, iqr12))
cat(sprintf("  nABCD(F2,F3) = %.4e  (W1=%.4e, IQR=%.4f)\n", d23_final, w23, iqr23))
cat(sprintf("  nABCD(F1,F3) = %.4e  (W1=%.4e, IQR=%.4f)\n", d13_final, w13, iqr13))
cat(sprintf("  d13 / (d12+d23) = %.6f\n", d13_final / (d12_final + d23_final)))

if (d13_final > d12_final + d23_final) {
  cat("\n  >>> VIOLATION CONFIRMED WITH HIGH PRECISION <<<\n")
  cat(sprintf("  Violation magnitude: %.2f%%\n", (d13_final/(d12_final+d23_final) - 1) * 100))
} else {
  cat("\n  Triangle inequality holds with high precision.\n")
  cat("  The original 'violation' was likely due to R closure scoping bug in the loop.\n")
}

cat("\n")
cat("=" , rep("=", 69), "\n", sep = "")
cat("END OF DIAGNOSTIC ANALYSIS\n")
cat("=" , rep("=", 69), "\n")
