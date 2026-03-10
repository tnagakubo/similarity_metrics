# =============================================================================
# Triangle Inequality Analysis for nABCD
# Mike Ross - Methodological Investigation
# Date: 2026-03-10
#
# Question from Reviewer R2:
#   Does nABCD satisfy the triangle inequality?
#
# nABCD(F1, F2) = W1(F1, F2) / (2 * IQR_pooled)
# where IQR_pooled = IQR of the mixture (F1 + F2)/2
# =============================================================================

cat("======================================================================\n")
cat("TRIANGLE INEQUALITY INVESTIGATION FOR nABCD\n")
cat("Mike Ross - Methodological Analysis\n")
cat("======================================================================\n\n")

# --- Helper functions ---

w1_normal <- function(mu1, s1, mu2, s2, n = 2e6) {
  lo <- min(mu1 - 7*s1, mu2 - 7*s2)
  hi <- max(mu1 + 7*s1, mu2 + 7*s2)
  x  <- seq(lo, hi, length.out = n)
  dx <- x[2] - x[1]
  sum(abs(pnorm(x, mu1, s1) - pnorm(x, mu2, s2))) * dx
}

iqr_mixture <- function(mu1, s1, mu2, s2) {
  mcdf <- function(x) 0.5*pnorm(x, mu1, s1) + 0.5*pnorm(x, mu2, s2)
  lo <- min(mu1 - 7*s1, mu2 - 7*s2)
  hi <- max(mu1 + 7*s1, mu2 + 7*s2)
  q25 <- uniroot(function(x) mcdf(x) - 0.25, c(lo, hi))$root
  q75 <- uniroot(function(x) mcdf(x) - 0.75, c(lo, hi))$root
  q75 - q25
}

nabcd_fn <- function(mu1, s1, mu2, s2) {
  w1  <- w1_normal(mu1, s1, mu2, s2)
  iqr <- iqr_mixture(mu1, s1, mu2, s2)
  list(nabcd = w1 / (2*iqr), w1 = w1, iqr = iqr)
}

check_triangle <- function(mu1, s1, mu2, s2, mu3, s3, label = "") {
  r13 <- nabcd_fn(mu1, s1, mu3, s3)
  r12 <- nabcd_fn(mu1, s1, mu2, s2)
  r23 <- nabcd_fn(mu2, s2, mu3, s3)

  lhs <- r13$nabcd
  rhs <- r12$nabcd + r23$nabcd
  violated <- lhs > rhs + 1e-10

  if (label != "") cat(sprintf("\n--- %s ---\n", label))
  cat(sprintf("F1=N(%.1f,%.2f) F2=N(%.1f,%.2f) F3=N(%.1f,%.2f)\n",
              mu1, s1, mu2, s2, mu3, s3))
  cat(sprintf("  nABCD(1,3)=%.4f [W1=%.3f IQR=%.3f]\n", r13$nabcd, r13$w1, r13$iqr))
  cat(sprintf("  nABCD(1,2)=%.4f [W1=%.3f IQR=%.3f]\n", r12$nabcd, r12$w1, r12$iqr))
  cat(sprintf("  nABCD(2,3)=%.4f [W1=%.3f IQR=%.3f]\n", r23$nabcd, r23$w1, r23$iqr))
  cat(sprintf("  LHS=%.6f  RHS=%.6f  %s\n", lhs, rhs,
              if (violated) "*** VIOLATED ***" else "OK"))

  invisible(list(lhs = lhs, rhs = rhs, violated = violated,
                 r13 = r13, r12 = r12, r23 = r23))
}

# =============================================================================
# PART 1: Understanding IQR_pool behavior
# =============================================================================
cat("----------------------------------------------------------------------\n")
cat("PART 1: Understanding IQR_pool for different mixture types\n")
cat("----------------------------------------------------------------------\n\n")

