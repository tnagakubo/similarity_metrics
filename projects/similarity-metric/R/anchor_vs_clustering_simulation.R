# =============================================================================
# ANCHOR-ONLY vs CLUSTERING -- same decision, same outcome, same scoring
#
# Tak's question (2026-07-26): "anchor 国とだけ比較しておけばよいのか、
# クラスタリングして選んだ方がいいのか". Part 1 and Part 2 cannot answer it
# because they score different objects (a ranking vs a partition). This script
# fixes the OUTCOME -- the anchor's pool, i.e. which countries end up pooled
# with the anchor -- and lets three decision rules produce that same object
# from the same estimated W1 distances:
#
#   ANCHOR-tau : pool = {anchor} + every c with What1(anchor, c) <= tau.
#                Uses only the anchor's row (11 distances).
#   CLUST-tau  : complete-linkage dendrogram on the FULL matrix (66 distances),
#                cut at height tau; pool = the anchor's cluster.
#   CLUST-sil  : average linkage + silhouette k-hat (Rule A machinery);
#                pool = the anchor's cluster. No tau; scored on group truth only.
#
# NESTING (proved, not simulated): cutting a complete-linkage tree at height
# tau guarantees every within-cluster estimated distance <= tau, hence
# CLUST-tau's pool is ALWAYS a subset of ANCHOR-tau's pool at the same tau.
# Pointwise comparison at equal tau is therefore trivial (CLUST is the
# conservative inner approximation). The decision-relevant comparison is
# Part 1B's: best sensitivity subject to violation <= 5%, swept over the grid.
#
# Scoring, all on the TRUE pairwise W1 (within-group true W1 is exactly 0):
#   viol_anchor = P(pool holds a c with TW[anchor,c] > tau)   -- the anchor's
#                 own KR guarantee, the paper's estimand.
#   viol_pair   = P(pool holds ANY pair with TW > tau)        -- the shared-pool
#                 guarantee; where ANCHOR-tau's 2*tau exposure should appear.
#   sensitivity = |pool ∩ acceptable| / |acceptable|, acceptable = {c : TW <= tau}
#   harm_anchor = E[max TW[anchor, c] over pool]              -- 0 if alone
#   Group-truth scoring (all three rules, no tau): recall of the anchor's 3
#   true partners, P(any out-group country admitted), pool size.
#
# Rosters, distance code, true-W1 matrix, tau grid and silhouette picker are
# SOURCED from clustering_nok_simulation.R (which itself sources
# clustering_simulation.R) -- identical constructions, same truth seeds.
#
# Outputs:
#   results/anchor_vs_clustering_tau.csv    (tau-indexed: ANCHOR-tau, CLUST-tau)
#   results/anchor_vs_clustering_group.csv  (group-truth: all three rules)
#   results/anchor_vs_clustering.log
# =============================================================================

suppressWarnings(RNGkind("Mersenne-Twister", "Inversion", "Rejection"))

.SELF2 <- local({
  f <- NULL
  for (fr in rev(sys.frames())) if (!is.null(fr$ofile)) { f <- fr$ofile; break }
  if (is.null(f)) { a <- commandArgs(FALSE); fa <- sub("^--file=", "", a[grepl("^--file=", a)])
                    if (length(fa)) f <- fa[1] }
  if (is.null(f)) NA_character_ else tryCatch(normalizePath(f, mustWork = FALSE), error = function(e) f)
})
.dir2 <- function() if (is.na(.SELF2)) "." else dirname(.SELF2)

local({
  p <- c("R/clustering_nok_simulation.R", "clustering_nok_simulation.R",
         file.path(.dir2(), "clustering_nok_simulation.R"))
  p <- p[file.exists(p)]
  if (!length(p)) stop("clustering_nok_simulation.R not found", call. = FALSE)
  source(p[1], local = FALSE)
})
stopifnot(exists("DMAT"), exists("build_clust_set1"), exists("true_w1_matrix"),
          exists("tau_grid"), exists("pick_k_silhouette"))

