# =============================================================================
# APPLICATION-WIDE METHOD COMPARISON -- every method the simulation examined,
# applied to the GUSTO-I partner-selection problem
#
# Tak (2026-07-26): "simulation で検討した方法をすべて Application では実際に
# 適用し、Simulation の結果からの推奨と比較・考察する."
#
# The manuscript's §4 computes W1 only. The simulation (Study 2) compared six
# distances and three decision procedures. This script closes that gap: it runs
# the whole roster on the real data and asks whether the simulation's
# predictions actually show up in GUSTO-I.
#
# Paper purpose (Tak, 2026-07-26): propose a method for SELECTING POOLING
# PARTNERS. So the anchor-selection task is primary; clustering is reported as
# the alternative procedure the estimand does not require.
#
# Roster (identical definitions to clustering_simulation.R):
#   W1, KS, SMD  -- pairwise, computed from the two samples directly
#   RV1          -- Komiyama Ch.4 as written: one representative value per EM
#   RV2, RV3     -- OUR extensions (mean,SD) and (mean,SD,skew); NOT Ch.4's
# Coordinate methods standardize across the 16-region roster, then Euclidean.
#
# What the simulation predicts, and what we test here:
#   P1  RV1 == SMD on a single continuous EM (representative value = the mean)
#   P2  SMD/RV1 are blind to scale and shape -> they should disagree with W1
#       exactly on the partners whose spread/shape differs, not their mean
#   P3  KS saturates on rare-extreme displacement -> KS should under-rank
#       partners whose difference sits in the tails
#   P4  rho = W1/(KS*sigma) heuristic: rho/rho_trans <~ 1 favours KS,
#       >~ 1.7 favours W1
#   P5  For the anchor estimand, pairwise screening suffices (convexity), so the
#       anchor's cluster under a tau_clin cut should be a SUBSET of the
#       pairwise-selected set (deterministically true in the estimates)
#
# Outputs:
#   results/app_all_methods_distances.csv  per-partner distance by method/EM
#   results/app_all_methods_ranks.csv      ranks + top-k agreement
#   results/app_all_methods_procedures.csv anchor-tau / silhouette / tau-cut
#   results/app_all_methods.log
# =============================================================================

suppressPackageStartupMessages({ library(predtools) })
suppressWarnings(RNGkind("Mersenne-Twister", "Inversion", "Rejection"))

ANCHOR  <- 8L
EMS     <- c(age = "age", sysbp = "sysbp")
# tau_clin = Delta_clin / L_UB, Delta_clin = 1 %pt (manuscript §4.3)
TAU     <- c(age = 1.0, sysbp = 5.0)
L_UB    <- c(age = 1e-2, sysbp = 2e-3)

