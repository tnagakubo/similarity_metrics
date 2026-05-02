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
# Paper font standard (2026-05-02): tag/axis.title rel(0.95), axis.text/legend.text rel(0.85)
# axis.text in pure black for readability. Applied uniformly to all paper figures.
theme_set(theme_bw(base_size = 11) +
  theme(
    panel.grid.minor = element_blank(),
    strip.background = element_rect(fill = "grey95"),
    legend.position = "bottom",
    plot.tag = element_text(size = rel(0.95)),
    axis.title = element_text(size = rel(0.95)),
    axis.text = element_text(size = rel(0.85), color = "black"),
    legend.title = element_text(size = rel(0.85)),
    legend.text = element_text(size = rel(0.85))
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

fig1_scenario_overview <- function(palette = c("greyscale", "color")) {
  palette <- match.arg(palette)

  # Theoretical density definitions (closed-form, no simulation)
  # Matched to simulation_manuscript_v2.R parametric specifications
  sc_defs <- list(
    list(id = "S1", name = "Null (identical)",
         pdf1 = function(x) dnorm(x, 50, 10),
         pdf2 = function(x) dnorm(x, 50, 10),
         xrange = c(20, 80)),
    list(id = "S2", name = "Location (0.2 sigma)",
         pdf1 = function(x) dnorm(x, 50, 10),
         pdf2 = function(x) dnorm(x, 52, 10),
         xrange = c(20, 80)),
    list(id = "S3", name = "Location (0.5 sigma)",
         pdf1 = function(x) dnorm(x, 50, 10),
         pdf2 = function(x) dnorm(x, 55, 10),
         xrange = c(20, 85)),
    list(id = "S4", name = "Location (1.0 sigma)",
         pdf1 = function(x) dnorm(x, 50, 10),
         pdf2 = function(x) dnorm(x, 60, 10),
         xrange = c(20, 90)),
    list(id = "S5", name = "Scale (1.5x)",
         pdf1 = function(x) dnorm(x, 50, 10),
         pdf2 = function(x) dnorm(x, 50, 15),
         xrange = c(0, 100)),
    list(id = "S6", name = "Skew (log-normal)",
         pdf1 = function(x) dnorm(x, 50, 10),
         pdf2 = function(x) dlnorm(x, meanlog = log(50) - 0.5^2/2, sdlog = 0.5),
         xrange = c(0, 200)),
    list(id = "S7", name = "Location + Scale",
         pdf1 = function(x) dnorm(x, 50, 10),
         pdf2 = function(x) dnorm(x, 55, 15),
         xrange = c(0, 100))
  )

  # Build data frame from analytical PDFs
  df_all <- do.call(rbind, lapply(sc_defs, function(sc) {
    x <- seq(sc$xrange[1], sc$xrange[2], length.out = 500)
    rbind(
      tibble(Scenario = paste0(sc$id, ": ", sc$name),
             Value = x, Density = sc$pdf1(x), Region = "Region 1"),
      tibble(Scenario = paste0(sc$id, ": ", sc$name),
             Value = x, Density = sc$pdf2(x), Region = "Region 2")
    )
  }))

  df_all$Scenario <- factor(df_all$Scenario, levels = sapply(sc_defs, function(s)
    paste0(s$id, ": ", s$name)))

  # Palette: greyscale (paper) uses outline-only Region 2; color (slides) uses theme red + deep navy
  if (palette == "color") {
    fill_vals  <- c("Region 1" = "#D52B1E", "Region 2" = "#1E3A5F")
    color_vals <- c("Region 1" = "#D52B1E", "Region 2" = "#1E3A5F")
  } else {
    fill_vals  <- c("Region 1" = "grey60", "Region 2" = NA)
    color_vals <- c("Region 1" = "grey20", "Region 2" = "grey20")
  }

  ggplot(df_all, aes(x = Value, y = Density,
                     fill = Region, color = Region, linetype = Region,
                     group = Region)) +
    geom_area(position = "identity", alpha = 0.45, linewidth = 0.5) +
    facet_wrap(~ Scenario, ncol = 4, scales = "free") +
    scale_fill_manual(values = fill_vals, na.value = NA) +
    scale_color_manual(values = color_vals) +
    scale_linetype_manual(values = c("Region 1" = "solid", "Region 2" = "dashed")) +
    labs(x = "Effect Modifier Value", y = "Density",
         fill = NULL, color = NULL, linetype = NULL) +
    theme(
      strip.text = element_text(size = 9, face = "bold"),
      axis.text = element_text(size = 7),
      legend.position = "bottom"
    )
}

# =============================================================================
# Figure 2: nABCD Visual Definition
# =============================================================================

fig2_nabcd_definition <- function(palette = c("greyscale", "color")) {
  palette <- match.arg(palette)

  # Region 1: Gamma(shape=4, scale=10), mean=40, right-skewed
  # Region 2: Normal(mean=55, sd=10), symmetric
  shape1 <- 4; scale1 <- 10
  mu2 <- 55; sd2 <- 10

  x <- seq(0, 100, length.out = 500)

  pdf1 <- dgamma(x, shape = shape1, scale = scale1)
  pdf2 <- dnorm(x, mean = mu2, sd = sd2)
  cdf1 <- pgamma(x, shape = shape1, scale = scale1)
  cdf2 <- pnorm(x, mean = mu2, sd = sd2)

  df <- tibble(x = x, f1 = pdf1, f2 = pdf2, F1 = cdf1, F2 = cdf2)
  df_ribbon <- df %>% mutate(ymin = pmin(F1, F2), ymax = pmax(F1, F2))

  # x position for W_1 annotation: where the gap between CDFs is widest
  i_max <- which.max(abs(df$F1 - df$F2))
  x_anno <- df$x[i_max]
  y_anno <- mean(c(df$F1[i_max], df$F2[i_max]))

  # Palette: greyscale (paper) uses black lines; color (slides) uses theme red + deep navy
  if (palette == "color") {
    line_vals <- c("Region 1" = "#D52B1E", "Region 2" = "#1E3A5F")
  } else {
    line_vals <- c("Region 1" = "black",   "Region 2" = "black")
  }

  legend_style <- theme(
    legend.background = element_rect(fill = "white", color = NA),
    legend.key.width = unit(0.8, "lines"),
    legend.key.height = unit(0.8, "lines"),
    legend.margin = margin(2, 4, 2, 4)
  )

  tag_style <- theme(
    plot.tag.position = c(0, 1.02),
    plot.margin = margin(t = 14, r = 12, b = 5, l = 12)
  )

  p_pdf <- ggplot(df) +
    geom_line(aes(x = x, y = f1, linetype = "Region 1", color = "Region 1"), linewidth = 0.5) +
    geom_line(aes(x = x, y = f2, linetype = "Region 2", color = "Region 2"), linewidth = 0.5) +
    scale_linetype_manual(values = c("Region 1" = "solid", "Region 2" = "dashed")) +
    scale_color_manual(values = line_vals) +
    labs(x = "Effect Modifier Value", y = "Density",
         linetype = "Region", color = "Region", tag = "(A)") +
    legend_style + tag_style

  p_cdf <- ggplot(df) +
    geom_ribbon(data = df_ribbon, aes(x = x, ymin = ymin, ymax = ymax),
                fill = "grey60", alpha = 0.6) +
    geom_line(aes(x = x, y = F1, linetype = "Region 1", color = "Region 1"), linewidth = 0.5) +
    geom_line(aes(x = x, y = F2, linetype = "Region 2", color = "Region 2"), linewidth = 0.5) +
    scale_linetype_manual(values = c("Region 1" = "solid", "Region 2" = "dashed")) +
    scale_color_manual(values = line_vals) +
    labs(x = "Effect Modifier Value", y = "Cumulative Probability",
         linetype = "Region", color = "Region", tag = "(B)") +
    annotate("text", x = x_anno, y = y_anno, label = "W[1]",
             parse = TRUE, size = 3.5) +
    legend_style + tag_style

  (p_pdf + p_cdf) +
    plot_layout(guides = "collect") &
    theme(legend.position = "right")
}

# =============================================================================
# Figure 3: Bias by Sample Size (from data)
# =============================================================================

fig3_bias <- function(palette = c("greyscale", "color"), data_dir = DATA_DIR) {
  palette <- match.arg(palette)
  sim_results <- load_simulation_v2(data_dir)

  # Short scenario labels (matched to fig4_estimation_quality)
  scenario_labels <- c(
    "S1" = "S1", "S2" = "S2", "S3" = "S3", "S4" = "S4",
    "S5" = "S5", "S6" = "S6", "S7" = "S7"
  )

  bias_data <- sim_results %>%
    filter(Scenario %in% names(scenario_labels)) %>%
    mutate(
      ScenarioLabel = factor(scenario_labels[Scenario],
                             levels = scenario_labels),
      SampleSizeLabel = factor(paste0("n=", SampleSize),
                               levels = c("n=50", "n=100", "n=200"))
    )

  # Palette: paper = Greys gradient, slides = Red gradient (theme red lightness)
  if (palette == "color") {
    fill_vals <- c("n=50" = "#F4A39B", "n=100" = "#D52B1E", "n=200" = "#8B0000")
  } else {
    fill_vals <- c("n=50" = "#999999", "n=100" = "#555555", "n=200" = "#1A1A1A")
  }

  ggplot(bias_data, aes(x = ScenarioLabel, y = Bias, fill = SampleSizeLabel)) +
    geom_col(position = position_dodge(0.8), width = 0.7) +
    geom_hline(yintercept = 0, linetype = "dashed", color = "grey50") +
    scale_fill_manual(values = fill_vals) +
    coord_cartesian(ylim = c(0, 0.10)) +
    labs(x = "Scenario", y = "Bias", fill = "Sample Size") +
    theme(legend.position = "inside",
          legend.position.inside = c(0.98, 0.98),
          legend.justification.inside = c(1, 1),
          legend.background = element_rect(fill = "white", color = NA))
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

  # Include all scenarios including S1 (boundary). S1 coverage is structurally
  # zero (non-negativity constraint at parameter space boundary); shown for
  # transparency. Short S1-S7 IDs for axis tick labels (avoids overlap in
  # combined two-panel layout); full names appear in caption / fig1 overview.
  scenario_labels <- c(
    "S1" = "S1",
    "S2" = "S2",
    "S3" = "S3",
    "S4" = "S4",
    "S5" = "S5",
    "S6" = "S6",
    "S7" = "S7"
  )

  sim_results %>%
    filter(Scenario %in% names(scenario_labels)) %>%
    mutate(
      ScenarioLabel = factor(scenario_labels[Scenario],
                             levels = scenario_labels),
      SampleSizeLabel = factor(paste0("n=", SampleSize),
                               levels = c("n=50", "n=100", "n=200"))
    )
}

# Helper: sample-size palette (greyscale = paper, color = slides theme red)
.sample_size_palette <- function(palette = c("greyscale", "color")) {
  palette <- match.arg(palette)
  if (palette == "color") {
    c("n=50" = "#F4A39B", "n=100" = "#D52B1E", "n=200" = "#8B0000")
  } else {
    c("n=50" = "#999999", "n=100" = "#555555", "n=200" = "#1A1A1A")
  }
}

# --- Figure 4a: Coverage only ------------------------------------------------
fig4a_coverage <- function(palette = c("greyscale", "color"), data_dir = DATA_DIR) {
  palette <- match.arg(palette)
  plot_data <- .prep_estimation_plot_data(data_dir)

  # Label for zero-coverage bars (S1 boundary scenarios)
  zero_cov <- plot_data %>%
    filter(Coverage_Pct == 0)

  ggplot(plot_data, aes(x = ScenarioLabel, y = Coverage_Pct,
                        fill = SampleSizeLabel)) +
    geom_col(position = position_dodge(0.8), width = 0.7) +
    geom_text(data = zero_cov,
              aes(label = "0"),
              position = position_dodge(0.8),
              vjust = -0.3, size = 2.6, color = "grey30") +
    geom_hline(yintercept = 0.95, linetype = "dashed", color = "grey30", alpha = 0.8) +
    scale_fill_manual(values = .sample_size_palette(palette)) +
    scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.1)) +
    labs(x = "Scenario", y = "Coverage Probability", fill = "Sample Size")
}

