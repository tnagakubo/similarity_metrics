## ---------------------------------------------------------------------------
## figures.R -- deliverable figures
## ---------------------------------------------------------------------------

library(ggplot2)

BASE <- 9; ANN <- 8; TICK <- 7

theme_pub <- function() {
  theme_bw(base_size = BASE) +
    theme(
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(linewidth = 0.25, colour = "grey90"),
      panel.border = element_rect(linewidth = 0.4, colour = "grey30"),
      strip.background = element_blank(),
      strip.text = element_text(size = BASE, hjust = 0, face = "plain",
                                margin = margin(b = 3)),
      axis.text = element_text(size = TICK, colour = "grey20"),
      axis.title = element_text(size = BASE),
      axis.ticks = element_line(linewidth = 0.3, colour = "grey30"),
      legend.background = element_rect(fill = NA, colour = NA),
      legend.box.background = element_rect(fill = NA, colour = NA),
      legend.key = element_rect(fill = NA, colour = NA),
      legend.title = element_blank(),
      legend.text = element_text(size = ANN),
      legend.key.height = unit(9, "pt"),
      plot.title = element_text(size = BASE + 1, face = "plain", hjust = 0),
      plot.subtitle = element_text(size = ANN, colour = "grey30", hjust = 0),
      plot.caption = element_text(size = TICK, colour = "grey30", hjust = 0)
    )
}

PAL <- c("t-test (Welch)"           = "#b9bfc6",
         "Wilcoxon"                 = "#8b949e",
         "Anderson-Darling"         = "#4e575f",
         "Smooth k=2"               = "#f4a582",
         "Smooth k=4"               = "#d6604d",
         "Smooth data-driven (BIC)" = "#8c0d17")
SZ <- c(0.5, 0.5, 0.5, 0.6, 0.6, 1.0)
names(SZ) <- names(PAL)

## ===========================================================================
## Figure 1 -- size and power
## ===========================================================================

sim <- read.csv("results/power_summary.csv", stringsAsFactors = FALSE)

TITLES <- c(
  S1_location        = "Location shift, normal (0.35 SD)",
  S2_heavytail_loc   = "Location shift, heavy tails (t3)",
  S3_scale_only      = "Spread only: SD 1.0 vs 1.6, equal mean and median",
  S4_responder       = "Responder subgroup: 25% shifted by 1.6 SD",
  S5_shape_only      = "Shape only: skewed, equal mean and SD",
  S6_lognormal_shift = "Right-skewed endpoint, lognormal shift",
  S7_stabilising     = "Mean shift 0.2 SD with variance reduction to 0.6 SD")

d1 <- subset(sim, scenario %in% names(TITLES) & test != "Kolmogorov-Smirnov")
d1$panel <- factor(TITLES[d1$scenario], levels = TITLES)
d1$test <- factor(d1$test, levels = names(PAL))

fig1 <- ggplot(d1, aes(n_per_arm, power, colour = test, linewidth = test)) +
  geom_hline(yintercept = 0.05, linetype = "22", linewidth = 0.3,
             colour = "grey55") +
  geom_line() +
  geom_point(size = 0.9) +
  facet_wrap(~ panel, ncol = 3, labeller = label_wrap_gen(34)) +
  scale_colour_manual(values = PAL) +
  scale_linewidth_manual(values = SZ, guide = "none") +
  scale_x_continuous(breaks = c(50, 100, 200)) +
  scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.25),
                     expand = expansion(mult = 0.04)) +
  guides(colour = guide_legend(ncol = 1, override.aes = list(linewidth = 0.9))) +
  labs(
    x = "patients per arm", y = "rejection rate",
    title = paste("When the treatment changes spread or shape, mean- and",
                  "rank-based tests have essentially no power"),
    subtitle = paste0("Two-sample tests at the 5% level; 5,000 replicates per",
                      " cell (Monte-Carlo SE \u2264 0.7 percentage points).\n",
                      "Dashed line marks the nominal 5% level; all rank-based",
                      " tests use exact distribution-free critical values."),
    caption = paste0("Kolmogorov-Smirnov omitted from the panels for legibility",
                     " (it is uniformly below Anderson-Darling here) but",
                     " retained in results/power_summary.csv.\n",
                     "\"Smooth k\" = smooth test with k components fixed in",
                     " advance; \"data-driven\" selects k \u2264 4 by Schwarz's",
                     " rule. In the spread-only panel the t-test and\n",
                     "Wilcoxon curves coincide at the nominal level.")) +
  theme_pub() +
  theme(legend.position = c(0.56, 0.13),
        legend.justification = c(0, 0.5),
        plot.title = element_text(margin = margin(b = 2)),
        plot.subtitle = element_text(margin = margin(b = 8)))

ggsave("figures/fig1_power.png", fig1, width = 7.4, height = 6.3,
       dpi = 300, bg = "white")
ggsave("figures/fig1_power.pdf", fig1, width = 7.4, height = 6.3, bg = "white")

## ===========================================================================
## Figure 2 -- GUSTO-I illustration
## ===========================================================================

