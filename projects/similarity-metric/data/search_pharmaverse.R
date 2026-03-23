## Check pharmaverseadam and Hmisc for useful datasets

# 1. pharmaverseadam - CDISC ADaM example datasets
cat("=== pharmaverseadam ===\n")
library(pharmaverseadam)
ds <- data(package = "pharmaverseadam")
cat("Datasets:", paste(ds$results[, "Item"], collapse=", "), "\n\n")

# Check each dataset for country-like variables
for (d in ds$results[, "Item"]) {
  tryCatch({
    data(list = d)
    obj <- get(d)
    if (is.data.frame(obj)) {
      nms <- tolower(names(obj))
      has_country <- any(grepl("country|ctry|region|site|center|ethnic", nms))
      cat(sprintf("%-20s N=%6d vars=%3d", d, nrow(obj), ncol(obj)))
      if (has_country) {
        matches <- names(obj)[grepl("country|ctry|region|site|center|ethnic|race", names(obj), ignore.case=TRUE)]
        cat("  ** MATCH:", paste(matches, collapse=", "))
      }
      cat("\n")
    }
  }, error = function(e) cat(sprintf("%-20s ERROR\n", d)))
}

# Check adsl (subject-level) in detail
cat("\n=== adsl detail ===\n")
if (exists("adsl")) {
  cat("Variables:", paste(names(adsl), collapse=", "), "\n")
  # Check for country
  if ("COUNTRY" %in% names(adsl)) {
    cat("\nCOUNTRY values:\n")
    print(table(adsl$COUNTRY))
  }
  if ("ETHNIC" %in% names(adsl)) {
    cat("\nETHNIC values:\n")
    print(table(adsl$ETHNIC))
  }
  if ("RACE" %in% names(adsl)) {
    cat("\nRACE values:\n")
    print(table(adsl$RACE))
  }
  if ("REGION1" %in% names(adsl)) {
    cat("\nREGION1 values:\n")
    print(table(adsl$REGION1))
  }
  # Continuous variables
  cont_vars <- names(adsl)[sapply(adsl, is.numeric)]
  cat("\nNumeric variables:", paste(cont_vars, collapse=", "), "\n")
}

# 2. Hmisc datasets
cat("\n=== Hmisc ===\n")
library(Hmisc)
ds2 <- data(package = "Hmisc")
cat("Datasets:", paste(ds2$results[, "Item"], collapse=", "), "\n")

cat("\n=== Done ===\n")
