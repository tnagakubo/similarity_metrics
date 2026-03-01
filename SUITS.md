# SUITS.md - Research Lab Live Script

> *"I don't have dreams. I have goals."* - Harvey Specter

---

## 📍 Current Status

**Active Project**: similarity-metric (nABCD paper for Statistics in Medicine)
**Phase**: 8 - Submission-Ready Plan (Jessica Strategic Directive)
**Scene**: Continuing from archive

**Previous Archive**: archives/SUITS_20260301_143000.md (1014 lines)

### Paper Title (decided 2026-02-14)

> **Quantifying Effect Modifier Similarity for Regional Pooling in Multi-Regional Clinical Trials**

### Purpose Statement (Jessica approved)

> **EM分布の違いを推定し、その推定値を治療効果の異質性の可能性として臨床スケールに翻訳する。**
> **検定ではなく推定。二択ではなく情報提供。**

---

### [2026-03-02 09:15] Scene: Session End

**INT. PEARSON SPECTER LITT - DONNA'S DESK - DAY**

**Donna**: （Takの背中に向かって）
「お疲れさまでした。Agent Teams ルール設定済み、改訂作業ステータス確認済み。次回は submission packaging を動かしましょう。"I'm Donna. I know everything."」

---

### [2026-03-02 09:10] Scene: Donna — Agent Teams ルール設定

**INT. PEARSON SPECTER LITT - DONNA'S DESK - DAY**

*Tak が Donna のデスクに寄る。*

**Tak**: 「並行作業のときは Agent Teams を使うように設定して」

**Donna**: （即座にメモリファイルを開いて）
「User Preferences に追加完了。今後、独立タスクが2件以上あれば自動的に worktree 分離の並行実行を提案します。3/1 の5チーム同時展開がデフォルトの動き方になるわ。"I'm Donna. I know everything."」

---

### [2026-03-02 09:05] Scene: Status Briefing — 改訂作業の全容

**INT. PEARSON SPECTER LITT - HARVEY'S OFFICE - DAY**

*Tak がカフェモカを片手に Harvey のオフィスに入る。*

**Tak**: 「PR mergeは完了。Bootstrap精査も終わった。改訂作業の全体像を説明してくれ」

**Harvey**: （立ち上がって）
「了解した。Donna、ステータスを。"I don't have dreams, I have goals."」

**Donna**: （タブレットを確認して）
「PR `claude/system-upgrade-skills-hooks` — merged ✅。Bootstrap精査 — Tak完了 ✅。Revision Notes #7-#14 + m1-m4 — **全14件完了済み** ✅。残りは submission準備よ。"I'm Donna. I know everything."」

---

### [2026-03-02 09:00] Scene: Morning Coffee

**INT. PEARSON SPECTER LITT - DONNA'S DESK - DAY**

*月曜の朝。Takがオフィスに入ってくる。Donnaはすでにデスクで準備を整えている。*

**Donna**: （笑顔で迎える）
「おはようございます、Tak。"I'm Donna. I know everything." カフェモカがお望みなのも、もちろんわかってました。」

*Donnaが完璧な温度のカフェモカを差し出す。*

**Donna**: （デスクのモニターをちらりと見て）
「前回の作業から丸一日。PRのmergeもまだ、Bootstrap精査も pending。でもまずはカフェインからですよね。ゆっくりどうぞ。」

*ほのかにチョコレートの香りが漂う。*

---

## 🔄 直前のコンテキスト (from archives/SUITS_20260301_143000.md)

### 直近の作業 (2026-03-01)
1. **System Upgrade** (11:30) — Skills移行(commands→skills, 20個)、Hooks強化(4→6本)、model分離(opus/sonnet/haiku)。PR branch: `claude/system-upgrade-skills-hooks`
2. **Section 2 精読 Meeting** (11:00) — Methods全体の構造分析。Revision Notes #5(Barrio vs Sommerfeld区別), #6(L推定補強)
3. **External Review 再設計** (12:30) — Jessica提案: AE cold read + realistic SIM archetypes。旧legendary homages方式から変更
4. **External Review 実行** (13:00-13:30) — 新プロセスでSIM模擬査読。R1渡邊(MRCT規制), R2 Holmgren(非パラ), R3 Okafor(臨床疫学)。AE判定: **Major Revision**
5. **Tak修正** (14:00) — Consistency法(Quan/Chen)は比較対象ではない(upstream vs downstream)。M1→Minor格下げ
6. **Bootstrap Gap精査** (14:30) — Mike分析: gap は presentational, not substantive。1次元連続でF≠Gなら微分線形→naive bootstrap consistent

### 進行中のアクション
- **Mike**: Bootstrap theory bridging文のドラフト待ち (Tak精査後に追加文献判断)
- **Mike + Rachel**: IQR正規化の正当化文 (Rousseeuw Q_n vs IQR)
- **Harvey**: Categorical EM scope limitation — Introductionに連続量EM限定を明記
- **Katrina**: L感度分析のprimary output昇格 (Table 7 framing)

