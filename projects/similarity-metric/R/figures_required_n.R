# =============================================================================
# Figure: the three behaviours, made visible by extending n to 2000
# Author: Katrina Bennett
#
# This is the figure the production grid could not draw. At n <= 100 a blind
# method and a severely underpowered one look identical -- both sit near
# chance. Only the extension to n = 2000 separates them, and the separation is
# the paper's central taxonomy:
#
#   BLIND       flat AT chance all the way to n = 2000 (Set 3 RV/SMD)
#   PARTIAL     flat ABOVE chance, never reaching 1 (Set 4 RV2, Set 1 RV3)
#   RECOVERING  climbs to ~1; the question is only how much n it costs
#
# The log-x scale is what makes the reading immediate: a method that gains
# nothing from a 20-fold increase in n is not short of data.
#
# Reads:
#   results/clustering_sim_summary.csv      (n <= 100, production)
#   results/clustering_sim_summary_ext.csv  (n = 150..2000, extension)
#   results/selection_sim_summary{,_ext}.csv
#
# Paper standards (feedback_figure_paper_standard.md):
#   theme_bw(base_size = 11); width 7"; white bg; greyscale + `_color` variant.
# Identity is encoded by colour + linetype + shape together, so no series is
# distinguished by colour alone (greyscale / print / CVD).
#
# Figures:
#   fig_required_n_ari.{pdf,png}  — ARI vs n (log), one panel per scenario set,
#       with chance (0) and the ARI = 0.8 criterion marked.
#   fig_required_n_auc.{pdf,png}  — the same reading on the selection task,
#       for the two discordance types that separate the methods.
# =============================================================================

suppressPackageStartupMessages({ library(ggplot2); library(dplyr); library(readr) })

.SELF <- local({
  f <- NULL
  for (fr in rev(sys.frames())) if (!is.null(fr$ofile)) { f <- fr$ofile; break }
  if (is.null(f)) { a <- commandArgs(FALSE); fa <- sub("^--file=", "", a[grepl("^--file=", a)])
                    if (length(fa)) f <- fa[1] }
  if (is.null(f)) NA_character_ else tryCatch(normalizePath(f, mustWork = FALSE), error = function(e) f)
})
.dir  <- function() if (is.na(.SELF)) "." else dirname(.SELF)
.find <- function(b) { p <- c(file.path("results", b), file.path("../results", b),
                              file.path(.dir(), "..", "results", b))
                       p <- p[file.exists(p)]; if (!length(p)) stop(b, " not found"); p[1] }
.out  <- function() if (is.na(.SELF)) "figures" else file.path(.dir(), "..", "figures")

# Shared with figures_selection.R -- RV2/RV3 are labelled "RV", never
# "Komiyama": the chapter proposes RV1 only (EXISTING_METHODS_AND_NOVELTY.md).
METHOD_LEVELS <- c("W1", "KS", "RV1", "RV2", "RV3", "SMD")
METHOD_LABELS <- c(W1 = "W[1]", KS = "KS", RV1 = "'RV: mean (Ch.4)'",
                   RV2 = "'RV: +SD'", RV3 = "'RV: +SD, skew'", SMD = "'SMD'")
FAMILY_LABELS <- c(Set1_Gaussian  = "Set 1: Gaussian world",
                   Set2_LogNormal = "Set 2: Log-normal world",
                   Set3_Mixture   = "Set 3: Mixture world (moment-matched)",
                   Set4_Extremes  = "Set 4: Extremes world (rare displaced mass)")

.pal <- function(palette = c("greyscale", "color")) {
  palette <- match.arg(palette)
  col <- if (palette == "color")
    c(W1 = "#D52B1E", KS = "#0072B2", RV1 = "#006D4F", RV2 = "#009E73",
      RV3 = "#66C2A5", SMD = "#999999")
  else
    c(W1 = "#1A1A1A", KS = "#4D4D4D", RV1 = "#737373", RV2 = "#8C8C8C",
      RV3 = "#A6A6A6", SMD = "#C4C4C4")
  list(color = col,
       linetype = c(W1 = "solid", KS = "dashed", RV1 = "dotdash", RV2 = "twodash",
                    RV3 = "1272", SMD = "dotted"),
       shape = c(W1 = 16, KS = 17, RV1 = 15, RV2 = 18, RV3 = 8, SMD = 4))
}

.theme <- theme_bw(base_size = 11) +
  theme(panel.grid.minor = element_blank(),
        panel.grid.major = element_line(color = "grey92"),
        strip.background = element_rect(fill = "grey95", color = NA),
        strip.text = element_text(size = rel(0.8)),
        legend.position = "bottom", legend.title = element_blank(),
        legend.text = element_text(size = rel(0.85)),
        axis.text = element_text(size = rel(0.82), color = "black"),
        plot.background = element_rect(fill = "white", color = NA),
        panel.background = element_rect(fill = "white", color = NA))

N_BREAKS <- c(25, 50, 100, 200, 400, 1000, 2000)