cat("Key insight: The IQR of mixture 0.5*F1 + 0.5*F2 depends on the\n")
cat("relative scales. When one component is very narrow (spike), the\n")
cat("spike pulls quartiles together, making IQR_pool SMALL.\n\n")

configs <- list(
  list(0, 1, 0, 1, "Same N(0,1)"),
  list(0, 1, 5, 1, "Shifted, same scale"),
  list(0, 1, 0, 10, "Same mean, different scale"),
  list(0, 0.1, 0, 10, "Narrow + Wide (spike effect)")
)

for (cfg in configs) {
  iqr <- iqr_mixture(cfg[[1]], cfg[[2]], cfg[[3]], cfg[[4]])
  cat(sprintf("  mix(N(%.1f,%.1f), N(%.1f,%.1f)): IQR = %.4f  [%s]\n",
              cfg[[1]], cfg[[2]], cfg[[3]], cfg[[4]], iqr, cfg[[5]]))
}

# =============================================================================
# PART 2: Systematic search for violation
# =============================================================================
cat("\n----------------------------------------------------------------------\n")
cat("PART 2: Systematic search for triangle inequality violation\n")
cat("----------------------------------------------------------------------\n\n")

# Strategy: F1 and F3 both wide (large IQR_pool for sides that include them
# with a narrow F2), but with a large location shift between F1 and F3.
# F2 is narrow - so mix(F1,F2) and mix(F2,F3) have tiny IQR_pool (spike effect)
# mix(F1,F3) has large IQR_pool (both wide, shifted)
#
# Wait - this makes nABCD(F1,F2) and nABCD(F2,F3) LARGE (tiny denominator).
# We need the OPPOSITE: nABCD(F1,F3) large, sides small.
#
# For nABCD(F1,F3) to be large: large W1(F1,F3) and/or small IQR_pool(F1,F3)
# For nABCD(F1,F2) to be small: small W1(F1,F2) and/or large IQR_pool(F1,F2)
# For nABCD(F2,F3) to be small: small W1(F2,F3) and/or large IQR_pool(F2,F3)
#
# So: F1 and F3 are very different (large W1) but their mix has small IQR
#     F2 is "between" F1 and F3, close to both in W1 sense
#     mix(F1,F2) and mix(F2,F3) have large IQR
#
# Try: F1=N(-d, eps), F2=Uniform-like/wide, F3=N(d, eps)
# mix(F1,F3) = bimodal with 2 spikes => IQR related to 2d (large IQR!)
# Hmm, that makes IQR_pool(F1,F3) LARGE, which gives small nABCD(F1,F3).

# Let's try all permutations. The violation is:
# nABCD(Fi, Fk) > nABCD(Fi, Fj) + nABCD(Fj, Fk)
# for SOME i,j,k (not necessarily 1,2,3 in that order)

cat("Strategy A: F2 wide (mediator), F1 and F3 narrow shifted\n")
check_triangle(0, 0.1, 0, 10, 5, 0.1, "A1: narrow-wide-narrow")

cat("\nStrategy B: F2 narrow (mediator), F1 and F3 wide\n")
check_triangle(0, 10, 0, 0.1, 5, 10, "B1: wide-narrow-wide")

cat("\nStrategy C: All different - check all 3 orderings\n")
cat("\nC1: F1=N(0,1), F2=N(3,1), F3=N(0,10)\n")
res <- check_triangle(0, 1, 3, 1, 0, 10, "C1a: (1,3) vs (1,2)+(2,3)")
check_triangle(0, 1, 0, 10, 3, 1, "C1b: reordered (1,2) vs (1,3)+(3,2)")
check_triangle(3, 1, 0, 1, 0, 10, "C1c: reordered")

# =============================================================================
# PART 3: Aggressive search with extreme parameters
# =============================================================================
cat("\n----------------------------------------------------------------------\n")
cat("PART 3: Aggressive parameter search\n")
cat("----------------------------------------------------------------------\n\n")

best_ratio <- 0
best_config <- NULL

