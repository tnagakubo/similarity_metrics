source("projects/similarity-metric/R/figures_paper.R")
out <- OUTPUT_DIR

# Slide-only figures (greyscale + color)

# scenario overview
ggsave(file.path(out, "slide_scenario_overview.png"),
       fig1_scenario_overview("greyscale"), width = 10, height = 5, dpi = 300, bg = "white")
ggsave(file.path(out, "slide_scenario_overview.pdf"),
       fig1_scenario_overview("greyscale"), width = 10, height = 5, bg = "white")
ggsave(file.path(out, "slide_scenario_overview_color.png"),
       fig1_scenario_overview("color"), width = 10, height = 5, dpi = 300, bg = "white")
ggsave(file.path(out, "slide_scenario_overview_color.pdf"),
       fig1_scenario_overview("color"), width = 10, height = 5, bg = "white")

# bias panel
ggsave(file.path(out, "slide_bias.png"),
       fig3_bias("greyscale"), width = 7, height = 3.5, dpi = 300, bg = "white")
ggsave(file.path(out, "slide_bias.pdf"),
       fig3_bias("greyscale"), width = 7, height = 3.5, bg = "white")
ggsave(file.path(out, "slide_bias_color.png"),
       fig3_bias("color"), width = 7, height = 3.5, dpi = 300, bg = "white")
ggsave(file.path(out, "slide_bias_color.pdf"),
       fig3_bias("color"), width = 7, height = 3.5, bg = "white")

# estimation quality
ggsave(file.path(out, "slide_estimation_quality.png"),
       fig4_estimation_quality("greyscale"), width = 7, height = 2.92, dpi = 300, bg = "white")
ggsave(file.path(out, "slide_estimation_quality.pdf"),
       fig4_estimation_quality("greyscale"), width = 7, height = 2.92, bg = "white")
ggsave(file.path(out, "slide_estimation_quality_color.png"),
       fig4_estimation_quality("color"), width = 7, height = 2.92, dpi = 300, bg = "white")
ggsave(file.path(out, "slide_estimation_quality_color.pdf"),
       fig4_estimation_quality("color"), width = 7, height = 2.92, bg = "white")

cat("Slide-only figures regenerated\n")
