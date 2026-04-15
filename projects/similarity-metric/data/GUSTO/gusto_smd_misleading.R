##############################################################################
## GUSTO-I: Systematic search for SMD-misleading cases
## Where |SMD| < threshold (negligible) but nABCD >= threshold (non-negligible)
##############################################################################

library(predtools)
library(moments)  # for skewness, kurtosis

data(gusto)

# --- Core functions ---
compute_w1 <- function(x, y) {
  all_vals <- sort(c(x, y)); n <- length(all_vals)
  if (n < 2) return(0)
  Fx <- ecdf(x); Fy <- ecdf(y)
  mids <- (all_vals[-n] + all_vals[-1]) / 2
  diffs <- diff(all_vals)
  sum(abs(Fx(mids) - Fy(mids)) * diffs)
}

compute_nABCD <- function(x, y) {
  iqr_p <- IQR(c(x, y)); if (iqr_p == 0) return(NA_real_)
  compute_w1(x, y) / (2 * iqr_p)
}

compute_smd <- function(x, y) {
  nx <- length(x); ny <- length(y)
  sp <- sqrt(((nx - 1) * var(x) + (ny - 1) * var(y)) / (nx + ny - 2))
  if (sp == 0) return(NA_real_)
  (mean(x) - mean(y)) / sp
}

# --- Setup ---
vars <- c("age", "sysbp", "pulse", "height", "weight")
regions <- sort(unique(gusto$regl))
n_regions <- length(regions)
pairs <- combn(regions, 2)
n_pairs <- ncol(pairs)

cat("=" , rep("=", 79), "\n", sep = "")
cat("GUSTO-I SMD-Misleading Analysis\n")
cat("N =", nrow(gusto), ", Regions =", n_regions, ", Pairs =", n_pairs,
    ", Variables =", length(vars), "\n")
cat("Total comparisons:", n_pairs * length(vars), "\n")
cat("=", rep("=", 79), "\n\n", sep = "")

# --- 1. Full pairwise computation ---
cat("### 1. Full Pairwise Computation ###\n\n")

results <- data.frame()

for (v in vars) {
  for (k in seq_len(n_pairs)) {
    ri <- pairs[1, k]; rj <- pairs[2, k]
    xi <- gusto[[v]][gusto$regl == ri]
    xj <- gusto[[v]][gusto$regl == rj]
    xi <- xi[!is.na(xi)]; xj <- xj[!is.na(xj)]
    if (length(xi) < 5 || length(xj) < 5) next

    nab <- compute_nABCD(xi, xj)
    smd_val <- compute_smd(xi, xj)
    sk_i <- skewness(xi); sk_j <- skewness(xj)
    sd_i <- sd(xi); sd_j <- sd(xj)
    ku_i <- kurtosis(xi); ku_j <- kurtosis(xj)

    results <- rbind(results, data.frame(
      variable = v, region_i = ri, region_j = rj,
      n_i = length(xi), n_j = length(xj),
      nABCD = round(nab, 5), abs_SMD = round(abs(smd_val), 5),
      SMD = round(smd_val, 5),
      skew_i = round(sk_i, 4), skew_j = round(sk_j, 4),
      skew_diff = round(abs(sk_i - sk_j), 4),
      sd_i = round(sd_i, 4), sd_j = round(sd_j, 4),
      sd_ratio = round(max(sd_i, sd_j) / min(sd_i, sd_j), 4),
      kurt_i = round(ku_i, 4), kurt_j = round(ku_j, 4),
      kurt_diff = round(abs(ku_i - ku_j), 4),
      stringsAsFactors = FALSE
    ))
  }
}

results$ratio <- ifelse(results$abs_SMD >= 0.01,
                         round(results$nABCD / results$abs_SMD, 4), NA)

cat("Total rows computed:", nrow(results), "\n\n")

# Show summary per variable
for (v in vars) {
  sub <- results[results$variable == v, ]
  cat(sprintf("  %s: nABCD range [%.4f, %.4f], |SMD| range [%.4f, %.4f]\n",
              v, min(sub$nABCD, na.rm = TRUE), max(sub$nABCD, na.rm = TRUE),
              min(sub$abs_SMD, na.rm = TRUE), max(sub$abs_SMD, na.rm = TRUE)))
}

# --- 2. SMD Misleading Cases ---
cat("\n\n### 2. SMD Misleading Cases ###\n")

show_misleading <- function(df, smd_thresh, nab_thresh, label) {
  sub <- df[!is.na(df$nABCD) & !is.na(df$abs_SMD) &
              df$abs_SMD < smd_thresh & df$nABCD >= nab_thresh, ]
  sub <- sub[order(-sub$nABCD), ]
  cat(sprintf("\n--- %s: |SMD| < %.2f & nABCD >= %.2f  (%d cases) ---\n",
              label, smd_thresh, nab_thresh, nrow(sub)))
  if (nrow(sub) == 0) {
    cat("  No cases found.\n")
    return(invisible(sub))
  }
  cat(sprintf("  %-8s  R_i  R_j  %8s  %8s  %8s  %8s  %8s\n",
              "Variable", "nABCD", "|SMD|", "skew_diff", "sd_ratio", "ratio"))
  for (i in seq_len(nrow(sub))) {
    r <- sub[i, ]
    cat(sprintf("  %-8s  %3d  %3d  %8.4f  %8.4f  %8.4f  %8.4f  %8.2f\n",
                r$variable, r$region_i, r$region_j,
                r$nABCD, r$abs_SMD, r$skew_diff, r$sd_ratio,
                ifelse(is.na(r$ratio), 0, r$ratio)))
  }
  return(invisible(sub))
}

