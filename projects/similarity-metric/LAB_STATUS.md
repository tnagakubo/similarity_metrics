# LAB_STATUS — similarity-metric

> Phase state file。`/phase` が読み書きする。SUITS.md の Current Status と一致させる（Donna 管理、`scripts/check_consistency.sh` が照合）。
> Lifecycle の定義: `RESEARCH_FRAMEWORK.md`

**Project**: per-EM W₁ paper — "Quantifying Effect Modifier Similarity for Regional Pooling in MRCTs"
**Target**: *Statistics in Medicine*
**Manuscript**: `paper/per_em_W1_wiley.tex`（20 pp、v6 + Terminal pass 09-27。compile error 0 は 09-27 の記録、本環境では未検証）
**Phase**: 8 — Revision（査読応答）
**Phase entered**: 2026-09-06
**Updated**: 2026-10-11 夜（数値の全件生成・`/claims init`・`/replicate` 完了後の on-disk sync。**Phase は変更していない** — gate の検証は `/phase next`）

## Lifecycle artifacts（2026-10-10、ディスクの実状態）

| artifact | path | status |
|---|---|---|
| Question / novelty | `EXISTING_METHODS_AND_NOVELTY.md` | ✅（2026-07-12） |
| Claims registry | `CLAIMS.md` | 🟡 39 行起票（`/claims init`、Harvey、2026-10-11）、**全行 pending**。evidence path は全件実在（gate log 2 本は再生成して追跡対象に）。弱い主張 3 本（C-34 BCa、C-35、C-08）と ⚠ 7 行 → D-20261011-6（Tak の判断） |
| Decision log | `DECISIONS.md` | 🟡 2026-09-25 以降を backfill。**D-20260927-1（#8–#50 一括適用）は Tak の一言で要クローズ** |
| Literature search log | `LITERATURE_SEARCH_LOG.md` | ❌ なし（Phase 1 は framework 以前に通過。gap の反証条件は未記載） |
| Protocols | `PROTOCOL_real_data_survey.md` | 🟡 1 本。Study 1 / Study 2 は protocol 以前に実施 — 事後 provenance（`results/STUDY1_PROVENANCE.md`）で代替、Discussion の limitations に「事前登録なし」の明記を検討 |
| Findings | `SIMULATION_FINDINGS*.md` | ✅ archive/SIMULATION_FINDINGS.md |
| Paragraph ledger | `REVIEW_QUEUE_v6.md` | ✅ 50/50（#1–#7 Tak 個別承認、#8–#50 包括指示 → D-20260927-1） |
| Numbers registry（生成） | `paper/numbers_registry.csv` → `paper/numbers_macros.tex` | ✅ **154 keys**（§3.2 の 34 + prose の結果数値 120）。`numbers_audit.py`: 672 → 526 → **2** unsourced。残り 2 は tab:study2_required_n 注の「0.44--0.46」で、grid の値から再現しない（RV3 は 0.43 まで下がる）→ D-20261011-4 finding、Tak の判断待ち。`verify-draft` 154/154、`check` PASS（R = Python） |
| Generated tables | `paper/generated/tab_*.tex`（9 本、`R/make_paper_tables.R`） | ✅ §3.1（required n、ARI）、§3.2（bias、coverage、precision）、GUSTO（R8、operability、nabcd、L*）。旧 tabular と byte 一致、compile error 0、`pdftotext` 差分 0、PDF サイズ同一 |
| Numbers ledger（設計定数） | `results/NUMBERS_LEDGER.csv` | ✅ 27 行（n grid、B、反復数、AUC/ARI 目標、CI 水準、margin、Set 4 設計値）、source_locator 付き。producer Mike、verifier Katrina（four eyes、2026-10-11）: **27/27 署名**。1 行は Mike の note の数え間違い（11 → 12 of 15）を Katrina が検出、修正後に locator を直した 3 行とともに再照合して署名 |
| Derived numbers（single writer） | `R/make_derived_numbers.R` → `results/derived/*.csv`（AUC range、error rate と chance、Set 4 母集団 W₁/KS、oracle−silhouette、GUSTO Spearman/SD 比、S6 閉形式、N/n_R8） | ✅ 乱数なし、`sessionInfo` 併置。CI が鮮度を検査 |
| Replication report | `results/REPLICATION_20261011.md`（+ `results/replication/`） | ✅ **PASS**（coverage 0.009、moments ≤ 0.099 vs 許容 0.025/0.30）。true_W1 FAIL は本文の 2 桁丸めが原因 → Methods action A1/A2 ほか（D-20261011-5） |
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
- [ ] `/verify-numbers` PASS — registry 154 keys、表 9 本生成、ledger 27 行（Katrina 検証）。残り **2** literal（0.44--0.46、再現せず → Tak の判断）。ratchet baseline 2 は下げるだけ
- [x] `/replicate` PASS（2026-10-11、`results/REPLICATION_20261011.md`：推定量と区間の全指標が許容差内）— ただし Methods 本文の欠落 A1/A2（resampling scheme、S1 coverage）を直すまで本文側は未完
- [ ] `/cite-check` 全行 yes — 未実施
- [ ] `/reproduce` PASS — 未実施（絶対パス 20 本を先に直す）
- [ ] `/claims check` PASS — 39 行起票、全行 pending（Mike が evidence を verify して supported に）
- [x] コンパイル error 0・undefined 0（2026-10-11 再 build、20 pp、`pdftotext` 差分 0）
- [ ] `scripts/check_consistency.sh` clean — 2 findings（RESPONSE_TRACKER なし、CLAIMS 全行 pending）

## Next

1. **Tak**: D-20260927-1 を閉じる（拒否なし、または拒否する段落番号）
2. **Tak**: 本文に触る判断 3 件 — (a) D-20261011-4 finding: tab:study2_required_n 注の 0.44--0.46 → 0.43--0.46；(b) D-20261011-5: Methods に bootstrap の resampling scheme（A1）と S1 coverage の扱い（A2）、true W₁ の正確値、seed/RNG、`\label{sec:study1}` 修正、「at most 0.005」；(c) D-20261011-6: C-34 削除／C-35 動詞+CI／C-08 required n の MC 不確かさ
3. **Mike**: `/claims check` — 39 行の evidence を 1 行ずつ verify（supported / narrowed）；`/verify-numbers` の最終 PASS 宣言（ledger の Katrina 検証を確認）
4. **Rachel**: `/cite-check`（25 keys、DOI 欠落 1）→ `review_response/CITATION_AUDIT_*.md`
5. **Mike / Katrina**: `/reproduce`（絶対パス 20 本・sessionInfo 欠落を先に直す；R lint baseline 22 は下げるだけ）
6. **Tak**: `scripts/cloud_setup.sh` を環境の Setup script に登録；CI の初回 run を確認して `continue-on-error` を外す
7. **Harvey**: response letter の要否を `/decide`。要るなら `/respond-reviewers init projects/similarity-metric/claude_science/referee_report.md`
8. `/review`（Louis、v6 後の原稿で旧キュー (2)〜(6) の残件を列挙）→ `/phase next`（8 → 7: Terminal pass → `/submission-check` R1–R8 → Jessica 承認 → 投稿）
