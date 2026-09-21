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

### Lifecycle (see `RESEARCH_FRAMEWORK.md`)
- `/phase [next | set N]` - Show / advance the 10-phase lifecycle (gates verified on disk by Donna)
- `/protocol {study}` - Pre-register a simulation / analysis protocol (Phase 2)
- `/pre-review [section]` - Proactive self-review by all members (Phase 6 entry)
- `/submission-check` - Terminal pass before submission (Phase 7)
- `/respond-reviewers [init|status|close]` - Point-by-point reviewer response tracker (Phase 8)
- `/verify-numbers`, `/handoff` - Numbers gate / persistence guard (any phase)

Phase state lives in `projects/{project}/LAB_STATUS.md`. Member subagents are defined in
`.claude/agents/` (persona source: `agents/*.md`); path-scoped rules in `.claude/rules/`.

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
├── CLAUDE.md              # Project rules
├── RESEARCH_FRAMEWORK.md  # 10-phase research → paper lifecycle + Claude Code feature map
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
A: Markdown (.md) with LaTeX math.

**Q: What language for code?**
A: R with tidyverse.
