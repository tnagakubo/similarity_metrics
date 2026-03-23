## Check pharmaverseadam datasets for multi-country data
library(pharmaverseadam)

datasets_to_check <- c("adppk", "adcoeq_metabolic", "advs_metabolic",
                        "adlb_metabolic", "adce_vaccine", "adis_vaccine",
                        "advs_peds", "adsl_vaccine")

for (d in datasets_to_check) {
  tryCatch({
    data(list = d)
    obj <- get(d)
    cat(sprintf("\n=== %s (N=%d) ===\n", d, nrow(obj)))
    if ("COUNTRY" %in% names(obj)) {
      cat("COUNTRY:\n")
      print(table(obj$COUNTRY))
    }
    if ("COUNTRYL" %in% names(obj)) {
      cat("COUNTRYL:\n")
      print(table(obj$COUNTRYL))
    }
    if ("REGION1" %in% names(obj)) {
      vals <- unique(obj$REGION1)
      vals <- vals[!is.na(vals)]
      if (length(vals) > 0) {
        cat("REGION1:\n")
        print(table(obj$REGION1))
      }
    }
    # Check for Asian countries
    for (v in c("COUNTRY", "COUNTRYL")) {
      if (v %in% names(obj)) {
        vals <- unique(obj[[v]])
        asian <- vals[grepl("JPN|CHN|KOR|TWN|Japan|China|Korea|Taiwan|Asia", vals, ignore.case=TRUE)]
        if (length(asian) > 0) cat("  ** ASIAN:", paste(asian, collapse=", "), "\n")
      }
    }
    # Show unique subjects
    if ("USUBJID" %in% names(obj)) {
      cat("Unique subjects:", length(unique(obj$USUBJID)), "\n")
    }
    # Continuous variables
    nums <- names(obj)[sapply(obj, is.numeric)]
    health_vars <- nums[grepl("BMI|WT|HT|AGE|SBP|DBP|PULSE|HR|TEMP|WEIGHT|HEIGHT|BSA", nums, ignore.case=TRUE)]
    if (length(health_vars) > 0) cat("Health vars:", paste(health_vars, collapse=", "), "\n")
  }, error = function(e) cat(sprintf("\n=== %s ERROR: %s ===\n", d, e$message)))
}

# Also check the main advs (vital signs) for country
cat("\n=== advs (vital signs, N=65032) ===\n")
data(advs)
if ("COUNTRY" %in% names(advs)) {
  cat("COUNTRY:\n")
  print(table(advs$COUNTRY))
}
cat("Unique subjects:", length(unique(advs$USUBJID)), "\n")
# What vital signs are measured?
if ("PARAM" %in% names(advs)) {
  cat("Parameters:\n")
  print(table(advs$PARAM))
}

cat("\n=== Done ===\n")
