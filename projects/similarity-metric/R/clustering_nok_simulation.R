# =============================================================================
# Pooled-region formation WITHOUT being told k
#
# Part 2 as run in production hands every method the true number of pooled
# regions (cutree(k = 3)). No sponsor has that. This script removes it, two
# different ways, because they answer two different questions and must be
# scored differently:
#
#   RULE A -- silhouette k-hat (STATISTICAL, every method).
#       Choose k in 2..K_MAX maximising the average silhouette on that
#       method's own distance matrix, then cut there. Method-agnostic, so it
#       is the fair way to ask "does the W1-vs-competitor gap survive losing
#       the oracle?". Scored by ARI against the construction labels, which are
#       metric-independent -- non-circular.
#
#   RULE B -- clinical tau_clin cut (W1's contribution).
#       Do not estimate k at all. By the Kantorovich-Rubinstein bound, any two
#       regions pooled together satisfy |dtheta| <= L * W1, so a pool is
#       admissible exactly when its DIAMETER is <= tau_clin = Delta_clin / L.
#       Cut the dendrogram at that height and k falls out of the clinical
#       requirement. This is Part 1B's move -- a clinical tolerance restated on
#       the EM scale -- generalised from anchor-based selection to a partition.
#
#       *** Rule B is NOT scored by ARI. ***
#       The tau_clin-cut recovers the construction groups only when tau_clin
#       happens to land in the within/between gap, so maximising ARI over
#       tau_clin would be tuning the requirement to the truth -- the exact
#       circularity flagged for Part 1B. It is scored the way Part 1B is:
#         violation   = P(some formed pool contains a pair with true W1 > tau)
#         sensitivity = E[fraction of acceptable pairs kept together]
#       swept over tau_clin, both defined on the TRUE pairwise W1.
#
# LINKAGE. Rule B uses COMPLETE linkage, not the average linkage of Part 2.
# This is required, not cosmetic: cutting a complete-linkage dendrogram at
# height h guarantees every cluster has diameter <= h, which is precisely the
# admissibility condition. Average linkage carries no such guarantee, so a
# tau_clin cut on it can emit pools that breach the tolerance. Rule A keeps
# average linkage so it stays comparable with the production Part 2 run.
#
# The rosters, distance matrices and ARI are SOURCED from
# clustering_simulation.R rather than restated here. An earlier draft
# reimplemented the samplers and got a different Set 3 and Set 4 -- the
# comparison is only meaningful against the identical constructions.
#
# Outputs:
#   results/clustering_nok_silhouette.csv  (Rule A: ARI, k-hat)
#   results/clustering_nok_clinical.csv    (Rule B: violation, sensitivity)
#   results/clustering_nok_truth.csv       (true group-level pairwise W1)
#   results/clustering_nok.log
# =============================================================================

suppressWarnings(RNGkind("Mersenne-Twister", "Inversion", "Rejection"))

.SELF <- local({
  f <- NULL
  for (fr in rev(sys.frames())) if (!is.null(fr$ofile)) { f <- fr$ofile; break }
  if (is.null(f)) { a <- commandArgs(FALSE); fa <- sub("^--file=", "", a[grepl("^--file=", a)])
                    if (length(fa)) f <- fa[1] }
  if (is.null(f)) NA_character_ else tryCatch(normalizePath(f, mustWork = FALSE), error = function(e) f)
})
.dir <- function() if (is.na(.SELF)) "." else dirname(.SELF)

# Sourcing is safe: clustering_simulation.R guards its entry point with
# `if (sys.nframe() == 0L) main()`, so nothing runs on load.
local({
  p <- c("R/clustering_simulation.R", "clustering_simulation.R",
         file.path(.dir(), "clustering_simulation.R"))
  p <- p[file.exists(p)]
  if (!length(p)) stop("clustering_simulation.R not found", call. = FALSE)
  source(p[1], local = FALSE)
})
stopifnot(exists("DMAT"), exists("adj_rand"), exists("build_clust_set1"),
          exists("build_clust_set4"))

