# Study 1: side on which the 95% percentile bootstrap CI misses the true W1.
# Source: results/w1_raw_simulation.rds (canonical run, see results/STUDY1_PROVENANCE.md).
# Also reports the 95th percentile of W1-hat under S1 (null floor, sigma = 10, equal n).
# Written 2026-09-27 for the v6 paragraph review (queue #23, #25, #33).
x <- readRDS("results/w1_raw_simulation.rds")
tr <- setNames(x$summary$true_W1, names(x$rep_data))
out <- do.call(rbind, lapply(names(x$rep_data), function(k) {
  d <- x$rep_data[[k]]; t <- tr[[k]]
  data.frame(cell = k, true_W1 = t,
             miss_below = mean(t < d[, "ci_lower"]),   # interval lies above the truth
             miss_above = mean(t > d[, "ci_upper"]),   # truth exceeds the upper limit
             q95_est = unname(quantile(d[, "estimate"], 0.95)))
}))
write.csv(out, "results/study1_miss_side.csv", row.names = FALSE)
print(out, digits = 4)
