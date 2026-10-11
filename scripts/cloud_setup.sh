#!/bin/bash
# cloud_setup.sh — setup script for Claude Code cloud sessions (environment settings → Setup script).
# Installs what the lab's gates need to RUN (not just lint): R for the simulations / numbers macros,
# TeX Live for the manuscript build, PyYAML for the protocol compiler. Idempotent; ~5 minutes on first run.
# Verified 2026-10-11 on the Ubuntu-based cloud image (r-base-core 4.3.3, texlive 2023).
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive
if ! command -v Rscript >/dev/null 2>&1 || ! command -v pdflatex >/dev/null 2>&1 || ! python3 -c 'import yaml' 2>/dev/null; then
  apt-get update -qq
  apt-get install -y --no-install-recommends \
    r-base-core python3-yaml \
    texlive-latex-base texlive-latex-recommended texlive-latex-extra texlive-fonts-recommended texlive-science texlive-bibtex-extra texlive-plain-generic
fi
# R packages used by the lab's own scripts are base R only. Project pipelines declare theirs in renv.lock / sessionInfo.
# Uncomment when a project needs them in the cloud:
# Rscript -e 'pk <- c("tidyverse","Rcpp","ggplot2"); inst <- pk[!pk %in% rownames(installed.packages())]; if (length(inst)) install.packages(inst, repos = "https://cloud.r-project.org")'
echo "cloud_setup: R $(Rscript -e 'cat(as.character(getRversion()))'), $(pdflatex --version | head -1), pyyaml $(python3 -c 'import yaml;print(yaml.__version__)')"
