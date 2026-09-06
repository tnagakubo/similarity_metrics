# Presentation-Fix Proposals — Simulated SiM Review (R2/R3 presentation items)

対象: `projects/similarity-metric/paper/per_em_W1_wiley.tex`（777 行、行番号は現行ファイル準拠）
本ファイルは **提案のみ**。tex への適用は Tak の承認後。数値・行番号はすべてファイルから検証済み（検証元スクリプト名を併記）。

---

## 1. R3.1 — Study numbering inversion（§3.1 = Study 2 が先に登場する問題）

### 1.1 Inventory（検証済み）

**"Study 2" — 16 occurrences / 15 行**（行 220 に 2 回）:

| 行 | 種別 | 内容 |
|---|---|---|
| 220 (×2) | 本文 | §3 導入段落（"Study 2, presented first, evaluates decision performance… Study 1 evaluates…"） |
| 222 | 本文 | 3つの sample-size statement の区別 |
| 224 | **見出し** | `\subsection{Study 2: Decision Performance}\label{sec:study2}` |
| 238 | 本文 | ADEMP design 段落 |
| 255 | **caption** | `fig:study2_auc` の caption（"three cells of Study 2"） |
| 312 | comment | DECIDED note（verification-gate 系） |
| 324 | 本文 | §3.2 冒頭（"Study 2 compared decisions; Study 1 characterizes…"） |
| 450 | comment | 旧 SMD table 削除 note |
| 462 | 本文 | §3.2 末尾（"the sample sizes that decisions require are Study 2's"） |
| 621 | comment | app_allmethods の decision note |
| 622 | 本文 | "mirroring Study 2's device" |
| 644 | 本文 | "displaced extremes of Study 2 (Section~\ref{sec:study2_classification})" |
| 646 | 本文 | "but Study 2 does:" |
| 662 | 本文 | Discussion (i) |
| 676 | 本文 | Discussion gap 段落 |

**"Study 1" — 5 occurrences / 4 行**: 220 (×2), 222, 322（見出し `\subsection{Study 1: Estimation Properties}\label{sec:study1}`）, 324。

集計: 全 21 occurrences。うち **reader-visible（本文・見出し・caption）18**（Study 2: 13、Study 1: 5）、**LaTeX comment 3**（行 312, 450, 621 — reviewer の言う verification-gate comments。優先度低、履歴として据え置き可）。ほかに行 226–234 の comment block が `R/verify_study2_figures.R` というスクリプト名を参照（"study2" は名前の一部でありリネーム対象外）。

**Labels（11 個、定義行）**: `sec:study2` (224), `sec:study2_design` (236), `sec:study2_classification` (244), `fig:study2_auc` (256), `sec:study2_selection` (259), `tab:study2_required_n` (265), `sec:study2_clustering` (286), `tab:study2_ari` (292), `sec:study1` (322), `sec:sim_design` (326), `sec:sim_results` (361)。

**\ref 使用状況**: `sec:sim_results` ×4 (214, 390, 513, 688) / `sec:study2_classification` ×4 (288, 644, 662, 676) / `fig:study2_auc` (246) / `tab:study2_required_n` (261) / `tab:study2_ari` (288) / `sec:study2_selection` (462) / `sec:study2_design` (622) / `sec:study2_clustering` (646)。**一度も参照されない label**: `sec:study2`, `sec:study1`, `sec:sim_design`。

**Repo docs への波及**（grep 行数カウントのみ、編集せず）:
- `PAPER_OUTLINE_BILINGUAL.md`: "Study 1" を含む行 **20**、"Study 2" を含む行 **22**
- `PAPER_LOGIC.md`: "Study 1" **3** 行、"Study 2" **3** 行

### 1.2 Options と cascade cost

