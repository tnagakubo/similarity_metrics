# =============================================================================
# L_UB SENSITIVITY OF THE GUSTO-I JOINT-ELIGIBILITY CONCLUSION -- section 4.4
#
# Written 2026-08-30. The figures for the section 4.4 sensitivity content
# (per-region slack, R7 near-miss, L_UB scaling counts) existed only in
# PAPER_OUTLINE_BILINGUAL.md and were produced by no script in this repo. This
# script establishes them from results/gusto_r8_w1_per_pair.csv -- the Table 3
# source, bit-identical to application_all_methods.R since the 2026-08-15 W1
# unification. Pure arithmetic on stored W1 values: no resampling, no seed.
#
# Decision rule (Methods 2.5): a partner is eligible on an EM when
#   W1-hat < tau = Delta_clin / L_UB   (equivalently L* = Delta_clin/W1 > L_UB).
# Jointly eligible = eligible on BOTH EMs (AND rule).
#
# Scaling design: L_age,UB and L_SBP,UB are independent clinical inputs from
# different evidence bases, so the manuscript varies EACH ALONE with the other
# held fixed. The common-factor scaling is computed FOR THE RECORD ONLY -- do
# not quote it in the manuscript: nothing makes two independently sourced
# inputs err in the same direction by the same amount.
#
# Output: results/gusto_lub_slack.csv, results/gusto_lub_scaling.csv,
#         results/gusto_lub_sensitivity.log
# =============================================================================

DELTA_CLIN <- 0.01
L_UB <- c(age = 1e-2, sysbp = 2e-3)          # /yr, /mmHg (section 4.4)
TAU  <- DELTA_CLIN / L_UB                     # 1.0 yr, 5.0 mmHg
FACTORS <- c(0.8, 0.9, 1.0, 1.05, 1.1, 1.25, 1.5, 2.0)

log_lines <- character(0)
say <- function(fmt, ...) {
  s <- sprintf(fmt, ...)
  cat(s, "\n", sep = "")
  log_lines <<- c(log_lines, s)
}

pp <- read.csv("results/gusto_r8_w1_per_pair.csv")
pp$region <- paste0("R", pp$partner)
stopifnot(nrow(pp) == 15)

eligible <- function(w1, tau) w1 < tau        # strict, as in section 4.4
joint_set <- function(tau_age, tau_sbp) {
  sort(pp$region[eligible(pp$W1_age, tau_age) & eligible(pp$W1_sysbp, tau_sbp)])
}

say("== L_UB sensitivity of the GUSTO-I joint eligibility (anchor = R8) ==")
say("tau_clin: age %.1f yr, SBP %.1f mmHg (Delta_clin = %.2f)", TAU["age"], TAU["sysbp"], DELTA_CLIN)

# ---- baseline ---------------------------------------------------------------
age_set <- sort(pp$region[eligible(pp$W1_age, TAU["age"])])
sbp_set <- sort(pp$region[eligible(pp$W1_sysbp, TAU["sysbp"])])
joint0  <- joint_set(TAU["age"], TAU["sysbp"])
say("\n[baseline] age-eligible %d: %s", length(age_set), paste(age_set, collapse = " "))
say("[baseline] SBP-eligible %d: %s", length(sbp_set), paste(sbp_set, collapse = " "))
say("[baseline] joint %d: %s", length(joint0), paste(joint0, collapse = " "))

# ---- per-region slack below tau, all 15 partners ----------------------------
slack <- data.frame(
  region          = pp$region,
  n               = pp$n,
  W1_age          = pp$W1_age,
  W1_sysbp        = pp$W1_sysbp,
  slack_age_pct   = 100 * (TAU["age"]   / pp$W1_age   - 1),
  slack_sysbp_pct = 100 * (TAU["sysbp"] / pp$W1_sysbp - 1),
  joint_eligible  = pp$region %in% joint0
)
slack <- slack[order(as.integer(sub("R", "", slack$region))), ]
say("\n[slack] tau/W1 - 1 (%%), positive = inside the threshold; joint-eligible six:")
for (r in joint0[order(as.integer(sub("R", "", joint0)))]) {
  i <- match(r, slack$region)
  say("   %-4s age %+7.1f%%   SBP %+7.1f%%", r, slack$slack_age_pct[i], slack$slack_sysbp_pct[i])
}

# ---- near-miss on the exclusion side: R7 ------------------------------------
i7 <- match("R7", slack$region)
r7_over_pct <- unname(100 * (slack$W1_sysbp[i7] / TAU["sysbp"] - 1))
r7_lstar    <- DELTA_CLIN / slack$W1_sysbp[i7]
say("\n[near-miss] R7: age W1 = %.3f (slack %+.1f%%); SBP W1 = %.4f vs tau %.3f -> over by %.2f%%",
    slack$W1_age[i7], slack$slack_age_pct[i7], slack$W1_sysbp[i7], TAU["sysbp"], r7_over_pct)
