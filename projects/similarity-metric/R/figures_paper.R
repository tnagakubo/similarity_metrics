# =============================================================================
# nABCD Paper Figures
# Author: Katrina Bennett
# Date: 2026-02-05
# Target: Statistics in Medicine
# =============================================================================

library(ggplot2)
library(dplyr)
library(tidyr)
library(readr)
library(patchwork)

# =============================================================================
# Configuration
# =============================================================================

# Paths (relative to project root) - no trailing slash
DATA_DIR <- "data"
OUTPUT_DIR <- "figures"

# Set theme for journal
theme_set(theme_bw(base_size = 11) +
  theme(
    panel.grid.minor = element_blank(),
    strip.background = element_rect(fill = "grey95"),
    legend.position = "bottom"
  ))

# Color palette (colorblind-friendly)
COLORS_REGION <- c("Japan" = "#E69F00", "US" = "#56B4E9", "EU" = "#009E73")
COLORS_SAMPLE <- c("n=50" = "#CC79A7", "n=100" = "#0072B2", "n=200" = "#D55E00")

# =============================================================================
# Data Loading Functions
# =============================================================================

load_simulation_results <- function(data_dir = DATA_DIR) {
  filepath <- file.path(data_dir, "simulation_results.csv")
  if (!file.exists(filepath)) {
    stop("Simulation results file not found: ", filepath)
  }
  read_csv(filepath, show_col_types = FALSE)
}

load_simulation_v2 <- function(data_dir = DATA_DIR) {
  filepath <- file.path(data_dir, "simulation_results_v2.csv")
  if (!file.exists(filepath)) {
    stop("Simulation results v2 file not found: ", filepath)
  }
  read_csv(filepath, show_col_types = FALSE)
}

load_application_params <- function(data_dir = DATA_DIR) {
  filepath <- file.path(data_dir, "application_params.csv")
  if (!file.exists(filepath)) {
    stop("Application parameters file not found: ", filepath)
  }
  read_csv(filepath, show_col_types = FALSE)
}

# =============================================================================
# Figure 2: nABCD Visual Definition
# =============================================================================

fig2_nabcd_definition <- function(mu1 = 45, mu2 = 55, sigma = 10) {
  # Generate two distributions (parameterized)
  set.seed(42)
  x <- seq(mu1 - 3*sigma, mu2 + 3*sigma, length.out = 500)

  cdf1 <- pnorm(x, mean = mu1, sd = sigma)
  cdf2 <- pnorm(x, mean = mu2, sd = sigma)

  df <- tibble(x = x, F1 = cdf1, F2 = cdf2)

  df_ribbon <- df %>%
    mutate(
      ymin = pmin(F1, F2),
      ymax = pmax(F1, F2)
    )

  ggplot(df) +
    geom_ribbon(data = df_ribbon, aes(x = x, ymin = ymin, ymax = ymax),
                fill = "#56B4E9", alpha = 0.4) +
    geom_line(aes(x = x, y = F1, color = "Region 1"), linewidth = 1) +
    geom_line(aes(x = x, y = F2, color = "Region 2"), linewidth = 1) +
    scale_color_manual(values = c("Region 1" = "#E69F00", "Region 2" = "#0072B2")) +
    labs(
      x = "Effect Modifier Value",
      y = "Cumulative Probability",
      color = NULL,
      title = "Figure 2: nABCD as Area Between CDFs"
    ) +
    annotate("text", x = mean(c(mu1, mu2)), y = 0.5,
             label = "W1 = Shaded Area", size = 4, fontface = "italic") +
    theme(legend.position.inside = c(0.85, 0.25))
}

# =============================================================================
# Figure 3: Bias by Sample Size (from data)
# =============================================================================

