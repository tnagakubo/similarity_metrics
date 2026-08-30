# =============================================================================
# STUDY 2 FIGURE VERIFICATION -- numbers gate for the manuscript's Simulation
# section (Study 2, decision performance).
#
# Written 2026-08-30, before drafting the section. Every quantitative claim the
# prose will quote is re-extracted from the results CSVs (and, for the Set 4
# true distances, recomputed from the generators) and compared against the
# value to be printed. Expected values are those recorded in
# SIMULATION_FINDINGS.md / PAPER_OUTLINE_BILINGUAL.md; a FAIL means the prose
# must quote the CSV, not the note.
#
# Sources: results/selection_sim_summary{,_ext}.csv
#          results/clustering_sim_summary{,_ext}.csv
#          results/required_n_{selection,clustering}{,_floor}.csv
#          results/clustering_nok_silhouette.csv
#          R/selection_simulation.R (build_set4 + true_w1/true_ks; source-safe,
#          guarded by sys.nframe() == 0)
#
# Output: results/verify_study2.log. Stops with an error on any FAIL.
# =============================================================================

log_lines <- character(0)
say <- function(fmt, ...) {
  s <- sprintf(fmt, ...)
  cat(s, "\n", sep = "")
  log_lines <<- c(log_lines, s)
}
fails <- 0
check <- function(label, got, want, digits = NA) {
  if (!is.na(digits)) got <- round(got, digits)
  ok <- isTRUE(all(got == want))
  if (!ok) fails <<- fails + 1
  say("[verify] %-58s %s%s", label, if (ok) "PASS" else "FAIL",
      if (ok) "" else sprintf("  (got %s, want %s)",
                              paste(got, collapse = ","), paste(want, collapse = ",")))
}

sel <- rbind(read.csv("results/selection_sim_summary.csv"),
             read.csv("results/selection_sim_summary_ext.csv"))
clu <- rbind(read.csv("results/clustering_sim_summary.csv"),
             read.csv("results/clustering_sim_summary_ext.csv"))
rqs  <- read.csv("results/required_n_selection.csv")
rqsf <- read.csv("results/required_n_selection_floor.csv")
rqc  <- read.csv("results/required_n_clustering.csv")
rqcf <- read.csv("results/required_n_clustering_floor.csv")
nok  <- read.csv("results/clustering_nok_silhouette.csv")

g_sel <- function(set, n, method, measure, type) {
  v <- sel$value[sel$set == set & sel$n == n & sel$method == method &
                 sel$measure == measure & sel$type == type]
  stopifnot(length(v) == 1); v
}
g_ari <- function(set, n, method) {
  v <- clu$value[clu$set == set & clu$n == n & clu$method == method & clu$measure == "ari"]
  stopifnot(length(v) == 1); v
}
g_rqs <- function(cell, method, col) {
  v <- rqs[[col]][rqs$set == cell & rqs$method == method & rqs$threshold == 0.9]
  stopifnot(length(v) == 1); v
}
g_rqc <- function(set, method, col) {
  v <- rqc[[col]][rqc$set == set & rqc$method == method & rqc$threshold == 0.8]
  stopifnot(length(v) == 1); v
}

say("== Study 2 numbers gate (2026-08-30) ==")

# ---- A. required n for AUC >= 0.9, decisive cells ---------------------------
say("\n-- A. required n, selection AUC >= 0.9 --")
cells <- list(
  c("Set4_Extremes / sym_severity",  "W1",  42), c("Set4_Extremes / sym_severity",  "KS", 1047),
  c("Set4_Extremes / sym_severity",  "RV2", 76), c("Set4_Extremes / sym_severity",  "RV3",  83),
  c("Set4_Extremes / asym_severity", "W1",  67), c("Set4_Extremes / asym_severity", "KS", 1252),
  c("Set4_Extremes / asym_severity", "RV1", 389), c("Set4_Extremes / asym_severity", "RV2", 125),
  c("Set4_Extremes / asym_severity", "RV3", 41), c("Set4_Extremes / asym_severity", "SMD", 530),
  c("Set4_Extremes / bulk_shift",    "KS", 333), c("Set4_Extremes / bulk_shift",    "W1",  377),
  c("Set3_Mixture / combined",       "W1", 368), c("Set3_Mixture / combined",       "KS",  550),
  c("Set3_Mixture / shape_sym",      "W1", 690), c("Set3_Mixture / shape_sym",      "KS",  716))