# --- Figure 4b: Precision (CI width) only -----------------------------------
fig4b_precision <- function(palette = c("greyscale", "color"), data_dir = DATA_DIR) {
  palette <- match.arg(palette)
  plot_data <- .prep_estimation_plot_data(data_dir)

  ggplot(plot_data, aes(x = ScenarioLabel, y = MeanCIWidth,
                        fill = SampleSizeLabel)) +
    geom_col(position = position_dodge(0.8), width = 0.7) +
    scale_fill_manual(values = .sample_size_palette(palette)) +
    labs(x = "Scenario", y = "Mean CI Width (nABCD units)", fill = "Sample Size")
}

# --- Figure 4: backward-compatible combined panel ---------------------------
fig4_estimation_quality <- function(palette = c("greyscale", "color"), data_dir = DATA_DIR) {
  palette <- match.arg(palette)
  p1 <- fig4a_coverage(palette, data_dir) +
    labs(x = "Scenario", subtitle = "(A) Bootstrap 95% CI Coverage")
  p2 <- fig4b_precision(palette, data_dir) +
    labs(x = "Scenario", subtitle = "(B) Estimation Precision")

  p1 + p2 +
    plot_layout(guides = "collect") &
    theme(legend.position = "bottom")
}

# =============================================================================
# Combined Simulation Results: Bias + Coverage + CI Width (3 panels)
# Three layout variants for review
# =============================================================================

