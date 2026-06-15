# =============================================================================
# Figure 3 (W1 raw-axis variant) — GUSTO-I Region 8 forest plot
# Author: Katrina Bennett
# Date: 2026-05-17
#
# Path α requirement (Tak, 2026-05-17): rebuild fig3 so the x-axis is the raw
# Wasserstein-1 distance \widehat{W}_1 in the original variable units
# (years for age, mmHg for SBP), not the dimensionless ratio ρ̂ = W1 / IQR.
#
# - Per-pair Ŵ₁ is recomputed directly from GUSTO-I IPD (anchor = Region 8).
# - 95% percentile bootstrap CIs are recomputed on the W₁ scale (B = 2,000).
# - Two panels (A) Age, (B) Systolic blood pressure; partners ordered by
#   ascending Ŵ₁ within each panel (per-panel ordering preserved from v2).
# - Filenames preserved: fig3_gusto_r8_forest.{pdf,png} + _color variants.
# - Paper standards (feedback_figure_paper_standard.md): width = 7",
#   base_size = 11, white background, greyscale (paper) + #D52B1E (slides).
# =============================================================================

suppressPackageStartupMessages({
  library(predtools)
  library(ggplot2)
  library(dplyr)
  library(tidyr)
  library(readr)
  library(patchwork)
})

set.seed(2026)

# --- Paths ---
base_dir <- "C:/Users/hrd13/Documents/Gak/0 Study/800Claude/20260210_SIM/similarity_metrics/projects/similarity-metric"
fig_dir  <- file.path(base_dir, "figures")
data_dir <- file.path(base_dir, "data", "GUSTO")
results_dir <- file.path(base_dir, "results")
dir.create(fig_dir,     showWarnings = FALSE, recursive = TRUE)
dir.create(results_dir, showWarnings = FALSE, recursive = TRUE)

# --- Core functions (W₁ on the raw scale) ---
compute_w1 <- function(x, y) {
  # Continuous-friendly W1: integral of |F_x - F_y| over the support.
  # Riemann-sum form using ECDF midpoints between sorted distinct atoms
  # (identical to compute_w1 in gusto_application_r8.R).
  all_vals <- sort(c(x, y))
  n <- length(all_vals)
  if (n < 2) return(0)
  Fx <- ecdf(x); Fy <- ecdf(y)
  mids  <- (all_vals[-n] + all_vals[-1]) / 2
  diffs <- diff(all_vals)
  sum(abs(Fx(mids) - Fy(mids)) * diffs)
}

w1_bootstrap_ci <- function(x, y, B = 2000, conf = 0.95) {
  n1 <- length(x); n2 <- length(y)
  est <- compute_w1(x, y)
  boot_vals <- numeric(B)
  for (b in seq_len(B)) {
    xb <- sample(x, n1, replace = TRUE)
    yb <- sample(y, n2, replace = TRUE)
    boot_vals[b] <- compute_w1(xb, yb)
  }
  alpha <- 1 - conf
  ci <- quantile(boot_vals, c(alpha / 2, 1 - alpha / 2), names = FALSE)
  ci[1] <- max(0, ci[1])
  list(estimate = est, lower = ci[1], upper = ci[2], se = sd(boot_vals))
}

# --- Load GUSTO-I IPD ---
data(gusto)
cat("GUSTO-I: N =", nrow(gusto), "\n")
cat("Regions:", paste(sort(unique(gusto$regl)), collapse = ", "), "\n")

anchor   <- 8
regions  <- sort(unique(gusto$regl))
partners <- setdiff(regions, anchor)
cat("Anchor: Region", anchor, "(n =", sum(gusto$regl == anchor), ")\n")
cat("Partners:", length(partners), "regions\n\n")

# --- Compute Ŵ₁ + bootstrap CI per partner per EM ---
vars <- c("age", "sysbp")
results <- data.frame()

for (v in vars) {
  cat("Bootstrap CI for W1 on", v, "...\n")
  x_anchor <- gusto[[v]][gusto$regl == anchor]
  for (p in partners) {
    x_partner <- gusto[[v]][gusto$regl == p]
    n_partner <- length(x_partner)
    res <- w1_bootstrap_ci(x_anchor, x_partner, B = 2000)
    results <- rbind(results, data.frame(
      variable  = v, partner = p, n = n_partner,
      W1        = res$estimate,
      ci_lower  = res$lower,
      ci_upper  = res$upper,
      se        = res$se,
      stringsAsFactors = FALSE
    ))
  }
}

cat("\n--- Ŵ₁ raw results (Region 8 anchor) ---\n")
print(results, digits = 4)

