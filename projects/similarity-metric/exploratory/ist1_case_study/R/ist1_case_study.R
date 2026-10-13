# EXPLORATORY — exploratory/ist1_case_study (not pre-registered; see README.md). Not cited by the manuscript.
# IST-1 application with the manuscript's section 4 procedure. Functions copied verbatim from
# R/gusto_operability_check.R, R/fig3_w1_axis.R, R/gusto_rank_intervals.R, R/application_all_methods.R.
# Project-relative paths; seed declared; sessionInfo saved.
suppressWarnings(RNGkind("Mersenne-Twister", "Inversion", "Rejection"))
SEED <- 20261012L
args <- commandArgs(trailingOnly = FALSE)
script <- sub("^--file=", "", grep("^--file=", args, value = TRUE))
here <- normalizePath(file.path(dirname(script), ".."))
proj <- normalizePath(file.path(here, "..", ".."))
IN   <- file.path(proj, "data", "IST", "IST_corrected.csv")
RES  <- file.path(here, "results"); FIG <- file.path(here, "figures")
dir.create(RES, showWarnings = FALSE); dir.create(FIG, showWarnings = FALSE)
ALPHA <- 0.05; DELTA_CLIN <- 0.01
ANCHORS <- list(USA  = list(B_ci = 2000L, B_null = 2000L, B_rank = 1000L),
                JAPA = list(B_ci = 500L,  B_null = 500L,  B_rank = 0L),
                UK   = list(B_ci = 500L,  B_null = 500L,  B_rank = 0L))
EMS  <- c(age = "AGE", sbp = "RSBP", delay = "RDELAY")
UNIT <- c(age = "years", sbp = "mmHg", delay = "hours")

compute_w1 <- function(x, y) {   # verbatim from R/fig3_w1_axis.R
  all_vals <- sort(c(x, y)); n <- length(all_vals); if (n < 2) return(0)
  Fx <- ecdf(x); Fy <- ecdf(y)
  mids <- (all_vals[-n] + all_vals[-1]) / 2; diffs <- diff(all_vals)
  sum(abs(Fx(mids) - Fy(mids)) * diffs)
}
null_floor <- function(src, n1, n2, B, alpha) {   # verbatim from R/gusto_operability_check.R
  v <- numeric(B)
  for (b in seq_len(B)) v[b] <- compute_w1(sample(src, n1, replace = TRUE), sample(src, n2, replace = TRUE))
  c(mean = mean(v), q = unname(quantile(v, 1 - alpha, names = FALSE)))
}
w1_bootstrap_ci <- function(x, y, B, conf = 0.95) {   # percentile, as R/fig3_w1_axis.R
  est <- compute_w1(x, y); bv <- numeric(B)
  for (b in seq_len(B)) bv[b] <- compute_w1(sample(x, length(x), replace = TRUE), sample(y, length(y), replace = TRUE))
  a <- 1 - conf; ci <- quantile(bv, c(a / 2, 1 - a / 2), names = FALSE)
  list(estimate = est, lower = ci[1], upper = ci[2], se = sd(bv))
}
smd_s <- function(sx, sy) {   # verbatim from R/application_all_methods.R
  n1 <- length(sx); n2 <- length(sy)
  sp <- sqrt(((n1 - 1) * var(sx) + (n2 - 1) * var(sy)) / (n1 + n2 - 2))
  abs(mean(sx) - mean(sy)) / sp
}

d <- read.csv(IN, stringsAsFactors = FALSE)
stopifnot(all(EMS %in% names(d)), "COUNTRY" %in% names(d))
nc <- sort(table(d$COUNTRY), decreasing = TRUE)
write.csv(data.frame(country = names(nc), n = as.integer(nc)), file.path(RES, "ist1_country_n.csv"), row.names = FALSE)
set.seed(SEED)
md <- c("# IST-1 exploratory application - script-written summary (no number typed)", "",
        sprintf("seed %d; alpha %.2f one-sided; Delta_clin %.2f; N = %d; countries = %d", SEED, ALPHA, DELTA_CLIN, nrow(d), length(nc)), "")

