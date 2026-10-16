# =============================================================================
# Figures for Part 1B — clinically calibrated threshold selection
#
# fig_threshold_sensitivity : sensitivity attainable while holding violation <= 5%,
#   as the clinical requirement tau_clin is swept. One panel per scenario. Every
#   competitor is shown at its ORACLE-BEST threshold; W1 is shown twice -- at its
#   oracle-best cut AND at the threshold it can derive with no oracle at all
#   (tau = tau_clin, straight from the clinical requirement).
#
#   The Set-4 panel is the point of the study: KS is FLAT in tau. Relaxing the
#   clinical requirement buys KS nothing, because it cannot separate T1 (true W1 3.0,
#   KS 0.047) from T2 (true W1 6.0, KS 0.050) at any cut. W1 rises with tau, as a
#   method that identifies the target must.
#
# Paper standard: theme_bw base 11, width 7", white bg, greyscale + colour variant.
# =============================================================================

suppressPackageStartupMessages({ library(ggplot2); library(dplyr); library(readr) })

.SELF <- local({
  f <- NULL
  for (fr in rev(sys.frames())) if (!is.null(fr$ofile)) { f <- fr$ofile; break }
  if (is.null(f)) { a <- commandArgs(FALSE); fa <- sub("^--file=", "", a[grepl("^--file=", a)])
                    if (length(fa)) f <- fa[1] }
  if (is.null(f)) NA_character_ else tryCatch(normalizePath(f, mustWork = FALSE), error = function(e) f)
})
.dir <- function() if (is.na(.SELF)) "." else dirname(.SELF)
.find <- function(b) { p <- c(file.path("results", b), file.path("../results", b),
                              file.path(.dir(), "..", "results", b))
                       p <- p[file.exists(p)]; if (!length(p)) stop(b, " not found"); p[1] }
.out  <- function() if (is.na(.SELF)) "figures" else file.path(.dir(), "..", "figures")

FAMILY <- c(Set1_Gaussian  = "Set 1: Gaussian world",
            Set2_LogNormal = "Set 2: Log-normal world",
            Set3_Mixture   = "Set 3: Mixture world (moment-matched)",
            Set4_Extremes  = "Set 4: Extremes world (rare displaced mass)")
# W1_derived first: it is the only series that uses NO oracle.
LV  <- c("W1_derived", "W1", "KS", "RV1", "RV2", "RV3", "SMD")
LAB <- c(W1_derived = "'W'[1]*' (derived tau, no oracle)'", W1 = "'W'[1]*' (oracle tau)'",
         KS = "'KS (oracle)'", RV1 = "'RV1 = Ch.4 (oracle)'", RV2 = "'RV2 (oracle)'",
         RV3 = "'RV3 (oracle)'", SMD = "'SMD (oracle)'")

.pal <- function(p = c("greyscale", "color")) {
  p <- match.arg(p)
  col <- if (p == "color")
    c(W1_derived = "#7A1F18", W1 = "#D52B1E", KS = "#0072B2", RV1 = "#006D4F",
      RV2 = "#009E73", RV3 = "#66C2A5", SMD = "#999999")
  else
    c(W1_derived = "#000000", W1 = "#1A1A1A", KS = "#4D4D4D", RV1 = "#666666",
      RV2 = "#8C8C8C", RV3 = "#A6A6A6", SMD = "#D9D9D9")
  list(color = col,
       linetype = c(W1_derived = "longdash", W1 = "solid", KS = "dashed", RV1 = "dotdash",
                    RV2 = "twodash", RV3 = "1272", SMD = "dotted"),
       shape = c(W1_derived = 1, W1 = 16, KS = 17, RV1 = 15, RV2 = 18, RV3 = 8, SMD = 4))
}
.theme <- theme_bw(base_size = 11) +
  theme(panel.grid.minor = element_blank(),
        panel.grid.major = element_line(color = "grey92"),
        strip.background = element_rect(fill = "grey95", color = NA),
        strip.text = element_text(size = rel(0.8)),
        legend.position = "bottom", legend.title = element_text(size = rel(0.85)),
        legend.text = element_text(size = rel(0.85)),
        axis.text = element_text(size = rel(0.82), color = "black"),
        plot.background = element_rect(fill = "white", color = NA),
        panel.background = element_rect(fill = "white", color = NA))

load_threshold <- function(n_at = 100L) {
  op <- read_csv(.find("threshold_sim_operating.csv"), show_col_types = FALSE)
  stopifnot(all(op$method %in% LV), all(op$set %in% names(FAMILY)))
  op %>% filter(n == n_at) %>%
    mutate(method = factor(method, levels = LV),
           family = factor(FAMILY[set], levels = FAMILY))
}

fig_threshold_sensitivity <- function(d, palette = "greyscale") {
  pal <- .pal(palette); lv <- LV[LV %in% levels(droplevels(d$method))]
  ggplot(d, aes(tau_clin, sensitivity, color = method, linetype = method,
                shape = method, group = method)) +
    geom_line(linewidth = 0.5) + geom_point(size = 1.9) +
    facet_wrap(~ family, scales = "free_x") +
    scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.25)) +
    scale_color_manual(values = pal$color[lv], breaks = lv,
                       labels = parse(text = LAB[lv]), name = NULL) +
    scale_linetype_manual(values = pal$linetype[lv], breaks = lv,
                          labels = parse(text = LAB[lv]), name = NULL) +
    scale_shape_manual(values = pal$shape[lv], breaks = lv,
                       labels = parse(text = LAB[lv]), name = NULL) +
    labs(x = expression(paste("clinical requirement  ", tau[clin], " = ",
                              Delta[clin], "/", L, "   (EM units)")),
         y = "sensitivity  (acceptable countries admitted)") +
    .theme + guides(color = guide_legend(nrow = 2))
}

generate_threshold_figures <- function(out = .out()) {
  dir.create(out, showWarnings = FALSE, recursive = TRUE)
  d <- load_threshold(100L)
  message("[threshold figures] n = 100, ", nrow(d), " operating points")
  for (p in c("greyscale", "color")) {
    sfx <- if (p == "color") "_color" else ""
    g <- fig_threshold_sensitivity(d, p)
    ggsave(file.path(out, paste0("fig_threshold_sensitivity", sfx, ".pdf")), g,
           width = 7.2, height = 5.6, bg = "white")
    ggsave(file.path(out, paste0("fig_threshold_sensitivity", sfx, ".png")), g,
           width = 7.2, height = 5.6, dpi = 300, bg = "white")
  }
  message("[threshold figures] done.")
  invisible(d)
}

if (sys.nframe() == 0L) generate_threshold_figures()
