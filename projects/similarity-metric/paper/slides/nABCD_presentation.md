---
marp: true
size: 16:9
paginate: true
header: "2026"
footer: "nABCD: Effect Modifier Similarity for MRCTs"
style: |
  /* ============================================
     Marp Slide Template
     - Accent Color 1: #1E3A5F (Deep Navy)
     - Accent Color 2: #199be6
     ============================================ */

  @import url('https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@100..900&display=swap');

  :root {
    --accent1: #1E3A5F;
    --accent2: #199be6;
    --text-main: #000000;
    --text-light: #303030;
    --bg-light: #F8F9FA;
    --bw: 10px;
    --footer-space: 24px;
  }

  /* ---- Base slide ---- */
  section {
    font-family: 'Noto Sans JP', sans-serif;
    color: var(--text-main);
    border: none;
    padding: 90px 60px 46px 60px;
    font-size: 28px;
    line-height: 1.3;
    position: relative;
    background-color: white;
    background-image:
      linear-gradient(var(--accent1), var(--accent1)),
      linear-gradient(var(--accent1), var(--accent1)),
      linear-gradient(var(--accent1), var(--accent1)),
      linear-gradient(var(--accent1), var(--accent1));
    background-position:
      0 0,
      0 0,
      100% 0,
      0 calc(100% - var(--footer-space));
    background-size:
      100% var(--bw),
      var(--bw) calc(100% - var(--footer-space)),
      var(--bw) calc(100% - var(--footer-space)),
      100% var(--bw);
    background-repeat: no-repeat;
  }

  section::before {
    display: none;
  }

  section h1 {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    box-sizing: border-box;
    background: var(--accent1);
    color: white;
    font-size: 48px;
    font-weight: 700;
    padding: 18px 60px 14px;
    margin: 0;
    line-height: 1.4;
    z-index: 2;
  }

  section h2 {
    color: var(--accent1);
    font-size: 36px;
    font-weight: 700;
    border-bottom: 3px solid var(--accent2);
    padding-bottom: 6px;
    margin-bottom: 20px;
  }

  section h3 {
    color: var(--accent2);
    font-size: 28px;
    font-weight: 700;
  }

  header {
    font-family: 'Noto Sans JP', sans-serif;
    position: absolute;
    top: auto;
    bottom: 4px;
    left: 20px;
    right: auto;
    font-size: 14px;
    color: var(--text-light);
    letter-spacing: 0.02em;
    z-index: 2;
  }

  footer {
    font-family: 'Noto Sans JP', sans-serif;
    position: absolute;
    top: auto;
    bottom: 4px;
    left: 0;
    right: 0;
    width: 100%;
    font-size: 14px;
    color: var(--text-light);
    text-align: center;
    letter-spacing: 0.02em;
    z-index: 2;
  }

  section::after {
    font-family: 'Noto Sans JP', sans-serif;
    position: absolute;
    bottom: 4px;
    right: 20px;
    top: auto;
    left: auto;
    width: auto;
    height: auto;
    font-size: 14px;
    color: var(--text-light);
    background: none;
    padding: 0;
    text-align: right;
    z-index: 2;
  }

  section strong {
    color: var(--accent2);
    font-weight: 700;
  }

  section ul, section ol {
    line-height: 1.4;
    margin-left: 10px;
  }

  section li {
    line-height: 1.4;
    margin-bottom: 4px;
  }

  section p {
    line-height: 1.3;
  }

  section li::marker {
    color: var(--accent1);
  }

  section table {
    border-collapse: collapse;
    width: 100%;
    font-size: 26px;
    margin: 16px 0;
  }

  section table th {
    background: var(--accent1);
    color: white;
    font-weight: 700;
    padding: 10px 16px;
    text-align: left;
  }

  section table td {
    padding: 8px 16px;
    border-bottom: 1px solid #E0E0E0;
  }

  section table tr:nth-child(even) td {
    background: var(--bg-light);
  }

  section code {
    font-size: 24px;
    background: var(--bg-light);
    border: 1px solid #E0E0E0;
    border-radius: 4px;
    padding: 2px 6px;
  }

  section pre {
    background: #1E1E2E;
    border-radius: 8px;
    padding: 20px;
    border-left: 4px solid var(--accent2);
  }

  section pre code {
    background: none;
    border: none;
    color: #CDD6F4;
    font-size: 22px;
    padding: 0;
  }

  section blockquote {
    border-left: 4px solid var(--accent2);
    padding: 12px 20px;
    margin: 16px 0;
    background: var(--bg-light);
    font-style: italic;
    color: var(--text-light);
  }

  section img {
    max-height: 60%;
    border-radius: 4px;
  }

  /* ---- Title slide ---- */
  section.title {
    background: var(--accent1);
    color: white;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: flex-start;
    text-align: left;
    padding: 60px;
  }

  section.title h1 {
    position: static;
    background: transparent;
    color: white;
    font-size: 86px;
    font-weight: 900;
    margin: 0 0 20px 0;
    padding: 0;
    line-height: 1.3;
    border: none;
  }

  section.title h2 {
    font-size: 68px;
    font-weight: 400;
    border: none;
    margin: 0 0 40px 0;
    padding: 0;
  }

  section.title p {
    font-size: 42px;
    margin: 4px 0;
    align-self: flex-end;
  }

  section.title::before {
    display: none;
  }

  section.title header,
  section.title footer {
    display: none;
  }

  section.title::after {
    display: none;
  }

  /* ---- Section divider ---- */
  section.section {
    background: var(--accent1);
    color: white;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: flex-start;
    text-align: left;
    padding: 60px;
  }

  section.section h1 {
    position: static;
    background: transparent;
    color: white;
    font-size: 72px;
    margin: 0;
    padding: 0 0 16px 0;
    border-bottom: 4px solid var(--accent2);
  }

  section.section h2 {
    font-size: 60px;
    font-weight: 400;
    border: none;
  }

  section.section header,
  section.section footer {
    display: none;
  }

  section.section::after {
    display: none;
  }

  /* ---- Two-column layout ---- */
  section.cols {
    display: grid;
    grid-template-columns: 1fr 1fr;
    grid-template-rows: 1fr;
    gap: 0 40px;
  }

  section.cols h1 {
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    box-sizing: border-box;
  }

  /* ---- End slide ---- */
  section.end {
    background: var(--accent1);
    color: white;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    text-align: center;
  }

  section.end h1 {
    position: static;
    background: transparent;
    color: white;
    font-size: 48px;
    margin: 0;
    padding: 0;
  }

  section.end p {
    color: rgba(255, 255, 255, 0.7);
    font-size: 26px;
  }

  section.end::before {
    display: none;
  }

  section.end header,
  section.end footer {
    display: none;
  }

  section.end::after {
    display: none;
  }