ga <- readRDS("results/gusto_application.rds")
r1 <- ga$B_pick$r1; r2 <- ga$B_pick$r2; vv <- ga$B_pick$variable
lab1 <- paste("region", r1); lab2 <- paste("region", r2)
COL2 <- c("#4e575f", "#8c0d17"); names(COL2) <- c(lab1, lab2)

## (a) distributions
dd <- rbind(data.frame(v = ga$xB, grp = lab1),
            data.frame(v = ga$yB, grp = lab2))
mns <- tapply(dd$v, dd$grp, mean)

pa <- ggplot(dd, aes(v, colour = grp)) +
  geom_density(linewidth = 0.7, bw = "SJ", key_glyph = "path") +
  geom_vline(xintercept = mns, colour = COL2[names(mns)],
             linetype = "22", linewidth = 0.35) +
  scale_colour_manual(values = COL2) +
  scale_x_continuous(limits = range(dd$v), expand = expansion(mult = 0.01)) +
  labs(x = "age (years)", y = "density",
       title = "a  Same mean age, different spread and shape",
       subtitle = sprintf(
         "means %.1f vs %.1f years (dashed); SD %.1f vs %.1f; skewness %.2f vs %.2f",
         mean(ga$xB), mean(ga$yB), sd(ga$xB), sd(ga$yB),
         mean(((ga$xB - mean(ga$xB))/sd(ga$xB))^3),
         mean(((ga$yB - mean(ga$yB))/sd(ga$yB))^3))) +
  theme_pub() +
  theme(legend.position = c(0.06, 0.88), legend.justification = c(0, 1),
        plot.title = element_text(face = "bold"))

## (b) components
cm <- ga$B_test$components
cm$lbl <- c("1\nlocation\n(Wilcoxon)", "2\nscale", "3\nskewness", "4\ntails")
cm$lbl <- factor(cm$lbl, levels = cm$lbl)
cm$sig <- ifelse(abs(cm$Z) > 1.96, "beyond \u00b11.96", "within \u00b11.96")

pb <- ggplot(cm, aes(lbl, Z, fill = sig)) +
  geom_hline(yintercept = 0, linewidth = 0.3, colour = "grey40") +
  geom_hline(yintercept = c(-1.96, 1.96), linetype = "22", linewidth = 0.3,
             colour = "grey55") +
  geom_col(width = 0.6) +
  geom_text(aes(label = sprintf("%.2f", Z),
                vjust = ifelse(Z > 0, -0.5, 1.4)), size = ANN / .pt) +
  scale_fill_manual(values = c("within \u00b11.96" = "#b9bfc6",
                               "beyond \u00b11.96" = "#8c0d17")) +
  scale_y_continuous(expand = expansion(mult = 0.16)) +
  labs(x = "smooth component", y = "standardised component Z",
       title = "b  Signal lies beyond the location component",
       subtitle = paste0("t-test p = ", signif(ga$p_t, 2),
                         ", Wilcoxon p = ", signif(ga$p_w, 2),
                         "; smooth test p ",
                         if (ga$B_test$p.value < 1e-3) "< 0.001" else
                           paste("=", signif(ga$B_test$p.value, 2)))) +
  theme_pub() +
  theme(legend.position = "none", plot.title = element_text(face = "bold"),
        axis.text.x = element_text(size = TICK, lineheight = 0.95))

## (c) resampling power
cc <- subset(ga$C, test != "Kolmogorov-Smirnov")
cc$test <- factor(cc$test, levels = names(PAL))
pc <- ggplot(cc, aes(n_per_arm, power, colour = test, linewidth = test)) +
  geom_hline(yintercept = 0.05, linetype = "22", linewidth = 0.3,
             colour = "grey55") +
  geom_line() + geom_point(size = 0.9) +
  scale_colour_manual(values = PAL, drop = TRUE) +
  scale_linewidth_manual(values = SZ, guide = "none") +
  scale_x_continuous(breaks = c(50, 100, 200)) +
  scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.25)) +
  guides(colour = guide_legend(ncol = 1,
                               override.aes = list(linewidth = 0.9))) +
  labs(x = "patients per arm resampled from the two regions",
       y = "rejection rate",
       title = "c  Detectability at trial-scale sample sizes",
       subtitle = "2,000 resamples per point; permutation critical values") +
  theme_pub() +
  theme(legend.position = c(0.03, 0.97), legend.justification = c(0, 1),
        plot.title = element_text(face = "bold"))

## compose with base grid (no layout package required)
library(grid)
compose_fig2 <- function() {
  grid.newpage()
  pushViewport(viewport(layout = grid.layout(2, 2, heights = unit(c(1, 1.06),
                                                                 "null"))))
  print(pa, vp = viewport(layout.pos.row = 1, layout.pos.col = 1:2))
  print(pb, vp = viewport(layout.pos.row = 2, layout.pos.col = 1))
  print(pc, vp = viewport(layout.pos.row = 2, layout.pos.col = 2))
  popViewport()
}
png("figures/fig2_gusto.png", width = 7.4, height = 6.6, units = "in",
    res = 300, bg = "white"); compose_fig2(); dev.off()
pdf("figures/fig2_gusto.pdf", width = 7.4, height = 6.6, bg = "white")
compose_fig2(); dev.off()

message("figures written")
