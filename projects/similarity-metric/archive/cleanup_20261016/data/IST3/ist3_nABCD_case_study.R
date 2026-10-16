## IST-3 Case Study: nABCD for Continuous Effect Modifiers
## Effect modifiers for alteplase (Emberson et al. Lancet 2014):
##   1. Age (years) — confirmed EM
##   2. Treatment delay (hours from onset to treatment) — confirmed EM
##   3. NIHSS (baseline stroke severity score) — confirmed EM
## DOI: 10.1016/S0140-6736(14)60584-5

ist3 <- read.csv("ist3_full_vars.csv", stringsAsFactors = FALSE)

# Convert and clean
ist3$age <- as.numeric(ist3$age)
ist3$nihss <- as.numeric(ist3$nihss)
ist3$treatdelay <- as.numeric(ist3$treatdelay)

cat("=== IST-3 Case Study Data Summary ===\n")
cat("Total N:", nrow(ist3), "\n")
cat("Countries:", length(unique(ist3$country)), "\n\n")

# Country counts
ct <- sort(table(ist3$country), decreasing = TRUE)
print(ct)

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

# --- Analysis for each EM variable ---
countries <- names(ct[ct >= 50])
countries <- countries[countries != "OTHER"]

cat("\n=== Countries included (N >= 50, excl. OTHER) ===\n")
for (c in countries) cat(sprintf("  %s: N=%d\n", c, ct[c]))

em_vars <- list(
  list(name = "Age", col = "age", unit = "years"),
  list(name = "Treatment Delay", col = "treatdelay", unit = "hours"),
  list(name = "NIHSS", col = "nihss", unit = "score")
)

all_results <- list()

for (em in em_vars) {
  vname <- em$name
  vcol <- em$col

  cat(sprintf("\n\n========================================\n"))
  cat(sprintf("=== nABCD(%s): Pairwise Country Comparison ===\n", vname))
  cat(sprintf("========================================\n"))

  # Descriptive stats by country
  cat(sprintf("\n--- %s by Country ---\n", vname))
  cat(sprintf("%-12s %5s %8s %7s %7s %15s\n",
              "Country", "N", "Mean", "SD", "Median", "IQR"))
  for (c in countries) {
    d <- ist3[[vcol]][ist3$country == c]
    d <- d[!is.na(d)]
    cat(sprintf("%-12s %5d %8.2f %7.2f %7.1f [%6.1f, %6.1f]\n",
                c, length(d), mean(d), sd(d), median(d),
                quantile(d, .25), quantile(d, .75)))
  }

  # Pairwise nABCD
  results <- data.frame(
    Country1 = character(), Country2 = character(),
    n1 = integer(), n2 = integer(),
    mean1 = numeric(), mean2 = numeric(),
    W1 = numeric(), IQR_pooled = numeric(), nABCD = numeric(),
    stringsAsFactors = FALSE
  )

  for (i in 1:(length(countries) - 1)) {
    for (j in (i + 1):length(countries)) {
      x <- ist3[[vcol]][ist3$country == countries[i]]
      y <- ist3[[vcol]][ist3$country == countries[j]]
      x <- x[!is.na(x)]
      y <- y[!is.na(y)]
      if (length(x) < 10 || length(y) < 10) next
      w1 <- compute_w1(x, y)
      iqr_p <- IQR(c(x, y), na.rm = TRUE)
      nab <- if (iqr_p > 0) w1 / iqr_p else NA
      results <- rbind(results, data.frame(
        Country1 = countries[i], Country2 = countries[j],
        n1 = length(x), n2 = length(y),
        mean1 = round(mean(x), 2), mean2 = round(mean(y), 2),
        W1 = round(w1, 4), IQR_pooled = round(iqr_p, 2),
        nABCD = round(nab, 4),
        stringsAsFactors = FALSE
      ))
    }
  }

  results <- results[order(results$nABCD), ]

  cat(sprintf("\n%-12s %-12s %5s %5s %7s %7s %8s %7s %8s\n",
              "Country1", "Country2", "n1", "n2", "mean1", "mean2",
              "W1", "IQR_p", "nABCD"))
  cat(strrep("-", 80), "\n")
  for (r in 1:nrow(results)) {
    cat(sprintf("%-12s %-12s %5d %5d %7.2f %7.2f %8.4f %7.2f %8.4f\n",
                results$Country1[r], results$Country2[r],
                results$n1[r], results$n2[r],
                results$mean1[r], results$mean2[r],
                results$W1[r], results$IQR_pooled[r], results$nABCD[r]))
  }

  cat(sprintf("\nnABCD(%s) Summary:\n", vname))
  cat(sprintf("  Range:  %.4f - %.4f\n", min(results$nABCD, na.rm = TRUE),
              max(results$nABCD, na.rm = TRUE)))
  cat(sprintf("  Mean:   %.4f\n", mean(results$nABCD, na.rm = TRUE)))
  cat(sprintf("  Median: %.4f\n", median(results$nABCD, na.rm = TRUE)))

  # Store for cross-variable comparison
  results$Variable <- vname
  all_results[[vname]] <- results
}