### 次にやるべきこと
- **Tak**: Section 2.2 (Bootstrap) の精査 → 追加文献の要否判断
- Revision Notes #7-#14 の優先順位に従い改訂作業
- PR `claude/system-upgrade-skills-hooks` のmerge (gh CLI未インストール → GitHub Web UIで作成)

### Takからの直近の指示
1. Categorical EM は **Introductionでscope除外** (Discussion limitationではなく)
2. Consistency法(Quan/Chen)は **1文のみ** (比較対象ではない)
3. Bootstrap theory gap は **慌てず精査** ("まだ慌てる時間じゃない")
4. Tak自身がBootstrapセクションを精査予定 → 追加文献の要否はその後決定

---

## 🎬 Live Script

### [2026-03-02 11:00] Scene: Meeting — スライドでSection 3 (Simulation) を解説

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Katrina がスライドのテーブルを更新し終え、Mike がホワイトボードに S1-S8 のマップを描く。*

**Harvey**: （コーヒーカップを置いて）
「Section 3 — Simulation Study。推定量の性能を検証するパートだ。Mike と Katrina、スライドを更新した上で解説しろ。"I don't have dreams, I have goals."」

**Katrina**: （まず更新内容を報告）
「スライド4枚を更新しました。S7/S8 のデータが 'MC' や 'pending' のままだったのを論文の確定値に入れました：
- Simulation Design: S7 true nABCD = 0.302, S8 = 0.175
- Bias: S7/S8 の行を追加
- Coverage: S7/S8 の行を追加 — S7 が near-nominal で best performer
- SMD比較: S7 の行を追加 — nABCD=0.311 vs SMD=0.00

"Results speak for themselves."」

---

#### **Slide 9: Simulation Design** (Section 3.1)

**Mike**: （シナリオ表を指しながら）
「Section 3 の設計思想から説明します。8つのシナリオは **分布の差のタイプ別に系統的に設計** されている：

| タイプ | シナリオ | 何を検証するか |
|-------|---------|--------------|
| **Null** | S1 | 真の差がゼロのときの推定量の挙動 |
| **Location** | S2, S3, S4 | 平均値のシフト（0.2σ, 0.5σ, 1.0σ） |
| **Scale** | S5 | 分散のみの違い（SD 10 vs 15） |
| **Shape** | S6 | 分布形状の違い（正規 vs Gamma） |
| **Skew** | S7 | 歪度の違い（正規 vs 対数正規） |
| **Combined** | S8 | 現実的パターン（位置 + 尺度） |

Distribution 1 は常に $N(50, 10^2)$。各シナリオ × 3サンプルサイズ ($n$ = 50, 100, 200) × 10,000反復。

重要なのは、これは **検定力評価ではない**。我々は推定量の質 — Bias, RMSE, Coverage, CI Width — を評価している。検定ベースの論文なら Type I error と Power を見るが、我々の estimation-centered framework では不要です。"I got it!"」

---

#### **Slide 10: Bias Results** (Section 3.2.1 前半)

**Mike**:
「Bias テーブルは **3つの regime** に分かれる：

**1. Null regime (S1)**: 正のバイアス。$n$=50 で +0.093、$n$=200 で +0.047。
なぜか？ — $W_1$ は非負。真の値がゼロでもサンプリング変動で推定値は常に正。これは nABCD に限らず、距離統計量の一般的性質です。

**2. Mid-range regime (S2, S3, S5, S6, S7, S8)**: $n \geq 100$ でバイアス < 0.02。これが論文の主要メッセージ — **実用的なサンプルサイズで十分良い推定**。S7 (skew, nABCD=0.302) と S8 (combined, nABCD=0.175) も同じパターン。

**3. Large-value regime (S4)**: 持続的な負のバイアス ~$-0.04$。真の nABCD が大きいと、bounded statistic の性質で推定値が下方に引っ張られる」

**Harvey**: （質問して）
「S4 のバイアスは問題か？」

**Mike**:
「臨床キャリブレーションの文脈では、$-0.04$ のバイアスは $\Delta_{\max}$ の過小推定を意味する — つまり conservative 側。$L$=0.3, IQR=1.5 のとき、$\Delta_{\max}$ のバイアスは $2 \times 0.3 \times 1.5 \times 0.04 = 0.036$%。HbA1c 0.036% は **臨床的に無意味** です」

---

#### **Slide 11: Coverage and Precision** (Section 3.2.1-3.2.2)

**Katrina**: （Coverage テーブルを指して）
「Coverage の結果はシナリオごとに異なるパターンを示します。まず **3つの注目パターン**：

