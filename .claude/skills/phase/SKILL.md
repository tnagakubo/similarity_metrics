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
1. **Donna**: `bash scripts/check_consistency.sh` を実行（Phase 同期・stale な state・欠けている lifecycle artifacts・undefined `\ref`）
2. **Donna**: `LAB_STATUS.md` を読み、Phase / entered / Open gates / Next / artifacts 表を表示
3. **Donna**: SUITS.md `Current Status` の Phase 行と一致しているか確認。不一致なら SUITS.md を LAB_STATUS に合わせる

### `/phase next`（前進）
1. **Donna**: 現 Phase の Open gates を一つずつ **on-disk evidence** で検証する（ファイル存在、grep、`git log`、compile log）。語られただけの項目は ❌。Phase ごとの機械的検証:
   - 0→1: `DECISIONS.md` に claim と「なぜ今」の entry　- 1→2: `LITERATURE_SEARCH_LOG.md` の gap statement + 反証条件、`knowledge/INDEX.md` の DOI
   - 2→3: `PROTOCOL_{study}.md` が commit 済み（ADEMP・MCSE・licenses・§0 honesty clause・Jessica Go）
   - 3→4: `bash scripts/check_r_reproducibility.sh` ❌ 0、`results/REPRODUCTION_*.md` PASS、provenance
   - 4→5: `SIMULATION_FINDINGS_*.md`（MCSE 付き）、`CLAIMS.md` の該当行 supported
   - 5→6: `/claims check` PASS、段落台帳の全行が Tak 承認（包括指示は `DECISIONS.md` に日時付き）
   - 6→7: `INTERNAL_REVIEW_*.md` / `PRE_REVIEW_*.md` / external review の Critical・Major 全件に方針
   - 7→投稿: `templates/reporting_checklist.md` R1–R8 全 ✅、`SUBMISSION_CHECK_*.md`、Jessica 承認
   - 8→7: `RESPONSE_TRACKER.md` 全件 closed、各変更が段落レビュー済み
2. **担当メンバー**: 各ゲートの verdict を character voice で述べる（Phase の owner は `RESEARCH_FRAMEWORK.md` の表）
3. **Louis**: 「このまま次に進んで reviewer に刺される点」を一つ以上挙げる。なければ「なし」と明言
4. **Jessica**: Phase 2→3（protocol Go）、6→7、7→投稿 の遷移では承認を出す（他の遷移では任意）
5. 全ゲート ✅ のとき **Donna** が `LAB_STATUS.md` を更新（Phase / entered / **Updated** / history 行に evidence path / 次 Phase の Open gates を `RESEARCH_FRAMEWORK.md` から転記）
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
