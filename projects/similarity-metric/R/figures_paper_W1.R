# =============================================================================
# Path α (W1-based) paper figures
# Author: Katrina Bennett
# Date: 2026-05-16
#
# Three main paper figures, rebuilt for the Path α (W1 raw / rho dimensionless)
# framework. Mirrors the structure / standards of figures_paper.R but uses
# W1-raw simulation results (results/w1_raw_simulation.rds) for fig2 and
# rho-axis labelling for fig3.
#
# Paper standards (feedback_figure_paper_standard.md, 2026-04-29):
#   width = 7"  (paper), base_size = 11, bg = white, greyscale palette
#   slides: _color suffix, #D52B1E theme
#
# Caption standards (feedback_caption_writing.md, 2026-04-29):
#   figure captions describe what is plotted, not results / interpretation
#
# Outputs (greyscale, paper):
#   figures/fig1_w1_definition.{pdf,png}
#   figures/fig2_simulation_results.{pdf,png}   (replaces v2 nABCD-based)
#   figures/fig3_gusto_r8_forest.{pdf,png}      (rho axis)
# Slides (color):
#   _color.{pdf,png} variants
# =============================================================================

suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
  library(tidyr)
  library(readr)
  library(patchwork)
})

# Auto-detect project root (handles source(), Rscript --file=, RStudio).
# Marker-based: walks up until we find projects/similarity-metric.
.find_project_root_W1 <- function() {
  cand <- NULL
  # 1. Via source frame (sourced via source()/file.path)
  for (f in rev(sys.frames())) {
    if (!is.null(f$ofile)) { cand <- dirname(dirname(normalizePath(f$ofile))); break }
  }
  # 2. Via Rscript --file=
  if (is.null(cand)) {
    args <- commandArgs(trailingOnly = FALSE)
    f_arg <- sub("^--file=", "", args[grepl("^--file=", args)])
    if (length(f_arg) > 0 && file.exists(f_arg)) {
      cand <- dirname(dirname(normalizePath(f_arg)))
    }
  }
  # 3. RStudio
  if (is.null(cand) && requireNamespace("rstudioapi", quietly = TRUE) &&
      rstudioapi::isAvailable()) {
    path <- tryCatch(rstudioapi::getActiveDocumentContext()$path,
                     error = function(e) "")
    if (nzchar(path)) cand <- dirname(dirname(normalizePath(path)))
  }
  # 4. Fallback: walk from getwd() searching for projects/similarity-metric
  if (is.null(cand)) {
    here <- normalizePath(getwd(), mustWork = FALSE)
    target <- file.path("projects", "similarity-metric")
    if (file.exists(file.path(here, target))) {
      cand <- normalizePath(file.path(here, target))
    } else {
      cand <- here
    }
  }
  cand
}
.project_root <- .find_project_root_W1()
DATA_DIR_W1   <- file.path(.project_root, "data")
GUSTO_CSV_W1  <- file.path(DATA_DIR_W1, "GUSTO", "gusto_r8_results.csv")
OUTPUT_DIR_W1 <- file.path(.project_root, "figures")

# Path α simulation results live at the REPO root (results/), not under
# projects/similarity-metric/. Resolve from project root:
.sim_repo_root <- function() {
  # .project_root = .../projects/similarity-metric  → up two = repo
  normalizePath(file.path(.project_root, "..", ".."), mustWork = FALSE)
}
W1_SIM_RDS    <- file.path(.sim_repo_root(), "results", "w1_raw_simulation.rds")
W1_TRUTH_RDS  <- file.path(.sim_repo_root(), "results", "w1_raw_truth.rds")

# Paper theme (consistent with figures_paper.R)
theme_set(theme_bw(base_size = 11) +
  theme(
    panel.grid.minor = element_blank(),
    strip.background = element_rect(fill = "grey95"),
    legend.position = "bottom",
    plot.tag = element_text(size = rel(0.95)),
    axis.title = element_text(size = rel(0.95)),
    axis.text = element_text(size = rel(0.85), color = "black"),
    legend.title = element_text(size = rel(0.85)),
    legend.text = element_text(size = rel(0.85)),
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = NA)
  ))

