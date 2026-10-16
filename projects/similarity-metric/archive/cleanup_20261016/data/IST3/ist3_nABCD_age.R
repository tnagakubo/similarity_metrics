## IST-3: nABCD Analysis — Age (confirmed EM for alteplase)
## Emberson et al. Lancet 2014: age modifies alteplase effect

ist3 <- read.csv("ist3_key_vars.csv")
ist3$age <- as.numeric(ist3$age)
ist3 <- ist3[!is.na(ist3$age), ]

cat("=== IST-3 Data Summary ===\n")
cat("Total N:", nrow(ist3), "\n")
cat("Countries:", length(unique(ist3$country)), "\n\n")

# Country counts
ct <- sort(table(ist3$country), decreasing = TRUE)
print(ct)

# Age summary by country
cat("\n=== Age by Country ===\n")
cat(sprintf("%-12s %5s %6s %5s %5s %7s\n", "Country", "N", "Mean", "SD", "Med", "IQR"))
for (c in names(ct)) {
  d <- ist3$age[ist3$country == c]
  cat(sprintf("%-12s %5d %6.1f %5.1f %5.0f [%4.0f,%3.0f]\n",
              c, length(d), mean(d), sd(d), median(d),
              quantile(d, .25), quantile(d, .75)))
}

# --- W1 (Wasserstein-1) ---
compute_w1 <- function(x, y) {
  ecdf1 <- ecdf(x)
  ecdf2 <- ecdf(y)
  pooled <- sort(c(x, y))
  vals <- ecdf1(pooled) - ecdf2(pooled)
  diffs <- diff(pooled)
  abs_cdf_diff <- abs(vals[-length(vals)])
  sum(abs_cdf_diff * diffs)
}

# --- nABCD = W1 / IQR_pooled ---
compute_nABCD <- function(x, y) {
  w1 <- compute_w1(x, y)
  pooled <- c(x, y)
  iqr_pooled <- IQR(pooled, na.rm = TRUE)
  if (iqr_pooled == 0) return(NA)
  w1 / iqr_pooled
}

# --- All pairwise nABCD for Age ---
# Exclude OTHER (heterogeneous group)
countries <- names(ct[ct >= 50])
countries <- countries[countries != "OTHER"]

cat("\n\n====================================\n")
cat("=== nABCD(Age): Pairwise Country Comparison ===\n")
cat("====================================\n")
cat("(Age = confirmed EM for alteplase, Emberson et al. Lancet 2014)\n\n")

results <- data.frame(
  Country1 = character(),
  Country2 = character(),
  n1 = integer(),
  n2 = integer(),
  W1 = numeric(),
  IQR_pooled = numeric(),
  nABCD = numeric(),
  stringsAsFactors = FALSE
)

for (i in 1:(length(countries) - 1)) {
  for (j in (i + 1):length(countries)) {
    x <- ist3$age[ist3$country == countries[i]]
    y <- ist3$age[ist3$country == countries[j]]
    w1 <- compute_w1(x, y)
    iqr_p <- IQR(c(x, y), na.rm = TRUE)
    nab <- if (iqr_p > 0) w1 / iqr_p else NA
    results <- rbind(results, data.frame(
      Country1 = countries[i], Country2 = countries[j],
      n1 = length(x), n2 = length(y),
      W1 = round(w1, 2), IQR_pooled = round(iqr_p, 2),
      nABCD = round(nab, 4),
      stringsAsFactors = FALSE
    ))
  }
}

# Sort by nABCD
results <- results[order(results$nABCD), ]

cat(sprintf("%-12s %-12s %5s %5s %7s %7s %8s\n",
            "Country1", "Country2", "n1", "n2", "W1", "IQR_p", "nABCD"))
cat(strrep("-", 62), "\n")
for (r in 1:nrow(results)) {
  cat(sprintf("%-12s %-12s %5d %5d %7.2f %7.2f %8.4f\n",
              results$Country1[r], results$Country2[r],
              results$n1[r], results$n2[r],
              results$W1[r], results$IQR_pooled[r], results$nABCD[r]))
}

cat("\n=== Summary Statistics ===\n")
cat("nABCD range:", sprintf("%.4f - %.4f\n", min(results$nABCD, na.rm=TRUE), max(results$nABCD, na.rm=TRUE)))
cat("nABCD mean:", sprintf("%.4f\n", mean(results$nABCD, na.rm=TRUE)))
cat("nABCD median:", sprintf("%.4f\n", median(results$nABCD, na.rm=TRUE)))

# Matrix format
cat("\n=== nABCD Matrix ===\n")
cat(sprintf("%-12s", ""))
for (j in countries) cat(sprintf("%-10s", j))
cat("\n")
for (i in countries) {
  cat(sprintf("%-12s", i))
  for (j in countries) {
    if (i == j) {
      cat(sprintf("%-10s", "---"))
    } else {
      idx <- which((results$Country1 == i & results$Country2 == j) |
                   (results$Country1 == j & results$Country2 == i))
      if (length(idx) > 0) {
        cat(sprintf("%-10s", sprintf("%.4f", results$nABCD[idx])))
      } else {
        cat(sprintf("%-10s", ""))
      }
    }
  }
  cat("\n")
}

# Treatment effect by country (descriptive)
cat("\n\n=== Treatment Allocation by Country ===\n")
cat(sprintf("%-12s %5s %7s %7s\n", "Country", "N", "Control", "Altep."))
for (c in countries) {
  d <- ist3[ist3$country == c, ]
  cat(sprintf("%-12s %5d %7d %7d\n", c, nrow(d),
              sum(d$itt_treat == 0), sum(d$itt_treat == 1)))
}

# Age distribution by treatment x country (for EM assessment)
cat("\n=== Age by Treatment Group (Alteplase EM check) ===\n")
cat(sprintf("%-12s %-10s %5s %6s %5s\n", "Country", "Group", "N", "Mean", "SD"))
for (c in countries) {
  for (trt in c(0, 1)) {
    d <- ist3$age[ist3$country == c & ist3$itt_treat == trt]
    lbl <- if (trt == 0) "Control" else "Alteplase"
    cat(sprintf("%-12s %-10s %5d %6.1f %5.1f\n", c, lbl, length(d), mean(d), sd(d)))
  }
}

cat("\n=== DONE ===\n")
