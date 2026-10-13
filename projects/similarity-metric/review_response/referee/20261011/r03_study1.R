# Referee recomputation 03 -- Study 1 (Section 3.1, required-n tables, blind/recovering, error rates, Set 4 truths)
# Base R only. Run from the project root:
#   Rscript review_response/referee/20261011/r03_study1.R
# Inputs: results/selection_sim_summary.csv (n = 25-100) and results/selection_sim_summary_ext.csv (n = 150-2000).
# The required-n rule is re-implemented from the manuscript's description (first grid crossing,
# linear interpolation on log n, rounded up; delta-method 95% interval from the two bracketing AUC MC SEs).
OUT <- "review_response/referee/20261011"
sink(file.path(OUT, "r03_study1.txt"), split = TRUE)
b <- read.csv("results/selection_sim_summary.csv"); e <- read.csv("results/selection_sim_summary_ext.csv")
d <- rbind(b[, names(e)], e); auc <- d[d$measure == "auc" & d$method %in% c("W1", "KS", "SMD", "SMD_log"), ]
auc <- auc[order(auc$set, auc$type, auc$method, auc$n), ]
cat("grid:", sort(unique(auc$n)), "\n")

req <- function(n, v, se, cut) {
  i <- which(v >= cut)[1]
  if (is.na(i)) return(c(n = NA, lo = NA, hi = NA))
  if (i == 1) return(c(n = n[1], lo = NA, hi = NA))
  x0 <- log(n[i - 1]); x1 <- log(n[i]); y0 <- v[i - 1]; y1 <- v[i]
  xs <- x0 + (cut - y0) * (x1 - x0) / (y1 - y0)
  d0 <- (x1 - x0) * (cut - y1) / (y1 - y0)^2; d1 <- -(x1 - x0) * (cut - y0) / (y1 - y0)^2
  sx <- sqrt(d0^2 * se[i - 1]^2 + d1^2 * se[i]^2)
  c(n = ceiling(exp(xs)), lo = floor(exp(xs - qnorm(0.975) * sx)), hi = ceiling(exp(xs + qnorm(0.975) * sx)))
}
cells <- unique(auc[, c("set", "type", "method")])
res <- do.call(rbind, lapply(seq_len(nrow(cells)), function(i) {
  s <- auc[auc$set == cells$set[i] & auc$type == cells$type[i] & auc$method == cells$method[i], ]
  r9 <- req(s$n, s$value, s$mc_se, 0.9); r8 <- req(s$n, s$value, s$mc_se, 0.8); r95 <- req(s$n, s$value, s$mc_se, 0.95)
  tl <- tail(s$value, 3)
  status <- if (!is.na(r9["n"])) "reached" else if (diff(range(tl)) < 0.02 && mean(tl) <= 0.55) "blind" else "other"
  # monotonicity: largest drop between consecutive grid points, in units of the combined MC SE
  dv <- diff(s$value); dse <- sqrt(head(s$mc_se, -1)^2 + tail(s$mc_se, -1)^2)
  data.frame(cells[i, ], req_0.8 = r8["n"], req_0.9 = r9["n"], lo_0.9 = r9["lo"], hi_0.9 = r9["hi"], req_0.95 = r95["n"],
             status = status, auc_min = min(s$value), auc_max = max(s$value), auc_2000 = s$value[s$n == 2000],
             worst_drop = min(dv), worst_drop_z = min(dv / dse), row.names = NULL)
}))
rn <- read.csv("results/required_n_selection.csv"); rn <- rn[rn$threshold == 0.9, ]
res$auth_req_0.9 <- rn$required_n[match(paste(res$set, res$type, res$method), paste(sub(" / .*", "", rn$set), sub(".* / ", "", rn$set), rn$method))]
res$auth_lo <- rn$required_n_lower[match(paste(res$set, res$type, res$method), paste(sub(" / .*", "", rn$set), sub(".* / ", "", rn$set), rn$method))]
res$auth_hi <- rn$required_n_upper[match(paste(res$set, res$type, res$method), paste(sub(" / .*", "", rn$set), sub(".* / ", "", rn$set), rn$method))]
cat("\n== every selection cell x measure: required n at AUC 0.8/0.9/0.95, MC interval at 0.9, status, AUC range, monotonicity ==\n")
print(res, row.names = FALSE, digits = 4)
cat(sprintf("\nmismatches with required_n_selection.csv at 0.9 (n, lo, hi): %d\n",
            sum(!(res$req_0.9 %in% res$auth_req_0.9 & TRUE) | xor(is.na(res$req_0.9), is.na(res$auth_req_0.9)) |
                (!is.na(res$req_0.9) & res$req_0.9 != res$auth_req_0.9), na.rm = TRUE)))