---

<!-- _class: title -->
<!-- _paginate: false -->

# Effect Modifier の分布類似性に基づく地域プーリングの定量化

##

Tak Nagakubo

---

# Agenda

1. **Background**: MRCT, ICH E17, 既存手法の限界
2. **Methods**: nABCD の定義・理論基盤・推定・clinical calibration
3. **Simulation**: 8シナリオによる推定性能評価
4. **Application**: IST-1 (Case A) / IST-3 (Case B)
5. **Discussion**: 主要な知見と実務への示唆

---

<!-- _class: section -->

# 背景

---

# MRCT と ICH E17

- **MRCT** (Multi-Regional Clinical Trial) は国際共同治験の標準パラダイム
- ICH E17 (2017) は治療効果の一般化可能性を前提とした計画・設計原則を規定
- 各規制当局は **地域部分集団における治療効果の一貫性** を要求

### 地域プーリングの必要性

- 個々の地域サンプルサイズは一貫性評価に不十分なことが多い
- ICH E17 は **effect modifier 分布の類似性** に基づくプーリングを記述
- しかし、定量的方法論は提供されていない

> "Similar enough" の判断基準が欠如している
> --- ICH E17 の実装上のギャップ

---

# Effect Modifier とは

**Effect modifier**: 治療効果がサブグループ間で異なる患者背景因子