# Try many combinations
for (mu2 in c(-5, 0, 2.5, 5, 10)) {
  for (s2 in c(0.01, 0.1, 1, 5, 20, 100)) {
    for (s1 in c(0.01, 0.1, 1, 10)) {
      for (s3 in c(0.01, 0.1, 1, 10)) {
        mu1 <- 0; mu3 <- 5

        # Quick check - skip if IQR will be problematic
        tryCatch({
          r13 <- nabcd_fn(mu1, s1, mu3, s3)
          r12 <- nabcd_fn(mu1, s1, mu2, s2)
          r23 <- nabcd_fn(mu2, s2, mu3, s3)

          # Check all 3 triangle inequality directions
          # (i,k) vs (i,j)+(j,k) for all orderings
          ratios <- c(
            r13$nabcd / (r12$nabcd + r23$nabcd),  # (1,3) vs (1,2)+(2,3)
            r12$nabcd / (r13$nabcd + r23$nabcd),  # (1,2) vs (1,3)+(3,2)  [note: nabcd symmetric]
            r23$nabcd / (r12$nabcd + r13$nabcd)   # (2,3) vs (2,1)+(1,3)
          )

          max_ratio <- max(ratios, na.rm = TRUE)
          if (is.finite(max_ratio) && max_ratio > best_ratio) {
            best_ratio <- max_ratio
            which_max <- which.max(ratios)
            best_config <- list(mu1=mu1, s1=s1, mu2=mu2, s2=s2, mu3=mu3, s3=s3,
                                ratio=max_ratio, which=which_max,
                                r13=r13, r12=r12, r23=r23)
          }
        }, error = function(e) NULL)
      }
    }
  }
}

cat(sprintf("Best ratio found: %.6f", best_ratio))
if (best_ratio > 1) {
  cat(" *** VIOLATION FOUND ***\n\n")
} else {
  cat(" (no violation found)\n\n")
}

cat(sprintf("Config: F1=N(%.1f,%.2f), F2=N(%.1f,%.2f), F3=N(%.1f,%.2f)\n",
            best_config$mu1, best_config$s1, best_config$mu2, best_config$s2,
            best_config$mu3, best_config$s3))
cat(sprintf("Direction: %d\n", best_config$which))
cat(sprintf("nABCD(1,3)=%.4f [W1=%.3f IQR=%.3f]\n",
            best_config$r13$nabcd, best_config$r13$w1, best_config$r13$iqr))
cat(sprintf("nABCD(1,2)=%.4f [W1=%.3f IQR=%.3f]\n",
            best_config$r12$nabcd, best_config$r12$w1, best_config$r12$iqr))
cat(sprintf("nABCD(2,3)=%.4f [W1=%.3f IQR=%.3f]\n",
            best_config$r23$nabcd, best_config$r23$w1, best_config$r23$iqr))

# =============================================================================
# PART 4: Non-normal distributions (uniform, exponential)
# =============================================================================
cat("\n----------------------------------------------------------------------\n")
cat("PART 4: Attempting with empirical/non-normal distributions\n")
cat("----------------------------------------------------------------------\n\n")

set.seed(42)
N <- 100000

# Try: F1 = Uniform(0, 1), F2 = point mass at 0.5, F3 = Uniform(10, 11)
# Approximate with samples

w1_empirical <- function(x, y) {
  # W1 between two empirical distributions
  n1 <- length(x); n2 <- length(y)
  all_sorted_x <- sort(x); all_sorted_y <- sort(y)
  # Use quantile function approach: W1 = integral |F^{-1}_1(t) - F^{-1}_2(t)| dt
  t_grid <- seq(0, 1, length.out = 10000)
  q1 <- quantile(x, probs = t_grid, type = 1)
  q2 <- quantile(y, probs = t_grid, type = 1)
  dt <- t_grid[2] - t_grid[1]
  sum(abs(q1 - q2)) * dt
}

iqr_pooled_empirical <- function(x, y) {
  combined <- c(x, y)
  IQR(combined)
}

