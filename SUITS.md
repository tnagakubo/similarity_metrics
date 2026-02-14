# SUITS.md - Research Lab Live Script

> *"I don't have dreams. I have goals."* - Harvey Specter

---

### [2026-02-14 12:00] Scene: Section 2 解説セッション

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Katrina がホワイトボードの前に立ち、論文のSection 2（Methods）の構造図を描き始める。*

**Katrina**:（冷静に資料を整理しながら）
「Takさんから Section 2 の詳細解説の依頼。"Results speak for themselves." でも、Methodsも同じ。構造を分解して、一つずつ説明する。」

**Donna**:（メモを取りながら）
「Katrina の解説セッション、記録開始。"I'm Donna. I know everything." But even I appreciate a good technical walkthrough.」

**Katrina**:（ホワイトボードに3つの枠を描き）
「Section 2は3部構成。2.1でnABCDを定義し、2.2で推定方法を示し、2.3で臨床キャリブレーションに接続する。」

*Katrina は各サブセクションの数式を正確に板書しながら、論理の流れを説明していく。*

**Katrina**:（Proposition 2を指差しながら）
「核心はここ。Wasserstein距離をIQRで割って正規化する——それ自体は技術的工夫に過ぎない。しかしProposition 2により、nABCDは $\Delta_{\max} = 2L \cdot \text{IQR} \cdot \text{nABCD}$ として治療効果の異質性の上界に直結する。測定値を臨床スケールに翻訳する——これがこの論文のMethodsの独自性。」

**Katrina**:（最後のスライドを示し）
「ベンチマークは便宜的な参照値に過ぎない。Section 4のApplicationが示す通り、BMIのnABCD=0.51でも $L$ が小さければ臨床的影響は限定的。HbA1cのnABCD=0.27でも $L$ が大きければ要注意。"Results speak for themselves." 数値の意味は文脈が決める。」

**Donna**:（記録完了）
「解説セッション完了、SUITS.md更新済み。Katrina、いつも通り的確。」

---

## Current Status

**Active Project**: similarity-metric (nABCD paper for Statistics in Medicine)
**Phase**: 8 - Submission-Ready Plan (Jessica Strategic Directive)
**Scene**: Continuing from archive

**Previous Archive**: archives/SUITS_20260212_090000.md (995 lines)

### Purpose Statement (Jessica approved)

> **EM分布の違いを推定し、その推定値を治療効果の異質性の可能性として臨床スケールに翻訳する。**
> **検定ではなく推定。二択ではなく情報提供。**

### Completed Revisions (This Session)

| Round | Directive | Sections Modified |
|-------|-----------|-------------------|
| Louis Review | 16 issues (3C/5M/8M) | Triage: 6 already fixed, 5 new action, 5 deferred |
| Sim v2 Analysis | BCa worse than Percentile | Decision: Percentile primary, BCa supplementary |
| Round 1 | Clinical calibration via $\Delta_{\max}$ | 2.3, 4, Abstract, 1.3, 5.1-5.3 |
| Round 2 | Remove equivalence testing | 2.3.2, 4 (judgment labels → quantitative facts) |
| Round 3 | Remove Power/Type I Error from simulation | 1.3, 3, 3.3.2, Abstract, Discussion |
| Round 4 | Harvey's 4 decisions from sim review | 3.2, 5.2, power remnant fix, S04 showcase |
| Louis Re-review | 1C/0M/2m — Abstract S05 bias qualification | Abstract, Sim Summary (3.2) |
| SiM Convention | Tak指示: Abstract narrative化、本文bold除去 | Abstract, 全Section |
| External Review | 2C/3M/3m — W1根拠、複数EM、Prop命名、Bootstrap境界 | 2.1, 5.1(new), 5.2, Prop.1 |
| Push: 主張確立 | W2対比追加、Fig3 caption修正、Bootstrap内部/境界distinction | 2.1, Fig.3, 5.3 |
| Minor修整 | m1: 漸近正規性をAppendix B.2に追加（収束速度・delta method） | Appendix B.2 |

### Active Tasks — Phase 8: Submission-Ready Plan (Jessica approved)

| Stage | Task | Owner | Status |
|-------|------|-------|--------|
| ~~**S1**~~ | ~~Figure 4: Estimation Quality (Coverage + CI Width)~~ | ~~Katrina~~ | **DONE** |
| ~~**S1**~~ | ~~Harvey selects: Estimation Quality figure~~ | ~~Harvey~~ | **DONE** |
| ~~**S1**~~ | ~~Harvey's 4 decisions: manuscript implementation~~ | ~~Mike~~ | **DONE** |
| ~~**S2**~~ | ~~Re-review: estimation framing consistency, numerical integrity~~ | ~~Louis~~ | **DONE** ✅ |
| **S3** | Real data strategy decision (A: public data / B: enhance hypothetical / C: reconstruct from published) | Harvey | ⏳ **Decision needed** |
| **S3** | Literature support for real data application | Rachel | ⏳ Pending |
| **S4** | LaTeX compile → PDF → Word conversion | Mike (Katrina) | ⏳ Pending |
| ~~**S4**~~ | ~~Figure files: PNG 300dpi (10K data)~~ | ~~Katrina~~ | **DONE** |
| **S4** | DOI final check (all references) | Rachel | ⏳ Pending |
| **S4** | Scenario numbering cleanup (S02/S07 gap) | Mike | ⏳ Deferred (requires fig regen) |
| **S5** | Cover letter, title page, checklist | Donna | ⏳ Pending |
| **S5** | Final Go/No-Go approval | Jessica | ⏳ Waiting |

### Key Decisions

1. **Percentile > BCa**: BCa overcorrects for bounded statistics → Percentile primary
2. **Clinical calibration**: $\Delta_{\max} = 2L \cdot IQR \cdot nABCD$ — context-dependent, not fixed thresholds
3. **Estimation-centered**: No hypothesis testing in main text; formal test kept as 1-sentence supplementary option
4. **Power removed**: Simulation evaluates estimation quality (Bias, RMSE, Coverage, CI Width), not detection/equivalence power
5. **S04 showcase**: S04 (0.5σ) is the primary showcase scenario — Bias negligible, Coverage nominal, CI Width reasonable
6. **S08 overcoverage**: Non-monotonic coverage pattern explicitly discussed in Results and Limitations

