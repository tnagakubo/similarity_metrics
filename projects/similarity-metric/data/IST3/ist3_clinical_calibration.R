## IST-3 Clinical Calibration: Delta_max for each EM
## Formula: Delta_max = 2 * L * IQR_pooled * nABCD
## L = CATE sensitivity (Lipschitz constant of tau(x))
## Estimated from treatment x EM interaction in logistic regression

ist3 <- read.csv("ist3_full_vars.csv", stringsAsFactors = FALSE)

# Binary outcome: good outcome = ohs6 <= 2 (mRS 0-2 equivalent)
ist3$good <- as.integer(ist3$ohs6 <= 2)

cat("=== IST-3 Clinical Calibration ===\n\n")
cat("Outcome: Good outcome (OHS 0-2 at 6 months)\n")
cat("Overall good outcome rate:", sprintf("%.1f%%\n",
    100 * mean(ist3$good, na.rm = TRUE)))
cat("  Control:", sprintf("%.1f%%\n",
    100 * mean(ist3$good[ist3$itt_treat == 0], na.rm = TRUE)))
cat("  Alteplase:", sprintf("%.1f%%\n",
    100 * mean(ist3$good[ist3$itt_treat == 1], na.rm = TRUE)))

# Overall treatment effect (risk difference)
rd_overall <- mean(ist3$good[ist3$itt_treat == 1], na.rm = TRUE) -
              mean(ist3$good[ist3$itt_treat == 0], na.rm = TRUE)
cat(sprintf("Overall RD: %.4f (%.1f%%)\n\n", rd_overall, 100 * rd_overall))

# --- Step 1: Estimate L for each EM ---
# L = |d(RD)/d(EM)| = rate of change of treatment effect per unit EM
# Approach: marginal standardization from logistic interaction model

em_vars <- list(
  list(name = "Age", col = "age", unit = "years"),
  list(name = "Treatment Delay", col = "treatdelay", unit = "hours"),
  list(name = "NIHSS", col = "nihss", unit = "score")
)

cat("========================================\n")
cat("=== Step 1: CATE Sensitivity (L) Estimation ===\n")
cat("========================================\n\n")

L_estimates <- list()

for (em in em_vars) {
  vcol <- em$col
  vname <- em$name

  d <- ist3[!is.na(ist3[[vcol]]) & !is.na(ist3$good), ]

  # Center the EM variable for numerical stability
  em_mean <- mean(d[[vcol]])
  em_sd <- sd(d[[vcol]])
  d$em_c <- (d[[vcol]] - em_mean) / em_sd

  # Logistic regression with interaction
  fit <- glm(good ~ itt_treat * em_c, data = d, family = binomial)

  cat(sprintf("--- %s (N=%d) ---\n", vname, nrow(d)))
  cat("Logistic model: good ~ treat * em_centered\n")

  # Extract interaction coefficient
  coefs <- summary(fit)$coefficients
  int_coef <- coefs["itt_treat:em_c", "Estimate"]
  int_se <- coefs["itt_treat:em_c", "Std. Error"]
  int_p <- coefs["itt_treat:em_c", "Pr(>|z|)"]

  cat(sprintf("Interaction coef (log-OR scale): %.4f (SE=%.4f, p=%.4f)\n",
              int_coef, int_se, int_p))

  # Convert to risk difference scale via marginal standardization
  # L = |d(RD)/d(EM)| estimated at multiple EM values
  em_grid <- seq(quantile(d[[vcol]], 0.1), quantile(d[[vcol]], 0.9),
                 length.out = 20)

  rd_at_em <- sapply(em_grid, function(x) {
    d_temp <- d
    d_temp[[vcol]] <- x
    d_temp$em_c <- (x - em_mean) / em_sd
    p1 <- predict(fit, newdata = transform(d_temp, itt_treat = 1),
                  type = "response")
    p0 <- predict(fit, newdata = transform(d_temp, itt_treat = 0),
                  type = "response")
    mean(p1 - p0)
  })

  # L = max |d(RD)/d(EM)| over the grid (Lipschitz constant)
  drd_dem <- diff(rd_at_em) / diff(em_grid)
  L_max <- max(abs(drd_dem))
  L_mean <- mean(abs(drd_dem))

  cat(sprintf("RD range over EM grid: %.4f to %.4f\n",
              min(rd_at_em), max(rd_at_em)))
  cat(sprintf("L (max |dRD/dEM|): %.6f per %s\n", L_max, em$unit))
  cat(sprintf("L (mean |dRD/dEM|): %.6f per %s\n", L_mean, em$unit))
  cat("\n")

  L_estimates[[vname]] <- list(L_max = L_max, L_mean = L_mean,
                                rd_range = range(rd_at_em),
                                int_p = int_p)
}

# --- Step 2: Compute Delta_max for each EM x country pair ---
cat("\n========================================\n")
cat("=== Step 2: Delta_max = 2 * L * IQR_pooled * nABCD ===\n")
cat("========================================\n\n")

compute_w1 <- function(x, y) {
  ecdf1 <- ecdf(x)
  ecdf2 <- ecdf(y)
  pooled <- sort(c(x, y))
  vals <- ecdf1(pooled) - ecdf2(pooled)
  diffs <- diff(pooled)
  abs_cdf_diff <- abs(vals[-length(vals)])
  sum(abs_cdf_diff * diffs)
}

