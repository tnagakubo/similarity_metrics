# SUITS.md - Research Lab Live Script

> *"I don't have dreams. I have goals."* - Harvey Specter

---

## 📍 Current Status

**Active Project**: similarity-metric (nABCD paper for Statistics in Medicine)
**Phase**: 8 - Submission-Ready Plan (Jessica Strategic Directive)
**Scene**: Continuing from archive

**Previous Archive**: archives/SUITS_20260223_104500.md (1057 lines)

### Paper Title (decided 2026-02-14)

> **Quantifying Effect Modifier Similarity for Regional Pooling in Multi-Regional Clinical Trials**

### Purpose Statement (Jessica approved)

> **EM分布の違いを推定し、その推定値を治療効果の異質性の可能性として臨床スケールに翻訳する。**
> **検定ではなく推定。二択ではなく情報提供。**

---

## 📊 Key Decisions

1. **Percentile > BCa**: BCa overcorrects for bounded statistics → Percentile primary
2. **Clinical calibration**: $\Delta_{\max} = 2L \cdot IQR \cdot nABCD$ — context-dependent, not fixed thresholds
3. **Estimation-centered**: No hypothesis testing in main text
4. **Power removed**: Simulation evaluates estimation quality (Bias, RMSE, Coverage, CI Width)
5. **S04 showcase**: S04 (0.5σ) is the primary showcase scenario
6. **S08 overcoverage**: Non-monotonic coverage pattern explicitly discussed
7. **LaTeX submission**: SiM accepts LaTeX directly — docx conversion不要 (Jessica ruling 2026-02-23)
8. **KL divergence**: Discussion段落で理論的説明。Simulation追加はR1 reserve (Meeting 2026-02-23)

---

## 📝 Active Tasks

| Task | Owner | Status |
|------|-------|--------|
| CSV検証 (S1-S8 × 3 = 24 rows) | Mike | ⏳ Sim完了待ち |
| S7/S8 true_nABCD確認 | Mike | ⏳ Sim完了待ち |
| Figure更新 (fig1,3,4,5) | Katrina/Mike | ⏳ Phase A後 |
| LaTeXシナリオ番号 S01→S1 更新 | Mike | ⏳ Phase B後 |
| S7/S8記述・数値テーブル追加 | Mike | ⏳ Phase B後 |
| Clinical calibration強化 | Mike | ✅ 完了 |
| スライド S7/S8 追加 | Katrina | ⏳ Phase C後 |
| DOI final check | Rachel | ⏳ Phase D後 |
| Louis internal review | Louis | ⏳ Phase D後 |
| Jessica final Go/No-Go | Jessica | ⏳ 最終 |
| **Clinical calibration概念図** | **Mike** | ✅ 完了 (3ファイル) |
| **Web Appendix: Worked Example** | **Katrina** | 🆕 Meeting決定 |
| **Worked Example — L推定文献補強** | **Rachel** | 🆕 Meeting決定 |
| **説明資料ドラフトレビュー** | **Louis** | 🆕 Meeting決定 |
| **Discussion: KL divergence段落追加** | **Mike** | 🆕 Meeting決定 |
| **Gibbs & Su (2002) 引用追加** | **Rachel** | 🆕 Meeting決定 |
| **KL段落 internal review** | **Louis** | 🆕 Meeting決定 |
| **TeXファイル merge conflict 解消 (2箇所)** | **Mike** | 🆕 緊急 |

---

## ⚠️ Issues

1. S05 coverage degradation (0.73 at n=200) — negative bias from bounded statistic
2. Scenario numbering gaps (S02, S07 missing) — deferred
3. KS comparison in simulation — deferred, Tak decision needed
4. **TeXファイル merge conflict** — Discussion section に `<<<<<<< HEAD` が2箇所残存（緊急）

---

## 📋 Paper Requests

*(None pending)*

---

## 🎬 Live Script

### [2026-02-23 11:15] Scene: Mike の概念図 — "I got it. 全体像を一枚で見せる。"

**INT. PEARSON SPECTER LITT - BULLPEN - DAY**

*Mike がデスクで3つのファイルを仕上げ、Harvey とKatrina に見せる。*

**Mike**: （画面を回して）
「"I got it." Clinical calibration の概念図、3ファイル作った：

**1. `fig_clinical_calibration_flow.mmd`** — メインフローチャート（Mermaid）
```
Step 0: Input (F₁, F₂)
  → Step 1: Compute nABCD = W₁ / (2 × IQR)  + Bootstrap CI
  → Step 2: Estimate CATE sensitivity L (from prior data)
  → Step 3: Δ_max = 2L × IQR × nABCD (Heterogeneity Bound)
  → Step 4: Compare vs clinical benchmarks (Tx effect, NI margin)
  → Step 5: Clinical Judgment
```
色分けで各ステップの情報源を区別。nABCD（青）、CATE sensitivity（橙）、calibration（緑）、interpretation（紫）。

**2. `fig_ranking_reversal.mmd`** — Ranking Reversal の概念図（Mermaid）
BMI（nABCD=0.51, Large → Δ_max=0.16%, Moderate）と HbA1c（nABCD=0.27, Moderate → Δ_max=0.24%, Highest）の **逆転** を視覚的に表現。L の違い（0.02 vs 0.30）が rankingを反転させることを一目で理解できる。

**3. `fig_clinical_calibration.drawio`** — 統合版（draw.io XML）
上記2つを1枚に統合。上半分がフローチャート、下半分がRanking Reversal。右側に "Why Wasserstein? (Kantorovich-Rubinstein)" と "Why NOT KL?" のアノテーション付き。」