| | Option (i) 番号スワップ | Option (ii) Study A / Study B | Option (iii) 番号廃止（記述名） |
|---|---|---|---|
| 変更方式 | 全 "Study 1"↔"Study 2" 入替え | Study 2→"Study A (decision performance)"、Study 1→"Study B (estimation properties)" | "the decision-performance study" / "the estimation study" |
| tex 変更 occurrences | 18（本文）+ 3 comment（任意） | 18 + 3（任意） | 18 + 3（任意）。ただし機械置換でなく文単位の書換え |
| \label rename | 不要（内部名）。ただし `sec:study2` が「Study 1」の節を指す**意味反転**が発生 — maintainer hazard | 不要。`study2`=Study A の対応表 1 行で足りる（反転なし） | 不要。`study2`=decision study の対応が恒久的に一意 |
| repo docs | OUTLINE 42 行 + LOGIC 6 行が**逆向きに**陳腐化（旧 Study 1 = 新 Study 2）。`verify_study2_figures.R` の名前も紙面の "Study 1" を指すことになる | docs は旧名のまま・namespace が別（1/2 vs A/B）なので衝突しない。対応表を要追記 | docs は旧名のまま歴史的記録として無害。紙面に番号がないため衝突が構造的に消滅 |
| 読者への効果 | 番号 = 提示順になる（reviewer の字義どおりの要求） | 順序問題は解消するが A/B は無情報ラベル | 名前自体が内容を語る。行 220 の "presented first" という弁明文も自然に消せる |

### 1.3 推奨: **Option (iii)**（次点 (ii)）

**Mike の検証観点での理由**:
1. **読者の混乱の根は「番号と順序の不一致」ではなく「番号が内容を語らないこと」**。(i) は紙面内では直るが、revision 中のすべての紙面外 artifact — `R/verify_study2_figures.R`、`results/verify_study2.log`、`PAPER_OUTLINE_BILINGUAL.md` 42 行、SUITS 履歴 — の "Study 2" が**逆の意味**になる。これは Numbers Verification Gate が防いでいる誤照合クラスをまさに人為的に作る操作で、リスクが最も高い。
2. (iii) は変更 occurrence 数が (i) と同じ 18 で、cascade は tex 内で閉じる。label・スクリプト名・結果ファイル・アウトラインは全て無変更で、しかも将来的に意味がずれない（"decision-performance study" は並び順に依存しない）。
3. 見出しは `\subsection{Decision Performance}` / `\subsection{Estimation Properties}` となり、§3.1/§3.2 の節番号が順序を担う。行 220 の導入文は「二つの研究を役割で導入する」形に書き換え（例: "The first study evaluates decision performance…; the second characterizes the estimator those decisions rely on…"）。
4. Comment 3 箇所（312, 450, 621）は歴史的記録なので**触らない**ことを推奨（reviewer 自身が lower priority と明言）。

**書換え対象 18 occurrences の置換方針（例示）**: 220 導入文全体を書換え / 222 "Study 1's recommendation"→"the estimation study's recommendation"、"Study 2's required sample sizes"→"the decision study's" / 224・322 見出し / 238 "Study 2 follows the ADEMP structure"→"The decision-performance study follows…" / 255 caption "three cells of Study 2"→"three cells of the decision-performance study" / 324 "Study 2 compared decisions; Study 1 characterizes"→"The preceding study compared decisions; this study characterizes…" / 462, 622, 644, 646, 662, 676 同様の名詞句置換。

---

## 2. R3.2 — Notation table（提案・未適用）

### 2.1 Harvest（定義位置はすべて検証済み）

式番号は出現順（eq 1 = `eq:regional_ate` … eq 11 = `eq:operability`）。

| Symbol | 定義位置（行） | 式 |
|---|---|---|
| $\tau(x)$ (CATE) | 97, §2 冒頭 | — |
| $F_r$ | 97 / 126 | — |
| $\bar\tau_r$ | 99 | eq (1) |
| SMD | 108 | eq (2) |
| $D_{\mathrm{KL}}$ | 115 | eq (3) |
| $D_{\mathrm{KS}}$ | 113（inline） | — |
| $W_1$ | 128 | eq (4) |
| $L_{\text{clinical}}$ | 145（導入）/ 174（§2.4 正式） | — |
| $\widehat W_1$ | 165 | eq (7) |
| $n_1, n_2$; $B=2000$ | 163 / 168 | — |
| $\Delta_{\max}$ | 178 | eq (8) |
| $\Delta_{\text{clin}}$ | 183 | — |
| $L^*$ | 185 | eq (9) |
| $L_{\text{UB}}$ | 188 | — |
| $\tau_{\text{clin}}$ | 194 | eq (10) |
| $q_{1-\alpha}(n_1,n_2,F)$ | 205 / eq (11) 207 | — |
| RV1–RV3 | 240（§3, `sec:study2_design`） | — |
| AUC / ARI | 222, 242 / 242, 288 | — |
| $\rho = W_1/(D_{\mathrm{KS}}\sigma_{\mathrm{EM}})$ | 654（§4.5） | — |
| $\rho_S$ (Spearman) | 628–641（§4.5, Table caption） | — |

