# =============================================================================
# Regenerate per-normalizer simulation results figures (4 separate files)
# Source: results/normalizer_comparison_grid1.rds
# Each metric (bias / rmse / coverage / width) gets its own figure with
# 5 normalizers compared side-by-side, faceted by sample size.
# =============================================================================
source("projects/similarity-metric/R/figures_paper.R")
out <- OUTPUT_DIR
W <- 7; H <- 7

# --- Bias ---
ggsave(file.path(out, "fig2_simulation_bias.png"),
       fig_normalizer_bias("greyscale"), width = W, height = H, dpi = 300, bg = "white")
ggsave(file.path(out, "fig2_simulation_bias.pdf"),
       fig_normalizer_bias("greyscale"), width = W, height = H, bg = "white")
ggsave(file.path(out, "fig2_simulation_bias_color.png"),
       fig_normalizer_bias("color"),     width = W, height = H, dpi = 300, bg = "white")
ggsave(file.path(out, "fig2_simulation_bias_color.pdf"),
       fig_normalizer_bias("color"),     width = W, height = H, bg = "white")

# --- RMSE ---
ggsave(file.path(out, "fig3_simulation_rmse.png"),
       fig_normalizer_rmse("greyscale"), width = W, height = H, dpi = 300, bg = "white")
ggsave(file.path(out, "fig3_simulation_rmse.pdf"),
       fig_normalizer_rmse("greyscale"), width = W, height = H, bg = "white")
ggsave(file.path(out, "fig3_simulation_rmse_color.png"),
       fig_normalizer_rmse("color"),     width = W, height = H, dpi = 300, bg = "white")
ggsave(file.path(out, "fig3_simulation_rmse_color.pdf"),
       fig_normalizer_rmse("color"),     width = W, height = H, bg = "white")

# --- Coverage ---
ggsave(file.path(out, "fig4_simulation_coverage.png"),
       fig_normalizer_coverage("greyscale"), width = W, height = H, dpi = 300, bg = "white")
ggsave(file.path(out, "fig4_simulation_coverage.pdf"),
       fig_normalizer_coverage("greyscale"), width = W, height = H, bg = "white")
ggsave(file.path(out, "fig4_simulation_coverage_color.png"),
       fig_normalizer_coverage("color"),     width = W, height = H, dpi = 300, bg = "white")
ggsave(file.path(out, "fig4_simulation_coverage_color.pdf"),
       fig_normalizer_coverage("color"),     width = W, height = H, bg = "white")

# --- CI Width ---
ggsave(file.path(out, "fig5_simulation_width.png"),
       fig_normalizer_width("greyscale"), width = W, height = H, dpi = 300, bg = "white")
ggsave(file.path(out, "fig5_simulation_width.pdf"),
       fig_normalizer_width("greyscale"), width = W, height = H, bg = "white")
ggsave(file.path(out, "fig5_simulation_width_color.png"),
       fig_normalizer_width("color"),     width = W, height = H, dpi = 300, bg = "white")
ggsave(file.path(out, "fig5_simulation_width_color.pdf"),
       fig_normalizer_width("color"),     width = W, height = H, bg = "white")

cat("Per-normalizer simulation figures regenerated:\n")
cat("  fig2_simulation_bias.{png,pdf} (+ _color)\n")
cat("  fig3_simulation_rmse.{png,pdf} (+ _color)\n")
cat("  fig4_simulation_coverage.{png,pdf} (+ _color)\n")
cat("  fig5_simulation_width.{png,pdf} (+ _color)\n")
