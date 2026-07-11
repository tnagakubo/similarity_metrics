# =============================================================================
# Figures for the pooling-partner SELECTION simulation
# Author: Katrina Bennett
#
# Reads results/selection_sim_summary.csv (produced by selection_simulation.R)
# and renders two paper figures + colour slide variants.
#
# Paper standards (feedback_figure_paper_standard.md):
#   theme_bw(base_size = 11); width 7"; white bg; greyscale palette.
# Identity is encoded by colour + linetype + point shape together, so series
# are distinguishable in greyscale / print / CVD (dataviz: never colour-alone).
# Captions describe what is plotted, not results (feedback_caption_writing.md).
#
# Figures:
#   fig_selection_false_pooling.{pdf,png}  — false-pooling@k vs n, by method,
#       one panel per scenario family.
#   fig_selection_auc_by_type.{pdf,png}    — AUC (match vs discordant) vs n, by
#       method, faceted family x discordance type; 0.5 = chance/blind reference.
# =============================================================================

suppressPackageStartupMessages({
  library(ggplot2); library(dplyr); library(tidyr); library(readr)
})

# ---- paths (resolved at RUNTIME, robust to source(chdir=TRUE) / Rscript) ----
# Capture a best-effort path to this script at load time (while ofile exists).
.SELF <- local({
  f <- NULL
  for (fr in rev(sys.frames())) if (!is.null(fr$ofile)) { f <- fr$ofile; break }
  if (is.null(f)) { a <- commandArgs(FALSE); fa <- sub("^--file=", "", a[grepl("^--file=", a)]); if (length(fa)) f <- fa[1] }
  if (is.null(f)) NA_character_ else tryCatch(normalizePath(f, mustWork = FALSE), error = function(e) f)
})
.script_dir <- function() if (is.na(.SELF)) NA_character_ else dirname(.SELF)
.first_existing <- function(paths) { p <- paths[!is.na(paths) & file.exists(paths)]; if (length(p)) p[1] else NA_character_ }

resolve_summary_csv <- function() .first_existing(c(
  "results/selection_sim_summary.csv",
  "../results/selection_sim_summary.csv",
  "projects/similarity-metric/results/selection_sim_summary.csv",
  if (!is.na(.script_dir())) file.path(.script_dir(), "..", "results", "selection_sim_summary.csv")))
resolve_output_dir <- function() {
  sd <- .script_dir()
  if (!is.na(sd)) file.path(sd, "..", "figures")
  else if (dir.exists("projects/similarity-metric")) "projects/similarity-metric/figures"
  else "figures"
}

# ---- labels / levels -------------------------------------------------------
METHOD_LEVELS <- c("W1", "KS", "SMD_log", "SMD")   # hero (W1) first for legend
METHOD_LABELS <- c(W1 = "W[1]", KS = "KS", SMD_log = "SMD (log)", SMD = "SMD (raw)")
FAMILY_LABELS <- c(Set1_Gaussian = "Set 1: Gaussian world",
                   Set2_LogNormal = "Set 2: Log-normal world")
TYPE_LABELS   <- c(location = "Location", scale = "Scale", shape = "Shape/dispersion",
                   combined = "Combined")

# greyscale + colour palettes; linetype/shape shared (secondary encoding)
.pal <- function(palette = c("greyscale", "color")) {
  palette <- match.arg(palette)
  col <- if (palette == "color")
    c(W1 = "#D52B1E", KS = "#0072B2", SMD_log = "#E69F00", SMD = "#999999")
  else
    c(W1 = "#1A1A1A", KS = "#737373", SMD_log = "#A6A6A6", SMD = "#BFBFBF")
  list(color = col,
       linetype = c(W1 = "solid", KS = "dashed", SMD_log = "dotdash", SMD = "dotted"),
       shape    = c(W1 = 16, KS = 17, SMD_log = 18, SMD = 15))
}

.theme <- theme_bw(base_size = 11) +
  theme(panel.grid.minor = element_blank(),
        panel.grid.major = element_line(color = "grey92"),
        strip.background = element_rect(fill = "grey95", color = NA),
        strip.text = element_text(size = rel(0.85)),
        legend.position = "bottom",
        axis.title = element_text(size = rel(0.95)),
        axis.text = element_text(size = rel(0.82), color = "black"),
        legend.title = element_text(size = rel(0.85)),
        legend.text = element_text(size = rel(0.85)),
        plot.background = element_rect(fill = "white", color = NA),
        panel.background = element_rect(fill = "white", color = NA))

