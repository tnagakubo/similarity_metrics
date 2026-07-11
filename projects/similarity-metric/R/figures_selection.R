# =============================================================================
# Figures for the pooling simulations — Part 1 (selection) and Part 2 (clustering)
# Author: Katrina Bennett
#
# Reads:
#   results/selection_sim_summary.csv   (selection_simulation.R)   -> Part 1
#   results/clustering_sim_summary.csv  (clustering_simulation.R)  -> Part 2
#
# Paper standards (feedback_figure_paper_standard.md):
#   theme_bw(base_size = 11); width 7"; white bg; greyscale palette.
# Identity is encoded by colour + linetype + point shape together, so series
# are distinguishable in greyscale / print / CVD (dataviz: never colour-alone).
# Captions describe what is plotted, not results (feedback_caption_writing.md).
#
# Figures:
#   fig_selection_false_pooling.{pdf,png} — false-pooling@k vs n, by method,
#       one panel per scenario family.
#   fig_selection_auc_by_type.{pdf,png}   — AUC (match vs discordant) vs n, by
#       method, faceted family x discordance type; 0.5 = chance/blind reference.
#   fig_clustering_ari.{pdf,png}          — adjusted Rand index vs n, by method,
#       one panel per family; 0 = chance reference.
# Each also written with a `_color` suffix for slides.
# =============================================================================

suppressPackageStartupMessages({
  library(ggplot2); library(dplyr); library(readr)
})

# ---- paths (resolved at RUNTIME, robust to source(chdir=TRUE) / Rscript) ----
.SELF <- local({
  f <- NULL
  for (fr in rev(sys.frames())) if (!is.null(fr$ofile)) { f <- fr$ofile; break }
  if (is.null(f)) { a <- commandArgs(FALSE); fa <- sub("^--file=", "", a[grepl("^--file=", a)]); if (length(fa)) f <- fa[1] }
  if (is.null(f)) NA_character_ else tryCatch(normalizePath(f, mustWork = FALSE), error = function(e) f)
})
.script_dir <- function() if (is.na(.SELF)) NA_character_ else dirname(.SELF)
.first_existing <- function(paths) { p <- paths[!is.na(paths) & file.exists(paths)]; if (length(p)) p[1] else NA_character_ }

resolve_csv <- function(base) .first_existing(c(
  file.path("results", base),
  file.path("../results", base),
  file.path("projects/similarity-metric/results", base),
  if (!is.na(.script_dir())) file.path(.script_dir(), "..", "results", base)))
resolve_output_dir <- function() {
  sd <- .script_dir()
  if (!is.na(sd)) file.path(sd, "..", "figures")
  else if (dir.exists("projects/similarity-metric")) "projects/similarity-metric/figures"
  else "figures"
}

# ---- labels / levels -------------------------------------------------------
# W1 first (hero); KOM/KOM3 are the Komiyama representative-value baselines.
METHOD_LEVELS <- c("W1", "KS", "KOM", "KOM3", "SMD_log", "SMD")
METHOD_LABELS <- c(W1 = "W[1]", KS = "KS",
                   KOM = "'RV (mean, SD)'", KOM3 = "'RV (mean, SD, skew)'",
                   SMD_log = "'SMD (log)'", SMD = "'SMD (raw)'")
FAMILY_LABELS <- c(Set1_Gaussian  = "Set 1: Gaussian world",
                   Set2_LogNormal = "Set 2: Log-normal world",
                   Set3_Mixture   = "Set 3: Mixture world (moment-matched)")
TYPE_LABELS   <- c(location   = "Location",
                   scale      = "Scale",
                   shape      = "Shape/dispersion",
                   shape_sym  = "Shape, mean+SD+skew matched",
                   shape_skew = "Shape, mean+SD matched",
                   combined   = "Combined")

.pal <- function(palette = c("greyscale", "color")) {
  palette <- match.arg(palette)
  col <- if (palette == "color")
    c(W1 = "#D52B1E", KS = "#0072B2", KOM = "#009E73", KOM3 = "#66C2A5",
      SMD_log = "#E69F00", SMD = "#999999")
  else
    c(W1 = "#1A1A1A", KS = "#4D4D4D", KOM = "#737373", KOM3 = "#969696",
      SMD_log = "#BDBDBD", SMD = "#D9D9D9")
  list(color = col,
       linetype = c(W1 = "solid", KS = "dashed", KOM = "dotdash", KOM3 = "twodash",
                    SMD_log = "longdash", SMD = "dotted"),
       shape    = c(W1 = 16, KS = 17, KOM = 15, KOM3 = 18, SMD_log = 3, SMD = 4))
}

.theme <- theme_bw(base_size = 11) +
  theme(panel.grid.minor = element_blank(),
        panel.grid.major = element_line(color = "grey92"),
        strip.background = element_rect(fill = "grey95", color = NA),
        strip.text = element_text(size = rel(0.8)),
        legend.position = "bottom",
        axis.title = element_text(size = rel(0.95)),
        axis.text = element_text(size = rel(0.82), color = "black"),
        legend.title = element_text(size = rel(0.85)),
        legend.text = element_text(size = rel(0.85)),
        plot.background = element_rect(fill = "white", color = NA),
        panel.background = element_rect(fill = "white", color = NA))

.method_scales <- function(pal, present) {
  lv <- METHOD_LEVELS[METHOD_LEVELS %in% present]
  list(scale_color_manual(values = pal$color[lv], labels = parse(text = METHOD_LABELS[lv]),
                          name = "Method", breaks = lv, drop = TRUE),
       scale_linetype_manual(values = pal$linetype[lv], labels = parse(text = METHOD_LABELS[lv]),
                             name = "Method", breaks = lv, drop = TRUE),
       scale_shape_manual(values = pal$shape[lv], labels = parse(text = METHOD_LABELS[lv]),
                          name = "Method", breaks = lv, drop = TRUE))
}

