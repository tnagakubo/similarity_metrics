# === Comprehensive Verification Script ===
# Rachel + Louis + Mike + Hardcoding check
# Run: Rscript R/verify_all.R

cat("=== nABCD Comprehensive Verification ===\n\n")

# ---- Independent nABCD implementation (no sourcing) ----
my_w1 <- function(x, y) {
  vals <- sort(unique(c(x, y)))
  n <- length(vals)
  if (n < 2) return(0)
  Fx <- ecdf(x); Fy <- ecdf(y)
  sum(diff(vals) * abs(Fx(vals[-n]) - Fy(vals[-n])))
}

my_nABCD <- function(x, y) {
  pooled <- c(x, y)
  iqr_p <- IQR(pooled)
  if (iqr_p == 0) return(NA)
  my_w1(x, y) / iqr_p
}

# ---- 1. True nABCD verification (N=10000, seed=99999) ----
cat("--- 1. True nABCD Independent Verification ---\n")
set.seed(99999)
N <- 10000
sigma_ln <- 0.5; mu_ln <- log(50) - sigma_ln^2/2

results <- list(
  S1 = my_nABCD(rnorm(N,50,10), rnorm(N,50,10)),
  S2 = my_nABCD(rnorm(N,50,10), rnorm(N,52,10)),
  S3 = my_nABCD(rnorm(N,50,10), rnorm(N,55,10)),
  S4 = my_nABCD(rnorm(N,50,10), rnorm(N,60,10)),
  S5 = my_nABCD(rnorm(N,50,10), rnorm(N,50,15)),
  S6 = my_nABCD(rnorm(N,50,10), rlnorm(N,mu_ln,sigma_ln)),
  S7 = my_nABCD(rnorm(N,50,10), rnorm(N,55,15))
)

csv_vals <- c(S1=0.001, S2=0.073, S3=0.18, S4=0.328, S5=0.122, S6=0.304, S7=0.175)

cat(sprintf("%-4s %8s %8s %8s %s\n", "ID", "CSV", "Indep", "Diff", "Status"))
for (id in names(results)) {
  d <- abs(results[[id]] - csv_vals[id])
  ok <- ifelse(d < 0.015, "OK", "*** MISMATCH ***")
  cat(sprintf("%-4s %8.4f %8.4f %8.4f %s\n", id, csv_vals[id], results[[id]], d, ok))
}

# ---- 2. W1 Implementation Comparison ----
cat("\n--- 2. W1 Midpoint vs Left-endpoint vs Quantile ---\n")
set.seed(42)
x <- rnorm(100, 50, 10); y <- rnorm(100, 55, 10)

w1_mid <- function(x, y) {
  all_vals <- sort(c(x, y)); n <- length(all_vals)
  mids <- (all_vals[-n] + all_vals[-1]) / 2
  sum(abs(ecdf(x)(mids) - ecdf(y)(mids)) * diff(all_vals))
}

w1_left_uniq <- function(x, y) {
  vals <- sort(unique(c(x, y))); n <- length(vals)
  sum(diff(vals) * abs(ecdf(x)(vals[-n]) - ecdf(y)(vals[-n])))
}

w1_left_all <- function(x, y) {
  all_vals <- sort(c(x, y)); n <- length(all_vals)
  sum(diff(all_vals) * abs(ecdf(x)(all_vals[-n]) - ecdf(y)(all_vals[-n])))
}

w1_quant <- function(x, y) mean(abs(sort(x) - sort(y)))

a <- w1_mid(x,y); b <- w1_left_uniq(x,y); c <- w1_left_all(x,y); d <- w1_quant(x,y)
cat(sprintf("  Midpoint:       %.10f\n  Left(unique):   %.10f\n  Left(all):      %.10f\n  Quantile:       %.10f\n", a,b,c,d))
cat(sprintf("  Max diff (mid vs others): %.2e\n", max(abs(c(a-b, a-c, a-d)))))

