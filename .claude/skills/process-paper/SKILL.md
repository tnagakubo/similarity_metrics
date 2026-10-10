---
description: Process a single PDF into knowledge base (Tak only)
model: sonnet
---

# Research Lab: Process Paper

Process a PDF and add to knowledge base.
File: $ARGUMENTS

## Execution

### Step 1: PDF → Image Conversion
Convert PDF to images for accurate reading (especially for mathematical content).

```bash
# Create a project-relative temp directory (gitignored). Do NOT use /tmp: the safety hook
# pre-bash-safety.sh refuses every recursive delete of an absolute path, so a /tmp cleanup is always blocked.
mkdir -p .claude/tmp/pdf-images

# Get PDF info
pdfinfo "$ARGUMENTS"

# Convert to PNG (150dpi for balance of quality and size)
mutool draw -o .claude/tmp/pdf-images/page_%03d.png -r 150 "$ARGUMENTS"
```

### Step 2: Read and Analyze
1. **Rachel**: Read converted images using Read tool
2. **Mike**: Extract mathematical methods (formulas are now visually accurate)
3. Analyze content comprehensively

### Step 3: Create Knowledge Base Files
Create files in knowledge/:
- `summaries/{paper_id}.md`
- `methods/{method_name}.md` (if applicable)
- `quotes/{paper_id}.md` (if applicable)

### Step 4: Update Index
Update `knowledge/INDEX.md` with new entry (DOI required!)

### Step 5: Record
**Donna**: Add scene to SUITS.md

### Step 6: Cleanup
```bash
rm -r .claude/tmp/pdf-images
```

## Output Files

### summaries/{paper_id}.md
```markdown
# {Author} {Year} - {Short Title}

## Citation
{Author} ({Year}) "{Title}" *{Journal}*
DOI: [10.xxxx](https://doi.org/10.xxxx)

## Summary
{1-2 paragraph summary}

## Key Contributions
- {contribution 1}
- {contribution 2}

## Methods
- {method 1}
- {method 2}

## Key Equations
{Important formulas in LaTeX}

## Verbatim passages we may cite（page 付き — 要約からの引用は禁止）
> "{exact sentence}" (p. {page}) — **use for**: {claim / CLAIMS.md ID}

## What this paper does NOT say（over-reading guard）
- {e.g., proposes clustering on one representative value per EM; does not compare full distributions}

## Relevance
{how it relates to our work}

## Tags
{keywords}
```

### methods/{method_name}.md
```markdown
# {Method Name}

## Definition
{mathematical definition in LaTeX}

## Properties
{key properties}

## Implementation
{R code if applicable}

## References
- {paper with DOI}
```

## Important
- Only Tak provides PDFs
- **Image conversion ensures accurate formula reading**
- Maintain consistent formatting
- DOI is required for all entries
- Link to original in pdfs/
- Verbatim passages carry page numbers; a claim we may cite without a verbatim passage is marked 🔍 (`memory/feedback_komiyama_no_overreading.md`)
