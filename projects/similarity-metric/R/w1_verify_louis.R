# ============================================================
# W1 Implementation Verification: Midpoint vs Left-Endpoint
# Louis Litt - Internal Review
# ============================================================
#
# PURPOSE: Verify that the simulation code (midpoint method)
# and the paper appendix code (left-endpoint method) compute
# identical W1 distances for empirical distributions.
# ============================================================

cat("============================================================\n")
cat("W1 IMPLEMENTATION VERIFICATION\n")
cat("Midpoint (simulation) vs Left-endpoint (paper appendix)\n")
cat("============================================================\n\n")

# --- Define the four methods ---

# Method A: Midpoint (simulation_manuscript_v2.R lines 84-96)
w1_midpoint <- function(x, y) {
  all_vals <- sort(c(x, y))
  n <- length(all_vals)
  if (n < 2) return(0)
  Fx <- ecdf(x)
  Fy <- ecdf(y)
  mids <- (all_vals[-n] + all_vals[-1]) / 2
  diffs <- diff(all_vals)
  sum(abs(Fx(mids) - Fy(mids)) * diffs)
}

# Method B: Left-endpoint with duplicates
w1_left_dup <- function(x, y) {
  all_vals <- sort(c(x, y))
  n <- length(all_vals)
  if (n < 2) return(0)
  Fx <- ecdf(x)
  Fy <- ecdf(y)
  diffs <- diff(all_vals)
  sum(abs(Fx(all_vals[-n]) - Fy(all_vals[-n])) * diffs)
}

# Method C: Left-endpoint with unique (paper appendix exactly)
w1_left_unique <- function(x, y) {
  pooled <- c(x, y)
  all_vals <- sort(unique(pooled))
  n <- length(all_vals)
  if (n < 2) return(0)
  F1 <- ecdf(x)
  F2 <- ecdf(y)
  sum(diff(all_vals) * abs(F1(all_vals[-n]) - F2(all_vals[-n])))
}

# Method D: Quantile identity (equal n only)
w1_quantile <- function(x, y) {
  mean(abs(sort(x) - sort(y)))
}

# --- Helper to run all tests ---
run_test <- function(label, x, y, equal_n = TRUE) {
  cat(sprintf("--- %s ---\n", label))
  cat(sprintf("  n1=%d, n2=%d\n", length(x), length(y)))

  a <- w1_midpoint(x, y)
  b <- w1_left_dup(x, y)
  c <- w1_left_unique(x, y)

  cat(sprintf("  A) Midpoint (simulation):     %.10f\n", a))
  cat(sprintf("  B) Left-endpoint (dup):       %.10f\n", b))
  cat(sprintf("  C) Left-endpoint (unique):    %.10f\n", c))

  if (equal_n) {
    d <- w1_quantile(x, y)
    cat(sprintf("  D) Quantile identity:         %.10f\n", d))
  }

  cat(sprintf("\n  A == B? %s  (diff = %.2e)\n", abs(a - b) < 1e-15, a - b))
  cat(sprintf("  A == C? %s  (diff = %.2e)\n", abs(a - c) < 1e-15, a - c))
  cat(sprintf("  B == C? %s  (diff = %.2e)\n", abs(b - c) < 1e-15, b - c))
  if (equal_n) {
    d <- w1_quantile(x, y)
    cat(sprintf("  A == D? %s  (diff = %.2e)\n", abs(a - d) < 1e-10, a - d))
  }
  cat("\n")

  invisible(list(A = a, B = b, C = c))
}

# ============================================================
# TEST 1: Basic case - equal n, continuous
# ============================================================
set.seed(42)
x1 <- rnorm(100, 50, 10)
y1 <- rnorm(100, 55, 10)
run_test("TEST 1: Equal n=100, N(50,10) vs N(55,10)", x1, y1, equal_n = TRUE)

# ============================================================
# TEST 2: Unequal sample sizes
# ============================================================
set.seed(42)
x2 <- rnorm(50, 50, 10)
y2 <- rnorm(100, 55, 10)
run_test("TEST 2: Unequal n1=50, n2=100", x2, y2, equal_n = FALSE)

