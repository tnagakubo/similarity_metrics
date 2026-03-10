## IST-3: Search for skewed EM candidates
## Goal: Find variables with non-normal distributions where nABCD diverges from SMD

ist3 <- read.csv("ist3_full_vars.csv", stringsAsFactors = FALSE)

ct <- sort(table(ist3$country), decreasing = TRUE)
countries <- names(ct[ct >= 50])
countries <- countries[countries != "OTHER"]

# Core functions
compute_w1 <- function(x, y) {
  ecdf1 <- ecdf(x); ecdf2 <- ecdf(y)
  pooled <- sort(c(x, y))
  vals <- ecdf1(pooled) - ecdf2(pooled)
  diffs <- diff(pooled)
  sum(abs(vals[-length(vals)]) * diffs)
}

compute_nABCD <- function(x, y) {
  w1 <- compute_w1(x, y)
  iqr_p <- IQR(c(x, y), na.rm = TRUE)
  if (iqr_p == 0) return(NA)
  w1 / (2 * iqr_p)
}

compute_smd <- function(x, y) {
  nx <- length(x); ny <- length(y)
  sp <- sqrt(((nx-1)*sd(x)^2 + (ny-1)*sd(y)^2) / (nx+ny-2))
  (mean(x) - mean(y)) / sp
}

skewness <- function(x) {
  n <- length(x); m <- mean(x); s <- sd(x)
  (n / ((n-1)*(n-2))) * sum(((x - m) / s)^3)
}

kurtosis_excess <- function(x) {
  n <- length(x); m <- mean(x); s <- sd(x)
  ((n*(n+1)) / ((n-1)*(n-2)*(n-3))) * sum(((x - m) / s)^4) -
    (3*(n-1)^2) / ((n-2)*(n-3))
}

# ================================================================
# Part 1: All continuous variables — distributional characteristics
# ================================================================
cat("================================================================\n")
cat("=== Part 1: All Continuous Variables — Distribution Profile ===\n")
cat("================================================================\n\n")

vars <- list(
  list(name = "Age", col = "age"),
  list(name = "NIHSS", col = "nihss"),
  list(name = "Treat Delay", col = "treatdelay"),
  list(name = "SBP", col = "sbp"),
  list(name = "Weight", col = "weight")
)

cat(sprintf("%-15s %6s %8s %8s %8s %8s %10s\n",
            "Variable", "N", "Mean", "SD", "Skew", "Kurt_ex", "SW_p"))
cat(strrep("-", 75), "\n")

for (v in vars) {
  d <- ist3[[v$col]][!is.na(ist3[[v$col]])]
  sw <- shapiro.test(if (length(d) > 5000) sample(d, 5000) else d)
  cat(sprintf("%-15s %6d %8.2f %8.2f %8.3f %8.3f %10.2e\n",
              v$name, length(d), mean(d), sd(d),
              skewness(d), kurtosis_excess(d), sw$p.value))
}

# ================================================================
# Part 2: Country-level skewness and SD for all variables
# ================================================================
cat("\n\n================================================================\n")
cat("=== Part 2: Country-Level Distribution Profiles ===\n")
cat("================================================================\n")

for (v in vars) {
  cat(sprintf("\n--- %s ---\n", v$name))
  cat(sprintf("%-12s %5s %8s %8s %8s %8s\n",
              "Country", "N", "Mean", "SD", "Skew", "Median"))
  cat(strrep("-", 55), "\n")
  for (c in countries) {
    d <- ist3[[v$col]][ist3$country == c & !is.na(ist3[[v$col]])]
    if (length(d) < 10) next
    cat(sprintf("%-12s %5d %8.2f %8.2f %8.3f %8.1f\n",
                c, length(d), mean(d), sd(d), skewness(d), median(d)))
  }
  # SD ratio
  sds <- sapply(countries, function(c) {
    d <- ist3[[v$col]][ist3$country == c & !is.na(ist3[[v$col]])]
    if (length(d) < 10) NA else sd(d)
  })
  sds <- sds[!is.na(sds)]
  skews <- sapply(countries, function(c) {
    d <- ist3[[v$col]][ist3$country == c & !is.na(ist3[[v$col]])]
    if (length(d) < 10) NA else skewness(d)
  })
  skews <- skews[!is.na(skews)]
  cat(sprintf("  SD ratio: %.2f (%.2f - %.2f)\n", max(sds)/min(sds), min(sds), max(sds)))
  cat(sprintf("  Skew range: %.3f to %.3f\n", min(skews), max(skews)))
}

