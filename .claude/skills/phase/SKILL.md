---
description: Show or advance the project's research-lifecycle phase (gate check by Donna)
model: sonnet
argument-hint: "[next | set N | (blank)]"
---

# Research Lab: Phase

Lifecycle の現在地を示し、ゲートを検証してから次の Phase へ進める。
Argument: $ARGUMENTS（空 = 表示、`next` = ゲート検証して前進、`set N` = Tak 指示で強制設定）

Lifecycle 定義: `RESEARCH_FRAMEWORK.md`。State file: `projects/{project}/LAB_STATUS.md`。

## Execution

### `/phase`（表示）
1. **Donna**: `LAB_STATUS.md` を読み、Phase / entered / Open gates / Next を表示
2. **Donna**: SUITS.md `Current Status` の Phase 行と一致しているか確認。不一致なら SUITS.md を LAB_STATUS に合わせる

### `/phase next`（前進）
1. **Donna**: 現 Phase の Open gates を一つずつ **on-disk evidence** で検証する（ファイル存在、grep、`git log`、compile log）。語られただけの項目は ❌
2. **担当メンバー**: 各ゲートの verdict を character voice で述べる（Phase の owner は `RESEARCH_FRAMEWORK.md` の表）
3. **Louis**: 「このまま次に進んで reviewer に刺される点」を一つ以上挙げる。なければ「なし」と明言
4. **Jessica**: Phase 6→7、7→投稿 の遷移では承認を出す（他の遷移では任意）
5. 全ゲート ✅ のとき **Donna** が `LAB_STATUS.md` を更新（Phase / entered / history 行追加 / 次 Phase の Open gates を `RESEARCH_FRAMEWORK.md` から転記）
6. ❌ が一つでもあれば前進しない。残項目を `Next` に書き戻す
7. **Donna**: SUITS.md に scene（TOP）+ `Current Status` の Phase 行を更新

### `/phase set N`（Tak のみ）
- Tak の指示があるときだけ。理由を history に記録する

## SUITS.md Scene（add at TOP）

```markdown
### [YYYY-MM-DD HH:MM] Scene: Phase gate — {from} → {to}

**INT. PEARSON SPECTER LITT - DONNA'S DESK - DAY**

*Donna がゲート表を机に広げる。*

**Donna**:（表を指で追いながら）
「ゲート {N} 件。ディスクで確認できたのは {P} 件。{verdict}」

**Louis**:（腕を組んで）
「進む前に一つ。{risk}」

**Harvey**:
「{decision}」

---
```