nabcd_empirical <- function(x, y) {
  w1 <- w1_empirical(x, y)
  iqr <- iqr_pooled_empirical(x, y)
  list(nabcd = w1 / (2*iqr), w1 = w1, iqr = iqr)
}

# F1: bimodal (two narrow spikes at 0 and 10)
# F2: wide uniform covering 0-10
# F3: bimodal (two narrow spikes at 1 and 9)
#
# mix(F1,F3): 4 spikes at {0,1,9,10} -> IQR ~ 8-9 (wide)
# mix(F1,F2): spikes + uniform -> IQR medium
# mix(F2,F3): spikes + uniform -> IQR medium

f1 <- c(rnorm(N/2, 0, 0.01), rnorm(N/2, 10, 0.01))  # bimodal spikes at 0, 10
f2 <- runif(N, 0, 10)                                   # wide uniform
f3 <- c(rnorm(N/2, 2, 0.01), rnorm(N/2, 8, 0.01))    # bimodal spikes at 2, 8

r13e <- nabcd_empirical(f1, f3)
r12e <- nabcd_empirical(f1, f2)
r23e <- nabcd_empirical(f2, f3)

cat("F1 = bimodal spikes at {0, 10}\n")
cat("F2 = Uniform(0, 10)\n")
cat("F3 = bimodal spikes at {2, 8}\n\n")

cat(sprintf("nABCD(F1,F3): W1=%.4f IQR=%.4f nABCD=%.4f\n", r13e$w1, r13e$iqr, r13e$nabcd))
cat(sprintf("nABCD(F1,F2): W1=%.4f IQR=%.4f nABCD=%.4f\n", r12e$w1, r12e$iqr, r12e$nabcd))
cat(sprintf("nABCD(F2,F3): W1=%.4f IQR=%.4f nABCD=%.4f\n", r23e$w1, r23e$iqr, r23e$nabcd))

# Check all 3 directions
for (dir in 1:3) {
  if (dir == 1) { lhs_e <- r13e$nabcd; rhs_e <- r12e$nabcd + r23e$nabcd; label <- "(1,3) vs (1,2)+(2,3)" }
  if (dir == 2) { lhs_e <- r12e$nabcd; rhs_e <- r13e$nabcd + r23e$nabcd; label <- "(1,2) vs (1,3)+(3,2)" }
  if (dir == 3) { lhs_e <- r23e$nabcd; rhs_e <- r12e$nabcd + r13e$nabcd; label <- "(2,3) vs (2,1)+(1,3)" }
  cat(sprintf("  %s: LHS=%.4f RHS=%.4f %s\n", label, lhs_e, rhs_e,
              if (lhs_e > rhs_e + 1e-6) "VIOLATED" else "OK"))
}

# =============================================================================
# PART 5: Analytical bound exploration
# =============================================================================
cat("\n----------------------------------------------------------------------\n")
cat("PART 5: Analytical structure\n")
cat("----------------------------------------------------------------------\n\n")

cat("For two normals N(mu1, s) and N(mu2, s) with SAME variance:\n")
cat("  W1 = |mu1 - mu2| (exact)\n")
cat("  mix CDF = 0.5*Phi((x-mu1)/s) + 0.5*Phi((x-mu2)/s)\n")
cat("  IQR_pool depends on both s and |mu1-mu2|\n\n")

cat("When s1 = s2 = s3 = s (common variance), let d_ij = |mu_i - mu_j|:\n")
cat("  nABCD(Fi,Fj) = d_ij / (2 * IQR_pool(i,j))\n")
cat("  W1 triangle: d_13 <= d_12 + d_23 (triangle ineq for real line)\n\n")