# ================================================================
# Part 3: Pairwise nABCD vs SMD for ALL variables
# ================================================================
cat("\n\n================================================================\n")
cat("=== Part 3: nABCD vs SMD — All Variables, All 28 Pairs ===\n")
cat("================================================================\n")

all_comp <- data.frame()

for (v in vars) {
  for (i in 1:(length(countries)-1)) {
    for (j in (i+1):length(countries)) {
      x <- ist3[[v$col]][ist3$country == countries[i] & !is.na(ist3[[v$col]])]
      y <- ist3[[v$col]][ist3$country == countries[j] & !is.na(ist3[[v$col]])]
      if (length(x) < 10 || length(y) < 10) next
      smd <- compute_smd(x, y)
      nab <- compute_nABCD(x, y)
      all_comp <- rbind(all_comp, data.frame(
        Variable = v$name,
        Country1 = countries[i], Country2 = countries[j],
        n1 = length(x), n2 = length(y),
        mean1 = mean(x), mean2 = mean(y),
        sd1 = sd(x), sd2 = sd(y),
        skew1 = skewness(x), skew2 = skewness(y),
        SMD = smd, abs_SMD = abs(smd),
        nABCD = nab,
        stringsAsFactors = FALSE
      ))
    }
  }
}

# ================================================================
# Part 4: Find pairs where nABCD >> SMD (shape/scale divergence)
# ================================================================
cat("\n\n================================================================\n")
cat("=== Part 4: Largest nABCD/|SMD| Ratio (scale/shape signal) ===\n")
cat("================================================================\n\n")

# Compute ratio, filter to meaningful nABCD
all_comp$ratio <- ifelse(all_comp$abs_SMD > 0.02,
                         all_comp$nABCD / all_comp$abs_SMD, NA)
all_comp$sd_ratio <- pmax(all_comp$sd1, all_comp$sd2) /
                     pmin(all_comp$sd1, all_comp$sd2)
all_comp$skew_diff <- abs(all_comp$skew1 - all_comp$skew2)

# Top divergence cases
top_div <- all_comp[!is.na(all_comp$ratio) & all_comp$nABCD > 0.05, ]
top_div <- top_div[order(-top_div$ratio), ]

cat(sprintf("Top 20 cases where nABCD/|SMD| ratio is highest (nABCD > 0.05):\n\n"))
cat(sprintf("%-12s %-12s %-12s %7s %7s %7s %7s %7s %7s\n",
            "Variable", "Country1", "Country2",
            "SMD", "nABCD", "ratio", "SD_rat", "skew1", "skew2"))
cat(strrep("-", 95), "\n")
for (r in 1:min(20, nrow(top_div))) {
  cat(sprintf("%-12s %-12s %-12s %7.3f %7.4f %7.2f %7.2f %7.3f %7.3f\n",
              top_div$Variable[r],
              top_div$Country1[r], top_div$Country2[r],
              top_div$SMD[r], top_div$nABCD[r], top_div$ratio[r],
              top_div$sd_ratio[r],
              top_div$skew1[r], top_div$skew2[r]))
}

# ================================================================
# Part 5: Treatment Delay deep dive (most skewed EM)
# ================================================================
cat("\n\n================================================================\n")
cat("=== Part 5: Treatment Delay Deep Dive ===\n")
cat("================================================================\n")
cat("(Emberson p=0.016, confirmed EM, most skewed distribution)\n\n")

delay_comp <- all_comp[all_comp$Variable == "Treat Delay", ]
delay_comp <- delay_comp[order(-delay_comp$nABCD), ]

cat("All 28 pairs sorted by nABCD:\n")
cat(sprintf("%-12s %-12s %7s %7s %7s %7s %7s %7s %7s\n",
            "Country1", "Country2",
            "mean1", "mean2", "SMD", "sd1", "sd2",
            "nABCD", "ratio"))
cat(strrep("-", 85), "\n")
for (r in 1:nrow(delay_comp)) {
  rat <- if (delay_comp$abs_SMD[r] > 0.02)
           sprintf("%.2f", delay_comp$ratio[r]) else "  -  "
  cat(sprintf("%-12s %-12s %7.2f %7.2f %7.3f %7.2f %7.2f %7.4f %7s\n",
              delay_comp$Country1[r], delay_comp$Country2[r],
              delay_comp$mean1[r], delay_comp$mean2[r],
              delay_comp$SMD[r],
              delay_comp$sd1[r], delay_comp$sd2[r],
              delay_comp$nABCD[r], rat))
}

