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

# ---- Komiyama et al. (2024) Ch.4 §4.6.1.1 representative-value distance ------
# Each country -> a representative value per EM "parameter" (coordinate); each
# coordinate is standardized to N(0,1) ACROSS countries; distance = Euclidean.
# Standardization is roster-level (not pairwise), so this cannot be written as a
# two-sample distance -- hence the roster-level distance API below.
# Implemented FAIRLY (Louis, 2026-06-27): §4.6.1.1 says "representative value in
# each candidate PARAMETER", not "the mean". A mean-only version would be a
# strawman patchable in one line. Two variants are therefore reported:
#   KOM  = (mean, SD)         -- the natural 2-coordinate reading
#   KOM3 = (mean, SD, skew)   -- pre-empts "just add another moment"
komiyama_dists <- function(xA, xs, coords = c("mean", "sd")) {
  allx <- c(list(A0 = xA), xs)
  M <- vapply(allx, function(v) {
    m <- mean(v); s <- sd(v)
    c(mean = m, sd = s, skew = mean(((v - m) / s)^3))[coords]
  }, numeric(length(coords)))
  if (is.null(dim(M))) M <- matrix(M, nrow = 1L, dimnames = list(coords, names(allx)))
  ctr <- rowMeans(M)
  sdv <- apply(M, 1L, sd)
  sdv[!is.finite(sdv) | sdv < .Machine$double.eps] <- 1  # degenerate coordinate -> no scaling
  Z <- (M - ctr) / sdv
  a <- Z[, "A0"]
  vapply(names(xs), function(id) sqrt(sum((Z[, id] - a)^2)), numeric(1))
}

# ---- roster-level distance API ---------------------------------------------
# Every method maps (anchor sample, named list of candidate samples) -> named
# vector of anchor-to-candidate distances, in the order of names(xs).
as_roster <- function(f) function(xA, xs) vapply(xs, function(y) f(xA, y), numeric(1))
DISTFUN <- list(
  W1      = as_roster(w1_dist),
  SMD     = as_roster(smd_dist),
  SMD_log = as_roster(smd_log_dist),
  KS      = as_roster(ks_dist),
  KOM     = function(xA, xs) komiyama_dists(xA, xs, c("mean", "sd")),
  KOM3    = function(xA, xs) komiyama_dists(xA, xs, c("mean", "sd", "skew"))
)

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

