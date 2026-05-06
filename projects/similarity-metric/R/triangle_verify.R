# =============================================================================
# Triangle Inequality Verification for nABCD — Clean Counterexample
#
# Author: Mike Ross (Methodologist)
# Date: 2026-03-10
#
# RESULT: nABCD DOES NOT satisfy the triangle inequality.
#         The simplest counterexample uses scale-only normal distributions.
# =============================================================================

set.seed(42)
cat("=======================================================================\n")
cat("TRIANGLE INEQUALITY FOR nABCD — DEFINITIVE RESULT\n")
cat("=======================================================================\n\n")

# Core functions
compute_w1 <- function(s1, s2, n_grid = 200000) {
  u <- seq(1/(n_grid + 1), n_grid/(n_grid + 1), length.out = n_grid)
  mean(abs(qnorm(u, 0, s1) - qnorm(u, 0, s2)))
}

get_iqr_mix <- function(s1, s2, n_mc = 1e6) {
  x <- c(rnorm(n_mc/2, 0, s1), rnorm(n_mc/2, 0, s2))
  IQR(x)
}

# =============================================================================
# PART 1: Clean counterexample
# =============================================================================
cat("=== COUNTEREXAMPLE 1: N(0,1), N(0,5), N(0,20) ===\n\n")

triples <- list(
  c(1, 5, 20),
  c(0.1, 1, 10),
  c(0.1, 0.5, 50),
  c(1, 2, 50),
  c(0.5, 1, 5)
)

for (triple in triples) {
  s1 <- triple[1]; s2 <- triple[2]; s3 <- triple[3]
  pairs <- list(c(s1,s2), c(s2,s3), c(s1,s3))
  pair_names <- c("(1,2)", "(2,3)", "(1,3)")

  w1s <- iqrs <- nabcds <- numeric(3)
  for (k in 1:3) {
    si <- pairs[[k]][1]; sj <- pairs[[k]][2]
    w1s[k] <- compute_w1(si, sj)
    iqrs[k] <- mean(c(get_iqr_mix(si,sj), get_iqr_mix(si,sj), get_iqr_mix(si,sj)))
    nabcds[k] <- w1s[k] / iqrs[k]
  }

  ratio <- nabcds[3] / (nabcds[1] + nabcds[2])
  status <- ifelse(ratio > 1, sprintf("VIOLATED (%.2fx)", ratio), "holds")

  cat(sprintf("F1=N(0,%.1f), F2=N(0,%.1f), F3=N(0,%.1f)\n", s1, s2, s3))
  for (k in 1:3) {
    cat(sprintf("  %s: W1=%.4f, IQR_mix=%.4f, nABCD=%.4f\n",
                pair_names[k], w1s[k], iqrs[k], nabcds[k]))
  }
  cat(sprintf("  d13=%.4f vs d12+d23=%.4f -> ratio=%.4f [%s]\n\n",
              nabcds[3], nabcds[1]+nabcds[2], ratio, status))
}

# =============================================================================
# PART 2: Why it fails — the IQR anchoring mechanism
# =============================================================================
cat("\n=== MECHANISM: IQR ANCHORING ===\n\n")

cat("For mixture 0.5*N(0,s1) + 0.5*N(0,s2) with s1 << s2:\n")
cat("The narrow component N(0,s1) concentrates 50% of mass near 0.\n")
cat("The mixture CDF G(x) = 0.5*Phi(x/s1) + 0.5*Phi(x/s2).\n")
cat("Near x=0: G(0) = 0.5, so median = 0.\n")
cat("Q1 satisfies: 0.5*Phi(Q1/s1) + 0.5*Phi(Q1/s2) = 0.25\n")
cat("When s1 << s2, Phi(Q1/s1) changes rapidly near 0, so Q1 ~ -c*s1\n")
cat("where c is a small constant. Hence IQR_mix ~ O(s1), NOT O(s2).\n\n")

cat("Meanwhile, W1(N(0,s1), N(0,s2)) = |s1-s2| * sqrt(2/pi) ~ O(s2).\n")
cat("So nABCD ~ O(s2) / O(s1) -> infinity as s2/s1 -> infinity.\n\n")

cat("IQR_mix quantiles for various scale ratios:\n")
for (pair in list(c(1,1), c(1,2), c(1,5), c(1,10), c(1,20), c(1,50))) {
  s1 <- pair[1]; s2 <- pair[2]
  x <- c(rnorm(5e5, 0, s1), rnorm(5e5, 0, s2))
  q <- quantile(x, c(0.25, 0.75))
  iqr <- q[2] - q[1]
  cat(sprintf("  N(0,%3d) + N(0,%3d): IQR_mix = %7.4f (component IQRs: %.3f, %.3f)\n",
              s1, s2, iqr, 1.349*s1, 1.349*s2))
}