# ---- distances (same estimators as the simulation) --------------------------
# W1: exact plug-in empirical Wasserstein-1, integral |F_x - F_y| dt evaluated on
# midpoints between the pooled order statistics. This is the SAME estimator as
# compute_w1() in fig3_w1_axis.R / gusto_all_pairwise.R (Table 3, forest plot)
# and, at equal n, is numerically identical to the simulation's
# mean(|sort(x) - sort(y)|). Do NOT "restore consistency" with the simulation by
# copying its sorted-pair form: region sizes differ here, and that form is only
# valid at equal n.
#
# It replaced (2026-08-15) a quantile-grid form using type = 7, which linearly
# interpolates between order statistics and therefore measures W1 between
# continuity-corrected surrogates -- a different estimand, and the one the
# paper's asymptotics and bootstrap consistency are NOT stated for.
w1_s  <- function(sx, sy) {
  all_vals <- sort(c(sx, sy))
  n <- length(all_vals)
  if (n < 2) return(0)
  Fx <- ecdf(sx); Fy <- ecdf(sy)
  mids <- (all_vals[-n] + all_vals[-1]) / 2
  sum(abs(Fx(mids) - Fy(mids)) * diff(all_vals))
}
ks_s  <- function(sx, sy) {
  g <- sort(unique(c(sx, sy)))
  max(abs(ecdf(sx)(g) - ecdf(sy)(g)))
}
smd_s <- function(sx, sy) {
  n1 <- length(sx); n2 <- length(sy)
  sp <- sqrt(((n1 - 1) * var(sx) + (n2 - 1) * var(sy)) / (n1 + n2 - 2))
  abs(mean(sx) - mean(sy)) / sp
}
# Komiyama-style coordinates, standardized ACROSS the roster then Euclidean
rv_dist <- function(S, coords, anchor_name) {
  M <- vapply(S, function(v) {
    mu <- mean(v); s <- sd(v)
    c(mean = mu, sd = s, skew = mean(((v - mu) / s)^3))[coords]
  }, numeric(length(coords)))
  if (is.null(dim(M))) M <- matrix(M, nrow = 1L, dimnames = list(coords, names(S)))
  ctr <- rowMeans(M); sdv <- apply(M, 1L, sd)
  sdv[!is.finite(sdv) | sdv < .Machine$double.eps] <- 1
  Z <- (M - ctr) / sdv
  D <- as.matrix(dist(t(Z), method = "euclidean"))
  D[anchor_name, ]
}
full_mat <- function(S, f) {
  m <- length(S); D <- matrix(0, m, m, dimnames = list(names(S), names(S)))
  for (i in seq_len(m - 1L)) for (j in (i + 1L):m) {
    d <- f(S[[i]], S[[j]]); D[i, j] <- d; D[j, i] <- d }
  D
}
rv_full <- function(S, coords) {
  M <- vapply(S, function(v) { mu <- mean(v); s <- sd(v)
    c(mean = mu, sd = s, skew = mean(((v - mu) / s)^3))[coords] }, numeric(length(coords)))
  if (is.null(dim(M))) M <- matrix(M, nrow = 1L, dimnames = list(coords, names(S)))
  ctr <- rowMeans(M); sdv <- apply(M, 1L, sd)
  sdv[!is.finite(sdv) | sdv < .Machine$double.eps] <- 1
  as.matrix(dist(t((M - ctr) / sdv), method = "euclidean"))
}

# ---- silhouette machinery (same as clustering_nok_simulation.R) -------------
avg_sil <- function(D, cl) {
  k <- length(unique(cl)); if (k < 2L || k >= nrow(D)) return(NA_real_)
  idx <- seq_along(cl)
  mean(vapply(idx, function(i) {
    own <- cl == cl[i]; if (sum(own) <= 1L) return(0)
    a <- mean(D[i, own & idx != i])
    b <- min(vapply(setdiff(unique(cl), cl[i]), function(g) mean(D[i, cl == g]), numeric(1)))
    if (max(a, b) <= .Machine$double.eps) 0 else (b - a) / max(a, b)
  }, numeric(1)))
}
pick_k <- function(D, k_max = 6L) {
  hc <- hclust(as.dist(D), method = "average")
  ks <- 2:min(k_max, nrow(D) - 1L)
  sw <- vapply(ks, function(k) { v <- avg_sil(D, cutree(hc, k)); if (is.na(v)) -Inf else v }, numeric(1))
  if (all(!is.finite(sw)) || max(sw) <= 0) return(list(k = 2L, cl = cutree(hc, 2L)))
  kk <- ks[which.max(sw)]; list(k = kk, cl = cutree(hc, k = kk))
}