### 2.2 配置の提案

Reviewer 案は「§2.1 末尾 or Table 1」。ただし §2.1（`sec:existing`）末尾では $W_1$ 以降の大半が未定義のため、**§2 の末尾（§2.5 の後、§3 の直前）に置き、"defined in" 列で遡及参照させる**か、§2 冒頭（eq 1 の後）に置くのが自然。§2 内のどこに置いても現行の最初の表 `tab:study2_required_n`（行 265）より前になるので**自動的に Table 1** になり、以降の表番号が全て +1 シフトする。本文の表参照は全箇所 `Table~\ref{...}` 形式（ハードコードなし、検証済み）なので**シフトは無害**。

### 2.3 LaTeX draft（English、未適用）

```latex
\begin{table}[t]
\centering
\caption{Notation used throughout the paper.\label{tab:notation}}
\begin{tabular}{llll}
\toprule
\textbf{Symbol} & \textbf{Meaning} & \textbf{Units} & \textbf{Defined in} \\
\midrule
$X$, $x$            & Continuous effect modifier (EM)                        & EM units      & Section~\ref{sec:methods} \\
$\tau(x)$           & Conditional average treatment effect (CATE)            & outcome scale & Section~\ref{sec:methods} \\
$F_r$               & CDF of the EM in region $r$                            & ---           & Section~\ref{sec:methods} \\
$\bar{\tau}_r$      & Average treatment effect in region $r$                 & outcome scale & Eq.~(\ref{eq:regional_ate}) \\
$\text{SMD}$        & Standardized mean difference                           & unitless      & Eq.~(\ref{eq:smd}) \\
$D_{\text{KS}}$     & Kolmogorov--Smirnov statistic                          & unitless      & Section~\ref{sec:existing} \\
$D_{\text{KL}}$     & Kullback--Leibler divergence                           & nats          & Eq.~(\ref{eq:kl}) \\
$W_1$               & Wasserstein-1 distance between two CDFs                & EM units      & Eq.~(\ref{eq:wasserstein}) \\
$\widehat{W}_1$     & Empirical (plug-in) estimator of $W_1$                 & EM units      & Eq.~(\ref{eq:estimator}) \\
$n_1, n_2$          & Regional sample sizes                                  & ---           & Section~\ref{sec:estimation} \\
$B$                 & Bootstrap replicates ($B = 2{,}000$)                   & ---           & Section~\ref{sec:estimation} \\
$L_{\text{clinical}}$ & Lipschitz constant of $\tau(x)$ (clinical slope)     & outcome per EM unit & Section~\ref{sec:inference} \\
$\Delta_{\max}$     & Maximum potential regional treatment effect difference & outcome scale & Eq.~(\ref{eq:delta_max}) \\
$\Delta_{\text{clin}}$ & Pre-specified clinical margin                       & outcome scale & Section~\ref{sec:inference} \\
$L^*$               & Required clinical slope at margin $\Delta_{\text{clin}}$ & outcome per EM unit & Eq.~(\ref{eq:lstar}) \\
$L_{\text{UB}}$     & Plausible upper bound on $L_{\text{clinical}}$         & outcome per EM unit & Section~\ref{sec:inference} \\
$\tau_{\text{clin}}$ & Clinically derived threshold on $W_1$                 & EM units      & Eq.~(\ref{eq:tau_clin}) \\
$q_{1-\alpha}(n_1,n_2,F)$ & $(1-\alpha)$ quantile of the null distribution of $\widehat{W}_1$ (null floor) & EM units & Eq.~(\ref{eq:operability}) \\
RV1--RV3            & Representative-value distances on (mean), (mean, SD), (mean, SD, skewness) & unitless & Section~\ref{sec:study2_design} \\
AUC                 & Area under the ROC curve (selection task)              & unitless      & Section~\ref{sec:study2_design} \\
ARI                 & Adjusted Rand index (clustering task)                  & unitless      & Section~\ref{sec:study2_design} \\
$\rho$              & Spread ratio $W_1 / (D_{\text{KS}} \cdot \sigma_{\text{EM}})$ & unitless & Section~\ref{sec:app_allmethods} \\
$\rho_S$            & Spearman rank correlation with the $W_1$ ordering      & unitless      & Section~\ref{sec:app_allmethods} \\
\bottomrule
\end{tabular}
\end{table}
```

