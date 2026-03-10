## IST-1 Global nABCD Analysis — Country-Level Pairwise Comparisons
## Purpose: Compare nABCD vs SMD across ALL country pairs for AGE, RSBP, RDELAY
## Filter: countries with n >= 50
## Output: summary statistics, correlation, divergence analysis, Asia focus

# Manual skewness (no external dependency)
skewness <- function(x) {
  x <- x[!is.na(x)]
  n <- length(x)
  m <- mean(x)
  s <- sd(x)
  if (s == 0) return(NA_real_)
  (n / ((n - 1) * (n - 2))) * sum(((x - m) / s)^3)
}

# ===========================================================================
# 0. Load data
# ===========================================================================
ist <- read.csv("projects/similarity-metric/data/IST/IST_corrected.csv")
cat("IST-1 data loaded:", nrow(ist), "patients,", ncol(ist), "variables\n")

# Filter countries with n >= 50
country_n <- table(ist$COUNTRY)
keep <- names(country_n[country_n >= 50])
ist <- ist[ist$COUNTRY %in% keep, ]
cat("After n>=50 filter:", nrow(ist), "patients in", length(keep), "countries\n\n")

# ===========================================================================
# 1. Helper functions
# ===========================================================================

# W1 (Wasserstein-1) via ECDF integration
compute_w1 <- function(x, y) {
  ecdf1 <- ecdf(x)
  ecdf2 <- ecdf(y)
  pooled <- sort(c(x, y))
  vals <- ecdf1(pooled) - ecdf2(pooled)
  diffs <- diff(pooled)
  abs_cdf_diff <- abs(vals[-length(vals)])
  sum(abs_cdf_diff * diffs)
}

# nABCD = W1 / (2 * IQR_pooled)
compute_nABCD <- function(x, y) {
  w1 <- compute_w1(x, y)
  pooled <- c(x, y)
  iqr_pooled <- IQR(pooled, na.rm = TRUE)
  if (iqr_pooled == 0) return(NA_real_)
  w1 / (2 * iqr_pooled)
}

# SMD = (mean1 - mean2) / pooled_SD
compute_smd <- function(x, y) {
  n1 <- length(x)
  n2 <- length(y)
  s1 <- sd(x)
  s2 <- sd(y)
  sp <- sqrt(((n1 - 1) * s1^2 + (n2 - 1) * s2^2) / (n1 + n2 - 2))
  if (sp == 0) return(NA_real_)
  (mean(x) - mean(y)) / sp
}

# ===========================================================================
# 2. Country-level distribution statistics
# ===========================================================================
countries <- sort(keep)
vars <- c("AGE", "RSBP", "RDELAY")

cat("============================================================\n")
cat("  Distribution Statistics by Country\n")
cat("============================================================\n")

for (v in vars) {
  cat(sprintf("\n--- %s ---\n", v))
  cat(sprintf("%-6s %5s %7s %7s %7s %7s %7s\n",
              "Cntry", "n", "Mean", "SD", "Median", "Skew", "IQR"))
  for (cntry in countries) {
    d <- ist[[v]][ist$COUNTRY == cntry]
    d <- d[!is.na(d)]
    cat(sprintf("%-6s %5d %7.1f %7.1f %7.0f %7.2f %7.1f\n",
                cntry, length(d), mean(d), sd(d), median(d),
                skewness(d), IQR(d)))
  }
}

# ===========================================================================
# 3. Pairwise nABCD and SMD for all country pairs
# ===========================================================================
cat("\n\n============================================================\n")
cat("  Pairwise nABCD and SMD (all country pairs, n>=50)\n")
cat("============================================================\n")

# Store results for all variables
all_results <- list()

for (v in vars) {
  pairs <- combn(countries, 2)
  npairs <- ncol(pairs)

  res <- data.frame(
    Country1 = pairs[1, ],
    Country2 = pairs[2, ],
    nABCD = numeric(npairs),
    SMD = numeric(npairs),
    absSMD = numeric(npairs),
    stringsAsFactors = FALSE
  )

  for (k in 1:npairs) {
    c1 <- pairs[1, k]
    c2 <- pairs[2, k]
    x <- ist[[v]][ist$COUNTRY == c1]
    y <- ist[[v]][ist$COUNTRY == c2]
    x <- x[!is.na(x)]
    y <- y[!is.na(y)]
    res$nABCD[k] <- compute_nABCD(x, y)
    res$SMD[k] <- compute_smd(x, y)
    res$absSMD[k] <- abs(res$SMD[k])
  }

  all_results[[v]] <- res

  # Print top 10 by nABCD
  cat(sprintf("\n--- %s: Top 10 pairs by nABCD ---\n", v))
  cat(sprintf("%-6s %-6s %8s %8s %10s\n", "Cntry1", "Cntry2", "nABCD", "|SMD|", "nABCD/|SMD|"))
  top10 <- res[order(-res$nABCD), ][1:10, ]
  for (i in 1:10) {
    ratio <- if (top10$absSMD[i] > 0) top10$nABCD[i] / top10$absSMD[i] else NA
    cat(sprintf("%-6s %-6s %8.4f %8.4f %10.3f\n",
                top10$Country1[i], top10$Country2[i],
                top10$nABCD[i], top10$absSMD[i],
                ifelse(is.na(ratio), NA, ratio)))
  }
}

# ===========================================================================
# 4. Summary table: per variable statistics
# ===========================================================================
cat("\n\n============================================================\n")
cat("  Summary: nABCD vs |SMD| Across Variables\n")
cat("============================================================\n")
cat(sprintf("%-8s %6s %8s %8s %8s %8s %8s %8s %8s\n",
            "Variable", "Pairs", "nABCD_mn", "nABCD_md", "nABCD_mx",
            "SMD_mn", "SMD_md", "SMD_mx", "r(nABCD,|SMD|)"))

