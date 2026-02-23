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
| **Worked Example (HbA1c Step1-5 + L 3パターン)** | **Katrina** | 🆕 説明Meeting決定 |
| **直感的説明スライド (アナロジー + Cohen's d)** | **Mike** | 🆕 説明Meeting決定 |
| **L推定文献補強 (Kim/Craddy/Jones DOI確認)** | **Rachel** | 🆕 説明Meeting決定 |
| **Web Appendix統合 (Worked Example + 説明)** | **Katrina + Rachel** | 🆕 説明Meeting決定 |
| **説明資料ドラフトレビュー** | **Louis** | 🆕 説明Meeting決定 |
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

### [2026-02-23 11:30] Scene: Meeting — Clinical Calibration の説明資料をどう作るか

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Harvey がホワイトボードに「Clinical Calibration = 翻訳装置」と書く。*

**Harvey**: （全員を見渡して）
「Clinical calibration は我々の論文の**核**だ。nABCD を臨床的な意味に翻訳する — この "翻訳" のプロセスをレビュワーに一発で理解させる説明資料が要る。Mike が概念図を作った。次は**何が足りないか**。意見を聞かせろ。」

**Mike**: （ホワイトボードに数式を書きながら）
「"I got it." まず、clinical calibration の本質を3行で整理する：

1. **nABCD は物差し** — 2つの分布がどれだけ違うかを測る。単位のない数字。
2. **L は変換係数** — effect modifier の "強さ"。BMI が1単位変わると治療効果がどれだけ動くか。
3. **Δ_max は臨床言語への翻訳** — $\Delta_{\max} = 2L \cdot \text{IQR} \cdot \text{nABCD}$。HbA1c何%の差として読める。

問題は、**L の意味が直感的に伝わらない**。概念図のフローは描いたが、"なぜ L を掛けると臨床的意味になるのか" の**直感的説明**がまだない。

提案として、**体温計のアナロジー**を使いたい：
- nABCD = 体温計の目盛り（37.5℃）
- L = その人の体質（同じ37.5℃でも、平熱36.0の人には高熱、平熱37.0の人には微熱）
- Δ_max = 「この人にとってどれくらい問題か」

つまり、同じ "測定値" でも**文脈**によって意味が変わる。それが clinical calibration。」

**Rachel**: （文献を引きながら）
「"Hard work beats talent when talent doesn't work hard." 説明資料に使える先行事例がある。

- **Armstrong & Kolesár (2021)** — Lipschitz constant を sensitivity parameter として使う framework。我々の L の使い方はこれに準拠。彼らの論文にも「Lの範囲を変えて結果を報告せよ」とある。
- **Cohen's d の教訓** — small/medium/large (0.2/0.5/0.8) の固定閾値が context-free に濫用された歴史。**我々が避けようとしている失敗**。

説明資料には「Cohen's d の二の舞を避ける」という文脈を入れるべき。これでレビュワーに "なぜ固定閾値ではダメなのか" が伝わる。」

**Katrina**: （実務的に整理して）
「"Results speak for themselves." 現在の資料ストックを整理する：

| 資料 | 状態 | 対象 |
|------|------|------|
| 概念図 flow (Mermaid) | ✅ Done | 全体像 |
| 概念図 ranking reversal (Mermaid) | ✅ Done | 逆転現象 |
| 概念図 統合版 (draw.io) | ✅ Done | 高解像度 |
| Marp スライド (Clinical Calibration) | ✅ 3枚あり | プレゼン |
| **Worked Example (計算過程)** | ❌ 未作成 | 手を動かす理解 |
| **直感的説明 (アナロジー)** | ❌ 未作成 | 非専門家向け |
| **"Why not thresholds?" 説明** | ❌ 未作成 | レビュワー対策 |
| **Web Appendix 完全版** | ❌ 未作成 | 投稿用 |

足りないのは3つ：
1. **Worked Example** — HbA1c の数値を使って、Step 1 から Step 5 まで手計算で追える資料
2. **直感的説明ページ** — アナロジーと "Cohen's d の教訓" を含むスライド1枚
3. **Web Appendix** — 上記2つを統合した投稿用の supplementary document」

**Louis**: （鋭く指摘して）
「"You just got Litt up!" 一つ重要な点がある。**L の推定がどれだけ信頼できるか**、これを誤魔化してはいけない。

Worked Example で L = 0.30 と書くのは簡単だが、レビュワーは必ず聞く：'Where does L come from? How robust is it?'

Sensitivity table は既にある（Table 7）。だが説明資料には**L の不確実性をどう扱うか**のガイダンスが要る：
- L が分かっている場合：点推定 + CI
- L が不確実な場合：感度分析（Lの範囲を変えた表）
- L が全く分からない場合：reference benchmarks をfallback として使用

この3パターンを明示しないと、"L が分からなければ Δ_max も計算できないじゃないか" という批判を受ける。」

**Jessica**: （最後に決定的に）
「"Let me be clear." 全員の意見を聞いた。整理する。

**説明資料の目的は2つ**：
1. **レビュワー向け** — 論文の Discussion + Web Appendix に入る
2. **プレゼン向け** — Marp スライドに追加

**作成すべきもの**：

**A. Worked Example ドキュメント** (Katrina担当)
- HbA1c, Japan vs US を題材に
- Step 1: nABCD = 0.27, CI = [0.20, 0.34]
- Step 2: L = 0.30 (from Craddy 2014, Jones 2016)
- Step 3: Δ_max = 2 × 0.30 × 1.5 × 0.27 = 0.24%
- Step 4: CI propagation → [0.18%, 0.31%]
- Step 5: vs treatment effect (-0.8%), vs NI margin (0.4%)
- **L 不確実性の3パターン** (Louis の指摘を反映)

**B. 直感的説明スライド** (Mike担当、1枚)
- アナロジー："nABCD は体温計、L は体質、Δ_max は診断"
- Cohen's d との対比："固定閾値の失敗を繰り返さない"

**C. Web Appendix Section** (Katrina + Rachel)
- A + B の内容をフォーマルに統合
- L 推定の文献根拠 (Rachel が補強)
- 投稿時に Supplementary Material として添付

以上。Harvey、進め方は？」

**Harvey**: （立ち上がって）
「Jessica の通りだ。**決定**：

1. **Katrina** — Worked Example ドキュメント作成。HbA1c の数値で Step 1-5 + L の3パターン。
2. **Mike** — 直感的説明スライド1枚。アナロジー + Cohen's d 対比。
3. **Rachel** — L 推定の文献根拠補強。Kim 2015, Craddy 2014, Jones 2016 の DOI と具体的数値を確認。
4. **Louis** — 完成後の説明資料レビュー。"L が分からない場合" の記述が十分か確認。

"I don't have dreams, I have goals." 各自、取りかかれ。」

**Donna**: （全て記録して）
「"I'm Donna. I know everything." 会議決定事項、全て記録完了。」

---

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
