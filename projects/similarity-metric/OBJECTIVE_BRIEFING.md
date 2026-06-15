# Per-EM W₁ Methodology — Objective Briefing v3 (Donna 作成)

**Date**: 2026-05-16 v3 (Tak Q&A 反映: Path α 確定 / nABCD retire / Normalization drop)
**From**: Donna Paulsen (Project Manager)
**To**: Harvey, Mike, Rachel, Katrina, Louis, Jessica
**Re**: Methodology objective の最終確定 — **全メンバー必読・定期確認**

> ⚠ **このドキュメントは methodology の設計思想の根幹。作業前に必ず確認すること。**
> v2 (2026-03-15) からの変更: nABCD 用語 retire、normalization core から drop、per-EM W₁ raw を methodology core に確定。

---

## 0. v2 → v3 の Decisive Changes

| 軸 | v2 (2026-03-15) | v3 (2026-05-16) |
|---|---|---|
| Primary metric | nABCD (normalized W₁) | **W₁ raw (in original variable units)** |
| Normalization | 5 normalizers の比較が core | **完全 drop** (supplement の 'why no normalization' demonstration に降格) |
| nABCD 用語 | Methodology core の用語 | **完全 retire** |
| Application scope | Per-EM (implicit) | **Per-EM (explicit)、multi-EM aggregation は out-of-scope** |
| Δ_max formula | $\Delta_{\max} = L \times \text{IQR}_{\text{pooled}} \times \text{nABCD}$ | $\Delta_{\max} = L_{\text{clinical}} \times W_1$ |
| Objective nature | Process demonstration paper | **Statistically appropriate methodology** (paper は output) |