注意（適用時）: (a) Option (iii) 採用なら "Defined in" の `sec:study2_design` 参照はそのまま有効（label 不変）。(b) 行 205 の $q_{1-\alpha}$ と行 654 の $\rho$ は現状 display 式でないため "Section" 参照とした。(c) `\toprule` 系は既存表（行 267 等）と同一 style。

---

## 3. R3.3 — Workflow box（提案・未適用）

### 3.1 §2・§4 との整合検証

Reviewer 提示の 5 steps を紙面と突き合わせた結果:

| Step | 紙面の根拠 | 整合性メモ |
|---|---|---|
| Inputs: candidate EM list / $\Delta_{\text{clin}}$ / $L$ evidence state / regional data sources | §4.1 行 472（sponsor が候補 EM を特定）、§2.4 行 183・188–190（$\Delta_{\text{clin}}$、二つの evidence state）、行 40・686（prior trials / registries / RWE） | ✔ そのまま |
| (1) operability check per EM | §2.5 行 201–214（null floor、eq 11）、§4.2 行 492–513 | ⚠ **eq (11) の比較には $\tau_{\text{clin}} = \Delta_{\text{clin}}/L_{\text{UB}}$（eq 10）が先に要る**（§4.2 の Table `tab:operability` 行 503–504 は $\tau_{\text{clin}}$=1.0 / 5.0 を既に使用）。また "unresolved partner" 判定（行 494）は**観測 $\widehat W_1$** を null floor の 95th pct と比較するので、実務では step 2 の点推定と同時に走る。box では step (1) に $\tau_{\text{clin}}$ 導出を明示し、unresolved 判定を注記 |
| (2) $\widehat W_1$ + percentile bootstrap CI per pair per EM | §2.3 行 163–168（eq 7、$B=2000$）、§4.3 行 515–517 | ✔ |
| (3) $\Delta_{\max}$ pathway if $L$ known / $L^*$ vs $L_{\text{UB}}$ if not | §2.4 行 176–190（eq 8 / eq 9）、§4.4 行 563–565 | ✔ dual pathway の記述と一致 |
| (4) joint (AND) criterion | §4.4 行 596（"A region is jointly eligible if it satisfies the criterion on both candidate effect modifiers"） | ✔ §2 には AND 基準の一般的記載はなく §4 で導入 — box に入れることでむしろ手順が §2 に前倒しで見える（利点として提示可能） |
| (5) sensitivity to $L_{\text{UB}}$ slack | §4.4 行 602–604（relative slack $\tau/\widehat W_1 - 1$、critical scaling factors） | ✔ |
| Outputs: eligible partner set + per-partner slack | §4.4 行 596（6 regions）、行 602（slack 分布） | ✔ unresolved-EM flags も §4.2 の出力として追加を推奨 |

### 3.2 Float 形式の検証

- Preamble の `\usepackage` は `mathtools`, `amssymb` のみ（行 15–16）。
- **`WileyNJDv5.cls` 自身が `algorithm`, `algorithmicx`, `algpseudocode`, `listings` をロード**（cls 行 6819–6821）。前回コンパイルの `paper/per_em_W1_wiley.log` に `algorithm.sty` / `algorithmicx.sty` / `algpseudocode.sty` / `listings.sty` / `enumerate.sty` のロード記録を確認済み。`.sty` 実体も `paper/` に同梱（`algorithm.sty`, `algorithmicx.sty`, `algpseudocode.sty`）。→ **algorithm float は追加パッケージなしで使用可能**。
- 一方 cls の `boxtext` / `boxwithhead` 環境（cls 行 592, 601）は内部で `breakbox` 環境を使うが、`breakbox` の定義（eclbkbox.sty）は cls 内・`paper/`・TeX 配布（kpsewhich 空振り）・コンパイルログのいずれにも見当たらない → **boxtext 系は使用した瞬間にコンパイルエラーの可能性が高く、非推奨**。

