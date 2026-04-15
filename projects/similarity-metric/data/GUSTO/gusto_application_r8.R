##############################################################################
## GUSTO-I Application: Region 8 Anchor Analysis
## nABCD with percentile bootstrap 95% CI for age & sysbp
## Clinical calibration (Delta_max) and sensitivity analysis (L*)
##############################################################################

library(predtools)
library(ggplot2)
library(dplyr)
library(tidyr)

set.seed(2026)

# --- Paths ---
base_dir <- "C:/Users/hrd13/Documents/Gak/0 Study/800Claude/20260210_SIM/similarity_metrics/projects/similarity-metric"
fig_dir  <- file.path(base_dir, "figures")
data_dir <- file.path(base_dir, "data/GUSTO")
dir.create(fig_dir, showWarnings = FALSE, recursive = TRUE)

# --- Load data ---
data(gusto)
cat("GUSTO-I: N =", nrow(gusto), "\n")
cat("Regions:", sort(unique(gusto$regl)), "\n")

# --- Core functions ---
compute_w1 <- function(x, y) {
  all_vals <- sort(c(x, y)); n <- length(all_vals)
  if (n < 2) return(0)
  Fx <- ecdf(x); Fy <- ecdf(y)
  mids <- (all_vals[-n] + all_vals[-1]) / 2
  diffs <- diff(all_vals)
  sum(abs(Fx(mids) - Fy(mids)) * diffs)
}

compute_nABCD <- function(x, y) {
  iqr_p <- IQR(c(x, y)); if (iqr_p == 0) return(NA_real_)
  compute_w1(x, y) / (2 * iqr_p)
}

nABCD_bootstrap_ci <- function(x, y, B = 2000, conf = 0.95) {
  n1 <- length(x); n2 <- length(y)
  est <- compute_nABCD(x, y)
  boot_vals <- numeric(B)
  for (b in seq_len(B)) {
    xb <- sample(x, n1, replace = TRUE)
    yb <- sample(y, n2, replace = TRUE)
    boot_vals[b] <- compute_nABCD(xb, yb)
  }
  boot_vals <- boot_vals[!is.na(boot_vals)]
  alpha <- 1 - conf
  ci <- quantile(boot_vals, c(alpha / 2, 1 - alpha / 2))
  ci[1] <- max(0, ci[1])
  list(estimate = est, lower = unname(ci[1]), upper = unname(ci[2]),
       se = sd(boot_vals))
}

# --- Region setup ---
anchor <- 8
regions <- sort(unique(gusto$regl))
partners <- setdiff(regions, anchor)
n_anchor <- sum(gusto$regl == anchor)
cat("Anchor: Region", anchor, "(n =", n_anchor, ")\n")
cat("Partners:", length(partners), "regions\n\n")

# --- Compute nABCD + bootstrap CI for age and sysbp ---
vars <- c("age", "sysbp")
results <- data.frame()

for (v in vars) {
  cat("Computing bootstrap CIs for", v, "...\n")
  x_anchor <- gusto[[v]][gusto$regl == anchor]
  for (p in partners) {
    x_partner <- gusto[[v]][gusto$regl == p]
    n_partner <- length(x_partner)
    res <- nABCD_bootstrap_ci(x_anchor, x_partner, B = 2000)
    results <- rbind(results, data.frame(
      variable = v, partner = p, n = n_partner,
      nABCD = res$estimate, ci_lower = res$lower, ci_upper = res$upper,
      se = res$se, stringsAsFactors = FALSE
    ))
  }
}

cat("\n--- nABCD Results (Region 8 vs Partners) ---\n")
print(results, digits = 4)

# --- Reshape to wide format ---
res_wide <- results %>%
  select(partner, n, variable, nABCD, ci_lower, ci_upper) %>%
  pivot_wider(
    names_from = variable,
    values_from = c(nABCD, ci_lower, ci_upper),
    names_glue = "{.value}_{variable}"
  ) %>%
  arrange(nABCD_age)

# --- Clinical calibration for age ---
# FTT-derived CATE sensitivity
L_mean <- 0.0003  # per year
L_max  <- 0.0005  # per year

# IQR_pooled for age (computed across all Region 8 pairs)
age_iqr_vals <- numeric(length(partners))
for (i in seq_along(partners)) {
  x_a <- gusto$age[gusto$regl == anchor]
  x_p <- gusto$age[gusto$regl == partners[i]]
  age_iqr_vals[i] <- IQR(c(x_a, x_p))
}
cat("\nAge IQR_pooled range:", round(range(age_iqr_vals), 1), "\n")

