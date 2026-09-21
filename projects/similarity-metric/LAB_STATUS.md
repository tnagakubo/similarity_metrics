# LAB_STATUS — similarity-metric

> Phase state file。`/phase` が読み書きする。SUITS.md の Current Status と一致させる（Donna 管理）。
> Lifecycle の定義: `RESEARCH_FRAMEWORK.md`

**Project**: per-EM W₁ paper — "Quantifying Effect Modifier Similarity for Regional Pooling in MRCTs"
**Target**: *Statistics in Medicine*
**Manuscript**: `paper/per_em_W1_wiley.tex`（23 pp）
**Phase**: 8 — Revision（査読応答）
**Phase entered**: 2026-09-06
**Updated**: 2026-09-21

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

- [ ] Harvey 推奨キュー (1)〜(6) の全項目に応答（¶D Discussion limitation 新設 から再開）
- [ ] 各応答は段落レビュー（Tak OK）を通す
- [ ] Response letter（comment / response / change / location）を `review_response/` に作成
- [ ] `/verify-numbers` PASS
- [ ] コンパイル error 0・undefined 0

## Next

- ¶D Discussion limitation 新設（L159 の予告の受け皿）
- キュー (2) 綻び2件（§2.5-L214・§4.2）→ (3) binary remark + L66 → (4) RWE caveat → (5) presentation 3点 → (6) minors
- Phase 7 に戻って Terminal pass（abstract）→ Jessica 承認 → 投稿
