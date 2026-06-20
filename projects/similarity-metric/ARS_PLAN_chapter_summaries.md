# ars-plan Chapter Summaries — Path α (per-EM W₁) Framework

**Project**: similarity-metric
**Process**: ars-plan Step 2 (Socratic chapter-by-chapter planning)
**Started**: 2026-06-15 (Introduction) | **Methods**: 2026-06-17
**Owner**: Donna (record) · Mike/Harvey (methods) · Tak (approver)

> これは ars-plan の **chapter PLAN**（paragraph-level summary）であり、実 LaTeX 実装ではない。
> 実装は全 chapter plan 確定後（Resume Protocol step 7）。EN = original、JA は後で sync（Rule 2.7）。

---

## Chapter 1: Introduction — ✅ Finalized (2026-06-15)

P1 MRCT 文脈 → P2 Urgency（適切な方法論未確立）→ P3 EM 概念（Matsushima 2024）→ P4 Gap reframed（方法論的 vacuum：「既存方法批判」ではなく「ICH E17 は qualitative criteria のみ」）→ P5 Contribution（Wasserstein + L_clinical）→ P6 Scope boundary（EM pre-specified 前提）→ P7 Reader expectation。

- Word count: ~700–800
- Gap framing: ✅ "No established methodology exists; ICH E17 only provides qualitative criteria"（既存方法 strawman を回避）

---

## Chapter 2: Methods — ✅ §2.1 Finalized (Round 1+2, 2026-06-17)

### Round 1 決定事項（Tak 回答ベース）

| Q | 決定 |
|---|---|
| **Q3.1 novelty 重心** | = **clinical interpretation への翻訳**。Proposition は *手段*、§2.4 Calibration が *重心*。「W₁ の古典性は無関係 — 分布距離を outcome 単位の治療効果差に翻訳したことが貢献」 |
| **Q3.2 既存手法の網羅** | from-scratch 再検討 → §2.1 を **「4系統 taxonomy → 3要件で選出」** に再構成。divergence を *強敵* として正面から扱う |
| **Q3.3 最大の limitation** | = **bootstrap 依存の inference**（del Barrio 非標準漸近 → 解析的 CI 不可）。§2.3 で明示 → §5 Discussion で正面扱い。Burying しない |

### 物語の背骨（Q3.1 反映）

§2.0 動機（地域 ATE = ∫τ dF）→ **§2.1 候補手法の選出（taxonomy → W₁）** → §2.2 W₁ 定義 + Proposition（*手段*）→ §2.3 Estimation（bootstrap + その限界を明示）→ **§2.4 Clinical Calibration（*重心*：Δ_max / L*）**

---

### §2.1 再構成プラン（NEW — 旧「羅列してダメ出し」を置換）

**Subsection title 案**: "Measuring Distributional Similarity: Candidate Approaches"

**設計原理**: 答え（W₁）を先に置かず、「分布の類似性を評価せよ」と言われた統計家が手に取る手法を4系統で棚卸しし、**この問題固有の3要件**が候補空間から W₁ を選び出す、という選択の論理で書く（Tak P2: 選択肢→選択→理由、P5: 主張と証拠の比例）。

**P1 — 問いの設定と4系統**
Pooling 適性の評価には2地域の EM 分布差の測定が要る。統計学は「類似性の何の側面か」で4系統を提供する：①検定（同じ分布か？）②モーメント効果量（要約統計の差）③ダイバージェンス（隔てる情報量）④輸送／距離（質量移動量）。どれを選ぶかは、この問題が課す要件に依存する（→ P4 で要件提示）。

**P2 — 系統①②：検定・モーメント効果量**
二標本検定（KS, Cramér–von Mises, Anderson–Darling；location は t/Wilcoxon、scale は F/Levene）は「同じ分布か (yes/no)」を答える testing frame。本問題に不適：(a) 必要なのは estimation であり testing でない、(b) 大標本では trivially 棄却、(c) p 値は臨床的 magnitude を持たない。SMD は共変量バランスの実務標準だが、location という単一モーメントのみを捉え、分散や形状には盲目。
> Round 2 決定（②）: **分散比 (variance ratio) は言及しない**（Tak 判断）。P2 は SMD のみで論を立てる。

