# L* with percentile intervals for the GUSTO-I application (Table tab:gusto_lstar_joint).
# Single writer of results/gusto_lstar_intervals.csv. Run from the project root.
# Source: results/gusto_r8_w1_per_pair.csv (W1 point estimates and 95% percentile CIs, B = 2,000).
# L* = Delta_clin / W1 is decreasing in W1, so its interval is [Delta_clin / W1_U, Delta_clin / W1_L].

DELTA_CLIN <- 0.01   # 1 percentage point on the absolute 30-day mortality scale

p <- read.csv("results/gusto_r8_w1_per_pair.csv")
p <- p[order(p$partner), ]
out <- data.frame(
  partner = paste0("R", p$partner),
  w1_age = p$W1_age, w1_sbp = p$W1_sysbp,
  lstar_age = DELTA_CLIN / p$W1_age,
  lstar_age_lower = DELTA_CLIN / p$ci_upper_age,
  lstar_age_upper = DELTA_CLIN / p$ci_lower_age,
  lstar_sbp = DELTA_CLIN / p$W1_sysbp,
  lstar_sbp_lower = DELTA_CLIN / p$ci_upper_sysbp,
  lstar_sbp_upper = DELTA_CLIN / p$ci_lower_sysbp)
write.csv(out, "results/gusto_lstar_intervals.csv", row.names = FALSE)

f <- function(x) formatC(x, format = "f", digits = 4)
for (i in seq_len(nrow(out))) {
  cat(sprintf("%-3s & %.2f & %.2f & %s (%s, %s) & %s (%s, %s) \\\\\n", out$partner[i],
              out$w1_age[i], out$w1_sbp[i],
              f(out$lstar_age[i]), f(out$lstar_age_lower[i]), f(out$lstar_age_upper[i]),
              f(out$lstar_sbp[i]), f(out$lstar_sbp_lower[i]), f(out$lstar_sbp_upper[i])))
}
