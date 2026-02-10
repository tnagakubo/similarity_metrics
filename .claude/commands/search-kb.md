---
description: Search knowledge base
---

# Research Lab: Search KB

Search the knowledge base for relevant content.
Query: $ARGUMENTS

## Execution

1. **Rachel**: Search knowledge/ directory
2. Return matching files and excerpts
3. Highlight most relevant

## Search Scope

- knowledge/summaries/*.md
- knowledge/methods/*.md
- knowledge/quotes/*.md
- knowledge/INDEX.md

## Output Format

```
**Rachel**: "Search results for '{query}':

### Summaries
- {paper1.md}: {relevant excerpt}
- {paper2.md}: {relevant excerpt}

### Methods
- {method.md}: {relevant excerpt}

Most relevant: {recommendation}"
```