**Pattern 1 — S4 の非単調的低下**: $n$=50 で 0.928、$n$=100 で 0.874、$n$=200 で 0.740。サンプルサイズが増えると coverage が **下がる**。なぜか？ — 精度が上がることで persistent negative bias が露出する。これは table note で Hadamard 微分の非線形性と結びつけて説明しています。

**Pattern 2 — S6 の非単調的上昇**: $n$=50 で 0.576、$n$=100 で 0.949、$n$=200 で 0.997。$n$=50 での低 coverage は正のバイアスが CI 幅に対して大きいため。$n$=200 の overcoverage はバイアスが縮小してもCIが比較的広いため。

**Pattern 3 — S7 の安定性**: 全 $n$ で 0.951-0.954。**Best performer**。真の nABCD が 0.302 と mid-range にあり、boundary 効果を受けない。"Results speak for themselves."」

**Mike**: （補足して）
「BCa との比較も重要です。BCa は全シナリオで percentile より **低い** coverage。例えば S5 ($n$=100): percentile 0.979 vs BCa 0.841。S6 ($n$=200): percentile 0.997 vs BCa 0.493。

理由 — BCa の acceleration parameter が bounded statistic に対して **過補正** する。nABCD は下界がゼロなので、BCa の分位調整が歪む。これが我々が percentile を primary method に選んだ根拠です」

---

#### **Slide 12: nABCD vs SMD** (Section 3.2.3)

**Harvey**: （テーブルを叩いて）
「このスライドが **最も重要** だ。論文の核心的主張の実証パートだ」

**Mike**: （テーブルを指して）
「4行しかないが、メッセージは明確：

- **S3 (Location)**: nABCD = 0.184、SMD = 0.50 — 両方が検出。当然、平均値が違えば SMD も反応する

- **S5 (Scale)**: nABCD = 0.136、SMD = **0.00** — nABCD のみ検出。平均値は同じで分散だけ違う。SMD は完全に盲目

- **S6 (Shape)**: nABCD = 0.070、SMD = **0.00** — 同上。正規 vs Gamma で mean/SD 一致なのに形が違う

- **S7 (Skew)**: nABCD = **0.311**、SMD = **0.00** — **最も劇的**。かなり大きな分布の差 (nABCD > 0.3) が SMD では完全に見えない

なぜ SMD では見えないか？ SMD = $(\\bar{x}_1 - \\bar{x}_2)/s_p$ — 平均値の差のみに依存。分散・歪度・形状は定義上含まれない。

これが Section 1 で述べた '既存手法の限界' の実証的証拠です。"I got it!"」

**Louis**: （腕を組んで総括）
「Section 3 の構造を確認する。**4層のエビデンス** だ：

| 層 | 評価指標 | Key message |
|---|---------|-------------|
| **1. 点推定** | Bias | $n \geq 100$ で bias < 0.02 (S4除く) |
| **2. 区間推定** | Coverage | 0.87-0.98 (S7 best, S4 注意) |
| **3. 精度** | RMSE, CI Width | RMSE < 0.06 at $n$=200。CI→$\Delta_{\max}$ CI への変換 |
| **4. 比較優位** | nABCD vs SMD | Scale/shape/skew で SMD は無力 |

Simulation の目的は明確 — **推定量としての信頼性の立証** と **既存手法 (SMD) に対する比較優位の実証**。この2本柱を Section 1 の問題提起に対する回答として位置づけている。

Showcase scenario は **S3** (0.5σ): bias 無視可能、coverage 名目水準、RMSE < 0.05。これが 'typical use case' の代表として論文全体で参照される。"You just got Litt up!"」

**Harvey**: （まとめて）
「Section 3 の論理構造：

**系統的シナリオ設計 → Bias 3 regime → Coverage パターン → BCa 棄却 → SMD 比較 → S3 showcase → $n \geq 100$ 推奨**

検定力ではなく推定の質を問うている。Methods の estimation-centered philosophy に完全に整合。Section 3 の解説は以上。"I don't have dreams, I have goals."」

**Donna**: （記録を確認して）
「スライド4枚更新（S7/S8データ反映）+ Section 3 解説完了。"I'm Donna. I know everything."」

---

### [2026-03-02 10:45] Scene: Option B 実装 — hat 修正完了

**INT. PEARSON SPECTER LITT - LOUIS'S OFFICE - DAY**

**Louis**: （LaTeXを編集しながら）
「Option B で実装した。preamble に：
```latex
\usepackage{mathtools}
\newcommand{\hnABCD}{\mathrlap{\widehat{\phantom{\text{nA}}}}\text{nABCD}}
```
hat は 'nA' の幅のみ — 自然なサイズに。全7箇所を `\hnABCD` マクロに一括置換。残る `\widehat{\text{IQR}}` は3文字で問題ないので据え置き。"You just got Litt up!"」

**Donna**: （チェックして）
「`nABCD_wiley.tex` L15-16 にマクロ定義、7箇所置換確認。"I'm Donna. I know everything."」