### 3.3 LaTeX draft（algorithm float、English、未適用）

```latex
\begin{algorithm}[t]
\caption{Planning-stage workflow for per-EM pooling-partner assessment.\label{alg:workflow}}
\begin{algorithmic}[1]
\Require Candidate effect modifier (EM) list; baseline EM data for the anchor and each
         candidate partner (trial, registry, or RWE sources); clinical margin
         $\Delta_{\text{clin}}$; CATE-sensitivity evidence state ($L_{\text{clinical}}$
         known, or an upper bound $L_{\text{UB}}$ only).
\State \textbf{Threshold and operability (per EM, per partner).} Derive
       $\tau_{\text{clin}} = \Delta_{\text{clin}} / L_{\text{UB}}$
       (equation~\ref{eq:tau_clin}). Obtain the null floor
       $q_{1-\alpha}(n_1, n_2, F)$ by resampling two independent draws of the actual
       sample sizes from one region's empirical distribution
       (Section~\ref{sec:operability}); require
       $\tau_{\text{clin}} > q_{1-\alpha}$ (equation~\ref{eq:operability}), and flag as
       unresolved any partner whose observed $\widehat{W}_1$ falls at or below the
       $(1-\alpha)$ null quantile.
\State \textbf{Estimation (per EM, per pair).} Compute $\widehat{W}_1$
       (equation~\ref{eq:estimator}) with a percentile bootstrap CI
       ($B = 2{,}000$; Section~\ref{sec:estimation}).
\State \textbf{Clinical calibration.} If $L_{\text{clinical}}$ is known, report
       $\Delta_{\max} = L_{\text{clinical}} \cdot \widehat{W}_1$ with its CI
       (equation~\ref{eq:delta_max}); otherwise report
       $L^* = \Delta_{\text{clin}} / \widehat{W}_1$ (equation~\ref{eq:lstar}) and judge
       per-EM eligibility by $L^* > L_{\text{UB}}$.
\State \textbf{Joint criterion.} Admit a partner only if it is eligible on every
       candidate EM (AND rule; Section~\ref{sec:app_clinical}).
\State \textbf{Sensitivity.} Report each admitted partner's relative slack
       $\tau_{\text{clin}} / \widehat{W}_1 - 1$ per EM, and the critical scaling of
       $L_{\text{UB}}$ at which the joint conclusion changes
       (Section~\ref{sec:app_clinical}).
\Ensure Jointly eligible partner set; per-partner, per-EM slack; unresolved-EM flags.
\end{algorithmic}
\end{algorithm}
```

配置案: §2.5 末尾（行 214 の後）— §2 の全部品が出揃った直後で、§4 の実演の予告になる。代替: `\Require`/`\Ensure` を使わず plain `enumerate` を `table` float に入れる fallback も可（`float`, `tabularx`, `enumerate` はロード済み確認）。

---

## 4. R2/R3 minors — 検証結果と修正案

### (a) S6 LogN(μ, σ) の実パラメータ

**検証済み**: Study 1（estimation）の production driver は `R/w1_raw_simulation.R`（ヘッダ行 12–21 にシナリオ定義、`simulation_manuscript_v2.R` を source）。

- `R/simulation_manuscript_v2.R` 行 366–367: `sigma_ln <- 0.5`, `mu_ln <- log(50) - sigma_ln^2 / 2`
- `R/w1_raw_simulation.R` 行 18: "S6: N(50,10^2) vs LogN(meanlog=log(50)-sigma_ln^2/2, sigma_ln=0.5)"
- 独立再現 `R/louis_independent_replication.R` 行 97–100、`R/verify_all.R` 行 27 も同値。

