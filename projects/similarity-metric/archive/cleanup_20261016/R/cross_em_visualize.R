# =============================================================================
# Cross-EM EM-invariance Visualization (Tak directive 2026-05-11)
# 3 figures:
#   1. fig_cross_em_invariance — true_nABCD by delta × EM × normalizer (lines)
#   2. fig_cross_em_cv         — CV bar chart, truth vs sample
#   3. fig_cross_em_alignment  — sample mean_est vs true_nABCD (scatter)
# =============================================================================
suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
  library(tidyr)
  library(patchwork)
})

source("projects/similarity-metric/R/figures_paper.R", chdir = FALSE)

g2      <- readRDS("results/normalizer_comparison_grid2.rds")
true_g2 <- readRDS("results/true_nabcd_cross_em.rds")

# Parse "age_d0p25" -> (EM=age, delta=0.25)
parse_em <- function(s) {
  m <- regmatches(s, regexec("^([a-z]+)_d(.+)$", s))[[1]]
  c(EM = m[2], delta = as.numeric(gsub("p", ".", m[3])))
}
for (df_name in c("g2", "true_g2")) {
  df <- get(df_name)
  p  <- t(sapply(df$scenario, parse_em))
  df$EM    <- p[, "EM"]
  df$delta <- as.numeric(p[, "delta"])
  assign(df_name, df)
}

NORMS <- c("IQR", "Q95Q5", "SD", "MAD", "Range")
true_g2$normalizer <- factor(true_g2$normalizer, levels = NORMS)
g2$normalizer      <- factor(g2$normalizer,      levels = NORMS)
true_g2$EM         <- factor(true_g2$EM, levels = c("age", "sbp", "creatinine"))
g2$EM              <- factor(g2$EM,      levels = c("age", "sbp", "creatinine"))

OUTPUT_DIR <- "projects/similarity-metric/figures"

# =============================================================================
# FIGURE 1: true_nABCD lines by (delta × EM), facet by normalizer
# =============================================================================
p1 <- ggplot(true_g2,
             aes(x = delta, y = true_nABCD, color = EM, shape = EM, group = EM)) +
  geom_line(linewidth = 0.7) +
  geom_point(size = 2.5) +
  facet_wrap(~ normalizer, scales = "free_y", ncol = 3) +
  scale_x_continuous(breaks = c(0.25, 0.5, 1.0),
                     labels = c("0.25", "0.50", "1.00")) +
  scale_color_manual(values = c(age = "#0072B2", sbp = "#D55E00", creatinine = "#009E73")) +
  labs(x = expression(paste(delta, "/", sigma, " (scaled location shift)")),
       y = "True nABCD (population)",
       title = "Population true_nABCD across EMs — EM-invariance check",
       subtitle = "Same delta -> ideally all 3 EMs at the same y (low CV)") +
  theme(legend.position = "bottom")

ggsave(file.path(OUTPUT_DIR, "fig_cross_em_invariance.png"), p1,
       width = 9, height = 6, dpi = 300, bg = "white")
ggsave(file.path(OUTPUT_DIR, "fig_cross_em_invariance.pdf"), p1,
       width = 9, height = 6, bg = "white")

# =============================================================================
# FIGURE 2: CV bar chart — truth vs sample
# =============================================================================
cv_truth <- true_g2 |>
  group_by(normalizer, delta) |>
  summarise(CV = sd(true_nABCD) / mean(true_nABCD), .groups = "drop") |>
  group_by(normalizer) |>
  summarise(mean_CV = mean(CV), .groups = "drop") |>
  mutate(source = "truth")

cv_sample <- g2 |>
  filter(n == 200) |>
  group_by(normalizer, delta) |>
  summarise(CV = sd(mean_est) / mean(mean_est), .groups = "drop") |>
  group_by(normalizer) |>
  summarise(mean_CV = mean(CV), .groups = "drop") |>
  mutate(source = "sample (n=200)")

cv_combined <- bind_rows(cv_truth, cv_sample)
cv_combined$source <- factor(cv_combined$source, levels = c("truth", "sample (n=200)"))

p2 <- ggplot(cv_combined,
             aes(x = normalizer, y = mean_CV, fill = source)) +
  geom_col(position = position_dodge(0.8), width = 0.7) +
  geom_text(aes(label = sprintf("%.3f", mean_CV)),
            position = position_dodge(0.8), vjust = -0.4, size = 3) +
  scale_fill_manual(values = c(truth = "#1A1A1A", `sample (n=200)` = "#888888")) +
  labs(x = "Normalizer", y = "Mean CV across 3 EMs (at fixed delta)",
       fill = NULL,
       title = "EM-invariance summary — lower CV is better",
       subtitle = "Range excluded from y-scale annotation due to extreme magnitude (~0.74)") +
  coord_cartesian(ylim = c(0, 0.20)) +
  theme(legend.position = "top")

ggsave(file.path(OUTPUT_DIR, "fig_cross_em_cv.png"), p2,
       width = 7, height = 5, dpi = 300, bg = "white")
ggsave(file.path(OUTPUT_DIR, "fig_cross_em_cv.pdf"), p2,
       width = 7, height = 5, bg = "white")

# =============================================================================
# FIGURE 3: alignment scatter — true_nABCD vs sample mean_est
# =============================================================================
g2_sub <- g2[g2$n == 200, c("scenario", "EM", "delta", "normalizer", "mean_est")]
merged <- merge(g2_sub, true_g2[, c("scenario", "normalizer", "true_nABCD")],
                  by = c("scenario", "normalizer"))

p3 <- ggplot(merged,
             aes(x = true_nABCD, y = mean_est, color = EM, shape = factor(delta))) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "grey50") +
  geom_point(size = 2.5, alpha = 0.85) +
  facet_wrap(~ normalizer, scales = "free", ncol = 3) +
  scale_color_manual(values = c(age = "#0072B2", sbp = "#D55E00", creatinine = "#009E73")) +
  scale_shape_manual(values = c(`0.25` = 16, `0.5` = 17, `1` = 15),
                     name = expression(delta)) +
  labs(x = "True nABCD (population)", y = "Sample mean estimate (n=200)",
       title = "Estimator alignment: sample vs truth",
       subtitle = "Diagonal = unbiased; tight clusters at same delta = EM-invariant") +
  theme(legend.position = "bottom",
        legend.box = "horizontal")

ggsave(file.path(OUTPUT_DIR, "fig_cross_em_alignment.png"), p3,
       width = 9, height = 6, dpi = 300, bg = "white")
ggsave(file.path(OUTPUT_DIR, "fig_cross_em_alignment.pdf"), p3,
       width = 9, height = 6, bg = "white")

cat("Cross-EM visualizations saved:\n")
cat("  fig_cross_em_invariance.{png,pdf} — true_nABCD lines by (delta x EM)\n")
cat("  fig_cross_em_cv.{png,pdf}         — CV bar chart truth vs sample\n")
cat("  fig_cross_em_alignment.{png,pdf}  — sample vs truth scatter\n")
