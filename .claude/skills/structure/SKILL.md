---
description: Structural audit — word budget vs venue, float placement, evidence outside Results, duplicated arguments, supplement labels; Harvey decides the restructure, Katrina measures
model: opus
argument-hint: "[--venue sim|generic]"
---

# Research Lab: Structure（構造診断 — RESEARCH_FRAMEWORK S17）

内容を読む前に構造を測る。Claude Science の structural review が使った診断をそのまま機械化した: 節ごとの語数を venue の典型と比べる、float が引用より前に定義されていないか、Discussion の段落に数値が詰まっていないか（= 証拠が Results の外にある）、同じ論証が 2 箇所にないか、Supplement の文字が飛んでいないか。
Arguments: $ARGUMENTS。Output: `projects/{project}/review_response/STRUCTURE_AUDIT_{YYYYMMDD}.md`

## Execution
1. **Katrina**: `python3 scripts/structure_audit.py projects/{p}/paper/{m}.tex --venue sim --out projects/{p}/review_response/STRUCTURE_AUDIT_{date}.md`。数字をそのまま読む（語数、比、drift、密度）
2. **Harvey**: 各 ❌ / ⚠ 行と「evidence outside Results」の各段落に対して判断 — (a) 削る（どの段落を、何語）、(b) 移す（どの節へ — 「Discussion の数値段落は §3 の study に昇格」の型）、(c) 残す（理由）。Option A/B/C で Tak に
3. **Louis**: 「構造の問題に見えて主張の問題」を指摘する — 2 箇所にある論証は、片方が証拠なしで主張を繰り返している可能性。duplicate pair の各行で「どちらが証拠を持つか」
4. **Mike**: Results の外にある数値段落が simulation の結果なら、ADEMP・表・MCSE のある study に昇格できるかを判定（`/protocol` の事後登録が要るか）
5. **Donna**: 判断を `DECISIONS.md`（`/decide`）、SUITS.md に scene（TOP）。`STRUCTURE_AUDIT_{date}.md` は `templates/reporting_checklist.md` R7（図表）の evidence、`/phase next` 6→7 の一覧に載る

## Rules
- 語数の budget は診断で規則ではない。2× は「削れ」ではなく「なぜ 2× か」を問う
- `--strict` が止めるのは float の placement issue（uncited / defined before cited）、`\ref` の欠落、**abstract の語数超過**の 3 つ。本文の語数は止めない（CI `lab-checks.yml` は `pipefail` 付きで strict を走らせる）
- 段落単位の変更は必ず段落レビュー（Tak OK）。構造変更は C1 cascade check（`templates/review_checklist.md`）を伴う

## SUITS.md Scene（add at TOP）

```markdown
### [YYYY-MM-DD HH:MM] Scene: 構造診断 — {原稿}

**INT. PEARSON SPECTER LITT - HARVEY'S OFFICE - DAY**

*Katrina が一枚の表を置く。節ごとの語数と venue の典型。*

**Katrina**: 「本文 {N} 語、venue 上限の {r}×。{節} が {k}×。Discussion の L{l} に数値 {n} 個。」

**Harvey**: 「{判断}。Discussion は判断を書く場所だ、証拠を書く場所じゃない。」

**Louis**: 「{duplicate / 構造に見えて主張の問題}」

---
```