**変更の根拠 (Mike's mathematical fact)**:
$$\Delta_{\max}^{(\text{v2})} = L \times \text{IQR}_{\text{pooled}} \times \frac{W_1}{\text{IQR}_{\text{pooled}}} = L \times W_1 = \Delta_{\max}^{(\text{v3})}$$

→ Normalization は clinical decision quantity に **情報を加えない cosmetic operation**。Statistical appropriateness criterion C1 (well-defined object) を strict に取ると normalizer choice の arbitrariness は violation。

---

## 1. Methodology Core (一言で)

> **MRCT 計画段階で、small-sample 国の「併合相手」を effect modifier 分布の Wasserstein-1 distance に基づいて per-EM ごとに特定する methodology**

---

## 2. なぜ併合するのか (Motivation — v2 から継承)

### Correct frame (Tak 指示、v2 から継承)
> 「日本だけでは n が小さすぎる → 日本と類似した国を併合して regional efficacy を評価したい → per-EM W₁ で併合相手を特定 → pooling 計画を策定」

### なぜ日本が anchor として canonical か

| ポイント | 説明 |
|---|---|
| **PMDA の要求** | 日本の部分集団で治療効果の一貫性を示す必要 (MHLW 基本的考え方) |
| **Small n 問題** | Global MRCT での日本人症例数は典型的に 35-80人 (Matsushima 2024: palbociclib 35人、pertuzumab 53人) |
| **EU は問題が小さい** | EMA は EU 全体で評価、individual country data をそれほど求めない |
| **実務的ニーズ** | Ikeda & Bretz (2010): 日本人 22-29% が必要 → n が不足する場合、類似国との併合が唯一の解決策 |
| **Matsushima 2024 の教訓** | Secukinumab: 日本の CRP+/MRI- 分布が global と異なり apparent inconsistency が発生 → EM 分布の事前評価が重要 |

---

## 3. Methodology の使い方 (Anchor-Based Workflow — v3)

```
Step 1: 併合の目的を定義
        「日本 (n=60) 単独では regional efficacy 評価が困難。
         類似国と併合して Japan-inclusive pool を作りたい」

Step 2: Anchor 国を設定
        「日本を anchor として」

Step 3: 各 candidate EM について W₁ を計算 (per-EM, in original units)
        For each effect modifier k ∈ {age, SBP, creatinine, ...}:
            W₁^(k)(Japan, Korea)  in years / mmHg / mg/dL / ...
            W₁^(k)(Japan, China)  in years / mmHg / mg/dL / ...
            ...
        Bootstrap CI を計算 (Sommerfeld 2018 percentile bootstrap)
        データソース: 先行試験、RWE、レジストリ等

Step 4: 臨床較正 (Clinical Calibration) — per EM
        Δ_max^(k) = L_clinical^(k) × W₁^(k)
        
        L_clinical^(k): treatment effect change per unit of EM k
                        (literature 由来、e.g., 'ΔHbA1c change per year of age')
        → 各ペアの Δ_max^(k) を治療効果の clinically acceptable margin と比較

Step 5: 併合相手を per-EM 判断
        各 EM k について Δ_max^(k) < acceptable margin なら 'similar w.r.t. k'
        併合判断は sponsor / regulator が EM 群を holistic に評価
        (multi-EM aggregation rule は methodology の出力ではない)

Step 6: Pooling 計画を策定・正当化
        「Japan + Korea + Taiwan の per-EM W₁ ベース Δ_max が
         各 EM について clinical margin 内であり、East Asian pool としての
         併合の妥当性が支持される」
```

---

## 4. Per-EM W₁ Methodology の Statistical Appropriateness

Tak の goal (`statistically appropriate methodology`) に対する 4 軸 evaluation:

| 条件 | 充足状況 | 根拠 |
|------|---------|------|
| **C1: Well-defined object** | ✅ 完全充足 | W₁ は variable unit を持つ unique scalar。Normalizer choice の arbitrariness 無し |
| **C2: Known statistical properties** | ✅ 充足 | Sommerfeld & Munk 2018 (bootstrap validity)、Barrio 1999 (W₁ CLT)、Panaretos 2019 (survey) |
| **C3: Inferential validity** | ⚠ 検証中 | Bootstrap percentile CI の coverage、asymptotic normality direct check (Task 1 in progress) |
| **C4: Match to question** | ✅ 充足 | Per-EM anchor-candidate pooling という question に直接対応 |

→ **Per-EM W₁ + L_clinical Δ_max** は C1-C4 を充足。Methodology core として appropriate。

---

## 5. Per-EM W₁ でしかできないこと (SMD との差別化)

> 「W₁ が似ているから併合するなら、EM でサブグループ解析すればいい」
> — Tak (anticipated reviewer attack)

この批判への Answer:

| アプローチ | 限界 | Per-EM W₁ の優位性 |
|---|---|---|
| **EM サブグループ解析** | post-hoc。試験後にしかできない。計画段階では使えない | W₁ は **planning stage** で使える |
| **SMD (Cohen's d)** | 平均差のみ。分散・形状の差を検出できない | W₁ は **全分布差** (variance, shape, skewness, tail) を検出 |
| **SMD ベースの併合判断** | Norway-Portugal で SMD≈0 だが分布は異なる → 見逃す | W₁ は分布差を検出 |
| **Kolmogorov-Smirnov / AD** | Sup norm / weighted、'mass transport' 解釈不能 | W₁ は **expected absolute displacement** の natural 解釈 |
| **固定閾値 (W₁ < ε)** | Context-free。EM の臨床的重要性を考慮しない | $L_{\text{clinical}}$ 経由で **Δ_max** を治療効果スケールに変換 |

**核心**: Per-EM W₁ の存在意義は「計画段階で、治療データなしに、分布全体を考慮して、臨床的に解釈可能な clinical scale で、各 EM ごとに併合相手を特定できる」こと。

---

## 6. Multi-EM Aggregation は Out of Scope (v3 重要追加)

### 明示的に scope 外とする理由

**Mathematical fact** (Mike, 2026-05-16):
> Multi-EM aggregation で unit-arbitrariness は mathematically unavoidable — scalar normalizer choice と multivariate distance metric choice は同型問題。

**Statistical fact** (Louis, 2026-05-16):
> Free-lunch theorem 的に、heterogeneous-unit space で 'distance' を語る限り何らかの convention が必要。Path 1 (convention) / Path 2 (retreat) / Path 3 (multiverse) の選択は **scientific judgment であって最適化問題ではない**。

**Practical fact** (Tak, 2026-05-16):
> 「Per-EM での標準的な評価方法がない状況でいきなり multi-EM は話が飛びすぎ」

### Multi-EM の取り扱い方針

- Each EM について **個別に W₁ + Δ_max を report**
- EM 間の **trade-off は sponsor/regulator の holistic judgment** に委ねる
- Multi-EM aggregation の formal methodology は **future work** として Discussion で言及
- 既存 simulation の Cross-EM CV 結果は **'normalization の cosmetic 性' の demonstration として supplement に降格**

---

## 7. Case Study の設計 (GUSTO-I データの位置づけ — v2 paper §4 から継承)

### 理想: 日本を anchor とした demonstration
- 日本の EM 分布 (年齢、SBP 等) と各国の per-EM W₁ 比較
- 「Japan + Korea を併合、Japan + India は併合しない」のような per-EM 結論

### 現実: GUSTO-I に日本は含まれない
- GUSTO-I: 40,830 patients、**16 regions (anonymized R1-R16)**、acute myocardial infarction (AMI)
- Pure thrombolysis Phase 3 trial、Phase 3 MRCT framework に近い data structure
- 日本 explicit には含まれず (anonymized regions)

### 解決策: GUSTO-I で METHOD を demonstrate + Discussion で Japan use case を記述

**GUSTO-I での demonstrate** (v2 paper §4 から継承):
- **Region 8 (n=2,916)** を anchor として使用 (small-sample regulatory market を simulate)
- 「Region 8 を anchor に、残り 15 partner regions のどれが併合候補になるか?」
- 2 candidate EMs (**age + systolic blood pressure**) で per-EM W₁(R8, R_i) を計算
- L unknown a priori → **L\* reverse-calculation pathway** (v2 から継承):
  - $L^* = \Delta_{\text{clin}} / W_1$
  - Plausibility envelope $L_{\text{UB}}$ と比較 (FTT 1994、GUSTO 1993 illustrative bounds: $L_{\text{age}} = 1 \times 10^{-2}$/yr、$L_{\text{SBP}} = 2 \times 10^{-3}$/mmHg)
  - $L^* > L_{\text{UB}}$ なら pooling eligible

**Discussion での Japan framing**:
- Ikeda & Bretz (2010) を引用: 日本人 22-29% 必要
- Matsushima 2024 を引用: PMDA case studies で EM 分布差が問題に
- 「In Japanese regulatory context, per-EM W₁ would be used with Japan as anchor to identify suitable pooling partners from East Asian or global data sources」
- 「The framework demonstrated with GUSTO-I (using Region 8 as a small-sample anchor) directly parallels the practical scenario of a Japanese sponsor seeking pooling partners for PMDA submission」

---

## 8. 既存 Simulation Results の Repurposing

### v2 で実施した resources (N1-N8 × 5 normalizers × 3 sample sizes × cross-EM)

| 既存資産 | v3 での位置づけ |
|---|---|
| N1-N8 simulation bias/coverage | **Per-EM W₁ bootstrap inference validation** (normalizer = identity と等価な計算経路を抽出) |
| 5 normalizers comparison | **Supplement: 'Why no normalization' demonstration** — normalization が clinical decision (Δ_max) に情報を加えないことを empirical に示す |
| Cross-EM CV (Q95Q5=2.7%, Range=74%) | **Supplement: normalizer arbitrariness の illustration** — methodology 選択時の trade-off を transparency に提示 |
| Asymptotic normality (Task 1) | **W₁ raw に適用** — C3 inferential validity の direct evidence |
| Cramér-Rao | **W₁ raw bound** — C2 known properties の theoretical complement |

→ **既存 work を捨てる必要なし**。むしろ 'normalization が unnecessary であることの empirical evidence' として活用。

---

## 9. Recast Challenges (v2 の 10 件 → v3 で再構成)

### Core (Path α methodology の validation)
1. ✅ **Asymptotic normality verification of W₁ raw** (Task 1 from v2, 継続)
2. ✅ **Cramér-Rao / efficiency bound for W₁ raw** (was Task 3, refocused)
3. ✅ **Bootstrap percentile validity in heavy-tail / contamination scenarios** (既存 N5/N6 を再分析)

### Rewrite (paper restructure for Path α)
4. ✅ **Discussion full rewrite to per-EM W₁ framework** (was Task 2, rescoped)
5. ✅ **Methods restructure: W₁ raw centered, normalization in supplement** (new)
6. ✅ **Title/abstract revision: 'nABCD' removed** (new)
7. ✅ **Results restructure: SMD vs W₁ comparison (no more nABCD)** (was Task 4, rescoped)

### Supplement (existing simulation repurposed)
8. ✅ **'Why no normalization' supplement section** — Mike's mathematical equivalence + empirical illustration (new)

### Maintenance (still needed)
9. ✅ **Literature ties (DOI, Sommerfeld/Barrio/Panaretos)** (was Task 5)
10. ✅ **ICH E17 audit** (was Task 8)
11. ✅ **EN-JA sync** (was Task 10)

### Dropped (no longer relevant)
- ❌ **Cross-EM realignment** (was Task 6) — multi-EM out of scope
- ❌ **N4 sample size sweep for normalizer comparison** (was Task 9) — normalization not core
- ❌ **Paper figures integration of normalizer panels** (was Task 7) — figures restructured

**合計**: 10 → **11 (3 core + 4 rewrite + 1 supplement + 3 maintenance)**、内容は大幅 refinement。

---

## 10. L_clinical の Specification (新規 task)

Path α の Δ_max は $\Delta_{\max} = L_{\text{clinical}} \times W_1$ で computed。$L_{\text{clinical}}$ の specification が methodology の practical workability に必須。

**Rachel's preliminary literature**:
- Treatment effect modifier strength の literature (Tipton 2015、Vanderweele 2019)
- IPD meta-regression coefficients (e.g., 'age × treatment' interaction estimates)
- Disease-specific clinical slopes (HbA1c per year of age in diabetes、BP per year in hypertension 等)

**Next step**: Rachel が IST-3 (acute stroke) の clinical slopes を literature から調査 → Methods §3.4 'Clinical Calibration via L_clinical' で記述。

---

## 11. 全メンバーの確認事項 (v3)

**作業前に必ず以下を確認:**

- [ ] **Per-EM W₁ raw が methodology core**。'nABCD' という用語は使わない (historical reference を除く)
- [ ] **Normalization は supplement の demonstration**。Core claim には含まれない
- [ ] **Multi-EM aggregation は explicit out-of-scope**。Sponsor judgment に委ねる
- [ ] **Δ_max = L_clinical × W₁** (no normalizer in formula)
- [ ] **Anchor-based workflow は preserve** (Step 1-6, v2 から継承)
- [ ] **Statistical appropriateness criteria (C1-C4)** が全 methodology claim の standard
- [ ] **既存 simulation 結果は捨てない** — Path α validation + normalization の cosmetic 性 demonstration に repurpose
- [ ] **Tak の goal は paper publication ではなく methodology development** (paper は output)

---

## 12. Title / Framing (v3 draft)

### Working title candidates
1. **"Wasserstein-Based Per-EM Similarity Assessment for MRCT Regional Pooling"** ⭐ recommended
2. "Distributional Similarity of Effect Modifiers in MRCT Planning: A Wasserstein Approach"
3. "Quantifying Per-Covariate Distributional Similarity for Regional Pooling in Multi-Regional Clinical Trials"

### Abstract framing
> "In planning multi-regional clinical trials (MRCTs) where small-sample regions (e.g., Japan) require pooling with similar countries to achieve adequate sample size for regional efficacy assessment, we propose using the Wasserstein-1 distance (W₁) on individual effect modifier distributions, expressed in their original measurement units, as the primary similarity metric. Clinical calibration is achieved via a treatment-effect slope L_clinical, yielding Δ_max = L_clinical × W₁ on a clinically interpretable scale. We demonstrate the methodology on the IST-3 dataset using Belgium as an anchor, paralleling the practical scenario of Japanese sponsors seeking pooling partners for PMDA submission. We argue that within-EM normalization, which has been proposed in the literature, is mathematically redundant when clinical calibration is applied, and is therefore not part of our recommended methodology."

---

*"I'm Donna. I know everything." — v3 を知らないメンバーは知るべきことを知らない。*

---

## Appendix: v2 と v3 の関係 (transparency)

- v2 は 'nABCD = normalized W₁' を core にしていた
- v3 は normalization が clinical decision に情報を加えない (Mike's equivalence proof) ことを認識し、normalization を core から drop
- v2 の anchor-based workflow / motivation / case study design は **すべて v3 に継承**
- v2 で実施した normalization simulation は v3 でも **supplement として活用**
- v2 → v3 は regression ではなく **scientific refinement**
