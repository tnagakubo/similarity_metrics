# Statistics in Medicine Submission Checklist

**Manuscript**: Quantifying Effect Modifier Similarity for Regional Pooling in Multi-Regional Clinical Trials（per-effect-modifier W₁。旧版の nABCD は撤回済み）

**Target Journal**: Statistics in Medicine (Wiley)　**Submission URL**: https://mc.manuscriptcentral.com/sim

**Rewritten**: 2026-11-14（D-20261114-1 の改訂後。2026-02 の版は nABCD 時代のまま — タイトル、`nABCD_wiley.tex`、図 5 本、表 7 — で、全部古かったので書き直した）

**凡例**: ✅ = 2026-11-14 にディスクで確認できたもの。🟡 = 一部、または placeholder が残る。🔴 = 未着手。❓ = 確認していない。**投稿可の宣言ではない**（Jessica の承認は未取得、下の「未了の gate」）。

---

## Required Files

投稿物の正本は `paper/` にある。`per_em_W1_wiley.tex` は作業原稿（編集履歴と Tak の拒否権 marker が `%` コメントで入っている）、`submission/per_em_W1_wiley_submission.tex` がコメントを除いた投稿用 source（`submission/make_submission_source.py` が single writer；組版 text は作業原稿と一致 — D-20261114-1 項目 13）。

| File | Format | Status | Path / Notes |
|------|--------|--------|-------|
| Main document | PDF | ✅ 存在・15 pp（`pdfinfo`）、2026-11-14 14:50 | `paper/per_em_W1_wiley.pdf`。**未 commit**（HEAD = `8308f84` の PDF とは別物） |
| Source（LaTeX） | .tex | ✅ 存在（413 行） | `paper/submission/per_em_W1_wiley_submission.tex`。🟡 `\input{generated/…}`・`\input{numbers_macros}`・`\includegraphics{fig…}` はすべて `paper/` 基準の相対パスで、`submission/` 単体では解決しない（`submission/` に `generated/` や図は無い）。アップロード時は下の関連ファイルと同じ階層に置く。**この source 単体のコンパイルは確認していない** ❓ |
| 参照 | .bib / .bbl | ✅ 存在 | `paper/per_em_W1_wiley.bib`（53 entries）、`paper/per_em_W1_wiley.bbl`（2026-11-14 12:00） |
| 数値マクロ | .tex | ✅ 存在 | `paper/numbers_macros.tex`（`numbers_registry.csv` から生成。`\numval{}` はこれが無いとコンパイルできない） |
| 生成表 | .tex | ✅ 4 本存在 | `paper/generated/tab_estimation.tex`・`tab_study2_ext.tex`・`tab_study2_required_n_mc.tex`・`tab_gusto_nabcd.tex`（原稿が `\input` する 4 本と一致。表 5 のうち残り 1 本は手書きの tabular） |
| Class / style / bst | .cls .sty .bst | ✅ 存在 | `paper/WileyNJDv5.cls`・`NJDnatbib.sty`・`wileyNJD-AMA.bst`（`paper/` 直下の `.cls/.sty` は build が読む現役ファイル、動かさない） |
| Figure 1 | PDF | ✅ 存在 | `figures/fig1_w1_definition.pdf` |
| Figure 2 | PDF | ✅ 存在 | `figures/fig2_simulation_results.pdf` |
| Figure 3 | PDF | ✅ 存在 | `figures/fig_required_n_auc.pdf` |
| Figure 4 | PDF | ✅ 存在 | `figures/fig3_gusto_r8_forest.pdf`（ファイル名の 3 と本文の Figure 4 は一致しない — 二時代の命名、renaming しない） |
| Cover letter | .md → PDF | 🟡 草稿を書き直し済み（2026-11-14）、`[Date]` などの placeholder が残る | `paper/submission/cover_letter.md`。PDF 化は未 |
| Title page | .md | 🟡 書き直し済み、著者欄は placeholder | `paper/submission/title_page.md`（語数は 6,079 に更新） |
| Supplementary material | — | ✅ **付けない**（Tak 2026-09-27） | `memory/feedback_no_process_supplements.md`。R code と登録 protocol・出力は repository（URL は placeholder） |

## Manuscript Requirements（2026-11-14 の実測）

