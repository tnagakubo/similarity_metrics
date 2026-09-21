## verify_corrections.R ---------------------------------------------------
## One gate over a manuscript file. Run from this folder:
##   Rscript verify_corrections.R                       # this folder's .tex
##   Rscript verify_corrections.R ../paper/per_em_W1_wiley.tex
## The target is an argument so the gate can be pointed at whichever copy is
## being edited. Exits non-zero on any failure; wire it into /verify-numbers.
##
## Checks
##   1. LaTeX integrity      -- balanced braces, even inline $, no undefined
##                              \ref, every \cite key present in the .bib
##   2. Abstract             -- <= 250 words, no citations (SiM requirement)
##   3. Study 1 tables       -- all 81 cells of tab:bias / tab:coverage /
##                              tab:precision against results/w1_raw_summary.csv
##   4. GUSTO application    -- Table 1 moments, all 30 W1 values, eligibility
##                              sets and pool diameters recomputed from
##                              data/gusto.csv

here  <- tryCatch(dirname(normalizePath(sub("^--file=", "", grep("^--file=",
           commandArgs(FALSE), value = TRUE)[1]))), error = function(e) getwd())
if (is.na(here) || !length(here)) here <- getwd()
root  <- normalizePath(file.path(here, ".."), mustWork = FALSE)
.args <- commandArgs(trailingOnly = TRUE)
tex   <- if (length(.args) >= 1L) .args[1L] else file.path(here, "per_em_W1_wiley.tex")
if (!file.exists(tex)) stop("target .tex not found: ", tex)
cat(sprintf("target : %s\nproject: %s\n\n", tex, root))

source(file.path(here, "count_abstract_words.R"))
source(file.path(here, "verify_study1_tables.R"))

fails <- character(0)
ok <- function(cond, msg) {
  cat(sprintf("[%s] %s\n", if (isTRUE(cond)) "PASS" else "FAIL", msg))
  if (!isTRUE(cond)) fails <<- c(fails, msg)
}

## ---- 1. LaTeX integrity -------------------------------------------------
src <- paste(readLines(tex, warn = FALSE, encoding = "UTF-8"), collapse = "\n")
nc  <- gsub("(?<!\\\\)%[^\n]*", "", src, perl = TRUE)
cnt <- function(p) lengths(regmatches(nc, gregexpr(p, nc, perl = TRUE)))
ok(cnt("(?<!\\\\)\\{") == cnt("(?<!\\\\)\\}"),
   sprintf("braces balanced (%d open, %d close)", cnt("(?<!\\\\)\\{"), cnt("(?<!\\\\)\\}")))
ok(cnt("(?<!\\\\)\\$") %% 2 == 0, sprintf("inline math delimiters even (%d)", cnt("(?<!\\\\)\\$")))

labs <- unique(gsub(".*\\{(.*)\\}", "\\1",
        regmatches(nc, gregexpr("\\\\label\\{[^}]*\\}", nc))[[1]]))
refs <- unique(gsub(".*\\{(.*)\\}", "\\1",
        regmatches(nc, gregexpr("\\\\(ref|eqref)\\{[^}]*\\}", nc))[[1]]))
undef <- setdiff(refs, labs)
ok(length(undef) == 0,
   sprintf("no undefined \\ref (%d refs against %d labels)%s", length(refs), length(labs),
           if (length(undef)) paste0(": ", paste(undef, collapse = ", ")) else ""))

bib  <- readLines(file.path(root, "paper/per_em_W1_wiley.bib"), warn = FALSE)
keys <- trimws(gsub("^@[A-Za-z]+\\{\\s*([^,]+),.*$", "\\1", grep("^@", bib, value = TRUE)))
used <- trimws(unique(unlist(strsplit(gsub("\\\\cite\\{([^}]*)\\}", "\\1",
        regmatches(nc, gregexpr("\\\\cite\\{[^}]*\\}", nc))[[1]]), ","))))
miss <- setdiff(used, keys)
ok(length(miss) == 0,
   sprintf("all %d \\cite keys resolve in the .bib%s", length(used),
           if (length(miss)) paste0(": missing ", paste(miss, collapse = ", ")) else ""))

## ---- 2. Abstract --------------------------------------------------------
ab <- abstract_report(tex)
ok(ab$math_as_word <= 250 && !ab$has_citation,
   sprintf("abstract %d words (limit 250), citations: %s", ab$math_as_word, ab$has_citation))

