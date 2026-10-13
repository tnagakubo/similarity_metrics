# Referee check 08 -- read (not recompute) the unreported registered outputs cited in M5.
# Base R only. Run from the project root: Rscript review_response/referee/20261011/r08_unbilled_reads.R
OUT <- "review_response/referee/20261011"
sink(file.path(OUT, "r08_unbilled_reads.txt"), split = TRUE)
s <- read.csv("results/clustering_nok_silhouette_ext.csv")
cat("Estimated-k (silhouette) average-linkage clustering, W1, n = 2000:\n"); print(s[s$method == "W1" & s$n == 2000, ], row.names = FALSE)
r <- read.csv("results/real_data_survey_summary.csv")
cat("\nRegistered real-data survey (all region pairs):\n"); print(r, row.names = FALSE, digits = 3)
cat(sprintf("Spearman(W1, |SMD|) range over the %d dataset x EM rows: %.3f - %.3f\n", nrow(r), min(r$spearman_w1_smd), max(r$spearman_w1_smd)))
rs <- read.csv("results/required_n_selection.csv")
cat(sprintf("\nrequired_n_selection.csv methods: %s ; thresholds: %s\n", paste(unique(rs$method), collapse = ","), paste(unique(rs$threshold), collapse = ",")))
sink()
