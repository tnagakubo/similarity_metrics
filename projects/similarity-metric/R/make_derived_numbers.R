#!/usr/bin/env Rscript
# make_derived_numbers.R — single writer of results/derived/*.csv: the quantities the manuscript prose cites that no
# canonical results CSV holds as one cell — ranges over the sample-size grid, rank correlations, differences between two
# partners, population distances of the Set 4 design, and design constants with a closed form.
# Reads only the canonical CSVs under results/, data/gusto.csv and the deterministic design functions of
# R/selection_simulation.R (build_set1..4, true_w1, true_ks). Draws no random numbers.
# 2026-10-12: section 10 added (study2_bias_over_sd.csv, study2_bias_ratio.csv, two scalars) for Louis's residual review.
# paper/numbers_registry.csv formats these values for the manuscript (\numval{key}); nothing here is typed into the paper.
# Usage: Rscript projects/similarity-metric/R/make_derived_numbers.R   (from the repo root or the project dir)
proj <- if (file.exists("results/w1_raw_summary.csv")) "." else "projects/similarity-metric"
OUT  <- file.path(proj, "results", "derived")
dir.create(OUT, showWarnings = FALSE, recursive = TRUE)
rd <- function(...) read.csv(file.path(proj, ...), stringsAsFactors = FALSE)
wr <- function(d, name) { write.csv(d, file.path(OUT, name), row.names = FALSE); cat(sprintf("wrote %s (%d rows)\n", file.path(OUT, name), nrow(d))) }
scalars <- list()
sc <- function(quantity, value, definition) scalars[[length(scalars) + 1]] <<- data.frame(quantity = quantity, value = value, definition = definition, stringsAsFactors = FALSE)

# ---- design functions (deterministic): rosters, population W1 and KS -------------------------------------------
source(file.path(proj, "R", "selection_simulation.R"), chdir = TRUE)   # guarded by sys.nframe(): defines, does not run
sets <- list(Set1_Gaussian = list(roster = build_set1(), lo = -80,  hi = 250),
             Set2_LogNormal = list(roster = build_set2(), lo = 0,    hi = 500),
             Set3_Mixture   = list(roster = build_set3(), lo = -60,  hi = 160),
             Set4_Extremes  = list(roster = build_set4(), lo = -400, hi = 600))   # limits as in selection_simulation.R::main

# ---- 1. Selection task: AUC range of every cell over the full grid (base n = 25–100, extended n = 150–2,000) -----
auc <- rbind(rd("results", "selection_sim_summary.csv"), rd("results", "selection_sim_summary_ext.csv"))
auc <- auc[auc$measure == "auc", ]
rn  <- rd("results", "required_n_selection.csv"); rn <- rn[rn$threshold == 0.9, ]
rn$set_id <- sub(" / .*", "", rn$set); rn$type <- sub(".* / ", "", rn$set)
cells <- unique(auc[, c("set", "type", "method")]); rownames(cells) <- NULL
cells <- cells[order(cells$set, cells$type, cells$method), ]
rng <- do.call(rbind, lapply(seq_len(nrow(cells)), function(i) {
  s <- auc[auc$set == cells$set[i] & auc$type == cells$type[i] & auc$method == cells$method[i], ]
  j <- match(paste(cells$set[i], cells$type[i], cells$method[i]), paste(rn$set_id, rn$type, rn$method))
  data.frame(n_points = nrow(s), n_min = min(s$n), n_max = max(s$n),
             auc_min = min(s$value), auc_max = max(s$value),
             auc_ext_min = min(s$value[s$n >= 150]), auc_ext_max = max(s$value[s$n >= 150]),
             auc_at_2000 = if (any(s$n == 2000)) s$value[s$n == 2000] else NA_real_,
             status_at_0.9 = if (is.na(j)) NA_character_ else rn$status[j],
             required_n_0.9 = if (is.na(j)) NA_integer_ else rn$required_n[j],
             max_auc_0.9 = if (is.na(j)) NA_real_ else rn$max_auc[j], stringsAsFactors = FALSE)
}))
wr(cbind(cells, rng), "selection_cell_auc_range.csv")

