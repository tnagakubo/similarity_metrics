## count_abstract_words.R -------------------------------------------------
## Word-count gate for the SiM abstract (limit: 250 words, no citations).
##
## Two de-TeX strategies are reported because they bracket the true count:
##   "math_as_word"  -- each inline $...$ group counts as one word
##                      (how a copy-paste into a word processor behaves:
##                       "$W_1$" pastes as the single token "W1")
##   "math_dropped"  -- inline math removed entirely (lower bound)
## Journal submission portals count the pasted plain-text abstract, so
## math_as_word is the operative number.

## Brace-matched extraction: regex alone cannot find the closing brace of
## \abstract{...} because the body contains balanced braces of its own.
extract_abstract <- function(tex_path) {
  txt <- paste(readLines(tex_path, warn = FALSE, encoding = "UTF-8"),
               collapse = "\n")
  start <- regexpr("\\\\abstract[[:space:]]*(\\[[^]]*\\])?[[:space:]]*\\{", txt,
                   perl = TRUE)
  if (start[1] == -1L) stop("no \\abstract{...} block found in ", tex_path)
  open_at <- start[1] + attr(start, "match.length") - 1L   # index of the '{'
  ch <- strsplit(txt, "")[[1]]
  depth <- 0L
  close_at <- NA_integer_
  for (i in seq(open_at, length(ch))) {
    if (ch[i] == "{" && (i == 1L || ch[i - 1L] != "\\")) depth <- depth + 1L
    else if (ch[i] == "}" && ch[i - 1L] != "\\") {
      depth <- depth - 1L
      if (depth == 0L) { close_at <- i; break }
    }
  }
  if (is.na(close_at)) stop("unbalanced braces in \\abstract{} of ", tex_path)
  body <- paste(ch[(open_at + 1L):(close_at - 1L)], collapse = "")
  sub("^%[[:space:]]*\n?", "", body)   # drop the leading line-join comment
}

detex <- function(x, math = c("math_as_word", "math_dropped")) {
  math <- match.arg(math)
  x <- gsub("(?<!\\\\)%.*", "", x, perl = TRUE)          # TeX comments
  x <- gsub("\\$[^$]*\\$", if (math == "math_as_word") " MATHTOKEN " else " ", x)
  x <- gsub("``|''", "\"", x)
  x <- gsub("---|--", " ", x)                            # em/en dash = word break
  x <- gsub("\\\\[a-zA-Z]+\\*?", " ", x)                 # residual macros
  x <- gsub("[{}\\\\]", " ", x)
  x
}

count_words <- function(x) {
  w <- unlist(strsplit(x, "[[:space:]]+"))
  sum(grepl("[[:alnum:]]", w))
}

abstract_report <- function(tex_path, label = basename(tex_path), limit = 250) {
  body <- extract_abstract(tex_path)
  data.frame(
    file          = label,
    math_as_word  = count_words(detex(body, "math_as_word")),
    math_dropped  = count_words(detex(body, "math_dropped")),
    characters    = nchar(gsub("[[:space:]]+", " ", trimws(detex(body, "math_as_word")))),
    has_citation  = grepl("\\\\cite", body),
    limit         = limit,
    stringsAsFactors = FALSE
  )
}

if (sys.nframe() == 0L) {
  args <- commandArgs(trailingOnly = TRUE)
  res <- do.call(rbind, lapply(args, abstract_report))
  res$over_limit <- res$math_as_word - res$limit
  res$PASS <- res$math_as_word <= res$limit & !res$has_citation
  print(res, row.names = FALSE)
}