print(res[(!is.na(res$req_0.9) & (res$req_0.9 != res$auth_req_0.9 | (!is.na(res$lo_0.9) & (res$lo_0.9 != res$auth_lo | res$hi_0.9 != res$auth_hi)))), ], row.names = FALSE)

sm <- res[res$method == "SMD", ]
cat(sprintf("\nSMD cells: %d ; blind: %d -> %s\n", nrow(sm), sum(sm$status == "blind"), paste(sm$set[sm$status == "blind"], sm$type[sm$status == "blind"], collapse = "; ")))
cat(sprintf("SMD blind cells: AUC over full grid %.4f - %.4f\n", min(sm$auc_min[sm$status == "blind"]), max(sm$auc_max[sm$status == "blind"])))
cat(sprintf("W1 and KS: any cell not reaching 0.9 by n=2000? %s\n", any(is.na(res$req_0.9[res$method %in% c("W1", "KS")]))))
cat("W1/KS cells with a drop between consecutive grid points larger than 2 combined MC SE (non-monotone):\n")
print(res[res$method %in% c("W1", "KS") & res$worst_drop_z < -2, c("set", "type", "method", "worst_drop", "worst_drop_z")], row.names = FALSE)

## ---- W1 vs KS in all 13 cells (Table 1 reports only Sets 3-4) ----
w <- res[res$method == "W1", ]; k <- res[res$method == "KS", ]; k <- k[match(paste(w$set, w$type), paste(k$set, k$type)), ]
cmpk <- data.frame(set = w$set, type = w$type, W1 = w$req_0.9, W1_lo = w$lo_0.9, W1_hi = w$hi_0.9, KS = k$req_0.9, KS_lo = k$lo_0.9, KS_hi = k$hi_0.9,
                   W1_0.8 = w$req_0.8, KS_0.8 = k$req_0.8, W1_0.95 = w$req_0.95, KS_0.95 = k$req_0.95)
cmpk$verdict_0.9 <- with(cmpk, ifelse(is.na(W1_hi) | is.na(KS_lo), ifelse(W1 < KS, "W1 fewer (no interval: <=25)", "KS fewer"),
                          ifelse(W1_hi < KS_lo, "separate, W1 fewer", ifelse(KS_hi < W1_lo, "separate, KS fewer", "overlap"))))
cat("\n== W1 vs KS required n, all 13 cells, thresholds 0.8 / 0.9 / 0.95 ==\n"); print(cmpk, row.names = FALSE)
cat("verdict counts (all 13):"); print(table(cmpk$verdict_0.9))
cat("verdict counts (Sets 3-4):"); print(table(cmpk$verdict_0.9[cmpk$set %in% c("Set3_Mixture", "Set4_Extremes")]))
cat("point-estimate order at 0.8 (W1 < KS) Sets 3-4:", with(cmpk[cmpk$set %in% c("Set3_Mixture", "Set4_Extremes"), ], paste(type, W1_0.8 < KS_0.8)), "\n")
cat("point-estimate order at 0.95 (W1 < KS) Sets 3-4:", with(cmpk[cmpk$set %in% c("Set3_Mixture", "Set4_Extremes"), ], paste(type, W1_0.95 < KS_0.95)), "\n")

