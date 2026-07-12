# =============================================================================
# CONFIGURATION VALIDATION — does the code implement what the PLAN says?
#
# SELECTION_SIMULATION_PLAN.md is the source of truth. Every number in its
# Tables 2a-2d and Table 5 is transcribed here as an EXPECTATION, and checked
# against what the code actually builds and what the run actually recorded.
# A disagreement means one of them is wrong; the script names which.
#
# This is a different job from validate_figures.R (which asks "do the figures
# plot the CSV, and are the qualitative claims in the data?"). This one asks
# "is the study we ran the study we said we would run?"
#
#   PART A — roster construction: every country's distribution, its true W1/KS,
#            and the moment structure the blind-spot argument depends on.
#   PART B — run settings: sets, n grid, reps, methods, seeds, clustering algo.
#   PART C — Set 4 closed forms vs numerical integration (the mechanism claim).
#
# WHEN THE PLAN CHANGES, CHANGE THE EXPECTATIONS HERE TOO. That is the point:
# the plan cannot drift away from the code silently.
# =============================================================================

.here <- function(f) {
  cands <- c(file.path("R", f), f, file.path("projects/similarity-metric/R", f),
             tryCatch(file.path(dirname(sys.frame(1)$ofile), f), error = function(e) NA_character_))
  p <- cands[!is.na(cands) & file.exists(cands)]
  if (!length(p)) stop("cannot locate ", f, " (cwd=", getwd(), ")")
  p[1]
}
source(.here("selection_simulation.R"),  chdir = TRUE)   # build_set1..4, DISTFUN, true_w1/true_ks
source(.here("clustering_simulation.R"), chdir = TRUE)   # build_clust_set1..4, DMAT, adj_rand

ok <- TRUE
chk <- function(name, cond, detail = "") {
  cat(sprintf("[%s] %s%s\n", if (isTRUE(cond)) "PASS" else "FAIL", name,
              if (nzchar(detail)) paste0("  -- ", detail) else "")); if (!isTRUE(cond)) ok <<- FALSE
}
near <- function(a, b, tol) all(abs(a - b) <= tol)

# ---- helpers ---------------------------------------------------------------
# Empirical moments of a roster country, from a large fixed-seed sample.
moms <- function(country, n = 2e6L, seed = 4242L) {
  set.seed(seed)
  v <- country$sampler(n); m <- mean(v); s <- sd(v)
  c(mean = m, sd = s, skew = mean(((v - m) / s)^3))
}
tw1 <- function(r, id, lo, hi) true_w1(r$A0, r[[id]], lo, hi)
tks <- function(r, id, lo, hi) true_ks(r$A0, r[[id]], lo, hi)

# =============================================================================
# PART A — rosters match the plan's Tables 2a-2d
# =============================================================================
cat("\n--- PART A: roster construction vs plan Tables 2a-2d ---\n")

## Table 2a — Set 1, Gaussian (anchor N(50,10^2)); lo/hi per the plan
S1 <- build_set1(); LO1 <- -80; HI1 <- 250
exp1 <- data.frame(
  id      = c("G1","L1","L2","V1","V2","X1","X2"),
  role    = c("match","location","location","scale","scale","combined","combined"),
  mean    = c(50, 55, 58, 50, 50, 56, 54),
  sd      = c(10, 10, 10, 16, 20, 14, 13),
  true_W1 = c(0.000, 5.000, 8.000, 4.787, 7.979, 6.234, 4.254),
  true_KS = c(0.000, 0.197, 0.311, 0.112, 0.161, 0.231, 0.167),
  stringsAsFactors = FALSE)
for (i in seq_len(nrow(exp1))) {
  id <- exp1$id[i]; mm <- moms(S1[[id]])
  chk(sprintf("Set1 %s: role/mean/SD as planned", id),
      S1[[id]]$role == exp1$role[i] && near(mm["mean"], exp1$mean[i], 0.05) &&
        near(mm["sd"], exp1$sd[i], 0.05),
      sprintf("role=%s mean=%.2f sd=%.2f", S1[[id]]$role, mm["mean"], mm["sd"]))
  chk(sprintf("Set1 %s: true W1/KS as planned", id),
      near(tw1(S1, id, LO1, HI1), exp1$true_W1[i], 0.002) &&
        near(tks(S1, id, LO1, HI1), exp1$true_KS[i], 0.002),
      sprintf("W1=%.3f KS=%.3f", tw1(S1, id, LO1, HI1), tks(S1, id, LO1, HI1)))
}
# The load-bearing structural fact for Set 1: the scale countries share the anchor's mean.
chk("Set1 STRUCTURE: scale countries have EXACTLY the anchor's mean (SMD/RV1 blind spot)",
    near(moms(S1$V1)["mean"], 50, 0.05) && near(moms(S1$V2)["mean"], 50, 0.05))

