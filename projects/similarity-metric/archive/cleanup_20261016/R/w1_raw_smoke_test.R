# Smoke test for W1_raw_bootstrap_cpp:
#   - Point-estimate parity with pure-R wasserstein1()
#   - Timing benchmark for full-grid extrapolation
SKIP_SIMULATION <- TRUE
suppressPackageStartupMessages({library(Rcpp)})

ROOT <- "projects/similarity-metric/R"
source(file.path(ROOT, "simulation_manuscript_v2.R"), chdir = TRUE)
Rcpp::sourceCpp(file.path(ROOT, "W1_raw_rcpp.cpp"))

# Correctness check: point estimate must match wasserstein1()
set.seed(20260516)
max_diff <- 0
for (k in 1:10) {
  n1 <- sample(20:300, 1); n2 <- sample(20:300, 1)
  x <- rnorm(n1, 50, 10); y <- rnorm(n2, runif(1,48,55), runif(1,5,15))
  a <- wasserstein1(x, y)
  b <- W1_raw_bootstrap_cpp(x, y, B = 1)$estimate
  d <- abs(a - b)
  max_diff <- max(max_diff, d)
  cat(sprintf("n1=%d n2=%d  R: %.8f  Cpp: %.8f  diff=%.2e\n",
              n1, n2, a, b, d))
}
cat(sprintf("\nMax |R - Cpp| = %.2e\n", max_diff))

# Timing: n=200, B=2000
n <- 200; B <- 2000; n_reps <- 200
set.seed(42)
t0 <- Sys.time()
for (i in 1:n_reps) {
  x <- rnorm(n, 50, 10); y <- rnorm(n, 55, 15)
  W1_raw_bootstrap_cpp(x, y, B = B, conf = 0.95)
}
el <- as.numeric(difftime(Sys.time(), t0, units = "secs"))
cat(sprintf("\nTiming: %d reps at n=%d, B=%d: %.2fs  (%.4fs/rep)\n",
            n_reps, n, B, el, el/n_reps))
cat(sprintf("21 cells x 10000 reps @ 8 cores ~ %.1f min  (single-core est: %.1f min)\n",
            21 * el/n_reps * 10000 / 60 / 8,
            21 * el/n_reps * 10000 / 60))
