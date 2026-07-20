# =============================================================================
# PART 1B (option) — BOOTSTRAP-UPPER-BOUND selection rule
#
# WHY THIS EXISTS. validate_threshold.R closes with the open item this script answers:
# the oracle-free derived threshold (admit candidate iff its POINT estimate W1 <= tau_clin)
# controls violation when the clinical requirement is LOOSE relative to the estimator's
# noise, but NOT when it is TIGHT -- point estimates straddle tau and the pool breaches
# the requirement (worst point-rule violation ~0.55 at strict tau in Set 3). Tak's decision
# (2026-07-19): add, AS AN OPTION alongside the point rule, a conservative rule that admits
# a candidate only when the UPPER edge of its bootstrap interval clears tau:
#
#        admit  iff   Uhat_{1-alpha}(W1)  <=  tau_clin       (Uhat = upper percentile boot bound)
#
# The upper bound sits above the point estimate, so this rule is strictly more conservative:
# it trades sensitivity for violation control. Whether that trade opens a usable middle band
# (tolerable violation AND non-trivial sensitivity) at the strict-tau cells where the point
# rule failed is the entire empirical question.
#
# WHAT WE DO / DO NOT CLAIM (see the advisor note in SUITS 2026-07-19):
#   - Pool violation is a UNION over admitted countries, so a per-candidate (1-alpha) bound
#     controls each candidate at ~alpha only at the boundary; pool violation inflates toward
#     k*alpha. We therefore SWEEP the bootstrap confidence level and report the whole
#     violation/sensitivity frontier. We do NOT search the level to make violation land on
#     0.05 -- that would silently reintroduce the oracle 1B removed.
#   - The point rule and the bootstrap rule are evaluated on the SAME drawn samples here
#     (paired), so their difference is not muddied by Monte Carlo noise. This cell is
#     SELF-CONTAINED and does not touch threshold_simulation.R or its outputs.
#
# STRUCTURE (efficiency). The bootstrap upper bound of a candidate does not depend on tau,
# so we draw once per (set, n), bootstrap each candidate once per replicate, and evaluate
# the admit/reject decision against EVERY tau_clin in the sweep. Cost = reps * cand * B,
# independent of the number of taus and of the number of confidence levels.
#
# Outputs (results/):
#   threshold_boot_summary.csv  — set,n,rule,tau_clin,violation,sensitivity (+ MC SE)
#   threshold_boot.log
# =============================================================================

suppressWarnings(RNGkind("Mersenne-Twister", "Inversion", "Rejection"))

.here <- function(f) {
  p <- c(file.path("R", f), f, file.path("projects/similarity-metric/R", f))
  p <- p[file.exists(p)]; if (!length(p)) stop("cannot find ", f, " (cwd=", getwd(), ")"); p[1]
}
source(.here("selection_simulation.R"), chdir = TRUE)   # w1_dist, true_w1, build_set1..4
Rcpp::sourceCpp(.here("W1_raw_rcpp.cpp"))               # W1_raw_boot_upper_cpp

parse_args <- function(a = commandArgs(trailingOnly = TRUE)) {
  # Default scope = the discriminating cells: Set 3/4, n in {50,100}, full tau grid.
  out <- list(reps = 3000L, B = 999L, sets = c("Set3_Mixture", "Set4_Extremes"),
              ns = c(50L, 100L), probs = c(0.90, 0.95, 0.975))
  for (x in a) {
    if (grepl("^--reps=", x))      out$reps <- as.integer(sub("^--reps=", "", x))
    else if (grepl("^--B=", x))    out$B    <- as.integer(sub("^--B=", "", x))
    else if (grepl("^--sets=", x)) out$sets <- strsplit(sub("^--sets=", "", x), ",")[[1]]
    else if (grepl("^--ns=", x))   out$ns   <- as.integer(strsplit(sub("^--ns=", "", x), ",")[[1]])
    else if (x == "--all")         { out$sets <- c("Set1_Gaussian","Set2_LogNormal",
                                                   "Set3_Mixture","Set4_Extremes")
                                     out$ns <- c(25L,50L,75L,100L) }
    else if (x == "--test")        { out$reps <- 200L; out$B <- 199L
                                     out$sets <- "Set4_Extremes"; out$ns <- 50L }
  }
  out
}

