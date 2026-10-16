# =============================================================================
# Normalizer decision evidence — multi-axis visualization
# Tak directive 2026-05-11: cross-EM alone insufficient to reject SD;
# combine estimation properties (bias, coverage, SMD differentiation, outlier
# sensitivity, asymptotic normality) into decision evidence.
# =============================================================================
suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
  library(tidyr)
  library(patchwork)
})

source("projects/similarity-metric/R/figures_paper.R", chdir = FALSE)

# Load data
true_redesign <- readRDS("results/true_redesign.rds")
true_redesign <- true_redesign[true_redesign$scenario != "N6", ]
smd_redesign  <- readRDS("results/smd_redesign.rds")
smd_redesign  <- smd_redesign[smd_redesign$scenario != "N6", ]
g_redesign    <- readRDS("results/normalizer_comparison_redesign.rds")
g_redesign    <- g_redesign[g_redesign$normalizer != "SMD" &
                              g_redesign$scenario != "N6", ]

NORMS <- c("IQR", "Q95Q5", "SD", "MAD", "Range")
scenarios_main <- c("N1", "N2", "N3", "N4", "N5", "N7", "N8")
scenario_labels <- c(
  N1 = "N1\nNull",
  N2 = "N2\nGauss\nSMD=0.5",
  N3 = "N3\nScale\nSMD=0",
  N4 = "N4\nt(3)\nSMD=0",
  N5 = "N5\nOutlier\n5%",
  N7 = "N7\nGamma\nSMD=0",
  N8 = "N8\nt(5)+0.5\nSMD=0.5"
)

OUTPUT_DIR <- "projects/similarity-metric/figures"

# =============================================================================
# Figure 1: SMD-equivalence revelation
# Bar chart of population nABCD per normalizer + |SMD| as a 6th category
# =============================================================================
true_long <- true_redesign[, c("scenario", "normalizer", "true_nABCD")]
smd_long  <- smd_redesign[, c("scenario", "population_smd")]
names(smd_long)[2] <- "true_nABCD"
smd_long$normalizer <- "|SMD|"
smd_long$true_nABCD <- abs(smd_long$true_nABCD)

combined <- rbind(true_long, smd_long)
combined$normalizer <- factor(combined$normalizer,
                                levels = c("IQR", "Q95Q5", "SD", "MAD", "Range", "|SMD|"))
combined$scenario_label <- factor(scenario_labels[combined$scenario],
                                    levels = scenario_labels[scenarios_main])

palette1 <- c(.normalizer_palette("color"), `|SMD|` = "#888888")

p1 <- ggplot(combined, aes(x = scenario_label, y = true_nABCD, fill = normalizer)) +
  geom_col(position = position_dodge(0.85), width = 0.78) +
  scale_fill_manual(values = palette1) +
  labs(x = "Scenario", y = "Population value",
       fill = "Normalizer / |SMD|",
       title = "Goal 1: SMD vs nABCD differentiation",
       subtitle = paste0("N3/N4/N7: |SMD|=0 (grey bar absent) yet nABCD>0 (Goal 1A). ",
                          "N2 vs N8: same |SMD|=0.5, SD-nABCD nearly equal (SD blind), ",
                          "MAD-nABCD differs (Goal 1B).")) +
  theme(legend.position = "bottom",
        axis.text.x = element_text(size = rel(0.75)),
        plot.subtitle = element_text(size = rel(0.85)))

ggsave(file.path(OUTPUT_DIR, "fig_smd_equivalence.png"), p1,
       width = 10, height = 6, dpi = 300, bg = "white")
ggsave(file.path(OUTPUT_DIR, "fig_smd_equivalence.pdf"), p1,
       width = 10, height = 6, bg = "white")

# =============================================================================
# Figure 2: Outlier sensitivity (N2 -> N5 transition)
# Line plot showing how true nABCD changes when 5% outliers added
# =============================================================================
n2_n5 <- true_redesign[true_redesign$scenario %in% c("N2", "N5") &
                          true_redesign$normalizer != "Range", ]
n2_n5$scenario <- factor(n2_n5$scenario, levels = c("N2", "N5"),
                          labels = c("N2 (clean Gaussian)", "N5 (5% outlier added)"))
n2_n5$normalizer <- factor(n2_n5$normalizer, levels = c("IQR", "Q95Q5", "SD", "MAD"))

# Compute shrink fraction
shrink_pct <- n2_n5 %>%
  group_by(normalizer) %>%
  summarise(shrink = sprintf("%+.0f%%",
                              100 * (true_nABCD[scenario == "N5 (5% outlier added)"] -
                                     true_nABCD[scenario == "N2 (clean Gaussian)"]) /
                                    true_nABCD[scenario == "N2 (clean Gaussian)"]),
            .groups = "drop")

p2 <- ggplot(n2_n5, aes(x = scenario, y = true_nABCD,
                          group = normalizer, color = normalizer)) +
  geom_line(linewidth = 1) +
  geom_point(size = 3) +
  geom_text(data = subset(n2_n5, scenario == "N5 (5% outlier added)"),
            aes(label = paste0("  ", normalizer, " ",
                                shrink_pct$shrink[match(normalizer, shrink_pct$normalizer)])),
            hjust = 0, size = 3.2) +
  scale_color_manual(values = .normalizer_palette("color")[c("IQR", "Q95Q5", "SD", "MAD")]) +
  labs(x = NULL, y = "Population true nABCD",
       color = "Normalizer",
       title = "Goal 2C: Outlier sensitivity — same location shift 0.5",
       subtitle = "5% outlier added: SD shrinks -58% (mean-driven), Q95Q5 only -15% (tail-robust).") +
  expand_limits(x = 2.6) +
  theme(legend.position = "none")