つまり **μ = log 50 − 0.125 ≈ 3.7870、σ = 0.5**（mean = 50、CV = √(e^{0.25}−1) ≈ 53.3%、skewness ≈ 1.75 — tex 行 347 の tablenote "mean 50 with CV ≈ 53%" と整合）。

**修正案**: `tab:scenarios` 行 342 の "LogN$(\mu, \sigma)$" を "LogN$(\mu = \log 50 - 0.125,\ \sigma = 0.5)$"（または数値 3.787, 0.5）に置換。tablenote は現状のままで整合。

### (b) Tie handling（eq 7 と離散 EM）

**検証済み**:
- eq (7)（tex 行 164–168）は combined order statistics を $x_{(1)} < \cdots < x_{(n_1+n_2)}$ と**狭義不等号**で書いており、tie（離散・丸め EM）があると表記上は成立しない。
- Appendix B の `compute_W1`（tex 行 750–758）は `sort(unique(pooled))` で tie を明示的に潰す。
- Production 実装は 3 系統とも tie-safe: `R/fig3_w1_axis.R` 行 39–50（midpoint Riemann 和、unique なし — 幅 0 区間の寄与が 0）、`R/selection_simulation.R` 行 61（equal-n sorted-pair mean）、`R/W1_raw_rcpp.cpp`（merge ベース CDF 積分）。**推定値は tie の有無に不変**（幅 0 の項が消えるだけ）。
- したがって必要なのは修正ではなく **remark 1 文**。

**修正案**（eq 7 直後、行 168 の "The estimator…" の前に挿入する draft）:

```latex
When ties occur, as with discrete or rounded effect modifiers, consecutive order
statistics coincide and the corresponding zero-width terms vanish; equivalently, the
sum may be taken over the distinct values of the combined sample, as in the
implementation of Appendix~B. The value of $\widehat{W}_1$ is unaffected.
```

### (c) Simulation seeds

**検証済み（grep set.seed 全 R/）** — 論文に載る全 study が seeded:

| Study / 解析 | Driver | Seed（行番号） |
|---|---|---|
| Estimation study（§3.2, S1–S7） | `R/w1_raw_simulation.R` | per-cell `42L + 1000L*k`（行 281）、truth MC `12345`（行 238）、`seed_base = 42L`（行 313） |
| Decision study — selection（§3.1） | `R/selection_simulation.R` | `base_seed = 20260711L`（行 45）、per-cell `base + 1000*cell`（行 387）、truth grid `990000L + si`（行 365） |
| Decision study — clustering（§3.1） | `R/clustering_simulation.R` | `base_seed = 20260712L`（行 51）、`880000L + cell`（行 239） |
| Silhouette（n-of-k）再実行 | `R/clustering_nok_simulation.R` | `base_seed = 55000000L`（行 77） |
| Discussion の anchor-vs-clustering sim | `R/anchor_vs_clustering_simulation.R` | `base_seed = 91000000L`（行 68） |
| Application $\widehat W_1$ + CI（Table 7） | `R/gusto_case_study.R` / `R/fig3_w1_axis.R` | `set.seed(2026)`（行 32 / 行 28）— **tex 行 544 の "seed = 2026" と一致** ✔ |
| Application operability（§4.2） | `R/gusto_operability_check.R` | `SEED <- 20260821L`（行 38）— **tex には未記載** |
| Application $L_{\text{UB}}$ sensitivity / all-methods | `R/gusto_lub_sensitivity.R` / `R/application_all_methods.R` | seed なし — **意図的**（行 9 コメント "Pure arithmetic … no resampling, no seed" / 距離計算のみで決定的） |

**修正案**: tex が明示する seed は 2026 のみ。Data availability（行 712–714）または各 study の design 記述に、simulation seeds（42 / 20260711 / 20260712 / 20260821）を一行で記載するか、リポジトリ README に委ねる旨を明記。blocking ではない。

### (d) Figure 1 の harmonization

