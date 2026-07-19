---
marp: true
size: 16:9
paginate: true
header: "Feb 28, 2026"
footer: "Heterogeneity Bound — nABCD の理論的背骨"
math: mathjax
style: |
  /* ============================================
     Marp Slide Template
     - Accent Color 1: #003638 (Deep Teal)
     - Accent Color 2: #1a0da7 (Deep Indigo)
     ============================================ */

  @import url('https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@100..900&display=swap');

  :root {
    --accent1: #003638;
    --accent2: #1a0da7;
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
    line-height: 1.6;
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

  section::before { display: none; }

  section h1 {
    position: absolute;
    top: 0; left: 0; right: 0;
    box-sizing: border-box;
    background: var(--accent1);
    color: white;
    font-size: 40px;
    font-weight: 700;
    padding: 18px 60px 14px;
    margin: 0;
    line-height: 1.4;
    z-index: 2;
  }

  section h2 {
    color: var(--accent1);
    font-size: 34px;
    font-weight: 700;
    border-bottom: 3px solid var(--accent2);
    padding-bottom: 6px;
    margin-bottom: 16px;
  }

  section h3 {
    color: var(--accent2);
    font-size: 28px;
    font-weight: 700;
  }

  header {
    font-family: 'Noto Sans JP', sans-serif;
    position: absolute;
    top: auto; bottom: 4px; left: 20px; right: auto;
    font-size: 14px;
    color: var(--text-light);
    letter-spacing: 0.02em;
    z-index: 2;
  }

  footer {
    font-family: 'Noto Sans JP', sans-serif;
    position: absolute;
    top: auto; bottom: 4px; left: 0; right: 0;
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
    bottom: 4px; right: 20px;
    top: auto; left: auto;
    width: auto; height: auto;
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
    line-height: 1.8;
    margin-left: 10px;
  }

  section li { margin-bottom: 4px; }
  section li::marker { color: var(--accent1); }

  section table {
    border-collapse: collapse;
    width: 100%;
    font-size: 24px;
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

  section blockquote {
    border-left: 4px solid var(--accent2);
    padding: 12px 20px;
    margin: 16px 0;
    background: var(--bg-light);
    font-style: italic;
    color: var(--text-light);
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
    font-size: 58px;
    font-weight: 900;
    margin: 0 0 20px 0;
    padding: 0;
    line-height: 1.3;
    border: none;
  }

  section.title h2 {
    font-size: 34px;
    font-weight: 400;
    border: none;
    margin: 0 0 40px 0;
    padding: 0;
    color: rgba(255, 255, 255, 0.85);
  }

  section.title p {
    font-size: 28px;
    margin: 4px 0;
    align-self: flex-end;
    color: rgba(255, 255, 255, 0.8);
  }

  section.title::before { display: none; }
  section.title header, section.title footer { display: none; }
  section.title::after { display: none; }

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
    font-size: 64px;
    margin: 0;
    padding: 0 0 16px 0;
    border-bottom: 4px solid var(--accent2);
  }

  section.section h2 {
    font-size: 36px;
    font-weight: 400;
    border: none;
    color: rgba(255, 255, 255, 0.85);
  }

  section.section header, section.section footer { display: none; }
  section.section::after { display: none; }

  /* ---- Two-column ---- */
  section.cols {
    display: grid;
    grid-template-columns: 1fr 1fr;
    grid-template-rows: 1fr;
    gap: 0 40px;
  }

  section.cols h1 {
    position: absolute;
    top: 0; left: 0; right: 0;
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

  section.end::before { display: none; }
  section.end header, section.end footer { display: none; }
  section.end::after { display: none; }

  /* ---- Block environments ---- */
  .block, .alertblock {
    border-radius: 6px;
    margin: 14px 0;
    padding: 0;
    overflow: hidden;
    font-size: 25px;
    line-height: 1.5;
    box-shadow: 0 1px 4px rgba(0, 0, 0, 0.10);
  }

  .block .block-title,
  .alertblock .block-title {
    display: block;
    font-weight: 700;
    font-size: 24px;
    padding: 8px 20px;
    margin: 0;
    color: white;
  }

  .block .block-content,
  .alertblock .block-content {
    padding: 12px 20px;
    margin: 0;
  }

  .block .block-content p,
  .alertblock .block-content p {
    margin: 0;
  }

  .block .block-title { background: var(--accent1); }
  .block .block-content { background: #e6f0f0; border: 1px solid #b3d1d2; border-top: none; border-radius: 0 0 6px 6px; }

  .alertblock .block-title { background: var(--accent2); }
  .alertblock .block-content { background: #eceafc; border: 1px solid #c4bfe8; border-top: none; border-radius: 0 0 6px 6px; }

---

<!-- _class: title -->
<!-- _paginate: false -->

# Heterogeneity Bound
## nABCD の理論的背骨を理解する

内部勉強会資料

---

# このスライドの目標

**Heterogeneity Bound** を4つのレベルで完全に理解する

1. **何が嬉しいのか？** &mdash; 分布の違いから治療効果差を予測できる
2. **なぜ成り立つのか？** &mdash; Kantorovich-Rubinstein 双対性
3. **どう使うのか？** &mdash; $\Delta_{\max}$ への変換と clinical calibration
4. **なぜ W₁ なのか？** &mdash; W₂ や KL にはできないこと

---

<!-- _class: section -->

# Part 1
## 問題設定：なぜ Bound が必要か

---

# MRCT における根本的な問い

多地域臨床試験（MRCT）で2つの地域を**プール**してよいか？

$$
\bar{\tau}_r = \int \tau(x) \, dF_r(x)
$$

- $\tau(x)$：個人レベルの治療効果（CATE）
- $F_r(x)$：地域 $r$ における効果修飾因子（EM）の分布

<div class="alertblock">
<div class="block-title">核心的問い</div>
<div class="block-content">

同じ薬でも、**患者構成が異なれば平均治療効果が異なる**。
$F_1 \neq F_2$ のとき、$|\bar{\tau}_1 - \bar{\tau}_2|$ はどの程度大きくなり得るか？

</div>
</div>

---

# 知りたいもの vs 計算できるもの

|  | 内容 | 入手可能性 |
|---|------|----------|
| **知りたいもの** | $\|\bar{\tau}_1 - \bar{\tau}_2\|$ 治療効果の地域差 | 試験後にしか分からない |
| **計算できるもの** | $W_1(F_1, F_2)$ 分布の違い | ベースラインデータから計算可能 |

### 理想

$$
\text{計算できるもの} \xrightarrow{\text{何らかの変換}} \text{知りたいものの上界}
$$

この「何らかの変換」を与えるのが **Heterogeneity Bound**。

---

<!-- _class: section -->

# Part 2
## Heterogeneity Bound の導出

---

# Step 1：Wasserstein-1 距離とは

2つの累積分布関数 $F$, $G$ の間の面積：

$$
W_1(F, G) = \int_{-\infty}^{\infty} |F(x) - G(x)| \, dx
$$

### 直感的な意味

- **Earth Mover's Distance**：一方の分布を他方に「移動」するコスト
- 位置・スケール・形状の**すべての違い**を捉える
- 1次元では CDF 間の面積という明快な幾何学的解釈

---

# Step 2：Kantorovich-Rubinstein 双対性

$W_1$ には以下の**等価表現**がある（これが鍵）：

<div class="block">
<div class="block-title">Kantorovich-Rubinstein 双対定理</div>
<div class="block-content">

$$W_1(F_1, F_2) = \sup_{\|f\|_{\text{Lip}} \leq 1} \left| \int f \, dF_1 - \int f \, dF_2 \right|$$

</div>
</div>

### 日本語で言うと

> Lipschitz 定数が 1 以下の**あらゆる関数** $f$ について、
> 2つの分布での期待値の差は $W_1$ を超えない

$W_1$ は「Lipschitz 関数の世界」で**最悪ケースの期待値差**を測る距離。

---

# Step 3：CATE 関数を代入する

CATE 関数 $\tau(x)$ の Lipschitz 定数が $L$ であるとする。

すると $g(x) = \tau(x) / L$ は Lipschitz 定数 1 の関数。

K-R 双対性から：

$$
\left| \int \frac{\tau(x)}{L} \, dF_1 - \int \frac{\tau(x)}{L} \, dF_2 \right| \leq W_1(F_1, F_2)
$$

両辺に $L$ を掛けると：

<div class="alertblock">
<div class="block-title">Heterogeneity Bound</div>
<div class="block-content">

$$|\bar{\tau}_1 - \bar{\tau}_2| \leq L \cdot W_1(F_1, F_2)$$

</div>
</div>

---

# 導出のまとめ：3ステップ

```
① W₁ の定義   : CDF間の面積 = ∫|F(x) - G(x)|dx
        ↓
② K-R 双対性  : W₁ = sup{Lip≤1} |∫f dF₁ - ∫f dF₂|
        ↓  τ(x)/L は Lip≤1 の関数
③ Bound 成立  : |τ̄₁ - τ̄₂| ≤ L · W₁(F₁, F₂)
```

### ポイント

- ステップ②が**本質** &mdash; W₁ だけが持つ Lipschitz 関数との双対性
- ステップ③は②の直接的な帰結
- 証明は3行で完結する、美しい構造

---

<!-- _class: section -->

# Part 3
## なぜ W₁ でなければならないか

---

# W₂ や KL ダイバージェンスではダメな理由

| 距離 | Lipschitz 双対性 | Heterogeneity Bound |
|------|:---:|:---:|
| **W₁** (Wasserstein-1) | あり | 構築可能 |
| W₂ (Wasserstein-2) | **なし** | 構築不可 |
| KL ダイバージェンス | **なし** | 構築不可 |
| Total Variation | あり（有界関数） | 弱いbound のみ |

### W₂ の双対表現（参考）

$$W_2^2(F_1, F_2) = \inf_{\gamma \in \Gamma} \int \|x - y\|^2 \, d\gamma(x, y)$$

W₂ の双対は**凸関数のクラス**であり、Lipschitz 関数ではない。
→ CATE 関数への適用が**直接的にはできない**。

---

# W₁ を選ぶ理由は「ひとつだけ」

<div class="alertblock">
<div class="block-title">決定的な理由</div>
<div class="block-content">

Kantorovich-Rubinstein 双対性により、W₁ は **Lipschitz 連続な CATE 関数** と直接結びつく。

この性質が **clinical calibration（臨床的較正）** の全体を支える。

</div>
</div>

### 他の利点（副次的）

- 1次元では CDF 間面積として**明快な幾何学的解釈**
- $O(n \log n)$ で計算可能
- 収束速度 $O(n^{-1/2})$ で CLT が成立（del Barrio et al. 1999）

しかしこれらは「あればうれしい」であって、W₁ を選ぶ**本当の理由は双対性だけ**。

---

<!-- _class: section -->

# Part 4
## nABCD 形式と $\Delta_{\max}$

---

# W₁ から nABCD へ

### nABCD の定義

$$
\text{nABCD}(F_1, F_2) = \frac{W_1(F_1, F_2)}{\text{IQR}_{\text{pooled}}}
$$

### なぜ正規化するか

- **無次元化**：年齢（歳）、BMI（kg/m²）、HbA1c（%）を同じスケールで比較可能
- **IQR で割る理由**：外れ値に頑健（SD より安定）
- **較正**：1-IQR の純粋な位置シフトで $\text{nABCD} = 1.0$ となるよう設計

→ $W_1$ を逆に解くと $W_1 = \text{IQR}_{\text{pooled}} \cdot \text{nABCD}$

---

# Heterogeneity Bound の nABCD 形式

$W_1 = \text{IQR} \cdot \text{nABCD}$ を代入：

<div class="block">
<div class="block-title">$\Delta_{\max}$ の定義</div>
<div class="block-content">

$$\Delta_{\max} = L \cdot \text{IQR}_{\text{pooled}} \cdot \text{nABCD}(F_1, F_2)$$

= EM 分布差に起因する**治療効果差の最大値**（臨床アウトカムの単位）

</div>
</div>

### 3 つの要素の積

| 要素 | 意味 | 情報源 | 単位 |
|------|------|--------|------|
| $L$ | CATE の傾き（感度） | ドメイン知識 | [outcome] / [EM] |
| $\text{IQR}$ | EM のスケール | 観測データ | [EM] |
| $\text{nABCD}$ | 無次元の分布差 | 観測データ + Bootstrap | 無次元 |

→ 掛け合わせると **[outcome] の単位** = 臨床スケール

---

# 3要素が「独立した情報」を持つ

```
     nABCD         ×        IQR          ×         L
  ┌──────────┐   ┌──────────────┐   ┌──────────────┐
  │ 分布の形の │   │ EMのスプレッド │   │ CATE関数の   │
  │ 違いの程度 │   │ （元の単位）  │   │ 傾きの上界   │
  ├──────────┤   ├──────────────┤   ├──────────────┤
  │ データから │   │ データから    │   │ ドメイン知識  │
  │ 推定       │   │ 計算          │   │ から推定      │
  └──────────┘   └──────────────┘   └──────────────┘
       │                │                   │
       └────────────────┴───────────────────┘
                        │
                   Δ_max（臨床スケール）
```

**nABCD だけ**では臨床的意味が分からない。
**L だけ**でも不十分。
3 つ揃って初めて **「HbA1c で最大 0.24% の差」** と言える。

---

<!-- _class: section -->

# Part 5
## 具体例で理解する

---

<!-- _class: cols -->

# 糖尿病 MRCT：Japan vs US

**試験設定**

- 治療効果：**&minus;0.8%** HbA1c
- 非劣性マージン：**0.4%**
- Japan: $n = 150$
- US: $n = 200$

**3つの効果修飾因子**

| EM | nABCD | $L$ | IQR |
|----|-------|-----|-----|
| Age | 0.24 | 0.01 | 14.2 yr |
| BMI | 1.02 | 0.02 | 7.8 kg/m² |
| HbA1c | 0.54 | 0.30 | 1.5% |

---

# $\Delta_{\max}$ の計算

$\Delta_{\max} = L \cdot \text{IQR} \cdot \text{nABCD}$

| EM | 計算式 | $\Delta_{\max}$ | 対マージン |
|----|--------|:-----------:|:------:|
| **Age** | $0.01 \times 14.2 \times 0.24$ | **0.03%** | 8% |
| **BMI** | $0.02 \times 7.8 \times 1.02$ | **0.16%** | 40% |
| **HbA1c** | $0.30 \times 1.5 \times 0.54$ | **0.24%** | 60% |

<div class="alertblock">
<div class="block-title">注目</div>
<div class="block-content">

BMI は nABCD が**最大**（1.02）だが、$\Delta_{\max}$ は HbA1c より**小さい**。
nABCD の大きさだけでは判断できない！

</div>
</div>

---

# なぜ BMI > HbA1c にならないのか？

### BMI（nABCD = 1.02）

- 日米の BMI 分布差は**大きい**（日本 24.8 vs 米国 32.1）
- しかし $L = 0.02$ → BMI が 1 kg/m² 違っても治療効果は **0.02%** しか変わらない
- **弱い効果修飾因子** → 大きな分布差も臨床的影響は限定的

### ベースライン HbA1c（nABCD = 0.54）

- 日米の HbA1c 分布差は**中程度**（日本 7.6% vs 米国 8.4%）
- しかし $L = 0.30$ → HbA1c が 1% 違うと治療効果が **0.30%** 変わる
- **強い効果修飾因子** → 中程度の分布差でも臨床的影響は大きい

<div class="block">
<div class="block-title">教訓</div>
<div class="block-content">

$\Delta_{\max}$ の大きさを決めるのは nABCD と $L$ の**積**。どちらか一方だけでは不十分。

</div>
</div>

---

<!-- _class: section -->

# Part 6
## Bound の性質と正当性

---

# Q: Bound は「ゆるい」のでは？

> $\Delta_{\max}$ は上界であって等号ではない。
> 実際の治療効果差はもっと小さいかもしれない。これは弱点では？

### A: 2つの理由で弱点ではない

**理由 1：規制文脈では上界が正しい判断基準**

- ICH E17 の pooling 判断では **false positive**（異なるのに同じと判断）が最も危険
- 保守的な評価が適切 → 上界で判断するのが正しい

**理由 2：K-R 双対性による bound は tight（最適）**

- $W_1$ を達成する Lipschitz-1 関数は**実際に存在する**
- Bound 自体は loose ではない
- 問題は「実際の CATE が最悪ケースか」→ だから $L$ の推定が重要

---

# L が不確実なときの対処法

### Sensitivity Analysis（Table 7 アプローチ）

nABCD = 0.54, IQR = 1.5% の場合：

| $L$（仮定） | $\Delta_{\max}$ | 治療効果の何%？ | マージンの何%？ |
|:---:|:---:|:---:|:---:|
| 0.10 | 0.08% | 10% | 20% |
| 0.20 | 0.16% | 20% | 40% |
| 0.30 | 0.24% | 30% | 60% |
| 0.40 | 0.32% | 40% | 80% |
| 0.50 | 0.41% | 51% | **100%** |

「$L$ がどの値なら問題になるか？」を**見せる**アプローチ。

---

# Breakeven Point：$L^*$

$L$ の正確な推定が難しい場合、**逆方向**から考える：

<div class="block">
<div class="block-title">Breakeven Point の定義</div>
<div class="block-content">

$$L^* = \frac{\Delta_{\text{clin}}}{\text{IQR} \cdot \text{nABCD}}$$

= $\Delta_{\max}$ が臨床的に問題になる閾値（$\Delta_{\text{clin}}$）に達する $L$ の値

</div>
</div>

### HbA1c の例

$$
L^* = \frac{0.4\%}{1.5\% \times 0.54} = 0.49
$$

> 「ベースライン HbA1c が 1% 違うと、治療効果が **0.49% 以上** 変わると思いますか？」

臨床家への問いに変換 → $L$ の**正確な推定は不要**、閾値との大小比較だけでよい。

---

<!-- _class: section -->

# Part 7
## 全体像の整理

---

# Heterogeneity Bound の 4 レベル

| レベル | 内容 | 核心 |
|:---:|------|------|
| 1 | **理論的基盤** | K-R 双対性が W₁ と Lipschitz 関数を結ぶ |
| 2 | **数学的構造** | $\Delta_{\max} = L \cdot \text{IQR} \cdot \text{nABCD}$（3要素の積） |
| 3 | **臨床的翻訳** | 抽象的な分布指標 → 臨床アウトカム単位 |
| 4 | **規制的正当性** | 保守的上界が ICH E17 に適合 |

<div class="alertblock">
<div class="block-title">なぜ "Theoretical Backbone" か</div>
<div class="block-content">

この bound があるから nABCD は「ただの分布距離」ではなく、
**治療効果の heterogeneity を定量的に評価するツール** になる。

</div>
</div>

---

# Clinical Calibration：5ステップの手順

| Step | 作業内容 |
|:---:|----------|
| 1 | 候補 EM を選び、nABCD と Bootstrap CI を計算 |
| 2 | $L$ を推定（事前知識 / サブグループ解析 / 感度分析） |
| 3 | $\Delta_{\max} = L \cdot \text{IQR} \cdot \text{nABCD}$ を計算 |
| 4 | CI を伝播：$[\Delta_{\max,L},\, \Delta_{\max,U}] = L \cdot \text{IQR} \cdot [\text{nABCD}_L,\, \text{nABCD}_U]$ |
| 5 | 治療効果・非劣性マージンと比較して判断 |

### $L$ の推定が難しい場合

- Sensitivity Analysis（$L$ の範囲を table で提示）
- Breakeven Point $L^*$（閾値との比較に変換）

---

# まとめ：Heterogeneity Bound が答える問い

| 問い | 答え |
|------|------|
| 分布が違うとき治療効果はどれだけ異なり得る？ | $\|\bar{\tau}_1 - \bar{\tau}_2\| \leq L \cdot W_1$ |
| なぜ $W_1$ か？ | K-R 双対性（Lipschitz 関数との対応） |
| nABCD の臨床的意味は？ | $\Delta_{\max} = L \cdot \text{IQR} \cdot \text{nABCD}$ |
| nABCD が大きければ必ず問題か？ | **No** &mdash; $L$ が小さければ影響は限定的 |
| $L$ が分からないときは？ | $L^*$（breakeven point）で逆算 |
| この bound は loose か？ | **No** &mdash; K-R 双対性により tight（最適） |

---

<!-- _class: end -->
<!-- _paginate: false -->

# Heterogeneity Bound

分布の違い → 治療効果の違いへの**理論的橋渡し**

$$|\bar{\tau}_1 - \bar{\tau}_2| \leq L \cdot \text{IQR} \cdot \text{nABCD}$$
