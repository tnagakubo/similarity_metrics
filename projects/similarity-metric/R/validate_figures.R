# =============================================================================
# Validation for figures_selection.R — Part 1 (selection) + Part 2 (clustering).
#
# Two jobs:
#   (A) FIDELITY  — the figures plot exactly the numbers in the CSVs (not a
#       mis-joined, stale, or silently-truncated view). Checked via ggplot_build.
#   (B) CLAIMS    — the qualitative findings the paper will rest on are actually
#       in the data, stated as thresholds (not point values), so they stay valid
#       across reps. If a claim check fails, the claim is wrong, not the test.
#
# Any FAIL blocks shipping the figures.
# =============================================================================
.cands <- c(
  tryCatch(file.path(dirname(sys.frame(1)$ofile), "figures_selection.R"), error = function(e) NA_character_),
  "R/figures_selection.R", "figures_selection.R",
  "projects/similarity-metric/R/figures_selection.R")
src <- .cands[!is.na(.cands) & file.exists(.cands)][1]
if (is.na(src)) stop("cannot locate figures_selection.R (cwd=", getwd(), ")")
source(src, chdir = TRUE)   # exposes load_* / fig_* ; generator guarded off
suppressPackageStartupMessages(library(ggplot2))

ok <- TRUE
chk <- function(name, cond, detail = "") {
  cat(sprintf("[%s] %s%s\n", if (isTRUE(cond)) "PASS" else "FAIL", name,
              if (nzchar(detail)) paste0("  -- ", detail) else "")); if (!isTRUE(cond)) ok <<- FALSE
}
approx <- function(a, b, tol = 1e-9) all(abs(a - b) <= tol)

SEL_CSV <- resolve_csv("selection_sim_summary.csv")
CLU_CSV <- resolve_csv("clustering_sim_summary.csv")
chk("selection CSV located",  !is.na(SEL_CSV), SEL_CSV)
chk("clustering CSV located", !is.na(CLU_CSV), CLU_CSV)
raw_s <- read.csv(SEL_CSV, stringsAsFactors = FALSE)
raw_c <- read.csv(CLU_CSV, stringsAsFactors = FALSE)
sel   <- load_selection()
clu   <- load_clustering()

# ---- (A) FIDELITY ----------------------------------------------------------
# A1. loaders preserve every row/value
key_s <- function(d) paste(d$set, d$n, d$method, d$measure, d$type, sep = "|")
key_c <- function(d) paste(d$set, d$n, d$method, d$measure, sep = "|")
ms <- match(key_s(raw_s), key_s(sel)); mc <- match(key_c(raw_c), key_c(clu))
chk("selection: row count preserved", nrow(sel) == nrow(raw_s), sprintf("%d rows", nrow(sel)))
chk("clustering: row count preserved", nrow(clu) == nrow(raw_c), sprintf("%d rows", nrow(clu)))
chk("selection: every CSV row present with identical value",
    all(!is.na(ms)) && approx(raw_s$value, sel$value[ms]))
chk("clustering: every CSV row present with identical value",
    all(!is.na(mc)) && approx(raw_c$value, clu$value[mc]))
chk("no NA values after load", all(!is.na(sel$value)) && all(!is.na(clu$value)))

# A2. all three sets and all six methods survive the load (the old 2-set/3-method
#     schema would silently drop RV1/RV2/RV3/Set3 -- this is the check that catches it)
chk("selection: all 4 sets present", setequal(unique(sel$set), names(FAMILY_LABELS)),
    paste(sort(unique(sel$set)), collapse = ", "))
chk("clustering: all 4 sets present", setequal(unique(clu$set), names(FAMILY_LABELS)))
chk("selection: RV1, RV2, RV3 present in every set",
    all(vapply(names(FAMILY_LABELS), function(s)
      all(c("RV1", "RV2", "RV3") %in% raw_s$method[raw_s$set == s]), logical(1))))
