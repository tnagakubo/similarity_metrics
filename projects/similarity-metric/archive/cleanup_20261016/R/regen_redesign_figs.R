# =============================================================================
# Regenerate per-normalizer figures for redesigned scenarios (N1-N8)
# =============================================================================
source("projects/similarity-metric/R/figures_paper.R")
out <- OUTPUT_DIR
W <- 7; H <- 8

save4 <- function(stem, gen) {
  ggsave(file.path(out, paste0(stem, ".png")),       gen("greyscale"), width = W, height = H, dpi = 300, bg = "white")
  ggsave(file.path(out, paste0(stem, ".pdf")),       gen("greyscale"), width = W, height = H,            bg = "white")
  ggsave(file.path(out, paste0(stem, "_color.png")), gen("color"),     width = W, height = H, dpi = 300, bg = "white")
  ggsave(file.path(out, paste0(stem, "_color.pdf")), gen("color"),     width = W, height = H,            bg = "white")
}

save4("fig_redesign_bias",     function(p) fig_normalizer_bias(p,     grid = "redesign"))
save4("fig_redesign_rmse",     function(p) fig_normalizer_rmse(p,     grid = "redesign"))
save4("fig_redesign_coverage", function(p) fig_normalizer_coverage(p, grid = "redesign"))
save4("fig_redesign_width",    function(p) fig_normalizer_width(p,    grid = "redesign"))

cat("Redesign figures generated:\n")
cat("  fig_redesign_bias.{png,pdf} (+ _color)\n")
cat("  fig_redesign_rmse.{png,pdf} (+ _color)\n")
cat("  fig_redesign_coverage.{png,pdf} (+ _color)\n")
cat("  fig_redesign_width.{png,pdf} (+ _color)\n")
