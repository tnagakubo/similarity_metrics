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
├── CLAUDE.md           # Project rules
├── SUITS.md            # Live drama script
├── README.md           # This file
├── archives/           # Archived SUITS.md files
├── agents/             # Team definitions
├── knowledge/          # Knowledge base
├── projects/           # Workspaces
└── templates/          # Templates
```

## FAQ

**Q: Who can start projects?**
A: Only Tak (the user) via `/start`.

**Q: What's SUITS.md?**
A: Live drama script showing team progress. Newest scenes at top. Japanese dialogue with English quotes.

**Q: When is SUITS.md archived?**
A: When it exceeds 1000 lines. Archived to `archives/SUITS_YYYYMMDD_HHMMSS.md`, then fresh start.

**Q: What format for papers?**
A: Markdown (.md) with LaTeX math.

**Q: What language for code?**
A: R with tidyverse.