for (v in vars) {
  res <- all_results[[v]]
  valid <- !is.na(res$nABCD) & !is.na(res$absSMD)
  r_val <- cor(res$nABCD[valid], res$absSMD[valid])
  cat(sprintf("%-8s %6d %8.4f %8.4f %8.4f %8.4f %8.4f %8.4f %8.4f\n",
              v, sum(valid),
              min(res$nABCD[valid]), median(res$nABCD[valid]), max(res$nABCD[valid]),
              min(res$absSMD[valid]), median(res$absSMD[valid]), max(res$absSMD[valid]),
              r_val))
}

# ===========================================================================
# 5. Divergence analysis: where nABCD and SMD disagree most
# ===========================================================================
cat("\n\n============================================================\n")
cat("  Divergence Analysis: High nABCD / Low |SMD| Ratio\n")
cat("  (cases where distributional difference exceeds location shift)\n")
cat("============================================================\n")

for (v in vars) {
  res <- all_results[[v]]
  valid <- !is.na(res$nABCD) & res$absSMD > 0.01  # avoid near-zero divisor
  rv <- res[valid, ]
  rv$ratio <- rv$nABCD / rv$absSMD
  rv <- rv[order(-rv$ratio), ]

  cat(sprintf("\n--- %s: Top 5 high nABCD/|SMD| ratio ---\n", v))
  cat(sprintf("%-6s %-6s %8s %8s %10s\n", "Cntry1", "Cntry2", "nABCD", "|SMD|", "Ratio"))
  n_show <- min(5, nrow(rv))
  for (i in 1:n_show) {
    cat(sprintf("%-6s %-6s %8.4f %8.4f %10.3f\n",
                rv$Country1[i], rv$Country2[i],
                rv$nABCD[i], rv$absSMD[i], rv$ratio[i]))
  }

  # Also show low ratio (high SMD but low nABCD)
  rv2 <- rv[order(rv$ratio), ]
  cat(sprintf("\n--- %s: Top 5 low nABCD/|SMD| ratio ---\n", v))
  cat(sprintf("%-6s %-6s %8s %8s %10s\n", "Cntry1", "Cntry2", "nABCD", "|SMD|", "Ratio"))
  for (i in 1:n_show) {
    cat(sprintf("%-6s %-6s %8.4f %8.4f %10.3f\n",
                rv2$Country1[i], rv2$Country2[i],
                rv2$nABCD[i], rv2$absSMD[i], rv2$ratio[i]))
  }
}

# ===========================================================================
# 6. Asia Focus: INDI, SING, HONG vs European countries
# ===========================================================================
cat("\n\n============================================================\n")
cat("  Asia (INDI, SING, HONG) vs European Countries\n")
cat("============================================================\n")

asia <- c("INDI", "SING", "HONG")
europe <- c("UK", "ITAL", "SWIT", "POLA", "NETH", "SWED", "SPAI", "CZEC",
            "PORT", "BELG", "AUST", "GREE", "HUNG", "SLOK", "FINL",
            "EIRE", "SLOV", "DENM")
# Keep only those with n>=50
europe <- intersect(europe, countries)
asia <- intersect(asia, countries)

cat(sprintf("\n%-6s %-6s %10s %10s %10s %10s %10s %10s\n",
            "Asia", "Europe",
            "nABCD_AGE", "|SMD|_AGE",
            "nABCD_SBP", "|SMD|_SBP",
            "nABCD_DLY", "|SMD|_DLY"))

for (a in asia) {
  for (e in europe) {
    vals <- character(0)
    for (v in vars) {
      x <- ist[[v]][ist$COUNTRY == a]
      y <- ist[[v]][ist$COUNTRY == e]
      x <- x[!is.na(x)]
      y <- y[!is.na(y)]
      nab <- compute_nABCD(x, y)
      smd <- abs(compute_smd(x, y))
      vals <- c(vals, sprintf("%10.4f %10.4f", nab, smd))
    }
    cat(sprintf("%-6s %-6s %s\n", a, e, paste(vals, collapse = " ")))
  }
}

# Summary by Asian country
cat("\n--- Average nABCD (Asia vs Europe) ---\n")
cat(sprintf("%-6s %10s %10s %10s\n", "Asia", "AGE", "RSBP", "RDELAY"))
for (a in asia) {
  means <- sapply(vars, function(v) {
    nabs <- sapply(europe, function(e) {
      x <- ist[[v]][ist$COUNTRY == a]
      y <- ist[[v]][ist$COUNTRY == e]
      x <- x[!is.na(x)]
      y <- y[!is.na(y)]
      compute_nABCD(x, y)
    })
    mean(nabs, na.rm = TRUE)
  })
  cat(sprintf("%-6s %10.4f %10.4f %10.4f\n", a, means[1], means[2], means[3]))
}

# ===========================================================================
# 7. Rank correlation (Spearman) between nABCD and |SMD|
# ===========================================================================
cat("\n\n============================================================\n")
cat("  Rank Correlation: Spearman rho(nABCD, |SMD|)\n")
cat("============================================================\n")
for (v in vars) {
  res <- all_results[[v]]
  valid <- !is.na(res$nABCD) & !is.na(res$absSMD)
  rho <- cor(res$nABCD[valid], res$absSMD[valid], method = "spearman")
  r_p <- cor(res$nABCD[valid], res$absSMD[valid], method = "pearson")
  cat(sprintf("%-8s  Pearson r = %.4f,  Spearman rho = %.4f\n", v, r_p, rho))
}

cat("\n=== ANALYSIS COMPLETE ===\n")
