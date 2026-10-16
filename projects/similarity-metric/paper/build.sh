#!/bin/bash
# Build script for per-EM W1 paper (Path α framework — confirmed 2026-06-15)
# Superseded nABCD_wiley.tex moved to archive/superseded_20260615/
# The Wiley class/style files are read from this directory (paper/); wiley-template/ holds the pristine template + Fonts.
# 2026-10-17: TEXINPUTS is now prepended with the OS path separator (':' on Linux/macOS, ';' on Windows TeX Live under MSYS),
# keeping the default search path (so './WileyNJDv5.cls' is still found), and the PDF is moved to output/ only when
# pdflatex actually produced one — a failed build used to `mv` the tracked PDF away.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
case "$(uname -s)" in
  MINGW*|MSYS*|CYGWIN*) SEP=";"; TPL="$(cygpath -w "$SCRIPT_DIR/wiley-template" 2>/dev/null || echo "$SCRIPT_DIR/wiley-template")" ;;
  *)                    SEP=":"; TPL="$SCRIPT_DIR/wiley-template" ;;
esac
export TEXINPUTS=".${SEP}${TPL}//${SEP}${TEXINPUTS:-}"
export TEXFONTS="${TPL}/Fonts//${SEP}${TEXFONTS:-}"

cd "$SCRIPT_DIR" || exit 1
TARGET="per_em_W1_wiley"

pdflatex -interaction=nonstopmode "${TARGET}.tex"
bibtex "${TARGET}"   # relative: TeX Live refuses to write .bbl/.blg for an absolute path (openout_any = p); cwd is already paper/
pdflatex -interaction=nonstopmode "${TARGET}.tex"
pdflatex -interaction=nonstopmode "${TARGET}.tex"
STATUS=$?

mkdir -p "$SCRIPT_DIR/output"
if [ "$STATUS" -eq 0 ] && grep -q '^Output written on' "${TARGET}.log"; then
  cp "${TARGET}.pdf" "$SCRIPT_DIR/output/${TARGET}.pdf"
  echo "Build complete: output/${TARGET}.pdf ($(grep -oE '\([0-9]+ pages' "${TARGET}.log" | tail -1 | tr -d '('))"
else
  echo "Build FAILED — see ${TARGET}.log (tracked ${TARGET}.pdf left untouched)" >&2
  exit 1
fi
