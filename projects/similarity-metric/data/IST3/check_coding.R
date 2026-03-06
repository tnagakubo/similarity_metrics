d <- read.csv("ist3_full_vars.csv")
d$good <- as.integer(d$ohs6 <= 2)
n0 <- sum(d$itt_treat==0)
n1 <- sum(d$itt_treat==1)
g0 <- sum(d$good[d$itt_treat==0])
g1 <- sum(d$good[d$itt_treat==1])
r0 <- g0/n0
r1 <- g1/n1
cat("itt_treat=0:", n0, "patients,", g0, "good,", sprintf("%.1f%%\n", 100*r0))
cat("itt_treat=1:", n1, "patients,", g1, "good,", sprintf("%.1f%%\n", 100*r1))
cat("Published: Alteplase 554/1515=36.6%, Control 534/1520=35.1%\n")