## Table 2b — Set 2, log-normal (anchor mean 50, CV 0.40).
## The plan's SD/skew are ANALYTIC, from (mean m, CV c): SD = m*c, skew = (c^2+3)*c.
## They must be: the log-normal's heavy tail makes the SAMPLE skewness unstable even at
## 1e6 draws (Cx1: truth 2.225, a 1e6-draw estimate lands anywhere near 2.18-2.25). An
## earlier version of the plan carried those sample estimates and this check caught it.
## So: verify the analytic values against the construction, then confirm the sampler
## reproduces them to within sampling error.
S2 <- build_set2(); LO2 <- 0; HI2 <- 500
exp2 <- data.frame(
  id      = c("Lm1","Lm2","Dp1","Dp2","Cx1","Cx2"),
  m       = c(55,   58,   50,   50,   55,   53),      # construction: mean
  cv      = c(0.40, 0.40, 0.60, 0.85, 0.65, 0.55),    # construction: CV
  sd      = c(22.00, 23.20, 30.00, 42.50, 35.75, 29.15),  # plan Table 2b
  skew    = c(1.264, 1.264, 2.016, 3.164, 2.225, 1.816),  # plan Table 2b
  true_W1 = c(5.000, 8.000, 6.744, 13.950, 9.603, 5.821),
  true_KS = c(0.098, 0.153, 0.132, 0.245, 0.106, 0.070),
  stringsAsFactors = FALSE)
chk("Set2: the plan's SD/skew ARE the analytic log-normal moments (not sample estimates)",
    near(exp2$sd, exp2$m * exp2$cv, 0.005) &&
      near(exp2$skew, (exp2$cv^2 + 3) * exp2$cv, 0.001),
    "SD = m*c, skew = (c^2+3)*c")
for (i in seq_len(nrow(exp2))) {
  id <- exp2$id[i]; mm <- moms(S2[[id]])
  chk(sprintf("Set2 %s: sampler reproduces the planned moments (within sampling error)", id),
      near(mm["mean"], exp2$m[i], 0.15) && near(mm["sd"], exp2$sd[i], 0.20) &&
        near(mm["skew"], exp2$skew[i], 0.10),
      sprintf("mean=%.2f sd=%.2f skew=%.3f (plan %.2f/%.2f/%.3f)", mm["mean"], mm["sd"],
              mm["skew"], exp2$m[i], exp2$sd[i], exp2$skew[i]))
  chk(sprintf("Set2 %s: true W1/KS as planned", id),
      near(tw1(S2, id, LO2, HI2), exp2$true_W1[i], 0.01) &&
        near(tks(S2, id, LO2, HI2), exp2$true_KS[i], 0.002),
      sprintf("W1=%.3f KS=%.3f", tw1(S2, id, LO2, HI2), tks(S2, id, LO2, HI2)))
}
chk("Set2 STRUCTURE: dispersion countries share the anchor's mean but NOT its SD",
    near(moms(S2$Dp1)["mean"], 50, 0.1) && near(moms(S2$Dp2)["mean"], 50, 0.1) &&
      !near(moms(S2$Dp1)["sd"], 20, 1) && !near(moms(S2$Dp2)["sd"], 20, 1),
    "=> RV2 separates them on the SD axis; Set 2 defeats SMD/RV1, not RV2. This is why Set 3 exists.")

## Table 2c — Set 3, mixture. THE claim: every country matches the anchor on mean and SD,
## and the symmetric ones match on skewness too.
S3 <- build_set3(); LO3 <- -60; HI3 <- 160
exp3 <- data.frame(
  id      = c("B1","B2","S1","S2","C1","C2"),
  role    = c("shape_sym","shape_sym","shape_skew","shape_skew","combined","combined"),
  skew    = c(0.000, 0.000, -0.386, -0.614, -0.492, -0.472),
  true_W1 = c(0.686, 3.015, 0.910, 1.262, 1.633, 1.035),
  stringsAsFactors = FALSE)
