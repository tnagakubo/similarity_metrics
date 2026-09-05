# PAPER_LOGIC — per-EM W₁ paper argument map

**Date**: 2026-09-06（旧 `paper_logic_ja.drawio` / `paper_logic_ja.html` は `archive/` へ — 本書が後継）
**Manuscript**: `paper/per_em_W1_wiley.tex`（23 pp、本文 TODO 0、abstract は Terminal pass 待ち）

> ⚠ **節番号の正（compiled numbering, `.aux` 確認 2026-09-06）**:
> operability は **§2.5**（内部記録の「§2.6」は旧構成の呼称）。SMD の位置限定の定式化は **§2.1**。
> §2.1 existing / §2.2 W₁ / §2.3 estimation / §2.4 calibration / §2.5 operability / §3.1 Study 2 / §3.2 Study 1 / §4.1–4.5 / §5。

## 論理構造（縦 = 論証の流れ）

```mermaid
flowchart TD
  subgraph S1["§1 Introduction — gap"]
    A1["ICH E17: pooling を EM 分布類似性で記述<br/>metric・threshold・procedure なし"]
    A2["SMD は位置のみを捉える<br/>（構造的、§2.1 で定式化）"]
    A3["計画段階の要請:<br/>baseline 分布のみ・臨床解釈可能"]
  end
  S1 -->|"gap + 要請 → 尺度の選択"| S2
  subgraph S2["§2 Methods — 選択・理論・較正・operability"]
    B1["候補の棄却 (§2.1)<br/>SMD: 位置のみ / KS: 臨床尺度なし /<br/>KL: 不安定・密度推定"]
    B2["per-EM W₁・元の単位 (§2.2)<br/>= CDF 間の面積"]
    B3["KR 双対性 (Prop.1, §2.4)<br/>Δ_max = L_clinical · W₁（n 非依存）"]
    B4["L 既知 → Δ_max + bootstrap CI<br/>L 未知 → L* 逆算 @ Δ_clin<br/>（二重経路、§2.4）"]
    B5["推定 (§2.3): percentile bootstrap"]
    B6["operability (§2.5): null floor —<br/>この n で決定は解像するか"]
    B1 -->|採用| B2 --> B3 --> B4
    B2 --> B5 -->|較正の弧| B6
  end
  S2 -->|"主張 → 検証"| S3
  subgraph S3["§3 Simulation Studies — 2つの検証"]
    C1["Study 2: 決定性能 (§3.1)<br/>4 worlds × selection/clustering<br/>要約量系は ≥1 の妥当な世界で構造的盲目（任意の n）<br/>W₁ は全世界で回復 / KS は低効率・高コスト誤り (harm 2.14×)"]
    C2["Study 1: 推定特性 (§3.2)<br/>7 scenarios: bias・coverage 良好 (n ≥ 100)<br/>null 近傍の境界挙動 → §2.5 の根拠"]
  end
  S3 -->|"検証済みの道具で実データ"| S4
  subgraph S4["§4 Application — GUSTO-I 仮想 MRCT"]
    D1["設計 (§4.1)<br/>anchor R8 + 15 partners × {age, SBP}"] --> D2["operability (§4.2)<br/>SBP が決定を担う"] --> D3["W₁ 評価 (§4.3)<br/>EM 間で順位乖離 → 同時評価"] --> D4["臨床解釈 (§4.4)<br/>L* vs L_UB (AND) → 6 eligible・R4"] --> D5["全手法比較 (§4.5)<br/>一致 = location 優位 / controlled reading / 感度"]
  end
  S4 -->|"結果 → 含意（controlled）"| S5
  subgraph S5["§5 Discussion"]
    E1["¶1: 3 gaps closed —<br/>(i) identification ← Study 2<br/>(ii) 臨床尺度 ← KR bound<br/>(iii) 推定 + operability ← Study 1"]
    E2["¶4: 手続きは estimand に従う<br/>anchor 借用 → pairwise screening<br/>共有 pool → 直径制御 clustering"]
    E3["¶5–¶6: GUSTO 一致の controlled reading<br/>（判断④: 担い手は ¶5 のみ）<br/>評価と較正の分離可能性 (¶6)"]
  end
```

## 主張 ↔ 証拠の台帳（Discussion ¶1）

| 主張 | 内容 | 証拠の所在 |
|---|---|---|
| (i) identification | 要約量ベースの競合は少なくとも1つの臨床的に妥当な世界で構造的に盲目（任意の n）。W₁ は盲目でない | §3.1（gate: `R/verify_study2_figures.R` ALL PASS） |
| (ii) 臨床尺度 | Δ_max = L·W₁ が分布距離を臨床スケールへ翻訳（KS/RV には無い性質） | §2.4 Prop.1（KR 双対性、n 非依存） |
| (iii) 推定可能性 | percentile bootstrap が n≥100 で良好、null 近傍は operability が計画基準化 | §3.2 + §2.5 + §4.2 |

## 3つの最上位の問い

| 問い | 答える場所 |
|---|---|
| Q_metric — どの尺度か | §2.1–2.2（構造）+ §3.1（決定性能）+ §4.5（実データの controlled reading） |
| Q_calibration — 臨床的に何を意味するか | §2.4（二重経路）+ §4.4（L*/L_UB 判定） |
| Q_operability — その n で決定は解像するか | §2.5（null floor）+ §3.2（境界挙動）+ §4.2（GUSTO 診断） |

## 統治ルール（執筆上の不変条件）

- **判断④**: GUSTO 一致は Discussion ¶5 のみが担う。abstract には載せない
- **scope**: 論文の主張は Q_metric = 「W₁ は盲目でない」(identification)。効果追跡 sim は行わない
- **RV2/RV3 は我々の拡張** — 「小宮山の手法」と呼ばない（RV1 のみが as written）
- **abstract**: SIM 規定 250 words、Terminal pass で処理（B/C 草案は outline §0-bis）
