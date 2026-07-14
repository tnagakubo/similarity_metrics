# =============================================================================
# PART 1B — CLINICALLY CALIBRATED THRESHOLD SELECTION (drop the oracle k)
#
# WHY. Parts 1 and 2 rank countries and take the top k, with k = the TRUE number of
# matches. That hands every method an oracle it would never have in practice, and it
# never tests the paper's contribution (b): that W1 -- alone among these distances --
# converts a CLINICAL requirement into a selection threshold.
#
# THE CLINICAL REQUIREMENT. A sponsor states Delta_clin: the largest regional
# treatment-effect difference they are willing to tolerate in a pool. With L_clinical
# (the Lipschitz constant of the treatment effect in the EM), the Kantorovich-Rubinstein
# bound gives, for ANY 1-Lipschitz theta:
#
#        Delta_max = L * W1 <= Delta_clin     <=>     W1 <= Delta_clin / L  =:  tau_clin
#
# So a W1 threshold IS the clinical requirement, restated. Nothing is simulated and no
# theta is posited -- this is the theta-free bound, not the rejected Part 3.
#
# THE COMPETITORS CANNOT DO THIS. A KS threshold does not identify Delta_max. Set 4 is
# the proof, from the TRUE values alone:
#     T1: KS 0.047, true W1 3.0        T2: KS 0.050, true W1 6.0
# A KS cut at 0.05 admits both, so the same KS value is consistent with Delta_max =
# L*3.0 AND L*6.0. Worse, KS ranks S1 (KS 0.072, true W1 2.0) as MORE discordant than
# T2 -- it would reject the safer region and admit the one permitting 3x the effect
# difference. SMD's 0.1 is a convention, not a calibration. RV has no threshold theory.
#
# STEELMAN. We therefore do NOT strawman them with an arbitrary cut. Every competitor is
# given an ORACLE-CALIBRATED threshold: for each scenario and n we search its entire
# distance grid and hand it the best threshold it could possibly have used -- the one
# maximising sensitivity subject to the violation constraint. They get the answer for
# free; W1 has to derive its threshold from the clinical input alone (tau_clin).
#
# MEASURES (both metric-independent -- the truth is the construction label and the TRUE
# W1, neither of which any method sees):
#   violation rate = P(the chosen pool contains a country whose TRUE W1 > tau_clin)
#                  = P(the pool breaches the sponsor's clinical requirement)
#   sensitivity    = E[fraction of the true matches that were admitted]   (efficiency)
# Reported as the sensitivity each method reaches while holding violation <= alpha.
#
# Outputs (results/):
#   threshold_sim_summary.csv  — set,n,method,tau,violation,sensitivity,mc_se_*
#   threshold_sim_operating.csv— the headline: best sensitivity at violation <= alpha
#   threshold_sim.log
# =============================================================================

suppressWarnings(RNGkind("Mersenne-Twister", "Inversion", "Rejection"))
source(local({
  c1 <- c("R/selection_simulation.R", "selection_simulation.R",
          "projects/similarity-metric/R/selection_simulation.R")
  p <- c1[file.exists(c1)]
  if (!length(p)) stop("cannot find selection_simulation.R (cwd=", getwd(), ")")
  p[1]
}), chdir = TRUE)   # reuses build_set1..4, DISTFUN, true_w1 ; its main() is guarded off

parse_args <- function(a = commandArgs(trailingOnly = TRUE)) {
  out <- list(reps = 5000L, alpha = 0.05)
  for (x in a) {
    if (grepl("^--reps=", x))       out$reps  <- as.integer(sub("^--reps=", "", x))
    else if (grepl("^--alpha=", x)) out$alpha <- as.numeric(sub("^--alpha=", "", x))
    else if (x == "--test")         out$reps  <- 300L
  }
  out
}