main <- function() {
  rd <- if (dir.exists("results")) "results" else "../results"
  lg <- file(file.path(rd, "app_all_methods.log"), open = "wt")
  on.exit(close(lg), add = TRUE)
  say <- function(...) { m <- sprintf(...); cat(m, "\n"); writeLines(m, lg) }

  data(gusto, package = "predtools")
  g <- gusto[!is.na(gusto$age) & !is.na(gusto$sysbp), ]
  regs <- sort(unique(g$regl))
  rn   <- paste0("R", regs)
  anch <- paste0("R", ANCHOR)
  partners <- setdiff(rn, anch)

  say("== Application-wide method comparison (GUSTO-I, anchor = %s) ==", anch)
  say("purpose: partner selection. 6 distances x 2 EMs x 3 procedures")
  say("regions: %d, n range %d-%d", length(regs), min(table(g$regl)), max(table(g$regl)))

  dist_rows <- list(); rank_rows <- list(); proc_rows <- list()

  for (em in names(EMS)) {
    v <- EMS[[em]]
    S <- lapply(regs, function(r) g[[v]][g$regl == r]); names(S) <- rn
    tau <- TAU[[em]]

    D <- list(W1  = full_mat(S, w1_s),
              KS  = full_mat(S, ks_s),
              SMD = full_mat(S, smd_s),
              RV1 = rv_full(S, "mean"),
              RV2 = rv_full(S, c("mean", "sd")),
              RV3 = rv_full(S, c("mean", "sd", "skew")))

    say("\n===== EM = %s  (tau_clin = %.1f = Delta_clin/L_UB) =====", em, tau)

    # ---- P1: does RV1 reproduce SMD? -----------------------------------------
    a1 <- D$RV1[anch, partners]; a2 <- D$SMD[anch, partners]
    say("[P1] RV1 vs SMD on this single continuous EM: Spearman rho = %.4f, Pearson = %.4f",
        cor(a1, a2, method = "spearman"), cor(a1, a2))
    say("     rank agreement (identical ordering): %s",
        identical(rank(a1), rank(a2)))

    # ---- per-partner distances and ranks ------------------------------------
    say("\n%-5s %6s %8s %8s %8s %8s %8s %8s", "reg", "n", "W1", "KS", "SMD", "RV1", "RV2", "RV3")
    for (p in partners) {
      row <- vapply(names(D), function(m) D[[m]][anch, p], numeric(1))
      say("%-5s %6d %8.3f %8.4f %8.4f %8.3f %8.3f %8.3f", p, length(S[[p]]),
          row["W1"], row["KS"], row["SMD"], row["RV1"], row["RV2"], row["RV3"])
      dist_rows[[length(dist_rows)+1]] <- data.frame(
        em = em, region = p, n = length(S[[p]]),
        W1 = row["W1"], KS = row["KS"], SMD = row["SMD"],
        RV1 = row["RV1"], RV2 = row["RV2"], RV3 = row["RV3"],
        rho_heur = row["W1"] / (row["KS"] * sd(S[[anch]])),
        row.names = NULL, stringsAsFactors = FALSE)
    }

    # ---- rank correlation matrix vs W1 --------------------------------------
    say("\n[ranks] Spearman correlation with W1's ordering of the 15 partners:")
    for (m in setdiff(names(D), "W1")) {
      rc <- cor(D$W1[anch, partners], D[[m]][anch, partners], method = "spearman")
      say("   %-4s rho_S = %+.4f", m, rc)
    }

    # ---- top-k set agreement (k = number W1 admits at tau_clin) -------------
    w1a <- D$W1[anch, partners]
    k   <- sum(w1a <= tau)
    sel <- lapply(D, function(M) names(sort(M[anch, partners]))[seq_len(k)])
    say("\n[top-k] W1 admits %d of 15 at tau_clin; comparing each method's %d closest:", k, k)
    say("   W1  : %s", paste(sort(sel$W1), collapse = " "))
    for (m in setdiff(names(D), "W1")) {
      ov <- length(intersect(sel$W1, sel[[m]]))
      say("   %-4s: %-44s overlap %d/%d  differs: %s", m,
          paste(sort(sel[[m]]), collapse = " "), ov, k,
          paste(sort(setdiff(sel[[m]], sel$W1)), collapse = " "))
      rank_rows[[length(rank_rows)+1]] <- data.frame(
        em = em, method = m, k = k, overlap = ov,
        spearman_vs_W1 = cor(w1a, D[[m]][anch, partners], method = "spearman"),
        only_in_method = paste(sort(setdiff(sel[[m]], sel$W1)), collapse = "|"),
        only_in_W1     = paste(sort(setdiff(sel$W1, sel[[m]])), collapse = "|"),
        stringsAsFactors = FALSE)
    }

    # ---- procedures, on W1's distance matrix --------------------------------
    say("\n[procedures] anchor's pool under each rule (W1 distances, all 16 regions)")
    pool_pair <- partners[w1a <= tau]
    hc_c <- hclust(as.dist(D$W1), method = "complete")
    cl_t <- cutree(hc_c, h = tau)
    pool_cut <- setdiff(names(cl_t)[cl_t == cl_t[anch]], anch)
    pk <- pick_k(D$W1)
    pool_sil <- setdiff(names(pk$cl)[pk$cl == pk$cl[anch]], anch)
    say("   pairwise tau screen   (%2d): %s", length(pool_pair), paste(pool_pair, collapse = " "))
    say("   complete-linkage cut  (%2d): %s", length(pool_cut),  paste(pool_cut,  collapse = " "))
    say("   silhouette k-hat = %d (%2d): %s", pk$k, length(pool_sil), paste(pool_sil, collapse = " "))
    say("   [P5] cut-pool is a subset of pairwise pool: %s",
        all(pool_cut %in% pool_pair))
    dg <- if (length(pool_cut)) max(D$W1[c(anch, pool_cut), c(anch, pool_cut)]) else 0
    dgp <- if (length(pool_pair)) max(D$W1[c(anch, pool_pair), c(anch, pool_pair)]) else 0
    say("   pool diameter: pairwise %.3f (tau %.1f) | cut %.3f", dgp, tau, dg)
    for (nm in c("pairwise_tau", "complete_cut", "silhouette")) {
      pl <- switch(nm, pairwise_tau = pool_pair, complete_cut = pool_cut, silhouette = pool_sil)
      dd <- if (length(pl)) max(D$W1[c(anch, pl), c(anch, pl)]) else 0
      proc_rows[[length(proc_rows)+1]] <- data.frame(
        em = em, rule = nm, n_selected = length(pl),
        members = paste(pl, collapse = "|"),
        max_anchor_dist = if (length(pl)) max(D$W1[anch, pl]) else 0,
        pool_diameter = dd, tau = tau, diameter_ok = dd <= tau,
        k_hat = if (nm == "silhouette") pk$k else NA_integer_,
        stringsAsFactors = FALSE)
    }
  }

  dd <- do.call(rbind, dist_rows); rr <- do.call(rbind, rank_rows); pp <- do.call(rbind, proc_rows)
  write.csv(dd, file.path(rd, "app_all_methods_distances.csv"), row.names = FALSE)
  write.csv(rr, file.path(rd, "app_all_methods_ranks.csv"), row.names = FALSE)
  write.csv(pp, file.path(rd, "app_all_methods_procedures.csv"), row.names = FALSE)

  # ---- joint (both EMs) selection per method -------------------------------
  say("\n\n===== JOINT selection across both EMs (AND rule), per method =====")
  say("each method admits its own k closest per EM (k = W1's count at tau_clin)")
  for (m in c("W1", "KS", "SMD", "RV1", "RV2", "RV3")) {
    sets <- lapply(names(EMS), function(em) {
      z <- rr[rr$em == em & rr$method == m, ]
      dsub <- dd[dd$em == em, ]
      kk <- if (nrow(z)) z$k[1] else sum(dsub$W1 <= TAU[[em]])
      dsub$region[order(dsub[[m]])][seq_len(kk)]
    })
    j <- Reduce(intersect, sets)
    say("   %-4s joint = %s", m, if (length(j)) paste(sort(j), collapse = " ") else "(none)")
  }
  say("\n[save] app_all_methods_{distances,ranks,procedures}.csv")
  invisible(list(d = dd, r = rr, p = pp))
}

if (sys.nframe() == 0L) main()
