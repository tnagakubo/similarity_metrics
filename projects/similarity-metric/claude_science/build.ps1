# Build the corrected per-EM W1 manuscript.
#
# Nothing is copied from ..\paper: the Wiley class/style files, the fonts,
# the .bib and the .bst are all resolved in place through TEXINPUTS /
# TEXFONTS / BIBINPUTS / BSTINPUTS, so this folder holds exactly one new
# file -- the manuscript -- and the bibliography has a single source of
# truth. \graphicspath{{../figures/}} in the .tex resolves from here
# because claude_science\ sits at the same depth as paper\.

$ErrorActionPreference = "Stop"
$here  = $PSScriptRoot
$paper = Join-Path (Split-Path $here -Parent) "paper"
$tmpl  = Join-Path $paper "wiley-template"
$target = "per_em_W1_wiley"

$env:TEXINPUTS = "$tmpl//;$paper//;" + $env:TEXINPUTS
$env:TEXFONTS  = "$tmpl/Fonts//;"    + $env:TEXFONTS
$env:BIBINPUTS = "$paper//;"         + $env:BIBINPUTS
$env:BSTINPUTS = "$tmpl//;$paper//;" + $env:BSTINPUTS

Push-Location $here
try {
    pdflatex -interaction=nonstopmode "$target.tex"
    bibtex   $target
    pdflatex -interaction=nonstopmode "$target.tex"
    pdflatex -interaction=nonstopmode "$target.tex"

    $log = Get-Content "$target.log" -Raw
    $undef = ([regex]::Matches($log, "LaTeX Warning: (Reference|Citation) `[^']*' on page")).Count
    $errs  = ([regex]::Matches($log, "(?m)^!")).Count
    Write-Host ""
    Write-Host "build complete: $target.pdf"
    Write-Host "  errors in log      : $errs"
    Write-Host "  undefined ref/cite : $undef"
    if ($errs -gt 0 -or $undef -gt 0) {
        Write-Warning "log is not clean -- inspect $target.log"
    }
}
finally { Pop-Location }
