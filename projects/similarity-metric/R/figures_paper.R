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

# Paths - auto-detect project root from script location
.find_project_root <- function() {
  # 1. When source()'d: use script path
  for (f in rev(sys.frames())) {
    if (!is.null(f$ofile)) return(dirname(dirname(normalizePath(f$ofile))))
  }
  # 2. RStudio: use active document path
  if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
    path <- tryCatch(rstudioapi::getActiveDocumentContext()$path, error = function(e) "")
    if (nzchar(path)) return(dirname(dirname(normalizePath(path))))
  }
  # 3. Fallback: getwd()
  getwd()
}
.project_root <- .find_project_root()

DATA_DIR <- file.path(.project_root, "data")
OUTPUT_DIR <- file.path(.project_root, "figures")

# Set theme for journal
theme_set(theme_bw(base_size = 11) +
  theme(
    panel.grid.minor = element_blank(),
    strip.background = element_rect(fill = "grey95"),
    legend.position = "bottom"
  ))

# Color palette (colorblind-friendly)
# Region: qualitative 3-level, Okabe-Ito (CVD-safe)
COLORS_REGION <- c("Japan" = "#E69F00", "US" = "#56B4E9", "EU" = "#009E73")
# SampleSize: ordered / sequential 3-level — single-hue blue light -> dark
# (ColorBrewer "Blues" anchors; monotone luminance keeps grayscale order)
COLORS_SAMPLE <- c("n=50" = "#9ECAE1", "n=100" = "#4292C6", "n=200" = "#08519C")

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
# Figure 1: Scenario Overview — Density plots for all 7 scenarios
# =============================================================================

fig1_scenario_overview <- function(n_plot = 5000, seed = 42) {
  set.seed(seed)

  # Scenario definitions (matched to simulation_manuscript_v2.R)
  sc_defs <- list(
    list(id = "S1", name = "Null (identical)",
         d1 = rnorm(n_plot, 50, 10), d2 = rnorm(n_plot, 50, 10)),
    list(id = "S2", name = "Location (0.2 sigma)",
         d1 = rnorm(n_plot, 50, 10), d2 = rnorm(n_plot, 52, 10)),
    list(id = "S3", name = "Location (0.5 sigma)",
         d1 = rnorm(n_plot, 50, 10), d2 = rnorm(n_plot, 55, 10)),
    list(id = "S4", name = "Location (1.0 sigma)",
         d1 = rnorm(n_plot, 50, 10), d2 = rnorm(n_plot, 60, 10)),
    list(id = "S5", name = "Scale (1.5x)",
         d1 = rnorm(n_plot, 50, 10), d2 = rnorm(n_plot, 50, 15)),
    list(id = "S6", name = "Skew (log-normal)",
         d1 = rnorm(n_plot, 50, 10),
         d2 = rlnorm(n_plot, meanlog = log(50) - 0.5^2/2, sdlog = 0.5)),
    list(id = "S7", name = "Location + Scale",
         d1 = rnorm(n_plot, 50, 10), d2 = rnorm(n_plot, 55, 15))
  )

  # Build data frame
  df_all <- do.call(rbind, lapply(sc_defs, function(sc) {
    tibble(
      Scenario = paste0(sc$id, ": ", sc$name),
      Value    = c(sc$d1, sc$d2),
      Region   = rep(c("Region 1", "Region 2"), each = n_plot)
    )
  }))

  df_all$Scenario <- factor(df_all$Scenario, levels = sapply(sc_defs, function(s)
    paste0(s$id, ": ", s$name)))

  ggplot(df_all, aes(x = Value, fill = Region)) +
    geom_density(alpha = 0.45, linewidth = 0.4) +
    facet_wrap(~ Scenario, ncol = 4, scales = "free") +
    scale_fill_manual(values = c("Region 1" = "#E69F00", "Region 2" = "#0072B2")) +
    labs(x = "Effect Modifier Value", y = "Density", fill = NULL) +
    theme(
      strip.text = element_text(size = 9, face = "bold"),
      axis.text = element_text(size = 7),
      legend.position = "bottom"
    )
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
      color = NULL
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
    "S1" = "S1\n(Null)",
    "S2" = "S2\n(0.2s)",
    "S3" = "S3\n(0.5s)",
    "S4" = "S4\n(1.0s)",
    "S5" = "S5\n(Scale)",
    "S6" = "S6\n(LogN)",
    "S7" = "S7\n(Loc+Sc)"
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
               color = "grey40", alpha = 0.7) +
    scale_fill_manual(values = COLORS_SAMPLE) +
    labs(
      x = "Scenario",
      y = "Bias",
      fill = "Sample Size"
    ) +
    annotate("text", x = 5.3, y = 0.02, label = "+/-0.02", color = "grey30", size = 3)
}

