# FIX_REVIEW_LOUIS_20261114 — `/review-fix` of the 2026-11-14 revision (D-20261114-1)

**Reviewer**: Louis（read-only；報告は返答で受け、Donna 役がここに保存）
**Before**: `review_response/known_bad/per_em_W1_wiley_pre_D-20261114-1.tex`（commit `8308f84`）
**Reviewed**: `review_response/known_bad/per_em_W1_wiley_20261114_before_louis.tex`（三本のレビューを適用した直後の原稿 = 下の指摘の known_bad）
**Diff**: `review_response/FIX_DIFF_20261114.diff`
**Verdict**: Critical 1 / Major 9 / Minor 8。Harvey は Critical・Major 全件と Minor 2–4・6・8 を採用、Minor 1 は writer の assert で対応、Minor 5 は修正、Minor 7 は見送り。

Louis の検算 source: `results/gusto_r8_w1_per_pair.csv`、`results/derived/gusto_reference_reading.csv`、`results/gusto_operability.csv`、`results/derived/gusto_dist_sd.csv`、`results/derived/set4_true_distances.csv`、`results/study2_interval_variants.csv`、`results/derived/selection_cell_auc_range.csv`、`results/required_n_selection.csv`、`data/gusto.csv`（30 日死亡の集計は Louis の Rscript、exploratory、registry 未登録）、`scripts/cascade_check.py`（residue 0、qualifier drop 7、strengthened 2）。

## Findings

| # | 場所 | severity | 指摘 | 対応 |
|---|---|---|---|---|
| C1 | App. A.2 | **Critical** | "a range that no CATE that only reduces risk can have" — 支えは Lee の年齢群平均 20.5% だけ。必要なのは台の上の baseline risk の sup。`data/gusto.csv` では SBP = 0 の 6 例は 6/6 死亡、SBP 1–79 は 35.9%（n = 493）で、SBP 上の 0.56 の幅を自前のデータが否定していない | 全称を外し、「risk を下げるだけの CATE の幅は台の上の最大 baseline risk 以下、ゆえに到達する CATE は 0.91（age）・0.56（SBP）以上の baseline risk を要する」に。guard `L4-C1` |
| M1 | DECISIONS / CLAIMS | Major | 本文 marker が D-20261114-1 を引くのに entry が無い；CLAIMS が未同期（C-36、C-37、新しい主張に行なし） | DECISIONS に D-20261114-1；CLAIMS 同期 |
| M2 | §3.2.1 vs §3.2.2 | Major | 不報告一覧に "a log-scale SMD" が残ったまま同じ小節でその結果を報告；C-28 は retracted のまま；protocol に再開の記録なし | 一覧から削除、AUC を `\numval{aucSMDlogShapeN2000}` で添える、`PROTOCOL_study1_identification.md` §8 に追記、C-28 を narrowed で再登録。guard `L4-M2` |
| M3 | §2.4・§4.4 | Major (P4) | "do not bound the sum" は偽 — 加法 CATE なら和は Σ L_k W₁^(k) で bound される（§5 と矛盾）。言えるのは「Δ_clin では bound されない」 | "bound the sum only by the sum of the margins, not by Δ_clin"。guard `L4-M3`、`REF3-M4` の qualifier を絞る |
| M4 | §4.4 | Major (Aim) | "R5, for example, lies below the line on both" — 両 EM で線の下にいるのは R5 だけ（"for example" は偽）、併合候補の指名に読める。R5 の age 距離は unresolved | 名指しを外し、一般の文に。guard `L4-M4` |
| M5 | §4.2・§5 | Major | "No simulated cell lies between zero and 0.2 SD" は偽（Set 4 の identification cell は 0.125–0.19 SD）；"several of the resolved age distances" は過小（resolved 23 本中 17 本、SBP を含む） | "No cell of the estimation study or its extension …"、数は `R/make_derived_numbers.R` §15 → `gusto_resolved_below_02.csv` → `\numval{nResolvedBelow02}` / `\numval{nResolved}`；§5 は "most"。guard `L4-M5` |
| M6 | §2.2 冒頭 | Major (P2) | 三つ目の採用理由を「どの有効な bound も満たす性質」に書き換えていた（D-20261012-3 で登録した文言を記録なしで変更、"with that slope" は不正確） | 登録済みの文言に戻し、bounded-scale の限定句だけを足す |
| M7 | §5 ¶1 | Major | "monotonicity lowers" は無条件（CDF が交差しなければ等号） | "can lower" |
| M8 | Abstract | Major (P5) | 0.2 SD について良い cell（n ≥ 1,000）だけを出していた。S2・n = 100 は 0.904 | "at 0.2 SD it was 0.904 with 100 per region and 0.947–0.951 with 1,000 or more"（key `covS2n100`） |
| M9 | §5 | Major | "all but negligible positive agreement" — 未定義語を別の未定義語に替えただけ | 区間が排除する値（上限）を書く。guard `L4-M9` |
| m1 | §4.4 | Minor | partner 名は手打ち、生成は件数だけ | `make_derived_numbers.R` §14 に `stopifnot`（data が変われば writer が止まる） |
| m2 | §3.1.2 | Minor | "they lie above the true value" は全称（S7・n = 200 は miss の 20% が下側） | "mostly" |
| m3 | §3.1.2 | Minor | 片側被覆の above / near / below の基準が無い | "(judged, as above, at two Monte Carlo standard errors)" |
| m4 | App. A.2 | Minor | "(20.5%³³)" が指数に読める | cite を文末へ |
| m5 | l.53 | Minor | `\cvol` 1–15 vs 16 pp | 1–16 |
| m6 | registry | Minor | note の崩れ（"lies contains"、"2 dp"） | 修正（key 名は変えない） |
| m7 | `R/figures_required_n.R` | Minor | `FAMILY_LABELS` に "world" が残る（論文の図には出ない） | 見送り |
| m8 | guards | Minor | `REF3-M4` の qualifier が広すぎ、`REF3-M5` は literal すぎ | `REF3-M4` を絞る、`REF3-M5` を "operating point" に |