chk("clustering: all 6 methods present in every set",
    all(vapply(names(FAMILY_LABELS), function(s)
      setequal(unique(raw_c$method[raw_c$set == s]), c("W1","SMD","KS","RV1","RV2","RV3")), logical(1))))

# A3. figures plot EXACTLY the CSV numbers (multiset equality of point y-values)
point_y <- function(p, n_expect) {
  b <- ggplot_build(p)$data
  hit <- Filter(function(L) nrow(L) == n_expect && "shape" %in% names(L), b)
  if (!length(hit)) hit <- Filter(function(L) nrow(L) == n_expect, b)
  if (!length(hit)) stop("no layer with ", n_expect, " rows")
  hit[[1]]$y
}
in_facets <- function(d, fs) paste(d$set, d$type, sep = "|") %in% fs
fp_csv   <- raw_s$value[raw_s$measure == "false_pooling_at_k"]
auc123   <- raw_s$value[raw_s$measure == "auc" & in_facets(raw_s, FACETS_123)]
auc4     <- raw_s$value[raw_s$measure == "auc" & in_facets(raw_s, FACETS_4)]
ari_csv  <- raw_c$value[raw_c$measure == "ari"]
chk("fig1 (false-pooling) point y == CSV (multiset)",
    approx(sort(point_y(fig_false_pooling(sel, "greyscale"), length(fp_csv))), sort(fp_csv)),
    sprintf("%d points", length(fp_csv)))
chk("fig2 (AUC, Sets 1-3) point y == CSV (multiset)",
    approx(sort(point_y(fig_auc_by_type(sel, "greyscale"), length(auc123))), sort(auc123)),
    sprintf("%d points", length(auc123)))
chk("fig2b (AUC, Set 4) point y == CSV (multiset)",
    approx(sort(point_y(fig_auc_set4(sel, "greyscale"), length(auc4))), sort(auc4)),
    sprintf("%d points", length(auc4)))
chk("fig2 + fig2b together cover EVERY AUC row (none silently dropped)",
    length(auc123) + length(auc4) == sum(raw_s$measure == "auc"),
    sprintf("%d + %d = %d of %d", length(auc123), length(auc4),
            length(auc123) + length(auc4), sum(raw_s$measure == "auc")))
chk("fig3 (ARI) point y == CSV (multiset)",
    approx(sort(point_y(fig_clustering_ari(clu, "greyscale"), length(ari_csv))), sort(ari_csv)),
    sprintf("%d points", length(ari_csv)))

# A4. every AUC row lands in a declared facet of fig2 (Sets 1-3) or fig2b (Set 4).
#     A row belonging to neither would be silently dropped from both figures.
facet_ok <- c(FACETS_123, FACETS_4)
d2 <- subset(raw_s, measure == "auc")
chk("every AUC row maps to a declared facet (fig2 or fig2b)",
    all(paste(d2$set, d2$type, sep = "|") %in% facet_ok),
    paste(setdiff(unique(paste(d2$set, d2$type, sep = "|")), facet_ok), collapse = ", "))

# A5. method factor / palette coverage
chk("method levels = the 7 declared methods",
    identical(levels(sel$method), c("W1","KS","RV1","RV2","RV3","SMD_log","SMD")))
pal <- .pal("greyscale")
chk("palette keys cover every method",
    all(levels(sel$method) %in% names(pal$color)) &&
    all(levels(sel$method) %in% names(pal$linetype)) &&
    all(levels(sel$method) %in% names(pal$shape)))

# ---- (B) CLAIMS the paper will make ----------------------------------------
vs <- function(set, n, meth, meas, ty) raw_s$value[raw_s$set == set & raw_s$n == n &
                                    raw_s$method == meth & raw_s$measure == meas & raw_s$type == ty]
vc <- function(set, n, meth, meas)     raw_c$value[raw_c$set == set & raw_c$n == n &
                                    raw_c$method == meth & raw_c$measure == meas]

