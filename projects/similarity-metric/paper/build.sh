#!/bin/bash
# Build script for per-EM W1 paper (Path α framework — confirmed 2026-06-15)
# Superseded nABCD_wiley.tex moved to archive/superseded_20260615/
# Sets TEXINPUTS so pdflatex can find Wiley template files

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
export TEXINPUTS="$SCRIPT_DIR/wiley-template//:$TEXINPUTS"
export TEXFONTS="$SCRIPT_DIR/wiley-template/Fonts//:$TEXFONTS"

cd "$SCRIPT_DIR" || exit 1
TARGET="per_em_W1_wiley"

pdflatex -interaction=nonstopmode "$SCRIPT_DIR/${TARGET}.tex"
bibtex "$SCRIPT_DIR/${TARGET}"
pdflatex -interaction=nonstopmode "$SCRIPT_DIR/${TARGET}.tex"
pdflatex -interaction=nonstopmode "$SCRIPT_DIR/${TARGET}.tex"

mv "$SCRIPT_DIR/${TARGET}.pdf" "$SCRIPT_DIR/output/" 2>/dev/null
echo "Build complete: output/${TARGET}.pdf"
