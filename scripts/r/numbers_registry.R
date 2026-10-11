# numbers_registry.R — R implementation of the numbers registry (same semantics as scripts/numbers_registry.py).
# Source this file, then:
#   reg <- num_registry_load("projects/<p>/paper/numbers_registry.csv")
#   num("covS2n50")                      # formatted string for LaTeX / Quarto inline
#   num_write_macros(reg, "projects/<p>/paper/numbers_macros.tex")
# Base R only. Used by scripts/make_numbers_macros.R and by Quarto manuscripts (templates/paper_template.qmd).

.num_env <- new.env(parent = emptyenv())

num_registry_load <- function(path) {
  reg <- read.csv(path, stringsAsFactors = FALSE, check.names = FALSE, colClasses = "character",
                  comment.char = "", strip.white = TRUE)
  reg <- reg[nzchar(reg$key) & !startsWith(reg$key, "#"), , drop = FALSE]
  root <- normalizePath(dirname(path))
  if (basename(root) == "paper") root <- dirname(root)
  .num_env$registry <- reg
  .num_env$root <- root
  .num_env$cache <- list()
  invisible(reg)
}

.num_read_source <- function(rel) {
  if (!is.null(.num_env$cache[[rel]])) return(.num_env$cache[[rel]])
  p <- file.path(.num_env$root, rel)
  if (!file.exists(p)) stop("source file not found: ", rel)
  d <- read.csv(p, stringsAsFactors = FALSE, check.names = FALSE, colClasses = "character", strip.white = TRUE)
  .num_env$cache[[rel]] <- d
  d
}

.num_eq <- function(cell, want) {
  cell <- trimws(cell); want <- trimws(want)
  if (cell == want) return(TRUE)
  a <- suppressWarnings(as.numeric(cell)); b <- suppressWarnings(as.numeric(want))
  !is.na(a) && !is.na(b) && abs(a - b) < 1e-12
}

.num_select <- function(d, flt) {
  keep <- rep(TRUE, nrow(d))
  parts <- trimws(strsplit(flt, ";", fixed = TRUE)[[1]])
  parts <- parts[nzchar(parts)]
  for (p in parts) {
    kv <- strsplit(p, "=", fixed = TRUE)[[1]]
    if (length(kv) < 2) stop("bad filter clause '", p, "'")
    col <- trimws(kv[1]); alts <- strsplit(paste(kv[-1], collapse = "="), "|", fixed = TRUE)[[1]]
    if (!col %in% names(d)) stop("filter column '", col, "' not in source")
    keep <- keep & vapply(d[[col]], function(c) any(vapply(alts, function(a) .num_eq(c, a), logical(1))), logical(1))
  }
  d[keep, , drop = FALSE]
}

# Round half to EVEN on the 15-significant-digit DECIMAL representation (IEC 60559), identical to Python's
# numbers_registry.round_dec. Not formatC/sprintf: those round the binary double, and 0.9425 then prints as
# 0.943 on glibc but 0.942 elsewhere — a platform-dependent manuscript. Pure string/integer arithmetic.
.num_round_dec <- function(x, dp) {
  s <- sprintf("%.15g", x)
  if (grepl("e", s, fixed = TRUE)) s <- format(x, scientific = FALSE, digits = 15)
  neg <- startsWith(s, "-"); if (neg) s <- substring(s, 2)
  parts <- strsplit(s, ".", fixed = TRUE)[[1]]
  int_part <- parts[1]; frac <- if (length(parts) > 1) parts[2] else ""
  frac <- paste0(frac, strrep("0", max(0, dp + 1 - nchar(frac))))
  keep <- paste0(int_part, substr(frac, 1, dp))          # digits kept, as an integer string
  rest <- substr(frac, dp + 1, nchar(frac))               # digits dropped
  first <- substr(rest, 1, 1); tail <- sub("0+$", "", substr(rest, 2, nchar(rest)))
  up <- (first > "5") || (first == "5" && nzchar(tail)) ||
        (first == "5" && !nzchar(tail) && (as.integer(substr(keep, nchar(keep), nchar(keep))) %% 2L == 1L))
  digits <- as.numeric(keep) + if (up) 1 else 0
  out <- formatC(digits, format = "f", digits = 0, big.mark = "")
  if (dp > 0) {
    out <- formatC(as.numeric(out), width = dp + 1, format = "d", flag = "0")
    out <- paste0(substr(out, 1, nchar(out) - dp), ".", substr(out, nchar(out) - dp + 1, nchar(out)))
  }
  if (neg && as.numeric(out) != 0) out <- paste0("-", out)
  out
}

