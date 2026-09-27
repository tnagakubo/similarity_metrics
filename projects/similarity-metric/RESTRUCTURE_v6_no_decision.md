# v6 — 判定の仕組みを抜いた構成（2026-09-26）

Tak（09-25）「厳密な判定方法は記載する必要がない。というか規定できない。違いを定量化して判定は臨床的な意味を考慮して行う」→（09-26）「判定の仕組みを抜いて」。
**v5（`RESTRUCTURE_v5_team.md`）は superseded**（判定の仕組みを増やす方向だったため）。本ファイルは計画であり、`.tex` は未編集。

## 0. 基準（全節に同じ物差しを当てる）
- **残す**: 不確かさ付きの量、またはその量の読み方の補助 — W₁、Prop. 1、推定量と bootstrap CI、Δ_max、所与の Δ_clin での L*、null floor（「ゼロと区別できない」という注意書き）、既存指標との比較
- **抜く**: 量を併合の判定・partner 数・手続きの推奨・EM や地域をまたぐ結合規則へ写すもの

## 1. 構成
| 節 | 内容 | 変更 |
|---|---|---|
| 1 Introduction | 現行のまま（gap は「分布全体」と「臨床的意味の指標」の二つで、判定規則を約束していない） | roadmap L91 の "operability check"・"decision performance" を言い換えるのみ |
| 2 Methods 2.1 Existing Approaches | 現行のまま | なし |
| 2.2 Per-EM W₁ | 現行のまま（Prop. 1、KR、TV 比較） | なし |
| 2.3 Estimation | 現行 + **null floor を推定量の性質として 2–3 文**（非負ゆえ同一分布でも正、小さい Ŵ₁ はゼロと区別できないことがある） | 現行 §2.5 から移設・縮約 |
| 2.4 Interpretation and Clinical Calibration | Δ_max と L*（CI 付き）、L_UB は sponsor の臨床判断 | **τ_clin（eq:tau_clin）と "screening rule"・"usable decision rule" を削除**。L206 の「§4.4 感度分析が primary robustness statement」を「L* を報告するので読者は任意の L_UB と比較できる」に置換 |
| ~~2.5 Operability~~ | — | **節ごと削除**（τ > q 条件、§2.4 と §4.2 の定義不一致も同時に消える） |
| 3 Simulation 冒頭 | 二つの study と二つの例数言明 | "Partner selection is the deliverable" を削除、三つ目の例数言明（operability）を削除 |
| 3.1 Study 2 | AUC、blind/partial/recovering、required n、clustering の再現 | 見出し "Decision Performance" → "Identification"（案）。内容は identification の証拠なので残す |
| 3.2 Study 1 | 現行のまま | L463 の operability 参照を「§2.3 の null floor」に付け替え |
| 4.1 Scenario | 現行のまま | なし |
| 4.2 Null floor | **どの距離が同一分布のノイズ内かの報告**として残す | 見出し "Is the Decision Resolvable" と「SBP が決定を担う」等の判定的読みを削除。τ_clin 列は削除 |
| 4.3 Distributional Assessment | 現行のまま（forest 図に τ 線なし、確認済み） | なし |
| 4.4 Clinical Interpretation | L_UB の例示値（L584）と **L* の表**（CI 付きを推奨）、臨床的な読み方の例示 | 適格 ✓ 列・Joint 列、AND 規則（L617）、L625 全体、L631–635 感度分析、L637「R4 最有力」を削除 |
| 4.5 Comparative Application | 既存指標との一致（`tab:app_allmethods`、¶5 の根拠）、位置差が支配的という機序、RV1=SMD | L677–681（anchor vs complete-linkage、直径）を削除。表の overlap は「τ_clin で W₁ が入れる k」に依存 → **Spearman のみ、または固定 k に再定義が必要（Katrina 要判断）** |
| 5 Discussion | ¶1 三つの貢献、実務、方針、限界、今後 | L706 全削除。L693 の "jointly eligible six partners"・"partner selection" を削除（「順位が EM で逆転する」観察は残す）。L695 の pool 移転の主張（per-EM bound を全 EM に当てる = 加法性問題）と "which partners are similar enough" を削除。L691 (iii) の operability 句を削除。L720 の "conservative ... maximum Δ_max" 文を削除（"deliberation rather than binary decisions" は Tak の原則そのものなので残す）。**限界に一文追加**: per-EM の bound は結合して joint の bound にならない（注意書き、規則ではない） |
| Appendix | 現行のまま | なし（v5 の新規三命題は不要） |

