# R Code Directory

R scripts and C++ source for the nABCD simulation study and manuscript figures.

## Entry Points

| Script | Purpose |
|--------|---------|
| `run_all.R` | One-command pipeline: runs simulation then generates figures. Set `MODE` to `"quick"` or `"full"`. |
| `run_full_sim.R` | Full simulation (10,000 reps, B=2000). Sources `simulation_manuscript_v2.R`. Writes `data/simulation_results_v2.csv`. |
| `run_sim_500.R` | Quick validation run (500 reps, B=2000). Writes `data/simulation_results_v2_500reps.csv`. |

Usage (from `projects/similarity-metric/`):

```sh
Rscript R/run_all.R          # full pipeline
Rscript R/run_full_sim.R     # simulation only (overnight)
Rscript R/run_sim_500.R      # quick check (~2.5 h with Rcpp)
```

## Core Scripts

| Script | Author | Description |
|--------|--------|-------------|
| `simulation_manuscript_v2.R` | Mike Ross | Main simulation engine. Scenarios S1--S8, percentile bootstrap CI, estimation metrics (Bias, RMSE, Coverage, CI Width). Supports Rcpp/Rfast acceleration. |
| `nABCD_rcpp.cpp` | Mike Ross | C++ bootstrap implementation via Rcpp. ~50--100x faster than pure R. Includes sort-based W1 for equal-n samples and optional BCa. |
| `figures_paper.R` | Katrina Bennett | Generates all manuscript figures. Reads `data/simulation_results_v2.csv`, writes to `figures/`. Colorblind-friendly palette, SiM style. |

## Triangle Inequality Investigation

Series of scripts investigating whether nABCD satisfies the triangle inequality (prompted by Reviewer R2). Result: nABCD does **not** satisfy it; counterexample uses scale-only normals N(0,1), N(0,5), N(0,20).

| Script | Description |
|--------|-------------|
| `triangle_inequality_analysis.R` | Initial investigation with analytical helpers for W1 and mixture IQR of normal pairs. |
| `triangle_inequality_check.R` | Definitive five-part analysis: targeted counterexamples, systematic random search, dense grid, asymptotic argument, formal proof. |
| `triangle_inequality_diagnose.R` | Diagnostic follow-up on violations found in random search (88/1000). Distinguishes real violations from Monte Carlo noise. |
| `triangle_verify.R` | Clean, minimal counterexample script confirming the definitive result. |

## Verification and Replication

| Script | Author | Description |
|--------|--------|-------------|
| `verify_all.R` | Rachel + Louis + Mike | Comprehensive verification: independent nABCD implementation (no sourcing), true value checks for S1--S8. |
| `verify_true_values.R` | Mike Ross | Monte Carlo true nABCD values (n=10^6) compared to old hard-coded values. Confirms S4 coverage fix. |
| `louis_independent_replication.R` | Louis Litt | Clean-room independent replication. All functions from scratch, no project code sourced. |
| `w1_verify_louis.R` | Louis Litt | Verifies W1 implementations: midpoint method (simulation) vs left-endpoint method (paper appendix) produce identical results. |

## Output Data

| File | Description |
|------|-------------|
| `data/simulation_results_v2.csv` | Main simulation output (24 rows: 8 scenarios x 3 sample sizes). Primary results for manuscript tables. |
| `data/application_params.csv` | Hypothetical application parameters (3 regions x 3 EMs) used for illustrative examples. |

---

## Application Analysis Scripts

R scripts that apply nABCD to real clinical trial datasets. Located in `data/` subdirectories alongside their source data.

### IST-3 (Third International Stroke Trial)

Directory: `data/IST3/`

| Script | Description |
|--------|-------------|
| `ist3_nABCD_age.R` | Age (confirmed EM for alteplase) analysis across countries. Computes pairwise W1 and nABCD for age distributions. Based on Emberson et al. *Lancet* 2014. |
| `ist3_nABCD_case_study.R` | Clinical calibration case study covering three confirmed effect modifiers: age, treatment delay, and NIHSS (baseline stroke severity). |
| `ist3_nabcd_vs_smd.R` | Head-to-head comparison of nABCD vs SMD (Cohen's d) for all 28 country pairs across 3 EMs. Demonstrates cases where SMD approx 0 but nABCD is non-trivial. |
| `ist3_skewed_em_search.R` | Searches for skewed EM candidates where nABCD diverges most from SMD. Filters countries with n >= 50. |
| `ist3_clinical_calibration.R` | Clinical calibration via Delta_max = 2 * L * IQR_pooled * nABCD, where L is the CATE sensitivity (Lipschitz constant) estimated from treatment-by-EM interaction in logistic regression. Binary outcome: OHS 0--2 at 6 months. |

Data files: `ist3.dat` (raw), `ist3_key_vars.csv`, `ist3_full_vars.csv`, `ist3.sas` (format definitions).

### GUSTO-I (Global Utilization of Streptokinase and TPA for Occluded Arteries)

Canonical script: `R/gusto_case_study.R` (outputs to `GUSTO/`)

| Script | Location | Description |
|--------|----------|-------------|
| `gusto_case_study.R` | `R/` | **Paper Case C**: Full case study with anchor Region 13, three EMs (sysbp, age, pulse), bootstrap CIs, clinical calibration, pooling decisions. Outputs CSV + PDF/PNG to `GUSTO/`. |
| `gusto_nABCD.R` | `data/GUSTO/` | Exploratory pairwise nABCD and SMD across 16 regions for 5 continuous variables. |
| `gusto_distribution_profile.R` | `data/GUSTO/` | Distribution profiling: overall and regional summaries, normality tests, density/boxplot PDFs. |
| `gusto_pooling_analysis.R` | `data/GUSTO/` | Pooling partner selection analysis with multivariate scoring and bootstrap CIs. |

Output directory: `GUSTO/` (CSV results + figures)

Also: `data/gusto.csv` is a local CSV export of the GUSTO-I data. The dataset is also available via `predtools::gusto`.

### IST-1 (International Stroke Trial)

Directory: `data/IST/`

| Script | Description |
|--------|-------------|
| `ist1_global_nABCD.R` | Country-level pairwise nABCD vs SMD comparisons for age, resting SBP, and treatment delay. Includes correlation analysis, divergence detection, and Asia-focused subset. Countries filtered to n >= 50. |

Data files: `IST_corrected.csv`, `IST_variables.csv`.

### CRASH-2 (Clinical Randomisation of an Antifibrinolytic in Significant Haemorrhage)

Directory: `data/CRASH2/`

No analysis script yet. Contains `crash2.rds` (R data file) and data dictionary (`CRASH2_DataDictionary.html`, `CRASH2_DataDictionary.pdf`).

---

## Dependencies

- **R packages**: stats, future.apply, ggplot2, dplyr, tidyr, readr, patchwork, predtools (GUSTO data)
- **Optional acceleration**: Rcpp (C++ bootstrap), Rfast (faster column sort)
- **Parallelization**: `future.apply` with `plan(multisession)`. Full simulation uses all available cores minus one.
