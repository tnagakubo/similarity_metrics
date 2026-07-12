# =============================================================================
# PART 2 — Pooled-region formation by CLUSTERING a full pairwise distance matrix
#
# Part 1 (selection_simulation.R) asks: given one anchor region, which candidates
# may be pooled with it? That is the regulatory "pool into the pivotal region"
# question, and it only ever uses the anchor's row of the distance matrix.
#
# Komiyama et al. (2024) Ch.4 §4.6.1.2 poses the other question: partition ALL
# regions into pooled regions at once, by clustering the full pairwise distance
# matrix. This script simulates that. No anchor exists here; every country is
# compared with every other.
#
# Ground truth = the construction partition (which population each country was
# drawn from), so it is metric-independent -> non-circular.
#
# FAIRNESS (the reviewer's first objection): the clustering ALGORITHM is held
# fixed -- same linkage (average), same number of clusters (k = true number of
# groups) -- and ONLY the distance matrix is swapped between methods. Any ARI
# difference is therefore attributable to the distance, not to clustering choices.
# Giving each method the true k is generous to the moment-based baselines: it
# hands them the answer to §4.6.1.3 (how many clusters) for free.
#
# Methods: W1, SMD, KS (pairwise); RV1 = (mean) = Ch.4 as written, RV2 = (mean,SD)
# and RV3 = (mean,SD,skew) = extensions Ch.4 does NOT propose, granted in advance.
# All RV variants: coordinates standardized across the roster, Euclidean (§4.6.1.1).
# See EXISTING_METHODS_AND_NOVELTY.md §3 -- do NOT call RV2/RV3 "Komiyama's method".
#
# Three worlds, matching Part 1 (one distributional family per world -- Tak's
# realism requirement):
#   Set 1 Gaussian    — groups differ in location / scale
#   Set 2 Log-normal  — groups differ in location / dispersion+shape
#   Set 3 Mixture     — groups differ in SHAPE ONLY; every country has the same
#                       mean (50) and SD (10). Representative-value coordinates are
#                       identical across all 12 countries => RV cannot form
#                       clusters at all (ARI ~ 0), while W1/KS still can.
#
# Outputs (results/):
#   clustering_sim_summary.csv — set,n,method,measure,value,mc_se
#   clustering_sim_config.csv  — per-cell seeds + settings
#   clustering_sim.log
# =============================================================================

suppressWarnings(RNGkind("Mersenne-Twister", "Inversion", "Rejection"))

parse_args <- function(a = commandArgs(trailingOnly = TRUE)) {
  out <- list(reps = 5000L)
  for (x in a) {
    if (grepl("^--reps=", x)) out$reps <- as.integer(sub("^--reps=", "", x))
    else if (x == "--test")  out$reps <- 300L
  }
  out
}

# ---- distances on PRE-SORTED samples (all rank-based; order is irrelevant) ---
w1_s  <- function(sx, sy) mean(abs(sx - sy))                 # equal n
ks_s  <- function(sx, sy) {                                   # equal n, no ties in practice
  n <- length(sx)
  o <- order(c(sx, sy))
  max(abs(cumsum(ifelse(o <= n, 1/n, -1/n))))
}
smd_s <- function(sx, sy) {
  n <- length(sx)
  sp <- sqrt(((n-1)*var(sx) + (n-1)*var(sy)) / (2*n - 2))
  abs(mean(sx) - mean(sy)) / sp
}

