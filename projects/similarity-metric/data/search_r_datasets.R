## Search R packages for multi-country IPD datasets
## Focus: country/region identifier + continuous health variables

# 1. Check specific known datasets
cat("=== 1. GUSTO (predtools) ===\n")
library(predtools)
data(gusto)
cat("N =", nrow(gusto), ", regions =", length(unique(gusto$regl)), "\n")
cat("Variables:", paste(names(gusto), collapse=", "), "\n")
cat("Region sizes:\n")
print(table(gusto$regl))
cat("\n")

# 2. survival package datasets with center/institution
cat("=== 2. survival package ===\n")
library(survival)

# kidney dataset
data(kidney)
cat("kidney: N =", nrow(kidney), ", variables:", paste(names(kidney), collapse=", "), "\n")

# cgd dataset (chronic granulomatous disease)
data(cgd)
cat("cgd: N =", nrow(cgd), ", variables:", paste(names(cgd), collapse=", "), "\n")
if ("center" %in% names(cgd)) cat("  centers:", length(unique(cgd$center)), "\n")

# veteran
data(veteran)
cat("veteran: N =", nrow(veteran), ", variables:", paste(names(veteran), collapse=", "), "\n")

# diabetic
data(diabetic)
cat("diabetic: N =", nrow(diabetic), ", variables:", paste(names(diabetic), collapse=", "), "\n")

cat("\n")

# 3. MASS package
cat("=== 3. MASS package ===\n")
library(MASS)

# birthwt
data(birthwt)
cat("birthwt: N =", nrow(birthwt), ", variables:", paste(names(birthwt), collapse=", "), "\n")
if ("race" %in% names(birthwt)) cat("  race levels:", paste(unique(birthwt$race), collapse=", "), "\n")

# Pima.tr
data(Pima.tr)
cat("Pima.tr: N =", nrow(Pima.tr), ", variables:", paste(names(Pima.tr), collapse=", "), "\n")
data(Pima.te)
cat("Pima.te: N =", nrow(Pima.te), ", variables:", paste(names(Pima.te), collapse=", "), "\n")

cat("\n")

# 4. List ALL installed packages
cat("=== 4. All installed packages ===\n")
ip <- installed.packages()[, "Package"]
cat("Total installed:", length(ip), "\n")
cat(paste(sort(ip), collapse=", "), "\n\n")

# 5. Check specific packages for multi-country datasets
cat("=== 5. Specific package checks ===\n")

# medicaldata
if ("medicaldata" %in% ip) {
  cat("medicaldata: INSTALLED\n")
  ds <- data(package = "medicaldata")
  cat("  Datasets:", paste(ds$results[, "Item"], collapse=", "), "\n")
} else {
  cat("medicaldata: NOT INSTALLED\n")
}

# metafor
if ("metafor" %in% ip) {
  cat("metafor: INSTALLED\n")
  ds <- data(package = "metafor")
  cat("  Datasets:", paste(ds$results[, "Item"], collapse=", "), "\n")
} else {
  cat("metafor: NOT INSTALLED\n")
}

# gapminder
if ("gapminder" %in% ip) {
  cat("gapminder: INSTALLED\n")
  library(gapminder)
  data(gapminder)
  cat("  N =", nrow(gapminder), "\n")
  cat("  Variables:", paste(names(gapminder), collapse=", "), "\n")
  cat("  Countries:", length(unique(gapminder$country)), "\n")
  if ("Japan" %in% gapminder$country) cat("  Japan: PRESENT\n") else cat("  Japan: NOT PRESENT\n")
} else {
  cat("gapminder: NOT INSTALLED\n")
}

# nhanesA
if ("nhanesA" %in% ip) {
  cat("nhanesA: INSTALLED\n")
} else {
  cat("nhanesA: NOT INSTALLED\n")
}

# Check for any WHO/health related packages
health_pkgs <- ip[grepl("(health|who|epi|clinical|trial|medical|bio)", ip, ignore.case=TRUE)]
cat("\nHealth-related packages:", paste(health_pkgs, collapse=", "), "\n")

cat("\n=== Search complete ===\n")