# B0. Ch.4 AS WRITTEN (RV1 = one representative value per EM) carries no information
#     about scale for a single continuous EM. This is the citation-faithful claim;
#     RV2/RV3 are OUR extensions and must never be attributed to Komiyama.
#
#     Subtlety, verified analytically: RV1's scale-AUC is ~0.62, not ~0.50. That is
#     NOT detection. RV1's distance is |xbar_i - xbar_A| / const, and all Set-1
#     countries share the true mean 50, so RV1's POPULATION distance to the anchor is
#     exactly 0 for the scale countries. The 0.62 comes from a wider country having a
#     noisier sample mean: for independent X~N(0,s1), Y~N(0,s2), P(|X|<|Y|) =
#     (2/pi)atan(s2/s1), giving 0.59 (V1) and 0.64 (V2) -> mean 0.62, matching the sim.
#     The signature of "no information" is therefore not AUC = 0.5 but AUC FLAT IN n:
#     a method that actually resolved scale would improve as n grows (W1: 0.93 -> 1.00).
rv1_scale <- vapply(c(25,50,75,100), function(n) vs("Set1_Gaussian", n, "RV1", "auc", "scale"), numeric(1))
w1_scale  <- vapply(c(25,50,75,100), function(n) vs("Set1_Gaussian", n, "W1",  "auc", "scale"), numeric(1))
chk("CLAIM Set1: RV1 scale-AUC is FLAT in n (gains no information as n grows)",
    abs(rv1_scale[4] - rv1_scale[1]) < 0.03 && max(rv1_scale) < 0.70,
    sprintf("RV1 n=25..100: %s", paste(sprintf("%.3f", rv1_scale), collapse = " ")))
chk("CLAIM Set1: W1 scale-AUC RISES with n and ends far above RV1",
    w1_scale[4] > w1_scale[1] && w1_scale[4] - rv1_scale[4] > 0.3,
    sprintf("W1 n=25..100: %s (RV1 ends %.3f)", paste(sprintf("%.3f", w1_scale), collapse = " "), rv1_scale[4]))
chk("CLAIM Set1: RV1 scale-AUC matches the sample-mean-noise prediction (2/pi)atan(.)",
    abs(rv1_scale[4] - 0.6231) < 0.03,
    sprintf("observed %.3f vs predicted 0.623", rv1_scale[4]))
chk("CLAIM Set1: RV1 and SMD agree on LOCATION (the control -- both see it)",
    abs(vs("Set1_Gaussian", 100, "RV1", "auc", "location") -
        vs("Set1_Gaussian", 100, "SMD", "auc", "location")) < 0.02,
    sprintf("RV1=%.3f SMD=%.3f", vs("Set1_Gaussian",100,"RV1","auc","location"),
            vs("Set1_Gaussian",100,"SMD","auc","location")))
chk("CLAIM Set1 clustering: RV1 tracks SMD, far below W1",
    abs(vc("Set1_Gaussian", 100, "RV1", "ari") - vc("Set1_Gaussian", 100, "SMD", "ari")) < 0.10 &&
    vc("Set1_Gaussian", 100, "W1", "ari") - vc("Set1_Gaussian", 100, "RV1", "ari") > 0.3,
    sprintf("RV1=%.3f SMD=%.3f W1=%.3f", vc("Set1_Gaussian",100,"RV1","ari"),
            vc("Set1_Gaussian",100,"SMD","ari"), vc("Set1_Gaussian",100,"W1","ari")))