# ---- Set 3: matched-moment world (the decisive test of pillar (a)) ----------
# WHY THIS SET EXISTS. Sets 1 and 2 are two-parameter families: (mean, SD)
# determines the whole distribution, so a fair (mean,SD) representative-value
# method can detect EVERY discordant country there -- W1 has no structural
# advantage over KOM in Sets 1-2, and we report that honestly. The open question
# a moment-list method cannot answer is: WHICH moments must be enumerated? Set 3
# answers it. Every country is a two-component Gaussian mixture (one consistent
# family, per Tak's realism requirement -- e.g. a genotype sub-population, such as
# fast/slow metabolisers, whose mixing proportion differs by region). Every
# candidate is constructed to match the anchor EXACTLY on overall mean (50) and
# SD (10); only the SHAPE differs. The symmetric-mixture countries additionally
# match the anchor's skewness (= 0), so even a (mean,SD,skew) method is blind.
#
# mixture: w*N(m1,s) + (1-w)*N(m2,s), parameterised by (w, d = m1-m2) with s
# solved so that the overall mean/variance hit the anchor's:
#   mean = w*m1 + (1-w)*m2 ;  var = s^2 + w(1-w)d^2 ;  skew = w(1-w)(1-2w)d^3 / var^1.5
mix_c <- function(role, w, d, mu = 50, v = 100) {
  s2 <- v - w * (1 - w) * d^2
  stopifnot(s2 > 0)                      # mixture must be able to hit the target variance
  s  <- sqrt(s2)
  m1 <- mu + (1 - w) * d                 # component carrying weight w
  m2 <- mu - w * d
  list(role = role,
       sampler = function(n) { k <- rbinom(1L, n, w); c(rnorm(k, m1, s), rnorm(n - k, m2, s)) },
       cdf     = function(t) w * pnorm(t, m1, s) + (1 - w) * pnorm(t, m2, s))
}
build_set3 <- function() {   # Mixture world: every country has mean 50, SD 10
  list(
    # Anchor: components only 6 apart -> effectively unimodal, skew 0. It is still
    # a mixture (same family as everyone else), just a barely-separated one.
    A0  = mix_c("anchor",       0.50,  6),
    G1  = mix_c("match",        0.50,  6), G2 = mix_c("match", 0.50, 6), G3 = mix_c("match", 0.50, 6),
    # Symmetric bimodal: mean, SD AND skew (= 0) all identical to the anchor.
    # Invisible to BOTH (mean,SD) and (mean,SD,skew) representative-value distance.
    B1  = mix_c("shape_sym",    0.50, 15),   # separation d/s = 2.3
    B2  = mix_c("shape_sym",    0.50, 19),   # separation d/s = 6.1 (two clear modes)
    # Asymmetric (a minority sub-population sitting low): mean and SD identical,
    # skewness differs -> KOM blind, KOM3 can see it.
    S1  = mix_c("shape_skew",   0.75, 16),   # skew ~= -0.38
    S2  = mix_c("shape_skew",   0.85, 19),   # skew ~= -0.61
    # Asymmetric AND bimodal.
    C1  = mix_c("combined",     0.70, 18),   # skew ~= -0.49
    C2  = mix_c("combined",     0.80, 17)    # skew ~= -0.47
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

  for (rep in seq_len(n_reps)) {
    xA <- roster$A0$sampler(n_per)
    xs <- lapply(cand_ids, function(id) roster[[id]]$sampler(n_per)); names(xs) <- cand_ids
    jit <- runif(nc)   # one random tie-break key per rep, shared across methods
    for (m in methods) {
      d <- DISTFUN[[m]](xA, xs)[cand_ids]   # roster-level API; enforce roster order
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
         methods = c("W1","SMD","KS","KOM","KOM3"), lo = -80, hi = 250),
    list(id = "Set2_LogNormal", roster = build_set2(),
         methods = c("W1","SMD","SMD_log","KS","KOM","KOM3"), lo = 0, hi = 500),
    list(id = "Set3_Mixture", roster = build_set3(),
         methods = c("W1","SMD","KS","KOM","KOM3"), lo = -60, hi = 160)
  )
  n_grid   <- c(25L, 50L, 75L, 100L)
  base_seed <- 20260711L

  all_rows <- list(); cfg_rows <- list(); cell <- 0L
  for (si in seq_along(sets)) {
    S <- sets[[si]]
    # Truth structure, printed once per set. The moment columns are the audit that
    # decides whether a set can discriminate W1 from a representative-value method:
    # a discordant country whose (mean, SD) equal the anchor's is invisible to KOM,
    # and one whose skew also matches is invisible to KOM3.
    ids_all <- names(S$roster)
    set.seed(990000L + si)
    mom <- vapply(ids_all, function(id) {
      v <- S$roster[[id]]$sampler(1000000L); m <- mean(v); s <- sd(v)
      c(mean = m, sd = s, skew = mean(((v - m) / s)^3))
    }, numeric(3))
    tr <- data.frame(country = ids_all,
      role = vapply(ids_all, function(id) S$roster[[id]]$role, character(1)),
      mean = round(mom["mean", ], 2), sd = round(mom["sd", ], 2), skew = round(mom["skew", ], 3),
      true_W1 = round(vapply(ids_all, function(id) true_w1(S$roster$A0, S$roster[[id]], S$lo, S$hi), numeric(1)), 3),
      true_KS = round(vapply(ids_all, function(id) true_ks(S$roster$A0, S$roster[[id]], S$lo, S$hi), numeric(1)), 3),
      stringsAsFactors = FALSE)
    say("\n-- %s truth structure (moments from 1e6 draws) --", S$id)
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
