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
# W1 first (hero). RV1 = the representative-value distance of Komiyama Ch.4 as
# written (one summary per effect modifier). RV2/RV3 are extensions the chapter
# does NOT propose -- we grant them in advance as the natural reviewer rebuttal.
# The labels say "RV", never "Komiyama", for RV2/RV3 (EXISTING_METHODS_AND_NOVELTY.md §3).
METHOD_LEVELS <- c("W1", "KS", "RV1", "RV2", "RV3", "SMD_log", "SMD")
METHOD_LABELS <- c(W1 = "W[1]", KS = "KS",
                   RV1 = "'RV: mean (Ch.4)'", RV2 = "'RV: +SD'", RV3 = "'RV: +SD, skew'",
                   SMD_log = "'SMD (log)'", SMD = "'SMD (raw)'")
FAMILY_LABELS <- c(Set1_Gaussian  = "Set 1: Gaussian world",
                   Set2_LogNormal = "Set 2: Log-normal world",
                   Set3_Mixture   = "Set 3: Mixture world (moment-matched)",
                   Set4_Extremes  = "Set 4: Extremes world (rare displaced mass)")
TYPE_LABELS   <- c(location       = "Location",
                   scale          = "Scale",
                   shape          = "Shape/dispersion",
                   shape_sym      = "Shape, mean+SD+skew matched",
                   shape_skew     = "Shape, mean+SD matched",
                   combined       = "Combined",
                   sym_severity   = "Extremes further out (mean matched)",
                   sym_prevalence = "More patients extreme (mean matched)",
                   asym_severity  = "One extreme further out",
                   bulk_shift     = "Location shift of everyone")

.pal <- function(palette = c("greyscale", "color")) {
  palette <- match.arg(palette)
  col <- if (palette == "color")
    c(W1 = "#D52B1E", KS = "#0072B2", RV1 = "#006D4F", RV2 = "#009E73", RV3 = "#66C2A5",
      SMD_log = "#E69F00", SMD = "#999999")
  else
    c(W1 = "#1A1A1A", KS = "#4D4D4D", RV1 = "#666666", RV2 = "#8C8C8C", RV3 = "#A6A6A6",
      SMD_log = "#BDBDBD", SMD = "#D9D9D9")
  list(color = col,
       linetype = c(W1 = "solid", KS = "dashed", RV1 = "dotdash", RV2 = "twodash",
                    RV3 = "longdash", SMD_log = "1272", SMD = "dotted"),
       shape    = c(W1 = 16, KS = 17, RV1 = 15, RV2 = 18, RV3 = 8, SMD_log = 3, SMD = 4))
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
# .fig_auc() renders whichever (set|type) facets it is handed, so Sets 1-3 (which
# share the "which moment is discordant" question) go in one figure and Set 4 (which
# asks the separate W1-vs-KS question, and has four types) gets its own.
.fig_auc <- function(df, facet_order, palette, ncol) {
  pal <- .pal(palette)
  d <- df %>% filter(measure == "auc") %>%
    filter(paste(set, type, sep = "|") %in% facet_order) %>% droplevels()
  present <- facet_order[facet_order %in% paste(d$set, d$type, sep = "|")]
  d <- d %>% mutate(fk = paste(set, type, sep = "|"),
                    facet = factor(fk, levels = present,
                                   labels = paste0(FAMILY_LABELS[sub("\\|.*", "", present)], "\n",
                                                   TYPE_LABELS[sub(".*\\|", "", present)])))
  ggplot(d, aes(n, value, color = method, linetype = method, shape = method, group = method)) +
    geom_hline(yintercept = 0.5, linetype = "dashed", color = "grey60", linewidth = 0.4) +
    geom_line(linewidth = 0.5) + geom_point(size = 1.8) +
    facet_wrap(~ facet, ncol = ncol) +
    scale_x_continuous(breaks = c(25, 50, 75, 100)) +
    scale_y_continuous(limits = c(0.35, 1), breaks = seq(0.4, 1, 0.2)) +
    .method_scales(pal, levels(d$method)) +
    labs(x = "n per country", y = "AUC (true match vs discordant)") +
    .theme + guides(color = guide_legend(nrow = 1))
}
FACETS_123 <- c("Set1_Gaussian|location",  "Set1_Gaussian|scale",     "Set1_Gaussian|combined",
                "Set2_LogNormal|location", "Set2_LogNormal|shape",    "Set2_LogNormal|combined",
                "Set3_Mixture|shape_sym",  "Set3_Mixture|shape_skew", "Set3_Mixture|combined")
FACETS_4   <- c("Set4_Extremes|sym_severity", "Set4_Extremes|sym_prevalence",
                "Set4_Extremes|asym_severity", "Set4_Extremes|bulk_shift")
fig_auc_by_type <- function(df, palette = "greyscale") .fig_auc(df, FACETS_123, palette, 3)
fig_auc_set4    <- function(df, palette = "greyscale") .fig_auc(df, FACETS_4,   palette, 4)

# ---- Figure 2c: clinical harm vs n (Part 1, lens A) -------------------------
# E[max true W1 among the countries the method chose to pool], in EM units.
# Multiply by L_clinical to read the y-axis as Delta_max: the worst-case regional
# treatment-effect difference the selected pool still admits, over EVERY Lipschitz
# theta (KR bound -- theta-free, so this does not reopen the rejected Part 3).
# 0 = perfect, because true matches have true W1 = 0 by construction.
fig_harm <- function(df, palette = "greyscale") {
  pal <- .pal(palette)
  d <- df %>% filter(measure == "harm_maxW1") %>% droplevels()
  ggplot(d, aes(n, value, color = method, linetype = method, shape = method, group = method)) +
    geom_hline(yintercept = 0, linetype = "dashed", color = "grey60", linewidth = 0.4) +
    geom_line(linewidth = 0.5) + geom_point(size = 1.8) +
    facet_wrap(~ family, scales = "free_y") +
    scale_x_continuous(breaks = c(25, 50, 75, 100)) +
    .method_scales(pal, levels(d$method)) +
    labs(x = "n per country",
         y = expression(paste("E[max true ", W[1], " in chosen pool]  (EM units; ",
                              times, " ", L[clinical], " = ", Delta[max], ")"))) +
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
    list(fn = fig_false_pooling,  df = sel, name = "fig_selection_false_pooling", w = 7.2, h = 5.2),
    list(fn = fig_auc_by_type,    df = sel, name = "fig_selection_auc_by_type",   w = 7.2, h = 6.4),
    list(fn = fig_auc_set4,       df = sel, name = "fig_selection_auc_set4",      w = 7.2, h = 3.0),
    list(fn = fig_harm,           df = sel, name = "fig_selection_harm",          w = 7.2, h = 5.4),
    list(fn = fig_clustering_ari, df = clu, name = "fig_clustering_ari",          w = 7.2, h = 5.4))
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