fig3_bias <- function(data_dir = DATA_DIR) {
  sim_results <- load_simulation_v2(data_dir)

  # Prepare data for plotting
  scenario_labels <- c(
    "S01" = "S01\n(Null)",
    "S03" = "S03\n(0.2s)",
    "S04" = "S04\n(0.5s)",
    "S05" = "S05\n(1.0s)",
    "S06" = "S06\n(Scale)",
    "S08" = "S08\n(Shape)"
  )

  bias_data <- sim_results %>%
    filter(Scenario %in% names(scenario_labels)) %>%
    mutate(
      ScenarioLabel = factor(scenario_labels[Scenario],
                             levels = scenario_labels),
      SampleSizeLabel = factor(paste0("n=", SampleSize),
                               levels = c("n=50", "n=100", "n=200"))
    )

  ggplot(bias_data, aes(x = ScenarioLabel, y = Bias, fill = SampleSizeLabel)) +
    geom_col(position = position_dodge(0.8), width = 0.7) +
    geom_hline(yintercept = 0, linetype = "dashed", color = "grey50") +
    geom_hline(yintercept = c(-0.02, 0.02), linetype = "dotted",
               color = "red", alpha = 0.5) +
    scale_fill_manual(values = COLORS_SAMPLE) +
    labs(
      x = "Scenario",
      y = "Bias",
      fill = "Sample Size",
      title = "Figure 3: Bias of nABCD Estimator"
    ) +
    annotate("text", x = 6.3, y = 0.02, label = "+/-0.02", color = "red", size = 3)
}

# =============================================================================
# Figure 4: Estimation Quality — Coverage + CI Width (Estimation-Centered)
# Replaces old power figure per Jessica Phase 8 directive
# =============================================================================

fig4_estimation_quality <- function(data_dir = DATA_DIR) {
  sim_results <- load_simulation_v2(data_dir)

  # If MeanCIWidth not present (old CSV), approximate from RMSE
  if (!"MeanCIWidth" %in% names(sim_results)) {
    sim_results <- sim_results %>%
      mutate(MeanCIWidth = 2 * 1.96 * SD)
  }

  # Exclude null scenario (coverage undefined at boundary)
  plot_data <- sim_results %>%
    filter(Scenario != "S01") %>%
    mutate(
      ScenarioLabel = factor(
        case_when(
          Scenario == "S03" ~ "S03 (0.2s)",
          Scenario == "S04" ~ "S04 (0.5s)",
          Scenario == "S05" ~ "S05 (1.0s)",
          Scenario == "S06" ~ "S06 (Scale)",
          Scenario == "S08" ~ "S08 (Shape)",
          TRUE ~ Scenario
        ),
        levels = c("S03 (0.2s)", "S04 (0.5s)", "S05 (1.0s)",
                    "S06 (Scale)", "S08 (Shape)")
      ),
      SampleSizeLabel = factor(paste0("n=", SampleSize),
                               levels = c("n=50", "n=100", "n=200"))
    )

  # Panel A: Coverage probability
  p1 <- ggplot(plot_data, aes(x = ScenarioLabel, y = Coverage_Pct,
                               fill = SampleSizeLabel)) +
    geom_col(position = position_dodge(0.8), width = 0.7) +
    geom_hline(yintercept = 0.95, linetype = "dashed", color = "red", alpha = 0.7) +
    geom_hline(yintercept = 0.90, linetype = "dotted", color = "orange", alpha = 0.7) +
    scale_fill_manual(values = COLORS_SAMPLE) +
    scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.1)) +
    labs(
      x = NULL,
      y = "Coverage Probability",
      fill = "Sample Size",
      subtitle = "A) Bootstrap 95% CI Coverage"
    ) +
    annotate("text", x = 5.4, y = 0.95, label = "0.95", color = "red",
             size = 3, hjust = 0) +
    theme(axis.text.x = element_text(angle = 30, hjust = 1))

  # Panel B: Mean CI Width
  p2 <- ggplot(plot_data, aes(x = ScenarioLabel, y = MeanCIWidth,
                               fill = SampleSizeLabel)) +
    geom_col(position = position_dodge(0.8), width = 0.7) +
    scale_fill_manual(values = COLORS_SAMPLE) +
    labs(
      x = NULL,
      y = "Mean CI Width (nABCD units)",
      fill = "Sample Size",
      subtitle = "B) Estimation Precision"
    ) +
    theme(axis.text.x = element_text(angle = 30, hjust = 1))

  p1 + p2 +
    plot_layout(guides = "collect") +
    plot_annotation(
      title = "Figure 4: Estimation Quality of nABCD Bootstrap Inference"
    ) &
    theme(legend.position = "bottom")
}