# For same-variance normals with different shifts
cat("Same-variance case (s=1):\n")
for (d12 in c(1, 2, 5)) {
  for (d23 in c(1, 2, 5)) {
    d13 <- d12 + d23  # worst case: collinear on real line
    r13_sv <- nabcd_fn(0, 1, d13, 1)
    r12_sv <- nabcd_fn(0, 1, d12, 1)
    r23_sv <- nabcd_fn(d12, 1, d13, 1)
    ratio_sv <- r13_sv$nabcd / (r12_sv$nabcd + r23_sv$nabcd)
    cat(sprintf("  d12=%d d23=%d d13=%d: nABCD(13)=%.4f sum=%.4f ratio=%.4f\n",
                d12, d23, d13, r13_sv$nabcd, r12_sv$nabcd + r23_sv$nabcd, ratio_sv))
  }
}

# =============================================================================
# PART 6: The definitive test - mixture IQR can be NON-MONOTONIC
# =============================================================================
cat("\n----------------------------------------------------------------------\n")
cat("PART 6: Non-normal attempt - carefully designed counterexample\n")
cat("----------------------------------------------------------------------\n\n")

# Key mathematical insight for potential violation:
# We need IQR_pool(F1,F3) to be MUCH smaller than IQR_pool(F1,F2) and IQR_pool(F2,F3)
# while W1(F1,F3) is close to W1(F1,F2) + W1(F2,F3)
#
# Consider: F1 = N(0, 1), F3 = N(d, 1) for large d
# mix(F1,F3) is bimodal: IQR ~ d (grows with d)
# W1(F1,F3) = d
# nABCD(F1,F3) = d / (2 * ~d) ~ 0.5 (bounded!)
#
# Now F2 = N(d/2, S) for VERY LARGE S
# mix(F1,F2): half N(0,1), half N(d/2, S). The wide component spreads mass.
# IQR will be ~ S (large)
# W1(F1,F2) ~ S*sqrt(2/pi) + something
# nABCD(F1,F2) ~ S*sqrt(2/pi) / (2*S*~0.7) ~ 0.6
# Similarly for nABCD(F2,F3)
#
# So nABCD(F1,F3) ~ 0.5, sum ~ 1.2. No violation.
#
# The problem: nABCD is "self-normalizing" - the normalization tends to
# keep values in a bounded range regardless of the raw distances.

# Let me try empirical distributions that exploit the IQR definition

# F1: all mass concentrated in [0, 0.01] (like a spike)
# F3: all mass concentrated in [1, 1.01] (spike, shifted by 1)
# F2: bimodal at {-10, 10} with some mass at 0.5

f1 <- rnorm(N, 0, 0.001)
f3 <- rnorm(N, 1, 0.001)

# F2: designed so that mix(F1,F2) and mix(F2,F3) have large IQR
# but mix(F1,F3) has small IQR
#
# mix(F1,F3) ~ spikes at 0 and 1, IQR ~ 1
# For mix(Fi,F2) to have large IQR, F2 needs to spread mass widely
# BUT if F2 is wide, W1(F1,F2) and W1(F2,F3) will also be large

# Actually, let me try: F2 has most mass between Q25 and Q75 of the F1-F3 mix
# spread far apart. So when mixed with F1 or F3, the quartiles shift.

# More careful approach: try Bernoulli-like discrete distributions
# F1 = point mass at 0
# F2 = point mass at 0.5
# F3 = point mass at 1
# mix(F1,F3): {0, 1} with equal weight, Q25=0, Q75=1, IQR=1
# mix(F1,F2): {0, 0.5} with equal weight, Q25=0, Q75=0.5, IQR=0.5
# mix(F2,F3): {0.5, 1} with equal weight, Q25=0.5, Q75=1, IQR=0.5
# W1(F1,F3)=1, W1(F1,F2)=0.5, W1(F2,F3)=0.5
# nABCD(F1,F3)=1/(2*1)=0.5, nABCD(F1,F2)=0.5/(2*0.5)=0.5, nABCD(F2,F3)=0.5/(2*0.5)=0.5
# Check: 0.5 <= 0.5 + 0.5 = 1.0. OK.