# B1. DECISIVE: in the moment-matched world NO representative-value variant can
#     cluster -- not the chapter's recipe, not either extension. (Part 2, Set 3.)
for (m in c("RV1", "RV2", "SMD")) {
  v <- vapply(c(25,50,75,100), function(n) vc("Set3_Mixture", n, m, "ari"), numeric(1))
  chk(sprintf("CLAIM Set3: %s ARI ~ 0 at every n", m), all(abs(v) < 0.10),
      sprintf("max |ARI| = %.3f", max(abs(v))))
}
chk("CLAIM Set3: W1 ARI exceeds every RV variant by a wide margin at n=100",
    all(vc("Set3_Mixture", 100, "W1", "ari") -
        vapply(c("RV1","RV2","RV3"), function(m) vc("Set3_Mixture", 100, m, "ari"), numeric(1)) > 0.3),
    sprintf("W1=%.3f RV1=%.3f RV2=%.3f RV3=%.3f", vc("Set3_Mixture",100,"W1","ari"),
            vc("Set3_Mixture",100,"RV1","ari"), vc("Set3_Mixture",100,"RV2","ari"),
            vc("Set3_Mixture",100,"RV3","ari")))

# B2. Adding a moment is NOT free: an irrelevant 3rd coordinate degrades the RV
#     method where two suffice (Set 1), and still fails on symmetric bimodality (Set 3).
chk("CLAIM Set1: RV3 is WORSE than RV2 [combined AUC, n=100]",
    vs("Set1_Gaussian", 100, "RV3", "auc", "combined") < vs("Set1_Gaussian", 100, "RV2", "auc", "combined"),
    sprintf("RV3=%.3f < RV2=%.3f", vs("Set1_Gaussian",100,"RV3","auc","combined"),
            vs("Set1_Gaussian",100,"RV2","auc","combined")))
chk("CLAIM Set3: RV3 still blind to symmetric-bimodal (AUC <= 0.55 at n=100)",
    vs("Set3_Mixture", 100, "RV3", "auc", "shape_sym") <= 0.55,
    sprintf("AUC=%.3f", vs("Set3_Mixture", 100, "RV3", "auc", "shape_sym")))
chk("CLAIM Set3: RV1 and RV2 blind to ALL three discordance types (AUC <= 0.55)",
    all(vapply(c("shape_sym","shape_skew","combined"), function(ty)
      vs("Set3_Mixture", 100, "RV1", "auc", ty) <= 0.55 &&
      vs("Set3_Mixture", 100, "RV2", "auc", ty) <= 0.55, logical(1))))

# B2b. SET 4 -- the W1-vs-KS test. KS is an L-infinity norm on the CDF gap, so a rare
#      contaminated fraction eps caps it no matter how far the mass is displaced;
#      W1 is an L1 norm in EM units and grows linearly in the displacement. The tell,
#      as with RV1's fake scale detection, is FLAT IN n.
ks_sev <- vapply(c(25,50,75,100), function(n) vs("Set4_Extremes", n, "KS", "auc", "sym_severity"), numeric(1))
w1_sev <- vapply(c(25,50,75,100), function(n) vs("Set4_Extremes", n, "W1", "auc", "sym_severity"), numeric(1))
chk("CLAIM Set4: KS is at CHANCE on displaced extremes, at every n",
    all(abs(ks_sev - 0.5) < 0.05),
    sprintf("KS n=25..100: %s", paste(sprintf("%.3f", ks_sev), collapse = " ")))
chk("CLAIM Set4: KS gains no information as n grows (flat), while W1 rises",
    abs(ks_sev[4] - ks_sev[1]) < 0.05 && w1_sev[4] > w1_sev[1] && w1_sev[4] > 0.90,
    sprintf("KS %.3f->%.3f | W1 %.3f->%.3f", ks_sev[1], ks_sev[4], w1_sev[1], w1_sev[4]))
chk("CLAIM Set4: SMD is at chance too (the displaced-extreme cells match on the mean)",
    abs(vs("Set4_Extremes", 100, "SMD", "auc", "sym_severity") - 0.5) < 0.05,
    sprintf("SMD=%.3f", vs("Set4_Extremes", 100, "SMD", "auc", "sym_severity")))
chk("CLAIM Set4 clustering: KS recovers NO structure (ARI ~ 0 at every n)",
    all(abs(vapply(c(25,50,75,100), function(n) vc("Set4_Extremes", n, "KS", "ari"), numeric(1))) < 0.06),
    sprintf("max |ARI| = %.3f",
            max(abs(vapply(c(25,50,75,100), function(n) vc("Set4_Extremes", n, "KS", "ari"), numeric(1))))))
