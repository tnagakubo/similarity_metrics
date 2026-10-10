# LAB_STATUS — similarity-metric

> Phase state file。`/phase` が読み書きする。SUITS.md の Current Status と一致させる（Donna 管理）。
> Lifecycle の定義: `RESEARCH_FRAMEWORK.md`

**Project**: per-EM W₁ paper — "Quantifying Effect Modifier Similarity for Regional Pooling in MRCTs"
**Target**: *Statistics in Medicine*
**Manuscript**: `paper/per_em_W1_wiley.tex`（v6、20 pp、Supplement なし）
**Phase**: 7 — Submission prep（Terminal pass 済み → `/submission-check` 実施中）
**Phase entered**: 2026-09-06
**Updated**: 2026-10-10

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
| 7 | Submission prep | 2026-10-10 | Terminal pass 済み（abstract 247 語、09-27）。`/submission-check` 実施中 |
| 8 | Revision（内部査読応答） | 2026-09-06 → 09-27 完了 | v6 再構成（判定の仕組みを削除）、段落レビュー 50/50、ゲート 2 本 ALL PASS、`6ec5a16` |

## Open gates（Phase 7 → 投稿）

- [ ] `/submission-check` 全項目 PASS（`paper/submission/SUBMISSION_CHECK_20261010.md`）
- [ ] `/verify-numbers` PASS（`R/verify_study1_app_numbers.R`、`R/verify_study2_figures.R`）
- [ ] コンパイル error 0・undefined 0
- [ ] Jessica 承認
- [ ] Rule 2.7: JA 版は意図的に削除済み（EN 完成まで保留）。投稿後に再作成するかは Tak 判断

## Next

- `/submission-check` の指摘を処理 → Jessica 承認 → 投稿
- 投稿前の整理: `results/gusto_operability.csv` の旧列、stale 文書（`PAPER_OUTLINE_BILINGUAL.md`、`review_response/`）
