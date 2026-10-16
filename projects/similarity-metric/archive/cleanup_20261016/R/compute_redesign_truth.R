# =============================================================================
# Compute true_nABCD per (scenario × normalizer) and population SMD for the
# redesigned scenarios N1-N8.
# Output:
#   results/true_redesign.rds  — true_nABCD per normalizer (5 norms × 8 scens)
#   results/smd_redesign.rds   — population SMD per scenario
# =============================================================================

SKIP_SIMULATION <- TRUE
ROOT <- "projects/similarity-metric/R"

source(file.path(ROOT, "simulation_manuscript_v2.R"), chdir = TRUE)
source(file.path(ROOT, "nabcd_normalizers.R"),       chdir = TRUE)
source(file.path(ROOT, "true_normalizers.R"),        chdir = TRUE)
source(file.path(ROOT, "scenarios_redesign.R"),      chdir = TRUE)

cat("=========================================================\n")
cat(" Redesigned Scenarios — Truth computation (N1-N8)\n")
cat("=========================================================\n\n")

# --- True nABCD per normalizer ---
true_df <- compute_true_redesign(scenarios_redesign,
                                   n_mc = 1e6,
                                   seed_base = 12345,
                                   out_file = "results/true_redesign.rds",
                                   verbose = TRUE)

cat("\n=== True nABCD per (scenario × normalizer) ===\n")
print(true_df, row.names = FALSE)

# --- Population SMD ---
smd_df <- compute_all_smd(scenarios_redesign, n_mc = 1e6, seed_base = 99999)
saveRDS(smd_df, "results/smd_redesign.rds")

cat("\n=== Population SMD per scenario ===\n")
print(smd_df, row.names = FALSE)

# --- Combined summary table: SMD vs nABCD ---
cat("\n=== Combined: SMD vs nABCD per normalizer ===\n")
NORMS <- c("IQR", "Q95Q5", "SD", "MAD", "Range")
wide <- reshape(true_df[, c("scenario", "normalizer", "true_nABCD")],
                idvar = "scenario", timevar = "normalizer",
                direction = "wide")
names(wide) <- gsub("^true_nABCD\\.", "", names(wide))
# Reorder columns
wide <- wide[, c("scenario", NORMS)]
# Merge SMD
merged <- merge(smd_df, wide, by = "scenario")
# Reorder rows by N1-N8 sequence
merged <- merged[match(names(scenarios_redesign), merged$scenario), ]
rownames(merged) <- NULL
# Round
for (c in c("population_smd", NORMS)) merged[[c]] <- round(merged[[c]], 4)
print(merged, row.names = FALSE)

# --- Goal-oriented analysis ---
cat("\n\n========================================================\n")
cat(" Goal-Specific Analysis\n")
cat("========================================================\n")

cat("\n--- Goal 1A check: SMD ~ 0 but nABCD > 0 ---\n")
g1a_scens <- c("N3", "N4", "N7")
sub <- merged[merged$scenario %in% g1a_scens, ]
print(sub[, c("scenario", "population_smd", NORMS)], row.names = FALSE)

cat("\n--- Goal 1B check: Same SMD (~0.5), different nABCD ---\n")
g1b_scens <- c("N2", "N8")
sub <- merged[merged$scenario %in% g1b_scens, ]
print(sub[, c("scenario", "population_smd", NORMS)], row.names = FALSE)
cat("Diff (N8 - N2) per normalizer:\n")
n2 <- merged[merged$scenario == "N2", NORMS]
n8 <- merged[merged$scenario == "N8", NORMS]
diff_row <- as.data.frame(n8 - n2)
diff_row <- cbind(scenario = "N8 - N2", diff_row)
print(diff_row, row.names = FALSE)

cat("\n--- Goal 2C check: Outlier pollution effect on SD vs robust ---\n")
g2c_scens <- c("N2", "N5", "N6")
sub <- merged[merged$scenario %in% g2c_scens, ]
print(sub[, c("scenario", "population_smd", NORMS)], row.names = FALSE)
cat("Note: N2 = clean Gaussian baseline (loc 0.5)\n")
cat("      N5 = same loc 0.5 with 5% outliers\n")
cat("      N6 = same loc 0.5 with 20% outliers\n")
cat("If SD-nABCD shrinks faster than robust-nABCD, SD breakdown is visible.\n")

cat("\n--- Goal 2D check: Skewed (N7) — mean=0 var=1 matched, SD-nABCD vs robust ---\n")
sub <- merged[merged$scenario == "N7", ]
print(sub[, c("scenario", "population_smd", NORMS)], row.names = FALSE)

cat("\n--- Goal 2E check: Heavy tail (N4) — same as Goal 1A but with tail focus ---\n")
sub <- merged[merged$scenario == "N4", ]
print(sub[, c("scenario", "population_smd", NORMS)], row.names = FALSE)

cat("\nDone. Outputs saved to results/true_redesign.rds and results/smd_redesign.rds\n")