# tau_clin grid, reproduced EXACTLY from threshold_simulation.R so the two scripts agree
# on what each clinical requirement means (midpoints between distinct discordant true W1,
# rounded before de-dup to collapse numerical-integration jitter at constructed ties).
tau_grid_for <- function(roster, lo, hi) {
  cand  <- setdiff(names(roster), "A0")
  TW1   <- vapply(cand, function(i) true_w1(roster$A0, roster[[i]], lo, hi), numeric(1))
  roles <- vapply(cand, function(i) roster[[i]]$role, character(1))
  disc  <- sort(TW1[roles != "match"])
  u     <- unique(round(disc, 6))
  tg    <- (u[-length(u)] + u[-1]) / 2
  tg    <- tg[vapply(tg, function(t) sum(TW1 <= t) >= 3 && sum(TW1 > t) >= 1, logical(1))]
  list(tau_grid = tg, TW1 = TW1, cand = cand)
}

# One (set, n) cell: draw reps ONCE, evaluate the point rule and each bootstrap-level rule
# against every tau, all on identical samples.
run_boot_cell <- function(roster, n_per, n_reps, seed, TW1, cand, tau_grid, probs, B) {
  set.seed(seed)
  nT <- length(tau_grid); nP <- length(probs)
  rules <- c("point", sprintf("boot_%.3f", probs))            # point estimate + one per level
  nR <- length(rules)
  # per (rule, tau): running sum & sumsq of violation (0/1) and sensitivity (fraction)
  vs  <- array(0, c(nR, nT)); vs2 <- array(0, c(nR, nT))
  ss  <- array(0, c(nR, nT)); ss2 <- array(0, c(nR, nT))

  # precompute the truth partition for each tau (matches always acceptable at true W1 = 0)
  acc_list <- lapply(tau_grid, function(t) { a <- TW1[cand] <= t; list(acc = a, bad = !a, nok = sum(a)) })

  for (rep in seq_len(n_reps)) {
    xA <- roster$A0$sampler(n_per)
    xs <- lapply(cand, function(id) roster[[id]]$sampler(n_per)); names(xs) <- cand
    dpoint <- vapply(cand, function(id) w1_dist(xA, xs[[id]]), numeric(1))
    ub <- vapply(cand, function(id) {
      r <- W1_raw_boot_upper_cpp(xA, xs[[id]], B = B, probs = probs); r$upper
    }, numeric(nP))                                            # nP x ncand (rows = levels)
    if (is.null(dim(ub))) ub <- matrix(ub, nrow = nP)

    for (ti in seq_len(nT)) {
      a <- acc_list[[ti]]$acc; bad <- acc_list[[ti]]$bad; nok <- acc_list[[ti]]$nok
      tau <- tau_grid[ti]
      # rule 1: point estimate
      sel <- dpoint <= tau
      v <- as.numeric(any(sel & bad)); s <- sum(sel & a) / nok
      vs[1, ti] <- vs[1, ti] + v; vs2[1, ti] <- vs2[1, ti] + v * v
      ss[1, ti] <- ss[1, ti] + s; ss2[1, ti] <- ss2[1, ti] + s * s
      # rules 2..: bootstrap upper bound at each level
      for (pj in seq_len(nP)) {
        selb <- ub[pj, ] <= tau
        v <- as.numeric(any(selb & bad)); s <- sum(selb & a) / nok
        r <- 1L + pj
        vs[r, ti] <- vs[r, ti] + v; vs2[r, ti] <- vs2[r, ti] + v * v
        ss[r, ti] <- ss[r, ti] + s; ss2[r, ti] <- ss2[r, ti] + s * s
      }
    }
  }

  meanse <- function(s, s2) { mu <- s / n_reps; v <- pmax(0, s2 / n_reps - mu^2)
                              list(mu = mu, se = sqrt(v / n_reps)) }
  do.call(rbind, lapply(seq_len(nR), function(r) {
    vv <- meanse(vs[r, ], vs2[r, ]); tt <- meanse(ss[r, ], ss2[r, ])
    data.frame(rule = rules[r], tau_clin = tau_grid,
               violation = vv$mu, violation_se = vv$se,
               sensitivity = tt$mu, sensitivity_se = tt$se, stringsAsFactors = FALSE)
  }))
}