for (A in names(ANCHORS)) {
  cfg <- ANCHORS[[A]]; partners <- setdiff(names(nc), A)
  rows <- list()
  for (v in names(EMS)) {
    xa <- d[[EMS[[v]]]][d$COUNTRY == A]
    for (p in partners) {
      xp <- d[[EMS[[v]]]][d$COUNTRY == p]
      ci <- w1_bootstrap_ci(xa, xp, cfg$B_ci)
      nf <- null_floor(xa, length(xa), length(xp), cfg$B_null, ALPHA)
      rows[[length(rows) + 1]] <- data.frame(anchor = A, partner = p, em = v, n_anchor = length(xa), n_partner = length(xp),
        W1 = ci$estimate, ci_lower = ci$lower, ci_upper = ci$upper, se = ci$se,
        null_mean = nf[["mean"]], null_q95 = nf[["q"]], resolved = ci$estimate > nf[["q"]],
        smd = smd_s(xa, xp), sd_ratio = sd(xp) / sd(xa),
        lstar = DELTA_CLIN / ci$estimate, lstar_lower = DELTA_CLIN / ci$upper, lstar_upper = DELTA_CLIN / ci$lower)
    }
    cat(sprintf("anchor %s em %s done\n", A, v))
  }
  pp <- do.call(rbind, rows)
  pp$rank <- ave(pp$W1, pp$em, FUN = rank)
  write.csv(pp, file.path(RES, sprintf("ist1_%s_w1_per_pair.csv", A)), row.names = FALSE)

  md <- c(md, sprintf("## Anchor %s (n = %d; partners %d; B_ci %d, B_null %d, B_rank %d)", A, sum(d$COUNTRY == A), length(partners), cfg$B_ci, cfg$B_null, cfg$B_rank), "",
          "| EM | resolved / partners | median W1 | min-max W1 | median CI width | median null q95 | sd ratio range |", "|---|---|---|---|---|---|---|")
  for (v in names(EMS)) { s <- pp[pp$em == v, ]
    md <- c(md, sprintf("| %s (%s) | %d / %d | %.2f | %.2f-%.2f | %.2f | %.2f | %.2f-%.2f |", v, UNIT[[v]], sum(s$resolved), nrow(s), median(s$W1), min(s$W1), max(s$W1), median(s$ci_upper - s$ci_lower), median(s$null_q95), min(s$sd_ratio), max(s$sd_ratio))) }
  res_all  <- Reduce(intersect, lapply(names(EMS), function(v) pp$partner[pp$em == v & pp$resolved]))
  res_none <- Reduce(intersect, lapply(names(EMS), function(v) pp$partner[pp$em == v & !pp$resolved]))
  md <- c(md, "", sprintf("Partners resolved on all three EMs (%d): %s", length(res_all), paste(res_all, collapse = ", ")),
          sprintf("Partners resolved on none (%d): %s", length(res_none), paste(res_none, collapse = ", ")), "")

  if (cfg$B_rank > 0) {
    idx <- split(seq_len(nrow(d)), d$COUNTRY)
    RK <- array(NA_real_, c(cfg$B_rank, length(partners), length(EMS)), dimnames = list(NULL, partners, names(EMS)))
    rho_ws_b <- matrix(NA_real_, cfg$B_rank, length(EMS), dimnames = list(NULL, names(EMS)))
    for (b in seq_len(cfg$B_rank)) {
      ii <- lapply(idx, function(i) i[sample.int(length(i), length(i), replace = TRUE)])
      for (v in names(EMS)) {
        xa <- d[[EMS[[v]]]][ii[[A]]]
        w <- vapply(partners, function(p) compute_w1(xa, d[[EMS[[v]]]][ii[[p]]]), 0)
        RK[b, , v] <- rank(w)
        sm <- vapply(partners, function(p) smd_s(xa, d[[EMS[[v]]]][ii[[p]]]), 0)
        rho_ws_b[b, v] <- suppressWarnings(cor(w, sm, method = "spearman"))
      }
    }
    cat(sprintf("anchor %s rank bootstrap done\n", A))
    rk <- do.call(rbind, lapply(names(EMS), function(v) {
      q <- t(apply(RK[, , v], 2, quantile, probs = c(0.025, 0.975), type = 1, names = FALSE))
      s <- pp[pp$em == v, ]
      data.frame(partner = partners, em = v, rank_obs = s$rank[match(partners, s$partner)],
                 rank_lo = as.integer(q[, 1]), rank_hi = as.integer(q[, 2]))
    }))
    write.csv(rk, file.path(RES, sprintf("ist1_%s_rank_intervals.csv", A)), row.names = FALSE)
    pairs <- combn(names(EMS), 2)
    sp <- do.call(rbind, lapply(seq_len(ncol(pairs)), function(k) {
      u <- pairs[1, k]; w <- pairs[2, k]
      su <- pp[pp$em == u, ]; sw <- pp[pp$em == w, ]
      obs <- cor(su$W1, sw$W1[match(su$partner, sw$partner)], method = "spearman")
      rb <- vapply(seq_len(cfg$B_rank), function(b) cor(RK[b, , u], RK[b, , w], method = "spearman"), 0)
      data.frame(em1 = u, em2 = w, rho_obs = obs, rho_lo = quantile(rb, 0.025, type = 1, names = FALSE),
                 rho_hi = quantile(rb, 0.975, type = 1, names = FALSE), B = cfg$B_rank)
    }))
    ws <- data.frame(em = names(EMS),
                     rho_w1_smd_obs = sapply(names(EMS), function(v) cor(pp$W1[pp$em == v], pp$smd[pp$em == v], method = "spearman")),
                     rho_lo = apply(rho_ws_b, 2, quantile, 0.025, type = 1, na.rm = TRUE),
                     rho_hi = apply(rho_ws_b, 2, quantile, 0.975, type = 1, na.rm = TRUE))
    write.csv(sp, file.path(RES, sprintf("ist1_%s_rank_spearman_boot.csv", A)), row.names = FALSE)
    write.csv(ws, file.path(RES, sprintf("ist1_%s_w1_vs_smd.csv", A)), row.names = FALSE)

    png(file.path(FIG, sprintf("ist1_%s_forest.png", A)), width = 7, height = 9, units = "in", res = 200, bg = "white")
    par(mfrow = c(1, 3), mar = c(4, 7, 3, 1))
    for (v in names(EMS)) {
      s <- pp[pp$em == v, ]; s <- s[order(s$W1), ]
      plot(s$W1, seq_len(nrow(s)), xlim = c(0, max(s$ci_upper)), yaxt = "n", pch = ifelse(s$resolved, 16, 1), col = "#1A1A1A",
           xlab = sprintf("W1 (%s)", UNIT[[v]]), ylab = "", main = sprintf("%s - anchor %s", v, A), cex.main = 1)
      segments(s$ci_lower, seq_len(nrow(s)), s$ci_upper, seq_len(nrow(s)), col = "#1A1A1A")
      abline(v = median(s$null_q95), lty = 3, col = "#1A1A1A")
      axis(2, at = seq_len(nrow(s)), labels = sprintf("%s (%d)", s$partner, s$n_partner), las = 1, cex.axis = 0.6)
    }
    dev.off()

    md <- c(md, "Spearman between EM orderings (patient bootstrap interval):",
            sprintf("- %s vs %s: %.2f [%.2f, %.2f]", sp$em1, sp$em2, sp$rho_obs, sp$rho_lo, sp$rho_hi), "",
            "Spearman W1 vs |SMD| per EM:", sprintf("- %s: %.2f [%.2f, %.2f]", ws$em, ws$rho_w1_smd_obs, ws$rho_lo, ws$rho_hi), "",
            sprintf("Mean rank-interval width (hi - lo): %s",
                    paste(sprintf("%s %.1f", names(EMS), sapply(names(EMS), function(v) mean(rk$rank_hi[rk$em == v] - rk$rank_lo[rk$em == v]))), collapse = "; ")), "",
            "Top-5 closest partners by W1 per EM (n, W1, CI; unresolved flagged):")
    for (v in names(EMS)) { s <- pp[pp$em == v, ]; s <- s[order(s$W1), ][1:5, ]
      md <- c(md, sprintf("- %s: %s", v, paste(sprintf("%s n=%d W1=%.2f [%.2f, %.2f]%s", s$partner, s$n_partner, s$W1, s$ci_lower, s$ci_upper, ifelse(s$resolved, "", " (unresolved)")), collapse = "; "))) }
    md <- c(md, "", "Top-5 most distant partners by W1 per EM:")
    for (v in names(EMS)) { s <- pp[pp$em == v, ]; s <- s[order(-s$W1), ][1:5, ]
      md <- c(md, sprintf("- %s: %s", v, paste(sprintf("%s n=%d W1=%.2f [%.2f, %.2f]", s$partner, s$n_partner, s$W1, s$ci_lower, s$ci_upper), collapse = "; "))) }
    md <- c(md, "")
  }
}