fig_combo_simulation <- function(palette = c("greyscale", "color"),
                                  layout = c("horizontal", "vertical", "L"),
                                  data_dir = DATA_DIR) {
  palette <- match.arg(palette)
  layout <- match.arg(layout)
  plot_data <- .prep_estimation_plot_data(data_dir)
  pal <- .sample_size_palette(palette)

  # Panel A: Bias
  pA <- ggplot(plot_data, aes(x = ScenarioLabel, y = Bias, fill = SampleSizeLabel)) +
    geom_col(position = position_dodge(0.8), width = 0.7) +
    geom_hline(yintercept = 0, linetype = "dashed", color = "grey50") +
    scale_fill_manual(values = pal) +
    coord_cartesian(ylim = c(0, 0.10)) +
    labs(x = "Scenario", y = "Bias", fill = "Sample Size",
         subtitle = "(A) Bias")

  # Panel B: Coverage
  zero_cov <- plot_data %>% filter(Coverage_Pct == 0)
  pB <- ggplot(plot_data, aes(x = ScenarioLabel, y = Coverage_Pct, fill = SampleSizeLabel)) +
    geom_col(position = position_dodge(0.8), width = 0.7) +
    geom_text(data = zero_cov, aes(label = "0"),
              position = position_dodge(0.8), vjust = -0.3, size = 2.6, color = "grey30") +
    geom_hline(yintercept = 0.95, linetype = "dashed", color = "grey30", alpha = 0.8) +
    scale_fill_manual(values = pal) +
    scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.2)) +
    labs(x = "Scenario", y = "Coverage", fill = "Sample Size",
         subtitle = "(B) Coverage")

  # Panel C: CI Width
  pC <- ggplot(plot_data, aes(x = ScenarioLabel, y = MeanCIWidth, fill = SampleSizeLabel)) +
    geom_col(position = position_dodge(0.8), width = 0.7) +
    scale_fill_manual(values = pal) +
    labs(x = "Scenario", y = "Mean CI Width", fill = "Sample Size",
         subtitle = "(C) CI Width")

  if (layout == "horizontal") {
    (pA + pB + pC) +
      plot_layout(guides = "collect") &
      theme(legend.position = "bottom",
            legend.box.margin = margin(t = -8),
            legend.margin = margin(t = 0, b = 0))
  } else if (layout == "vertical") {
    (pA / pB / pC) +
      plot_layout(guides = "collect") &
      theme(legend.position = "right")
  } else {
    # L-shape: (A) on top full width, (B | C) below
    (pA / (pB + pC)) +
      plot_layout(guides = "collect") &
      theme(legend.position = "bottom",
            legend.box.margin = margin(t = -8),
            legend.margin = margin(t = 0, b = 0))
  }
}

