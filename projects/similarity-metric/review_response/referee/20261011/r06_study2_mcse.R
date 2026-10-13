# Referee check 06 -- Monte Carlo SEs of RMSE and mean CI width (Section 3.2.1), from the per-replicate rds.
# RMSE MCSE by the delta method: sd((e - t)^2) / (2 * RMSE * sqrt(R)); width MCSE: sd(U - L) / sqrt(R).
# Base R only. Run from the project root: Rscript review_response/referee/20261011/r06_study2_mcse.R
OUT <- "review_response/referee/20261011"
sink(file.path(OUT, "r06_study2_mcse.txt"), split = TRUE)
x <- readRDS("results/w1_raw_simulation.rds")
s6 <- integrate(function(t) pnorm(t, 50, 10), -Inf, 0, rel.tol = 1e-12)$value +
      integrate(function(t) abs(pnorm(t, 50, 10) - plnorm(t, log(50) - 0.125, 0.5)), 0, Inf, rel.tol = 1e-12, subdivisions = 5000L)$value
s7 <- integrate(function(t) abs(pnorm(t, 50, 10) - pnorm(t, 55, 15)), -Inf, Inf, rel.tol = 1e-12, subdivisions = 5000L)$value
truth <- c(S1 = 0, S2 = 2, S3 = 5, S4 = 10, S5 = sqrt(2 / pi) * 5, S6 = s6, S7 = s7)
r <- do.call(rbind, lapply(names(x$rep_data), function(k) { d <- x$rep_data[[k]]; t <- truth[[sub("-.*", "", k)]]
  e <- d[, "estimate"]; R <- length(e); rmse <- sqrt(mean((e - t)^2))
  data.frame(cell = k, mcse_bias = sd(e) / sqrt(R), mcse_rmse = sd((e - t)^2) / (2 * rmse * sqrt(R)),
             mcse_width = sd(d[, "ci_upper"] - d[, "ci_lower"]) / sqrt(R)) }))
print(r, row.names = FALSE, digits = 4)
a <- read.csv("results/study2_mcse.csv")
cat(sprintf("max: bias %.4f (file %.4f) | rmse %.4f (file %.4f) | width %.4f (file %.4f)\n", max(r$mcse_bias), max(a$mcse_bias),
            max(r$mcse_rmse), max(a$mcse_rmse), max(r$mcse_width), max(a$mcse_ci_width)))
sink()