ct <- sort(table(ist3$country), decreasing = TRUE)
countries <- names(ct[ct >= 50])
countries <- countries[countries != "OTHER"]

# Results table
cal_results <- data.frame(
  Variable = character(), Country1 = character(), Country2 = character(),
  nABCD = numeric(), IQR_pooled = numeric(),
  L = numeric(), Delta_max = numeric(), Delta_max_pct = numeric(),
  stringsAsFactors = FALSE
)

for (em in em_vars) {
  vcol <- em$col
  vname <- em$name
  L <- L_estimates[[vname]]$L_max

  cat(sprintf("\n--- %s (L = %.6f per %s) ---\n", vname, L, em$unit))
  cat(sprintf("%-12s %-12s %8s %8s %10s %10s\n",
              "Country1", "Country2", "nABCD", "IQR_p", "Delta_max", "% of RD"))
  cat(strrep("-", 64), "\n")

  for (i in 1:(length(countries) - 1)) {
    for (j in (i + 1):length(countries)) {
      x <- ist3[[vcol]][ist3$country == countries[i]]
      y <- ist3[[vcol]][ist3$country == countries[j]]
      x <- x[!is.na(x)]
      y <- y[!is.na(y)]
      if (length(x) < 10 || length(y) < 10) next

      w1 <- compute_w1(x, y)
      iqr_p <- IQR(c(x, y), na.rm = TRUE)
      nab <- if (iqr_p > 0) w1 / (2 * iqr_p) else NA
      dmax <- 2 * L * iqr_p * nab
      dmax_pct <- 100 * dmax / abs(rd_overall)

      cal_results <- rbind(cal_results, data.frame(
        Variable = vname, Country1 = countries[i], Country2 = countries[j],
        nABCD = round(nab, 4), IQR_pooled = round(iqr_p, 2),
        L = L, Delta_max = round(dmax, 4), Delta_max_pct = round(dmax_pct, 1),
        stringsAsFactors = FALSE
      ))

      cat(sprintf("%-12s %-12s %8.4f %8.2f %10.4f %9.1f%%\n",
                  countries[i], countries[j], nab, iqr_p, dmax, dmax_pct))
    }
  }
}

# --- Step 3: Summary by Variable ---
cat("\n\n========================================\n")
cat("=== Step 3: Clinical Calibration Summary ===\n")
cat("========================================\n\n")

cat(sprintf("Overall treatment effect (RD): %.4f (%.1f%%)\n\n",
            rd_overall, 100 * rd_overall))

cat(sprintf("%-20s %8s %8s %8s %10s %10s %10s\n",
            "Variable", "L", "nABCD_med", "nABCD_max",
            "Dmax_med", "Dmax_max", "Dmax_%_max"))
cat(strrep("-", 82), "\n")

for (em in em_vars) {
  d <- cal_results[cal_results$Variable == em$name, ]
  cat(sprintf("%-20s %8.6f %8.4f %8.4f %10.4f %10.4f %9.1f%%\n",
              em$name,
              L_estimates[[em$name]]$L_max,
              median(d$nABCD, na.rm = TRUE),
              max(d$nABCD, na.rm = TRUE),
              median(d$Delta_max, na.rm = TRUE),
              max(d$Delta_max, na.rm = TRUE),
              max(d$Delta_max_pct, na.rm = TRUE)))
}

# --- Step 4: Ranking reversal check ---
cat("\n\n========================================\n")
cat("=== Step 4: Ranking Reversal Analysis ===\n")
cat("========================================\n")
cat("(Does the nABCD ranking match the Delta_max ranking?)\n\n")

# For each country pair, compare ranking across variables
# Take top-5 most different pairs for each variable
for (em in em_vars) {
  d <- cal_results[cal_results$Variable == em$name, ]
  d <- d[order(-d$nABCD), ]
  cat(sprintf("Top 3 by nABCD (%s): ", em$name))
  for (k in 1:min(3, nrow(d))) {
    cat(sprintf("%s-%s(%.3f/%.4f) ", d$Country1[k], d$Country2[k],
                d$nABCD[k], d$Delta_max[k]))
  }
  cat("\n")

  d <- d[order(-d$Delta_max), ]
  cat(sprintf("Top 3 by Dmax  (%s): ", em$name))
  for (k in 1:min(3, nrow(d))) {
    cat(sprintf("%s-%s(%.3f/%.4f) ", d$Country1[k], d$Country2[k],
                d$nABCD[k], d$Delta_max[k]))
  }
  cat("\n\n")
}

# --- Step 5: Cross-variable ranking ---
cat("=== Cross-Variable: Highest Delta_max pairs ===\n\n")
cal_results <- cal_results[order(-cal_results$Delta_max), ]
cat(sprintf("%-20s %-12s %-12s %8s %10s %10s\n",
            "Variable", "Country1", "Country2", "nABCD", "Delta_max", "% of RD"))
cat(strrep("-", 76), "\n")
for (k in 1:min(15, nrow(cal_results))) {
  cat(sprintf("%-20s %-12s %-12s %8.4f %10.4f %9.1f%%\n",
              cal_results$Variable[k], cal_results$Country1[k],
              cal_results$Country2[k], cal_results$nABCD[k],
              cal_results$Delta_max[k], cal_results$Delta_max_pct[k]))
}

cat("\n=== CLINICAL CALIBRATION COMPLETE ===\n")