# ---- data ------------------------------------------------------------------
.load <- function(base) {
  csv <- resolve_csv(base)
  if (is.na(csv)) stop(base, " not found (cwd=", getwd(), ")")
  df <- read_csv(csv, show_col_types = FALSE)
  stopifnot(all(df$method %in% METHOD_LEVELS), all(df$set %in% names(FAMILY_LABELS)))
  df$method <- factor(df$method, levels = METHOD_LEVELS)
  df$family <- factor(FAMILY_LABELS[df$set], levels = FAMILY_LABELS)
  df
}
load_selection  <- function() .load("selection_sim_summary.csv")
load_clustering <- function() .load("clustering_sim_summary.csv")

# ---- Figure 1: false-pooling@k vs n (Part 1) -------------------------------
fig_false_pooling <- function(df, palette = "greyscale") {
  pal <- .pal(palette)
  d <- df %>% filter(measure == "false_pooling_at_k") %>% droplevels()
  ggplot(d, aes(n, value, color = method, linetype = method, shape = method, group = method)) +
    geom_line(linewidth = 0.5) + geom_point(size = 1.8) +
    facet_wrap(~ family) +
    scale_x_continuous(breaks = c(25, 50, 75, 100)) +
    scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.2)) +
    .method_scales(pal, levels(d$method)) +
    labs(x = "n per country", y = "False-pooling rate (top-k)") +
    .theme + guides(color = guide_legend(nrow = 1))
}

# ---- Figure 2: AUC vs n, by discordance type (Part 1) ----------------------
fig_auc_by_type <- function(df, palette = "greyscale") {
  pal <- .pal(palette)
  d <- df %>% filter(measure == "auc") %>% droplevels()
  facet_order <- c("Set1_Gaussian|location",  "Set1_Gaussian|scale",       "Set1_Gaussian|combined",
                   "Set2_LogNormal|location", "Set2_LogNormal|shape",      "Set2_LogNormal|combined",
                   "Set3_Mixture|shape_sym",  "Set3_Mixture|shape_skew",   "Set3_Mixture|combined")
  present <- facet_order[facet_order %in% paste(d$set, d$type, sep = "|")]
  d <- d %>% mutate(fk = paste(set, type, sep = "|"),
                    facet = factor(fk, levels = present,
                                   labels = paste0(FAMILY_LABELS[sub("\\|.*", "", present)], "\n",
                                                   TYPE_LABELS[sub(".*\\|", "", present)])))
  ggplot(d, aes(n, value, color = method, linetype = method, shape = method, group = method)) +
    geom_hline(yintercept = 0.5, linetype = "dashed", color = "grey60", linewidth = 0.4) +
    geom_line(linewidth = 0.5) + geom_point(size = 1.8) +
    facet_wrap(~ facet, ncol = 3) +
    scale_x_continuous(breaks = c(25, 50, 75, 100)) +
    scale_y_continuous(limits = c(0.35, 1), breaks = seq(0.4, 1, 0.2)) +
    .method_scales(pal, levels(d$method)) +
    labs(x = "n per country", y = "AUC (true match vs discordant)") +
    .theme + guides(color = guide_legend(nrow = 1))
}

# ---- Figure 3: adjusted Rand index vs n (Part 2) ---------------------------
fig_clustering_ari <- function(df, palette = "greyscale") {
  pal <- .pal(palette)
  d <- df %>% filter(measure == "ari") %>% droplevels()
  ggplot(d, aes(n, value, color = method, linetype = method, shape = method, group = method)) +
    geom_hline(yintercept = 0, linetype = "dashed", color = "grey60", linewidth = 0.4) +
    geom_line(linewidth = 0.5) + geom_point(size = 1.8) +
    facet_wrap(~ family) +
    scale_x_continuous(breaks = c(25, 50, 75, 100)) +
    scale_y_continuous(limits = c(-0.05, 1), breaks = seq(0, 1, 0.2)) +
    .method_scales(pal, levels(d$method)) +
    labs(x = "n per country", y = "Adjusted Rand index") +
    .theme + guides(color = guide_legend(nrow = 1))
}

# ---- generate --------------------------------------------------------------
generate_all_figures <- function(output_dir = resolve_output_dir()) {
  dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)
  sel <- load_selection(); clu <- load_clustering()
  message("[figures] selection : ", resolve_csv("selection_sim_summary.csv"))
  message("[figures] clustering: ", resolve_csv("clustering_sim_summary.csv"))
  message("[figures] output    : ", output_dir)
  specs <- list(
    list(fn = fig_false_pooling,  df = sel, name = "fig_selection_false_pooling", w = 7.2, h = 3.6),
    list(fn = fig_auc_by_type,    df = sel, name = "fig_selection_auc_by_type",   w = 7.2, h = 6.4),
    list(fn = fig_clustering_ari, df = clu, name = "fig_clustering_ari",          w = 7.2, h = 3.6))
  for (s in specs) for (pal in c("greyscale", "color")) {
    suffix <- if (pal == "color") "_color" else ""
    p <- s$fn(s$df, pal)
    ggsave(file.path(output_dir, paste0(s$name, suffix, ".pdf")), p, width = s$w, height = s$h, bg = "white")
    ggsave(file.path(output_dir, paste0(s$name, suffix, ".png")), p, width = s$w, height = s$h, dpi = 300, bg = "white")
  }
  message("[figures] done.")
  invisible(list(selection = sel, clustering = clu))
}

if (sys.nframe() == 0L) generate_all_figures()
