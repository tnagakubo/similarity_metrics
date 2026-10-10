# fixture: draws without seed, absolute path, writes results without sessionInfo
setwd("C:/Users/someone/project")
x <- rnorm(100)
write.csv(data.frame(x), "results/out.csv")