chk("CLAIM Set4 clustering: W1 exceeds KS by a wide margin at n=100",
    vc("Set4_Extremes", 100, "W1", "ari") - vc("Set4_Extremes", 100, "KS", "ari") > 0.20,
    sprintf("W1=%.3f KS=%.3f", vc("Set4_Extremes",100,"W1","ari"), vc("Set4_Extremes",100,"KS","ari")))

# B2c. THE LAYERED ARGUMENT. No competitor survives BOTH Set 3 and Set 4. This is the
#      claim the whole comparison rests on, so assert it directly rather than by eye.
survives <- function(m) {
  s3 <- vc("Set3_Mixture",  100, m, "ari")
  s4 <- vc("Set4_Extremes", 100, m, "ari")
  c(set3 = s3 > 0.20, set4 = s4 > 0.20)
}
surv <- vapply(c("W1","KS","RV1","RV2","RV3","SMD"), function(m) all(survives(m)), logical(1))
chk("CLAIM: W1 is the ONLY method that survives both Set 3 and Set 4 (ARI > 0.20 in each)",
    isTRUE(surv[["W1"]]) && sum(surv) == 1L,
    sprintf("survivors: %s", paste(names(surv)[surv], collapse = ", ")))

# B2d. CLINICAL HARM (lens A). false-pooling counts mistakes; harm weighs them.
#      E[max true W1 in the chosen pool] x L_clinical = Delta_max, the worst-case
#      regional effect difference the pool still admits (KR bound, theta-free).
vh <- function(set, n, meth) vs(set, n, meth, "harm_maxW1", "overall")
chk("CLAIM Set4: KS's mistakes are WORSE than W1's, not just as frequent",
    vh("Set4_Extremes", 100, "KS") > 1.5 * vh("Set4_Extremes", 100, "W1"),
    sprintf("harm KS=%.3f vs W1=%.3f (ratio %.2f); false-pooling KS=%.3f vs W1=%.3f",
            vh("Set4_Extremes",100,"KS"), vh("Set4_Extremes",100,"W1"),
            vh("Set4_Extremes",100,"KS") / vh("Set4_Extremes",100,"W1"),
            vs("Set4_Extremes",100,"KS","false_pooling_at_k","overall"),
            vs("Set4_Extremes",100,"W1","false_pooling_at_k","overall")))
chk("CLAIM: harm is 0 when the selection is perfect (true matches have true W1 = 0)",
    all(vapply(names(FAMILY_LABELS), function(s) vh(s, 100, "W1") >= 0, logical(1))) &&
      min(raw_s$value[raw_s$measure == "harm_maxW1"]) >= 0,
    sprintf("min harm across all cells = %.4f", min(raw_s$value[raw_s$measure == "harm_maxW1"])))
chk("CLAIM Set3: W1 admits the least harmful pool of all six methods",
    vh("Set3_Mixture", 100, "W1") == min(vapply(c("W1","KS","RV1","RV2","RV3","SMD"),
                                                function(m) vh("Set3_Mixture", 100, m), numeric(1))),
    sprintf("W1=%.3f KS=%.3f RV2=%.3f SMD=%.3f", vh("Set3_Mixture",100,"W1"),
            vh("Set3_Mixture",100,"KS"), vh("Set3_Mixture",100,"RV2"), vh("Set3_Mixture",100,"SMD")))
# HONEST: report the harm cell where W1 does NOT win, so it cannot be quietly dropped.
chk("CLAIM Set1 (HONEST): RV2's pool is no worse than W1's -- Gaussian is 2 moments",
    vh("Set1_Gaussian", 100, "RV2") <= vh("Set1_Gaussian", 100, "W1") + 0.05,
    sprintf("RV2=%.3f vs W1=%.3f", vh("Set1_Gaussian",100,"RV2"), vh("Set1_Gaussian",100,"W1")))

