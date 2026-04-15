library(predtools)
data(gusto)

cat("=== Continuous variables ===\n")
cont <- c("age","sysbp","pulse","height","weight")
for (v in cont) {
  x <- gusto[[v]]
  nv <- sum(!is.na(x))
  nu <- length(unique(x[!is.na(x)]))
  cat(v, " N_valid=", nv, " miss=", round(100*(1-nv/nrow(gusto)),1),
      "% unique=", nu, " range=", range(x,na.rm=TRUE),
      " mean=", round(mean(x,na.rm=TRUE),1), " sd=", round(sd(x,na.rm=TRUE),1), "\n")
}

cat("\n=== Ordinal/count ===\n")
ord <- c("Killip","ste")
for (v in ord) {
  x <- gusto[[v]]
  cat(v, ": ", paste(sort(unique(x[!is.na(x)])), collapse=","),
      " N_valid=", sum(!is.na(x)), "\n")
}

cat("\n=== Binary ===\n")
bin <- c("sex","hig","dia","hyp","hrt","sho","ttr","ant","pmi","htn","smk","pan","fam","prevcvd","prevcabg","tpa")
for (v in bin) {
  x <- gusto[[v]]
  cat(v, ": unique=", length(unique(x[!is.na(x)])), " N_valid=", sum(!is.na(x)), "\n")
}

cat("\n=== Outcome ===\n")
cat("day30: unique=", length(unique(gusto$day30[!is.na(gusto$day30)])),
    " N_valid=", sum(!is.na(gusto$day30)), "\n")

cat("\n=== Region/group ===\n")
cat("regl: ", paste(sort(unique(gusto$regl)), collapse=","), "\n")
cat("grpl: ", paste(sort(unique(gusto$grpl)), collapse=","), "\n")
