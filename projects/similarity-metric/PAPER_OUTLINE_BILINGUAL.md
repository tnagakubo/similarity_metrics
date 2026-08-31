# Paper Outline — Section Structure and Content / 論文アウトライン — セクション構成と内容

**Created / 作成**: 2026-07-26
**Status / 状態**: Pre-drafting outline. Not the manuscript. / 執筆前アウトライン。原稿ではない
**Sources / 出所**: `SIMULATION_FINDINGS.md`, `PAPER_RESTRUCTURE_PROPOSAL.md`, `results/*.csv`, `paper/per_em_W1_wiley.tex`, `paper_logic_ja.drawio`
**All figures verified against CSV / 全数値は CSV から再検証済み**

---

## 0. Purpose and Claim Hierarchy / 目的と主張の階層

**Purpose (fixed by Tak, 2026-07-26)**
> To propose a method for selecting pooling partners when a sponsor adopts a pooling strategy.

**目的（Tak 確定、2026-07-26）**
> 併合戦略を取る際の併合相手を選択するための方法を提案する。

**Claim hierarchy / 主張の階層**

- **Backbone = theory, sample-size independent.** Proposition 1 (the Kantorovich–Rubinstein bound), the asymmetry of the calibrating constants, and the rank reversal on true values.
  **骨格＝理論（n 非依存）。** 命題1（KR 上界）、較正定数の非対称性、真値上の順位逆転。
- **Principal simulation = Study 2 (decision performance).** It shows the theory has practical force at attainable sample sizes.
  **simulation の主役＝Study 2（決定性能）。** 理論が達成可能な例数で実効性を持つことを示す。
- **Supporting = Study 1 (estimation properties).** Necessary infrastructure for any proposed distance; it argues against no competitor.
  **supporting＝Study 1（推定特性）。** どの距離を提案しても必要な基盤であり、競合に対する主張ではない。
- **Why not put the headline on Study 2**: a required-sample-size table invites "give me 3.3× the patients and KS is fine." The n-independent results close that door.
  **headline を Study 2 に置かない理由**: 必要例数の表は「例数を 3.3 倍寄越せば KS でよい」を許す。n 非依存の結果がその反論を封じる。

**Three questions the paper must answer / 論文が答える3つの問い**

1. **Q_metric** — which distance measures pooling-relevant dissimilarity? / どの指標で測るか
2. **Q_procedure** — which decision procedure turns distances into a partner set? / どの決定手続きを使うか
3. **Q_operability** — is the decision resolvable at the available sample sizes? / その判断が例数の解像度で成立するか

---

## 0-bis. Title, Abstract, Keywords / タイトル・abstract・キーワード

- **Title (unchanged)**: "Quantifying Effect Modifier Similarity for Regional Pooling in Multi-Regional Clinical Trials."
  **タイトル（変更なし）**: 「Quantifying Effect Modifier Similarity for Regional Pooling in Multi-Regional Clinical Trials」
- **Journal constraint (verified 2026-08-31, Wiley author guidelines): *Statistics in Medicine* abstract up to 250 words, unstructured, no citations, up to six keywords. Current abstract is 354 words, so the queued rows 1–3 cannot be closed by local edits — the abstract must be reconstructed.** / **投稿規定（2026-08-31 確認）: abstract は 250 words 以内・unstructured・引用なし・keywords 6つまで。現行 354 words のため、行1–3 は局所修正では閉じず、再構成が必要。**
- ⚠ **Item 6 below conflicts with decision ④ (2026-08-15: GUSTO agreement is Discussion-only, abstract silent). Decision ④ governs; the agreement clause in item 6 is treated as a recording error unless Tak reverses ④ (flagged 2026-08-31).** / ⚠ **下記 item 6 は判断④（一致は Discussion のみ）と矛盾。④が優先、item 6 の一致句は記録誤りとして扱う（2026-08-31 flag）。**
- **Two changes are forced on the abstract / abstract に強制される変更が2つある**
  - ❌ **"small-sample anchor" must go.** R8 has n = 2,916 and is the **6th largest of 16** regions — the data contradict the phrase. Use "a designated anchor region."
    ❌ **「small-sample anchor」は削除。** R8 は n = 2,916 で 16地域中**6番目に大きい** — データと矛盾する。「a designated anchor region」に変更。
  - ❌ **The simulation sentence is Study 1 language under a Study-2-primary hierarchy.** "Simulation studies across seven systematic scenarios demonstrated satisfactory bias and coverage" describes the supporting study only. **Lead with Study 2.**
    ❌ **simulation の文が、Study 2 主役の階層の下で Study 1 の言語になっている。** 「seven systematic scenarios ... satisfactory bias and coverage」は supporting study のみを記述している。**Study 2 を先に述べる。**
- **Ordering the abstract should follow / abstract が取るべき順序**
  1. Regulatory gap: E17 describes pooling in terms of EM distributional similarity but supplies no metric, threshold, or procedure. / 規制上の gap
  2. What is proposed: a **partner-selection method** built on the per-EM W₁ in the EM's original units. / 提案するもの
  3. Theory (the backbone, sample-size independent): Δ_max = L·W₁ via Kantorovich–Rubinstein; the dual-pathway calibration (Δ_max when L is known, L* when it is not); and **the calibrating constant is what distinguishes W₁ — L is a per-unit interaction slope, the quantity the interaction literature reports.** / 理論（骨格、n 非依存）
  4. Study 2 (principal simulation): representative-value and mean-based measures are **structurally blind** in matched-moment worlds — unsolvable at any n, an identification rather than a power failure; **Ch.4's method as written coincides with SMD on a single continuous EM**; KS is **underpowered rather than blind** and errs in the more expensive direction; and **the procedure follows the estimand** (pairwise screening suffices for the anchor). / Study 2（主たる simulation）
  5. Study 1 (supporting): percentile bootstrap gives satisfactory bias and coverage for non-negligible differences at n ≥ 100 per region, with characterized boundary behaviour. / Study 1（supporting）
  6. Application: GUSTO-I, two candidate EMs; partner rankings differ markedly between them; **an operability diagnostic identifies which EM actually carries the decision**; and — stated at the controlled level §4.5 requires — **W₁ reaches the same partner set as the existing measures in this location-dominated dataset, so its contribution here is the clinical calibration rather than a different answer.** / 応用
  7. Contribution: turning a qualitative "similar enough" judgement into a reproducible, clinically calibrated basis for sponsor judgement. / 貢献
- **Candidate drafts (2026-08-31), held until the final-manuscript pass — Tak: 「Abstractは最終の原稿が完成してからだ」. Rows 1–3 stay queued; apply at the Terminal pass on whichever base Tak then chooses. / 候補草案（2026-08-31）。Tak 指示により最終原稿完成後の Terminal pass まで保留。**
  - **Option B (248 words)** — §0-bis order, decision ④ applied (no agreement), no moment list, operability included:
    ```
    The ICH E17 guideline describes regional pooling in multi-regional clinical trials in terms of effect modifier distributional similarity but provides no metric, threshold, or procedure. We propose a planning-stage partner-selection method based on the Wasserstein-1 ($W_1$) distance between regional effect modifier distributions in original units. $W_1$ bounds the regional treatment effect difference via $\Delta_{\max} = L \cdot W_1$, where $L$ is the per-unit conditional average treatment effect (CATE) sensitivity. Hence a dual-pathway clinical calibration: $\Delta_{\max}$ with bootstrap confidence intervals when $L$ is available, and the required $L^*$ at a clinical margin when not. Needing only baseline distributions, $W_1$ can be computed from prior trials, registries, or real-world evidence. In a decision-performance simulation, summary-based measures---the standardized mean difference (SMD) and representative-value distances, the simplest of which reduces to SMD for a continuous effect modifier---are structurally blind in clinically plausible configurations, missing the partner structure at every sample size examined, whereas $W_1$ recovers it; the Kolmogorov--Smirnov statistic is underpowered rather than blind and errs in the more expensive direction. A supporting simulation shows satisfactory bias and coverage for the percentile bootstrap estimator at $n \geq 100$ per region. In a GUSTO-I illustration (a designated anchor region, fifteen candidate partners, two candidate effect modifiers), rankings differ markedly between the two effect modifiers, an operability check shows which of them carries the decision, and leading candidates require an implausible $L$ for a meaningful effect difference. The method turns the qualitative judgement ``similar enough'' into a reproducible, clinically calibrated basis for sponsor judgement.
    ```
  - **Option C (250 words)** — keeps an SMD-contrast sentence ("scale and shape"), drops the operability clause:
    ```
    The ICH E17 guideline describes regional pooling in multi-regional clinical trials in terms of the similarity of effect modifier distributions but provides no metric, threshold, or procedure. We propose a planning-stage partner-selection method built on the Wasserstein-1 ($W_1$) distance between regional effect modifier distributions in original units. Unlike the standardized mean difference (SMD), which registers only location, $W_1$ registers differences in scale and shape, and it bounds the regional treatment effect difference through $\Delta_{\max} = L \cdot W_1$, where $L$ is the per-unit conditional average treatment effect (CATE) sensitivity. Hence a dual-pathway clinical calibration: $\Delta_{\max}$ with bootstrap confidence intervals when $L$ is available, and the required sensitivity $L^*$ at a clinical margin when it is not. Because only baseline distributions are needed, $W_1$ can be computed from prior trials, registries, or real-world evidence. In a decision-performance simulation, SMD and representative-value distances are structurally blind in clinically plausible configurations, missing the partner structure at every sample size examined, whereas $W_1$ recovers it; the Kolmogorov--Smirnov statistic is underpowered rather than blind and errs in the more expensive direction. A supporting simulation shows satisfactory bias and coverage of the percentile bootstrap estimator at $n \geq 100$ per region. In a GUSTO-I illustration with a designated anchor region and fifteen candidate partners on two candidate effect modifiers, rankings differ markedly between the two, and leading candidates are those requiring an implausible $L$ for a meaningful effect difference. The method turns the qualitative judgement ``similar enough'' into a reproducible, clinically calibrated basis for sponsor judgement.
    ```
- **Keywords (unchanged)**: multi-regional clinical trial; ICH E17; effect modifier; Wasserstein distance; regional pooling; distributional similarity.
  **キーワード（変更なし）**

---

## 1. Introduction

- MRCTs are the standard paradigm; ICH E17 (2017) sets principles for assessing whether treatment effects generalize across the target population.
  MRCT は標準的な開発様式であり、ICH E17（2017）は治療効果が対象集団に一般化できるかを評価する原則を定めた。
- Japanese and Chinese authorities expect demonstration of consistency in regional subpopulations, yet per-region sample sizes are often insufficient; regional pooling is the standard remedy.
  日本・中国の規制当局は地域部分集団での一貫性の提示を期待するが、地域別例数は不足しがちで、地域併合が標準的な対処となる。
- E17 describes pooling in terms of the **similarity of effect modifier (EM) distributions**, and defines pooled regions as a **planning-stage** grouping of regions judged "similar enough" on intrinsic/extrinsic factors — but supplies **no metric, threshold, or procedure**.
  E17 は併合を **EM 分布の類似性**で描き、pooled regions を intrinsic/extrinsic factors が「similar enough」と判断される地域の **planning stage での**併合として定義するが、**metric・閾値・手続きを示さない**。
- An effect modifier is a baseline characteristic across whose levels the treatment benefit differs; when it exists, regions with different patient composition observe different average effects even if the drug acts identically per patient. Hence the **whole distribution**, not only its average, matters.
  効果修飾因子は、その水準によって治療効果が異なるベースライン特性である。存在すれば、薬剤が個体レベルで同一に作用しても患者構成の違う地域は異なる平均効果を観測する。ゆえに平均だけでなく**分布全体**が問題になる。
- Scope: continuous EMs. Categorical EMs raise distinct considerations and are out of scope.
  スコープ: 連続 EM。カテゴリカル EM は別の考慮を要し、対象外。
- How much is known about which EMs matter varies by programme; the framework operates on whichever candidates the sponsor specifies and is agnostic to how they were identified.
  どの EM が関連するかの既知度は開発プログラムにより異なる。本枠組みはスポンサーが指定した候補に対して作動し、候補の同定法には非依存。
- Existing practice: SMD is routinely applied to baseline covariates but detects only location. KS and related EDF statistics compare full CDFs but carry no clinical scale. KL divergence is asymmetric, can diverge, and needs density estimation.
  既存実務: SMD はベースライン共変量に日常的に用いられるが位置のみを検出する。KS 等の EDF 統計量は CDF 全体を比較するが臨床尺度を持たない。KL divergence は非対称で発散し得、密度推定を要する。
- The most concrete existing proposal is Komiyama et al. (2024) Ch.4: one **representative value per EM** per region, Euclidean distance in that space, Lasso relevance weighting, hierarchical or k-means clustering, and no more than four pools on multiplicity grounds. This is the closest prior art and the paper engages it directly.
  最も具体的な既存提案は小宮山ら（2024）Ch.4 である: 各地域・各 EM に**代表値ひとつ**、その空間の Euclid 距離、Lasso による関連度重みづけ、hierarchical または k-means クラスタリング、多重性根拠から pool は4以下。これが最も近い先行研究であり、本論文は正面から扱う。
- **Gaps addressed / 埋める gap**
  - (a) Metric: any finite summary requires pre-specifying which distributional features matter; two regions agreeing on the chosen summary sit at distance zero.
    (a) 指標: 有限の要約はどの分布特徴が重要かの事前指定を要し、その要約が一致する2地域は距離ゼロになる。
  - (b) Clinical scale: Ch.4 asks whether differences are "clinically meaningful or not" but supplies no metric to operationalize the judgement.
    (b) 臨床尺度: Ch.4 は差が「臨床的に意味があるか」を問うが、その判断を操作化する metric を供給しない。
  - (c) Procedure and resolution: neither the dependence of the required guarantee on **who uses the pooled estimate**, nor whether a threshold is **resolvable at the available n**, has been articulated.
    (c) 手続きと解像度: 必要な保証が**誰が pooled 推定値を使うか**に依存する点も、閾値が**利用可能な n で解像可能か**も論じられていない。
- Contribution statement: a partner-selection method built on the per-EM Wasserstein-1 distance in the EM's original units, with a clinical calibration pathway, a stated procedure justification, and an operability condition.
  貢献: EM の原単位を保った per-EM Wasserstein-1 距離に基づく併合相手選択法。臨床較正経路、手続き選択の根拠、operability 条件を伴う。

---

## 2. Methods

### 2.1 The pooling-partner selection problem / 併合相手の選択問題

- State the problem: a region adopting a pooling strategy must decide which regions to pool with. The quantity to be protected is **that region's own heterogeneity bound**.
  問題の明示: 併合戦略を取る地域が、どの地域と併合するかを決める。守るべき量は**その地域自身の異質性上界**。
- Formal setup: CATE θ(x) = E[Y(1) − Y(0) | X = x]; the region-average effect is θ̄_r = ∫ θ(x) dF_r(x), so assessing pooling requires a measure of distributional difference between regions.
  定式化: CATE θ(x) = E[Y(1) − Y(0) | X = x]、地域平均効果は θ̄_r = ∫ θ(x) dF_r(x)。ゆえに併合適否の判断は地域間の分布差の測度を要する。
- Draw the boundary with the adjacent problem in one paragraph (not as two co-equal settings):
  隣接問題との境界を1段落で引く（対等な2設定として並べない）:
  - **This paper**: an anchor region selects partners; the guarantee needed is the anchor's own bound.
    **本論文**: anchor 地域が相手を選ぶ。必要な保証は anchor 自身の上界。
  - **Adjacent**: pooled regions formed at the planning stage where **every member reports the shared pooled estimate** (E17's pooled-region definition; Ch.4's setting). That setting additionally requires a condition on mutual distances (§2.7).
    **隣接**: planning stage で pooled region を形成し**全メンバーが共有 pooled 推定値を報告**する設定（E17 の pooled regions 定義、Ch.4 の設定）。相互距離の条件が追加で必要（§2.7）。
- Purpose of the boundary: defence. A reviewer noting "E17's pooled region is a partition problem" should see that the scope was chosen deliberately.
  境界を引く目的は防御。査読者が「E17 の pooled region は区割りの話だ」と言ったとき、**scope を意識的に選んだこと**を示せる。

### 2.2 Existing approaches and their calibrating constants / 既存手法とその較正定数

- SMD = |x̄₁ − x̄₂| / s_pooled. Scale-free and directly comparable to the mean-difference quantities that drive clinical decisions, but by construction captures **location only**: N(50, 5²) vs N(50, 15²) gives SMD = 0 despite a threefold difference in spread.
  SMD = |x̄₁ − x̄₂| / s_pooled。無次元で、臨床判断を駆動する平均差量と直接比較できるが、構成上**位置のみ**を捉える: N(50, 5²) 対 N(50, 15²) は ばらつきが3倍違っても SMD = 0。
- KS = sup|F₁ − F₂| and related EDF statistics (Cramér–von Mises, Anderson–Darling) compare full CDFs.
  KS = sup|F₁ − F₂| と関連 EDF 統計量（Cramér–von Mises、Anderson–Darling）は CDF 全体を比較する。
- KL divergence is asymmetric, can diverge under non-overlapping support, and requires density estimation impractical at regional sample sizes.
  KL divergence は非対称で、台が重ならなければ発散し得、地域規模の例数では実行困難な密度推定を要する。
- Representative-value distance (Ch.4 as written): one summary per EM per region, standardized across the roster, then Euclidean.
  代表値距離（Ch.4 as written）: 各地域・各 EM に要約ひとつ、roster 全体で標準化して Euclid。
- **Reframe the comparison**: the question is not "which measures admit a heterogeneity bound" but **"what constant calibrates each bound, and is that constant available at the planning stage."** Deferred to §2.3.
  **比較の枠組みを変える**: 問いは「どの測度が異質性上界を持つか」ではなく「**各上界を較正する定数は何か、そしてその定数は planning stage で入手できるか**」。§2.3 に接続。
- Structural taxonomy that determines where each method is blind:
  盲点の在り処を決める構造的分類:
  - **Pairwise** (W₁, KS, SMD): computed from the two samples directly, without summarizing.
    **対距離型**（W₁, KS, SMD）: 2標本から直接計算し、要約しない。
  - **Coordinate** (RV1, RV2, RV3): each region collapsed to a point first; **whatever the collapse discards is gone for good.**
    **座標型**（RV1, RV2, RV3）: 各地域をまず点に潰す。**潰した時点で落ちた情報は永久に戻らない。**