## ---- 2b. Claim-level cascade check --------------------------------------
## A claim correction applied to one sentence is not applied to the claim.
## Each pattern is a phrasing a corrected claim must NOT leave anywhere in
## the file; residual hits = 0 is the acceptance condition. Comment lines
## and the verbatim R listing are excluded from the scan.
body <- readLines(tex, warn = FALSE, encoding = "UTF-8")
lst  <- grep("lstlisting", body)
inlst <- if (length(lst) >= 2) seq(lst[1], lst[length(lst)]) else integer(0)
scan_ix <- setdiff(which(!grepl("^\\s*%", body)), inlst)

pat <- c("unique theoretical connection",
         "no theoretical connection",
         "cannot provide an analogous bound",
         "lack any analogous property",
         "a theoretical link to treatment effect heterogeneity",
         "balanced across both modifiers",
         "balanced ranking on both modifiers",
         "percentage points of 30-day mortality per year")
why <- c(rep("M1 bound-exclusivity", 5), rep("M4 R4 recommendation", 2), "M2 L units")

hits <- character(0)
for (i in seq_along(pat)) {
  j <- grep(pat[i], body[scan_ix], fixed = TRUE)
  if (length(j))
    hits <- c(hits, sprintf("%s L%d '%s'", why[i], scan_ix[j][1], pat[i]))
}
ok(length(hits) == 0,
   sprintf("cascade: %d forbidden phrasings, 0 residual hits%s", length(pat),
           if (length(hits)) paste0(" -- ", paste(hits, collapse = "; ")) else ""))

## Exact strings catch only the phrasings already seen. The M1 claim is a
## class, so guard it by proximity instead: any sentence asserting a
## theoretical link/connection to heterogeneity must qualify it by naming
## the constant. This is what makes the check survive rewording.
## Strip trailing comments line by line BEFORE collapsing: on a single
## collapsed string "%[^\n]*" has no newline to stop at and would delete
## everything after the first comment, silently making this check vacuous.
prose <- gsub("(?<!\\\\)%.*$", "", body[scan_ix], perl = TRUE)
prose <- paste(prose, collapse = " ")
sentences <- unlist(strsplit(prose, "(?<=\\.)\\s+", perl = TRUE))
stem <- grepl("theoretical (link|connection)", sentences)
qual <- grepl("constant|specif|elicit|total variation", sentences)
unqualified <- sentences[stem & !qual]
ok(length(unqualified) == 0,
   sprintf("M1 proximity: every 'theoretical link/connection' sentence names its constant%s",
           if (length(unqualified))
             paste0(" -- ", length(unqualified), " unqualified: ",
                    paste(substr(unqualified, 1, 70), collapse = " | ")) else ""))

## Quantifier guard on the abstract: compression turns "in at least one
## world" into "wherever", and deletes restricting phrases.
abs_body <- extract_abstract(tex)
univ  <- c("wherever", "in every world", "always")
found <- univ[vapply(univ, function(w) grepl(w, abs_body, fixed = TRUE), logical(1))]
ok(length(found) == 0,
   sprintf("abstract free of universal quantifiers over worlds%s",
           if (length(found)) paste0(" -- found: ", paste(found, collapse = ", ")) else ""))
ok(grepl("non-negligible", abs_body, fixed = TRUE),
   "abstract retains the 'non-negligible distributional differences' qualifier")

## ---- 3. Study 1 tables --------------------------------------------------
ws <- audit_study1(root)
tx <- readLines(tex, warn = FALSE, encoding = "UTF-8")
grab <- function(lab, n) {
  i   <- grep(lab, tx, fixed = TRUE)[1]
  mid <- grep("\\midrule", tx[i:(i + 30)], fixed = TRUE)[1] + i - 1
  tx[(mid + 1):(mid + n)]
}
num <- function(rows, ncol) t(vapply(rows, function(r) {
  f <- trimws(strsplit(sub("\\\\\\\\\\s*$", "", r), "&")[[1]])
  as.numeric(gsub("[^0-9.-]", "", tail(f, ncol)))
}, numeric(ncol)))

sc <- paste0("S", 1:7)
B <- num(grab("\\label{tab:bias}", 7), 4)[, 2:4];   rownames(B) <- sc
C <- num(grab("\\label{tab:coverage}", 6), 3);      rownames(C) <- sc[-1]
P <- num(grab("\\label{tab:precision}", 7), 6);     rownames(P) <- sc