for (v in cells)
  check(sprintf("req n 0.9: %s %s", v[1], v[2]), g_rqs(v[1], v[2], "required_n"), as.numeric(v[3]))
check("blind: sym_severity SMD never reaches 0.9",
      g_rqs("Set4_Extremes / sym_severity", "SMD", "status") != "reached", TRUE)
check("partial: sym_severity RV1 max AUC", g_rqs("Set4_Extremes / sym_severity", "RV1", "max_auc"), 0.63, 2)
check("partial: Set3 combined RV3 max AUC", g_rqs("Set3_Mixture / combined", "RV3", "max_auc"), 0.78, 2)
w1_cells <- c(g_rqs("Set4_Extremes / sym_severity", "W1", "required_n"),
              g_rqs("Set4_Extremes / asym_severity", "W1", "required_n"),
              g_rqs("Set4_Extremes / bulk_shift", "W1", "required_n"),
              g_rqs("Set3_Mixture / combined", "W1", "required_n"),
              g_rqs("Set3_Mixture / shape_sym", "W1", "required_n"))
check("W1 range across decisive cells 42-690", range(w1_cells), c(42, 690))
flo <- vapply(c("Set4_Extremes / sym_severity", "Set4_Extremes / asym_severity",
                "Set4_Extremes / bulk_shift", "Set3_Mixture / combined",
                "Set3_Mixture / shape_sym"),
              function(cl) rqsf$required_n[rqsf$set == cl & rqsf$threshold == 0.9], numeric(1))
check("task floor range across decisive cells 41-690", range(flo), c(41, 690))

# ---- B. AUC plateaus (blind / partial claims) -------------------------------
# The recorded note quoted max_auc for the blind cells (0.50-0.51); at n = 2000
# the values sit at 0.49-0.50. The prose therefore claims "0.49-0.51 across the
# full grid, chance = 0.5", verified two-sided here.
say("\n-- B. AUC plateaus, blind / partial --")
blind <- list(c("Set3_Mixture / combined",      "RV1", "Set3_Mixture",  "combined"),
              c("Set3_Mixture / combined",      "RV2", "Set3_Mixture",  "combined"),
              c("Set3_Mixture / combined",      "SMD", "Set3_Mixture",  "combined"),
              c("Set4_Extremes / sym_severity", "SMD", "Set4_Extremes", "sym_severity"))
for (v in blind) {
  check(sprintf("blind %s %s: max_auc <= 0.51", v[1], v[2]),
        round(g_rqs(v[1], v[2], "max_auc"), 2) <= 0.51, TRUE)
  check(sprintf("blind %s %s: AUC@2000 in 0.49-0.51", v[1], v[2]),
        abs(g_sel(v[3], 2000, v[2], "auc", v[4]) - 0.5) <= 0.011, TRUE)
}
check("S3 combined RV3 (partial)", g_sel("Set3_Mixture", 2000, "RV3", "auc", "combined"), 0.78, 2)
for (m in c("RV1", "RV2", "RV3", "SMD"))
  check(sprintf("S3 shape_sym %s: AUC@2000 in 0.43-0.51", m),
        g_sel("Set3_Mixture", 2000, m, "auc", "shape_sym") >= 0.43 &&
        g_sel("Set3_Mixture", 2000, m, "auc", "shape_sym") <= 0.51, TRUE)
check("S4 sym_severity RV1 plateau 0.60-0.64",
      abs(g_sel("Set4_Extremes", 2000, "RV1", "auc", "sym_severity") - 0.62) <= 0.02, TRUE)

# ---- C. harm and false-pooling at n = 100 -----------------------------------
say("\n-- C. harm / false-pooling, n = 100, overall --")
harm <- list(c("Set1_Gaussian", "W1", 0.402, 3), c("Set1_Gaussian", "RV2", 0.336, 3),
             c("Set2_LogNormal", "W1", 2.583, 3), c("Set3_Mixture", "W1", 0.988, 3),
             c("Set4_Extremes", "W1", 2.000, 3), c("Set4_Extremes", "KS", 4.27, 2))