### 2.3 Per-EM Wasserstein-1 distance and the heterogeneity bound / per-EM W₁ と異質性上界

- Three equivalent forms on the real line: area between CDFs, integrated absolute quantile difference, and minimum expected absolute transport cost.
  実線上の3つの同値表現: CDF 間の面積、分位点差の絶対値の積分、最小期待絶対輸送費用。
- **W₁ carries the units of the EM.** In every form the integrand has the units of X, so W₁ = 5 mmHg means an expected 5 mmHg of probability mass must be transported. This precludes cross-EM comparison and is why the assessment is per-EM.
  **W₁ は EM の単位を持つ。** どの形でも被積分関数は X の単位を持ち、W₁ = 5 mmHg は期待 5 mmHg 分の確率質量の輸送を意味する。ゆえに EM 横断の比較はできず、per-EM 評価となる。
- W₁ is a proper metric (non-negativity, symmetry, identity of indiscernibles, triangle inequality) and is affine-equivariant: W₁(F_{aX+b}, F_{aY+b}) = |a|·W₁(F_X, F_Y).
  W₁ は距離の公理（非負性・対称性・不可識別者同一・三角不等式）を満たし、アフィン同変: W₁(F_{aX+b}, F_{aY+b}) = |a|·W₁(F_X, F_Y)。
- **Proposition 1 (heterogeneity bound).** If θ is Lipschitz with constant L, then |θ̄₁ − θ̄₂| ≤ L · W₁(F₁, F₂). Proof: apply Kantorovich–Rubinstein duality with f = θ/L, which is 1-Lipschitz.
  **命題1（異質性上界）。** θ が Lipschitz 定数 L で Lipschitz なら |θ̄₁ − θ̄₂| ≤ L · W₁(F₁, F₂)。証明: KR 双対性を f = θ/L（1-Lipschitz）に適用。
- **Sharpness and non-nestedness — corrected 2026-07-26. This replaces the earlier claim that competing measures "lack any analogous property," which was imprecise.**
  **鋭さと非入れ子性 — 2026-07-26 修正。従来の「他の測度は類似の性質を持たない」は不正確であり、これで置き換える。**
  - By KR duality, **L·W₁ is sharp (attained) over the Lipschitz class**: W₁ = sup{|∫θ dF₁ − ∫θ dF₂| : θ ∈ Lip₁}.
    KR 双対性より、**L·W₁ は Lipschitz クラス上で sharp（達成される）**: W₁ = sup{|∫θ dF₁ − ∫θ dF₂| : θ ∈ Lip₁}。
  - Integration by parts gives ∫θ d(F₁ − F₂) = −∫(F₁ − F₂) dθ, hence **|θ̄₁ − θ̄₂| ≤ D_KS · TV(θ)** — KS **does** admit a bound, sharp over the bounded-variation class.
    部分積分より ∫θ d(F₁ − F₂) = −∫(F₁ − F₂) dθ、ゆえに **|θ̄₁ − θ̄₂| ≤ D_KS · TV(θ)** — KS も上界を持ち、有界変動クラス上で sharp。
  - **The two bounds are non-nested.** Verified numerically: for a rare-extreme displacement of δ = 100 with a CATE linear throughout, L·W₁ = 0.094 vs D_KS·TV = 0.250 (W₁ tighter); with a CATE saturating outside [0, 100], the same cell gives 0.094 vs **0.050** (KS tighter). Which is tighter depends on whether the CATE varies where the distributions disagree.
    **両上界は非入れ子。** 数値検証: 希少極値の変位 δ = 100 で CATE が全域線形なら L·W₁ = 0.094 対 D_KS·TV = 0.250（W₁ が tight）、CATE が [0, 100] の外で飽和すると同じセルで 0.094 対 **0.050**（KS が tight）。どちらが tight かは、分布が食い違う場所で CATE が動くかで決まる。
  - **Over the Lipschitz class no uniform finite constant exists for KS**: for θ(x) = x on unbounded support TV(θ) = ∞, so |Δθ̄|/D_KS ≥ δ → ∞. The earlier θ(x) = x argument was valid **in this sense**.
    **Lipschitz クラス上では KS に一様な有限定数は存在しない**: 非有界台の θ(x) = x では TV(θ) = ∞ なので |Δθ̄|/D_KS ≥ δ → ∞。従来の θ(x) = x 論証は**この意味では妥当**だった。
  - W₂ gives a valid but looser bound via W₁ ≤ W₂; it lacks the Lipschitz dual and hence the sharp form. (The earlier "cannot provide an analogous bound" was too strong.)
    W₂ は W₁ ≤ W₂ より妥当だが緩い上界を与える。Lipschitz 双対を持たないため sharp 形にはならない。（従来の「類似の上界を提供できない」は強すぎた。）
  - **The decisive asymmetry is the calibrating constant, not the existence of a bound.** L is a **per-unit interaction slope** — the quantity IPD meta-regression actually reports. TV(θ) is the **total swing of the CATE across the support** — not reported by interaction analyses, unknown for a novel agent, and assuming a bound on it presupposes a bound on the heterogeneity one is trying to establish (circular).
    **決定的な非対称性は上界の存在ではなく較正定数にある。** L は **per-unit interaction slope**（IPD meta-regression が実際に報告する量）。TV(θ) は **CATE の台全体での全振幅**（交互作用解析は報告せず、新規薬では未知。しかもその上界を仮定することは、立証しようとしている異質性の上界を前提にすることになり循環）。
  - Reuse the metric-relations reference (Gibbs & Su) **for the corrected statement**; the current text cites it at the very claim it refutes.
    測度間関係の文献（Gibbs & Su）は**訂正後の記述に**再利用する。現行本文はそれを反証される主張の位置で引いている。
- Scope note: for threshold or step CATEs, L can be arbitrarily large and the bound becomes conservative — a design property, not a defect (§5).
  スコープ注記: 閾値型・階段型 CATE では L が任意に大きくなり得、上界は保守的になる — 欠陥ではなく設計特性（§5）。

### 2.4 Estimation / 推定

- Plug-in estimator from empirical CDFs; the integral reduces to a finite sum over combined order statistics; O((n₁+n₂) log(n₁+n₂)).
  経験 CDF による plug-in 推定量。積分は結合順序統計量上の有限和に帰着。計算量 O((n₁+n₂) log(n₁+n₂))。
- The limit law is non-standard (del Barrio et al.: √n W₁(F̂ₙ, F) → ∫|B(F(x))| dx with B a Brownian bridge) and its quantiles depend on the unknown F, so asymptotic CIs are impractical.
  極限分布は非標準（del Barrio ら: √n W₁(F̂ₙ, F) → ∫|B(F(x))| dx、B は Brownian bridge）で、その分位点は未知の F に依存するため漸近 CI は実用的でない。
- Percentile bootstrap with B = 2,000. In the two-sample setting with F₁ ≠ F₂ the Hadamard derivative of the L¹ functional is linear, so the ordinary bootstrap is consistent (Sommerfeld & Munk). Convergence at rate √(n₁n₂/(n₁+n₂)).
  percentile bootstrap（B = 2,000）。F₁ ≠ F₂ の2標本設定では L¹ 汎関数の Hadamard 微分が線形なので通常の bootstrap が consistent（Sommerfeld & Munk）。収束率 √(n₁n₂/(n₁+n₂))。
- **BCa is rejected**, not omitted: BCa consistently undercovered relative to percentile, worst near the boundary, because the acceleration parameter distorts the quantile adjustment for a statistic bounded below by zero.
  **BCa は不採用**（省略ではない）: BCa は percentile より一貫して coverage が低く、境界近傍で最も悪い。ゼロで下から抑えられた統計量に対し acceleration が分位点調整を歪めるため。

### 2.5 Clinical calibration / 臨床較正

- Forward pathway, when L is estimable: Δ_max = L · W₁, in the units of the trial outcome. CI propagates linearly with L fixed.
  順方向（L が推定可能なとき）: Δ_max = L · W₁、試験アウトカムの単位。L を固定すれば CI は線形に伝播。
- Reverse pathway, when L is unknown: L* = Δ_clin / W₁ is the smallest clinical slope at which the observed distributional difference would produce a clinically meaningful difference. If a plausible upper bound L_UB lies below L*, the difference is unlikely to translate into clinical heterogeneity.
  逆方向（L が未知のとき）: L* = Δ_clin / W₁ は、観測された分布差が臨床的に意味ある差を生む最小の臨床傾き。妥当な上限 L_UB が L* を下回れば、その差が臨床的異質性に翻訳される見込みは低い。
- Scale-normalization invariance: any normalized form W₁/X multiplied by the same X cancels in Δ_max, so retaining original units loses nothing. This is why no IQR-type normalizer is used.
  尺度正規化不変性: 正規化形 W₁/X に同じ X を掛けると Δ_max で相殺するので、原単位を保っても失うものはない。ゆえに IQR 型正規化子を用いない。
- **The clinical margin induces a threshold**: τ_clin = Δ_clin / L_UB. State it this way rather than claiming the framework "does not force binary decisions" — it does induce a decision rule, but the threshold comes from the clinical margin, not from the metric. (This resolves an internal tension in the current text.)
  **臨床 margin が閾値を誘導する**: τ_clin = Δ_clin / L_UB。「binary 決定を強制しない」と述べるのではなくこう書く — 決定規則は誘導されるが、閾値は metric ではなく臨床 margin から来る。（現行本文の内部矛盾を解消。）
- Specifying L or L_UB draws on disease-area evidence; sensitivity across a plausible range, or comparison of L* with L_UB, accommodates the usual uncertainty.
  L・L_UB の指定は疾患領域のエビデンスに依拠する。妥当な範囲での感度分析、または L* と L_UB の比較が通常の不確実性に対応する。
- **Closing sentence — this is the hinge into §2.6, and it must be written as a hinge, not as a summary.** Having derived τ_clin, the calibration is only half done: a threshold is a usable decision rule only if the estimator can resolve differences on its scale. **That question is taken up next.**
  **締めの一文 — ここが §2.6 への蝶番であり、要約ではなく蝶番として書くこと。** τ_clin を導いた時点で較正は半分しか終わっていない: 閾値が使える決定規則であるためには、推定量がその尺度上で差を解像できなければならない。**その問いを次節で扱う。**

### 2.6 Operability: the null floor / operability — 帰無床 〔NEW / 新規〕

⚠ **Placement decision (3), Tak 2026-08-15: keep §2.6 as its own subsection, but write §2.5 → §2.6 as one arc — the clinical margin induces τ_clin, and §2.6 asks whether that τ_clin is resolvable.** Independence is what makes §4.2's "this is not a failure report" land: a diagnostic that is a sub-bullet of calibration turns §4.2's age result into the method stumbling, whereas a named component with its own necessary condition turns the same result into the diagnostic doing its job. The arc framing keeps that prominence while preventing a standalone section from reading as "our method has a resolution problem." **Do not open §2.6 cold — open it from τ_clin.**
⚠ **配置の判断③、Tak 2026-08-15: §2.6 は独立節として維持するが、§2.5 → §2.6 を一本の弧として書く** — 臨床 margin が τ_clin を誘導し、§2.6 はその τ_clin が解像可能かを問う。独立性こそが §4.2 の「これは失敗の報告ではない」を成立させる: 診断が較正の下位項目なら §4.2 の age の結果は**手法のつまずき**と読まれ、自前の必要条件を持つ名前のある構成要素なら同じ結果が**診断の仕事**と読まれる。弧の枠組みはこの位置を保ったまま、単独節が「本手法には解像度の問題がある」と読まれる危険を消す。**§2.6 を唐突に始めるな — τ_clin から入れ。**

- Mechanism: because W₁ ≥ 0, the estimator returns a positive value even when F₁ = F₂. The **sampling distribution of Ŵ₁ under the null** — not a bias to be corrected — sets the estimator's resolution.
  機構: W₁ ≥ 0 のため、F₁ = F₂ でも推定量は正の値を返す。補正すべき bias ではなく **帰無時の Ŵ₁ の標本分布**が推定量の解像度を決める。
- **Necessary condition for a threshold rule to discriminate**: τ_clin must exceed an upper percentile of the null floor at the actual n and distributional shape.
  **閾値則が識別を行うための必要条件**: τ_clin が当該 n・当該形状での帰無床の上側パーセンタイルを上回ること。
- Diagnostic: draw two independent resamples of the actual sizes from one region's empirical distribution and build the null distribution of Ŵ₁. Cost: seconds.
  診断法: 一方の地域の経験分布から実サイズで独立に2標本を再抽出し、Ŵ₁ の帰無分布を作る。コストは数秒。
- **This is not a restatement of the "n ≥ 100 per region" recommendation, and the text must say so explicitly.** n ≥ 100 is calibrated to bias and coverage. Operability compares the floor with τ_clin and therefore depends on the **strictness of the clinical requirement and the shape of the EM**, not on n alone. Evidence for the non-collapse: GUSTO-I has n ≈ 2,900 — far above n ≥ 100 — and **still fails operability on age** (§4.2).
  **これは「n ≥ 100」推奨の言い換えではなく、本文で明示的にそう述べる必要がある。** n ≥ 100 は bias と coverage に較正された数字。operability は帰無床と τ_clin の比較であり、n だけでなく**臨床要件の厳しさと EM の形状**に依存する。非一致の証拠: GUSTO-I は n ≈ 2,900 で n ≥ 100 を遥かに満たしながら、**age では operability に失敗する**（§4.2）。
- Two existing results become instances of this general statement rather than scattered caveats: the S1 null bias in Study 1, and the operable-range finding in the threshold calibration study (a strict τ_clin is undecidable at n ≤ 100, and the direction of error is abstention).
  既存の2結果が散在した caveat ではなくこの一般命題の実例になる: Study 1 の S1 帰無 bias、および閾値較正研究の operable range（厳しい τ_clin は n ≤ 100 で決定不能、誤りの方向は棄権）。

### 2.7 From pairwise distances to a pool / 対距離から pool へ 〔NEW / 新規〕

- **P2 (convexity).** W₁ is convex in mixtures, so W₁(F_a, Σ wᵢFᵢ) ≤ max_i W₁(F_a, Fᵢ). **Controlling each anchor-to-candidate distance at τ therefore controls the anchor's bound at L·τ — pairwise screening is sufficient for the anchor estimand,** and a full-pairwise constraint is unnecessary conservatism.
  **P2（凸性）。** W₁ は混合について凸なので W₁(F_a, Σ wᵢFᵢ) ≤ max_i W₁(F_a, Fᵢ)。**ゆえに anchor–各候補の距離を τ で制御すれば anchor の上界は L·τ で制御される — anchor estimand には対比較で十分**であり、全ペア制約は不要な保守性。
- **P3 (2τ exposure).** By the triangle inequality, two candidates each within τ of the anchor may lie up to 2τ apart, so a **member's own** bound can reach twice the intended margin. This is the exposure that matters only if the pool is read as a shared pooled region.
  **P3（2τ 露出）。** 三角不等式より、anchor から双方 τ 以内の2候補は互いに最大 2τ 離れ得るので、**メンバー自身の**上界は意図した margin の2倍に達し得る。これは pool を共有 pooled region として読む場合にのみ問題になる露出。
- **P4 (diameter guarantee).** Cutting a complete-linkage dendrogram at height τ guarantees every cluster has diameter ≤ τ, which is exactly the admissibility condition for a shared pool. Average linkage carries no such guarantee and cannot be used for this rule.
  **P4（直径保証）。** complete linkage の樹形図を高さ τ で切ると全クラスタの直径 ≤ τ が保証され、これが共有 pool の許容条件そのもの。average linkage には保証がなく、この規則には使えない。
- Proofs in Appendix. Discussion retains only the empirical summary and the practical guidance.
  証明は Appendix。Discussion には実証の要約と実務助言のみ残す。
- **Worked example: §4.5 Result 4** (Tak decision 2026-08-15 — it is consolidated there rather than given its own subsection). P2 is what licenses the pairwise screen used throughout §4; P3 and P4 are what the shared-region reading in Result 4 instantiates. **§2.7 states the theory only — do not pre-empt Result 4's figures here.**
  **worked example は §4.5 Result 4**（Tak 判断 2026-08-15 — 独立節を立てずそこに集約）。P2 は §4 全体で用いる対比較 screening を正当化するもの、P3・P4 は Result 4 の共有 region 読みが該当するもの。**§2.7 では理論のみ述べ、Result 4 の数値を先取りしない。**

---

## 3. Simulation

✅ **§3.0 + §3.1.1–3.1.3 + §3.2 WRITTEN INTO THE `.tex` 2026-08-30** (`sec:study2` with `sec:study2_design` / `sec:study2_classification` / `sec:study2_selection` / `sec:study2_clustering`; Study 1 demoted to `sec:study1` with `sec:sim_design` / `sec:sim_results` kept as labels; SMD sensitivity table deleted per §3.2 spec; S1↔§2.6 cross-referenced both ways; `fig_required_n_auc.pdf` placed as `fig:study2_auc`; `morris2019` added to the bib). Every quoted number passes `R/verify_study2_figures.R` (`results/verify_study2.log`, ALL PASS).
⚠ **Two recorded-note errors found by the gate and corrected in the prose**: (i) the blind plateau values quoted below (0.50–0.51) are `max_auc`; at n = 2,000 the values are 0.49–0.50 — the manuscript says "0.49–0.51 across the full grid". (ii) The design constants are **selection 10,000/3,000 reps, clustering 5,000/2,000, and 9 candidates in every set** — the "5,000–10,000 reps" and "9–11 candidates" below pooled two different tasks.
⚠ **Deliberately NOT yet written** (TODO comment at the end of `sec:study2_clustering`): (a) the ρ/ρ_trans regime heuristic (§3.1.2 last bullet — per-cell ρ_trans not yet verifiable); (b) the oracle-best-threshold steelman + Part 1B operating characteristics (placement vs §2.6 open); (c) ~~§3.1.4 placement~~ → ✅ **decided 2026-08-30 (Tak, option A): stays in the Discussion; §3.1.4 not written**.
  ✅ **2026-08-30 に §3.0・§3.1.1–3.1.3・§3.2 を `.tex` へ執筆済み**（構造・label・図・morris2019 追加は上記）。全数値は `R/verify_study2_figures.R` で ALL PASS。⚠ ゲートが下記ノートの誤り2件を検出・訂正: ①blind の 0.50–0.51 は max_auc（n=2,000 時点は 0.49–0.50、本文は「全グリッドで 0.49–0.51」と記載）②設計定数は selection 10,000/3,000・clustering 5,000/2,000・**候補は全 Set で 9**。⚠ 意図的に未執筆: (a) ρ/ρ_trans（検証未整備）(b) oracle 閾値 steelman + Part 1B（§2.6 との配置未決）(c) **§3.1.4 = Discussion 段落と二重になるため Tak 判断待ち**。

