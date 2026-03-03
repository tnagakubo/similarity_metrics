## IST v2 — nABCD Exploratory Analysis
## Purpose: Assess regional EM distribution differences using IST trial data

ist <- read.csv("projects/similarity-metric/data/IST/IST_corrected.csv")

# --- Regional groupings (ICH E17 style) ---
ist$REGION <- NA_character_
ist$REGION[ist$COUNTRY %in% c("UK", "EIRE")] <- "UK/Ireland"
ist$REGION[ist$COUNTRY %in% c("ITAL", "SWIT", "SPAI", "PORT", "BELG", "GREE", "FRAN", "AUST")] <- "W.Europe"
ist$REGION[ist$COUNTRY %in% c("POLA", "CZEC", "HUNG", "SLOK", "SLOV", "ROMA")] <- "CE.Europe"
ist$REGION[ist$COUNTRY %in% c("SWED", "NORW", "FINL", "DENM", "NETH")] <- "N.Europe"
ist$REGION[ist$COUNTRY %in% c("AUSL", "NEW")] <- "Oceania"
ist$REGION[ist$COUNTRY %in% c("ARGE", "BRAS", "CHIL")] <- "S.America"
ist$REGION[ist$COUNTRY %in% c("INDI", "SING", "HONG", "JAPA", "SRI")] <- "Asia"
ist$REGION[ist$COUNTRY %in% c("SOUT")] <- "Africa"
ist$REGION[ist$COUNTRY %in% c("USA", "CANA")] <- "N.America"
ist$REGION[ist$COUNTRY %in% c("ISRA", "TURK")] <- "MidEast"

cat("\n=== REGION distribution ===\n")
rt <- sort(table(ist$REGION), decreasing = TRUE)
print(rt)

# --- Summary statistics by region ---
summary_by_region <- function(var, varname) {
  cat(sprintf("\n=== %s by Region ===\n", varname))
  for (r in names(rt)) {
    d <- ist[[var]][ist$REGION == r]
    d <- d[!is.na(d)]
    cat(sprintf("%-15s n=%5d mean=%6.1f sd=%5.1f med=%5.0f IQR=[%4.0f,%4.0f]\n",
                r, length(d), mean(d), sd(d), median(d),
                quantile(d, .25), quantile(d, .75)))
  }
}

summary_by_region("AGE", "Age (years)")
summary_by_region("RSBP", "SBP (mmHg)")
summary_by_region("RDELAY", "Delay (hours)")

# --- W1 (Wasserstein-1) computation ---
compute_w1 <- function(x, y) {
  # W1 = integral |F1(t) - F2(t)| dt = area between CDFs
  n1 <- length(x)
  n2 <- length(y)
  pooled <- sort(c(x, y))
  # Compute empirical CDFs at pooled points
  ecdf1 <- ecdf(x)
  ecdf2 <- ecdf(y)
  vals <- ecdf1(pooled) - ecdf2(pooled)
  # Riemann sum
  diffs <- diff(pooled)
  abs_cdf_diff <- abs(vals[-length(vals)])
  sum(abs_cdf_diff * diffs)
}

# --- nABCD = W1 / (2 * IQR_pooled) ---
compute_nABCD <- function(x, y) {
  w1 <- compute_w1(x, y)
  pooled <- c(x, y)
  iqr_pooled <- IQR(pooled, na.rm = TRUE)
  if (iqr_pooled == 0) return(NA)
  w1 / (2 * iqr_pooled)
}

# --- Compute nABCD for all region pairs (top 6 regions) ---
top_regions <- names(head(rt, 6))
vars <- c("AGE", "RSBP", "RDELAY")

cat("\n\n========================================\n")
cat("=== nABCD: Pairwise Region Comparison ===\n")
cat("========================================\n")

for (v in vars) {
  cat(sprintf("\n--- %s ---\n", v))
  cat(sprintf("%-20s", ""))
  for (j in 2:length(top_regions)) cat(sprintf("%-15s", top_regions[j]))
  cat("\n")

  for (i in 1:(length(top_regions) - 1)) {
    cat(sprintf("%-20s", top_regions[i]))
    for (j in 2:length(top_regions)) {
      if (j <= i) {
        cat(sprintf("%-15s", ""))
      } else {
        x <- ist[[v]][ist$REGION == top_regions[i]]
        y <- ist[[v]][ist$REGION == top_regions[j]]
        x <- x[!is.na(x)]
        y <- y[!is.na(y)]
        val <- compute_nABCD(x, y)
        cat(sprintf("%-15s", sprintf("%.4f", val)))
      }
    }
    cat("\n")
  }
}

# --- Focus comparison: Asia vs major regions ---
cat("\n\n=== Asia vs Other Regions (all 3 variables) ===\n")
cat(sprintf("%-20s %-10s %-10s %-10s\n", "Region Pair", "Age", "SBP", "Delay"))
asia_data <- ist[ist$REGION == "Asia", ]
for (r in setdiff(names(rt), "Asia")) {
  other_data <- ist[ist$REGION == r, ]
  vals <- sapply(vars, function(v) {
    x <- asia_data[[v]][!is.na(asia_data[[v]])]
    y <- other_data[[v]][!is.na(other_data[[v]])]
    if (length(x) < 10 || length(y) < 10) return(NA)
    compute_nABCD(x, y)
  })
  cat(sprintf("Asia vs %-12s %-10s %-10s %-10s\n", r,
              sprintf("%.4f", vals[1]), sprintf("%.4f", vals[2]), sprintf("%.4f", vals[3])))
}

cat("\n=== DONE ===\n")
