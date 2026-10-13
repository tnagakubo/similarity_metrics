# Referee: terminal-digit heaping of SBP by region and its contribution to W1_SBP (R8 anchor)
g <- read.csv("data/gusto.csv")
w1f <- function(x, y) { x <- sort(x); y <- sort(y); z <- sort(c(x, y)); k <- z[-length(z)]
  sum(diff(z) * abs(findInterval(k, x) / length(x) - findInterval(k, y) / length(y))) }
h <- tapply(g$sysbp %% 10 == 0, g$regl, mean); h5 <- tapply(g$sysbp %% 5 == 0, g$regl, mean)
cat("share of SBP on multiples of 10 by region:\n"); print(round(h, 3)); cat("multiples of 5:\n"); print(round(h5, 3))
cat("age: share integer-valued by region:", round(range(tapply(abs(g$age - round(g$age)) < 1e-9, g$regl, mean)), 3), "\n")
a <- g$sysbp[g$regl == 8]; P <- setdiff(sort(unique(g$regl)), 8)
r10 <- function(x) 10 * round(x / 10)
w <- sapply(P, function(p) w1f(a, g$sysbp[g$regl == p])); w10 <- sapply(P, function(p) w1f(r10(a), r10(g$sysbp[g$regl == p])))
# uniform jitter within the recording interval implied by 10-mmHg rounding for heaped values only
set.seed(1); jit <- function(x) ifelse(x %% 10 == 0, x + runif(length(x), -5, 5), x)
wj <- sapply(P, function(p) mean(replicate(20, w1f(jit(a), jit(g$sysbp[g$regl == p])))))
out <- data.frame(partner = paste0("R", P), heap10 = round(h[as.character(P)], 3), W1 = round(w, 2), W1_rounded10 = round(w10, 2), W1_dejittered = round(wj, 2), rank = rank(w), rank_r10 = rank(w10), rank_jit = rank(wj))
print(out, row.names = FALSE)
cat("Spearman W1 vs W1(rounded to 10):", cor(rank(w), rank(w10)), " vs dejittered:", cor(rank(w), rank(wj)), "\n")
cat("R8 heap share", round(h["8"], 3), "; partner range", round(range(h[as.character(P)]), 3), "\n")
cat("corr(|heap_p - heap_8|, W1):", cor(abs(h[as.character(P)] - h["8"]), w, method = "spearman"), "\n")
write.csv(out, "review_response/referee/20261012/ref_heaping.csv", row.names = FALSE)