# Test with ties
cat("\n  With ties (integer data, n=200 each):\n")
x3 <- sample(0:42, 200, replace=TRUE); y3 <- sample(5:42, 200, replace=TRUE)
a3 <- w1_mid(x3,y3); b3 <- w1_left_uniq(x3,y3); c3 <- w1_left_all(x3,y3); d3 <- w1_quant(x3,y3)
cat(sprintf("  Midpoint:       %.10f\n  Left(unique):   %.10f\n  Left(all):      %.10f\n  Quantile:       %.10f\n", a3,b3,c3,d3))
cat(sprintf("  Mid vs Left(uniq): %.2e\n  Mid vs Left(all):  %.2e\n", abs(a3-b3), abs(a3-c3)))

# Unequal n
cat("\n  Unequal n (50 vs 150):\n")
x4 <- rnorm(50, 50, 10); y4 <- rnorm(150, 55, 10)
a4 <- w1_mid(x4,y4); b4 <- w1_left_uniq(x4,y4); c4 <- w1_left_all(x4,y4)
cat(sprintf("  Midpoint:       %.10f\n  Left(unique):   %.10f\n  Left(all):      %.10f\n", a4,b4,c4))
cat(sprintf("  Max diff: %.2e\n", max(abs(c(a4-b4, a4-c4, b4-c4)))))

# ---- 3. Analytical W1 for equal-variance normals ----
cat("\n--- 3. Analytical W1 Check ---\n")
cat("  W1(N(mu1,s), N(mu2,s)) = |mu1-mu2| for equal variance\n")
set.seed(123)
for (delta in c(2, 5, 10)) {
  w <- my_w1(rnorm(N, 50, 10), rnorm(N, 50+delta, 10))
  cat(sprintf("  delta=%d: W1_MC=%.4f, analytical=%d, ratio=%.4f\n", delta, w, delta, w/delta))
}

# ---- 4. Hardcoding Check ----
cat("\n--- 4. Hardcoding Check ---\n")
cat("  Checking simulation code for hardcoded results...\n")
sim_code <- readLines("R/simulation_manuscript_v2.R")

# Check for hardcoded coverage/bias values
hardcode_patterns <- c(
  "coverage.*=.*0\\.[89]",
  "bias.*=.*0\\.0",
  "cov_pct.*=.*0\\.",
  "true_nABCD.*=.*0\\.[0-9]"  # non-NA/non-zero hardcoded true values
)
cat("  Patterns checked:\n")
for (pat in hardcode_patterns) {
  matches <- grep(pat, sim_code)
  if (length(matches) > 0) {
    for (m in matches) {
      line <- trimws(sim_code[m])
      if (!grepl("^#|^cat|sprintf|ifelse", line)) {
        cat(sprintf("    Line %d: %s\n", m, substr(line, 1, 80)))
      }
    }
  }
}

# Check that true_nABCD is computed via MC, not hardcoded
mc_lines <- grep("true_nABCD.*=.*NA", sim_code)
hardcoded_lines <- grep("true_nABCD.*=.*[0-9]\\.[0-9]", sim_code)
hardcoded_non_zero <- grep("true_nABCD.*=.*[1-9]", sim_code)
cat(sprintf("  true_nABCD = NA (MC computed): %d lines\n", length(mc_lines)))
cat(sprintf("  true_nABCD = 0 (S1 exact): %d lines\n", length(hardcoded_lines) - length(hardcoded_non_zero)))
cat(sprintf("  true_nABCD hardcoded non-zero: %d lines\n", length(hardcoded_non_zero)))

# Verify compute_true_values function exists and is called
if (any(grepl("compute_true_values", sim_code))) {
  cat("  compute_true_values() function: FOUND\n")
} else {
  cat("  compute_true_values() function: MISSING - SUSPICIOUS\n")
}

# Check that results are not pre-written
if (any(grepl("summary_table.*<-.*data\\.frame\\(Scenario", sim_code))) {
  cat("  Pre-filled summary_table: FOUND - SUSPICIOUS\n")
} else {
  cat("  Pre-filled summary_table: NOT FOUND (good)\n")
}

cat("\n=== VERIFICATION COMPLETE ===\n")
