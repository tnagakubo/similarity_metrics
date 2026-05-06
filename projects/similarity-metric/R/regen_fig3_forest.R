library(ggplot2)
library(dplyr)
library(tidyr)
library(readr)
library(patchwork)

repo <- normalizePath(".")
csv_path <- file.path(repo, "projects/similarity-metric/data/GUSTO/gusto_r8_results.csv")
fig_dir  <- file.path(repo, "projects/similarity-metric/figures")

raw <- read_csv(csv_path, show_col_types = FALSE)

# Pivot wide to long — one row per (partner, variable)
forest_data <- raw %>%
  select(partner, n, nABCD_age, ci_lower_age, ci_upper_age,
                       nABCD_sysbp, ci_lower_sysbp, ci_upper_sysbp) %>%
  pivot_longer(
    cols = -c(partner, n),
    names_to = c(".value", "variable"),
    names_pattern = "(nABCD|ci_lower|ci_upper)_(age|sysbp)"
  ) %>%
  mutate(partner_label = paste0("R", partner))

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
    scale_x_continuous(limits = c(0, NA),
                       labels = function(x) sprintf("%.2f", x)) +
    labs(
      x = "nABCD",
      y = "Partner region",
      title = sprintf("(%s) %s", panel_letter, var_title)
    ) +
    theme_minimal(base_size = 11) +
    theme(
      legend.position = "none",
      panel.grid.minor = element_blank(),
      plot.title       = element_text(size = rel(0.9), hjust = 0),
      axis.title       = element_text(size = rel(0.9)),
      axis.text        = element_text(size = rel(0.8), color = "black"),
      axis.text.y      = element_text(size = rel(0.8), color = "black", hjust = 0),
      legend.text      = element_text(size = rel(0.8)),
      plot.background  = element_rect(fill = "white", color = NA),
      panel.background = element_rect(fill = "white", color = NA)
    )
}

build_forest <- function(palette = c("greyscale", "color")) {
  palette <- match.arg(palette)
  pA <- .build_forest_panel(forest_data, "age",   "Age",         "A", palette)
  pB <- .build_forest_panel(forest_data, "sysbp", "Systolic blood pressure", "B", palette)
  pA + pB
}

ggsave(file.path(fig_dir, "fig3_gusto_r8_forest.pdf"),       build_forest("greyscale"),
       width = 7, height = 3.5, device = cairo_pdf, bg = "white")
ggsave(file.path(fig_dir, "fig3_gusto_r8_forest.png"),       build_forest("greyscale"),
       width = 7, height = 3.5, dpi = 300, bg = "white")
ggsave(file.path(fig_dir, "fig3_gusto_r8_forest_color.pdf"), build_forest("color"),
       width = 7, height = 3.5, device = cairo_pdf, bg = "white")
ggsave(file.path(fig_dir, "fig3_gusto_r8_forest_color.png"), build_forest("color"),
       width = 7, height = 3.5, dpi = 300, bg = "white")

cat("fig3 forest regenerated (greyscale + color)\n")
