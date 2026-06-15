# =============================================================================
# Figure 2 (W1 raw): grouped bar chart redesign
# Author: Katrina Bennett
# Date: 2026-05-17
#
# Redesigns fig2_simulation_results from a (x = n, color = scenario) line plot
# into a grouped bar chart with:
#   x-axis = scenario (S1, S2, ..., S7)
#   fill   = sample size (n=50, n=100, n=200)
#
# Color scheme: matches the v2 nABCD sample-size palette from figures_paper.R
# (`.sample_size_palette`):
#   greyscale: n=50  #999999 (light)  → n=100 #555555 → n=200 #1A1A1A (dark)
#   color    : n=50  #F4A39B (pale)   → n=100 #D52B1E → n=200 #8B0000 (deep red)
# This monotone-luminance ramp keeps grayscale order intact and uses the
# `#D52B1E` slide theme red as the mid anchor.
#
# Paper standard (feedback_figure_paper_standard.md, 2026-04-29):
#   width = 10"  (textwidth-spanning, matches v2 fig2_simulation_results)
#   height = 3.5", base_size = 11, bg = white
#   3 horizontal panels: (A) Bias, (B) Coverage, (C) Mean CI width
#
# Output filenames (preserved from v2; per_em_W1_wiley.tex references these):
#   figures/fig2_simulation_results.{pdf,png}        — paper, greyscale
#   figures/fig2_simulation_results_color.{pdf,png}  — slides, color
# =============================================================================

suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
  library(tidyr)
  library(readr)
  library(patchwork)
})

# Reuse project-root resolution from figures_paper_W1.R
.find_project_root_fig2 <- function() {
  cand <- NULL
  for (f in rev(sys.frames())) {
    if (!is.null(f$ofile)) { cand <- dirname(dirname(normalizePath(f$ofile))); break }
  }
  if (is.null(cand)) {
    args  <- commandArgs(trailingOnly = FALSE)
    f_arg <- sub("^--file=", "", args[grepl("^--file=", args)])
    if (length(f_arg) > 0 && file.exists(f_arg)) {
      cand <- dirname(dirname(normalizePath(f_arg)))
    }
  }
  if (is.null(cand) && requireNamespace("rstudioapi", quietly = TRUE) &&
      rstudioapi::isAvailable()) {
    path <- tryCatch(rstudioapi::getActiveDocumentContext()$path,
                     error = function(e) "")
    if (nzchar(path)) cand <- dirname(dirname(normalizePath(path)))
  }
  if (is.null(cand)) {
    here   <- normalizePath(getwd(), mustWork = FALSE)
    target <- file.path("projects", "similarity-metric")
    if (file.exists(file.path(here, target))) {
      cand <- normalizePath(file.path(here, target))
    } else {
      cand <- here
    }
  }
  cand
}
.project_root_fig2 <- .find_project_root_fig2()
OUTPUT_DIR_FIG2    <- file.path(.project_root_fig2, "figures")
W1_SIM_RDS_FIG2    <- normalizePath(
  file.path(.project_root_fig2, "..", "..", "results", "w1_raw_simulation.rds"),
  mustWork = FALSE
)

# Paper theme (matches figures_paper_W1.R / figures_paper.R)
theme_set(theme_bw(base_size = 11) +
  theme(
    panel.grid.minor  = element_blank(),
    strip.background  = element_rect(fill = "grey95"),
    legend.position   = "bottom",
    plot.tag          = element_text(size = rel(0.95)),
    axis.title        = element_text(size = rel(0.95)),
    axis.text         = element_text(size = rel(0.85), color = "black"),
    legend.title      = element_text(size = rel(0.85)),
    legend.text       = element_text(size = rel(0.85)),
    plot.background   = element_rect(fill = "white", color = NA),
    panel.background  = element_rect(fill = "white", color = NA)
  ))

