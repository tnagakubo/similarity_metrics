source("projects/similarity-metric/R/figures_paper.R")
out <- OUTPUT_DIR

# Paper Figure 1
ggsave(file.path(out, "fig1_nabcd_definition.png"),
       fig2_nabcd_definition("greyscale"), width = 7, height = 3, dpi = 300, bg = "white")
ggsave(file.path(out, "fig1_nabcd_definition.pdf"),
       fig2_nabcd_definition("greyscale"), width = 7, height = 3, bg = "white")
ggsave(file.path(out, "fig1_nabcd_definition_color.png"),
       fig2_nabcd_definition("color"), width = 7, height = 3, dpi = 300, bg = "white")
ggsave(file.path(out, "fig1_nabcd_definition_color.pdf"),
       fig2_nabcd_definition("color"), width = 7, height = 3, bg = "white")

# Paper Figure 2
ggsave(file.path(out, "fig2_bias.png"),
       fig3_bias("greyscale"), width = 7, height = 3.5, dpi = 300, bg = "white")
ggsave(file.path(out, "fig2_bias.pdf"),
       fig3_bias("greyscale"), width = 7, height = 3.5, bg = "white")
ggsave(file.path(out, "fig2_bias_color.png"),
       fig3_bias("color"), width = 7, height = 3.5, dpi = 300, bg = "white")
ggsave(file.path(out, "fig2_bias_color.pdf"),
       fig3_bias("color"), width = 7, height = 3.5, bg = "white")

# Paper Figure 3
ggsave(file.path(out, "fig3_estimation_quality.png"),
       fig4_estimation_quality("greyscale"), width = 7, height = 2.92, dpi = 300, bg = "white")
ggsave(file.path(out, "fig3_estimation_quality.pdf"),
       fig4_estimation_quality("greyscale"), width = 7, height = 2.92, bg = "white")
ggsave(file.path(out, "fig3_estimation_quality_color.png"),
       fig4_estimation_quality("color"), width = 7, height = 2.92, dpi = 300, bg = "white")
ggsave(file.path(out, "fig3_estimation_quality_color.pdf"),
       fig4_estimation_quality("color"), width = 7, height = 2.92, bg = "white")

cat("All paper figures (1-3) regenerated\n")