# ---- one cell: sweep every method over its own threshold grid ---------------
run_threshold_cell <- function(roster, methods, n_per, n_reps, seed, tw1, tau_clin, grids) {
  set.seed(seed)
  cand_ids <- setdiff(names(roster), "A0")
  # THE TARGET IS CLINICAL, NOT COMBINATORIAL. A sponsor does not want "the countries
  # drawn from the same population"; they want "the countries whose pooling keeps the
  # regional effect difference within Delta_clin". By the KR bound that set is exactly
  #     ACCEPTABLE = { true W1 <= tau_clin }   (the true matches, at W1 = 0, plus any
  #                                             discordant country mild enough to tolerate)
  #     UNACCEPTABLE = { true W1 >  tau_clin }
  # Both are defined on the TRUTH and on the sponsor's requirement -- not on any
  # method's estimate -- so no method is scored by its own ruler.
  acceptable <- tw1[cand_ids] <= tau_clin
  bad        <- !acceptable
  n_ok       <- sum(acceptable)
  stopifnot(n_ok > 0, sum(bad) > 0)

  acc <- lapply(methods, function(m) {
    g <- grids[[m]]
    list(viol = numeric(length(g)), viol2 = numeric(length(g)),
         sens = numeric(length(g)), sens2 = numeric(length(g)))
  })
  names(acc) <- methods

  for (rep in seq_len(n_reps)) {
    xA <- roster$A0$sampler(n_per)
    xs <- lapply(cand_ids, function(id) roster[[id]]$sampler(n_per)); names(xs) <- cand_ids
    for (m in methods) {
      d <- DISTFUN[[m]](xA, xs)[cand_ids]
      g <- grids[[m]]
      # sel(tau) = { candidates with d <= tau }. Vectorised over the whole grid.
      for (j in seq_along(g)) {
        sel <- d <= g[j]
        v <- as.numeric(any(sel & bad))          # requirement breached?
        s <- sum(sel & acceptable) / n_ok        # how much of the admissible pool was kept?
        acc[[m]]$viol[j]  <- acc[[m]]$viol[j]  + v
        acc[[m]]$viol2[j] <- acc[[m]]$viol2[j] + v * v
        acc[[m]]$sens[j]  <- acc[[m]]$sens[j]  + s
        acc[[m]]$sens2[j] <- acc[[m]]$sens2[j] + s * s
      }
    }
  }

  meanse <- function(s, s2) { mu <- s / n_reps; v <- pmax(0, s2/n_reps - mu^2)
                              list(mu = mu, se = sqrt(v / n_reps)) }
  do.call(rbind, lapply(methods, function(m) {
    vv <- meanse(acc[[m]]$viol, acc[[m]]$viol2); ss <- meanse(acc[[m]]$sens, acc[[m]]$sens2)
    data.frame(method = m, tau = grids[[m]],
               violation = vv$mu, violation_se = vv$se,
               sensitivity = ss$mu, sensitivity_se = ss$se, stringsAsFactors = FALSE)
  }))
}