# =============================================================================
# Figure 1: W1 = area between CDFs (Path α framing)
# 2-panel (PDFs, CDFs). Shaded area between CDFs = W_1.
# Uses Gamma(shape=4, scale=10) vs Normal(55, 10^2) as in v2 (conceptual fig).
# =============================================================================

fig1_w1_definition <- function(palette = c("greyscale", "color")) {
  palette <- match.arg(palette)

  shape1 <- 4; scale1 <- 10        # Region 1: right-skewed Gamma
  mu2 <- 55;  sd2 <- 10            # Region 2: symmetric Normal

  x   <- seq(0, 100, length.out = 500)
  pdf1 <- dgamma(x, shape = shape1, scale = scale1)
  pdf2 <- dnorm(x,  mean  = mu2,    sd    = sd2)
  cdf1 <- pgamma(x, shape = shape1, scale = scale1)
  cdf2 <- pnorm(x,  mean  = mu2,    sd    = sd2)

  df        <- tibble(x = x, f1 = pdf1, f2 = pdf2, F1 = cdf1, F2 = cdf2)
  df_ribbon <- df %>% mutate(ymin = pmin(F1, F2), ymax = pmax(F1, F2))

  # W_1 annotation at widest CDF gap
  i_max  <- which.max(abs(df$F1 - df$F2))
  x_anno <- df$x[i_max]
  y_anno <- mean(c(df$F1[i_max], df$F2[i_max]))

  if (palette == "color") {
    line_vals <- c("Region 1" = "#D52B1E", "Region 2" = "#1E3A5F")
  } else {
    line_vals <- c("Region 1" = "black",   "Region 2" = "black")
  }

  legend_style <- theme(
    legend.background = element_rect(fill = "white", color = NA),
    legend.key.width  = unit(0.8, "lines"),
    legend.key.height = unit(0.8, "lines"),
    legend.margin     = margin(2, 4, 2, 4)
  )
  tag_style <- theme(
    plot.tag.position = c(0, 1.02),
    plot.margin       = margin(t = 14, r = 12, b = 5, l = 12)
  )

  p_pdf <- ggplot(df) +
    geom_line(aes(x = x, y = f1, linetype = "Region 1", color = "Region 1"),
              linewidth = 0.5) +
    geom_line(aes(x = x, y = f2, linetype = "Region 2", color = "Region 2"),
              linewidth = 0.5) +
    scale_linetype_manual(values = c("Region 1" = "solid",
                                       "Region 2" = "dashed")) +
    scale_color_manual(values = line_vals) +
    labs(x = "Effect Modifier Value", y = "Density",
         linetype = "Region", color = "Region", tag = "(A)") +
    legend_style + tag_style

  p_cdf <- ggplot(df) +
    geom_ribbon(data = df_ribbon, aes(x = x, ymin = ymin, ymax = ymax),
                fill = "grey60", alpha = 0.6) +
    geom_line(aes(x = x, y = F1, linetype = "Region 1", color = "Region 1"),
              linewidth = 0.5) +
    geom_line(aes(x = x, y = F2, linetype = "Region 2", color = "Region 2"),
              linewidth = 0.5) +
    scale_linetype_manual(values = c("Region 1" = "solid",
                                       "Region 2" = "dashed")) +
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
# Figure 2: Simulation operating characteristics — W1 raw
# 3-panel horizontal: (A) Bias, (B) Coverage, (C) Mean CI width
# X-axis: n per group {50, 100, 200}. Color/line: scenario S1-S7.
# Y-axis: W1 raw units (per scenario; common abstract unit since
# scenarios share an N(50, 10^2) baseline).
# =============================================================================

.load_w1_summary <- function() {
  if (!file.exists(W1_SIM_RDS)) {
    stop("W1 simulation RDS not found at: ", W1_SIM_RDS,
         "\nRun w1_raw_simulation.R first.")
  }
  sim <- readRDS(W1_SIM_RDS)
  df  <- sim$summary
  df$scenario <- factor(df$scenario,
                        levels = c("S1", "S2", "S3", "S4", "S5", "S6", "S7"))
  df
}

# 7-level Okabe-Ito-inspired palette (color) and monotone grey (greyscale)
.scenario_palette_W1 <- function(palette = c("greyscale", "color")) {
  palette <- match.arg(palette)
  if (palette == "color") {
    c("S1" = "#999999",
      "S2" = "#E69F00",
      "S3" = "#56B4E9",
      "S4" = "#009E73",
      "S5" = "#CC79A7",
      "S6" = "#D55E00",
      "S7" = "#0072B2")
  } else {
    # Monotone grey ramp (S1 lightest → S7 darkest)
    c("S1" = "#BFBFBF",
      "S2" = "#A6A6A6",
      "S3" = "#8C8C8C",
      "S4" = "#737373",
      "S5" = "#595959",
      "S6" = "#404040",
      "S7" = "#1A1A1A")
  }
}

fig2_w1_simulation <- function(palette = c("greyscale", "color")) {
  palette <- match.arg(palette)
  df  <- .load_w1_summary()
  pal <- .scenario_palette_W1(palette)

  base <- function(p) p +
    geom_line(linewidth = 0.5) +
    geom_point(size = 1.8) +
    scale_x_continuous(breaks = c(50, 100, 200)) +
    scale_color_manual(values = pal) +
    labs(x = "n per group", color = "Scenario")

  # Panel (A): Bias
  pA <- base(ggplot(df, aes(x = n, y = bias,
                            color = scenario, group = scenario))) +
    geom_hline(yintercept = 0, linetype = "dashed", color = "grey50") +
    labs(y = expression(Bias~"of"~widehat(W)[1]~"(units of "*W[1]*")"),
         subtitle = "(A) Bias")

  # Panel (B): Coverage (95% bootstrap CI)
  pB <- base(ggplot(df, aes(x = n, y = coverage_pct,
                            color = scenario, group = scenario))) +
    geom_hline(yintercept = 0.95, linetype = "dashed", color = "grey50") +
    scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.2)) +
    labs(y = "Coverage of 95% bootstrap CI",
         subtitle = "(B) Coverage")

  # Panel (C): Mean CI width
  pC <- base(ggplot(df, aes(x = n, y = mean_ci_width,
                            color = scenario, group = scenario))) +
    labs(y = expression(Mean~CI~width~"(units of "*W[1]*")"),
         subtitle = "(C) CI width")

  (pA + pB + pC) +
    plot_layout(guides = "collect") &
    theme(legend.position = "bottom",
          legend.box.margin = margin(t = -8),
          legend.margin     = margin(t = 0, b = 0))
}