ggsave(file.path(OUTPUT_DIR, "fig_outlier_sensitivity.png"), p2,
       width = 8, height = 5, dpi = 300, bg = "white")
ggsave(file.path(OUTPUT_DIR, "fig_outlier_sensitivity.pdf"), p2,
       width = 8, height = 5, bg = "white")

# =============================================================================
# Figure 3: Multi-criterion decision matrix (heatmap)
# =============================================================================
# Criterion 1: EM-invariance (1 - CV / max_CV)
em_cv <- c(IQR = 0.0753, Q95Q5 = 0.0269, SD = 0.0443, MAD = 0.0897, Range = 0.7393)
c1 <- 1 - em_cv / max(em_cv)

# Criterion 2: Coverage at n=200, averaged across main scenarios
cov_data <- g_redesign[g_redesign$n == 200 & g_redesign$scenario %in% scenarios_main, ]
cov_avg  <- aggregate(coverage_pct ~ normalizer, data = cov_data, FUN = mean)
c2_raw   <- setNames(cov_avg$coverage_pct, cov_avg$normalizer)[NORMS]
c2 <- 1 - pmin(abs(c2_raw - 0.95) / 0.95, 1)

# Criterion 3: SMD differentiation (|N8 - N2| nABCD diff)
n2 <- true_redesign[true_redesign$scenario == "N2", c("normalizer", "true_nABCD")]
n8 <- true_redesign[true_redesign$scenario == "N8", c("normalizer", "true_nABCD")]
smd_diff <- merge(n2, n8, by = "normalizer", suffixes = c("_n2", "_n8"))
smd_diff$diff <- abs(smd_diff$true_nABCD_n8 - smd_diff$true_nABCD_n2)
c3_raw <- setNames(smd_diff$diff, smd_diff$normalizer)[NORMS]
c3 <- c3_raw / max(c3_raw)

# Criterion 4: Outlier robustness (N5 coverage at n=200)
n5_cov <- g_redesign[g_redesign$scenario == "N5" & g_redesign$n == 200,
                       c("normalizer", "coverage_pct")]
c4_raw <- setNames(n5_cov$coverage_pct, n5_cov$normalizer)[NORMS]
c4 <- c4_raw / max(c4_raw)

# Criterion 5: Asymptotic normality (kurtosis close to 3 in N3 n=200)
norm_data <- readRDS("results/normality_results.rds")$summary
n3_norm <- norm_data[norm_data$cell == "N3_n200", ]
c5_raw <- setNames(abs(n3_norm$kurtosis - 3), n3_norm$normalizer)[NORMS]
c5 <- 1 - c5_raw / max(c5_raw)

score_df <- data.frame(
  normalizer = factor(NORMS, levels = NORMS),
  `EM-invariance`  = round(c1, 2),
  `Coverage cal`   = round(c2, 2),
  `SMD diff`       = round(c3, 2),
  `Outlier robust` = round(c4, 2),
  `Asymp normal`   = round(c5, 2),
  check.names = FALSE
)

# Print raw values too for transparency
cat("--- Raw values per criterion ---\n")
cat(sprintf("EM-invariance CV:   "));  print(round(em_cv, 4))
cat(sprintf("Coverage (n=200):   "));  print(round(c2_raw, 4))
cat(sprintf("|N8 - N2| diff:     "));  print(round(c3_raw, 4))
cat(sprintf("N5 cov (n=200):     "));  print(round(c4_raw, 4))
cat(sprintf("|kurt - 3| (N3):    "));  print(round(c5_raw, 4))

cat("\n--- Normalized scores (0=worst, 1=best) ---\n")
print(score_df, row.names = FALSE)

score_long <- pivot_longer(score_df, -normalizer,
                            names_to = "criterion", values_to = "score")
score_long$criterion <- factor(score_long$criterion,
                                 levels = c("EM-invariance", "Coverage cal", "SMD diff",
                                            "Outlier robust", "Asymp normal"))

p3 <- ggplot(score_long, aes(x = criterion, y = normalizer, fill = score)) +
  geom_tile(color = "white", linewidth = 0.6) +
  geom_text(aes(label = sprintf("%.2f", score),
                color = score < 0.5),
            size = 3.8, fontface = "bold") +
  scale_fill_gradient(low = "#E89090", high = "#1A4D1A",
                       limits = c(0, 1)) +
  scale_color_manual(values = c(`TRUE` = "black", `FALSE` = "white"), guide = "none") +
  labs(x = "Criterion", y = "Normalizer",
       fill = "Score\n(1 = best)",
       title = "Normalizer decision matrix — all evidence combined",
       subtitle = paste0("Score 0–1 per criterion (higher = better). ",
                          "Q95Q5 dominates 3 of 5 criteria; SD weak on SMD-diff and outlier-robust; ",
                          "Range fails all.")) +
  theme(legend.position = "right",
        plot.subtitle = element_text(size = rel(0.85)))

ggsave(file.path(OUTPUT_DIR, "fig_normalizer_decision_matrix.png"), p3,
       width = 10, height = 5, dpi = 300, bg = "white")
ggsave(file.path(OUTPUT_DIR, "fig_normalizer_decision_matrix.pdf"), p3,
       width = 10, height = 5, bg = "white")

cat("\nDecision evidence figures saved:\n")
cat("  fig_smd_equivalence.{png,pdf}\n")
cat("  fig_outlier_sensitivity.{png,pdf}\n")
cat("  fig_normalizer_decision_matrix.{png,pdf}\n")