### Issues

1. S05 coverage degradation (0.73 at n=200) — negative bias from bounded statistic
2. Scenario numbering gaps (S02, S07 missing) — deferred, requires figure regeneration
3. KS comparison in simulation — deferred, Tak decision needed

---

## Live Script

### [2026-02-12 12:45] Scene: Donna's Compile — "I'm Donna. I know everything."

**INT. PEARSON SPECTER LITT - DONNA'S DESK - DAY**

*Tak が Donna に直接指示を出す。Donna がすぐに動く。*

**Donna**: （キーボードに向かって）
「"I'm Donna. I know everything." Tak の指示: compile。了解。

**Step 1: 環境確認**
texlive 未インストール。即座にインストール — pdfTeX 3.141592653-2.6-1.40.25 確認。

**Step 2: 初回コンパイル**
pdflatex × 2 pass → **PDF 生成成功: 16 pages, 294 KB**。
ただし warning を 1 件検出:

❌ `Citation 'andrews2000' undefined`

andrews2000 — Andrews (2000) "Inconsistency of the Bootstrap when a Parameter is on the Boundary of the Parameter Space" *Econometrica*。M3 対応で Limitations に追加した citation だが、**bib ファイルへの追加が漏れていた**。

**Step 3: 修正**
`nABCD_wiley.bib` に追加:
- Andrews, D W K (2000), *Econometrica*, 68(2):399-405
- DOI: 10.1111/1468-0262.00114

**Step 4: 再コンパイル**
pdflatex → bibtex → pdflatex → pdflatex（4 pass）

**最終結果:**
| 項目 | 結果 |
|------|------|
| Pages | 16 |
| Errors | **0** |
| Undefined citations | **0** |
| Warnings | Class warning のみ（Wiley template 由来、無害） |
| References | 19 件、全て resolved |
| andrews2000 | Ref [19] として正常表示 ✅ |
| Appendix A.2 | 漸近正規性 eq (A1) 正常レンダリング ✅ |
| Appendix B | R code listing 正常表示 ✅ |
| Figures | fig2-fig6 全て正常埋め込み ✅ |

**PDF path**: `projects/similarity-metric/paper/latex/nABCD_wiley.pdf`

Harvey、Mike — bib 追加漏れは今後注意。新しい `\cite{}` を原稿に追加したら、同時に bib にもエントリを追加すること」

---

### [2026-02-12 12:30] Scene: Harvey's Sign-Off & Jessica's Review — "Let me be clear."

**INT. PEARSON SPECTER LITT - JESSICA'S OFFICE - DAY**

*Harvey が原稿の最終版を持って Jessica のオフィスに入る。Mike、Katrina が後ろに続く。Donna がタブレットを持って待機。*

**Harvey**: （原稿をテーブルに置いて）
「Tak、俺のレビューは完了した。Section ごとに報告する。

**Lead Author Review — Harvey Specter:**

| Section | 評価 | 所見 |
|---------|------|------|
| **Abstract** | ✅ Good | Narrative style。Gap → Method → Validation → Application → Conclusion。SiM convention 準拠 |
| **1. Introduction** | ✅ Good | ICH E17 の gap を明確に articulate。4 contributions が structured。Research question が的確 |
| **2. Methods** | ✅ Strong | nABCD 定義 → W1 根拠（K-R + W2 排除）→ Propositions → 5-step calibration。理論的に airtight |
| **3. Simulation** | ✅ Strong | Bias/Coverage/Precision/SMD comparison。S05 除外一貫。BCa vs percentile 論証確立。S04 showcase |
| **4. Application** | ✅ Strong | BMI vs HbA1c の対比が論文の核心。'Same nABCD, different clinical impact' — これがメッセージだ |
| **5. Discussion** | ✅ Good | Implications → Multiple EM → Limitations → Conclusion。Honest かつ thorough |
| **Appendix** | ✅ Improved | 漸近正規性追加。Boundary/interior cross-reference 成立。R code clean |

**数値一貫性:**
- S05 除外: Abstract ✅ / 本文 (line 298) ✅ / Fig.3 caption ✅ / Summary (line 393) ✅
- Coverage range 0.87-0.98: 本文 ✅ / Limitations ✅ / Appendix ✅
- $\Delta_{\max}$ 計算: Table 8 と本文の arithmetic 一致 ✅

**残存 issues (Lead Author 判断):**
1. **M2 (Real data)**: Application は hypothetical。Pemberton の指摘は valid だが、**Tak の S3 strategy 決定待ち**
2. **m2 (URL)**: '[repository URL]' placeholder — **submit 直前に確定**
3. **Scenario gaps (S02/S07)**: Figure regeneration が必要 — **non-blocking but cosmetic**

俺の結論: **原稿の理論構造、simulation reporting、clinical calibration framework は submission quality に達している。** M2 と m2 は Tak 判断事項であり、原稿本体の quality issue ではない。

"I don't have dreams, I have goals." 目標は submit だ。Jessica、戦略的に見てどうだ？」

---

*Jessica がゆっくりと原稿を置き、眼鏡を外す。*

**Jessica**: （静かに、しかし鋭く）
「"Let me be clear." 原稿を全文読んだ。

**Senior Advisor Strategic Review — Jessica Pearson:**

**1. Story Clarity: 合格**

この論文の story は一文で言える: 'ICH E17 の "similar enough" を定量化し、臨床スケールで解釈可能にする。' Introduction から Conclusion まで、この thread が途切れていない。

**2. Positioning: 正しい**

Estimation-centered approach は戦略的に正しい。2016 年の ASA p-value statement 以降、Methods 論文で 'estimation, not testing' の positioning は reviewer に好印象を与える。ただし — Section 2.3 の formal decision rule への言及（line 203）は保険として適切。Regulatory reviewer が binary rule を求めた場合の escape route がある。

**3. Novelty の articulation: 十分**

