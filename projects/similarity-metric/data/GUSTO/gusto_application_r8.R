##############################################################################
## GUSTO-I Application: Region 8 Anchor Analysis
## nABCD with percentile bootstrap 95% CI for age & sysbp
## Sensitivity analysis (L* reverse-calculation) for BOTH age and sysbp
## (L is treated as unknown a priori for both effect modifiers — the
##  realistic planning-stage scenario; Delta_max pathway is dropped for age.)
##
## Ranking-based output: partners are ranked by nABCD on each EM and jointly.
## No threshold-based poolability classification is produced or used for
## figures; figures show the nABCD + CI continuum and L* for upper-nABCD
## partners.
##############################################################################

library(predtools)
library(ggplot2)
library(dplyr)
library(tidyr)
library(patchwork)
library(ggrepel)

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

# --- L* sensitivity analysis (BOTH age and sysbp) ---
# L is treated as unknown a priori for both effect modifiers. This is the
# realistic MRCT-planning scenario: CATE sensitivity is rarely available
# before Phase 3. L* reverse-calculation asks what value of L would be
# required for the observed distributional difference to produce a
# pre-specified clinically meaningful effect (Delta_clin).

# IQR_pooled for age (computed per Region 8 pair)
age_iqr_vals <- numeric(length(partners))
for (i in seq_along(partners)) {
  x_a <- gusto$age[gusto$regl == anchor]
  x_p <- gusto$age[gusto$regl == partners[i]]
  age_iqr_vals[i] <- IQR(c(x_a, x_p))
}
cat("\nAge IQR_pooled range:", round(range(age_iqr_vals), 1), "\n")
res_wide$iqr_age <- age_iqr_vals[match(res_wide$partner, partners)]

# L* for age at Delta_clin = 1%pt and 2%pt
res_wide$Lstar_age_1pct <- 0.01 / (2 * res_wide$iqr_age * res_wide$nABCD_age)
res_wide$Lstar_age_2pct <- 0.02 / (2 * res_wide$iqr_age * res_wide$nABCD_age)

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

# --- Ranking summaries (no threshold-based poolability) ---
# Order partners by each effect modifier's nABCD and by a simple combined rank,
# which is the sum of within-EM ranks. Smaller combined rank = closer to Region 8
# on both effect modifiers jointly.
res_wide$rank_age   <- rank(res_wide$nABCD_age, ties.method = "min")
res_wide$rank_sysbp <- rank(res_wide$nABCD_sysbp, ties.method = "min")
res_wide$rank_sum   <- res_wide$rank_age + res_wide$rank_sysbp

cat("\n--- Ranking Summary (ascending nABCD) ---\n")
cat("Top 5 partners by age nABCD:\n")
print(res_wide[order(res_wide$nABCD_age), c("partner", "nABCD_age", "ci_lower_age", "ci_upper_age")][1:5, ])
cat("\nTop 5 partners by SBP nABCD:\n")
print(res_wide[order(res_wide$nABCD_sysbp), c("partner", "nABCD_sysbp", "ci_lower_sysbp", "ci_upper_sysbp")][1:5, ])
cat("\nTop 5 partners by combined rank (smallest nABCD on both EMs):\n")
print(res_wide[order(res_wide$rank_sum), c("partner", "nABCD_age", "nABCD_sysbp", "rank_age", "rank_sysbp", "rank_sum")][1:5, ])

# --- Save CSV ---
csv_out <- res_wide %>%
  select(partner, n,
         nABCD_age, ci_lower_age, ci_upper_age,
         nABCD_sysbp, ci_lower_sysbp, ci_upper_sysbp,
         iqr_age, Lstar_age_1pct, Lstar_age_2pct,
         iqr_sysbp, Lstar_sysbp_1pct, Lstar_sysbp_2pct,
         rank_age, rank_sysbp, rank_sum)

write.csv(csv_out, file.path(data_dir, "gusto_r8_results.csv"), row.names = FALSE)
cat("\nResults saved to gusto_r8_results.csv\n")

# ===========================================================================
# FIGURES
# ===========================================================================

# Color palette (colorblind-friendly)
col_point  <- "#0072B2"  # single neutral blue for all points (no threshold colouring)

# --- Figure A: Forest plot (two panels, independently sorted) ---
# Panel (A) Age: partners sorted by ascending age nABCD.
# Panel (B) Systolic BP: partners sorted by ascending SBP nABCD.
# Partner ordering therefore differs between panels — this difference is
# itself a substantive observation (the ranking of partners by candidate
# effect modifier is not the same). Dual palette: greyscale (paper) +
# vivid red (slides).
forest_data <- results %>%
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

