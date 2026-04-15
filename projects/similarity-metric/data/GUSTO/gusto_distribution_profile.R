###############################################################################
# GUSTO-I Distribution Profile
# Purpose: Explore variable distributions (overall and by region)
# Data: predtools::gusto (N=40,830, 16 regions)
# Output: Summary tables + PDF plots
###############################################################################

library(predtools)
library(dplyr)
library(tidyr)
library(ggplot2)
library(moments)   # skewness, kurtosis

# --- Output directory ---
out_dir <- "C:/Users/hrd13/Documents/Gak/0 Study/800Claude/20260210_SIM/similarity_metrics/projects/similarity-metric/data/GUSTO"

# --- Load data ---
data(gusto)

# Strip labelled class to avoid vctrs conflicts in pivot_longer
strip_labelled <- function(x) {
  if (inherits(x, "labelled")) {
    class(x) <- setdiff(class(x), "labelled")
  }
  x
}
gusto <- gusto %>% mutate(across(everything(), strip_labelled))

cat("=== GUSTO-I Data Overview ===\n")
cat("N =", nrow(gusto), "\n")
cat("Variables =", ncol(gusto), "\n\n")

###############################################################################
# 1. Variable inventory
###############################################################################
cat("============================================================\n")
cat("1. VARIABLE INVENTORY\n")
cat("============================================================\n\n")

var_info <- data.frame(
  variable = names(gusto),
  class    = sapply(gusto, function(x) paste(class(x), collapse = "/")),
  n_missing = sapply(gusto, function(x) sum(is.na(x))),
  pct_missing = sapply(gusto, function(x) round(100 * mean(is.na(x)), 2)),
  n_unique = sapply(gusto, function(x) length(unique(x[!is.na(x)]))),
  stringsAsFactors = FALSE
)
# Add labels where available
var_info$label <- sapply(gusto, function(x) {
  lb <- attr(x, "label")
  if (is.null(lb)) "" else lb
})
print(var_info, row.names = FALSE)
cat("\n")

###############################################################################
# 2. Overall distribution of continuous variables
###############################################################################
cat("============================================================\n")
cat("2. OVERALL DISTRIBUTION (Continuous Variables)\n")
cat("============================================================\n\n")

cont_vars <- c("age", "sysbp", "pulse", "height", "weight")

overall_stats <- gusto %>%
  select(all_of(cont_vars)) %>%
  pivot_longer(everything(), names_to = "variable", values_to = "value") %>%
  filter(!is.na(value)) %>%
  group_by(variable) %>%
  summarise(
    n        = n(),
    n_miss   = nrow(gusto) - n(),
    mean     = mean(value),
    sd       = sd(value),
    median   = median(value),
    Q1       = quantile(value, 0.25),
    Q3       = quantile(value, 0.75),
    IQR      = IQR(value),
    min      = min(value),
    max      = max(value),
    skewness = skewness(value),
    kurtosis = kurtosis(value),
    .groups  = "drop"
  ) %>%
  mutate(across(where(is.numeric), ~ round(.x, 3)))

print(as.data.frame(overall_stats), row.names = FALSE)
cat("\n")

# Normality assessment
cat("--- Normality Assessment ---\n")
cat("(Shapiro-Wilk on random subsample of 5000; skewness & kurtosis for full data)\n\n")
set.seed(42)
idx_sub <- sample(nrow(gusto), 5000)
for (v in cont_vars) {
  vals <- gusto[[v]]
  vals <- vals[!is.na(vals)]
  sw <- shapiro.test(vals[idx_sub[idx_sub <= length(vals)]])
  cat(sprintf("  %-8s  skew=%6.3f  kurt=%6.3f  Shapiro-Wilk W=%.5f  p=%s\n",
              v, skewness(vals), kurtosis(vals), sw$statistic,
              format.pval(sw$p.value, digits = 3)))
}
cat("\n")

# --- PDF: histograms + density ---
pdf(file.path(out_dir, "gusto_overall_distributions.pdf"), width = 10, height = 8)

plot_data <- gusto %>%
  select(all_of(cont_vars)) %>%
  pivot_longer(everything(), names_to = "variable", values_to = "value") %>%
  filter(!is.na(value))

