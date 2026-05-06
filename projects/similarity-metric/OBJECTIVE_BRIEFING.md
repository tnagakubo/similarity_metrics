# nABCD Paper — Objective Briefing v2 (Donna作成)

**Date**: 2026-03-15 v2 (Tak reframe 反映)
**From**: Donna Paulsen (Project Manager)
**To**: Harvey, Mike, Rachel, Katrina, Louis, Jessica
**Re**: 論文目的の最終確定 — **全メンバー必読・定期確認**

> ⚠ **このドキュメントは論文の設計思想の根幹。作業前に必ず確認すること。**

---

## 1. nABCD とは何か（一言で）

> **MRCT 計画段階で、small-sample 国の「併合相手」を EM 分布に基づいて特定するツール**

---

## 2. なぜ併合するのか（Motivation First — これが全ての出発点）

### ❌ Wrong frame（旧）
> 「全ペアの nABCD を計算 → 類似/非類似を判定」
> → これは descriptive statistics exercise。EM でサブグループ解析すればいいだけ。

### ✅ Correct frame（Tak 指示）
> 「日本だけでは n が小さすぎる → 日本と類似した国を併合して regional efficacy を評価したい → nABCD で併合相手を特定 → pooling 計画を策定」

### なぜ日本がベストな anchor か

| ポイント | 説明 |
|---|---|
| **PMDA の要求** | 日本の部分集団で治療効果の一貫性を示す必要がある（MHLW 基本的考え方） |
| **Small n 問題** | Global MRCT での日本人症例数は典型的に 35-80人（Matsushima 2024: palbociclib 35人、pertuzumab 53人） |
| **EU は問題が小さい** | EU の各国当局は individual country data をそれほど求めない。EMA は EU 全体で評価 |
| **実務的ニーズ** | Ikeda & Bretz (2010): 日本人 22-29% が必要 → n が不足する場合、類似国との併合が唯一の解決策 |
| **Matsushima 2024 の教訓** | Secukinumab: 日本の CRP+/MRI- 分布が global と異なり、apparent inconsistency が発生 → EM 分布の事前評価が重要 |

---

## 3. nABCD の使い方（Anchor-Based Workflow）

```
Step 1: 併合の目的を定義
        「日本 (n=60) 単独では regional efficacy 評価が困難。
         類似国と併合して Japan-inclusive pool を作りたい」

Step 2: Anchor 国を設定
        「日本を anchor として」

Step 3: 日本と各候補国の nABCD を計算
        各 candidate EM について:
        nABCD(Japan, Korea), nABCD(Japan, China), nABCD(Japan, UK), ...
        データソース: 先行試験、RWE、レジストリ等

Step 4: 臨床較正（Clinical Calibration）
        Δ_max = L × IQR_pooled × nABCD
        → 各ペアの Δ_max を治療効果と比較

Step 5: 併合相手を選定
        Δ_max < 臨床的に許容される閾値 → 併合候補
        例: Japan + Korea + Taiwan → "East Asian pool"

Step 6: Pooling 計画を策定・正当化
        「Japan + Korea + Taiwan を pooled East Asian region として
         regional efficacy を評価する。nABCD に基づく Δ_max は
         治療効果の X% 以内であり、併合の妥当性が支持される」
```

---

## 4. nABCD でしかできないこと（SMD との差別化）

> 「nABCD が似ているから併合するなら、EM でサブグループ解析すればいい」
> — Tak

この批判への Answer:

| アプローチ | 限界 | nABCD の優位性 |
|---|---|---|
| **EM サブグループ解析** | post-hoc。試験後にしかできない。計画段階では使えない | nABCD は **planning stage** で使える |
| **SMD** | 平均差のみ。分散・形状の差を検出できない | nABCD は **全分布差**（variance, shape, skewness）を検出 |
| **SMD ベースの併合判断** | Norway-Portugal で SMD≈0 だが分布は異なる → 見逃す | nABCD は分布差を検出（nABCD=0.138） |
| **固定閾値** | Context-free。EM の臨床的重要性を考慮しない | 臨床較正で **Δ_max** を治療効果スケールに変換 |

**核心**: nABCD の存在意義は「計画段階で、治療データなしに、分布全体を考慮して、臨床的に解釈可能な形で併合相手を特定できる」こと。

---

## 5. Case Study の設計（IST データの位置づけ）

### 理想: 日本を anchor とした demonstration
- 日本の EM 分布（年齢、重症度等）と各国の比較
- 「Japan + Korea を併合、Japan + India は併合しない」のような結論

### 現実: IST データに日本は含まれない
- IST-1: 31ヵ国（India, Singapore, Hong Kong あり。日本なし）
- IST-3: 8ヵ国（全て欧豪。日本なし）

### 解決策: IST で METHOD を demonstrate + Discussion で Japan use case を記述

**IST-3 での demonstrate**:
- Belgium (n=73) を anchor として使用（日本と同じ small-n 問題）
- 「Belgium を anchor に、どの国が併合相手になるか？」
- nABCD(Belgium, X) を計算 → Δ_max で評価 → 併合候補を特定

**Discussion での Japan framing**:
- Ikeda & Bretz (2010) を引用: 日本人 22-29% 必要
- Matsushima 2024 を引用: PMDA case studies で EM 分布差が問題に
- 「In Japanese regulatory context, nABCD would be used with Japan as anchor to identify suitable pooling partners from East Asian or global data sources」
- 「The framework demonstrated with IST-3 (using Belgium as a small-sample anchor) directly parallels the practical scenario of a Japanese sponsor seeking pooling partners for PMDA submission」

---

## 6. 全メンバーの確認事項

**作業前に必ず以下を確認:**

- [ ] nABCD は「全ペアを眺めるツール」ではなく「**anchor 国の併合相手を特定するツール**」
- [ ] Motivation first: 「**なぜ併合するのか**」が先。類似性評価はその手段
- [ ] データソースは臨床試験に限らない（RWE, registry, EHR OK）
- [ ] Planning-stage tool: 治療データ不要、ベースライン EM 分布のみ
- [ ] Clinical calibration: nABCD magnitude alone は insufficient。Δ_max が判断基準
- [ ] Process demonstration, not prescription: 「would warrant attention」not「should pool」

---

*"I'm Donna. I know everything." — そしてこの briefing を知らないメンバーは、知るべきことを知らない。*