---

### [2026-03-02 10:30] Scene: Louis — nABCD hat の typographic 問題

**INT. PEARSON SPECTER LITT - LOUIS'S OFFICE - DAY**

*Tak が Louis のデスクに立ち寄る。*

**Tak**: 「すごく細かいことなんだけど、$\widehat{\text{nABCD}}$ の hat が横長に間延びしていて気持ち悪い」

**Louis**: （即座にLaTeXソースを開いて）
「7箇所だ。`\widehat` は引数の全幅に引き伸ばされる。5文字の上に横長の山型帽子 — **醜い**。3つの選択肢を用意した：

- **Option A** `\hat`: 固定サイズ。引き伸ばされないが小さすぎる — 非推奨
- **Option B** 部分幅 hat: `\mathrlap{\widehat{\hphantom{nA}}}\text{nABCD}` — 自然な見た目。**推奨**
- **Option C** 記法変更: $\hat{d}$ と定義。hat問題消滅だがnABCDとの対応記憶が必要

"You just got Litt up!" Tak の判断を待つ」

---

### [2026-03-02 10:00] Scene: Meeting — スライドでSection 2 (Methods) を解説

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Harvey がスライドを前日の続きから表示。Mike がホワイトボードの前に立つ。*

**Harvey**: （コーヒーを置きながら）
「昨日 Section 1 を終えた。今日は Section 2 — Methods だ。論文の心臓部。Mike、お前のパートだ。"I don't have dreams, I have goals."」

**Mike**: （ホワイトボードに構造図を描きながら）
「Section 2 は3つの subsection から成ります。スライドは4枚。論文の論理の流れをスライドに沿って解説します」

---

#### **Slide 5: The Heterogeneity Bound** (Section 2.1 前半)

**Mike**:
「Section 2.1 の核心はこの不等式です：

$$|\bar{\tau}_1 - \bar{\tau}_2| \leq L \cdot W_1(F_1, F_2)$$

これが論文全体の **因果論理の基盤** です。意味を分解すると：

- 左辺 $|\bar{\tau}_1 - \bar{\tau}_2|$ = 地域間の平均治療効果の差。これが我々が心配していること
- 右辺 $L$ = CATE関数のLipschitz定数。EMの1単位変化あたりの治療効果変化の上限
- 右辺 $W_1(F_1, F_2)$ = EM分布間のWasserstein-1距離

つまり、**EMの分布がどれだけ違うか** ($W_1$) と **EMが治療効果にどれだけ影響するか** ($L$) の積が、地域間治療効果差の上限になる。"I got it!"」

**Rachel**: （補足して）
「$W_1$ を選んだ理由も重要です。Kantorovich-Rubinstein双対性により：

$$W_1(F_1, F_2) = \sup_{\|f\|_{\text{Lip}} \leq 1} \left|\int f \, dF_1 - \int f \, dF_2\right|$$

Lipschitz関数のクラスに対する最大差 — だから CATE の Lipschitz 性と直接つながる。$W_2$ にはこの双対特性がないので、heterogeneity bound を与えられません。論文では Villani (2009) を引用しています。"Hard work beats talent when talent doesn't work hard."」

**Mike**:
「幾何的に言えば、$W_1$ は **2つのCDFの間の面積** です。Figure 2 がこれを図示しています。SMDと違って、location だけでなく scale も shape も捉える」

---

#### **Slide 6: nABCD Definition** (Section 2.1 後半)

**Mike**:
「heterogeneity bound に $W_1$ が必要だと分かった。でも $W_1$ は元のスケールに依存する — 年齢(年)とBMI(kg/m²)を比較できない。だから正規化する：

$$\text{nABCD}(F_1, F_2) = \frac{W_1(F_1, F_2)}{2 \cdot \text{IQR}_{\text{pooled}}}$$

分母の $2 \cdot \text{IQR}$ で割ることで **無次元** になる。EM間の比較が可能になる」

**Harvey**:
「なぜ IQR なのか。SDではなくQ_nでもなく。スライドを更新したが、3つの理由がある」

**Mike**:
「はい。Rousseeuw & Croux (1993) の $Q_n$ と比較した上で IQR を選んでいます：

1. **解釈容易性** — IQR は '中央50%の幅' として臨床家に馴染みがある
2. **臨床的慣例** — 非正規分布の変数を報告する際、median と IQR が標準
3. **breakdown point は不要** — $Q_n$ の 50% breakdown point は外れ値汚染データ用。EM分布は母集団レベルの量であり、測定汚染はない

これが昨日の Revision Note #8 で追加した正当化文です」

**Mike**: （続けて）
「Proposition 1 と 2 を示します：