4 contributions が明確:
- Full distributional comparison (vs SMD)
- Scale-free estimation (IQR normalization)
- Clinical calibration ($\Delta_{\max}$)
- Sensitivity analysis over $L$

特に 3 番目が最大の売り。Simulation Section 最後の S04 showcase paragraph（line 399）が、methods → clinical significance の bridge として機能している。

**4. Vulnerability Assessment: 3 点**

| Risk | Likelihood | Severity | 対策 |
|------|-----------|----------|------|
| 'Where is the real data?' | 高 | Medium | M2 — Tak decision needed |
| 'Why not W2 or KS in simulation?' | 中 | Low | W2 排除は理論的に完了。KS は Table 1 で limitation 記載。Simulation head-to-head は nice-to-have |
| 'Limitation 3 is too dense' | 低 | Low | SiM Methods paper では許容範囲。Split は optional |

**5. 戦略的判断:**

原稿は **conditionally submission-ready** だ。Condition は 2 つ:
- **M2**: Real data か、hypothetical の grounding 強化か。どちらかを選べ、Tak
- **m2**: Repository URL

Tak、M2 について 3 つの選択肢がある：

**Option A**: Public data（NHANES 等）を使って real-data application に差し替え — **最強だが時間がかかる**

**Option B**: 現在の hypothetical を維持し、'parameters were informed by published summary statistics' の grounding を強化 — **最速。Submit 可能**

**Option C**: Published trial の summary statistics から分布を reconstruct — **中間。Feasibility は文献次第**

私の recommendation は **B を default とし、reviewer が要求したら A を revision で対応**。初回 submission は method の novelty で勝負すべきだ。Real data は revision の切り札として温存できる」

**Mike**: （メモを取りながら）
「Jessica の Option B の場合、修正は最小限だ。Application の冒頭に bridge 文を 1 つ追加するだけ。既に line 257 と line 452-453 で published literature を cite しているから、'Parameters were selected to reflect published summary statistics from regional comparisons in type 2 diabetes trials' の一文で grounding が完成する」

**Katrina**: （チェックリストを更新して）
「"Results speak for themselves." 現在の blocking items:

| Item | Blocker | Owner | Effort |
|------|---------|-------|--------|
| M2 strategy | Tak decision: A/B/C | Tak | Decision only |
| m2 URL | Repository URL 確定 | Tak | URL 提供 |
| Option B 修正 (if chosen) | Application 冒頭 1 文追加 | Mike | 5 min |

**Non-blocking deferred:**
| Item | Note |
|------|------|
| Scenario gaps (S02/S07) | Cosmetic, revision material |
| KS simulation comparison | Nice-to-have, revision material |」

**Donna**: （記録完了）
「"I'm Donna. I know everything."

**Review Summary:**
- **Harvey**: Lead Author review complete ✅ — submission quality confirmed
- **Jessica**: Senior Advisor review complete ✅ — conditionally submission-ready
- **Condition**: M2 strategy (A/B/C) + m2 URL — **both Tak-dependent**
- **Jessica recommendation**: Option B → reviewer 要求時に Option A

Tak、決定を待っています」

---

### [2026-02-12 12:15] Scene: Harvey's Fix — "Get it done."

**INT. PEARSON SPECTER LITT - HARVEY'S OFFICE - DAY**

*Tak からのメッセージが届く。Harvey がそれを読み上げる。*

**Harvey**: （チームに向かって）
「Tak の指示だ。"そのまま修整を頼む。その後私がレビューする。" シンプルだ。残っている deferred items を片付けろ。

Mike、外部レビューの deferred 状況は？」

**Mike**: （リストを確認して）
「"I got it." 残り 4 件の status：

| Item | 内容 | Status |
|------|------|--------|
| **M2** | Real data → hypothetical → real grounding | ❌ S3 strategy 待ち。Tak 判断が必要 |
| **m1** | 収束速度・漸近正規性 Appendix に追加 | 🔧 **今すぐ対応可能** |
| **m2** | R code URL placeholder | ❌ Tak が URL 提供するまで不可 |
| **m3** | Percentile 精度次数の trade-off | ✅ **既に解決済み** — Limitations に記載 |

m3 は前回の Push で解決している。'first-order accurate; BCa showed inferior performance for this bounded statistic, and the studentized bootstrap would require variance estimation' — Hartigan の指摘を全てカバーしている。

**対応可能なのは m1 だけだ。** Beaumont が言った通り、Appendix B.2 に収束速度と漸近正規性を追加する」

**Harvey**: （頷いて）
「やれ」

**Mike**: （Appendix B.2 を編集しながら）
「Appendix B.2 'Asymptotic Properties' を強化した。追加内容：

1. **収束速度**: 1 次元の empirical $W_1$ は $O(n^{-1/2})$ — 対数項なし（del Barrio et al. 1999）
2. **漸近正規性**: $F_1 \neq F_2$ かつ有限二次モーメントの下で
$$\sqrt{n}(\widehat{\text{nABCD}} - \text{nABCD}) \xrightarrow{d} N(0, \sigma^2_{\text{nABCD}})$$
3. **Delta method**: $W_1$ と IQR の両方が $\sqrt{n}$-consistent → ratio $g(w,q) = w/(2q)$ に delta method 適用
4. **Boundary cross-reference**: $\text{nABCD} > 0$ を要求、$F_1 = F_2$ では standard asymptotics 不適用 → Section 5.3 Limitations を参照

これで Beaumont の m1 に完全に対応し、かつ Hartigan の boundary distinction とも理論的に接続した」

**Katrina**: （整合性を確認して）
「"Results speak for themselves."

m1 の修正は Limitations の boundary/interior distinction と完全に整合。Appendix から Limitations に cross-reference あり。逆方向の参照も既に成立。循環参照なし、理論構造が closed。

**外部レビュー全体ステータス:**

