# =============================================================================
# OPERABILITY CHECK ON GUSTO-I -- the null floor of W1-hat, per candidate partner
#
# Written 2026-08-21. The figures previously quoted for section 4.2 existed only
# in PAPER_OUTLINE_BILINGUAL.md and were produced by no script in this repo, so
# they were not reproducible. This script establishes them; nothing here is a
# "correction" of an earlier computation, because there was no earlier one to
# reproduce.
#
# Method (Methods section 2.6):
#   Because W1 >= 0, W1-hat returns a positive value even when F1 = F2. The null
#   floor is the sampling distribution of W1-hat under F1 = F2 at the two ACTUAL
#   regional sample sizes. A threshold rule can discriminate only if
#   tau_clin > q_{1-alpha}(n1, n2, F).
#
#   Null draw: TWO INDEPENDENT resamples WITH REPLACEMENT from the ANCHOR's
#   empirical distribution, at sizes n_anchor and n_partner respectively. The
#   floor is therefore computed PER PARTNER, since it depends on that partner's
#   n. Drawing from the anchor is the null appropriate to an anchor-borrowing
#   estimand ("if this partner were distributed like R8"); it is not symmetric,
#   so the partner-drawn floor is also computed as a sensitivity check and every
#   verdict is compared across the two.
#
#   Verdict: a partner is NOT RESOLVED from identical when its observed W1-hat
#   lies at or below the (1-alpha) quantile of the null distribution, with
#   alpha = 0.05 (one-sided).
#
# W1 estimator: the exact CDF-area form, identical to compute_w1() in
# fig3_w1_axis.R / gusto_all_pairwise.R and to application_all_methods.R since
# the 2026-08-15 unification. Do NOT substitute the simulation's equal-n
# sorted-difference form: region sizes differ here.
#
# Output: results/gusto_operability.csv, results/gusto_operability.log
# =============================================================================

suppressPackageStartupMessages({ library(predtools) })

SEED   <- 20260821L      # recorded so the manuscript figures regenerate exactly
B      <- 2000L          # null replications per partner (matches the paper's bootstrap B)
ALPHA  <- 0.05
ANCHOR <- 8L
EMS    <- c(age = "age", sysbp = "sysbp")
TAU    <- c(age = 1.0, sysbp = 5.0)   # tau_clin = Delta_clin / L_UB, Methods 2.5

compute_w1 <- function(x, y) {
  a <- sort(c(x, y)); n <- length(a); if (n < 2) return(0)
  Fx <- ecdf(x); Fy <- ecdf(y); m <- (a[-n] + a[-1]) / 2
  sum(abs(Fx(m) - Fy(m)) * diff(a))
}

null_floor <- function(src, n1, n2, B, alpha) {
  v <- numeric(B)
  for (b in seq_len(B)) {
    v[b] <- compute_w1(sample(src, n1, replace = TRUE),
                       sample(src, n2, replace = TRUE))
  }
  c(mean = mean(v), q = unname(quantile(v, 1 - alpha, names = FALSE)))
}

main <- function() {
  rd <- if (dir.exists("results")) "results" else "../results"
  lg <- file(file.path(rd, "gusto_operability.log"), open = "wt")
  on.exit(close(lg), add = TRUE)
  say <- function(...) { m <- sprintf(...); cat(m, "\n"); writeLines(m, lg) }

  set.seed(SEED)
  data(gusto, package = "predtools")
  g <- gusto[!is.na(gusto$age) & !is.na(gusto$sysbp), ]
  regs <- sort(unique(g$regl)); rn <- paste0("R", regs)
  anch <- paste0("R", ANCHOR); partners <- setdiff(rn, anch)

  say("== Operability check, GUSTO-I, anchor = %s ==", anch)
  say("seed %d | B = %d null replications per partner | alpha = %.2f (one-sided)",
      SEED, B, ALPHA)
  say("verdict: NOT RESOLVED  <=>  observed W1hat <= q_{1-alpha} of the null floor")

  rows <- list()
  for (em in names(EMS)) {
    v <- EMS[[em]]
    S <- lapply(regs, function(r) g[[v]][g$regl == r]); names(S) <- rn
    tau <- TAU[[em]]; src_a <- S[[anch]]; n_a <- length(src_a)

    say("\n===== EM = %s  (tau_clin = %.1f, n_%s = %d) =====", em, tau, anch, n_a)
    say("%-5s %6s %8s %9s %9s %9s %-14s %-14s", "reg", "n_p", "W1obs",
        "nullMean", "null q95", "tau", "verdict(anch)", "verdict(part)")

    for (p in partners) {
      n_p <- length(S[[p]])
      w1  <- compute_w1(src_a, S[[p]])
      fa  <- null_floor(src_a,  n_a, n_p, B, ALPHA)
      fp  <- null_floor(S[[p]], n_a, n_p, B, ALPHA)
      res_a <- w1 >  fa[["q"]]
      res_p <- w1 >  fp[["q"]]
      say("%-5s %6d %8.4f %9.4f %9.4f %9.1f %-14s %-14s", p, n_p, w1,
          fa[["mean"]], fa[["q"]], tau,
          if (res_a) "resolved" else "NOT resolved",
          if (res_p) "resolved" else "NOT resolved")
      rows[[length(rows) + 1L]] <- data.frame(
        em = em, region = p, n_anchor = n_a, n_partner = n_p,
        w1_obs = w1, tau_clin = tau,
        null_mean_anchor = fa[["mean"]], null_q95_anchor = fa[["q"]],
        null_mean_partner = fp[["mean"]], null_q95_partner = fp[["q"]],
        resolved_anchor = res_a, resolved_partner = res_p,
        eligible = w1 <= tau,
        stringsAsFactors = FALSE)
    }
  }

  d <- do.call(rbind, rows)
  write.csv(d, file.path(rd, "gusto_operability.csv"), row.names = FALSE)

  say("\n\n===== SUMMARY =====")
  for (em in names(EMS)) {
    s <- d[d$em == em, ]
    nr <- s$region[!s$resolved_anchor]
    say("%-6s null mean range %.3f-%.3f | null q95 range %.3f-%.3f | tau %.1f",
        em, min(s$null_mean_anchor), max(s$null_mean_anchor),
        min(s$null_q95_anchor), max(s$null_q95_anchor), s$tau_clin[1])
    say("       NOT resolved: %d / %d  -> %s", length(nr), nrow(s),
        if (length(nr)) paste(sort(nr), collapse = " ") else "(none)")
    say("       of those, how many are on the ELIGIBLE side (W1 <= tau): %d / %d",
        sum(!s$resolved_anchor & s$eligible), length(nr))
  }

  say("\n[sensitivity] verdicts that FLIP when the null is drawn from the partner")
  fl <- d[d$resolved_anchor != d$resolved_partner, ]
  if (nrow(fl) == 0) {
    say("   none - every verdict is stable to the choice of null source")
  } else {
    for (i in seq_len(nrow(fl))) with(fl[i, ], say(
      "   %-6s %-4s  anchor-drawn: %s | partner-drawn: %s  (W1 %.4f, q95 %.4f / %.4f)",
      em, region, ifelse(resolved_anchor, "resolved", "NOT"),
      ifelse(resolved_partner, "resolved", "NOT"),
      w1_obs, null_q95_anchor, null_q95_partner))
  }
  say("\n[save] results/gusto_operability.csv")
  invisible(d)
}

if (sys.nframe() == 0L) main()
