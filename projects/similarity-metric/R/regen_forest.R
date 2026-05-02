## Regenerate fig4_gusto_r8_forest from cached CSV (no bootstrap re-run)
## Paper standard: width = 7 in, white background, base_size = 11.
## Implements Option A: each panel independently sorted, (A)/(B) titles,
## greyscale (paper) + color (slides) dual palette.

library(ggplot2)
library(dplyr)
library(tidyr)
library(patchwork)

base_dir <- "C:/Users/hrd13/Documents/Gak/0 Study/800Claude/20260210_SIM/similarity_metrics/projects/similarity-metric"
fig_dir  <- file.path(base_dir, "figures")
data_dir <- file.path(base_dir, "data/GUSTO")

res_wide <- read.csv(file.path(data_dir, "gusto_r8_results.csv"))

results <- bind_rows(
  res_wide %>% transmute(variable = "age",   partner = partner,
                         nABCD = nABCD_age,   ci_lower = ci_lower_age,   ci_upper = ci_upper_age),
  res_wide %>% transmute(variable = "sysbp", partner = partner,
                         nABCD = nABCD_sysbp, ci_lower = ci_lower_sysbp, ci_upper = ci_upper_sysbp)
)

forest_data <- results %>% mutate(partner_label = paste0("R", partner))

.build_forest_panel <- function(data, var_name, var_title, panel_letter, palette) {
  d <- data %>% filter(variable == var_name)
  ord <- d %>% arrange(nABCD) %>% pull(partner_label)
  d$partner_label <- factor(d$partner_label, levels = rev(ord))

  if (palette == "color") {
    col_pt <- "#D52B1E"; col_ci <- "#D52B1E"
  } else {
    col_pt <- "#1A1A1A"; col_ci <- "#555555"
  }

  ggplot(d, aes(x = nABCD, y = partner_label)) +
    geom_errorbarh(aes(xmin = ci_lower, xmax = ci_upper),
                   height = 0.3, linewidth = 0.4, color = col_ci) +
    geom_point(size = 2, color = col_pt) +
    labs(
      x = "nABCD  (95% percentile bootstrap CI)",
      y = sprintf("Partner region (ordered by ascending %s nABCD)",
                  ifelse(var_name == "age", "age", "SBP")),
      title = sprintf("(%s) %s", panel_letter, var_title)
    ) +
    theme_minimal(base_size = 11) +
    theme(
      legend.position  = "none",
      panel.grid.minor = element_blank(),
      plot.title       = element_text(face = "bold", size = 12, hjust = 0),
      axis.text.y      = element_text(hjust = 0),
      plot.background  = element_rect(fill = "white", color = NA),
      panel.background = element_rect(fill = "white", color = NA)
    )
}

build_forest <- function(palette = c("greyscale", "color")) {
  palette <- match.arg(palette)
  pA <- .build_forest_panel(forest_data, "age",   "Age",         "A", palette)
  pB <- .build_forest_panel(forest_data, "sysbp", "Systolic BP", "B", palette)
  pA + pB
}

ggsave(file.path(fig_dir, "fig4_gusto_r8_forest.pdf"),       build_forest("greyscale"),
       width = 7, height = 3.5, device = cairo_pdf, bg = "white")
ggsave(file.path(fig_dir, "fig4_gusto_r8_forest.png"),       build_forest("greyscale"),
       width = 7, height = 3.5, dpi = 300, bg = "white")
ggsave(file.path(fig_dir, "fig4_gusto_r8_forest_color.pdf"), build_forest("color"),
       width = 7, height = 3.5, device = cairo_pdf, bg = "white")
ggsave(file.path(fig_dir, "fig4_gusto_r8_forest_color.png"), build_forest("color"),
       width = 7, height = 3.5, dpi = 300, bg = "white")
cat("fig4_gusto_r8_forest (greyscale + color, 7x3.5 in, white bg) regenerated.\n")
