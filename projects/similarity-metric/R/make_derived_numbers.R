#!/usr/bin/env Rscript
# make_derived_numbers.R — single writer of results/derived/*.csv: the quantities the manuscript prose cites that no
# canonical results CSV holds as one cell — ranges over the sample-size grid, differences between two runs, rank
# correlations, population distances of the Set 4 design, and design constants with a closed form.
# Reads only the canonical CSVs under results/, data/gusto.csv and the deterministic design functions of
# R/selection_simulation.R (build_set1..4, true_w1, true_ks). Draws no random numbers.
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

# ---- 4. Clustering task: oracle k (clustering_sim_summary) vs silhouette-estimated k (clustering_nok_silhouette) --
co <- rd("results", "clustering_sim_summary.csv"); co <- co[co$measure == "ari", c("set", "n", "method", "value")]
ns <- rd("results", "clustering_nok_silhouette.csv")[, c("set", "n", "method", "ari", "k_hat_mode", "p_k_correct")]
cv <- merge(co, ns, by = c("set", "n", "method"))
names(cv)[names(cv) == "value"] <- "ari_oracle"; names(cv)[names(cv) == "ari"] <- "ari_silhouette"
cv$ari_drop <- cv$ari_oracle - cv$ari_silhouette
cv <- cv[order(cv$set, cv$n, cv$method), ]
wr(cv, "clustering_oracle_vs_silhouette.csv")
g3 <- function(col) { x <- cv[cv$set == "Set3_Mixture" & cv$n == 100, ]; x[[col]][x$method == "W1"] - x[[col]][x$method == "KS"] }
sc("set3_n100_ari_w1_minus_ks_oracle",     g3("ari_oracle"),     "Set 3, n = 100: ARI(W1) - ARI(KS) with the true number of clusters supplied")
sc("set3_n100_ari_w1_minus_ks_silhouette", g3("ari_silhouette"), "Set 3, n = 100: ARI(W1) - ARI(KS) with the number of clusters chosen by the silhouette criterion")

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
dm <- rd("results", "app_all_methods_distances.csv")
for (em in c("age", "sysbp")) { d <- dm[dm$em == em, ]
  sc(sprintf("gusto_spearman_rv1_vs_smd_%s", em), cor(d$RV1, d$SMD, method = "spearman"),
     sprintf("Spearman correlation between the RV1 and SMD anchor distances of the 15 partners, %s (results/app_all_methods_distances.csv)", em)) }
sdr <- vapply(c("age", "sysbp"), function(v) { x <- tapply(g[[v]], g$regl, sd); r <- x[names(x) != "8"] / x[["8"]]; max(pmax(r, 1 / r)) }, 0)
sc("gusto_max_sd_ratio_partner_vs_anchor", max(sdr), "largest ratio (either direction) of a partner region's SD to Region 8's, over age and SBP")

# ---- 6. Study 2 design constants with a closed form ------------------------------------------------------------
sigma_log <- 0.5; mean_s6 <- 50; n_sim <- 10000            # S6: LogN(mu_log, sigma_log^2) with mean 50 (PROTOCOL / STUDY1_PROVENANCE.md)
sc("s6_mu_log", log(mean_s6) - sigma_log^2 / 2, "S6 log-normal: mu_log = log 50 - sigma_log^2 / 2")
sc("s6_cv", sqrt(exp(sigma_log^2) - 1), "S6 log-normal coefficient of variation: sqrt(exp(sigma_log^2) - 1)")
sc("s6_sd", mean_s6 * sqrt(exp(sigma_log^2) - 1), "S6 log-normal SD = mean x CV (Distribution 1 has SD 10)")
sc("s6_skewness", (exp(sigma_log^2) + 2) * sqrt(exp(sigma_log^2) - 1), "S6 log-normal skewness: (exp(sigma_log^2) + 2) sqrt(exp(sigma_log^2) - 1)")
sc("mcse_bound_proportion_10000", sqrt(0.25 / n_sim), "largest Monte Carlo SE of a proportion at n_sim = 10,000: sqrt(0.5 * 0.5 / n_sim)")

wr(do.call(rbind, scalars), "derived_scalars.csv")
writeLines(capture.output(sessionInfo()), file.path(OUT, "make_derived_numbers_sessionInfo.txt"))
cat("make_derived_numbers: done\n")