**Katrina**: （確認して）
「"Results speak for themselves." プレゼンには Mermaid 版が使いやすい。Marp スライドに直接埋め込める。draw.io 版は投稿用の高解像度 figure 生成に使えるわ。」

**Harvey**: （頷いて）
「一目で伝わる。これがあれば "What is clinical calibration?" への答えが5秒で済む。"I don't have dreams, I have goals." — 次は Discussion の KL 段落だ。」

**Donna**: （記録して）
「Clinical calibration概念図タスク完了マーク。ファイルは全て `paper/slides/` に格納。」

---

### [2026-02-23 11:00] Scene: Meeting — KL Divergence との比較は必要か？

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Harvey がホワイトボードの前に立ち、チーム全員がテーブルを囲む。*

**Harvey**: （腕を組んで）
「単刀直入に言う。レビュワーから "Why not compare with KL divergence?" と聞かれるのは時間の問題だ。`simulation_design.md` にも元々 comparator として入っていた。今のうちに対策を決める。意見を聞かせろ。」

**Mike**: （ホワイトボードに立ち上がって書きながら）
「"I got it." まず技術的な整理をさせてくれ。KL divergence を comparator に入れ**なかった**のには明確な理由がある：

1. **非対称性** — $D_{KL}(P \| Q) \neq D_{KL}(Q \| P)$。Region A vs B と B vs A で値が変わる。MRCT の region comparison は本質的に対称であるべき。
2. **無限発散** — $Q(x) = 0$ かつ $P(x) > 0$ なら $D_{KL} = \infty$。empirical distribution 同士で普通に起きる。density estimation が必要になり bandwidth 選択という tuning parameter が増える。
3. **Lipschitz bound がない** — これが決定的。Wasserstein には Kantorovich-Rubinstein 双対定理があり、CATE function が Lipschitz continuous なら treatment effect の差を直接 bound できる。Proposition 2 の根拠。**KL にはこれがない**。つまり clinical calibration framework が成立しない。
4. **Pinsker 経由は遠回り** — TV → KL の変換は可能だが tightness が失われ、非対称性も残る。」

**Rachel**: （文献ノートを広げて）
「"Hard work beats talent when talent doesn't work hard." 文献的にも補強できるわ。

- **Villani (2008)** "Optimal Transport: Old and New" — Wasserstein が metric であり三角不等式を満たすのに対し、KL は metric ですらない。既に引用済み。
- **Gibbs & Su (2002)** "On Choosing and Bounding Probability Metrics" *International Statistical Review* DOI: [10.1111/1751-5823.00028](https://doi.org/10.1111/1751-5823.00028) — 確率距離の包括的比較。Wasserstein が weak convergence を metrize するという topological な利点を明確にしている。未引用。追加すべき。

問題は、Discussion に KL divergence への言及が**ゼロ**。」

**Louis**: （テーブルを叩いて）
「"You just got Litt up!" **レビュワーは必ず突いてくる**。"You compared against SMD and KS, both relatively simple. What about information-theoretic divergences?" — standard question だ。しかも `simulation_design.md` に "Comparator Metrics: Kullback-Leibler divergence" と書いてある。計画して落とした理由を問われるぞ。**先手を打つべきだ**。」

**Katrina**: （実務的に整理して）
「"Results speak for themselves." 選択肢：

| Option | 作業量 | 効果 |
|--------|--------|------|
| **A. Simulation に KL 追加** | 大（R code + 再実行 + 新Table/Figure） | 完璧だが投稿遅延 |
| **B. Discussion に理論的説明1段落追加** | 小（今日中） | 大半のレビュワーは納得 |
| **C. B + Supplementary に簡易比較** | 中 | バランス良い |

推奨は **Option B**。」

**Jessica**: （静かに、しかし決定的に）
「"Let me be clear." これは **preemptive defense** の問題。

**Option B を基本とし、必要に応じて C に escalate** する。理由：
1. 投稿を遅らせない — simulation 追加は scope creep
2. 理論的優位性は明確 — Mike の4点は KL の構造的限界であり simulation で示す必要がない
3. R1 対応の余地を残す — レビュワーが求めたらその時 simulation を追加する方が、要求に沿った形で応じられて効果的

ただし Discussion の記述は中途半端では逆効果。**なぜ KL ではなく Wasserstein なのか**を数学的に正確かつ簡潔に。」

**Harvey**: （決断して）
「Jessica の判断に同意する。**決定だ**：

1. **Mike** — Discussion に KL divergence 比較段落を追加。非対称性・無限発散・Lipschitz bound の不在を明記。
2. **Rachel** — Gibbs & Su (2002) の引用追加。
3. **Louis** — 追加段落の internal review。
4. **Simulation 追加は R1 reserve** — KL + Hellinger + TV はレビュワーが求めた時。

**もう一つ** — TeXファイルに git merge conflict markers が2箇所残っている（Discussion section, lines 583-587 と 606-610）。`<<<<<<< HEAD` が入ったまま投稿したら終わりだ。**即修正**。」

**Donna**: （記録完了）
「"I'm Donna. I know everything." Action items 全て記録。」

---

### [2026-02-23 10:50] Scene: Archive

**INT. PEARSON SPECTER LITT - FILE ROOM - DAY**

*Donna、分厚いフォルダをアーカイブ棚に移す。*

**Donna**: （ファイルを整理しながら）
「"I'm Donna. I know everything." SUITS.md が 1057 行を超えたからアーカイブしたわ。
`archives/SUITS_20260223_104500.md` に保存済み。
新しいスクリプト開始よ。」

**Harvey**: （通りがかりに）
「過去は過去だ。前を見ろ。"I don't have dreams, I have goals."」

---
