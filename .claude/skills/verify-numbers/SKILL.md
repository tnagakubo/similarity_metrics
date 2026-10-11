---
description: Numbers Verification Gate (active half) — Mike extracts every quantitative claim with scripts/numbers_audit.py, ties each to a source in results/NUMBERS_LEDGER.csv, and a second member re-derives it
model: opus
argument-hint: "[tex file]"
---

# Research Lab: Verify Numbers（Numbers Verification Gate — active half）

原稿の全数値を、再現可能な source（R 出力 CSV / データ / 再導出した手計算）に結ぶ。hook `check-numbers-verification.sh` の active 側。
Reference: `memory/feedback_calculation_verification.md`。Target: $ARGUMENTS（空なら `projects/{project}/paper/*.tex`）
Ledger: `projects/{project}/results/NUMBERS_LEDGER.csv`（header: `templates/numbers_ledger_header.csv`）

## Principle（2026-10-11, Option B）
原稿の数値は **書かない、生成する**。CSV から引ける数値は `paper/numbers_registry.csv` の 1 行にし、LaTeX では `\numval{key}`、Quarto では `` `r num("key")` `` で参照する。表は `R/make_paper_tables.R` のような single writer が `paper/generated/*.tex` に書き、原稿は `\input` する。ledger（`results/NUMBERS_LEDGER.csv`）は CSV に無い数値（手計算・文献値・構造定数）にだけ使う。

## Execution
1. **Mike**: `python3 scripts/numbers_audit.py <tex> --draft-registry draft.csv` — 全数値を抽出（`\numval{}` と生成表は除外済み）。draft の各行に key・`source_file`・`filter`・`column`・`agg`・`fmt` を書く（丸めは **decimal round-half-even**、両実装共通）
1b. **Katrina**（verifier）: `python3 scripts/numbers_registry.py verify-draft draft.csv --tex <tex>` — 原稿の literal と CSV の値が一致するか。⚠️ は「原稿か CSV のどちらが誤りか」を決めてから進む（0.9425 のような丸め境界も表に出る）
1c. **Mike**: `apply`（literal を `\numval{}` に置換）→ registry に追記 → `Rscript scripts/make_numbers_macros.R <registry>` → `python3 scripts/numbers_registry.py check <registry> --macros <macros> --tex <tex>` → `build.sh` で error 0、`pdftotext` の差分 0 を確認
2. **Mike**（producer）: registry に載らない残りの unsourced に source を書く（ledger） — `source_file`（CSV / script / provenance）と `source_locator`（行・列・object / 式）。手計算は式を `note` に書き、**独立に再導出**する
3. **Katrina または Louis**（verifier、**producer と別人**）: source を開いて値を照合（再実行または再計算。記憶で承認しない）。`verified_by` / `verified_date` を記入
4. **Mike**: 閾値比較・boolean・sort・単位換算・proportion vs percent を特に再確認
5. 分類: ✅ verified / ⚠️ mismatch（source ≠ paper → **大きく flag**、原稿か source のどちらが正か決めてから直す）/ ❓ unsourced
6. **Katrina**: 表の数値が CSV から生成されているか（手打ちの表は生成スクリプトに置換）
7. **Donna**: SUITS.md に scene（検証表付き）。⚠️ / ❓ が 1 件でもあれば "submission-ready" と言わせない

## 除外の扱い
- 年号・節番号・式番号・grid の構造定数は script が自動で除く。それ以外で「数値ではない」と判断したものは ledger に `note=structural` で登録する（黙って無視しない）

## Output: Verification Table

| # | Claim (paper, L) | Source (file:locator) | Re-derived by | Value found | Status |
|---|---|---|---|---|---|

## SUITS.md Scene（add at TOP）

```markdown
### [YYYY-MM-DD HH:MM] Scene: Numbers Verification — Mike traces every digit

**INT. PEARSON SPECTER LITT - BULLPEN - DAY**

*Mike が R の出力を原稿の横に広げ、一行ずつ照合する。Katrina が別の端末で同じ CSV を開く。*

**Mike**:（電卓を置いて）
「{N} 個の数値を全部 source に当てた。{V} 件 verified、{F} 件は要修正だ。"I got it!"」

**Katrina**:
「verifier は私。{V} 件は CSV で一致。{F} 件は {理由}」

**Donna**:（頷いて）
「{F} 件が片付くまで submission-ready とは言わせないわ」

---
```
