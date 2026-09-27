## ---------------------------------------------------------------------------
## render.R -- render the report.
##
## Preferred route (on a machine with Quarto installed):
##     quarto render neyman_smooth_clinical.qmd
##
## This script is the fallback used when the Quarto CLI is unavailable: it
## knits the same .qmd with knitr and converts the result with pandoc.  The
## document deliberately avoids Quarto-only cross-reference syntax so that
## both routes produce the same content.
## ---------------------------------------------------------------------------

library(knitr)

opts_chunk$set(echo = FALSE, warning = FALSE, message = FALSE)
knit("neyman_smooth_clinical.qmd", output = "neyman_smooth_clinical.md",
     quiet = TRUE)

rmarkdown::pandoc_convert(
  input = normalizePath("neyman_smooth_clinical.md"),
  to = "html5",
  output = normalizePath("neyman_smooth_clinical.html", mustWork = FALSE),
  options = c("--standalone", "--embed-resources", "--toc", "--toc-depth=3",
              "--number-sections", "--mathml", "--metadata", "lang=ja",
              "--metadata", "title=Neyman の smooth test による主要評価変数の 2 標本 omnibus 検定",
              "--css", "R/report.css"))

message("rendered: neyman_smooth_clinical.html")
