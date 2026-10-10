# fixture: clean
set.seed(2026)
x <- rnorm(100)
write.csv(data.frame(x), file.path("results", "out.csv"))
writeLines(capture.output(sessionInfo()), file.path("results", "out_sessionInfo.txt"))
