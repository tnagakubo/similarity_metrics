# =============================================================================
# Validation Analysis — 4 Experiments (E1-E4)
# Reads: results/normalizer_comparison_validation.rds
# Produces:
#   1. fig_e1_em_invariance     — Pure EM-invariance verification
#   2. fig_e2_shape_sensitivity — Multi-shape SMD differentiation
#   3. fig_e3_outlier_curve     — Outlier breakdown curve (0-10%)
#   4. fig_e4_monotonicity      — Monotonicity check across delta
#   5. fig_validation_summary   — Multi-criterion decision summary
# Console: detailed numerical tables per experiment.
# =============================================================================
suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
  library(tidyr)
  library(patchwork)
})

source("projects/similarity-metric/R/figures_paper.R", chdir = FALSE)

g <- readRDS("results/normalizer_comparison_validation.rds")
true_all <- readRDS("results/true_validation.rds")
smd_all  <- readRDS("results/smd_validation.rds")

NORMS <- c("IQR", "Q95Q5", "SD", "MAD", "Range")
OUTPUT_DIR <- "projects/similarity-metric/figures"

# Helper: scenario -> experiment + parameters
parse_scenario <- function(s) {
  if (startsWith(s, "E1_")) {
    parts <- strsplit(sub("^E1_", "", s), "_d")[[1]]
    return(list(exp = "E1", em = parts[1], delta = as.numeric(parts[2])))
  }
  if (startsWith(s, "E2_")) return(list(exp = "E2", subgroup = s))
  if (startsWith(s, "E3_")) {
    p <- as.integer(sub("^E3_p", "", s))
    return(list(exp = "E3", outlier_pct = p))
  }
  if (startsWith(s, "E4_")) {
    d <- as.numeric(sub("^E4_d", "", s))
    return(list(exp = "E4", delta = d))
  }
  list(exp = NA)
}

g$exp <- sapply(g$scenario, function(s) parse_scenario(s)$exp)

# =============================================================================
# E1: Pure EM-invariance
# =============================================================================
cat("=========================================================\n")
cat(" E1: Pure EM-invariance (standardized 3 EMs)\n")
cat("=========================================================\n")

e1 <- g[g$exp == "E1" & g$normalizer != "SMD", ]
e1$em    <- sapply(e1$scenario, function(s) parse_scenario(s)$em)
e1$delta <- sapply(e1$scenario, function(s) parse_scenario(s)$delta)

# True nABCD per (em x delta x normalizer)
true_e1 <- data.frame()
for (s in names(true_all)) {
  if (startsWith(s, "E1_")) {
    p <- parse_scenario(s)
    for (norm in NORMS) {
      true_e1 <- rbind(true_e1, data.frame(
        em = p$em, delta = p$delta, normalizer = norm,
        true_nABCD = unname(true_all[[s]][norm])
      ))
    }
  }
}

cat("\n--- Truth: true_nABCD per (delta x EM x normalizer) [E1] ---\n")
for (norm in NORMS) {
  cat(sprintf("\n=== %s ===\n", norm))
  sub <- true_e1[true_e1$normalizer == norm, c("em", "delta", "true_nABCD")]
  wide <- reshape(sub, idvar = "delta", timevar = "em", direction = "wide")
  wide <- wide[order(wide$delta), ]
  mat  <- as.matrix(wide[, -1])
  wide$mean_nABCD <- apply(mat, 1, mean)
  wide$CV     <- round(apply(mat, 1, function(r) sd(r) / mean(r)), 4)
  rownames(wide) <- NULL
  names(wide) <- gsub("^true_nABCD\\.", "", names(wide))
  print(wide, row.names = FALSE)
}

# E1 EM-invariance summary (truth)
cat("\n--- EM-invariance summary (truth, mean CV across 3 deltas) ---\n")
e1_cv_truth <- data.frame(normalizer = NORMS, mean_CV_truth = NA_real_)
for (i in seq_along(NORMS)) {
  norm <- NORMS[i]
  sub <- true_e1[true_e1$normalizer == norm, ]
  cvs <- c()
  for (d in unique(sub$delta)) {
    vals <- sub$true_nABCD[sub$delta == d]
    cvs <- c(cvs, sd(vals) / mean(vals))
  }
  e1_cv_truth$mean_CV_truth[i] <- mean(cvs)
}
e1_cv_truth <- e1_cv_truth[order(e1_cv_truth$mean_CV_truth), ]
print(e1_cv_truth, row.names = FALSE)

