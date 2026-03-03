df <- read.csv("C:/Users/hrd13/Documents/Gak/0 Study/800Claude/20260210_SIM/similarity_metrics/projects/similarity-metric/data/IST/IST_corrected.csv")
cat("=== Dataset Dimensions ===\n")
cat(sprintf("Rows: %d, Columns: %d\n\n", nrow(df), ncol(df)))

cat("=== Summary Statistics ===\n\n")

cat("AGE:\n")
print(summary(df$AGE))
cat(sprintf("  SD: %.1f\n\n", sd(df$AGE, na.rm=TRUE)))

cat("RSBP (Systolic Blood Pressure):\n")
print(summary(df$RSBP))
cat(sprintf("  SD: %.1f\n\n", sd(df$RSBP, na.rm=TRUE)))

cat("RDELAY (Delay in hours):\n")
print(summary(df$RDELAY))
cat(sprintf("  SD: %.1f\n\n", sd(df$RDELAY, na.rm=TRUE)))

cat("=== Key Categorical Variables ===\n\n")

cat("SEX:\n")
print(table(df$SEX, useNA="ifany"))
cat("\n")

cat("RCONSC (Consciousness level: F=fully alert, D=drowsy, U=unconscious):\n")
print(table(df$RCONSC, useNA="ifany"))
cat("\n")

cat("RXASP (Aspirin allocation: Y/N):\n")
print(table(df$RXASP, useNA="ifany"))
cat("\n")

cat("RXHEP (Heparin allocation: N=none, L=low, M=medium, H=high):\n")
print(table(df$RXHEP, useNA="ifany"))
cat("\n")

cat("=== COUNTRY (all values) ===\n")
ct <- sort(table(df$COUNTRY), decreasing=TRUE)
print(ct)
cat(sprintf("\nTotal unique countries: %d\n", length(ct)))
cat(sprintf("Total patients: %d\n", sum(ct)))
