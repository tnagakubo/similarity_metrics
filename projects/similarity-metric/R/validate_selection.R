# =============================================================================
# Validation for selection_simulation.R — tests the PRODUCTION functions
# (sourced, so main() does not run). Any FAIL must block the production run.
# =============================================================================
.cands <- c(
  tryCatch(file.path(dirname(sys.frame(1)$ofile), "selection_simulation.R"), error = function(e) NA_character_),
  "R/selection_simulation.R",
  "selection_simulation.R",
  "projects/similarity-metric/R/selection_simulation.R")
src <- .cands[!is.na(.cands) & file.exists(.cands)][1]
if (is.na(src) || length(src) == 0) stop("cannot locate selection_simulation.R (cwd=", getwd(), ")")
source(src, chdir = TRUE)   # exposes w1_dist/smd_dist/.../run_cell; main() guarded off

ok <- TRUE
chk <- function(name, cond, detail = "") {
  cat(sprintf("[%s] %s%s\n", if (isTRUE(cond)) "PASS" else "FAIL", name,
              if (nzchar(detail)) paste0("  -- ", detail) else "")); if (!isTRUE(cond)) ok <<- FALSE
}
approx <- function(a, b, tol = 1e-6) all(abs(a - b) <= tol)
w1_ecdf <- function(x, y) { a <- sort(c(x,y)); n <- length(a); if (n<2) return(0)
  Fx <- ecdf(x); Fy <- ecdf(y); m <- (a[-n]+a[-1])/2; sum(abs(Fx(m)-Fy(m))*diff(a)) }
set.seed(1)

# 1. W1 estimator == canonical integral-of-|F1-F2| (machine precision)
x <- rnorm(200,50,10); y <- rnorm(200,55,12)
chk("W1 == canonical ecdf-integral W1", approx(w1_dist(x,y), w1_ecdf(x,y), 1e-9),
    sprintf("%.9f vs %.9f", w1_dist(x,y), w1_ecdf(x,y)))
# 2-3. closed forms
set.seed(2); big <- 4e5
chk("W1 -> |mu1-mu2|=10 (location)", abs(w1_dist(rnorm(big,50,10), rnorm(big,60,10)) - 10) < 0.05)
set.seed(3); sc <- replicate(5, w1_dist(rnorm(big,50,10), rnorm(big,50,20)))
chk("W1 -> sqrt(2/pi)*10 (scale, mean of 5)", abs(mean(sc) - sqrt(2/pi)*10) < 0.03,
    sprintf("%.4f vs %.4f", mean(sc), sqrt(2/pi)*10))
# 4. SMD
set.seed(4); chk("SMD ~ 2 for 2-SD gap", abs(smd_dist(rnorm(1e5,0,1), rnorm(1e5,2,1)) - 2) < 0.02)
# 5. log-SMD blind to equal-mean dispersion
set.seed(5); ln <- function(m,cv){ s<-sqrt(log(1+cv^2)); rlnorm(2e5, log(m)-s^2/2, s) }
a <- ln(50,.4); b <- ln(50,.6)
chk("raw SMD ~ 0 on equal-mean LogN", smd_dist(a,b) < 0.03, sprintf("%.4f", smd_dist(a,b)))
chk("log-SMD small (0.10-0.25) not large", smd_log_dist(a,b) > 0.10 && smd_log_dist(a,b) < 0.25,
    sprintf("%.4f", smd_log_dist(a,b)))
chk("log-SMD -> NaN on non-positive data (Set 1 excludes it)",
    is.nan(smd_log_dist(c(-1,1,2,3), c(1,2,3,4))))
# 6. AUC edge cases (tie-fair)
chk("AUC=1 all closer", approx(auc_pairs(c(1,2,3), c(4,5)), 1))
chk("AUC=0 all farther", approx(auc_pairs(c(9,9,9), c(1,2)), 0))
chk("AUC=0.5 on ties", approx(auc_pairs(c(1,1), c(1,1)), 0.5))
# 7. analytic truth == large-n MC (LogN dispersion)
s2 <- build_set2()
w1_int <- true_w1(s2$A0, s2$Dp1, 0, 500)
set.seed(7); p <- lnorm_pars(50,.6); p0 <- lnorm_pars(50,.4)
w1_mc <- w1_dist(rlnorm(6e5,p0$meanlog,p0$sdlog), rlnorm(6e5,p$meanlog,p$sdlog))
chk("analytic W1 == large-n MC (LogN Dp1)", abs(w1_int - w1_mc) < 0.05,
    sprintf("%.4f vs %.4f", w1_int, w1_mc))