### 例: 年齢が effect modifier の場合

- 若年患者の方が治療反応が良い場合、年齢は effect modifier
- 薬が個人レベルで同一に作用しても、患者構成が異なれば地域平均治療効果は異なる

### 地域平均治療効果

$$
\bar{\tau}_r = \int \tau(x) \, dF_r(x)
$$

$\tau(x)$: CATE (条件付き平均治療効果)、$F_r$: 地域 $r$ の effect modifier 分布

---

# 既存手法の限界

| 指標 | 特徴 | 限界 |
|------|------|------|
| **SMD** | スケールフリー、解釈容易 | **位置 (mean) のみ**。分散・形状差を無視 |
| **KS 統計量** | 分布全体を比較 | 臨床的解釈困難。治療効果との理論的連結なし |
| **KL ダイバージェンス** | 密度ベース | 非対称、小サンプルで不安定、$\infty$ に発散可能 |

### SMD の盲点

$$
N(50, 5^2) \text{ vs } N(50, 15^2) \implies \text{SMD} = 0
$$

分散が3倍異なるにもかかわらず SMD は差を検出できない

---

<!-- _class: section -->

# Methods

---

# nABCD の定義

### Wasserstein-1 距離 (Earth Mover's Distance)

$$
W_1(F, G) = \int_{-\infty}^{\infty} |F(x) - G(x)| \, dx
$$

幾何学的解釈: **2つの CDF 間の総面積**

### nABCD: 正規化された CDF 間面積

$$
\text{nABCD}(F_1, F_2) = \frac{W_1(F_1, F_2)}{2 \cdot \text{IQR}_{\text{pooled}}}
$$

- $\text{IQR}_{\text{pooled}}$: プールされた分布の四分位範囲
- 係数 2 により、1-IQR の位置シフトで nABCD $= 0.5$ となるよう較正
- **スケールフリー**: 測定単位に依存しない解釈が可能

---

# nABCD の3つの要件充足

### 要件 1: 位置以外の分布特徴

- $W_1$ は位置・分散・歪度の差に反応
- SMD が検出できない分散差・形状差を捕捉

### 要件 2: 臨床的解釈

- IQR 正規化によりスケールフリーな指標
- Reference benchmarks で初期評価可能

### 要件 3: 理論的連結

- Kantorovich-Rubinstein 双対性により治療効果異質性への上界を提供
- これは $W_1$ 固有の性質 ($W_2$, KS, KL にはない)

---

# 理論基盤: 治療効果異質性との連結

### Kantorovich-Rubinstein 双対性

$$
W_1(F_1, F_2) = \sup_{\|f\|_{\text{Lip}} \leq 1} \left|\int f \, dF_1 - \int f \, dF_2\right|
$$

### Heterogeneity Bound (Proposition 2)

CATE $\tau(x)$ が Lipschitz 定数 $L$ を持つとき:

$$
|\bar{\tau}_1 - \bar{\tau}_2| \leq 2L \cdot \text{IQR}_{\text{pooled}} \cdot \text{nABCD}(F_1, F_2)
$$

- $L$: effect modifier の1単位変化あたりの治療効果変化の上界
- **分布距離 $\to$ 治療効果差の上界** への定量的橋渡し

---

# 推定と推論

### 推定量

$$
\widehat{\text{nABCD}} = \frac{\sum_{k=1}^{n_1+n_2-1} |\hat{F}_1(x_{(k)}) - \hat{F}_2(x_{(k)})| \cdot (x_{(k+1)} - x_{(k)})}{2 \cdot \widehat{\text{IQR}}_{\text{pooled}}}
$$

### 漸近分布と Bootstrap

