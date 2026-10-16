source("projects/similarity-metric/R/figures_paper.R")
out <- OUTPUT_DIR
ggsave(file.path(out, "fig1_nabcd_definition.png"),
       fig2_nabcd_definition("greyscale"), width = 7, height = 3, dpi = 300, bg = "white")
ggsave(file.path(out, "fig1_nabcd_definition.pdf"),
       fig2_nabcd_definition("greyscale"), width = 7, height = 3, bg = "white")
ggsave(file.path(out, "fig1_nabcd_definition_color.png"),
       fig2_nabcd_definition("color"), width = 7, height = 3, dpi = 300, bg = "white")
ggsave(file.path(out, "fig1_nabcd_definition_color.pdf"),
       fig2_nabcd_definition("color"), width = 7, height = 3, bg = "white")
cat("regenerated successfully\n")
