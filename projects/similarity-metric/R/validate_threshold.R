# =============================================================================
# Validation for Part 1B — clinically calibrated threshold selection.
#
# The claims here are the ones most exposed to a circularity charge, so they are the
# ones that most need machine assertion. Three jobs:
#
#   (A) NON-IDENTIFICATION, from the TRUE values alone (no simulation, no theta).
#       This is the anti-circularity proof: no KS threshold, oracle-tuned or not, can
#       recover a clinical target of the form { W1 <= tau }. If this check ever fails,
#       the paper's central claim about KS is wrong.
#   (B) DESIGN INTEGRITY — the target is defined on the truth; the competitors really
#       are given their oracle-best cut; no tau sits on a knife-edge.
#   (C) THE RESULTS — including the cells where W1 LOSES.
# =============================================================================
.here <- function(f) {
  p <- c(file.path("R", f), f, file.path("projects/similarity-metric/R", f))
  p <- p[file.exists(p)]; if (!length(p)) stop("cannot find ", f); p[1]
}
source(.here("selection_simulation.R"), chdir = TRUE)   # build_set4, true_w1, true_ks
source(.here("figures_threshold.R"),    chdir = TRUE)   # load_threshold, fig_*

ok <- TRUE
chk <- function(name, cond, detail = "") {
  cat(sprintf("[%s] %s%s\n", if (isTRUE(cond)) "PASS" else "FAIL", name,
              if (nzchar(detail)) paste0("  -- ", detail) else "")); if (!isTRUE(cond)) ok <<- FALSE
}

sm <- read.csv(.here("../results/threshold_sim_summary.csv"),   stringsAsFactors = FALSE)
op <- read.csv(.here("../results/threshold_sim_operating.csv"), stringsAsFactors = FALSE)

# =============================================================================
# (A) NON-IDENTIFICATION -- the anti-circularity proof, from truth alone
# =============================================================================
cat("\n--- (A) can a KS threshold recover the clinical target? (true values only) ---\n")
S4 <- build_set4(); LO <- -400; HI <- 600
cand <- setdiff(names(S4), "A0")
W <- vapply(cand, function(i) true_w1(S4$A0, S4[[i]], LO, HI), numeric(1))
K <- vapply(cand, function(i) true_ks(S4$A0, S4[[i]], LO, HI), numeric(1))

chk("Set4 truth: T1 and T2 differ 2x in W1 but are near-identical in KS",
    abs(W[["T2"]] / W[["T1"]] - 2) < 0.02 && abs(K[["T2"]] / K[["T1"]] - 1) < 0.10,
    sprintf("W1 %.2f vs %.2f (x%.2f) | KS %.4f vs %.4f (x%.3f)",
            W[["T1"]], W[["T2"]], W[["T2"]]/W[["T1"]],
            K[["T1"]], K[["T2"]], K[["T2"]]/K[["T1"]]))

# THE decisive check: for a target { true W1 <= tau } with tau strictly between T1 and
# T2, does ANY KS cut reproduce it? Sweep every possible KS threshold and see whether
# even one separates the acceptable set from the unacceptable set.
tau <- (W[["T1"]] + W[["T2"]]) / 2          # e.g. 4.5: T1 acceptable, T2 not
acceptable <- W <= tau
cuts <- sort(unique(c(0, K, K + 1e-9, max(K) + 1)))
recovered <- vapply(cuts, function(c0) identical(unname(K <= c0), unname(acceptable)), logical(1))
chk("*** NO KS threshold recovers the clinical target { true W1 <= tau } ***",
    !any(recovered),
    sprintf("tau=%.2f: acceptable={%s}; searched %d KS cuts, %d reproduce it",
            tau, paste(names(acceptable)[acceptable], collapse=","), length(cuts), sum(recovered)))
chk("    (and W1's own threshold trivially does, by definition -- that IS contribution (b))",
    identical(unname(W <= tau), unname(acceptable)))
chk("Set4: KS RANKS the target wrongly -- it calls the SAFEST discordant country the worst",
    K[["S1"]] > K[["T2"]] && W[["S1"]] < W[["T2"]],
    sprintf("S1: KS %.3f (worst) but true W1 %.1f (mildest) | T2: KS %.3f, true W1 %.1f",
            K[["S1"]], W[["S1"]], K[["T2"]], W[["T2"]]))

# =============================================================================
# (B) DESIGN INTEGRITY
# =============================================================================
cat("\n--- (B) design integrity ---\n")
chk("target is defined on the TRUTH: n_acceptable always includes the 3 true matches",
    all(sm$n_acceptable >= 3), sprintf("min = %d", min(sm$n_acceptable)))
chk("every tau leaves at least one country unacceptable (a real decision problem)",
    all(sm$n_acceptable < 9), sprintf("max = %d of 9", max(sm$n_acceptable)))
chk("no tau sits ON a country's true W1 (the knife-edge that would coin-flip a perfect method)",
    { t4 <- unique(sm$tau_clin[sm$set == "Set4_Extremes"])
      all(vapply(t4, function(t) min(abs(W - t)) > 1e-6, logical(1))) },
    sprintf("Set4 taus: %s (true W1 include 3.000 x3)",
            paste(sprintf("%.2f", unique(sm$tau_clin[sm$set=="Set4_Extremes"])), collapse=" ")))