- $W_1$ の漸近分布は **非標準**: $\sqrt{n}\,W_1(\hat{F}_n, F) \xrightarrow{d} \int |B(F(x))|\,dx$ (Brownian bridge functional)
- 未知の $F$ に依存 → 普遍的臨界値なし → **percentile bootstrap** を採用 ($B = 2{,}000$)
- $F_1 \neq F_2$ のとき $L_1$ functional の Hadamard 微分が線形 → bootstrap は consistent
- 計算量: $O((n_1+n_2)\log(n_1+n_2))$ --- combined order statistics のソートが支配的

---

# Clinical Calibration: $\Delta_{\max}$

### 最大治療効果差

$$
\Delta_{\max} = 2L \cdot \text{IQR}_{\text{pooled}} \cdot \text{nABCD}(F_1, F_2)
$$

- $L$: CATE の感度パラメータ。worst-case の治療効果異質性を制御
- 先行知識、パイロットデータ、既発表サブグループ解析から推定

### 5-Step Calibration Procedure

1. 候補 effect modifier ごとに **nABCD + bootstrap CI** を算出
2. 先行研究から $L$ を推定 (例: $L \approx \Delta\tau / \Delta x$)
3. $\Delta_{\max}$ を算出 --- worst-case の治療効果差
4. $\Delta_{\max}$ の CI を nABCD CI から導出 (臨床スケールでの不確実性)
5. 全体治療効果・非劣性マージン・臨床的最小重要差と **並置して** 報告

### なぜ仮説検定ではなく推定か

- ICH E17 の "similar enough" は本質的に **文脈依存**
- $L$ の不確実性 → $\Delta_{\max}$ 自体が感度分析の対象
- $\Delta_{\max}$ + CI は p値や棄却判断より豊かな情報を提供

---

# $L$ が未知の場合: 感度分析

### 逆算アプローチ ($L^*$ 感度分析)

$$
L^* = \frac{\Delta_{\text{clin}}}{2 \cdot \text{IQR}_{\text{pooled}} \cdot \text{nABCD}}
$$

- $\Delta_{\text{clin}}$: 臨床的に重要な治療効果差 (例: 全体治療効果、非劣性マージン)
- $L^*$ が妥当な範囲を超えていれば、分布差は臨床的に問題になりにくい
- $L^*$ が小さければ、分布異質性への対策が必要

### Reference Benchmarks (分布的大きさのみ)

| nABCD 範囲 | 分布的大きさ | ガイダンス |
|-----------|------------|----------|
| $< 0.05$ | Negligible | Clinical calibration で有意な $\Delta_{\max}$ は出にくい |
| $0.05$--$0.15$ | Small | $L$ が利用可能なら calibration 推奨 |
| $0.15$--$0.30$ | Moderate | Calibration 重要; 臨床文脈で解釈 |
| $> 0.30$ | Large | プーリング検討前に calibration 必須 |

> **注意**: これらは **distributional magnitude only** の初期参照。同じ nABCD でも $L$ が異なれば臨床的含意は異なる。プーリング判断には clinical calibration ($\Delta_{\max}$) を使用すべき。

---

<!-- _class: section -->

# Simulation

---

# シミュレーション設計

### 8つのシナリオ

| ID | 説明 | Distribution 1 | Distribution 2 | True nABCD |
|----|------|----------------|----------------|------------|
| S1 | Null (同一) | $N(50, 10^2)$ | $N(50, 10^2)$ | 0.000 |
| S2 | 位置 0.2$\sigma$ | $N(50, 10^2)$ | $N(52, 10^2)$ | 0.073 |
| S3 | 位置 0.5$\sigma$ | $N(50, 10^2)$ | $N(55, 10^2)$ | 0.180 |
| S4 | 位置 1.0$\sigma$ | $N(50, 10^2)$ | $N(60, 10^2)$ | 0.328 |
| S5 | 尺度 1.5x | $N(50, 10^2)$ | $N(50, 15^2)$ | 0.122 |
| S6 | 形状 (Gamma) | $N(50, 10^2)$ | Gamma$(25, 0.5)$ | 0.024 |
| S7 | 歪度 (Log-normal) | $N(50, 10^2)$ | LogN | 0.304 |
| S8 | 位置+尺度 | $N(50, 10^2)$ | $N(55, 15^2)$ | 0.175 |

