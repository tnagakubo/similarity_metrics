## Regenerate fig5_gusto_r8_scatter from cached CSV (no bootstrap re-run)
## Paper standard: source width = 5 in (square), displayed at 0.71*textwidth.
## White background, base_size = 11.
## Option (d): same color, no triangle, equal scale, geom_text_repel labels.
## Greyscale (paper) + color (slides) dual palette.

library(ggplot2)
library(dplyr)
library(ggrepel)

base_dir <- "C:/Users/hrd13/Documents/Gak/0 Study/800Claude/20260210_SIM/similarity_metrics/projects/similarity-metric"
fig_dir  <- file.path(base_dir, "figures")
data_dir <- file.path(base_dir, "data/GUSTO")

res_wide <- read.csv(file.path(data_dir, "gusto_r8_results.csv"))
scatter_data <- res_wide %>% mutate(partner_label = paste0("R", partner))

build_scatter <- function(palette = c("greyscale", "color")) {
  palette <- match.arg(palette)
  col_pt <- if (palette == "color") "#D52B1E" else "#1A1A1A"

  ggplot(scatter_data, aes(x = nABCD_age, y = nABCD_sysbp)) +
    geom_point(size = 2.6, color = col_pt) +
    geom_text_repel(aes(label = partner_label), size = 3, color = col_pt,
                    box.padding = 0.35, point.padding = 0.3,
                    segment.color = "#888888", segment.size = 0.3,
                    max.overlaps = Inf, seed = 1) +
    coord_fixed(xlim = c(0, 0.12), ylim = c(0, 0.12)) +
    labs(x = "nABCD (Age)", y = "nABCD (Systolic BP)", title = NULL) +
    theme_minimal(base_size = 11) +
    theme(
      panel.grid.minor = element_blank(),
      plot.background  = element_rect(fill = "white", color = NA),
      panel.background = element_rect(fill = "white", color = NA)
    )
}

ggsave(file.path(fig_dir, "fig5_gusto_r8_scatter.pdf"),       build_scatter("greyscale"),
       width = 5, height = 5, device = cairo_pdf, bg = "white")
ggsave(file.path(fig_dir, "fig5_gusto_r8_scatter.png"),       build_scatter("greyscale"),
       width = 5, height = 5, dpi = 300, bg = "white")
ggsave(file.path(fig_dir, "fig5_gusto_r8_scatter_color.pdf"), build_scatter("color"),
       width = 5, height = 5, device = cairo_pdf, bg = "white")
ggsave(file.path(fig_dir, "fig5_gusto_r8_scatter_color.png"), build_scatter("color"),
       width = 5, height = 5, dpi = 300, bg = "white")
cat("fig5_gusto_r8_scatter (greyscale + color, 5x5 in, white bg) regenerated.\n")
