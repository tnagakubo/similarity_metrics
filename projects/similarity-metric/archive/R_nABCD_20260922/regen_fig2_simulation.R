source("projects/similarity-metric/R/figures_paper.R")
out <- OUTPUT_DIR

# Production: combined simulation results (Bias | Coverage | CI Width) for paper Fig 2
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

cat("fig2_simulation_results (combined) generated\n")