avc_args <- function(a = commandArgs(trailingOnly = TRUE)) {
  out <- list(reps = 2000L, n_grid = c(25L, 50L, 100L, 200L, 400L),
              base_seed = 91000000L, tag = "", truth_n = 1000000L)
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

# ---- the three rules: each returns the anchor's pool as a logical over ids --
pool_anchor_tau <- function(D, ai, tau) D[ai, ] <= tau | seq_len(ncol(D)) == ai
pool_clust_cut  <- function(cl, ai)     cl == cl[ai]

# ---- tau-indexed scoring on the true matrix ---------------------------------
score_pool_tau <- function(pool, ai, TW, tau) {
  others <- which(pool); others <- others[others != ai]
  acc    <- which(TW[ai, ] <= tau); acc <- acc[acc != ai]
  va <- as.integer(any(TW[ai, others] > tau))
  vp <- if (length(others) < 1L) 0L else {
    mem <- c(ai, others)
    as.integer(any(TW[mem, mem][upper.tri(diag(length(mem)))] > tau))
  }
  list(viol_anchor = va, viol_pair = vp,
       sensitivity = if (!length(acc)) NA_real_ else mean(acc %in% others),
       harm = if (!length(others)) 0 else max(TW[ai, others]),
       size = length(others) + 1L)
}

# ---- group-truth scoring (no tau) -------------------------------------------
score_pool_group <- function(pool, ai, truth) {
  others   <- which(pool); others <- others[others != ai]
  partners <- which(truth == truth[ai]); partners <- partners[partners != ai]
  list(recall    = if (!length(partners)) NA_real_ else mean(partners %in% others),
       any_wrong = as.integer(any(truth[others] != truth[ai])),
       size      = length(others) + 1L)
}

main_avc <- function() {
  OPTS <- avc_args()
  rd <- if (dir.exists("results")) "results" else file.path(.dir2(), "..", "results")
  dir.create(rd, showWarnings = FALSE, recursive = TRUE)
  logcon <- file(file.path(rd, sprintf("anchor_vs_clustering%s.log", OPTS$tag)), open = "wt")
  on.exit(close(logcon), add = TRUE)
  say <- function(...) { m <- sprintf(...); cat(m, "\n"); writeLines(m, logcon) }

  say("== ANCHOR-ONLY vs CLUSTERING on the unified outcome (the anchor's pool) ==")
  say("reps=%d  truth_n=%d  n grid=%s  started=%s",
      OPTS$reps, OPTS$truth_n, paste(OPTS$n_grid, collapse=","), format(Sys.time()))
  say("metric fixed at W1; every country serves as anchor in turn (12 per rep)")
  say("rules: ANCHOR-tau (11 distances) | CLUST-tau (complete linkage, 66) | CLUST-sil (k-hat)")

  sets <- list(list(id="Set1_Gaussian",  roster=build_clust_set1()),
               list(id="Set2_LogNormal", roster=build_clust_set2()),
               list(id="Set3_Mixture",   roster=build_clust_set3()),
               list(id="Set4_Extremes",  roster=build_clust_set4()))

  tau_rows <- list(); grp_rows <- list(); cell <- 0L
  for (si in seq_along(sets)) {
    S <- sets[[si]]
    ids    <- names(S$roster)
    m      <- length(ids)
    truth  <- vapply(ids, function(i) S$roster[[i]]$group, character(1))
    tw     <- true_w1_matrix(S$roster, OPTS$truth_n, 424242L + si)  # same seeds as nok run
    TW     <- tw$TW
    taus   <- tau_grid(tw$G)
    rules_tau <- c("ANCHOR_tau", "CLUST_tau")

    say("\n-- %s: tau grid = %s --", S$id, paste(sprintf("%.3f", taus), collapse = ", "))

    for (n in OPTS$n_grid) {
      cell <- cell + 1L
      set.seed(OPTS$base_seed + 1000L * cell)
      t0 <- Sys.time()
      # accumulators: [rule, tau] for tau scoring; [rule] for group scoring
      A <- array(0, dim = c(2L, length(taus), 5L),
                 dimnames = list(rules_tau, NULL, c("va","vp","sens","harm","size")))
      sensN <- matrix(0, 2L, length(taus))
      G3 <- matrix(0, 3L, 4L, dimnames = list(c("ANCHOR_tau_min","CLUST_tau_min","CLUST_sil"),
                                              c("recall","any_wrong","size","nacc")))

      for (rep in seq_len(OPTS$reps)) {
        Sm <- lapply(S$roster, function(cc) sort(cc$sampler(n)))
        D  <- DMAT$W1(Sm)
        hc  <- hclust(as.dist(D), method = "complete")
        cls <- lapply(taus, function(tt) cutree(hc, h = tt))
        sil <- pick_k_silhouette(D)$cl
        for (ai in seq_len(m)) {
          for (ti in seq_along(taus)) {
            pools <- list(ANCHOR_tau = pool_anchor_tau(D, ai, taus[ti]),
                          CLUST_tau  = pool_clust_cut(cls[[ti]], ai))
            for (ri in 1:2) {
              sc <- score_pool_tau(pools[[ri]], ai, TW, taus[ti])
              A[ri, ti, "va"]   <- A[ri, ti, "va"]   + sc$viol_anchor
              A[ri, ti, "vp"]   <- A[ri, ti, "vp"]   + sc$viol_pair
              if (!is.na(sc$sensitivity)) { A[ri, ti, "sens"] <- A[ri, ti, "sens"] + sc$sensitivity
                                            sensN[ri, ti] <- sensN[ri, ti] + 1 }
              A[ri, ti, "harm"] <- A[ri, ti, "harm"] + sc$harm
              A[ri, ti, "size"] <- A[ri, ti, "size"] + sc$size
            }
          }
          # group-truth scoring: the two tau rules at the SMALLEST tau (the
          # strict clinical reading, acceptable = true partners only) + sil
          gp <- list(pool_anchor_tau(D, ai, taus[1]),
                     pool_clust_cut(cls[[1]], ai),
                     pool_clust_cut(sil, ai))
          for (ri in 1:3) {
            sc <- score_pool_group(gp[[ri]], ai, truth)
            if (!is.na(sc$recall)) { G3[ri, "recall"] <- G3[ri, "recall"] + sc$recall
                                     G3[ri, "nacc"]   <- G3[ri, "nacc"] + 1 }
            G3[ri, "any_wrong"] <- G3[ri, "any_wrong"] + sc$any_wrong
            G3[ri, "size"]      <- G3[ri, "size"]      + sc$size
          }
        }
      }

      NN <- OPTS$reps * m
      for (ri in 1:2) for (ti in seq_along(taus)) {
        va <- A[ri, ti, "va"] / NN
        tau_rows[[length(tau_rows)+1]] <- data.frame(
          set = S$id, n = n, rule = rules_tau[ri], tau = taus[ti],
          viol_anchor = va,
          viol_pair   = A[ri, ti, "vp"] / NN,
          sensitivity = if (sensN[ri, ti] > 0) A[ri, ti, "sens"] / sensN[ri, ti] else NA_real_,
          harm        = A[ri, ti, "harm"] / NN,
          pool_size   = A[ri, ti, "size"] / NN,
          mc_se_viol  = sqrt(va * (1 - va) / NN),
          feasible    = va <= 0.05, stringsAsFactors = FALSE)
      }
      for (ri in 1:3) {
        aw <- G3[ri, "any_wrong"] / NN
        grp_rows[[length(grp_rows)+1]] <- data.frame(
          set = S$id, n = n, rule = rownames(G3)[ri],
          recall     = if (G3[ri, "nacc"] > 0) G3[ri, "recall"] / G3[ri, "nacc"] else NA_real_,
          any_wrong  = aw,
          pool_size  = G3[ri, "size"] / NN,
          mc_se_wrong = sqrt(aw * (1 - aw) / NN), stringsAsFactors = FALSE)
      }

      el <- as.numeric(difftime(Sys.time(), t0, units = "secs"))
      bs <- function(rn) {  # best sensitivity under viol_anchor <= 5% on this cell
        z <- Filter(function(r) r$set == S$id && r$n == n && r$rule == rn && r$feasible, tau_rows)
        if (!length(z)) return("--")
        sprintf("%.3f", max(vapply(z, function(r) ifelse(is.na(r$sensitivity), -1, r$sensitivity), numeric(1))))
      }
      say("[%s n=%d] (%.0fs)  best sens@viol<=5%%: ANCHOR=%s CLUST=%s | sil: recall=%.3f wrong=%.3f",
          S$id, n, el, bs("ANCHOR_tau"), bs("CLUST_tau"),
          G3[3,"recall"]/max(G3[3,"nacc"],1), G3[3,"any_wrong"]/NN)
    }
  }

  tdf <- do.call(rbind, tau_rows); gdf <- do.call(rbind, grp_rows)
  write.csv(tdf, file.path(rd, sprintf("anchor_vs_clustering_tau%s.csv",   OPTS$tag)), row.names = FALSE)
  write.csv(gdf, file.path(rd, sprintf("anchor_vs_clustering_group%s.csv", OPTS$tag)), row.names = FALSE)
  say("\n[save] anchor_vs_clustering_{tau,group}%s.csv", OPTS$tag)
  say("[done] finished=%s", format(Sys.time()))
  invisible(list(tau = tdf, grp = gdf))
}

if (sys.nframe() == 0L) main_avc()