for (v in harm)
  check(sprintf("harm %s %s", v[1], v[2]),
        g_sel(v[1], 100, v[2], "harm_maxW1", "overall"), as.numeric(v[3]), as.numeric(v[4]))
h_w1 <- g_sel("Set4_Extremes", 100, "W1", "harm_maxW1", "overall")
h_ks <- g_sel("Set4_Extremes", 100, "KS", "harm_maxW1", "overall")
check("harm ratio KS/W1 Set4", h_ks / h_w1, 2.14, 2)
fp_w1 <- g_sel("Set4_Extremes", 100, "W1", "false_pooling_at_k", "overall")
fp_ks <- g_sel("Set4_Extremes", 100, "KS", "false_pooling_at_k", "overall")
check("false-pooling Set4 W1", fp_w1, 0.718, 3)
check("false-pooling Set4 KS", fp_ks, 0.971, 3)
check("false-pooling ratio KS/W1", fp_ks / fp_w1, 1.35, 2)
w1_smallest <- vapply(c("Set2_LogNormal", "Set3_Mixture", "Set4_Extremes"), function(s) {
  meth <- c("W1", "KS", "SMD", "RV1", "RV2", "RV3")
  h <- vapply(meth, function(m) g_sel(s, 100, m, "harm_maxW1", "overall"), numeric(1))
  meth[which.min(h)] == "W1" }, logical(1))
check("W1 harm smallest in Sets 2-4 at n=100", all(w1_smallest), TRUE)

# ---- D. clustering ARI at n = 100 / 2000 ------------------------------------
say("\n-- D. clustering ARI (n = 100 / n = 2000) --")
ari_exp <- list(
  W1  = c(0.995, 1.000, 0.642, 1.000, 0.526, 1.000, 0.355, 0.999),
  KS  = c(0.983, 1.000, 0.850, 1.000, 0.503, 0.995, 0.003, 0.985),
  RV1 = c(0.489, 0.495, 0.343, 0.494, 0.000, 0.001, 0.026, 0.023),
  RV2 = c(0.996, 1.000, 0.614, 1.000, 0.018, 0.014, 0.271, 0.380),
  RV3 = c(0.620, 0.736, 0.448, 0.953, 0.131, 0.339, 0.189, 0.247),
  SMD = c(0.452, 0.460, 0.334, 0.461, 0.000, 0.001, 0.018, 0.014))
sets4 <- c("Set1_Gaussian", "Set2_LogNormal", "Set3_Mixture", "Set4_Extremes")
for (m in names(ari_exp)) {
  got <- as.vector(vapply(sets4, function(s) c(g_ari(s, 100, m), g_ari(s, 2000, m)), numeric(2)))
  check(sprintf("ARI %s (4 sets x n=100,2000)", m), got, ari_exp[[m]], 3)
}

# ---- E. required n for ARI >= 0.8 -------------------------------------------
say("\n-- E. required n, clustering ARI >= 0.8 --")
check("W1 per set", vapply(sets4, function(s) g_rqc(s, "W1", "required_n"), numeric(1)),
      c(41, 156, 364, 376))
check("KS per set", vapply(sets4, function(s) g_rqc(s, "KS", "required_n"), numeric(1)),
      c(49, 83, 629, 1240))
floc <- vapply(sets4, function(s) rqcf$required_n[rqcf$set == s & rqcf$threshold == 0.8], numeric(1))
check("task floor per set", floc, c(36, 83, 364, 376))
check("Set1 floor achieved by RV2",
      rqcf$achieved_by[rqcf$set == "Set1_Gaussian" & rqcf$threshold == 0.8], "RV2")

