# Statistics in Medicine Submission Checklist

**Manuscript**: nABCD: A Normalized Metric for Comparing Effect Modifier Distributions in MRCTs

**Target Journal**: Statistics in Medicine (Wiley)

**Submission URL**: https://mc.manuscriptcentral.com/sim

---

## Pre-Submission Checklist

### Required Files

| File | Format | Status | Notes |
|------|--------|--------|-------|
| Main manuscript | .tex + .pdf | ✅ Done | `nABCD_wiley.tex` + compiled PDF |
| Title page | .tex or .pdf | 🟡 Draft | `submission/title_page.md` → integrate into .tex |
| Cover letter | .pdf | 🟡 Draft | `submission/cover_letter.md` → convert to PDF |
| Figure 1 | .eps, .pdf, or .tiff | ✅ Done | fig1_nabcd_definition.pdf/.png |
| Figure 2 | .eps, .pdf, or .tiff | ✅ Done | fig2_bias.pdf/.png |
| Figure 3 | .eps, .pdf, or .tiff | ✅ Done | fig3_estimation_quality.pdf/.png |
| Figure 4 | .eps, .pdf, or .tiff | ✅ Done | fig4_gusto_r8_forest.pdf/.png |
| Figure 5 | .eps, .pdf, or .tiff | ✅ Done | fig5_gusto_r8_scatter.pdf/.png |
| Slides-only figure | .pdf/.png | ✅ Done | slide_scenario_overview.pdf/.png (paper omits) |
| Calibration / density figures | .pdf/.png | ✅ Done | fig_gusto_r8_{calibration,density_similar,density_dissimilar}.pdf/.png (slides only) |
| Supplementary material | .zip | 🔴 TODO | R code package |

### Manuscript Requirements

| Requirement | Limit | Current | Status |
|-------------|-------|---------|--------|
| Abstract | ≤250 words | 248 | ✅ |
| Short title | ≤70 chars | 42 | ✅ |
| Keywords | ≤6 | 6 | ✅ |
| References | Numbered | 10 | ✅ |
| Figures | Separate files | 6 generated | ✅ |
| Tables | In manuscript | 7 | 🟡 |

### Format Specifications

| Element | Specification | Status |
|---------|---------------|--------|
| Font | Times/Helvetica/Courier 12pt | 🟢 LaTeX handles |
| Line spacing | Not required (SiM guideline) | 🟢 N/A |
| Margins | Standard LaTeX | 🟢 LaTeX handles |
| Page numbers | Standard LaTeX | 🟢 LaTeX handles |
| Line numbers | Optional for submission | 🟡 Add lineno pkg |
| Figure format | EPS/PDF/TIFF | ✅ PDF available |
| Reference style | Vancouver (numbered) | ✅ |

---

## Action Items

### Phase 1: Critical (Must Have)

- [ ] **Generate figures** — Run `R/figures_paper.R`
  ```r
  setwd("projects/similarity-metric")
  source("R/figures_paper.R")
  generate_all_figures()
  ```

- [x] ~~**Convert manuscript to Word**~~ — **NOT NEEDED**: SiM accepts LaTeX directly
  - Submit compiled PDF as "Main Document"
  - Upload .tex source + .bib/.bbl as "Supplemental Material not for review"

- [ ] **Verify LaTeX compiles cleanly** — Ensure nABCD_wiley.tex produces clean PDF

- [ ] **Finalize title page**
  - Add author names, affiliations, ORCID
  - Integrate into .tex or submit as separate PDF

- [ ] **Finalize cover letter**
  - Add date and signatures
  - Convert to PDF

### Phase 2: Supporting

- [ ] **Package R code**
  ```
  nABCD_code.zip/
  ├── R/
  │   ├── nABCD_functions.R
  │   ├── figures_paper.R
  │   └── simulation_code.R
  ├── data/
  │   ├── simulation_results.csv
  │   └── application_params.csv
  └── README.md
  ```

- [ ] **Create supplementary document**
  - Additional simulation results
  - Proofs (if moved from main text)

### Phase 3: Final Review

- [ ] **Proofread all files**
- [ ] **Check figure quality** (300 dpi minimum)
- [ ] **Verify reference formatting**
- [ ] **Spell check**
- [ ] **Grammar check**

---

## Submission Process

1. Go to https://mc.manuscriptcentral.com/sim
2. Create account / Login
3. Start new submission
4. Select article type: "Original Article"
5. Upload files in order:
   - Main document: compiled PDF (File Designation: "Main Document")
   - TeX source files + .bib/.bbl (File Designation: "Supplemental Material not for review")
   - Figures: separate EPS/PDF/TIFF files
   - Supplementary material: R code .zip
   - Cover letter: PDF
6. Enter metadata (title, abstract, keywords, authors)
7. Suggest reviewers (optional but recommended)
8. Submit

---

## Reviewer Suggestions (Optional)

| Name | Affiliation | Expertise | Email |
|------|-------------|-----------|-------|
| [Name 1] | [University] | MRCT methodology | |
| [Name 2] | [University] | Optimal transport | |
| [Name 3] | [Regulatory] | ICH guidelines | |

---

## Post-Submission

- [ ] Confirmation email received
- [ ] Manuscript ID recorded
- [ ] Track status via ScholarOne

---

*Checklist created: 2026-02-05*
*Last updated: 2026-02-23 — Jessica review: LaTeX submission confirmed, docx conversion removed*