nok_args <- function(a = commandArgs(trailingOnly = TRUE)) {
  out <- list(reps = 2000L, n_grid = c(50L, 100L, 200L, 400L),
              base_seed = 55000000L, tag = "", truth_n = 1000000L)
  for (x in a) {
    if (grepl("^--reps=", x)) out$reps <- as.integer(sub("^--reps=", "", x))
    else if (grepl("^--n-grid=", x))
      out$n_grid <- as.integer(strsplit(sub("^--n-grid=", "", x), ",")[[1]])
    else if (grepl("^--base-seed=", x)) out$base_seed <- as.integer(sub("^--base-seed=", "", x))
    else if (grepl("^--tag=", x)) out$tag <- sub("^--tag=", "", x)
    else if (x == "--test") { out$reps <- 200L; out$truth_n <- 200000L }
  }
  stopifnot(length(out$n_grid) > 0, !anyNA(out$n_grid), all(out$n_grid > 1))
  out
}

K_MAX <- 6L

# ---- average silhouette on a distance matrix --------------------------------
# Degenerate by design in the blind cells: when every coordinate coincides the
# distance matrix is ~0, a and b are both 0, and the width is undefined. We
# return 0 there rather than NaN -- a method that cannot even define a
# silhouette is not clustering anything, and that is itself the finding.
avg_silhouette <- function(D, cl) {
  k <- length(unique(cl))
  if (k < 2L || k >= nrow(D)) return(NA_real_)
  idx <- seq_along(cl)
  s <- vapply(idx, function(i) {
    own <- cl == cl[i]
    if (sum(own) <= 1L) return(0)
    a <- mean(D[i, own & idx != i])
    b <- min(vapply(setdiff(unique(cl), cl[i]),
                    function(g) mean(D[i, cl == g]), numeric(1)))
    if (max(a, b) <= .Machine$double.eps) 0 else (b - a) / max(a, b)
  }, numeric(1))
  mean(s)
}

# Pick k by silhouette. All-degenerate cases fall back to k = 2, the smallest
# non-trivial partition -- recorded via k_hat, never treated as truth.
pick_k_silhouette <- function(D, k_max = K_MAX) {
  hc <- hclust(as.dist(D), method = "average")
  ks <- 2:min(k_max, nrow(D) - 1L)
  sw <- vapply(ks, function(k) {
    v <- avg_silhouette(D, cutree(hc, k = k)); if (is.na(v)) -Inf else v }, numeric(1))
  if (all(!is.finite(sw)) || max(sw) <= 0) return(list(k = 2L, cl = cutree(hc, 2L)))
  kk <- ks[which.max(sw)]
  list(k = kk, cl = cutree(hc, k = kk))
}

# ---- true pairwise W1 --------------------------------------------------------
# Countries within a group share the SAME sampler, so their true W1 is exactly
# zero -- it is not estimated. Only the between-group distances are unknown,
# and each is estimated once per group pair from very large samples via the
# quantile form W1 = mean|F1^{-1} - F2^{-1}|. Estimating the within-group
# zeros instead would fill the matrix with Monte Carlo noise (~0.02-0.12) and,
# worse, that noise would drive the tau grid.
true_w1_matrix <- function(roster, n_truth, seed) {
  set.seed(seed)
  grp <- vapply(roster, function(cc) cc$group, character(1))
  gl  <- unique(grp)
  rep_of <- vapply(gl, function(g) names(roster)[which(grp == g)[1]], character(1))
  big <- lapply(rep_of, function(id) sort(roster[[id]]$sampler(n_truth)))
  names(big) <- gl
  G <- matrix(0, length(gl), length(gl), dimnames = list(gl, gl))
  for (i in seq_along(gl)) for (j in seq_along(gl)) if (i < j) {
    d <- mean(abs(big[[i]] - big[[j]])); G[i,j] <- d; G[j,i] <- d
  }
  ids <- names(roster)
  TW <- outer(grp, grp, Vectorize(function(a, b) G[a, b]))
  dimnames(TW) <- list(ids, ids)
  list(TW = TW, G = G)
}