| Item | Status | Note |
|------|--------|------|
| C1 | ✅ Resolved | K-R duality + W2 排除 |
| C2 | ✅ Resolved | Section 5.2 practical guidance |
| M1 | ✅ Resolved | Non-negativity 改名 |
| M2 | ⏳ Deferred | S3 strategy (Tak 判断待ち) |
| M3 | ✅ Resolved | Boundary/interior distinction |
| m1 | ✅ **Resolved** | 漸近正規性 Appendix B.2 |
| m2 | ⏳ Deferred | URL placeholder (Tak 提供待ち) |
| m3 | ✅ Resolved | Percentile trade-off in Limitations |

**8 件中 6 件 resolved。残 2 件は Tak 依存（M2: real data, m2: URL）**」

**Harvey**: （Tak に向かって）
「Tak、修整完了だ。6/8 items resolved。残り 2 件は貴方の判断を待っている。

"I don't have dreams, I have goals." レビューを頼む」

**Donna**: （記録を完了して）
「"I'm Donna. I know everything."

**Fix Summary:**
- m1 resolved: 漸近正規性を Appendix B.2 に追加
- m3 confirmed resolved: Limitations で既にカバー
- 外部レビュー: 6/8 resolved, 2 deferred (Tak 依存)
- **原稿は Tak レビュー ready**」

---

### [2026-02-12 12:00] Scene: Push — "Winners don't make excuses."

**INT. PEARSON SPECTER LITT - HARVEY'S OFFICE - DAY**

*Harvey がジャケットの袖を直し、外部レビューの報告書を机に置く。Mike と Katrina が対面に座る。*

**Harvey**: （立ち上がって、窓に背を向けて）
「外部レビューは終わった。Beaumont、Pemberton、Hartigan — 3 人とも的確だった。だが**修正して終わりじゃない**。専門家が指摘したポイントを逆手に取って、**我々の主張を確立する**。

3 つのアクション：

1. **W1 vs W2 — 攻めの論証**: Beaumont が認めた通り、W1 の選択は正しい。K-R duality は既に書いた。だが reviewer は 'Why not W2?' と聞く。W2 が Lipschitz dual を持たず、heterogeneity bound を提供**できない**ことを明示した。これは防御ではない — **唯一の正解が W1 である**という主張だ。

2. **Figure 3 caption — 残存した不整合**: Louis が Abstract と Summary の S05 除外漏れを潰した。だが Figure 3 caption にも同じ問題が残っていた。'for non-null scenarios excluding S05' に修正。数値の honest さは全箇所で一貫させる。

3. **Bootstrap 境界 vs 内部 — Hartigan の知恵を活用**: Hartigan が言った distinction — 境界（true = 0）では bootstrap consistency が崩れるが、内部（non-null）では standard theory が適用される。この distinction を Limitations に明記した。Non-null での coverage 0.87-0.98 がその empirical evidence だ。守りの limitation ではなく、**我々の推奨（n ≥ 100、null 近傍に注意）の理論的裏付け**として書いた。

"Winners don't make excuses when the other side validates your position." 専門家が我々を正しいと認めた。それを原稿に刻め」

**Mike**: （画面を確認しながら）
「"I got it." 3 点とも実装完了。具体的に：

**Section 2.1 (line 136)**: 'The $W_2$ distance, while admitting closed-form expressions for Gaussian families, does not possess this dual characterization via Lipschitz functions and therefore cannot provide the heterogeneity bound that is central to our clinical calibration framework.' — W2 を排除する一文追加。

**Figure 3 caption**: 'For non-null scenarios excluding S05, bias is less than 0.02 at $n \geq 100$.' — S05 除外を明記。本文・Summary・Abstract と完全一貫。

**Limitations (line 541)**: 'For non-null scenarios, the true value lies in the interior of the parameter space where standard bootstrap consistency holds, and our simulation confirms this with coverage of 0.87--0.98 at $n \geq 100$ for most scenarios.' — 境界/内部の理論的 distinction を明示」

**Katrina**: （チェックリストを確認して）
「"Results speak for themselves." 全修正箇所を検証：

| 修正 | 箇所 | 内容 | 整合性 |
|------|------|------|--------|
| W2 対比 | Sec 2.1 | K-R duality → W2 排除 | ✅ eq(2) と整合 |
| Fig.3 caption | Fig.3 | S05 除外追加 | ✅ 本文/Summary/Abstract と一貫 |
| Bootstrap distinction | Sec 5.3 | 境界 vs 内部 | ✅ Coverage data と整合 |

数値の変更なし。論理の強化のみ」

**Harvey**: （満足げに頷いて）
「"I don't have dreams, I have goals." 外部専門家の 3 人が我々の方法論を検証し、我々はそのフィードバックを原稿の強みに変換した。

**現在の原稿状態:**
- W1 選択: 理論的に唯一の正解であることを明示 ✅
- 数値一貫性: 全 caption、本文、Summary、Abstract で S05 除外を反映 ✅
- Bootstrap 理論: 境界/内部の distinction で推奨の根拠を確立 ✅
- Proposition 1: Non-negativity に改名済み ✅
- 複数 EM: Section 5.2 で practical guidance 確立済み ✅

**C1, C2, M1, M3 — 全件 resolved.** 次は S3 の real data strategy だ」

**Donna**: （タブレットに記録して）
「"I'm Donna. I know everything."

**Push Summary:**
- 修正 3 件実施（W2 対比、Fig3 caption、Bootstrap distinction）
- 外部レビュー即時対応 4 件: **全件 resolved** ✅
- 原稿の主張: 防御 → 攻めの論証に転換
- 残 deferred: M2 (real data), m1-m3 (minor, non-blocking)」

---

### [2026-02-12 11:30] Scene: External Review — "Three Pairs of Eyes"

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Louis がコンファレンスルームのホワイトボードに 3 名の外部レビュアーの名前を書く。Harvey、Mike、Katrina、Rachel が着席。*

**Louis**: （資料を配りながら）
「外部レビューを招集した。この論文の 3 つの柱 — Wasserstein 理論、臨床試験の規制実務、Bootstrap 推論 — それぞれの専門家だ。