# Figure: E1 EM-invariance (lines)
p1 <- ggplot(true_e1,
             aes(x = delta, y = true_nABCD,
                 color = factor(em, levels = c("gauss", "t5", "gamma")),
                 group = em, shape = factor(em, levels = c("gauss", "t5", "gamma")))) +
  geom_line(linewidth = 0.7) +
  geom_point(size = 2.5) +
  facet_wrap(~ normalizer, scales = "free_y", ncol = 3) +
  scale_x_continuous(breaks = c(0.25, 0.5, 1.0)) +
  scale_color_manual(values = c(gauss = "#0072B2", t5 = "#D55E00", gamma = "#009E73"),
                       name = "EM intrinsic shape") +
  scale_shape_manual(values = c(gauss = 16, t5 = 17, gamma = 15),
                       name = "EM intrinsic shape") +
  labs(x = expression(paste(delta, " (standardized location shift)")),
       y = "Population true nABCD",
       title = "E1: Pure EM-invariance — 3 standardized EMs",
       subtitle = "Same effective shift across EMs; lines overlapping = scale-equivariant normalizer") +
  theme(legend.position = "bottom")

ggsave(file.path(OUTPUT_DIR, "fig_e1_em_invariance.png"), p1,
       width = 10, height = 6, dpi = 300, bg = "white")
ggsave(file.path(OUTPUT_DIR, "fig_e1_em_invariance.pdf"), p1,
       width = 10, height = 6, bg = "white")

# =============================================================================
# E2: Multi-shape sensitivity
# =============================================================================
cat("\n\n=========================================================\n")
cat(" E2: Multi-shape sensitivity (5 pairs, SMD ~ 0.5)\n")
cat("=========================================================\n")

e2 <- g[g$exp == "E2", ]

true_e2 <- data.frame()
for (s in names(true_all)) {
  if (startsWith(s, "E2_")) {
    pop_smd <- smd_all$population_smd[smd_all$scenario == s]
    for (norm in NORMS) {
      true_e2 <- rbind(true_e2, data.frame(
        scenario = s, normalizer = norm,
        true_nABCD = unname(true_all[[s]][norm]),
        pop_smd = pop_smd
      ))
    }
  }
}

cat("\n--- Truth: true_nABCD per (scenario x normalizer) [E2] ---\n")
wide_e2 <- reshape(true_e2[, c("scenario", "normalizer", "true_nABCD")],
                   idvar = "scenario", timevar = "normalizer", direction = "wide")
names(wide_e2) <- gsub("^true_nABCD\\.", "", names(wide_e2))
smd_e2_uniq <- unique(true_e2[, c("scenario", "pop_smd")])
wide_e2 <- merge(smd_e2_uniq, wide_e2, by = "scenario")
print(wide_e2, row.names = FALSE)

# E2 SMD-sensitivity summary: max - min of nABCD across 5 pairs per normalizer
cat("\n--- Shape sensitivity (max nABCD - min nABCD across 5 pairs) ---\n")
e2_shape <- data.frame(normalizer = NORMS, range = NA_real_, ratio = NA_real_)
for (i in seq_along(NORMS)) {
  norm <- NORMS[i]
  vals <- true_e2$true_nABCD[true_e2$normalizer == norm]
  e2_shape$range[i] <- max(vals) - min(vals)
  e2_shape$ratio[i] <- (max(vals) - min(vals)) / mean(vals)
}
e2_shape <- e2_shape[order(e2_shape$range, decreasing = TRUE), ]
print(e2_shape, row.names = FALSE)

p2 <- ggplot(true_e2,
             aes(x = scenario, y = true_nABCD, fill = normalizer)) +
  geom_col(position = position_dodge(0.85), width = 0.78) +
  scale_fill_manual(values = .normalizer_palette("color")) +
  labs(x = "Scenario (all with SMD ~ 0.5)",
       y = "Population true nABCD",
       fill = "Normalizer",
       title = "E2: Multi-shape sensitivity at fixed SMD",
       subtitle = "Bars varying within color = normalizer detects F2 shape; flat = blind") +
  theme(legend.position = "bottom",
        axis.text.x = element_text(size = rel(0.75)))

ggsave(file.path(OUTPUT_DIR, "fig_e2_shape_sensitivity.png"), p2,
       width = 9, height = 5.5, dpi = 300, bg = "white")
ggsave(file.path(OUTPUT_DIR, "fig_e2_shape_sensitivity.pdf"), p2,
       width = 9, height = 5.5, bg = "white")

# =============================================================================
# E3: Outlier breakdown curve
# =============================================================================
cat("\n\n=========================================================\n")
cat(" E3: Outlier breakdown curve (0%, 1%, 2%, 3%, 5%, 7%, 10%)\n")
cat("=========================================================\n")

e3 <- g[g$exp == "E3" & g$normalizer != "SMD", ]
e3$outlier_pct <- sapply(e3$scenario, function(s) as.integer(sub("^E3_p", "", s)))