# Add labels for facets
var_labels <- c(
  age    = "Age (years)",
  sysbp  = "Systolic BP (mmHg)",
  pulse  = "Pulse (beats/min)",
  height = "Height (cm)",
  weight = "Weight (kg)"
)
plot_data$var_label <- var_labels[plot_data$variable]

# Annotation data for each panel
anno <- overall_stats %>%
  mutate(
    var_label = var_labels[variable],
    label = sprintf("n=%s  mean=%.1f  sd=%.1f\nmedian=%.1f  IQR=%.1f\nskew=%.2f  kurt=%.2f",
                    format(n, big.mark = ","), mean, sd, median, IQR, skewness, kurtosis)
  )

p1 <- ggplot(plot_data, aes(x = value)) +
  geom_histogram(aes(y = after_stat(density)), bins = 50,
                 fill = "steelblue", alpha = 0.6, colour = "white", linewidth = 0.2) +
  geom_density(colour = "darkred", linewidth = 0.8) +
  facet_wrap(~ var_label, scales = "free", ncol = 3) +
  geom_text(data = anno, aes(label = label),
            x = Inf, y = Inf, hjust = 1.05, vjust = 1.2, size = 2.8,
            inherit.aes = FALSE) +
  labs(title = "GUSTO-I: Overall Distribution of Continuous Variables",
       subtitle = sprintf("N = %s", format(nrow(gusto), big.mark = ",")),
       x = NULL, y = "Density") +
  theme_minimal(base_size = 11) +
  theme(strip.text = element_text(face = "bold"))

print(p1)
dev.off()
cat("Saved: gusto_overall_distributions.pdf\n\n")

###############################################################################
# 3. Regional distribution
###############################################################################
cat("============================================================\n")
cat("3. REGIONAL DISTRIBUTION\n")
cat("============================================================\n\n")

# Region sample sizes
cat("--- Region Sample Sizes ---\n")
reg_n <- gusto %>% count(regl, name = "n") %>% arrange(regl)
print(as.data.frame(reg_n), row.names = FALSE)
cat("\n")

# Summary statistics by region
regional_stats <- gusto %>%
  select(regl, all_of(cont_vars)) %>%
  pivot_longer(-regl, names_to = "variable", values_to = "value") %>%
  filter(!is.na(value)) %>%
  group_by(regl, variable) %>%
  summarise(
    n        = n(),
    mean     = round(mean(value), 2),
    sd       = round(sd(value), 2),
    median   = round(median(value), 1),
    skewness = round(skewness(value), 3),
    kurtosis = round(kurtosis(value), 3),
    .groups  = "drop"
  )

cat("--- Regional Summary (mean, sd, skewness) ---\n")
for (v in cont_vars) {
  cat(sprintf("\n[%s]\n", v))
  tbl <- regional_stats %>%
    filter(variable == v) %>%
    select(regl, n, mean, sd, skewness, kurtosis) %>%
    as.data.frame()
  print(tbl, row.names = FALSE)
}
cat("\n")

# --- PDF: Regional Boxplots ---
pdf(file.path(out_dir, "gusto_regional_boxplots.pdf"), width = 12, height = 9)

for (v in cont_vars) {
  pdata <- gusto %>%
    select(regl, value = !!sym(v)) %>%
    filter(!is.na(value)) %>%
    mutate(regl = factor(regl))

  # Region-level means for overlay
  rmeans <- pdata %>% group_by(regl) %>% summarise(m = mean(value), .groups = "drop")
  grand_mean <- mean(pdata$value)

  p <- ggplot(pdata, aes(x = regl, y = value)) +
    geom_boxplot(fill = "steelblue", alpha = 0.5, outlier.size = 0.5, outlier.alpha = 0.3) +
    geom_point(data = rmeans, aes(x = regl, y = m),
               colour = "red", size = 2.5, shape = 18) +
    geom_hline(yintercept = grand_mean, linetype = "dashed", colour = "red", linewidth = 0.5) +
    labs(title = sprintf("GUSTO-I: %s by Region", var_labels[v]),
         subtitle = "Red diamond = regional mean; dashed line = grand mean",
         x = "Region (regl)", y = var_labels[v]) +
    theme_minimal(base_size = 12) +
    theme(panel.grid.minor = element_blank())

  print(p)
}