# GUSTO descriptors on the same footing (read-only from canonical CSVs)
g_pp <- read.csv(file.path(proj, "results", "gusto_r8_w1_per_pair.csv")); g_op <- read.csv(file.path(proj, "results", "gusto_operability.csv"))
g_rk <- read.csv(file.path(proj, "results", "gusto_rank_intervals.csv")); g_sp <- read.csv(file.path(proj, "results", "gusto_rank_spearman_boot.csv"))
u_pp <- read.csv(file.path(RES, "ist1_USA_w1_per_pair.csv")); u_rk <- read.csv(file.path(RES, "ist1_USA_rank_intervals.csv")); u_sp <- read.csv(file.path(RES, "ist1_USA_rank_spearman_boot.csv"))
desc <- rbind(
  data.frame(case = "GUSTO-I (anchor R8)", partners = nrow(g_pp), n_partner_min = min(g_pp$n), n_partner_max = max(g_pp$n),
             resolved_age = sum(g_op$resolved_anchor[g_op$em == "age"]), resolved_sbp = sum(g_op$resolved_anchor[g_op$em == "sysbp"]), resolved_delay = NA,
             rank_width_age = mean(g_rk$rank_hi[g_rk$em == "age"] - g_rk$rank_lo[g_rk$em == "age"]),
             rank_width_sbp = mean(g_rk$rank_hi[g_rk$em == "sysbp"] - g_rk$rank_lo[g_rk$em == "sysbp"]),
             rho_age_sbp = g_sp$value[g_sp$stat == "rho_obs"], rho_lo = g_sp$value[g_sp$stat == "rho_lo"], rho_hi = g_sp$value[g_sp$stat == "rho_hi"]),
  data.frame(case = "IST-1 (anchor USA)", partners = length(unique(u_pp$partner)), n_partner_min = min(u_pp$n_partner), n_partner_max = max(u_pp$n_partner),
             resolved_age = sum(u_pp$resolved[u_pp$em == "age"]), resolved_sbp = sum(u_pp$resolved[u_pp$em == "sbp"]), resolved_delay = sum(u_pp$resolved[u_pp$em == "delay"]),
             rank_width_age = mean(u_rk$rank_hi[u_rk$em == "age"] - u_rk$rank_lo[u_rk$em == "age"]),
             rank_width_sbp = mean(u_rk$rank_hi[u_rk$em == "sbp"] - u_rk$rank_lo[u_rk$em == "sbp"]),
             rho_age_sbp = u_sp$rho_obs[u_sp$em1 == "age" & u_sp$em2 == "sbp"], rho_lo = u_sp$rho_lo[u_sp$em1 == "age" & u_sp$em2 == "sbp"], rho_hi = u_sp$rho_hi[u_sp$em1 == "age" & u_sp$em2 == "sbp"]))
write.csv(desc, file.path(RES, "gusto_vs_ist1_descriptors.csv"), row.names = FALSE)
md <- c(md, "## GUSTO-I vs IST-1 on the same descriptors", "",
        "| case | partners | n range | resolved age | resolved SBP | resolved delay | mean rank width age / SBP | rho(age, SBP) [CI] |", "|---|---|---|---|---|---|---|---|",
        sprintf("| %s | %d | %d-%d | %d | %d | %s | %.1f / %.1f | %.2f [%.2f, %.2f] |", desc$case, desc$partners, desc$n_partner_min, desc$n_partner_max,
                desc$resolved_age, desc$resolved_sbp, ifelse(is.na(desc$resolved_delay), "-", as.character(desc$resolved_delay)),
                desc$rank_width_age, desc$rank_width_sbp, desc$rho_age_sbp, desc$rho_lo, desc$rho_hi))
writeLines(md, file.path(RES, "ist1_summary.md"))
writeLines(c(sprintf("seed = %d; RNGkind = %s", SEED, paste(RNGkind(), collapse = " / ")), capture.output(sessionInfo())), file.path(RES, "sessionInfo.txt"))
cat("done\n")