# ---- main ------------------------------------------------------------------
main <- function() {
  OPTS <- parse_args()
  dir.create("results", showWarnings = FALSE, recursive = TRUE)
  logcon <- file("results/threshold_sim.log", open = "wt"); on.exit(close(logcon), add = TRUE)
  say <- function(...) { m <- sprintf(...); cat(m, "\n"); writeLines(m, logcon) }

  say("== Clinically calibrated THRESHOLD selection (Part 1B) ==")
  say("reps=%d  alpha=%.2f  started=%s", OPTS$reps, OPTS$alpha, format(Sys.time()))
  say("W1 uses tau_clin DERIVED from the clinical requirement; every competitor is given")
  say("its ORACLE-BEST threshold (full grid search). No method is handed the true k.")

  methods <- c("W1", "SMD", "KS", "RV1", "RV2", "RV3")
  sets <- list(
    list(id = "Set1_Gaussian",  roster = build_set1(), lo = -80,  hi = 250),
    list(id = "Set2_LogNormal", roster = build_set2(), lo = 0,    hi = 500),
    list(id = "Set3_Mixture",   roster = build_set3(), lo = -60,  hi = 160),
    list(id = "Set4_Extremes",  roster = build_set4(), lo = -400, hi = 600)
  )
  n_grid <- c(25L, 50L, 75L, 100L)
  base_seed <- 20260714L

  all_rows <- list(); op_rows <- list(); cell <- 0L
  for (S in sets) {
    cand <- setdiff(names(S$roster), "A0")
    TW1  <- vapply(cand, function(i) true_w1(S$roster$A0, S$roster[[i]], S$lo, S$hi), numeric(1))
    roles <- vapply(cand, function(i) S$roster[[i]]$role, character(1))

    # tau_clin = Delta_clin / L, the sponsor's requirement translated onto the EM scale.
    # Set to the MEDIAN true W1 among the discordant countries, so that roughly half of
    # the real differences are mild enough to tolerate and half are not. Two reasons:
    #   - it is not tuned to any method (it is a function of the truth alone), and
    #   - it is the regime a sponsor is actually in. A requirement so strict that only
    #     an exact-match country qualifies is not a decision problem; and one so loose
    #     that everything qualifies is not either. (An earlier version set tau_clin to
    #     half the lightest discordant W1 -- which in Set 3 was 0.34, BELOW the null
    #     bias of the W1 estimator at n = 100, so nothing at all could be selected.)
    disc <- sort(TW1[roles != "match"])
    # SWEEP tau_clin, do not report one point. Two reasons:
    #  - "you chose tau" is answerable only by showing the whole curve;
    #  - a country sitting EXACTLY on tau is a coin-flip to admit even for a perfect
    #    method (Set 4 has three at true W1 = 3.000, the median), which structurally caps
    #    sensitivity. Placing tau BETWEEN the true W1 values removes that knife-edge.
    # Grid = midpoints between consecutive distinct discordant W1 values, so every tau
    # partitions the roster cleanly and each one is a genuinely different clinical
    # requirement (from "tolerate only the mildest" to "tolerate all but the worst").
    # Round before de-duplicating: true_w1() integrates numerically, so three countries
    # constructed to sit at exactly 3.0 come back as 2.9999998 / 3.0000001 / 3.0000000.
    # Without this, unique() keeps all three and the "midpoint" grid emits tau = 3.000
    # itself -- putting tau EXACTLY on those countries and making them a coin-flip to
    # admit even for a perfect method. That is the knife-edge this sweep exists to remove.
    u <- unique(round(disc, 6))
    tau_grid <- (u[-length(u)] + u[-1]) / 2
    tau_grid <- tau_grid[vapply(tau_grid, function(t) sum(TW1 <= t) >= 3 &&
                                                      sum(TW1 >  t) >= 1, logical(1))]
    say("\n-- %s --", S$id)
    say("   discordant true W1: %s", paste(sprintf("%.2f", disc), collapse = " "))
    say("   tau_clin swept over %d values: %s",
        length(tau_grid), paste(sprintf("%.2f", tau_grid), collapse = " "))
    say("   (each tau => ACCEPTABLE = {true W1 <= tau}; matches at W1 = 0 always acceptable)")

    # Threshold grids: each method searched over ITS OWN distance scale, from 0 to a
    # generous upper bound estimated from a pilot draw. W1's grid necessarily contains
    # tau_clin, which is the only threshold W1 is actually allowed to use.
    set.seed(77000L + cell)
    pilot <- replicate(200, {
      xA <- S$roster$A0$sampler(60L)
      xs <- lapply(cand, function(i) S$roster[[i]]$sampler(60L)); names(xs) <- cand
      vapply(methods, function(m) max(DISTFUN[[m]](xA, xs)), numeric(1))
    })
    # W1's grid must contain EVERY swept tau_clin exactly, because tau_clin is the only
    # threshold W1 is entitled to use without an oracle -- we have to be able to read its
    # operating point off the grid at that precise value.
    grids <- lapply(methods, function(m) {
      hi <- 1.15 * max(pilot[m, ])
      sort(unique(c(seq(0, hi, length.out = 200L), if (m == "W1") tau_grid)))
    })
    names(grids) <- methods

    for (n in n_grid) {
      cell <- cell + 1L
      t0 <- Sys.time()
      for (ti in seq_along(tau_grid)) {
        tau_clin <- tau_grid[ti]
        seed <- base_seed + 1000L * cell + ti
        res <- run_threshold_cell(S$roster, methods, n, OPTS$reps, seed, TW1, tau_clin, grids)
        res <- cbind(set = S$id, n = n, tau_clin = tau_clin,
                     n_acceptable = sum(TW1 <= tau_clin), res)
        all_rows[[length(all_rows) + 1]] <- res

        # OPERATING POINT, per (set, n, tau_clin):
        #  - every competitor gets its ORACLE-BEST threshold (max sensitivity s.t.
        #    violation <= alpha) -- it is told the answer;
        #  - W1 ALSO reports the threshold it is entitled to derive with no oracle at
        #    all: tau = tau_clin itself, straight from the clinical requirement.
        for (m in methods) {
          r  <- res[res$method == m, ]
          ok <- r[r$violation <= OPTS$alpha, ]
          best <- if (nrow(ok)) ok[which.max(ok$sensitivity), ] else r[which.min(r$violation), ]
          op_rows[[length(op_rows) + 1]] <- data.frame(
            set = S$id, n = n, tau_clin = tau_clin, method = m, kind = "oracle_best",
            tau = best$tau, violation = best$violation, sensitivity = best$sensitivity,
            feasible = nrow(ok) > 0, stringsAsFactors = FALSE)
          if (m == "W1") {
            i <- which.min(abs(r$tau - tau_clin))
            op_rows[[length(op_rows) + 1]] <- data.frame(
              set = S$id, n = n, tau_clin = tau_clin, method = "W1_derived",
              kind = "derived_tau_clin", tau = r$tau[i], violation = r$violation[i],
              sensitivity = r$sensitivity[i], feasible = r$violation[i] <= OPTS$alpha,
              stringsAsFactors = FALSE)
          }
        }
      }
      el <- as.numeric(difftime(Sys.time(), t0, units = "secs"))
      sens_at <- function(m) {
        z <- Filter(function(o) o$set == S$id && o$n == n && o$method == m &&
                                o$kind == "oracle_best", op_rows)
        if (length(z)) mean(vapply(z, function(o) o$sensitivity, numeric(1))) else NA_real_
      }
      say("[%s n=%d] (%.0fs, %d taus)  mean sensitivity @ violation<=%.2f :  W1=%.3f  KS=%.3f  RV2=%.3f  SMD=%.3f",
          S$id, n, el, length(tau_grid), OPTS$alpha,
          sens_at("W1"), sens_at("KS"), sens_at("RV2"), sens_at("SMD"))
    }
  }

  summary_df <- do.call(rbind, all_rows); rownames(summary_df) <- NULL
  op_df      <- do.call(rbind, op_rows);  rownames(op_df) <- NULL
  write.csv(summary_df, "results/threshold_sim_summary.csv", row.names = FALSE)
  write.csv(op_df,      "results/threshold_sim_operating.csv", row.names = FALSE)
  say("\n[save] results/threshold_sim_summary.csv   (%d rows)", nrow(summary_df))
  say("[save] results/threshold_sim_operating.csv (%d rows)", nrow(op_df))
  say("[done] finished=%s", format(Sys.time()))
  invisible(list(summary = summary_df, operating = op_df))
}

if (sys.nframe() == 0L) main()
