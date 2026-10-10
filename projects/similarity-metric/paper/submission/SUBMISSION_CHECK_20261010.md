# Submission Check — 2026-10-10

対象: `paper/per_em_W1_wiley.tex`（`6ec5a16`、v6）。判定: **差し戻し（Jessica）**。投稿前に下記 Blocker 3 件と Major の判断が必要。

## 1. 機械的検証（on-disk evidence）

| 項目 | 検証方法 | 結果 | 担当 |
|---|---|---|---|
| コンパイル | scratchpad コピーで pdflatex → bibtex → pdflatex ×2（TeX Live 2023） | ✅ error 0、undefined ref/cite 0、20 pp。Overfull 3（L51 作者ブロック 351pt、L730 9pt、output vbox 29pt。いずれも既存） | Katrina |
| Bibliography | bbl / blg | ✅ bibitem 25、BibTeX warning 0 | Katrina |
| Abstract 語数 | 09-27 Terminal pass | ✅ 247 語（≤ 250） | Katrina |
| 数値ゲート Study 1 / Application / Discussion | `R/verify_study1_app_numbers.R`（predtools 0.0.3 を CRAN から導入） | ✅ 55/55 PASS（09-27 の「56」は overall 行を含めた数） | Mike |
| 数値ゲート Study 2（identification） | `R/verify_study2_figures.R` | ✅ ALL PASS | Mike |
| 引用 | 25 key × Crossref | ✅ 25/25 存在、24 一致 + GUSTO 1993 は書誌検索で一致。DOI 欠落は `iche17` のみ（ICH 文書、DOI なし、URL あり） | Rachel |
| Supplement 参照 | grep | ❌ Back matter「Supporting information」節が存在しない SI に R code を約束（下 #1） | Louis/Donna |

## 2. 処置済み（本日）

- **`R/study1_miss_side.R`**: S6/S7 の真値が rds 内の旧 Monte-Carlo 値（12.1532、5.8454）だった。Table 3 の exact quadrature 値（12.159806、5.833155）に切替えて再実行。結果: S7 coverage 0.928/0.935/0.943 で Table 5 と一致、upper 側 miss の最大 1.12%（S7, n=200）→ 本文「at most 1.1%」は**そのまま成立**。ゲート再実行 ALL PASS。本文変更なし。

## 3. Louis の指摘（27 件）— トリアージ

検証欄: ✔ = Donna/Mike が disk で確認、— = 未検証（Louis の主張のみ）

### Blocker（投稿物の整合）

| # | 箇所 | 内容 | 検証 | 処置案 |
|---|---|---|---|---|
| 1 | L725–727 | 「Supporting information … R code」節が残存。Data availability（[repository URL]）と二重 | ✔ | 節を削除、code は repository に一本化 |
| 2 | tex コメント 147 行 | 内部経緯・旧番号・削除済み Supplement C への言及。投稿時 .tex をアップロードする前提 | — | 投稿用コピーでコメント全削除（作業版は保持） |
| 3 | `submission/cover_letter.md`, `title_page.md` | nABCD・旧タイトル・IST・"recommends" など v6 前の内容 | — | v6 に合わせ書き直し |

### Major（判断が要る）

| # | 箇所 | 内容 | 検証 | 論点 |
|---|---|---|---|---|
| 4 | L257, L550, L667 | Spearman 1.000、partner-source 入替、SD 比 1.11・Spearman 0.90/0.95 が紙面の表に無い | 一部 | 表に列を足すか、"not shown" か、削るか |
| 5 | L601 | 「Section 5 quantifies this across all region pairs」→ 実際は 15 partners（r = −0.30, n = 15） | ✔ | 文言を 15 partners に。r に CI を添えるか |
| 7 | §4.2, L227 | null floor の 95th percentile ラベル = 片側 5% 検定 × 30 比較。「not driven by a significance test」と衝突 | — | quantify-not-decide 原則の核心。名乗り方の判断 |
| 8 | Abstract, L72, L257 | Komiyama を abstract で批判、L257 で免責。RV1 = 平均ベースは原典（F(c) の一点）と異なる | — | 帰属の書き方、abstract の範囲 |
| 9 | Abstract, Table 1 | required n に Monte Carlo 不確実性なし（690 vs 716 等） | — | MC CI を計算するか、"comparable" 表現か |
| 10 | L224, §4.4 | L_UB,age ≈ 10⁻²/yr は FTT の年齢帯から見て大きすぎる可能性 | — | FTT から粗い傾きを計算して確認（Mike/Rachel） |
| 11 | Figure 2 (`fig_required_n_auc.pdf`) | 図中に "RV: mean (Ch.4)", "KS's home turf" | ✔ | 図を再生成（RV1–RV3、セル名） |
| 12 | L697 | 「operationalizing … ICH E17」は限定事項と比べ過大 | — | narrow |
| 13 | Table 1, L265, L654 | chance 範囲が 0.43–0.51 と 0.48–0.51 で不一致。0.44 は系統的に chance 未満 | — | 統一＋機構の一文 |

### Minor（#14–#27）

条件の明記（L185 の ∫√(F(1−F)) < ∞、Prop. 1 の有限一次モーメント）、"should" の残骸（L200）、境界例の小数 5 桁（L643）、"misses from below" の曖昧さ（L425）、MCSE（L429）、"reliable" の範囲（L486）、表に無い required n（L237, L314）、記法 L_k・W_{1,L}（L692, L210）、label 名・図ファイル名の旧番号、bib（komiyama2024 の year/pages、未引用 19 件）、N = 40,830 of 41,021（L503）、F₁ = F₂ a.e.（L391）、略語表・\copyyear。

Rachel 追加: L185 の del Barrio 極限は 1 標本で条件付き。Appendix L745 の「consistent estimator」の帰属は 1 標本論文に依存（#14 と統合）。

## 4. 次の手順（提案）

1. Tak: Blocker #1–#3 の処置案の可否
2. 全員: Major #4, #7, #8, #9, #10, #12, #13 を 1 件ずつ議論 → Option 提示 → Tak 選択（09-26 の判断ラウンド形式）
3. Mike: #9（required n の MC CI）、#10（FTT 年齢帯の傾き）の計算を先行
4. Katrina: #11 図の再生成
5. 全適用後に再度 submission-check → Jessica 承認
