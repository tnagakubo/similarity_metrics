# LAB_STATUS — similarity-metric

> Phase state file。`/phase` が読み書きする。SUITS.md の Current Status と一致させる（Donna 管理、`scripts/check_consistency.sh` が照合）。
> Lifecycle の定義: `RESEARCH_FRAMEWORK.md`

**Project**: per-EM W₁ paper — "Quantifying Effect Modifier Similarity for Regional Pooling in MRCTs"
**Target**: *Statistics in Medicine*
**Manuscript**: `paper/per_em_W1_wiley.tex`（20 pp、v6 + Terminal pass 09-27。compile error 0 は 09-27 の記録、本環境では未検証）
**Phase**: 8 — Revision（査読応答）
**Phase entered**: 2026-09-06
**Updated**: 2026-10-11（Option B 導入後の on-disk sync。**Phase は変更していない** — gate の検証は `/phase next`）

## Lifecycle artifacts（2026-10-10、ディスクの実状態）

| artifact | path | status |
|---|---|---|
| Question / novelty | `EXISTING_METHODS_AND_NOVELTY.md` | ✅（2026-07-12） |
| Claims registry | `CLAIMS.md` | 🟡 雛形。候補 3 行は pending（`/claims init` 待ち） |
| Decision log | `DECISIONS.md` | 🟡 2026-09-25 以降を backfill。**D-20260927-1（#8–#50 一括適用）は Tak の一言で要クローズ** |
| Literature search log | `LITERATURE_SEARCH_LOG.md` | ❌ なし（Phase 1 は framework 以前に通過。gap の反証条件は未記載） |
| Protocols | `PROTOCOL_real_data_survey.md` | 🟡 1 本。Study 1 / Study 2 は protocol 以前に実施 — 事後 provenance（`results/STUDY1_PROVENANCE.md`）で代替、Discussion の limitations に「事前登録なし」の明記を検討 |
| Findings | `SIMULATION_FINDINGS*.md` | ✅ archive/SIMULATION_FINDINGS.md |
| Paragraph ledger | `REVIEW_QUEUE_v6.md` | ✅ 50/50（#1–#7 Tak 個別承認、#8–#50 包括指示 → D-20260927-1） |
| Numbers registry（生成） | `paper/numbers_registry.csv` → `paper/numbers_macros.tex` | 🟡 34 keys（§3.2 推定の結果）。`numbers_audit.py`: 672 → **526** unsourced（285 値）。残りは §3.1 の表・GUSTO の表が大半 → single writer を 2 本 |
| Generated tables | `paper/generated/tab_{bias,coverage,precision}.tex`（`R/make_paper_tables.R`） | ✅ 旧手打ち行と byte 一致、compile error 0、`pdftotext` 差分 0 |
| Numbers ledger（CSV に無い数値用） | `results/NUMBERS_LEDGER.csv` | ❌ 0 行 |
| CI | `.github/workflows/lab-checks.yml`, `r-and-tex.yml` | 🟡 追加済み、初回 run は push 後。TeX job は初回 green まで `continue-on-error` |
| Cloud setup | `scripts/cloud_setup.sh` | 🟡 **Tak**: 環境設定 → Setup script に登録 |
| Citation audit | `review_response/CITATION_AUDIT_*.md` | ❌ 未実施。`cite_audit.py`: cited 25 keys 全件 .bib にあり、DOI 欠落 1（E17 techreport、URL あり）、未引用 19 entries |
| Reproduction report | `results/REPRODUCTION_*.md` | ❌ 未実施。R lint: 絶対パス 20 本、sessionInfo 欠落 50 本超 |
| Response tracker / letter | `review_response/RESPONSE_TRACKER.md`, `RESPONSE_LETTER.md` | ❌ なし（`review_response/` には 09-06 の memo 3 本のみ） |

## Phase history

| Phase | Name | Entered | Gate evidence |
|---|---|---|---|
| 0 | Question | 2026-02-10 | `EXISTING_METHODS_AND_NOVELTY.md` |
| 1 | Literature | 2026-02 | `knowledge/INDEX.md`、Singh 2024 gap 確認（06-22） |
| 2 | Protocol | 2026-07 | simulation design 4 rules × 6 metrics × 12 anchors（07-21） |
| 3 | Implementation | 2026-07 | Rcpp bootstrap rule、W₁ 計算系統統一 max diff 0.0（08-15） |
| 4 | Results | 2026-08 | `SIMULATION_FINDINGS.md`、Study 1/2 |
| 5 | Writing | 2026-08 | §2–§4 執筆、Intro/Discussion 段落レビュー完了（09-01） |
| 6 | Internal review | 2026-09-05 | `/external-review` → Major Revision、5 unanticipated criticisms |
| 7 | Submission prep | — | 未着手（Terminal pass = abstract 250 words 保留中） |
| 8 | Revision | 2026-09-06 | `review_response/` 3 deliverables、¶A–¶C 適用済み |

## Open gates（現 Phase を抜ける条件）

旧 gate（2026-09-21 記載）と、Rule 6（2026-10-10）で加わった gate。チェックは on-disk evidence でのみ付ける。

- [ ] Harvey 推奨キュー (1)〜(6) への応答 — (1) ¶D は 09-22 に適用（commit `ab376fb`）。(2)〜(6) は v6（09-26）で対象箇所が削除・移動されたため **v6 後の原稿で再評価**（`/review` で Louis が残件を列挙）
- [ ] 各応答は段落レビュー（Tak OK）— 台帳は 50/50 だが #8–#50 は包括指示。**D-20260927-1 を Tak が閉じるまで ✅ にしない**
- [ ] Response letter / tracker — ディスクに無い。simulated review への応答文書を作るか、不要と判断するかを `/decide`
- [ ] `/verify-numbers` PASS — registry 34 keys、残り 526 literal（表 2 本を single writer に、prose を registry に）。ratchet baseline 526 は下げるだけ
- [ ] `/replicate` PASS（Study 2 estimation: Methods 本文だけから W₁ と bootstrap CI を再実装 → `w1_raw_summary.csv` と比較）
- [ ] `/cite-check` 全行 yes — 未実施
- [ ] `/reproduce` PASS — 未実施（絶対パス 20 本を先に直す）
- [ ] `/claims check` PASS — 候補 3 行 pending
- [ ] コンパイル error 0・undefined 0 — 09-27 の記録のみ（再 build で確認）
- [ ] `scripts/check_consistency.sh` clean

## Next

1. **Tak**: D-20260927-1 を閉じる（拒否なし、または拒否する段落番号）
2. `/claims init`（Harvey + Mike）→ `/verify-numbers`（registry: §3.1 と §4 の表を single writer に、Mike producer / Katrina verifier）→ `/cite-check`（Rachel）→ `/reproduce` と `/replicate`（Mike / Louis / Katrina）
2b. **Tak**: `scripts/cloud_setup.sh` を環境の Setup script に登録；CI の初回 run を確認
3. **Harvey**: response letter の要否を `/decide`。要るなら `/respond-reviewers init projects/similarity-metric/claude_science/referee_report.md`
4. `/review`（Louis、v6 後の原稿で旧キュー (2)〜(6) の残件を列挙）
5. `/phase next`（8 → 7: Terminal pass 再確認 → `/submission-check` R1–R8 → Jessica 承認 → 投稿）
