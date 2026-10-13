---
description: Cold-read referee — a context-free reviewer recomputes the paper from raw data, attacks the mathematics and the interpretation, and every finding is compiled into a mutation-tested guard; Harvey triages, Louis seeds the guards
model: opus
effort: xhigh
argument-hint: "[all | section | --no-recompute]"
---

# Research Lab: Referee（冷読 referee — RESEARCH_FRAMEWORK S16/S20）

Claude Science（2026-09-21）が一度だけやったことを、**毎 draft・同じ条件・同じ深さ**で再現する: 内部記録を一切知らない reviewer が原稿と repository だけを受け取り、raw data から再計算し、数学を攻撃し、所見を guard に変える。
対象: $ARGUMENTS（空なら原稿全体）。Output: `projects/{project}/review_response/REFEREE_{YYYYMMDD}.md`、`review_response/referee/{YYYYMMDD}/`（再計算 script と出力）、`CLAIM_GUARDS.toml` への追記。

`/review`（Louis）との違い: Louis は CLAIMS・DECISIONS・自分の memory を読んで攻める（文脈あり）。Referee は **blind list** を持ち、SUITS・CLAIMS・DECISIONS・review_response・memory を開けない（文脈なし）。同じモデルでも、与える情報を変えると見えるものが変わる。`/external-review` は archetype の視点を模すが再計算しない。Referee は再計算が義務。

## Execution
1. **Donna**: 原稿のコミット状態を確認（merge 中・conflict marker ありなら中止）。出力ディレクトリ `projects/{p}/review_response/referee/{YYYYMMDD}/` を作る。`python3 scripts/structure_audit.py projects/{p}/paper/{m}.tex --out projects/{p}/review_response/STRUCTURE_AUDIT_{date}.md` と `python3 scripts/evidence_coverage.py projects/{p} --out projects/{p}/review_response/EVIDENCE_COVERAGE_{date}.md` を先に回す（referee には渡さない — 独立性のため。後で突き合わせる）
2. **Referee**（`Agent(subagent_type: "referee")`。prompt に渡すのは: 原稿パス、bib、`PROTOCOL_*.md`、`data/`・`R/`・`results/`・`figures/` のパス、出力ディレクトリ、対象範囲、journal 名、必要なら `--no-recompute`。**それ以外は渡さない**）: 再計算 → 数学 → 解釈 → binding → abstract 圧縮。固定書式の report を返す。blind list は `.claude/hooks/referee-blind.sh` が **tool scope として強制**する（`agent_type = referee` の Read / Grep / Glob / Bash / Write を検査、内部記録は exit 2 で遮断、Write は出力ディレクトリのみ）— 「渡さない」に加えて「開けない」
3. **Donna**: report を `review_response/REFEREE_{date}.md` に保存。§1 の機械的所見（structure / coverage）と referee の所見を突き合わせ、referee が見落とした機械的所見を末尾に `## Mechanical addendum` として付ける
4. **Harvey**: Major 各件に方針 — 直す / 反論を書く / 受け入れて narrow（`/claims` を更新）。「reviewer が間違っている」は derivation 付きでのみ許す
   - referee が「別の研究になる」と書いた項目は `/idea` で `IDEAS_BACKLOG.md` へ（S23）。出典を要する反論は `/ground` を先に（S21）
5. **Mike**: Arithmetic verification 表の不一致を root-cause（原稿の転記か、registry の key か、canonical CSV のバグか）。`Not verified` の項目を自分で再計算して埋める
6. **Louis**: report の各 `*Guard*` 案を審査し、文言を確定する（Louis agent は Write を持たない — TOML への書き込みは **Donna** が行い、起票者として Louis を記す）。`projects/{p}/CLAIM_GUARDS.toml` に `finding = "review_response/REFEREE_{date}.md M?"`、`known_bad` は **現在の原稿のコミット**（修正前 = known-bad）、**`pending = true`**（修正が入るまで FAIL ではなく OPEN — hook と CI `--strict` が赤くならない）。`python3 scripts/claim_guards.py projects/{p}/CLAIM_GUARDS.toml --mutation` で vacuous 0 を確認してから Katrina へ
7. **Katrina**: 修正を適用した後 `claim_guards.py --strict` PASS、PASS になった guard から `pending` を外す、`/review-fix` で cascade を確認、compile 0/0
8. **Jessica**: Major に「直さない」と決めた件があれば、その理由を `DECISIONS.md` に（`/decide`）。「決定 X と矛盾」は理由にならない
9. **Donna**: SUITS.md に scene（TOP）。`REFEREE_{date}.md` は Phase 6→7 の gate evidence（`/phase next` の 6→7 一覧: INTERNAL_REVIEW / PRE_REVIEW / external review / **REFEREE** の Critical・Major 全件に方針）

## Rules
- Referee に SUITS / CLAIMS / DECISIONS / memory のパスを渡さない。渡したら review は無効（Donna が差し戻す）
- 「再計算した」は referee の script と出力がディスクにある時だけ言える
- Major を 0 件にしない。強い原稿なら「次の reviewer がまだ聞くこと」を Major 相当で書かせる
- `--no-recompute` は R が無い環境の緊急用。report の `Arithmetic verification` が空なら Phase gate の evidence にならない

## SUITS.md Scene（add at TOP）

```markdown
### [YYYY-MM-DD HH:MM] Scene: Cold referee — {対象}

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - NIGHT**

*封筒が一通。差出人は誰も知らない reviewer。Donna が開封し、Harvey の前に置く。*

**Donna**: 「Major {X}、Minor {Y}。再計算表は {N} 行、不一致 {k}。Guard 案 {g} 件。」

**Harvey**: 「M1 は{方針}。M2 は{方針}。反論するなら derivation を付けろ。」

**Louis**: 「guard {g} 件を起票した。known_bad は {rev}。mutation で vacuous 0。同じ穴は二度開かない。You just got Litt up」

**Mike**: 「{不一致の root cause}」

---
```
