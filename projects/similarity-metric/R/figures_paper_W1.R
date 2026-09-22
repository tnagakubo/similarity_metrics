# =============================================================================
# Path α (W1-based) paper figures
# Author: Katrina Bennett
# Date: 2026-05-16
#
# Paper figures rebuilt for the Path α (W1 raw / rho dimensionless) framework.
# Mirrors the structure / standards of figures_paper.R.
#
# 2026-09-21 (Tak's decision): figure 2 is NO LONGER produced here. The single
# source of truth for fig2_simulation_results{,_color}.{pdf,png} is
#   R/fig2_bar_chart.R  ->  generate_fig2_bars()
# which reads the canonical Study 1 summary
#   projects/similarity-metric/results/w1_raw_summary.csv  (2026-05-17 run,
#   exact-quadrature S6/S7 truth; see results/STUDY1_PROVENANCE.md).
# The fig2 block that used to live here read the superseded repo-root
# results/w1_raw_simulation.rds ($summary = Monte-Carlo truth), now archived at
# archives/results_root_20260516/, and silently overwrote the canonical output.
# This script therefore reads nothing from any results/ tree.
#
# Paper standards (feedback_figure_paper_standard.md, 2026-04-29):
#   width = 7"  (paper), base_size = 11, bg = white, greyscale palette
#   slides: _color suffix, #D52B1E theme
#
# Caption standards (feedback_caption_writing.md, 2026-04-29):
#   figure captions describe what is plotted, not results / interpretation
#
# 2026-09-22 (Tak's decision): figure 3 is NO LONGER produced here either. The
# single source of truth for fig3_gusto_r8_forest{,_color}.{pdf,png} is
#   R/fig3_w1_axis.R
# which plots the raw Wasserstein-1 axis \widehat{W}_1 in the original variable
# units (years / mmHg), as required by Tak (2026-05-17) and referenced by the
# manuscript. The fig3 block that used to live here plotted the dimensionless
# ratio rho-hat = W1-hat / IQR-hat_pooled and wrote the same filenames, so any
# re-run of this script silently replaced the raw-axis figure with the rho-axis
# one. It has been removed.
#
# This script therefore owns figure 1 only.
#
# Outputs (greyscale, paper):
#   figures/fig1_w1_definition.{pdf,png}
# Slides (color):
#   figures/fig1_w1_definition_color.{pdf,png}
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
OUTPUT_DIR_W1 <- file.path(.project_root, "figures")

# No simulation-results input is read here. The Study 1 simulation output is
# consumed only by R/fig2_bar_chart.R (fig2) and R/study1_summary_exact.R
# (tables), both of which resolve it under projects/similarity-metric/results/.

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
# Figure 2: NOT generated here (2026-09-21, Tak's decision)
#
# fig2_simulation_results{,_color}.{pdf,png} is produced exclusively by
#   R/fig2_bar_chart.R  ->  generate_fig2_bars()
# (grouped bar chart, 10" x 3.5", reading the canonical Study 1 summary
#  projects/similarity-metric/results/w1_raw_summary.csv).
#
# The former line-plot generator (fig2_w1_simulation / .load_w1_summary /
# .scenario_palette_W1) read the superseded repo-root results/ rds and wrote
# the same filenames, so any re-run of this script silently replaced the
# canonical figure. It has been removed; see git history and
# projects/similarity-metric/archive/figure_rebuild_notes.md for the record.
# =============================================================================

# =============================================================================
# Figure 3: NOT generated here (2026-09-22, Tak's decision)
#
# fig3_gusto_r8_forest{,_color}.{pdf,png} is produced exclusively by
#   R/fig3_w1_axis.R
# (2-panel GUSTO-I Region 8 forest plot on the raw \widehat{W}_1 axis: years for
#  age, mmHg for systolic blood pressure; percentile bootstrap CIs recomputed on
#  the W1 scale from GUSTO-I IPD, B = 2000, set.seed(2026)).
#
# The former generator here (fig3_gusto_r8_forest_W1, plus the fig3-only path
# helpers DATA_DIR_W1 / GUSTO_CSV_W1) read data/GUSTO/gusto_r8_results.csv and
# plotted the dimensionless ratio rho-hat = W1-hat / IQR-hat_pooled on the same
# filenames, so re-running this script replaced the raw-axis figure referenced by
# the manuscript. It has been removed; see git history and
# projects/similarity-metric/archive/figure_rebuild_notes.md for the record.
# =============================================================================

# =============================================================================
# Generate the paper figure owned by this script: fig1 only
# (greyscale paper + color slides). Fig 2 lives in R/fig2_bar_chart.R,
# fig 3 in R/fig3_w1_axis.R.
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

  # --- Fig 2: intentionally NOT written here --------------------------------
  # fig2_simulation_results{,_color}.{pdf,png} belongs to R/fig2_bar_chart.R
  # (generate_fig2_bars(), canonical CSV input). Do not re-add a fig2 writer to
  # this script: it would overwrite the canonical figure with different data.

  # --- Fig 3: intentionally NOT written here --------------------------------
  # fig3_gusto_r8_forest{,_color}.{pdf,png} belongs to R/fig3_w1_axis.R (raw
  # W1 axis). Do not re-add a fig3 writer to this script: it would overwrite the
  # raw-axis figure with the rho-axis version.

  message("[W1 figures] fig1 regenerated only ",
          "(fig2: see R/fig2_bar_chart.R; fig3: see R/fig3_w1_axis.R).")
}

# Allow direct script invocation
if (sys.nframe() == 0L) {
  generate_paper_figures_W1()
}
