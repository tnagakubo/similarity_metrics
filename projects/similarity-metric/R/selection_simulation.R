# =============================================================================
# Pooling-partner SELECTION simulation (production driver)
# Question: can a distributional metric (W1) select the countries that truly
# share the anchor's EM distribution, better than SMD (raw / log) and KS?
#
# Framework: ADEMP (Morris, White & Crowther 2019, Stat Med, DOI 10.1002/sim.8086).
# Ground truth = construction label (same population as anchor: yes/no) -> the
# poolable set is metric-independent (non-circular).
#
# Two scenario sets, each a consistent single distributional family:
#   Set 1 (Gaussian world):   discordance in location / scale.
#   Set 2 (Skewed/log-normal): discordance in location / dispersion+shape.
#
# Methods rank the 9 candidates by anchor-to-candidate distance; the k nearest
# (k = |true match set|) are the proposed pooling partners.
#   Set 1 methods: W1, SMD, KS.   Set 2 methods: W1, SMD(raw), SMD(log), KS.
#
# Reproducibility notes:
#   - Pure base R (rnorm/rlnorm/sort/ks.test/integrate); no Rcpp/parallel.
#   - Per-cell seed set INSIDE run_cell + serial execution => bit-reproducible.
#     (This selection sim is fully reproducible, in contrast to the
#      per-EM W1 operating-characteristic sim whose parLapplyLB + per-worker
#      RNG streams make individual replicates non-bit-reproducible.)
#   - W1 estimator = sorted-pair mean(|x_(i)-y_(i)|), equal n; this equals the
#     canonical integral-of-|F1-F2| Wasserstein-1 to machine precision
#     (verified in validate_selection.R, Check 1).
#   - Ties in a method's distances are broken at RANDOM (under the cell seed),
#     not by roster order, so matches (listed first) get no spurious advantage.
#
# Outputs (results/):
#   selection_sim_summary.csv  — tidy: set,n,method,measure,type,value,mc_se
#   selection_sim_config.csv   — per-cell seeds + settings (reproducibility)
#   selection_sim.log          — run log
# =============================================================================

suppressWarnings(RNGkind("Mersenne-Twister", "Inversion", "Rejection"))

# ---- CLI (reps overridable for a quick smoke run) --------------------------
parse_args <- function(a = commandArgs(trailingOnly = TRUE)) {
  out <- list(reps = 10000L, ntest = FALSE)
  for (x in a) {
    if (grepl("^--reps=", x)) out$reps <- as.integer(sub("^--reps=", "", x))
    else if (x == "--test")  out$ntest <- TRUE
  }
  if (out$ntest) out$reps <- 500L
  out
}

# ---- distance / metric functions -------------------------------------------
w1_dist  <- function(x, y) { n <- min(length(x), length(y)); mean(abs(sort(x)[1:n] - sort(y)[1:n])) }
smd_dist <- function(x, y) {
  sp <- sqrt(((length(x)-1)*var(x) + (length(y)-1)*var(y)) / (length(x)+length(y)-2))
  abs(mean(x) - mean(y)) / sp
}
smd_log_dist <- function(x, y) smd_dist(log(x), log(y))   # Set 2 only (positive support)
ks_dist  <- function(x, y) as.numeric(suppressWarnings(ks.test(x, y)$statistic))
# AUC: P(a true-match distance < a discordant distance), ties scored 0.5 (fair).
auc_pairs <- function(dm, dd) mean(outer(dm, dd, function(a, b) (a < b) + 0.5 * (a == b)))

# ---- roster builders -------------------------------------------------------
# Each country: list(role, sampler(n), cdf(t)). Anchor is 'A0'.
lnorm_pars <- function(mean, cv) { s <- sqrt(log(1 + cv^2)); list(meanlog = log(mean) - s^2/2, sdlog = s) }

