---
# Machine-readable half of the protocol — compiled by `python3 scripts/protocol_compile.py PROTOCOL_{study}.md`
# into R/{study}.R (seed, grid, performance measures with Monte Carlo SE, outputs), results/{STUDY}_PROVENANCE.md
# and SIMULATION_FINDINGS_{study}.md. The prose sections below remain the registered protocol.
study: example_study            # identifier → R/example_study.R
claim_id: C-01                  # CLAIMS.md row this study supports
seed: 2026
n_sim: 2000                     # >= p(1-p)/eps^2 for the coverage target below (0.95*0.05/0.005^2 = 1900)
target_mcse: {coverage: 0.005}
estimand: "W1(F1,F2) = int |F1(t) - F2(t)| dt"
truth: {method: closed_form, note: "exact for location shifts; quadrature (rel.tol 1e-12) otherwise"}
dgm:
  - {name: S1, description: "N(50,10^2) vs N(50,10^2)", params: {mu1: 50, sd1: 10, mu2: 50, sd2: 10}, true_value: 0}
  - {name: S2, description: "N(50,10^2) vs N(52,10^2)", params: {mu1: 50, sd1: 10, mu2: 52, sd2: 10}, true_value: 2}
n_grid: [50, 100, 200]
methods:
  - {name: W1,  owner: ours,     fn: estimate_w1,  ci: percentile_bootstrap, B: 2000, description: "CDF-area W1 with percentile bootstrap CI"}
  - {name: SMD, owner: existing, fn: estimate_smd, description: "Austin 2011 standardized mean difference, as written"}
measures: [bias, empse, mse, coverage, ci_width]
outputs: {summary_csv: results/example_study_summary.csv, per_rep_rds: results/example_study.rds, log: results/example_study.log}
parallel: {workers: 1, rng: per_task_seed}
prior_look: none                # or: "scratchpad/scan.R 2026-09-26 — see §0"
# post_hoc: true                # only for registering a study that was run before this gate existed: task-specific measures are
#                               # then documented, not compiled (projects/similarity-metric/PROTOCOL_study1_identification.md is the model)
---

# PROTOCOL — {study name}

**Registered**: YYYY-MM-DD HH:MM（commit `{hash}`）。**Phase 2 gate**: この file が commit されるまで confirmatory run は走らせない。逸脱は §9 に理由付きで追記し、削除はしない。
**Project**: `projects/{project}/` **Claim ID**: `CLAIMS.md` の C-xx