**P3 — 系統③：ダイバージェンス（強敵として正面から）**
KL, Jensen–Shannon, Hellinger, 全変動(TV) は「2分布の違い」への正準的（情報理論的）回答であり、SMD と違い *全分布* を捉える — これは強い。しかし本問題で3つの本質的限界：(i) **ground-metric blind → 飽和**：ほぼ重ならない地域分布では TV→1, KL→∞ となり「遠い」と「もっと遠い」を区別できず、**partner ranking（本研究の application）が不可**；(ii) **無次元**（nats / 確率）→ 臨床 outcome スケールへ翻訳不可；(iii) **Lipschitz 双対を欠く** → 治療効果差を縛れない（Pinsker は *有界* 関数のみ、*非有界* outcome の平均差は縛らない）。加えて KL は非対称、小標本での密度推定が脆弱。

**P4 — 系統④：輸送／距離、そして W₁ の選出**
Wasserstein, energy distance, MMD, Cramér 距離は台の幾何を尊重し、divergence の飽和問題を回避する。この系統の中で clinical calibration の要件が W₁ をほぼ一意に選出する：W₁ は変数自身の臨床単位を持ち（energy/MMD は二乗乖離単位、Cramér/CvM は CDF 差の L²）、Kantorovich–Rubinstein の **1-Lipschitz 双対** を唯一持って |τ̄₁−τ̄₂| ≤ L·W₁ を生む（W₂・Cramér(L²)・energy・MMD は不可）。**3要件 — (i) 全分布感応、(ii) 臨床単位較正、(iii) Lipschitz 双対による治療効果 bound — が結合して W₁ を選び出す**。詳細は §2.2 で展開。

**知的誠実性の一節（✅ Round 2 確定①: 抑制的に inclusion）**: P4 末尾に **1文** だけ。「W₁ が選ばれるのは普遍的に最良の距離だからではなく、本問題が課す3要件を同時に満たす唯一の候補だから」。**requirement-driven framing を明示**し、「divergence と等価」という切り取られ方を防ぐ（Louis 懸念対応）。段落化しない。Tak P5 合致。

**文献裏づけ（Rachel 確認済、新規ほぼ不要）**: 飽和 / ground-metric blindness は最適輸送の標準論点（Panaretos & Zemel 2019, Villani 2009）；Pinsker, Kantorovich–Rubinstein は既存 cite で対応。SMD は Austin 2011。

---

### §2.2–§2.4（既存ドラフト成熟、Round 1 決定を反映）

- **§2.2 Per-EM W₁**: 3等価表現 + 単位整合 + Proposition（heterogeneity bound）。Q3.1 反映 — Proposition を「臨床翻訳の *手段*」として位置づけ（それ自体を novelty の終点としない）。
- **§2.3 Estimation**: 経験 W₁ + percentile bootstrap。Q3.3 反映 — 「解析的 CI が作れない（del Barrio 非標準漸近）ため bootstrap に依存」を limitation として明示し、§5 へ forward。
- **§2.4 Clinical Calibration（重心）**: L_clinical, Δ_max = L·W₁, L* reverse-calc, L_UB の dual-pathway。novelty の到達点として最も厚く書く。

---

### Round 2 決定（✅ 全 resolved, 2026-06-17）
1. ✅ 知的誠実性の一節 → **抑制的に入れる**（1文、requirement-driven framing）
2. ✅ 分散比 → **入れない**（SMD のみで P2 を構成）
3. ✅ energy/MMD → **現状維持**（P4 で既に1文ずつ言及、深掘りせず）

→ **§2.1 plan finalized**。次回の選択肢: (A) §2.2–§2.4 の Round 1（Q3.1/Q3.3 反映を paragraph plan に落とす）、(B) §2.1 を実 LaTeX に展開、(C) Results chapter Round 1 へ。

---

## Chapter 3: Results (Simulation + Application) — ⏸ 未着手
## Chapter 4: Discussion — ⏸ 未着手
## Step 2.5: Contribution Sharpening — ⏸
## Step 3: Argument Stress Test — ⏸
