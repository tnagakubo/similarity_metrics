# =============================================================================
# W1 raw simulation — quick visualization (bias / coverage / RMSE)
# Author: Katrina Bennett
# Date: 2026-05-16
#
# Quick three-panel diagnostic plot for the W1 operating characteristics.
# Saves to projects/similarity-metric/figures/w1_raw_oc.pdf (and .png).
# =============================================================================

SKIP_SIMULATION <- TRUE
suppressPackageStartupMessages({
  library(ggplot2)
  library(tidyr)
})

if (!file.exists("results/w1_raw_simulation.rds")) {
  stop("Run w1_raw_simulation.R first")
}
sim <- readRDS("results/w1_raw_simulation.rds")
df <- sim$summary

df$scenario <- factor(df$scenario, levels = c("S1","S2","S3","S4","S5","S6","S7"))
df$n_f <- factor(df$n, levels = c(50, 100, 200))

# Long format for facet_grid
long <- pivot_longer(df,
  cols = c(bias, coverage_pct, rmse, mean_ci_width),
  names_to = "metric", values_to = "value")
long$metric <- factor(long$metric,
  levels = c("bias", "coverage_pct", "rmse", "mean_ci_width"),
  labels = c("Bias (W1 units)",
             "Coverage (95% CI)",
             "RMSE (W1 units)",
             "Mean CI width (W1 units)"))

p <- ggplot(long, aes(x = n, y = value, color = scenario, group = scenario)) +
  geom_line(linewidth = 0.6) +
  geom_point(size = 1.8) +
  facet_wrap(~ metric, scales = "free_y", ncol = 2) +
  scale_x_continuous(breaks = c(50, 100, 200)) +
  scale_color_brewer(palette = "Dark2") +
  labs(x = "n per group", y = NULL,
       title = "Sample W1 estimator: operating characteristics",
       subtitle = sprintf("n_reps = %d, B = %d, scenarios S1-S7",
                          sim$config$n_reps, sim$config$B),
       color = "Scenario") +
  theme_minimal(base_size = 11) +
  theme(plot.background = element_rect(fill = "white", color = NA),
        panel.grid.minor = element_blank())

# Add nominal coverage reference 0.95 only in the coverage panel
p <- p + geom_hline(data = data.frame(
                      metric = factor("Coverage (95% CI)",
                                       levels = levels(long$metric)),
                      yintercept = 0.95),
                    aes(yintercept = yintercept),
                    linetype = "dashed", color = "grey50")

if (!dir.exists("projects/similarity-metric/figures"))
  dir.create("projects/similarity-metric/figures", recursive = TRUE)

ggsave("projects/similarity-metric/figures/w1_raw_oc.pdf",
       p, width = 7, height = 5.5, bg = "white")
ggsave("projects/similarity-metric/figures/w1_raw_oc.png",
       p, width = 7, height = 5.5, dpi = 150, bg = "white")
cat("[save] figures/w1_raw_oc.pdf / .png\n")