# ---- 2. Selection task: error rates at fixed n with their chance levels ----------------------------------------
# chance for retaining k of m candidates at random: P(at least one discordant) = 1 - 1/C(m, k); E[share discordant] = (m-k)/m
base <- rd("results", "selection_sim_summary.csv")
er <- base[base$measure %in% c("false_pooling_at_k", "precision_at_k"), c("set", "n", "method", "measure", "value")]
er <- reshape(er, idvar = c("set", "n", "method"), timevar = "measure", direction = "wide")
names(er) <- sub("^value\\.", "", names(er)); rownames(er) <- NULL
er$p_any_discordant <- er$false_pooling_at_k
er$share_discordant <- 1 - er$precision_at_k
roster_k <- vapply(sets, function(S) sum(vapply(S$roster, function(c) c$role, "") == "match"), 0L)
roster_m <- vapply(sets, function(S) length(S$roster) - 1L, 0L)
er$k_true <- roster_k[er$set]; er$m_candidates <- roster_m[er$set]
er$chance_any_discordant <- 1 - 1 / choose(er$m_candidates, er$k_true)
er$chance_share_discordant <- (er$m_candidates - er$k_true) / er$m_candidates
er <- er[order(er$set, er$n, er$method), c("set", "n", "method", "k_true", "m_candidates", "p_any_discordant", "share_discordant",
                                           "chance_any_discordant", "chance_share_discordant")]
wr(er, "selection_error_rates.csv")

# ---- 3. Set 4 design: population anchor distances of the six discordant regions, on the W1 and KS scales --------
S4 <- sets$Set4_Extremes
ids <- setdiff(names(S4$roster), "A0")
tr <- data.frame(id = ids, role = vapply(ids, function(id) S4$roster[[id]]$role, ""),
                 true_W1 = vapply(ids, function(id) true_w1(S4$roster$A0, S4$roster[[id]], S4$lo, S4$hi), 0),
                 true_KS = vapply(ids, function(id) true_ks(S4$roster$A0, S4$roster[[id]], S4$lo, S4$hi), 0),
                 stringsAsFactors = FALSE, row.names = NULL)
wr(tr, "set4_true_distances.csv")
dis <- tr[tr$role != "match", ]
sc("set4_ks_gap_w1max_vs_ksmin", dis$true_KS[which.max(dis$true_W1)] - min(dis$true_KS),
   "Set 4: KS of the discordant region largest on the W1 scale minus the smallest KS among discordant regions")

# ---- 4. (clustering oracle-vs-silhouette block removed 2026-09-27 with Section 3.1.4: clustering is not reported) -----

# ---- 5. GUSTO-I application: counts, rank agreement, dispersion ratio ------------------------------------------
g <- rd("data", "gusto.csv"); r8 <- g[g$regl == 8, ]
sc("gusto_N", nrow(g), "GUSTO-I patients in data/gusto.csv")
sc("gusto_n_regions", length(unique(g$regl)), "GUSTO-I regions (regl)")
sc("gusto_n_R8", nrow(r8), "Region 8 (anchor) patients")
pp <- rd("results", "gusto_r8_w1_per_pair.csv")
rho <- cor(pp$W1_age, pp$W1_sysbp, method = "spearman"); n_p <- nrow(pp)
sc("gusto_spearman_w1age_vs_w1sbp", rho,
   "Spearman correlation between the 15 partners' W1 on age and their W1 on SBP (results/gusto_r8_w1_per_pair.csv)")
# 95% interval for a Spearman correlation: Fisher z with the rank-correlation variance (1 + rho^2/2)/(n - 3)
# (Bonett & Wright 2000, Psychometrika 65:23-28, DOI 10.1007/BF02294183); normal quantile, two-sided 95%.
se_z <- sqrt((1 + rho^2 / 2) / (n_p - 3)); zq <- qnorm(0.975)
sc("gusto_spearman_w1age_vs_w1sbp_lower", tanh(atanh(rho) - zq * se_z), "lower 95% limit of the Spearman correlation above (Fisher z, Bonett-Wright SE, n = 15)")
sc("gusto_spearman_w1age_vs_w1sbp_upper", tanh(atanh(rho) + zq * se_z), "upper 95% limit of the Spearman correlation above (Fisher z, Bonett-Wright SE, n = 15)")
# Table 5 note: R6 and R5 are adjacent in the SBP ordering (ranks 5 and 6) and print the same 2-dp distance
sc("gusto_w1_sbp_R6_minus_R5", pp$W1_sysbp[pp$partner == 6] - pp$W1_sysbp[pp$partner == 5],
   "W1 on SBP of partner R6 minus that of R5 (results/gusto_r8_w1_per_pair.csv)")