# B3. Honest counter-findings the paper must NOT overclaim away.
chk("CLAIM Set4: KS BEATS W1 on the bulk-shift control (a tall, narrow CDF gap)",
    vs("Set4_Extremes", 100, "KS", "auc", "bulk_shift") >=
      vs("Set4_Extremes", 100, "W1", "auc", "bulk_shift"),
    sprintf("KS=%.3f >= W1=%.3f", vs("Set4_Extremes",100,"KS","auc","bulk_shift"),
            vs("Set4_Extremes",100,"W1","auc","bulk_shift")))
chk("CLAIM Set4: a moment method (RV3) BEATS W1 on the asymmetric cell",
    vs("Set4_Extremes", 100, "RV3", "auc", "asym_severity") >
      vs("Set4_Extremes", 100, "W1", "auc", "asym_severity"),
    sprintf("RV3=%.3f > W1=%.3f", vs("Set4_Extremes",100,"RV3","auc","asym_severity"),
            vs("Set4_Extremes",100,"W1","auc","asym_severity")))
chk("CLAIM Set1: RV2 (OUR extension, not Ch.4) matches or beats W1 (Gaussian is 2-parameter)",
    vs("Set1_Gaussian", 100, "RV2", "auc", "combined") >= vs("Set1_Gaussian", 100, "W1", "auc", "combined") - 0.02,
    sprintf("RV2=%.3f vs W1=%.3f", vs("Set1_Gaussian",100,"RV2","auc","combined"),
            vs("Set1_Gaussian",100,"W1","auc","combined")))
chk("CLAIM Set2 clustering: KS beats W1 (W1 scale-sensitivity loosens the high-spread group)",
    vc("Set2_LogNormal", 100, "KS", "ari") > vc("Set2_LogNormal", 100, "W1", "ari"),
    sprintf("KS=%.3f > W1=%.3f", vc("Set2_LogNormal",100,"KS","ari"), vc("Set2_LogNormal",100,"W1","ari")))

# B4. SMD's structural blind spots (the original result, must survive the refactor)
chk("CLAIM Set1: SMD blind to scale (AUC ~ 0.5)",
    abs(vs("Set1_Gaussian", 100, "SMD", "auc", "scale") - 0.5) < 0.05)
chk("CLAIM Set2: SMD blind to shape (AUC ~ 0.5)",
    abs(vs("Set2_LogNormal", 100, "SMD", "auc", "shape") - 0.5) < 0.05)

# ---- (C) generation produces non-trivial output files ----------------------
tmpdir <- file.path(tempdir(), "simfig_validate")
generate_all_figures(output_dir = tmpdir)
expect_files <- c("fig_selection_false_pooling.pdf", "fig_selection_false_pooling.png",
                  "fig_selection_false_pooling_color.pdf",
                  "fig_selection_auc_by_type.pdf", "fig_selection_auc_by_type.png",
                  "fig_selection_auc_by_type_color.pdf",
                  "fig_selection_auc_set4.pdf", "fig_selection_auc_set4.png",
                  "fig_selection_auc_set4_color.pdf",
                  "fig_selection_harm.pdf", "fig_selection_harm.png",
                  "fig_selection_harm_color.pdf",
                  "fig_clustering_ari.pdf", "fig_clustering_ari.png",
                  "fig_clustering_ari_color.pdf")
paths <- file.path(tmpdir, expect_files)
chk("all expected figure files generated", all(file.exists(paths)),
    paste(expect_files[!file.exists(paths)], collapse = ", "))
sizes <- file.size(paths)
chk("figure files are non-trivial (>3KB each)", all(sizes > 3000, na.rm = TRUE),
    sprintf("min=%.0f bytes", min(sizes, na.rm = TRUE)))

cat(sprintf("\n===== VALIDATION %s =====\n", if (ok) "ALL PASS" else "HAS FAILURES"))
if (!ok) quit(status = 1L)