# ============================================================
# TEST 3: Discrete/tied data (integers)
# ============================================================
set.seed(42)
x3 <- rpois(100, lambda = 10)
y3 <- rpois(100, lambda = 15)
run_test("TEST 3: Discrete (Poisson 10 vs 15), n=100", x3, y3, equal_n = TRUE)

# ============================================================
# TEST 4: Very unequal sizes
# ============================================================
set.seed(42)
x4 <- rnorm(20, 50, 10)
y4 <- rnorm(200, 55, 10)
run_test("TEST 4: Very unequal n1=20, n2=200", x4, y4, equal_n = FALSE)

# ============================================================
# TEST 5: Heavy ties - small integer range
# ============================================================
set.seed(42)
x5 <- sample(1:5, 100, replace = TRUE)
y5 <- sample(3:7, 100, replace = TRUE)
run_test("TEST 5: Heavy ties, integers 1:5 vs 3:7, n=100", x5, y5, equal_n = TRUE)

# ============================================================
# THEORETICAL ANALYSIS
# ============================================================
cat("============================================================\n")
cat("THEORETICAL ANALYSIS\n")
cat("============================================================\n\n")
cat("For ECDF step functions, between consecutive order statistics\n")
cat("x_i and x_{i+1}, both F1 and F2 are CONSTANT.\n")
cat("Therefore |F1(t) - F2(t)| is constant on (x_i, x_{i+1}).\n\n")
cat("Key insight: ecdf() in R is RIGHT-CONTINUOUS (cadlag).\n")
cat("So F(left) = F(mid) for any point strictly between jumps.\n\n")

# Demonstrate with a tiny example
cat("--- Tiny demonstration ---\n")
x_tiny <- c(1, 3, 5)
y_tiny <- c(2, 4, 6)
Fx <- ecdf(x_tiny)
Fy <- ecdf(y_tiny)
all_v <- sort(c(x_tiny, y_tiny))
cat("Combined sorted values:", paste(all_v, collapse = ", "), "\n")
for (i in 1:(length(all_v) - 1)) {
  left <- all_v[i]
  mid <- (all_v[i] + all_v[i + 1]) / 2
  cat(sprintf("  [%g, %g]: F1(left)=%.4f, F1(mid)=%.4f, F2(left)=%.4f, F2(mid)=%.4f | |dF|(left)=%.4f, |dF|(mid)=%.4f\n",
              left, all_v[i + 1], Fx(left), Fx(mid), Fy(left), Fy(mid),
              abs(Fx(left) - Fy(left)), abs(Fx(mid) - Fy(mid))))
}

cat("\n============================================================\n")
cat("DUPLICATE HANDLING\n")
cat("============================================================\n\n")
cat("If x and y share a value v, sort(c(x,y)) has TWO copies.\n")
cat("This creates a zero-width interval [v, v] with diff=0.\n")
cat("Either way, diff=0 so the contribution is 0.\n")
cat("Result: duplicates add zero-contribution intervals.\n\n")

# Verify: unique vs non-unique with shared values
cat("--- Duplicate handling test ---\n")
x_d <- c(1.0, 2.0, 3.0, 4.0, 5.0)
y_d <- c(2.0, 3.0, 4.0, 5.0, 6.0)
a <- w1_midpoint(x_d, y_d)
b <- w1_left_dup(x_d, y_d)
c <- w1_left_unique(x_d, y_d)
cat(sprintf("Shared values {2,3,4,5}:\n"))
cat(sprintf("  Midpoint:          %.10f\n", a))
cat(sprintf("  Left (dup):        %.10f\n", b))
cat(sprintf("  Left (unique):     %.10f\n", c))
cat(sprintf("  All identical? %s\n\n", all(abs(c(a - b, a - c, b - c)) < 1e-15)))

cat("============================================================\n")
cat("VERDICT\n")
cat("============================================================\n\n")
cat("For step-function ECDFs, F(left) = F(mid) always holds\n")
cat("between consecutive order statistics (no jumps in open interval).\n")
cat("The midpoint and left-endpoint methods are MATHEMATICALLY\n")
cat("IDENTICAL for empirical distributions.\n")
cat("The simulation and paper appendix code compute the same W1.\n")