sdr <- vapply(c("age", "sysbp"), function(v) { x <- tapply(g[[v]], g$regl, sd); r <- x[names(x) != "8"] / x[["8"]]; max(pmax(r, 1 / r)) }, 0)
sc("gusto_max_sd_ratio_partner_vs_anchor", max(sdr), "largest ratio (either direction) of a partner region's SD to Region 8's, over age and SBP")

# ---- 6. Study 2 design constants with a closed form ------------------------------------------------------------
sigma_log <- 0.5; mean_s6 <- 50; n_sim <- 10000            # S6: LogN(mu_log, sigma_log^2) with mean 50 (PROTOCOL / STUDY1_PROVENANCE.md)
sc("s6_mu_log", log(mean_s6) - sigma_log^2 / 2, "S6 log-normal: mu_log = log 50 - sigma_log^2 / 2")
sc("s6_cv", sqrt(exp(sigma_log^2) - 1), "S6 log-normal coefficient of variation: sqrt(exp(sigma_log^2) - 1)")
sc("s6_sd", mean_s6 * sqrt(exp(sigma_log^2) - 1), "S6 log-normal SD = mean x CV (Distribution 1 has SD 10)")
sc("s6_skewness", (exp(sigma_log^2) + 2) * sqrt(exp(sigma_log^2) - 1), "S6 log-normal skewness: (exp(sigma_log^2) + 2) sqrt(exp(sigma_log^2) - 1)")
sc("mcse_bound_proportion_10000", sqrt(0.25 / n_sim), "largest Monte Carlo SE of a proportion at n_sim = 10,000: sqrt(0.5 * 0.5 / n_sim)")
sc("z975_sqrt2", qnorm(0.975) * sqrt(2), "noise factor for the difference of two independent Monte Carlo estimates: z_0.975 * sqrt(2)")

# ---- 7. Required n at AUC 0.9, W1 vs KS: separation of the 95% Monte Carlo intervals over all 13 cells (referee M3) ------
# Rule (identical to sepmc in R/make_paper_tables.R): W1 fewer if W1 upper < KS lower; KS fewer if KS upper < W1 lower; else
# overlap. A cell reached at the grid minimum (required_n_lower NA, required_n = 25) has upper limit 25 and no lower limit.
GRID_MIN <- min(rd("results", "selection_sim_config.csv")$n)
mc <- rn[rn$method %in% c("W1", "KS"), ]
lims <- function(r) {
  if (r$status == "reached" && is.na(r$required_n_lower) && r$required_n == GRID_MIN) c(NA, GRID_MIN) else c(r$required_n_lower, r$required_n_upper)
}
sep <- do.call(rbind, lapply(unique(mc$set), function(s) {
  a <- mc[mc$set == s & mc$method == "W1", ]; b <- mc[mc$set == s & mc$method == "KS", ]; stopifnot(nrow(a) == 1, nrow(b) == 1)
  la <- lims(a); lb <- lims(b)
  v <- if (!is.na(lb[1]) && la[2] < lb[1]) "W1_fewer" else if (!is.na(la[1]) && lb[2] < la[1]) "KS_fewer" else if (anyNA(c(la, lb))) "undetermined" else "overlap"
  data.frame(set = s, w1_n = a$required_n, w1_lo = la[1], w1_hi = la[2], ks_n = b$required_n, ks_lo = lb[1], ks_hi = lb[2],
             verdict = v, one = 1L, stringsAsFactors = FALSE)
}))
stopifnot(nrow(sep) == 13, !any(sep$verdict == "undetermined"))
wr(sep, "required_n_separation.csv")

# ---- 8. GUSTO-I data checks (referee M1, Minor 7, Minor 12) ---------------------------------------------------------
# M1 attainment: the extremal tau*(x) = L * int sgn(F2 - F1) has range at most L x (support width); on the risk-difference
# scale |tau| <= 1 needs L x (b - a) <= 2. Support = pooled GUSTO-I range of the modifier. L = L_UB = Delta_clin / tau_clin with
# Delta_clin = DELTA_CLIN of R/gusto_lstar_table.R and tau_clin = TAU of R/gusto_operability_check.R (L43), parsed from those
# scripts so the constant has one home; L_UB,age is checked against its NUMBERS_LEDGER.csv row (0.01). L_UB,SBP = 0.002 has
# no ledger row of its own before 2026-10-11 (the row "2" derives it as 0.01 / 5.0); a row is appended for it.
grab <- function(file, pattern) { x <- grep(pattern, readLines(file.path(proj, "R", file)), value = TRUE); stopifnot(length(x) == 1)
  eval(parse(text = sub("#.*$", "", sub(".*<-", "", x)))) }
