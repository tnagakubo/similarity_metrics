## Check newly installed packages for multi-country IPD
## Mike's systematic scan

cat("=== 1. medicaldata ===\n")
library(medicaldata)
ds <- data(package = "medicaldata")
cat("Datasets:", nrow(ds$results), "\n")
for (i in seq_len(nrow(ds$results))) {
  d <- ds$results[i, "Item"]
  tryCatch({
    data(list = d)
    obj <- get(d)
    if (is.data.frame(obj)) {
      nms <- names(obj)
      has_geo <- any(grepl("country|ctry|region|site|center|ethnic|race|nation", nms, ignore.case=TRUE))
      if (has_geo || nrow(obj) > 500) {
        geo_vars <- nms[grepl("country|ctry|region|site|center|ethnic|race|nation", nms, ignore.case=TRUE)]
        cat(sprintf("  %-25s N=%6d vars=%3d", d, nrow(obj), ncol(obj)))
        if (length(geo_vars) > 0) cat("  GEO:", paste(geo_vars, collapse=","))
        cat("\n")
      }
    }
  }, error = function(e) NULL)
}

cat("\n=== 2. metafor/metadat ===\n")
library(metafor)
library(metadat)
ds2 <- data(package = "metadat")
cat("metadat datasets:", nrow(ds2$results), "\n")

# Check each dataset for IPD (individual patient data) vs aggregate
ipd_candidates <- c()
for (i in seq_len(nrow(ds2$results))) {
  d <- ds2$results[i, "Item"]
  tryCatch({
    data(list = d, package = "metadat")
    obj <- get(d)
    if (is.data.frame(obj) && nrow(obj) > 200) {
      nms <- tolower(names(obj))
      has_country <- any(grepl("country|region|nation|site|center", nms))
      has_patient <- any(grepl("patient|subject|id|age|bmi|weight|height|bp|sbp", nms))
      if (has_country || has_patient) {
        cat(sprintf("  %-30s N=%6d vars=%3d", d, nrow(obj), ncol(obj)))
        matches <- names(obj)[grepl("country|region|nation|site|center|age|bmi|weight|height|bp", names(obj), ignore.case=TRUE)]
        cat("  MATCH:", paste(head(matches, 6), collapse=","))
        cat("\n")
        ipd_candidates <- c(ipd_candidates, d)
      }
    }
  }, error = function(e) NULL)
}

# Deep check top candidates
if (length(ipd_candidates) > 0) {
  cat("\n--- Deep check ---\n")
  for (d in head(ipd_candidates, 5)) {
    data(list = d, package = "metadat")
    obj <- get(d)
    cat(sprintf("\n%s (N=%d):\n", d, nrow(obj)))
    cat("  Columns:", paste(names(obj), collapse=", "), "\n")
    # Check for country
    for (v in names(obj)) {
      if (grepl("country|region|nation", v, ignore.case=TRUE)) {
        cat(sprintf("  %s values: %s\n", v, paste(head(unique(obj[[v]]), 10), collapse=", ")))
      }
    }
  }
}

cat("\n=== 3. nhanesA ===\n")
library(nhanesA)
cat("nhanesA is a data downloader for NHANES (USA CDC)\n")
cat("Available tables can be listed with nhanesTables()\n")
cat("Data: USA only, no country variable\n")
cat("BUT: individual-level BMI, BP, lab values for ~10,000/cycle\n")
# List available data groups
cat("Data groups: DEMO, EXAM, LAB, DIET, Q\n")

cat("\n=== Done ===\n")