for (i in seq_len(nrow(exp3))) {
  id <- exp3$id[i]; mm <- moms(S3[[id]])
  chk(sprintf("Set3 %s: mean AND SD equal the anchor's (RV blind spot)", id),
      near(mm["mean"], 50, 0.05) && near(mm["sd"], 10, 0.05),
      sprintf("mean=%.2f sd=%.2f (anchor 50, 10)", mm["mean"], mm["sd"]))
  chk(sprintf("Set3 %s: skew and true W1 as planned", id),
      near(mm["skew"], exp3$skew[i], 0.02) && near(tw1(S3, id, LO3, HI3), exp3$true_W1[i], 0.01),
      sprintf("skew=%.3f W1=%.3f", mm["skew"], tw1(S3, id, LO3, HI3)))
}
chk("Set3 STRUCTURE: the symmetric-bimodal countries ALSO match the anchor's skewness (RV3 blind)",
    near(moms(S3$B1)["skew"], 0, 0.02) && near(moms(S3$B2)["skew"], 0, 0.02) &&
      near(moms(S3$A0)["skew"], 0, 0.02))
chk("Set3 STRUCTURE: every discordant country still has true W1 > 0 (W1 can see them)",
    all(vapply(exp3$id, function(id) tw1(S3, id, LO3, HI3) > 0.5, logical(1))))

## Table 2c-bis — Set 4, extremes. THE claim: KS saturates while W1 grows; the
## displaced-extreme countries match the anchor's mean exactly (CDFs cross).
S4 <- build_set4(); LO4 <- -400; HI4 <- 600
exp4 <- data.frame(
  id      = c("T1","T2","P1","P2","S1","S2"),
  role    = c("sym_severity","sym_severity","sym_prevalence","asym_severity","bulk_shift","bulk_shift"),
  mean    = c(50, 50, 50, 53, 52, 53),
  true_W1 = c(3.000, 6.000, 4.483, 3.000, 2.000, 3.000),
  true_KS = c(0.047, 0.050, 0.067, 0.050, 0.072, 0.107),
  stringsAsFactors = FALSE)
for (i in seq_len(nrow(exp4))) {
  id <- exp4$id[i]; mm <- moms(S4[[id]])
  chk(sprintf("Set4 %s: role/mean and true W1/KS as planned", id),
      S4[[id]]$role == exp4$role[i] && near(mm["mean"], exp4$mean[i], 0.08) &&
        near(tw1(S4, id, LO4, HI4), exp4$true_W1[i], 0.01) &&
        near(tks(S4, id, LO4, HI4), exp4$true_KS[i], 0.002),
      sprintf("mean=%.2f W1=%.3f KS=%.4f", mm["mean"],
              tw1(S4, id, LO4, HI4), tks(S4, id, LO4, HI4)))
}
chk("Set4 STRUCTURE: displaced-extreme countries have EXACTLY the anchor's mean (SMD/RV1 have no coordinate)",
    near(moms(S4$T1)["mean"], 50, 0.08) && near(moms(S4$T2)["mean"], 50, 0.08) &&
      near(moms(S4$P1)["mean"], 50, 0.08),
    "the CDFs cross, so W1 > 0 while |mean difference| = 0")
chk("Set4 STRUCTURE (the point of the set): doubling the displacement doubles W1 but not KS",
    near(tw1(S4,"T2",LO4,HI4) / tw1(S4,"T1",LO4,HI4), 2.0, 0.01) &&
      tks(S4,"T2",LO4,HI4) / tks(S4,"T1",LO4,HI4) < 1.10,
    sprintf("W1 x%.3f, KS x%.3f", tw1(S4,"T2",LO4,HI4)/tw1(S4,"T1",LO4,HI4),
            tks(S4,"T2",LO4,HI4)/tks(S4,"T1",LO4,HI4)))
chk("Set4 STRUCTURE (rank inversion): KS calls the 2-unit bulk shift MORE discordant than T2",
    tks(S4, "S1", LO4, HI4) > tks(S4, "T2", LO4, HI4) &&
      tw1(S4, "T2", LO4, HI4) > tw1(S4, "S1", LO4, HI4),
    sprintf("KS: S1=%.4f > T2=%.4f, but W1: T2=%.2f > S1=%.2f",
            tks(S4,"S1",LO4,HI4), tks(S4,"T2",LO4,HI4),
            tw1(S4,"T2",LO4,HI4), tw1(S4,"S1",LO4,HI4)))

