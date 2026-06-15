---
description: External review by legendary statistician homages
model: opus
effort: xhigh
---

# Research Lab: External Review

Simulate the full editorial and peer review process of Statistics in Medicine.
These are **fictional reviewers** modeled on realistic SIM reviewer archetypes, NOT legendary statisticians.

## Design Principle

The previous approach had Louis (an internal team member) selecting reviewers based on knowledge of the paper's content. This introduces **selection bias** — the same blind spots that created the paper's weaknesses also govern who reviews it.

The new process simulates what actually happens at Statistics in Medicine:
1. An Associate Editor reads the paper **cold** (title, abstract, keywords only)
2. The AE selects reviewers from a realistic pool — NOT OT theorists or legendary statisticians, but working biostatisticians
3. Reviewers evaluate independently using the journal's review criteria

## Execution

### Phase 1: Editor Triage

A simulated **Associate Editor** (modeled on SIM's AE profile: senior biostatistician at a research university or regulatory agency) performs initial assessment:

1. Read ONLY: title, abstract, keywords, section headings
2. Determine: Is this in scope for SIM? (methodology with clinical relevance)
3. Select 2-3 reviewers from the Reviewer Archetypes below
4. **CRITICAL**: The AE must NOT use internal knowledge of the paper's weaknesses or the team's Revision Notes. Selection is based solely on what is visible in the abstract.

### Phase 2: Reviewer Assignment

Select from these **SIM-realistic archetypes** (NOT the old legendary statistician styles):

| # | Archetype | Profile | What They Look For |
|---|-----------|---------|-------------------|
| R1 | **MRCT Regulatory Biostatistician** | Senior statistician at a global pharma company or regulatory agency (FDA/PMDA/EMA). Works on ICH E17 implementation daily. | Practical utility, integration with existing pooling strategies, multiple EMs, sample size implications, regulatory acceptability |
| R2 | **Nonparametric Methods Specialist** | Associate professor in a university biostatistics department. Publishes on distribution comparison, rank-based methods, resampling. | Statistical rigor, asymptotic theory, bootstrap validity, comparison with competing methods, finite-sample behavior |
| R3 | **Clinical Trials Design Methodologist** | Experienced trial designer at an academic medical center or CRO. Focuses on adaptive designs, subgroup analysis, ICH guidelines. | Clinical interpretability, sensitivity to assumptions, presentation clarity, practical thresholds, connection to existing trial design literature |
| R4 | **Clinical Epidemiologist / Applied Statistician** | Works at the intersection of clinical medicine and statistics. Reviews frequently for SIM. | Clinical relevance, interpretability for non-statisticians, unmeasured confounders, generalizability, whether clinicians would actually use this |

### Reviewer Behavioral Characteristics (realistic)

Each reviewer should exhibit realistic behaviors:
- **Time pressure**: Forms global impression quickly; fatal flaws dominate evaluation
- **Expertise boundaries**: Does not deeply critique areas outside their expertise
- **Anchoring**: One major concern can color the entire review
- **Constructive variation**: Some give specific suggestions, others state problems without solutions
- **Style variation**: Some are terse (3 bullet points), others are detailed (2 pages)

### Phase 3: Independent Review

Each reviewer writes a report following SIM's review structure:

```
## Reviewer [N] — [Archetype Name]

### Overall Assessment
[1-2 sentences: overall impression and recommendation]

### Recommendation
[ ] Accept
[ ] Minor Revision
[ ] Major Revision
[ ] Reject

### Evaluation
- **Originality**: [1-5] — [brief comment]
- **Statistical Methodology**: [1-5] — [brief comment]
- **Presentation/Clarity**: [1-5] — [brief comment]
- **Clinical Relevance**: [1-5] — [brief comment]

### Major Comments
1. [comment with specific section/equation reference]
2. ...

### Minor Comments
1. [comment]
2. ...
```

### Phase 4: Editorial Decision

The simulated AE synthesizes all reviews into an **editorial decision letter**:

```
Dear Authors,

Thank you for submitting your manuscript "[Title]" to Statistics in Medicine.

Your paper has been reviewed by [N] referees. Based on their assessments,
I have reached the following decision: [Accept / Minor Revision / Major Revision / Reject].

[Summary of key issues across reviewers]

[Specific items that must be addressed]

Sincerely,
[Simulated AE Name]
Associate Editor, Statistics in Medicine
```

### Phase 5: Team Response (Louis leads)

After the simulated review:
1. **Louis**: Triage reviewer comments by severity (Critical/Major/Minor)
2. **Louis**: Identify **unexpected criticisms** — points the team did NOT anticipate
3. **Harvey**: Assign response tasks
4. **Donna**: Add scene to SUITS.md

## SUITS.md Scene (add at TOP)

```markdown
### [YYYY-MM-DD HH:MM] Scene: External Review — SIM Simulation

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*The team receives a sealed envelope. Harvey opens it.*

**Harvey**: （手紙を読みながら）
「Statistics in Medicine からの模擬レビューが届いた」

*Simulated AE decision letter is read aloud.*

**Louis**: （レビューを分類しながら）
「Critical X件、Major Y件、Minor Z件。
最も重要なのは — {unexpected criticism}。これは我々が想定していなかった」

**Mike**: （メモを取りながら）
「{response to key technical point}」

**Harvey**: （決断）
「対応の優先順位はこうだ。{assignments}」

---
```

## What Changed from the Old Design

| Aspect | Old | New |
|--------|-----|-----|
| Reviewer selection | Louis (internal, biased) | Simulated AE (cold read, unbiased) |
| Reviewer types | Legendary statistician homages | Realistic SIM reviewer archetypes |
| Selection basis | Paper topic + team knowledge | Title + abstract + keywords only |
| Review format | Free-form critique | SIM's structured review form |
| Behavioral realism | Expert-level precision | Time pressure, expertise limits, anchoring |
| Output | Louis's severity list | Full editorial decision letter + team response |

## Important

- The AE and reviewers are **fictional** but modeled on realistic SIM profiles
- Reviewers should produce **surprises** — criticisms the team did not anticipate
- The value of this exercise is proportional to its independence from the team's perspective
- Old legendary statistician styles (`agents/statisticians.md`) remain available for `/defend` and `/simulate-qa` where domain-specific attack is the goal
