# Case Study 解説 — Harvey Specter

> "I don't play the odds. I play the man."
> この Case Study は、nABCD が reviewer に対して何を prove するかを理解するための資料だ。

---

## Slide 1: 全体構造 — なぜ2つの Case Study が必要か

```
┌─────────────────────────────────────────────────────┐
│          MRCT 計画段階の Sponsor の問い              │
│  「地域間の EM 分布差は、プーリングに影響するか？」  │
└─────────────────────┬───────────────────────────────┘
                      │
          ┌───────────┴───────────┐
          ▼                       ▼
┌─────────────────┐     ┌─────────────────┐
│   Case A        │     │   Case B        │
│   EM Unknown    │     │   EM Identified │
│                 │     │                 │
│  L 推定不可     │     │  L 推定可能     │
│  → L* 感度分析  │     │  → 臨床較正     │
│                 │     │  → Δ_max 算出   │
│  IST-1          │     │  IST-3          │
│  31ヵ国         │     │  8ヵ国          │
│  19,435人       │     │  3,035人        │
└─────────────────┘     └─────────────────┘
```

**ポイント**: Song et al. (2025) が指摘する通り、"It is extremely challenging to identify true effect modifiers"。
Case A（EM Unknown）が **実務で最も多い状況**。Case B は理想的状況。
両方を demonstrate することで、framework の **汎用性** を示す。

---

## Slide 2: 大前提 — データソースは臨床試験に限らない

```
┌──────────────────────────────────────────────┐
│          nABCD の入力データ                    │
│                                              │
│   x1 = 地域1 の EM ベースライン分布           │
│   x2 = 地域2 の EM ベースライン分布           │
│                                              │
│   ※ 治療アウトカムは不要                      │
│   ※ W1(F1, F2) = CDF 面積差のみ             │
└──────────────────────────────────────────────┘
                    │
    ┌───────────────┼───────────────┐
    ▼               ▼               ▼
┌────────┐   ┌──────────┐   ┌───────────┐
│先行試験 │   │レジストリ │   │ RWE/EHR   │
│IST-1   │   │SITS-MOST │   │ CPRD      │
│IST-3   │   │SEER      │   │ Medicare  │
└────────┘   └──────────┘   └───────────┘
  ← 今回はここを使用（publicly available な例として）
```

**核心**: nABCD は **planning-stage tool**。
ICH E17 Section 2.2.5 は "at the planning stage" でのプーリング判断を要求。
その判断に必要なのは **母集団の EM 分布** であり、臨床試験の治療データではない。

---

## Slide 3: Case A — EM Unknown (IST-1, 31ヵ国)

### シナリオ設定
- IST-1: 19,435人、31ヵ国、aspirin/heparin (1991-1996)
- 28のサブグループ解析で **有意な treatment × EM interaction なし** (全 p > 0.05)
- → L（CATE 感度）は推定不能
- → **nABCD は純粋な分布比較ツールとして機能**

### 465ペアの nABCD 計算（3つの候補 EM）

```
                Age           RSBP          Treatment Delay
Max nABCD:      0.565         ---           ---
Max pair:       India-UK      ---           ---

|SMD| vs nABCD
correlation:    high          0.906(最低)    variable
                              → scale/shape
                                heterogeneity大
```

### Geographic gradient（Age）
```
India ──── mean nABCD = 0.375 ──── 大きな分布差
  │
Singapore ── mean nABCD = 0.205
  │
Hong Kong ── mean nABCD = 0.121
  │
European countries ── smaller
```

**重要**: Asia vs Europe の geographic clustering が nABCD で定量化できる。

### L* 感度分析（Case A の核心手法）

**問い**: 「この分布差が臨床的に重要になるには、CATE 感度 L がどの程度必要か？」

```
India-UK Age (nABCD = 0.565):

  Δ_max = L × IQR_pooled × nABCD

  Δ_max = 2%pt を達成するのに必要な L* ≈ 0.005/年

  臨床的解釈:
  L* = 0.005/年 → 10歳の年齢差で治療効果が 5%pt 変化
  → これは modest な値（十分あり得る）
  → この分布差は clinically concerning
```

**判断ロジック**:
```
L* が小さい（modest）→ 「小さな interaction でも heterogeneity が生じる」
                     → プーリングに注意が必要
                     → 層別ランダム化、プロトコル制限を検討

L* が大きい（implausible）→ 「非現実的に大きな interaction が必要」
                          → 分布差は臨床的リスク低い
                          → プーリング可能
```