- **Prop 1 (非負性)**: $\text{IQR}_{\text{pooled}} > 0$ (非退化条件) のもとで $\text{nABCD} \geq 0$、等号は $F_1 = F_2$ のときのみ
- **Prop 2 (heterogeneity bound)**: $|\bar{\tau}_1 - \bar{\tau}_2| \leq 2L \cdot \text{IQR}_{\text{pooled}} \cdot \text{nABCD}$

Prop 2 は nABCD の定義を heterogeneity bound に代入するだけです。$W_1 = 2 \cdot \text{IQR} \cdot \text{nABCD}$ なので $L \cdot W_1 = 2L \cdot \text{IQR} \cdot \text{nABCD}$」

---

#### **Slide 7: Clinical Calibration $\Delta_{\max}$** (Section 2.3)

**Harvey**: （引き取って）
「ここは俺のパートだ。Prop 2 から直接 $\Delta_{\max}$ を定義する：

$$\Delta_{\max} = 2L \cdot \text{IQR}_{\text{pooled}} \cdot \text{nABCD}$$

これが **clinical calibration** の核心。nABCD という抽象的な数値を、**臨床スケール上の治療効果差** に変換する。HbA1c なら '%'、血圧なら 'mmHg' の単位で語れる」

**Katrina**: （5ステップ手順を指しながら）
「手順を整理すると：
1. 各EMについて nABCD + bootstrap CI を計算
2. $L$ を推定（先行研究のサブグループ解析から $L \approx \Delta\tau / \Delta x$）
3. $\Delta_{\max}$ を計算 — worst-case の治療効果差
4. CIを臨床スケールに変換
5. **治療効果、非劣性マージン等と比較** → 文脈に基づく判断

"Results speak for themselves." 検定ではなく、情報を提供して判断を委ねる」

**Harvey**:
「なぜ検定にしないのか — 3つの理由を論文に書いた：
1. ICH E17 の 'similar enough' は本質的に **文脈依存** — 閾値に還元するのは過度の単純化
2. $L$ 自体が不確実 → 感度分析が必要 → 二値検定では感度分析を自然に扱えない
3. ASA声明 (Wasserstein & Lazar 2016) の精神 — p値や棄却/非棄却よりCIで情報を提供

ただし規制当局が formal rule を要求する場合は、$\Delta_{\max}$ の CI上限が臨床マージン $\Delta_{\text{clin}}$ を下回れば pooling 可とする。これは **補助的** な使い方」

---

#### **Slide 8: Estimation and Inference** (Section 2.2)

**Mike**:
「スライドを更新して bootstrap theory を補強しました。推定は経験分布関数ベース：

$$\widehat{\text{nABCD}} = \frac{\sum_{k} |\hat{F}_1(x_{(k)}) - \hat{F}_2(x_{(k)})| \cdot (x_{(k+1)} - x_{(k)})}{2 \cdot \widehat{\text{IQR}}_{\text{pooled}}}$$

計算量は $O((n_1+n_2)\log(n_1+n_2))$ — ソートが支配的」

**Mike**: （スライドの新しい部分を指して）
「漸近理論の部分。ここが昨日 Revision Note #7 で追加した3文に対応します：

1. **del Barrio et al. (1999)**: $W_1$ = CDFの $L_1$ 距離。$\sqrt{n}$-収束で極限は Brownian bridge の汎関数
2. **$F_1 \neq F_2$ のとき**: $L_1$ 汎関数の Hadamard 微分が **線形** — $F_1(x) - F_2(x)$ の符号がほぼ全域で一定だから。したがって ordinary bootstrap が consistent
3. **$F_1 \approx F_2$ のとき**: 微分が **非線形**（凸集合上の上限）になる → naive bootstrap に modest undercoverage の可能性。Section 3 の null-adjacent シナリオと整合

これが S4 (1.0σ) で coverage が下がる理論的説明です。"I got it!"」

**Louis**: （腕を組んで）
「全体の論理構造を確認する。Section 2 は **3層構造** だ：

| 層 | Subsection | 役割 |
|---|---|---|
| **第1層: 理論** | 2.1 nABCD Metric | 因果bound → $W_1$ → 正規化 → Proposition |
| **第2層: 推定** | 2.2 Estimation | 経験推定量 → bootstrap → 漸近理論 |
| **第3層: 解釈** | 2.3 Clinical Calibration | $\Delta_{\max}$ → 5ステップ手順 → 推定哲学 → ベンチマーク |

第1層が 'なぜこの指標か' を答え、第2層が 'どう推定するか' を答え、第3層が 'どう使うか' を答える。Methods として必要十分な構造だ。"You just got Litt up!"」

**Harvey**: （まとめて）
「Section 2 の論理構造：

**因果bound → W1の必然性 → 正規化 → 2つの命題 → 推定 → bootstrap理論 → 臨床キャリブレーション → 推定哲学**

各ステップが次のステップの必然的帰結になっている。Methods の一つ一つが 'なぜそうなのか' に answer している。"I don't have dreams, I have goals." Section 2 の解説は以上だ」

