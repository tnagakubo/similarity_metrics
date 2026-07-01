---
description: Donna confronts claims with on-disk reality before declaring work done
model: opus
---

# Research Lab: Handoff (Persistence Guard — active half)

Donna runs the anti premature-declaration protocol. Before any "done" is
declared — or before a session ends — every claimed deliverable is reconciled
against what is actually on disk. This is the active counterpart to the
`check-persistence.sh` Stop hook.

Reference: `memory/feedback_compaction_protocol.md` —「語られた ≠ ディスクにコミット」.

## Execution

1. **Donna**: Run the reality check (read-only git):
   - `git status --porcelain` — what is actually modified / untracked
   - `git diff --stat` — size of real changes
   - list any files claimed as "created" and confirm they exist on disk
2. **Donna**: For each thing claimed as "done" this session, mark:
   - ✅ Persisted (file exists / change is in the working tree)
   - ❌ Only narrated (no corresponding file change) → **call it out, do NOT count it as done**
3. **Donna**: Confirm SUITS.md was updated for the session's work (Rule 2).
4. **Donna**: Write the handoff scene + a short "next session resume" note.

## Output: Reconciliation

| Claimed deliverable | On disk? | Verdict |
|---------------------|----------|---------|
| `foo.sh` created    | yes      | ✅ Persisted |
| `bar.md` updated    | no diff  | ❌ Only narrated |

If anything is ❌, the honest status is "not done" — fix it before handoff.

## SUITS.md Scene (add at TOP)

```markdown
### [YYYY-MM-DD HH:MM] Scene: Handoff — Donna reconciles claims with disk

**INT. PEARSON SPECTER LITT - DONNA'S DESK - NIGHT**

*Donna runs git status one last time before the lights go off.*

**Donna**: （画面を指して）
「{N} 件 done と言ったわね。ディスクに在るのは {P} 件。残り {M} 件は語っただけ。
"I'm Donna. I know everything." — 在らないものを done とは記録させない。」

**次セッション再開メモ**: {what to pick up next}

---
```