| Requirement | Limit | Current | Status | 出所 |
|-------------|-------|---------|--------|------|
| Abstract | ≤ 250 words | 250 | ✅ 上限ちょうど | D-20261114-1 の実測（`structure_audit`）；この checklist 作成時に私は数え直していない |
| Short title | ≤ 70 chars | 59（"Quantifying Effect Modifier Similarity for Regional Pooling"） | ✅ | `title_page.md`、`\titlemark` |
| Keywords | ≤ 6 | 6 | ✅ | tex l.47 |
| Main text | 目安 4,000–6,000（SiM は厳密な上限を定めない） | 6,079 語（参考文献・表・図の説明を除く） | 🟡 目安の上端を超える | D-20261114-1（"SiM 上限の 1.0×" と記録）、`SiM_author_guidelines.md` l.67–76 |
| Figures | 別ファイル | 4 | ✅ | tex の `\includegraphics` 4 本 |
| Tables | 本文中 | 5 | ✅ | |
| Pages | — | 16 | ✅ | `pdfinfo` |
| References | numbered（AMA bst） | .bib 53 entries、本文引用 28 key（`cite_audit.py`、2026-11-14 14:50、D-20261114-2 で 34 → 28） | ✅ missing 0 | `CITATION_AUDIT_20261114.md` |
| Supplement | — | なし | ✅ | 方針 |

## 残っている placeholder（原稿・submission 文書）

著者が埋める項目。ディスクの現物を確認した。

| 項目 | 場所 | 現状 |
|---|---|---|
| 著者名 | tex `\author` ×3、`title_page.md` | "Author One / Two / Three" |
| 所属 | tex `\address` ×2、`title_page.md` | "Department Name, Institution Name" |
| Corresponding author | tex `\corres`、`title_page.md` | placeholder |
| ORCID | — | 原稿にも title page にも欄が無い（SiM / ScholarOne の要求は未確認 ❓） |
| Author contributions | tex l.758–760 | "[Author 1] …" |
| 謝辞 | tex l.762–764 | "[colleagues]" |
| Funding | tex "Financial disclosure: None reported." と `title_page.md` の "[This work was supported by… / No external funding…]" | 食い違い — 著者が決める |
| Repository URL | tex Data availability（l.777）、`title_page.md` | `[repository URL]` |
| AI 利用の開示 | — | 原稿に該当する節が無い（journal の要求の有無は未確認 ❓）。開示するかは著者の判断（D-20261114-1 O-2） |
| 日付・署名 | `cover_letter.md` | `[Date]` ほか |

## 未了の gate（Phase 8 → 7 → 投稿）

- 🔴 `/reproduce`（clean checkout からの再実行）未実施 — `results/REPRODUCTION_*.md` が無い（LAB_STATUS）
- 🔴 `/submission-check`（reporting checklist R1–R8 + journal 要件）未実施
- 🔴 **Jessica の投稿承認は未取得**（Phase 7 → 投稿の gate）
- 🟡 Paper Request: 原典を読めていない引用は `efron1993` と Kent 2020 の本文だけ（`riley2010`・`villani2009`・`vallender1974`・`andrews2000` は D-20261114-2 で外した／読了済みの出典に替えた）と Matsushima の Data S1 / Table S1（`CITATION_AUDIT_20261114.md`、D-20261114-1 O-3）。`/cite-check` は 34 key を現行文で監査済みだが NV が残るので全行 yes ではない
- 🟡 Tak の拒否権（marker、段落単位、投稿前まで）、O-1（0–0.2 SD の coverage cell を走らせるか）— D-20261114-1
- 🟡 **commit 未**（2026-11-14 の改訂一式、HEAD = `8308f84`）。commit は Tak の指示を待つ
- ❓ 投稿用 source 単体のコンパイル（paper/ の関連ファイルを同階層に置いて）は未実施
- ❓ Figure の解像度・色（paper の図は greyscale、`memory/feedback_figure_paper_standard.md`）の最終確認は未

## Format Specifications

| Element | Specification | Status |
|---------|---------------|--------|
| Class | `WileyNJDv5`（`AMA, Times1COL`） | ✅ tex l.1 |
| Reference style | AMA（`wileyNJD-AMA.bst`、numbered） | ✅ |
| Figure format | PDF | ✅ 4 本とも PDF が存在 |
| Line numbers | 任意 | 未 |

## Submission Process

1. https://mc.manuscriptcentral.com/sim → Original Article
2. Main Document: `paper/per_em_W1_wiley.pdf`
3. Source + `.bib`/`.bbl` + `numbers_macros.tex` + `generated/tab_*.tex` + cls/sty/bst: "Supplemental Material not for review"
4. Figures: 上の 4 PDF
5. Cover letter、title page
6. メタデータ（title、abstract、keywords、著者）
7. Suggest reviewers（任意）

## Reviewer Suggestions（任意）

| Name | Affiliation | Expertise |
|------|-------------|-----------|
| [Name 1] | [University] | MRCT methodology |
| [Name 2] | [University] | Optimal transport / Wasserstein inference |
| [Name 3] | [Regulatory] | ICH E17 |

## Post-Submission

- [ ] Confirmation email / Manuscript ID
- [ ] Track status via ScholarOne

---

*Created 2026-02-05（nABCD 時代）。2026-11-14: 現行原稿（per-EM W₁、15 pp、6,079 語 — 14:50 更新）で書き直し — Donna。✅ はこの日にディスクで確認したものだけ。*