# ---- pairwise distance matrix from a list of samples ------------------------
dmat_pairwise <- function(S, f) {
  m <- length(S)
  D <- matrix(0, m, m, dimnames = list(names(S), names(S)))
  for (i in seq_len(m - 1L)) for (j in (i + 1L):m) {
    d <- f(S[[i]], S[[j]]); D[i, j] <- d; D[j, i] <- d
  }
  D
}
# Komiyama representative-value distance: coordinates standardized ACROSS the
# roster (N(0,1) per coordinate), then Euclidean between countries.
dmat_rv <- function(S, coords) {
  M <- vapply(S, function(v) {
    mu <- mean(v); s <- sd(v)
    c(mean = mu, sd = s, skew = mean(((v - mu) / s)^3))[coords]
  }, numeric(length(coords)))
  if (is.null(dim(M))) M <- matrix(M, nrow = 1L, dimnames = list(coords, names(S)))
  ctr <- rowMeans(M); sdv <- apply(M, 1L, sd)
  sdv[!is.finite(sdv) | sdv < .Machine$double.eps] <- 1
  Z <- (M - ctr) / sdv
  as.matrix(dist(t(Z), method = "euclidean"))
}
DMAT <- list(
  W1   = function(S) dmat_pairwise(S, w1_s),
  SMD  = function(S) dmat_pairwise(S, smd_s),
  KS   = function(S) dmat_pairwise(S, ks_s),
  RV1  = function(S) dmat_rv(S, "mean"),
  RV2  = function(S) dmat_rv(S, c("mean", "sd")),
  RV3  = function(S) dmat_rv(S, c("mean", "sd", "skew"))
)

# ---- adjusted Rand index (Hubert & Arabie 1985) -----------------------------
adj_rand <- function(x, y) {
  tab <- table(x, y)
  n   <- sum(tab)
  ch2 <- function(v) sum(v * (v - 1) / 2)
  a   <- ch2(as.vector(tab)); b <- ch2(rowSums(tab)); cc <- ch2(colSums(tab))
  tot <- n * (n - 1) / 2
  ex  <- b * cc / tot
  den <- 0.5 * (b + cc) - ex
  if (den == 0) return(0)          # degenerate (all-in-one-cluster) -> no agreement
  (a - ex) / den
}

# ---- rosters: 12 countries, 3 true groups of 4 ------------------------------
lnorm_pars <- function(mean, cv) { s <- sqrt(log(1 + cv^2)); list(meanlog = log(mean) - s^2/2, sdlog = s) }
rep_group <- function(prefix, k, group, sampler) {
  setNames(lapply(seq_len(k), function(i) list(group = group, sampler = sampler)),
           paste0(prefix, seq_len(k)))
}
build_clust_set1 <- function() {   # Gaussian: reference / location-shifted / scale-inflated
  c(rep_group("A", 4, "A", function(n) rnorm(n, 50, 10)),
    rep_group("B", 4, "B", function(n) rnorm(n, 58, 10)),
    rep_group("C", 4, "C", function(n) rnorm(n, 50, 20)))
}
build_clust_set2 <- function() {   # Log-normal: reference / location / dispersion+shape
  p1 <- lnorm_pars(50, 0.40); p2 <- lnorm_pars(58, 0.40); p3 <- lnorm_pars(50, 0.85)
  c(rep_group("A", 4, "A", function(n) rlnorm(n, p1$meanlog, p1$sdlog)),
    rep_group("B", 4, "B", function(n) rlnorm(n, p2$meanlog, p2$sdlog)),
    rep_group("C", 4, "C", function(n) rlnorm(n, p3$meanlog, p3$sdlog)))
}
# Set 3: every country mean 50, SD 10 -- groups differ ONLY in shape.
# Group A: near-unimodal (d = 6). Group B: symmetric bimodal (d = 19, skew 0 too).
# Group C: skewed (w = 0.85, d = 19). A vs B is invisible to RV1/RV2 *and* RV3.
mix_sampler <- function(w, d, mu = 50, v = 100) {
  s2 <- v - w * (1 - w) * d^2; stopifnot(s2 > 0); s <- sqrt(s2)
  m1 <- mu + (1 - w) * d; m2 <- mu - w * d
  function(n) { k <- rbinom(1L, n, w); c(rnorm(k, m1, s), rnorm(n - k, m2, s)) }
}
build_clust_set3 <- function() {
  c(rep_group("A", 4, "A", mix_sampler(0.50,  6)),
    rep_group("B", 4, "B", mix_sampler(0.50, 19)),
    rep_group("C", 4, "C", mix_sampler(0.85, 19)))
}
# Set 4: bulk + rare low/high extreme subgroups. Groups differ ONLY in HOW FAR the
# rare extremes sit (+-40 / +-70 / +-100), at fixed prevalence 5% each side and fixed
# mean 50. KS is capped at the contamination fraction eps regardless of displacement,
# so its population distance matrix is nearly CONSTANT off-diagonal (0.047 / 0.050 /
# 0.047) and carries no cluster structure at all -- the exact mirror of Set 3, where
# it is the representative-value coordinates that are identical across countries.
# W1 = eps*(dL + dH) gives a clean ladder: A-B 3.0, A-C 6.0, B-C 3.0.
ext_sampler <- function(mu0, eL, dL, eH, dH, s0 = 10, st = 8) {
  w <- c(eL, 1 - eL - eH, eH); m <- c(mu0 - dL, mu0, mu0 + dH); s <- c(st, s0, st)
  function(n) {
    k <- as.vector(rmultinom(1L, n, w))
    c(rnorm(k[1], m[1], s[1]), rnorm(k[2], m[2], s[2]), rnorm(k[3], m[3], s[3]))
  }
}
build_clust_set4 <- function() {
  c(rep_group("A", 4, "A", ext_sampler(50, 0.05,  40, 0.05,  40)),
    rep_group("B", 4, "B", ext_sampler(50, 0.05,  70, 0.05,  70)),
    rep_group("C", 4, "C", ext_sampler(50, 0.05, 100, 0.05, 100)))
}

