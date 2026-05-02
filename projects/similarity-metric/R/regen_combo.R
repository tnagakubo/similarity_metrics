source("projects/similarity-metric/R/figures_paper.R")
out <- OUTPUT_DIR

# Pattern 1: Horizontal 1x3
ggsave(file.path(out, "preview_combo_horizontal.png"),
       fig_combo_simulation("greyscale", "horizontal"),
       width = 10, height = 3.5, dpi = 300, bg = "white")
ggsave(file.path(out, "preview_combo_horizontal.pdf"),
       fig_combo_simulation("greyscale", "horizontal"),
       width = 10, height = 3.5, bg = "white")

# Pattern 2: Vertical 3x1
ggsave(file.path(out, "preview_combo_vertical.png"),
       fig_combo_simulation("greyscale", "vertical"),
       width = 6, height = 8, dpi = 300, bg = "white")
ggsave(file.path(out, "preview_combo_vertical.pdf"),
       fig_combo_simulation("greyscale", "vertical"),
       width = 6, height = 8, bg = "white")

# Pattern 3: L-shape (A on top full, B|C below)
ggsave(file.path(out, "preview_combo_L.png"),
       fig_combo_simulation("greyscale", "L"),
       width = 7, height = 6, dpi = 300, bg = "white")
ggsave(file.path(out, "preview_combo_L.pdf"),
       fig_combo_simulation("greyscale", "L"),
       width = 7, height = 6, bg = "white")

cat("3 combo layout previews generated\n")