# --- Cross-variable comparison ---
cat("\n\n========================================\n")
cat("=== Cross-Variable nABCD Comparison ===\n")
cat("========================================\n\n")

combined <- do.call(rbind, all_results)

cat(sprintf("%-20s %8s %8s %8s %8s\n",
            "Variable", "Min", "Median", "Mean", "Max"))
cat(strrep("-", 56), "\n")
for (em in em_vars) {
  d <- combined$nABCD[combined$Variable == em$name]
  cat(sprintf("%-20s %8.4f %8.4f %8.4f %8.4f\n",
              em$name, min(d, na.rm = TRUE), median(d, na.rm = TRUE),
              mean(d, na.rm = TRUE), max(d, na.rm = TRUE)))
}

# --- Matrix format for each variable ---
for (em in em_vars) {
  res <- all_results[[em$name]]
  cat(sprintf("\n=== nABCD Matrix: %s ===\n", em$name))
  cat(sprintf("%-12s", ""))
  for (j in countries) cat(sprintf("%-10s", j))
  cat("\n")
  for (i in countries) {
    cat(sprintf("%-12s", i))
    for (j in countries) {
      if (i == j) {
        cat(sprintf("%-10s", "---"))
      } else {
        idx <- which((res$Country1 == i & res$Country2 == j) |
                     (res$Country1 == j & res$Country2 == i))
        if (length(idx) > 0) {
          cat(sprintf("%-10s", sprintf("%.4f", res$nABCD[idx])))
        } else {
          cat(sprintf("%-10s", ""))
        }
      }
    }
    cat("\n")
  }
}

# --- Bootstrap CI for selected pairs ---
cat("\n\n========================================\n")
cat("=== Bootstrap 95% CI (selected pairs) ===\n")
cat("========================================\n\n")

set.seed(42)
B <- 2000

boot_nABCD <- function(x, y, B) {
  n1 <- length(x)
  n2 <- length(y)
  boot_vals <- numeric(B)
  for (b in 1:B) {
    xb <- sample(x, n1, replace = TRUE)
    yb <- sample(y, n2, replace = TRUE)
    w1b <- compute_w1(xb, yb)
    iqrb <- IQR(c(xb, yb), na.rm = TRUE)
    boot_vals[b] <- if (iqrb > 0) w1b / iqrb else NA
  }
  boot_vals
}

# Select 3 pairs: most similar, middle, most different (for Age)
age_res <- all_results[["Age"]]
pairs_idx <- c(1, ceiling(nrow(age_res)/2), nrow(age_res))

cat(sprintf("%-12s %-12s %-8s %10s %18s\n",
            "Country1", "Country2", "Var", "nABCD", "95% CI"))
cat(strrep("-", 65), "\n")

for (em in em_vars) {
  res <- all_results[[em$name]]
  for (pi in pairs_idx) {
    c1 <- res$Country1[pi]
    c2 <- res$Country2[pi]
    x <- ist3[[em$col]][ist3$country == c1]
    y <- ist3[[em$col]][ist3$country == c2]
    x <- x[!is.na(x)]
    y <- y[!is.na(y)]
    bvals <- boot_nABCD(x, y, B)
    ci <- quantile(bvals, c(0.025, 0.975), na.rm = TRUE)
    cat(sprintf("%-12s %-12s %-8s %10.4f [%7.4f, %7.4f]\n",
                c1, c2, em$name, res$nABCD[pi], ci[1], ci[2]))
  }
}

cat("\n=== CASE STUDY COMPLETE ===\n")