cat("Point mass example: F1=delta(0), F2=delta(0.5), F3=delta(1)\n")
cat("nABCD(F1,F3)=0.5, nABCD(F1,F2)=0.5, nABCD(F2,F3)=0.5\n")
cat("Triangle: 0.5 <= 0.5 + 0.5 = 1.0 OK\n\n")

# What if F2 is NOT between F1 and F3?
# F1 = delta(0), F2 = delta(10), F3 = delta(1)
# W1(F1,F3)=1, W1(F1,F2)=10, W1(F2,F3)=9
# IQR: mix(F1,F3)={0,1}: IQR=1; mix(F1,F2)={0,10}: IQR=10; mix(F2,F3)={10,1}: IQR=9
# nABCD(F1,F3)=1/2=0.5, nABCD(F1,F2)=10/20=0.5, nABCD(F2,F3)=9/18=0.5
# ALL equal to 0.5!! Interesting.

cat("Point mass example 2: F1=delta(0), F2=delta(10), F3=delta(1)\n")
cat("All nABCD values = 0.5 (for any pair of distinct point masses!)\n")
cat("Triangle: 0.5 <= 0.5 + 0.5 = 1.0 OK\n\n")

# This reveals: for point masses, nABCD = 0.5 always (since W1=d, IQR=d)
# So point masses cannot violate.

# For continuous distributions, nABCD is bounded:
# For N(0,s) and N(d,s): nABCD = d/(2*IQR_pool)
# As d->inf: IQR_pool -> d (bimodal mix), so nABCD -> d/(2d) = 0.5
# As d->0: nABCD -> 0

# =============================================================================
# PART 7: Definitive search with skewed and heavy-tailed distributions
# =============================================================================
cat("----------------------------------------------------------------------\n")
cat("PART 7: Larger search with non-normal distributions\n")
cat("----------------------------------------------------------------------\n\n")

set.seed(123)
N <- 50000

# Try many random configurations
max_ratio_found <- 0
best_found <- NULL
n_tries <- 0
n_violations <- 0

# Generate various distribution types
gen_dist <- function(type, N) {
  switch(type,
    "narrow_0"   = rnorm(N, 0, 0.01),
    "narrow_5"   = rnorm(N, 5, 0.01),
    "narrow_10"  = rnorm(N, 10, 0.01),
    "wide_0"     = rnorm(N, 0, 10),
    "wide_5"     = rnorm(N, 5, 10),
    "std_0"      = rnorm(N, 0, 1),
    "std_3"      = rnorm(N, 3, 1),
    "std_5"      = rnorm(N, 5, 1),
    "exp_1"      = rexp(N, 1),
    "exp_01"     = rexp(N, 0.1),
    "unif_0_1"   = runif(N, 0, 1),
    "unif_0_10"  = runif(N, 0, 10),
    "lnorm"      = rlnorm(N, 0, 1),
    "lnorm_wide" = rlnorm(N, 0, 2),
    "bimod_0_10" = c(rnorm(N/2, 0, 0.1), rnorm(N/2, 10, 0.1)),
    "bimod_0_5"  = c(rnorm(N/2, 0, 0.1), rnorm(N/2, 5, 0.1)),
    "skew_right" = c(rnorm(N*0.9, 0, 1), rnorm(N*0.1, 10, 0.5)),
    "skew_left"  = c(rnorm(N*0.9, 10, 1), rnorm(N*0.1, 0, 0.5))
  )
}

dist_types <- c("narrow_0", "narrow_5", "narrow_10", "wide_0", "wide_5",
                "std_0", "std_3", "std_5", "exp_1", "exp_01",
                "unif_0_1", "unif_0_10", "lnorm", "lnorm_wide",
                "bimod_0_10", "bimod_0_5", "skew_right", "skew_left")

# Pre-generate all distributions
dists <- lapply(dist_types, function(t) gen_dist(t, N))
names(dists) <- dist_types

