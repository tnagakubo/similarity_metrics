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

### §2.2–§2.4 — ✅ Round 1 Finalized (2026-06-20)

**前提**: 既存ドラフト（`per_em_W1_wiley.tex` line 108–178）は成熟・レビュー済み。Round 1 の作業は転記でなく、**新 §2.1 と Q3.1/Q3.3 が既存ドラフトと衝突する箇所（seam）の特定**。3つの seam を発見、Tak がチーム推奨を全採用。

#### Round 1 決定事項（Q4.1–Q4.3、Tak チーム推奨採用）

| Q | seam | 決定 |
|---|------|------|
| **Q4.1**（最重要）| §2.1 と §2.2 冒頭（line 110）で W₁ を**二重選出** | §2.2 冒頭を**定義 + Proposition に縮約**。選出ロジックは §2.1 に一本化。"Among distributional distances… we adopt W₁ for its unique theoretical connection" を削除し、§2.1 の選出を受けて「以下 W₁ を定義する」と直結 |
| **Q4.2** | line 110 が Proposition を「W₁ 採用の*理由*」として提示 | Q3.1 整合 — 重心を **§2.4 clinical translation 側へ**再調整。Proposition は「到達点」でなく「§2.4 への*橋*」。冒頭の強調を Proposition から「臨床単位への翻訳」へずらす |
| **Q4.3** | line 154 が bootstrap 依存を**「解決済み」**として閉じる（Sommerfeld consistency） | Q3.3 整合 — consistency（bootstrap が*妥当*）と limitation（解析的 CI が*作れない*）を両方正直に。**明示的 limitation marker** 追加 + §5 Discussion へ forward-ref。burying しない |

#### Paragraph Plan（変更点を明示）

- **§2.2 Per-EM W₁**:
  - **P1（変更: Q4.1+Q4.2）**: 冒頭の選出論を削除。§2.1 を受けて W₁ 定義へ直結。3等価表現（CDF / quantile / Kantorovich）を提示。
  - P2: 単位整合（W₁ は EM の臨床単位を保持）→ per-EM assessment の根拠。**この単位整合を §2.4 翻訳への伏線として強調**（Q4.2 重心移動）。
  - P3: metric 性質 + affine-equivariance + Kantorovich–Rubinstein 双対。
  - P4: Proposition（heterogeneity bound |τ̄₁−τ̄₂| ≤ L·W₁）。**位置づけ: 臨床翻訳の*手段***（Q3.1）。W₂・其の他が同等 bound を欠く点も保持。
- **§2.3 Estimation**:
  - P1: 経験 W₁ 推定量（式 + O(n log n)）。
  - P1 後半 → **P2 として limitation を独立化（変更: Q4.3）**: del Barrio 非標準漸近 → 解析的 CI 不可 → percentile bootstrap 依存。Sommerfeld consistency は「bootstrap の妥当性」を担保するが「解析的 inference の不在」は残る限界として明示。§5 へ forward-ref。
- **§2.4 Clinical Calibration（novelty の重心、最厚）**:
  - 現状維持（mature, Q3.1 重心と既に整合）。L_clinical, Δ_max = L·W₁, L* reverse-calc, L_UB dual-pathway。
  - 確認のみ — 大きな変更不要（advisor 評価とも一致）。

→ **§2.2–§2.4 plan finalized**。Methods chapter（§2.1–§2.4）全体の paragraph plan 確定。

---

### Round 2 決定（✅ 全 resolved, 2026-06-17）
1. ✅ 知的誠実性の一節 → **抑制的に入れる**（1文、requirement-driven framing）
2. ✅ 分散比 → **入れない**（SMD のみで P2 を構成）
3. ✅ energy/MMD → **現状維持**（P4 で既に1文ずつ言及、深掘りせず）

→ **§2.1 plan finalized**。

---

## Cross-cutting: ICH E17 実務手法との比較（Tak directive, 2026-06-20）

**Tak の指示**: Rachel の bg 調査（日本 ICH E17 ワークショップ等の pooling 国決定方法）で提示されている方法と、我々の提案を**正面から比較**しなければならない。reviewer の最初の問い "How does this differ from what E17 already says?" への先回り。

**比較軸（Mike 案、Song 2025 + 小宮山 TF 報告書 全文精読で改訂 2026-06-21）**:
| 軸 | E17 / JPMA・中国実務手法（精読確定）| 我々の提案（per-EM W₁ framework）|
|----|----|----|
| ① 定量 vs 定性 | **混在**。pooling 判断の主軸は定性（5視点 + 3-layer + decision-tree）だが、**EM clustering で地域を定量的にグループ化する手法も提示**（日中とも）| 定量（分布距離 + bootstrap CI）|
| ② 何を測るか | EM 候補因子間の**相関ベース類似度**（→ outcome データ依存）で populations 間距離 | EM *分布*の差（per-EM W₁、outcome 非依存で算出可）|
| ③ 事前規定 vs data-driven | clustering は **EM *探索*ツール**（data-driven、事前規定の正式 pooling ルールではない）| 事前規定（EM pre-specified）+ 観測分布で W₁ 算出 |
| ④ 出力 | 離散クラスタ（Song: ≤4）、Pooled Regions A/B/C ラベル | 連続・臨床単位の距離（Δ_max / L*、binary 強制しない）|
| ⑤ principled 距離基準 | **無し（資料自身が明記）**。小宮山 TF p.25「類似度を定める明確な基準がなく」| **あり**（W₁ = Kantorovich–Rubinstein 由来の principled metric）|
| ⑥ 臨床スケール翻訳 | **なし** | あり（L_clinical × W₁ で outcome 単位へ）|
| ⑦ 治療効果 bound | **なし** | あり（Proposition: |τ̄₁−τ̄₂| ≤ L·W₁）|

