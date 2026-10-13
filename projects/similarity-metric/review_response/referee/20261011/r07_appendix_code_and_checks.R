# Referee check 07 -- (A) the Appendix B listing, run verbatim, reproduces Table 5's first pair (R8 vs R1, age)
# when started from set.seed(2026), i.e. the RNG state R/fig3_w1_axis.R uses before its first partner;
# (B) range constraint for attainment of the W1 bound on the risk-difference scale (|tau| <= 1);
# (C) small prose counts. Base R only. Run from the project root:
#   Rscript review_response/referee/20261011/r07_appendix_code_and_checks.R
OUT <- "review_response/referee/20261011"
sink(file.path(OUT, "r07_appendix_code_and_checks.txt"), split = TRUE)
suppressWarnings(RNGkind("Mersenne-Twister", "Inversion", "Rejection"))
## ---- Appendix B listing, verbatim (lines 639-662 of the manuscript) ----
compute_W1 <- function(x1, x2) {
  pooled <- c(x1, x2)
  all_vals <- sort(unique(pooled))
  F1 <- ecdf(x1); F2 <- ecdf(x2)
  w1 <- sum(diff(all_vals) *
    abs(F1(all_vals[-length(all_vals)]) -
        F2(all_vals[-length(all_vals)])))
  w1
}
W1_bootstrap <- function(x1, x2,
    B = 2000, conf = 0.95) {
  obs <- compute_W1(x1, x2)
  boot_vals <- replicate(B, {
    b1 <- sample(x1, replace = TRUE)
    b2 <- sample(x2, replace = TRUE)
    compute_W1(b1, b2)
  })
  alpha <- 1 - conf
  ci <- quantile(boot_vals,
    c(alpha/2, 1 - alpha/2), na.rm = TRUE)
  list(estimate = obs,
       ci_lower = ci[1], ci_upper = ci[2])
}
g <- read.csv("data/gusto.csv")
set.seed(2026)
r <- W1_bootstrap(g$age[g$regl == 8], g$age[g$regl == 1])
a <- read.csv("results/gusto_r8_w1_per_pair.csv"); a <- a[a$partner == 1, ]
cat(sprintf("Appendix code, R8 vs R1 age: %.10f [%.10f, %.10f]\nresults CSV:                 %.10f [%.10f, %.10f]\n",
            r$estimate, r$ci_lower, r$ci_upper, a$W1_age, a$ci_lower_age, a$ci_upper_age))
## ---- (B) attainment on the risk-difference scale: extremal tau* has range L x (support width); needs <= 2 ----
for (v in c("age", "sysbp")) { L <- c(age = 0.01, sysbp = 0.002)[[v]]; w <- diff(range(g[[v]]))
  cat(sprintf("%s: pooled GUSTO-I range %.1f (min %.1f, max %.1f); L_UB x range = %.3f (<= 2 needed for a risk-difference CATE)\n",
              v, w, min(g[[v]]), max(g[[v]]), L * w)) }
## ---- (C) prose counts ----
pp <- read.csv("results/gusto_r8_w1_per_pair.csv")
cat(sprintf("partners with W1_age < 1.5 years: %d of %d\n", sum(pp$W1_age < 1.5), nrow(pp)))
sink()
## ---- (D) extreme recorded values (data screening; W1 weights each observation by its displacement) ----
sink(file.path(OUT, "r07_appendix_code_and_checks.txt"), append = TRUE, split = TRUE)
cat(sprintf("SBP == 0: %d (regions %s); SBP < 60: %d; age > 100: %d (regions %s); R8: SBP < 60 %d, age > 100 %d\n",
            sum(g$sysbp == 0), paste(g$regl[g$sysbp == 0], collapse = ","), sum(g$sysbp < 60), sum(g$age > 100),
            paste(g$regl[g$age > 100], collapse = ","), sum(g$sysbp[g$regl == 8] < 60), sum(g$age[g$regl == 8] > 100)))
sink()