$n = 50, 100, 200$ / 地域、10,000反復、$B = 2{,}000$ bootstrap resamples

---

# シミュレーション結果: バイアスと被覆確率

### バイアス ($n = 100$)

- True nABCD $\geq 0.1$ のシナリオ: バイアス $< 0.02$
- S3 (0.5$\sigma$): +0.003、S4 (1.0$\sigma$): +0.003 --- ほぼ無視可能
- 近境界シナリオ (S1, S6): 正のバイアスが大きい (非負制約による)

### 被覆確率 (95% CI, $n = 100$)

| シナリオ | $n = 50$ | $n = 100$ | $n = 200$ |
|---------|---------|----------|----------|
| S3 (0.5$\sigma$) | 0.947 | 0.951 | 0.947 |
| S4 (1.0$\sigma$) | 0.950 | 0.950 | 0.957 |
| S7 (Skew) | 0.953 | 0.954 | 0.954 |
| S8 (Loc+Scale) | 0.917 | 0.935 | 0.944 |

**推奨**: $n \geq 100$ / 地域で信頼性のある推定・推論が可能

---

# nABCD vs SMD: 感度比較 ($n = 100$)

| シナリオ | nABCD (mean $\pm$ SD) | SMD (mean $\pm$ SD) | 含意 |
|---------|----------------------|--------------------|----|
| S3 (位置) | $0.183 \pm 0.048$ | $0.50 \pm 0.14$ | 両方が検出 |
| S5 (尺度のみ) | $0.136 \pm 0.033$ | $0.00 \pm 0.14$ | **nABCD のみ検出** |
| S6 (形状のみ) | $0.070 \pm 0.025$ | $0.00 \pm 0.14$ | **nABCD のみ検出** |
| S7 (歪度のみ) | $0.312 \pm 0.048$ | $0.00 \pm 0.14$ | **nABCD のみ検出** |

### Key Finding

- 位置差: SMD と nABCD は同等の情報を提供
- **尺度・形状・歪度差**: SMD はゼロのまま --- nABCD のみが検出
- S7 は特に顕著: 大きな分布差 (nABCD $= 0.31$) が SMD には完全に不可視

---

<!-- _class: section -->

# Application

---

# 適用: 2つの計画シナリオ

### 仮想シナリオ

新規血栓溶解薬 (drug A) の Phase 3 MRCT を計画中

### Case A: Effect Modifier が未知 (IST-1)

- IST-1: 31カ国、19,435名 (1991--1996)
- 治療 x effect modifier 交互作用なし (全 $p > 0.05$)
- $L$ 推定不可 --- **$L^*$ 感度分析** で対応

### Case B: Effect Modifier が特定済み (IST-3)

- IST-3: 8カ国、3,035名 (2000--2012)
- NIHSS: 交互作用 $p = 0.001$、$L$ 推定可能
- --- **Clinical calibration** で $\Delta_{\max}$ を算出

---

# Case A: IST-1 --- 地理的分布異質性

### 31カ国の分布パターン (年齢)

- **最大 nABCD**: India--UK = 0.565 (IST-3 の約4倍)
- アジア諸国: India (0.375) > Singapore (0.205) > Hong Kong (0.121)
- 人口構成と医療アクセスパターンの地理的クラスタリング

### $L^*$ 感度分析 (India--UK)

- nABCD $= 0.565$ で $\Delta_{\max} = 2$%pt を生じる $L^*$ は約 $0.005$/year
- --- **小さな年齢関連交互作用** でも臨床的に問題となりうる
- 明示的な緩和策 (層別ランダム化、プロトコル制限) が必要

> $L^*$ が小さい = 分布異質性のリスクが高い

---

# Case B: IST-3 --- nABCD vs SMD の実データ比較

