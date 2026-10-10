---
description: Claims registry — Harvey and Mike maintain the 主張↔証拠台帳 (CLAIMS.md); every claim in the manuscript must have on-disk evidence and a verb that matches its strength
model: opus
argument-hint: "[init | check | add <claim text>]"
---

# Research Lab: Claims（主張↔証拠台帳）

原稿のあらゆる主張（abstract を含む）を 1 行ずつ、証拠の所在・許される動詞・掲載箇所・状態とともに台帳に持つ。
Argument: $ARGUMENTS　File: `projects/{project}/CLAIMS.md`（template: `templates/claims_template.md`）

なぜ: 構成の迷走（v3 → v6）と「three gaps」の enumeration drift は、主張の正本が無く段落ごとに言い直したことから起きた（Louis memory: recurring holes #1, #2）。台帳があれば restructure は行の並べ替えで済み、証拠を削ったときに狭めるべき文言が一覧で分かる。

## `init`（Phase 5 の入口、または既存原稿に後付け）
1. **Harvey**: abstract → Discussion ¶1 → 各節の topic sentence の順に主張を 1 文ずつ抽出し、ID（C-01…）と Type（theory / simulation / application / literature）を振る。abstract に載る主張は "abstract: yes"
2. **Mike**: 各主張の **Evidence** を特定する — 命題番号、`results/*.csv` のファイルと列、`PROTOCOL_*.md` §2 の licenses 行。ディスクに無いものは `pending`
3. **Louis**: 各行に「reviewer が要求する証拠」を 1 行。動詞が許容表（template 冒頭）を超える行を指摘
4. **Donna**: 保存、`LAB_STATUS.md` の artifacts 表を更新、SUITS.md に scene（TOP）

## `check`（段落レビュー前・`/pre-review`・`/submission-check` が呼ぶ）
1. **Donna**: 各行の Evidence path がディスクに在るか（`ls` / `grep`）。`pending` の件数
2. **Mike**: Evidence が主張の文言を支えるか — 証拠より広い主張（wider）は narrow 候補。数値を含む行は `results/NUMBERS_LEDGER.csv` に対応行があるか
3. **Harvey**: 動詞を許容表に合わせる。narrowed / retracted は台帳下部の log に旧文言と理由を書く
4. **Katrina**: narrowed / retracted の旧文言を原稿全体で grep（C1 cascade）→ 残存 0 を確認
5. **判定**: 全行 `supported` → PASS。`pending` / mismatch が 1 行でもあれば FAIL（`/submission-check` を止める）

## `add <claim text>`
- **Harvey** が文言、**Mike** が Evidence、**Louis** が攻撃、**Donna** が記録。**証拠が無い主張は追加しない** — 証拠は `/protocol` で作る

## SUITS.md Scene（add at TOP）

```markdown
### [YYYY-MM-DD HH:MM] Scene: Claims registry — {init | check} {N} claims

**INT. PEARSON SPECTER LITT - HARVEY'S OFFICE - DAY**

*Harvey が台帳を机に置く。Mike が CSV を開いている。*

**Harvey**:
「主張は {N} 本。証拠が付いているのは {S}。残りは書かないか、証拠を作るかだ」

**Mike**:
「{pending の主張} は {evidence} で支えられます。{wider の主張} は証拠より広いので narrow が要ります」

**Louis**:
「{最も弱い行}。reviewer はここを突く」

---
```