# =============================================================================
# Figure 4: Estimation Quality - Coverage + CI Width (Estimation-Centered)
# Replaces old power figure per Jessica Phase 8 directive
#
# Current scenario set: S1 (Null), S2-S4 (Location), S5 (Scale),
#   S6 = log-normal (TrueNABCD ~= 0.304), S7 = Location + Scale (~= 0.175).
# All scenarios have healthy coverage near the nominal 0.95 level.
# =============================================================================

# Helper: prepare shared estimation-quality plot data
.prep_estimation_plot_data <- function(data_dir = DATA_DIR) {
  sim_results <- load_simulation_v2(data_dir)

  # If MeanCIWidth not present (old CSV), approximate from RMSE
  if (!"MeanCIWidth" %in% names(sim_results)) {
    sim_results <- sim_results %>%
      mutate(MeanCIWidth = 2 * 1.96 * SD)
  }

  # Exclude null scenario (coverage undefined at boundary).
  sim_results %>%
    filter(Scenario != "S1") %>%
    mutate(
      ScenarioLabel = factor(
        case_when(
          Scenario == "S2" ~ "S2 (0.2s)",
          Scenario == "S3" ~ "S3 (0.5s)",
          Scenario == "S4" ~ "S4 (1.0s)",
          Scenario == "S5" ~ "S5 (Scale)",
          Scenario == "S6" ~ "S6 (LogN)",
          Scenario == "S7" ~ "S7 (Loc+Sc)",
          TRUE ~ Scenario
        ),
        levels = c("S2 (0.2s)", "S3 (0.5s)", "S4 (1.0s)",
                    "S5 (Scale)", "S6 (LogN)", "S7 (Loc+Sc)")
      ),
      SampleSizeLabel = factor(paste0("n=", SampleSize),
                               levels = c("n=50", "n=100", "n=200"))
    )
}

# --- Figure 4a: Coverage only ------------------------------------------------
fig4a_coverage <- function(data_dir = DATA_DIR) {
  plot_data <- .prep_estimation_plot_data(data_dir)

  # Label for any zero-coverage bars (defensive — kept in case future
  # scenarios produce zero coverage; currently no S2-S7 scenario has Cov=0)
  zero_cov <- plot_data %>%
    filter(Coverage_Pct == 0)

  ggplot(plot_data, aes(x = ScenarioLabel, y = Coverage_Pct,
                        fill = SampleSizeLabel)) +
    geom_col(position = position_dodge(0.8), width = 0.7) +
    # Zero-coverage marker: small tick at baseline + numeric label "0"
    geom_text(data = zero_cov,
              aes(label = "0"),
              position = position_dodge(0.8),
              vjust = -0.3, size = 2.6, color = "grey30") +
    geom_hline(yintercept = 0.95, linetype = "dashed", color = "grey30", alpha = 0.8) +
    geom_hline(yintercept = 0.90, linetype = "dotted", color = "grey50", alpha = 0.8) +
    scale_fill_manual(values = COLORS_SAMPLE) +
    scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.1)) +
    labs(
      x = "Scenario",
      y = "Coverage Probability",
      fill = "Sample Size"
    ) +
    annotate("text", x = 4.8, y = 0.95, label = "0.95", color = "grey30",
             size = 3, hjust = 0) +
    theme(axis.text.x = element_text(angle = 30, hjust = 1))
}

