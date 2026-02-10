---
description: Process a single PDF into knowledge base (Tak only)
---

# Research Lab: Process Paper

Process a PDF and add to knowledge base.
File: $ARGUMENTS

## Execution

### Step 1: PDF → Image Conversion
Convert PDF to images for accurate reading (especially for mathematical content).

```bash
# Create temp directory for images
mkdir -p /tmp/pdf-images

# Get PDF info
pdfinfo "$ARGUMENTS"

# Convert to PNG (150dpi for balance of quality and size)
mutool draw -o /tmp/pdf-images/page_%03d.png -r 150 "$ARGUMENTS"
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
rm -rf /tmp/pdf-images
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