main <- function() {
  OPTS <- parse_args()
  dir.create("results", showWarnings = FALSE, recursive = TRUE)
  logcon <- file("results/threshold_boot.log", open = "wt"); on.exit(close(logcon), add = TRUE)
  say <- function(...) { m <- sprintf(...); cat(m, "\n"); writeLines(m, logcon) }

  say("== Part 1B (option): BOOTSTRAP-UPPER-BOUND selection rule ==")
  say("reps=%d  B=%d  sets={%s}  n={%s}  boot upper levels={%s}",
      OPTS$reps, OPTS$B, paste(OPTS$sets, collapse=","), paste(OPTS$ns, collapse=","),
      paste(sprintf("%.3f", OPTS$probs), collapse=","))
  say("rule: admit candidate iff its (level) upper bootstrap bound <= tau_clin (percentile, one-sided)")
  say("point rule shown alongside on the SAME samples (paired); confidence level is SWEPT, not tuned")

  all_sets <- list(
    Set1_Gaussian  = list(roster = build_set1, lo = -80,  hi = 250),
    Set2_LogNormal = list(roster = build_set2, lo = 0,    hi = 500),
    Set3_Mixture   = list(roster = build_set3, lo = -60,  hi = 160),
    Set4_Extremes  = list(roster = build_set4, lo = -400, hi = 600)
  )
  base_seed <- 20260719L
  rows <- list(); cell <- 0L

  for (sid in OPTS$sets) {
    S <- all_sets[[sid]]; if (is.null(S)) { say("!! unknown set %s -- skipped", sid); next }
    roster <- S$roster()
    g <- tau_grid_for(roster, S$lo, S$hi)
    say("\n-- %s --  discordant true W1: %s", sid,
        paste(sprintf("%.2f", sort(g$TW1[vapply(g$cand, function(i) roster[[i]]$role, character(1)) != "match"])),
              collapse = " "))
    say("   tau_clin swept over %d values: %s", length(g$tau_grid),
        paste(sprintf("%.2f", g$tau_grid), collapse = " "))

    for (n in OPTS$ns) {
      cell <- cell + 1L
      t0 <- Sys.time()
      res <- run_boot_cell(roster, n, OPTS$reps, base_seed + 1000L * cell,
                           g$TW1, g$cand, g$tau_grid, OPTS$probs, OPTS$B)
      res <- cbind(set = sid, n = n, res)
      rows[[length(rows) + 1]] <- res
      el <- as.numeric(difftime(Sys.time(), t0, units = "secs"))
      # headline: at the STRICTEST tau, does the top bootstrap level cut violation vs the point rule?
      tmin <- min(g$tau_grid)
      pr  <- subset(res, rule == "point"            & abs(tau_clin - tmin) < 1e-9)
      bhi <- subset(res, rule == sprintf("boot_%.3f", max(OPTS$probs)) & abs(tau_clin - tmin) < 1e-9)
      say("[%s n=%d] (%.0fs)  strict tau=%.2f:  point viol=%.3f sens=%.3f  ->  boot@%.3f viol=%.3f sens=%.3f",
          sid, n, el, tmin, pr$violation, pr$sensitivity,
          max(OPTS$probs), bhi$violation, bhi$sensitivity)
    }
  }

  out <- do.call(rbind, rows); rownames(out) <- NULL
  write.csv(out, "results/threshold_boot_summary.csv", row.names = FALSE)
  say("\n[save] results/threshold_boot_summary.csv (%d rows)", nrow(out))
  say("[done] finished")
  invisible(out)
}

if (sys.nframe() == 0L) main()