1. **Dr. Cédric Beaumont** — Villani-style OT theorist。最適輸送の理論的基盤を審査。
2. **Dr. Sarah Pemberton** — Pocock-style clinical trialist。規制実務への適用可能性を審査。
3. **Dr. Neville Hartigan** — Hall-style bootstrap theorist。Bootstrap 推論の理論的妥当性を審査。

"You just got Litt up!" — 容赦なく行くぞ」

---

*Dr. Beaumont が原稿の Section 2.1 を開く。*

**Dr. Beaumont** (Villani-style):
「理論面から 3 点指摘する。

**[C1] W1 vs W2 の選択根拠が不十分** ❌ Critical

論文は Wasserstein-1 距離を使用しているが、なぜ W1 であって W2 ではないのか。W2 は Gaussian family で closed-form を持ち、統計的推論の漸近理論も整備されている。

ただし — 私自身の答えを言えば — W1 の選択は正しい。理由は equation (2) の heterogeneity bound だ：

$$|\bar{\tau}_1 - \bar{\tau}_2| \leq L \cdot W_1(F_1, F_2)$$

CATE 関数 $\tau(x)$ が Lipschitz 連続であれば、Kantorovich-Rubinstein 双対性により bound は自然に W1 を要求する。W2 では Lipschitz bound が成立しない。

問題は、**この根拠が原稿に明示されていない**ことだ。Reviewer は必ず聞く。Section 2.1 で Kantorovich-Rubinstein 双対性への一文を加えるべきだ。

**[M1] Proposition 1 の命名が不正確** ⚠️ Major

'Boundedness' と名付けているが、証明しているのは non-negativity であって上界（有界性）ではない。nABCD の上界は一般には無限だ（heavy-tail 分布で IQR は有限でも W1 は無限になりうる）。'Non-negativity' に改名するか、上界の議論を追加すべきだ。

**[m1] 収束速度の欠如** ⚠️ Minor

1 次元の W1 推定量の収束速度は $O(n^{-1/2})$（対数項なし、del Barrio et al. 1999）。IQR の収束速度も $O(n^{-1/2})$。nABCD の漸近正規性を Appendix で述べるべきだ。ただし submit blocking ではない」

---

*Dr. Pemberton がテーブルを見回す。*

**Dr. Pemberton** (Pocock-style):
「規制実務の観点から 3 点。

**[C2] 複数 EM の統合方法が欠落** ❌ Critical

現実の MRCT では EM 候補が 5-10 個ある。論文は各 EM を個別に評価するが、**複数の EM から pooling の overall decision にどう至るのか**の guidance が全くない。

Reviewer の典型的な質問: 'Age の $\Delta_{\max}$ は小さいが HbA1c の $\Delta_{\max}$ は大きい。Pooling するのか、しないのか？'

最低限 Discussion で practical guidance を述べるべきだ。例えば：
- 全 EM の $\Delta_{\max}$ の maximum を使う conservative approach
- Risk-benefit の枠組みで総合判断する totality-of-evidence approach
- 各 EM の $\Delta_{\max}$ を報告し、最も影響の大きい EM で判断する

**[M2] Hypothetical data の限界** ⚠️ Major

Application section は hypothetical parameters を使用。Published summary statistics からの再構成でもいいから、何らかの real-world grounding が欲しい。Reviewer 2 が必ず 'Where is the real data?' と聞く。ただしこれは major revision レベルで、current submission の判断次第だ。

**[m2] R code リポジトリの URL が placeholder** ⚠️ Minor

'available at [repository URL]' — submit 前に actual URL が必要」

---

*Dr. Hartigan が coverage table を指す。*

**Dr. Hartigan** (Hall-style):
「Bootstrap 推論について 2 点。

**[M3] 境界でのBootstrap妥当性** ⚠️ Major

nABCD = 0（null case）ではパラメータが parameter space の境界にある。Standard percentile bootstrap は境界で breakdown する可能性がある — Efron (1979) 以来知られた問題だ。

論文は S01 の coverage を 'not reported' としており、これは honest だ。だが理論的な議論が足りない。'True value at the boundary of the parameter space invalidates standard bootstrap consistency results' の一文を Limitations に加えるべきだ。

Non-null scenarios では boundary から離れるため standard theory が適用でき、実際 simulation results が良好な coverage を示している。この distinction を明示すれば、S01 coverage 非報告の正当化が強化される。

**[m3] Percentile bootstrap の精度次数** ⚠️ Minor

Percentile bootstrap は first-order accurate（error $O(n^{-1/2})$）。BCa は second-order（$O(n^{-1})$）を狙うが、本論文では bounded statistic のため失敗している。

Studentized bootstrap は alternative だが、nABCD の分散推定量が複雑なため現実的でない。この trade-off を一文で述べると、'why percentile?' への回答が完全になる」

---

**Louis**: （ホワイトボードにまとめを書きながら）
「**外部レビュー集計:**

| 重要度 | 件数 | 内容 |
|--------|------|------|
| **Critical** | 2 | C1: W1 選択根拠の明示、C2: 複数 EM 統合 guidance |
| **Major** | 3 | M1: Proposition 命名、M2: Hypothetical data、M3: Bootstrap 境界理論 |
| **Minor** | 3 | m1: 収束速度、m2: R code URL、m3: Percentile 精度次数 |

Harvey、判断を」

**Harvey**: （立ち上がって）
「Critical 2 件と Major 3 件のうち、**今すぐ対応できるものと保留するものを分ける。**

**即時対応（原稿修正）:**
1. **C1**: W1 選択根拠 — Section 2.1 に Kantorovich-Rubinstein の一文追加。Mike。
2. **C2**: 複数 EM 統合 — Discussion に practical guidance 段落追加。Mike。
3. **M1**: Proposition 1 → 'Non-negativity' に改名。Mike。
4. **M3**: Bootstrap 境界 — Limitations に一文追加。Mike。

**保留（Tak 判断待ち）:**
5. **M2**: Real data — S3 の strategy decision に依存。Tak と相談。
6. **m1-m3**: Minor は submit blocking ではない。m2 の URL は submit 直前に確定。

"I don't have dreams, I have goals." C1, C2, M1, M3 — 4 件を今すぐ潰す」