# Use pair-specific IQR for accurate Delta_max
res_wide$iqr_age <- age_iqr_vals[match(res_wide$partner, partners)]
res_wide$delta_max_age_Lmean <- 2 * L_mean * res_wide$iqr_age * res_wide$nABCD_age
res_wide$delta_max_age_Lmax  <- 2 * L_max  * res_wide$iqr_age * res_wide$nABCD_age

# --- L* sensitivity analysis for sysbp ---
# IQR_pooled for sysbp
sysbp_iqr_vals <- numeric(length(partners))
for (i in seq_along(partners)) {
  x_a <- gusto$sysbp[gusto$regl == anchor]
  x_p <- gusto$sysbp[gusto$regl == partners[i]]
  sysbp_iqr_vals[i] <- IQR(c(x_a, x_p))
}
cat("SBP IQR_pooled range:", round(range(sysbp_iqr_vals), 1), "\n")

res_wide$iqr_sysbp <- sysbp_iqr_vals[match(res_wide$partner, partners)]

# L* = Delta_clin / (2 * IQR_pooled * nABCD)
res_wide$Lstar_sysbp_1pct <- 0.01 / (2 * res_wide$iqr_sysbp * res_wide$nABCD_sysbp)
res_wide$Lstar_sysbp_2pct <- 0.02 / (2 * res_wide$iqr_sysbp * res_wide$nABCD_sysbp)

# --- Poolability ---
threshold <- 0.05
res_wide$pool_age   <- ifelse(res_wide$nABCD_age < threshold, "Y", "N")
res_wide$pool_sysbp <- ifelse(res_wide$nABCD_sysbp < threshold, "Y", "N")
res_wide$pool_joint <- ifelse(res_wide$pool_age == "Y" & res_wide$pool_sysbp == "Y", "Y", "N")

cat("\n--- Poolability Summary ---\n")
cat("Age poolable:", sum(res_wide$pool_age == "Y"), "of", nrow(res_wide), "\n")
cat("SBP poolable:", sum(res_wide$pool_sysbp == "Y"), "of", nrow(res_wide), "\n")
cat("Joint poolable:", sum(res_wide$pool_joint == "Y"), "of", nrow(res_wide), "\n")

# R6 boundary check
r6_row <- res_wide[res_wide$partner == 6, ]
cat("\nR6 boundary: nABCD(sysbp) =", round(r6_row$nABCD_sysbp, 5), "\n")
cat("  strict < 0.05:", r6_row$nABCD_sysbp < 0.05, "\n")
cat("  <= 0.05:", r6_row$nABCD_sysbp <= 0.05, "\n")

# --- Save CSV ---
csv_out <- res_wide %>%
  select(partner, n,
         nABCD_age, ci_lower_age, ci_upper_age,
         nABCD_sysbp, ci_lower_sysbp, ci_upper_sysbp,
         delta_max_age_Lmean, delta_max_age_Lmax,
         Lstar_sysbp_1pct, Lstar_sysbp_2pct,
         pool_age, pool_sysbp, pool_joint)

write.csv(csv_out, file.path(data_dir, "gusto_r8_results.csv"), row.names = FALSE)
cat("\nResults saved to gusto_r8_results.csv\n")

# ===========================================================================
# FIGURES
# ===========================================================================

# Color palette (colorblind-friendly)
col_pool   <- "#0072B2"  # blue
col_nopool <- "#D55E00"  # vermillion
col_border <- "#999999"
col_r6     <- "#E69F00"  # amber for boundary

# --- Figure A: Forest plot ---
forest_data <- results %>%
  mutate(
    partner_label = paste0("R", partner),
    poolable = ifelse(nABCD < threshold, "Poolable", "Not poolable")
  )

# Add R6/sysbp boundary annotation
forest_data$poolable[forest_data$variable == "sysbp" & forest_data$partner == 6] <- "Boundary"

# Reorder partners by age nABCD
age_order <- forest_data %>%
  filter(variable == "age") %>%
  arrange(nABCD) %>%
  pull(partner_label)
forest_data$partner_label <- factor(forest_data$partner_label, levels = rev(age_order))

forest_data$variable_label <- ifelse(forest_data$variable == "age", "Age", "Systolic BP")

p_forest <- ggplot(forest_data, aes(x = nABCD, y = partner_label, color = poolable)) +
  geom_vline(xintercept = threshold, linetype = "dashed", color = "grey40", linewidth = 0.5) +
  geom_errorbarh(aes(xmin = ci_lower, xmax = ci_upper), height = 0.3, linewidth = 0.4) +
  geom_point(size = 2) +
  facet_wrap(~ variable_label, scales = "free_x") +
  scale_color_manual(
    values = c("Poolable" = col_pool, "Not poolable" = col_nopool, "Boundary" = col_r6),
    name = NULL
  ) +
  labs(
    x = "nABCD  (95% percentile bootstrap CI)",
    y = "Partner region",
    title = NULL
  ) +
  theme_minimal(base_size = 11) +
  theme(
    legend.position = "bottom",
    panel.grid.minor = element_blank(),
    strip.text = element_text(face = "bold", size = 12)
  )