## ---- KS 'weakest Set 4 cell' and the 0.99 at n = 2000 ----
cat("\nKS in Set 4 by cell: required n at 0.9 and AUC at n = 2000\n"); print(k[k$set == "Set4_Extremes", c("type", "req_0.9", "auc_2000")], row.names = FALSE)
cat("KS weakest cell overall (AUC at 2000):", k$type[which.min(k$auc_2000)], k$set[which.min(k$auc_2000)], round(min(k$auc_2000), 4), "\n")
## ---- shape-symmetric crossing ----
cat("\nSet 3 shape_sym AUC by n (W1, KS, W1 - KS, combined MCSE):\n")
ws <- auc[auc$set == "Set3_Mixture" & auc$type == "shape_sym" & auc$method == "W1", ]; ksx <- auc[auc$set == "Set3_Mixture" & auc$type == "shape_sym" & auc$method == "KS", ]
print(data.frame(n = ws$n, W1 = round(ws$value, 4), KS = round(ksx$value, 4), diff = round(ws$value - ksx$value, 4), se = round(sqrt(ws$mc_se^2 + ksx$mc_se^2), 4)), row.names = FALSE)
## ---- SMD on the log scale (Set 2) ----
sl <- auc[auc$method == "SMD_log" & auc$n == 2000, ]; cat("\nSMD_log at n=2000:\n"); print(sl[, c("type", "value", "mc_se")], row.names = FALSE)

## ---- error rates at n = 100, Set 4 ----
er <- d[d$set == "Set4_Extremes" & d$n == 100 & d$measure %in% c("false_pooling_at_k", "precision_at_k") & d$method %in% c("W1", "KS", "SMD"), ]
er$value2 <- ifelse(er$measure == "precision_at_k", 1 - er$value, er$value)
cat("\nSet 4, n = 100: P(any discordant retained) and share discordant (1 - precision), with MC SE\n")
print(er[, c("method", "measure", "value2", "mc_se")], row.names = FALSE)
cat(sprintf("chance: 1 - 1/choose(9,3) = %.4f ; 6/9 = %.4f\n", 1 - 1 / choose(9, 3), 6 / 9))
## unbilled measure present in the CSV
cat("\nmeasures present in selection CSVs:", unique(d$measure), "\n")
hm <- d[d$measure == "harm_maxW1" & d$set == "Set4_Extremes" & d$n %in% c(100, 2000) & d$method %in% c("W1", "KS", "SMD"), ]
print(hm[, c("n", "method", "value", "mc_se")], row.names = FALSE)

## ---- Set 4 population distances, independent of the authors' code ----
mixcdf <- function(t, mu0, eL, dL, eH, dH) eL * pnorm(t, mu0 - dL, 8) + (1 - eL - eH) * pnorm(t, mu0, 10) + eH * pnorm(t, mu0 + dH, 8)
A <- function(t) mixcdf(t, 50, .05, 40, .05, 40)
ros <- list(T1 = c(50, .05, 70, .05, 70), T2 = c(50, .05, 100, .05, 100), P1 = c(50, .12, 40, .12, 40),
            P2 = c(50, .05, 40, .05, 100), S1 = c(52, .05, 40, .05, 40), S2 = c(53, .05, 40, .05, 40))
grid <- seq(-400, 600, by = 0.001)
tw <- t(sapply(ros, function(p) { Bc <- function(t) mixcdf(t, p[1], p[2], p[3], p[4], p[5])
  c(W1 = integrate(function(t) abs(A(t) - Bc(t)), -400, 600, subdivisions = 5000L, rel.tol = 1e-10)$value,
    KS = max(abs(A(grid) - Bc(grid))), mean_diff = (p[1] - 50) + p[4] * p[5] - p[2] * p[3] - (0.05 * 40 - 0.05 * 40)) }))
print(round(tw, 4))
au <- read.csv("results/derived/set4_true_distances.csv"); cat("authors' set4_true_distances.csv:\n"); print(au)
## threshold statement: for c in [3, 6), is there any KS cut t with {KS <= t} == {W1 <= c} among the 6 discordant + matches?
for (cc in c(2.5, 3, 3.5, 4.48, 5, 5.99)) {
  target <- rownames(tw)[tw[, "W1"] <= cc + 1e-9]
  ok <- any(sapply(c(0, sort(tw[, "KS"])), function(t) setequal(rownames(tw)[tw[, "KS"] <= t + 1e-12], target)))
  cat(sprintf("c = %.2f: target {%s}; some KS threshold reproduces it: %s\n", cc, paste(target, collapse = ","), ok))
}
sink()
writeLines(capture.output(sessionInfo()), file.path(OUT, "r03_sessionInfo.txt"))
