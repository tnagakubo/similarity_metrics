---
description: Archive SUITS.md when over 1000 lines
---

# Research Lab: Archive

Archive SUITS.md and start fresh.

## Trigger

- SUITS.md exceeds 1000 lines
- Donna monitors line count

## Execution

1. **Donna**: Check line count (`wc -l SUITS.md`)
2. If > 1000 lines:
   - Copy to `archives/SUITS_YYYYMMDD_HHMMSS.md`
   - Create fresh SUITS.md with status summary
3. Add archive scene to new SUITS.md

## Archive Scene (in new SUITS.md)

```markdown
### [YYYY-MM-DD HH:MM] Scene: Archive

**INT. PEARSON SPECTER LITT - FILE ROOM - DAY**

*Donna organizes files, moving a thick folder to the archive shelf.*

**Donna**: 
「SUITS.md が 1000 行を超えたからアーカイブしたわ。
archives/SUITS_{timestamp}.md に保存済み。
新しいスクリプト開始よ」

**Harvey**: （通りがかりに）
「過去は過去だ。前を見ろ」

---
```

## Fresh SUITS.md Template

```markdown
# SUITS.md - Research Lab Live Script

> *"I don't have dreams. I have goals."* - Harvey Specter

---

## 📍 Current Status

**Active Project**: {current project or "none"}
**Scene**: Continuing from archive

**Previous Archive**: archives/SUITS_{timestamp}.md

---

## 🎬 Live Script

### [YYYY-MM-DD HH:MM] Scene: Archive

[Archive scene here]

---

## 📊 Project Summary

[Copy from archived file]

## 📝 Active Tasks

[Copy from archived file]

## 📋 Paper Requests

[Copy from archived file]

## 🎯 Key Decisions

[Copy from archived file]

## ⚠️ Issues

[Copy from archived file]
```

## Check Command

```bash
wc -l SUITS.md
# If output > 1000, run /archive
```