# Norway deep dive
cat("\n--- Norway Treatment Delay: Distribution Detail ---\n")
d_norway <- ist3$treatdelay[ist3$country == "NORWAY" & !is.na(ist3$treatdelay)]
cat(sprintf("  N: %d\n", length(d_norway)))
cat(sprintf("  Mean: %.2f, Median: %.2f\n", mean(d_norway), median(d_norway)))
cat(sprintf("  SD: %.2f, IQR: [%.2f, %.2f]\n", sd(d_norway),
            quantile(d_norway, 0.25), quantile(d_norway, 0.75)))
cat(sprintf("  Skewness: %.3f\n", skewness(d_norway)))
cat(sprintf("  Range: %.2f - %.2f\n", min(d_norway), max(d_norway)))
cat(sprintf("  >6h: %d (%.1f%%)\n",
            sum(d_norway > 6), 100*mean(d_norway > 6)))
cat(sprintf("  >8h: %d (%.1f%%)\n",
            sum(d_norway > 8), 100*mean(d_norway > 8)))

# ================================================================
# Part 6: SBP and Weight — potential skewed EMs
# ================================================================
cat("\n\n================================================================\n")
cat("=== Part 6: SBP and Weight as Potential Skewed EMs ===\n")
cat("================================================================\n\n")

for (vname in c("SBP", "Weight")) {
  d_comp <- all_comp[all_comp$Variable == vname, ]
  r_p <- cor(d_comp$abs_SMD, d_comp$nABCD)
  r_s <- cor(d_comp$abs_SMD, d_comp$nABCD, method = "spearman")
  cat(sprintf("--- %s ---\n", vname))
  cat(sprintf("  Pearson r(|SMD|, nABCD) = %.3f, Spearman rho = %.3f\n", r_p, r_s))

  # Top divergence
  d_comp$ratio2 <- ifelse(d_comp$abs_SMD > 0.02,
                          d_comp$nABCD / d_comp$abs_SMD, NA)
  top3 <- d_comp[!is.na(d_comp$ratio2), ]
  top3 <- top3[order(-top3$ratio2), ]
  cat("  Top 3 divergence (nABCD >> |SMD|):\n")
  for (r in 1:min(3, nrow(top3))) {
    cat(sprintf("    %s-%s: SMD=%.3f, nABCD=%.4f, ratio=%.2f, SD=%.1f/%.1f, skew=%.2f/%.2f\n",
                top3$Country1[r], top3$Country2[r],
                top3$SMD[r], top3$nABCD[r], top3$ratio2[r],
                top3$sd1[r], top3$sd2[r],
                top3$skew1[r], top3$skew2[r]))
  }
  cat("\n")
}

# ================================================================
# Part 7: Summary — Best candidates for "nABCD advantage" demo
# ================================================================
cat("\n================================================================\n")
cat("=== Part 7: Best Candidates for nABCD Advantage Demo ===\n")
cat("================================================================\n\n")

cat("Criteria: Variable is plausible EM + skewed distribution +\n")
cat("          country pairs where nABCD detects what SMD misses\n\n")

# Correlation summary
cat("Variable         Pearson(|SMD|,nABCD)  Overall_Skew  SD_ratio  EM_evidence\n")
cat(strrep("-", 80), "\n")
for (v in vars) {
  d_comp <- all_comp[all_comp$Variable == v$name, ]
  r_p <- cor(d_comp$abs_SMD, d_comp$nABCD)
  d_all <- ist3[[v$col]][!is.na(ist3[[v$col]])]
  sds <- sapply(countries, function(c) {
    d <- ist3[[v$col]][ist3$country == c & !is.na(ist3[[v$col]])]
    if (length(d) < 10) NA else sd(d)
  })
  sds <- sds[!is.na(sds)]
  em_ev <- switch(v$name,
    "Age" = "Emberson p=0.53",
    "NIHSS" = "Emberson p=0.06",
    "Treat Delay" = "Emberson p=0.016",
    "SBP" = "Plausible (BP)",
    "Weight" = "Weak")
  cat(sprintf("%-15s  %8.3f              %8.3f     %5.2f     %s\n",
              v$name, r_p, skewness(d_all), max(sds)/min(sds), em_ev))
}

cat("\n=== ANALYSIS COMPLETE ===\n")
