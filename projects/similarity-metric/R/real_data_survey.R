# Real-data survey: W1 vs existing measures (SMD, KS) on region pairs.
# Protocol: PROTOCOL_real_data_survey.md (registered 2026-09-26). Run from the
# project root (projects/similarity-metric). Single writer of the three outputs below.
#   results/real_data_survey_pairs.csv
#   results/real_data_survey_summary.csv
#   results/real_data_survey.log

suppressPackageStartupMessages(library(parallel))

SEED  <- 2026L
B     <- 1000L
ALPHA <- 0.05
NMIN  <- 100L
SMD_NEGLIGIBLE <- 0.1

# Same exact CDF-area form as R/gusto_operability_check.R::compute_w1
compute_w1 <- function(x, y) {
  a <- sort(c(x, y)); n <- length(a); if (n < 2) return(0)
  Fx <- ecdf(x); Fy <- ecdf(y); m <- (a[-n] + a[-1]) / 2
  sum(abs(Fx(m) - Fy(m)) * diff(a))
}
compute_ks <- function(x, y) {
  z <- sort(unique(c(x, y)))
  max(abs(ecdf(x)(z) - ecdf(y)(z)))
}
compute_smd <- function(x, y) abs(mean(x) - mean(y)) / sqrt((var(x) + var(y)) / 2)

load_data <- function() {
  data(gusto, package = "predtools", envir = environment())
  ist3 <- read.csv("data/IST3/ist3_full_vars.csv", stringsAsFactors = FALSE)
  ist3 <- ist3[ist3$country != "OTHER", ]
  ist1 <- read.csv("data/IST/IST_corrected.csv", stringsAsFactors = FALSE)
  list(
    list(name = "GUSTO-I", df = gusto, grp = "regl",
         ems = c("age", "sysbp", "pulse", "height", "weight")),
    list(name = "IST-3", df = ist3, grp = "country",
         ems = c("age", "nihss", "treatdelay", "sbp", "weight")),
    list(name = "IST-1", df = ist1, grp = "COUNTRY",
         ems = c("AGE", "RSBP", "RDELAY")))
}

build_tasks <- function(sets) {
  tasks <- list(); k <- 0L
  for (s in sets) for (em in s$ems) {
    d <- s$df[!is.na(s$df[[em]]) & !is.na(s$df[[s$grp]]), c(s$grp, em)]
    tab <- table(d[[s$grp]]); keep <- sort(names(tab)[tab >= NMIN])
    sd_all <- sd(d[[em]][d[[s$grp]] %in% keep])
    pr <- combn(keep, 2)
    for (j in seq_len(ncol(pr))) {
      k <- k + 1L
      tasks[[k]] <- list(idx = k, data = s$name, em = em, sd_all = sd_all,
        g1 = pr[1, j], g2 = pr[2, j],
        x = as.numeric(d[[em]][d[[s$grp]] == pr[1, j]]),
        y = as.numeric(d[[em]][d[[s$grp]] == pr[2, j]]))
    }
  }
  tasks
}

run_pair <- function(t) {
  set.seed(SEED + t$idx)                       # per-pair stream: bit-reproducible
  pool <- c(t$x, t$y); n1 <- length(t$x); n2 <- length(t$y)
  nullv <- vapply(seq_len(B), function(b)
    compute_w1(sample(pool, n1, replace = TRUE), sample(pool, n2, replace = TRUE)), 0)
  w1 <- compute_w1(t$x, t$y); q <- unname(quantile(nullv, 1 - ALPHA))
  data.frame(data = t$data, em = t$em, region1 = t$g1, region2 = t$g2,
    n1 = n1, n2 = n2, w1 = w1, w1_sd = w1 / t$sd_all,
    smd = compute_smd(t$x, t$y), ks = compute_ks(t$x, t$y),
    sd_ratio = max(sd(t$x), sd(t$y)) / min(sd(t$x), sd(t$y)),
    null_q95 = q, resolved = w1 > q)
}

summarise_rows <- function(p) {
  do.call(rbind, lapply(split(p, list(p$data, p$em), drop = TRUE), function(r) {
    neg <- r$smd < SMD_NEGLIGIBLE
    data.frame(data = r$data[1], em = r$em[1],
      regions = length(unique(c(r$region1, r$region2))), pairs = nrow(r),
      spearman_w1_smd = cor(r$w1, r$smd, method = "spearman"),
      spearman_w1_ks = cor(r$w1, r$ks, method = "spearman"),
      smd_negl_w1_resolved = sum(neg & r$resolved),
      smd_negl_w1_unresolved = sum(neg & !r$resolved),
      max_sd_ratio = max(r$sd_ratio))
  }))
}

main <- function() {
  t0 <- Sys.time()
  tasks <- build_tasks(load_data())
  cl <- makeCluster(max(1L, detectCores() - 1L))
  on.exit(stopCluster(cl), add = TRUE)
  clusterExport(cl, c("compute_w1", "compute_ks", "compute_smd", "SEED", "B", "ALPHA"))
  pairs <- do.call(rbind, parLapply(cl, tasks, run_pair))   # fixed assignment
  ord <- c("GUSTO-I", "IST-3", "IST-1")
  pairs <- pairs[order(match(pairs$data, ord), pairs$em, pairs$region1, pairs$region2), ]
  summ <- summarise_rows(pairs)
  summ <- summ[order(match(summ$data, ord)), ]
  write.csv(pairs, "results/real_data_survey_pairs.csv", row.names = FALSE)
  write.csv(summ, "results/real_data_survey_summary.csv", row.names = FALSE)
  lg <- file("results/real_data_survey.log", open = "wt"); on.exit(close(lg), add = TRUE)
  writeLines(c(sprintf("Real-data survey | seed %d (per pair: seed + index) | B = %d | alpha = %.2f | n_min = %d",
                       SEED, B, ALPHA, NMIN),
               sprintf("pairs: %d | run time: %.1f min", nrow(pairs),
                       as.numeric(difftime(Sys.time(), t0, units = "mins")))), lg)
  writeLines(capture.output(print(summ, row.names = FALSE, digits = 3)), lg)
  writeLines(capture.output(sessionInfo()), lg)
  print(summ, row.names = FALSE, digits = 3)
}

if (sys.nframe() == 0L) main()
