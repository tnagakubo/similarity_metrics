# LAB_STATUS — similarity-metric

> Phase state file。`/phase` が読み書きする。SUITS.md の Current Status と一致させる（Donna 管理、`scripts/check_consistency.sh` が照合）。
> Lifecycle の定義: `RESEARCH_FRAMEWORK.md`

**Project**: per-EM W₁ paper — "Quantifying Effect Modifier Similarity for Regional Pooling in MRCTs"
**Target**: *Statistics in Medicine*
**Manuscript**: `paper/per_em_W1_wiley.tex`（20 pp、v6 + Terminal pass 09-27 + Tak の 09-27 決定（RV1–RV3・clustering を外す、W₁ で順位付け）を Option B の生成基盤の上に載せ直してマージ（2026-10-11、D-20261011-8）。compile error 0・undefined 0、Tak の機械で latexmk 再 build）
**Question / Aims**（Tak 2026-10-12 10:46 — RESEARCH_FRAMEWORK S22。Aim は**目的**であって方法ではない）: **A1** 効果修飾因子の分布の類似性を定量的に評価する指標を提示すること。判定規則・partner 数・結合規則は Aim に含まない（`memory/feedback_quantify_not_decide.md`）
**Results that answer A1**（目的と結果の対応 — Results の小節と CLAIMS の行はこの番号を持つ）: R1 指標の定義と性質（per-EM W₁、Prop. 1 Δ_max = L·W₁、既存指標 KS / SMD との関係）; R2 指標が EM 分布の違いに盲目でないこと（Study 1）; R3 指標の推定量と bootstrap 区間の性能（Study 2、MCSE 付き）; R4 指標の読み方の例示（GUSTO-I）。この四つのどれにも答えない結果は原稿に入れない（`IDEAS_BACKLOG.md` / `exploratory/`）
**Phase**: 8 — Revision（査読応答）
**Phase entered**: 2026-09-06
**Updated**: 2026-10-14 01:40（D-20261014-1 **applied**: 本文 11,097 → **9,617 語**（1.6×、74 cuts + Louis review-fix の復元、拒否権項目 15）。Tables 3–5 → `tab:estimation`。build 0/0/**21 pp**、guards 59 0 FAIL、abstract 250/250、unsourced 0、verify ALL PASS。**Phase は変更していない**。commit 1f6fc6b（lab）/ d32af02（paper）、origin/main に push 済み（2026-10-14 07:52）。次: 拒否権項目の確認（Tak）、bootstrap 端点の MC 誤差、L_UB の根拠、Álvarez-Esteban）

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
| Numbers registry（生成） | `paper/numbers_registry.csv` → `paper/numbers_macros.tex` | ✅ **132 keys、全 key 使用**（RV・clustering の孤児 46 keys を削除、5 keys 追加 — D-20261011-8）。`numbers_audit.py`: 672 → 526 → 2 → **0** unsourced（維持）。`check` PASS（R = Python） |
| Generated tables | `paper/generated/tab_*.tex`（**9 本**、`R/make_paper_tables.R`） | ✅ tab:study2_required_n は W₁/KS/SMD の 3 列、tab:study2_ari は削除、tab:gusto_nabcd に Rank 列（null floor 内は dagger range を `gusto_operability.csv` から生成）— D-20261011-8；tab:study2_required_n_mc（W₁ vs KS、`R/required_n.R` の delta 法）は維持 |
| Numbers ledger（設計定数） | `results/NUMBERS_LEDGER.csv` | ✅ 31 行、**Katrina 署名 31/31**（Methods 補強で加えた 97.5 / 1,000 / 42 と Louis review で加えた $z_{0.975}$ も source で確認、2026-10-11） |
| Derived numbers（single writer） | `R/make_derived_numbers.R` → `results/derived/*.csv`（AUC range、error rate と chance、Set 4 母集団 W₁/KS、oracle−silhouette、GUSTO Spearman/SD 比、S6 閉形式、N/n_R8） | ✅ 乱数なし、`sessionInfo` 併置。CI が鮮度を検査 |
| Replication report | `results/REPLICATION_20261011.md`（+ `results/replication/`） | ✅ **PASS**（coverage 0.009、moments ≤ 0.099 vs 許容 0.025/0.30）。true_W1 FAIL は本文の 2 桁丸めが原因 → Methods を補強（A1 resampling scheme、A2 S1 coverage、正確な true W₁、seed/RNG、type-7 quantile；D-20261011-7） |
| Referee report（cold read, 2026-10-11） | `review_response/REFEREE_20261011.md` + `review_response/referee/20261011/`（R 8 本） | ✅ Major 5 / Minor 14、再計算 44 行不一致 0。**判断 D-20261011-11、適用済み（2026-10-12）**: M1–M5・Minor 1–7, 9, 10, 12 ✅、Minor 8 却下、Minor 11/13/14 ⏳。guard 30 本 strict（referee の 15 本は pending → 昇格）。`FIX_REVIEW_20261011.md` residue 0 |
| Residual review（2026-10-12） | `review_response/INTERNAL_REVIEW_20261012.md`（Louis）、`VERIFY_RESIDUAL_20261012.md`（Mike A1–A9）、`CITATION_AUDIT_20261012.md`（Rachel）、`KATRINA_FIG3_TABLES_20261012.md` + `KATRINA_TABLE_FOLD_20261012.md`、`results/VERIFY_FOUREYES_20261012.md`、`FIX_REVIEW_20261012.md`（cascade）、`FIX_DIFF_20261012.diff`、known_bad `review_response/known_bad/per_em_W1_wiley_20261012.tex` | ✅ 判断 D-20261012-2、**適用済み 11:00**: Critical 4（C1 both suffice / C2 standardized distance / C3 n^{-1/2} / C4 uniform shift）、Major 10（M1–M10、Table 1→2 統合）、Minor 採用 14、Matsushima・FTT・Song の引用訂正、Louis `/review-fix`（`FIX_REVIEW_LOUIS_20261012.md`、K1–K3 適用）。本文 9,923 語（実質不変）。guard `LR2-*` 11 本 strict。Tak の拒否権は `% Paragraph revised 2026-10-12 (D-20261012-2 …)` の段落に対して投稿前まで開いている |
| Round 3（2026-10-12 午後） | `review_response/EXTERNAL_REVIEW_20261012.md`（外部、Tak 経由）、`review_response/referee/20261012/REFEREE_20261012.md`（冷読 #2、再計算 44 行不一致 0）、`EXTERNAL_REVIEW_ATTACK_20261012.md`（Louis）、`LIT_POSITIONING_20261012.md`（Rachel、9 本）、`LENGTH_PLAN_20261012.md`（Katrina）、`PROTOCOL_set4_control_mechanism.md`（新、本番 run 済み）、`PROTOCOL_study2_extension.md`（新、実行中）、`results/VERIFY_FOUREYES_20261012_round3.md`、`exploratory/set4_control_mechanism/` | ✅ D-20261012-3 **applied（10-13 00:55）**: 断る 3 件（EXT M3 Study 3 / M5 決定規則 / M7(b)）は科学的理由を記録；採用: attainment → class 内 sharp + 単調 bound、可縮性、Jensen、Study 1 の射程、位置づけ段落（bib +8）、Set 4 機構（登録済み）、片側上限・basic 区間、permutation、外れ値・heaping、Table 8 の † 区間、誤植。Study 2 拡張 11 cell は `tab_study2_ext` と §3.2・§4.2 の一文で本文に；Louis round 3（C3/M15/m9）も反映。ARS integrity PASS WITH NOTES、re-review Minor Revision、応答表あり。残: 長さ、Minor 10、M7(a) |
| Numbers gates | `results/verify_study2.log`, `results/verify_study1_app.log` | ✅ ALL PASS（2026-10-11 22:00 再実行、134 + 60 checks；`verify_study1_app_numbers.R` は Table 5 の Rank 列も `generated/tab_gusto_nabcd.tex` から読む） |
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
- [x] `/verify-numbers` — registry 132 keys（全 key 使用）、表 9 本生成、ledger 31 行、unsourced **0**（ratchet baseline 0）。ledger 30/30 署名。`/claims check` と合わせて Mike が最終 PASS を宣言
- [x] `/replicate` PASS（2026-10-11、`results/REPLICATION_20261011.md`）— Methods の欠落 A1/A2 は D-20261011-7 で本文に反映済み
- [x] `/referee` Major 5 件 — 方針 D-20261011-10、判断 D-20261011-11、**適用 2026-10-12**（R 3 本・registry +20・原稿 46 置換・`/review-fix fad1010` residue 0・guards 30 strict PASS・build 0/0/21 pp）。Tak の拒否権は `% Paragraph revised 2026-10-11 (D-20261011-11 …)` 29 段落に対して投稿前まで開いている。残: Minor 11（Rachel）、Minor 13（Katrina）、`/claims check`（C-43 pending、C-08/09 の verify）
- [x] 残差レビュー（2026-10-12、D-20261012-2）— Louis C4/M10 全件適用、Louis `/review-fix`（`FIX_REVIEW_LOUIS_20261012.md`）、四つ目の目（Katrina、23 keys 一致、Harvey の説明文 1 件を訂正）。残: `gusto_operability.csv` の旧列 `tau_clin`/`eligible` の整理（code 公開準備、Louis m16）、C4 の機構は `/explore` 候補
- [ ] `/cite-check` 全行 yes — **部分実施 2026-10-12**（`CITATION_AUDIT_20261012.md`: 原典で読んだ 11 keys のうち Matsushima NOT SUPPORTED → 訂正済み、partial 5 → 訂正済み（FTT 条件、Song 限定）/ 記録済み；PDF 不在 lee1995・andrews2000・austin2011 ほかは Paper Request）
- [ ] `/reproduce` PASS — 未実施（絶対パス 20 本を先に直す）
- [ ] `/claims check` PASS — 43 行。**2026-10-12**: supported 7（C-05/06/08/10/11/23/37）、narrowed 6（C-08/09/16/17/32/35）、withdrawn 1（C-30）、retracted 1（C-34）、残り pending（Mike が verify 中、C-43 は Katrina の verify 待ち）
- [x] コンパイル error 0・undefined 0（2026-10-11 22:00、マージ後に latexmk で再 build、20 pp；overfull 4）。注: `paper/build.sh` の `TEXINPUTS` は `:` 区切りで Windows では `.cls` を見失う（CI/Linux 用；ローカルは latexmk）
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
