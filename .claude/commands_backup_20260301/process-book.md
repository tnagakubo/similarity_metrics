---
description: Process a book PDF by chapters into knowledge base (Tak only)
---

# Research Lab: Process Book

Process a book PDF by chapters and add to knowledge base.
File: $ARGUMENTS

## Execution

### Step 1: Analyze Book Structure
```bash
# Get PDF info (total pages, metadata)
pdfinfo "$ARGUMENTS"

# Extract text from first few pages to find TOC
pdftotext -f 1 -l 10 "$ARGUMENTS" /tmp/toc-preview.txt
```

Review the table of contents and identify chapter boundaries.

### Step 2: Plan Chapter Extraction
Ask Tak which chapters to process, or process all if specified.

Format for chapter specification:
- `all` - process entire book
- `3` - process chapter 3 only
- `3-5` - process chapters 3 through 5
- `3.9` - process section 3.9 only

### Step 3: Convert Chapters to Images
For each chapter/section to process:

```bash
# Create directory for this book
BOOK_ID="{author}_{year}"
mkdir -p /tmp/book-images/$BOOK_ID

# Convert specified pages to PNG (150dpi)
# Example: Chapter 3 is pages 100-150
mutool draw -o /tmp/book-images/$BOOK_ID/ch03_page_%03d.png -r 150 "$ARGUMENTS" 100-150
```

### Step 4: Read and Analyze Each Chapter
For each chapter:
1. **Rachel**: Read converted images using Read tool
2. **Mike**: Extract mathematical methods (formulas are visually accurate)
3. Create chapter summary

### Step 5: Create Knowledge Base Files
Create files in knowledge/:
- `summaries/{book_id}_ch{XX}.md` - per chapter summary
- `summaries/{book_id}_overview.md` - book overview (if processing multiple chapters)
- `methods/{method_name}.md` - extracted methods
- `quotes/{book_id}.md` - notable quotes

### Step 6: Update Index
Update `knowledge/INDEX.md` with new entries (DOI/ISBN required!)

### Step 7: Record
**Donna**: Add scene to SUITS.md

### Step 8: Cleanup
```bash
rm -rf /tmp/book-images/$BOOK_ID
```

## Output Files

### summaries/{book_id}_ch{XX}.md
```markdown
# {Author} {Year} - {Book Title} Chapter {X}: {Chapter Title}

## Citation
{Author} ({Year}) *{Book Title}* Chapter {X}. {Publisher}.
DOI: [10.xxxx](https://doi.org/10.xxxx) or ISBN: {isbn}

## Chapter Summary
{1-2 paragraph summary of this chapter}

## Key Concepts
- {concept 1}
- {concept 2}

## Key Theorems/Results
### Theorem X.Y
{statement}

### Corollary X.Z
{statement}

## Key Equations
{Important formulas in LaTeX}

## Relevance
{how it relates to our work}

## Tags
{keywords}
```

### summaries/{book_id}_overview.md
```markdown
# {Author} {Year} - {Book Title}

## Citation
{Author} ({Year}) *{Book Title}*. {Publisher}.
DOI: [10.xxxx](https://doi.org/10.xxxx) or ISBN: {isbn}

## Book Overview
{General description of the book}

## Processed Chapters
| Chapter | Title | Summary File |
|---------|-------|--------------|
| 3 | {title} | {book_id}_ch03.md |
| 4 | {title} | {book_id}_ch04.md |

## Key Themes
- {theme 1}
- {theme 2}

## Tags
{keywords}
```

## Example Usage

### van der Vaart & Wellner (1996) Chapter 3.9
```bash
# 1. Check structure
pdfinfo vandervaart_wellner_1996.pdf

# 2. Find Chapter 3.9 pages (e.g., pages 374-395)

# 3. Convert to images
mkdir -p /tmp/book-images/vandervaart_1996
mutool draw -o /tmp/book-images/vandervaart_1996/ch3.9_page_%03d.png -r 150 vandervaart_wellner_1996.pdf 374-395

# 4. Read images and create summary
# 5. Save to knowledge/summaries/vandervaart_1996_ch3.9.md
```

## Important
- Only Tak provides PDFs
- **Image conversion ensures accurate formula/theorem reading**
- Process chapters incrementally (don't try to do entire book at once)
- DOI or ISBN is required for all entries
- Maintain consistent file naming: `{author}_{year}_ch{XX}.md`
- Link to original in pdfs/
