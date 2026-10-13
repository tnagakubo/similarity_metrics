# Ideas Backlog（cross-project）

> *"The best ideas come when you're working on something else."* - Donna Paulsen

議論の展開で出た**別論文のネタ**をその場でストックする（`/idea`、RESEARCH_FRAMEWORK S23、`memory/feedback_idea_stock.md`）。
研究は発散してよい。論文は絞る（`memory/feedback_diverge_converge.md`）。絞るときに外した論点はここに来る — supplement にも Discussion の「将来の課題」にも行かない。
**判定しない**: 登録して本題に戻る。見直しは Phase 9（`/victory`）で Harvey。

- ID: `I-YYYYMMDD-n`（同日は n を増やす）。`scripts/check_consistency.sh` §7 が ID の重複を見る
- status: `💡 Incubating` → `🔬 Exploring`（`/explore <slug>`）→ `📄 Promoted`（`/start`）/ `🗑 Dropped`（理由）
- 根拠が無いネタは「必要な根拠」列に `[推測]` と書いてよい（ストックは推測 OK、原稿は不可 → `/ground`）

---

## Stock

| ID | date | source | ネタ（一行） | 現論文の scope 外である理由 | 必要な根拠・データ | status | by |
|---|---|---|---|---|---|---|---|
| I-20260203-1 | 2026-02-03 | Tak | 相対効果（relative effect）を因果推論の枠組み（potential outcomes、transportability）で再考する | similarity-metric の Aim（EM 分布の違いの定量化）ではなく、効果の定義そのものを問う | 文献: transportability / effect modification の causal 文献。ICH E17 regional consistency との接点は `[推測]` | 💡 Incubating | Tak |
| I-20260927-1 | 2026-09-27 | SUITS 09-27（RV1–RV3・clustering を原稿から外す、D-20261011-8）；`projects/similarity-metric/PROTOCOL_silhouette_extension.md` | 地域の EM 類似性に基づく clustering（W₁ 距離行列 + silhouette / ARI）の性質と限界 | 現論文は per-EM の pairwise 定量化まで。地域を**まとめる**手続きは「判定」側（`feedback_quantify_not_decide`） | 既存 protocol と results（ディスクにあり、原稿は引かない）。oracle-k 依存の扱いが論点 | 💡 Incubating | Donna（backfill 2026-10-12） |
| I-20261011-1 | 2026-10-11 | Claude Science の referee 付随 exploratory（`/explore` SKILL.md 冒頭に記録） | Neyman smooth test の 2 標本版を EM 分布比較に使う（W₁ の補完 / 対抗手法） | 現論文の Aim は W₁ の identification / estimation / calibration。検定中心の手法は estimation-centered の方針と別の論文 | 2 標本 smooth test の原典（🔍要根拠 — Rachel が DOI を引く）、simulation は exploratory から | 💡 Incubating | Donna（backfill 2026-10-12） |
| I-20261012-1 | 2026-10-12 | Tak「もっとよい事例がないか」→ `projects/similarity-metric/review_response/CASE_STUDY_CANDIDATES_20261012.md`（Rachel 13 datasets 調査） | 既知の地域間不一致 MRCT（TOPCAT: Americas vs Russia/Georgia、BioLINCC、country 変数あり）で、per-EM W₁ が事後的にどこまで不一致を「説明」し得るかを、薬剤曝露（de Denus 2017、canrenone 30% vs 3%）と切り分けて分解する | 現論文は planning-stage の定量化（Q_metric）で、EM 分布差 → 効果差の追跡は意図的に scope 外（`memory/project_no_effect_tracking_sim.md`） | TOPCAT IPD（BioLINCC tier 3、DUA、"under review" notice あり）、Pfeffer 2015 DOI 10.1161/CIRCULATIONAHA.114.013255、de Denus 2017 DOI 10.1056/NEJMc1612601 | 💡 Incubating | Donna |
| I-20261012-2 | 2026-10-12 | D-20261012-2 Louis C4 → `projects/similarity-metric/exploratory/set4_control_mechanism/`（exploratory run 2026-10-12, Supported） | For a pure location shift, when does the sup-norm (KS) discriminate with fewer patients than W₁? Hypothesis: the ordering follows the sampling noise of Ŵ₁ (null mean ∝ ∫√(F(1−F))dx, inflated by heavy or remote tails) while D_KS is distribution-free | R2 only claims that W₁ is not blind (identification). The efficiency of W₁ vs KS against shifts is a power question outside A1; the manuscript states only the fact (Table 1) | Protocol with a family of base distributions graded by ∫√(F(1−F))dx at fixed SD; paired ΔAUC with MCSE; null law of √n·Ŵ₁ (del Barrio, Giné & Matrán 1999, DOI 10.1214/aop/1022677394 — passage to verify) | 💡 Incubating | Mike / Donna |
| I-20261012-3 | 2026-10-12 | 外部レビュー M3（`review_response/EXTERNAL_REVIEW_20261012.md`）| Study 1 の比較に Cramér–von Mises・Anderson–Darling・energy distance（1 次元では 2∫(F₁−F₂)² dx）を加える | 現論文の比較は W₁・KS・SMD で protocol 登録済み；追加は amendment と再実行（13 cell × 10,000 reps）が要る。energy distance の bound の定数は ‖τ′‖₂ で per-unit slope でない（Louis） | protocol amendment、`R/selection_simulation.R` への method 追加、MCSE | 💡 Incubating | Harvey |
| I-20261012-4 | 2026-10-12 | 外部レビュー M6 | GUSTO-I で age × SBP の同時分布の W_d（重み付き ℓ₁ cost、L_k = L_UB,k）を計算し、周辺の和 Σ L_k W₁^(k) との差で交互作用の寄与を示す | 現論文は per-EM の周辺距離に scope を限定（§2.2）；W_d の推定・区間は多変量問題で Study 2 の範囲外 | 2 次元 OT（`transport` / LP）、L_k の指定、bootstrap 区間の性質 | 💡 Incubating | Harvey |
| I-20261012-5 | 2026-10-12 | 外部レビュー M5 + Rachel `LIT_POSITIONING_20261012.md` §5 | W₁ を Δ_clin / L_UB に対する同等性検定として定式化し、Munk & Czado 型の size 制御と percentile 区間の片側 coverage を比較する | 判定規則の規定は現論文の方針外（`feedback_quantify_not_decide`）；size が臨床入力 L_UB を条件にする | Munk & Czado 1998（DOI 10.1111/1467-9868.00121）の trimmed Mallows の枠組み、境界での size の simulation | 💡 Incubating | Louis |

## Developed（Promoted / Dropped）

| ID | became | date | note |
|---|---|---|---|
| — | — | — | — |

---

*Maintained by Donna | Format v2 2026-10-12（`/idea`）| 旧 Idea #1 = I-20260203-1*
