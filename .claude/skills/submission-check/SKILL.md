---
description: Submission readiness check (Terminal pass) — Katrina verifies every journal requirement on disk before Jessica approves
model: opus
---

# Research Lab: Submission Check（Phase 7 gate）

投稿前の Terminal pass。すべて **on-disk evidence** で判定する。語られただけの項目は ❌。
科学的報告基準は `templates/reporting_checklist.md`（R1–R8）、journal 形式は `paper/submission/SUBMISSION_CHECKLIST.md`。
Output: `projects/{project}/paper/submission/SUBMISSION_CHECK_{YYYYMMDD}.md`

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
2. **Mike**: `/verify-numbers` — `python3 scripts/numbers_audit.py <tex>` の unsourced 0（または各件に exclusion reason）、ledger の全行に verifier。`/reproduce` の最新 `REPRODUCTION_*.md` が PASS。性能指標に MCSE
3. **Rachel**: `/cite-check` — `scripts/cite_audit.py` の cited-but-missing 0、article 系の DOI 欠落 0、`CITATION_AUDIT_*.md` の "supports the claim?" 全行 yes。著者名・年・タイトルの typo、DOI リンク疎通
3b. **Harvey**: `/claims check` PASS — abstract の各文が `CLAIMS.md` の supported 行に対応。段落レビュー台帳の全行が Tak 承認（個別 OK、または包括指示が `DECISIONS.md` に日時付きで記録されていること。「Harvey 推奨で適用」のまま投稿しない）
3c. **Donna**: `bash scripts/check_all.sh` → `MECHANICAL_CHECKS_{date}.md` を添付、`check_consistency.sh` clean、`DECISIONS.md` に構成・射程・supplement の判断が理由付きで在る
4. **Louis**: 一読して「reviewer の第一印象」を 3 行で
5. **Jessica**: 承認 / 差し戻し。「Let me be clear」で一言
6. **Donna**: 結果を `projects/{project}/paper/submission/SUBMISSION_CHECK_{YYYYMMDD}.md` に保存、SUITS.md に scene（TOP）。承認なら `/phase next`

## 出力表

| 項目 | 検証方法 | 結果 | 担当 |
|---|---|---|---|