**Mike**: （頷いて）
「"I got it." 全て明確だ。即座に対応する」

**Donna**: （タブレットに記録）
「"I'm Donna. I know everything."

**External Review Summary:**
- Experts: Beaumont (Villani), Pemberton (Pocock), Hartigan (Hall)
- Critical 2 / Major 3 / Minor 3
- 即時対応: 4 件（C1, C2, M1, M3）
- 保留: 2 件（M2 = S3 dependent, Minor = non-blocking）」

---

### [2026-02-12 11:00] Scene: Harvey's Correction — "Winners don't make excuses."

**INT. PEARSON SPECTER LITT - HARVEY'S OFFICE - DAY**

*Tak からのメッセージが Harvey のスクリーンに表示される。Harvey が一読し、表情が引き締まる。*

**Harvey**: （立ち上がって）
「Tak からだ。2点。端的に言う：

1. **Abstract に数字は要らない** — SiM に載っている他の論文を見ろ。structured format（Background/Objective/Methods/Results/Conclusions）は SiM の慣例じゃない。数字を並べるのも違う。Narrative style で書き直す。

2. **本文の太字は不要** — `\textbf{}` を本文中で使いすぎだ。SiM の convention では emphasis は italics、定義語も italics。Table header の bold は standard だが、body text に bold は使わない。

"Winners don't make excuses when the boss corrects you." 即座に直す」

**Mike**: （原稿を開きながら）
「"I got it." 具体的な修正リスト：

**Abstract 書き直し:**
- structured labels（Background/Objective/Methods/Results/Conclusions）を除去
- 具体的数字を全て除去: 0.02, 0.87-0.98, 10,000, 0.372, -0.04
- Narrative style: 一つの flowing paragraph

**本文 bold → italics:**
- 'similar enough' → `\\emph`（ICH E17 引用内）
- 'normalized Area Between Cumulative Distributions' → `\\emph`（定義）
- 研究質問の quote block → bold 除去
- 'estimation and clinical interpretation' → `\\emph`
- enumerate labels（Full distributional comparison 等）→ `\\emph`
- Computational complexity → `\\emph`
- 評価指標 labels（Bias, RMSE 等）→ `\\emph`
- Simulation summary labels → `\\emph`
- Application の Step 1/2/3 → `\\emph`
- EM名（Age, BMI, HbA1c）→ `\\emph`
- 'measuring instrument', 'clinical judgment' → bold 除去

Table header の `\\textbf` は standard convention なので維持」

**Harvey**: （頷いて）
「全て修正完了。Tak の指摘は正しかった。お作法を間違えたのは我々のミスだ。

"I don't have dreams, I have goals." SiM の convention に従う。それが goal だ」

**Donna**: （記録して）
「"I'm Donna. I know everything."

**修正内容:**
- Abstract: structured → narrative（数字なし、labels なし）
- 本文: `\\textbf` 17箇所 → `\\emph` or 除去
- Table header の bold: 維持（standard convention）
- 修正済み ✅」

---

### [2026-02-12 10:30] Scene: Louis Re-Review — "You just got Litt up!"

**INT. PEARSON SPECTER LITT - LOUIS'S OFFICE - DAY**

*Louis が眼鏡をかけ直し、赤ペンで書き込んだ原稿を机に広げている。Harvey と Mike が入室。Louis の表情は真剣だが、満足の色も見える。*

**Louis**: （ペンを置いて）
「レビュー完了だ。正直に言う。

**4項目を精査した：**
1. Estimation framing の一貫性
2. 数値の整合性（全テーブル × CSV v2 10K データ）
3. $\Delta_{\max}$ calibration の論理的一貫性
4. BCa 失敗の説明

**結果: Critical 1件、Major 0件、Minor 2件。**」

*Harvey が腕を組む。Mike がノートを構える。*

**Louis**: （赤ペンで Abstract を指しながら）
「まず Critical から。

---

**[C1] Abstract と Simulation Summary の bias 記述 — 事実と不整合** ❌

Abstract (line 40):
> *"bias $<0.02$ for $n \geq 100$ across non-null scenarios"*

Simulation Summary (line 397):
> *"Less than 0.02 for non-null scenarios at $n \geq 100$"*

だが本文 (line 302) は正しく書いてある：
> *"For non-null scenarios **excluding S05**, bias was less than 0.02"*

S05 の bias は n=100 で **-0.041**、n=200 で **-0.043** だ。|bias| = 0.04 > 0.02。

Abstract と Summary が S05 を除外していない。これは **事実の誤記** だ。Reviewer がテーブルを見て 3 秒で気づく。Reject の理由になりうる」

**Mike**: （即座に修正案を提示）
「"I got it." 修正した：

**Abstract**: 'across non-null scenarios' → 'across non-null scenarios with moderate effect sizes; bias of approximately $-0.04$ persisted for the largest distributional difference (true nABCD $= 0.372$)'

**Summary**: 'Less than 0.02 for non-null scenarios' → 'Less than 0.02 for non-null scenarios at $n \geq 100$, excluding S05 where persistent bias of $-0.04$ reflects boundary effects at large true values'

S05 を正直に acknowledge する。隠すのは逆効果だ」

**Louis**: （頷いて）
「それでいい。次、Minor。

---

**[m1] Coverage range "0.87--0.98" と S08 overcoverage** ⚠️

Abstract: "coverage within 0.87--0.98 for $n \geq 100$ in most scenarios"

だが S08 n=200 は **0.996** — 0.98 の範囲外だ。'most scenarios' の qualifier があるから致命的ではないが、reviewer に突っ込まれる可能性はある。現状の 'most scenarios' で許容範囲とする。

---

**[m2] Table 5 の小数桁数** ⚠️

RMSE は 3 桁（0.099, 0.071）、CI Width は 2 桁（0.16, 0.11）。桁数の不統一は cosmetic だが、RMSE を 2 桁にするか CI Width を 3 桁にするかで統一した方がいい。だが submit blocking ではない。

---

**Positive findings（問題なし確認）:**」

*Louis が一枚のチェックリストをテーブルに置く。*

