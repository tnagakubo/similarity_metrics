# =============================================================================
# Required sample size per region — how much data before pooled-region formation
# (Part 2, clustering) and pooling-partner selection (Part 1) become reliable?
#
# Reads the production grid (n = 25..100) and the extension grid (n = 150..2000)
# and reports, for each scenario set and method, the smallest n at which the
# performance measure first reaches a pre-specified threshold.
#
# Two distinctions the table is built to expose, because they are different
# findings and the manuscript must not conflate them:
#
#   BLIND       the curve plateaus below the threshold and stays there out to
#               n = 2000. More data does not help; the population distance
#               carries no information about the structure. Reported as "blind".
#   UNDERPOWERED the curve is still climbing and crosses the threshold at some
#               finite n. Reported as that n.
#
# A method that never crosses but is still rising at n = 2000 is reported as
# ">2000", NOT as blind -- we did not measure far enough to tell.
#
# Thresholds are pre-specified (Tak, 2026-07-20): ARI 0.7 / 0.8 / 0.9 for
# clustering; AUC 0.8 / 0.9 / 0.95 for selection. Reporting three levels rather
# than one avoids resting the required-n claim on a single arbitrary cut.
#
# Outputs:
#   results/required_n_clustering.csv
#   results/required_n_selection.csv
#   results/required_n.log
# =============================================================================

suppressWarnings(RNGkind("Mersenne-Twister", "Inversion", "Rejection"))

ARI_CUTS <- c(0.7, 0.8, 0.9)
AUC_CUTS <- c(0.80, 0.90, 0.95)
N_MAX    <- 2000L
# A curve counts as plateaued if its last three points span less than this and
# it sits below the threshold: more n is demonstrably not buying recovery.
PLATEAU_SPAN <- 0.02

.dir <- function() {
  f <- NULL
  for (fr in rev(sys.frames())) if (!is.null(fr$ofile)) { f <- fr$ofile; break }
  if (is.null(f)) { a <- commandArgs(FALSE); fa <- sub("^--file=", "", a[grepl("^--file=", a)])
                    if (length(fa)) f <- fa[1] }
  if (is.null(f)) "." else dirname(normalizePath(f, mustWork = FALSE))
}
.find <- function(b) {
  p <- c(file.path("results", b), file.path("../results", b), file.path(.dir(), "..", "results", b))
  p <- p[file.exists(p)]
  if (!length(p)) stop(b, " not found", call. = FALSE)
  p[1]
}
.results <- function() dirname(.find("clustering_sim_summary.csv"))

# ---- load and splice the two grids ------------------------------------------
# The production and extension runs use disjoint n grids and disjoint seed
# streams, so they concatenate without overlap. Assert that, rather than assume.
load_grid <- function(prod_file, ext_file, measure_keep) {
  prod <- read.csv(.find(prod_file), stringsAsFactors = FALSE)
  ext  <- read.csv(.find(ext_file),  stringsAsFactors = FALSE)
  common <- intersect(unique(prod$n), unique(ext$n))
  if (length(common))
    stop(sprintf("production and extension grids overlap at n = %s -- refusing to splice",
                 paste(common, collapse = ", ")), call. = FALSE)
  d <- rbind(prod[, names(ext)], ext)
  d <- d[d$measure %in% measure_keep, , drop = FALSE]
  d <- unique(d)
  d[order(d$set, d$method, d$n), ]
}

# ---- required n for one curve -----------------------------------------------
# Linear interpolation on log(n): sample-size requirements are multiplicative,
# so interpolating on the log scale is the honest reading of a coarse grid.
# Returned n is rounded UP to the next whole patient -- a required sample size
# must not be rounded down.
required_n <- function(n, v, cut) {
  stopifnot(length(n) == length(v), !is.unsorted(n))
  if (any(v >= cut)) {
    i <- which(v >= cut)[1]
    if (i == 1L) return(list(n = n[1], note = sprintf("<=%d", n[1])))
    x0 <- log(n[i-1]); x1 <- log(n[i]); y0 <- v[i-1]; y1 <- v[i]
    nn <- if (y1 == y0) n[i] else exp(x0 + (cut - y0) * (x1 - x0) / (y1 - y0))
    return(list(n = ceiling(nn), note = ""))
  }
  # never reached: distinguish a plateau (blind) from a slow climb (unmeasured)
  tail_v <- tail(v, 3)
  span <- max(tail_v) - min(tail_v)
  if (length(v) >= 3 && span < PLATEAU_SPAN)
    list(n = NA_real_, note = sprintf("blind (plateau %.3f)", mean(tail_v)))
  else
    list(n = NA_real_, note = sprintf(">%d (still rising, %.3f at n=%d)", N_MAX, tail(v,1), tail(n,1)))
}

build_table <- function(d, cuts, value_label) {
  keys <- unique(d[, c("set", "method")])
  out <- list()
  for (i in seq_len(nrow(keys))) {
    s <- keys$set[i]; m <- keys$method[i]
    sub <- d[d$set == s & d$method == m, ]
    sub <- sub[order(sub$n), ]
    for (cut in cuts) {
      r <- required_n(sub$n, sub$value, cut)
      out[[length(out)+1]] <- data.frame(
        set = s, method = m, threshold = cut,
        required_n = r$n, note = r$note,
        max_value = round(max(sub$value), 4),
        value_at_2000 = round(sub$value[sub$n == max(sub$n)][1], 4),
        stringsAsFactors = FALSE)
    }
  }
  res <- do.call(rbind, out)
  names(res)[names(res) == "max_value"] <- paste0("max_", value_label)
  res
}