---

## Slide 4: Case B — EM Identified (IST-3, 8ヵ国)

### シナリオ設定
- IST-3: 3,035人、8ヵ国、alteplase vs control (2000-2012)
- Emberson et al. (2014) IPD meta-analysis で EM 確認済み:
  - **NIHSS**: interaction p = 0.001（IST-3）/ p = 0.06（meta-analysis）→ **強い EM**
  - **Age**: p = 0.614 / p = 0.53 → **弱い EM**
  - **Treatment delay**: p = 0.567（IST-3）/ p = 0.016（meta-analysis）→ **外部 evidence あり**

### Step 1: 28ペアの分布比較

| Candidate EM | Skewness | Min | Median | Mean | **Max** | Max pair |
|---|---|---|---|---|---|---|
| Age | -1.26 | 0.039 | 0.103 | 0.123 | **0.285** | Sweden-Belgium |
| NIHSS | 0.49 | 0.027 | 0.101 | 0.113 | **0.240** | Poland-Portugal |
| Treatment delay | 1.21 | 0.026 | 0.098 | 0.107 | **0.195** | Sweden-Australia |

**注目**: Age が最大の nABCD (0.285) を持つ。直感的には Age が最も "問題" に見える。

### Step 2: nABCD vs SMD — Treatment Delay の教訓

```
Norway vs Portugal (Treatment Delay):

  Mean delay:  Norway = 4.34h    Portugal = 4.33h    → ほぼ同一
  SMD = 0.007                                        → 「差なし」と判定

  しかし:
  Norway:   skewness = 6.76, SD = 1.80, range up to 24.3h
  Portugal: skewness = -0.23, SD = 1.21

  nABCD = 0.069                                      → 分布差を検出！

  ┌─── Norway ───┐          ┌─── Portugal ───┐
  │   ▓          │          │  ▓▓▓▓          │
  │  ▓▓▓    ····│···>      │ ▓▓▓▓▓▓▓        │
  │ ▓▓▓▓▓       │  長い尾  │▓▓▓▓▓▓▓▓▓       │
  └──────────────┘          └─────────────────┘
  0    4    8   12  16  20   0    4    8

  SMD は平均のみ比較 → 同一と判定
  nABCD は分布全体を比較 → 差を検出
```

**|SMD| vs nABCD の相関**:
- NIHSS: r = 0.98 (ほぼ一致 → 正規に近い分布)
- Age: r = 0.95
- **Treatment delay: r = 0.91** (最低 → scale/shape heterogeneity が大きい)

**メッセージ**: 分布が正規に近いとき SMD と nABCD は一致。**非正規のとき nABCD が本領発揮**。

---

## Slide 5: Clinical Calibration — Ranking Reversal（最重要 Finding）

### CATE 感度 L の推定

IST-3 の logistic regression（outcome: OHS 0-2 at 6 months）+ marginal standardization:

| EM | L_max | L_mean |
|---|---|---|
| NIHSS | 0.01398/pt | 0.00950/pt |
| Age | 0.00090/yr | 0.00065/yr |

### Δ_max の計算

```
Δ_max = L × IQR_pooled × nABCD
```

### ★ RANKING REVERSAL ★

```
                    nABCD        ×  L_mean        =  Δ_max
                    (分布差)        (CATE感度)        (臨床的影響)
                    ─────────       ──────────       ──────────
  Age:              0.285  ◄─大     0.00065/yr       0.47%pt ◄─小
  NIHSS:            0.240  ◄─中     0.00950/pt       5.02%pt ◄─大!!

  Overall treatment effect: RD ≈ 1.5%pt

  ┌─────────────────────────────────────────────────────┐
  │  Age:    Δ_max = 0.47%pt  << 1.5%pt  → 問題なし   │
  │  NIHSS:  Δ_max = 5.02%pt  >> 1.5%pt  → 要注意!!   │
  └─────────────────────────────────────────────────────┘
```

**これが論文の central message**:

> **分布差が大きい（nABCD が大きい）≠ 臨床的に重要**
>
> **臨床的重要性 = 分布差 × CATE 感度**
>
> **同じ nABCD でも、EM の clinical relevance によって結論が正反対になる**

### Sensitivity analysis（NIHSS）

```
L の範囲:     0.5×L_mean   L_mean    2×L_mean
Δ_max:        2.51%pt      5.02%pt   10.04%pt

→ どの L でも treatment effect (1.5%pt) を超える
→ NIHSS の分布差はプーリング判断に影響する
```