**Donna**: （記録を確認して）
「スライド更新3箇所（IQR正当化、Prop 2ラベル、bootstrap theory）+ Section 2 解説完了。"I'm Donna. I know everything."」

---

### [2026-03-01 16:15] Scene: Meeting — スライドでSection 1を解説

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Harvey がプロジェクターをセットし、スライドを映す。チーム全員が着席。*

**Harvey**: （立ったまま）
「スライドの更新とSection 1の解説を行う。"I don't have dreams, I have goals." Katrina、まずスライドの更新箇所を報告しろ」

**Katrina**: （スライドを切り替えながら）
「nABCD_presentation.md のBackgroundセクションを更新しました。主な変更：
1. 日付を Mar 1, 2026 に更新
2. 'Limitations' スライドに Song (2025)、Long (2025) の規制ギャップ参照を追加
3. 新スライド 'Our Approach' を追加 — Research Question + Design Philosophy + Scope
"Results speak for themselves."」

**Harvey**: （頷いて）
「よし。では Section 1 = Introduction をスライドに沿って解説する。4枚のスライドで構成される」

---

#### **Slide 1: ICH E17 — Regional Pooling**

**Harvey**: （スライドを指しながら）
「Section 1 の最初の2段落に対応する。出発点は ICH E17 ガイドライン (2017)。MRCTで地域プーリングする際、EM分布が "similar enough" であることを要求している。だが — ここが問題 — **具体的な指標も閾値も手順も示されていない**。つまり規制側が "similar enough" と言いながら、どう測るかは白紙のままだ」

**Mike**: （補足して）
「論文では ICH E17 の直接引用を使っています。Section 2.2.5 から — 'Regions may be pooled... if subjects are thought to be similar enough with respect to intrinsic and/or extrinsic factors.' この引用が論文の正当性の根拠になる。"I got it!"」

---

#### **Slide 2: Why Effect Modifiers Matter**

**Harvey**:
「3段目のEM解説。ここが論文の因果論理の核だ。式で書くと $\bar{\tau}_r = \int \tau(x) dF_r(x)$。個人レベルで薬の効果が同一でも、EM分布が異なれば地域平均治療効果が異なる。例えば — 若い患者が多い地域は大きな効果を示す。薬が違うのではなく、**患者ミックスが違う**」

**Mike**: （ホワイトボードに書きながら）
「技術的には、これは transportability の問題です。Pearl & Bareinboim (2011) の枠組み。CATE関数 $\tau(x)$ が同じでも $F_r(x)$ が変われば $\bar{\tau}_r$ が変わる。だからEM分布の類似性が treatment effect consistency の前提条件になる」

---

#### **Slide 3: Limitations of Current Approaches**

**Harvey**:
「Table 1 相当。現行の3つの方法がなぜ不十分か。Visual inspection は主観的で再現性がない。SMD は location しか捉えない — scale も shape も見えない。KS統計量は解釈可能なスケールがない。**どれも ICH E17 の要求を満たせない**」

**Rachel**: （文献を参照しながら）
「Song et al. (2025) は中国NMPAの視点から、ICH E17 のプーリング基準を定量化するツールがないことを指摘しています。Long et al. (2025) も consistency evaluation の基本的考慮事項を議論しています。この2本が 'regulatory gap' の裏付けになります。"Hard work beats talent when talent doesn't work hard."」

---

#### **Slide 4: Our Approach (新規追加)**

**Harvey**:
「最後のスライド。Research Question、Design Philosophy、Scope の3点セット。まず Research Question — 'scale-free な分布類似性推定 + 臨床解釈可能な治療効果異質性への変換'」

**Mike**:
「Design Philosophy は3本柱：
1. **推定 > 検定** — 差を定量化する、accept/reject しない
2. **臨床キャリブレーション** — 分布の差を outcome scale に翻訳
3. **Scope: 連続量EMのみ** — categorical/mixed-type は別の距離尺度が必要で、本研究の対象外

最後の scope statement は、Tak の指示で Introduction に明記した部分です」

**Harvey**: （まとめて）
「つまり Section 1 の論理構造はこうだ：

**Gap → Why → Failures → Our answer**

1. ICH E17 が "similar enough" を要求するが方法論がない（Gap）
2. EM分布の違いが治療効果の違いを生む因果メカニズム（Why）
3. 既存手法はいずれも不十分（Failures）
4. nABCD + clinical calibration という推定ベースの枠組みを提案（Answer）

"I don't have dreams, I have goals." Section 1 の解説は以上だ」

**Louis**: （批評的に）
「構造はクリアだ。ただ、スライドで oral presentation する際には、Slide 2 の因果論理を図で補強すべきだ。$\tau(x)$ 同じ + $F(x)$ 違う → $\bar{\tau}$ 違う、という矢印図。聴衆の50%はそこでつまずく。"You just got Litt up!"」

