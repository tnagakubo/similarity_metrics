# Research Lab

Virtual statistics research lab powered by SUITS-inspired AI agents.

## Quick Start

```bash
cd research-lab
claude

# Start a project
/start similarity-index "ICH E11A similarity metrics"

# Check status
/suits

# Team meeting
/meeting "methodology selection"

# Review
/review

# Celebrate
/victory
```

## SUITS.md - Live Drama Script

Progress is recorded as a Japanese drama script in `SUITS.md`:
- Newest scenes at TOP (reverse chronological)
- Each character speaks in their voice
- Quotes can be in English
- Cross-project (single file at root)

### Example Entry

```markdown
### [2026-02-01 10:30] Scene: Methods Discussion

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Mike stands at the whiteboard, marker in hand.*

**Mike**: （数式を書きながら）
「Wasserstein 距離を使う。定義はこうだ...」

**Harvey**: （うなずいて）
「いいだろう。"Don't play the odds. I play the man."
データに語らせろ」

---
```

## Team Members

| Member | Role | Style |
|--------|------|-------|
| **Harvey Specter** | Lead Author | "I don't have dreams, I have goals." |
| **Mike Ross** | Methodologist | Eidetic memory, mathematical genius |
| **Donna Paulsen** | Project Manager | "I'm Donna. I know everything." |
| **Louis Litt** | Internal Critic | "You just got Litt up!" |
| **Jessica Pearson** | Senior Advisor | "Let me be clear." |
| **Rachel Zane** | Researcher | Thorough, dedicated |
| **Katrina Bennett** | Technical Writer | Efficient, results-focused |

## Commands

### Project
- `/start {name} {theme}` - Start project
- `/suits` - Show SUITS.md status
- `/meeting {topic}` - Team meeting
- `/push` - Accelerate work
- `/rule` - Remind rules
- `/archive` - Archive SUITS.md (>1000 lines)

### Review
- `/review` - Louis review
- `/external-review` - Expert homage review
- `/simulate-qa {conference}` - Q&A practice
- `/defend {claim}` - Attack/defense

### Knowledge
- `/process-paper {path}` - Process PDF
- `/search-kb {query}` - Search KB
- `/read {paper} {level}` - Read paper
- `/cite {paper}` - Get citation

### Motivation
- `/motivate` - Encouragement
- `/victory` - Celebrate

### Lifecycle & Scientific Integrity (see `RESEARCH_FRAMEWORK.md`)
- `/phase [next | set N]` - Show / advance the 10-phase lifecycle (gates verified on disk by Donna)
- `/protocol {study}` - Pre-register a protocol: ADEMP, Monte Carlo SE, licenses / does not license, prior-look disclosure (Phase 2)
- `/claims [init | check | add]` - Claims ↔ evidence registry `CLAIMS.md` (every claim has a row; verbs match evidence)
- `/decide {question}` - Decision record with options and reasons in `DECISIONS.md`
- `/reproduce [study]` - Clean-checkout reproduction gate (Phase 3)
- `/verify-numbers` - Every number tied to its source in `results/NUMBERS_LEDGER.csv`; verifier ≠ producer
- `/cite-check` - Citations reconciled with the .bib and verified against the original passage
- `/pre-review [section]` - Proactive self-review by all members (Phase 6 entry)
- `/review` - Louis's structured internal review, written to `review_response/INTERNAL_REVIEW_*.md`
- `/submission-check` - Reporting checklist R1–R8 + journal requirements (Phase 7)
- `/respond-reviewers [init|status|close]` - Point-by-point reviewer response tracker (Phase 8)
- `/handoff`, `/lint-suits` - Persistence guard / mechanical character lint (any phase)

### Mechanical checks (`scripts/`, no R required)
```bash
python3 scripts/lint_suits.py SUITS.md --scenes 3        # last names, keigo, labels, scene order
python3 scripts/numbers_audit.py projects/<p>/paper/<m>.tex   # numbers vs results/NUMBERS_LEDGER.csv
python3 scripts/cite_audit.py <m>.tex <m>.bib --out …    # \cite vs .bib, DOI, citation–claim table
bash scripts/check_r_reproducibility.sh                  # seeds, parallel RNG, absolute paths, sessionInfo
bash scripts/check_consistency.sh                        # phase sync, stale state, undefined \ref, artifacts
```

Phase state lives in `projects/{project}/LAB_STATUS.md`. Member subagents are defined in
`.claude/agents/` (persona source: `agents/*.md`); path-scoped rules in `.claude/rules/`;
versioned principles in `memory/` (`memory/INDEX.md`).

## External Experts

The `/external-review`, `/simulate-qa`, and `/defend` commands dynamically generate
**homage characters** inspired by legendary statisticians:

- Bayesian experts (Rubin-style, Gelman-style, Efron-style)
- Theoretical experts (Rao-style, Bickel-style)
- Applied experts (Cox-style, Tibshirani-style)
- And more...

These are fictional characters paying tribute to statistical giants, not the actual persons.

## Directory Structure

```
research-lab/
├── CLAUDE.md              # Project rules (Rule 1–6)
├── RESEARCH_FRAMEWORK.md  # 10-phase lifecycle + integrity principles S1–S11 + feature map
├── memory/                # Versioned principles (repo copy of the auto-memory)
├── scripts/               # Mechanical checks (lint, numbers, citations, reproducibility, consistency)
├── SUITS.md               # Live drama script
├── README.md              # This file
├── .claude/
│   ├── agents/            # Member subagents (harvey, mike, donna, rachel, katrina, louis, jessica)
│   ├── rules/             # Path-scoped rules (paper-writing, r-code, suits-script)
│   ├── skills/            # Slash commands
│   └── hooks/             # Enforcement hooks (Donna)
├── archives/              # Archived SUITS.md files
├── agents/                # Persona definitions (source of truth for voice)
├── knowledge/             # Knowledge base
├── projects/              # Workspaces (each with LAB_STATUS.md)
└── templates/             # Templates
```

## FAQ

**Q: Who can start projects?**
A: Only Tak (the user) via `/start`.

**Q: What's SUITS.md?**
A: Live drama script showing team progress. Newest scenes at top. Japanese dialogue with English quotes.

**Q: When is SUITS.md archived?**
A: When it exceeds 1000 lines. Archived to `archives/SUITS_YYYYMMDD_HHMMSS.md`, then fresh start.

**Q: What format for papers?**
A: LaTeX (.tex, journal template) or Quarto (.qmd); lab records in Markdown (.md) with LaTeX math.

**Q: What language for code?**
A: R with tidyverse.