# ---- data ------------------------------------------------------------------
load_selection <- function(csv = resolve_summary_csv()) {
  if (is.na(csv)) stop("selection_sim_summary.csv not found (cwd=", getwd(), ")")
  df <- read_csv(csv, show_col_types = FALSE)
  df$method <- factor(df$method, levels = METHOD_LEVELS)
  df$family <- factor(FAMILY_LABELS[df$set], levels = FAMILY_LABELS)
  df
}

.method_scales <- function(pal) list(
  scale_color_manual(values = pal$color,    labels = parse(text = METHOD_LABELS[METHOD_LEVELS]), name = "Method"),
  scale_linetype_manual(values = pal$linetype, labels = parse(text = METHOD_LABELS[METHOD_LEVELS]), name = "Method"),
  scale_shape_manual(values = pal$shape,    labels = parse(text = METHOD_LABELS[METHOD_LEVELS]), name = "Method"))

# ---- Figure 1: false-pooling@k vs n ---------------------------------------
fig_false_pooling <- function(df, palette = "greyscale") {
  pal <- .pal(palette)
  d <- df %>% filter(measure == "false_pooling_at_k")
  ggplot(d, aes(n, value, color = method, linetype = method, shape = method, group = method)) +
    geom_line(linewidth = 0.5) + geom_point(size = 1.9) +
    facet_wrap(~ family) +
    scale_x_continuous(breaks = c(25, 50, 75, 100)) +
    scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.2)) +
    .method_scales(pal) +
    labs(x = "n per country", y = "False-pooling rate (top-k)") +
    .theme
}

# ---- Figure 2: AUC vs n, by discordance type ------------------------------
fig_auc_by_type <- function(df, palette = "greyscale") {
  pal <- .pal(palette)
  d <- df %>% filter(measure == "auc")
  # facet order: Set1 (location, scale, combined) then Set2 (location, shape, combined)
  facet_order <- c("Set1_Gaussian|location","Set1_Gaussian|scale","Set1_Gaussian|combined",
                   "Set2_LogNormal|location","Set2_LogNormal|shape","Set2_LogNormal|combined")
  d <- d %>% mutate(fk = paste(set, type, sep = "|"),
                    facet = factor(fk, levels = facet_order,
                                   labels = paste0(FAMILY_LABELS[sub("\\|.*","",facet_order)],
                                                   "\n", TYPE_LABELS[sub(".*\\|","",facet_order)])))
  ggplot(d, aes(n, value, color = method, linetype = method, shape = method, group = method)) +
    geom_hline(yintercept = 0.5, linetype = "dashed", color = "grey60", linewidth = 0.4) +
    geom_line(linewidth = 0.5) + geom_point(size = 1.9) +
    facet_wrap(~ facet, ncol = 3) +
    scale_x_continuous(breaks = c(25, 50, 75, 100)) +
    scale_y_continuous(limits = c(0.45, 1), breaks = seq(0.5, 1, 0.1)) +
    .method_scales(pal) +
    labs(x = "n per country", y = "AUC (true match vs discordant)") +
    .theme
}

# ---- generate --------------------------------------------------------------
generate_selection_figures <- function(output_dir = resolve_output_dir()) {
  dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)
  df <- load_selection()
  message("[selection figures] csv   : ", resolve_summary_csv())
  message("[selection figures] output: ", output_dir)
  specs <- list(
    list(fn = fig_false_pooling, name = "fig_selection_false_pooling", w = 7,   h = 3.4),
    list(fn = fig_auc_by_type,   name = "fig_selection_auc_by_type",   w = 7.2, h = 4.8))
  for (s in specs) for (pal in c("greyscale", "color")) {
    suffix <- if (pal == "color") "_color" else ""
    p <- s$fn(df, pal)
    ggsave(file.path(output_dir, paste0(s$name, suffix, ".pdf")), p, width = s$w, height = s$h, bg = "white")
    ggsave(file.path(output_dir, paste0(s$name, suffix, ".png")), p, width = s$w, height = s$h, dpi = 300, bg = "white")
  }
  message("[selection figures] done.")
  invisible(df)
}

if (sys.nframe() == 0L) generate_selection_figures()
