# Referee: operating range of Study 2 vs the GUSTO-I application (standardized distance and signal-to-noise W1/SE)
g <- read.csv("data/gusto.csv"); a <- g[g$regl == 8, ]
pp <- read.csv("results/gusto_r8_w1_per_pair.csv")
cat("GUSTO W1/SD(R8): age", round(range(pp$W1_age / sd(a$age)), 3), " sbp", round(range(pp$W1_sysbp / sd(a$sysbp)), 3), "\n")
cat("GUSTO W1/SE (bootstrap SE): age", round(range(pp$W1_age / pp$se_age), 2), " sbp", round(range(pp$W1_sysbp / pp$se_sysbp), 2), "\n")
cat("n ratio partner/R8 range:", round(range(pp$n / 2916), 2), " distinct SBP values in R8:", length(unique(a$sysbp)), " share of R8 SBP on multiples of 10:", round(mean(a$sysbp %% 10 == 0), 3), "\n")
s <- read.csv("results/w1_raw_summary.csv"); s$snr <- s$true_W1 / s$sd_est
print(data.frame(s$scenario, s$n, W1sd = s$true_W1 / 10, snr = round(s$snr, 2), cov = s$coverage_pct), row.names = FALSE)