### Sensitivity analysis（Age）

```
L の範囲:     0.5×L_mean   L_mean    2×L_mean
Δ_max:        0.24%pt      0.47%pt   0.94%pt

→ どの L でも treatment effect (1.5%pt) 以下
→ Age の分布差はプーリング判断に影響しない
```

---

## Slide 6: Case A + Case B の統合 — Framework Decision Flow

```
┌──────────────────────────────────────────────────────┐
│           MRCT Planning Stage                         │
│  Sponsor が地域 EM 分布データを収集                   │
│  （臨床試験、RWE、レジストリ等から）                  │
└───────────────────────┬──────────────────────────────┘
                        ▼
            ┌──── 候補 EM ごとに ────┐
            │ nABCD + bootstrap CI   │
            │ を全地域ペアで計算     │
            └───────────┬────────────┘
                        ▼
           ┌────── L は推定可能か？──────┐
           │                             │
           ▼ NO                          ▼ YES
    ┌──────────────┐              ┌──────────────┐
    │   Case A     │              │   Case B     │
    │              │              │              │
    │ L* 感度分析  │              │ 臨床較正     │
    │ "L がいくつ  │              │ Δ_max 算出   │
    │  なら問題？" │              │ (= L·IQR·    │
    │              │              │    nABCD)    │
    └──────┬───────┘              └──────┬───────┘
           ▼                             ▼
    ┌──────────────┐              ┌──────────────┐
    │L* が modest  │              │Δ_max が      │
    │→ 注意が必要  │              │治療効果を    │
    │  層別化等を  │              │超える        │
    │  検討        │              │→ 注意が必要  │
    │              │              │              │
    │L* が大きい   │              │Δ_max が小さい│
    │→ リスク低い  │              │→ プーリングOK│
    │  プーリングOK│              │              │
    └──────────────┘              └──────────────┘
```

---

## Slide 7: この Case Study が Prove すること（5点）

### 1. nABCD は SMD では見えない分布差を検出する
- Norway-Portugal treatment delay: SMD ≈ 0 だが nABCD = 0.069
- Scale と shape の差が非線形 EM を通じて heterogeneity を生みうる

### 2. 臨床較正が ranking reversal を明らかにする
- Age: 大きい nABCD (0.285) → 小さい Δ_max (0.47%pt)
- NIHSS: 中程度の nABCD (0.240) → 大きい Δ_max (5.02%pt)
- **nABCD magnitude alone is insufficient — clinical calibration is essential**

### 3. Framework は EM-unknown と EM-identified の両方で機能する
- Case A: L* 感度分析（IST-1, 31ヵ国）
- Case B: 臨床較正（IST-3, 8ヵ国）
- 実務の spectrum 全体をカバー

### 4. データソースは臨床試験に限定されない
- nABCD の入力 = baseline EM 分布のみ（治療データ不要）
- RWE、レジストリ、EHR で十分
- IST-1/IST-3 は publicly available な representative data の一例

### 5. ICH E17 の "similar enough" を operationalize する
- 固定閾値ではなく、context-dependent な calibration
- Δ_max を treatment effect と比較して判断
- Sensitivity analysis で不確実性を明示

---

## Slide 8: Reviewer への Pre-emptive Defense

| 予想される攻撃 | 防御 |
|---|---|
| "IST-1/IST-3 は MRCT ではない" | nABCD は分布比較ツール。入力は EM 分布であり trial design に依存しない。Publicly available IPD の例として使用。実務では RWE 等を使用 |
| "L の class-transferability は仮定" | Sensitivity analysis (0.5×–2×) で robustness を demonstrate。NIHSS は全範囲で clinically meaningful |
| "Belgium n=73, Portugal n=82 < 推奨 n≥100" | Limitation として acknowledge。Bootstrap CI が wider であることを明記。Results は substantively unchanged when restricted to n≥100 countries |
| "Norway-Portugal は cherry-picked" | |SMD| vs nABCD correlation が NIHSS(0.98) > Age(0.95) > Delay(0.91)。Systematic pattern であり isolated example ではない |
| "L* analysis は "what if" にすぎない" | EM-unknown が most common planning scenario (Song 2025)。Fixed threshold よりも context-dependent sensitivity analysis が ICH E17 の精神に合致 |

---

*"Winners don't make excuses. They make adjustments."*
*この Case Study は adjustment の結果だ。IST-1 + IST-3 の dual structure、data-source agnostic framing、ranking reversal の demonstration——全てが reviewer の攻撃を anticipate している。*
