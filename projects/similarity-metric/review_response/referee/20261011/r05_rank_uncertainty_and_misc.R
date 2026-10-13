# Referee check 05 -- (A) uncertainty of the partner ranks (Table 5) and of the age-vs-SBP rank correlation when
# patients, not distances, are resampled; (B) moments of the 'blind' cells (what a location-scale summary would see);
# (C) the KS curve in the asymmetric-severity cell; (D) GUSTO-I prognostic age gradient (Section 2.4 reference point);
# (E) design constants of Study 1; (F) abstract word count. Base R only. Run from the project root:
#   Rscript review_response/referee/20261011/r05_rank_uncertainty_and_misc.R
OUT <- "review_response/referee/20261011"
sink(file.path(OUT, "r05_rank_uncertainty_and_misc.txt"), split = TRUE)
suppressWarnings(RNGkind("Mersenne-Twister", "Inversion", "Rejection"))
set.seed(5)
g <- read.csv("data/gusto.csv"); partners <- setdiff(sort(unique(g$regl)), 8)
w1 <- function(x, y) { a <- sort(unique(c(x, y))); m <- length(a)
  sum(abs(findInterval(a[-m], sort(x)) / length(x) - findInterval(a[-m], sort(y)) / length(y)) * diff(a)) }

## (A) patient-level bootstrap: resample within every region (Region 8 once per replicate, shared by all partners)
B <- 1000
obs <- sapply(c("age", "sysbp"), function(v) sapply(partners, function(p) w1(g[[v]][g$regl == 8], g[[v]][g$regl == p])))
rk_obs <- apply(obs, 2, rank)
R <- array(NA, c(B, length(partners), 2)); rho_b <- numeric(B)
idx <- split(seq_len(nrow(g)), g$regl)
for (b in 1:B) {
  ii <- lapply(idx, function(i) i[sample.int(length(i), length(i), TRUE)])
  for (j in 1:2) { v <- c("age", "sysbp")[j]; xa <- g[[v]][ii[["8"]]]
    R[b, , j] <- sapply(partners, function(p) w1(xa, g[[v]][ii[[as.character(p)]]])) }
  rho_b[b] <- cor(R[b, , 1], R[b, , 2], method = "spearman")
}
for (j in 1:2) {
  rk <- t(apply(R[, , j], 1, rank))
  ci <- t(apply(rk, 2, quantile, c(0.025, 0.975), type = 1))
  cat(sprintf("\n== %s: observed rank and 95%% bootstrap rank interval (patients resampled within regions, B = %d) ==\n", c("age", "SBP")[j], B))
  print(data.frame(partner = paste0("R", partners), W1 = round(obs[, j], 3), rank = rk_obs[, j], lo = ci[, 1], hi = ci[, 2],
                   width = ci[, 2] - ci[, 1])[order(rk_obs[, j]), ], row.names = FALSE)
}
# adjacent-rank order probabilities for the pairs the text discusses
pr <- function(j, a, b) mean(R[, partners == a, j] < R[, partners == b, j])
cat(sprintf("\nP(R1 < R14 on age) = %.3f ; P(R14 < R12 on age) = %.3f ; P(R12 < R6 on age) = %.3f\n", pr(1, 1, 14), pr(1, 14, 12), pr(1, 12, 6)))
cat(sprintf("P(R3 < R6 on SBP) = %.3f ; P(R6 < R5 on SBP) = %.3f ; P(R5 < R1 on SBP) = %.3f\n", pr(2, 3, 6), pr(2, 6, 5), pr(2, 5, 1)))
rho <- cor(obs[, 1], obs[, 2], method = "spearman")
cat(sprintf("\nSpearman(age, SBP) observed %.3f; patient-level bootstrap: mean %.3f, 95%% percentile interval [%.3f, %.3f], P(rho_b > 0) = %.3f\n",
            rho, mean(rho_b), quantile(rho_b, 0.025), quantile(rho_b, 0.975), mean(rho_b > 0)))
cat("(the manuscript's interval [-0.71, 0.26] treats the 15 distances as known and the partners as a sample of regions;\n the bootstrap above captures only the patient-level part, so the two answer different questions)\n")

