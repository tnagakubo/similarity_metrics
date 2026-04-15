# Plot simulation results from nABCD paper tables
# Generates 4 panels for review

library(ggplot2)
library(tidyr)
library(dplyr)
library(patchwork)

# ---- Data from paper tables ----

# Table 3: Bias
bias_df <- data.frame(
  Scenario = rep(c("S1 (Null)", "S2 (0.2σ)", "S3 (0.5σ)", "S4 (1.0σ)",
                    "S5 (Scale)", "S6 (Shape)", "S7 (Skew)", "S8 (Loc+Scale)"), each = 3),
  True_nABCD = rep(c(0.000, 0.073, 0.180, 0.328, 0.122, 0.024, 0.304, 0.175), each = 3),
  n = rep(c(50, 100, 200), 8),
  Bias = c(0.093, 0.066, 0.047,  # S1
           0.039, 0.020, 0.009,  # S2
           0.010, 0.003, 0.001,  # S3
           0.006, 0.003, 0.001,  # S4
           0.028, 0.014, 0.007,  # S5
           0.071, 0.046, 0.028,  # S6
           0.015, 0.008, 0.003,  # S7
           0.023, 0.011, 0.006)  # S8
)

# Table 4: Coverage
coverage_df <- data.frame(
  Scenario = rep(c("S2 (0.2σ)", "S3 (0.5σ)", "S4 (1.0σ)",
                    "S5 (Scale)", "S7 (Skew)", "S8 (Loc+Scale)"), each = 3),
  n = rep(c(50, 100, 200), 6),
  Coverage = c(0.652, 0.881, 0.941,  # S2
               0.947, 0.951, 0.947,  # S3
               0.950, 0.950, 0.957,  # S4
               0.856, 0.910, 0.933,  # S5
               0.953, 0.954, 0.954,  # S7
               0.917, 0.935, 0.944)  # S8
)

# Table 5: RMSE and CI width
precision_df <- data.frame(
  Scenario = rep(c("S1 (Null)", "S2 (0.2σ)", "S3 (0.5σ)", "S4 (1.0σ)",
                    "S5 (Scale)", "S6 (Shape)", "S7 (Skew)", "S8 (Loc+Scale)"), each = 3),
  n = rep(c(50, 100, 200), 8),
  RMSE = c(0.099, 0.069, 0.049,
           0.061, 0.044, 0.032,
           0.067, 0.048, 0.035,
           0.062, 0.043, 0.030,
           0.053, 0.036, 0.025,
           0.080, 0.053, 0.033,
           0.070, 0.049, 0.034,
           0.062, 0.043, 0.030),
  CI_Width = c(0.16, 0.11, 0.08,
               0.18, 0.13, 0.11,
               0.23, 0.18, 0.13,
               0.24, 0.17, 0.12,
               0.19, 0.13, 0.09,
               0.16, 0.11, 0.08,
               0.27, 0.19, 0.13,
               0.22, 0.16, 0.12)
)

# Table 6: SMD comparison (n=100)
smd_df <- data.frame(
  Scenario = c("S3 (Location)", "S5 (Scale)", "S6 (Shape)", "S7 (Skew)"),
  nABCD_mean = c(0.183, 0.136, 0.070, 0.312),
  nABCD_sd = c(0.048, 0.033, 0.025, 0.048),
  SMD_mean = c(0.50, 0.00, 0.00, 0.00),
  SMD_sd = c(0.14, 0.14, 0.14, 0.14)
)

# ---- Theme ----
theme_paper <- theme_minimal(base_size = 13) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    strip.text = element_text(face = "bold"),
    legend.position = "bottom",
    panel.grid.minor = element_blank()
  )

# ---- Plot 1: Bias ----
bias_df$n_factor <- factor(bias_df$n)
bias_df$Scenario <- factor(bias_df$Scenario,
  levels = c("S1 (Null)", "S2 (0.2σ)", "S3 (0.5σ)", "S4 (1.0σ)",
             "S5 (Scale)", "S6 (Shape)", "S7 (Skew)", "S8 (Loc+Scale)"))

# Color: boundary scenarios in red, others in blue
bias_df$Type <- ifelse(bias_df$Scenario %in% c("S1 (Null)", "S2 (0.2σ)", "S6 (Shape)"),
                       "Near-boundary", "Non-boundary")

