## Belgium-anchor nABCD analysis for paper rewrite
ist3 <- read.csv("ist3_full_vars.csv", stringsAsFactors = FALSE)
ist3$age <- as.numeric(ist3$age)
ist3$nihss <- as.numeric(ist3$nihss)
ist3$treatdelay <- as.numeric(ist3$treatdelay)

compute_w1 <- function(x, y) {
  ecdf1 <- ecdf(x)
  ecdf2 <- ecdf(y)
  pooled <- sort(c(x, y))
  vals <- ecdf1(pooled) - ecdf2(pooled)
  diffs <- diff(pooled)
  abs_cdf_diff <- abs(vals[-length(vals)])
  sum(abs_cdf_diff * diffs)
}

ct <- table(ist3$country)
countries <- names(ct[ct >= 50])
countries <- countries[countries != "OTHER"]

cat("=== Belgium-Anchor nABCD ===\n")
cat(sprintf("%-12s %8s %8s %8s\n", "Partner", "Age", "NIHSS", "Delay"))
for (partner in setdiff(countries, "BELGIUM")) {
  vals <- numeric(3)
  cols <- c("age", "nihss", "treatdelay")
  for (i in 1:3) {
    x <- ist3[[cols[i]]][ist3$country == "BELGIUM"]
    y <- ist3[[cols[i]]][ist3$country == partner]
    x <- x[!is.na(x)]
    y <- y[!is.na(y)]
    w1 <- compute_w1(x, y)
    iqr_p <- IQR(c(x, y), na.rm = TRUE)
    vals[i] <- if (iqr_p > 0) w1 / (2 * iqr_p) else NA
  }
  cat(sprintf("%-12s %8.4f %8.4f %8.4f\n", partner, vals[1], vals[2], vals[3]))
}

cat("\n=== Belgium-Anchor Delta_max (NIHSS, L=0.00950) ===\n")
L_nihss <- 0.00950
for (partner in setdiff(countries, "BELGIUM")) {
  x <- ist3$nihss[ist3$country == "BELGIUM"]
  y <- ist3$nihss[ist3$country == partner]
  x <- x[!is.na(x)]
  y <- y[!is.na(y)]
  w1 <- compute_w1(x, y)
  iqr_p <- IQR(c(x, y), na.rm = TRUE)
  nab <- if (iqr_p > 0) w1 / (2 * iqr_p) else NA
  dmax <- 2 * L_nihss * iqr_p * nab
  cat(sprintf("%-12s nABCD=%6.4f IQR=%5.2f Dmax=%5.2f%%pt\n",
              partner, nab, iqr_p, dmax * 100))
}

cat("\n=== Belgium-Anchor Delta_max (Age, L=0.00065) ===\n")
L_age <- 0.00065
for (partner in setdiff(countries, "BELGIUM")) {
  x <- ist3$age[ist3$country == "BELGIUM"]
  y <- ist3$age[ist3$country == partner]
  x <- x[!is.na(x)]
  y <- y[!is.na(y)]
  w1 <- compute_w1(x, y)
  iqr_p <- IQR(c(x, y), na.rm = TRUE)
  nab <- if (iqr_p > 0) w1 / (2 * iqr_p) else NA
  dmax <- 2 * L_age * iqr_p * nab
  cat(sprintf("%-12s nABCD=%6.4f IQR=%5.2f Dmax=%5.2f%%pt\n",
              partner, nab, iqr_p, dmax * 100))
}
