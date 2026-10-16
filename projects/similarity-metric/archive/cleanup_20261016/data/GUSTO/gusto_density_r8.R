##############################################################################
## GUSTO-I Application: Region 8 Anchor - Density Distribution Figures
##
## Purpose
## -------
## Visualize the empirical distribution of age and systolic BP for Region 8
## (anchor) against two curated partner sets:
##   * "Similar partners"   : R4, R6, R13   (joint-low nABCD on both EMs)
##   * "Dissimilar partners": R2, R3, R9    (high nABCD on >=1 EM)
##
## Figures are *descriptive companions* to the nABCD + bootstrap + L* pipeline
## in gusto_application_r8.R. Nothing in that pipeline is re-computed here.
##
## Design
## ------
##   * Okabe-Ito palette (CVD-safe). Anchor (R8) reserved to Vermillion
##     (#D55E00) and drawn with thicker line (1.3) across both figures.
##     Partners use blue / sky-blue / bluish-green at regular thickness
##     (0.7) with alpha 0.85.
##   * Panels laid out side-by-side via patchwork: (a) Age, (b) Systolic BP.
##   * theme_bw base_size 11 to match the existing forest/calibration figs.
##
## Output
## ------
##   figures/fig_gusto_r8_density_similar.{png,pdf}
##   figures/fig_gusto_r8_density_dissimilar.{png,pdf}
##############################################################################

library(predtools)
library(ggplot2)
library(dplyr)
library(patchwork)

set.seed(2026)  # density estimation is deterministic; seed kept for parity

# --- Paths (identical to gusto_application_r8.R) ---
base_dir <- "C:/Users/hrd13/Documents/Gak/0 Study/800Claude/20260210_SIM/similarity_metrics/projects/similarity-metric"
fig_dir  <- file.path(base_dir, "figures")
dir.create(fig_dir, showWarnings = FALSE, recursive = TRUE)

# --- Load data (same source as the main R8 pipeline) ---
data(gusto)
cat("GUSTO-I: N =", nrow(gusto), "\n")

anchor <- 8

# --- Okabe-Ito palette references ---
# Anchor (R8) is reserved for Vermillion across BOTH figures; partners use
# blue / sky-blue / bluish-green, ordered by region number.
COL_ANCHOR    <- "#D55E00"  # Okabe-Ito Vermillion
COL_PARTNER_1 <- "#0072B2"  # Okabe-Ito Blue
COL_PARTNER_2 <- "#56B4E9"  # Okabe-Ito Sky blue
COL_PARTNER_3 <- "#009E73"  # Okabe-Ito Bluish green

ANCHOR_SIZE  <- 1.3
PARTNER_SIZE <- 0.7
PARTNER_ALPHA <- 0.85

# ---------------------------------------------------------------------------
# Helper: build the density data frame (anchor + partners) for one variable
# ---------------------------------------------------------------------------
build_density_df <- function(var, partners) {
  regions_keep <- c(anchor, partners)
  df <- gusto %>%
    filter(regl %in% regions_keep) %>%
    transmute(
      value = .data[[var]],
      region = regl
    ) %>%
    mutate(
      region_label = paste0("R", region),
      is_anchor    = (region == anchor)
    )
  # Order factor: anchor first in the legend, then partners ascending
  lvl <- c(paste0("R", anchor), paste0("R", sort(partners)))
  df$region_label <- factor(df$region_label, levels = lvl)
  df
}

# ---------------------------------------------------------------------------
# Helper: single density panel
# ---------------------------------------------------------------------------
density_panel <- function(df, xlab, subtitle, color_map, size_map) {
  ggplot(df, aes(x = value, color = region_label,
                 linewidth = region_label)) +
    # Partner densities first (alpha 0.85), anchor drawn last on top.
    geom_density(data = df %>% filter(!is_anchor),
                 fill = NA, alpha = PARTNER_ALPHA) +
    geom_density(data = df %>% filter(is_anchor),
                 fill = NA, alpha = 1) +
    scale_color_manual(values = color_map, name = NULL) +
    scale_linewidth_manual(values = size_map, guide = "none") +
    labs(x = xlab, y = "Density", subtitle = subtitle) +
    theme_bw(base_size = 11) +
    theme(
      panel.grid.minor  = element_blank(),
      strip.background  = element_rect(fill = "grey95", color = NA),
      legend.position   = "bottom"
    )
}

# ---------------------------------------------------------------------------
# Main plotting driver: two-panel figure (age | sysbp) for a given partner set
# ---------------------------------------------------------------------------
plot_density <- function(partners, outfile_png, outfile_pdf, fig_title) {
  stopifnot(length(partners) == 3)
  partners_sorted <- sort(partners)

  # Color map: anchor -> vermillion; partners -> blue / sky / bluish-green
  color_map <- c(
    setNames(COL_ANCHOR,    paste0("R", anchor)),
    setNames(c(COL_PARTNER_1, COL_PARTNER_2, COL_PARTNER_3),
             paste0("R", partners_sorted))
  )
  size_map <- c(
    setNames(ANCHOR_SIZE,  paste0("R", anchor)),
    setNames(rep(PARTNER_SIZE, 3), paste0("R", partners_sorted))
  )

  df_age <- build_density_df("age",   partners_sorted)
  df_sbp <- build_density_df("sysbp", partners_sorted)

  p_age <- density_panel(df_age,
                         xlab     = "Age (years)",
                         subtitle = "(a) Age",
                         color_map = color_map,
                         size_map  = size_map)

  p_sbp <- density_panel(df_sbp,
                         xlab     = "Systolic BP (mmHg)",
                         subtitle = "(b) Systolic BP",
                         color_map = color_map,
                         size_map  = size_map)

  # Share one legend at the bottom via patchwork
  p_combined <- (p_age | p_sbp) +
    plot_layout(guides = "collect") +
    plot_annotation(
      title = fig_title,
      theme = theme(
        plot.title    = element_text(size = 12, face = "bold"),
        legend.position = "bottom"
      )
    ) &
    theme(legend.position = "bottom")

  ggsave(outfile_pdf, p_combined,
         width = 9, height = 4.5, device = cairo_pdf)
  ggsave(outfile_png, p_combined,
         width = 9, height = 4.5, dpi = 300)
  cat("Saved:", outfile_png, "\n")
  cat("Saved:", outfile_pdf, "\n")
}

# ---------------------------------------------------------------------------
# Figure A: Similar partners (R4, R6, R13) -- joint-low nABCD leaders
# ---------------------------------------------------------------------------
plot_density(
  partners     = c(4, 6, 13),
  outfile_png  = file.path(fig_dir, "fig_gusto_r8_density_similar.png"),
  outfile_pdf  = file.path(fig_dir, "fig_gusto_r8_density_similar.pdf"),
  fig_title    = "Region 8 vs. similar partners (age and SBP distributions)"
)

# ---------------------------------------------------------------------------
# Figure B: Dissimilar partners
#   R2 -- high age nABCD, low SBP
#   R3 -- joint high (largest age nABCD)
#   R9 -- largest SBP nABCD, low age
# ---------------------------------------------------------------------------
plot_density(
  partners     = c(2, 3, 9),
  outfile_png  = file.path(fig_dir, "fig_gusto_r8_density_dissimilar.png"),
  outfile_pdf  = file.path(fig_dir, "fig_gusto_r8_density_dissimilar.pdf"),
  fig_title    = "Region 8 vs. dissimilar partners (age and SBP distributions)"
)

cat("\nDone.\n")