delta_clin <- grab("gusto_lstar_table.R", "^DELTA_CLIN *<-")
tau_clin   <- grab("gusto_operability_check.R", "^TAU *<-")
L_UB <- delta_clin / tau_clin
led <- rd("results", "NUMBERS_LEDGER.csv")
stopifnot(abs(L_UB[["age"]] - as.numeric(led$value[startsWith(led$label, "L_UB,age")])) < 1e-15)
for (v in c("age", "sysbp")) {
  w <- diff(range(g[[v]]))
  sc(paste0("gusto_support_width_", v), w, sprintf("pooled GUSTO-I range of %s (max - min, data/gusto.csv)", v))
  sc(paste0("gusto_L_UB_", v), L_UB[[v]], sprintf("L_UB for %s = DELTA_CLIN (R/gusto_lstar_table.R) / TAU (R/gusto_operability_check.R L43)", v))
  sc(paste0("gusto_lip_range_", v), L_UB[[v]] * w, sprintf("L_UB x pooled range of %s; |tau| <= 1 attainment needs <= 2", v))
}
# Minor 12: recorded values retained as recorded
sc("gusto_n_sysbp_zero", sum(g$sysbp == 0), "patients with recorded systolic blood pressure 0 mmHg (data/gusto.csv, retained)")
sc("gusto_n_age_over_100", sum(g$age > 100), "patients with recorded age > 100 years (data/gusto.csv, retained)")
# Minor 7: do the sample CDFs of Region 8 and a partner coincide on an interval of the pooled grid? With a_1 < ... < a_m the
# distinct pooled SBP values, the empirical CDFs are constant on [a_j, a_{j+1}), j = 1..m-1, so they coincide on that interval
# iff F_R8(a_j) = F_p(a_j), tested exactly in integers: #{x <= a_j} * n_p == #{y <= a_j} * n_R8. A pair counts if any of its
# m - 1 intervals coincides. (Variant "_excl_first" skips j = 1, as the referee's r01 does; both are recorded.)
coincide <- function(x, y, skip_first = FALSE) { a <- sort(unique(c(x, y))); j <- seq_len(length(a) - 1); if (skip_first) j <- j[-1]
  cx <- findInterval(a[j], sort(x)); cy <- findInterval(a[j], sort(y)); sum(cx * length(y) == cy * length(x)) }
partners <- sort(setdiff(unique(g$regl), 8))
for (v in c("sysbp", "age")) {
  k  <- vapply(partners, function(p) coincide(r8[[v]], g[[v]][g$regl == p]), 0)
  k2 <- vapply(partners, function(p) coincide(r8[[v]], g[[v]][g$regl == p], TRUE), 0)
  sc(paste0("gusto_cdf_coincide_pairs_", v), sum(k > 0), sprintf("of the 15 R8-vs-partner pairs, number whose sample CDFs of %s coincide on at least one interval [a_j, a_j+1) of the pooled grid", v))
  sc(paste0("gusto_cdf_coincide_pairs_", v, "_excl_first"), sum(k2 > 0), "the same, skipping the first grid interval (referee r01 definition)")
}

# ---- 9. Study 2 coverage relative to its Monte Carlo SE (referee M2, D-20261011-11 judgement 1) --------------------------
# SIGMA_REF = 10: the reference distribution of every Study 2 scenario is N(50, 10^2) (R/w1_raw_simulation.R header L13-L19;
# results/STUDY1_PROVENANCE.md). MCSE of a coverage proportion p over n_valid replications: sqrt(p (1 - p) / n_valid).
SIGMA_REF <- 10; NOMINAL <- 0.95
w1s <- rd("results", "w1_raw_summary.csv")
s37 <- w1s[w1s$scenario %in% paste0("S", 3:7), ]
sc("study2_min_true_w1_sd_S3toS7", min(s37$true_W1) / SIGMA_REF, "smallest true W1 among S3-S7 in reference-SD units (true_W1 / 10; S5 = sqrt(2/pi) * 5 / 10)")
sc("study2_max_true_w1_sd_S3toS7", max(s37$true_W1) / SIGMA_REF, "largest true W1 among S3-S7 in reference-SD units (S6 = 12.16 / 10); D-20261012-2 review-fix: the design range is 0.4-1.2 SD, not '0.4 SD or more'")
cv <- s37[s37$n >= 100, c("scenario", "n", "coverage_pct", "n_valid")]
cv$mcse <- sqrt(cv$coverage_pct * (1 - cv$coverage_pct) / cv$n_valid)
cv$z_vs_nominal <- (cv$coverage_pct - NOMINAL) / cv$mcse
cv$below_2mcse <- as.integer(cv$coverage_pct < NOMINAL - 2 * cv$mcse)
stopifnot(nrow(cv) == 10)
rownames(cv) <- NULL
wr(cv[order(cv$scenario, cv$n), ], "study2_coverage_vs_mcse.csv")

