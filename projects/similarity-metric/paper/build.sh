#!/bin/bash
# Build script for nABCD paper
# Sets TEXINPUTS so pdflatex can find Wiley template files

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
export TEXINPUTS="$SCRIPT_DIR/wiley-template//:$TEXINPUTS"
export TEXFONTS="$SCRIPT_DIR/wiley-template/Fonts//:$TEXFONTS"

cd "$SCRIPT_DIR" || exit 1
pdflatex -interaction=nonstopmode "$SCRIPT_DIR/nABCD_wiley.tex"
# Run twice for references
pdflatex -interaction=nonstopmode "$SCRIPT_DIR/nABCD_wiley.tex"

mv "$SCRIPT_DIR/nABCD_wiley.pdf" "$SCRIPT_DIR/output/" 2>/dev/null
echo "Build complete: output/nABCD_wiley.pdf"