build_set1 <- function() {   # Gaussian world
  norm_c <- function(role, mu, sd) list(role = role,
    sampler = function(n) rnorm(n, mu, sd), cdf = function(t) pnorm(t, mu, sd))
  list(
    A0  = norm_c("anchor",   50, 10),
    G1  = norm_c("match",    50, 10), G2 = norm_c("match", 50, 10), G3 = norm_c("match", 50, 10),
    L1  = norm_c("location", 55, 10), L2 = norm_c("location", 58, 10),
    V1  = norm_c("scale",    50, 16), V2 = norm_c("scale", 50, 20),
    X1  = norm_c("combined", 56, 14), X2 = norm_c("combined", 54, 13)
  )
}
build_set2 <- function() {   # Skewed / log-normal world
  ln_c <- function(role, mean, cv) { p <- lnorm_pars(mean, cv); list(role = role,
    sampler = function(n) rlnorm(n, p$meanlog, p$sdlog), cdf = function(t) plnorm(t, p$meanlog, p$sdlog)) }
  list(
    A0  = ln_c("anchor",   50, 0.40),
    G1  = ln_c("match",    50, 0.40), G2 = ln_c("match", 50, 0.40), G3 = ln_c("match", 50, 0.40),
    Lm1 = ln_c("location", 55, 0.40), Lm2 = ln_c("location", 58, 0.40),
    Dp1 = ln_c("shape",    50, 0.60), Dp2 = ln_c("shape", 50, 0.85),
    Cx1 = ln_c("combined", 55, 0.65), Cx2 = ln_c("combined", 53, 0.55)
  )
}

# ---- analytic true distances anchor -> candidate ---------------------------
true_w1 <- function(a, b, lo, hi) integrate(function(t) abs(a$cdf(t) - b$cdf(t)),
                                            lo, hi, subdivisions = 3000L, rel.tol = 1e-8)$value
true_ks <- function(a, b, lo, hi) { g <- seq(lo, hi, length.out = 200001L); max(abs(a$cdf(g) - b$cdf(g))) }

# ---- one cell: one (roster, methods, n) over n_reps ------------------------
run_cell <- function(roster, methods, n_per, n_reps, seed) {
  set.seed(seed)
  cand_ids   <- setdiff(names(roster), "A0")
  roles      <- vapply(cand_ids, function(id) roster[[id]]$role, character(1))
  true_match <- roles == "match"
  k_true     <- sum(true_match)
  types      <- setdiff(unique(roles), "match")
  nc         <- length(cand_ids)

  # accumulators (sum & sumsq per rep) for mean + MC SE
  acc <- function() list(prec = 0, prec2 = 0, fp = 0, fp2 = 0,
                         auc = setNames(numeric(length(types)), types),
                         auc2 = setNames(numeric(length(types)), types))
  A <- setNames(lapply(methods, function(m) acc()), methods)

  distfun <- list(W1 = w1_dist, SMD = smd_dist, SMD_log = smd_log_dist, KS = ks_dist)

  for (rep in seq_len(n_reps)) {
    xA <- roster$A0$sampler(n_per)
    xs <- lapply(cand_ids, function(id) roster[[id]]$sampler(n_per)); names(xs) <- cand_ids
    jit <- runif(nc)   # one random tie-break key per rep, shared across methods
    for (m in methods) {
      d <- vapply(cand_ids, function(id) distfun[[m]](xA, xs[[id]]), numeric(1))
      sel <- cand_ids[order(d, jit)][seq_len(k_true)]     # RANDOM tie-break
      ncm <- sum(true_match[sel])
      p <- ncm / k_true; f <- as.numeric(ncm < k_true)
      A[[m]]$prec <- A[[m]]$prec + p; A[[m]]$prec2 <- A[[m]]$prec2 + p*p
      A[[m]]$fp   <- A[[m]]$fp   + f; A[[m]]$fp2   <- A[[m]]$fp2   + f*f
      dm <- d[true_match]
      for (ty in types) {
        av <- auc_pairs(dm, d[roles == ty])
        A[[m]]$auc[ty]  <- A[[m]]$auc[ty]  + av
        A[[m]]$auc2[ty] <- A[[m]]$auc2[ty] + av*av
      }
    }
  }

  # assemble tidy rows: mean + MC SE
  meanse <- function(s, s2) { mu <- s / n_reps; v <- max(0, s2/n_reps - mu^2); list(mu = mu, se = sqrt(v / n_reps)) }
  rows <- list()
  for (m in methods) {
    pr <- meanse(A[[m]]$prec, A[[m]]$prec2); fp <- meanse(A[[m]]$fp, A[[m]]$fp2)
    rows[[length(rows)+1]] <- data.frame(method=m, measure="precision_at_k", type="overall",
                                         value=pr$mu, mc_se=pr$se, stringsAsFactors=FALSE)
    rows[[length(rows)+1]] <- data.frame(method=m, measure="false_pooling_at_k", type="overall",
                                         value=fp$mu, mc_se=fp$se, stringsAsFactors=FALSE)
    for (ty in types) {
      au <- meanse(A[[m]]$auc[ty], A[[m]]$auc2[ty])
      rows[[length(rows)+1]] <- data.frame(method=m, measure="auc", type=ty,
                                           value=au$mu, mc_se=au$se, stringsAsFactors=FALSE)
    }
  }
  do.call(rbind, rows)
}