# =============================================================================
# Figure 5: SMD vs nABCD Comparison
# =============================================================================

fig5_smd_comparison <- function(n = 500, mu = 50, sd1 = 10, sd2 = 15, seed = 123) {
  set.seed(seed)

  # Scenario: Same mean, different variance
  x1 <- rnorm(n, mean = mu, sd = sd1)
  x2 <- rnorm(n, mean = mu, sd = sd2)

  # Calculate actual metrics
  pooled_sd <- sqrt((var(x1) + var(x2)) / 2)
  smd_value <- abs(mean(x1) - mean(x2)) / pooled_sd

  # Calculate nABCD (approximation)
  iqr_pooled <- IQR(c(x1, x2))
  ecdf1 <- ecdf(x1)
  ecdf2 <- ecdf(x2)
  x_grid <- sort(unique(c(x1, x2)))
  w1_approx <- sum(abs(ecdf1(x_grid) - ecdf2(x_grid)) * c(diff(x_grid), 0))
  nabcd_value <- w1_approx / (2 * iqr_pooled)

  df <- tibble(
    value = c(x1, x2),
    group = rep(c(paste0("Region 1\n(sd=", sd1, ")"),
                  paste0("Region 2\n(sd=", sd2, ")")), each = n)
  )

  # Panel A: Density plot
  p1 <- ggplot(df, aes(x = value, fill = group)) +
    geom_density(alpha = 0.5) +
    scale_fill_manual(values = c("#E69F00", "#0072B2")) +
    labs(
      x = "Effect Modifier Value",
      y = "Density",
      fill = NULL,
      subtitle = "A) Same mean, different variance"
    ) +
    theme(legend.position.inside = c(0.85, 0.85))

  # Panel B: Metric comparison (using calculated values)
  metrics <- tibble(
    Metric = c("SMD", "nABCD"),
    Value = round(c(smd_value, nabcd_value), 2),
    Detection = c(ifelse(smd_value > 0.1, "Yes", "No"),
                  ifelse(nabcd_value > 0.1, "Yes", "No"))
  )

  p2 <- ggplot(metrics, aes(x = Metric, y = Value, fill = Detection)) +
    geom_col(width = 0.6) +
    geom_text(aes(label = Value), vjust = -0.5, size = 4) +
    scale_fill_manual(values = c("No" = "#999999", "Yes" = "#009E73")) +
    scale_y_continuous(limits = c(0, max(metrics$Value) * 1.3)) +
    labs(
      x = NULL,
      y = "Metric Value",
      fill = "Detects\nDifference?",
      subtitle = "B) Metric comparison"
    )

  p1 + p2 +
    plot_annotation(title = "Figure 5: nABCD Detects Scale Differences Missed by SMD")
}

# =============================================================================
# Figure 6: BMI Distribution Example (from data)
# =============================================================================