bad <- character(0)
for (s in sc) for (a in 1:3) {
  k <- paste0(s, "-", c(50, 100, 200)[a])
  if (abs(B[s, a]     - round(ws[k, "bias"], 3))          > 1e-9) bad <- c(bad, paste("bias", k))
  if (abs(P[s, a]     - round(ws[k, "rmse"], 2))          > 1e-9) bad <- c(bad, paste("rmse", k))
  if (abs(P[s, a + 3] - round(ws[k, "mean_ci_width"], 2)) > 1e-9) bad <- c(bad, paste("ciw", k))
}
for (s in sc[-1]) for (a in 1:3) {
  k <- paste0(s, "-", c(50, 100, 200)[a])
  if (abs(C[s, a] - round(ws[k, "coverage_pct"], 3)) > 1e-9) bad <- c(bad, paste("cov", k))
}
ok(length(bad) == 0, sprintf("Study 1 tables: 81 cells against results/w1_raw_summary.csv%s",
   if (length(bad)) paste0(" -- ", length(bad), " mismatches: ", paste(bad, collapse = ", ")) else ""))

## ---- 4. GUSTO application ----------------------------------------------
g <- read.csv(file.path(root, "data/gusto.csv"), stringsAsFactors = FALSE)
skew <- function(x) { n <- length(x); m <- mean(x)
  (sum((x - m)^3) / n) / (sum((x - m)^2) / n)^1.5 }
r8 <- g[g$regl == 8, ]
ok(nrow(g) == 40830 && length(unique(g$regl)) == 16 && nrow(r8) == 2916,
   sprintf("N = %d, regions = %d, anchor R8 n = %d", nrow(g), length(unique(g$regl)), nrow(r8)))
ok(all(abs(c(round(mean(r8$age), 1)   - 60.2,  round(sd(r8$age), 1)   - 12.1,
             round(skew(r8$age), 2)   + 0.17,  round(mean(r8$sysbp), 1) - 132.4,
             round(sd(r8$sysbp), 1)   - 22.9,  round(skew(r8$sysbp), 2) - 0.20)) < 1e-9),
   "Table 1 moments for Region 8 (age and SBP mean / SD / skewness)")

compute_W1 <- function(x1, x2) {
  av <- sort(unique(c(x1, x2))); k <- length(av)
  sum(diff(av) * abs(ecdf(x1)(av[-k]) - ecdf(x2)(av[-k])))
}
A <- split(g$age, g$regl); S <- split(g$sysbp, g$regl)
prs <- t(combn(1:16, 2))
wa <- apply(prs, 1, function(p) compute_W1(A[[as.character(p[1])]], A[[as.character(p[2])]]))
wsb <- apply(prs, 1, function(p) compute_W1(S[[as.character(p[1])]], S[[as.character(p[2])]]))
pp <- read.csv(file.path(root, "results/gusto_r8_w1_per_pair.csv"))
anch <- prs[, 1] == 8 | prs[, 2] == 8
ok(max(abs(sort(wa[anch]) - sort(pp$W1_age))) < 1e-9 &&
   max(abs(sort(wsb[anch]) - sort(pp$W1_sysbp))) < 1e-9,
   "30 anchor W1 distances reproduce results/gusto_r8_w1_per_pair.csv")

elig_age <- sort(pp$partner[0.01 / pp$W1_age   > 0.01])
elig_sbp <- sort(pp$partner[0.01 / pp$W1_sysbp > 0.002])
ok(identical(as.integer(elig_age), c(1L,4L,5L,6L,7L,9L,12L,14L,15L)) &&
   identical(as.integer(elig_sbp), c(1L,2L,3L,4L,5L,6L,10L,13L,14L,15L,16L)) &&
   identical(as.integer(intersect(elig_age, elig_sbp)), c(1L,4L,5L,6L,14L,15L)),
   "eligibility sets on age and SBP, and the jointly eligible six")

dia <- function(members, w) max(w[(prs[,1] %in% members) & (prs[,2] %in% members)])
ok(all(abs(c(round(dia(c(8,1,4,5,6,14,15), wa),  4) - 1.0595,
             round(dia(c(8,1,4,5,6,14,15), wsb), 4) - 4.7243,
             round(dia(c(8,1,4,5,6,7,9,12,14,15), wa), 4) - 1.1093,
             round(dia(c(8,1,2,3,4,5,6,10,13,14,15,16), wsb), 4) - 8.9362)) < 1e-9),
   "pool diameters (joint age/SBP, 9-partner age, 11-partner SBP)")
ok(round(cor(wa, wsb), 2) == 0.13,
   sprintf("age-SBP distance correlation over 120 pairs = %.4f", cor(wa, wsb)))

## ---- verdict ------------------------------------------------------------
cat("\n")
if (length(fails)) {
  cat(sprintf("%d check(s) FAILED:\n  - %s\n", length(fails), paste(fails, collapse = "\n  - ")))
  quit(status = 1)
}
cat("ALL CHECKS PASS\n")