## Part 1 roster shape: 10 countries = 1 anchor + 9 candidates, 3 true matches
for (nm in c("Set1","Set2","Set3","Set4")) {
  r <- switch(nm, Set1 = S1, Set2 = S2, Set3 = S3, Set4 = S4)
  roles <- vapply(setdiff(names(r), "A0"), function(id) r[[id]]$role, character(1))
  chk(sprintf("%s Part-1 roster: 1 anchor + 9 candidates, exactly 3 true matches", nm),
      length(r) == 10L && r$A0$role == "anchor" && sum(roles == "match") == 3L,
      sprintf("%d countries, %d matches", length(r), sum(roles == "match")))
}

## Table 2d — Part 2 rosters: 12 countries, 3 groups of 4
for (nm in c("Set1","Set2","Set3","Set4")) {
  r <- switch(nm, Set1 = build_clust_set1(), Set2 = build_clust_set2(),
              Set3 = build_clust_set3(), Set4 = build_clust_set4())
  g <- table(vapply(r, function(x) x$group, character(1)))
  chk(sprintf("%s Part-2 roster: 12 countries, 3 groups of 4", nm),
      length(r) == 12L && length(g) == 3L && all(g == 4L),
      sprintf("groups: %s", paste(names(g), g, sep = "x", collapse = " ")))
}

# =============================================================================
# PART B — run settings match Table 5
# =============================================================================
cat("\n--- PART B: run settings vs plan Table 5 ---\n")
cfg_s <- read.csv(.here("../results/selection_sim_config.csv"), stringsAsFactors = FALSE)
cfg_c <- read.csv(.here("../results/clustering_sim_config.csv"), stringsAsFactors = FALSE)

chk("Table 5: four scenario sets in BOTH parts",
    setequal(cfg_s$set, c("Set1_Gaussian","Set2_LogNormal","Set3_Mixture","Set4_Extremes")) &&
      setequal(cfg_c$set, c("Set1_Gaussian","Set2_LogNormal","Set3_Mixture","Set4_Extremes")))
chk("Table 5: n grid = {25, 50, 75, 100} in both parts",
    setequal(cfg_s$n, c(25,50,75,100)) && setequal(cfg_c$n, c(25,50,75,100)))
chk("Table 5: Part 1 reps = 10,000 in every cell", all(cfg_s$reps == 10000L),
    sprintf("reps: %s", paste(unique(cfg_s$reps), collapse = ",")))
chk("Table 5: Part 2 reps = 5,000 in every cell", all(cfg_c$reps == 5000L),
    sprintf("reps: %s", paste(unique(cfg_c$reps), collapse = ",")))
chk("Table 5: Part 2 clustering algorithm fixed (average linkage, k = 3) in every cell",
    all(cfg_c$linkage == "average") && all(cfg_c$k_true == 3L))
chk("Table 5: Part 1 methods per set (SMD_log only in Set 2)",
    all(cfg_s$methods[cfg_s$set != "Set2_LogNormal"] == "W1|SMD|KS|RV1|RV2|RV3") &&
      all(cfg_s$methods[cfg_s$set == "Set2_LogNormal"] == "W1|SMD|SMD_log|KS|RV1|RV2|RV3"),
    paste(unique(cfg_s$methods), collapse = " / "))
chk("Table 5: Part 2 methods = all six, every set",
    all(cfg_c$methods == "W1|SMD|KS|RV1|RV2|RV3"))
chk("Reproducibility: every cell has a distinct seed",
    !anyDuplicated(cfg_s$seed) && !anyDuplicated(cfg_c$seed),
    sprintf("%d + %d cells", nrow(cfg_s), nrow(cfg_c)))