dev.off()
cat("Saved: gusto_regional_boxplots.pdf\n\n")

# --- PDF: Regional Density Overlays ---
pdf(file.path(out_dir, "gusto_regional_density.pdf"), width = 12, height = 9)

# Use a palette that works for 16 regions
region_cols <- c(
  "#E41A1C", "#377EB8", "#4DAF4A", "#984EA3", "#FF7F00", "#FFFF33",
  "#A65628", "#F781BF", "#999999", "#66C2A5", "#FC8D62", "#8DA0CB",
  "#E78AC3", "#A6D854", "#FFD92F", "#B3B3B3"
)

for (v in cont_vars) {
  pdata <- gusto %>%
    select(regl, value = !!sym(v)) %>%
    filter(!is.na(value)) %>%
    mutate(regl = factor(regl))

  p <- ggplot(pdata, aes(x = value, colour = regl)) +
    geom_density(linewidth = 0.6, alpha = 0.8) +
    scale_colour_manual(values = region_cols, name = "Region") +
    labs(title = sprintf("GUSTO-I: %s — Density by Region", var_labels[v]),
         x = var_labels[v], y = "Density") +
    theme_minimal(base_size = 12) +
    theme(legend.position = "right",
          panel.grid.minor = element_blank())

  print(p)
}

dev.off()
cat("Saved: gusto_regional_density.pdf\n\n")

###############################################################################
# 4. Distribution characteristics & nABCD-relevant findings
###############################################################################
cat("============================================================\n")
cat("4. DISTRIBUTION CHARACTERISTICS & nABCD RELEVANCE\n")
cat("============================================================\n\n")

# 4a. Non-normality ranking (overall)
cat("--- Non-normality Ranking (|skewness| + |excess kurtosis|) ---\n")
nonnorm <- overall_stats %>%
  mutate(excess_kurt = kurtosis - 3,
         nonnorm_score = abs(skewness) + abs(excess_kurt)) %>%
  arrange(desc(nonnorm_score)) %>%
  select(variable, skewness, kurtosis, excess_kurt, nonnorm_score)
print(as.data.frame(nonnorm), row.names = FALSE)
cat("\n")

# 4b. Regional heterogeneity in skewness
cat("--- Regional Heterogeneity in Skewness (SD of regional skewness) ---\n")
skew_het <- regional_stats %>%
  group_by(variable) %>%
  summarise(
    mean_skew = round(mean(skewness), 3),
    sd_skew   = round(sd(skewness), 3),
    range_skew = round(max(skewness) - min(skewness), 3),
    .groups = "drop"
  ) %>%
  arrange(desc(sd_skew))
print(as.data.frame(skew_het), row.names = FALSE)
cat("\n")

# 4c. Regional heterogeneity in kurtosis
cat("--- Regional Heterogeneity in Kurtosis (SD of regional kurtosis) ---\n")
kurt_het <- regional_stats %>%
  group_by(variable) %>%
  summarise(
    mean_kurt = round(mean(kurtosis), 3),
    sd_kurt   = round(sd(kurtosis), 3),
    range_kurt = round(max(kurtosis) - min(kurtosis), 3),
    .groups = "drop"
  ) %>%
  arrange(desc(sd_kurt))
print(as.data.frame(kurt_het), row.names = FALSE)
cat("\n")

# 4d. SMD vs shape differences — identify variables where means/SDs are similar
#     across regions but shapes differ
cat("--- Variables Where SMD May Miss Shape Differences ---\n")
cat("(Small SD of regional means, but large SD of regional skewness/kurtosis)\n\n")

shape_vs_location <- regional_stats %>%
  group_by(variable) %>%
  summarise(
    cv_mean  = round(sd(mean) / mean(mean) * 100, 2),   # CV of regional means (%)
    sd_skew  = round(sd(skewness), 3),
    sd_kurt  = round(sd(kurtosis), 3),
    .groups  = "drop"
  ) %>%
  mutate(shape_signal = round(sd_skew + sd_kurt / 10, 3)) %>%
  arrange(desc(shape_signal))
print(as.data.frame(shape_vs_location), row.names = FALSE)
cat("\n")

cat("============================================================\n")
cat("DONE. All PDFs saved to:\n")
cat(out_dir, "\n")
cat("============================================================\n")
