## IST-3: nABCD vs SMD comparison + distributional analysis
## Purpose: Compute both nABCD and SMD for all 28 pairs x 3 EMs
## Show cases where SMD ≈ 0 but nABCD is non-trivial

ist3 <- read.csv("ist3_full_vars.csv", stringsAsFactors = FALSE)

# --- Core functions ---
compute_w1 <- function(x, y) {
  ecdf1 <- ecdf(x)
  ecdf2 <- ecdf(y)
  pooled <- sort(c(x, y))
  vals <- ecdf1(pooled) - ecdf2(pooled)
  diffs <- diff(pooled)
  abs_cdf_diff <- abs(vals[-length(vals)])
  sum(abs_cdf_diff * diffs)
}

compute_nABCD <- function(x, y) {
  w1 <- compute_w1(x, y)
  pooled <- c(x, y)
  iqr_pooled <- IQR(pooled, na.rm = TRUE)
  if (iqr_pooled == 0) return(NA)
  w1 / iqr_pooled
}

compute_smd <- function(x, y) {
  # Cohen's d with pooled SD
  nx <- length(x); ny <- length(y)
  sx <- sd(x); sy <- sd(y)
  sp <- sqrt(((nx - 1) * sx^2 + (ny - 1) * sy^2) / (nx + ny - 2))
  (mean(x) - mean(y)) / sp
}

# --- Countries with n >= 50 ---
ct <- sort(table(ist3$country), decreasing = TRUE)
countries <- names(ct[ct >= 50])
countries <- countries[countries != "OTHER"]

# ================================================================
# Part 1: Distributional characteristics of each EM
# ================================================================
cat("================================================================\n")
cat("=== Part 1: Distributional Characteristics of EMs ===\n")
cat("================================================================\n\n")

em_vars <- list(
  list(name = "Age", col = "age", unit = "years"),
  list(name = "Treatment Delay", col = "treatdelay", unit = "hours"),
  list(name = "NIHSS", col = "nihss", unit = "score")
)

for (em in em_vars) {
  d_all <- ist3[[em$col]][!is.na(ist3[[em$col]])]
  cat(sprintf("--- %s (Overall, N=%d) ---\n", em$name, length(d_all)))
  cat(sprintf("  Mean: %.2f, SD: %.2f\n", mean(d_all), sd(d_all)))
  cat(sprintf("  Median: %.1f, IQR: [%.1f, %.1f]\n",
              median(d_all), quantile(d_all, 0.25), quantile(d_all, 0.75)))
  cat(sprintf("  Min: %.1f, Max: %.1f\n", min(d_all), max(d_all)))

  # Skewness and kurtosis (manual)
  n <- length(d_all)
  m <- mean(d_all)
  s <- sd(d_all)
  skew <- (n / ((n-1)*(n-2))) * sum(((d_all - m) / s)^3)
  kurt <- ((n*(n+1)) / ((n-1)*(n-2)*(n-3))) * sum(((d_all - m) / s)^4) -
          (3*(n-1)^2) / ((n-2)*(n-3))
  cat(sprintf("  Skewness: %.3f\n", skew))
  cat(sprintf("  Excess Kurtosis: %.3f\n", kurt))

  # Shapiro-Wilk (subsample if > 5000)
  sw_sample <- if (length(d_all) > 5000) sample(d_all, 5000) else d_all
  sw <- shapiro.test(sw_sample)
  cat(sprintf("  Shapiro-Wilk p: %.2e\n", sw$p.value))

  # SD ratio across countries (indicator of scale difference)
  sds <- sapply(countries, function(c) {
    d <- ist3[[em$col]][ist3$country == c & !is.na(ist3[[em$col]])]
    sd(d)
  })
  cat(sprintf("  SD range across countries: %.2f - %.2f (ratio: %.2f)\n",
              min(sds), max(sds), max(sds)/min(sds)))

  # Country-level skewness
  cat("  Country-level skewness:\n")
  for (c in countries) {
    d <- ist3[[em$col]][ist3$country == c & !is.na(ist3[[em$col]])]
    n_c <- length(d)
    m_c <- mean(d); s_c <- sd(d)
    skew_c <- (n_c / ((n_c-1)*(n_c-2))) * sum(((d - m_c) / s_c)^3)
    cat(sprintf("    %-12s (n=%4d): skew=%.3f, SD=%.2f\n", c, n_c, skew_c, s_c))
  }
  cat("\n")
}

# ================================================================
# Part 2: Pairwise nABCD vs SMD for all 3 EMs
# ================================================================
cat("\n================================================================\n")
cat("=== Part 2: Pairwise nABCD vs SMD (all 28 pairs x 3 EMs) ===\n")
cat("================================================================\n")

all_comp <- data.frame()