# --- Wide format + CSV export for downstream use (Mike's §4.2 table) ---
res_wide <- results %>%
  select(partner, n, variable, W1, ci_lower, ci_upper, se) %>%
  pivot_wider(
    names_from  = variable,
    values_from = c(W1, ci_lower, ci_upper, se),
    names_glue  = "{.value}_{variable}"
  ) %>%
  arrange(W1_age)

csv_out <- res_wide %>%
  select(partner, n,
         W1_age,   ci_lower_age,   ci_upper_age,   se_age,
         W1_sysbp, ci_lower_sysbp, ci_upper_sysbp, se_sysbp)

write.csv(csv_out,
          file.path(results_dir, "gusto_r8_w1_per_pair.csv"),
          row.names = FALSE)
cat("\nPer-pair Ŵ₁ saved: results/gusto_r8_w1_per_pair.csv\n")

cat(sprintf("\nAge   Ŵ₁ range: [%.3f, %.3f] years\n",
            min(results$W1[results$variable == "age"]),
            max(results$W1[results$variable == "age"])))
cat(sprintf("SBP   Ŵ₁ range: [%.3f, %.3f] mmHg\n",
            min(results$W1[results$variable == "sysbp"]),
            max(results$W1[results$variable == "sysbp"])))

# =============================================================================
# Figure 3 — W₁ raw axis, two panels with per-panel ordering
# =============================================================================

forest_data <- results %>%
  mutate(partner_label = paste0("R", partner))

.build_forest_panel <- function(data, var_name, var_title, panel_letter,
                                x_unit, palette) {
  d <- data %>% filter(variable == var_name)
  ord <- d %>% arrange(W1) %>% pull(partner_label)
  d$partner_label <- factor(d$partner_label, levels = rev(ord))

  if (palette == "color") {
    col_pt <- "#D52B1E"; col_ci <- "#D52B1E"
  } else {
    col_pt <- "#1A1A1A"; col_ci <- "#555555"
  }

  ggplot(d, aes(x = W1, y = partner_label)) +
    geom_errorbarh(aes(xmin = ci_lower, xmax = ci_upper),
                   height = 0.3, linewidth = 0.4, color = col_ci) +
    geom_point(size = 2, color = col_pt) +
    scale_x_continuous(limits = c(0, NA),
                       labels = function(x) sprintf("%.2f", x)) +
    labs(
      x = bquote(widehat(W)[1] ~ "(" * .(x_unit) * ")"),
      y = "Partner region",
      title = sprintf("(%s) %s", panel_letter, var_title)
    ) +
    theme_minimal(base_size = 11) +
    theme(
      legend.position  = "none",
      panel.grid.minor = element_blank(),
      plot.title       = element_text(size = rel(0.9), hjust = 0),
      axis.title       = element_text(size = rel(0.9)),
      axis.text        = element_text(size = rel(0.8), color = "black"),
      axis.text.y      = element_text(size = rel(0.8), color = "black",
                                      hjust = 0),
      plot.background  = element_rect(fill = "white", color = NA),
      panel.background = element_rect(fill = "white", color = NA)
    )
}

build_forest <- function(palette = c("greyscale", "color")) {
  palette <- match.arg(palette)
  pA <- .build_forest_panel(forest_data, "age",   "Age",
                            "A", "years",  palette)
  pB <- .build_forest_panel(forest_data, "sysbp", "Systolic blood pressure",
                            "B", "mmHg",   palette)
  pA + pB
}

# --- Export (paper greyscale + slide color) -----------------------------------
ggsave(file.path(fig_dir, "fig3_gusto_r8_forest.pdf"),
       build_forest("greyscale"),
       width = 7, height = 3.5, device = cairo_pdf, bg = "white")
ggsave(file.path(fig_dir, "fig3_gusto_r8_forest.png"),
       build_forest("greyscale"),
       width = 7, height = 3.5, dpi = 300, bg = "white")
ggsave(file.path(fig_dir, "fig3_gusto_r8_forest_color.pdf"),
       build_forest("color"),
       width = 7, height = 3.5, device = cairo_pdf, bg = "white")
ggsave(file.path(fig_dir, "fig3_gusto_r8_forest_color.png"),
       build_forest("color"),
       width = 7, height = 3.5, dpi = 300, bg = "white")

cat("\nFigures saved to:", fig_dir, "\n")
cat("  fig3_gusto_r8_forest.{pdf,png}        (paper, greyscale)\n")
cat("  fig3_gusto_r8_forest_color.{pdf,png}  (slides, #D52B1E)\n")
cat("\nDone.\n")