ggsave(file.path(fig_dir, "fig_gusto_r8_forest.pdf"), p_forest,
       width = 7, height = 6, device = cairo_pdf)
ggsave(file.path(fig_dir, "fig_gusto_r8_forest.png"), p_forest,
       width = 7, height = 6, dpi = 300)
cat("Figure A (forest) saved.\n")

# --- Figure B: Joint pooling scatter ---
scatter_data <- res_wide %>%
  mutate(
    partner_label = paste0("R", partner),
    pool_status = case_when(
      pool_joint == "Y" ~ "Both poolable",
      pool_age == "Y" & pool_sysbp == "N" ~ "Age only",
      pool_age == "N" & pool_sysbp == "Y" ~ "SBP only",
      TRUE ~ "Neither"
    )
  )

# Mark R6 boundary
scatter_data$pool_status[scatter_data$partner == 6] <-
  ifelse(scatter_data$pool_status[scatter_data$partner == 6] == "Both poolable",
         "Both poolable (R6 boundary)", "Age only (R6 boundary)")

p_scatter <- ggplot(scatter_data, aes(x = nABCD_age, y = nABCD_sysbp)) +
  # Threshold lines
  geom_vline(xintercept = threshold, linetype = "dashed", color = "grey50", linewidth = 0.4) +
  geom_hline(yintercept = threshold, linetype = "dashed", color = "grey50", linewidth = 0.4) +
  # Quadrant shading
  annotate("rect", xmin = -Inf, xmax = threshold, ymin = -Inf, ymax = threshold,
           fill = col_pool, alpha = 0.08) +
  # Points
  geom_point(aes(color = pool_status, shape = pool_status), size = 3) +
  # Labels
  geom_text(aes(label = partner_label), vjust = -0.8, hjust = 0.5, size = 3) +
  scale_color_manual(
    values = c(
      "Both poolable" = col_pool,
      "Both poolable (R6 boundary)" = col_r6,
      "Age only" = "#56B4E9",
      "Age only (R6 boundary)" = col_r6,
      "SBP only" = "#CC79A7",
      "Neither" = col_nopool
    ),
    name = NULL
  ) +
  scale_shape_manual(
    values = c(
      "Both poolable" = 16,
      "Both poolable (R6 boundary)" = 17,
      "Age only" = 1,
      "Age only (R6 boundary)" = 2,
      "SBP only" = 15,
      "Neither" = 4
    ),
    name = NULL
  ) +
  # Quadrant labels
  annotate("text", x = 0.025, y = 0.005, label = "Both poolable",
           color = col_pool, fontface = "bold", size = 3.5, alpha = 0.7) +
  annotate("text", x = 0.065, y = 0.005, label = "SBP only",
           color = "#CC79A7", size = 3, alpha = 0.7) +
  annotate("text", x = 0.025, y = 0.115, label = "Age only",
           color = "#56B4E9", size = 3, alpha = 0.7) +
  annotate("text", x = 0.065, y = 0.115, label = "Neither",
           color = col_nopool, size = 3, alpha = 0.7) +
  labs(
    x = "nABCD (Age)",
    y = "nABCD (Systolic BP)",
    title = NULL
  ) +
  theme_minimal(base_size = 11) +
  theme(
    legend.position = "bottom",
    panel.grid.minor = element_blank()
  )

ggsave(file.path(fig_dir, "fig_gusto_r8_scatter.pdf"), p_scatter,
       width = 7, height = 6, device = cairo_pdf)
ggsave(file.path(fig_dir, "fig_gusto_r8_scatter.png"), p_scatter,
       width = 7, height = 6, dpi = 300)
cat("Figure B (scatter) saved.\n")

# --- Figure C: Clinical calibration & sensitivity ---
# Panel 1: Delta_max for age (all partners)
cal_age <- res_wide %>%
  select(partner, delta_max_age_Lmean, delta_max_age_Lmax) %>%
  pivot_longer(cols = starts_with("delta_max"),
               names_to = "L_type", values_to = "delta_max") %>%
  mutate(
    L_label = ifelse(L_type == "delta_max_age_Lmean",
                     "L[mean] == 0.0003/yr", "L[max] == 0.0005/yr"),
    partner_label = paste0("R", partner),
    partner_label = factor(partner_label,
                           levels = paste0("R", res_wide$partner[order(res_wide$nABCD_age)]))
  )

