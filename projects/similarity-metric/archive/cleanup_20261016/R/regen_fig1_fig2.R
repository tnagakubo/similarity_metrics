source("projects/similarity-metric/R/figures_paper.R")
out <- OUTPUT_DIR

# slide_scenario_overview: 9 scenarios (S1-S9) in 3x3 layout. Paper omits this fig.
ggsave(file.path(out, "slide_scenario_overview.png"),
       fig1_scenario_overview("greyscale"), width = 10, height = 8, dpi = 300)
ggsave(file.path(out, "slide_scenario_overview.pdf"),
       fig1_scenario_overview("greyscale"), width = 10, height = 8)
ggsave(file.path(out, "slide_scenario_overview_color.png"),
       fig1_scenario_overview("color"),     width = 10, height = 8, dpi = 300)
ggsave(file.path(out, "slide_scenario_overview_color.pdf"),
       fig1_scenario_overview("color"),     width = 10, height = 8)

# fig1_nabcd_definition (paper Fig 1): greyscale (paper) + color (slides)
ggsave(file.path(out, "fig1_nabcd_definition.png"),
       fig2_nabcd_definition("greyscale"),  width = 7,  height = 3, dpi = 300)
ggsave(file.path(out, "fig1_nabcd_definition.pdf"),
       fig2_nabcd_definition("greyscale"),  width = 7,  height = 3)
ggsave(file.path(out, "fig1_nabcd_definition_color.png"),
       fig2_nabcd_definition("color"),      width = 7,  height = 3, dpi = 300)
ggsave(file.path(out, "fig1_nabcd_definition_color.pdf"),
       fig2_nabcd_definition("color"),      width = 7,  height = 3)

# fig2_bias (paper Fig 2): greyscale (paper) + color (slides); unified width 7 in
ggsave(file.path(out, "fig2_bias.png"),
       fig3_bias("greyscale"),              width = 7, height = 3.5, dpi = 300)
ggsave(file.path(out, "fig2_bias.pdf"),
       fig3_bias("greyscale"),              width = 7, height = 3.5)
ggsave(file.path(out, "fig2_bias_color.png"),
       fig3_bias("color"),                  width = 7, height = 3.5, dpi = 300)
ggsave(file.path(out, "fig2_bias_color.pdf"),
       fig3_bias("color"),                  width = 7, height = 3.5)

# fig3_estimation_quality (paper Fig 3): greyscale (paper) + color (slides)
# Combined Coverage + Precision; unified width 7 in (preserves 12:5 = 2.4:1 aspect)
ggsave(file.path(out, "fig3_estimation_quality.png"),
       fig4_estimation_quality("greyscale"), width = 7, height = 2.92, dpi = 300)
ggsave(file.path(out, "fig3_estimation_quality.pdf"),
       fig4_estimation_quality("greyscale"), width = 7, height = 2.92)
ggsave(file.path(out, "fig3_estimation_quality_color.png"),
       fig4_estimation_quality("color"),     width = 7, height = 2.92, dpi = 300)
ggsave(file.path(out, "fig3_estimation_quality_color.pdf"),
       fig4_estimation_quality("color"),     width = 7, height = 2.92)

message("fig1_nabcd_definition, fig2_bias, fig3_estimation_quality (and slide_scenario_overview) versions generated.")
