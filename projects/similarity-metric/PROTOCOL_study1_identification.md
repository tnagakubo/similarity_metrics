---
# Machine-readable half (protocol_compile.py). POST-HOC registration: the study was run in July 2026, before the lab's
# protocol gate existed; this file fixes what was decided when, and what the results license. No new confirmatory run.
study: study1_identification
claim_id: C-07                    # also C-08 (efficiency vs the KS statistic); CLAIMS.md
post_hoc: true
seed: 20260711                    # base seed of the production run (R/selection_simulation.R parse_args); per-cell seeds in results/selection_sim_config*.csv
n_sim: 10000                      # selection task, base grid (n = 25-100); 3,000 on the extended grid; clustering 5,000 / 2,000
target_mcse: {auc: 0.005}
estimand: "Selection: AUC for discriminating true matches from discordant candidates by anchor distance (ties count 1/2), P(the k retained regions include a discordant one), share of retained regions that are discordant; clustering: adjusted Rand index of the average-linkage partition against the construction labels, exact recovery; required n: smallest n at which AUC >= 0.9 (ARI >= 0.8), interpolated on log n"
truth: {method: construction_label, note: "ground truth is the construction label (built from the anchor's population or not), independent of every compared measure; population W1/KS of the Set 4 roster in results/derived/set4_true_distances.csv"}
dgm:
  - {name: Set1_Gaussian,  description: "Gaussian world: discordance in location and scale; anchor N(50, 10^2)"}
  - {name: Set2_LogNormal, description: "Log-normal world: discordance in location, and in dispersion combined with shape"}
  - {name: Set3_Mixture,   description: "Mixture world: every region has mean 50 and SD 10; discordance only in shape (skewed / symmetric / combined)"}
  - {name: Set4_Extremes,  description: "Extremes world: 5% subgroups 40 units from the centre; discordant regions move both (70, 100), raise prevalence (12%), move the upper only (100), or shift the bulk (2, 3) as a control"}
n_grid: [25, 50, 75, 100, 150, 200, 300, 400, 600, 1000, 1500, 2000]
methods:
  - {name: W1,  owner: ours,     fn: w1_dist,  description: "Wasserstein-1 distance (CDF-area form)"}
  - {name: KS,  owner: existing, fn: ks_dist,  description: "Kolmogorov-Smirnov statistic"}
  - {name: SMD, owner: existing, fn: smd_dist, description: "standardized mean difference (pooled SD); SMD on the log scale added for Set 2"}
  - {name: RV1, owner: existing, fn: rv_dists, description: "representative-value distance of Komiyama et al. as written: regional mean, standardized across the roster, Euclidean"}
  - {name: RV2, owner: ours,     fn: rv_dists, description: "our extension: (mean, SD) coordinates"}
  - {name: RV3, owner: ours,     fn: rv_dists, description: "our extension: (mean, SD, skewness) coordinates"}
measures: [auc, false_pooling_at_k, precision_at_k, ari, exact_recovery, required_n]
outputs: {summary_csv: results/selection_sim_summary.csv, per_rep_rds: "none (per-replicate values were not retained; summaries with mc_se only)", log: results/selection_sim.log}
parallel: {workers: 1, rng: per_cell_seed}
prior_look: "yes — post-hoc registration; the extension grid, the three-behaviour taxonomy and the required-n thresholds were fixed after the production results had been seen (section 0)"
---

# PROTOCOL — Study 1 (identification): can a distributional measure recover which regions share the anchor's effect-modifier distribution?