**検証済み**: `fig1_w1_definition.pdf` の generator は `R/figures_paper_W1.R` の `fig1_w1_definition()`（行 104–113、出力 行 330–340）。描画内容は **Region 1 = Gamma(shape 4, scale 10)（right-skewed, mean 40）、Region 2 = N(55, 10²)**。つまり **caption（tex 行 135 "gamma … normal"）は図と一致**しており、不一致は §2.1 の SMD 例 $N(50,5^2)$ vs $N(50,15^2)$（行 111）との**題材のズレ**のみ。なお `R/regen_fig1_only.R` は旧 nABCD 名 `fig1_nabcd_definition` を出力する obsolete script（現行 fig1 とは別物）。

**Options**:
1. §2.1 の例を gamma vs normal に変える — ✕ SMD = 0 になる equal-mean 例という論証機能を失う。
2. 図を $N(50,5^2)$ vs $N(50,15^2)$ に描き替える — △ 図の目的（skewness を含む shape 差が面積として見えること）が弱まり、再生成 + 検証の手間も発生。
3. **Bridging sentence 1 文を追加（推奨、最小コスト）** — 行 131 の "(Figure~\ref{fig:nabcd_definition})" 直後に挿入:

```latex
The figure pairs a right-skewed with a symmetric distribution so that a shape
difference is visible as the area between the CDFs; the equal-mean,
unequal-variance example of Section~\ref{sec:existing}, invisible to the SMD,
would register on $W_1$ in the same way.
```

### (e) Placeholders（submission checklist 用、検証済み）

| 行 | 内容 |
|---|---|
| 24, 26, 28 | `\author` = "Author One/Two/Three" |
| 30–31 | `\authormark` / `\titlemark`（AUTHOR ONE et al.） |
| 33, 35 | `\address` = "Department Name / Institution Name / State / Country" |
| 37 | `\corres` + `corresponding@institution.edu` |
| 44–48 | `\jnlcitation` の Author One/Two/Three |
| 698 | Author contributions: `[Author 1]` `[Author 2]` `[Author 3]` |
| 702 | Acknowledgments: `[colleagues]` |
| 714 | Data availability: `[repository URL]` |

すべて投稿時差し替え項目。`[repository URL]` は (c) の seed 記載先と併せて確定するのが効率的。

### (f) Abstract word count

`\abstract{}`（tex 行 39–40）の粗 de-TeX カウントで **約 360 語**（2 通りの strip 方法で 356 / 364）。SiM の分量調整は**別途 "Terminal pass" で扱うことが決定済み**（repo 決定事項、abstract 本文の変更案は本ファイルの scope 外 — 提案しない）。ここでは現状値の記録のみ。

---

## 5. Prioritized checklist

| # | Item | Effort | Resubmission blocking? |
|---|---|---|---|
| 1 | R3.1 Study naming — Option (iii) 適用（18 本文 occurrences 書換え、label/comment 不変） | 中（半日以内、全文 re-read 込み） | **Yes**（reviewer 明示指摘） |
| 2 | R3.2 Notation table 挿入（Table 1 化、以降の表番号自動シフト） | 小〜中（表 1 個 + 配置確認） | **Yes**（reviewer 明示指摘） |
| 3 | R3.3 Workflow algorithm float 挿入（§2.5 末尾、パッケージ追加不要） | 小（draft 済み、コンパイル確認のみ） | **Yes**（reviewer 明示指摘） |
| 4 | (a) S6 パラメータ明記（行 342 の 1 セル） | 極小 | Yes（数値の完全性） |
| 5 | (b) eq (7) ties remark（1 文挿入） | 極小 | No（but cheap — 同時に入れる） |
| 6 | (d) Fig 1 bridging sentence（1 文挿入） | 極小 | No |
| 7 | (c) Seeds の紙面記載（Data availability に 1 文） | 極小 | No（リポジトリ公開時に吸収可） |
| 8 | (e) Placeholders 差し替え（9 箇所） | 極小 | **Yes**（投稿手続き上必須、ただし機械的） |
| 9 | (f) Abstract 語数（≈360 語） | — | 別 pass（Terminal pass）で対応、本提案の scope 外 |

適用順の推奨: #1 → #2/#3（表番号シフトと節参照が #1 の文面確定後に安定するため）→ #4–#6 を一括 → #7/#8 は投稿直前。