# ---- one cell ---------------------------------------------------------------
run_cell <- function(roster, methods, n_per, n_reps, seed, k_true) {
  set.seed(seed)
  ids   <- names(roster)
  truth <- vapply(ids, function(id) roster[[id]]$group, character(1))

  acc <- setNames(lapply(methods, function(m) list(s = 0, s2 = 0, exact = 0)), methods)

  for (rep in seq_len(n_reps)) {
    S <- lapply(ids, function(id) sort(roster[[id]]$sampler(n_per)))  # sort once, reuse
    names(S) <- ids
    for (m in methods) {
      D  <- DMAT[[m]](S)
      # FIXED algorithm across methods: average linkage, cut at the true k.
      cl <- cutree(hclust(as.dist(D), method = "average"), k = k_true)
      ar <- adj_rand(truth, cl)
      acc[[m]]$s     <- acc[[m]]$s  + ar
      acc[[m]]$s2    <- acc[[m]]$s2 + ar * ar
      acc[[m]]$exact <- acc[[m]]$exact + (ar > 0.999)   # partition recovered exactly
    }
  }

  meanse <- function(s, s2) { mu <- s / n_reps; v <- max(0, s2/n_reps - mu^2); list(mu = mu, se = sqrt(v / n_reps)) }
  rows <- list()
  for (m in methods) {
    a <- meanse(acc[[m]]$s, acc[[m]]$s2)
    p <- acc[[m]]$exact / n_reps
    rows[[length(rows)+1]] <- data.frame(method = m, measure = "ari",
      value = a$mu, mc_se = a$se, stringsAsFactors = FALSE)
    rows[[length(rows)+1]] <- data.frame(method = m, measure = "exact_recovery",
      value = p, mc_se = sqrt(p * (1 - p) / n_reps), stringsAsFactors = FALSE)
  }
  do.call(rbind, rows)
}