## 検算済み・一致（Louis、値つき）

- §4.4 の区間の位置 30 行: age above R2 [1.565, 2.758]・R3 [1.963, 3.282]・R16 [1.162, 2.470]、below R5 [0.355, 0.922]・R7 [0.303, 0.945]、contains 10；SBP above R9 [5.712, 8.007]・R11 [5.248, 7.708]・R12 [5.385, 7.461]、below R1–R6・R13（upper 最大 R1 4.929）、contains 5
- log-scale SMD: Set 2 shape で reached（n 225、max AUC 0.9998）、combined で blind（0.495–0.515）；original-scale は combined で reached（n 529）、shape で blind
- SMD blind 7 cell はすべて original-scale の mean 一致、AUC 0.488–0.511
- KS の必要 n 最大は Set 4 asymmetric severity 1,252 [1,226, 1,278]（旧 "weakest" は AUC では誤り）
- 2 MCSE 判定 5 cell（S4-100、S5-100、S6-100、S7-100、S7-200）、範囲 0.917–0.951
- miss 側: S7-200 1.12%、S2 は 0、S6 は 2.04 / 2.65 / 2.56%
- 片側上限の列挙（S4-200 = 0.976 を追加したもの）は 2 MCSE で引き直して一致、範囲 0.9710–0.9999
- §2.2 の bounded-scale の文、§5 の "1-Lipschitz"、W_d ≥ Σ L_k W₁^(k)、結語の "where the outcome scale does not bind" は数学として正しい
- 旧文言の cascade: prose の残存 0（コメント行のみ）；行途中の `%` による本文の欠落 0

## 適用後のゲート（2026-11-14 12:20 実測）

build 16 pp・error 0・undefined 0／`claim_guards --strict --mutation` 79 本 0 FAIL（L4-* 6 本、REF3-* 6 本を seed）／`numbers_registry check` PASS／`numbers_audit` 115/115／`verify_study1_app_numbers.R`・`verify_study2_figures.R` ALL PASS／abstract 250 語／本文 6,116 語。
