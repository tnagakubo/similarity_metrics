# =============================================================================
# NUMBERS GATE for Study 1 (Section 3.2), the GUSTO-I application (Section 4)
# and the Discussion figures edited in the 2026-09-27 paragraph review.
# Study 2 (Section 3.1) has its own gate: R/verify_study2_figures.R.
#
# Every value below is the number printed in per_em_W1_wiley.tex; each is
# re-extracted from its source and compared at the printed precision.
# Sources: results/w1_raw_summary.csv, results/study1_miss_side.csv,
#          results/gusto_operability.csv, results/gusto_r8_w1_per_pair.csv,
#          results/gusto_lstar_intervals.csv, predtools::gusto.
# Output: results/verify_study1_app.log. Stops on any FAIL.
# Written 2026-09-27.
# =============================================================================
log_lines <- character(0)
say <- function(fmt, ...) { s <- sprintf(fmt, ...); cat(s, "\n", sep = ""); log_lines <<- c(log_lines, s) }
fails <- 0
check <- function(label, got, want, digits = NA) {
  if (!is.na(digits)) got <- round(got, digits)
  ok <- isTRUE(all(got == want)) && length(got) == length(want)
  if (!ok) fails <<- fails + 1
  say("[verify] %-62s %s%s", label, if (ok) "PASS" else "FAIL",
      if (ok) "" else sprintf("  (got %s, want %s)", paste(got, collapse = ","), paste(want, collapse = ",")))
}
say("== Study 1 / Application numbers gate (2026-09-27) ==")

# ---- Study 1 ----------------------------------------------------------------
w <- read.csv("results/w1_raw_summary.csv"); w <- unique(w)
g <- function(sc, n, col) { v <- w[[col]][w$scenario == sc & w$n == n]; stopifnot(length(v) == 1); v }
cov <- function(sc, n) g(sc, n, "coverage_pct")   # stored as a proportion
say("\n-- Study 1 prose --")
check("S1 bias 2.46 (n=50), 1.26 (n=200)", c(g("S1",50,"bias"), g("S1",200,"bias")), c(2.46, 1.26), 2)
check("S1 bias 1.76 at n=100 (summary list)", g("S1",100,"bias"), 1.76, 2)
b200 <- sapply(c("S3","S4","S5","S6","S7"), function(s) g(s,200,"bias"))
check("max bias S3-S7 at n=200 = 0.193 (S7)", c(round(max(b200),3), names(which.max(b200))), c("0.193","S7"))
check("S4 bias 0.034 (n=50), 0.005 (n=200)", c(g("S4",50,"bias"), g("S4",200,"bias")), c(0.034, 0.005), 3)
check("S3 bias 0.051, S4 -0.013 at n=100", c(g("S3",100,"bias"), g("S4",100,"bias")), c(0.051, -0.013), 3)
rng <- function(sc, ns) round(range(sapply(ns, function(n) cov(sc, n))), 3)
check("coverage S3 0.948-0.951", rng("S3", c(50,100,200)), c(0.948, 0.951))
check("coverage S4 0.945-0.948 (n>=100)", rng("S4", c(100,200)), c(0.945, 0.948))
# S4 n=50 is 0.9425 exactly (a rounding tie); the table prints 0.942 as in results/study1_latex_rows.tex.
check("coverage S4 0.942-0.948 (all n, table note; tie at 0.9425)", all(abs(range(sapply(c(50,100,200), function(n) cov("S4", n))) - c(0.942, 0.948)) <= 0.0005 + 1e-9), TRUE)
check("coverage S6 0.942-0.947", rng("S6", c(50,100,200)), c(0.942, 0.947))
check("coverage S7 0.935-0.943 (n>=100)", rng("S7", c(100,200)), c(0.935, 0.943))
check("coverage S5 0.862 (50), 0.946 (200)", c(cov("S5",50), cov("S5",200)), c(0.862, 0.946), 3)
check("coverage S2 0.703 (50), 0.947 (200)", c(cov("S2",50), cov("S2",200)), c(0.703, 0.947), 3)
check("coverage S3-S7 at n>=100 within 0.92-0.95",
      round(range(sapply(c("S3","S4","S5","S6","S7"), function(s) c(cov(s,100), cov(s,200)))), 2), c(0.92, 0.95))
check("RMSE S3 1.83 (50) -> 0.98 (200)", c(g("S3",50,"rmse"), g("S3",200,"rmse")), c(1.83, 0.98), 2)
r200 <- sapply(c("S1","S2","S3","S4","S5","S6","S7"), function(s) g(s,200,"rmse"))
check("RMSE at n=200 from 0.77 (S5) to 1.34 (S1)",
      c(round(min(r200),2), names(which.min(r200)), round(max(r200),2), names(which.max(r200))),
      c("0.77","S5","1.34","S1"))