# Paper standard: width = 7 in, white background. Two-panel forest needs
# slight extra height to accommodate per-panel y-axis labels.
ggsave(file.path(fig_dir, "fig3_gusto_r8_forest.pdf"),       build_forest("greyscale"),
       width = 7, height = 3.5, device = cairo_pdf, bg = "white")
ggsave(file.path(fig_dir, "fig3_gusto_r8_forest.png"),       build_forest("greyscale"),
       width = 7, height = 3.5, dpi = 300, bg = "white")
ggsave(file.path(fig_dir, "fig3_gusto_r8_forest_color.pdf"), build_forest("color"),
       width = 7, height = 3.5, device = cairo_pdf, bg = "white")
ggsave(file.path(fig_dir, "fig3_gusto_r8_forest_color.png"), build_forest("color"),
       width = 7, height = 3.5, dpi = 300, bg = "white")
cat("Figure A (forest, greyscale + color) saved.\n")

# --- Figure B: Joint distributional assessment (continuum) ---
# Partner regions plotted in the (nABCD_age, nABCD_sysbp) plane. No
# threshold-based classification: all points share one shape, equal x/y
# scale, and labels use collision-avoidance (ggrepel). Dual palette:
# greyscale (paper) + vivid red (slides). Paper standard: width = 7 in,
# white background.
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
    labs(x = "nABCD (Age)", y = "nABCD (Systolic blood pressure)", title = NULL) +
    theme_minimal(base_size = 11) +
    theme(
      panel.grid.minor = element_blank(),
      axis.title       = element_text(size = rel(0.9)),
      axis.text        = element_text(size = rel(0.8), color = "black"),
      legend.text      = element_text(size = rel(0.8)),
      plot.background  = element_rect(fill = "white", color = NA),
      panel.background = element_rect(fill = "white", color = NA)
    )
}

ggsave(file.path(fig_dir, "slide_gusto_r8_scatter.pdf"),       build_scatter("greyscale"),
       width = 5, height = 5, device = cairo_pdf, bg = "white")
ggsave(file.path(fig_dir, "slide_gusto_r8_scatter.png"),       build_scatter("greyscale"),
       width = 5, height = 5, dpi = 300, bg = "white")
ggsave(file.path(fig_dir, "slide_gusto_r8_scatter_color.pdf"), build_scatter("color"),
       width = 5, height = 5, device = cairo_pdf, bg = "white")
ggsave(file.path(fig_dir, "slide_gusto_r8_scatter_color.png"), build_scatter("color"),
       width = 5, height = 5, dpi = 300, bg = "white")
cat("Figure B (scatter, greyscale + color) saved.\n")

# --- Figure C: L* sensitivity analysis (age & sysbp) ---
# Panels show L* for the partners with the largest nABCD on each EM --
# the partners whose observed distributional differences require the most
# careful assessment of CATE sensitivity plausibility. To preserve the
# previous number of bars, we keep the original selection logic but reframe
# it in ranking terms: the upper-nABCD partners on each effect modifier.
# (Selection identical in cardinality to the previous pool_*=="N" filter.)
upper_age_partners   <- res_wide$partner[res_wide$nABCD_age   >= 0.05]
upper_sysbp_partners <- res_wide$partner[res_wide$nABCD_sysbp >  0.05]

cal_age <- res_wide %>%
  filter(partner %in% upper_age_partners) %>%
  select(partner, Lstar_age_1pct, Lstar_age_2pct) %>%
  pivot_longer(cols = starts_with("Lstar"),
               names_to = "delta_clin", values_to = "Lstar") %>%
  mutate(
    delta_label = ifelse(delta_clin == "Lstar_age_1pct",
                         "Delta[clin] == 1*'%pt'", "Delta[clin] == 2*'%pt'"),
    partner_label = paste0("R", partner),
    partner_label = factor(partner_label,
                           levels = paste0("R", res_wide$partner[res_wide$partner %in% upper_age_partners][
                             order(res_wide$nABCD_age[res_wide$partner %in% upper_age_partners])]))
  )

p_cal_age <- ggplot(cal_age, aes(x = partner_label, y = Lstar, fill = delta_label)) +
  geom_col(position = position_dodge(width = 0.7), width = 0.6) +
  scale_fill_manual(
    values = c("Delta[clin] == 1*'%pt'" = "#56B4E9", "Delta[clin] == 2*'%pt'" = "#0072B2"),
    labels = c(expression(Delta[clin] == 1*"%pt"), expression(Delta[clin] == 2*"%pt")),
    name = NULL
  ) +
  labs(x = "Partner region (upper-nABCD partners on age)",
       y = expression(L^"*" ~ "(per year)"),
       subtitle = "(a) Age: Sensitivity analysis") +
  theme_minimal(base_size = 11) +
  theme(
    legend.position = "top",
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.grid.minor = element_blank()
  )