# ---- main ------------------------------------------------------------------
main <- function() {
  OPTS <- parse_args()
  results_dir <- "results"
  if (!dir.exists(results_dir)) dir.create(results_dir, recursive = TRUE)
  logfile <- file.path(results_dir, "selection_sim.log")
  logcon <- file(logfile, open = "wt"); on.exit(close(logcon), add = TRUE)
  say <- function(...) { m <- sprintf(...); cat(m, "\n"); writeLines(m, logcon) }

  say("== Pooling-partner selection simulation ==")
  say("reps=%d  started=%s  R=%s", OPTS$reps, format(Sys.time()), R.version.string)

  sets <- list(
    list(id = "Set1_Gaussian", roster = build_set1(),
         methods = c("W1","SMD","KS"), lo = -80, hi = 250),
    list(id = "Set2_LogNormal", roster = build_set2(),
         methods = c("W1","SMD","SMD_log","KS"), lo = 0, hi = 500)
  )
  n_grid   <- c(25L, 50L, 75L, 100L)
  base_seed <- 20260711L

  all_rows <- list(); cfg_rows <- list(); cell <- 0L
  for (si in seq_along(sets)) {
    S <- sets[[si]]
    # print truth structure once per set
    cand_ids <- setdiff(names(S$roster), "A0")
    tr <- data.frame(cand = cand_ids,
      role = vapply(cand_ids, function(id) S$roster[[id]]$role, character(1)),
      true_W1 = vapply(cand_ids, function(id) true_w1(S$roster$A0, S$roster[[id]], S$lo, S$hi), numeric(1)),
      true_KS = vapply(cand_ids, function(id) true_ks(S$roster$A0, S$roster[[id]], S$lo, S$hi), numeric(1)),
      stringsAsFactors = FALSE)
    say("\n-- %s truth structure --", S$id)
    say(paste(capture.output(print(tr, row.names = FALSE)), collapse = "\n"))

    for (n in n_grid) {
      cell <- cell + 1L
      seed <- base_seed + 1000L * cell
      t0 <- Sys.time()
      res <- run_cell(S$roster, S$methods, n_per = n, n_reps = OPTS$reps, seed = seed)
      res <- cbind(set = S$id, n = n, res)
      all_rows[[length(all_rows)+1]] <- res
      el <- as.numeric(difftime(Sys.time(), t0, units = "secs"))
      # headline line
      w1fp  <- res$value[res$method=="W1"  & res$measure=="false_pooling_at_k"]
      smdfp <- res$value[res$method=="SMD" & res$measure=="false_pooling_at_k"]
      say("[%s n=%d] seed=%d done (%.1fs)  false-pool@k: W1=%.3f SMD=%.3f",
          S$id, n, seed, el, w1fp, smdfp)
      cfg_rows[[length(cfg_rows)+1]] <- data.frame(set = S$id, n = n, seed = seed,
        reps = OPTS$reps, methods = paste(S$methods, collapse="|"), elapsed_s = round(el,1),
        stringsAsFactors = FALSE)
    }
  }

  summary_df <- do.call(rbind, all_rows); rownames(summary_df) <- NULL
  cfg_df     <- do.call(rbind, cfg_rows)
  write.csv(summary_df, file.path(results_dir, "selection_sim_summary.csv"), row.names = FALSE)
  write.csv(cfg_df,     file.path(results_dir, "selection_sim_config.csv"),  row.names = FALSE)
  say("\n[save] results/selection_sim_summary.csv  (%d rows)", nrow(summary_df))
  say("[save] results/selection_sim_config.csv")
  say("[done] finished=%s", format(Sys.time()))
  invisible(summary_df)
}

if (sys.nframe() == 0L) main()
