source("projects/similarity-metric/R/figures_paper.R")
out <- OUTPUT_DIR

# Fig 1: nABCD definition (legend now on right outside panels)
ggsave(file.path(out, "fig1_nabcd_definition.png"),
       fig2_nabcd_definition("greyscale"), width = 7, height = 3, dpi = 300, bg = "white")
ggsave(file.path(out, "fig1_nabcd_definition.pdf"),
       fig2_nabcd_definition("greyscale"), width = 7, height = 3, bg = "white")
ggsave(file.path(out, "fig1_nabcd_definition_color.png"),
       fig2_nabcd_definition("color"), width = 7, height = 3, dpi = 300, bg = "white")
ggsave(file.path(out, "fig1_nabcd_definition_color.pdf"),
       fig2_nabcd_definition("color"), width = 7, height = 3, bg = "white")

# Fig 2: combined simulation (legend bottom with reduced margin)
ggsave(file.path(out, "fig2_simulation_results.png"),
       fig_combo_simulation("greyscale", "horizontal"),
       width = 10, height = 3.5, dpi = 300, bg = "white")
ggsave(file.path(out, "fig2_simulation_results.pdf"),
       fig_combo_simulation("greyscale", "horizontal"),
       width = 10, height = 3.5, bg = "white")
ggsave(file.path(out, "fig2_simulation_results_color.png"),
       fig_combo_simulation("color", "horizontal"),
       width = 10, height = 3.5, dpi = 300, bg = "white")
ggsave(file.path(out, "fig2_simulation_results_color.pdf"),
       fig_combo_simulation("color", "horizontal"),
       width = 10, height = 3.5, bg = "white")

cat("fig1 and fig2 regenerated\n")
