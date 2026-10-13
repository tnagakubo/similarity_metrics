---
# Machine-readable half (protocol_compile.py). PRE-REGISTERED: written 2026-10-12 before any replicate of this study was run.
# The skeleton was NOT generated with protocol_compile.py (the output whitelist of this task allows four result files only);
# the hand-written script is checked against this front matter with `protocol_compile.py --verify R/w1_raw_simulation_ext.R`.
study: study2_extension
code: R/w1_raw_simulation_ext.R
claim_id: C-09                    # Study 2 estimation statement (coverage / bias); also C-17 (null cell), C-32
post_hoc: false
seed: 20261012                    # cell k uses set.seed(20261012 + 1000 k) under L'Ecuyer-CMRG; replicate i uses the i-th substream
n_sim: 2000                       # minimum over cells (amendment cells E5, E6, E3c); original 8 cells 10000 or 5000; per-cell n_reps in section 3 and in the CSV
target_mcse: {coverage: 0.005, bias: 0.05}   # 0.0035 for the original 8 cells (>= 5000 reps); 0.0049 at 2000 reps (amendment)
estimand: "theta = W1(F1, F2) = integral |F1(t) - F2(t)| dt (population, original units); for integer-rounded data theta = W1 of the rounded population distributions"
truth: {method: closed_form, note: "location shifts (normal, t3, integer-rounded normal with integer shift) W1 = |delta| = 5; null 0; equal-mean normals sqrt(2/pi)|s1 - s2|; the rounded-population value is re-computed in the script from the discretized CDFs and must equal 5 to 1e-10"}
dgm:
  - {name: E1a_unequal_100_300,  true_value: 5,         description: "N(50,10^2) vs N(55,10^2), n1 = 100, n2 = 300"}
  - {name: E1b_unequal_200_1000, true_value: 5,         description: "N(50,10^2) vs N(55,10^2), n1 = 200, n2 = 1000"}
  - {name: E2a_t3_null,          true_value: 0,         description: "50 + (10/sqrt(3)) t3 in both regions (SD 10), n = 100 each"}
  - {name: E2b_t3_shift,         true_value: 5,         description: "50 + (10/sqrt(3)) t3 vs 55 + (10/sqrt(3)) t3, n = 100 each"}
  - {name: E3a_grid_100,         true_value: 5,         description: "round(N(50,10^2)) vs round(N(55,10^2)) (whole units, as SBP in mmHg), n = 100 each"}
  - {name: E3b_grid_200,         true_value: 5,         description: "as E3a, n = 200 each"}
  - {name: E4a_S3_1000,          true_value: 5,         description: "N(50,10^2) vs N(55,10^2), n = 1000 each"}
  - {name: E4b_S5_1000,          true_value: 3.9894228, description: "N(50,10^2) vs N(50,15^2), n = 1000 each; theta = sqrt(2/pi) * 5"}
  # Amendment 2026-10-12 17:00 (Harvey; cold referee M5), registered before these three cells ran:
  - {name: E5_S2_1000,           true_value: 2,            description: "N(50,10^2) vs N(52,10^2) (0.2 SD), n = 1000 each"}
  - {name: E6_S2_2900_1200_r10,  true_value: 1.9999999919, description: "10 round(X/10): N(50,10^2) vs N(52,10^2) rounded to the nearest 10, n1 = 2900 (GUSTO anchor), n2 = 1200 (smallest partner); theta = W1 of the rounded laws"}
  - {name: E3c_grid_1000,        true_value: 5,            description: "round(N(50,10^2)) vs round(N(55,10^2)), n = 1000 each"}
n_grid: [100, 200, 300, 1000, 1200, 2900]
methods:
  - {name: W1_percentile, owner: ours, fn: W1_raw_bootstrap_cpp, description: "plug-in W1 (CDF-area form; equal n sorted-pair, unequal n merged-support sum) with the percentile bootstrap, B = 2000, conf = 0.95 (R/W1_raw_rcpp.cpp, unchanged from Study 2)"}
