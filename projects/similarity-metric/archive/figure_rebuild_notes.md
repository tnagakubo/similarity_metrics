# Path α (W₁) figure rebuild — notes

**Date:** 2026-05-16
**Author:** Katrina Bennett
**Driver:** `projects/similarity-metric/R/figures_paper_W1.R`
**Inputs:**
- `results/w1_raw_simulation.rds` (repo root)  — 10,000 reps × 7 scenarios × 3 sample sizes
- `projects/similarity-metric/data/GUSTO/gusto_r8_results.csv`

## Approach

A standalone script `figures_paper_W1.R` was added under `projects/similarity-metric/R/`. It mirrors the structure of `figures_paper.R` (paper standards: width = 7", base_size = 11, white background, greyscale + `_color` variants) but adapts the encoding to the Path α framework:

- Fig 1: kept the v2 CDF-area construction; only the visible label was already `W₁`, so no plot-level change was needed beyond renaming the file.
- Fig 2: switched simulation source from `data/simulation_results_v2.csv` (nABCD-scale) to `results/w1_raw_simulation.rds` (W₁ raw scale).
- Fig 3: kept the v2 GUSTO data file (nABCD column is numerically identical to ρ̂), only the axis label was rewritten as `ρ̂ = Ŵ₁ / ÎQR_pooled`.

## Per-figure summary

### Figure 1 — `fig1_w1_definition.{pdf,png}` (+ `_color` slide variant)

- **Status:** rebuilt
- **Data:** conceptual (closed-form), Gamma(shape=4, scale=10) vs Normal(55, 10²) — same as v2 Fig 1
- **Encoding:** PDFs (panel A) + CDFs (panel B), shaded area = W₁
- **Axis convention:** Effect-modifier value (x), Density / Cumulative probability (y); annotation `W₁` placed at the maximum CDF gap
- **Dimensions:** 7" × 3"
- **Notes:** The v2 file `fig1_nabcd_definition.{pdf,png}` was already labelled `W₁` in the shaded region; the new file is essentially a rename. The original v2 files are preserved untouched (legacy nABCD framing).

### Figure 2 — `fig2_simulation_results.{pdf,png}` (+ `_color`)

- **Status:** rebuilt twice. (1) 2026-05-16 line plot (W₁ raw replacement of v2 ρ̂ figure). (2) **2026-05-17 grouped bar-chart redesign** per Tak directive (this version, current files). **Filename preserved** to avoid breaking the `\includegraphics{fig2_simulation_results.pdf}` reference in `per_em_W1_wiley.tex` (l.257). Caption text in §3.2 needs a minor encoding-description update (see *Suggested caption updates for Mike* below).
- **Driver script (current):** `R/fig2_bar_chart.R` (`generate_fig2_bars()`). The previous line-plot generator in `R/figures_paper_W1.R` (`fig2_w1_simulation()`) is retained for reference but no longer drives the output files; `R/fig2_bar_chart.R` overwrites them.
- **Data:** `results/w1_raw_simulation.rds` (10,000 reps × 21 cells, S1–S7 × {n=50, 100, 200})
- **Encoding (bar version):** 3 horizontal panels, **grouped bar chart**
  - (A) Bias of Ŵ₁ in W₁ units
  - (B) Coverage of 95% percentile bootstrap CI for W₁
  - (C) Mean CI width in W₁ units
- **Axis convention:** x = scenario (S1, …, S7); fill = sample size (n=50, n=100, n=200), three bars side-by-side per scenario (`position_dodge(0.8)`, width 0.7).
- **Reference lines:** Bias panel → y=0 (dashed); Coverage panel → y=0.95 (dashed).
- **Dimensions:** 10" × 3.5" (`\includegraphics[width=\textwidth]` retained).
- **Y-axis label rationale:** unchanged — "(units of W₁)" since the simulation baseline is N(50, 10²); carries through to GUSTO-I units by Path α invariance (Supplement A).

#### Sample-size palette (matches v2 nABCD figures)

Identified from `figures_paper.R` `.sample_size_palette()` (used by v2 `fig3_bias`, `fig4a_coverage`, `fig4b_precision`). Reused unchanged in `R/fig2_bar_chart.R` `.sample_size_palette_fig2()`:

| Sample size | Greyscale (paper) | Color (slides) |
|---|---|---|
| n=50  | `#999999` (light grey) | `#F4A39B` (pale red) |
| n=100 | `#555555` (mid grey)   | `#D52B1E` (theme red) |
| n=200 | `#1A1A1A` (near black) | `#8B0000` (deep red) |

Rationale: monotone-luminance ramp keeps grayscale order intact under B&W printing; the slide variant uses the `#D52B1E` theme red as the mid anchor so the family stays visually consistent with the rest of the slide deck.

#### Bar-chart design choices

- **Scenario order on x-axis** (S1 → S7) preserves the contiguous-scenario ordering used in §3.1 and Table 1; no reordering by effect size.
- **Sample-size order in legend** (n=50, n=100, n=200, ascending) matches the natural reading order and the palette's light → dark luminance ramp, reinforcing the perceptual mapping "darker = larger n".
- **Dodge width 0.8, bar width 0.7** gives a small white gap between adjacent bars within a scenario group, and a larger gap between scenarios — matches v2 `fig3_bias` / `fig4a_coverage` geometry.
- **No error bars** on Panel A (bias) or Panel C (CI width): each cell summarises 10,000 reps, so Monte-Carlo SE is ≲ 0.03 in W₁ units (much smaller than the visible bar height), and adding error bars would add visual clutter without information. (Panel B already shows coverage on its own [0,1] scale, which is the relevant uncertainty metric for inference.)
- **S1 in Panel B:** coverage is structurally 0 (W₁ = 0 lies at the parameter-space boundary, and the percentile bootstrap CI is constructed from a positive estimator). Bars correctly render as zero-height; consistent with v2 `fig4a_coverage` which used an explicit "0" text label for these cells. **Decision:** omit the explicit "0" annotations in the W₁ figure — the boundary issue is now discussed in §3.2 text and the all-zero S1 cluster is self-evident. If Mike wants them restored for symmetry with the v2 nABCD figure, adding `geom_text()` for `coverage_pct == 0` cells is a one-line change in `R/fig2_bar_chart.R`.

#### Suggested caption updates for Mike (`per_em_W1_wiley.tex`, l.258)

The current caption (set at the line-plot rebuild on 2026-05-16) still reads:

> "Estimation properties of $\hat{\rho} = \widehat{W}_1 / \widehat{\text{IQR}}_{\text{pooled}}$ across scenarios (S1--S7) and sample sizes ($n = 50, 100, 200$). [...] Panel~(C): mean CI width in units of $\hat{\rho}$."

Two inaccuracies for the **bar version** that Mike should fix:

1. **Unit description.** The figure now plots $\widehat{W}_1$ in raw $W_1$ units (matching the y-axis labels "(units of $W_1$)"), not $\hat{\rho}$. Replace "Estimation properties of $\hat{\rho} = \widehat{W}_1 / \widehat{\text{IQR}}_{\text{pooled}}$" with something like "Estimation properties of $\widehat{W}_1$ (raw $W_1$ units) across scenarios (S1--S7) and sample sizes ($n = 50, 100, 200$)." Panel C end should read "mean CI width in $W_1$ units."
2. **Encoding mention (per caption-writing rule).** The figure is now a grouped bar chart, not a line plot, so the caption should add one short clause naming the geometry: e.g. "Bars within each scenario correspond to $n = 50, 100, 200$ (light to dark)." This honours `feedback_caption_writing.md` (caption describes what is plotted).

No changes are needed to:
- The dashed reference lines description (still y=0 and y=0.95).
- The S1 boundary explanation in panel B.

### Figure 3 — `fig3_gusto_r8_forest.{pdf,png}` (+ `_color`)

- **Status:** rebuilt, **filename preserved**
- **Data:** `data/GUSTO/gusto_r8_results.csv` — same numerical values as v2 (the `nABCD_*` columns are by definition Ŵ₁/ÎQR_pooled = ρ̂)
- **Encoding:** 2 panels (A) Age, (B) Systolic blood pressure; one point + 95% percentile bootstrap CI per partner region; partners ordered by ascending ρ̂ within each panel
- **Axis convention:** x = ρ̂ = Ŵ₁ / ÎQR_pooled (dimensionless); y = partner region (R1, R2, …, R16 excluding R8)
- **Dimensions:** 7" × 3.5"
- **Choice rationale (ρ̂ vs Ŵ₁ raw units):** The §4.2 paper text consistently uses ρ̂ for cross-EM comparability, and Table `tab:gusto_nabcd` reports ρ̂ values. The figure caption (l.416) also names the axis as `ρ̂`. Using ρ̂ also keeps the age panel (years) and SBP panel (mmHg) on a common dimensionless scale that supports direct visual comparison of partner-region rankings.

## File status summary

| File | v2 status | Action |
|------|-----------|--------|
| `fig1_nabcd_definition.{pdf,png}` | v2, kept | **Preserved** (legacy; Mike to remove or supplement-move) |
| `fig1_nabcd_definition_color.{pdf,png}` | v2 slide | **Preserved** |
| `fig1_w1_definition.{pdf,png}` | NEW | **Created** (paper, greyscale) |
| `fig1_w1_definition_color.{pdf,png}` | NEW | **Created** (slides, `#D52B1E`) |
| `fig2_simulation_results.{pdf,png}` | v2 ρ̂-based | **Overwritten** (W₁ raw, greyscale) |
| `fig2_simulation_results_color.{pdf,png}` | v2 ρ̂-based | **Overwritten** (W₁ raw, color) |
| `fig3_gusto_r8_forest.{pdf,png}` | v2 nABCD label | **Overwritten** (ρ̂ label, otherwise identical numerics) |
| `fig3_gusto_r8_forest_color.{pdf,png}` | v2 nABCD label | **Overwritten** |

## v2 figures that could move to supplement (Mike to decide)

These are no longer referenced in the Path α main paper but were active in v2:

- `fig2_bias.{pdf,png}` (single-panel bias only; Path α uses combined fig2)
- `fig3_estimation_quality.{pdf,png}` (coverage + width 2-panel; superseded by fig2 panels B, C)
- `fig3_simulation_rmse.{pdf,png}` (RMSE only; Path α has not retained an RMSE-only figure in the main paper)
- `fig4_simulation_coverage.{pdf,png}` (coverage only; superseded)
- `fig5_simulation_width.{pdf,png}` (width only; superseded)

Recommendation: move RMSE figure to supplement (the Path α framework still cares about RMSE, but it's a secondary metric); delete or archive the rest as they are exact subsets of the combined fig2.

## Deviations from paper standard

None for figs 1, 3.

For fig 2, the figure spans `\textwidth` (not the standard 7" paper text column) because §3.2 uses `\includegraphics[width=\textwidth]{fig2_simulation_results.pdf}`. The 10" × 3.5" dimensions match v2 and preserve readability of the three side-by-side panels.

## How to regenerate

For **figs 1 and 3** (definition + GUSTO forest), the original driver is still authoritative:

```bash
cd /c/Users/hrd13/Documents/Gak/0\ Study/800Claude/20260210_SIM/similarity_metrics
Rscript projects/similarity-metric/R/figures_paper_W1.R
```

For **fig 2** (simulation OC bar chart, current version), use the dedicated driver:

```bash
cd /c/Users/hrd13/Documents/Gak/0\ Study/800Claude/20260210_SIM/similarity_metrics
Rscript projects/similarity-metric/R/fig2_bar_chart.R
```

Or, from R:

```r
source("projects/similarity-metric/R/fig2_bar_chart.R")
generate_fig2_bars()
```

Important: if `figures_paper_W1.R` is run after `fig2_bar_chart.R`, it will overwrite `fig2_simulation_results*.{pdf,png}` with the older line-plot version. Tak's directive (2026-05-17) is to keep the bar version, so run `fig2_bar_chart.R` last (or only run it for fig 2).
