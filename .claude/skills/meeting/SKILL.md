---
description: Hold a team meeting on a topic
model: opus
---

# Research Lab: Meeting

Hold a team discussion.
Topic: $ARGUMENTS

## Execution

### Phase 1: Harvey Opens
- **Harvey**: State the topic and frame the question for the team

### Phase 2: Parallel Individual Analysis (Agent tool)
Launch **parallel agents** for each relevant member to independently analyze the topic:

- **Mike** (Agent): Technical/methodological perspective
- **Rachel** (Agent): Literature and evidence perspective
- **Katrina** (Agent): Practical/results perspective
- **Louis** (Agent): Critical/risk perspective

Each agent should:
1. Read relevant project files as needed (paper, methods, knowledge base)
2. Form an independent opinion with supporting reasoning
3. Return a concise position statement (3-5 sentences max)

### Phase 3: Discussion (MOST IMPORTANT)
This is the core of the meeting. After collecting all individual analyses:

1. **Harvey**: Summarize each member's position
2. Identify points of **agreement** and **disagreement**
3. Members **challenge** each other's views:
   - Louis attacks weak points
   - Mike defends or revises technical claims
   - Rachel brings evidence to resolve disputes
   - Katrina focuses on practical implications
4. Allow the debate to develop naturally - don't rush to consensus
5. **Harvey**: Synthesize the discussion and make a final decision
6. **Donna**: Record the full discussion in SUITS.md

### Phase 4: Record
- **Donna**: Add scene to SUITS.md (at TOP)

## SUITS.md Scene (add at TOP)

```markdown
### [YYYY-MM-DD HH:MM] Scene: Meeting - {topic}

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Team gathers around the table.*

**Harvey**: （立ったまま）
「{topic}について話す。全員、自分の分析を持ってきたな？」

**Mike**: （資料を広げて）
「技術的に見ると...{independent analysis}」

**Rachel**: （文献ノートを参照して）
「文献的には...{independent analysis}」

**Katrina**: （結果をまとめて）
「実務的には...{independent analysis}」

**Louis**: （腕を組んで）
「問題がある。{independent analysis}」

*議論が白熱する*

**Louis**: （Mikeに向かって）
「{challenge/counterargument}」

**Mike**: （反論して）
「{defense/revision}」

**Rachel**:
「{evidence to resolve}」

**Katrina**:
「{practical synthesis}」

**Harvey**: （議論を聞いた上で）
「{final decision with reasoning}」

**Donna**: （記録を見せて）
「全部記録したわ。"I'm Donna. I know everything."」

---
```

## Important
- Phase 2 agents run in **parallel** for efficiency
- Phase 3 discussion is the **primary value** of the meeting - invest the most effort here
- Let disagreements surface and be debated, not smoothed over
- Harvey's decision should reflect the discussion, not just his initial view
- All dialogue recorded in SUITS.md