# ---- task floor: the best ANY method achieves --------------------------------
# Tak's reframe (2026-07-20): a low number for W1 alone reads as a W1 defect.
# The question that matters is whether the TASK is solvable at that n by any
# metric. The achieving method is carried along -- it changes with n, and
# omitting it would look like cherry-picking (Louis, same day).
task_floor <- function(d, cuts) {
  out <- list()
  for (s in unique(d$set)) {
    sub <- d[d$set == s, ]
    ns <- sort(unique(sub$n))
    best <- vapply(ns, function(nn) max(sub$value[sub$n == nn]), numeric(1))
    who  <- vapply(ns, function(nn) {
      z <- sub[sub$n == nn, ]; z$method[which.max(z$value)] }, character(1))
    for (cut in cuts) {
      r <- required_n(ns, best, cut)
      # which method is achieving the floor at (or nearest above) the crossing
      j <- if (is.na(r$n)) length(ns) else which(ns >= r$n)[1]
      if (is.na(j)) j <- length(ns)
      out[[length(out)+1]] <- data.frame(
        set = s, threshold = cut, required_n = r$n, note = r$note,
        achieved_by = who[j], best_at_2000 = round(tail(best,1), 4),
        stringsAsFactors = FALSE)
    }
  }
  do.call(rbind, out)
}

main <- function() {
  rd <- .results()
  logcon <- file(file.path(rd, "required_n.log"), open = "wt")
  on.exit(close(logcon), add = TRUE)
  say <- function(...) { m <- sprintf(...); cat(m, "\n"); writeLines(m, logcon) }

  say("== Required sample size per region ==")
  say("started=%s  R=%s", format(Sys.time()), R.version.string)
  say("ARI cuts: %s | AUC cuts: %s | grid max n = %d",
      paste(ARI_CUTS, collapse=", "), paste(AUC_CUTS, collapse=", "), N_MAX)

  # ---------------- clustering (Part 2) ----------------
  cl <- load_grid("clustering_sim_summary.csv", "clustering_sim_summary_ext.csv", "ari")
  say("\n[clustering] %d rows, n grid = %s", nrow(cl), paste(sort(unique(cl$n)), collapse=","))
  cl_tab <- build_table(cl, ARI_CUTS, "ari")
  cl_flr <- task_floor(cl, ARI_CUTS)
  write.csv(cl_tab, file.path(rd, "required_n_clustering.csv"), row.names = FALSE)
  write.csv(cl_flr, file.path(rd, "required_n_clustering_floor.csv"), row.names = FALSE)

  say("\n-- clustering: required n for ARI >= 0.8 (per method) --")
  z <- cl_tab[cl_tab$threshold == 0.8, ]
  say(paste(capture.output(print(z[, c("set","method","required_n","note")], row.names = FALSE)),
            collapse = "\n"))
  say("\n-- clustering: TASK FLOOR (best across all methods) --")
  say(paste(capture.output(print(cl_flr, row.names = FALSE)), collapse = "\n"))

  # ---------------- selection (Part 1) ----------------
  se <- load_grid("selection_sim_summary.csv", "selection_sim_summary_ext.csv", "auc")
  # AUC is reported per discordance type; the combined type is the headline.
  se$key <- paste(se$set, se$type, sep = " / ")
  se2 <- data.frame(set = se$key, method = se$method, n = se$n, value = se$value,
                    measure = se$measure, stringsAsFactors = FALSE)
  say("\n[selection] %d rows over %d set/type cells", nrow(se2), length(unique(se2$set)))
  se_tab <- build_table(se2, AUC_CUTS, "auc")
  se_flr <- task_floor(se2, AUC_CUTS)
  write.csv(se_tab, file.path(rd, "required_n_selection.csv"), row.names = FALSE)
  write.csv(se_flr, file.path(rd, "required_n_selection_floor.csv"), row.names = FALSE)

  say("\n-- selection: required n for AUC >= 0.9, W1 vs KS --")
  z <- se_tab[se_tab$threshold == 0.9 & se_tab$method %in% c("W1","KS"), ]
  say(paste(capture.output(print(z[, c("set","method","required_n","note")], row.names = FALSE)),
            collapse = "\n"))

  # ---------------- the blind / underpowered split ----------------
  say("\n-- BLIND methods (plateau below every threshold, out to n=2000) --")
  b <- cl_tab[cl_tab$threshold == 0.9 & grepl("^blind", cl_tab$note), ]
  say(paste(capture.output(print(b[, c("set","method","note")], row.names = FALSE)), collapse="\n"))

  say("\n[save] results/required_n_{clustering,selection}[_floor].csv")
  say("[done] finished=%s", format(Sys.time()))
  invisible(list(clustering = cl_tab, selection = se_tab,
                 cl_floor = cl_flr, se_floor = se_flr))
}

if (sys.nframe() == 0L) main()