m1 <- show_misleading(results, 0.10, 0.05, "Strict")
m2 <- show_misleading(results, 0.15, 0.05, "Moderate")
m3 <- show_misleading(results, 0.20, 0.10, "Relaxed")

# --- 3. nABCD / SMD Ratio Analysis ---
cat("\n\n### 3. nABCD / |SMD| Ratio Analysis ###\n")
cat("(Excluding |SMD| < 0.01 to avoid division instability)\n\n")

for (v in vars) {
  sub <- results[results$variable == v & !is.na(results$ratio), ]
  sub <- sub[order(-sub$ratio), ]
  top <- head(sub, 10)
  cat(sprintf("--- %s: Top 10 ratio (nABCD / |SMD|) ---\n", v))
  cat(sprintf("  R_i  R_j  %8s  %8s  %8s  %8s  %8s\n",
              "nABCD", "|SMD|", "ratio", "skew_diff", "sd_ratio"))
  for (i in seq_len(nrow(top))) {
    r <- top[i, ]
    cat(sprintf("  %3d  %3d  %8.4f  %8.4f  %8.2f  %8.4f  %8.4f\n",
                r$region_i, r$region_j, r$nABCD, r$abs_SMD,
                r$ratio, r$skew_diff, r$sd_ratio))
  }
  cat("\n")
}

# --- 4. Anchor-based Analysis ---
cat("\n### 4. Anchor-based Analysis ###\n")
cat("For each anchor region x variable: partners where |SMD|<0.1 but nABCD>=0.05\n\n")

anchor_results <- data.frame()

for (anchor in regions) {
  for (v in vars) {
    sub <- results[results$variable == v &
                     (results$region_i == anchor | results$region_j == anchor), ]
    misleading <- sub[!is.na(sub$nABCD) & !is.na(sub$abs_SMD) &
                        sub$abs_SMD < 0.1 & sub$nABCD >= 0.05, ]
    if (nrow(misleading) > 0) {
      for (i in seq_len(nrow(misleading))) {
        r <- misleading[i, ]
        partner <- ifelse(r$region_i == anchor, r$region_j, r$region_i)
        anchor_results <- rbind(anchor_results, data.frame(
          anchor = anchor, variable = v, partner = partner,
          nABCD = r$nABCD, abs_SMD = r$abs_SMD,
          stringsAsFactors = FALSE
        ))
      }
    }
  }
}

if (nrow(anchor_results) > 0) {
  cat(sprintf("Total anchor-partner-variable misleading entries: %d\n\n",
              nrow(anchor_results)))

  # Show all
  cat(sprintf("  %-6s  %-8s  %-7s  %8s  %8s\n",
              "Anchor", "Variable", "Partner", "nABCD", "|SMD|"))
  for (i in seq_len(nrow(anchor_results))) {
    r <- anchor_results[i, ]
    cat(sprintf("  %4d    %-8s  %5d    %8.4f  %8.4f\n",
                r$anchor, r$variable, r$partner, r$nABCD, r$abs_SMD))
  }

  # Partners appearing across multiple variables
  cat("\n--- Partners with misleading pattern in MULTIPLE variables ---\n")
  pair_key <- paste(pmin(anchor_results$anchor, anchor_results$partner),
                    pmax(anchor_results$anchor, anchor_results$partner), sep = "-")
  pair_vars <- tapply(anchor_results$variable, pair_key, function(x) unique(x))
  multi <- pair_vars[sapply(pair_vars, length) >= 2]
  if (length(multi) > 0) {
    for (nm in names(multi)) {
      cat(sprintf("  Pair %s: misleading in %s\n", nm, paste(multi[[nm]], collapse = ", ")))
    }
  } else {
    cat("  None found.\n")
  }
} else {
  cat("No misleading cases found for anchor analysis.\n")
}

# --- 5. Distribution Shape Indicators ---
cat("\n\n### 5. Distribution Shape Analysis ###\n")
cat("Cases with large shape differences but small |SMD|\n\n")

cat("--- High skewness difference (>0.5) with |SMD| < 0.15 ---\n")
shape1 <- results[!is.na(results$skew_diff) & results$skew_diff > 0.5 &
                    results$abs_SMD < 0.15, ]
