# =============================================================================
# Detailed comparison: E1 (Pure) vs Grid 2 (Realistic) scenario setup
# Tak directive 2026-05-12: ranking reversal between E1 (SD CV=0.4%) and
# Grid 2 (Q95Q5 CV=2.7%) demands a clear setup comparison.
# =============================================================================
SKIP_SIMULATION <- TRUE  # Must be set BEFORE sourcing any kernel
suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
  library(tidyr)
  library(patchwork)
})

# Source generators
source("projects/similarity-metric/R/simulation_manuscript_v2.R", chdir = TRUE)
source("projects/similarity-metric/R/scenarios_validation.R",    chdir = TRUE)
source("projects/similarity-metric/R/cross_em_generators.R",      chdir = TRUE)

OUTPUT_DIR <- "projects/similarity-metric/figures"
N_MC <- 1e5

# =============================================================================
# Part 1: Print the actual generator code side-by-side
# =============================================================================
cat("================================================================\n")
cat(" Setup Comparison: E1 (Pure) vs Grid 2 (Realistic)\n")
cat("================================================================\n")

cat("\n--- E1: Pure EM-invariance test (all standardized) ---\n")
cat("All EMs are standardized to (mean=0, var=1) BEFORE applying location shift.\n")
cat("Δ is the location shift in STANDARDIZED units (i.e. Δ * σ_intrinsic = Δ * 1 = Δ).\n\n")
cat("  E1_gauss:  F1 = N(0,1)                       F2 = N(Δ, 1)\n")
cat("  E1_t5:     F1 = t(5)/sqrt(5/3)               F2 = t(5)/sqrt(5/3) + Δ\n")
cat("  E1_gamma:  F1 = [Gamma(0.5,2) - 1]/sqrt(2)   F2 = same + Δ\n")
cat("  Δ in {0.25, 0.5, 1.0}\n\n")

cat("--- Grid 2: Realistic clinical scenarios ---\n")
cat("Each EM keeps its REALISTIC clinical scale (mean, sd, shape).\n")
cat("Δσ is the location shift in EACH EM's NATIVE σ (i.e. Δσ * σ_native).\n\n")
cat("  age:        F1 = N(60, 15²)              F2 = N(60 + Δσ·15, 15²)\n")
cat("  sbp:        F1 = 140 + 20·t(5)/sqrt(5/3)  F2 = F1 + Δσ·20\n")
cat("  creatinine: F1 = LogN(0, 0.5²)            F2 = LogN(Δσ·0.5, 0.5²)\n")
cat("              (shift on log scale -> multiplicative on raw scale)\n")
cat("  Δσ in {0.25, 0.5, 1.0}\n\n")

# =============================================================================
# Part 2: Empirical moments of F1 (and pooled F1+F2 normalizers)
# at Δ = 0.5 (the representative delta) for both setups
# =============================================================================
cat("================================================================\n")
cat(" Empirical moments at Δ = 0.5 (n_mc = 1e5)\n")
cat("================================================================\n")

NORMS <- c("IQR", "Q95Q5", "SD", "MAD", "Range")

compute_moments <- function(x1, x2) {
  pooled <- c(x1, x2)
  list(
    n          = length(x1),
    mean_F1    = mean(x1),
    sd_F1      = sd(x1),
    mean_F2    = mean(x2),
    sd_F2      = sd(x2),
    mean_pool  = mean(pooled),
    sd_pool    = sd(pooled),
    IQR_pool   = IQR(pooled),
    Q95Q5_pool = unname(diff(quantile(pooled, c(0.05, 0.95)))),
    MAD_pool   = median(abs(pooled - median(pooled))),
    Range_pool = diff(range(pooled)),
    W1         = wasserstein1(x1, x2)
  )
}

set.seed(42)

