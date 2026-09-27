> **SUPERSEDED by `RESTRUCTURE_v5_team.md` (2026-09-23)**. Kept for the diagnosis record only.

# v3 — 白紙からの構成（2026-09-22、Tak「現行の原稿に引っ張られずに、よりわかりやすく明確な目的に構成し直して」）

v2（`RESTRUCTURE_PLAN_20260922.md`）は現行原稿の診断。v3 は診断を前提に、**目的から逆算した構成**を書く。材料（理論・Study 1/2・procedure sim・GUSTO）は全て既存。変わるのは「何のために並んでいるか」だけ。

---

## 0. 目的 — 一文で

**EN**: This paper gives a sponsor who plans to pool regions in an MRCT a reproducible way to decide *which* regions to pool: a per-effect-modifier distance with a clinical scale, a check that the decision is resolvable at the planning sample sizes, and a selection rule whose guarantee matches the sponsor's estimand.

**JA**: MRCT で地域併合を計画する sponsor に、**どの地域と併合するか**を再現可能に決める方法を与える — 臨床尺度を持つ per-EM 距離、その判断が planning 時の例数で解像するかの確認、そして sponsor の推定対象に合った保証を持つ選択規則。

問いは一つ: **「similar enough」を、誰が再現しても同じ答えになる手続きにするには何が要るか。** 答えは三つの部品で、順に依存する。

| 部品 | sponsor に欠けているもの（gap） | 本論文の策 |
|---|---|---|
| **① 測る** | 分布全体を比べ、かつ臨床尺度に換算できる距離 | per-EM W₁（元の単位）+ 異質性 bound Δ_max = L·W₁。定数 L は EM 単位あたりの効果変化で sponsor が指定できる。L 不明なら L* を逆算 |
| **② 解像する** | 閾値を当てる前に、判断が手元の n で解像するかの確認 | null floor（同一分布での Ŵ₁ の分位点）と τ = Δ_clin/L_UB の比較 |
| **③ 変換する** | per-EM 距離を、推定対象に応じた保証つきで相手集合にする規則 | anchor が借りる → anchor への pairwise screen（凸性）; 共有 pool → 直径 ≤ τ の cut（2τ exposure を防ぐ）; 複数 EM は AND |

依存関係: ① が無ければ ③ は定義できない。② が満たされなければ ①③ の答えは数値の見かけだけになる。

---

## 1. 構成 — 章は「手続きの順」に並ぶ

読者は §2 で手続き全体を 1 ページで見る。§3–§5 は三つの部品の理論。§6 は部品ごとの simulation 証拠。§7 は同じ順序で GUSTO を通す。§8 は部品ごとに何が言えて何が言えないか。

### §1 Introduction（≈600 words）
1. 意思決定: planning 時に、ある地域（anchor）はどの地域と併合するか。E17 は EM 分布の類似で pooling を**記述**するが、metric・threshold・procedure を与えない。
2. 最も具体的な既存 recipe（小宮山 Ch.4: 代表値 1 つ → Lasso 重み Euclid → cluster）が与えるものと、欠けるもの — 上の三つの gap を**連鎖**として一段落（列挙しない）。
3. 貢献: 三つの部品を一つの手続きにし、それぞれに理論・simulation・実データの証拠を与える。「W₁ が常に違う答えを出す」とは主張しない — 答えが変わる状況を特定し、変わらない状況ではその理由を示す。
4. roadmap: 各節がどの部品に答えるかを名指す。

### §2 The partner-selection problem（≈450 words、**新設**）
- 設定: anchor 地域 a、候補 partner r = 1..R、候補 EM j = 1..J。二つの推定対象 — (a) anchor が partner から借りる、(b) 共有 pooled region として全 member が同じ推定値を報告する。
- sponsor が与える入力: 候補 EM、臨床 margin Δ_clin、CATE 傾きの上界 L_UB（判断、非劣性 margin と同じ立場）。手法が返す出力: partner 集合と、partner ごとの Δ_max または L*。
- **手続きの要約 box**（≈120 words、現 R3.3 の workflow float）: ① 入力 → ② τ = Δ_clin/L_UB → ③ operability check → ④ per-EM Ŵ₁ + CI → ⑤ 推定対象に応じた選択規則 → ⑥ 出力。
- ここで τ は **sponsor の入力から導かれる量**であり、手法が産出する閾値ではないと明記（規制メッセージ）。

### §3 Measuring dissimilarity on a clinical scale（≈1,100 words）— 部品①
- 3.1 既存の比較法と何が足りないか（**一度だけ**、一段落）: SMD と代表値距離は summary を比べる（RV1 は単一連続 EM で SMD と同一）; KS は分布全体を見るが bound の定数 TV(τ) を臨床家は言えない; KL は非対称・発散・密度推定。
- 3.2 per-EM W₁: 定義（CDF 面積形のみ本文、他の表現は Supplement A）、Proposition 1（KR bound）、**定数と tightness の議論**（M1 Option B: bound は唯一ではない、区別は sponsor が指定できる定数と順序）。
- 3.3 臨床較正: Δ_max 経路と L* 経路、L_UB は判断（¶B）、平均傾きは下界 → safety factor、尺度規約（proportion）。
- 3.4 推定: ECDF 推定量（tie を含む）、percentile bootstrap、収束率。