# Panel 2: L* for sysbp (upper-nABCD partners on SBP)
cal_sbp <- res_wide %>%
  filter(partner %in% upper_sysbp_partners) %>%
  select(partner, Lstar_sysbp_1pct, Lstar_sysbp_2pct) %>%
  pivot_longer(cols = starts_with("Lstar"),
               names_to = "delta_clin", values_to = "Lstar") %>%
  mutate(
    delta_label = ifelse(delta_clin == "Lstar_sysbp_1pct",
                         "Delta[clin] == 1*'%pt'", "Delta[clin] == 2*'%pt'"),
    partner_label = paste0("R", partner),
    partner_label = factor(partner_label,
                           levels = paste0("R", res_wide$partner[res_wide$partner %in% upper_sysbp_partners][
                             order(res_wide$nABCD_sysbp[res_wide$partner %in% upper_sysbp_partners])]))
  )

p_cal_sbp <- ggplot(cal_sbp, aes(x = partner_label, y = Lstar, fill = delta_label)) +
  geom_col(position = position_dodge(width = 0.7), width = 0.6) +
  scale_fill_manual(
    # Same blue pair as panel (a): Delta_clin is the same variable across
    # facets, so color mapping is kept consistent. Panel differentiation is
    # conveyed by subtitle ("Age" vs "Systolic BP") and y-axis unit.
    # (knowledge/visualization/color_for_scientific_figures.md §4)
    values = c("Delta[clin] == 1*'%pt'" = "#56B4E9", "Delta[clin] == 2*'%pt'" = "#0072B2"),
    labels = c(expression(Delta[clin] == 1*"%pt"), expression(Delta[clin] == 2*"%pt")),
    name = NULL
  ) +
  labs(x = "Partner region (upper-nABCD partners on SBP)",
       y = expression(L^"*" ~ "(per mmHg)"),
       subtitle = "(b) Systolic BP: Sensitivity analysis") +
  theme_minimal(base_size = 11) +
  theme(
    legend.position = "top",
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.grid.minor = element_blank()
  )

# Combine panels
p_calibration <- p_cal_age / p_cal_sbp

ggsave(file.path(fig_dir, "fig_gusto_r8_calibration.pdf"), p_calibration,
       width = 7, height = 8, device = cairo_pdf)
ggsave(file.path(fig_dir, "fig_gusto_r8_calibration.png"), p_calibration,
       width = 7, height = 8, dpi = 300)
cat("Figure C (calibration) saved.\n")

# ===========================================================================
# Print summary table for LaTeX (ranking-based, no pool? columns)
# ===========================================================================
cat("\n\n====== LATEX TABLE DATA (ranked by age nABCD) ======\n")
cat("Rank & Partner & n & nABCD_age [CI] & nABCD_sysbp [CI]\n")
ordered <- res_wide[order(res_wide$nABCD_age), ]
for (i in seq_len(nrow(ordered))) {
  r <- ordered[i, ]
  cat(sprintf("%d & R%d & %d & %.3f [%.3f, %.3f] & %.3f [%.3f, %.3f] \\\\\n",
              i, r$partner, r$n,
              r$nABCD_age, r$ci_lower_age, r$ci_upper_age,
              r$nABCD_sysbp, r$ci_lower_sysbp, r$ci_upper_sysbp))
}

cat("\n\n====== L* (AGE, ALL PARTNERS, ordered by ascending age nABCD) ======\n")
for (i in seq_len(nrow(ordered))) {
  r <- ordered[i, ]
  cat(sprintf("R%d: IQR=%.1f, nABCD=%.4f, L*(1%%pt)=%.6f/yr, L*(2%%pt)=%.6f/yr\n",
              r$partner, r$iqr_age, r$nABCD_age,
              r$Lstar_age_1pct, r$Lstar_age_2pct))
}

cat("\n\n====== L* (SBP, UPPER-nABCD PARTNERS, ordered by ascending SBP nABCD) ======\n")
upper <- res_wide[res_wide$partner %in% upper_sysbp_partners, ]
upper <- upper[order(upper$nABCD_sysbp), ]
for (i in seq_len(nrow(upper))) {
  r <- upper[i, ]
  cat(sprintf("R%d: IQR=%.1f, nABCD=%.4f, L*(1%%pt)=%.5f, L*(2%%pt)=%.5f\n",
              r$partner, r$iqr_sysbp, r$nABCD_sysbp,
              r$Lstar_sysbp_1pct, r$Lstar_sysbp_2pct))
}

cat("\nDone.\n")