.num_fmt <- function(x, fmt) {
  parts <- strsplit(fmt, "!", fixed = TRUE)[[1]]
  base <- parts[1]; mods <- if (length(parts) > 1) parts[2] else ""
  if (grepl("a", mods, fixed = TRUE)) x <- abs(x)
  if (base == "d") {
    s <- .num_round_dec(x, 0)
  } else if (base == ",d") {
    s <- format(as.numeric(.num_round_dec(x, 0)), big.mark = ",", scientific = FALSE, trim = TRUE)
  } else if (base == "{,}d") {
    s <- format(as.numeric(.num_round_dec(x, 0)), big.mark = "{,}", scientific = FALSE, trim = TRUE)
  } else if (grepl("^\\.[0-9]+f$", base)) {
    s <- .num_round_dec(x, as.integer(sub("^\\.([0-9]+)f$", "\\1", base)))
  } else if (grepl("^\\.[0-9]+g$", base)) {
    s <- formatC(x, format = "g", digits = as.integer(sub("^\\.([0-9]+)g$", "\\1", base)))
  } else stop("unknown fmt '", fmt, "'")
  if (grepl("m", mods, fixed = TRUE) && startsWith(s, "-")) s <- paste0("$", s, "$")
  s
}

num_compute <- function(row) {
  key <- row[["key"]]
  if (!grepl("^[A-Za-z][A-Za-z0-9.-]*$", key)) stop("bad key '", key, "'")
  d <- .num_read_source(row[["source_file"]])
  sel <- .num_select(d, if (is.null(row[["filter"]]) || is.na(row[["filter"]])) "" else row[["filter"]])
  col <- row[["column"]]
  if (nrow(sel) > 0 && !col %in% names(sel)) stop(key, ": column '", col, "' not in ", row[["source_file"]])
  agg <- tolower(if (is.null(row[["agg"]]) || !nzchar(row[["agg"]])) "value" else row[["agg"]])
  scale <- if (is.null(row[["scale"]]) || !nzchar(row[["scale"]])) 1 else as.numeric(row[["scale"]])
  fmt <- if (is.null(row[["fmt"]]) || !nzchar(row[["fmt"]])) ".3f" else row[["fmt"]]
  vals <- suppressWarnings(as.numeric(sel[[col]])) * scale
  if (any(is.na(vals))) stop(key, ": non-numeric cell in column ", col)
  switch(agg,
    value = { if (nrow(sel) != 1) stop(key, ": filter selects ", nrow(sel), " rows, 'value' needs exactly 1"); .num_fmt(vals[1], fmt) },
    min   = .num_fmt(min(vals), fmt),
    max   = .num_fmt(max(vals), fmt),
    mean  = .num_fmt(mean(vals), fmt),
    sum   = .num_fmt(sum(vals), fmt),
    n     = .num_fmt(length(vals), if (grepl("d$", fmt)) fmt else "d"),
    range = paste0(.num_fmt(min(vals), fmt), "--", .num_fmt(max(vals), fmt)),
    stop(key, ": unknown agg '", agg, "'"))
}

num <- function(key) {
  reg <- .num_env$registry
  if (is.null(reg)) stop("call num_registry_load() first")
  i <- match(key, reg$key)
  if (is.na(i)) stop("no such key in registry: ", key)
  num_compute(as.list(reg[i, , drop = FALSE]))
}

num_all <- function(reg = .num_env$registry) {
  vals <- vapply(seq_len(nrow(reg)), function(i) num_compute(as.list(reg[i, , drop = FALSE])), character(1))
  names(vals) <- reg$key
  vals[order(names(vals))]
}

num_write_macros <- function(reg, out, registry_rel = "paper/numbers_registry.csv",
                             generator = "scripts/make_numbers_macros.R") {
  vals <- num_all(reg)
  lines <- c(
    sprintf("%% numbers_macros.tex — GENERATED from %s (Rscript scripts/make_numbers_macros.R, cross-checked by scripts/numbers_registry.py). Do not edit by hand.", registry_rel),
    "% Usage in the manuscript: \\numval{key}. Regenerate: Rscript scripts/make_numbers_macros.R <registry> <out>",
    "\\providecommand{\\numval}[1]{\\csname lab@num@#1\\endcsname}",
    sprintf("\\expandafter\\def\\csname lab@num@%s\\endcsname{%s}", names(vals), vals))
  writeLines(lines, out)
  invisible(vals)
}
