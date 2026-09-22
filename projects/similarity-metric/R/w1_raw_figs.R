# =============================================================================
# W1 raw simulation — quick visualization (bias / coverage / RMSE / CI width)
# Author: Katrina Bennett
# Date: 2026-05-16
#
# Quick four-panel diagnostic plot for the W1 operating characteristics
# (NOT a paper figure: paper fig2 is R/fig2_bar_chart.R).
#
# 2026-09-22 (Mike): two fixes.
#   (a) Paths are resolved relative to THIS script's location, not the cwd. The
#       repo-root results/ tree was archived to archives/results_root_20260516/,
#       so the old cwd-relative "results/w1_raw_simulation.rds" made the script
#       stop() from anywhere except the old repo root.
#   (b) The summary plotted is now the canonical CSV
#         projects/similarity-metric/results/w1_raw_summary.csv
#       (exact-quadrature S6/S7 truth; see results/STUDY1_PROVENANCE.md), NOT
#       the rds's embedded `$summary`, which still carries the superseded
#       Monte-Carlo truth for S6/S7. The rds is read only for `$config`
#       (n_reps, B) used in the subtitle.
#
# No random number generation (nothing to seed): this only re-plots a stored
# summary, so re-running on the same CSV is deterministic.
#
# Inputs  (project-relative)
#   projects/similarity-metric/results/w1_raw_summary.csv     [canonical]
#   projects/similarity-metric/results/w1_raw_simulation.rds  [config only]
# Output  (project-relative; override with W1_FIGS_DIR for scratch runs)
#   projects/similarity-metric/figures/w1_raw_oc.{pdf,png}
# =============================================================================

SKIP_SIMULATION <- TRUE
suppressPackageStartupMessages({
  library(ggplot2)
  library(tidyr)
})

find_project_root <- function() {
  # script location (Rscript --file=... or source(); two levels up from R/)
  args  <- commandArgs(trailingOnly = FALSE)
  f_arg <- sub("^--file=", "", args[grepl("^--file=", args)])
  if (length(f_arg) > 0 && file.exists(f_arg)) {
    return(normalizePath(dirname(dirname(f_arg)), winslash = "/"))
  }
  ofile <- tryCatch(sys.frame(1)$ofile, error = function(e) NULL)
  if (!is.null(ofile)) {
    return(normalizePath(dirname(dirname(ofile)), winslash = "/"))
  }
  here   <- normalizePath(getwd(), winslash = "/", mustWork = FALSE)
  target <- file.path("projects", "similarity-metric")
  if (dir.exists(file.path(here, target))) {
    return(normalizePath(file.path(here, target), winslash = "/"))
  }
  here
}

PROJECT_ROOT <- find_project_root()
RESULTS_DIR  <- file.path(PROJECT_ROOT, "results")
IN_CSV       <- file.path(RESULTS_DIR, "w1_raw_summary.csv")
IN_RDS       <- file.path(RESULTS_DIR, "w1_raw_simulation.rds")
FIG_DIR      <- Sys.getenv("W1_FIGS_DIR",
                           unset = file.path(PROJECT_ROOT, "figures"))

message("[paths] canonical summary: ", IN_CSV)
message("[paths] rds (config only): ", IN_RDS)
message("[paths] output dir       : ", FIG_DIR)

if (!file.exists(IN_CSV)) {
  stop("Missing canonical summary ", IN_CSV,
       "\nRun w1_raw_simulation.R, then study1_summary_exact.R.")
}
if (!file.exists(IN_RDS)) {
  stop("Run w1_raw_simulation.R first; missing ", IN_RDS)
}

df  <- read.csv(IN_CSV, stringsAsFactors = FALSE)
cfg <- readRDS(IN_RDS)$config

df$scenario <- factor(df$scenario, levels = c("S1","S2","S3","S4","S5","S6","S7"))
df$n_f <- factor(df$n, levels = c(50, 100, 200))

# Long format for facet_grid
long <- pivot_longer(df,
  cols = c(bias, coverage_pct, rmse, mean_ci_width),
  names_to = "metric", values_to = "value")
long$metric <- factor(long$metric,
  levels = c("bias", "coverage_pct", "rmse", "mean_ci_width"),
  labels = c("Bias (W1 units)",
             "Coverage (95% CI)",
             "RMSE (W1 units)",
             "Mean CI width (W1 units)"))

p <- ggplot(long, aes(x = n, y = value, color = scenario, group = scenario)) +
  geom_line(linewidth = 0.6) +
  geom_point(size = 1.8) +
  facet_wrap(~ metric, scales = "free_y", ncol = 2) +
  scale_x_continuous(breaks = c(50, 100, 200)) +
  scale_color_brewer(palette = "Dark2") +
  labs(x = "n per group", y = NULL,
       title = "Sample W1 estimator: operating characteristics",
       subtitle = sprintf("n_reps = %d, B = %d, scenarios S1-S7",
                          cfg$n_reps, cfg$B),
       color = "Scenario") +
  theme_minimal(base_size = 11) +
  theme(plot.background = element_rect(fill = "white", color = NA),
        panel.grid.minor = element_blank())

# Add nominal coverage reference 0.95 only in the coverage panel
p <- p + geom_hline(data = data.frame(
                      metric = factor("Coverage (95% CI)",
                                       levels = levels(long$metric)),
                      yintercept = 0.95),
                    aes(yintercept = yintercept),
                    linetype = "dashed", color = "grey50")

if (!dir.exists(FIG_DIR)) dir.create(FIG_DIR, recursive = TRUE)

ggsave(file.path(FIG_DIR, "w1_raw_oc.pdf"),
       p, width = 7, height = 5.5, bg = "white")
ggsave(file.path(FIG_DIR, "w1_raw_oc.png"),
       p, width = 7, height = 5.5, dpi = 150, bg = "white")
cat("[save] ", file.path(FIG_DIR, "w1_raw_oc.pdf"), " / .png\n", sep = "")