cat("\n--- Coverage at n=200 per (outlier_pct x normalizer) ---\n")
e3_n200 <- e3[e3$n == 200, c("outlier_pct", "normalizer", "coverage_pct")]
wide_e3 <- reshape(e3_n200, idvar = "outlier_pct", timevar = "normalizer", direction = "wide")
wide_e3 <- wide_e3[order(wide_e3$outlier_pct), ]
names(wide_e3) <- gsub("^coverage_pct\\.", "cov.", names(wide_e3))
print(wide_e3, row.names = FALSE)

p3 <- ggplot(e3,
             aes(x = outlier_pct, y = coverage_pct, color = normalizer, group = normalizer)) +
  geom_line(linewidth = 0.8) +
  geom_point(size = 2.5) +
  geom_hline(yintercept = 0.95, linetype = "dashed", color = "grey30", alpha = 0.8) +
  facet_wrap(~ paste0("n=", n), ncol = 3) +
  scale_color_manual(values = .normalizer_palette("color")) +
  scale_x_continuous(breaks = c(0, 1, 2, 3, 5, 7, 10)) +
  scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.2)) +
  labs(x = "Outlier contamination (%)",
       y = "Bootstrap CI coverage",
       color = "Normalizer",
       title = "E3: Outlier breakdown curve",
       subtitle = "Dashed line: nominal 95%. Higher curve = robust to contamination.") +
  theme(legend.position = "bottom")

ggsave(file.path(OUTPUT_DIR, "fig_e3_outlier_curve.png"), p3,
       width = 10, height = 5, dpi = 300, bg = "white")
ggsave(file.path(OUTPUT_DIR, "fig_e3_outlier_curve.pdf"), p3,
       width = 10, height = 5, bg = "white")

# =============================================================================
# E4: Monotonicity sweep
# =============================================================================
cat("\n\n=========================================================\n")
cat(" E4: Monotonicity sweep (delta = 0 ... 2.0, Gaussian)\n")
cat("=========================================================\n")

e4 <- g[g$exp == "E4" & g$normalizer != "SMD" & g$n == 100, ]
e4$delta <- sapply(e4$scenario, function(s) as.numeric(sub("^E4_d", "", s)))

cat("\n--- True nABCD vs delta (n=100) ---\n")
true_e4 <- data.frame()
for (s in names(true_all)) {
  if (startsWith(s, "E4_")) {
    d <- as.numeric(sub("^E4_d", "", s))
    for (norm in NORMS) {
      true_e4 <- rbind(true_e4, data.frame(
        delta = d, normalizer = norm,
        true_nABCD = unname(true_all[[s]][norm])
      ))
    }
  }
}
wide_e4 <- reshape(true_e4, idvar = "delta", timevar = "normalizer", direction = "wide")
wide_e4 <- wide_e4[order(wide_e4$delta), ]
names(wide_e4) <- gsub("^true_nABCD\\.", "", names(wide_e4))
print(wide_e4, row.names = FALSE)

# Monotonicity check: differences between consecutive deltas
cat("\n--- Monotonicity check: diff between consecutive deltas (truth) ---\n")
for (norm in NORMS) {
  sub <- true_e4[true_e4$normalizer == norm, c("delta", "true_nABCD")]
  sub <- sub[order(sub$delta), ]
  diffs <- diff(sub$true_nABCD)
  all_pos <- all(diffs > -1e-4)
  cat(sprintf("  %-6s monotone-up: %s  (min diff = %.4f, max diff = %.4f)\n",
              norm, ifelse(all_pos, "YES", "NO"),
              min(diffs), max(diffs)))
}

p4 <- ggplot(true_e4,
             aes(x = delta, y = true_nABCD, color = normalizer, group = normalizer)) +
  geom_line(linewidth = 0.8) +
  geom_point(size = 2.5) +
  scale_color_manual(values = .normalizer_palette("color")) +
  scale_x_continuous(breaks = c(0, 0.1, 0.2, 0.3, 0.5, 0.7, 1.0, 1.5, 2.0)) +
  labs(x = expression(paste(delta, " (location shift, sigma=1)")),
       y = "Population true nABCD",
       color = "Normalizer",
       title = "E4: Monotonicity sweep — nABCD vs delta",
       subtitle = "Monotone increasing required (F2 more dissimilar from F1 -> nABCD up)") +
  theme(legend.position = "bottom")

ggsave(file.path(OUTPUT_DIR, "fig_e4_monotonicity.png"), p4,
       width = 8, height = 5, dpi = 300, bg = "white")
ggsave(file.path(OUTPUT_DIR, "fig_e4_monotonicity.pdf"), p4,
       width = 8, height = 5, bg = "white")

cat("\n\nAll 4 validation figures saved:\n")
cat("  fig_e1_em_invariance.{png,pdf}\n")
cat("  fig_e2_shape_sensitivity.{png,pdf}\n")
cat("  fig_e3_outlier_curve.{png,pdf}\n")
cat("  fig_e4_monotonicity.{png,pdf}\n")