cat("\n--- E1 (Δ = 0.5) ---\n")
e1_moments <- list()
for (em in c("gauss", "t5", "gamma")) {
  key <- sprintf("E1_%s_d0.5", em)
  sc <- scenarios_validation[[key]]
  x1 <- sc$dist1(N_MC); x2 <- sc$dist2(N_MC)
  m <- compute_moments(x1, x2)
  e1_moments[[em]] <- m
}
e1_df <- do.call(rbind, lapply(names(e1_moments), function(em) {
  m <- e1_moments[[em]]
  data.frame(EM = em,
             mean_F1 = round(m$mean_F1, 4), sd_F1 = round(m$sd_F1, 4),
             mean_F2 = round(m$mean_F2, 4), sd_F2 = round(m$sd_F2, 4),
             sd_pool = round(m$sd_pool, 4), IQR_pool = round(m$IQR_pool, 4),
             Q95Q5_pool = round(m$Q95Q5_pool, 4),
             MAD_pool = round(m$MAD_pool, 4), Range_pool = round(m$Range_pool, 4),
             W1 = round(m$W1, 4))
}))
print(e1_df, row.names = FALSE)

cat("\n  -> All EMs have F1: mean=0, sd≈1 (standardized).\n")
cat("  -> pooled SD ≈ sqrt(1 + Δ²/4) ≈ 1.03 (CONSTANT across EMs).\n")
cat("  -> W₁ ≈ Δ = 0.5 for all (since variance matched).\n")
cat("  -> SD-normalized nABCD = W₁/SD_pool ≈ 0.5/1.03 ≈ 0.485 for ALL EMs\n")
cat("     => SD is trivially EM-invariant when EMs are standardized.\n")

cat("\n--- Grid 2 (Δσ = 0.5) ---\n")
grid2_moments <- list()
for (em in c("age", "sbp", "creatinine")) {
  sc <- make_cross_em_scenario(em, 0.5)
  x1 <- sc$dist1(N_MC); x2 <- sc$dist2(N_MC)
  m <- compute_moments(x1, x2)
  grid2_moments[[em]] <- m
}
g2_df <- do.call(rbind, lapply(names(grid2_moments), function(em) {
  m <- grid2_moments[[em]]
  data.frame(EM = em,
             mean_F1 = round(m$mean_F1, 3), sd_F1 = round(m$sd_F1, 3),
             mean_F2 = round(m$mean_F2, 3), sd_F2 = round(m$sd_F2, 3),
             sd_pool = round(m$sd_pool, 3), IQR_pool = round(m$IQR_pool, 3),
             Q95Q5_pool = round(m$Q95Q5_pool, 3),
             MAD_pool = round(m$MAD_pool, 3), Range_pool = round(m$Range_pool, 3),
             W1 = round(m$W1, 3))
}))
print(g2_df, row.names = FALSE)

cat("\n  -> EMs have VERY different absolute scales:\n")
cat("       age:        sd≈15,   IQR≈20\n")
cat("       sbp:        sd≈20,   IQR≈22\n")
cat("       creatinine: sd≈0.5,  IQR≈0.6  (different by ~30x)\n")
cat("  -> W₁ ALSO differs: age≈7.5, sbp≈10, creatinine≈0.32 (in raw units)\n")
cat("  -> SD-nABCD ratio depends on relative shift vs spread variation per EM\n")
cat("     => Not trivially EM-invariant; adaptive normalizers (Q95Q5) win.\n")

# =============================================================================
# Part 3: nABCD per (EM × normalizer) at Δ = 0.5 — compare directly
# =============================================================================
cat("\n================================================================\n")
cat(" nABCD per (EM × normalizer) at Δ = 0.5\n")
cat("================================================================\n")

build_nABCD_table <- function(moments_list) {
  rows <- list()
  for (em in names(moments_list)) {
    m <- moments_list[[em]]
    rows[[em]] <- data.frame(
      EM = em,
      IQR   = m$W1 / m$IQR_pool,
      Q95Q5 = m$W1 / m$Q95Q5_pool,
      SD    = m$W1 / m$sd_pool,
      MAD   = m$W1 / m$MAD_pool,
      Range = m$W1 / m$Range_pool
    )
  }
  do.call(rbind, rows)
}

