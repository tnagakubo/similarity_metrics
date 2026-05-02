source("projects/similarity-metric/R/figures_paper.R")
out <- OUTPUT_DIR
ggsave(file.path(out, "fig2_bias.png"), fig3_bias("greyscale"), width = 7, height = 3.5, dpi = 300, bg = "white")
ggsave(file.path(out, "fig2_bias.pdf"), fig3_bias("greyscale"), width = 7, height = 3.5, bg = "white")
ggsave(file.path(out, "fig2_bias_color.png"), fig3_bias("color"), width = 7, height = 3.5, dpi = 300, bg = "white")
ggsave(file.path(out, "fig2_bias_color.pdf"), fig3_bias("color"), width = 7, height = 3.5, bg = "white")
cat("fig2 regen done\n")