for (em in em_vars) {
  vcol <- em$col
  vname <- em$name

  cat(sprintf("\n--- %s ---\n", vname))
  cat(sprintf("%-12s %-12s %5s %5s %7s %7s %7s %7s %7s %8s %8s\n",
              "Country1", "Country2", "n1", "n2",
              "mean1", "mean2", "sd1", "sd2",
              "SMD", "nABCD", "nABCD/SMD"))
  cat(strrep("-", 100), "\n")

  for (i in 1:(length(countries) - 1)) {
    for (j in (i + 1):length(countries)) {
      x <- ist3[[vcol]][ist3$country == countries[i] & !is.na(ist3[[vcol]])]
      y <- ist3[[vcol]][ist3$country == countries[j] & !is.na(ist3[[vcol]])]

      smd <- compute_smd(x, y)
      nab <- compute_nABCD(x, y)
      ratio <- if (abs(smd) > 0.01) abs(nab / smd) else NA

      cat(sprintf("%-12s %-12s %5d %5d %7.2f %7.2f %7.2f %7.2f %7.3f %8.4f %8s\n",
                  countries[i], countries[j],
                  length(x), length(y),
                  mean(x), mean(y), sd(x), sd(y),
                  smd, nab,
                  if (is.na(ratio)) "  -  " else sprintf("%.2f", ratio)))

      all_comp <- rbind(all_comp, data.frame(
        Variable = vname,
        Country1 = countries[i], Country2 = countries[j],
        n1 = length(x), n2 = length(y),
        mean1 = mean(x), mean2 = mean(y),
        sd1 = sd(x), sd2 = sd(y),
        SMD = round(smd, 4), abs_SMD = round(abs(smd), 4),
        nABCD = round(nab, 4),
        stringsAsFactors = FALSE
      ))
    }
  }
}

# ================================================================
# Part 3: Key cases — SMD ≈ 0 but nABCD non-trivial
# ================================================================
cat("\n\n================================================================\n")
cat("=== Part 3: Divergence Cases (|SMD| < 0.1 but nABCD > 0.05) ===\n")
cat("================================================================\n\n")

divergent <- all_comp[abs(all_comp$SMD) < 0.1 & all_comp$nABCD > 0.05, ]
divergent <- divergent[order(-divergent$nABCD), ]

if (nrow(divergent) > 0) {
  cat(sprintf("Found %d cases where |SMD| < 0.1 but nABCD > 0.05:\n\n", nrow(divergent)))
  cat(sprintf("%-8s %-12s %-12s %7s %7s %7s %7s %8s %8s\n",
              "EM", "Country1", "Country2", "sd1", "sd2",
              "SD_rat", "SMD", "nABCD", "nABCD/|SMD|"))
  cat(strrep("-", 90), "\n")
  for (r in 1:nrow(divergent)) {
    sd_ratio <- max(divergent$sd1[r], divergent$sd2[r]) /
                min(divergent$sd1[r], divergent$sd2[r])
    nab_smd <- if (abs(divergent$SMD[r]) > 0.001)
                 divergent$nABCD[r] / abs(divergent$SMD[r]) else Inf
    cat(sprintf("%-8s %-12s %-12s %7.2f %7.2f %7.2f %7.3f %8.4f %8s\n",
                divergent$Variable[r],
                divergent$Country1[r], divergent$Country2[r],
                divergent$sd1[r], divergent$sd2[r], sd_ratio,
                divergent$SMD[r], divergent$nABCD[r],
                if (is.finite(nab_smd)) sprintf("%.1f", nab_smd) else "Inf"))
  }
} else {
  cat("No cases found with |SMD| < 0.1 and nABCD > 0.05.\n")
}

# ================================================================
# Part 4: Correlation between |SMD| and nABCD by EM
# ================================================================
cat("\n\n================================================================\n")
cat("=== Part 4: Correlation between |SMD| and nABCD ===\n")
cat("================================================================\n\n")

for (em in em_vars) {
  d <- all_comp[all_comp$Variable == em$name, ]
  r_pearson <- cor(abs(d$SMD), d$nABCD)
  r_spearman <- cor(abs(d$SMD), d$nABCD, method = "spearman")
  cat(sprintf("%-20s: Pearson r = %.3f, Spearman rho = %.3f\n",
              em$name, r_pearson, r_spearman))

  # Rank comparison
  rank_smd <- rank(-abs(d$SMD))
  rank_nab <- rank(-d$nABCD)
  cat(sprintf("  Top 3 by |SMD|:  %s\n",
              paste(paste0(d$Country1[order(-abs(d$SMD))][1:3], "-",
                          d$Country2[order(-abs(d$SMD))][1:3]), collapse = ", ")))
  cat(sprintf("  Top 3 by nABCD: %s\n",
              paste(paste0(d$Country1[order(-d$nABCD)][1:3], "-",
                          d$Country2[order(-d$nABCD)][1:3]), collapse = ", ")))
  cat("\n")
}

# ================================================================
# Part 5: Summary table for paper
# ================================================================
cat("\n================================================================\n")
cat("=== Part 5: Summary for Paper (nABCD vs SMD by EM) ===\n")
cat("================================================================\n\n")

cat(sprintf("%-20s %8s %8s %8s %8s %8s %8s\n",
            "EM", "nABCD_min", "nABCD_med", "nABCD_max",
            "SMD_min", "SMD_med", "SMD_max"))
cat(strrep("-", 76), "\n")
for (em in em_vars) {
  d <- all_comp[all_comp$Variable == em$name, ]
  cat(sprintf("%-20s %8.3f %8.3f %8.3f %8.3f %8.3f %8.3f\n",
              em$name,
              min(d$nABCD), median(d$nABCD), max(d$nABCD),
              min(abs(d$SMD)), median(abs(d$SMD)), max(abs(d$SMD))))
}

cat("\n=== ANALYSIS COMPLETE ===\n")