**Louis**: （チェックマークを指して）
「✅ **Estimation framing**: Power, Type I error, equivalence testing, detection rate — **全て除去済み**。hypothesis testing への言及は全て contrast（"not testing, but estimation"）の文脈。問題なし。

✅ **数値整合性**: 全 6 scenarios × 3 sample sizes = 18 data points。
- Table 3 (Bias): 全 18 値が CSV と一致 ✅
- Table 4 (Coverage): 全 15 値が CSV と一致（S01 は NA で除外、正しい）✅
- Table 5 (RMSE/CI Width): 全 36 値が CSV と一致（適切な四捨五入）✅
- Table 6 (SMD comparison): nABCD 値 = TrueNABCD + Bias、CSV と一致 ✅
- 本文中の数値: S01 bias 0.093→0.047、S05 -0.04、S08 coverage 0.573→0.945→0.996、BCa S06 n=100 0.839 — 全て CSV と一致 ✅

✅ **$\Delta_{\max}$ calibration 一貫性**:
- Proposition 2 (eq 5) → eq 6 の導出: 正しい
- Table 7 の計算: Age $2×0.01×14.2×0.12=0.034→0.03$% ✅、BMI $2×0.02×7.8×0.51=0.159→0.16$% ✅、HbA1c $2×0.30×1.5×0.27=0.243→0.24$% ✅
- Table 8 の sensitivity analysis: 全 5 行の $\Delta_{\max}$ 計算が正しい ✅
- Section 4 の本文数値（Age 4%/8%、BMI 20%、HbA1c 30%/60%）: 全て正しい ✅
- CI Width → $\Delta_{\max}$ CI Width の変換: 整合 ✅

✅ **BCa 説明**: "bounded below by zero, causing the acceleration parameter to distort the quantile adjustment" — メカニズムの説明として十分。S06 n=100 の具体例（Pct 0.976 vs BCa 0.839）も正しい ✅

✅ **S04 showcase paragraph**: bias -0.003、coverage 0.950、CI width 0.18 — 全て CSV と整合。$\Delta_{\max}$ CI Width 計算も正しい ✅」

*Louis が立ち上がり、Harvey を見る。*

**Louis**: （静かな自信を込めて）
「Critical 1件は修正された。Major は **ゼロ** だ。Minor 2件は submit blocking ではない。

この原稿は — 数値的に honest だ。S05 の問題を隠さない。BCa の失敗理由を説明している。Estimation framing は一貫している。

"You just got Litt up!" — **Re-review passed.** 原稿は S3 以降に進んでよい」

**Harvey**: （微笑んで）
「よくやった、Louis。1C を見つけたのは正解だった。Reviewer に先に見つけられるより遥かにいい。

"I don't have dreams, I have goals." S2 gate は通過だ。次は S3 — real data strategy だ」

**Donna**: （記録しながら）
「"I'm Donna. I know everything."

**Louis Re-review 結果:**
| 重要度 | 件数 | 詳細 |
|--------|------|------|
| **Critical** | 1 | Abstract/Summary の S05 bias 除外漏れ → **修正済み** |
| **Major** | 0 | — |
| **Minor** | 2 | Coverage range qualifier (acceptable) / Table decimal precision (cosmetic) |

**数値検証**: 18 scenarios × 全テーブル = **全一致** ✅
**Framing検証**: Testing remnants = **ゼロ** ✅
**Calibration検証**: Sec 2.3 → Sec 4 = **論理的一貫** ✅

**S2 Gate: PASSED** 🎯」

---

### [2026-02-12 10:00] Scene: Push — "I don't get lucky. I make my own luck."

**INT. PEARSON SPECTER LITT - BULLPEN - DAY**

*Harvey がジャケットの袖を直しながらブルペンに入る。全員がシミュレーション結果レビューの余韻に浸っている。Harvey の表情はそれを許さない。*

**Harvey**: （厳しい表情で、テーブルを叩いて）
「結果のレビューは終わった。いい結果だった。だがそれで満足するな。

3つの問題を見つけた：
1. **原稿に "power" の残骸が残っていた** — Section 3.2 の MCSE 記述に "coverage, power" とあった。Power は削除したはずだ。修正済み。
2. **S08 overcoverage の議論が Discussion に不足** — Results には書いたが Limitations に反映されていなかった。追加済み。
3. **S04 showcase のナラティブが弱かった** — S04 が我々の best scenario だ。Simulation summary に $\Delta_{\max}$ CI Width の具体計算とともに明示した。

"I don't get lucky. I make my own luck." 細部で負けるわけにはいかない。動け」

**Mike**: （画面を確認しながら）
「"I got it." 全修正確認した。技術的に整理すると：

1. **"coverage, power" → "coverage probabilities"** — Line 315、power の残骸を除去。正確に estimation metrics のみの記述に。
2. **Limitations 追加** — S08 の non-monotonic coverage パターン（0.573 → 0.945 → 0.996）を Limitation #3 に組み込み。bias と CI width のバランスが n で異なる rate で変化することを説明。
3. **S04 showcase paragraph** — Simulation summary 直後に追加。bias -0.003、coverage 0.950、CI width 0.18 → $\Delta_{\max}$ CI width 0.16% HbA1c。具体的な数字で reviewer を説得する」

**Katrina**: （テーブルを確認して）
「"Results speak for themselves." S04 の数字を改めて確認：

| 指標 | S04 (n=100) | 判定 |
|------|------------|------|
| Bias | -0.003 | ✅ Negligible |
| Coverage | 0.950 | ✅ Nominal |
| CI Width | 0.179 | ✅ Reasonable |
| RMSE | 0.049 | ✅ < 0.05 |

$\Delta_{\max}$ CI Width = $2 \times 0.3 \times 1.5 \times 0.179 = 0.16$% HbA1c。臨床的に十分な精度」

**Louis**: （腕を組んで）
「よし。原稿の3修正は acceptable だ。だが俺の本格 re-review はまだだ。"You just got Litt up!" は原稿全体を精査してからだ。