cat("\n--- E1 (Δ = 0.5) ---\n")
e1_n <- build_nABCD_table(e1_moments)
for (col in NORMS) e1_n[[col]] <- round(e1_n[[col]], 4)
print(e1_n, row.names = FALSE)
cat("CV across 3 EMs:\n")
for (col in NORMS) {
  v <- e1_n[[col]]
  cat(sprintf("  %-6s mean=%.4f  CV=%.4f\n", col, mean(v), sd(v) / mean(v)))
}

cat("\n--- Grid 2 (Δσ = 0.5) ---\n")
g2_n <- build_nABCD_table(grid2_moments)
for (col in NORMS) g2_n[[col]] <- round(g2_n[[col]], 4)
print(g2_n, row.names = FALSE)
cat("CV across 3 EMs:\n")
for (col in NORMS) {
  v <- g2_n[[col]]
  cat(sprintf("  %-6s mean=%.4f  CV=%.4f\n", col, mean(v), sd(v) / mean(v)))
}

# =============================================================================
# Part 4: Visualize the F1 (and F2) densities side-by-side
# =============================================================================
set.seed(42)
samples_data <- data.frame()
for (em in c("gauss", "t5", "gamma")) {
  key <- sprintf("E1_%s_d0.5", em)
  sc <- scenarios_validation[[key]]
  x1 <- sc$dist1(50000); x2 <- sc$dist2(50000)
  samples_data <- rbind(samples_data,
    data.frame(setup = "E1 (Pure / standardized)",
               EM = em, group = "F1", value = x1),
    data.frame(setup = "E1 (Pure / standardized)",
               EM = em, group = "F2", value = x2))
}
for (em in c("age", "sbp", "creatinine")) {
  sc <- make_cross_em_scenario(em, 0.5)
  x1 <- sc$dist1(50000); x2 <- sc$dist2(50000)
  samples_data <- rbind(samples_data,
    data.frame(setup = "Grid 2 (Realistic)",
               EM = em, group = "F1", value = x1),
    data.frame(setup = "Grid 2 (Realistic)",
               EM = em, group = "F2", value = x2))
}
samples_data$EM <- factor(samples_data$EM,
                            levels = c("gauss", "t5", "gamma", "age", "sbp", "creatinine"))

p_e1 <- ggplot(subset(samples_data, setup == "E1 (Pure / standardized)"),
               aes(x = value, fill = group)) +
  geom_density(alpha = 0.45) +
  facet_wrap(~ EM, scales = "free", ncol = 3) +
  scale_fill_manual(values = c(F1 = "#0072B2", F2 = "#D55E00")) +
  labs(x = "Standardized value", y = "Density",
       title = "E1: Pure / standardized (mean=0, var=1) — same Δ=0.5",
       subtitle = "All 3 EMs have identical first two moments; only shape differs.") +
  theme(legend.position = "bottom")

p_g2 <- ggplot(subset(samples_data, setup == "Grid 2 (Realistic)"),
               aes(x = value, fill = group)) +
  geom_density(alpha = 0.45) +
  facet_wrap(~ EM, scales = "free", ncol = 3) +
  scale_fill_manual(values = c(F1 = "#0072B2", F2 = "#D55E00")) +
  labs(x = "Native clinical units", y = "Density",
       title = "Grid 2: Realistic clinical (native scale) — same Δσ=0.5",
       subtitle = "EMs have very different mean, sd, and shape.") +
  theme(legend.position = "bottom")

combined <- p_e1 / p_g2
ggsave(file.path(OUTPUT_DIR, "fig_setup_comparison.png"), combined,
       width = 11, height = 8, dpi = 300, bg = "white")
ggsave(file.path(OUTPUT_DIR, "fig_setup_comparison.pdf"), combined,
       width = 11, height = 8, bg = "white")

cat("\n\nFigure saved: fig_setup_comparison.{png,pdf}\n")
