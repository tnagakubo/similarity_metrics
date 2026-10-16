## Test 4 scatter options for Tak review (greyscale paper version)
## a: ▲削除 + equal scale + labels keep + same color
## b: a + diagonal y=x reference line
## c: a + unified tick marks
## d: a + geom_text_repel (label collision avoidance)

library(ggplot2)
library(dplyr)
library(tidyr)
library(ggrepel)

base_dir <- "C:/Users/hrd13/Documents/Gak/0 Study/800Claude/20260210_SIM/similarity_metrics/projects/similarity-metric"
fig_dir  <- file.path(base_dir, "figures")
data_dir <- file.path(base_dir, "data/GUSTO")

res_wide <- read.csv(file.path(data_dir, "gusto_r8_results.csv"))
scatter_data <- res_wide %>%
  mutate(partner_label = paste0("R", partner))

col_pt <- "#1A1A1A"  # greyscale paper

# ===== Option (a): minimum — same color, no triangle, equal scale =====
p_a <- ggplot(scatter_data, aes(x = nABCD_age, y = nABCD_sysbp)) +
  geom_point(size = 2.6, color = col_pt) +
  geom_text(aes(label = partner_label), vjust = -0.9, hjust = 0.5,
            size = 3, color = col_pt) +
  coord_fixed(xlim = c(0, 0.12), ylim = c(0, 0.12)) +
  labs(x = "nABCD (Age)", y = "nABCD (Systolic BP)",
       title = "(a) plain — equal scale, no triangle") +
  theme_minimal(base_size = 11) +
  theme(panel.grid.minor = element_blank(),
        plot.title = element_text(face = "bold", size = 11))

# ===== Option (b): a + diagonal y = x =====
p_b <- ggplot(scatter_data, aes(x = nABCD_age, y = nABCD_sysbp)) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed",
              color = "#888888", linewidth = 0.4) +
  geom_point(size = 2.6, color = col_pt) +
  geom_text(aes(label = partner_label), vjust = -0.9, hjust = 0.5,
            size = 3, color = col_pt) +
  coord_fixed(xlim = c(0, 0.12), ylim = c(0, 0.12)) +
  labs(x = "nABCD (Age)", y = "nABCD (Systolic BP)",
       title = "(b) + diagonal y = x reference") +
  theme_minimal(base_size = 11) +
  theme(panel.grid.minor = element_blank(),
        plot.title = element_text(face = "bold", size = 11))

# ===== Option (c): a + unified ticks =====
p_c <- ggplot(scatter_data, aes(x = nABCD_age, y = nABCD_sysbp)) +
  geom_point(size = 2.6, color = col_pt) +
  geom_text(aes(label = partner_label), vjust = -0.9, hjust = 0.5,
            size = 3, color = col_pt) +
  coord_fixed(xlim = c(0, 0.12), ylim = c(0, 0.12)) +
  scale_x_continuous(breaks = seq(0, 0.12, 0.025)) +
  scale_y_continuous(breaks = seq(0, 0.12, 0.025)) +
  labs(x = "nABCD (Age)", y = "nABCD (Systolic BP)",
       title = "(c) + unified tick marks (0, 0.025, 0.05, ...)") +
  theme_minimal(base_size = 11) +
  theme(panel.grid.minor = element_blank(),
        plot.title = element_text(face = "bold", size = 11))

# ===== Option (d): a + geom_text_repel =====
p_d <- ggplot(scatter_data, aes(x = nABCD_age, y = nABCD_sysbp)) +
  geom_point(size = 2.6, color = col_pt) +
  geom_text_repel(aes(label = partner_label), size = 3, color = col_pt,
                  box.padding = 0.35, point.padding = 0.3,
                  segment.color = "#888888", segment.size = 0.3,
                  max.overlaps = Inf, seed = 1) +
  coord_fixed(xlim = c(0, 0.12), ylim = c(0, 0.12)) +
  labs(x = "nABCD (Age)", y = "nABCD (Systolic BP)",
       title = "(d) + geom_text_repel (collision-avoid labels)") +
  theme_minimal(base_size = 11) +
  theme(panel.grid.minor = element_blank(),
        plot.title = element_text(face = "bold", size = 11))

# Save all four for Tak review
ggsave(file.path(fig_dir, "test_scatter_a.png"), p_a, width = 6, height = 6, dpi = 200)
ggsave(file.path(fig_dir, "test_scatter_b.png"), p_b, width = 6, height = 6, dpi = 200)
ggsave(file.path(fig_dir, "test_scatter_c.png"), p_c, width = 6, height = 6, dpi = 200)
ggsave(file.path(fig_dir, "test_scatter_d.png"), p_d, width = 6, height = 6, dpi = 200)

cat("4 test scatter options saved to figures/test_scatter_{a,b,c,d}.png\n")