p1 <- ggplot(bias_df, aes(x = n, y = Bias, color = Scenario, linetype = Type)) +
  geom_line(linewidth = 0.8) +
  geom_point(size = 2) +
  geom_hline(yintercept = 0.02, linetype = "dashed", color = "gray50", linewidth = 0.5) +
  annotate("text", x = 195, y = 0.025, label = "0.02 threshold", size = 3, color = "gray40", hjust = 1) +
  scale_x_continuous(breaks = c(50, 100, 200)) +
  scale_color_brewer(palette = "Set2") +
  labs(title = "A. Bias by Scenario and Sample Size",
       x = "Sample size (n per region)", y = "Bias") +
  theme_paper

# ---- Plot 2: Coverage ----
coverage_df$n_factor <- factor(coverage_df$n)
coverage_df$Scenario <- factor(coverage_df$Scenario,
  levels = c("S2 (0.2σ)", "S3 (0.5σ)", "S4 (1.0σ)",
             "S5 (Scale)", "S7 (Skew)", "S8 (Loc+Scale)"))

p2 <- ggplot(coverage_df, aes(x = n, y = Coverage, color = Scenario)) +
  geom_line(linewidth = 0.8) +
  geom_point(size = 2) +
  geom_hline(yintercept = 0.95, linetype = "dashed", color = "gray50") +
  geom_hline(yintercept = 0.90, linetype = "dotted", color = "gray50") +
  annotate("text", x = 55, y = 0.955, label = "0.95 nominal", size = 3, color = "gray40") +
  annotate("text", x = 55, y = 0.905, label = "0.90 minimum", size = 3, color = "gray40") +
  scale_x_continuous(breaks = c(50, 100, 200)) +
  scale_y_continuous(limits = c(0.6, 1.0)) +
  scale_color_brewer(palette = "Set2") +
  labs(title = "B. Coverage Probability (95% Bootstrap CI)",
       x = "Sample size (n per region)", y = "Coverage") +
  theme_paper

# ---- Plot 3: CI Width ----
precision_df$Scenario <- factor(precision_df$Scenario,
  levels = c("S1 (Null)", "S2 (0.2σ)", "S3 (0.5σ)", "S4 (1.0σ)",
             "S5 (Scale)", "S6 (Shape)", "S7 (Skew)", "S8 (Loc+Scale)"))

p3 <- ggplot(precision_df, aes(x = n, y = CI_Width, color = Scenario)) +
  geom_line(linewidth = 0.8) +
  geom_point(size = 2) +
  scale_x_continuous(breaks = c(50, 100, 200)) +
  scale_color_brewer(palette = "Set2") +
  labs(title = "C. Mean CI Width",
       x = "Sample size (n per region)", y = "CI Width (nABCD units)") +
  theme_paper

# ---- Plot 4: nABCD vs SMD ----
smd_long <- smd_df |>
  pivot_longer(cols = c(nABCD_mean, SMD_mean),
               names_to = "Metric", values_to = "Mean") |>
  mutate(
    SD = ifelse(Metric == "nABCD_mean", nABCD_sd, SMD_sd),
    Metric = ifelse(Metric == "nABCD_mean", "nABCD", "SMD"),
    Scenario = factor(Scenario, levels = c("S3 (Location)", "S5 (Scale)", "S6 (Shape)", "S7 (Skew)"))
  )

p4 <- ggplot(smd_long, aes(x = Scenario, y = Mean, fill = Metric)) +
  geom_col(position = position_dodge(0.7), width = 0.6) +
  geom_errorbar(aes(ymin = Mean - SD, ymax = Mean + SD),
                position = position_dodge(0.7), width = 0.2) +
  scale_fill_manual(values = c("nABCD" = "#1E3A5F", "SMD" = "#BBBBBB")) +
  labs(title = "D. nABCD vs SMD Sensitivity (n = 100)",
       x = "", y = "Mean ± SD") +
  theme_paper +
  theme(axis.text.x = element_text(angle = 15, hjust = 1))

# ---- Combine ----
combined <- (p1 + p2) / (p3 + p4) +
  plot_annotation(
    title = "nABCD Simulation Results Summary",
    theme = theme(plot.title = element_text(face = "bold", size = 16, hjust = 0.5))
  )

output_path <- "C:/Users/hrd13/Documents/Gak/0 Study/800Claude/20260210_SIM/similarity_metrics/projects/similarity-metric/paper/output/simulation_results_review.png"

ggsave(output_path, combined, width = 14, height = 10, dpi = 150, bg = "white")
cat("Saved to:", output_path, "\n")