# ---- F. oracle-k removal (silhouette k-hat), n = 100 ------------------------
say("\n-- F. silhouette k-hat vs oracle k = 3, n = 100 --")
g_nok <- function(set, method, col) {
  v <- nok[[col]][nok$set == set & nok$n == 100 & nok$method == method]
  stopifnot(length(v) == 1); v
}
d_w1 <- vapply(sets4, function(s) g_nok(s, "W1", "ari") - g_ari(s, 100, "W1"), numeric(1))
check("W1 delta per set", d_w1, c(-0.005, -0.021, -0.010, -0.023), 3)
check("KS delta Set1", g_nok("Set1_Gaussian", "KS", "ari") - g_ari("Set1_Gaussian", 100, "KS"), -0.260, 3)
check("KS delta Set2", g_nok("Set2_LogNormal", "KS", "ari") - g_ari("Set2_LogNormal", 100, "KS"), -0.179, 3)
pk3 <- function(s) { i <- nok$set == s & nok$n == 100; max(nok$p_k_correct[i]) }
check("max P(k-hat=3) Set3", pk3("Set3_Mixture"), 0.228, 3)
check("max P(k-hat=3) Set4", pk3("Set4_Extremes"), 0.288, 3)
mode2 <- function(s) all(nok$k_hat_mode[nok$set == s & nok$n == 100] == 2)
check("k-hat mode = 2 for every method, Set3", mode2("Set3_Mixture"), TRUE)
check("k-hat mode = 2 for every method, Set4", mode2("Set4_Extremes"), TRUE)
check("Set3 KS silhouette ARI", g_nok("Set3_Mixture", "KS", "ari"), 0.521, 3)
check("Set3: near-zero-ARI methods (RV1, SMD) hit k=3 at least as often as W1",
      g_nok("Set3_Mixture", "RV1", "p_k_correct") >= g_nok("Set3_Mixture", "W1", "p_k_correct") &&
      g_nok("Set3_Mixture", "SMD", "p_k_correct") >= g_nok("Set3_Mixture", "W1", "p_k_correct") &&
      g_ari("Set3_Mixture", 100, "RV1") < 0.05 && g_ari("Set3_Mixture", 100, "SMD") < 0.05, TRUE)

# ---- G. Set 4 true distances from the generators ----------------------------
say("\n-- G. Set 4 true W1 / KS (recomputed from build_set4) --")
source("R/selection_simulation.R", chdir = FALSE)  # source-safe: main() guarded
r4 <- build_set4(); lo <- -400; hi <- 600           # bounds as in the driver
ids <- c("T1", "T2", "P2", "S1")
tw <- vapply(ids, function(id) true_w1(r4$A0, r4[[id]], lo, hi), numeric(1))
tk <- vapply(ids, function(id) true_ks(r4$A0, r4[[id]], lo, hi), numeric(1))
check("true W1 (T1,T2,P2,S1)", tw, c(3.000, 6.000, 3.000, 2.000), 3)
check("true KS (T1,T2,P2,S1)", tk, c(0.047, 0.050, 0.050, 0.072), 3)
check("rank reversal: S1 has the largest true KS", names(which.max(tk)), "S1")
check("no KS threshold separates T1(in) from T2(out): |KS gap| <= 0.006",
      abs(tk["T2"] - tk["T1"]) <= 0.006, TRUE)

# ---- H. design constants quoted in prose ------------------------------------
say("\n-- H. design constants --")
# The recorded note said "5,000-10,000 / 2,000-3,000 reps" and "9-11 candidates";
# the configs show those ranges pooled two different tasks. Reality: selection
# 10,000 / 3,000, clustering 5,000 / 2,000, and 9 candidates in every set.
cfg  <- read.csv("results/selection_sim_config.csv")
cfge <- read.csv("results/selection_sim_config_ext.csv")
ccf  <- read.csv("results/clustering_sim_config.csv")
ccfe <- read.csv("results/clustering_sim_config_ext.csv")
check("selection production reps = 10000", unique(cfg$reps), 10000)
check("selection extension reps = 3000", unique(cfge$reps), 3000)
check("clustering production reps = 5000", unique(ccf$reps), 5000)
check("clustering extension reps = 2000", unique(ccfe$reps), 2000)
check("production n grid", sort(unique(cfg$n)), c(25, 50, 75, 100))
check("extension n grid tops out at 2000", max(cfge$n), 2000)
check("clustering oracle k_true = 3", unique(ccf$k_true), 3)
n_cand <- vapply(list(build_set1(), build_set2(), build_set3(), build_set4()),
                 function(r) length(setdiff(names(r), "A0")), numeric(1))
check("9 candidates in every set", unique(n_cand), 9)

say("\n[verify] overall: %s (%d failure%s)",
    if (fails == 0) "ALL PASS" else "FAILURES PRESENT", fails, if (fails == 1) "" else "s")
writeLines(log_lines, "results/verify_study2.log")
say("[save] results/verify_study2.log")
if (fails > 0) stop("verification failed -- quote the CSV, not the note")