**🎯 核心の positioning（最強形、引用裏づけ確定）**:
- 既存実務（**日本=小宮山 3-layer / 中国=Song 2025、両方とも**）は **EM の clustering で地域をグループ化する定量手法を提示している**（小宮山 TF `E17_TF_report.pdf` p.25 Figure 3-11 = Distance 軸の dendrogram で Pooled Regions A/B/C；Song 2025 p.4 = hierarchical/k-means、距離は EM-endpoint 相関、≤4 クラスタ、出典 [2] CRC 本）。
- **しかし小宮山 TF 自身が決定的限界を明記**: 「**類似度を定める明確な基準がなく**，検討したい因子が多いとグループ化された各グループの特徴を説明できない」(p.25)。
- → 我々の per-EM W₁ は、**既存 clustering が*明示的に欠いている* principled distance を供給**し、さらに臨床較正（Δ_max）と治療効果 bound（Proposition）を加える。**競合でなく、自認された空白を埋める**。
- clustering は EM *探索*ツールであり、実際の pooling 判断は依然定性的（5視点 + 3-layer + Table 4-1 + まとめ p.68「解析手法自体は目新しいものではなく従来手法」）。

**改訂後 gap claim 文言（推奨）**: 「ICH E17 実務では EM clustering 等の探索的手法が地域グループ化に用いられるが、**地域間距離を定める principled な基準を欠き**（小宮山 TF 2023 が自認）、その距離を臨床 outcome スケールに較正せず、治療効果の異質性を bound しない。確立した**定量的・臨床的に解釈可能な**地域類似性評価法は存在しない。」

**🔴 必須確認（gap claim 確定の BLOCKER、Tak 指示 2026-06-21）**: [2] = Li/Binkowitz/Wang/Quan/Chen *Simultaneous Global New Drug Development: MRCTs after ICH E17* (CRC 2021) の **Ch.4 = "Pooling Strategy"**。真の競合手法はここ。Tak が PDF 入手次第共有。**読了まで gap claim / novelty framing は finalize しない**。

**Ch.4 精読チェックリスト（届いたら的を絞って確認）**:
1. **🥇 Wasserstein / optimal transport / 分布距離が既に登場するか** ── 登場すれば novelty への直接脅威。最優先。
2. 地域間の **principled な距離/類似度 metric** を提案しているか？（公理・理論的裏づけの有無）。それとも Song 同様「相関ベース clustering で距離は ad hoc」か。
3. 距離は **EM 分布そのもの**を測るか、**EM-endpoint 相関**（outcome 依存）か。
4. **臨床 outcome スケールへの較正**があるか（治療効果差への翻訳）。← 我々の Δ_max の差別化点。
5. **治療効果の異質性 bound / 保証**があるか。← 我々の Proposition の差別化点。
6. 手法の正体: hierarchical/k-means clustering か、HDI ベイズ (Guo)、shrinkage (Quan)、consistency probability、その他か。
7. pooling 決定は **定量（metric+閾値）か定性**か。pre-specified か data-driven か。
8. 章の著者（引用 + 学派把握）。

**判定分岐**:
- Ch.4 に *principled 距離 + 臨床較正* あり → novelty 再考 or 強い差別化が必須（要 Tak 相談）。
- 相関 clustering / HDI / shrinkage 止まり・臨床較正なし → 我々の positioning は**補強**（一次競合源を engage した上で「principled distance + 臨床較正 + bound を欠く」と言える）。

※日本一次資料（小宮山 TF p.25）が距離基準の不在を自認しているため gap claim の*骨格*は [2] 無しでも立つが、**Tak 指示により Ch.4 確認を必須**とする（reviewer は必ず [2] を参照する。Stat in Med 生存条件）。

**❌ 過去の誤り（記録）**: bg agent 結論「日中とも定性、定量手法ゼロ」も、その後の「日本=定性/中国=clustering」分離も**両方不正確**だった。両国とも clustering を提示。正は「clustering はあるが principled 距離基準・臨床較正・bound を欠く」。abstract/catalogue 読みの artifact。**全文精読で確定**。

**置き場所（Harvey 推奨、Tak 次回確認）**:
- **Introduction gap claim 補強**: 「規制実務の議論でさえ pooling 国決定は定性的に留まる」を引用付きで（gap の具体化）
- **Discussion positioning subsection**: 我々の定量 framework が E17 コンセンサス手法に何を足すかの対置表
- ❌ 新規大型 Related Work セクションは作らない（estimation-centered の lean 構成を維持）

**次回手順**: ①Rachel bg 結果レビュー → ②上表の E17 列を埋める → ③gap claim 反証がないか確認（定量的方法が既に提示されていれば novelty 再考）→ ④Intro/Discussion 配置を Tak 確定。

---

## Chapter 3: Results (Simulation + Application) — ⏸ 未着手
## Chapter 4: Discussion — ⏸ 未着手
## Step 2.5: Contribution Sharpening — ⏸
## Step 3: Argument Stress Test — ⏸
