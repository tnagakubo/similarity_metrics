# =============================================================================
# Validation for figures_selection.R — confirms the figures plot exactly the
# numbers in results/selection_sim_summary.csv (not a mis-joined / stale view).
# Any FAIL blocks shipping the figures.
# =============================================================================
.cands <- c(
  tryCatch(file.path(dirname(sys.frame(1)$ofile), "figures_selection.R"), error = function(e) NA_character_),
  "R/figures_selection.R", "figures_selection.R",
  "projects/similarity-metric/R/figures_selection.R")
src <- .cands[!is.na(.cands) & file.exists(.cands)][1]
if (is.na(src)) stop("cannot locate figures_selection.R (cwd=", getwd(), ")")
source(src, chdir = TRUE)   # exposes load_selection / fig_* ; main() guarded off
suppressPackageStartupMessages(library(ggplot2))

ok <- TRUE
chk <- function(name, cond, detail = "") {
  cat(sprintf("[%s] %s%s\n", if (isTRUE(cond)) "PASS" else "FAIL", name,
              if (nzchar(detail)) paste0("  -- ", detail) else "")); if (!isTRUE(cond)) ok <<- FALSE
}
approx <- function(a, b, tol = 1e-9) all(abs(a - b) <= tol)

# independent raw read
SUMMARY_CSV <- resolve_summary_csv()
chk("summary CSV located", !is.na(SUMMARY_CSV), SUMMARY_CSV)
raw <- read.csv(SUMMARY_CSV, stringsAsFactors = FALSE)
df  <- load_selection()

# 1. load_selection preserves every value/row from the CSV -------------------
chk("row count preserved", nrow(df) == nrow(raw), sprintf("%d vs %d", nrow(df), nrow(raw)))
chk("no NA values after load", all(!is.na(df$value)))
# key/value equality independent of row order
key <- function(d) paste(d$set, d$n, d$method, d$measure, d$type, sep="|")
m <- match(key(raw), key(df))
chk("every CSV row present with identical value", all(!is.na(m)) && approx(raw$value, df$value[m]))
chk("mc_se preserved", approx(raw$mc_se, df$mc_se[m]))

# 2. spot-check specific headline values -------------------------------------
val <- function(set,n,meth,meas,ty) raw$value[raw$set==set & raw$n==n & raw$method==meth &
                                               raw$measure==meas & raw$type==ty]
chk("spot: Set1 n=100 W1 false-pool = 0.0852", approx(val("Set1_Gaussian",100,"W1","false_pooling_at_k","overall"), 0.0852, 1e-6))
chk("spot: Set1 n=100 SMD scale-AUC ~ 0.499 (blind)", abs(val("Set1_Gaussian",100,"SMD","auc","scale") - 0.4988) < 1e-3)
chk("spot: Set2 n=100 SMD_log shape-AUC ~ 0.801 (partial)", abs(val("Set2_LogNormal",100,"SMD_log","auc","shape") - 0.8010) < 1e-3)
chk("spot: Set2 n=25 SMD false-pool = 0.9761", approx(val("Set2_LogNormal",25,"SMD","false_pooling_at_k","overall"), 0.9761, 1e-6))

# 3. figures plot EXACTLY the CSV numbers (via ggplot_build) ------------------
# helper: return the point-layer y-values (layer whose row count matches data)
point_y <- function(p, n_expect) {
  b <- ggplot_build(p)$data
  hit <- Filter(function(L) nrow(L) == n_expect && "shape" %in% names(L), b)
  if (!length(hit)) hit <- Filter(function(L) nrow(L) == n_expect, b)
  hit[[1]]$y
}
fp_csv  <- raw$value[raw$measure == "false_pooling_at_k"]
p1 <- fig_false_pooling(df, "greyscale")
chk("fig1 point y-values == CSV false-pooling (multiset)",
    approx(sort(point_y(p1, length(fp_csv))), sort(fp_csv)),
    sprintf("%d points", length(fp_csv)))

auc_csv <- raw$value[raw$measure == "auc"]
p2 <- fig_auc_by_type(df, "greyscale")
chk("fig2 point y-values == CSV auc (multiset)",
    approx(sort(point_y(p2, length(auc_csv))), sort(auc_csv)),
    sprintf("%d points", length(auc_csv)))

# 4. no data dropped in fig2 facet mapping (all auc rows keep a facet) --------
d2 <- subset(df, measure == "auc")
chk("fig2 maps every auc row to a facet (no NA facet)",
    { dd <- d2; dd$fk <- paste(dd$set, dd$type, sep="|")
      all(dd$fk %in% c("Set1_Gaussian|location","Set1_Gaussian|scale","Set1_Gaussian|combined",
                       "Set2_LogNormal|location","Set2_LogNormal|shape","Set2_LogNormal|combined")) })

# 5. method factor levels / colour keys consistent ---------------------------
chk("method levels = {W1,KS,SMD_log,SMD}", identical(levels(df$method), c("W1","KS","SMD_log","SMD")))
pal <- .pal("greyscale")
chk("palette keys cover all methods", all(levels(df$method) %in% names(pal$color)) &&
    all(levels(df$method) %in% names(pal$linetype)) && all(levels(df$method) %in% names(pal$shape)))

# 6. generation produces non-trivial output files ----------------------------
tmpdir <- file.path(tempdir(), "selfig_validate")
generate_selection_figures(output_dir = tmpdir)
expect_files <- c("fig_selection_false_pooling.pdf","fig_selection_false_pooling.png",
                  "fig_selection_false_pooling_color.pdf","fig_selection_auc_by_type.pdf",
                  "fig_selection_auc_by_type.png","fig_selection_auc_by_type_color.pdf")
sizes <- file.size(file.path(tmpdir, expect_files))
chk("all expected figure files generated", all(file.exists(file.path(tmpdir, expect_files))))
chk("figure files are non-trivial (>3KB each)", all(sizes > 3000, na.rm = TRUE),
    sprintf("min=%.0f bytes", min(sizes, na.rm = TRUE)))

cat(sprintf("\n===== FIGURE VALIDATION %s =====\n", if (ok) "ALL PASS" else "HAS FAILURES"))
if (!ok) quit(status = 1L)