**Registered**: 2026-10-11（**post hoc**; D-20261011-7。runs 自体は 2026-07-11〜07-20）。**Project**: `projects/similarity-metric/` **Claim ID**: `CLAIMS.md` C-07（識別の失敗 vs 回復）、C-08（W₁ と KS の required n）
**Framework**: ADEMP（Morris, White & Crowther 2019 *Statistics in Medicine* 38:2074–2102, DOI: [10.1002/sim.8086](https://doi.org/10.1002/sim.8086)）

> この protocol は RESEARCH_FRAMEWORK の Phase 2 gate より前に走った study の**事後登録**である。目的は二つ: (i) 何がいつ決まったかを時系列で固定し、結果を見た後に決めた事項を開示する（§0）；(ii) 結果が license する主張と license しない主張を固定する（§2）。新しい confirmatory run は含まない。

---

## 0. Prior look の開示（honesty clause）

| 日付 | 事項 | 結果を見る前 / 後 | 証拠 |
|---|---|---|---|
| 2026-07-11 | 計画（4 world、anchor-centric selection と clustering の 2 task、6 measure、ground truth = construction label、θ を置かない） | 前 | `archive/SELECTION_SIMULATION_PLAN.md`（初回 commit 07-11）、`R/validate_plan.R`（roster が plan の Tables 2a–2d と一致することを検証） |
| 2026-07-11 | selection 本番 run: n = 25, 50, 75, 100、10,000 reps/cell、base seed 20260711（cell 毎に `2026{n index}7{11}` 系の seed） | — | `results/selection_sim_config.csv`、`results/selection_sim_summary.csv` |
| 2026-07-12 | clustering 本番 run: 同 grid、5,000 reps/cell、seed 系 `…712`；Part 1/Part 2 の二 task 構成を Tak が確定 | — | `results/clustering_sim_config.csv`、`clustering_sim_summary.csv` |
| 2026-07-20 | **grid 拡張** n = 150–2,000（selection 3,000 reps、clustering 2,000 reps、seed 系 66001000…） | **後**（n ≤ 100 の曲線を見て「どこまで上げても追いつかないか」を確かめるために追加） | `results/selection_sim_config_ext.csv`、`clustering_sim_config_ext.csv`、`archive/SIMULATION_FINDINGS.md`（07-20） |
| 2026-07-20 | **閾値**: ARI 0.7 / 0.8 / 0.9、AUC 0.8 / 0.9 / 0.95 の三段（Tak）、**三行動の分類**（blind / partial / recovering: PLATEAU_SPAN 0.02、CHANCE_MARGIN 0.05） | **後**（曲線を見てから定義） | `R/required_n.R` header L27–L29、L37–L47 |
| 2026-09-27 | 論文の headline 閾値を AUC 0.9 / ARI 0.8（三段の中央）に固定、Study 番号を入れ替え（identification = Study 1） | 後 | D-20260927-3 |
| 2026-10-11 | required n に delta 法の 95% Monte Carlo 区間を付与（`required_n_lower/upper`）、比較を「区間が分かれる cell」に限定 | 後（C-08 の MC 不確かさ欠落を `/claims init` が指摘） | D-20261011-7、`R/required_n.R` |

**結果を見た後に決めた事項とその扱い**: (a) 拡張 grid — 三行動の分類は n = 2,000 まで見なければ成立しないため追加した。識別失敗（blind）の判定は母集団距離が構成ラベルと無関係であることに基づく（Set 3 の mean/SD 一致は構成で保証）ので、grid の長さに依存しない。(b) 閾値 — 三段をすべて CSV に出し、本文は中央の段を報告する。W₁ と KS の順序は shape-symmetric mixture を除いて三段で不変（`required_n_selection.csv`、2026-10-11 に確認）；shape-symmetric では 0.8 で点推定が逆転し（W₁ 204 [189, 220] vs KS 184 [165, 206]、区間は重なる）、0.9 で重なり（690 vs 716）、0.95 で W₁ が分離して少ない（1,199 [1,152, 1,246] vs 1,320 [1,263, 1,379]）— 曲線が目標付近で交差するためで、本文はこの cell の優劣を主張しない。(c) 分類の定数（0.02、0.05）— `R/required_n.R` に固定；"blind" は plateau が chance ± 0.05 以内、"partial" はそれ以上で閾値未満。(d) **primary outcome は閾値非依存**: 「W₁ と KS は全 world で recovering、SMD/RV1/RV2 は Set 3 で blind」は AUC 曲線の形（chance への plateau か、単調増加か）であり、cut に依らない。

## 1. Claim（Harvey）

C-07: 一つ〜三つの regional moment から作る距離（SMD、RV1–RV3）は、ある構成では n = 2,000 まで chance に留まる（識別の失敗、power の問題ではない）。W₁ と KS は 4 world すべてで真の構造を回復する。
C-08: summary measure を困らせるために作った構成（Set 3・4）で、W₁ は 7 cell 中 5 cell で KS より少ない n で AUC 0.9 に達する（95% Monte Carlo 区間が分かれる）；shape-symmetric mixture では区別がつかず、bulk-shift control では KS が少ない。

## 2. この study が licenses する主張 / しない主張（Mike）

**Licenses**
- 構成ラベルを ground truth とした、6 measure の識別力の比較（AUC、false pooling at k、ARI）と、閾値到達の required n（log n 補間、MC 区間付き）
- "blind" の判定: Set 3 では mean と SD が構成で一致するため、mean / (mean, SD) 座標の母集団距離は 0（RV1、RV2、SMD）。Set 4 の symmetric severity / prevalence では SMD の母集団距離が 0

**Does not license**
- 実データの地域差が Set 3・4 のような形状差を持つという主張（§4 の GUSTO-I は illustration）
- 「W₁ が臨床的に優れる」— AUC の差は構成ラベルの回復に関する差であり、治療効果差の予測精度ではない（θ を置いていない）
- pooling の判定規則や閾値の推奨（`memory/feedback_quantify_not_decide.md`）
- shape-symmetric mixture での W₁ と KS の優劣（区間が重なる）

## 3. ADEMP

### A — Aims
anchor の effect-modifier 分布と同じ母集団から作られた region を、有限標本の距離だけから、既存の summary 系指標より正しく見つけられるか（selection）。anchor を置かない clustering で同じ結論になるか（第二の scoring currency）。

### D — Data-generating mechanisms
4 world（front matter の `dgm`）。各 world は anchor A0 + 3 true match + 6 discordant（Set 4）等、構成は `R/selection_simulation.R` `build_set1..4`。Set 4 の母集団距離（W₁ 3.0/6.0/4.48/3.0/2.0/3.0、KS 0.047/0.050/0.067/0.050/0.072/0.107）は `results/derived/set4_true_distances.csv`（`R/make_derived_numbers.R` が `true_w1`/`true_ks` から計算）。clustering は 12 region を 3 群 × 4。

### E — Estimands
selection: AUC $= P(d(\text{match}) < d(\text{discordant})) + \tfrac12 P(=)$；$P(\text{retained } k \text{ include a discordant})$；retained のうち discordant の割合（chance: $1 - 1/\binom{9}{3} = 0.988$、$6/9$）。clustering: ARI（chance 0）、exact recovery。required n: AUC（ARI）曲線が閾値に初めて達する n、log n 上の線形補間、切り上げ。

### M — Methods
W₁、KS、SMD（Set 2 は log scale も）、RV1（Komiyama et al. as written）、RV2、RV3（our extensions）。選択は距離で順位付けし k = true match 数を保持（k は oracle）。clustering は average linkage、k_true 供給（silhouette 推定版は `R/clustering_nok_simulation.R`）。

### P — Performance measures（Monte Carlo SE 付き）
各 measure の cell 平均と $\mathrm{MCSE} = s/\sqrt{n_{\mathrm{reps}}}$（`mc_se` 列）。required n の MC 不確かさは delta 法: $\hat x^* = \log n^*$ の分散 $= (\partial x^*/\partial y_0)^2 s_0^2 + (\partial x^*/\partial y_1)^2 s_1^2$（bracketing cell の AUC の MCSE、独立 run）、95% 区間 $\exp(\hat x^* \pm z_{0.975}\sqrt{\mathrm{Var}})$、切り上げ。

## 4. Outcomes（定義）
- blind: 最後の 3 点の AUC（ARI）の span < 0.02 で、水準が chance + 0.05 以下
- partial: 同じ plateau 条件で水準が chance + 0.05 超かつ閾値未満
- recovering: 閾値に達する（required n を報告）；達しないが上昇中は "unmeasured"（">2000"）
- 本文の headline: AUC 0.9（selection）、ARI 0.8（clustering）。0.8 / 0.95 と 0.7 / 0.9 も CSV にある

## 5. Louis の攻撃と回答
1. 「grid 拡張と分類は結果を見てから」— 事実。§0 に開示。分類の根拠（母集団距離 0）は grid に依らず、primary outcome は閾値非依存。
2. 「閾値の選択で勝敗が変わる」— shape-symmetric mixture 以外では threshold 0.8 / 0.9 / 0.95 のどれでも W₁ と KS の順序は不変。shape-symmetric では閾値で順位が入れ替わる（§0(b)）ので、その cell の優劣は主張しない（§2 Does not license）。
3. 「required n の差は Monte Carlo ノイズでは」— 2026-10-11 に区間を付与（外側丸め）。shape-symmetric mixture（690 [661, 718] vs 716 [687, 747]）は区間が重なり、曲線が目標付近で交差するため「分離しない」と書く（同等とは書かない）。主張は 5 of 7 に狭めた（C-08 narrowed）。W₁ と KS は同じ replicate 上の paired 推定だが per-replicate 値は保存されていないので paired 区間は出せない — 非重なりは保守的、重なりは同等性の根拠にならない。
4. 「Set 3・4 は W₁ に有利に作ってある」— そのとおり。summary measure の構造的盲点を示すための world であり、Set 1・2 と control（bulk shift、KS が勝つ）を同時に報告する。
5. 「k は oracle」— 本文に明記；clustering の silhouette 版で oracle を外した結果も報告。

## 6. Outputs（Katrina）
`results/selection_sim_summary{,_ext}.csv`、`results/selection_sim_config{,_ext}.csv`、`results/clustering_sim_summary{,_ext}.csv`、`results/clustering_sim_config{,_ext}.csv`、`results/clustering_nok_silhouette.csv`、`results/required_n_{selection,clustering}{,_floor}.csv`（`R/required_n.R`）、`results/derived/*.csv`（`R/make_derived_numbers.R`）、`results/study1_miss_side.csv`。Scripts: `R/selection_simulation.R`、`R/clustering_simulation.R`、`R/clustering_nok_simulation.R`、`R/required_n.R`、`R/validate_plan.R`、`R/verify_study2_figures.R`（gate、`results/verify_study2.log`）。

## 7. Go / No-Go（Jessica）
事後登録のため Go/No-Go は無い。Let me be clear: この protocol が license するのは §2 の範囲だけだ。それを超える文言は CLAIMS.md で narrow する。

## 8. Deviations
- 2026-10-11（登録当日、Louis review B3）: §0(b)・§5.2 の「閾値を変えても順序は不変」は shape-symmetric mixture で偽だった（0.8 で逆転）。確認せずに書いた文を、CSV で確認した文に差し替えた。
- 再 run は同じ seed（config CSV）で行い、差分は `scripts/compare_results.py` で比較する。paired 比較を行うなら per-replicate の W₁・KS の AUC 差を保存する再 run が要る（未実施）。
- 2026-10-11（マージ時に記録；決定は 2026-09-27、Tak、D-20261011-8）: 本 protocol の M に挙げた 6 measure のうち **RV1–RV3 の結果は本文で報告しない**（Komiyama et al. 第 4 章は一例の紹介で、評価された手法ではない — 比較対象にしない）。**clustering task の結果も報告しない**（`PROTOCOL_silhouette_extension.md`、2026-09-27 事前登録: n = 2,000 で 4 world すべて ARI ≥ 0.80 かつ P(k̂ = k) ≥ 0.80 → Set 3 で ARI 0.646 / P 0.26 で不成立。群の数を推定できない手法は併合地域を特定する手法ではない）。本文の Study 1 は selection task × {W₁, KS, SMD}、挙動は blind / recovering の二分（partial は RV の挙動だった）。CSV（RV 行、`clustering_*.csv`）は削除せず canonical のまま残す；§2 の licenses は selection task の範囲で変わらない。
