# KATRINA_FIG3_TABLES_20261012

## 1. Figure 3 dagger (referee Minor 13)
- Generator: R/fig3_w1_axis.R (edited: reads results/gusto_operability.csv; dagger when `!resolved_anchor`, same rule as `unres()` in R/make_paper_tables.R for Tables 5 and 7).
- Daggered partners (from CSV): age R1, R4, R5, R7, R9, R15; SBP R2. Matches Table 5 / Table 7.
- Regenerated figures/fig3_gusto_r8_forest.{pdf,png} and _color.{pdf,png}: 7 x 3.5 in, base_size 11, white, greyscale. Seed 2026 declared in script; no absolute paths.
- Regeneration was run with FIG3_OUT_DIR / FIG3_RESULTS_DIR pointing to a temp dir; the recomputed gusto_r8_w1_per_pair.csv is byte-identical (cmp) to results/ -> no numbers changed.
- Pitfall fixed: raw UTF-8 dagger in the R source rendered as "b" under the Windows locale; the source now uses the escape "†".
- Caption (tex line 517) appended: "$^\dagger$Distance unresolved against its null floor (Table~\ref{tab:operability})." No other tex line edited.

## 2. Feasibility: Table 1 -> Table 2 (report only)
(a) Table 1 (tab:study2_required_n) carries what Table 2 lacks: the SMD column (required n: 530 asym severity, 489 bulk shift; "blind" in the other 5 cells); the caption's blind definition (AUC range via aucBlindSMDmin/max); the "combined" tablenote. Table 1 has no MC intervals and no Sets 1-2. W1 and KS point values are identical in both tables.
(b) Generator change (R/make_paper_tables.R): in the Table 2 block add `cellmc(set,"SMD")` (reads required_n/_lower/_upper from the same CSV rows; status "blind" prints "blind"), add a column to the header, `H("lllll")`, and the row sprintf; the `sepmc` column keeps W1 vs KS only. Delete the Table 1 block (lines ~50-72) and its output file; cells_all still needs the `cells` vector. SMD cells exist for all 13 rows (Sets 1,2 SMD reached or blind; checked in required_n_selection.csv).
(c) tex references to repoint: line 297 (`Table~\ref{tab:study2_required_n}`, results prose); the label itself at line 302 (caption + \input + tablenotes lines 302-308 removed or merged into Table 2's caption/notes). Also move the blind definition and the "combined" note into Table 2's caption/notes. numvals aucBlindSMDmin/max stay.
(d) Width: 5 columns (Cell, W1, KS, SMD, Intervals) in one-column Wiley. Longest cells: "1{,}047 [1{,}011, 1{,}083]" (26 chars) x2, "separate ($W_1$ fewer)" (22), "Set 4, symmetric prevalence" (27). Estimated line ~ 27+26+26+~16+22 = ~117 characters at footnotesize/tabular -> overfull risk at \normalsize; needs `\small` or `\footnotesize` and shorter Intervals text (e.g. "W1 <" / "KS <" / "overlap") or drop the Intervals column to a tablenote. SMD MC intervals would add ~13 chars more; recommend SMD as point value only if intervals are not required.
(e) Recommendation: fold, SMD as required n (point) or "blind", W1/KS keep MC intervals, Intervals column shortened to symbols; saves one float, removes the duplicated W1/KS numbers of 7 cells. Table 1 and Table 2 currently repeat those 7 cells.

Current: 21 pages (latexmk). Main-text words: 9,937 per STRUCTURE_AUDIT_20261012.md; unchanged (edit was inside a caption, which that count excludes). pdftotext full-document word count 15,116.

## 3. Build / checks
- latexmk -pdf per_em_W1_wiley.tex (in paper/): rc 0; errors 0; undefined 0; 21 pages; Overfull 4 (hbox lines 52 [350.99pt, pre-existing front matter], 644 [9.0pt]; vbox x2 1.2pt and 29.4pt), Underfull 6.
- pdftotext diff vs previous PDF: 0 lines (caption text appears in both previous and new? previous PDF was already the 10:20 rebuild only after the edit; see note) -- see note below.
- numbers_audit: 118 numeric tokens, 118 sourced, 0 unsourced.
- claim_guards --strict: 30 guards, 0 FAIL.
Note: the pdftotext "previous" snapshot was taken after latexmk had already rebuilt, so the 0-line diff is not a content comparison; content change = 1 caption sentence + 7 figure labels only.