## 2. 触れる承認済み段落（再レビュー要）
L206（09-06 C）、L584 周辺（09-06 C）、L625（09-21 B、削除）、L691 ¶1（08-30 B）、L706（09-22、削除）、L712 ¶5（08-30 B、表の再定義次第）、L720 周辺（08-31 B）、L733 ¶D（09-22 B、感度分析参照の付け替え）

## 3. 語数の目安（LaTeX 込みの概算）
| 節 | 現行 | v6 |
|---|---|---|
| 2.4 + 2.5 | 1,362 | ≈ 850（2.3 へ移設分を含む） |
| 4.2 | 516 | ≈ 250 |
| 4.4 | 1,393 | ≈ 350 |
| 4.5 | 1,395 | ≈ 900 |
| Discussion | 2,285 | ≈ 1,600 |
| 合計 | — | **約 3,000 語減**（LaTeX 込み ≈ 15.3k → ≈ 12.2k） |

## 4. 09-23 の判断 6 件の処遇
1. キュー (3) — **解消**。τ_clin を削除し、L720 "deliberation rather than binary decisions" を残す
2. 案A — **消滅**（anchor vs clustering 自体を削除）
3. ¶1 の "three gaps" 訂正 — **残る**（(iii) は §2.1 に無い）。¶1+¶5 統合は不要
4. AND の加法性 — **限界の一文に縮小**。τ_k・joint Δ_max の開示・§2.5 新命題は不要
5. title — 現行 "Quantifying ... Similarity for Regional Pooling" が原則に合致、変更不要。abstract の "leading pooling candidates"・"pooling decisions" は Terminal pass の台帳へ
6. notation table・Figure 1 模式図 — 手続きのために提案したもので**不要**。`fig:simulation` の Supplement 移動は独立に可

## 5. 引用されなくなるスクリプト（削除しない）
`R/gusto_lub_sensitivity.R`（`gusto_lub_slack.csv`・`gusto_lub_scaling.csv`）、anchor-vs-clustering 系（`anchor_vs_clustering*.csv`）。`R/gusto_operability_check.R` は §4.2 で引き続き使用

## 6. 適用方法（Tak 判断）
一括の削除 pass（team）→ 残った段落のつなぎ文だけを段落レビュー、の二段。新しいつなぎ文は段落レビューを通るまで placeholder 扱い。

## 7. 適用記録（2026-09-26、Tak「OK」）
- 削除 pass 適用: 53 箇所（`apply_v6.py`、backup は scratchpad の `per_em_W1_wiley.before_v6.tex`）。diff 69+/109−、**24 → 21 ページ**、compile error 0・undefined ref 0
- つなぎ文を含む段落 18 箇所に `% V6-BRIDGE` 印 — **段落レビューまで placeholder**
- 計画からの補足: §4.5 の k は「L* > L_UB の地域数」に再定義（数値 9・11 は不変、τ_clin 不使用）。§4.5 見出しから "and Procedures" を削除。限界の一文は ¶D（Lipschitz 前提の段落）末尾に追加
- 未着手: ¶1 "three gaps" 訂正（判断③）、abstract（Terminal）。L693 の「同じ W₁ でも L* が partner で変わる」は同一 EM では L* = Δ_clin/W₁ で成り立たない既存の文 — 段落レビューで要確認
- 追記（advisor 指摘）: §2.3 と §4.2 の新しい null floor 文を訂正 —「上位裾」→「上位パーセンタイル以下」、「類似の証拠でも差の証拠でもない」→「差の証拠ではない。どこまで大きくありうるかは CI 上限で読む」（R5 は未解像だが age の上限 0.92）。再コンパイル error 0・21 ページ
- 後追い（未修正）: `PAPER_OUTLINE_BILINGUAL.md` に operability/jointly eligible/diameter が 49 箇所残る（stale）／`review_response/` の memo・presentation_proposals が旧 §2.5・L625 を参照（M4 対応の着地先が削除済み）／L647 の "admitted nine"・"changes the selection" は選択語彙が残る／abstract の "leading pooling candidates" は本文と不整合（Terminal pass）

## 8. §4.5 削除（2026-09-26 16:10、Tak「OK。両方外す」）
- §4.5 Comparative Application を節ごと削除（`tab:app_allmethods`、RV2/RV3・R6、ρ 段落を含む）。**ρ は 09-05 の Tak 決定（§4.5 残置）を Tak 自身が覆した**
- RV1 = SMD の射程の一文を Study 2 Design（RV1 定義直後）へ移設
- Discussion ¶4（判断④の sole carrier、08-30 承認）の参照先を §4.5 → Supplement E に付け替え、実データ調査の一文を追加（0.84–0.996、SD 比 ≤ 1.65）
- 両段落に V6-BRIDGE 印を追加（§4.5 内の 2 箇所は節ごと消えたため、総数は 18 のまま）。21 → 20 ページ、表 11 → 10、error 0・undefined 0
- 残課題: ¶4 の "mixtures and rare displaced subgroups, configurations that are clinically ordinary" は引用なし（未対応）／outline の §4.5 記述は stale

