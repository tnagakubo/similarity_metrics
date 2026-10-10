---
description: Start a new research project (Tak only) — Donna scaffolds the lifecycle artifacts, Harvey states the one-sentence claim, Jessica gives the Phase 0 Go
model: sonnet
argument-hint: "<project-name> <theme>"
---

# Research Lab: Start Project

新しい研究プロジェクトを Phase 0（Question）から始める。Tak だけが起動できる。
Project: $ARGUMENTS　Lifecycle: `RESEARCH_FRAMEWORK.md`

## Execution
1. **Donna**: scaffold — `projects/{project}/` に
   - `LAB_STATUS.md`（`templates/lab_status_template.md`、Phase 0）
   - `CLAIMS.md`（`templates/claims_template.md`）、`DECISIONS.md`（`templates/decisions_template.md`）
   - `LITERATURE_SEARCH_LOG.md`（`templates/literature_search_log_template.md`）
   - `EXISTING_METHODS_AND_NOVELTY.md`（空の表: 既存法 / 答える問い / 何を比較するか / 我々との差分）
   - `results/NUMBERS_LEDGER.csv`（`templates/numbers_ledger_header.csv`）、`R/`、`paper/`、`figures/`、`review_response/`
2. **Harvey**: Phase 0 の問い — **claim を 1 文**、「なぜ今この論文か」、想定 journal。`DECISIONS.md` に D-…-1 として記録（`/decide`）
3. **Mike**: estimand の候補を数式で 1 つ（何を推定・比較する量か）。ここで決めきらなくてよいが、量が無ければ問いになっていない
4. **Rachel**: `LITERATURE_SEARCH_LOG.md` に最初の検索計画（database・query・inclusion/exclusion）を書く。`knowledge/` を先に見る
5. **Louis**: 「この問いの一番弱いところ」を 1 件
6. **Jessica**: Phase 0 Go / No-Go（No-Go なら flip する条件）
7. **Donna**: SUITS.md に scene（TOP）、`Current Status` を更新

## SUITS.md Scene Entry（add at TOP）

```markdown
### [YYYY-MM-DD HH:MM] Scene: Project Kickoff - {name}

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Harvey enters, placing a folder on the table.*

**Harvey**:（全員を見回して）
「新しいプロジェクトだ。{theme}。claim は一文で言う — {claim}。これを成功させる。"Winners don't make excuses."」

*Donna updates the whiteboard.*

**Donna**:
「フォルダと台帳は作ったわ。LAB_STATUS は Phase 0。claim が台帳の一行目よ、Harvey」

**Mike**:（資料を手に取りながら）
「推定する量はこれです — {estimand}。方法論は僕が設計する」

**Rachel**:
「文献調査、knowledge/ から始めます。検索ログに残します」

**Louis**:
「先に言っておく。{weakest point}」

**Jessica**:
「Let me be clear。{Go / No-Go}」

---
```

## Important
- Only Tak can start projects
- Phase 0 を抜ける条件は `RESEARCH_FRAMEWORK.md` §1（claim 1 文 + 「なぜ今」に Jessica が Go）