fig6_application <- function(data_dir = DATA_DIR, em = "BMI", seed = 456) {
  set.seed(seed)

  params <- load_application_params(data_dir) %>%
    filter(EffectModifier == em)

  # Generate data based on parameters
  data_list <- params %>%
    rowwise() %>%
    mutate(values = list(rnorm(N, mean = Mean, sd = SD))) %>%
    ungroup()

  df <- data_list %>%
    select(Region, values) %>%
    unnest(values) %>%
    rename(Value = values)

  df$Region <- factor(df$Region, levels = c("Japan", "US", "EU"))

  # Get nABCD values for subtitle
  nabcd_japan_us <- params$nABCD_vs_US[params$Region == "Japan"]
  nabcd_japan_eu <- params$nABCD_vs_Japan[params$Region == "EU"]
  nabcd_us_eu <- params$nABCD_vs_US[params$Region == "EU"]

  subtitle_text <- sprintf("nABCD: Japan-US = %.2f, Japan-EU = %.2f, US-EU = %.2f",
                           nabcd_japan_us, nabcd_japan_eu, nabcd_us_eu)

  # Summary stats for annotation
  stats <- df %>%
    group_by(Region) %>%
    summarise(mean = mean(Value), .groups = "drop")

  # X-axis label based on EM
  x_label <- switch(em,
    "BMI" = "BMI (kg/m^2)",
    "Age" = "Age (years)",
    "HbA1c" = "HbA1c (%)",
    em
  )

  ggplot(df, aes(x = Value, fill = Region)) +
    geom_density(alpha = 0.5) +
    geom_vline(data = stats, aes(xintercept = mean, color = Region),
               linetype = "dashed", linewidth = 0.8) +
    scale_fill_manual(values = COLORS_REGION) +
    scale_color_manual(values = COLORS_REGION) +
    labs(
      x = x_label,
      y = "Density",
      fill = "Region",
      color = "Region",
      title = paste0("Figure 6: ", em, " Distribution by Region"),
      subtitle = subtitle_text
    )
}

# =============================================================================
# Generate All Figures
# =============================================================================

generate_all_figures <- function(data_dir = DATA_DIR, output_dir = OUTPUT_DIR) {
  dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

  message("Generating figures from data in: ", data_dir)

  # Figure 2
  ggsave(file.path(output_dir, "fig2_nabcd_definition.png"),
         fig2_nabcd_definition(), width = 8, height = 5, dpi = 300)
  ggsave(file.path(output_dir, "fig2_nabcd_definition.pdf"),
         fig2_nabcd_definition(), width = 8, height = 5)
  message("  Figure 2: Done")

  # Figure 3
  ggsave(file.path(output_dir, "fig3_bias.png"),
         fig3_bias(data_dir), width = 10, height = 5, dpi = 300)
  ggsave(file.path(output_dir, "fig3_bias.pdf"),
         fig3_bias(data_dir), width = 10, height = 5)
  message("  Figure 3: Done")

  # Figure 4 (Estimation Quality: Coverage + CI Width)
  ggsave(file.path(output_dir, "fig4_estimation_quality.png"),
         fig4_estimation_quality(data_dir), width = 12, height = 5, dpi = 300)
  ggsave(file.path(output_dir, "fig4_estimation_quality.pdf"),
         fig4_estimation_quality(data_dir), width = 12, height = 5)
  message("  Figure 4: Done")

  # Figure 5
  ggsave(file.path(output_dir, "fig5_smd_comparison.png"),
         fig5_smd_comparison(), width = 10, height = 5, dpi = 300)
  ggsave(file.path(output_dir, "fig5_smd_comparison.pdf"),
         fig5_smd_comparison(), width = 10, height = 5)
  message("  Figure 5: Done")

  # Figure 6
  ggsave(file.path(output_dir, "fig6_application.png"),
         fig6_application(data_dir), width = 8, height = 5, dpi = 300)
  ggsave(file.path(output_dir, "fig6_application.pdf"),
         fig6_application(data_dir), width = 8, height = 5)
  message("  Figure 6: Done")

  message("\nAll figures saved to: ", output_dir)
}

# =============================================================================
# Usage
# =============================================================================
# Set working directory to project root, then:
# source("R/figures_paper.R")
# generate_all_figures()
#
# Or generate individual figures:
# fig3_bias("data/")
# fig6_application("data/", em = "Age")
# =============================================================================
