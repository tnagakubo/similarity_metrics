# Post-run analysis for anchor_vs_clustering_simulation.R
# Frame 1 (viol_anchor) is printed by the sim log; this adds Frame 2 (viol_pair),
# the pair-violation ANCHOR-tau silently carries at its Frame-1 optimum, and harm.

t <- read.csv("results/anchor_vs_clustering_tau.csv")
g <- read.csv("results/anchor_vs_clustering_group.csv")

best_row <- function(df, vcol) {
  f <- df[df[[vcol]] <= 0.05 & !is.na(df$sensitivity), ]
  if (!nrow(f)) return(NULL)
  f[which.max(f$sensitivity), ]
}

cells <- unique(t[, c("set", "n")])

cat("== Frame 2: best sensitivity @ viol_pair <= 5% (shared-pool guarantee) ==\n")
f2 <- do.call(rbind, lapply(seq_len(nrow(cells)), function(i) {
  s <- cells$set[i]; n <- cells$n[i]
  a <- best_row(t[t$set == s & t$n == n & t$rule == "ANCHOR_tau", ], "viol_pair")
  c2 <- best_row(t[t$set == s & t$n == n & t$rule == "CLUST_tau", ], "viol_pair")
  data.frame(set = s, n = n,
             ANCHOR = if (is.null(a)) NA else round(a$sensitivity, 3),
             CLUST  = if (is.null(c2)) NA else round(c2$sensitivity, 3))
}))
print(f2, row.names = FALSE)

cat("\n== ANCHOR-tau at its Frame-1 optimum: hidden pair violation + harm ==\n")
e2 <- do.call(rbind, lapply(seq_len(nrow(cells)), function(i) {
  s <- cells$set[i]; n <- cells$n[i]
  a <- best_row(t[t$set == s & t$n == n & t$rule == "ANCHOR_tau", ], "viol_anchor")
  if (is.null(a)) return(NULL)
  cc <- t[t$set == s & t$n == n & t$rule == "CLUST_tau" & t$tau == a$tau, ]
  data.frame(set = s, n = n, tau = round(a$tau, 3),
             A_viol_anchor = round(a$viol_anchor, 3),
             A_viol_pair   = round(a$viol_pair, 3),
             A_harm        = round(a$harm, 3),
             C_viol_pair   = round(cc$viol_pair, 3),
             C_harm        = round(cc$harm, 3))
}))
print(e2, row.names = FALSE)

cat("\n== Group-truth scoring at the strictest tau (+ silhouette) ==\n")
print(g[g$n %in% c(100, 400), ], row.names = FALSE)