wd <- sapply(c("S2","S3","S4","S5","S6","S7"), function(s) g(s,100,"mean_ci_width"))
check("CI width at n=100, non-null, roughly 3.6-7.0", round(range(wd), 1), c(3.6, 7.0))
check("S3 CI width 4.96 at n=100", g("S3",100,"mean_ci_width"), 4.96, 2)
check("Delta_max width 0.01*4.96 = 0.050", round(0.01 * round(g("S3",100,"mean_ci_width"), 2), 3), 0.050)
check("S1 CI width 4.19 (50), 2.07 (200)", c(g("S1",50,"mean_ci_width"), g("S1",200,"mean_ci_width")), c(4.19, 2.07), 2)
m <- read.csv("results/study1_miss_side.csv")
check("S1 q95 4.21, 2.97, 2.11", m$q95_est[m$cell %in% c("S1-50","S1-100","S1-200")], c(4.21, 2.97, 2.11), 2)
ms <- m[grepl("^S[257]-", m$cell), ]
check("miss above upper limit <= 1.1% in S2, S5, S7", round(max(ms$miss_above) * 100, 1) <= 1.1, TRUE)
check("miss above upper limit never in S2", all(m$miss_above[grepl("^S2-", m$cell)] == 0), TRUE)
check("shortfall comes from below in S2, S5, S7 (below > 2.5% where coverage < 0.94)",
      all(ms$miss_below[ms$miss_below + ms$miss_above > 0.06] > 0.025), TRUE)

# ---- Application: data ------------------------------------------------------
say("\n-- Application --")
data(gusto, package = "predtools", envir = environment())
check("GUSTO-I N = 40,830; 16 regions", c(nrow(gusto), length(unique(gusto$regl))), c(40830, 16))
r8 <- gusto[gusto$regl == 8, ]
sk <- function(x) { x <- x[!is.na(x)]; mean(((x - mean(x)) / sd(x))^3) }
check("R8 n = 2,916", nrow(r8), 2916)
check("R8 age mean, SD, skew = 60.2, 12.1, -0.17",
      c(round(mean(r8$age),1), round(sd(r8$age),1), round(sk(r8$age),2)), c(60.2, 12.1, -0.17))
check("R8 SBP mean, SD, skew = 132.4, 22.9, 0.20",
      c(round(mean(r8$sysbp),1), round(sd(r8$sysbp),1), round(sk(r8$sysbp),2)), c(132.4, 22.9, 0.20))
check("SBP recorded in whole mmHg", all(r8$sysbp == round(r8$sysbp)), TRUE)

# ---- null floor --------------------------------------------------------------
o <- read.csv("results/gusto_operability.csv")
oa <- o[o$em == "age", ]; os <- o[o$em == "sysbp", ]
check("null 95th pct age 0.618-0.900", round(range(oa$null_q95_anchor), 3), c(0.618, 0.900))
check("null 95th pct SBP 1.176-1.691", round(range(os$null_q95_anchor), 3), c(1.176, 1.691))
ua <- oa$region[!oa$resolved_anchor]; us <- os$region[!os$resolved_anchor]
check("unresolved age = R1,R4,R5,R7,R9,R15", ua, c("R1","R4","R5","R7","R9","R15"))
check("unresolved SBP = R2", us, "R2")
check("unresolved <=> w1_obs <= null_q95", all((o$w1_obs <= o$null_q95_anchor) == !o$resolved_anchor), TRUE)
check("partner-source null gives identical readings", all(o$resolved_anchor == o$resolved_partner), TRUE)

# ---- distances ---------------------------------------------------------------
p <- read.csv("results/gusto_r8_w1_per_pair.csv"); p$R <- paste0("R", p$partner)
check("partner n range 1,231-4,352", range(p$n), c(1231, 4352))
check("15 partners", nrow(p), 15)
tab_age <- c(R1=.65,R2=2.15,R3=2.61,R4=.56,R5=.39,R6=.91,R7=.40,R9=.59,R10=1.38,R11=1.27,R12=.86,R13=1.15,R14=.70,R15=.61,R16=1.74)
tab_sbp <- c(R1=3.61,R2=.95,R3=3.35,R4=2.60,R5=3.37,R6=3.37,R7=5.07,R9=6.80,R10=4.00,R11=6.44,R12=6.40,R13=2.40,R14=4.36,R15=4.72,R16=4.28)
check("Table W1 age point estimates", round(p$W1_age[match(names(tab_age), p$R)], 2), unname(tab_age))
check("Table W1 SBP point estimates", round(p$W1_sysbp[match(names(tab_sbp), p$R)], 2), unname(tab_sbp))
ra <- rank(p$W1_age); rs <- rank(p$W1_sysbp); names(ra) <- names(rs) <- p$R
check("age min R5 0.39, max R3 2.61", c(p$R[which.min(p$W1_age)], p$R[which.max(p$W1_age)]), c("R5","R3"))
check("SBP min R2 0.95, max R9 6.80", c(p$R[which.min(p$W1_sysbp)], p$R[which.max(p$W1_sysbp)]), c("R2","R9"))
check("most partners below 1.5 years (> half)", sum(p$W1_age < 1.5) > 7.5, TRUE)
check("R16 13th-smallest age; CI [1.16, 2.47]", c(ra[["R16"]], round(p$ci_lower_age[p$R=="R16"],2), round(p$ci_upper_age[p$R=="R16"],2)), c(13, 1.16, 2.47))
check("R6 9th-smallest age 0.91", ra[["R6"]], 9)
check("R6 SBP CI [2.06, 4.77]", round(c(p$ci_lower_sysbp[p$R=="R6"], p$ci_upper_sysbp[p$R=="R6"]), 2), c(2.06, 4.77))
check("R2 second-largest age, smallest SBP", c(ra[["R2"]], rs[["R2"]]), c(14, 1))
check("R9 4th-smallest age, largest SBP", c(ra[["R9"]], rs[["R9"]]), c(4, 15))