# The production and extension runs use disjoint n grids; assert rather than
# assume, so a future re-run that overlaps them cannot silently double-plot.
splice <- function(prod_file, ext_file, keep_measure) {
  p <- read_csv(.find(prod_file), show_col_types = FALSE)
  e <- read_csv(.find(ext_file),  show_col_types = FALSE)
  ov <- intersect(unique(p$n), unique(e$n))
  if (length(ov)) stop("grids overlap at n = ", paste(ov, collapse = ", "))
  bind_rows(p, e) %>% filter(measure == keep_measure) %>% distinct()
}

fig_ari <- function(palette = "greyscale") {
  d <- splice("clustering_sim_summary.csv", "clustering_sim_summary_ext.csv", "ari") %>%
    filter(method %in% METHOD_LEVELS) %>%
    mutate(method = factor(method, levels = METHOD_LEVELS),
           family = factor(FAMILY_LABELS[set], levels = FAMILY_LABELS))
  pal <- .pal(palette); lv <- METHOD_LEVELS
  ggplot(d, aes(n, value, color = method, linetype = method, shape = method)) +
    geom_hline(yintercept = 0.8, color = "grey55", linewidth = 0.35, linetype = "longdash") +
    geom_hline(yintercept = 0,   color = "grey35", linewidth = 0.35) +
    geom_line(linewidth = 0.5) + geom_point(size = 1.7) +
    facet_wrap(~ family) +
    scale_x_log10(breaks = N_BREAKS, labels = N_BREAKS) +
    scale_y_continuous(limits = c(-0.05, 1), breaks = seq(0, 1, 0.25)) +
    scale_color_manual(values = pal$color[lv], breaks = lv, labels = parse(text = METHOD_LABELS[lv])) +
    scale_linetype_manual(values = pal$linetype[lv], breaks = lv, labels = parse(text = METHOD_LABELS[lv])) +
    scale_shape_manual(values = pal$shape[lv], breaks = lv, labels = parse(text = METHOD_LABELS[lv])) +
    labs(x = "sample size per region, n  (log scale)",
         y = "adjusted Rand index") +
    .theme + guides(color = guide_legend(nrow = 1))
}

fig_auc <- function(palette = "greyscale") {
  d <- splice("selection_sim_summary.csv", "selection_sim_summary_ext.csv", "auc") %>%
    filter(method %in% METHOD_LEVELS,
           (set == "Set3_Mixture"  & type == "combined") |
           (set == "Set4_Extremes" & type %in% c("sym_severity", "bulk_shift"))) %>%
    mutate(method = factor(method, levels = METHOD_LEVELS),
           panel = factor(paste0(sub("_.*", "", set), ": ", type),
                          levels = c("Set3: combined", "Set4: sym_severity", "Set4: bulk_shift"),
                          labels = c("Set 3, combined\n(mean and SD matched)",
                                     "Set 4, extremes further out\n(mean matched)",
                                     "Set 4, location shift of everyone\n(control: KS's home turf)")))
  pal <- .pal(palette); lv <- METHOD_LEVELS
  ggplot(d, aes(n, value, color = method, linetype = method, shape = method)) +
    geom_hline(yintercept = 0.9, color = "grey55", linewidth = 0.35, linetype = "longdash") +
    geom_hline(yintercept = 0.5, color = "grey35", linewidth = 0.35) +
    geom_line(linewidth = 0.5) + geom_point(size = 1.7) +
    facet_wrap(~ panel) +
    scale_x_log10(breaks = N_BREAKS, labels = N_BREAKS) +
    scale_y_continuous(limits = c(0.4, 1), breaks = seq(0.4, 1, 0.1)) +
    scale_color_manual(values = pal$color[lv], breaks = lv, labels = parse(text = METHOD_LABELS[lv])) +
    scale_linetype_manual(values = pal$linetype[lv], breaks = lv, labels = parse(text = METHOD_LABELS[lv])) +
    scale_shape_manual(values = pal$shape[lv], breaks = lv, labels = parse(text = METHOD_LABELS[lv])) +
    labs(x = "sample size per region, n  (log scale)",
         y = "AUC (match versus discordant)") +
    .theme + guides(color = guide_legend(nrow = 1))
}

generate <- function(out = .out()) {
  dir.create(out, showWarnings = FALSE, recursive = TRUE)
  for (p in c("greyscale", "color")) {
    sfx <- if (p == "color") "_color" else ""
    g1 <- fig_ari(p)
    ggsave(file.path(out, paste0("fig_required_n_ari", sfx, ".pdf")), g1, width = 7, height = 5.4, bg = "white")
    ggsave(file.path(out, paste0("fig_required_n_ari", sfx, ".png")), g1, width = 7, height = 5.4, dpi = 300, bg = "white")
    g2 <- fig_auc(p)
    ggsave(file.path(out, paste0("fig_required_n_auc", sfx, ".pdf")), g2, width = 7, height = 3.2, bg = "white")
    ggsave(file.path(out, paste0("fig_required_n_auc", sfx, ".png")), g2, width = 7, height = 3.2, dpi = 300, bg = "white")
  }
  message("[required-n figures] done -> ", normalizePath(out, mustWork = FALSE))
}

if (sys.nframe() == 0L) generate()