shape1 <- shape1[order(-shape1$skew_diff), ]
if (nrow(shape1) > 0) {
  cat(sprintf("  %-8s  R_i  R_j  %8s  %8s  %8s  %8s  %8s\n",
              "Variable", "skew_diff", "|SMD|", "nABCD", "sd_ratio", "kurt_diff"))
  for (i in seq_len(nrow(shape1))) {
    r <- shape1[i, ]
    cat(sprintf("  %-8s  %3d  %3d  %8.4f  %8.4f  %8.4f  %8.4f  %8.4f\n",
                r$variable, r$region_i, r$region_j,
                r$skew_diff, r$abs_SMD, r$nABCD, r$sd_ratio, r$kurt_diff))
  }
} else {
  cat("  None found.\n")
}

cat("\n--- High SD ratio (>1.3) with |SMD| < 0.15 ---\n")
shape2 <- results[!is.na(results$sd_ratio) & results$sd_ratio > 1.3 &
                    results$abs_SMD < 0.15, ]
shape2 <- shape2[order(-shape2$sd_ratio), ]
if (nrow(shape2) > 0) {
  cat(sprintf("  %-8s  R_i  R_j  %8s  %8s  %8s  %8s\n",
              "Variable", "sd_ratio", "|SMD|", "nABCD", "skew_diff"))
  for (i in seq_len(min(nrow(shape2), 30))) {
    r <- shape2[i, ]
    cat(sprintf("  %-8s  %3d  %3d  %8.4f  %8.4f  %8.4f  %8.4f\n",
                r$variable, r$region_i, r$region_j,
                r$sd_ratio, r$abs_SMD, r$nABCD, r$skew_diff))
  }
  if (nrow(shape2) > 30) cat(sprintf("  ... and %d more\n", nrow(shape2) - 30))
} else {
  cat("  None found.\n")
}

cat("\n--- High kurtosis difference (>1.0) with |SMD| < 0.15 ---\n")
shape3 <- results[!is.na(results$kurt_diff) & results$kurt_diff > 1.0 &
                    results$abs_SMD < 0.15, ]
shape3 <- shape3[order(-shape3$kurt_diff), ]
if (nrow(shape3) > 0) {
  cat(sprintf("  %-8s  R_i  R_j  %8s  %8s  %8s  %8s\n",
              "Variable", "kurt_diff", "|SMD|", "nABCD", "skew_diff"))
  for (i in seq_len(min(nrow(shape3), 30))) {
    r <- shape3[i, ]
    cat(sprintf("  %-8s  %3d  %3d  %8.4f  %8.4f  %8.4f  %8.4f\n",
                r$variable, r$region_i, r$region_j,
                r$kurt_diff, r$abs_SMD, r$nABCD, r$skew_diff))
  }
  if (nrow(shape3) > 30) cat(sprintf("  ... and %d more\n", nrow(shape3) - 30))
} else {
  cat("  None found.\n")
}

# --- 6. Variable-level Summary ---
cat("\n\n### 6. Variable-level Summary ###\n\n")

cat(sprintf("%-8s  %5s  %5s  %5s  %10s  %10s  %10s  %10s\n",
            "Variable", "N_tot", "M_str", "M_mod", "max_nABCD", "max|SMD|",
            "max_ratio", "max_discrep"))

for (v in vars) {
  sub <- results[results$variable == v, ]
  n_strict <- sum(!is.na(sub$nABCD) & !is.na(sub$abs_SMD) &
                    sub$abs_SMD < 0.10 & sub$nABCD >= 0.05, na.rm = TRUE)
  n_mod <- sum(!is.na(sub$nABCD) & !is.na(sub$abs_SMD) &
                 sub$abs_SMD < 0.15 & sub$nABCD >= 0.05, na.rm = TRUE)
  max_nab <- max(sub$nABCD, na.rm = TRUE)
  max_smd <- max(sub$abs_SMD, na.rm = TRUE)
  max_rat <- max(sub$ratio, na.rm = TRUE)
  # max discrepancy: max(nABCD - abs_SMD) where SMD < 0.1
  low_smd <- sub[sub$abs_SMD < 0.1, ]
  max_disc <- if (nrow(low_smd) > 0) max(low_smd$nABCD - low_smd$abs_SMD, na.rm = TRUE) else NA

  cat(sprintf("%-8s  %5d  %5d  %5d  %10.4f  %10.4f  %10.2f  %10.4f\n",
              v, nrow(sub), n_strict, n_mod, max_nab, max_smd, max_rat,
              ifelse(is.na(max_disc), 0, max_disc)))
}

cat("\n(M_str = |SMD|<0.1 & nABCD>=0.05; M_mod = |SMD|<0.15 & nABCD>=0.05)\n")

# --- Save CSV ---
outpath <- "C:/Users/hrd13/Documents/Gak/0 Study/800Claude/20260210_SIM/similarity_metrics/projects/similarity-metric/data/GUSTO/gusto_smd_misleading.csv"
write.csv(results, outpath, row.names = FALSE)
cat(sprintf("\nCSV saved: %s (%d rows)\n", outpath, nrow(results)))

cat("\n", rep("=", 80), "\n", sep = "")
cat("Analysis complete.\n")
