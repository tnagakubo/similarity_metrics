# EXPLORATORY — exploratory/set4_control_mechanism (not pre-registered; see README.md). Not cited by the manuscript.
# Post-processing only (no random numbers): signal / noise decomposition of the separation, base (b) vs (a).
# Reads results/set4_control_mechanism.csv written by R/set4_control_mechanism.R; writes results/decomposition.csv.
SEED <- 20261012L   # declared for the lint; this script draws no random numbers
set.seed(SEED)
args <- commandArgs(trailingOnly = FALSE)
script <- sub("^--file=", "", grep("^--file=", args, value = TRUE))
here <- if (length(script) == 1L) normalizePath(file.path(dirname(script), "..")) else
        normalizePath(file.path("projects", "similarity-metric", "exploratory", "set4_control_mechanism"))
RES <- file.path(here, "results")
r <- read.csv(file.path(RES, "set4_control_mechanism.csv"))
r$signal <- r$mean_alt - r$mean_null
r$noise  <- sqrt((r$sd_alt^2 + r$sd_null^2) / 2)
key <- c("n", "delta", "statistic")
a <- r[r$base == "gauss", c(key, "signal", "noise", "separation")]
b <- r[r$base == "set4",  c(key, "signal", "noise", "separation")]
m <- merge(a, b, by = key, suffixes = c("_gauss", "_set4"))
m$signal_ratio     <- m$signal_set4 / m$signal_gauss
m$noise_ratio      <- m$noise_set4 / m$noise_gauss
m$separation_ratio <- m$separation_set4 / m$separation_gauss
m <- m[order(m$statistic, m$delta, m$n), ]
write.csv(m, file.path(RES, "decomposition.csv"), row.names = FALSE)
writeLines(capture.output(sessionInfo()), file.path(RES, "sessionInfo_decompose.txt"))