# ---- L* table ----------------------------------------------------------------
l <- read.csv("results/gusto_lstar_intervals.csv")
check("L* = 0.01 / W1 (age) and 0.01 / W1 (SBP)",
      isTRUE(all.equal(l$lstar_age, 0.01 / l$w1_age)) && isTRUE(all.equal(l$lstar_sbp, 0.01 / l$w1_sbp)), TRUE)
check("L* interval = 0.01 / CI of W1 (reversed)",
      isTRUE(all.equal(l$lstar_age_lower, 0.01 / p$ci_upper_age[match(l$partner, p$R)])) &&
      isTRUE(all.equal(l$lstar_sbp_upper, 0.01 / p$ci_lower_sysbp[match(l$partner, p$R)])), TRUE)
check("R1 SBP lower L* = 0.00203 (> L_UB,SBP 0.002)", c(round(l$lstar_sbp_lower[l$partner=="R1"], 5), l$lstar_sbp_lower[l$partner=="R1"] > 0.002), c(0.00203, 1))
tex <- readLines("paper/per_em_W1_wiley.tex", encoding = "UTF-8")
i0 <- grep("label\\{tab:gusto_lstar_joint\\}", tex); i1 <- i0 + grep("^\\\\bottomrule", tex[i0:length(tex)])[1]
rows <- grep("^R[0-9]+ &", tex[i0:i1], value = TRUE)
num <- function(x) as.numeric(regmatches(x, gregexpr("[0-9]+\\.[0-9]+", x))[[1]])
got <- t(sapply(rows, function(r) { cs <- strsplit(r, "&")[[1]]; c(num(cs[2])[1], num(cs[3])[1], num(cs[4]), num(cs[5])) }))
want <- cbind(round(l$w1_age,2), round(l$w1_sbp,2), round(l$lstar_age,4), round(l$lstar_age_lower,4), round(l$lstar_age_upper,4),
              round(l$lstar_sbp,4), round(l$lstar_sbp_lower,4), round(l$lstar_sbp_upper,4))
check("L* table: all 15 rows x 8 numbers match the CSV", all(abs(unname(got) - want) < 1e-9), TRUE)
dag_age <- sub(" .*", "", rows[grepl("^R[0-9]+ & [0-9.]+\\$\\^\\\\dagger", rows)])
dag_sbp <- sub(" .*", "", rows[grepl("^R[0-9]+ & [0-9.]+(\\$\\^\\\\dagger\\$)? & [0-9.]+\\$\\^\\\\dagger", rows)])
check("daggers (age) = unresolved age distances", sort(dag_age), sort(ua))
check("daggers (SBP) = unresolved SBP distances", dag_sbp, us)

# ---- Discussion (2026-09-27: the real-data survey supplement was dropped; ----
# ---- the two Discussion statements are carried by the GUSTO-I application) --
say("\n-- Discussion --")
check("age vs SBP distance ordering across the 15 partners: Spearman -0.30",
      cor(p$W1_age, p$W1_sysbp, method = "spearman"), -0.30, 2)
smd <- function(x, y) abs(mean(x) - mean(y)) /
  sqrt(((length(x) - 1) * var(x) + (length(y) - 1) * var(y)) / (length(x) + length(y) - 2))
pr  <- setdiff(sort(unique(gusto$regl)), 8)
rho <- sapply(c("age", "sysbp"), function(v) {
  sm <- sapply(pr, function(r) smd(r8[[v]], gusto[[v]][gusto$regl == r]))
  w  <- if (v == "age") p$W1_age[match(pr, p$partner)] else p$W1_sysbp[match(pr, p$partner)]
  cor(w, sm, method = "spearman") })
check("W1 vs SMD ordering of the 15 partners: Spearman 0.90 (age), 0.95 (SBP)", unname(rho), c(0.90, 0.95), 2)
sdr <- sapply(c("age", "sysbp"), function(v) {
  x <- tapply(gusto[[v]], gusto$regl, sd); r <- x[names(x) != "8"] / x[["8"]]; max(pmax(r, 1 / r)) })
check("partner SDs within a factor of 1.11 of the anchor's", round(max(sdr), 2), 1.11)

say("\n[verify] overall: %s (%d failure%s)", if (fails == 0) "ALL PASS" else "FAILURES PRESENT", fails, if (fails == 1) "" else "s")
writeLines(log_lines, "results/verify_study1_app.log")
if (fails > 0) stop("verification failed")
