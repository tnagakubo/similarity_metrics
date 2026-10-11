# LAB_STATUS — similarity-metric

> Phase state file。`/phase` が読み書きする。SUITS.md の Current Status と一致させる（Donna 管理、`scripts/check_consistency.sh` が照合）。
> Lifecycle の定義: `RESEARCH_FRAMEWORK.md`

**Project**: per-EM W₁ paper — "Quantifying Effect Modifier Similarity for Regional Pooling in MRCTs"
**Target**: *Statistics in Medicine*
**Manuscript**: `paper/per_em_W1_wiley.tex`（20 pp、v6 + Terminal pass 09-27。compile error 0 は 09-27 の記録、本環境では未検証）
**Phase**: 8 — Revision（査読応答）
**Phase entered**: 2026-09-06
**Updated**: 2026-10-11 夜（Tak の判断 3 件 — Table 1 の注、Methods の補強、C-34/C-35/C-08 — を適用後の on-disk sync。**Phase は変更していない** — gate の検証は `/phase next`）

## Lifecycle artifacts（2026-10-10、ディスクの実状態）

| artifact | path | status |
|---|---|---|
| Question / novelty | `EXISTING_METHODS_AND_NOVELTY.md` | ✅（2026-07-12） |
| Claims registry | `CLAIMS.md` | 🟡 39 行。**C-34 retracted、C-08/C-33/C-35 narrowed（2026-10-11、D-20261011-7）**、C-11 に CI 追記、他 pending（Mike の verify 待ち）。evidence path は全件実在 |
| Decision log | `DECISIONS.md` | 🟡 2026-09-25 以降を backfill。**D-20260927-1（#8–#50 一括適用）は Tak の一言で要クローズ** |
| Literature search log | `LITERATURE_SEARCH_LOG.md` | ❌ なし（Phase 1 は framework 以前に通過。gap の反証条件は未記載） |
| Protocols | `PROTOCOL_real_data_survey.md`, `PROTOCOL_study1_identification.md`（**事後登録**、prior-look 開示付き、2026-10-11） | 🟡 Study 2（estimation）は protocol 以前に実施 — `results/STUDY1_PROVENANCE.md` と `R/study2_mcse.R`（MCSE）で代替。Study 1 は事後 protocol に plan（07-11）・production（07-11/12）・extension（07-20）・閾値（07-20）の時系列を開示 |
| Findings | `SIMULATION_FINDINGS*.md` | ✅ archive/SIMULATION_FINDINGS.md |
| Paragraph ledger | `REVIEW_QUEUE_v6.md` | ✅ 50/50（#1–#7 Tak 個別承認、#8–#50 包括指示 → D-20260927-1） |
| Numbers registry（生成） | `paper/numbers_registry.csv` → `paper/numbers_macros.tex` | ✅ **172 keys**。`numbers_audit.py`: 672 → 526 → 2 → **0** unsourced（Table 1 の注を registry 化、D-20261011-7）。`check` PASS（R = Python） |
| Generated tables | `paper/generated/tab_*.tex`（**10 本**、`R/make_paper_tables.R`） | ✅ 9 本は旧 tabular と byte 一致；10 本目 tab:study2_required_n_mc（W₁ vs KS の required n と 95% Monte Carlo 区間、`R/required_n.R` の delta 法）を新設 |
| Numbers ledger（設計定数） | `results/NUMBERS_LEDGER.csv` | ✅ 30 行、**Katrina 署名 30/30**（Methods 補強で加えた 97.5 / 1,000 / 42 も source で確認、2026-10-11） |
| Derived numbers（single writer） | `R/make_derived_numbers.R` → `results/derived/*.csv`（AUC range、error rate と chance、Set 4 母集団 W₁/KS、oracle−silhouette、GUSTO Spearman/SD 比、S6 閉形式、N/n_R8） | ✅ 乱数なし、`sessionInfo` 併置。CI が鮮度を検査 |
| Replication report | `results/REPLICATION_20261011.md`（+ `results/replication/`） | ✅ **PASS**（coverage 0.009、moments ≤ 0.099 vs 許容 0.025/0.30）。true_W1 FAIL は本文の 2 桁丸めが原因 → Methods を補強（A1 resampling scheme、A2 S1 coverage、正確な true W₁、seed/RNG、type-7 quantile；D-20261011-7） |
| Numbers gates | `results/verify_study2.log`, `results/verify_study1_app.log` | ✅ ALL PASS（2026-10-11 再実行；`verify_study1_app_numbers.R` は生成表を読み predtools 無しで走る） |
| CI | `.github/workflows/lab-checks.yml`, `r-and-tex.yml` | 🟡 追加済み（generated tables・derived CSV・macros の鮮度検査を含む）、初回 run は push 後。TeX job は初回 green まで `continue-on-error` |
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
- [x] `/verify-numbers` — registry 172 keys、表 10 本生成、ledger 30 行、unsourced **0**（ratchet baseline 0）。ledger 30/30 署名。`/claims check` と合わせて Mike が最終 PASS を宣言
- [x] `/replicate` PASS（2026-10-11、`results/REPLICATION_20261011.md`）— Methods の欠落 A1/A2 は D-20261011-7 で本文に反映済み
- [ ] `/cite-check` 全行 yes — 未実施
- [ ] `/reproduce` PASS — 未実施（絶対パス 20 本を先に直す）
- [ ] `/claims check` PASS — 39 行起票、全行 pending（Mike が evidence を verify して supported に）
- [x] コンパイル error 0・undefined 0（2026-10-11 夜の再 build、21 pp；overfull 9 は基準と同数）
- [ ] `scripts/check_consistency.sh` clean — 2 findings（RESPONSE_TRACKER なし、CLAIMS 全行 pending）

## Next

1. **Tak**: D-20260927-1 を閉じる（拒否なし、または拒否する段落番号）；今日の 3 判断と Louis review で変わった段落（abstract、§2.3、§3.1 design/selection と Table 1–2 の注、§3.2 design/results/summary、§4.3、§5 ¶1 (iii)・¶2–¶4）を段落レビューで確認
1b. **Tak**: Louis review の残り 6 件（D-20261011-7 addendum）— 特に "near-nominal" の扱い（C-09）と BCa の一文開示
2. **Mike**: `/claims check` — 39 行の evidence を 1 行ずつ verify（supported / narrowed）；`/verify-numbers` の最終 PASS を宣言（ledger 30/30 署名済み）
3. **Rachel**: `/cite-check`（26 keys、新規 `bonett2000` を含む；DOI 欠落 1）→ `review_response/CITATION_AUDIT_*.md`
4. **Mike / Katrina**: `/reproduce`（絶対パス 20 本・sessionInfo 欠落を先に直す；R lint baseline 22 は下げるだけ）
5. **Tak**: `scripts/cloud_setup.sh` を環境の Setup script に登録；CI の初回 run を確認して `continue-on-error` を外す
6. **Harvey**: response letter の要否を `/decide`。要るなら `/respond-reviewers init projects/similarity-metric/claude_science/referee_report.md`
7. `/review`（Louis、v6 後の原稿で旧キュー (2)〜(6) の残件を列挙）→ `/phase next`（8 → 7: Terminal pass → `/submission-check` R1–R8 → Jessica 承認 → 投稿）