say("[near-miss] R7 L*_SBP = %.6f vs L_SBP,UB = %.6f (fails the strict inequality)",
    r7_lstar, L_UB["sysbp"])

# ---- L_UB scaling -----------------------------------------------------------
# Scaling L_UB by c multiplies tau by 1/c: a LARGER bound is a TIGHTER screen.
scaling <- do.call(rbind, lapply(c("age_only", "sbp_only", "common"), function(mode) {
  do.call(rbind, lapply(FACTORS, function(f) {
    ta <- if (mode %in% c("age_only", "common")) TAU["age"]   / f else TAU["age"]
    ts <- if (mode %in% c("sbp_only", "common")) TAU["sysbp"] / f else TAU["sysbp"]
    js <- joint_set(ta, ts)
    data.frame(mode = mode, factor = f, tau_age = ta, tau_sysbp = ts,
               n_joint = length(js), members = paste(js, collapse = " "))
  }))
}))
for (mode in c("age_only", "sbp_only", "common")) {
  lab <- c(age_only = "L_age,UB alone (SBP fixed)",
           sbp_only = "L_SBP,UB alone (age fixed)",
           common   = "common factor (RECORD ONLY -- not for the manuscript)")[mode]
  say("\n[scaling: %s]", lab)
  for (i in which(scaling$mode == mode)) {
    say("   x%-4.2f -> joint %d: %s", scaling$factor[i], scaling$n_joint[i], scaling$members[i])
  }
}

# ---- verification against the outline-recorded values -----------------------
# Predictions fixed before running (PAPER_OUTLINE_BILINGUAL.md section 4.4).
fails <- 0
check <- function(label, got, want) {
  ok <- identical(got, want)
  if (!ok) fails <<- fails + 1
  say("[verify] %-52s %s%s", label, if (ok) "PASS" else "FAIL",
      if (ok) "" else sprintf("  (got %s, want %s)", paste(got, collapse = ","), paste(want, collapse = ",")))
}
check("baseline joint set", joint0, sort(c("R1", "R4", "R5", "R6", "R14", "R15")))
check("baseline counts age/SBP", c(length(age_set), length(sbp_set)), c(9L, 11L))
exp_slack <- rbind(R1 = c(54.7, 38.5), R4 = c(80.0, 92.3), R5 = c(156.5, 48.3),
                   R6 = c(9.6, 48.4), R14 = c(42.4, 14.6), R15 = c(63.8, 5.8))
for (r in rownames(exp_slack)) {
  i <- match(r, slack$region)
  check(sprintf("slack %s (age, SBP)", r),
        round(c(slack$slack_age_pct[i], slack$slack_sysbp_pct[i]), 1), unname(exp_slack[r, ]))
}
check("R7 L*_SBP", round(r7_lstar, 6), 0.001972)
check("R7 SBP over-by (%)", round(r7_over_pct, 1), 1.4)
grab <- function(mode, f) scaling$n_joint[scaling$mode == mode & scaling$factor == f]
for (v in list(c(0.8, 7), c(1.0, 6), c(1.1, 5), c(1.5, 4), c(2.0, 1)))
  check(sprintf("age_only x%.2f joint count", v[1]), grab("age_only", v[1]), as.integer(v[2]))
for (v in list(c(0.8, 7), c(1.0, 6), c(1.1, 5), c(1.25, 4), c(1.5, 1), c(2.0, 0)))
  check(sprintf("sbp_only x%.2f joint count", v[1]), grab("sbp_only", v[1]), as.integer(v[2]))
for (v in list(c(0.8, 8), c(0.9, 7), c(1.0, 6), c(1.05, 6), c(1.1, 4), c(1.5, 1), c(2.0, 0)))
  check(sprintf("common x%.2f joint count (record only)", v[1]), grab("common", v[1]), as.integer(v[2]))
check("sbp_only x1.5 member is R4", scaling$members[scaling$mode == "sbp_only" & scaling$factor == 1.5], "R4")
check("sbp_only x0.8 admits R7",
      grepl("\\bR7\\b", scaling$members[scaling$mode == "sbp_only" & scaling$factor == 0.8]), TRUE)

say("\n[verify] overall: %s (%d failure%s)", if (fails == 0) "ALL PASS" else "FAILURES PRESENT",
    fails, if (fails == 1) "" else "s")

# ---- save -------------------------------------------------------------------
write.csv(slack,   "results/gusto_lub_slack.csv",   row.names = FALSE)
write.csv(scaling, "results/gusto_lub_scaling.csv", row.names = FALSE)
writeLines(log_lines, "results/gusto_lub_sensitivity.log")
say("[save] gusto_lub_slack.csv, gusto_lub_scaling.csv, gusto_lub_sensitivity.log")
if (fails > 0) stop("verification failed -- do not quote these figures")