# ---- 10. Louis's residual review 2026-10-12 (D-20261012-2): ratios the prose would otherwise compute ----------------------
# (a) Study 2: bias relative to the Monte Carlo SD of the estimator, every scenario x n (from unrounded w1_raw_summary.csv cells)
bs <- w1s[, c("scenario", "n", "bias", "sd_est")]
bs$bias_over_sd <- bs$bias / bs$sd_est
rownames(bs) <- NULL
wr(bs[order(bs$scenario, bs$n), ], "study2_bias_over_sd.csv")
#     bias(n = 50) / bias(n = 200) per scenario (unrounded; for S1 the ratio of the printed 2.46 / 1.26 would differ in the 2nd dp)
br <- do.call(rbind, lapply(sort(unique(w1s$scenario)), function(s) {
  b50 <- w1s$bias[w1s$scenario == s & w1s$n == 50]; b200 <- w1s$bias[w1s$scenario == s & w1s$n == 200]
  stopifnot(length(b50) == 1, length(b200) == 1)
  data.frame(scenario = s, bias_n50 = b50, bias_n200 = b200, bias_ratio_50_to_200 = b50 / b200, stringsAsFactors = FALSE)
}))
wr(br, "study2_bias_ratio.csv")
# (b) Study 1 selection: KS over W1 required n at AUC 0.9, Set 4 symmetric severity (the cells reqnKSSet4symsev / reqnW1Set4symsev read)
rq <- function(cell, m) { x <- rn$required_n[rn$set == cell & rn$method == m]; stopifnot(length(x) == 1, !is.na(x)); x }
sc("reqn_ratio_ks_over_w1_set4_symsev", rq("Set4_Extremes / sym_severity", "KS") / rq("Set4_Extremes / sym_severity", "W1"),
   "required n at AUC 0.9 of KS divided by that of W1, Set4_Extremes / sym_severity (results/required_n_selection.csv)")
#     Delta_max CI width for S3 at n = 100 in units of the 1 %pt clinical margin. Same cell as registry dmaxWidthS3n100pct
#     (w1_raw_summary.csv S3, n = 100, mean_ci_width): Delta_max width = L_UB,age x W1 width; margin = DELTA_CLIN (section 8 constants).
ciw <- w1s$mean_ci_width[w1s$scenario == "S3" & w1s$n == 100]; stopifnot(length(ciw) == 1)
q_dm <- L_UB[["age"]] * ciw / delta_clin
stopifnot(abs(q_dm - (0.01 * ciw * 100) / 1) < 1e-12)   # = dmaxWidthS3n100pct (percentage points) / 1 %pt
sc("dmax_width_s3_n100_over_margin", q_dm,
   "S3, n = 100: Delta_max CI width (L_UB,age x mean W1 CI width, w1_raw_summary.csv) divided by the 1 %pt margin DELTA_CLIN")