# =============================================================================
# Figure 3: GUSTO-I Region 8 forest plot (rho axis)
# 2-panel: (A) age, (B) systolic blood pressure
# Partners ordered by ascending rho-hat within each panel.
# Axis label: rho-hat (dimensionless ratio = W1-hat / IQR-hat_pooled).
# =============================================================================

fig3_gusto_r8_forest_W1 <- function(palette = c("greyscale", "color")) {
  palette <- match.arg(palette)

  if (!file.exists(GUSTO_CSV_W1)) {
    stop("GUSTO results CSV not found: ", GUSTO_CSV_W1)
  }
  raw <- read_csv(GUSTO_CSV_W1, show_col_types = FALSE)

  forest_data <- raw %>%
    select(partner, n,
           nABCD_age,   ci_lower_age,   ci_upper_age,
           nABCD_sysbp, ci_lower_sysbp, ci_upper_sysbp) %>%
    pivot_longer(
      cols = -c(partner, n),
      names_to = c(".value", "variable"),
      names_pattern = "(nABCD|ci_lower|ci_upper)_(age|sysbp)"
    ) %>%
    rename(rho_hat = nABCD) %>%
    mutate(partner_label = paste0("R", partner))

  .panel <- function(data, var_name, var_title, panel_letter) {
    d <- data %>% filter(variable == var_name)
    ord <- d %>% arrange(rho_hat) %>% pull(partner_label)
    d$partner_label <- factor(d$partner_label, levels = rev(ord))

    if (palette == "color") {
      col_pt <- "#D52B1E"; col_ci <- "#D52B1E"
    } else {
      col_pt <- "#1A1A1A"; col_ci <- "#555555"
    }

    ggplot(d, aes(x = rho_hat, y = partner_label)) +
      geom_errorbarh(aes(xmin = ci_lower, xmax = ci_upper),
                     height = 0.3, linewidth = 0.4, color = col_ci) +
      geom_point(size = 2, color = col_pt) +
      scale_x_continuous(limits = c(0, NA),
                         labels = function(x) sprintf("%.2f", x)) +
      labs(
        x = expression(hat(rho) == widehat(W)[1] / widehat(IQR)[pooled]),
        y = "Partner region",
        title = sprintf("(%s) %s", panel_letter, var_title)
      ) +
      theme(
        legend.position  = "none",
        plot.title       = element_text(size = rel(0.9), hjust = 0),
        axis.text.y      = element_text(size = rel(0.85), color = "black",
                                        hjust = 0)
      )
  }

  pA <- .panel(forest_data, "age",   "Age",
               "A")
  pB <- .panel(forest_data, "sysbp", "Systolic blood pressure",
               "B")
  pA + pB
}