measures: [bias, rmse, coverage, ci_width]   # plus the one-sided 97.5% upper-limit coverage P(theta <= U), documented in section 3P
outputs: {summary_csv: results/w1_raw_ext_summary.csv, per_rep_rds: results/w1_raw_ext_simulation.rds, log: results/w1_raw_ext_sessionInfo.txt}
parallel: {workers: 6, rng: "L'Ecuyer-CMRG, per-cell seed 20261012 + 1000k, per-replicate substream (nextRNGSubStream) assigned inside the worker"}
prior_look: "no — designed 2026-10-12 after external review M8 asked for it, before any replicate was drawn; a cost-only timing pilot (no performance measure computed) fixed n_reps per cell (section 0)"
---

# PROTOCOL — Study 2 extension: estimation of $W_1$ under unequal n, heavy tails, integer grid and large n

**Registered**: 2026-10-12（**pre-registered**; no replicate drawn before this file was written）。**Project**: `projects/similarity-metric/` **Claim ID**: `CLAIMS.md` C-09（coverage / bias の estimation statement）、C-17（null 付近）、C-32
**Trigger**: `review_response/EXTERNAL_REVIEW_20261012.md` M8（Study 2 は $n \le 200$、等 n、正規基準で、応用 GUSTO-I の $n$ = 1,231–4,352、不均衡、整数格子の SBP と合っていない）
**Framework**: ADEMP（Morris, White & Crowther 2019 *Statistics in Medicine* 38:2074–2102, DOI: [10.1002/sim.8086](https://doi.org/10.1002/sim.8086)）

---

## 0. Prior look の開示（honesty clause）

| 日付 | 事項 | 結果を見る前 / 後 | 証拠 |
|---|---|---|---|
| 2026-05-17 | Study 2 本体（S1–S7 × n = 50/100/200、10,000 reps、B = 2,000）の結果は既知 | 本 extension の設計は Study 2 本体の結果を**見た後** | `results/w1_raw_summary.csv`、`results/study2_mcse.csv` |
| 2026-10-12 | external review M8 が 4 方向（不均衡 n、$t_3$、格子化、大きな n）を要求 | 設計の起点 | `review_response/EXTERNAL_REVIEW_20261012.md` l.59–61 |
| 2026-10-12 | **timing pilot**: `W1_raw_bootstrap_cpp` を単一 core で 20 回ずつ（n1/n2 = 100/300, 200/1000, 100/100, 200/200, 1000/1000）実行し **wall time だけ**を測った。推定値・区間・性能指標は計算も表示もしていない | 前（本 extension の性能指標について） | 本 protocol §3 の projected minutes |
| 2026-10-12 | cell 構成（8 cell）、真値、性能指標、per-cell n_reps、seed をこのファイルで固定 | 前 | 本ファイル |

**結果を見た後に決めた事項**: なし（Study 2 本体の結果を知った上での設計である点は上表の 1 行目で開示）。cell の選択は M8 の 4 方向をそのまま写したもので、Study 2 本体で coverage が低かった cell（S5–S7）に合わせて選んだものではない。E4b（S5 at n = 1,000）は Study 2 本体の最低 coverage cell の型を大きな n で見るための cell であり、その選択は Study 2 本体の結果を見た後である（開示）。

## 1. Claim（Harvey）

この extension は新しい主張を立てない。C-09 の estimation statement（「normal reference、equal n、n = 50–200」）が、応用の条件（不均衡 n、裾の重さ、整数格子、大きな n）の各方向に一つずつ動かしたときにどう変わるかを、同じ estimator・同じ bootstrap・同じ性能指標で報告する。

## 2. この study が licenses する主張 / しない主張（Mike）

**Licenses**
- 8 cell それぞれでの $\widehat W_1$ の bias、RMSE、95% percentile interval の coverage、one-sided 97.5% upper limit の coverage、mean width（すべて Monte Carlo SE 付き）
- 各 cell の coverage が 0.95 から 2 MCSE 以内か外か、bias の sampling SD に対する比
- Study 2 本体の対応 cell（S3 n = 100/200、S5 n = 200）との並置（同じ estimator・同じ B）

**Does not license**
- GUSTO-I の partner 毎の区間が nominal coverage を持つという主張（GUSTO-I の分布は $t_3$ でも正規でもない；ここで動かすのは一度に一方向だけ）
- 方向の組み合わせ（不均衡 × 格子 × 裾）での性能 — 組み合わせ cell は置いていない
- 理論的な bootstrap 一致性の主張（下記 §3M の注、特に格子化 cell）
- pooling の判定規則や閾値の推奨（`memory/feedback_quantify_not_decide.md`）
- θ を置いた効果追跡の主張（`memory/project_no_effect_tracking_sim.md`；本 study は距離の推定性能のみ）

## 3. ADEMP

### A — Aims
Study 2 の estimation 性能（bias、RMSE、coverage、width）が、M8 の 4 方向それぞれで Study 2 本体の対応 cell と比べてどう変わるかを定量化する。

### D — Data-generating mechanisms

| Cell (k) | 方向 | Region 1 | Region 2 | $n_1, n_2$ | $\theta$ | 真値の根拠 | n_reps | projected min |
|---|---|---|---|---|---|---|---|---|
| E2a (1) | heavy tails, null | $50 + (10/\sqrt3)\,T_3$ | 同じ | 100, 100 | 0 | 同一分布 | 10,000 | 1.3 |
| E2b (2) | heavy tails, shift | $50 + (10/\sqrt3)\,T_3$ | $55 + (10/\sqrt3)\,T_3$ | 100, 100 | 5 | location shift: $W_1 = \lvert\delta\rvert$ | 10,000 | 1.3 |
| E3a (3) | integer grid | $\mathrm{round}(N(50,10^2))$ | $\mathrm{round}(N(55,10^2))$ | 100, 100 | 5 | 下記 | 10,000 | 1.3 |
| E3b (4) | integer grid | 同上 | 同上 | 200, 200 | 5 | 下記 | 10,000 | 2.7 |
| E1a (5) | unequal n | $N(50,10^2)$ | $N(55,10^2)$ | 100, 300 | 5 | location shift | 10,000 | 3.9 |
| E1b (6) | unequal n | $N(50,10^2)$ | $N(55,10^2)$ | 200, 1,000 | 5 | location shift | 5,000 | 7.1 (14 at 10,000) |
| E4a (7) | large n | $N(50,10^2)$ | $N(55,10^2)$ | 1,000, 1,000 | 5 | location shift | 5,000 | 12.9 (26 at 10,000) |
| E4b (8) | large n | $N(50,10^2)$ | $N(50,15^2)$ | 1,000, 1,000 | $\sqrt{2/\pi}\cdot5 = 3.98942$ | equal-mean normals: $\sqrt{2/\pi}\,\lvert\sigma_1-\sigma_2\rvert$ | 5,000 | 12.9 (26 at 10,000) |

- $T_3$ の分散は 3 なので $10/\sqrt3 \cdot T_3$ の SD は 10（Study 2 本体の σ = 10 と揃える）。
- **n_reps の規則**（task 指示）: 10,000 reps で 4 分以内に終わる cell は 10,000、それ以外は 5,000。**projected min** は timing pilot の単一 core 秒/rep × n_reps / 6 workers に、Study 2 本体の実測（`results/w1_raw_simulation_partial.rds` `elapsed_s`: n = 100 で 71–77 s、n = 200 で 161–170 s、10,000 reps、6 workers）と pilot の予測（156 s、406 s）の比 0.44 を掛けた値。E1a は 3.9 分で規則の境界にあるが、規則どおり 10,000 とする。予算見積もり合計は約 43 分。
- 実行順は k の順（安い cell から、n = 1,000 は最後）。

**格子化 cell の真値**: $X \sim N(50, 10^2)$、$Y = X + 5$ と書けば $\mathrm{round}(Y) = \mathrm{round}(X) + 5$（5 は整数；丸めの境界 $x + 1/2 \in \mathbb Z$ は確率 0）。よって丸めた母集団分布は整数 5 の平行移動で $\theta = 5$（Mike の導出）。script は離散化 CDF $F_\mu(k) = \Phi((k + 1/2 - \mu)/10)$ から $\sum_{k} \lvert F_{50}(k) - F_{55}(k)\rvert$（格子間隔 1、$k = -200, \ldots, 300$）を計算し、5 と $10^{-10}$ 以内で一致しなければ停止する。

### E — Estimands
$\theta = W_1(F_1, F_2) = \int_{-\infty}^{\infty} \lvert F_1(t) - F_2(t)\rvert\,dt$（原単位）。格子化 cell では $F_1, F_2$ は丸めた母集団分布の CDF。

### M — Methods
Study 2 本体と同じ `W1_raw_bootstrap_cpp`（`R/W1_raw_rcpp.cpp`、無変更）: 点推定は等 n で sorted-pair 平均、不等 n で merged support 上の $\sum \lvert\hat F_1 - \hat F_2\rvert \Delta t$；percentile bootstrap（各 region 内で独立に復元抽出、B = 2,000、type 7 quantile、下限は 0 で切る）。
- **新しい code path**: Study 2 本体の 21 cell はすべて等 n だったので、不等 n の分岐（E1）は Study 2 で初めて使う。script は本 run の前に、不等 n と同順位（ties）の多い整数データで点推定を独立な R 実装（`ecdf` による CDF 面積の和）と照合し、差が $10^{-10}$ を超えたら停止する（gate）。
- **理論の注**: one-sample の $\sqrt n\,W_1(\hat F_n, F)$ の CLT の必要十分条件は $\Lambda_{2,1}(X) = \int_0^\infty \sqrt{P(\lvert X\rvert > t)}\,dt < \infty$（$\Leftrightarrow \int \sqrt{F(1-F)} < \infty$）（del Barrio, Giné & Matrán 1999 *Ann. Probab.* 27:1009–1071, DOI: [10.1214/aop/1022677394](https://doi.org/10.1214/aop/1022677394)；`knowledge/summaries/Barrio_1999.md` l.37–51、原典頁は /cite-check 未了）。$T_3$ では $P(\lvert X\rvert > t) \sim c\,t^{-3}$ なので被積分関数は $t^{-3/2}$ で可積分、条件を満たす（Mike の導出）。two-sample の percentile bootstrap の一致性が $t_3$ や格子化データでどうなるかについては主張しない（`[推測]`：格子化 cell では $F_1 = F_2$ となる区間は無いが、経験 CDF の ties が多い；一致性は本 study の licenses の外）。

### P — Performance measures（Monte Carlo SE 付き；式は `R/study2_mcse.R` と同じ、Morris et al. 2019 Table 6；$n$ = 有効 replicate 数）
- bias $= \bar{\hat\theta} - \theta$、$\mathrm{MCSE} = s_{\hat\theta}/\sqrt n$
- RMSE $= \sqrt{\overline{(\hat\theta - \theta)^2}}$、$\mathrm{MCSE} = \mathrm{sd}((\hat\theta-\theta)^2)/(2\sqrt n\,\mathrm{RMSE})$（delta 法）
- coverage（95% percentile）$p = \overline{1\{L \le \theta \le U\}}$、$\mathrm{MCSE} = \sqrt{p(1-p)/n}$
- **upper-limit coverage**（one-sided 97.5%）$p_U = \overline{1\{\theta \le U\}}$、$\mathrm{MCSE} = \sqrt{p_U(1-p_U)/n}$。$U$ は同じ bootstrap の 0.975 quantile（追加の bootstrap は無い）
- mean width $= \overline{U - L}$、$\mathrm{MCSE} = \mathrm{sd}(U-L)/\sqrt n$
- 補助: $s_{\hat\theta}$、bias / $s_{\hat\theta}$（C-09 と同じ比）
- **null cell（E2a）**: percentile 下限は連続データで確率 1 で 0 より大きいので two-sided coverage は構造的に ≈ 0、$U \ge 0$ なので upper-limit coverage は自明に 1。CSV には値を残すが、表では "---"（Study 2 本体の tab:coverage が S1 を除くのと同じ扱い）。
- 目標 MCSE: coverage ≤ 0.0035（5,000 reps で $\sqrt{0.95\cdot0.05/5000} = 0.0031$、10,000 reps で 0.0022）。

## 4. Outcomes（定義）
各 cell について: coverage が $0.95 \pm 2\,\mathrm{MCSE}$ の内か外か；bias / $s_{\hat\theta}$；Study 2 本体の対応 cell（E1・E3 ↔ S3 at n = 100/200；E2b ↔ S3 at n = 100；E4a ↔ S3 at n = 200；E4b ↔ S5 at n = 200）との並置。判定規則や「十分」の閾値は置かない。

## 5. Louis の攻撃と回答
1. 「cell は Study 2 本体の結果を見てから選んだ」— 4 方向は M8 の要求そのもの。E4b が S5 型であるのは結果を見た後の選択であり §0 に開示。
2. 「5,000 reps では足りない」— coverage MCSE 0.0031、2 MCSE 判定の幅は ±0.006。n_reps は pilot の wall time だけで事前に決めた（§3 D）。
3. 「格子化の真値は連続の 5 と同じだから意味がない」— 真値は同じだが、推定量は ties の多い経験 CDF で計算され、bootstrap 分布も離散的になる。性能が変わるかが問い。
4. 「組み合わせ（GUSTO-I そのもの）を見ていない」— そのとおり。§2 Does not license。

## 6. Outputs（Katrina）
`results/w1_raw_ext_summary.csv`（cell 毎の性能指標と MCSE、n_reps、n1、n2、elapsed_s、workers；cell 終了毎に書き直し）、`results/w1_raw_ext_simulation.rds`（per-replicate の estimate / L / U と per-cell summary・elapsed；cell 終了毎に書き直し、resume 可能）、`results/w1_raw_ext_sessionInfo.txt`、`results/STUDY2_EXT_PROVENANCE.md`（script が書く）。Script: `R/w1_raw_simulation_ext.R`。表: `paper/generated/tab_study2_ext.tex`（`R/make_paper_tables.R` の末尾の generator）。

## 7. Go / No-Go（Jessica）
Harvey の指示（2026-10-12、M8 対応）で即時実行。Let me be clear: 本 study が license するのは §2 の範囲だけだ。原稿に入る数値は registry を通す。

## 8. Deviations（実行後に追記）
- RNG は Study 2 本体（`clusterSetRNGStream` + 動的割当で replicate が bit 再現しない）から変更: cell 毎の L'Ecuyer-CMRG seed から replicate 毎の substream を作り、worker 内で `.Random.seed` に設定する。worker 数や割当に依らず bit 再現する。性能指標の定義は不変。
- 2026-10-12 16:40（run 開始後、cell 1–2 終了時点、性能指標は未確認）: wall time が projection の約 2.3 倍（E2a 165 s、E2b 186 s vs 75 s）。同時に別 session の single-thread R job（`R/gusto_sensitivity_outliers.R`、16:31 開始）が走り CPU load 100%。**n_reps・cell・seed は変更しない**（規則は事前の projection で適用済み）；総 wall time は予算 30–40 分を超え約 90–100 分の見込み。実測は `results/STUDY2_EXT_PROVENANCE.md` の per-cell 表。
- 2026-10-12（run 前）: smoke test（`--test`: 50 reps、B = 200、出力は `tempdir()` のみ、`results/` には書かない）を 2 workers と 1 worker で実行し、per-replicate substream により両者の summary が一致することを確認した。smoke の数値は 50 reps・B = 200 であり、本 run の n_reps・B・cell 構成の決定には使っていない（構成は smoke 前に本ファイルで固定済み）。

## 9. Amendment（2026-10-12 17:00、Harvey 指示；cold referee M5）— **3 cell の追加、run 中・追加 cell の実行前に登録**
- 理由（Harvey verbatim）: "every GUSTO distance is 0.03–0.30 SD, unequal n, SBP heaped on multiples of 10, and no Study 2 cell is in that regime"
- 登録時点で見えていたもの: 元の 8 cell のうち cell 1–5 の **wall time のみ**（log の "done (… s)" 行）。性能指標（CSV / rds）は開いていない。
- 追加 cell（k = 9, 10, 11；seed 20261012 + 1000k、substream 規則は同じ；B = 2,000）:

| Cell (k) | Region 1 | Region 2 | $n_1, n_2$ | $\theta$ | 真値の根拠 | n_reps |
|---|---|---|---|---|---|---|
| E5 (9) | $N(50,10^2)$ | $N(52,10^2)$（0.2 SD） | 1,000, 1,000 | 2 | location shift | 2,000 |
| E6 (10) | $10\,\mathrm{round}(X/10)$, $X \sim N(50,10^2)$ | 同、$N(52,10^2)$ | 2,900, 1,200 | 1.9999999919 | 下記 | 2,000 |
| E3c (11) | $\mathrm{round}(N(50,10^2))$ | $\mathrm{round}(N(55,10^2))$ | 1,000, 1,000 | 5 | §3 D（整数平行移動） | 2,000 |

- **E6 の真値**: 10 単位格子 $10j$ 上で丸めた CDF は $F_\mu(10j) = \Phi((10j + 5 - \mu)/10)$、$\theta = \sum_j 10\,\lvert F_{50}(10j) - F_{52}(10j)\rvert = 1.9999999919$（$j = -100..100$、$j = -1000..1000$ と $10^{-12}$ 以内で一致；script が停止条件として再計算）。2 は 10 の倍数でないので丸め後の平行移動にはならず、真値は 2 と厳密には一致しない。二つの丸めた法則は確率順序にあるので $\theta$ は平均差にも等しい（Mike の導出）。
- **n_reps**: 10,000 では n = 1,000 級の cell 1 つで 25–60 分（cell 1–5 の実測から）のため、Harvey の指示どおり 2,000。coverage の MCSE は $\sqrt{0.95\cdot0.05/2000} = 0.0049$（2 MCSE 判定の幅 ±0.010）、bias の MCSE は $s_{\hat\theta}/\sqrt{2000}$。front matter の target_mcse を 0.005 に緩めたのはこのため（元の 8 cell は 0.0035 のまま満たす）。
- E3c は Harvey の「E3 が安ければ n = 1,000 も」による。E3a/E3b の実測（165 s、299 s、10,000 reps）から 2,000 reps で 10 分前後の見込みで追加した。
- 対応する Study 2 本体の cell: E5・E6 ↔ S2 at n = 200（S2 は n = 50–200 で coverage が 0.703–0.947、Study 2 本体の結果は既知 — 開示）；E3c ↔ E4a（同じ n の連続版）。
- licenses / does not license は §2 と同じ。E6 は GUSTO-I の **一つの組み合わせ**（不均衡 n × 10 単位の heaping × 0.2 SD）を模すが、GUSTO-I の SBP 分布そのものではない。
- 2026-10-12 17:53（§9 の追記）: 第 1 invocation は 8 cell を完走し、各 cell の結果（rds の `mat`、CSV の行）を cell 毎に保存した後、**provenance 書き出しで停止**した。原因: run 中に amendment のため script を編集したが、Rscript はファイルを top-level 式ごとに逐次読むため、cell loop（開始前に parse 済み）の後の式がずれた位置から読まれた。8 cell の replicate と summary は loop 内で計算・保存済みで影響を受けない（rds に 8 cell × n_reps 行を確認）。provenance と sessionInfo は第 2 invocation（resume、cell 9–11 を実行）が書き直す。以後、実行中の script は編集しない。