# --- Figure 4b: Precision (CI width) only -----------------------------------
fig4b_precision <- function(data_dir = DATA_DIR) {
  plot_data <- .prep_estimation_plot_data(data_dir)

  ggplot(plot_data, aes(x = ScenarioLabel, y = MeanCIWidth,
                        fill = SampleSizeLabel)) +
    geom_col(position = position_dodge(0.8), width = 0.7) +
    scale_fill_manual(values = COLORS_SAMPLE) +
    labs(
      x = "Scenario",
      y = "Mean CI Width (nABCD units)",
      fill = "Sample Size"
    ) +
    theme(axis.text.x = element_text(angle = 30, hjust = 1))
}

# --- Figure 4: backward-compatible combined panel ---------------------------
fig4_estimation_quality <- function(data_dir = DATA_DIR) {
  p1 <- fig4a_coverage(data_dir) +
    labs(x = NULL, subtitle = "A) Bootstrap 95% CI Coverage")
  p2 <- fig4b_precision(data_dir) +
    labs(x = NULL, subtitle = "B) Estimation Precision")

  p1 + p2 +
    plot_layout(guides = "collect") &
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
    # Binary detection encoded as neutral grey (No) vs lab-default blue (Yes)
    # Avoids red/green significance encoding (accessibility.md S1, fig guide S5).
    scale_fill_manual(values = c("No" = "#999999", "Yes" = "#0072B2")) +
    scale_y_continuous(limits = c(0, max(metrics$Value) * 1.3)) +
    labs(
      x = NULL,
      y = "Metric Value",
      fill = "Detects\nDifference?",
      subtitle = "B) Metric comparison"
    )

  p1 + p2
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
      color = "Region"
    )
}

# =============================================================================
# Generate All Figures
# =============================================================================

generate_all_figures <- function(data_dir = DATA_DIR, output_dir = OUTPUT_DIR) {
  dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

  message("Project root: ", .project_root)
  message("Generating figures from data in: ", data_dir)

  # Figure 1: Scenario Overview
  ggsave(file.path(output_dir, "fig1_scenario_overview.png"),
         fig1_scenario_overview(), width = 14, height = 7, dpi = 300)
  ggsave(file.path(output_dir, "fig1_scenario_overview.pdf"),
         fig1_scenario_overview(), width = 14, height = 7)
  message("  Figure 1: Done")

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

  # Figure 4 (Estimation Quality: Coverage + CI Width) — combined (legacy)
  ggsave(file.path(output_dir, "fig4_estimation_quality.png"),
         fig4_estimation_quality(data_dir), width = 12, height = 5, dpi = 300)
  ggsave(file.path(output_dir, "fig4_estimation_quality.pdf"),
         fig4_estimation_quality(data_dir), width = 12, height = 5)
  message("  Figure 4 (combined): Done")

  # Figure 4a (Coverage only) — split version
  ggsave(file.path(output_dir, "fig4a_coverage.png"),
         fig4a_coverage(data_dir), width = 8, height = 5, dpi = 300)
  ggsave(file.path(output_dir, "fig4a_coverage.pdf"),
         fig4a_coverage(data_dir), width = 8, height = 5)
  message("  Figure 4a (coverage): Done")

  # Figure 4b (Precision / CI Width only) — split version
  ggsave(file.path(output_dir, "fig4b_precision.png"),
         fig4b_precision(data_dir), width = 8, height = 5, dpi = 300)
  ggsave(file.path(output_dir, "fig4b_precision.pdf"),
         fig4b_precision(data_dir), width = 8, height = 5)
  message("  Figure 4b (precision): Done")

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
# source("R/figures_paper.R")  # or open in RStudio
# generate_all_figures()       # works from any working directory
#
# Or generate individual figures:
# fig3_bias("data/")
# fig6_application("data/", em = "Age")
# =============================================================================