chk("tau is SWEPT, not chosen (>= 3 distinct values per set)",
    all(tapply(sm$tau_clin, sm$set, function(x) length(unique(x))) >= 3))
chk("competitors really get their ORACLE-BEST cut (their reported tau maximises sensitivity)",
    { o <- subset(op, set=="Set4_Extremes" & n==100 & method=="KS" & kind=="oracle_best")
      r <- subset(sm, set=="Set4_Extremes" & n==100 & method=="KS" &
                      abs(tau_clin - o$tau_clin[1]) < 1e-9 & violation <= 0.05)
      nrow(r) == 0 || abs(max(r$sensitivity) - o$sensitivity[1]) < 1e-9 })
chk("W1_derived uses tau = tau_clin exactly (no oracle at all)",
    { d <- subset(op, method == "W1_derived")
      max(abs(d$tau - d$tau_clin)) < 1e-6 },
    "its threshold comes from the clinical requirement, nothing else")

# =============================================================================
# (C) RESULTS -- including where W1 loses
# =============================================================================
cat("\n--- (C) results ---\n")
o100 <- subset(op, n == 100 & kind == "oracle_best")
sens <- function(s, m) mean(o100$sensitivity[o100$set == s & o100$method == m])

chk("*** CLAIM Set4: W1 >> KS even though KS is GIVEN its best possible threshold ***",
    sens("Set4_Extremes","W1") > 10 * sens("Set4_Extremes","KS"),
    sprintf("W1 %.3f vs KS %.3f  (%.0fx)", sens("Set4_Extremes","W1"),
            sens("Set4_Extremes","KS"), sens("Set4_Extremes","W1")/sens("Set4_Extremes","KS")))

# The mechanism, made visible: KS cannot exploit a RELAXED requirement, because the
# countries it must separate are indistinguishable to it at ANY cut.
s4 <- subset(o100, set == "Set4_Extremes")
ks_rng <- range(s4$sensitivity[s4$method == "KS"])
w1_rng <- range(s4$sensitivity[s4$method == "W1"])
chk("*** CLAIM Set4: KS is FLAT in tau -- relaxing the clinical requirement buys it nothing ***",
    diff(ks_rng) < 0.05 && diff(w1_rng) > 0.3,
    sprintf("KS sensitivity spans [%.3f, %.3f] (range %.3f); W1 spans [%.3f, %.3f] (range %.3f)",
            ks_rng[1], ks_rng[2], diff(ks_rng), w1_rng[1], w1_rng[2], diff(w1_rng)))

chk("CLAIM Set3: W1 leads on the moment-matched world",
    sens("Set3_Mixture","W1") >= max(vapply(c("KS","RV1","RV2","RV3","SMD"),
                                            function(m) sens("Set3_Mixture", m), numeric(1))))
chk("CLAIM: RV1 (Ch.4 as written) is near-useless under a clinical threshold in Sets 2-4",
    all(vapply(c("Set2_LogNormal","Set3_Mixture","Set4_Extremes"),
               function(s) sens(s, "RV1") < 0.05, logical(1))),
    sprintf("RV1: %.3f / %.3f / %.3f", sens("Set2_LogNormal","RV1"),
            sens("Set3_Mixture","RV1"), sens("Set4_Extremes","RV1")))

# HONEST: the cell where W1 loses, asserted so it cannot be quietly dropped.
chk("CLAIM Set1 (HONEST): RV2 -- OUR extension, not Ch.4 -- beats W1 on Gaussian data",
    sens("Set1_Gaussian","RV2") >= sens("Set1_Gaussian","W1") - 0.02,
    sprintf("RV2 %.3f vs W1 %.3f", sens("Set1_Gaussian","RV2"), sens("Set1_Gaussian","W1")))

# The open item that motivates the bootstrap: a POINT-ESTIMATE threshold cannot control
# violation when the requirement is tight relative to the estimator's noise -- but it CAN
# when the requirement is loose. Both halves must hold, or the story is wrong.
d100 <- subset(op, n == 100 & method == "W1_derived")
chk("CLAIM: the derived (oracle-free) threshold DOES control violation for loose requirements",
    any(d100$feasible), sprintf("%d of %d (set,tau) cells feasible at violation <= 5%%",
                                sum(d100$feasible), nrow(d100)))
chk("CLAIM: ...and does NOT for tight ones -- which is why the paper needs bootstrap limits",
    any(!d100$feasible),
    sprintf("worst violation with a point estimate: %.3f", max(d100$violation)))
best <- d100[d100$feasible, ][which.max(d100$sensitivity[d100$feasible]), ]
chk("CLAIM: at its best feasible requirement the derived threshold is genuinely useful",
    nrow(best) == 1 && best$sensitivity > 0.5,
    sprintf("%s tau=%.2f: violation %.3f, sensitivity %.3f -- no oracle used",
            best$set, best$tau_clin, best$violation, best$sensitivity))

cat(sprintf("\n===== PART 1B VALIDATION %s =====\n", if (ok) "ALL PASS" else "HAS FAILURES"))
if (!ok) quit(status = 1L)