### §4 Is the decision resolvable at the planning sample sizes?（≈350 words）— 部品②
- W₁ ≥ 0 ゆえ同一分布でも正の値。null floor q_{1−α}(n_a, n_r) を anchor の経験分布から resample して τ と比べる。未解決 partner は「similar と言えない」のであって「dissimilar」ではない — 判定は許容側に働く（M4）。
- 現 §2.5 をほぼそのまま。独立節に**昇格**（判断③の根拠 (a) の帰結）。

### §5 From distances to a partner set（≈400 words）— 部品③
- 推定対象 (a): W₁ は混合に対して凸 → anchor-to-pool 距離は最大 anchor-to-partner 距離を超えない → 各 pairwise W₁ ≤ τ で anchor の bound は L·τ で守られる。pairwise screen で十分。
- 推定対象 (b): 各 partner が anchor から τ 以内でも partner 同士は 2τ まで離れうる → member の bound は 2 倍 → pool 直径 ≤ τ が要る → complete-linkage を τ で cut。
- 複数 EM: 候補 EM ごとに判定し AND。
- 証明は Appendix A。現 Discussion ¶4 の前半と §4.5 の直径段落の理論部分を**移す**。

### §6 Simulation evidence（≈2,000 words）— 部品ごとに一つ
- 6.0 framing（≈120）: 三つの例数の言明は別の問いに答える（推定の質 / 決定の正確さ / 閾値の解像度）。
- **6.1 部品①: summary 指標が識別できない世界で W₁ は識別するか**（現 Study 2 選択課題、≈900）: blind / partial / recovering、必要例数の表、harm。KS は underpowered であって blind ではない、と正直に。clustering-as-scoring-currency は一段落 + 表（改題: scoring currency）。
- **6.2 部品③: 選択規則は推定対象を守るか**（現 Discussion ¶4 の後半 + 100k sim、≈300 + 二通貨表）: 同じ 4 世界・12 anchors。anchor screen の pool-wide 違反は n で下がるがゼロには向かわない、直径 cut はゼロへ。表は viol_pair と、anchor-violation ≤ 5% 下の best sensitivity の二通貨。caption に「τ は真の群間距離の中点、臨床閾値ではない」。
- **6.3 部品②の基盤: 推定量は planning n で使えるか**（現 Study 1、≈550 + 表 3 つ据え置き）: bias・coverage・CI 幅、S1 の null floor の上側裾（部品②の数値的根拠）、n ≥ 100 の推奨。load-bearing な scenario を本文で名指す。
- 順序の言い訳は書かない。番号は提示順（Study 1 = 6.1 …）。

### §7 Worked example: GUSTO-I（≈1,600 words）— §2 の手続きを順に
- 7.1 入力: シナリオ、候補 EM（age, SBP）、Δ_clin、L_UB とその出所（判断）。
- 7.2 部品②: operability — age は 6 partner が未解決、SBP は 1 → **SBP が判断を担う**。
- 7.3 部品①: 15 partner の per-EM Ŵ₁ + CI、R2/R9 の逆転（小さい方の 2 距離は未解決、M5）。
- 7.4 部品③: L* と joint eligibility（6 地域）、null floor が許容側に働く事実（M4）、R4 は resolved evidence 上で最有力、slack と L_UB 感度（**primary robustness statement**）、二つの独立な論拠が SBP を指す。
- 7.5 既存指標なら何を選んだか（≈350）: k を揃えた一致（Table: "agreement with W₁"）、KS・SMD・RV1 は同じ 6 地域、RV2/RV3 だけ逸脱。**この dataset では W₁ は同じ答え + 較正**（判断④）。ρ は画定の一文（判断⑤）。
- 7.6 pool の直径（≈300、判断②の開示）: pairwise pool の直径は τ を超える（age 5.95%、SBP 78.7%）、cut pool は守る、代価は 9→2・11→2。推定対象が規則を決める、の実データ版。

### §8 Discussion（≈800 words）
- ¶1 三つの部品で何が示せたか — 部品ごとに一文 + 証拠。GUSTO の一致はここが唯一の担い手（判断④）。
- ¶2 答えが変わる状況と変わらない状況: 位置優位の dataset では既存指標と一致し、取り分は較正; mixture と displaced extremes（clinically ordinary）では summary 指標は識別失敗。どちらの dataset かは計算前に分からない。
- ¶3 小宮山との関係: per-EM 解像 vs 集約距離（r = 0.13）; Lasso 前段は補完; pool 数 ≤ 4 は彼らの答えで我々は答えない。
- ¶4 限界: Lipschitz 前提（¶D、09-22 承認、そのまま）; 連続 EM のみ; 未測定 EM; W₁ は holistic 評価の一入力で cutoff を処方しない。
- ¶5 実務と方針（一段落）: 何を計算し何を報告するか; データ源（RWE 含む）。
- ¶6 今後: EM の同定、境界での bias 補正。一文で閉じる。

