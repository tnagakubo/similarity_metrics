# Statistics in Medicine Submission Checklist

**Manuscript**: nABCD: A Normalized Metric for Comparing Effect Modifier Distributions in MRCTs

**Target Journal**: Statistics in Medicine (Wiley)

**Submission URL**: https://mc.manuscriptcentral.com/sim

---

## Pre-Submission Checklist

### Required Files

| File | Format | Status | Notes |
|------|--------|--------|-------|
| Main manuscript | .docx or .tex+.pdf | 🔴 TODO | Convert from markdown |
| Title page | .docx | 🟡 Draft | `submission/title_page.md` |
| Cover letter | .docx | 🟡 Draft | `submission/cover_letter.md` |
| Figure 1 | .tiff or .png (300 dpi) | 🔴 TODO | Run R code |
| Figure 2 | .tiff or .png (300 dpi) | 🔴 TODO | Run R code |
| Figure 3 | .tiff or .png (300 dpi) | 🔴 TODO | Run R code |
| Figure 4 | .tiff or .png (300 dpi) | 🔴 TODO | Run R code |
| Supplementary material | .zip | 🔴 TODO | R code package |

### Manuscript Requirements

| Requirement | Limit | Current | Status |
|-------------|-------|---------|--------|
| Abstract | ≤250 words | 248 | ✅ |
| Short title | ≤70 chars | 42 | ✅ |
| Keywords | ≤6 | 6 | ✅ |
| References | Numbered | 10 | ✅ |
| Figures | Separate files | 4 planned | 🔴 |
| Tables | In manuscript | 7 | 🟡 |

### Format Specifications

| Element | Specification | Status |
|---------|---------------|--------|
| Font | Times New Roman 12pt | 🔴 TODO |
| Line spacing | Double | 🔴 TODO |
| Margins | 1 inch all sides | 🔴 TODO |
| Page numbers | Bottom center | 🔴 TODO |
| Line numbers | Continuous | 🔴 TODO |
| Figure format | TIFF/PNG 300 dpi | 🔴 TODO |
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

- [ ] **Convert manuscript to Word**
  - Option A: Pandoc
    ```bash
    pandoc paper/nABCD_manuscript_SiM.md -o paper/submission/nABCD_manuscript.docx
    ```
  - Option B: Manual copy to Word template

- [ ] **Format tables in Word**
  - Use Word's table feature
  - No vertical lines (SiM style)
  - Horizontal lines: top, header bottom, table bottom only

- [ ] **Finalize title page**
  - Add author names and affiliations
  - Convert to .docx

- [ ] **Finalize cover letter**
  - Add date and signatures
  - Convert to .docx

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
   - Main document (.docx)
   - Title page (.docx)
   - Figures (separate files)
   - Supplementary material (.zip)
   - Cover letter (.docx)
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
*Last updated: 2026-02-05*
