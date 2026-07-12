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
chk("selection: all 3 sets present", setequal(unique(sel$set), names(FAMILY_LABELS)),
    paste(sort(unique(sel$set)), collapse = ", "))
chk("clustering: all 3 sets present", setequal(unique(clu$set), names(FAMILY_LABELS)))
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
fp_csv  <- raw_s$value[raw_s$measure == "false_pooling_at_k"]
auc_csv <- raw_s$value[raw_s$measure == "auc"]
ari_csv <- raw_c$value[raw_c$measure == "ari"]
chk("fig1 (false-pooling) point y == CSV (multiset)",
    approx(sort(point_y(fig_false_pooling(sel, "greyscale"), length(fp_csv))), sort(fp_csv)),
    sprintf("%d points", length(fp_csv)))
chk("fig2 (AUC) point y == CSV (multiset)",
    approx(sort(point_y(fig_auc_by_type(sel, "greyscale"), length(auc_csv))), sort(auc_csv)),
    sprintf("%d points", length(auc_csv)))
chk("fig3 (ARI) point y == CSV (multiset)",
    approx(sort(point_y(fig_clustering_ari(clu, "greyscale"), length(ari_csv))), sort(ari_csv)),
    sprintf("%d points", length(ari_csv)))

# A4. no AUC row falls outside the 9 declared facets
facet_ok <- c("Set1_Gaussian|location",  "Set1_Gaussian|scale",     "Set1_Gaussian|combined",
              "Set2_LogNormal|location", "Set2_LogNormal|shape",    "Set2_LogNormal|combined",
              "Set3_Mixture|shape_sym",  "Set3_Mixture|shape_skew", "Set3_Mixture|combined")
d2 <- subset(raw_s, measure == "auc")
chk("fig2 maps every AUC row to a declared facet",
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

# B3. Honest counter-findings the paper must NOT overclaim away.
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
