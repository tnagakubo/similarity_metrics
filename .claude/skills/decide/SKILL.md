---
description: Record a decision in DECISIONS.md (question, options, decision, reasons, reversibility) so that a later reversal has something to rebut; Harvey decides, Tak when it is Tak's call
model: opus
argument-hint: "<question>"
---

# Research Lab: Decide（判断記録）

判断は会話に流さず、`projects/{project}/DECISIONS.md`（template: `templates/decisions_template.md`）に理由付きで残す。
Question: $ARGUMENTS

なぜ: 09-05 の「ρ 残置」決定が 09-26 に覆されたとき、覆す側に反駁すべき理由が無かった。Louis memory #3「reasonless ledger rejections」。理由が書いてあれば、覆すときは理由に答えればよい。

## Execution
1. **Harvey**: Question を 1 文で。既存 entry の reopen なら `D-…` を引く
2. 意見（並列 `Agent` または会議）: **Mike**（技術・数学）/ **Rachel**（文献・原典の verbatim）/ **Katrina**（実装・図表・cascade の影響範囲）/ **Louis**（risk、reviewer の反応）/ **Jessica**（Go/No-Go、必要時）
3. **Harvey**: Option A / B / C（変更内容・影響範囲・trade-off）を書き、採る案と **なぜ他を捨てたか**。Tak の判断領域（主張の射程、構成、supplement、commit）なら Tak に提示して待つ
4. **Donna**: `DECISIONS.md` 末尾に `D-YYYYMMDD-n` を追記。Affected artifacts（CLAIMS IDs、§、scripts、figures）を列挙し、`CLAIMS.md` の該当行を更新。覆した entry は `superseded by D-…`
5. **Donna**: SUITS.md に scene（TOP）。scene は D-ID を引く

## Rules
- 「決定 X と矛盾する」は理由にならない。理由の無い却下は記録しない
- 判断と誤りの修正を混ぜない（Tak 2026-09-26: まず誤りを全部直す → 判断を一つずつ）
- Tak の指示は verbatim で Reasons に写す

## SUITS.md Scene（add at TOP）

```markdown
### [YYYY-MM-DD HH:MM] Scene: Decision D-{id} — {title}

**INT. PEARSON SPECTER LITT - JESSICA'S OFFICE - DAY**

**Harvey**:
「{question}。A は {…}、B は {…}。{decision} で行く。理由は {reasons}」

**Louis**:
「{risk}。それでも B か」

**Jessica**:
「Let me be clear。{verdict}」

---
```