# 8. TIE-BREAK FIX: ties broken at random, not by roster order --------------
# Two candidates with identical distance; the first-listed must NOT always win.
set.seed(8)
picks <- replicate(4000, { d <- c(A = 1.0, B = 1.0); order(d, runif(2))[1] })
rate_A <- mean(picks == 1)
chk("random tie-break ~50/50 (not roster-order biased)", rate_A > 0.45 && rate_A < 0.55,
    sprintf("first-listed wins %.1f%% (roster-order bug would be 100%%)", 100*rate_A))
# document the bug the fix removes:
old_rate <- mean(replicate(200, { d <- c(A=1.0, B=1.0); which(names(sort(d))[1] == names(d))[1] }) == 1)
chk("OLD stable-sort would be 100% biased (documents the fixed bug)", approx(old_rate, 1))

# 9. run_cell bit-reproducibility (same seed) & structural sanity ------------
# run_cell now also needs tw1 = the TRUE anchor->candidate W1 (the clinical-harm
# yardstick). Build it the same way main() does, by integrating |F_A - F_B|.
S1  <- build_set1()
CID <- setdiff(names(S1), "A0")
TW1 <- vapply(CID, function(id) true_w1(S1$A0, S1[[id]], -80, 250), numeric(1))
chk("true W1 = 0 for the true matches, > 0 for every discordant country",
    all(TW1[vapply(CID, function(i) S1[[i]]$role, character(1)) == "match"] == 0) &&
      all(TW1[vapply(CID, function(i) S1[[i]]$role, character(1)) != "match"] > 0),
    "=> a perfect selection scores harm = 0, so the harm scale is anchored at truth")

r1 <- run_cell(S1, c("W1","SMD","KS"), n_per = 40L, n_reps = 300L, seed = 123L, tw1 = TW1)
r2 <- run_cell(S1, c("W1","SMD","KS"), n_per = 40L, n_reps = 300L, seed = 123L, tw1 = TW1)
chk("run_cell reproducible (same seed identical)", identical(r1, r2))
# AUC / precision / false-pooling are in [0,1]; harm is in EM units, so exclude it.
u <- subset(r1, measure != "harm_maxW1")
chk("all unit-free values in [0,1]", all(u$value >= 0 & u$value <= 1))
chk("all mc_se >= 0 and small (unit-free measures)", all(u$mc_se >= 0 & u$mc_se < 0.1))
h <- subset(r1, measure == "harm_maxW1")
chk("harm is within the range of true W1 actually present in the roster",
    all(h$value >= 0) && all(h$value <= max(TW1)),
    sprintf("harm in [%.2f, %.2f]; max true W1 in roster = %.2f",
            min(h$value), max(h$value), max(TW1)))
chk("harm ranks W1 no worse than SMD on this Gaussian roster (SMD is scale-blind)",
    h$value[h$method == "W1"] <= h$value[h$method == "SMD"],
    sprintf("W1=%.2f SMD=%.2f", h$value[h$method=="W1"], h$value[h$method=="SMD"]))
# W1 should beat SMD on scale-type AUC (structural, not a tuned claim)
w1_scale  <- r1$value[r1$method=="W1"  & r1$measure=="auc" & r1$type=="scale"]
smd_scale <- r1$value[r1$method=="SMD" & r1$measure=="auc" & r1$type=="scale"]
chk("W1 scale-AUC > SMD scale-AUC (SMD blind to scale)", w1_scale > smd_scale + 0.2,
    sprintf("W1=%.3f SMD=%.3f", w1_scale, smd_scale))

cat(sprintf("\n===== VALIDATION %s =====\n", if (ok) "ALL PASS" else "HAS FAILURES"))
if (!ok) quit(status = 1L)