## (B) population moments of the cells in which SMD is 'blind' -- would a location-scale summary see them?
lnsd <- function(mean, cv) mean * cv
mix_sd <- function(w, d) 10   # Set 3: every region constructed with SD 10
ext_sd <- function(eL, dL, eH, dH, s0 = 10, st = 8) { w <- c(eL, 1 - eL - eH, eH); m <- c(-dL, 0, dH); s <- c(st, s0, st)
  mu <- sum(w * m); sqrt(sum(w * (s^2 + m^2)) - mu^2) }
cat("\n== population SD of anchor vs discordant regions in the seven SMD-blind cells ==\n")
cat(sprintf("Set 1 scale: anchor 10 vs 16, 20\nSet 2 shape: anchor %.1f vs %.1f, %.1f (log-normal, mean 50, CV 0.40 vs 0.60, 0.85)\n", lnsd(50, .4), lnsd(50, .6), lnsd(50, .85)))
cat(sprintf("Set 3 (all three cells): anchor 10 vs 10 (constructed)\n"))
cat(sprintf("Set 4 sym severity: anchor %.2f vs %.2f (70), %.2f (100)\nSet 4 sym prevalence: anchor %.2f vs %.2f\n",
            ext_sd(.05, 40, .05, 40), ext_sd(.05, 70, .05, 70), ext_sd(.05, 100, .05, 100), ext_sd(.05, 40, .05, 40), ext_sd(.12, 40, .12, 40)))
rn <- read.csv("results/required_n_selection.csv"); z <- rn[rn$threshold == 0.9 & rn$method %in% c("SMD", "RV2"), c("set", "method", "required_n", "status")]
cat("\nrequired n at AUC 0.9 for SMD and for the (mean, SD) summary distance RV2 (results/required_n_selection.csv; RV2 is not reported in the manuscript):\n")
print(reshape(z, idvar = "set", timevar = "method", direction = "wide"), row.names = FALSE)

## (C) KS selection AUC curve in the Set 4 asymmetric- and symmetric-severity cells
b <- read.csv("results/selection_sim_summary.csv"); e <- read.csv("results/selection_sim_summary_ext.csv"); d <- rbind(b[, names(e)], e)
for (ty in c("asym_severity", "sym_severity")) {
  k <- d[d$set == "Set4_Extremes" & d$type == ty & d$method == "KS" & d$measure == "auc", ]; k <- k[order(k$n), ]
  cat(sprintf("\nKS AUC, Set 4 %s: %s\n", ty, paste(sprintf("n=%d %.4f(%.4f)", k$n, k$value, k$mc_se), collapse = "; ")))
}

## (D) GUSTO-I 30-day mortality gradient in age (prognostic), all arms pooled
fit <- lm(day30 ~ age, data = g)
cat(sprintf("\n30-day mortality: linear slope on age = %.5f per year (SE %.5f)\n", coef(fit)[2], summary(fit)$coef[2, 2]))
br <- c(0, 65, 75, 85, Inf); grp <- cut(g$age, br, right = FALSE)
tab <- aggregate(cbind(day30, age) ~ grp, data = transform(g, grp = grp), FUN = mean); print(tab)
cat(sprintf("gradient between the <65 and 75-84 groups: %.5f per year\n", diff(tab$day30[c(1, 3)]) / diff(tab$age[c(1, 3)])))

## (E) design constants
c1 <- read.csv("results/selection_sim_config.csv"); c2 <- read.csv("results/selection_sim_config_ext.csv")
cat(sprintf("\nselection reps: base %s (n = %s); extended %s (n = %s)\n", paste(unique(c1$reps), collapse = ","), paste(unique(c1$n), collapse = ","),
            paste(unique(c2$reps), collapse = ","), paste(unique(c2$n), collapse = ",")))

## (F) abstract word count (text between \abstract[Abstract]{% and the closing brace on the same line)
tex <- readLines("paper/per_em_W1_wiley.tex"); ab <- tex[grep("^\\\\abstract", tex) + 1]
ab <- gsub("\\\\numval\\{[^}]*\\}", "0.92--0.95", ab); ab <- gsub("\\$[^$]*\\$", "X", ab); ab <- gsub("[{}\\\\]", " ", ab)
cat(sprintf("\nabstract words (approx.): %d\n", length(strsplit(trimws(ab), "\\s+")[[1]])))
sink()
writeLines(capture.output(sessionInfo()), file.path(OUT, "r05_sessionInfo.txt"))