**Re-review checklist:**
1. estimation framing の一貫性 — 検定の残骸がゼロか再確認
2. 数値の整合性 — Tables, 本文, Abstract の全数値が v2 10K CSV と一致するか
3. $\Delta_{\max}$ calibration の論理的一貫性 — Section 2.3 → Section 4 の流れ
4. BCa 失敗の説明 — "bounded below by zero, causing the acceleration parameter to distort the quantile adjustment" で十分か

Harvey、Go を出してくれたら即座に re-review に入る」

**Harvey**: （Louis を見て）
「Go だ。S2 — Louis re-review、今すぐ始めろ。これが次のゲートだ。

**残りの bottleneck:**
- **S2: Louis re-review** — 今すぐ着手。これが全ての前提
- **S3: Real data strategy** — 俺が Tak と相談する。Public dataset か hypothetical 強化か
- **S4: Scenario numbering** — 図の再生成が必要。後回し
- **S4: DOI check** — Rachel、Louis review と並行しろ

"I don't have dreams. I have goals." 次のゴールは Louis の re-review 完了だ」

**Rachel**: （文献リストを開いて）
「"Hard work beats talent when talent doesn't work hard." DOI チェック、Louis review と並行で始めるわ。18 references 全件確認する」

**Donna**: （タブレットを掲げて）
「"I'm Donna. I know everything." 全て記録完了。

**本日の進捗:**
- ✅ Harvey's 4 decisions → 原稿反映（3件実施、scenario renumbering は deferred）
- ✅ Power 残骸修正
- ✅ S08 overcoverage を Discussion に追加
- ✅ S04 showcase paragraph 追加
- ✅ SUITS.md アーカイブ（995行 → archives/SUITS_20260212_090000.md）

**次のアクション:**
- ⏳ Louis re-review (S2) — **Gate task**
- ⏳ DOI final check — Rachel 並行
- ⏳ Real data strategy — Harvey/Tak 相談」

---

### [2026-02-12 09:00] Scene: Meeting — Simulation Results Review

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Harvey が大型ディスプレイにシミュレーション結果テーブルを映す。全メンバー着席。コーヒーの香りが漂う朝のミーティング。*

**Harvey**: （立ったまま、テーブルを見回して）
「10,000 replications が完了した。これは試運転じゃない。本番の結果だ。全員の目でレビューしろ。見落としがあれば今日中に潰す。意見を聞かせろ」

**Mike**: （ディスプレイを指しながら）
「"I got it." 技術的な所見を整理する。

**1. Bias — 想定通り、問題なし**

| Scenario | n=50 | n=100 | n=200 | 判定 |
|----------|------|-------|-------|------|
| S01 (Null) | +0.093 | +0.066 | +0.047 | 境界効果 — 予想通り |
| S03 (0.2σ) | +0.039 | +0.018 | +0.007 | ✅ n≥100 で < 0.02 |
| S04 (0.5σ) | +0.004 | -0.003 | -0.004 | ✅ 全 n で negligible |
| S05 (1.0σ) | -0.038 | -0.041 | -0.043 | ⚠️ 持続的負バイアス |
| S06 (Scale) | +0.001 | -0.012 | -0.019 | ✅ n≥100 で < 0.02 |
| S08 (Shape) | +0.029 | +0.003 | -0.015 | ✅ n≥100 で < 0.02 |

S05 の負バイアス約 -0.04 は bounded statistic の性質。nABCD は [0, ∞) だが、true value 0.372 が実効的な上限に近いため、推定値が下に引っ張られる。これは正直に Discussion に書いている。

**2. Coverage — 核心的な話題**

Percentile CI の Coverage:

| Scenario | n=50 | n=100 | n=200 |
|----------|------|-------|-------|
| S03 (0.2σ) | 0.672 | 0.895 | **0.949** |
| S04 (0.5σ) | **0.956** | **0.950** | **0.949** |
| S06 (Scale) | **0.963** | **0.976** | **0.939** |
| S08 (Shape) | 0.573 | **0.945** | **0.996** |
| S05 (1.0σ) | **0.929** | 0.867 | 0.731 |

n≥100 で bold = 0.90 以上。S04, S06, S08 は n≥100 で excellent。S03 は n=100 で 0.895 — ギリギリ acceptable。S05 は known issue。

注目すべきは **S08 (Shape) n=200 の 0.996** だ。これは overcoverage — CI が広すぎることを意味する。Shape scenario では分布の非対称性が影響している可能性がある」

**Katrina**: （Figure 4 を投影しながら）
「"Results speak for themselves." Figure 4 のパネル B — CI Width を見てほしい。

| Scenario | n=50 | n=100 | n=200 |
|----------|------|-------|-------|
| S03 | 0.181 | 0.135 | 0.106 |
| S04 | 0.229 | 0.179 | 0.134 |
| S05 | 0.243 | 0.172 | 0.121 |
| S06 | 0.186 | 0.131 | 0.094 |
| S08 | 0.165 | 0.113 | 0.078 |

n を 2 倍にすると CI Width が約 25-30% 縮小する。$\sqrt{n}$ rate と整合。n=100 で 0.11-0.18 の範囲。

Clinical calibration の観点: $L = 0.3$, IQR = 1.5% の HbA1c に対して、S04 (n=100) の CI Width 0.179 は $\Delta_{\max}$ の CI Width $= 2 \times 0.3 \times 1.5 \times 0.179 = 0.16$% HbA1c に相当する。臨床的に意味のある精度だ」

**Harvey**: （全員を見渡して、決断）
「結果はレビューに耐えうる。以下を決定する。

**Decision 1**: S04 を primary showcase scenario として論文のナラティブの中心に据える。
**Decision 2**: Louis の 3 指摘を全て manuscript に反映。特に MCSE 明示と BCa 失敗理由。
**Decision 3**: S08 の overcoverage の非単調パターンを Discussion で議論。
**Decision 4**: $\Delta_{\max}$ CI Width の具体計算を Section 4 に追加。

Mike、Louis の指摘の manuscript 反映を担当しろ。Katrina、Section 4 の $\Delta_{\max}$ 計算追加。

"I don't have dreams, I have goals." 次は Stage 2 — Louis の full re-review だ」

---
