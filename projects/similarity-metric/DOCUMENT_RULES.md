# Document Organization Rules - similarity-metric Project

**Created by**: Donna Paulsen
**Date**: 2026-02-03
**Status**: Active

---

## Directory Structure

```
projects/similarity-metric/
├── DOCUMENT_RULES.md          # This file
├── paper/                      # Manuscript files
│   ├── sections/              # Individual sections
│   │   ├── 01_introduction.md
│   │   ├── 02_methods.md
│   │   ├── 03_simulation.md
│   │   ├── 04_results.md
│   │   ├── 05_discussion.md
│   │   └── appendices/
│   └── figures/               # Publication figures
├── R/                         # R code
│   ├── nabcd.R               # Core functions
│   ├── power_normal_sim.R    # Simulation code
│   └── benchmark_sim.R       # Comparison simulations
├── results/                   # Simulation outputs
│   ├── raw/                  # Raw .rds files
│   └── tables/               # Summary tables (.csv)
├── notes/                     # Working notes (temporary)
│   ├── verification_notes.md
│   ├── corrected_true_values.md
│   └── appendix_b_corrected.md
└── archive/                   # Superseded documents
```

---

## File Naming Conventions

| Type | Format | Example |
|------|--------|---------|
| Paper sections | `NN_sectionname.md` | `01_introduction.md` |
| R scripts | `snake_case.R` | `power_normal_sim.R` |
| Results | `YYYYMMDD_description.csv` | `20260203_benchmark_results.csv` |
| Figures | `figNN_description.png` | `fig01_bias_comparison.png` |
| Notes | `descriptive_name.md` | `verification_notes.md` |

---

## Document Status Tags

Every document should include a status in its header:

| Tag | Meaning |
|-----|---------|
| `Draft` | Work in progress, not reviewed |
| `Review` | Ready for internal review |
| `Approved` | Reviewed and approved |
| `Superseded` | Replaced by newer version (move to archive/) |
| `Reference` | External reference, do not edit |

---

## Version Control

- Major revisions: Create new file with `_v2`, `_v3` suffix
- Minor edits: Edit in place, update date in header
- Superseded files: Move to `archive/` with date suffix

---

## Required Headers

Every `.md` file must include:

```markdown
# [Title]

**Author**: [Name]
**Date**: YYYY-MM-DD
**Status**: [Draft|Review|Approved|Superseded|Reference]

---
```

---

## Current Document Inventory

| File | Location | Status | Owner |
|------|----------|--------|-------|
| verification_notes.md | notes/ | Review | Mike |
| corrected_true_values.md | notes/ | Approved | Mike |
| appendix_b_corrected.md | notes/ | Approved | Louis |
| power_normal_sim.R | R/ | Approved | Katrina |
| introduction_regulatory_gap.md | paper/sections/ | Draft | Rachel |
| methods_twosample_clt.md | paper/sections/ | Draft | Mike |
| simulation_results_power_normal.md | results/ | Superseded | Katrina |

---

## Action Items

1. [x] Create DOCUMENT_RULES.md
2. [ ] Reorganize existing files into proper directories
3. [ ] Add status headers to all documents
4. [ ] Create paper/sections/ structure

---

*"A place for everything, and everything in its place."* — Donna Paulsen