# Sample-size palette: identical to v2 figures_paper.R `.sample_size_palette`
.sample_size_palette_fig2 <- function(palette = c("greyscale", "color")) {
  palette <- match.arg(palette)
  if (palette == "color") {
    c("n=50" = "#F4A39B", "n=100" = "#D52B1E", "n=200" = "#8B0000")
  } else {
    c("n=50" = "#999999", "n=100" = "#555555", "n=200" = "#1A1A1A")
  }
}

.load_w1_summary_fig2 <- function() {
  if (!file.exists(W1_SIM_RDS_FIG2)) {
    stop("W1 simulation RDS not found at: ", W1_SIM_RDS_FIG2,
         "\nRun w1_raw_simulation.R first.")
  }
  sim <- readRDS(W1_SIM_RDS_FIG2)
  df  <- sim$summary
  df$scenario <- factor(df$scenario,
                        levels = c("S1", "S2", "S3", "S4", "S5", "S6", "S7"))
  df$n_label  <- factor(paste0("n=", df$n),
                        levels = c("n=50", "n=100", "n=200"))
  df
}

# -----------------------------------------------------------------------------
# Combined 3-panel figure: (A) Bias, (B) Coverage, (C) Mean CI width
# -----------------------------------------------------------------------------
fig2_w1_simulation_bars <- function(palette = c("greyscale", "color")) {
  palette <- match.arg(palette)
  df  <- .load_w1_summary_fig2()
  pal <- .sample_size_palette_fig2(palette)

  # Common bar geometry: grouped bars by sample size, side-by-side per scenario
  bar_geom <- function() {
    list(
      geom_col(position = position_dodge(width = 0.8), width = 0.7),
      scale_fill_manual(values = pal),
      labs(x = "Scenario", fill = "Sample size")
    )
  }

  # Panel (A): Bias of W1-hat
  pA <- ggplot(df, aes(x = scenario, y = bias, fill = n_label)) +
    bar_geom() +
    geom_hline(yintercept = 0, linetype = "dashed", color = "grey50") +
    labs(y = expression(Bias~"of"~widehat(W)[1]~"(units of "*W[1]*")"),
         subtitle = "(A) Bias")

  # Panel (B): Coverage of 95% percentile bootstrap CI
  pB <- ggplot(df, aes(x = scenario, y = coverage_pct, fill = n_label)) +
    bar_geom() +
    geom_hline(yintercept = 0.95, linetype = "dashed", color = "grey50") +
    scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.2)) +
    labs(y = "Coverage of 95% bootstrap CI",
         subtitle = "(B) Coverage")

  # Panel (C): Mean CI width
  pC <- ggplot(df, aes(x = scenario, y = mean_ci_width, fill = n_label)) +
    bar_geom() +
    labs(y = expression(Mean~CI~width~"(units of "*W[1]*")"),
         subtitle = "(C) CI width")

  (pA + pB + pC) +
    plot_layout(guides = "collect") &
    theme(legend.position    = "bottom",
          legend.box.margin  = margin(t = -8),
          legend.margin      = margin(t = 0, b = 0))
}

# -----------------------------------------------------------------------------
# Driver: write greyscale + color variants at v2 dimensions (10" x 3.5")
# -----------------------------------------------------------------------------
generate_fig2_bars <- function(output_dir = OUTPUT_DIR_FIG2) {
  dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)
  message("[fig2 bars] project root: ", .project_root_fig2)
  message("[fig2 bars] input RDS   : ", W1_SIM_RDS_FIG2)
  message("[fig2 bars] output dir  : ", output_dir)

  for (pal in c("greyscale", "color")) {
    suffix <- if (pal == "color") "_color" else ""
    p      <- fig2_w1_simulation_bars(pal)
    ggsave(file.path(output_dir,
                     paste0("fig2_simulation_results", suffix, ".pdf")),
           p, width = 10, height = 3.5, bg = "white")
    ggsave(file.path(output_dir,
                     paste0("fig2_simulation_results", suffix, ".png")),
           p, width = 10, height = 3.5, dpi = 300, bg = "white")
  }
  message("[fig2 bars] fig2_simulation_results{,_color}.{pdf,png}: done")
}

# Allow direct script invocation
if (sys.nframe() == 0L) {
  generate_fig2_bars()
}