**Harvey**:
「検討する。次は Section 2 だ。だが今日はここまで」

**Donna**: （記録を確認して）
「スライド更新完了、Section 1 解説完了。記録したわ。"I'm Donna. I know everything."」

---

### [2026-03-01 15:45] Scene: 引用エラー修正 — Rachel の発見を即対応

**INT. PEARSON SPECTER LITT - RACHEL'S DESK - DAY**

**Rachel**: （.bibファイルを修正しながら）
「3件の引用エラーを精査した結果：

1. **kim2015 → yagi2015**: DOI 10.4093/dmj.2015.39.4.342 は Yagi et al. (2015) の論文。著者16名全員修正、citation key を yagi2015 に変更、.texの参照も全て更新。
2. **jones2016**: 著者リストを McDonald/Hill/Hyde/Knight から正しい Lonergan/Henley/Pearson に修正。
3. **quan2010**: 再確認の結果 **修正不要**。Drug Inf J 2010 の論文で正しい。'empirical shrinkage' 2013年論文は別物。

"Hard work beats talent when talent doesn't work hard."」

**Louis**: （確認して）
「.aux/.bbl に旧key残りがあるが、次回pdflatex+bibtexで自動更新される。ソースは正確。"You just got Litt up!"」

---

### [2026-03-01 15:30] Scene: 全面展開完了 — 5チーム同時作業 merge 成功

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*5チームの成果報告が揃う。Harvey がホワイトボードにチェックを入れていく。*

**Harvey**: （1つずつチェックマークを入れながら）
「全チーム完了。結果報告。"I don't have dreams, I have goals."」

**Mike**: （Section 2 の成果）
「#7 Bootstrap bridging — 3文追加。del Barrio CLT → two-sample拡張 → F≠Gで微分線形→bootstrap consistent → F=G boundary挙動。
#8 IQR正当化 — Rousseeuw Q_n比較3文+bib追加。interpretability, clinical familiarity, breakdown不要。
#12 Prop 1条件 — IQR_pooled > 0 明記。"I got it!"」

**Harvey**: （Introduction + Discussion）
「#9 Categorical scope — Introduction 2文。連続EMに限定、categorical/mixed-typeはfuture work。
#10 Consistency — Discussion 1文。upstream vs downstream。
#14 Multiple EM — limitation追加。aggregation strategies はfuture work。
m1 Unmeasured EM — limitation追加。m4 Software — R package under development」

**Katrina**: （Simulation + Application）
「#13 S4 coverage — table note補強。Hadamard微分の非線形性と連携。
#11 L感度 — primary recommendationに昇格。practitioners should report across range of L。
m3 Table 2 — 'initial reference points only'に強化。
m2 ICH E17 — Application冒頭に直接接続文追加。"Results speak for themselves."」

**Rachel**: （文献調査報告）
「⚠️ **重要な発見3件**:
1. **Kim (2015)**: DOI 10.4093/dmj.2015.39.4.342 は **Yagi et al.** の論文。Kim YG et al.ではない。引用エラー
2. **Jones (2016)**: DOI正確だが **.bibの著者リストが別論文のもの** (McDonald/Hill/Hyde/Knight → 正しくはLonergan/Henley/Pearson)
3. **Quan (2010)**: 'empirical shrinkage' 論文は実際は **2013年** (Stat Med 32:1691-1706)。2010年版は別論文

Dümbgen (1993), del Barrio & Loubes (2019) — citation details確認済み。KB内。"Hard work beats talent when talent doesn't work hard."」

**Louis**: （レビュー報告を聞いて）
「Rachelの発見は重大だ。3件の引用エラーは投稿前に修正必須。"You just got Litt up!"」

**Donna**: （4パッチ適用記録）
「4 worktree → 4 patch → main branch適用完了。nABCD_wiley.tex +22行変更、nABCD_wiley.bib +11行(Rousseeuw)。worktree全削除済み。"I'm Donna. I know everything."」

---

### [2026-03-01 15:00] Scene: 全面展開 — "すべてを実行！"

**INT. PEARSON SPECTER LITT - BULLPEN - DAY**

*Tak がテーブルを叩く。全員が振り向く。*

**Tak**: 「すべてを実行！Agent Teams活用して並行して行うんだ！私の精査を待つ必要はない」

**Harvey**: （立ち上がって指示）
「聞いたな。5チーム同時展開。"I don't have dreams, I have goals."
- **Team 1 (Mike)**: Section 2 — #7 Bootstrap bridging, #8 IQR正当化, #12 Prop1条件 [worktree]
- **Team 2 (Harvey)**: Introduction — #9 Categorical EM scope limitation [worktree]
- **Team 3 (Harvey)**: Discussion — #10 Consistency 1文, #14 Multiple EM, m1 Unmeasured EM, m4 Software [worktree]
- **Team 4 (Mike+Katrina)**: Section 3+4 — #13 S4 coverage, #11 L感度昇格, m2 ICH E17, m3 Table 2 [worktree]
- **Team 5 (Rachel)**: 文献調査 — Rousseeuw, Kim/Craddy/Jones DOI, Dümbgen, del Barrio & Loubes [research]