# =============================================================================
# Generate All Figures
# =============================================================================

generate_all_figures <- function(data_dir = DATA_DIR, output_dir = OUTPUT_DIR) {
  dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

  message("Project root: ", .project_root)
  message("Generating figures from data in: ", data_dir)

  # Scenario Overview (slides only — paper omits this figure)
  ggsave(file.path(output_dir, "slide_scenario_overview.png"),
         fig1_scenario_overview(), width = 14, height = 7, dpi = 300)
  ggsave(file.path(output_dir, "slide_scenario_overview.pdf"),
         fig1_scenario_overview(), width = 14, height = 7)
  message("  Scenario overview (slide-only): Done")

  # Figure 2 → renamed to fig1_nabcd_definition (paper Figure 1)
  ggsave(file.path(output_dir, "fig1_nabcd_definition.png"),
         fig2_nabcd_definition(), width = 7, height = 3, dpi = 300)
  ggsave(file.path(output_dir, "fig1_nabcd_definition.pdf"),
         fig2_nabcd_definition(), width = 7, height = 3)
  message("  Figure 1 (nabcd_definition): Done")

  # Bias panel (slide-only; paper uses combined fig2_simulation_results)
  ggsave(file.path(output_dir, "slide_bias.png"),
         fig3_bias(data_dir), width = 7, height = 3.5, dpi = 300)
  ggsave(file.path(output_dir, "slide_bias.pdf"),
         fig3_bias(data_dir), width = 7, height = 3.5)
  message("  Bias (slide-only): Done")

  # Estimation Quality (Coverage + CI Width) — slide-only
  # (paper uses combined fig2_simulation_results which includes Bias panel too)
  ggsave(file.path(output_dir, "slide_estimation_quality.png"),
         fig4_estimation_quality(data_dir), width = 7, height = 2.92, dpi = 300)
  ggsave(file.path(output_dir, "slide_estimation_quality.pdf"),
         fig4_estimation_quality(data_dir), width = 7, height = 2.92)
  message("  Figure 3 (estimation_quality): Done")

  # Coverage only (split version, unused in paper/slides/poster — kept for completeness)
  ggsave(file.path(output_dir, "unused_coverage.png"),
         fig4a_coverage(data_dir), width = 8, height = 5, dpi = 300)
  ggsave(file.path(output_dir, "unused_coverage.pdf"),
         fig4a_coverage(data_dir), width = 8, height = 5)
  message("  Coverage (unused split): Done")

  # Precision / CI Width only (split version, unused in paper/slides/poster — kept for completeness)
  ggsave(file.path(output_dir, "unused_precision.png"),
         fig4b_precision(data_dir), width = 8, height = 5, dpi = 300)
  ggsave(file.path(output_dir, "unused_precision.pdf"),
         fig4b_precision(data_dir), width = 8, height = 5)
  message("  Precision (unused split): Done")

  # Figure 5: removed (Tak directive 2026-04-29) — Tab 5 in §3.2.3 already provides
  # SMD/nABCD comparison in unit-separated columns; figure was redundant and the
  # same y-axis was misleading because SMD (sigma-scaled) and nABCD (IQR-scaled)
  # have different reference units.

  # Figure 6 (BMI hypothetical) removed (Tak directive 2026-04-29) — main paper
  # uses GUSTO-I figures (fig_gusto_r8_*) instead; legacy BMI density figure
  # was unused in paper and surrounded by GUSTO-I narrative in slides/poster.

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
# =============================================================================