## Table 5's Monte Carlo precision claim. The headline results rest on AUC and ARI, so
## those must be within 0.005. Part 2's exact-recovery rate is a proportion and its SE
## at 5,000 reps peaks at sqrt(0.25/5000) = 0.0071 -- the plan states this exception
## explicitly rather than pretending the bound holds everywhere.
sum_s <- read.csv(.here("../results/selection_sim_summary.csv"),  stringsAsFactors = FALSE)
sum_c <- read.csv(.here("../results/clustering_sim_summary.csv"), stringsAsFactors = FALSE)
chk("Table 5: Part 1 MC SE <= 0.005 everywhere",
    max(sum_s$mc_se) <= 0.005, sprintf("max %.5f", max(sum_s$mc_se)))
chk("Table 5: Part 2 ARI MC SE <= 0.005 (the headline measure)",
    max(sum_c$mc_se[sum_c$measure == "ari"]) <= 0.005,
    sprintf("max %.5f", max(sum_c$mc_se[sum_c$measure == "ari"])))
chk("Table 5: Part 2 exact-recovery MC SE within its structural bound sqrt(0.25/reps)",
    max(sum_c$mc_se[sum_c$measure == "exact_recovery"]) <= sqrt(0.25 / 5000) + 1e-6,
    sprintf("max %.5f vs bound %.5f", max(sum_c$mc_se[sum_c$measure == "exact_recovery"]),
            sqrt(0.25 / 5000)))

## The RV variants are what the plan says they are: 1, 2, 3 coordinates.
set.seed(7L)
xs <- lapply(1:9, function(i) rnorm(200, 50 + i, 10 + i)); names(xs) <- paste0("C", 1:9)
xA <- rnorm(200, 50, 10)
chk("Table 3: RV1 uses the MEAN only (Ch.4 as written)",
    identical(unname(DISTFUN$RV1(xA, xs)), unname(rv_dists(xA, xs, "mean"))))
chk("Table 3: RV2 = (mean, SD); RV3 = (mean, SD, skew) -- OUR extensions, not Ch.4",
    identical(unname(DISTFUN$RV2(xA, xs)), unname(rv_dists(xA, xs, c("mean","sd")))) &&
      identical(unname(DISTFUN$RV3(xA, xs)), unname(rv_dists(xA, xs, c("mean","sd","skew")))))
chk("Table 3: RV1 differs from RV2 (else the Ch.4-vs-extension distinction is vacuous)",
    !isTRUE(all.equal(unname(DISTFUN$RV1(xA, xs)), unname(DISTFUN$RV2(xA, xs)))))

# =============================================================================
# PART C — Set 4 closed forms (the mechanism the KS argument rests on)
# =============================================================================
cat("\n--- PART C: Set 4 closed forms vs numerical integration ---\n")
eps <- 0.05; st <- 8
w1_cf <- function(dL, dH) eps * dL + eps * dH                       # plan: W1 = eL*dL + eH*dH
ks_cf <- function(dL, dH) max(eps * (2 * pnorm(c(dL, dH) / (2 * st)) - 1))  # plan: max, not sum
for (d in c(70, 100)) {
  id <- if (d == 70) "T1" else "T2"
  dd <- d - 40                                                      # displacement RELATIVE to anchor
  chk(sprintf("Set4 closed form W1 (%s, displacement %d each side)", id, dd),
      near(w1_cf(dd, dd), tw1(S4, id, LO4, HI4), 0.002),
      sprintf("closed %.4f vs integrated %.4f", w1_cf(dd, dd), tw1(S4, id, LO4, HI4)))
  chk(sprintf("Set4 closed form KS (%s)", id),
      near(ks_cf(dd, dd), tks(S4, id, LO4, HI4), 0.002),
      sprintf("closed %.4f vs integrated %.4f", ks_cf(dd, dd), tks(S4, id, LO4, HI4)))
}
chk("Set4 mechanism: KS is bounded by the contamination fraction eps",
    tks(S4, "T2", LO4, HI4) <= eps + 1e-9,
    sprintf("KS(T2) = %.4f <= eps = %.2f", tks(S4, "T2", LO4, HI4), eps))
chk("Set4 mechanism: KS saturates -- doubling 30 -> 60 moves it < 7%",
    ks_cf(60,60) / ks_cf(30,30) < 1.07,
    sprintf("KS ratio %.4f (W1 ratio %.2f)", ks_cf(60,60)/ks_cf(30,30), w1_cf(60,60)/w1_cf(30,30)))

cat(sprintf("\n===== PLAN/CODE CONFIGURATION %s =====\n", if (ok) "ALL PASS" else "HAS FAILURES"))
if (!ok) quit(status = 1L)