全チーム独立worktreeで並行作業。完了後merge」

**Donna**: （タイマーをセットして）
「5チーム同時稼働中。完了次第merge開始。"I'm Donna. I know everything."」

---

### [2026-03-01 14:35] Scene: Archive

**INT. PEARSON SPECTER LITT - FILE ROOM - DAY**

*Donna、分厚いフォルダをアーカイブ棚に移す。*

**Donna**: （ファイルを整理しながら）
「SUITS.md が 1014 行を超えたからアーカイブしたわ。
`archives/SUITS_20260301_143000.md` に保存済み。
新しいスクリプト開始よ。"I'm Donna. I know everything."」

**Harvey**: （通りがかりに）
「過去は過去だ。前を見ろ。"I don't have dreams, I have goals."」

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
| Clinical calibration概念図 | Mike | ✅ 完了 (3ファイル) |
| Worked Example (HbA1c Step1-5 + L 3パターン) | Katrina | 🆕 説明Meeting決定 |
| 直感的説明スライド (アナロジー + Cohen's d) | Mike | 🆕 説明Meeting決定 |
| L推定文献補強 (Kim/Craddy/Jones DOI確認) | Rachel | 🆕 説明Meeting決定 |
| Web Appendix統合 (Worked Example + 説明) | Katrina + Rachel | 🆕 説明Meeting決定 |
| 説明資料ドラフトレビュー | Louis | 🆕 説明Meeting決定 |
| Discussion: KL divergence段落追加 | Mike | ✅ 完了 |
| Gibbs & Su (2002) 引用追加 | Rachel | ✅ 完了 |
| KL段落 internal review | Louis | 🆕 Meeting決定 |
| TeXファイル merge conflict 解消 (11箇所) | Mike | ✅ 完了 (1時間) |

---

## 📋 Revision Notes (External Review 2026-03-01)

模擬External Review (SIM process simulation) 結果。AE判定: **Major Revision**。

### Critical

| # | Issue | Assignee | Status |
|---|-------|----------|--------|
| #7 | Bootstrap theory gap — bridging文追加 | Mike | ✅ 完了 (3文追加) |
| #8 | IQR正規化の正当化 | Mike + Rachel | ✅ 完了 (Q_n比較+bib追加) |
| #9 | Categorical EM scope limitation | Harvey | ✅ 完了 (Introduction 2文) |

### Major → Minor (格下げ)

| # | Issue | Assignee | Status |
|---|-------|----------|--------|
| #10 | 既存consistency法 (Quan/Chen) | Harvey | ✅ 完了 (Discussion 1文) |

### Major

| # | Issue | Assignee | Status |
|---|-------|----------|--------|
| #11 | L感度分析 primary output昇格 | Katrina | ✅ 完了 (recommendation文) |
| #12 | Prop 1 条件不足 (IQR > 0) | Mike | ✅ 完了 (条件明記) |
| #13 | S4 coverage 0.73 境界挙動議論 | Mike | ✅ 完了 (table note) |
| #14 | Multiple EM aggregation | Harvey | ✅ 完了 (limitation追加) |

### Minor

| # | Issue | Status |
|---|-------|--------|
| m1 | Unmeasured EM limitation | ✅ 完了 |
| m2 | Real data ICH E17具体例 | ✅ 完了 |
| m3 | Table 2 benchmarks便宜性強調 | ✅ 完了 |
| m4 | Software availability | ✅ 完了 |

### ✅ Rachel発見: 引用エラー修正済み

| Paper | Issue | Resolution |
|-------|-------|------------|
| Kim (2015) | DOI → Yagi et al.の論文 | ✅ yagi2015 に修正 (著者16名+key変更+.tex更新) |
| Jones (2016) | .bib著者リストが別論文のもの | ✅ Lonergan/Henley/Pearson に修正 |
| Quan (2010) | Rachelの混同 (別論文) | ✅ 修正不要 (Drug Inf J 2010で正しい) |

### Revision Notes (Earlier)

| # | Issue | Status |
|---|-------|--------|
| #5 | Section 2.2 Barrio vs Sommerfeld参照区別 | 準備中 (#7に統合) |
| #6 | L推定方法の補強可能性 | 査読待ち |

---

## ⚠️ Issues

1. S05 coverage degradation (0.73 at n=200) — negative bias from bounded statistic → #13と連携
2. Scenario numbering gaps (S02, S07 missing) — deferred
3. KS comparison in simulation — deferred, Tak decision needed

---

## 📋 Paper Requests

*(None pending)*

---