### 3.0 Framing: which recommendation answers which criterion / 枠組み — どの推奨がどの基準に答えるか

- **State up front that three different sample-size statements appear in the paper and they answer different questions.** Otherwise they read as a contradiction.
  **本章冒頭で、性質の異なる3つの例数に関する言明が論文に現れ、それぞれ別の問いに答えることを明示する。** さもなければ矛盾として読まれる。

| Statement / 言明 | Value / 値 | Criterion / 基準 |
|---|---|---|
| Study 1 | n ≥ 100 per region | Estimation quality (bias, coverage, CI width) / 推定の質 |
| Study 2, **selection** (primary) | **42 – 690** (W₁'s required n across the reported cells; per-cell task floor 41 – 690) | Decision accuracy, AUC ≥ 0.9 / 決定の正確さ |
| Study 2, clustering (illustration) | 36 – 376 (task floor across worlds) | Decision accuracy, ARI ≥ 0.8 / 決定の正確さ |
| §2.6 | null floor < τ_clin | Threshold resolution / 閾値の解像度 |

- ⚠ **Keep the two kinds of number apart in every table.** A **range across scenarios** (how hard the task is: 42 → 690 for W₁) and a **gap between methods within one cell** (42 for W₁ vs 1,047 for KS in Set 4 / symmetric severity, a 25× difference) answer different questions. Writing "42 – 1,047" as if it were a scenario range destroys the paper's headline method gap by reformatting it as task difficulty.
  ⚠ **2種類の数字を全ての表で分離すること。** **シナリオ間の範囲**（タスクの難しさ: W₁ で 42 → 690）と**同一セル内の手法間の差**（Set 4 / sym_severity で W₁ 42 対 KS 1,047、**25倍**）は別の問いに答える。「42–1,047」とシナリオ範囲のように書くと、論文の中心的な手法差をタスク難易度に化けさせて消してしまう。
- Since the purpose is partner selection, **the selection numbers are the ones cited as practical guidance**; clustering is illustration.
  目的が併合相手の選択であるため、**実務助言として引くのは selection の数字**。clustering は illustration。

### 3.1 Study 2 — Decision performance / 決定性能 〔PRIMARY / 主役〕

**Design / 設計**

- Four worlds, one distributional family each: **Set 1 Gaussian** (location/scale), **Set 2 Log-normal** (location/dispersion+shape), **Set 3 Mixture** (shape only — every one of 12 countries has mean 50 and SD 10), **Set 4 Extremes** (rare 5% subgroups displaced by ±40/±70/±100; mean fixed).
  4つの世界、各1分布族: **Set 1 Gaussian**（位置/尺度）、**Set 2 Log-normal**（位置/散らばり+形状）、**Set 3 Mixture**（形状のみ — 12か国すべて平均 50・SD 10）、**Set 4 Extremes**（稀な 5% の部分集団が ±40/±70/±100 変位、平均固定）。
- Six methods: W₁, KS, SMD (pairwise); **RV1 = Ch.4 as written** (one representative value), **RV2 = (mean, SD)** and **RV3 = (mean, SD, skew)** — **our extensions, which Ch.4 does not propose.** Plus SMD(log) for Set 2 only.
  6手法: W₁・KS・SMD（対距離型）、**RV1 = Ch.4 as written**（代表値ひとつ）、**RV2 = (mean, SD)**・**RV3 = (mean, SD, skew)** — **我々の拡張であり Ch.4 の提案ではない**。Set 2 のみ SMD(log) を追加。
- Ground truth = the construction labels, which are **metric-independent**, so the comparison is non-circular.
  真値は構成ラベルであり **metric に依存しない**ため、比較は非循環。
- **Steelman**: only W₁ derives its threshold from the clinical requirement (τ = Δ_clin/L). Competitors are given the **oracle-best threshold searched over the whole distance grid at each scenario and n** (maximum sensitivity subject to violation ≤ α). **Competitors are told the answer; W₁ is not.** If W₁ still wins, the win is not an artefact of threshold choice.
  **steelman**: W₁ だけが臨床要件から閾値を導出する（τ = Δ_clin/L）。競合には**各シナリオ・各 n で距離グリッド全体を探索した oracle-best 閾値**を与える（violation ≤ α の下で sensitivity 最大）。**競合は答えを教えられ、W₁ は教えられていない。** それでも W₁ が勝つなら、勝ちは閾値選択の産物ではない。
- Sample-size grid 25–100 (5,000–10,000 reps) extended to 150–2,000 (2,000–3,000 reps). **The extension to n = 2,000 is what makes the central classification possible.**
  例数グリッド 25–100（5,000–10,000 reps）を 150–2,000（2,000–3,000 reps）へ拡張。**n = 2,000 への拡張が中心的な分類を可能にした。**

**3.1.1 Central result: methods fall into three behaviours / 中心的結果 — 手法は3つの挙動に分かれる**

- **State the classification on the selection task (AUC), since selection is the deliverable; chance = 0.5.** Clustering (ARI, chance = 0) then reproduces it in §3.1.3 as an independent second currency.
  **classification は selection タスク（AUC、chance = 0.5）で述べる**（selection が deliverable であるため）。clustering（ARI、chance = 0）は §3.1.3 で独立な第二の通貨として再現する。
- **Blind**: at chance and flat in n. The population distance carries no information; **unsolvable even at n = ∞.** This is an **identification** failure, not a power failure.
  **Blind（盲目）**: chance 水準で n に対して平坦。母集団距離に情報がなく、**n = ∞ でも解けない**。**identification** の失敗であり power の失敗ではない。
  - Selection AUC: Set 3 / combined — RV1 **0.51**, RV2 **0.50**, SMD **0.51**. Set 3 / shape-symmetric — RV1, SMD blind, RV2 **0.46**, RV3 **0.45**. Set 4 / symmetric severity — SMD **0.51**.
    selection の AUC: Set 3 / combined — RV1 **0.51**、RV2 **0.50**、SMD **0.51**。Set 3 / shape_sym — RV1・SMD が盲目、RV2 **0.46**、RV3 **0.45**。Set 4 / sym_severity — SMD **0.51**。
  - Mechanism: by construction all 12 countries share (mean, SD) in Set 3, so the population distance for a mean-or-(mean,SD) coordinate is **exactly zero**.
    機構: Set 3 では構成上 12か国が (mean, SD) を共有するので、平均または (mean, SD) 座標の母集団距離は**厳密にゼロ**。
- **Partial**: above chance but flat below the threshold — part of the structure resolved, the rest never.
  **Partial（部分識別）**: chance 超だが閾値未満で平坦 — 構造の一部だけ解像し、残りは永久に解けない。
  - Selection AUC: Set 4 / symmetric severity — RV1 **0.63**. Set 3 / combined — RV3 **0.78**.
    selection の AUC: Set 4 / sym_severity — RV1 **0.63**。Set 3 / combined — RV3 **0.78**。
  - ⚠ **Do not call these "blind."** RV1's 0.63 is well above chance and resolves real structure; on the clustering currency RV2's 0.380 in Set 4 is nearly four times chance.
    ⚠ **これを「盲目」と呼んではいけない。** RV1 の 0.63 は chance を大きく超え実構造を解像している。clustering 通貨では Set 4 の RV2 0.380 は chance のほぼ4倍。
- **Recovering**: monotone increase past the threshold — identification succeeds; it is a question of **required sample size**. W₁ and KS in every world, on both currencies.
  **Recovering（回復）**: 単調増加し閾値を越える — identification は成功しており、**必要例数**の問題。全世界の W₁ と KS、両通貨で。
- ⚠ **Correction to an earlier draft: KS is not blind in any world.** It was planned to state that Set 4 kills KS; at n = 2,000 KS recovers to ARI 0.985. **KS is underpowered, not blind.**
  ⚠ **旧草案の訂正: KS はどの世界でも盲目ではない。** Set 4 が KS を殺すと述べる計画だったが、n = 2,000 で ARI 0.985 まで回復する。**盲目ではなく非力。**

**3.1.2 Metric comparison on the selection task (primary) / 指標の比較 — selection タスク（主）**

- Required n for AUC ≥ 0.9, decisive cells:
  AUC ≥ 0.9 の必要例数、決定的なセル:
  - Set 4 / symmetric severity: **W₁ 42**, KS 1,047, RV2 76, RV3 83, RV1 partial (0.63), SMD **blind** (0.51).
  - Set 4 / asymmetric severity: W₁ 67, KS 1,252, RV1 389, RV2 125, **RV3 41**, SMD 530.
  - Set 3 / combined: **W₁ 368**, KS 550, RV1/RV2/SMD **blind**, RV3 partial (0.78).
  - Set 4 / **bulk shift (control cell)**: KS **333**, W₁ 377. **KS wins here and we report it** — a uniform shift of the whole population is a tall narrow CDF gap, which is the sup-norm's specialty.
    Set 4 / **一様シフト（対照セル）**: KS **333**、W₁ 377。**ここは KS が勝ち、報告する** — 全集団の一様シフトは高く狭い CDF ギャップで、sup ノルムの得意技。
- **Harm** = expected maximum true W₁ inside the selected pool, readable as Δ_max via × L. At n = 100 W₁ is smallest in three of four worlds (0.402 / 2.583 / 0.988 / 2.000; RV2 wins Set 1 at 0.336).
  **harm** = 選ばれた pool 内の真の W₁ 最大値の期待値、× L で Δ_max として読める。n = 100 で W₁ は4世界中3つで最小（0.402 / 2.583 / 0.988 / 2.000。Set 1 は RV2 の 0.336 が最小）。
- **Two ways of measuring the same errors in Set 4**: false-pooling@k (counting errors) 0.718 vs KS 0.971 = **1.35×**; harm (weighting errors) 2.000 vs 4.27 = **2.14×**. Weighting **widens** the gap: **KS not only errs more often, it errs in the more expensive direction.**
  **Set 4 における同じ誤りの二重測定**: false-pooling@k（誤りを数える）0.718 対 KS 0.971 = **1.35倍**、harm（誤りを重みづける）2.000 対 4.27 = **2.14倍**。重みづけると差が**開く**: **KS は誤る頻度が高いだけでなく、より高価な方向に誤る。**
- Achieving method changes with n (RV2 at small n, W₁ as n grows) — state this as the guard against cherry-picking.
  達成手法が n で入れ替わる（小 n では RV2、n が増えると W₁）— cherry-pick でないことの担保として明記する。
- **Adding moments is not free**: in Set 1 RV3 is **worse** than RV2 (ARI 0.620 vs 0.996; AUC 0.847 vs 0.988) — the unnecessary third coordinate injects estimation noise — and it buys no insurance against blindness (RV3 is at chance, 0.452, in Set 3 shape-symmetric).
  **モーメントを足すのは無料ではない**: Set 1 で RV3 は RV2 より**悪い**（ARI 0.620 対 0.996、AUC 0.847 対 0.988）— 不要な第3座標が推定ノイズを注入する — そして盲目性の保険にもならない（Set 3 shape_sym で RV3 は chance の 0.452）。
- **Rank reversal on true values, sample-size independent.** Set 4 true W₁: T1 3.0, T2 6.0, P2 3.0, S1 2.0; true KS: 0.047, 0.050, 0.050, **0.072**. The clinically mildest region (S1, W₁ = 2.0) is **more discordant on KS** than the worst (T2, W₁ = 6.0). **Consequence: for τ ∈ (3, 6) there exists no KS threshold that recovers {true W₁ ≤ τ} — at any n, with an oracle-tuned threshold.**
  **真値上の順位逆転、n 非依存。** Set 4 の真 W₁: T1 3.0、T2 6.0、P2 3.0、S1 2.0。真 KS: 0.047、0.050、0.050、**0.072**。臨床的に最も軽い S1（W₁ = 2.0）が最悪の T2（W₁ = 6.0）より **KS 上で discordant**。**帰結: τ ∈ (3, 6) について {真の W₁ ≤ τ} を復元する KS 閾値は存在しない — 任意の n、oracle 調整済み閾値でも。**
- ρ = W₁/(KS·σ_EM) heuristic: ρ/ρ_trans ≲ 1 → KS matches or wins; ≳ 1.7 → W₁ wins. Retrodicts every cell.
  ρ = W₁/(KS·σ_EM) ヒューリスティック: ρ/ρ_trans ≲ 1 なら KS が並ぶか勝ち、≳ 1.7 なら W₁ が勝つ。全セルを retrodict する。

**3.1.3 Clustering as illustration / clustering — illustration として**

- **The §3.1.1 classification reproduces in a second, independent scoring currency (ARI, chance = 0), which is corroboration that the defect lies upstream in the distance**, not in a task-specific interaction. One task alone would permit "perhaps it is a quirk of that task." The blind set on ARI at n = 2,000: Set 3 RV1 **0.001**, RV2 **0.014**, SMD **0.001**; Set 4 RV1 **0.023**, SMD **0.014**. The partial set: Set 1 RV1 **0.495**, SMD **0.460**, RV3 **0.736**; Set 4 RV2 **0.380**, RV3 **0.247**.
  **§3.1.1 の分類が第二の独立な採点通貨（ARI、chance = 0）で再現する。これは欠陥が上流の距離にあることの相互裏づけ**であり、タスク固有の相性ではない。1タスクだけなら「そのタスク固有の相性では」と言えてしまう。n = 2,000 の ARI で blind: Set 3 RV1 **0.001**、RV2 **0.014**、SMD **0.001**、Set 4 RV1 **0.023**、SMD **0.014**。partial: Set 1 RV1 **0.495**、SMD **0.460**、RV3 **0.736**、Set 4 RV2 **0.380**、RV3 **0.247**。
- ARI at n = 100 / n = 2,000: Set 1 W₁ 0.995/1.000, KS 0.983/1.000, RV2 0.996/1.000; Set 2 W₁ 0.642/1.000, **KS 0.850**/1.000; Set 3 W₁ 0.526/1.000, KS 0.503/0.995; Set 4 W₁ 0.355/0.999, KS 0.003/0.985.
- Required n for ARI ≥ 0.8: Set 1 W₁ 41 / KS 49 / task floor 36 (RV2); Set 2 W₁ 156 / **KS 83**; Set 3 **W₁ 364** / KS 629; Set 4 **W₁ 376** / KS 1,240 (**3.3×**).
- **KS wins Set 2 clustering at n = 100 (0.850 vs 0.642) and we report it.**
  **Set 2 の clustering では n = 100 で KS が勝つ（0.850 対 0.642）ので報告する。**
- Oracle-k removal (silhouette k̂): **W₁ loses least** from losing the oracle (−0.005 to −0.023); **KS loses most** (−0.260 in Set 1, −0.179 in Set 2) because KS's distance structure makes silhouette choose k = 2. But **in the hard worlds no method recovers k = 3** at n = 100 (max P(k̂ = 3) is 0.228 in Set 3, 0.288 in Set 4; the mode is k = 2 for every method) — **a limit of the task, not a difference between methods.** ⚠ Do not read P(k̂ = 3) alone: RV1 and SMD score higher on it in Set 3 than W₁ while their ARI is ≈ 0, so hitting k is coincidence. And **W₁'s Set 3 advantage over KS disappears when the oracle is removed** (+0.023 → −0.005); report this honestly.
  oracle k の除去（silhouette k̂）: **W₁ は oracle 喪失の損失が最小**（−0.005〜−0.023）、**KS が最大**（Set 1 −0.260、Set 2 −0.179）— KS の距離構造が silhouette に k = 2 を選ばせる。ただし**難しい世界では誰も k = 3 を回復しない**（n = 100 で P(k̂ = 3) の最大は Set 3 0.228、Set 4 0.288。最頻値は全手法 k = 2）— **手法の差ではなくタスク自体の限界。** ⚠ P(k̂ = 3) を単独で読むな: Set 3 の RV1・SMD は W₁ より高いが ARI ≈ 0 なので k が当たるのは偶然。そして **Set 3 の W₁ 優位は oracle 喪失で消える**（+0.023 → −0.005）。正直に報告する。

**3.1.4 Justification of the proposed procedure / 提案手続きの正当化**

✅ **DECIDED (Tak, 2026-08-30): Option A — this content stays in the Discussion paragraph (applied to the `.tex` 2026-08-18, 100k figures); §3.1.4 is not written as a manuscript subsection.** The material below remains as the spec and record for that Discussion paragraph.
  ✅ **決定（Tak、2026-08-30）: 案A — 本内容は Discussion 段落（2026-08-18 適用済み、100k 数値）に留め、§3.1.4 は本文の節として書かない。** 以下は当該 Discussion 段落の仕様・記録として残す。

- **This subsection is not an even-handed comparison; it justifies the procedure the proposed method uses.**
  **本節は中立比較ではなく、提案手法が用いる手続きを正当化するものである。**
- Unified-outcome experiment: fix the **outcome** to the anchor's pool (which regions end up pooled with the anchor), fix the **metric** to W₁, let three rules produce that same object from the same estimated distances. Every one of 12 countries serves as anchor in turn. **100,000 replications**, n = 25–400. MC SE ≤ 0.0005.
  統一アウトカム実験: **アウトカム**を anchor の pool（どの地域が anchor と併合されるか）に固定、**指標**を W₁ に固定し、同じ推定距離から3規則に同じ物体を出力させる。12か国すべてが交代で anchor を務める。**100,000 反復**、n = 25–400。MC SE ≤ 0.0005。
  - **Pairwise-τ**: uses only the anchor's row (11 distances).
  - **Complete-linkage cut at τ**: uses all 66 distances; take the anchor's cluster.
  - **Silhouette k̂**: average linkage, data-chosen k; take the anchor's cluster.
- **Structural fact proved, not simulated**: a complete-linkage cut at height τ guarantees estimated diameter ≤ τ, so at the same τ the **cut pool is always a subset of the pairwise pool**. Pointwise comparison at equal τ is therefore trivial; the informative comparisons are (i) best sensitivity under matched violation control and (ii) behaviour at a fixed clinical τ.
  **証明された構造的事実（シミュレーションではない）**: 高さ τ の complete linkage cut は推定直径 ≤ τ を保証するので、同一 τ では **cut pool は常に pairwise pool の部分集合**。ゆえに同一 τ の点比較は自明であり、有意味な比較は (i) 同一 violation 制御下の best sensitivity と (ii) 固定臨床 τ での挙動。
- **Result: for the anchor estimand, pairwise screening is both sufficient in theory and better in practice.** Best sensitivity at anchor-violation ≤ 5%, n = 100: Set 1 **0.948** vs 0.841; Set 2 **0.912** vs 0.652; Set 3 **0.908** vs 0.556; Set 4 **0.636** vs 0.323. **Pairwise wins in all 20 cells (4 worlds × 5 sample sizes)** — exactly as convexity (P2) predicts, since the full-pairwise constraint is unnecessary conservatism here.
  **結果: anchor estimand には対比較が理論的に十分かつ実務的にも優れる。** anchor 違反 ≤ 5% 下の best sensitivity、n = 100: Set 1 **0.948** 対 0.841、Set 2 **0.912** 対 0.652、Set 3 **0.908** 対 0.556、Set 4 **0.636** 対 0.323。**全 20 セル（4世界 × 5例数）で対比較が優位** — 凸性（P2）の予測どおり、ここでは全ペア制約が不要な保守性であるため。
- **Scope note (not this paper's estimand): if the pool is read as a shared pooled region, the guarantee changes and the ranking inverts.** At a fixed clinical τ, n = 100: pair-violation for pairwise screening 0.607 (Set 1, τ = 9.205), **0.684** (Set 2, τ = 15.198), 0.494 (Set 3), 0.095 (Set 4) vs the τ-cut's 0.004 / 0.009 / 0.002 / 0.005; harm 8.37 / 12.99 / 2.44 / 1.63 vs 1.82 / 5.09 / 0.79 / 0.40.
  **スコープ注記（本論文の estimand ではない）: pool を共有 pooled region として読むと保証が変わり順位が逆転する。** 固定臨床 τ、n = 100 のペア違反: 対比較 0.607（Set 1、τ = 9.205）、**0.684**（Set 2、τ = 15.198）、0.494（Set 3）、0.095（Set 4）。対して τ cut は 0.004 / 0.009 / 0.002 / 0.005。harm は 8.37 / 12.99 / 2.44 / 1.63 対 1.82 / 5.09 / 0.79 / 0.40。
- **The decisive asymmetry — structural exposure versus estimation error.** Maximum pair-violation over all worlds and thresholds: pairwise screening 0.661 / 0.682 / **0.684** / 0.663 / 0.613 at n = 25 / 50 / 100 / 200 / 400 — **flat, i.e. structural; it does not vanish with more data.** The τ-cut: 0.157 / 0.089 / 0.052 / 0.011 / **0.010** — **monotone decay, i.e. estimation error only**, since the cut guarantees the diameter condition in the *estimated* distances and what remains is only "estimated diameter ≤ τ while the true diameter exceeds τ."
  **決定的な非対称性 — 構造的露出 対 推定誤差。** 全世界・全閾値を通じたペア違反の最大値: 対比較は n = 25 / 50 / 100 / 200 / 400 で 0.661 / 0.682 / **0.684** / 0.663 / 0.613 — **平坦、すなわち構造的で、データを増やしても消えない。** τ cut は 0.157 / 0.089 / 0.052 / 0.011 / **0.010** — **単調減衰、すなわち推定誤差のみ**。cut は*推定*距離において直径条件を保証するので、残るのは「推定直径 ≤ τ だが真の直径が τ を超える」場合だけ。
- ⚠ **Do not write "the cut keeps violation below 2%."** That was an error in a preliminary 2,000-replication analysis that examined only selected n = 100 cells; the global maximum is 15.7% at n = 25 and 5.2% at n = 100. The correct statement is the **decay contrast** above.
  ⚠ **「cut は violation を 2% 未満に保つ」と書いてはいけない。** 予備的な 2,000 反復分析で n = 100 の一部セルのみを見た誤り。全体最大は n = 25 で 15.7%、n = 100 で 5.2%。正しい言明は上記の**減衰の対比**。
- **Statistically chosen k is unsuitable for either purpose**: silhouette recall is high (0.79–0.99) but admission of dissimilar members reaches 0.51–0.68 in the hard worlds (0.66 even at n = 400 in Set 3) because the k = 2 bias swallows a whole second group. **Hence the guarantee comes from the clinical cut, not from clustering as such.**
  **統計的に選んだ k はどちらの目的にも不適**: silhouette の recall は高い（0.79–0.99）が、難しい世界で異質メンバーの混入が 0.51–0.68 に達する（Set 3 では n = 400 でも 0.66）— k = 2 バイアスが第二グループを丸呑みするため。**ゆえに保証は「クラスタリング」ではなく「臨床 cut」に由来する。**
- ⚠ Aggregation caveat: "best sensitivity at violation ≤ 5%" tends to sit at the loosest grid point, where violation is structurally impossible and the pair-violation contrast is invisible. **Since a clinical τ is fixed by the requirement rather than chosen, the practically relevant reading is the fixed-τ rows.**
  ⚠ 集計上の注意: 「violation ≤ 5% 下の best sensitivity」は最緩グリッド点に座りがちで、そこでは violation が構造的に起こらずペア違反の差が見えない。**臨床 τ は要件から固定されるものであり選ぶものではないので、実務的に妥当な読みは固定 τ の行。**
- ⚠ **Deliberate change to a recorded decision, stated as such**: the threshold-calibration study and this study are **not like-for-like** with the earlier anchor-rule results, because the decision procedure, the violation definition, and the τ grid all differ. **"The partition rule rescued the anchor rule's failure" cannot be written.** What can be written is that a partition-form clinical cut controls violation on its own τ grid.
  ⚠ **記録済み決定の意図的変更として明記する**: 閾値較正研究と本研究は、旧 anchor 規則の結果と **like-for-like ではない**。決定手続き、violation の定義、τ グリッドがすべて異なるため。**「partition 規則が anchor 規則の失敗を救済した」とは書けない。** 書けるのは「partition 形式の臨床 cut は自身の τ グリッド上で violation を制御する」まで。

### 3.2 Study 1 — Estimation properties / 推定特性 〔SUPPORTING〕

- Seven systematic scenarios, each specified with σ = 10, so bias and CI width are on the W₁ scale and coverage is unitless: **S1 null** (W₁ = 0), **S2** 0.2σ location (2.00), **S3** 0.5σ (5.00), **S4** 1.0σ (10.00), **S5** scale 1.5× (3.99), **S6** log-normal skew (12.15), **S7** location + scale (5.85). n = 50, 100, 200; 10,000 replications; B = 2,000.
  7つの系統的シナリオ、各 σ = 10 で規定するので bias と CI 幅は W₁ 尺度、coverage は無次元: **S1 帰無**（W₁ = 0）、**S2** 0.2σ 位置（2.00）、**S3** 0.5σ（5.00）、**S4** 1.0σ（10.00）、**S5** 尺度 1.5倍（3.99）、**S6** 対数正規の歪み（12.15）、**S7** 位置+尺度（5.85）。n = 50, 100, 200、10,000 反復、B = 2,000。
- Bias: negligible away from the boundary (S4 0.034 → 0.004; S3 0.174 → 0.020) and at most 0.189 at n = 200 (S5). At the boundary it is large and decays slowly: S1 2.463 → 1.759 → 1.260, because non-negativity forces Ŵ₁ > 0 with probability 1 when the true value is zero.
  bias: 境界から離れれば無視できる（S4 0.034 → 0.004、S3 0.174 → 0.020）、n = 200 で最大 0.189（S5）。境界では大きく、減衰が遅い: S1 2.463 → 1.759 → 1.260。真値ゼロでは非負性が Ŵ₁ > 0 を確率1で強制するため。
- Coverage near nominal at n ≥ 100 for the non-null scenarios: S3 0.948–0.951, S4 0.942–0.948, S6 0.942–0.946, S7 0.936–0.945. S5 undercovers at n = 50 (0.863 → 0.945 at n = 200); S2 0.703 → 0.947.
  非帰無シナリオでは n ≥ 100 で coverage は名目近傍: S3 0.948–0.951、S4 0.942–0.948、S6 0.942–0.946、S7 0.936–0.945。S5 は n = 50 で undercover（0.863 → n = 200 で 0.945）、S2 は 0.703 → 0.947。
- **S1 coverage is structurally zero**, not an estimator failure: the true value lies on the parameter-space boundary and the persistent positive bias prevents any finite-sample CI from covering zero.
  **S1 の coverage は構造的にゼロ**であり推定量の失敗ではない: 真値がパラメータ空間の境界にあり、持続する正のバイアスが有限標本 CI にゼロを含ませない。
- RMSE and CI width fall at the O(n^{-1/2}) rate; at n = 200 RMSE ranges 0.77 (S5) to 1.34 (S1); CI widths at n = 100 span roughly 3.6–7.0 on the W₁ scale, propagating to Δ_max linearly (e.g. S3 at n = 100: CI width 4.96 yr × L = 0.01/yr → 5.0 %pt).
  RMSE と CI 幅は O(n^{-1/2}) で減少。n = 200 で RMSE は 0.77（S5）〜1.34（S1）。n = 100 の CI 幅は W₁ 尺度で概ね 3.6–7.0 で、Δ_max に線形に伝播（例: S3 n = 100 は CI 幅 4.96 年 × L = 0.01/年 → 5.0 %pt）。
- Recommendation from this study: **n ≥ 100 per region for reliable estimation and inference**, with cautious interpretation near the null. **Label this explicitly as the estimation criterion** (see §3.0).
  本研究からの推奨: **信頼できる推定と推論には地域あたり n ≥ 100**、帰無近傍では慎重な解釈。**これが推定の基準であることを明示的にラベルする**（§3.0 参照）。
- **Delete the current SMD sensitivity table**: Study 2's metric comparison supersedes it (a detection-only contrast on three scenarios versus a full six-method decision comparison across four worlds).
  **現行の SMD 感度比較表は削除**: Study 2 の指標比較が上位互換（3シナリオでの検出有無の対比 対 4世界での6手法決定比較）。
- **S1's null behaviour is not merely a caveat here — it is the instance of the general operability statement in §2.6.** Cross-reference it in both directions.
  **S1 の帰無挙動は単なる caveat ではなく、§2.6 の一般的 operability 命題の実例。** 双方向に相互参照する。

---

## 4. Application: hypothetical thrombolytic MRCT using GUSTO-I / 応用

⚠ **Outline § → `.tex` `\label` mapping, recorded 2026-08-15 before the numbers drift.** The `.tex` currently holds only three Application subsections, and their label *names* encode the pre-restructure ordering. §4.2 (operability, NEW) is to be inserted **between** `sec:app_scenario` and `sec:app_nabcd`, so outline numbers and label names will no longer line up. **Reuse the existing labels; do not renumber them** — renaming a label that figures and cross-references already point at buys nothing and breaks the build.

| Outline § | `.tex` `\label` | Status |
|---|---|---|
| 4.1 Scenario and EM selection | `sec:app_scenario` | exists |
| 4.2 Operability check | *(new — suggest `sec:app_operability`)* | to write |
| 4.3 Per-EM W₁ across 15 partners | `sec:app_nabcd` | exists (label name is a nABCD-era relic; keep it) |
| 4.4 Clinical interpretation, eligibility, sensitivity | `sec:app_clinical` | ✅ sensitivity content written 2026-08-30 (`R/gusto_lub_sensitivity.R`, 30/30 verification PASS) |
| 4.5 All methods applied | `sec:app_allmethods` | ✅ written 2026-08-30; absorbs the dissolved pool-level check; Study-2-dependent sentences held at current-manuscript level (TODO in `.tex`) |

**Methods carries the same drift risk — §2.1, §2.6 and §2.7 are all new and two of them insert between existing labels.**
**Methods も同じ drift の危険を持つ — §2.1・§2.6・§2.7 は全て新規で、うち2つは既存 label の間に入る。**

| Outline § | `.tex` `\label` | Status |
|---|---|---|
| 2.1 The pooling-partner selection problem | *(new — suggest `sec:problem`)* | to write; absorbs the current §2 opening |
| 2.2 Existing approaches | `sec:existing` | exists, reframed |
| 2.3 Per-EM W₁ and the heterogeneity bound | `sec:nabcd_metric` | exists (nABCD-era relic name; **keep it**) |
| 2.4 Estimation | `sec:estimation` | exists |
| 2.5 Clinical calibration | `sec:inference` | exists; closing clause retracted per decision (4)/S6 — draft in `DRAFT_s25_s26_arc.md` |
| 2.6 Operability: the null floor | *(new — `sec:operability`)* | **drafted**, not applied — `DRAFT_s25_s26_arc.md` |
| 2.7 From pairwise distances to a pool | *(new — suggest `sec:pooling`)* | to write |

⚠ **アウトライン § → `.tex` `\label` の対応、数値がずれる前に記録（2026-08-15）。** `.tex` には現在 Application の subsection が3つしかなく、その label 名は restructure 前の順序を反映している。§4.2（operability、新規）は `sec:app_scenario` と `sec:app_nabcd` の**間**に挿入されるため、アウトライン番号と label 名は一致しなくなる。**既存 label は再利用し、番号に合わせて改名するな** — 図やクロス参照が既に指している label を改名しても得るものはなく、ビルドを壊す。

### 4.1 Scenario and EM selection / シナリオと EM 選択

- A sponsor developing a novel thrombolytic (Drug T) for acute myocardial infarction plans a Phase 3 MRCT and uses GUSTO-I IPD (N = 40,830; 16 regions) at the planning stage to identify pooling partners for a designated anchor region.
  急性心筋梗塞に対する新規血栓溶解薬（Drug T）を開発するスポンサーが第3相 MRCT を計画し、planning stage で GUSTO-I の IPD（N = 40,830、16地域）を用いて指定された anchor 地域の併合相手を同定する。
- Candidate EMs: age and systolic blood pressure, suggested by Phase 2 exploratory analyses and biological plausibility but with **no quantitative prior on L** for either — so the L* reverse pathway is used for both.
  候補 EM: 年齢と収縮期血圧。第2相の探索的解析と生物学的妥当性から示唆されるが、どちらも **L の定量的事前情報がない** — ゆえに両方に L* 逆算経路を用いる。
- Anchor = Region 8, n = 2,916. **Correction: the abstract currently calls this a "small-sample anchor," which the data contradicts — R8 is the 6th largest of 16 regions** (larger: R12 4,352; R14 3,437; R7 3,150; R9 3,123; R2 2,952). Change to "a designated anchor region."
  anchor = Region 8、n = 2,916。**訂正: 現行 abstract は「small-sample anchor」と呼ぶがデータと矛盾する — R8 は 16地域中6番目に大きい**（上に R12 4,352、R14 3,437、R7 3,150、R9 3,123、R2 2,952）。「a designated anchor region」に変更。
- Caveat retained: GUSTO-I was not designed as an MRCT, its regions are anonymized, and the data were collected 1990–1993; the exercise is methodological illustration, not a substantive recommendation.
  留保を維持: GUSTO-I は MRCT として設計されておらず、地域は匿名化され、データは 1990–1993 年収集。本演習は方法論的な例示であり実質的な推奨ではない。

### 4.2 Operability check / 解像度診断 〔NEW / 新規〕

⚠ **Obligation created by decision on $\alpha$ (Tak, 2026-08-18): §2.6 keeps $\alpha$ symbolic, so §4.2 must state the choice explicitly.** Write "we take $\alpha = 0.05$" as a stated choice; do not let it hide inside the phrase "95th percentile." Without that sentence §2.6's general condition has no landing point and a reader cannot tell whether 0.05 was selected or inherited by convention. The 95th-percentile column below is that $\alpha$.
⚠ **$\alpha$ に関する判断（Tak、2026-08-18）が §4.2 に作る義務: §2.6 は $\alpha$ を記号のままにするので、§4.2 が選択を明示する。** 「本例では $\alpha = 0.05$ を採る」と選択として書くこと。「95パーセンタイル」という語の中に隠すな。その一文が無ければ §2.6 の一般条件は着地点を失い、読者は 0.05 が選択されたのか惰性で継承されたのか判断できない。下表の 95th pct 列がその $\alpha$ である。

- Apply §2.6's diagnostic: resample two independent samples of the actual sizes from R8's own empirical distribution (600 replications per partner, so the floor is computed **per partner**, since it depends on that partner's n).
  §2.6 の診断を適用: R8 自身の経験分布から実サイズで独立に2標本を再抽出（相手ごとに 600 反復。帰無床は相手の n に依存するので**相手ごとに**計算する）。

| EM | Null E[Ŵ₁] | Null 95th pct | τ_clin | Partners **not resolved** from identical |
|---|---|---|---|---|
| age | 0.359 – 0.510 | 0.618 – 0.900 | **1.0 yr** | **6 / 15** — R1, R4, R5, R7, R9, R15 |
| SBP | 0.704 – 1.013 | 1.176 – 1.691 | **5.0 mmHg** | **1 / 15** — R2 only |

✅ **WRITTEN INTO THE `.tex` 2026-08-21 as `sec:app_operability`, from figures established by `R/gusto_operability_check.R` (seed 20260821, B = 2,000, α = 0.05).**
⚠ **Provenance correction.** The figures previously in this table were produced by **no script in the repository** and could not be reproduced — a repo-wide search for them returned only coincidental matches in raw data files. They have now been **established for the first time**, not corrected: the null means land within 0.002–0.024 of the old values, but the 95th-percentile ranges widen (age 0.629–0.848 → 0.618–0.900; SBP 1.198–1.589 → 1.176–1.691), consistent with 2,000 replications resolving the tails better than the 600 previously claimed. **Every verdict is unchanged**: age 6/15 unresolved = {R1, R4, R5, R7, R9, R15}, SBP 1/15 = {R2}, and **all unresolved partners fall on the eligible side** (6/6 and 1/1).
  ✅ **2026-08-21 に `sec:app_operability` として `.tex` へ執筆済み**（数値は `R/gusto_operability_check.R`、seed 20260821、B = 2,000、α = 0.05 による）。
  ⚠ **来歴の訂正。** この表の従前の数値は**リポジトリ内のどの script からも生成されておらず**再現不能だった（全文検索のヒットは生データ中の偶然一致のみ）。ゆえに今回は訂正ではなく**初めての確立**である: 帰無平均は旧値と 0.002–0.024 の差に収まるが、95 パーセンタイルの範囲は広がる（age 0.629–0.848 → 0.618–0.900、SBP 1.198–1.589 → 1.176–1.691）。2,000 反復が従前称していた 600 より裾をよく解像することと整合。**判定は一つも変わらない**: age 6/15 未解像 = {R1, R4, R5, R7, R9, R15}、SBP 1/15 = {R2}、そして**未解像の全件が eligible 側に落ちる**（6/6、1/1）。
✅ **Sensitivity, requested before computing: drawing the null from each partner's own distribution instead of the anchor's flips no verdict.** Stated in the `.tex`, since the anchor-drawn null is not symmetric and the choice would otherwise look arbitrary.
  ✅ **計算前に要求した感度分析: 帰無床を anchor ではなく各 partner 自身の分布から引いても、判定は一つも反転しない。** anchor から引く帰無は非対称なので、述べなければ選択が恣意的に見える。ゆえに `.tex` に明記した。

- "Not resolved" = the observed Ŵ₁ lies at or below the 95th percentile of its null distribution, i.e. **indistinguishable from identical distributions.**
  「解像されない」= 観測 Ŵ₁ がその帰無分布の 95 パーセンタイル以下 = **同一分布と区別できない。**
- **On age, 6 of 15 partners are indistinguishable from identical, and all six fall on the eligible side** — so an "eligible" verdict on age can mean "we could not detect a difference" rather than "they are similar."
  **age では 15 中 6 が同一分布と区別できず、その6つは全て eligible 側に落ちる** — ゆえに age での「eligible」判定は「似ている」ではなく「**差を検出できなかった**」を意味し得る。
- **On SBP, 14 of 15 are resolved. SBP is the modifier that actually carries the decision.**
  **SBP では 15 中 14 が解像される。決定を実質的に担っているのは SBP。**
- **This is not a failure report; it is what the §2.6 diagnostic is for.** The diagnostic answers the question "which EM is carrying this decision," which no existing method asks.
  **これは失敗の報告ではなく、§2.6 の診断が何のためにあるかの実例。** 診断は「どの EM が決定を担っているか」に答え、既存手法はこの問いを立てない。

### 4.3 Per-EM W₁ across the 15 partners / 15 相手に対する per-EM W₁

- Keep the distance table with bootstrap CIs and the forest plot. Point estimates: age 0.39 (R5) to 2.61 (R3); SBP 0.95 (R2) to 6.80 (R9).
  bootstrap CI つきの距離表と forest plot を維持。点推定: age 0.39（R5）〜2.61（R3）、SBP 0.95（R2）〜6.80（R9）。
- Across all 120 region pairs the pairwise age and SBP distances are nearly uncorrelated (**r = 0.133**), so the two EMs carry almost independent distributional geometry — **collapsing them into one aggregate distance would systematically mask incompatibilities.** This is the quantitative case for per-EM assessment.
  全 120 地域ペアで age と SBP の対距離はほぼ無相関（**r = 0.133**）であり、2つの EM はほぼ独立な分布幾何を持つ — **単一の集約距離に潰すと不整合を体系的に隠す。** これが per-EM 評価の定量的根拠。
- **Sentences that survive the resolution analysis / 解像度分析を生き残る文**
  - The mid-rank discussion (partners whose CIs overlap broadly are not sharply ordered by the data) **survives and is reinforced** — the null floor supports the same conclusion independently. R16 (1.74) and R6 (0.91) are both resolved on age, so the choice of examples is sound.
    mid-rank の議論（CI が広く重なる相手は データによって明確に順序づけられない）は**生き残り、強化される** — 帰無床が独立に同じ結論を支持する。R16（1.74）と R6（0.91）は age で解像されているので、例の選択自体は妥当。
  - The R2 / R9 contrast **survives and becomes stronger**: R2 is clearly different on age (2.15, resolved) and **indistinguishable from identical on SBP** (0.95, not resolved); R9 is the mirror image (age 0.59 not resolved; SBP 6.80 resolved). This is a **stronger statement than the ordinal one** ("4th-smallest"), which should be dropped.
    R2 / R9 の対比は**生き残り、より強くなる**: R2 は age で明確に異なり（2.15、解像）、**SBP では同一分布と区別できない**（0.95、未解像）。R9 は鏡像（age 0.59 未解像、SBP 6.80 解像）。これは序数表現（「4th-smallest」）より**強い言明**であり、序数表現は削る。
- **Sentences that need rewriting / 書き換えが必要な文**
  - "age spans from 0.39 (R5) at the low end" — R5's 0.39 is **below** its null expectation of 0.436.
    「age は R5 の 0.39 が最小」 — R5 の 0.39 は帰無期待値 0.436 を**下回る**。
  - "R4 emerges as the leading candidate, 3rd-lowest on age and 3rd-lowest on SBP, balanced across both" — **the age half of the argument dissolves** (R4 0.56 and R5 0.39 both unresolved). **The SBP half stands** (R4 2.60 < R5 3.37, both resolved). **The conclusion survives but its basis moves from "balanced across both EMs" to "closest on the EM that is actually resolved."**
    「R4 が leading candidate、age で3番目に小さく SBP でも3番目に小さくバランスしている」 — **age 側の論拠は消える**（R4 0.56、R5 0.39 とも未解像）。**SBP 側は成立する**（R4 2.60 < R5 3.37、両方解像）。**結論は残るが、根拠が「両 EM でバランス」から「実際に解像されている EM で最も近い」へ移る。**
- Resolution status of the six jointly eligible partners on age: R1 ✗ / R4 ✗ / R5 ✗ / R6 ✓ / R14 ✓ / R15 ✗ — **4 of 6 unresolved.**
  joint eligible 6地域の age 解像状況: R1 ✗ / R4 ✗ / R5 ✗ / R6 ✓ / R14 ✓ / R15 ✗ — **6中4が未解像。**

### 4.4 Clinical interpretation, eligibility, and sensitivity / 臨床解釈・適格性・感度分析

✅ **WRITTEN INTO THE `.tex` 2026-08-30.** Three paragraphs appended to `sec:app_clinical` (per-region slack + R7 near-miss; per-EM L_UB scaling; convergence with §4.2) plus the R7 unrounded-value correction in the eligibility paragraph. Figures established by `R/gusto_lub_sensitivity.R` — pure arithmetic on `results/gusto_r8_w1_per_pair.csv`, **30/30 verification PASS** against the values recorded below. Per the ⚠ at the asymmetry bullet, the common-factor scaling is computed **for the record only** (`results/gusto_lub_scaling.csv`, mode `common`) and does not appear in the manuscript. One presentational change against this outline: the "stable to roughly ±5–10%" summary (a common-scaling artefact, and false on the SBP downside — R7 enters at −1.4%) is replaced by exact critical factors, which are the slack values themselves: age +9.6% → R6 drops; SBP +5.8% → R15 drops; SBP −1.4% → R7 enters.
  ✅ **2026-08-30 に `.tex` へ執筆済み。** `sec:app_clinical` に3段落を追加（地域別 slack + R7 near-miss／EM 別 L_UB scaling／§4.2 との収束）+ 適格性段落の R7 丸め訂正。数値は `R/gusto_lub_sensitivity.R` が確立（**検証 30/30 PASS**）。common-factor scaling は**記録のみ**で本文に載せない。アウトラインからの変更点1つ: 「±5–10% に安定」（common scaling 由来で、SBP 下方向には偽 — R7 が −1.4% で入る）は**臨界倍率 = slack 値そのもの**の記述に置換した。

- L_UB from disease-area evidence: L_age,UB = 1×10⁻² /yr, L_SBP,UB = 2×10⁻³ /mmHg on the 30-day mortality scale, exceeding the empirical prognostic gradients reported for GUSTO-I. Eligible on an EM if L* > L_UB at Δ_clin = 1 %pt.
  疾患領域エビデンスからの L_UB: 30日死亡尺度で L_age,UB = 1×10⁻² /年、L_SBP,UB = 2×10⁻³ /mmHg。GUSTO-I で報告された経験的予後勾配を上回る。Δ_clin = 1 %pt で L* > L_UB なら当該 EM で eligible。
- Joint eligibility (AND across both EMs, since pooling requires compatibility on every evaluated modifier): **R1, R4, R5, R6, R14, R15**.
  両 EM の AND による joint 適格（併合は評価した全 modifier での両立性を要するため）: **R1, R4, R5, R6, R14, R15**。
- Correction: R7's L*_SBP is **0.001972**, not "0.0020 = L_UB" as the current text implies; the rounded display makes a strict-inequality exclusion look arbitrary. Quote the unrounded value.
  訂正: R7 の L*_SBP は **0.001972** であり、現行本文が示唆する「0.0020 = L_UB」ではない。丸め表示が厳密不等号による除外を恣意的に見せる。丸めない値を引く。
- **Sensitivity of the conclusion / 結論の感度**

| Rule / 規則 | Jointly eligible / joint 適格 |
|---|---|
| Point estimate (current) / 点推定（現行） | R1, R4, R5, R6, R14, R15 (six) |
| Bootstrap **upper** CI limit / bootstrap **上限** | **R5 only / R5 のみ** |

- ⚠ **Corrected 2026-08-02 (recomputed from `results/gusto_r8_w1_per_pair.csv`): the margins were stated as +9.9% and +6.0%; the correct values are +9.63% and +5.84%.**
  ⚠ **2026-08-02 訂正（`results/gusto_r8_w1_per_pair.csv` から再計算）: margin を +9.9% / +6.0% としていたが、正しくは +9.63% / +5.84%。**
- **The aggregate margin understates the structure — only two of the six are near a boundary.** Slack below τ, per region: R5 age +156.5% / SBP +48.3%; R4 +80.0% / +92.3%; R1 +54.7% / +38.5%; R14 +42.4% / +14.6%; **R6 age +9.6%** / SBP +48.4%; R15 age +63.8% / **SBP +5.8%**. So **four of the six are robust on both EMs, and the fragility is carried by R6 (on age) and R15 (on SBP) alone.**
  **集約 margin は構造を過小に伝える — 境界に近いのは6中2だけ。** τ に対する余裕（地域別）: R5 age +156.5% / SBP +48.3%、R4 +80.0% / +92.3%、R1 +54.7% / +38.5%、R14 +42.4% / +14.6%、**R6 age +9.6%** / SBP +48.4%、R15 age +63.8% / **SBP +5.8%**。ゆえに **6中4は両 EM で頑健であり、脆さは R6（age）と R15（SBP）だけが担っている。**
- **Near-miss on the exclusion side**: R7 passes age comfortably (0.405) and fails SBP by 1.4% (5.072 vs 5.000, L* = 0.001972 vs L_UB = 0.002). The six/nine split is not a wide gap at its edge.
  **除外側の near-miss**: R7 は age を余裕で通過（0.405）し SBP を **1.4%** 差で落ちる（5.072 対 5.000、L* = 0.001972 対 L_UB = 0.002）。6対9の分割は縁において僅差。
- **L_UB sensitivity — this is what §2.5 actually promises ("sensitivity across a plausible range"), and it is not the bootstrap CI.** Scaling both L_UB values: ×0.8 → 8 partners; ×0.9 → 7; **×1.0 → 6**; ×1.05 → 6; ×1.1 → 4; ×1.5 → 1 (R4 only); ×2.0 → none. **The conclusion is stable to roughly ±5–10% in L_UB and degrades quickly beyond it.**
  **L_UB の感度分析 — §2.5 が実際に約束しているのはこれ（「妥当な範囲での感度」）であり、bootstrap CI ではない。** 両 L_UB を同率で動かすと: ×0.8 → 8地域、×0.9 → 7、**×1.0 → 6**、×1.05 → 6、×1.1 → 4、×1.5 → 1（R4 のみ）、×2.0 → 0。**結論は L_UB の ±5–10% 程度には安定し、それを超えると急速に劣化する。**
- **The bootstrap-upper collapse is the operability finding in a second currency, not an independent result.** The only two partners surviving the upper-limit rule on age are R5 and R7 — **both of which §4.2 classifies as _not resolved from identical_.** This is coherent rather than contradictory (a small Ŵ₁ yields both a low CI upper limit and a position beneath the null floor), but it means the two analyses must be cross-referenced, not reported as separate evidence.
  **bootstrap 上限の崩壊は operability 所見の第二通貨での再表現であり、独立の結果ではない。** age で上限則を生き残る2地域は R5 と R7 だが、**その2つはどちらも §4.2 が「同一分布と区別できない」と分類した地域**。矛盾ではなく整合的だが（Ŵ₁ が小さければ CI 上限も低く、同時に帰無床の下にも入る）、**両分析は相互参照すべきで、独立の証拠として並べてはいけない。**
- ✅ **DECIDED 2026-08-08 (Tak). Include the L_UB sensitivity (a) and the per-region slack (c). Do NOT include the bootstrap-CI upper-limit sensitivity (b).**
  ✅ **決定 2026-08-08（Tak）。L_UB 感度 (a) と地域別 slack (c) は入れる。bootstrap CI 上限の感度 (b) は入れない。**
  - **Reason given: "that the answer could change if the data were insufficient is already known."** The bootstrap-upper collapse restates the age resolution problem that §4.2 already reports and that Study 1 already characterizes (positive null bias, boundary coverage). It adds no information and would read as fragility. This is Tak's P3 (delete what is not needed) applied to a redundant analysis.
    **理由: 「データが足りなかったら答えが変わる可能性があるのは既知」。** bootstrap 上限の崩壊は、§4.2 が既に報告し Study 1 が既に特徴づけている（正のヌルバイアス、境界での coverage）age の解像度問題の言い換えにすぎない。情報を追加せず、かつ脆さとして読まれる。**Tak の P3（不要なら削除）**を冗長な解析に適用したもの。
  - Consequence: the previously noted "§2.4 builds bootstrap machinery, §4.4 decides on point estimates" tension is **resolved by §4.2, not by adding (b)** — the bootstrap CIs do appear in the application (Table 3 and the forest plot), and the resolution question is answered by the null-floor diagnostic. If a reviewer asks why CI limits are not used as a decision rule, the answer is §4.2 plus the recorded finding that such a rule degenerates to abstention.
    帰結: 「§2.4 で bootstrap を構築し §4.4 は点推定で判定する」という緊張は、**(b) の追加ではなく §4.2 が解消する** — bootstrap CI は応用に登場している（Table 3・forest plot）し、解像度の問いには帰無床診断が答える。CI 上限を決定規則にしない理由を問われたら、§4.2 と「その規則は棄権に退化する」という既記録の所見で答える。
- 〔Superseded context / 経緯〕 A bootstrap-upper-limit **selection rule** had earlier been ruled out of the paper because at small n it degenerates to abstention. The (b) proposal was a different object — a sensitivity analysis of one application's conclusion at n ≈ 2,900 — but has now also been declined, on redundancy rather than degeneracy grounds.
  〔経緯〕 bootstrap 上限**選択規則**は、小 n で棄権に退化するため以前に論文外と判断済み。(b) はそれとは別の対象（n ≈ 2,900 での一応用の結論の感度分析）だったが、退化ではなく**冗長性**を理由に同じく不採用となった。
- ⚠ **Corrected 2026-08-02 — the earlier claim that §2.5 makes an undelivered promise was wrong; the .tex was not checked.** Line 177 reads: "sensitivity analyses across a plausible range of values, **or** comparison of $L^*$ to $L_{\text{UB}}$, accommodate the typical uncertainty." The **disjunction** means §4.4's $L^*$-vs-$L_{\text{UB}}$ comparison **already discharges the promise.** An L_UB range analysis is therefore an optional strengthening, **not a repair of a broken commitment.**
  ⚠ **2026-08-02 訂正 — 「§2.5 が約束を果たしていない」という従来の記述は誤り。.tex を確認していなかった。** line 177 は "sensitivity analyses across a plausible range of values, **or** comparison of $L^*$ to $L_{\text{UB}}$" であり、**選言**ゆえ §4.4 の $L^*$ 対 $L_{\text{UB}}$ 比較で**約束は既に履行されている。** L_UB の範囲分析は**破られた約束の修復ではなく**、任意の強化にすぎない。
- What does remain is a **presentational** tension, not a broken promise: §2.4 builds percentile bootstrap machinery and §4.4 then decides on point estimates. A reviewer may ask why.
  残るのは**約束違反ではなく提示上の**緊張: §2.4 で percentile bootstrap を構築しながら §4.4 は点推定で判定する。査読者はその理由を問い得る。
- **L_UB sensitivity is asymmetric across the two EMs, and SBP is the binding assumption.** Scaling each bound alone (the other held fixed), since the two are independent clinical inputs from different evidence bases: **L_age,UB** ×0.8 → 7, ×1.0 → 6, ×1.1 → 5, ×1.5 → 4, ×2.0 → 1. **L_SBP,UB** ×0.8 → 7 (admits R7), ×1.0 → 6, ×1.1 → 5, ×1.25 → 4, **×1.5 → 1 (R4 only)**, ×2.0 → 0. **At ×1.5 the age bound still leaves four partners while the SBP bound leaves one** — so the SBP assumption carries the conclusion. ⚠ Do **not** scale both bounds by a common factor: nothing makes two independently sourced clinical inputs err in the same direction by the same amount.
  **L_UB 感度は2つの EM で非対称であり、SBP が拘束的な仮定。** 2つは異なるエビデンス基盤からの独立な臨床入力なので、各々を単独で動かす（他方は固定）: **L_age,UB** ×0.8 → 7、×1.0 → 6、×1.1 → 5、×1.5 → 4、×2.0 → 1。**L_SBP,UB** ×0.8 → 7（R7 が入る）、×1.0 → 6、×1.1 → 5、×1.25 → 4、**×1.5 → 1（R4 のみ）**、×2.0 → 0。**×1.5 で age 側は4地域を残すのに対し SBP 側は1地域** — ゆえに結論を担っているのは SBP の仮定。⚠ 両者を**共通倍率で動かすな**: 独立に調達した2つの臨床入力が同方向に同率で誤る理由はない。
- **This converges with §4.2 from an independent direction.** §4.2 showed SBP carries the decision because age is unresolved against the null floor (an **estimation-resolution** argument). The L_UB sensitivity shows SBP carries the decision because the conclusion is most fragile to the SBP clinical input (a **clinical-input** argument). Two different arguments, same conclusion — worth stating explicitly.
  **これは §4.2 と独立の方向から合流する。** §4.2 は age が帰無床に対して未解像であることから SBP が決定を担うと示した（**推定解像度**の論証）。L_UB 感度は結論が SBP の臨床入力に最も脆いことから同じ結論を示す（**臨床入力**の論証）。**別の論証で同じ結論** — 明示する価値がある。

### ~~4.5 Pool-level check~~ → DISSOLVED into §4.5 Result 4 / §4.5 に統合・解体済み 〔Tak decision 2026-08-15〕

**Decision (2), 2026-08-15 — Tak: fold into Result 4, register = scope clarification.** The former §4.5 no longer exists as its own subsection. Its content — the diameter table, the R6 convergence with §4.4, and the scope-clarification framing — now lives inside **§4.5 Result 4** (the section formerly numbered 4.6, renumbered here). Rationale on record: the breach could not be omitted while Result 4 stands, since Result 4 already prints a breach **13.2× louder** (SBP 78.7% over τ) than the former §4.5's (age 5.95%); and Result 4 *is* the procedure-divergence finding the restructure is built on. Consolidating into one place removes the two-diameter reading hazard that the labelling note below was written to manage.
**判断②、2026-08-15 — Tak: Result 4 に畳む、register は scope の明確化。** 旧 §4.5 は独立節としては存在しない。内容（直径表・§4.4 との R6 収束・scope 枠組み）は **§4.5 Result 4**（旧 4.6 を繰り上げ）に統合済み。判断の根拠を記録に残す: Result 4 が立つ限り超過は伏せられない（Result 4 は旧 §4.5 の age 5.95% より **13.2 倍派手な** SBP 78.7% 超過を既に印刷しており、かつ Result 4 は restructure の土台である手続き分岐の所見そのもの）。一箇所に集約することで、下記のラベル注記が管理しようとしていた「直径が2つ見える」危険自体が消える。

---

## Computational provenance — record, not paper content / 計算の来歴 — 記録であって本文ではない

> **Numbering note.** Entries below were written before the 2026-08-15 restructure and say "§4.6" for what is now **§4.5**, and "§4.5" for the dissolved subsection. They are left as written — a provenance record should not be back-edited.
> **番号の注記。** 以下は 2026-08-15 の restructure より前に書かれたもので、現在の **§4.5** を「§4.6」、解体した節を「§4.5」と呼んでいる。来歴の記録は遡って書き換えるべきでないため、原文のまま残す。

⚠ **Diameter figures were recomputed and corrected 2026-08-02→08-08 from `data/GUSTO/gusto_all_pairwise.csv` (verified against `results/gusto_r8_w1_per_pair.csv` to 4.9e-15 over all 30 anchor distances). Three figures were wrong: partner↔partner age 1.058 → 1.0595; SBP anchor→partner 4.714 → 4.7243; SBP partner↔partner 3.020 → 3.0253.**
⚠ **直径の数値は 2026-08-02→08-08 に `data/GUSTO/gusto_all_pairwise.csv` から再計算・訂正（anchor 距離30本すべてで `results/gusto_r8_w1_per_pair.csv` と 4.9e-15 まで一致を確認）。3つの数値が誤っていた: partner↔partner age 1.058 → 1.0595、SBP anchor→partner 4.714 → 4.7243、SBP partner↔partner 3.020 → 3.0253。**

✅ **RESOLVED 2026-08-15 — the two W₁ pipelines are now one.** Surfaced 2026-08-08: `R/application_all_methods.R` and the Table 3 source (`gusto_r8_w1_per_pair.csv` / `gusto_all_pairwise.csv`) returned **different values for the same 30 anchor distances** (every one differing by 0.003–0.031; worst SBP R6: 3.3383 vs 3.3695), so §4.6's diameters came from one pipeline and §4.5's from the other and **the manuscript would have printed two different numbers for the same quantity.** **Cause diagnosed 2026-08-08** (quantile-interpolation convention `type = 7`, not the grid — see below); **`w1_s` replaced with the exact CDF-area form and the script re-run 2026-08-15. The 30 anchor distances now agree with `gusto_r8_w1_per_pair.csv` to max |diff| = 0.0e+00 — bit-identical, as they must be, since GUSTO has zero missing age/sysbp so both scripts read the same sample.** Figures below re-quoted from the re-run.
  ✅ **2026-08-15 解決 — W₁ の計算系統は1つになった。** 2026-08-08 に判明: `R/application_all_methods.R` と Table 3 の出所は**同一の anchor 距離30本すべてで異なる値**を返していた（差 0.003–0.031、最大は SBP R6 の 3.3383 対 3.3695）。§4.6 の直径は前者、§4.5 は後者に由来し、**同一量に2つの数値を印刷することになっていた。** **原因は 2026-08-08 に特定**（グリッドではなく分位点補間の規約 `type = 7`。下記参照）。**2026-08-15 に `w1_s` を厳密な CDF 面積形へ差し替えて再実行。30本すべてが `gusto_r8_w1_per_pair.csv` と max |diff| = 0.0e+00 で一致 = ビット単位で同一。** GUSTO の age/sysbp に欠測がないため両スクリプトの標本は完全に同じであり、これは当然そうでなければならない。以下の数値は再実行から引き直した。

**Diagnosis / 原因の特定 (2026-08-08) — kept as the forensic record; (2) no longer exists as of 2026-08-15 / 記録として保存。(2) は 2026-08-15 時点で存在しない**

- **Three W₁ implementations coexisted.** (1) `compute_w1` — exact CDF-area, `sum(|F̂x(mid) − F̂y(mid)| · Δ)` over the pooled order statistics; used by `fig3_w1_axis.R` (**Table 3 + forest plot**) and `gusto_all_pairwise.R`. (2) `w1_s` in `application_all_methods.R` — `mean(|quantile(x, ppoints(4000), type = 7) − quantile(y, …)|)`; used by **§4.6 only**. (3) simulations — `mean(|sort(x) − sort(y)|)` at equal n, **proved identical to (1)** (max discrepancy 8.9e-16 over 200 random trials). **So (1) and (3) share one estimand and (2) is the sole outlier.**
  **W₁ の実装が3つ併存している。** (1) `compute_w1` — 厳密な CDF 面積形。`fig3_w1_axis.R`（**Table 3・forest plot**）と `gusto_all_pairwise.R` が使用。(2) `application_all_methods.R` の `w1_s` — `ppoints(4000)` + `type = 7`。**§4.6 のみ**が使用。(3) simulation — 等 n の `mean(|sort(x) − sort(y)|)`。**(1) と厳密に同一であることを証明済み**（200 試行で最大差 8.9e-16）。**ゆえに (1)(3) が同一推定量で、(2) だけが外れている。**
- **Decomposition over all 30 anchor distances.** Switching only `type 7 → type 1` on a fine grid reproduces the exact value to **≤ 2.7e-4** (mean residual 3.0e-5 age, 8.9e-5 SBP). Refining the grid 4,000 → 200,000 while holding `type = 7` moves the value by **≤ 6.9e-4 and does not close the gap.** Interpolation accounts for **≥ 91.6% of every gap.**
  **全30本での要因分解。** 細かいグリッド上で `type 7 → type 1` だけを変えると厳密値を **≤ 2.7e-4** で再現（残差平均 age 3.0e-5、SBP 8.9e-5）。`type = 7` のままグリッドを 4,000 → 200,000 に細かくしても **≤ 6.9e-4 しか動かず、差は埋まらない。** 補間が**全ペアで差の 91.6% 以上**を説明する。
- **Mechanism, and why SBP is hit ~3× harder.** `type = 7` linearly interpolates between order statistics, i.e. replaces the step ECDF with a piecewise-linear one; the coarser the recording grid, the more this changes the distance. **age: 2,066 distinct values in 2,916 obs (1.4 obs/value) → mean |gap| 0.0035. SBP: 109 distinct values in 2,916 obs (26.8 obs/value) → mean |gap| 0.0112, max 0.0311.** SBP is recorded in coarse integer mmHg, so its ECDF has large flat steps and interpolating across them materially changes W₁.
  **機構、および SBP が約3倍強く影響を受ける理由。** `type = 7` は順序統計量間を線形補間する = 階段 ECDF を区分線形に置き換える。記録粒度が粗いほど距離が変わる。**age: 2,916 obs 中 2,066 distinct（1.4 obs/値）→ 平均 |差| 0.0035。SBP: 2,916 obs 中 109 distinct（26.8 obs/値）→ 平均 |差| 0.0112、最大 0.0311。** SBP は整数 mmHg の粗い記録なので ECDF の踏み面が広く、そこを補間すると W₁ が実質的に変わる。
- **(1)/(3) is the correct one.** The exact empirical W₁ is ∫|F̂₁ − F̂₂| dt = ∫₀¹|F̂₁⁻¹ − F̂₂⁻¹| du with the **generalized** inverse (= quantile `type = 1`). `type = 7` computes W₁ between continuity-corrected surrogates — a different estimator. The paper's asymptotics and bootstrap consistency (del Barrio et al.; Sommerfeld & Munk) are stated for the **plug-in empirical** W₁, i.e. (1).
  **正しいのは (1)/(3)。** 厳密な経験 W₁ は ∫|F̂₁ − F̂₂| dt = ∫₀¹|F̂₁⁻¹ − F̂₂⁻¹| du（**一般化**逆関数 = 分位点 `type = 1`）。`type = 7` は連続性補正された代理分布間の W₁ という別の推定量。論文の漸近論と bootstrap consistency（del Barrio ら、Sommerfeld & Munk）は **plug-in 経験** W₁ = (1) について述べられている。
- ✅ **Fixing it changed no conclusion — confirmed by re-run, not predicted.** age: Spearman(old, new) 1.00000, full rank order identical, top-9 identical. SBP: 0.99643, top-11 identical (one adjacent swap). **Joint eligible under both estimators = {R1, R4, R5, R6, R14, R15}, and the admitted counts survive: k = 9 (age), 11 (SBP).** The one boundary tight enough to have flipped is SBP R7 at 1.3% above τ; it moved 5.0673 → 5.0716, i.e. **further outside**, and remains excluded. What did shift: §4.6's SBP rank correlations and every pool diameter — re-quoted below.
  ✅ **修正しても結論は一つも変わらなかった — 予測ではなく再実行で確認。** age: Spearman(旧, 新) 1.00000、順位完全一致、top-9 一致。SBP: 0.99643、top-11 一致（隣接1組の入替のみ）。**両推定量で joint eligible = {R1, R4, R5, R6, R14, R15}、採択数も維持: k = 9（age）、11（SBP）。** 反転しうるほど境界が狭かったのは τ の 1.3% 上にある SBP の R7 だけだが、5.0673 → 5.0716 と**より外側へ動き**、除外のまま。動いたのは §4.6 の SBP 順位相関と全 pool 直径 — 下記で引き直した。
- ✅ **Latent-bug guard installed.** `application_all_methods.R` now carries a comment stating why the application uses the CDF-area form and must **not** be "made consistent" with the simulation's `mean(|sort(x) − sort(y)|)`: region sizes differ, and that form is valid only at equal n.
  ✅ **潜在バグへの予防措置。** `application_all_methods.R` に、応用側が CDF 面積形を使う理由と、simulation の `mean(|sort(x) − sort(y)|)` に「整合させて」は**ならない**理由（地域サイズが異なり、あの形は等 n でのみ妥当）をコメントとして明記した。
- ⚠ **Latent bug, separate and currently dormant.** `selection_simulation.R`'s `w1_dist` is `n <- min(length(x), length(y)); mean(abs(sort(x)[1:n] - sort(y)[1:n]))`. At equal n this is exact; at **unequal** n it silently truncates both samples to their n **smallest** values, which is not W₁ at all. The simulations always use equal n per region so it never fires — **but it must not be reused on the application, where region sizes differ.**
  ⚠ **別件の潜在バグ、現状は不発。** `selection_simulation.R` の `w1_dist` は `n <- min(...); mean(abs(sort(x)[1:n] - sort(y)[1:n]))`。等 n なら厳密だが、**不等 n では両標本を小さい方から n 個に黙って切り詰める**ので W₁ ではない。simulation は常に地域あたり等 n なので発火しないが、**地域サイズが異なる応用側に流用してはならない。**
---

### 4.5 All methods applied, compared with the simulation's recommendations / 全手法の適用と simulation 推奨との対照 〔NEW / 新規、旧 4.6〕

✅ **WRITTEN INTO THE `.tex` 2026-08-30 as `sec:app_allmethods`** — Results 1–5 as specified, one agreement table (`tab:app_allmethods`), pool diameters cross-checked against `data/GUSTO/gusto_all_pairwise.csv` (max |diff| 4.9e-15; note the CSV's `nABCD` column is $W_1/(2\cdot\text{IQR}_{\text{pooled}})$). ⚠ **The manuscript's Simulation section is still the Study-1-only structure**, so every Study-2 reference below was written at the level the current manuscript supports (S5/S6 + `tab:smd` for SMD blindness), with a TODO comment in the `.tex` listing the three re-pointings due when Study 2 enters §3: (a) "constructible but does not manifest" → cite the matched-moment / displaced-extreme worlds; (b) RV2/RV3 "adding moments is not free" simulation tie; (c) the ρ/ρ_trans regime and its thresholds. The steelman contrast with Study 2's oracle thresholds is likewise held back until Study 2 exists in the manuscript.
  ✅ **2026-08-30 に `sec:app_allmethods` として `.tex` へ執筆済み** — Result 1–5、一致表 `tab:app_allmethods`、直径は `gusto_all_pairwise.csv` と 4.9e-15 で照合（同 CSV の `nABCD` 列は $W_1/(2\cdot\text{IQR})$）。⚠ **本文の Simulation 節は Study 1 のみの旧構成のまま**なので、Study 2 参照はすべて現行本文が支持する水準（S5/S6 + `tab:smd`）で執筆し、Study 2 が §3 に入った時の張り替え3件を `.tex` の TODO コメントに記載した。steelman の「Study 2 は oracle 閾値」対比も Study 2 が本文に入るまで保留。

- **Implemented**: `R/application_all_methods.R` — six distances × two EMs × three procedures on GUSTO-I (16 regions, anchor R8). Outputs `results/app_all_methods_{distances,ranks,procedures}.csv`.
  **実施済み**: `R/application_all_methods.R` — GUSTO-I（16地域、anchor R8）に6距離 × 2 EM × 3手続き。出力 `results/app_all_methods_{distances,ranks,procedures}.csv`。
- **Note on the steelman, since it differs from Study 2's.** In the simulation the competitors receive **oracle-best thresholds**, which requires knowing the truth. In the application there is no truth, so instead each competitor is given **W₁'s k** — it admits its own k closest partners, k being the number W₁ admits at τ_clin. **Top-k matching is the fair analogue here precisely because no competitor has a pathway from a clinical margin to a threshold**; withholding a threshold from them and inventing one would be arbitrary, and matching the count removes any advantage from admitting more or fewer. State this in one sentence so a reviewer does not have to reconcile the two devices.
  **steelman が Study 2 と異なる点の注記。** simulation では競合に **oracle-best 閾値**を与えるが、これは真値の知識を要する。応用に真値はないので、代わりに各競合に **W₁ の k** を与える — 自分の距離で最も近い k 地域を認め、k は W₁ が τ_clin で認める数。**ここで top-k 一致が公平な類似物である理由は、まさにどの競合も臨床 margin から閾値への経路を持たないことにある。** 閾値を与えずに勝手に作れば恣意的になり、数を揃えれば「多く／少なく認めること」による有利さが消える。査読者が2つの仕掛けを自分で調整しなくて済むよう、本文に一文で明記する。

**Result 1 — ⚠ W₁, KS, SMD and RV1 select the same partners in GUSTO / 結果1 — GUSTO では W₁・KS・SMD・RV1 が同一の相手を選ぶ**

- Each method admits its own k closest partners, k = the number W₁ admits at τ_clin:
  各手法が自分の距離で最も近い k 地域を選ぶ（k = W₁ が τ_clin で認める数）:

| EM | k | KS | SMD | RV1 | RV2 | RV3 |
|---|---|---|---|---|---|---|
| age | 9 | **9/9 identical** | **9/9 identical** | **9/9 identical** | 8/9 (adds R11) | 8/9 (adds R10) |
| SBP | 11 | **11/11 identical** | **11/11 identical** | **11/11 identical** | 9/11 | 8/11 |

- Joint (AND across both EMs): **W₁ = KS = SMD = RV1 = {R1, R4, R5, R6, R14, R15}** — exactly §4.4's six. RV2 = {R1, R4, R5, R7, R12, R15}; RV3 = **{R1, R4, R7, R9, R10, R12, R15} — seven regions.** ⚠ **Corrected 2026-08-15: this was recorded as "eight regions" (with R5). The old run's log gives the same seven, so the error predates the W₁ unification and was never a consequence of it.**
  両 EM の AND: **W₁ = KS = SMD = RV1 = {R1, R4, R5, R6, R14, R15}** — §4.4 の6地域と完全一致。RV2 = {R1, R4, R5, R7, R12, R15}、RV3 = **{R1, R4, R7, R9, R10, R12, R15} の7地域。** ⚠ **2026-08-15 訂正: 従前は R5 を含む「8地域」と記載していた。旧実行のログでも同じ7地域なので、誤りは W₁ 統一より前からあり、統一の結果ではない。**
- Spearman correlation with W₁'s ordering (re-quoted 2026-08-15 from the unified estimator): age KS 0.964, SMD 0.896, RV1 0.896, RV2 0.911, RV3 0.904 — **unchanged**; SBP KS 0.957, SMD 0.954, RV1 0.954, **RV2 0.643, RV3 0.536**.
  W₁ の順位との Spearman（2026-08-15 に統一推定量から引き直し）: age は KS 0.964、SMD 0.896、RV1 0.896、RV2 0.911、RV3 0.904 — **不変**。SBP は KS 0.957、SMD 0.954、RV1 0.954、**RV2 0.643、RV3 0.536**。
- **Mechanism: GUSTO-I's regional differences are predominantly differences in location.** The pathological configurations the simulation constructs — matched moments, rare displaced extremes — do not occur here.
  **機構: GUSTO-I の地域差は主として位置（平均）の差。** simulation が構成した病的配置（モーメント一致、希少極値の変位）はここでは起きていない。

| ❌ Cannot be written / 書けない | ✅ Can be written / 書ける |
|---|---|
| "W₁ selects **different** partners in real data" / 「W₁ は実データで**異なる**相手を選ぶ」 | "In GUSTO, W₁ reaches the same selection as the existing methods." **The finding that four methods agree in location-dominated data is itself worth reporting.** / 「GUSTO では W₁ は既存手法と同じ選択に到達する」。**位置優位のデータで4手法が一致するという所見自体が報告に値する。** |
| "SMD misleads in practice" / 「SMD は実務で誤る」 | SMD's blind spot is **constructible but does not manifest in GUSTO.** The simulation shows the failure modes exist; the application shows they do not always bite. / SMD の盲点は**構成可能だが GUSTO では発現しない。** simulation は失敗様式の存在を示し、応用はそれが常に起きるわけではないことを示す。 |
| — | **W₁'s value in GUSTO is not a different answer but the same answer plus clinical calibration** (Δ_max, L*); no competitor has a translation pathway to Δ_clin. / **GUSTO における W₁ の価値は「別の答え」ではなく「同じ答え＋臨床較正」**（Δ_max、L*）。競合に Δ_clin への翻訳経路はない。 |
| — | **One cannot know a priori whether one's own data is location-dominated**, so the simulation functions as a map of when to worry. / **自分のデータが位置優位かは事前に分からない**ため、simulation は「いつ心配すべきか」の地図として機能する。 |

**Result 2 — ✅ P1 confirmed exactly in real data / 結果2 — P1 が実データで厳密に確認された**

- **RV1 vs SMD: Spearman = 1.0000 on both EMs** (identical ordering), Pearson 0.9999 (age) and 0.9995 (SBP).
  **RV1 対 SMD: 両 EM で Spearman = 1.0000**（順位完全一致）、Pearson 0.9999（age）・0.9995（SBP）。
- This confirms in real data that on a single continuous EM Ch.4's representative value **is** the mean, so RV1 measures a standardized mean difference — **stronger evidence than the simulation's approximate ARI agreement.**
  単一連続 EM では Ch.4 の代表値が**平均そのもの**であり、ゆえに RV1 は標準化平均差を測っていることが実データで確認された — **simulation の ARI 近似一致より強い証拠。**
- ⚠ **This is a scope observation about Ch.4, not a criticism.** Ch.4's worked example uses proportions of binary characteristics, where one summary describes the distribution completely.
  ⚠ **これは Ch.4 への批判ではなく適用範囲の指摘。** Ch.4 の worked example は2値特性の割合で、そこでは1要約が分布を完全に記述する。

**Result 3 — ✅ Adding moments changes the selection, with no guarantee of improvement / 結果3 — モーメントを足すと選択が変わるが、改善の保証はない**

- Only RV2 and RV3 depart from the consensus, and their rank agreement with W₁ **degrades** on SBP (0.643 / 0.536 versus 0.954 for SMD and RV1).
  consensus から外れるのは RV2 と RV3 のみで、SBP では W₁ との順位一致が**劣化**する（0.643 / 0.536 対 SMD・RV1 の 0.954）。
- Illustrative case: **R6 is W₁ 0.912 (close) but RV2 2.056 (far)** — the SD coordinate excludes it. With no ground truth in real data, **the application alone cannot adjudicate which is right.**
  象徴的な例: **R6 は W₁ 0.912（近い）だが RV2 では 2.056（遠い）** — SD 座標が排除する。実データに真値がないため、**応用だけではどちらが正しいか決着しない。**
- Consistent with the simulation's finding that adding moments is not free (RV3 worse than RV2 in Set 1). **Only the simulation and the application together license the statement that RV2/RV3's departures are more likely noise than information** — this is the value of presenting both.
  simulation の「モーメントを足すのは無料ではない」（Set 1 で RV3 が RV2 より悪い）と整合。**simulation と応用を組み合わせて初めて「RV2/RV3 の逸脱は情報よりノイズの可能性が高い」と言える** — 両者を並べる価値がここにある。

**Result 4 — ✅ The procedures diverge sharply, and what separates them is the diameter condition / 結果4 — 手続きは大きく分岐し、それを分けているのは直径条件**

*This result carries two things that used to be written apart: the procedure comparison, and the pool-level check formerly at §4.5 (consolidated here by Tak's decision, 2026-08-15). They belong together because **the divergence between the procedures simply is the diameter condition** — the pairwise screen answers the anchor estimand, the complete-linkage cut answers the shared-region reading, and the gap between 9 and 2 is what that extra condition costs. Read as one argument, not as a finding plus a caveat.*
*この結果は、従来は別々に書かれていた2つを担う: 手続き比較と、旧 §4.5 の pool 水準の検証（Tak 判断 2026-08-15 によりここへ集約）。両者が同じ場所に属するのは、**手続き間の分岐がそのまま直径条件だから**である — 対比較 screening は anchor estimand に答え、complete-linkage cut は共有 region の読みに答える。9 と 2 の差は、その追加条件の値段そのもの。**所見＋caveat ではなく、一本の論証として読ませる。***

| EM | Pairwise τ screen | Complete-linkage τ cut | Silhouette k̂ |
|---|---|---|---|
| age | **9 partners** | **2** (R5, R6) | k̂ = 3 → 10 |
| SBP | **11 partners** | **2** (R2, R16) | k̂ = 2 → 2 |

- **P5 confirmed**: the cut pool is a subset of the pairwise pool on both EMs, as the theory requires.
  **P5 確認**: cut pool は両 EM で pairwise pool の部分集合。理論の要求どおり。

**Pool-level check — the §2.7 worked example, consolidated here (Tak decision 2026-08-15) / pool 水準の検証 — §2.7 の worked example をここに集約（Tak 判断 2026-08-15）**

- **Start from what the method actually claims.** Every anchor→partner distance is within τ on both EMs, so R8's own heterogeneity bound holds. **For the stated purpose — selecting R8's pooling partners — the pool is valid, and there is no breach of anything the method promises.** This is not a caveat being softened; it is what P2 (convexity) guarantees, and it is why pairwise screening is the procedure rather than a full-pairwise constraint.
  **手法が実際に主張していることから始める。** anchor→partner の距離は両 EM で全て τ 以内であり、R8 自身の異質性上界は成立する。**目的（R8 の併合相手選択）に対して pool は妥当であり、手法が約束したものは何一つ破られていない。** これは caveat を和らげているのではなく、P2（凸性）が保証する当のものであり、全ペア制約ではなく対比較 screening が手続きである理由そのもの。
- **A diameter condition applies only under a different reading — that the pool is a shared pooled region** in which every member, not just the anchor, carries the bound. Under that reading the relevant quantity is the pool's diameter, and it depends on which pool is meant:
  **直径条件が適用されるのは別の読み — pool を共有 pooled region と見なし、anchor だけでなく全メンバーが上界を担う場合**のみ。その読みでの当該量は pool の直径であり、どの pool を指すかに依存する:

| Pool / 対象 pool | age (τ = 1.0) | SBP (τ = 5.0) |
|---|---|---|
| R8 + the six **jointly** eligible (§4.4) / **joint** eligible 6地域 | 1.0595 — **over by 5.95%**, on 1 of 15 mutual pairs (R1–R6) / **5.95% 超過**、15相互ペア中1本 | 4.7243 — within / 合格 |
| R8 + each EM's **own** pairwise-admitted set / 各 EM 自身の pairwise 採択集合 | 9 partners → 1.1093, **over by 10.9%** / 9地域 → **10.9% 超過** | 11 partners → 8.9362, **over by 78.7%** / 11地域 → **78.7% 超過** |
| R8 + complete-linkage cut at τ / 高さ τ で complete linkage cut | 2 partners → 0.9121, within / 合格 | 2 partners → 4.2823, within / 合格 |

- **The cost of enforcing the diameter is the finding, not the breach.** Requiring the shared-region condition drops the admissible partner count from 9 to 2 on age (**78% loss**) and from 11 to 2 on SBP (**82% loss**). That is the price of the extra conservatism, and it is the practical reason the anchor estimand is the scope the method is built for.
  **所見は超過ではなく、直径を強制する費用のほうである。** 共有 region 条件を課すと併合可能な相手は age で 9→2（**78% 減**）、SBP で 11→2（**82% 減**）。これが追加的保守性の値段であり、anchor estimand を手法の scope とする実務上の理由。
- **Write it as a scope clarification, not a confession**: "the method bounds the anchor's heterogeneity; if the pool is intended as a shared pooled region, the mutual-distance condition applies additionally, and in this example one pair on age breaches it."
  **欠陥の告白ではなく scope の明確化として書く**: 「本手法は anchor の異質性を上界する。pool を共有 pooled region として意図する場合は相互距離の条件が追加で適用され、本例では age で1ペアがそれを破る。」
- Two details worth one sentence each. **(i)** The breaching pair is R1–R6, and **R6 is the same region §4.4 flags as the age-borderline member** — the two analyses converge on one region, which is stronger stated as a convergence than reported as two unrelated caveats. **(ii)** On SBP the joint-pool diameter is set by an anchor→partner distance (4.7243), not by a mutual pair, so **on that EM the anchor is the extreme point of its own pool and the shared-region reading costs nothing.**
  各一文で足りる細部が2つ。**(i)** 超過ペアは R1–R6 であり、**R6 は §4.4 が age の境界地域として名指しする当の地域** — 2つの分析が1地域に収束しており、無関係な caveat 2件より収束として述べるほうが強い。**(ii)** SBP では joint pool の直径を決めているのは相互ペアではなく anchor→partner 距離（4.7243）なので、**この EM では anchor 自身が pool の端点であり、共有 region 読み替えの追加コストはゼロ。**
- Risk of omission: a reviewer runs the same computation and writes "the application falls into the trap the paper's own theory identifies." Writing it first turns the same fact into evidence of scope discipline.
  伏せる危険: 査読者が同じ計算をして「論文自身の理論が指摘した罠に応用が落ちている」と書く。先に書けば同じ事実が scope の規律の証拠になる。

⚠ **Drafting guard — three diameters appear in the table above and they are different quantities.** Do not let two of them land in the same sentence unlabelled: a reader who sees age 1.0595 and 1.1093 nearby will take one for a typo of the other. Always name the pool. Related: the age cut-pool diameter (0.9121) is numerically identical to the age max anchor→partner distance — coincidence, not identity; keep them apart in the prose.
  ⚠ **執筆時の注意 — 上表には3つの直径があり、それぞれ別の量である。** ラベルなしで2つを同じ文に置くな: age の 1.0595 と 1.1093 が近接すれば読者は片方を誤植と読む。**必ず pool を明示すること。** 関連: age の cut pool 直径（0.9121）は age の anchor→partner 最大と数値が一致するが、これは偶然であって同一性ではない。散文中では離すこと。

**Result 5 — ρ heuristic behaviour / ρ ヒューリスティックの挙動**

- ρ = W₁/(KS·σ_EM) computed for all pairs (stored in the CSV). KS's rank agreement with W₁ is 0.964 on age and 0.957 on SBP, consistent with GUSTO sitting in the simulation's "ρ/ρ_trans ≲ 1, KS matches" regime. **KS matching here is predicted, not a defeat for W₁.**
  ρ = W₁/(KS·σ_EM) を全ペアで算出（CSV に格納）。KS と W₁ の順位一致は age 0.964、SBP 0.957 であり、GUSTO が simulation の「ρ/ρ_trans ≲ 1 なら KS が並ぶ」領域に位置することと整合。**ここで KS が並ぶのは予測どおりであり、W₁ の敗北ではない。**
- **Required sentence bounding what ρ is (decision (5), Tak 2026-08-15 — ρ stays here and is not promoted to a named diagnostic).** ρ **explains, after the fact, why the measures agreed in this dataset; it is not a pre-screening rule for deciding whether to use W₁.** W₁ appears in its numerator, so any sponsor who can compute ρ has already computed W₁ — the quantity can say whether KS would have sufficed, never whether W₁ was needed. Its thresholds (≲ 1, ≳ 1.7) also retrodict the study they were constructed from and carry no held-out validation. **Write this bound explicitly**; without it a reader takes ρ for a method being proposed.
  **ρ が何であるかを画定する必須の一文（判断⑤、Tak 2026-08-15 — ρ はここに留め、名前のある診断に格上げしない）。** ρ は**本例で各手法が一致した理由を事後に説明するものであり、W₁ を使うか否かを事前に決める選別規則ではない。** 分子に W₁ があるため、ρ を計算できるスポンサーは**既に W₁ を計算し終えている** — この量が言えるのは「KS で足りたか」だけで、「W₁ が必要だったか」ではない。閾値（≲ 1、≳ 1.7）も**構成した当のスタディを retrodict する**もので、held-out 検証を持たない。**この画定を明示的に書くこと**。書かなければ読者は ρ を提案手法と受け取る。

**Discussion skeleton for §4.5 / §4.5 の考察の骨格**

> The simulation establishes **that the failure modes exist and when they manifest.** The application establishes **that they do not manifest in this particular dataset.** Only together do they license: (i) in location-dominated data existing methods suffice — **W₁ does no harm**; (ii) the configurations in which they do manifest are clinically realistic (mixtures, rare extremes are ordinary), and **one cannot know in advance which world one is in**; (iii) therefore the reason to use W₁ is not that it always gives a different answer, but that **it is the only option that does not break in the worlds where the answer changes and that carries a clinical calibration.**
>
> simulation は**失敗様式が存在すること、およびいつ発現するか**を確立する。応用は**この特定のデータでは発現しないこと**を確立する。両者を並べて初めて言えるのは — ①位置優位のデータでは既存手法で足りる、**W₁ は害を与えない** ②発現する構成は臨床的に現実的（混合分布・希少極値は普通にある）であり、**事前に自分がどちらの世界にいるか分からない** ③ゆえに W₁ を使う理由は「常に違う答えを出すから」ではなく、**「答えが変わる世界でも壊れず、かつ臨床較正を持つ唯一の選択肢だから」**。

- ⚠ **This is more controlled than the current abstract and Discussion imply.** The present text suggests W₁'s advantage as a practical difference; GUSTO does not support that. **The claim level must be brought into line.**
  ⚠ **これは現行 abstract と Discussion の含意より控えめ。** 現行本文は W₁ の優位を実務的な差として示唆しており、GUSTO はそれを支持しない。**主張水準を揃える必要がある。**

---

## 5. Discussion

- Restate the three contributions against the three gaps, **once** — the current text repeats the SMD/KS/KL contrast in three separate paragraphs; consolidate into one.
  3つの gap に対する3つの貢献を**一度だけ**述べ直す — 現行本文は SMD/KS/KL の対比を3つの別段落で繰り返している。1箇所に統合する。
- Fix the cross-reference: the current text says "three gaps identified in §2.1" but lists bootstrap inference as the third, which is not one of §2.1's three requirements (beyond location / clinical scale / theoretical link).
  相互参照を修正: 現行本文は「§2.1 が特定した3つの gap」と述べながら第3項に bootstrap 推論を挙げるが、これは §2.1 の3要件（位置を超える / 臨床尺度 / 理論的接続）ではない。
- Two interpretive implications for pooling decisions:
  併合判断への2つの解釈的含意:
  - **All candidate EMs must be evaluated jointly.** A partner similar on one modifier may not be on another (R2 / R9), and r = 0.133 shows the two carry nearly independent geometry.
    **全候補 EM を同時に評価しなければならない。** ある modifier で似ている相手が別の modifier では似ていない（R2 / R9）。r = 0.133 が両者のほぼ独立な幾何を示す。
  - **Selection cannot rest on W₁ ranking alone.** The required slope L* varies markedly across partners and modifiers, so the same W₁ carries different clinical weight.
    **選択は W₁ の順位だけに依拠できない。** 必要傾き L* は相手と modifier で大きく変わるので、同じ W₁ が異なる臨床的重みを持つ。
- **Relation to Komiyama et al.** — per-EM resolution matters because rankings reverse across modifiers; the heterogeneity bound answers a question their account leaves open (whether a pooled estimate transfers to an individual member); their Lasso relevance weighting is **ahead of us** on EM selection, and their treatment of pool count (≤ 4 on multiplicity grounds) addresses a question **we do not**. The two are complementary and the constraints can be applied in sequence.
  **小宮山らとの関係** — 順位が modifier で逆転するため per-EM の解像度が重要。異質性上界は彼らの記述が開いたままにする問い（pooled 推定値が個別メンバーに転移するか）に答える。彼らの Lasso 関連度重みづけは EM 選択において**我々より進んでおり**、pool 数の扱い（多重性根拠から4以下）は**我々が論じていない**問いに答えている。両者は補完的で、制約は順次適用できる。
- **Procedure guidance, now backed by §2.7 and §3.1.4**: which procedure is appropriate follows the **estimand**, not statistical performance. Pairwise screening for a single borrowing region; diameter-controlled clustering for shared pooled regions. **The guarantee derives from the clinical cut, not from clustering as such.**
  **手続きの助言（§2.7 と §3.1.4 が裏づける）**: どの手続きが妥当かは統計的性能ではなく **estimand** に従う。一地域の借用には対比較、共有 pooled region には直径制御クラスタリング。**保証は「クラスタリング」ではなく「臨床 cut」に由来する。**
- **The weapon against KS is not the ARI table.** The required-sample-size results only say "KS works if you give me 3.3× the patients." The n-independent results — the calibrating-constant asymmetry and the rank reversal — are what close that argument. Lead with them.
  **KS に対する武器は ARI の表ではない。** 必要例数の結果は「例数を 3.3 倍寄越せば KS でよい」としか言っていない。n 非依存の結果 — 較正定数の非対称性と順位逆転 — がその議論を封じる。そちらを前面に出す。
- Practice recommendation: compute per-EM W₁ with bootstrap CIs for every candidate EM across region pairs; **run the operability diagnostic**; translate into Δ_max or L*; report alongside clinical benchmarks; **state which estimand the pool serves**; and if a shared pooled region is intended, check mutual distances.
  実務推奨: 全候補 EM について地域ペアの per-EM W₁ を bootstrap CI つきで算出し、**operability 診断を実行**、Δ_max または L* へ翻訳、臨床ベンチマークと並べて報告、**pool がどの estimand に供するかを明示**、共有 pooled region を意図するなら相互距離を検証する。
- Policy: W₁ needs only baseline EM distributions, so regional data can come from prior trials, registries, or RWE — relevant as agencies promote RWE use.
  政策: W₁ はベースライン EM 分布のみを要するので、地域データは既存試験・レジストリ・RWE から構成できる — 当局が RWE 活用を促進する状況で意義がある。
- **Limitations / 限界**
  - Continuous EMs treated marginally; categorical and multivariate extensions are future work.
    連続 EM を周辺的に扱う。カテゴリカル・多変量拡張は将来課題。
  - Positive bias and zero bootstrap coverage at the boundary; hence n ≥ 100 and caution near the null — **now formalized as the operability condition.**
    境界での正のバイアスと bootstrap coverage ゼロ。ゆえに n ≥ 100 と帰無近傍での慎重さ — **operability 条件として定式化された。**
  - **Age operability in the application**: on the modifier where the null floor approaches τ_clin, ranking is not resolved; report as a lesson, with the diagnostic as the remedy.
    **応用における age の operability**: 帰無床が τ_clin に接近する modifier では順位が解像されない。診断を対処として、教訓として報告する。
  - **Outlier sensitivity** of W₁, with mitigations (clinical truncation, trimmed W₁).
    W₁ の**外れ値感度**と緩和策（臨床的切り詰め、trimmed W₁）。
  - **Looseness under a saturating CATE**: the bound stays valid and becomes conservative, so W₁ over-warns. **This is an error in the safe direction** — W₁'s error is declining to pool (efficiency loss), KS's is pooling wrongly (validity loss). Report the looseness; do not apologize for it. Note that this is also **why the two bounds are non-nested** (§2.3).
    **飽和 CATE 下での緩み**: 上界は妥当なまま保守的になり、W₁ は過剰に警告する。**これは安全側の誤り** — W₁ の誤りは併合を見送ること（効率の損失）、KS の誤りは誤って併合すること（妥当性の損失）。緩みは報告し、謝罪はしない。これが**両上界が非入れ子である理由**でもある（§2.3）。
  - Unmeasured EMs may contribute heterogeneity beyond what any index captures.
    未測定の EM が、どの指標も捉えない異質性に寄与し得る。
- **Out of scope, deliberately / 意図的にスコープ外**
  - **No simulation that posits an explicit θ.** Three reasons: (i) "regions differing in EM distribution have different average effects" follows **from the definition** of an effect modifier, so verifying it verifies the setup, not a claim; (ii) the KR bound holds for **every** 1-Lipschitz θ, so fixing one θ conditions the conclusion on that shape and forfeits the general answer; (iii) by KR duality W₁ = sup over Lip₁, so with θ free to choose W₁ wins **by definition** — "W₁ tracked the effect difference best" would restate the theorem, not evidence it.
    **明示的な θ を置くシミュレーションは行わない。** 3つの理由: ①「EM 分布が異なる地域は平均効果が異なる」は効果修飾因子の**定義から従う**ので、検証しても主張ではなく問題設定を確認するだけ ②KR 上界は**あらゆる** 1-Lipschitz θ で成立するので、θ を1つ固定すれば結論がその形に条件づけられ一般性を失う ③KR 双対性より W₁ = Lip₁ 上の sup なので、θ を自由に選べる設定では W₁ が**定義上**勝ち、「W₁ が効果差を最もよく追えた」は定理の言い換えであってその証拠ではない。
  - Future directions: upstream EM identification (Lasso relevance weighting as one front end), and boundary bias-correction to extend the operational range.
    将来課題: 上流の EM 同定（front end のひとつとして Lasso 関連度重みづけ）、および operational range を拡張する境界バイアス補正。

---

## 6. Appendix / 付録

- A. Metric axioms for W₁ (non-negativity, identity of indiscernibles, symmetry, triangle inequality) and affine equivariance.
  A. W₁ の距離公理（非負性、不可識別者同一、対称性、三角不等式）とアフィン同変性。
- B. Proof of Proposition 1 via Kantorovich–Rubinstein duality.
  B. KR 双対性による命題1の証明。
- C. **Sharpness and non-nestedness / 鋭さと非入れ子性** 〔NEW〕 — L·W₁ sharp over Lip; D_KS·TV(θ) sharp over BV via integration by parts; divergence of TV for a Lipschitz θ on unbounded support; W₁ ≤ W₂.
- D. **Pool-formation propositions / pool 形成の命題** 〔NEW〕 — P2 convexity of W₁ in mixtures; P3 the 2τ exposure; P4 the complete-linkage diameter guarantee and why average linkage fails it.
- E. Asymptotics of Ŵ₁ (del Barrio et al. limit law; bootstrap consistency via Hadamard differentiability, Sommerfeld & Munk; convergence rate).
  E. Ŵ₁ の漸近論（del Barrio らの極限定理、Hadamard 微分可能性による bootstrap consistency（Sommerfeld & Munk）、収束率）。
- F. Scale-normalization redundancy (any W₁/X cancels in Δ_max).
  F. 尺度正規化の冗長性（任意の W₁/X は Δ_max で相殺する）。
- G. Derivation of the L_UB bounds used in the application, alternative specification strategies, and the limitations of class-level evidence.
  G. 応用で用いた L_UB の導出、代替の指定戦略、クラスレベルエビデンスの限界。
- H. Full Study 1 tables (RMSE, CI width, BCa comparison) if moved out of the main text.
  H. Study 1 の完全な表（RMSE、CI 幅、BCa 比較）を本文外に移す場合。
- I. Reproduction: script inventory and commands.
  I. 再現: スクリプト一覧とコマンド。

---

## 7. Attribution rules — must not be violated / 帰属の禁則 — 違反不可

| ❌ Never write / 書いてはいけない | ✅ Correct / 正しい |
|---|---|
| "Komiyama uses (mean, SD) coordinates" | Ch.4 assigns **one** representative value per EM |
| "Komiyama could add skewness to the coordinates" | Ch.4 does not discuss within-EM moments at all |
| Calling RV2 / RV3 "Komiyama's method" | **Our extensions**, granted in advance to pre-empt the obvious objection |
| "No quantitative pooling method exists" | Ch.4 provides a complete, concrete recipe |
| "Komiyama ignores EM relevance" | Handled via Lasso weighting — **ahead of us** (we have no EM selection method) |
| "Komiyama does not address the number of pools" | **Komiyama Ch.4 §4.6.1.3** answers it (≤ 4, on multiplicity grounds) — **we do not**. (Book section, not ours — our §4.6 no longer exists.) |
| "KS is blind" | **Underpowered, not blind** (recovers to ARI 0.985 at n = 2,000) |
| "The alternative measures lack any analogous bound" | KS admits D_KS·TV(θ); the bounds are **non-nested** and differ in their **calibrating constant** |
| "W₂ cannot provide an analogous bound" | W₁ ≤ W₂ gives a valid but looser bound; W₂ lacks the **sharp** Lipschitz form |
| "The clustering cut keeps violation below 2%" | 15.7% at n = 25, 5.2% at n = 100; the claim is the **decay contrast** |

Source of truth: `EXISTING_METHODS_AND_NOVELTY.md` §3 and the primary PDFs in `knowledge/pdfs/Ch4_Pooling_Strategy/`.
出所: `EXISTING_METHODS_AND_NOVELTY.md` §3 および原典 PDF `knowledge/pdfs/Ch4_Pooling_Strategy/`。

---

## 8. Decisions — all five closed / 判断 — 全5件決着

**Status: 5 / 5 decided (①2026-08-02, ②–⑤ 2026-08-15). No decision is awaiting Tak.** What remains is implementation, and the `.tex` edits queued under (4) go through paragraph review before they are applied.
**状況: 5件中5件決着（①2026-08-02、②〜⑤2026-08-15）。Tak 待ちの判断は無い。** 残るのは実装であり、(4) の下に queue した `.tex` 修正は適用前に段落レビューを通す。

1. ✅ **DECIDED 2026-08-02 — §4.4 sensitivity analysis. Tak: include (a) the L_UB sensitivity and (c) the per-region slack; drop (b) the bootstrap-CI upper rule.** Grounds Tak gave for dropping (b): "if the data were insufficient the answer could change" is already known — §4.2's null floor and Study 1's null bias and boundary coverage report it twice, and a third appearance wearing a robustness-check face adds no information while inviting the misreading that the conclusion is fragile (P3 — delete what is not needed). Distinct from the previously rejected bootstrap-upper **selection rule**.
   / ✅ **2026-08-02 決定 — §4.4 の感度分析。Tak: (a) L_UB 感度と (c) 地域別 slack は入れ、(b) bootstrap CI 上限則は落とす。** (b) を落とす理由として Tak が挙げたもの: 「データが足りなければ答えが変わる」は既知であり、§4.2 の帰無床と Study 1 のヌルバイアス・境界 coverage が**既に二重に報告している**。三度目を robustness check の顔で出せば新情報ゼロで「結論が脆い」という誤読だけを買う（P3 — 不要なら削除）。却下済みの bootstrap 上限**選択規則**とは別物。
2. ✅ **DECIDED 2026-08-15 — pool-diameter breach.** "Write or omit" turned out not to be the decision: omission was unreachable while Result 4 stands, since Result 4 already prints a breach **13.2× louder** (SBP 78.7% over τ) than the former §4.5's (age 5.95%), and Result 4 *is* the procedure-divergence finding the restructure is built on. **Tak's call: (i) fold it into §4.5 Result 4 — the former §4.5 is dissolved and the subsection renumbered; (ii) register = scope clarification, not limitation.** Implemented.
   / ✅ **2026-08-15 決定 — pool 直径超過。** 「書くか伏せるか」は判断ではなかった: Result 4 が立つ限り「伏せる」は到達不能（Result 4 は旧 §4.5 の age 5.95% より **13.2 倍派手な** SBP 78.7% 超過を既に印刷しており、かつ Result 4 は restructure の土台）。**Tak 判断: (i) §4.5 Result 4 に畳む — 旧 §4.5 は解体し、節番号を繰り上げ。(ii) register は限界ではなく scope の明確化。** 反映済み。
3. ✅ **DECIDED 2026-08-15 — §2.6 placement. Tak: keep it as its own subsection, and frame §2.5 → §2.6 as a single calibration arc.** Grounds on record: (a) Q_operability is one of the three top-level questions the paper answers, so folding it demotes a claim the paper makes; (b) §4.2 is a dedicated Application subsection and the Methods/Application parallelism should hold; (c) the abstract names the diagnostic as an application highlight; (d) decisively — **independence is what lets §4.2 read as the diagnostic working rather than the method stumbling**. The arc framing neutralises the one real risk of independence. Length was checked and is not a constraint (the `.tex` is ~9,830 words, Methods ~2,111).
   / ✅ **2026-08-15 決定 — §2.6 の配置。Tak: 独立節として維持し、§2.5 → §2.6 を一本の較正の弧として書く。** 根拠を記録: (a) Q_operability は論文が答える3つの最上位の問いの1つであり、折り込めば論文自身の主張を格下げする (b) §4.2 は Application の独立節であり Methods/Application の対応を保つべき (c) abstract が診断を応用の要点として名指ししている (d) 決定的には — **独立性こそが §4.2 を「手法のつまずき」ではなく「診断の仕事」として読ませる**。弧の枠組みが独立の唯一実在するリスクを打ち消す。長さは確認済みで制約ではない（`.tex` 約 9,830 words、Methods 約 2,111）。
4. ✅ **DECIDED 2026-08-15 — claim level. Tak: the GUSTO agreement is stated in the Discussion only; the abstract does not carry it.** The framing that made this tractable: **the fix is not to weaken the claims but to relocate the difference claim from the application to Study 2**, where the divergence is real (structural blindness at any n, an identification failure) rather than resting on capability language illustrated by a dataset that produced no difference. **Consequence Tak's choice creates: the Discussion now carries the controlled reading alone, so §5 ¶5 becomes load-bearing** — see the required edits below.
   / ✅ **2026-08-15 決定 — 主張水準。Tak: GUSTO の一致は Discussion にのみ記述し、abstract には載せない。** 判断を可能にした枠組み: **修正は主張を弱めることではなく、差の主張を応用から Study 2 へ移すこと。** Study 2 には本物の乖離がある（任意の n で構造的に盲目 = 検出力ではなく識別の失敗）のに対し、現行は能力の言葉を、差の出なかったデータで例示している。**Tak の選択が生む帰結: controlled な読みを Discussion が単独で担うため、§5 ¶5 が load-bearing になる** — 下記の必須修正を参照。

**Required edits to `paper/per_em_W1_wiley.tex` — decision (4) / 判断④による `.tex` の必須修正**

⚠ **These are queued, not applied. The abstract and Discussion are existing prose and go through the paragraph review process with Tak before being rewritten** (`memory/feedback_review_process.md`). The four factual/hierarchy fixes are forced and independent of the abstract/Discussion split; the fifth follows from Tak's choice.
⚠ **未適用・待機中。abstract と Discussion は既存の散文であり、書き換え前に Tak との段落単位レビューを通す**（`memory/feedback_review_process.md`）。①〜④は強制で abstract/Discussion の切り分けとは独立、⑤は Tak の選択から従う。

| # | Location | Fix | Why forced |
|---|---|---|---|
| 1 | Abstract, "a **small-sample** region identifies suitable pooling partners" | → "a designated anchor region" | R8 is n = 2,916, **6th largest of 16** — the data contradict the phrase |
| 2 | Abstract, "one region designated as a **small-sample anchor**" | same substitution | second occurrence of the same contradiction |
| 3 | Abstract, "**Simulation studies across seven systematic scenarios demonstrated satisfactory bias and coverage**…" | lead with Study 2 (structural blindness of representative-value/mean-based measures at any n; RV1 ≡ SMD on a single continuous EM; KS underpowered rather than blind and erring in the more expensive direction); demote Study 1 to one supporting clause. **Same pass (added 2026-08-30, Louis, during the ¶6 review):** re-examine the abstract's "captures differences in scale and skewness in addition to location" against whatever Tak decides for row 6 — the phrase is analytically true (SMD = 0 whenever means match, §2.2) but names moments the surviving Study 2 evidence does not single out | Study 1 language is standing where the claim hierarchy puts Study 2 |
| 4 | Discussion ¶1 item (i), "as confirmed by simulation scenarios … (**S5, S6**)" | ✅ **APPLIED 2026-08-30 — paragraph review, Tak chose Option B**: full ¶1 rewrite. (i) upgraded to the identification claim ("every summary-based competitor is at chance at every sample size examined in at least one clinically plausible world"); scenario IDs and the coverage range removed from the opening (C2); (iii) now ends on the §2.6 operability connection | S5/S6 are **Study 1** scenarios; the structural-blindness claim now rests on Study 2, so the citation pointed at the weaker evidence |
| 5 | Discussion ¶5, "**The $W_1$ distance addresses all three.**" | ✅ **APPLIED 2026-08-30 — paragraph review, Tak chose Option B**: full rewrite. Claim and scope arrive together (gap-by-gap closure with Study 2 evidence for SMD; controlled reading; **GUSTO agreement written in as the Discussion's sole carrier**; closes on the discussion-skeleton reason-to-use sentence) | ⚠ Was the strongest surviving overclaim; ¶5 was also the only possible home for the agreement (decision ④ keeps it out of the abstract) |
| 6 | Discussion ¶6 (dual-pathway strengths), "capturing **scale and skewness differences invisible to SMD**" | ✅ **APPLIED 2026-08-31 — paragraph review, Tak chose Option B**: full rewrite. Topic sentence no longer says the second feature "follows from" calibration (P2 mismatch); the second feature is now the separability of distributional assessment and calibration, evidence delegated to ¶5/§3, no moments named. (Original fix: re-evidence or trim; found by Louis 2026-08-30 during the ¶5 review) | Same pattern as row 4 one paragraph down: Study 1 detection language whose table evidence was deleted in the 2026-08-30 restructure; the claim now rests on Study 2. |
5. ✅ **DECIDED 2026-08-15 — no. The diagnostic is not promoted; ρ stays in §4.5 Result 5 with an explicit bound on what it is.** The question turned out not to be "add something new": ρ = W₁/(KS·σ_EM) is already implemented (`application_all_methods.R:178`), stored in the CSV, and applied to GUSTO in Result 5. Both candidate mechanisms fail, for **independent** reasons. **(a) ρ / the W₁–SMD rank correlation cannot work "in advance" — W₁ is in the numerator, so computing ρ presupposes having computed W₁.** The proposal fails on its own stated terms, which is not a scope judgement. **(b) The moment decomposition requires no W₁ and survives (a), but appears nowhere in the project except this decision line** — no implementation, no evaluation, no validation; proposing it would mean offering an unvalidated method as a contribution. And ρ's own thresholds (≲ 1 / ≳ 1.7) **retrodict the study they were fitted to**, with the rival mechanism tested and rejected — promotion would be a P5 violation (claim exceeding evidence). **ρ's honest function is explanatory and Result 5 already uses it correctly**; only the promotion is unsupported.
   / ✅ **2026-08-15 決定 — 提案しない。診断は格上げせず、ρ は §4.5 Result 5 に留め、それが何であるかの画定を明示する。** 問いは「新しいものを足すか」ではなかった: ρ = W₁/(KS·σ_EM) は既に実装済み（`application_all_methods.R:178`）、CSV 格納済み、Result 5 で GUSTO に適用済み。候補2つは**独立の理由で**落ちる。**(a) ρ ／ W₁–SMD 順位相関は「事前」に働けない — 分子が W₁ なので、ρ の算出は W₁ の算出を前提とする。** 提案が自身の条件で失敗しており、scope の判断ではない。**(b) モーメント分解は W₁ を要さず (a) を生き延びるが、この判断行以外にプロジェクト内のどこにも存在しない** — 実装なし・評価なし・検証なし。提案すれば未検証の手法を貢献として出すことになる。さらに ρ の閾値（≲ 1 / ≳ 1.7）は**適合させた当のスタディを retrodict する**もので、対抗機構は検証のうえ棄却されている — 格上げは P5 違反（主張が証拠を超える）。**ρ の誠実な機能は説明であり、Result 5 は既にそれを正しく使っている。** 支えを欠くのは格上げだけ。
