---
description: Second-order review of a fix — did the correction cascade to every site, did compression drop a qualifier or strengthen a quantifier; Louis reads only the diff and the cascade report
model: opus
argument-hint: "<old rev|file> [new rev|file]  (default new = working tree)"
---

# Research Lab: Review-Fix（修正の二次審査 — RESEARCH_FRAMEWORK S18）

修正そのものを審査する。Claude Science の referee は自分の修正を再審査して 2 つの型を見つけた: **patch without cascade**（引用された一文だけ直して、同じ主張が 3 箇所に残る）と **compression drops the qualifier**（"in at least one world" が "wherever" になる）。この skill はその再審査を毎回の修正の後に機械的に行う。
Arguments: $ARGUMENTS（old は必須。commit か file。new を省略すると working tree）。Output: `projects/{project}/review_response/FIX_REVIEW_{YYYYMMDD}.md`

## Execution
1. **Donna**: `python3 scripts/cascade_check.py --old <old> --new <new|tex> --tex projects/{p}/paper/{m}.tex --out projects/{p}/review_response/FIX_REVIEW_{date}.md`。続けて `python3 scripts/claim_guards.py projects/{p}/CLAIM_GUARDS.toml --strict` と `python3 scripts/numbers_registry.py check …`（数値を触った修正なら）
2. **Louis**（`Agent(subagent_type: "louis")`、渡すのは FIX_REVIEW の §2–§4 と `git diff <old> -- <tex>` の出力だけ。原稿全体は渡さない。この隔離は **指示によるもの**で tool scope ではない — Louis は Read を持つ。prompt に「原稿本体を開かない」と明記し、report に開いたファイルを列挙させる）: residue 各行に「残して良い / 直す」、qualifier drop 各行に「意図的（narrow）/ 事故（広げた）」、strengthened quantifier 各行に「表で支えられる / 支えられない」を判定。支えられない行は Major
3. **Harvey**: Louis の Major に方針。意図的に広げた claim は `CLAIMS.md` の動詞と evidence を更新（`/claims`）。残す residue は `DECISIONS.md` に理由
4. **Katrina**: 直した箇所に再度 `cascade_check.py`（old = 今回の修正前）→ residue 0、`claim_guards.py --strict` PASS、compile 0/0
5. **Donna**: SUITS.md に scene（TOP）

## Rules
- 修正を適用した本人（Harvey / Katrina）は Louis の判定に参加しない（producer ≠ verifier）
- cascade_check の residue 行は、直すか `DECISIONS.md` に理由を書くまで「所見」。語っただけでは消えない
- `/review` → 修正 → `/review-fix` の順。`/review-fix` を飛ばした修正は Phase 6→7 の gate で Donna が差し戻す（`/phase next` の 6→7 一覧: 修正ごとの `FIX_REVIEW_*.md` と residue 0）

## SUITS.md Scene（add at TOP）

```markdown
### [YYYY-MM-DD HH:MM] Scene: 修正の二次審査 — {old} → {new}

**INT. PEARSON SPECTER LITT - LOUIS'S OFFICE - DAY**

*Louis の机には diff と cascade report だけ。原稿は無い。*

**Louis**: 「residue {r} 件、qualifier drop {q} 件、強められた quantifier {s} 件。{最悪の 1 件}。You just got Litt up」

**Harvey**: 「{方針}」

**Katrina**: 「再実行。residue 0、guards PASS、compile 0/0。」

---
```
