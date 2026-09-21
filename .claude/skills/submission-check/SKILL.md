---
description: Submission readiness check (Terminal pass) — Katrina verifies every journal requirement on disk before Jessica approves
model: opus
---

# Research Lab: Submission Check（Phase 7 gate）

投稿前の Terminal pass。すべて **on-disk evidence** で判定する。語られただけの項目は ❌。

## Execution

1. **Katrina**: 以下を一つずつ検証し、表に verdict を書く
   - コンパイル: `build.sh` 実行 → error 0、undefined reference 0、overfull box の件数
   - Abstract: 語数 ≤ 250（SIM 規定）。本文と数値・名称が一致
   - Abbreviations: 初出フルスペル、略語表と本文の整合
   - Figures: width 7"、base_size 11、greyscale、caption は「何がプロットされているか」のみ
   - Tables: 桁数規則（`feedback_tak_feedback_patterns.md` 数値表記パターン）
   - References: 全 entry に DOI（🔍 未取得は列挙）、本文 `\cite` と `.bib` の整合、bbl に未解決 0
   - Data availability / Code availability statement の存在と citation
   - Supplement: 本文から参照される supplement が全て存在
   - 禁則語 grep: `\emph{`、"recommends"（E17 文脈）、"significant"（検定文脈）、"proves"
2. **Mike**: `/verify-numbers` を実行し PASS を添える
3. **Rachel**: 引用の最終確認（著者名・年・タイトルの typo、DOI リンク疎通）
4. **Louis**: 一読して「reviewer の第一印象」を 3 行で
5. **Jessica**: 承認 / 差し戻し。「Let me be clear」で一言
6. **Donna**: 結果を `projects/{project}/paper/submission/SUBMISSION_CHECK_{YYYYMMDD}.md` に保存、SUITS.md に scene（TOP）。承認なら `/phase next`

## 出力表

| 項目 | 検証方法 | 結果 | 担当 |
|---|---|---|---|