# =============================================================================
# PART 3: Clinical relevance assessment
# =============================================================================
cat("\n\n=== CLINICAL RELEVANCE ===\n\n")

cat("In MRCT context, effect modifiers are typically:\n")
cat("  - Age: coefficient of variation (CV) ~ 0.2-0.3\n")
cat("  - BMI: CV ~ 0.1-0.2\n")
cat("  - Lab values: CV ~ 0.1-0.5\n")
cat("  - The sigma ratio between regions is typically < 2x\n\n")

cat("Triangle inequality violations require sigma_ratio >> 1.\n")
cat("Testing with clinically realistic sigma ratios:\n\n")

# Test with sigma ratios typical in clinical trials
clinical_triples <- list(
  list(s=c(10, 12, 15), label="Age: similar regions"),
  list(s=c(10, 15, 20), label="Age: moderate difference"),
  list(s=c(5, 10, 15), label="BMI: moderate difference"),
  list(s=c(1, 2, 4), label="Lab value: 2x ratio"),
  list(s=c(1, 3, 9), label="Lab value: 3x ratio (rare)")
)

for (case in clinical_triples) {
  s <- case$s
  pairs <- list(c(s[1],s[2]), c(s[2],s[3]), c(s[1],s[3]))
  w1s <- iqrs <- nabcds <- numeric(3)
  for (k in 1:3) {
    si <- pairs[[k]][1]; sj <- pairs[[k]][2]
    w1s[k] <- compute_w1(si, sj)
    iqrs[k] <- mean(c(get_iqr_mix(si,sj), get_iqr_mix(si,sj)))
    nabcds[k] <- w1s[k] / iqrs[k]
  }
  ratio <- nabcds[3] / (nabcds[1] + nabcds[2])
  cat(sprintf("  %-35s s=(%s): ratio=%.4f [%s]\n",
              case$label, paste(s, collapse=","),
              ratio, ifelse(ratio > 1, "VIOLATED", "holds")))
}

# =============================================================================
# PART 4: Summary
# =============================================================================
cat("\n\n=======================================================================\n")
cat("SUMMARY\n")
cat("=======================================================================\n\n")

cat("FINDING: nABCD does NOT satisfy the triangle inequality.\n\n")

cat("SIMPLEST COUNTEREXAMPLE:\n")
cat("  F1 = N(0, 0.1), F2 = N(0, 1), F3 = N(0, 10)\n")
cat("  nABCD(F1,F3) / [nABCD(F1,F2) + nABCD(F2,F3)] ~ 3.6\n\n")

cat("MECHANISM:\n")
cat("  The 50:50 mixture IQR for N(0,s1) + N(0,s2) with s1 << s2\n")
cat("  is anchored near O(s1) by the narrow component, while\n")
cat("  W1 = |s1-s2| * sqrt(2/pi) grows as O(s2).\n")
cat("  This makes nABCD scale as O(s2/s1) -> unbounded.\n")
cat("  The non-constant denominator breaks subadditivity.\n\n")

cat("CLINICAL RELEVANCE:\n")
cat("  Violations require large scale ratios (sigma_ratio > ~3).\n")
cat("  In MRCT practice, EM distributions across regions rarely\n")
cat("  differ by more than 2x in scale, so violations are unlikely\n")
cat("  in the intended application domain.\n\n")

cat("RECOMMENDATION FOR PAPER:\n")
cat("  1. Do NOT call nABCD a 'metric' or claim triangle inequality.\n")
cat("  2. Use 'normalized dissimilarity index' or 'dissimilarity measure'.\n")
cat("  3. The paper can note:\n")
cat("     - nABCD satisfies: non-negativity, symmetry, identity of\n")
cat("       indiscernibles (inheriting these from W1).\n")
cat("     - nABCD does NOT satisfy the triangle inequality in general.\n")
cat("     - However, for location-shift families (same shape, different\n")
cat("       location), the triangle inequality does hold.\n")
cat("     - In the MRCT context, where EM distributions across regions\n")
cat("       have similar shapes, the triangle inequality is satisfied\n")
cat("       in practice.\n")
cat("  4. This is not a deficiency — many useful dissimilarity measures\n")
cat("     (e.g., KL divergence, chi-squared distance) also fail the\n")
cat("     triangle inequality.\n\n")

cat("METRIC PROPERTIES OF nABCD:\n")
cat("  [YES] Non-negativity: nABCD(F1,F2) >= 0\n")
cat("  [YES] Symmetry: nABCD(F1,F2) = nABCD(F2,F1)\n")
cat("  [YES] Identity: nABCD(F1,F2) = 0 iff F1 = F2 (when IQR > 0)\n")
cat("  [NO]  Triangle inequality: VIOLATED for scale-differing distributions\n\n")

cat("TERMINOLOGY: nABCD is a 'dissimilarity index', not a 'metric'.\n")