# ---- Rule B scoring ----------------------------------------------------------
# A pool breaches the requirement if it holds ANY pair whose TRUE W1 exceeds
# tau. Sensitivity is the share of genuinely-poolable pairs kept together.
score_partition <- function(cl, TW, tau, iu) {
  same <- cl[iu[,1]] == cl[iu[,2]]
  tw   <- TW[iu]
  ok   <- tw <= tau
  list(violation   = as.integer(any(same & !ok)),
       sensitivity = if (!any(ok)) NA_real_ else mean(same[ok]),
       k_formed    = length(unique(cl)))
}

# Height grid: midpoints between consecutive distinct true BETWEEN-group
# distances, plus one below the smallest and one above the largest. Every tau
# then partitions the roster cleanly and none sits exactly on a tie (a tau
# placed on a tie makes admission a coin flip even for a perfect method).
tau_grid <- function(G) {
  v <- sort(unique(round(G[upper.tri(G)], 6)))
  v <- v[v > 0]
  if (!length(v)) return(numeric(0))
  mids <- if (length(v) > 1L) (head(v,-1) + tail(v,-1)) / 2 else numeric(0)
  sort(c(v[1] * 0.5, mids, v[length(v)] * 1.15))
}

main_nok <- function() {
  OPTS <- nok_args()
  rd <- if (dir.exists("results")) "results" else file.path(.dir(), "..", "results")
  dir.create(rd, showWarnings = FALSE, recursive = TRUE)
  logcon <- file(file.path(rd, sprintf("clustering_nok%s.log", OPTS$tag)), open = "wt")
  on.exit(close(logcon), add = TRUE)
  say <- function(...) { m <- sprintf(...); cat(m, "\n"); writeLines(m, logcon) }

  say("== Pooled-region formation WITHOUT oracle k ==")
  say("reps=%d  truth_n=%d  n grid=%s  started=%s",
      OPTS$reps, OPTS$truth_n, paste(OPTS$n_grid, collapse=","), format(Sys.time()))
  say("Rule A: silhouette k-hat, average linkage, scored by ARI (all methods)")
  say("Rule B: clinical tau cut, COMPLETE linkage, scored by violation/sensitivity (W1)")
  say("rosters and distances sourced from clustering_simulation.R (identical constructions)")

  methods <- names(DMAT)
  sets <- list(list(id="Set1_Gaussian",  roster=build_clust_set1()),
               list(id="Set2_LogNormal", roster=build_clust_set2()),
               list(id="Set3_Mixture",   roster=build_clust_set3()),
               list(id="Set4_Extremes",  roster=build_clust_set4()))

  sil_rows <- list(); cli_rows <- list(); tru_rows <- list(); cell <- 0L
  for (si in seq_along(sets)) {
    S <- sets[[si]]
    ids   <- names(S$roster)
    truth <- vapply(ids, function(i) S$roster[[i]]$group, character(1))
    k_true <- length(unique(truth))
    tw <- true_w1_matrix(S$roster, OPTS$truth_n, 424242L + si)
    TW <- tw$TW; G <- tw$G
    taus <- tau_grid(G)
    iu <- which(upper.tri(TW), arr.ind = TRUE)

    say("\n-- %s: true between-group W1 --", S$id)
    say(paste(capture.output(print(round(G, 4))), collapse = "\n"))
    say("   tau grid: %s", paste(sprintf("%.3f", taus), collapse = ", "))
    for (a in seq_along(rownames(G))) for (b in seq_along(colnames(G))) if (a < b)
      tru_rows[[length(tru_rows)+1]] <- data.frame(
        set = S$id, group_pair = paste(rownames(G)[a], colnames(G)[b], sep="-"),
        true_W1 = round(G[a,b], 6), stringsAsFactors = FALSE)

    for (n in OPTS$n_grid) {
      cell <- cell + 1L
      set.seed(OPTS$base_seed + 1000L * cell)
      t0 <- Sys.time()
      accA <- setNames(lapply(methods, function(m) list(ari=0, ari2=0, k=integer(0))), methods)
      viol <- numeric(length(taus)); sens <- numeric(length(taus))
      sensN <- numeric(length(taus)); kf <- numeric(length(taus))

      for (rep in seq_len(OPTS$reps)) {
        Sm <- lapply(S$roster, function(cc) sort(cc$sampler(n)))
        for (m in methods) {
          D  <- DMAT[[m]](Sm)
          pk <- pick_k_silhouette(D)
          a  <- adj_rand(pk$cl, truth)
          accA[[m]]$ari  <- accA[[m]]$ari  + a
          accA[[m]]$ari2 <- accA[[m]]$ari2 + a*a
          accA[[m]]$k    <- c(accA[[m]]$k, pk$k)
        }
        hcW <- hclust(as.dist(DMAT$W1(Sm)), method = "complete")
        for (ti in seq_along(taus)) {
          sc <- score_partition(cutree(hcW, h = taus[ti]), TW, taus[ti], iu)
          viol[ti] <- viol[ti] + sc$violation
          if (!is.na(sc$sensitivity)) { sens[ti] <- sens[ti] + sc$sensitivity; sensN[ti] <- sensN[ti] + 1 }
          kf[ti] <- kf[ti] + sc$k_formed
        }
      }

      for (m in methods) {
        mu <- accA[[m]]$ari / OPTS$reps
        v  <- max(0, accA[[m]]$ari2 / OPTS$reps - mu^2)
        sil_rows[[length(sil_rows)+1]] <- data.frame(
          set = S$id, n = n, method = m, ari = mu, mc_se = sqrt(v / OPTS$reps),
          k_hat_mean  = mean(accA[[m]]$k),
          k_hat_mode  = as.integer(names(sort(table(accA[[m]]$k), decreasing = TRUE))[1]),
          p_k_correct = mean(accA[[m]]$k == k_true), stringsAsFactors = FALSE)
      }
      for (ti in seq_along(taus))
        cli_rows[[length(cli_rows)+1]] <- data.frame(
          set = S$id, n = n, tau_clin = taus[ti],
          violation   = viol[ti] / OPTS$reps,
          sensitivity = if (sensN[ti] > 0) sens[ti] / sensN[ti] else NA_real_,
          k_formed_mean = kf[ti] / OPTS$reps,
          feasible = (viol[ti] / OPTS$reps) <= 0.05, stringsAsFactors = FALSE)

      el <- as.numeric(difftime(Sys.time(), t0, units = "secs"))
      pa <- function(m) { z <- sil_rows[[length(sil_rows) - length(methods) + which(methods == m)]]
                          sprintf("%.3f(k=%d)", z$ari, z$k_hat_mode) }
      say("[%s n=%d] (%.0fs)  W1=%s KS=%s RV1=%s RV2=%s RV3=%s SMD=%s",
          S$id, n, el, pa("W1"), pa("KS"), pa("RV1"), pa("RV2"), pa("RV3"), pa("SMD"))
    }
  }

  sil <- do.call(rbind, sil_rows); cli <- do.call(rbind, cli_rows); tru <- do.call(rbind, tru_rows)
  write.csv(sil, file.path(rd, sprintf("clustering_nok_silhouette%s.csv", OPTS$tag)), row.names = FALSE)
  write.csv(cli, file.path(rd, sprintf("clustering_nok_clinical%s.csv",   OPTS$tag)), row.names = FALSE)
  write.csv(tru, file.path(rd, sprintf("clustering_nok_truth%s.csv",      OPTS$tag)), row.names = FALSE)
  say("\n[save] clustering_nok_{silhouette,clinical,truth}%s.csv", OPTS$tag)
  say("[done] finished=%s", format(Sys.time()))
  invisible(list(sil = sil, cli = cli, tru = tru))
}

if (sys.nframe() == 0L) main_nok()