n_types <- length(dist_types)
cat(sprintf("Testing %d distribution types (%d triplets)...\n",
            n_types, choose(n_types, 3) * 3))

for (i in 1:(n_types-2)) {
  for (j in (i+1):(n_types-1)) {
    for (k in (j+1):n_types) {
      n_tries <- n_tries + 1

      tryCatch({
        r_ij <- nabcd_empirical(dists[[i]], dists[[j]])
        r_jk <- nabcd_empirical(dists[[j]], dists[[k]])
        r_ik <- nabcd_empirical(dists[[i]], dists[[k]])

        # Check all 3 triangle inequalities
        ratios <- c(
          r_ik$nabcd / (r_ij$nabcd + r_jk$nabcd),
          r_ij$nabcd / (r_ik$nabcd + r_jk$nabcd),
          r_jk$nabcd / (r_ij$nabcd + r_ik$nabcd)
        )

        max_r <- max(ratios[is.finite(ratios)], na.rm = TRUE)
        if (max_r > 1.0) n_violations <- n_violations + 1

        if (max_r > max_ratio_found) {
          max_ratio_found <- max_r
          which_dir <- which.max(ratios)
          best_found <- list(
            types = c(dist_types[i], dist_types[j], dist_types[k]),
            ratio = max_r, direction = which_dir,
            r_ij = r_ij, r_jk = r_jk, r_ik = r_ik
          )
        }
      }, error = function(e) NULL)
    }
  }
}

cat(sprintf("\nTested %d triplets\n", n_tries))
cat(sprintf("Violations found: %d\n", n_violations))
cat(sprintf("Maximum ratio: %.6f\n\n", max_ratio_found))

if (!is.null(best_found)) {
  cat(sprintf("Best (closest to/exceeding violation):\n"))
  cat(sprintf("  Types: %s, %s, %s\n", best_found$types[1], best_found$types[2], best_found$types[3]))
  cat(sprintf("  Direction: %d\n", best_found$direction))
  cat(sprintf("  nABCD(i,k)=%.4f [W1=%.3f IQR=%.3f]\n",
              best_found$r_ik$nabcd, best_found$r_ik$w1, best_found$r_ik$iqr))
  cat(sprintf("  nABCD(i,j)=%.4f [W1=%.3f IQR=%.3f]\n",
              best_found$r_ij$nabcd, best_found$r_ij$w1, best_found$r_ij$iqr))
  cat(sprintf("  nABCD(j,k)=%.4f [W1=%.3f IQR=%.3f]\n",
              best_found$r_jk$nabcd, best_found$r_jk$w1, best_found$r_jk$iqr))

  if (max_ratio_found > 1.0) {
    cat("\n*** TRIANGLE INEQUALITY CAN BE VIOLATED ***\n")
  } else {
    cat("\n--- No violation found in this search ---\n")
  }
}

# =============================================================================
# PART 8: FINAL CONCLUSION
# =============================================================================
cat("\n======================================================================\n")
cat("SUMMARY AND CONCLUSION\n")
cat("======================================================================\n\n")

if (n_violations > 0) {
  cat("RESULT: Triangle inequality IS violated for nABCD.\n")
  cat("nABCD is a dissimilarity index, not a metric in the strict sense.\n")
} else {
  cat("RESULT: No triangle inequality violation found in extensive search.\n")
  cat("This does not constitute a proof, but suggests the triangle inequality\n")
  cat("may hold or violations are confined to extreme/pathological cases.\n")
}

cat("\nNote: Even if nABCD is not a metric, this does NOT affect:\n")
cat("  1. Proposition 1 (non-negativity, identity of indiscernibles)\n")
cat("  2. Proposition 2 (heterogeneity bound / clinical calibration)\n")
cat("  3. The practical use case (pairwise comparisons, not embedding)\n")
cat("The triangle inequality is relevant only when using nABCD for\n")
cat("metric-space operations (e.g., clustering, MDS), which is not\n")
cat("the intended use in the paper.\n")