# ---- main -------------------------------------------------------------------
main <- function() {
  OPTS <- parse_args()
  results_dir <- "results"
  if (!dir.exists(results_dir)) dir.create(results_dir, recursive = TRUE)
  logcon <- file(file.path(results_dir, "clustering_sim.log"), open = "wt")
  on.exit(close(logcon), add = TRUE)
  say <- function(...) { m <- sprintf(...); cat(m, "\n"); writeLines(m, logcon) }

  say("== Pooled-region CLUSTERING simulation (Part 2) ==")
  say("reps=%d  started=%s  R=%s", OPTS$reps, format(Sys.time()), R.version.string)
  say("algorithm held fixed across methods: hclust(average) + cutree(k=3); only the distance matrix varies")

  methods <- c("W1", "SMD", "KS", "RV1", "RV2", "RV3")
  sets <- list(
    list(id = "Set1_Gaussian",  roster = build_clust_set1()),
    list(id = "Set2_LogNormal", roster = build_clust_set2()),
    list(id = "Set3_Mixture",   roster = build_clust_set3()),
    list(id = "Set4_Extremes",  roster = build_clust_set4())
  )
  n_grid <- c(25L, 50L, 75L, 100L)
  base_seed <- 20260712L

  all_rows <- list(); cfg_rows <- list(); cell <- 0L
  for (S in sets) {
    ids <- names(S$roster)
    truth <- vapply(ids, function(id) S$roster[[id]]$group, character(1))
    k_true <- length(unique(truth))
    say("\n-- %s: %d countries, %d true groups (%s) --", S$id, length(ids), k_true,
        paste(names(table(truth)), table(truth), sep = "x", collapse = ", "))
    # audit the moment coordinates once: shows WHICH sets a representative-value
    # method can even in principle separate.
    set.seed(880000L + cell)
    mm <- vapply(ids, function(id) {
      v <- S$roster[[id]]$sampler(500000L); mu <- mean(v); s <- sd(v)
      c(mean = mu, sd = s, skew = mean(((v - mu)/s)^3))
    }, numeric(3))
    au <- data.frame(country = ids, group = truth, mean = round(mm["mean",], 2),
                     sd = round(mm["sd",], 2), skew = round(mm["skew",], 3),
                     stringsAsFactors = FALSE)
    say(paste(capture.output(print(au, row.names = FALSE)), collapse = "\n"))

    for (n in n_grid) {
      cell <- cell + 1L
      seed <- base_seed + 1000L * cell
      t0 <- Sys.time()
      res <- run_cell(S$roster, methods, n_per = n, n_reps = OPTS$reps, seed = seed, k_true = k_true)
      res <- cbind(set = S$id, n = n, res)
      all_rows[[length(all_rows)+1]] <- res
      el <- as.numeric(difftime(Sys.time(), t0, units = "secs"))
      pick <- function(m) res$value[res$method == m & res$measure == "ari"]
      say("[%s n=%d] seed=%d done (%.1fs)  ARI: W1=%.3f KS=%.3f RV1=%.3f RV2=%.3f RV3=%.3f SMD=%.3f",
          S$id, n, seed, el, pick("W1"), pick("KS"), pick("RV1"), pick("RV2"), pick("RV3"), pick("SMD"))
      cfg_rows[[length(cfg_rows)+1]] <- data.frame(set = S$id, n = n, seed = seed,
        reps = OPTS$reps, k_true = k_true, linkage = "average",
        methods = paste(methods, collapse = "|"), elapsed_s = round(el, 1),
        stringsAsFactors = FALSE)
    }
  }

  summary_df <- do.call(rbind, all_rows); rownames(summary_df) <- NULL
  write.csv(summary_df, file.path(results_dir, "clustering_sim_summary.csv"), row.names = FALSE)
  write.csv(do.call(rbind, cfg_rows), file.path(results_dir, "clustering_sim_config.csv"), row.names = FALSE)
  say("\n[save] results/clustering_sim_summary.csv  (%d rows)", nrow(summary_df))
  say("[done] finished=%s", format(Sys.time()))
  invisible(summary_df)
}

if (sys.nframe() == 0L) main()
