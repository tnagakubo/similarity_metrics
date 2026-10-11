---
description: Archive SUITS.md when over 1000 lines
model: haiku
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
   - Create fresh SUITS.md with status summary（template below; the `**Phase**` line must equal `projects/{project}/LAB_STATUS.md`）
3. Add archive scene to new SUITS.md
4. **Donna**: `python3 scripts/lint_suits.py SUITS.md --all` と `bash scripts/check_consistency.sh` を実行し、clean を確認してから終える

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

## CRITICAL: Context Preservation

アーカイブ時に**直前の作業コンテキスト**を必ず引き継ぐこと。
アーカイブ前のLive Scriptから以下を抽出し、新SUITS.mdに記載する：

1. **直前の3-5シーンの要約** — 何を議論/作業していたか
2. **進行中のアクション** — 誰が何をしている途中か
3. **次にやるべきこと** — 中断された作業、保留中の判断
4. **Takからの直近の指示** — PI指示は最優先で引き継ぐ

これにより、アーカイブ後もチームは中断なく作業を継続できる。

## Fresh SUITS.md Template

```markdown
# SUITS.md - Research Lab Live Script

> *"I don't have dreams. I have goals."* - Harvey Specter

---

## Current Status

**Active Project**: {current project or "none"}
**Phase**: {N — name} → `projects/{project}/LAB_STATUS.md`
**Manuscript**: `projects/{project}/paper/{file}.tex`（{pp}、compile error {n}）
**Scene**: Continuing from archive
**System**: Rule 5/6 の gate 状態は `LAB_STATUS.md` の artifacts 表（CLAIMS / DECISIONS / ledger / reproduction）

**Previous Archive**: archives/SUITS_{timestamp}.md

---

## 🔄 直前のコンテキスト (from archived scenes)

### 直近の作業
- {アーカイブ前の直近3-5シーンの要約}

### 進行中のアクション
- {誰が何をしている途中か}

### 次にやるべきこと
- {中断された作業、保留中の判断}

### Takからの直近の指示
- {PIの最新指示を漏れなく引き継ぐ}

---

## 🎬 Live Script

### [YYYY-MM-DD HH:MM] Scene: Archive

[Archive scene here]

---

## 📊 Key Decisions

判断の正本は `projects/{project}/DECISIONS.md`（append-only、理由付き）。ここには直近 5 件の D-ID と 1 行要約だけを書く。

## Active Tasks

[Copy from archived file]

## 📋 Revision Notes

[Copy from archived file, if any]

## 📋 Paper Requests

[Copy from archived file]

## ⚠️ Issues

[Copy from archived file]
```

## Check Command

```bash
wc -l SUITS.md
# If output > 1000, run /archive
```
