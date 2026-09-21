#!/bin/bash
# Build the corrected per-EM W1 manuscript.
#
# Nothing is copied from ../paper: the Wiley class/style files, the fonts,
# the .bib and the .bst are all resolved in place through TEXINPUTS /
# TEXFONTS / BIBINPUTS / BSTINPUTS, so this folder holds exactly one new
# file -- the manuscript -- and the bibliography has a single source of
# truth. \graphicspath{{../figures/}} in the .tex resolves from here
# because claude_science/ sits at the same depth as paper/.
set -u

HERE="$(cd "$(dirname "$0")" && pwd)"
PAPER="$(cd "$HERE/../paper" && pwd)"
TMPL="$PAPER/wiley-template"
TARGET="per_em_W1_wiley"

export TEXINPUTS="$TMPL//:$PAPER//:$TEXINPUTS"
export TEXFONTS="$TMPL/Fonts//:$TEXFONTS"
export BIBINPUTS="$PAPER//:$BIBINPUTS"
export BSTINPUTS="$TMPL//:$PAPER//:$BSTINPUTS"

cd "$HERE" || exit 1
pdflatex -interaction=nonstopmode "$TARGET.tex"
bibtex   "$TARGET"
pdflatex -interaction=nonstopmode "$TARGET.tex"
pdflatex -interaction=nonstopmode "$TARGET.tex"

errs=$(grep -c '^!' "$TARGET.log" || true)
undef=$(grep -c "LaTeX Warning: \(Reference\|Citation\) \`" "$TARGET.log" || true)
echo
echo "build complete: $TARGET.pdf"
echo "  errors in log      : $errs"
echo "  undefined ref/cite : $undef"
