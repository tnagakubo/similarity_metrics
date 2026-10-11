# =============================================================================
# GUSTO-I: average-linkage clustering of the 16 regions on the W1 distance
# matrix, per candidate effect modifier (age, SBP). Registered in
# PROTOCOL_silhouette_extension.md (2026-09-27) before the extension run.
#
# Same code path as the simulation: pick_k_silhouette() and avg_silhouette()
# are sourced from R/clustering_nok_simulation.R (not copied). W1 is the exact
# CDF-area compute_w1() sourced from R/gusto_operability_check.R, because the
# GUSTO-I regions have unequal n (selection_simulation.R's w1_dist truncates).
#
# Branch (PROTOCOL section 3), passed as --branch=cut or --branch=nocut:
#   cut   : report k-hat, silhouette at k-hat and the partition
#   nocut : report the dendrogram merge heights only (no partition)
# The silhouette values are computed in both branches (they are the input the
# criterion was about) but the partition is written only under --branch=cut.
#
# Outputs: results/gusto_w1_clustering.csv, results/gusto_w1_clustering.log,
#          figures/fig_gusto_dendrogram.pdf (7" wide, greyscale #1A1A1A)
# No random numbers are drawn (W1 on the full data; hclust is deterministic).
# =============================================================================
args   <- commandArgs(trailingOnly = TRUE)
BRANCH <- sub("^--branch=", "", args[grepl("^--branch=", args)])
stopifnot(length(BRANCH) == 1, BRANCH %in% c("cut", "nocut"))

source("R/clustering_nok_simulation.R")          # pick_k_silhouette, avg_silhouette, K_MAX
ops <- new.env(); sys.source("R/gusto_operability_check.R", envir = ops)
compute_w1 <- ops$compute_w1
stopifnot(exists("pick_k_silhouette"), exists("avg_silhouette"), K_MAX == 6L)

data(gusto, package = "predtools", envir = environment())
regs <- sort(unique(gusto$regl)); lab <- paste0("R", regs)
EMS  <- c(age = "age", sysbp = "sysbp")

log_lines <- character(0)
say <- function(fmt, ...) { s <- sprintf(fmt, ...); cat(s, "\n", sep = ""); log_lines <<- c(log_lines, s) }
say("== GUSTO-I W1 clustering (branch = %s) ==", BRANCH)

rows <- list(); hcs <- list()
for (em in names(EMS)) {
  x <- lapply(regs, function(r) { v <- gusto[[EMS[em]]][gusto$regl == r]; v[!is.na(v)] })
  D <- matrix(0, length(regs), length(regs), dimnames = list(lab, lab))
  for (i in seq_along(regs)) for (j in seq_along(regs)) if (i < j)
    D[i, j] <- D[j, i] <- compute_w1(x[[i]], x[[j]])
  hc <- hclust(as.dist(D), method = "average"); hcs[[em]] <- hc
  ks <- 2:min(K_MAX, nrow(D) - 1L)
  sw <- vapply(ks, function(k) avg_silhouette(D, cutree(hc, k = k)), numeric(1))
  pk <- pick_k_silhouette(D)
  say("\n-- %s --", em)
  say("average silhouette by k: %s", paste(sprintf("k=%d:%.3f", ks, sw), collapse = "  "))
  say("merge heights: %s", paste(sprintf("%.3f", hc$height), collapse = " "))
  if (BRANCH == "cut") {
    say("k-hat = %d; R8's group: %s", pk$k, paste(lab[pk$cl == pk$cl[lab == "R8"]], collapse = " "))
    for (g in sort(unique(pk$cl))) say("  cluster %d: %s", g, paste(lab[pk$cl == g], collapse = " "))
    rows[[em]] <- data.frame(em = em, region = lab, cluster = unname(pk$cl), k_hat = pk$k,
                             sil_at_k_hat = max(sw), stringsAsFactors = FALSE)
  } else {
    rows[[em]] <- data.frame(em = em, merge_step = seq_along(hc$height), height = hc$height,
                             stringsAsFactors = FALSE)
  }
}
out <- do.call(rbind, rows)
write.csv(out, "results/gusto_w1_clustering.csv", row.names = FALSE)
writeLines(log_lines, "results/gusto_w1_clustering.log")

# ---- figure: per-EM dendrograms ---------------------------------------------
pdf("figures/fig_gusto_dendrogram.pdf", width = 7, height = 3.6, bg = "white")
op <- par(mfrow = c(1, 2), mar = c(3.2, 3.6, 2, 0.5), mgp = c(2.2, 0.7, 0), cex = 0.8,
          col = "#1A1A1A", col.axis = "#1A1A1A", col.lab = "#1A1A1A", col.main = "#1A1A1A")
for (em in names(EMS)) {
  hc <- hcs[[em]]; hc$labels <- lab
  plot(hc, main = c(age = "(A) Age", sysbp = "(B) Systolic blood pressure")[em], xlab = "", sub = "",
       ylab = c(age = "W1 (years)", sysbp = "W1 (mmHg)")[em], hang = -1)
  if (BRANCH == "cut") {
    k <- unique(out$k_hat[out$em == em]); rect.hclust(hc, k = k, border = "#1A1A1A")
  }
}
par(op); invisible(dev.off())
say("\n[save] results/gusto_w1_clustering.{csv,log}, figures/fig_gusto_dendrogram.pdf")
writeLines(log_lines, "results/gusto_w1_clustering.log")