> 手本: `projects/similarity-metric/PROTOCOL_real_data_survey.md`（2026-09-26）。構造は ADEMP（Morris, White & Crowther 2019 "Using simulation studies to evaluate statistical methods" *Statistics in Medicine* 38:2074–2102, DOI: [10.1002/sim.8086](https://doi.org/10.1002/sim.8086)）。

---

## 0. Prior look の開示（honesty clause）

- この protocol 以前に、同じデータ／同じ生成機構で結果を見たか。見た場合: 何を・いつ・どのスクリプトで（scratchpad の出力は結果として報告しない）。見ていない場合: 「なし」と明記
- 事前に見た結果に基づいて決めた閾値・シナリオ・比較対象を列挙する。該当があれば **primary outcome は閾値非依存**にする

## 1. Claim（Harvey）

この study が支える主張を 1 文で。書けないなら study は要らない。

## 2. この study が licenses する主張 / しない主張（Mike、実行前に固定）

**Licenses**
- …

**Does not license**
- …（例: real data には ground truth がないので「W₁ が正しく SMD が誤り」は言えない／他の疾患領域・RWE への一般化／pooling の判定）

## 3. ADEMP

### A — Aims
何を知りたいか（1–3 文）。Claim（§1）との対応。

### D — Data-generating mechanisms
| scenario | 分布・パラメータ | n grid | EM 数・依存構造 | 「臨床的にありうる」根拠 |
|---|---|---|---|---|

- θ（効果関数）を特定して効果差を追跡する設計は **しない**（`memory/project_no_effect_tracking_sim.md`）
- シナリオは結果を見る前に固定。追加は §9 に逸脱として記録

### E — Estimands / targets
- 推定対象（例: $W_1(F_1,F_2)=\int_{-\infty}^{\infty}\lvert F_1(t)-F_2(t)\rvert\,dt$ の真値）と **真値の求め方**（閉形式 / 数値積分（`rel.tol`）/ Monte Carlo（$n_{\mathrm{MC}}$ と SE））

### M — Methods compared
| method | 誰の手法か（既存 as written / 我々の拡張） | 実装（関数・ファイル） | tuning |
|---|---|---|---|

誤引用禁止: 既存手法は原典の定義どおりに実装し、拡張は拡張と呼ぶ（`memory/feedback_komiyama_no_overreading.md`）。

### P — Performance measures（定義と Monte Carlo SE を事前に書く）

$n_{\mathrm{sim}}$ replications、推定値 $\hat\theta_i$、真値 $\theta$、$\bar{\hat\theta}=n_{\mathrm{sim}}^{-1}\sum_i\hat\theta_i$ として:

| measure | definition | Monte Carlo SE |
|---|---|---|
| bias | $n_{\mathrm{sim}}^{-1}\sum_i(\hat\theta_i-\theta)$ | $\sqrt{\dfrac{\sum_i(\hat\theta_i-\bar{\hat\theta})^2}{n_{\mathrm{sim}}(n_{\mathrm{sim}}-1)}}$ |
| EmpSE | $\sqrt{(n_{\mathrm{sim}}-1)^{-1}\sum_i(\hat\theta_i-\bar{\hat\theta})^2}$ | $\widehat{\mathrm{EmpSE}}\big/\sqrt{2(n_{\mathrm{sim}}-1)}$ |
| MSE | $n_{\mathrm{sim}}^{-1}\sum_i(\hat\theta_i-\theta)^2$ | $\sqrt{\dfrac{\sum_i\{(\hat\theta_i-\theta)^2-\widehat{\mathrm{MSE}}\}^2}{n_{\mathrm{sim}}(n_{\mathrm{sim}}-1)}}$ |
| coverage | $n_{\mathrm{sim}}^{-1}\sum_i\mathbb{1}\{\theta\in\mathrm{CI}_i\}$ | $\sqrt{\widehat{\mathrm{Cov}}(1-\widehat{\mathrm{Cov}})/n_{\mathrm{sim}}}$ |
| 任意の割合（power, 選択率, resolved 率） | 同上 | $\sqrt{\hat p(1-\hat p)/n_{\mathrm{sim}}}$ |
| AUC / ARI 等 | 定義を書く | replication 上の bootstrap SE、または $\sqrt{\widehat{\mathrm{Var}}/n_{\mathrm{sim}}}$ |

- **$n_{\mathrm{sim}}$ の正当化**: 目標 MCSE を先に決める。例: coverage 0.95 の MCSE を 0.005 以下にするなら $n_{\mathrm{sim}}\ge 0.95\times0.05/0.005^2=1{,}900$
- 性能指標は論文でも MCSE 付きで報告する（表の列、または図の帯）

## 4. Seeds・計算環境・失敗の扱い

- seed: スクリプト冒頭で `set.seed({seed})` を宣言。parallel は `clusterSetRNGStream` / `RNGkind("L'Ecuyer-CMRG")` / task ごとの `set.seed(base + index)` のいずれかを明記（`w1_raw_simulation.R` の非再現性を繰り返さない）
- 環境: R version、主要 package version（`renv.lock` または `sessionInfo()` を results に同梱）
- 推定実行時間、中間保存の方式
- 非収束・エラー・NA の扱い（除外規則は **事前に**。除外数は報告）

## 5. 解析計画

- **Primary outcome**（1 つ、閾値非依存を優先）／**Secondary outcomes**
- 集計の単位と方法（scenario × n ごとに表の 1 行）
- 図: 何をプロットするか（caption は事実のみ）。規格は `.claude/rules/r-code.md`
- **探索的解析**はここに「探索的」と明記したものだけ許す。論文に載せるときも exploratory と書く

## 6. Louis の攻撃と回答

- 循環論法（KR 双対で W₁ が定義上最適になる設計か）
- Cherry-picking（データ・EM・シナリオの選抜基準は結果非依存か）
- 「結果がどう出ても §1 の claim を守れるか」— 両方向の結果を書いておく
- 多重性・非独立（pair が region を共有する等）→ p 値を出すのか descriptive に留めるのか
- 誤読の予防（"resolved" ≠ "correct" など）

## 7. 出力物（Katrina、single writer）

| artifact | path | 列定義 / 規格 |
|---|---|---|
| script | `R/{study}.R` | 入力・出力パスを冒頭で変数化、project-relative |
| results | `results/{study}_summary.csv` | measure ごとに estimate と MCSE の列 |
| per-replicate | `results/{study}.rds` | 再集計の source |
| log | `results/{study}.log` | seed, B, $n_{\mathrm{sim}}$, sessionInfo, 実行時間 |
| findings | `SIMULATION_FINDINGS_{study}.md` | `templates/simulation_findings_template.md` |
| provenance | `results/{STUDY}_PROVENANCE.md` | `templates/provenance_template.md` |

## 8. Go / No-Go（Jessica）

Go / No-Go と条件（1–3 文）。

## 9. 逸脱記録（append-only）

| date | 何を変えたか | 理由 | 承認 |
|---|---|---|---|