## 9. 誤り一括修正（2026-09-26 17:40、Tak「まず間違い・誤りをすべて修正」）
- 監査: Mike（数値・数学）/ Louis（論理・整合）/ Rachel（文献）。数値は大半が CSV と一致
- 適用 48 箇所、`% ERRFIX-2026-09-26` 印 37 段落。20 ページ、error 0・undefined 0。backup: scratchpad `per_em_W1_wiley.before_errfix.{tex,bib}`
- 主な修正: KS と W₁ bound の順序（M1 着地文、反例あり）／bootstrap 一致性の条件（{F₁=F₂∈(0,1)} 測度 0）と Appendix の漸近・bootstrap 文（Sommerfeld の結論を反転していた）／Prop. 1 に「τ は両地域共通・X のみの関数」／L* 表を区間付きに（R1・R4・R14 の丸め誤りも訂正）し地域数を削除／¶2「同じ W₁ でも重みが違う」／¶1 の (iii) 帰属／cell for cell／n 1,231–4,352／S1・S2 coverage／Set 4 記述（build_set4 と照合）／AUC 範囲／−0.004／Lee 1995／§4 目的と R8 の記述／「clinically ordinary」→「cannot be excluded in advance」
- bib: quan2010 DOI（…509、KB の INDEX・summary も修正）、song2025 著者、komiyama2024 year 2021（Crossref published-print 2021-11-16、key は据え置き）、austin2009 追加（Supplement E で引用）
- 未修正（Tak 判断）: abstract（Terminal）／Study 2 の harm と「KS は W₁ 尺度の要件を表現できない」の循環性／α=0.05 の resolved ラベル／Supplement 番号（B 未引用・C 欠番・E 仮）／VanderWeele の "interaction slope" 🔍／ICH E6(R3) の RWE 記述 🔍／Data availability と "publicly available"／r = 0.13 と L* 表の出典 CSV なし／Appendix の二標本正規極限の文献 🔍

## 10. 判断項目の確定（2026-09-26 18:10、Tak「一つずつ全員で議論して判断を確定」）
| # | 項目 | 確定 | 適用 |
|---|---|---|---|
| 1 | Study 2 の harm と「KS は W₁ 尺度の要件を表現できない」 | harm は W₁ 尺度で採点 = KR 双対で W₁ が定義上最適 → 循環。**harm を削除**、構成ラベルで採点する false-pooling rate のみ残す。KS 段落は population の順位逆転の事実を残し、最終文を「W₁ 尺度の順序の話で、臨床的優位の独立証拠ではない」に | 済 |
| 2 | α = 0.05 の resolved ラベル | α の文言を外し「95 パーセンタイルは推定値を読むための参照点」と記述。検定でないとは主張しない | 済 |
| 3 | Supplement 番号 | 未引用の旧 B（正規化不変性の数値例、A の数学と重複）を**外す**（ファイルは残す）。D → B、E → C。A の本文参照 §3.x → §2.x も訂正 | 済 |
| 4 | VanderWeele の "interaction slope" | 原典で確認できず、節も冗長 → **節ごと削除**（riley2010・fisher2017 で足りる） | 済 |
| 5 | ICH E6(R3) の RWE | 裏付けなし → **括弧句を削除** | 済 |
| 6 | Appendix の二標本正規極限 | 出典なしの表示式を**削除**。条件（測度 0）で bootstrap の記述につなぐ一文に | 済 |
| 7 | Data availability と "publicly available" | 本文が正しい（`predtools::gusto` は公開）。Data availability を Terminal pass で差し替え: "The GUSTO-I individual patient data used here are publicly available in the R package predtools (dataset gusto)." | Terminal |
| 8 | r = 0.13 と L* 表の出典 | r は Supplement C の pairs CSV から再現（Pearson 0.1331、120 ペア）→ 本文に出典を明記、"systematically" を削除。L* 表は `R/gusto_lstar_table.R` → `results/gusto_lstar_intervals.csv` を新設（表の行と完全一致） | 済 |
| 9 | abstract の誤り 4 件 | Tak の Terminal pass 規則を維持 | Terminal |
- 印: `% DECISION-2026-09-26`（11 段落）。20 ページ、error 0・undefined 0。backup: scratchpad `per_em_W1_wiley.before_decisions.tex`
