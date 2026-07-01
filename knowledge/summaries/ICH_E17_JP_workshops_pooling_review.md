# ICH E17 日本ワークショップ・関連文献レビュー — プーリング国・地域の決定方法

**作成:** Rachel | 2026-06-20 | **🔴 重要訂正 2026-06-21（全文精読）**
**目的:** 日本で行われた ICH E17 関連のワークショップ・シンポジウム資料、および日本/アジア圏発の関連査読論文をレビューし、「プーリング戦略をとる際に、併合する国・地域をどんな方法で決めるか」について何が議論されているかを整理する。本研究室の gap claim の裏づけ確認が主眼。

> **🔴🔴 2026-06-21 訂正バナー（本文 §3 論点3・§5 の「定量手法は存在しない」結論を SUPERSEDE）**
> Tak が `Song_2025.pdf` と `E17_TF_report.pdf`（小宮山 TF）を提供。**全文精読の結果、当初の abstract/catalogue ベース結論は誤りと判明:**
> - **日中とも EM の clustering で地域をグループ化する定量手法を提示している**（Song 2025 p.4: hierarchical/k-means、EM-endpoint 相関距離、≤4 クラスタ；小宮山 TF p.25 **Figure 3-11**: Distance 軸 dendrogram で Pooled Regions A/B/C）。「定量手法ゼロ」「日本=純粋に定性」は**両方とも誤り**。
> - **しかし小宮山 TF 自身が決定的限界を明記** (p.25): 「**類似度を定める明確な基準がなく**，検討したい因子が多いとグループ化された各グループの特徴を説明できない」。
> - → **改訂 gap claim（引用で成立、最強形）**: 既存 clustering は (i) 地域間距離の **principled な基準を欠き**（資料自認）、(ii) 臨床 outcome へ較正せず、(iii) 治療効果を bound しない。我々の per-EM W₁ + Δ_max がこの3点を供給。**競合でなく自認された空白を埋める**。
> - clustering は EM *探索*ツールで、実 pooling 判断は依然定性的（5視点 + 3-layer + Table 4-1、まとめ p.68「解析手法自体は目新しいものではなく従来手法」）。
> - 比較表(7軸)・改訂文言は `projects/similarity-metric/ARS_PLAN_chapter_summaries.md` "Cross-cutting" 節。残確認: Song 参照 [2] CRC 本（優先度低、[2] 無しでも日本一次資料の自認引用で gap 成立）。
> **以下の本文（特に §3 論点3・§5）は abstract 段階の旧結論。上記バナーが優先。**

---

## 0. 調査の到達範囲と制約（重要）

本調査ではアクセス手段に以下の制約があった。誠実性のため明記する。

- **WebFetch（HTML/PDF 本文取得）は権限拒否** → JPMA/PMDA の各 HTML ページ・配布 PDF 本文を直接精読できなかった。
- **小宮山 PDF（ローカル DL 済み）はパスワード保護**で開けず。ただし同一資料が PMDA サーバに非保護版で公開されている（`https://www.pmda.go.jp/files/000247714.pdf`）。
- **PubMed 全文取得（PMC）も権限拒否** → 査読論文は **abstract レベル**まで確認。
- 利用できたのは: (a) 知識ベース内の既読サマリー（`Matsushima_2024.md`, `ICH_E17_2017.md` 等、本文精読済み）、(b) PubMed の **metadata/abstract**、(c) WebSearch の要約スニペット。

→ 結論（論点3）は **本文精読済みの一次資料（Matsushima 2024, ICH E17 本体）＋ 査読論文 abstract** に基づいて確定できる。一方、JPMA TF 報告書・PMRJ 解説・小宮山スライドの **頁単位の詳細引用は本調査では未確定**（要 WebFetch 再実行）。下表で資料ごとに「精読／abstract のみ／未読(catalogue)」を明示する。

---

## 1. 調査資料一覧