### nABCD 要約 (28ペア)

| Effect Modifier | Median | Max | Max pair |
|----------------|--------|-----|----------|
| Age | 0.103 | 0.285 | SE--BE |
| NIHSS | 0.101 | 0.240 | PL--PT |
| Delay | 0.098 | 0.195 | SE--AU |

### SMD が見逃すケース

Norway--Portugal (治療遅延):
- 平均: 4.34 vs 4.33 h
- **SMD = 0.007** (ほぼ同一)
- **nABCD = 0.069** (形状差を検出)
- Norway は極端な右裾 (歪度 6.76); Portugal はコンパクト (歪度 $-0.23$)

---

# Case B: Clinical Calibration 結果

### NIHSS vs Age の対比

| | NIHSS | Age |
|---|-------|-----|
| 交互作用 $p$ | **0.001** | 0.614 |
| $L_{\text{mean}}$ | 0.00950/pt | 0.00065/yr |
| nABCD (max) | 0.240 | 0.285 |
| $\Delta_{\max}$ ($L_{\text{mean}}$) | **5.02%pt** | 0.47%pt |
| $\Delta_{\max}$ ($L_{\max}$) | **7.37%pt** | 0.65%pt |

全体治療効果 RD $\approx$ +1.5%pt

### 核心的知見

- Age の方が nABCD は **大きい** (0.285 > 0.240)
- しかし $\Delta_{\max}$ は NIHSS の方が **10倍以上大きい**
- **分布距離のランキング $\neq$ 臨床的インパクトのランキング**

---

<!-- _class: section -->

# Discussion

---

# 主要な知見と nABCD の3つの優位性

### 1. SMD が見逃す分布差を捕捉

- Simulation: S5 (尺度), S6 (形状), S7 (歪度) で SMD $\approx 0$ だが nABCD は検出
- IST-3: Norway--Portugal (治療遅延) で実データでも確認

### 2. 治療効果異質性への理論的連結

- Heterogeneity bound により $\Delta_{\max}$ への定量的橋渡し
- KS 統計量・KL ダイバージェンスにはこの性質がない ($W_1$ 固有)

### 3. 客観的・再現性のある推論

- Bootstrap CI による統計的推論
- 視覚的検査 (目視) と異なり定量的・再現可能

---

# 実務への推奨

1. 候補 effect modifier ごとに **nABCD + bootstrap CI** を算出 ($n \geq 100$/地域)

2. $L$ が推定可能な場合: **$\Delta_{\max}$** とその CI を臨床スケールで報告
   - $L_{\max}$ (保守的上界) と $L_{\text{mean}}$ (現実的推定) の両方を提示

3. $L$ が未知の場合: **Reference benchmarks** で初期評価 + $L^*$ 感度分析

4. $\Delta_{\max}$ を全体治療効果・非劣性マージンと **並置して** 報告

5. 複数 effect modifier がある場合: 最大 $\Delta_{\max}$ に基づく保守的判断、
   または全 $\Delta_{\max}$ の totality-of-evidence アプローチ

> 固定閾値ではなく、**文脈依存の臨床判断** を支援する
> --- ICH E17 の "similar enough" の実装

---

# まとめ

### nABCD が埋めるギャップ

- ICH E17 の **定量的方法論の欠如** に対応
- 計画段階で利用可能 (事前試験・レジストリ・RWE データから算出可能)
- $\Delta_{\max}$ calibration により **evidence-based かつ clinically grounded** なプーリング判断を支援

### Central Message

$$
\boxed{|\bar{\tau}_1 - \bar{\tau}_2| \leq 2L \cdot \text{IQR}_{\text{pooled}} \cdot \text{nABCD}}
$$

**分布距離ランキング $\neq$ 臨床的インパクトランキング**

--- nABCD の大きさだけでなく、clinical calibration が判断の鍵

---

<!-- _class: end -->
<!-- _paginate: false -->

# Thank You

ご質問をお願いします

Tak Nagakubo