### Appendix / Supplement
- A: Prop. 1 の証明; 凸性と直径の補題（部品③の proof home）; 漸近。距離公理（現 A.1）は Villani 引用に置換（Tak 判断 T7）。
- B → Supporting Information（コード）。Supplement A（表現と正規化）、D（L の文献）は現状の内容、label は T2 で整理。

---

## 2. 現行 → v3 の対応（失われるものは無い）

| 現行 | v3 | 動き |
|---|---|---|
| §1 Intro（913） | §1（600） | 小宮山 2 gap → 三つの gap の連鎖に吸収; EM tutorial を 2 文に; SMD location-only は §3.1 に一元化 |
| —（無し） | **§2 問題設定 + 手続き box** | **新設**（現 R3.3 と §4.5 の estimand 文から） |
| §2.1 既存法 | §3.1 | 一段落に |
| §2.2 W₁ + bound、§2.3 推定 | §3.2、§3.4 | 三つの表現のうち 2 つと正規化冗長性 → Supp A |
| §2.4 較正 | §3.3 | L の文献詳細 → Supp D |
| §2.5 operability | **§4** | 独立節に昇格 |
| Discussion ¶4 前半 + §4.5 直径段落の理論 | **§5** | 移動 |
| §3 Study 2 | §6.1 | clustering は一段落 + 表 |
| Discussion ¶4 後半（100k sim） | **§6.2** | 移動 + 二通貨表（案A を覆す） |
| §3 Study 1 | §6.3 | 表 3 つ据え置き、本文で load-bearing を名指す |
| §4.1–4.4 | §7.1–7.4 | 順序は手続き順（operability を距離の前に） |
| §4.5 | §7.5 + §7.6 | 一致と直径に分割 |
| Discussion ¶1 + ¶5 | §8 ¶1 | 統合（判断④の担い手を明記） |
| Discussion ¶2, ¶3, ¶6–¶9, ¶10, ¶D, ¶11 | §8 ¶2–¶6 | 圧縮 |

語数目標は置かない。目安 ≈ 8,000–8,500（現 ≈ 11,800）。減るのは重複と言い訳、増えるのは §2 と §5。

---

## 3. Abstract の骨格（≤ 250 words、Terminal pass で確定。Option B を手続き順に組み替え）

> ICH E17 describes regional pooling in MRCTs in terms of effect modifier distributional similarity but supplies no metric, threshold, or procedure. We give a sponsor a reproducible way to decide which regions to pool. [部品①] Dissimilarity is measured per effect modifier by the Wasserstein-1 distance in original units, which bounds the regional treatment-effect difference through a constant—the CATE change per unit of the modifier—that a sponsor can specify; when the constant is unknown, the sensitivity required for a clinical margin is reverse-calculated. [部品②] An operability check tests whether the decision is resolvable at the planning sample sizes. [部品③] Partners are selected by the rule matching the estimand: pairwise screening when one region borrows strength, diameter-controlled clustering for a shared pooled region. [証拠] In simulation, summary-based measures are at chance in clinically plausible configurations at every sample size, whereas W₁ recovers the partner structure; pairwise screening under-protects a shared pool at all sample sizes while the diameter rule does not; the percentile bootstrap is adequate at n ≥ 100 per region. [GUSTO] In GUSTO-I, one modifier carries the decision because the other is unresolved at the available sample sizes, and the selected partners coincide with those of existing measures—the contribution there being the clinical calibration. The method turns "similar enough" into a reproducible basis for sponsor judgment.

（≈235 words。判断④: GUSTO の一致は abstract に載せない — 上の [GUSTO] の後半は落とす。Tak 判断）

---

## 4. Title（Tak 判断、記録のみ）
現行「Quantifying Effect Modifier Similarity for Regional Pooling in Multi-Regional Clinical Trials」は部品①しか広告しない。候補: **"Selecting Pooling Partners in Multi-Regional Clinical Trials: A Clinically Calibrated Criterion for Effect Modifier Similarity"**。改題しなくても v3 は成立する。

---

## 5. 触る既決
- 案A（08-30、procedure sim は Discussion）→ **§6.2 へ**（覆す。理由: 部品③の唯一の証拠が証拠の場所に無い）
- ③（operability 独立節）→ **強化**（§4 として独立）
- ②（直径開示）→ §7.6 で保つ
- ④（一致は Discussion のみ、abstract 沈黙）→ §8 ¶1 が担い手。abstract 骨格の [GUSTO] 後半は落とす
- ⑤（ρ は画定の一文）→ §7.5
- Study 2 主役 → §6.1 が最初

## 6. 実行
Jessica の順序（キュー (2)–(4) を現行番号で閉じる → 骨格 → 圧縮 → minors → location 列 → Terminal）に従う。骨格 Pass は「移動と新設」だけで散文を書き直さない。新設 §2 と §5 の散文は段落レビュー（Option A/B/C）。