| # | タイトル | 主催/著者 | 年 | 種別 | URL / DOI | 本調査での確認度 |
|---|---------|-----------|----|----|-----------|----------------|
| A | Summary Report of a Public Workshop: Case Studies of MRCT Incorporating Concept of the ICH E17 Guideline | Matsushima, Ando(PMDA), Komiyama 他 / *Clin Pharmacol Ther* | 2024 | 査読論文（2022年 PMDA/JPMA 公開ワークショップ報告） | DOI: [10.1002/cpt.3163](https://doi.org/10.1002/cpt.3163) | **本文精読済**（KB サマリー） |
| B | ICH Harmonised Guideline E17: General Principles for Planning and Design of MRCTs | ICH | 2017 | ガイドライン本体 | https://database.ich.org/sites/default/files/E17_Guideline.pdf | **本文精読済**（KB サマリー） |
| C | Basic Considerations for Data Pooling Strategy in MRCTs | Song, Ji, Hou 他（北京大/RDPAC/企業） / *Ther Innov Regul Sci* | 2025 | 査読論文（中国/東アジア文脈） | DOI: [10.1007/s43441-025-00744-8](https://doi.org/10.1007/s43441-025-00744-8) ; PMC11880086 | **abstract のみ** |
| D | Basic Considerations for the Consistency Evaluation Based on ICH E17 Guideline | Long, Hou 他（北京大/RDPAC/企業） / *Ther Innov Regul Sci* | 2025 | 査読論文 | DOI: [10.1007/s43441-024-00737-z](https://doi.org/10.1007/s43441-024-00737-z) ; PMC11880088 | **abstract のみ** |
| E | 製薬企業視点からの ICH E17ガイドラインのおさらい | 小宮山靖（JPMA データサイエンス部会） / PMDA | — | 講演スライド | https://www.pmda.go.jp/files/000247714.pdf （非保護版） | **未読(catalogue)**（要WebFetch） |
| F | ICH E17 の理念に基づく国際共同治験成績を用いた CTD の構成（E17 TF report） | JPMA 医薬品評価委員会 データサイエンス部会 | — | TF 報告書 | https://www.jpma.or.jp/information/evaluation/results/allotment/bbh7c90000000ebo-att/E17_TF_report.pdf | **未読(catalogue)** |
| G | これからの医薬品評価－国際共同開発での日本人データの意義って何？（TF5） | JPMA データサイエンス部会 2020年度 TF5 | 2022 | TF 報告書 | https://www.jpma.or.jp/information/evaluation/results/allotment/gbkspa0000001336-att/DS_202207_e17etc.pdf | **未読(catalogue)** |
| H | E17 により三極国際共同治験から世界の治験へ | PMRJ | — | 解説記事 | https://www.pmrj.jp/publications/02/pmdrs_topics/topc49-05_ICH-E17.pdf | **未読(catalogue)** |
| I | ワークショップ「ICH E17ガイドラインの考え方」第1回/第2回 | JPMA / PMDA | 2022 | シンポジウム告知・資料 | https://www.jpma.or.jp/information/ich/explanation/ich220808.html ; https://www.pmda.go.jp/review-services/symposia/0101.html ; https://www.pmda.go.jp/review-services/symposia/0133.html | **未読(catalogue)** |
| J | ICH-E17 にもとづいた製薬企業の開発戦略 | （J-STAGE 抄録） | — | 学会抄録 | https://www.jstage.jst.go.jp/article/jsptsuppl/42/0/42_3-S42-4/_article/-char/ja/ | **未読(catalogue)** |

> PubMed 由来情報（資料 A/C/D）の利用にあたり、出典として PubMed を明示し DOI リンクを付す。According to PubMed の metadata。

---

## 2. 資料ごとの「pooling 国・地域の決定方法」記述要約

### 資料 A — Matsushima et al. 2024（2022年 PMDA/JPMA 公開ワークショップ報告）★最重要

本調査で最も load-bearing な一次資料。日本の規制当局（PMDA: Ando）＋ 産業界が参加した公開ワークショップの公式報告であり、E17 の **実装上の考え方**を最も具体的に示す。

- **決定の枠組み = 3-layer approach**（Komiyama 起源）:
  - Layer 1: 全体プール集団で consistency を評価
  - Layer 2: subgroup 解析で **effect modifier (EM) を同定**し、地域差を説明できるか判定（= EM 分布が地域間で異なるか）
  - Layer 3: 各国/地域の **局所 EM 分布**に基づき benefit-risk を評価
- **pooling の正当化基準**（E17 を引用）: "The pooling strategy should be justified based on the distribution of the intrinsic and extrinsic factors known to affect the treatment response"
- **方法の性質:** 5次元の consistency 評価（biological plausibility / internal consistency / external consistency / clinical relevance / statistical uncertainty）。**いずれも定性的判断**であり、EM 分布の地域間「類似度」を測る **定量指標・距離・閾値は提示されていない**。
- **ケーススタディ4件**（次節 §4）。
- **決定的記述（KB サマリー本文より）:** 3-layer approach は EM 分布が地域間で異なるかの評価を要求するが、「**そのための定量ツールは提供していない**」。→ 本研究室の gap claim を**直接精読した日本ワークショップ資料で裏づけ**。

### 資料 B — ICH E17 本体 2017

- **Pooled regions の定義:** 計画段階で、疾患/薬剤に関連する intrinsic/extrinsic factor について「**similar enough（十分に類似）**」とみなせる地域を pool する。
- **Pooled subpopulations:** 地域を跨いで 1つ以上の intrinsic/extrinsic factor を共有する subset を pool。
- **正当化要件:** (i) factor 類似性に基づく科学的根拠、(ii) protocol/SAP での **事前規定（pre-specification）**、(iii) 試験中の factor 分布モニタリング。
- **例（§2.2.5）:** カナダ+米国→「北米」（医療慣行・併用薬が類似）、南北米の Hispanic、欧州+北米の Caucasian（遺伝型ベース）。
- **方法の性質:** "similar enough" の判断基準は **定性的**。どの程度近ければ pool 可かを測る **距離・指標・統計検定は規定されていない**（治療×地域交互作用検定は consistency 評価の文脈で言及されるが、検出力が極めて低いと注記、かつ pooling 決定の道具としては位置づけられていない）。

### 資料 C — Song et al. 2025「Data Pooling Strategy」（abstract）★gap 判別の鍵

タイトル上は最も「定量的 pooling 決定法」を含みそうな論文だったため重点確認。**Abstract が示す方法（According to PubMed）:**

- 中国/東アジア文脈で E17 実装の曖昧さ（pooling strategy, EM, 統計解析, sample size allocation）を論じる。
- **EM を intrinsic/extrinsic factor から「determine し identify する」**（= 同定する）。
- **"If no EMs are found, we use pooling by regions"** — EM が見つからなければ**地域単位でプール**し、東アジア集団間の差の有無、東アジアでのプールの要否を検討。
- プール集団での薬効推定のための統計モデルを列挙。
- **方法の性質:** pooling 決定は (i) EM 同定の有無 → (ii) 地理的グルーピング（region-based）という **decision tree 的・定性的ロジック**。**EM 分布間の距離や類似度を測る定量的 metric は abstract に現れない**。→ gap claim を弱めるどころか、むしろ補強。

### 資料 D — Long et al. 2025「Consistency Evaluation」（abstract）

- design considerations の列挙、PK/PD/efficacy/safety/benefit-risk ごとの consistency 評価・解釈、特殊状況（非劣性・複数主要評価項目・中間解析・適応的デザイン・単群・希少疾患）への対応、regional treatment effect 推定の統計手法を扱う。
- inconsistency が予期/観測された場合の **exploratory framework** を提供。
- **方法の性質:** consistency「評価」が主眼で、**事前に「どの地域を pool するか」を定量的に決める metric は abstract に現れない**。地域効果推定の統計手法（shrinkage 等）は扱うが、これは pooling 決定基準ではなく推定段階の道具。

### 資料 E — 小宮山「製薬企業視点からの ICH E17 おさらい」（未読・WebSearch スニペットのみ）

- WebSearch 要約によれば、多様な地理的地域を考慮することが EM 発見につながりうる点、**Komiyama et al. 2013 の 3-layer approach**（資料 A の枠組みの起源）、国際共同治験での pooling strategy / 探索的解析計画の **事前規定（pre-specification）**、EM（またはその分布）で特徴づけられる患者「集団」での治療効果予測を支援する、といった内容が示唆される。
- **注:** 上記はスニペット由来。頁単位の正確な引用は **要 WebFetch 再実行**。

### 資料 F–J（未読・catalogue のみ）

- F (E17 TF report), G (TF5「日本人データの意義」), H (PMRJ 解説), I (JPMA/PMDA ワークショップ第1/2回), J (J-STAGE 抄録)。
- WebSearch スニペットの範囲では、E17 の region 三分類（Regulatory / Geographical / Pooled region。Pooled region = 結果に影響する ethnic factor とその分布が共通）、事前規定地域での被験者登録計画、「類似性の証明ではなく EM の観点から地域差を説明する」という consistency 評価の基本姿勢が繰り返し言及される。**いずれも定性的枠組みの解説**であり、定量的 pooling 決定 metric への言及は確認されなかった（ただし本文未精読のため断定は留保。要 WebFetch）。

---

## 3. 横断的まとめ（論点2・3への回答）

### 論点2: pooling 国決定方法の性質（精読・abstract 確認済み資料の範囲で）

| 観点 | 日本/アジア圏の議論の実態 |
|------|--------------------------|
| (a) pre-specified vs data-driven | **基本は pre-specified**（E17・小宮山が事前規定を強調）。ただし EM 同定や inconsistency 探索は **data-driven な探索段階**を併用。 |
| (b) EM 類似性に基づくか | **Yes（概念上）**。3-layer approach は EM 分布の地域間差を中核に据える。ただし「分布が異なるか」の判定は **定性的**。 |
| (c) intrinsic/extrinsic factor グルーピング | **Yes**。pooling 正当化の第一原理は intrinsic/extrinsic factor の類似性。 |
| (d) 地理的・規制的グルーピング | **Yes（特に fallback）**。Song 2025 は「EM が無ければ region でプール」と明示。E17 の北米・東アジア等の例も地理ベース。 |
| (e) 定量的・統計的手法 vs 定性的 | **圧倒的に定性的**。consistency 評価には統計手法（交互作用検定・shrinkage・random effects 等）が登場するが、これらは **推定・consistency 評価**の道具。「**どの地域を pool するか**」を **EM 分布間距離で定量的に決める metric・閾値は、精読・abstract 確認したいずれの資料にも存在しない**。 |

### 論点3: 「どの地域を pool するか」を定量的に決める確立した方法は示されているか？

**結論: No。日本（および中国/東アジア）の実務議論は一貫して定性的・ケースバイケースに留まる。**

- 確立した枠組みは **Komiyama の 3-layer approach**（資料 A/E）だが、これは EM 分布の地域間差を **概念的に**問うのみで、**類似度を測る定量ツールを欠く**（資料 A が自認）。
- 2025年の dedicated「pooling strategy」論文（資料 C）ですら、pooling 決定は「EM 同定の有無 → 地理的グルーピング」という **decision-tree 的定性ロジック**で、分布距離 metric を持たない。
- WebSearch による独立確認: "MRCT pooling region quantitative similarity metric distance ... Wasserstein" の検索は **MRCT 文脈と交差するヒットを返さなかった**（ヒットは CV・地質・omics 等の無関係分野のみ）。→ 「分布距離による pooling 決定」は当該規制領域で **未確立**である状況証拠。

---

## 4. ケーススタディ（資料 A の4例）

| 例 | 薬剤 / 試験 | 論点 | 教訓 |
|----|-----------|------|------|
| 1 | Secukinumab（ASAS, 軸性脊椎関節炎） | CRP+/MRI− 比率・併用 biologics の地域不均衡 | EM 調整後に ASAS40 が consistent に。subgroup 不均衡が見かけの inconsistency を説明 |
| 2 | Pertuzumab（CLEOPATRA, HER2+ 乳癌） | 疾患特性・前治療・腫瘍生物学 | 疾患生物学が well-characterized なら EM が biologically plausible で consistency 支持 |
| 3 | Palbociclib（PALOMA-3） | 日本人 n≈35、層別化因子の不均衡 | 小標本→高い統計的不確実性。holistic 評価（生物学的妥当性・外部整合性）が必須 |
| 4 | Blonanserin 経皮パッチ（統合失調症） | 日本の効果が小さいが EM で説明不能 | EM で説明できない地域差も存在。生物学的説明が無い場合は慎重な臨床判断 |

→ いずれも **EM の質的同定と臨床判断**に依拠。EM 分布の定量的距離評価は行われていない（行う道具が無い）。

---

## 5. 本研究室の gap claim への含意

**gap claim:**「ICH E17 は qualitative criteria のみで、どの地域を pool するかを決める確立した定量的方法論が存在しない」

- **裏づけ（強い）:**
  1. E17 本体の "similar enough" は定性的判断基準で距離/閾値を規定しない（資料 B）。
  2. PMDA/JPMA 公開ワークショップ報告（資料 A）が、3-layer approach は EM 分布差の評価を要求するが「**そのための定量ツールを提供しない**」と自認。
  3. 2025年の dedicated pooling-strategy 論文（資料 C/D）も abstract レベルで定量 metric を持たず、decision-tree 的定性ロジックに留まる。
  4. 独立 WebSearch で MRCT 文脈の分布距離 pooling 法はヒットせず。
- **反証は確認されず。** ただし誠実性のため留保: 資料 C/D は **abstract のみ**、資料 E–J は **本文未精読**。本文に定量手続きが埋め込まれている可能性は完全には排除できない（特に Song 2025 が列挙する「statistical models」の中身は要確認）。→ gap claim を最終確定する前に、**Song 2025 (PMC11880086) 本文の精読を推奨**（WebFetch/PMC 全文の権限再付与で可能）。
- **推奨される claim の言い回し:** 現状の証拠は claim を強く支持。万全を期すなら「確立した（established / standardized / consensus）定量的方法論が存在しない」とし、"established/standardized" を明示することで、個別論文に断片的な統計手法があっても claim が崩れない形にしておくのが安全。

---

## 6. 本研究室の framework（per-EM Wasserstein-1 + 臨床較正）との接点

| 日本の議論（既存） | 本研究室の framework（提案） |
|---------------------|------------------------------|
| 3-layer Layer 2→3: 「EM 分布が地域間で異なるか」を**定性的に**問う | per-EM W1 距離で EM 分布差を**定量化**（まさにこの空白を埋める） |
| pooling 正当化 = factor 類似性の科学的議論 | 類似性を**距離 + 臨床較正 Δ_max で閾値化** |
| consistency 評価 = 結果ベース・事後的 | 設計段階で EM 分布類似性を**事前定量予測**可能 |
| Layer 3: 局所 EM 分布で benefit-risk 評価 | per-EM 分布距離が局所分布の差を直接定量 |
| Δ_max の臨床的較正の素材 | ケーススタディ（例1 secukinumab 等）が臨床的に意味ある分布差の大きさを示唆 → 較正に利用可 |

**位置づけ:** 本 framework は日本の議論（特に 3-layer approach の Layer 2→3 遷移）が**概念的に要求しながら道具を欠いていた「EM 分布の地域間類似度の定量化」を直接供給する**もの。日本の規制実務の枠組みと**競合せず補完**する関係。

---

## 7. 引用元 URL / DOI リスト

**査読論文（PubMed / DOI）**
- 資料 A: https://doi.org/10.1002/cpt.3163
- 資料 C: https://doi.org/10.1007/s43441-025-00744-8 （PMC11880086）
- 資料 D: https://doi.org/10.1007/s43441-024-00737-z （PMC11880088）
- ICH E17 本体: https://database.ich.org/sites/default/files/E17_Guideline.pdf

**日本ワークショップ / 解説資料（HTML/PDF）**
- 小宮山スライド（非保護版）: https://www.pmda.go.jp/files/000247714.pdf
- JPMA E17 TF report: https://www.jpma.or.jp/information/evaluation/results/allotment/bbh7c90000000ebo-att/E17_TF_report.pdf
- JPMA TF5「日本人データの意義」: https://www.jpma.or.jp/information/evaluation/results/allotment/gbkspa0000001336-att/DS_202207_e17etc.pdf
- PMRJ「三極から世界の治験へ」: https://www.pmrj.jp/publications/02/pmdrs_topics/topc49-05_ICH-E17.pdf
- JPMA ワークショップ告知: https://www.jpma.or.jp/information/ich/explanation/ich220808.html
- PMDA シンポジウム第1回: https://www.pmda.go.jp/review-services/symposia/0101.html
- PMDA シンポジウム第2回: https://www.pmda.go.jp/review-services/symposia/0133.html
- J-STAGE 抄録（製薬企業の開発戦略）: https://www.jstage.jst.go.jp/article/jsptsuppl/42/0/42_3-S42-4/_article/-char/ja/

---

## 8. フォローアップ推奨（次セッション）

1. **WebFetch 権限再付与** → 資料 E（小宮山）・F・G・H を本文精読し、頁単位の引用を確定。
2. **PMC 全文 or WebFetch** → Song 2025（C）本文の「statistical models」節を精読し、定量 pooling 手続きの有無を最終確認（gap claim の最後の留保点）。
3. 確定後、`Matsushima_2024.md` と本ファイルを相互参照リンクで結ぶ。

---
*Rachel | 2026-06-20 | 一次精読: 資料 A・B / abstract 確認: C・D / catalogue: E–J*