p_cal_age <- ggplot(cal_age, aes(x = partner_label, y = delta_max * 100, fill = L_label)) +
  geom_col(position = position_dodge(width = 0.7), width = 0.6) +
  scale_fill_manual(
    values = c("L[mean] == 0.0003/yr" = "#56B4E9", "L[max] == 0.0005/yr" = "#0072B2"),
    labels = c(expression(L[mean] == 0.0003/yr), expression(L[max] == 0.0005/yr)),
    name = NULL
  ) +
  labs(x = "Partner region", y = expression(Delta[max] ~ "(%pt)"),
       subtitle = "(a) Age: Clinical calibration") +
  theme_minimal(base_size = 11) +
  theme(
    legend.position = "top",
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.grid.minor = element_blank()
  )

# Panel 2: L* for sysbp (non-poolable partners only)
cal_sbp <- res_wide %>%
  filter(pool_sysbp == "N") %>%
  select(partner, Lstar_sysbp_1pct, Lstar_sysbp_2pct) %>%
  pivot_longer(cols = starts_with("Lstar"),
               names_to = "delta_clin", values_to = "Lstar") %>%
  mutate(
    delta_label = ifelse(delta_clin == "Lstar_sysbp_1pct",
                         "Delta[clin] == 1*'%pt'", "Delta[clin] == 2*'%pt'"),
    partner_label = paste0("R", partner),
    partner_label = factor(partner_label,
                           levels = paste0("R", res_wide$partner[res_wide$pool_sysbp == "N"][
                             order(res_wide$nABCD_sysbp[res_wide$pool_sysbp == "N"])]))
  )

p_cal_sbp <- ggplot(cal_sbp, aes(x = partner_label, y = Lstar, fill = delta_label)) +
  geom_col(position = position_dodge(width = 0.7), width = 0.6) +
  scale_fill_manual(
    values = c("Delta[clin] == 1*'%pt'" = "#E69F00", "Delta[clin] == 2*'%pt'" = "#D55E00"),
    labels = c(expression(Delta[clin] == 1*"%pt"), expression(Delta[clin] == 2*"%pt")),
    name = NULL
  ) +
  labs(x = "Partner region (SBP non-poolable)",
       y = expression(L^"*" ~ "(per mmHg)"),
       subtitle = "(b) Systolic BP: Sensitivity analysis") +
  theme_minimal(base_size = 11) +
  theme(
    legend.position = "top",
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.grid.minor = element_blank()
  )

# Combine panels
library(patchwork)
p_calibration <- p_cal_age / p_cal_sbp

ggsave(file.path(fig_dir, "fig_gusto_r8_calibration.pdf"), p_calibration,
       width = 7, height = 8, device = cairo_pdf)
ggsave(file.path(fig_dir, "fig_gusto_r8_calibration.png"), p_calibration,
       width = 7, height = 8, dpi = 300)
cat("Figure C (calibration) saved.\n")

# ===========================================================================
# Print summary table for LaTeX
# ===========================================================================
cat("\n\n====== LATEX TABLE DATA ======\n")
cat("Partner & n & nABCD_age [CI] & nABCD_sysbp [CI] & Pool_age & Pool_sysbp & Pool_joint\n")
for (i in seq_len(nrow(res_wide))) {
  r <- res_wide[i, ]
  cat(sprintf("R%d & %d & %.3f [%.3f, %.3f] & %.3f [%.3f, %.3f] & %s & %s & %s \\\\\n",
              r$partner, r$n,
              r$nABCD_age, r$ci_lower_age, r$ci_upper_age,
              r$nABCD_sysbp, r$ci_lower_sysbp, r$ci_upper_sysbp,
              r$pool_age, r$pool_sysbp, r$pool_joint))
}

cat("\n\n====== DELTA_MAX (AGE) ======\n")
for (i in seq_len(nrow(res_wide))) {
  r <- res_wide[i, ]
  cat(sprintf("R%d: IQR=%.1f, nABCD=%.4f, Delta_max(Lmean)=%.4f%%pt, Delta_max(Lmax)=%.4f%%pt\n",
              r$partner, r$iqr_age, r$nABCD_age,
              r$delta_max_age_Lmean * 100, r$delta_max_age_Lmax * 100))
}

cat("\n\n====== L* (SYSBP, NON-POOLABLE) ======\n")
np <- res_wide[res_wide$pool_sysbp == "N", ]
for (i in seq_len(nrow(np))) {
  r <- np[i, ]
  cat(sprintf("R%d: IQR=%.1f, nABCD=%.4f, L*(1%%pt)=%.5f, L*(2%%pt)=%.5f\n",
              r$partner, r$iqr_sysbp, r$nABCD_sysbp,
              r$Lstar_sysbp_1pct, r$Lstar_sysbp_2pct))
}

cat("\nDone.\n")