# ---- 11. Set 4 control mechanism (PROTOCOL_set4_control_mechanism.md; R/set4_control_mechanism.R) — headline cell n = 200, delta = 2 ----
# Reads results/set4_control_mechanism.csv, results/set4_null_sd_ratios.csv, results/set4_integrals.csv (single writer:
# R/set4_control_mechanism.R). Scalars only; the MCSE of each is emitted beside it.
s4  <- rd("results", "set4_control_mechanism.csv")
s4r <- rd("results", "set4_null_sd_ratios.csv")
s4i <- rd("results", "set4_integrals.csv")
s4cell <- function(b, st, col, n = 200, d = 2) { x <- s4[[col]][s4$base == b & s4$n == n & s4$delta == d & s4$statistic == st]; stopifnot(length(x) == 1, !is.na(x)); x }
s4rat  <- function(col, n = 200) { x <- s4r[[col]][s4r$n == n]; stopifnot(length(x) == 1); x }
sc("set4_null_sd_ratio_w1_n200", s4rat("sd_ratio_w1"), "null SD of W1-hat, Set 4 anchor mixture / N(50,10^2), n = 200 (results/set4_null_sd_ratios.csv)")
sc("set4_null_sd_ratio_w1_n200_mcse", s4rat("sd_ratio_w1_mcse"), "Monte Carlo SE of the ratio above")
sc("set4_null_sd_ratio_ks_n200", s4rat("sd_ratio_ks"), "null SD of D_KS, Set 4 anchor mixture / N(50,10^2), n = 200")
sc("set4_null_sd_ratio_ks_n200_mcse", s4rat("sd_ratio_ks_mcse"), "Monte Carlo SE of the ratio above")
ir <- s4i$ratio_to_gauss[s4i$base == "mix"]; stopifnot(length(ir) == 1)
sc("set4_integral_ratio", ir, "int sqrt(F(1-F)) dx of the Set 4 anchor mixture / that of N(50,10^2) (results/set4_integrals.csv; quadrature)")
for (b in c("gauss", "mix")) {
  sc(sprintf("set4_delta_auc_%s_n200_d2", b), s4cell(b, "w1_minus_ks", "auc"), sprintf("paired AUC(W1) - AUC(KS), base %s, n = 200, delta = 2", b))
  sc(sprintf("set4_delta_auc_%s_n200_d2_mcse", b), s4cell(b, "w1_minus_ks", "auc_mcse"), "paired DeLong Monte Carlo SE of the difference above")
  for (st in c("w1", "ks")) {
    sc(sprintf("set4_auc_%s_%s_n200_d2", st, b), s4cell(b, st, "auc"), sprintf("AUC of %s for shifted vs unshifted pairs, base %s, n = 200, delta = 2", st, b))
    sc(sprintf("set4_auc_%s_%s_n200_d2_mcse", st, b), s4cell(b, st, "auc_mcse"), "DeLong Monte Carlo SE of the AUC above")
  }
}

# ---- 12. GUSTO-I: monotone-bound ratio per (EM, partner) pair (Tak/referee 2026-10-12) ------------------------------------
# r = (W1 + |mean_partner - mean_R8|) / (2 W1), from the per-pair W1 of results/gusto_r8_w1_per_pair.csv and the regional means
# of data/gusto.csv. Since |mean difference| <= W1 (asserted), r lies in [1/2, 1].
mono <- do.call(rbind, lapply(c(age = "age", sbp = "sysbp"), function(v) {
  w <- pp[[paste0("W1_", v)]]
  md <- vapply(pp$partner, function(p) mean(g[[v]][g$regl == p]) - mean(r8[[v]]), 0)
  nn <- vapply(pp$partner, function(p) sum(g$regl == p), 0L); stopifnot(all(nn == pp$n))
  stopifnot(all(abs(md) <= w + 1e-9))
  data.frame(em = v, partner = pp$partner, n = pp$n, W1 = w, mean_diff = md, ratio = (w + abs(md)) / (2 * w), stringsAsFactors = FALSE)
}))
rownames(mono) <- NULL
stopifnot(nrow(mono) == 30)
wr(mono, "gusto_monotone_bound_ratio.csv")

# ---- 13. GUSTO-I: W1 relative to the SD of Region 8's distribution of that modifier (Harvey/referee 2026-10-13) -------------
# ratio = W1(partner, R8) / SD(R8 distribution of the EM), per (EM, partner) pair; SD = sample SD of data/gusto.csv Region 8.
sd8 <- c(age = sd(r8$age), sbp = sd(r8$sysbp))
dsd <- do.call(rbind, lapply(c(age = "age", sbp = "sysbp"), function(v) {
  w <- pp[[paste0("W1_", v)]]; em <- if (v == "age") "age" else "sbp"
  data.frame(em = em, partner = pp$partner, W1 = w, sd_r8 = unname(sd8[em]), ratio = w / unname(sd8[em]), stringsAsFactors = FALSE) }))
rownames(dsd) <- NULL
stopifnot(nrow(dsd) == 30, all(is.finite(dsd$ratio)))
wr(dsd, "gusto_dist_sd.csv")
sc("gusto_dist_sd_min", min(dsd$ratio), "min over the 30 (EM, partner) pairs of W1 / SD of Region 8's distribution of that modifier")
sc("gusto_dist_sd_max", max(dsd$ratio), "max over the 30 (EM, partner) pairs of W1 / SD of Region 8's distribution of that modifier")

wr(do.call(rbind, scalars), "derived_scalars.csv")
writeLines(capture.output(sessionInfo()), file.path(OUT, "make_derived_numbers_sessionInfo.txt"))
cat("make_derived_numbers: done\n")