# =============================================================================
# Generate all three paper figures (greyscale paper + color slides)
# =============================================================================

generate_paper_figures_W1 <- function(output_dir = OUTPUT_DIR_W1) {
  dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)
  message("[W1 figures] project root: ", .project_root)
  message("[W1 figures] output       : ", output_dir)

  # --- Fig 1: W1 definition (replaces fig1_nabcd_definition) ----------------
  # Width 7" x 3" (preserves v2 dimensions; mathematics is the same)
  for (pal in c("greyscale", "color")) {
    suffix <- if (pal == "color") "_color" else ""
    p      <- fig1_w1_definition(pal)
    ggsave(file.path(output_dir, paste0("fig1_w1_definition", suffix, ".pdf")),
           p, width = 7, height = 3, bg = "white")
    ggsave(file.path(output_dir, paste0("fig1_w1_definition", suffix, ".png")),
           p, width = 7, height = 3, dpi = 300, bg = "white")
  }
  message("  fig1_w1_definition: done")

  # --- Fig 2: simulation results (W1 raw) -----------------------------------
  # Width 7" x 3.5" (consistent with v2 fig2_simulation_results, 3-panel horiz)
  # Replaces v2 fig2_simulation_results.pdf in-place.
  for (pal in c("greyscale", "color")) {
    suffix <- if (pal == "color") "_color" else ""
    p      <- fig2_w1_simulation(pal)
    ggsave(file.path(output_dir, paste0("fig2_simulation_results", suffix, ".pdf")),
           p, width = 10, height = 3.5, bg = "white")
    ggsave(file.path(output_dir, paste0("fig2_simulation_results", suffix, ".png")),
           p, width = 10, height = 3.5, dpi = 300, bg = "white")
  }
  message("  fig2_simulation_results: done")

  # --- Fig 3: GUSTO-I R8 forest (rho axis) ----------------------------------
  for (pal in c("greyscale", "color")) {
    suffix <- if (pal == "color") "_color" else ""
    p      <- fig3_gusto_r8_forest_W1(pal)
    ggsave(file.path(output_dir, paste0("fig3_gusto_r8_forest", suffix, ".pdf")),
           p, width = 7, height = 3.5, bg = "white")
    ggsave(file.path(output_dir, paste0("fig3_gusto_r8_forest", suffix, ".png")),
           p, width = 7, height = 3.5, dpi = 300, bg = "white")
  }
  message("  fig3_gusto_r8_forest: done")

  message("[W1 figures] all three figures regenerated.")
}

# Allow direct script invocation
if (sys.nframe() == 0L) {
  generate_paper_figures_W1()
}
