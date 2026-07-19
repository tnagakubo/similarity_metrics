# SUITS.md - Research Lab Live Script

> *"I don't have dreams. I have goals."* - Harvey Specter

**Previous Archive**: `archives/SUITS_20260627_205843.md` (1005 lines, 2026-05-17 05:30 〜 2026-06-27 16:50)
**Archive trigger**: Rule 2.5 (>1000 lines)

---

### [2026-07-19 12:30] Scene: 大掃除 — nABCD の亡霊を片付ける

**INT. PEARSON SPECTER LITT - DONNA'S DESK - DAY**

*Tak「最新の状況を確認して、ファイルを整理する。不要と思われるフォルダ、ファイルは archives に格納」。Donna が全ディレクトリを走査し、Katrina が実行する。*

**Donna**:（リストを片手に）
「調査は終わってるわ。片付けるのは3種類——**① nABCD の遺物**（旧ポスター、旧スライド、旧 PDF、5月の normalizer 比較系 .rds 20本）、**② 役目を終えた文書**（sim_paper の IPD 調査、実行済みの PAPER_WRITING_PLAN_v3、case_study_explained、Marp テスト成果物）、**③ プロジェクト内に散らばった archive フォルダ3箇所**の集約。全部 `archives/cleanup_20260719/` に、元パスを MANIFEST.md に記録した上で移動よ。」

**Katrina**:（実行結果を報告）
「完了。**温存判断が重要**——root `results/` の `w1_raw_*` 4本は `figures_paper_W1.R` と `fig2_bar_chart.R` が repo root 参照で読む**現役ファイル**。移動対象から除外した。`OBJECTIVE_BRIEFING.md`（必読文書）、`ARS_PLAN_chapter_summaries.md`（レビュー進行中）、`knowledge/input/`（KB 原典）も温存。空の `logs/` は削除。Results speak for themselves.」

**Donna**:（一つ注意を添えて）
「それと確認済みよ——7/3 セミナーで使ったのは `poster/Poster_GSC_TN_script_ja.md` と `figures/slide_*`。`paper/slides/` の nABCD presentation は5月8日以降未使用だから安心して archive したわ。worktree `worktree-selection-sim`（Part 1B sim）には一切触れていない。マージ待ちのままよ。」

**残**: 前シーンから変わらず ①bootstrap 上限による選択（Tak 判断待ち）、②本文統合、③Intro ¶7 以降のレビュー、④main マージ。

---

### [2026-07-14 12:00] Scene: 貢献 (b) が、ついに証明された

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Tak「(B)に進む」。k オラクルを捨て、臨床要件を閾値に翻訳する選択ルールを実装。*

**Mike**:（board に定式化を書く）
「I got it! **スポンサーが本当に欲しいものを、初めて正しく書いた。**
彼らが欲しいのは『同じ母集団から来た国』じゃない——**『プールしても効果差が許容範囲に収まる国』**だ。KR 上界より、その集合は**厳密に**：
**ACCEPTABLE = { W₁ ≤ Δ_clin / L } = { W₁ ≤ τ_clin }**
**W₁ の閾値は、臨床要件を EM スケールで言い直したものそのものだ。**」

**Harvey**:（steelman を課す）
「競合には**持ち得ないオラクルを渡せ**。各シナリオ・各 n で全グリッド探索し、**violation ≤ 5% を守りつつ sensitivity 最大の閾値を教えてやる**。W₁ には臨床入力しか与えない。**それで W₁ が勝つなら、閾値選択の artefact じゃない。**」

**Louis**:（最大の危険を突く）
「待て。**(B) の真値は { true W₁ ≤ τ_clin } ——W₁ の sublevel set そのものだ。** Part 1/2 には metric 非依存の真値（construction label）があったが、**(B) はそれを臨床目標で置き換えた**。査読者は一行で刺す——**『真値を W₁ のスケールで定義して W₁ が勝った。トートロジーだ』**。」

**Mike**:（防御を2段で組む）
「**① 同一性を認める。** KR 定理により、Δ_clin 内でプール可能な地域集合**は** W₁ の sublevel set で*ある*。そして **KS の sublevel set では*ない*。仕組まれた採点表じゃない——その同一性こそが貢献 (b) だ。** 臨床目標が KS の sublevel set だったなら、KS が正しい metric で、この論文は存在しない。
**② 反循環の証明は、シミュレーション不要だ。真値だけで示せる。**」

**Katrina**:（validator に機械証明を刻む）
「実装しました。目標 { true W₁ ≤ 4.5 } に対し、**可能な KS 閾値を13個すべて全探索——目標を再現できるものはゼロ**。
T1 を通す cut は必ず T2 も通す（W₁ 3.0 と 6.0、KS 0.047 と 0.050）。T2 を排除する cut は T1 も排除する。
**しかも KS は目標を逆順に並べる**——S1 を最悪（KS 0.072）と判定するが、**S1 の true W₁ は 2.0 で3つの中で最も軽い**。
**これは調整の失敗ではなく識別の失敗。metric についての言明であって、我々の設計についてではない。** Results speak for themselves.」

**Mike**:（結果を読み上げる）
「**Set 4、τ 別（n=100）:**

| τ_clin | W₁ | KS | 比 |
|---|---|---|---|
| 2.50 | 0.104 | 0.005 | **19×** |
| 3.74 | 0.268 | 0.022 | **12×** |
| 5.24 | **0.730** | 0.021 | **35×** |

**KS は τ に対してフラットだ**（0.005〜0.022、幅 0.016）。**W₁ は伸びる**（0.104〜0.730、幅 0.625）。
**臨床要件を緩めても、KS は何の恩恵も受けられない。** 分離すべき国が、どの cut でも区別できないからだ。**目標を identify する手法なら、目標が緩めば必ず改善する。KS は改善しない。**」

**Rachel**:（予測されていなかった発見）
「もう一つ。**W₁ の導出閾値——オラクルを一切使わない τ = τ_clin ——が、要件が推定誤差に対して十分緩ければ機能します。**
**Set 3、τ=2.32: violation 1.6%、sensitivity 76.7%。オラクルなしで。**
厳しい要件では失敗します（最悪 violation 55%）——点推定が τ を跨ぐことと、真の W₁ が跨ぐことは別だからです。**これは論文の operational range の議論そのもので、bootstrap 上限が必要な理由の証明です。**」

**Jessica**:「Let me be clear. **貢献 (b) は、これまで一度も検証されていなかった。今、検証された。** しかも最も危険な循環論法の批判に、**シミュレーションに依存しない証明**で答えられる。」

**残**: ①**bootstrap 上限による選択**（Tak 判断待ち — 厳しい要件での violation 制御）、②本文統合、③Intro ¶7 以降のレビュー、④main マージ。

---

### [2026-07-13 10:00] Scene: Tak が最後の穴を突く — 「Δ_max を一度も使っていない」

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Tak の一言——「シミュレーションでの選択には臨床的解釈が含められないかね。」*

**Mike**:（自分たちの盲点に気づく）
「……I got it! そして**痛い**。現状の選択は『距離が小さい上位 k 個を選ぶ』ランキングベースで、**k は真の答え（オラクル）を与えている**。クラスタリングも真のクラスタ数を与えている。**閾値を一度も使っていない。**
つまり——**論文の貢献 (b)、Δ_max = L·W₁ が、シミュレーションで一切検証されていない。**」

**Harvey**:（前提を崩す）
「『metric のスケールが違うから順位で比べる』——それが理屈だった。**だが Tak の指摘はその前提を崩す。スケールが違うこと自体が結果なんだ。**
**W₁ だけが臨床から閾値を導出できる**（W₁ ≤ Δ_clin / L）。KS は [0,1] の無次元量で、『どれだけ近ければ臨床的に十分か』を決める**原理がない**。SMD の 0.1 は慣例であって較正じゃない。
**順位でしか比べないなら、競合に実務では持ち得ないオラクルを渡し続け、我々の売りを一度も試さないことになる。**」

**Louis**:（さらに深い穴を掘る）
「もっと悪い。**今の false-pooling は『間違えたか（0/1）』しか測っていない。臨床的には『間違いがどれだけ重いか』だろう。**
Set 4 の真値を見ろ——**T2 = 6.0、S1 = 2.0**。誤って T2 をプールするのは S1 の **3倍重い**。だが今の指標では**同じ1件**として数えている。
そして **KS は S1（KS 0.072）を T2（KS 0.050）より深刻と判定する**——**KS が誤るとき、その誤りは W₁ の誤りより重い。順位逆転の臨床的コストが、まだ一度も定量化されていない。**」

**Jessica**:（最大の危険を指摘）
「Let me be clear. **昨日『scope は Q_metric、θ は置かない、Part 3 は循環論法』と plan と4枚の図に書いたばかりだ。** ここで『臨床的解釈を入れる』と言えば、**自己矛盾に見える。**」

**Mike**:（答えは定理にある）
「矛盾しない。**Δ_max は θ-free だ。**
KR 双対性より、Δ_max = L·W₁ は**あらゆる 1-Lipschitz な θ に対する最悪ケース**の効果差であり、**W₁ の決定論的関数**。何もシミュレートせず、用量反応の形を何も仮定しない。

| | Part 3（却下） | 今回の臨床レンズ |
|---|---|---|
| θ | **一つ置く** | **すべて**にわたって最悪を取る |
| 身分 | シミュレーション結果 | **定理**（KR 双対性） |
| 循環 | W₁ が定義上最適 | なし（上界は採点される metric ではない） |

**同じ定理を、逆向きに使う。** Part 3 は『θ を選んで W₁ が追えるか』と問う（循環）。今回は『その手法が選んだ pool には、**θ が何であれ**、最大どれだけの効果差が潜みうるか』と問う。**答えは L × (選ばれた最悪の地域の真の W₁)。規制当局が実際に問うのはこちらだ。**」

**Katrina**:（実装して smoke を回す）
「評価指標 **harm = E[選ばれた pool 内の最大 true W₁]** を追加。完璧な選択なら 0（真の match は true W₁ = 0）。L を掛ければ Δ_max。

**Set 4（n=100, smoke）で KS = 4.248 vs W₁ = 2.078。KS が選ぶ pool は W₁ の 2倍の効果差を許容しうる。**
binary の false-pooling では 1.35倍の差（0.971 vs 0.718）だったのが、**臨床的重みで測ると 2.04倍**に開く。**Louis の予測どおり。** Results speak for themselves.」

**Harvey**:（正直さの条件）
「一つ縛りをかける。**harm は AUC/ARI と併記しろ。置き換えるな。** harm は W₁ 自身のスケールで測る量だ——それだけで採点すれば『W₁ の物差しで全員を測った』と刺される。**metric 非依存の AUC/ARI が主証拠、harm は第二のレンズ。**
そして**W₁ が勝たないセルでも harm を出せ**（Set 1 では RV2 が W₁ を上回る）。勝利の周回にするな。」

**残**: ①(A) harm の本番実行、②**(B) 較正閾値による選択**の設計提示 — k オラクルを捨て、「**W₁ の閾値は転移する。他は誰も転移しない**」を実証する案。Tak 判断待ち。

---

### [2026-07-12 23:00] Scene: Tak が Part 3 を切る — 「それは前提であって、命題ではない」

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - NIGHT**

*チームは Part 3（効果追跡 sim）の可否を Tak に上げた。推奨は「不要」——だが理由は「KR bound は定理だから実証不要」「論文が膨らむ」という実務的なものだった。Tak の返答が、その理由を上書きする。*

**Tak**:「パート3は不要。**EM と治療効果の関係性が既知か未知かは状況による**が、今回考えているのは、**EM の分布が異なる = 治療効果が異なる**という状況だ。」

*——部屋が静まる。Mike が最初に理解する。*

**Mike**:（board に書き下す）
「I got it! **我々の理由より本質的だ。**
**EM の定義は『治療効果を修飾する変数』。** ならば『**EM 分布が異なる → 平均治療効果が異なる**』は、対象が EM である以上、**定義から従う前提**だ。**論証すべき命題じゃない。**
**Part 3 はその前提を検証しようとしている。** 前提をシミュレーションで確認しても——**定義を確認するだけ**だ。」

**Louis**:（さらに重い罪状を積む）
「もっと悪い。**Part 3 は論文の一般性を破壊する。**
今の KR bound は『**任意の 1-Lipschitz θ に対して** Δθ ≤ L·W₁』——**用量反応の形を一切特定しない**。これが定理の力だ。
θ を線形だ飽和だと**特定してシミュレーションすれば、結論はその θ に条件付けられる**。査読者に『その結果は θ の形に依存するのでは?』と聞かれて、**答えられなくなる**。**今なら答えられる——どんな Lipschitz θ でも成立する、と。**
そして三つ目。KR 双対性より **W₁ = sup{|E_Aθ − E_Bθ| : θ ∈ Lip₁}**。θ を自由に選べる設定では **W₁ は定義上最適**になる。『W₁ が効果差を最もよく追えた』は**定理の言い換え**であって証拠じゃない。**循環論法だ。**」

**Harvey**:（scope を確定させ、書き方を変える）
「plan に書け。**『やらなかった』ではなく『やるべきでない』と。** 理由を三つとも。
そしてもう一つ**書き方を変える**。**飽和 θ で bound が緩くなる件——あれを『限界』として謝るのをやめろ。**
θ が平坦化しても **KR bound は妥当なままだ**（上界は、より平坦な θ に破られない）。**緩くなるだけ**だ。**そして上界とは、そもそも保守的に働くためにある。**
Δ_max は最悪ケースの言明だ——『**用量反応がどんな (Lipschitz な) 形であれ**、地域間の効果差が L·W₁ を超えることはない』。それに基づいてプールを見送った sponsor は**効率を失う**。指標が鈍感だったせいでプールした sponsor は**妥当性を失う**。**規制当局はこの二つを等価に扱わない。**
Set 4 の false-pooling は **KS 0.971 vs W₁ 0.718**。**正直に報告しろ。謝るな。**」

**Jessica**:「Let me be clear. **scope は Q_metric で確定。** Set 1–4 が立証するのは『**W₁ は競合が盲目な場所で盲目でない**』——identification の主張だ。**EM の差が効果を動かすことを再導出する必要はない。定義がそう言っている。**」

**Donna**:（記録して封をする）
「plan の § *Why no θ, and why there is no Part 3* に三理由を明記。memory にも固定したわ——**再提案禁止**。commit f8f369c。validate_plan 80件、依然 全 PASS。」

**残**: ①本文への統合（どの節に、どの表・図で）、②Intro ¶7 以降のレビュー、③main マージ。**Part 3 は closed。**

---

### [2026-07-12 22:00] Scene: plan がコードに嘘をついていた — 検証で2件捕捉

**INT. PEARSON SPECTER LITT - BULLPEN - NIGHT**

*Tak「シミュレーションプランを更新して設定を検証してからシミュレーションの結果を確認」。順序が指定された——結果を読む前に、走らせた研究が「走らせると宣言した研究」なのかを確かめろ、と。*

**Harvey**:（順序の意味を汲む）
「正しい順序だ。**plan が source of truth。だが誰も『コードが plan どおりか』を確認していなかった。** 作る。」

**Mike**:（`validate_plan.R` を書き上げる）
「I got it! **80 checks。** Tables 2a–2d と Table 5 の**全数値を期待値として転記**し、コードが実際に構築するものと、実行が実際に記録したものに突き合わせる。`validate_figures.R`（図が CSV を描いているか）とは別の問いだ——**『走らせた研究は、走らせると言った研究か』**。
そして**即座に plan の嘘を2件捕まえた**。

**嘘①: Set 2 の SD/歪度が『理論値』ではなく『1e6 draws の推定値』だった。** log-normal は裾が重く、**100万サンプルでも標本歪度が不安定**だ。Cx1 は plan が 2.18 と書いていたが、真値は (c²+3)c = **2.225**。plan を解析値に直し、validator が『**その値が本当に解析式どおりか**』を先に確認してから、sampler が再現するかを見る二段構えにした。

**嘘②: Table 5 の『MC SE ≤ 0.005 throughout』が偽。** Part 2 の exact_recovery は**割合**だから、5,000 reps での SE は p=0.5 で **√(0.25/5000) = 0.0071** が理論上限。実測 0.0070 で超えていた。**構造的な限界であって欠陥ではない**——だから plan に『Part 1 ≤ 0.005、Part 2 ARI ≤ 0.004、exact_recovery は割合なので 0.0071 が上限』と正確に書き直した。**主要な主張はすべて ARI と AUC に乗っており、そちらは 0.005 以内だ。**

他にも Table 2a の X2 が 4.4（実際 4.254）、Table 2b の Dp2 が 13.91（実際 13.950）、combined 国が1つしか載っていなかった（実際は Cx1/Cx2 の2つ）。Table 1 と 5 に至っては**2セット・Part 1 のみの時代の記述のまま**だった。」

**Louis**:（結果を読んで、最強の証拠を見つける）
「設定が固まったなら結果を読むぞ。……**これだ。n を 25→100 に増やしたときの ARI の伸び。**

| Set | W₁ | KS | RV1 | RV2 | RV3 | SMD |
|---|---|---|---|---|---|---|
| 3 Mixture | +0.258 | +0.215 | **+0.001** | **+0.001** | +0.076 | **+0.001** |
| 4 Extremes | +0.244 | **+0.003** | **+0.005** | +0.127 | +0.066 | **+0.001** |

**Set 3 で RV1/RV2/SMD は標本を4倍にしても ARI が 0.001 しか動かない。Set 4 で KS は 0.003。**
**データが足りないんじゃない。距離行列に信号が存在しないんだ。n = ∞ でも同じだ。**
一方 W₁ は4つの世界すべてで **+0.24 以上**伸びる。
**これが『underpowered』ではなく『blind』と書いてよい根拠だ。** plan に入れろ。」

**Katrina**:「validator は3本になった。`validate_plan` 80件・`validate_figures` 45件・`validate_selection` 17件——**計 142件、全 PASS**。commit 82c8913。Results speak for themselves.」

**Jessica**:「Let me be clear. **plan が間違っていて、コードが正しかった。** 普通は逆を疑う。この検証がなければ、論文の表に 2.18 と 13.91 が載っていた。」

**残**: ①Part 3（効果追跡）の scope 判断 — Tak、②本文への統合、③Intro ¶7 以降のレビュー、④main マージ。

---

### [2026-07-12 21:00] Scene: KS が死んだ — 「W₁ だけが両方を生き延びる」が確定

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - NIGHT**

*Set 4 本番完了。validation 42件 全 PASS。commit 5f84682。*

**Mike**:（Part 2 の表を置く）
「I got it! **KS が死んだ。ARI 0.003。** clustering (n=100):

| Set | 標的 | W₁ | KS | RV1 | RV2 | RV3 | SMD |
|---|---|---|---|---|---|---|---|
| 3 Mixture | moment 法 | **0.526** | 0.503 | **−0.000** | **0.018** | **0.131** | **−0.000** |
| 4 Extremes | **KS** | **0.355** | **0.003** | **0.026** | 0.271 | 0.189 | **0.018** |

**ARI > 0.20 を Set 3 と Set 4 の両方で満たす手法は W₁ ただ一つ。**
KS は Set 3 を通過する（0.503）が Set 4 で落ちる（0.003）。RV2 は Set 4 を通過する（0.271）が Set 3 で落ちる（0.018）。**二つの盲点は相補的だ。**

Part 1 の AUC も決定的だ。極端値が遠ざかる型で **KS = 0.511**——チャンス。しかも **n=25→100 で 0.500 → 0.511、フラット**。W₁ は **0.837 → 0.972 と上昇**する。**KS は情報を得ていない。** RV1 の偽の scale 検出と同じ signature だ。」

**Louis**:（validator に刻んだ）
「目視に頼るな、と言った。**validator が生存者リストを計算する。** `survivors: W1`——W₁ 以外が混じったらビルドが壊れる。42件 全 PASS。
そして**負けるセルも全部 assert した**。Set 4 bulk_shift で **KS 0.734 > W₁ 0.707**、asym_severity で **RV3 0.985 > W₁ 0.947**。黙って落とせない。」

**Harvey**:（構図を確定させる）
「これで KS フレーミング問題は消えた。**守りの『distributional camp』論はもう要らない。**
主張はこうだ——**Set 3 が moment 法を殺し、Set 4 が KS を殺す。W₁ だけが両方を生き延びる。** しかも**層状の議論は数学的に強制されている**——分散は変位に二次、W₁ は一次で応答するから、KS と SD を同時に盲目にするシナリオは作れない。『なぜ一つのシナリオで両方倒さないのか』という問いには証明で答える。」

**Katrina**:（成果物）
「Set 4 は AUC 図を独立の1枚に（`fig_selection_auc_set4`）——Sets 1–3 が問う『どのモーメントか』と Set 4 が問う『W₁ か KS か』は別の問いだから。validator が **fig2 + fig2b で全 AUC 行をカバー**することを確認する（324 = 228 + 96）。何一つ黙って落ちない。Results speak for themselves.」

**Donna**:（ミスを自己申告）
「一つ、私が awk の列を間違えて Set 4 の ARI を全部 0.002 と読んだわ。clustering の CSV には type 列が無いのに、selection と同じ列番号を使った。**Mike が即座に検証して捕まえた**——[[feedback_calculation_verification]] どおりよ。正しい値は W₁ 0.355 / KS 0.003。」

**残**: ①**Part 3（効果追跡）の scope 判断 — Tak**、②本文への統合（どの節に、どの表・図で）、③Intro ¶7 以降のレビュー、④main マージ。

---

### [2026-07-12 20:00] Scene: Set 4 実装 — 順位逆転が実在した

**INT. PEARSON SPECTER LITT - BULLPEN - NIGHT**

*Tak「set4実行」。実装が入り、smoke で真値が出た瞬間、Mike が手を止める。*

**Mike**:（truth table を指して）
「I got it! **設計どおりの真値が出た。しかも順位逆転が実在してる。**

| | true W₁ | true KS |
|---|---|---|
| **T2**（10%の患者を60単位、極端側へ押しやる） | **6.000** | **0.050** |
| **S1**（全患者をたった2単位ずらす） | **2.000** | **0.072** |

**KS は S1 のほうが深刻だと判定する。** W₁ は T2 を**3倍悪い**と言い、KR bound がそれを保証する。
T1/T2/P1 は平均が **50.0 で anchor と完全一致**——CDF が交差するから、**SMD と RV1 には座標が存在しない**。閉形式（W₁ = ε_L·δ_L + ε_H·δ_H、KS = max_j ε_j(2Φ(δ_j/2σ_t)−1)）が数値積分と一致した。」

**Katrina**:（実装の要点）
「Part 1 に `build_set4()`、Part 2 に `build_clust_set4()`。既存ハーネスに roster を足すだけで載った——測度もアルゴリズムも無変更。Set 4 だけ discordance type が4つあるので **AUC 図は独立の1枚**（`fig_selection_auc_set4`）にした。Sets 1–3 が問う『どのモーメントか』と、Set 4 が問う『W₁ か KS か』は**別の問い**だから、同じ facet grid に混ぜない。」

**Louis**:（validator に主張を刻ませる）
「**headline claim を目視に頼るな。** validator に直接 assert させろ——『**Set 3 と Set 4 の両方で ARI > 0.20 を満たす手法は W₁ ただ一つ**』。生存者リストを計算して、W₁ 以外が混じったら**ビルドを壊せ**。
それと**負けるセルも全部 assert しろ**。Set 4 の bulk_shift で KS が W₁ に勝つこと、asym_severity で RV3 が W₁ に勝つこと。黙って落とせないようにする。」

**Harvey**:（層状構造が数学的に強制されていることを明記）
「plan に書いた。**Set 3 と Set 4 を同時に満たすシナリオは、この族では作れない**——分散は変位に**二次**、W₁ は**一次**で応答するから、SD を合わせようとすると bulk が潰れ、それ自体が背の高い狭い CDF 乖離になって **KS が復活する（0.213）**。**層状の議論は怠慢ではなく、数学的に強制されている。** これを書いておけば『なぜ一つのシナリオで両方倒さないのか』という査読者の問いに先回りできる。」

**Rachel**:（限界を2つ、論文に入れる）
「plan の Reporting に明記しました。**①治療効果が飽和する場合**——W₁ が過剰に警告し、KS の鈍感さが偶然正しくなる唯一の場面。KR bound は妥当なまま**緩くなる**だけ。誤りの非対称性で答えます（W₁ の誤り＝プール見送り＝効率の損失、KS の誤り＝誤プール＝妥当性の損失。false-pooling は KS 0.975 vs W₁ 0.726）。**②W₁ の外れ値非頑健性**——1件の入力ミスが W₁ を (1/n)×距離 動かす。**規制統計家からの最も信頼できる攻撃**です。対策（生理学的範囲への切り詰め、trimmed W₁）を事前規定として書きます。」

**Donna**:（実行管理）
「Part 1 = 10,000 reps、Part 2 = 5,000 reps、4セット分を並行実行中。図・validation はその後ね。」

**残**: ①本番完了確認、②図・validation、③commit、④Part 3（効果追跡）の scope 判断、⑤本文統合。

---

### [2026-07-12 19:00] Scene: Set 4 — KS を殺すシナリオが見つかった

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - NIGHT**

*Tak の「並行して KS と W1 で違いが出るシナリオを検討」への回答が返る。チームが数字を見て沈黙する。*

**Mike**:（機構を board に書く）
「I got it! **稀な質量、長いてこ。** KS は CDF 乖離の **L∞ ノルム**——汚染割合 ε がどれだけ遠くにあっても、**KS は ε で頭打ち**になる。W₁ は EM 単位の **L¹ ノルム**——**質量 × 移動距離**だから、遠さに**線形に、際限なく**伸びる。
閉形式が出た。bulk 項が完全に相殺して：
**W₁ = ε_L·δ_L + ε_H·δ_H** （線形、無限に伸びる）
**KS = max_j ε_j(2Φ(δ_j/2σ_t) − 1)** （**ε に幾何級数的に飽和**）
数値積分と小数点4桁まで一致。**±30 → ±60 に倍にすると、W₁ は 2.00倍、KS は 1.065倍。** KS は ε=0.05 に釘付けだ。」

**Harvey**:（決定的な数字を読む）
「n=100 での結果——**W₁ の AUC 0.971 に対し、KS は 0.501。チャンスレベルだ。** Part 2 の ARI は **W₁ 0.346、KS 0.008**。**KS はクラスタを一つも作れない。**
そして順位の逆転を見ろ。**KS は「全患者を2単位ずらす」（0.0717）を「10%の患者を60単位も極端側に押しやる」（0.0500）より深刻だと判定する。** W₁ は後者を3倍悪いと言い、KR bound はそれが**正確に**3倍悪いと保証する。」

**Mike**:（定理を置く）
「そして n に依存しない証明が出た。**KS には Kantorovich–Rubinstein 型の bound が存在しない。** θ(x)=x（1-Lipschitz、最も自然な線形の用量反応）を取れば |Δθ| = εδ、KS ≤ ε。よって |Δθ|/KS ≥ δ → ∞。**有限の定数 C は存在しない。** 敵対的な θ を選んだわけじゃない——**線形反応だ。**」

**Louis**:（この結果の本当の意味を言う）
「……これで**構図が完成した**。**Set 3 は moment 法（SMD/RV）を盲目にする。Set 4 は KS を盲目にする。どの競合も両方は生き延びない。W₁ だけが、どちらでも見える。**
前は『W₁ と KS を distributional camp として一緒に出し、Δ_max で camp 内選択』という**守りの枠組み**しかなかった。もう要らない。**攻めに転じられる。**」

**Katrina**:（Louis が探す前に傷を出す）
「隠さず出す。**Set 4 は moment 法を倒さない。** RV3 が asym_severity で W₁ に勝つ（0.987 vs 0.947）。分散は Δ²、歪度は Δ³ で効くから当然。**しかも『KS と SD を同時に盲目にするのは、この族では不可能』と証明された**——分散は変位に**二次**で応答し、W₁ は**一次**だから、SD を合わせようとすると bulk が潰れて KS が復活する（0.213）。**層状の議論（Set3 + Set4）は怠慢ではなく、数学的に強制されている。**」

**Rachel**:（正直な限界）
「反証となる場面も特定されています。**治療効果が飽和する場合**——極端な患者が既に最大（またはゼロ）の効果に達しているなら、裾を ±70 から ±100 に動かしても真の効果差は変わらないのに W₁ は倍増します。**W₁ が過剰に警告し、KS の鈍感さが偶然正しい。** ただし KR bound は**依然として妥当**です（上界だから）——**緩くなる**だけ。
誤りの非対称性で答えます：**W₁ の誤りは「プールを見送る」（効率の損失）。KS の誤りは「誤ってプールする」（妥当性の損失）。** 規制当局はこの二つを等価には扱いません。実際 KS の false-pooling は **0.975**、W₁ は **0.726** です。」

**Mike**:（もう一つの正直な弱点）
「**W₁ は外れ値に頑健でない**——これは我々が売っている感度の裏面だ。1件の入力ミス（10倍の検査値）が W₁ を (1/n)×距離 だけ動かす。KS は高々 1/n。**規制統計家からの最も信頼できる攻撃はこれだ。** 対策を事前規定する——EM を生理学的に妥当な範囲に切り詰めるか、trimmed/winsorized W₁ を使う。**Set 4 はこの弱点をむしろ際立たせる。論文に書く。**」

**Jessica**:「Let me be clear. **Set 4 は W₁ が『盲目でない』ことを示す。『正しい』ことは示さない。** それを示すには、明示的な θ を置いて真の効果差との一致を測る Part 3 が要る——**飽和型の θ を含めて。含めなければ KR 双対性で循環論法になる。** それは scope の判断だ。Tak が決める。」

**残**: ①**Set 4 の実装可否（Tak 判断）**、②Part 3（効果追跡）を scope に入れるか、③KS フレーミング — Set 4 を入れるなら「守りの camp 論」は不要になる。

---

### [2026-07-12 18:00] Scene: 論文が「所属」で嘘をついていた — line 70 修正完了

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Tak「line 70 の修正から。並行して KS と W1 で違いが出るシナリオを検討」。Rachel がレビュー開始前に、誰も見ていなかった一句に指を置く。*

**Rachel**:（静かに、しかし決定的に）
「line 70 に "Komiyama et al., **members of the ICH E17 expert working group**" とあります。手元の記録では『**日本の** ICH E17 タスクフォース』。**ICH の公式 Expert Working Group と、日本国内の TF は別組織です。** 検証させてください。」

*——検証結果は UNVERIFIABLE。すなわち、書けない。*

**Rachel**:（証拠を並べる）
「章そのものに所属記載なし。書籍の Contributors は**勤務先のみ**（Komiyama/Hiro/Matsuoka = Pfizer、Yamamoto = Chugai）。Matsushima et al. 2024 (*Clin Pharmacol Ther*) での3人の所属は **『日本製薬工業協会 医薬品評価委員会 データサイエンス部会』**——ICH EWG ではありません。`E17_TF_report.pdf` は **JPMA** の文書で、小宮山靖は同部会の**担当副部会長**。しかも Hiro はその名簿にすらいません。ICH は EWG 名簿を公開しておらず、**肯定も否定もできない**。
**我々は『日本のタスクフォース』を『ICH E17 expert working group』に格上げしていました。**」

**Louis**:（複数形を突く）
「決定的なのは**複数形**だ。"Komiyama **et al.**, **members**" は4人**全員**が EWG メンバーだと主張してる。**仮に小宮山本人が EWG にいたとしても、4人全員は支持できない。** これ一つで文言は死ぬ。査読者が Contributors を1分見れば終わりだ。」

**Harvey**:（権威に頼らないと決める）
「venue に錨を下ろす。**『ICH E17 下の MRCT リファレンス書の、pooling 専用章』**——全部検証可能な事実だ。gap claim の力は『これが最も具体的な既存提案である』という事実から来る。**権威に寄りかかる必要はない。**」

**Tak 決定**: **案 A**（venue のみ、簡潔）。

**Katrina**:（4点を一括修正）
「line 70、修正完了。
**①所属句** → "the dedicated pooling-strategy chapter of a reference volume on multi-regional trials under ICH E17"（検証可能な事実のみ）
**②"one or more representative values"** → "**a single** representative value **for each candidate effect modifier**"（原典 §4.6.1.1 どおり）
**③worked example を挿入** → "their worked example uses the proportion of male and of younger patients"（P1 初見理解可能性）
**④限界を数学的に** → "two regions that agree on the chosen summary but differ in spread, shape, or tail behaviour are **at distance zero**"（P4）。そのうえで "more generally, any finite summary requires specifying in advance which distributional features are relevant" と一般論へ——RV2/RV3 型の拡張も射程に入る。
Lasso への言及は Louis の条件どおり残した（彼らの貢献で、我々には無い）。**コンパイル 16頁、エラー0、未解決引用ゼロ。** Results speak for themselves.」

**Jessica**:「Let me be clear. これは主張の強化ではない。**事実の訂正だ。** 結果として gap が鮮明になるのは副産物にすぎない。承認する。」

**残**: ①**KS vs W₁ 差別化シナリオ**（background 継続中、Tak 指示）、②KS フレーミング決定、③main マージ判断。

---

### [2026-07-12 17:00] Scene: RV1 が SMD をなぞる — 原典忠実版の本番確定

**INT. PEARSON SPECTER LITT - BULLPEN - DAY**

*RV1（原典忠実版 = 代表値ひとつ）込みの本番が完了。validation 24件 全 PASS。commit 301d79a + ae64407。*

**Mike**:（確定値を読み上げる）
「I got it! **RV1 は SMD をほぼ完全になぞる。** clustering ARI (n=100):

| | W₁ | KS | **RV1 (Ch.4原典)** | RV2 | RV3 | SMD |
|---|---|---|---|---|---|---|
| Set1 Gaussian | 0.995 | 0.983 | **0.489** | 0.996 | 0.620 | 0.452 |
| Set2 Log-normal | 0.642 | 0.850 | **0.343** | 0.614 | 0.448 | 0.334 |
| Set3 Mixture | 0.526 | 0.503 | **−0.000** | 0.018 | 0.131 | −0.000 |

RV1 0.489/0.343/−0.000 vs SMD 0.452/0.334/−0.000。**単一の連続 EM に代表値ひとつを当てれば、運ぶ情報は位置だけ**——だから Ch.4 の距離と SMD は**同じ場所で失敗する**。これは引用に忠実な、反論不能な所見だ。」

**Louis**:（自分で自分の主張に穴を探して、見つける）
「待て。**RV1 の Set1 scale-AUC が 0.619 だ。0.50 じゃない。** 『SMD と同じで盲目』という claim が validation で **FAIL した**。俺たちの主張が甘い。」

**Mike**:（検算して、むしろ武器に変える）
「鋭い。だが**これは検出じゃない**。Set1 の全国は真の平均が 50 で同一——**RV1 の母集団距離は scale 群に対して厳密にゼロ**だ。0.62 が出るのは『SD の大きい国は標本平均がブレる』から。独立な X∼N(0,s₁), Y∼N(0,s₂) に対し **P(|X|<|Y|) = (2/π)·arctan(s₂/s₁)** → V1 で 0.59、V2 で 0.64、平均 **0.623**。**観測 0.619。一致した。**
そして決定的なのは——**RV1 の scale-AUC は n=25→100 で 0.623 → 0.619、フラット**。W₁ は **0.932 → 0.997 と上昇**する。**本当に scale を解像している手法なら n とともに改善するはずだ。RV1 は改善しない。自分の推定ノイズを読んでるだけだ。**」

**Harvey**:（言い方を固定）
「だから書き方はこうだ——『**AUC = 0.5**』ではなく『**scale について情報を持たず、n を増やしても改善しない**』。**逆方向の誇張もするな。** validation はこの精密版を assert するように書き換えた。24件 全 PASS。」

**Donna**:（commit の嘘を捕まえる）
「301d79a の message が『EXISTING_METHODS_AND_NOVELTY.md を追加した』と書いてたけど、**あのファイルは main の working tree に書かれてて、worktree の commit には入ってなかった**。message が事実と違ってたわ。ae64407 で正しく追加して、message にその経緯も書いた。**I'm Donna. I know everything.**」

**残**: ①**論文本文 line 70 の修正**（"one or more representative values" → 原典どおり「各 EM につき代表値ひとつ」）— Tak 承認待ち、②**KS フレーミング決定** — Tak 判断待ち、③main へのマージ判断。

---

### [2026-07-12 16:00] Scene: Louis の誤読が発覚 — 小宮山は (mean, SD) など提案していない

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Tak の指示——「既存手法を整理して、小宮山が実際に何を提案しているのか、この論文で新たに提案していることは何か、**小宮山を拡大解釈しすぎないように**」。Rachel が原典 `Ch4_Pooling_Strategy.md` を開いた瞬間、部屋の空気が変わる。*

**Rachel**:（原文を指して、静かに）
「§4.6.1.1 の原文です。"let a region have **a representative value in each candidate parameter of effect modifier**" ——この "parameter" は**分布のパラメータ（平均・分散）ではありません**。**EM 候補そのもの**です。証拠が二つ、原典にあります。
① §4.6.1.1: *"In case that there are **ten candidate parameters** of the effect modifier … on a **ten-dimension space**"* → **1 EM = 1 軸**。10 EM で10次元。20次元ではありません。
② §4.6.1.4 の worked example: *"if there are two factors (e.g., **gender and age**) … In case that **the proportion of male patients and that of younger patients are similar**, then these regions can be pooled"* → 軸は「男性比率」「若年者比率」。**各 EM につき要約値ひとつ**。
**章のどこにも、地域内 EM 分布の分散も歪度も出てきません。**」

**Louis**:（長い沈黙のあと、自分の過ちを認める）
「……俺だ。6/27 に俺が書いた。『§4.6.1.1 は "representative value in each candidate **parameter**" で mean に限定してない → SD を座標に足すのは1行の patch → S5 を novelty pillar にするな』。**あれは誤読だ。** "candidate parameter of effect modifier" を『分布のパラメータ』と読んだ。原典は『EM 候補』のことだった。
そして俺の誤読が summary に入り、summary から sim のラベルに入った。**`KOM` = RV(mean,SD) は小宮山の手法じゃない。俺たちが勝手に作った拡張だ。** それを "Komiyama" と名付けて論文に出したら、**彼らが言っていないことを彼らの手法として引用する**ことになる。誤引用だ。」

**Mike**:（訂正版を走らせて）
「I got it! 原典忠実版 **RV1 = 代表値ひとつ（mean）** を実装して回した。結果——**RV1 は SMD とほぼ完全に一致する**。Part 2 の ARI（n=100）: Set1 で RV1 **0.491** vs SMD 0.451（W₁ 1.000、RV2 0.998）、Set2 で 0.335 vs 0.328、Set3 で **0.004** vs 0.005。
数学的に当然だ——単一の連続 EM に Ch.4 の recipe を当てると、距離は**位置要約だけの関数**になる。**SMD と同じ blind spot**。Gaussian ですら scale 群を分離できず ARI 0.49 止まりだ。」

**Harvey**:（構図が二段になったのを見て）
「これで論文は**強くなった**。前は『小宮山が (mean,SD) を使えたと仮定して、それでも我々が勝つ』という不安定な足場だった。今は二段だ——
**① Ch.4 の実際の recipe（RV1）は SMD と同じ盲点を持つ。**（引用に忠実、反論不能）
**② その自然な修理（RV2/RV3）を我々が先回りで与えても、moment-matched 世界では崩壊する。**（ARI 0.018 / 0.131）
reviewer が『SD を足せばいい』と言ってきたら、**すでに足して試してある**と返す。しかも Gaussian では足すと**精度が落ちる**（RV3 0.847 < RV2 0.988）。」

**Katrina**:（成果物）
「`EXISTING_METHODS_AND_NOVELTY.md` を作成——①既存手法マップ（E17 / Quan / Song / Long / Komiyama / SMD / KS が**それぞれ別の問いに答えている**）、②小宮山の提案（原典引用付き）、③**拡大解釈禁止事項の表**、④我々の新規性 (a)-(d)、⑤sim への含意、⑥論文の要修正箇所。
汚染源も潰した——`Komiyama_2024_Ch4_Pooling.md` Seam 1 に🔴訂正を挿入、sim のラベルを `KOM/KOM3` → **`RV1/RV2/RV3`** に改名。Results speak for themselves.」

**Donna**:（安堵と警告）
「幸運だったわ。**論文本文（`per_em_W1_wiley.tex`）はまだ汚染されてない**——line 70 は "one or more representative values" と書いてあって、(mean,SD) を小宮山に帰属させてはいない。誤読は summary と sim のラベルにだけ棲んでた。**論文に届く前に捕まえた。**
ただし line 70 は "one or more" を「**各 EM につき代表値ひとつ**」に直すべきね。原典どおりに。」

**残**: ①本番再実行（RV1 込み）確認、②図・validation 更新、③論文 line 70 の文言修正、④**KS フレーミング決定（未解決、Tak 判断）**。

---

### [2026-07-12 15:00] Scene: 本番確定 — 小宮山法は「クラスタを一つも作れない」

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Part 1（10,000 reps）・Part 2（5,000 reps）本番完了。validation 23件 全 PASS。commit 8a9cb70。*

**Mike**:（数字を読み上げる）
「I got it! 確定した。**Part 2 の ARI（n=100）**——

| Set | W₁ | KS | RV(mean,SD) | RV(+skew) | SMD |
|---|---|---|---|---|---|
| 1 Gaussian | 0.995 | 0.983 | **0.996** | 0.620 | 0.452 |
| 2 Log-normal | 0.642 | **0.850** | 0.614 | 0.448 | 0.334 |
| 3 Mixture | **0.526** | 0.503 | **0.018** | 0.131 | −0.000 |

**Set 3 で RV(mean,SD) は ARI 0.018。** 全 n で |ARI| < 0.02。**クラスタを一つも形成できない。** 12か国の座標が全部同一だから、距離行列に信号がゼロなんだ。SMD は −0.000。一方 W₁ 0.526、KS 0.503。**質的な分断だ**——distribution-based は動く、moment-based は動かない。」

**Louis**:（決定的な一撃を確認）
「そして俺が予告した反論——『skew を足せばいい』——の代償が出た。**Set 1 で RV(+skew) は RV(mean,SD) より悪い**。AUC 0.847 vs 0.988、ARI 0.620 vs 0.996。2モーメントで足りる世界に3つ目を足すと、**純粋なノイズを注入するだけ**だ。しかも Set 3 の対称二峰では依然 0.434——**足しても盲目のまま**。『もう一つモーメントを足せ』は無料の patch じゃない。**当てずっぽうへの賭けで、コストは実測された。** You just got Litt up!」

**Katrina**:（負けた場所も表に載せる）
「W₁ が負けるセルも同じ紙面に出した。**Gaussian では RV(mean,SD) が W₁ を上回る**（AUC 0.988 vs 0.985、false-pooling 0.071 vs 0.085）——Gaussian は最初の2モーメントそのものだから当然。**Part 2 の Set 2 では KS が W₁ を大きく上回る**（ARI 0.850 vs 0.642）。C群（SD≈42）の群内 W₁ 距離が大きく、average linkage でクラスタが緩む。Results speak for themselves.」

**Mike**:（正規化案を数学で却下）
「Tak が『W₁ を正規化すれば直るのでは』と思うかもしれないから先に潰しておく。**直らない。** `hclust`+`cutree` は距離行列の**大域スケール変換に不変**だ——全体を定数倍しても ARI はビット単位で同一。国ごとに正規化すればスケール情報が消え、Set 1 で SMD/RV に勝つ根拠が死ぬ。**同一の性質の裏表**——W₁ が raw スケールに乗っているから scale discordance を検出でき、同じ理由で高分散群が緩む。一文で正直に書く。」

**Harvey**:（結論を固定）
「この sim が licence する主張は一つだ。**distribution-based（W₁, KS）vs moment-based（SMD, RV）の質的分断。** W₁ が KS に勝つ根拠は**この sim にはない**——Δ_max だ。それは理論で示す。plan にそう明記した。」

**Donna**:（記録）
「validation は figure fidelity（ggplot_build で 64/192/60点 が CSV と完全一致）**+ 主張そのもの**を assert する形にしたわ。**W₁ が負けるセルも CLAIM check に入ってる**——黙って落としたら build が壊れる。commit 8a9cb70、branch `worktree-selection-sim`（main 未マージ）。」

**Harvey**:（最後に本当の争点を置く）
「一つ、Tak が決めるまで論文に触らせない論点がある。**この sim は『distribution > moment』の強い弾だが、『W₁ > KS』については中立か、むしろ不利だ。**
head-to-head を数えろ——W₁ が勝つのは Set1/Set2 の selection と Set3 の clustering。**KS が勝つのは Set2 の clustering（0.850 vs 0.642）と Set3 shape_sym の selection（0.772 vs 0.759）**。どちらも支配的じゃない。
手法別の勝敗表を論文に出せば、reviewer は指で数える。そして言う——**『じゃあ KS でいい。古くて単純だ』**。我々の答えは Δ_max ただ一つだ。KS にはそれがない。
だから枠組みはこうする——**W₁ と KS を「moment 法を葬る distributional camp」として一体で出す**（これが linkage 不変の決定的所見だ）。**その camp の中で W₁ を選ぶ理由が Δ_max**。**セル単位の horse-race 表は出すな。** これは Tak の判断だ。」

**Louis**:（傷を先に見つける）
「もう一つ、俺が reviewer なら突く穴——**Set3 shape_skew で RV(+skew) 0.651 が W₁ 0.639 を上回ってる**。『distribution > moment』の物語の中で moment 法が勝つセルだ。当然だ、skew はまさに足した座標だからな。**隠すな、武器に変えろ**——『正しいモーメントは、足すべきと知っていれば効く。**それを知れないことこそ Set3 の対称二峰が示している**』。傷が thesis になる。」

**残**: ①**論文フレーミングの決定（KS をどう出すか）← 論文着手前の gate、Tak 判断**、②main へのマージ判断、③（任意）Set2 の linkage 頑健性チェック——決定的所見（Set3 で信号ゼロ）は linkage 不変だが、「Set2 で KS > W₁」は average linkage 固有の可能性があり、別 linkage 1回で確定できる、④Intro ¶7 以降のレビュー再開。

---

### [2026-07-12 14:00] Scene: Set 3 が決定打を撃つ — だが W₁ の売り文句は書き換えになる

**INT. PEARSON SPECTER LITT - BULLPEN - DAY**

*Part 1（selection、KOM/KOM3/Set3 追加）と Part 2（全ペア行列 clustering、新規）の smoke が揃う。数字はチームの想定を半分肯定し、半分裏切った。*

**Mike**:（CSV を三枚並べて）
「I got it! 三つ出た。**一つは決定打、二つは痛い。**

**決定打 — Set 3 で moment-based が完全崩壊。** Part 2 の ARI（n=100）: W₁ **0.530**、KS 0.500 に対して **KOM 0.018、SMD 0.005**。ゼロだ。**クラスタを一つも形成できない。** 全12か国の (mean, SD) 座標が同一だから当然だが、数字で見ると凄まじい。Part 1 の false-pooling も KOM=**0.998**——ほぼ全 rep で誤選択。

**痛い①——Set 1 では KOM が W₁ に勝つ。** scale AUC が KOM **0.999** vs W₁ 0.996、false-pooling が KOM **0.078** vs W₁ 0.098。Gaussian は2モーメントで決まる以上、当然だ。**隠さず出す。**

**痛い②——Part 2 の Set 2 で KS が W₁ を大きく上回る**（ARI **0.856** vs 0.633）。原因は W₁ の**スケール依存**だ。C 群（SD=42）は群内の W₁ 距離まで大きくなり、average linkage でクラスタが緩む。KS は [0,1] 有界だから影響を受けない。Part 1（anchor からのランキング）では出なかった弱点が、clustering では露出する。」

**Katrina**:（もう一つの発見を拾う）
「見落とすな。**KOM3 は KOM より悪い**——Set 1 の combined AUC が KOM 0.988 に対し KOM3 **0.840**。skew 座標を足すと**性能が下がる**。無関係な座標がノイズを持ち込むから。Results speak for themselves.」

**Louis**:（我が意を得たり）
「それが俺の欲しかった弾だ。『SD を足せばいい、skew も足せばいい』という反論は、**足すこと自体にコストがある**という事実で死ぬ。しかも Set 3 の shape_sym では KOM3 が **0.419**——3座標にしても対称二峰には盲目のままだ。**どのモーメントを足すべきかを知らない限り、足す行為は賭けにすぎない。** これが pillar (a) の完成形だ。」

**Harvey**:（売り文句を書き換える）
「W₁ の主張を『あらゆる場面で最強』にするな。それは数字が否定した。正しい主張はこうだ——**『2パラメータ族の世界なら既存法で足りる。我々もそう認める。だが、どのモーメントまで数えれば足りるかを事前に知る方法は存在しない。Set 3 がその代償を示す——representative-value 法はクラスタを一つも作れない。W₁ はその問いを回避し、加えて Δ_max で臨床較正できる。』** KS も前半は満たす。**W₁ と KS を分けるのは Δ_max だ**——ここが (b) の出番になる。」

**Donna**:（本番実行を管理）
「Part 1 = 10,000 reps、Part 2 = 5,000 reps を並行で走らせたわ。図と validation はその後ね。」

**残**: ①本番結果の確認、②図（KOM/KOM3/Set3/Part2 ARI）、③validation、④W₁ スケール依存の扱い（正規化版を足すか、限界として書くか）を Tak 判断。

---

### [2026-07-12 13:00] Scene: Mike の予測が崩れる — 現行ロスターでは小宮山に勝てない

**INT. PEARSON SPECTER LITT - BULLPEN - DAY**

*実装に入る直前、Mike が advisor に設計を諮る。返ってきたのは自分の予測の否定だった。*

**Mike**:（自分の誤りを認めて）
「訂正する。さっき『log-normal なら W₁ が (mean,SD)-Euclidean に勝つ』と言ったが、**間違いだ**。log-normal は**2パラメータ族**——(mean, SD) と (μ, σ) が全単射だから、歪度も裾も (mean,SD) の決定論的関数になる。小宮山法は歪度を『取りこぼして』いない。
検算した。Set2 の Dp1 は mean=50 のまま **SD が 20→30**、Dp2 は **20→42.5**。**SD 軸だけで完全に分離できる**。Set1 の V1/V2 も同じ（SD 10→16, 20）。
結論——**現行 Set1/Set2 には『mean も SD も anchor と一致するのに分布が違う』候補が一つも存在しない**。fair な小宮山法は両セットの discordant 国を全部検出する。このまま走らせても出るのは『W₁ ≈ 小宮山』だけだ。」

**Louis**:（勝ち誇って）
「だから言っただろう。俺の bimodal 要求を『Tak 判断待ち』の残タスクに落としたのが間違いだ。**あれが sim の心臓部だった。** matched-moment シナリオがなければ、この sim は小宮山法の優秀さを証明して終わる。You just got Litt up!」

**Harvey**:（即断）
「Set 3 を作る。選択肢はない。全10か国を **2成分 Gaussian mixture**——同一 family だから Tak の realism 要件は満たす——にして、**overall mean と SD を anchor と完全一致させたまま形だけ変える**。小宮山の座標は同一 → AUC 0.5。W₁ は CDF の差を見る → 検出。pillar (a)『どのモーメントを見るべきか事前指定不要』の decisive な実証だ。」

**Mike**:（さらに一手先へ）
「I got it! もう一段深くやる。対称 bimodal を使えば **skew までも anchor と一致させられる**。つまり (mean, SD, **skew**) の3座標を持つ小宮山法でさえ検出できない候補を作れる。Louis が予告した『SD を座標に足せば1行 patch』という反論を、**モーメントをいくつ足しても追いつかない**という形で先回りして潰せる。」

**Donna**:（設計原則を固定）
「advisor から fairness 制約も2つ。①小宮山の標準化は**全10か国 across** で行う（ペアワイズ API では書けない → リファクタ必須）。②Part 2 では **clustering アルゴリズムを固定して距離行列だけ差し替える**——でないと reviewer は『差はアルゴリズムのせい』と言うわ。ground truth は construction label のみ、metric 由来は禁止。」

**Harvey**:（3セット構成の物語を定義）
「これで論文の筋が通る。**Set1/Set2 では既存法で足りる——正直に出す。だが『どのモーメントまで見れば十分か』を事前に知る方法はない。Set3 がそれを証明する。W₁ はその問いを回避する。**」

**残**: ①Part 1 = distfun の roster-level リファクタ + Komiyama(mean,SD) / Komiyama3(mean,SD,skew) 追加 + Set 3 実装、②Part 2 = multi-group ロスター + 行列 clustering (ARI)。

---

### [2026-07-12 12:30] Scene: Tak の二撃 — 「行列で選べないのか」「小宮山と比べろ」

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Tak が結果を見た直後、sim の設計そのものに二発を撃ち込む——「アンカーとの比較だけじゃなくて、全組み合わせで比べて行列作るのは併合候補選択に使えないんだっけ？」「既存手法として小宮山のクラスタリングと比べたほうがよいよね」。*

**Mike**:（材料を照合して即答）
「I got it! 二つとも本質だ。
**①行列は使える——むしろそれが小宮山法そのもの**。ここで問題定式化が2種類あることを区別しないといけない。今回の sim は **anchor-centric ranking**（1つの基準地域に併合できる相手を距離順に選ぶ＝規制上の pivotal region 判断）。小宮山は **全ペア距離行列 + hierarchical/k-means clustering**（地域全体をグループ分け）。後者は**まだ一度も比較してない**。
**②比較対象が metric 止まり**——W₁ vs SMD vs KS は全部『距離の測り方』の違いでしかない。既存の**手続き全体**（representative value + Euclidean + clustering）と比べていない。reviewer は必ずここを突く。」

**Harvey**:（理論から結果を先読みする）
「先に言っておく。fair な小宮山法を作ると Gaussian world では **(mean,SD)-Euclidean が W₁ とほぼ並ぶ**——Gaussian は2モーメントで完全に決まるからだ。そこで W₁ の優位はほぼ消える。隠すな、出せ。逆に log-normal では (mean,SD) が歪度・裾を取りこぼす → W₁ が勝つ。それが novelty pillar (a)『どのモーメントを見るべきか事前指定不要』の実証になる。」

**Louis**:（釘を刺す）
「小宮山法を **mean-only** で実装したら strawman だ。俺が 6/27 に Seam 1 で残した警告どおり——§4.6.1.1 は "representative value in each candidate **parameter**" で mean に限定してない。SD を座標に足すのは1行の patch だぞ。fair 版は最低でも **(mean, SD)-Euclidean + hierarchical clustering**。それでも W₁ が勝つ土俵——bimodality / heavy-tail——を用意しない限り『incremental over Komiyama』で沈む。You just got Litt up! される側になるな。」

**Tak 決定**: **Option C — 2部構成**。Part 1 = anchor-centric selection に小宮山距離を第4手法として追加、Part 2 = 全ペア行列 + clustering（W₁-clust vs 小宮山-clust、adjusted Rand index 等）。

**Donna**:（先回りして）
「fair 版 (mean,SD)-Euclidean + hierarchical は Louis の警告どおり確定。作業は worktree `selection-sim` で継続——main 未マージのままね。」

**残**: ①既存コード読解→Part 1 拡張、②Part 2（行列 clustering）設計・実装、③Louis 条件の bimodal/heavy-tail シナリオ要否を Tak 判断。

---

### [2026-07-12 12:00] Scene: Selection simulation 結果確認 — W₁ > KS > SMD、SMD は scale/shape に盲目

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Tak が「simulation の結果を確認していく」と宣言。7/11 に worktree `selection-sim` で完了した pooling-partner selection sim（commits 43c2bfa + a8f7148、main 未マージ）の成果物をチームで開く。*

**Donna**:（worktree を照合して）
「SUITS.md が 7/4 で止まってたから実態確認したわ。worktree-selection-sim に2コミット——sim 本体（10か国=anchor 1+candidates 9、ground truth は construction label で non-circular、10,000 reps、n=25/50/75/100、per-cell seed の random tie-break）と、検証済み図2枚（validate_figures.R 16/16 pass、図の点は CSV と multiset 一致）。」

**Mike**:（CSV を指でなぞりながら）
「I got it! 結果の骨格は3点だ。
① **SMD は scale/shape に完全に盲目**——Set1 Gaussian の scale AUC が全 n で ≈0.50（n=100 でも 0.499）、Set2 log-normal の shape も同じ（0.507）。さらに SMD_log は combined で ≈0.50——log-mean cancellation で設計どおり潰れる。
② **W₁ が全面的に優位**——Set1 n=100: combined AUC W₁ 0.985 vs KS 0.957 vs SMD 0.947、scale では 0.997 vs 0.934 vs 0.499。Set2 n=100: combined 0.950 vs 0.802 vs 0.648。**W₁ > KS > SMD の順位は両 family・全 n で不変**。
③ **false-pooling@k の減衰**——W₁ は Set1 で n=25→100 に 0.575→0.085 まで落ちるが、SMD は 0.94→0.89 で高止まり。Set2 は全法とも難しく W₁ でも 0.841→0.438——歪んだ分布での選択は n=100 でも残余リスクがある、これは正直に書くべき限界だ。
一つ注意——location だけなら SMD が W₁ を僅差で上回る（Set1 n=25: 0.880 vs 0.870）。SMD は location 専用設計だから当然で、W₁ はそれにほぼ並びつつ scale/shape も拾う、という読み方が正確だ。」

**Katrina**:（図を提示）
「fig_selection_auc_by_type（84点）と fig_selection_false_pooling（28点）を Tak に送付済み。paper standard（theme_bw base 11、greyscale + color 変種、白背景）、greyscale/印刷/CVD でも系列判別可能な colour+linetype+shape 三重エンコード。Results speak for themselves.」

**Louis**:（腕を組んで）
「言っておくが、この sim の ground truth が『anchor 母集団から引いたか否か』の construction label だという点は防御の要だ。metric 自身で正解を定義したら circular だと reviewer に一撃で刺される——そこは回避できてる。だが Set2 の W₁ false-pooling 0.438 @ n=100 を隠して 'W₁ wins' とだけ書いたら、You just got Litt up! される側になるぞ。」

**Harvey**:（短く）
「limitation は武器にする。『SMD では選択問題は原理的に解けない、W₁ なら解けるが小標本の歪み分布では慎重を要する』——これが売り込みの構図だ。次は Tak の判断——この結果を論文のどこに載せるか、worktree を main にマージするかだ。」

**残**: ①worktree-selection-sim の main マージ判断、②論文への組み込み位置（ADEMP 5-table 計画との整合）、③Intro ¶7（SMD 限界）以降のレビュー継続。

---

### [2026-07-04 XX:XX] Scene: レビュー再開 — \emph 除去を先行、¶4 は確認保留

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Tak がレビューに復帰。チームは再開点を ¶4（EM known/unknown、7/2 挿入・Tak 確認保留）と特定。Tak の判断は「\emph 除去だけ先に」。*

**Donna**:（状況を整理）
「再開点は挿入済み ¶4 の Tak 確認。並行して line 72 に `\emph{planning stage}` が残ってた——[[feedback_paper_no_emph]] の除去対象。Tak は『\emph 除去だけ先に』と決めたわ。」

**全チーム**:（¶4 を full-team で読み、Louis 全段落 critique）
- Harvey: 段落の役割は known/unknown 軸→¶5 Komiyama gap への橋渡しのみ。scope 文が防御線。
- Louis: "regional/ethnic factors as surrogates" が危険地帯だが、事実記述に留まり定量/定性の優劣に踏み込まず → ぎりぎり通す。条件は ¶5 で Komiyama が具体的手法を持つことを明示し続けること。
- Jessica: 段落は novelty を主張せず軸を立てるのみ → 承認。

**Katrina**:（\emph 除去を実行）
「本文全体を grep したら `\emph` は **line 72 の1箇所のみ**。過去の除去作業がほぼ完了してた。`\emph{planning stage}` → `planning stage` に修正。braces 除去なのでコンパイルへの影響なし。残存ゼロ。」

**Tak 決定①**: 「¶4 確定 → ¶5 へ」→ 挿入済み ¶4（EM known/unknown）を確定。

**全チーム**:（¶5 = Komiyama gap 段落 = novelty (a)(b) の土台を full-team レビュー）
- Harvey: E17沈黙→Song→Komiyama最具体→二gap の構造は [[feedback_writing_logic_flow]] どおり。骨格 OK。
- Mike: gap(a)=full distribution 未見 → W₁ が回答、gap(b)='clinically meaningful' judgment に metric なし → Δ_max が回答。第1文 "standardized/clinically calibrated" が伏線→最後で回収。P2 満たす。
- Louis: 3文目 "Recent regulatory guidance has highlighted this gap." は **P4 不正確**（Song et al.=論文≠guidance）＋ **P3 冗長**（次の Song 文と重複）→ 削除一択。¶4 で課した『Komiyama が具体的手法を持つ明示』条件は本段落の "cluster analysis...via the Lasso" が満たす。
- Jessica: novelty は (a)(b) のみ、それ以外主張するな → 現状維持で承認。3文目削除に同意。

**Katrina**:（¶5 修正を実行）
「Tak 決定②で3文目 "Recent regulatory guidance has highlighted this gap." を削除。Song 文が E17 の沈黙を直接受けて流れる。残り7文は as-is。」

**全チーム**:（¶6 = planning stage / Matsushima secukinumab 例を full-team レビュー）
- Louis: ①2文目が ¶5 の焼き直し（"similar enough" 二重）→ P3 削除。②Matsushima 実例が CRP陽性/MRI陰性の **binary status** なのに ¶3 で continuous に scope 限定済み → consistency の穴。
- Mike: binary の W₁ は $|p_1-p_2|$ に縮退（形・裾なし）→ 実例が ¶7 SMD 売り込みと噛み合わない点を数学的に裏付け。
- Rachel: Matsushima 記述自体は正確。争点は scope 整合。
- Jessica: 実例は捨てるな（real/documented）。binary の弱点を bridge で ¶7 への助走に変えろ。

**Tak 決定**: 「(A) 2文目削除 + (B) bridge 一文追加」。

**Katrina**:（¶6 修正を実行）
「2文目削除。bridge 追加——'That case involved a binary status, where imbalance reduces to a difference in proportions; the continuous effect modifiers on which we focus can differ in shape and spread, not only average level, so assessing their similarity requires more than comparing means.' 末尾が ¶7 の SMD 批判へ直結。Louis 条件どおり SMD 名指しは ¶7 に残した。」

**残**: ¶7（SMD 限界）以降の段落レビュー継続。コンパイル未確認（¶5 1文削除 + ¶6 削除/追加、Intro 一区切りで確認予定）。

---

### [2026-07-03 00:40] Scene: ポスター説明原稿を書く

**INT. PEARSON SPECTER LITT - KATRINA'S DESK - NIGHT**

*Tak から一言 ——「Poster_GSC_TN の説明用原稿を日本語で作れ」。Katrina がポスターの中身を素早く洗い出す。*

**Katrina**: （pptx を開いて即座に見抜く）
「実物は1枚パネルの学会ポスター。本文は画像化されてて、テキストが完全に残ってるのは marp版の方。典拠はこっち。Results speak for themselves.」

**Mike**: （数値を指で追いながら）
「carry する数字はチェックした。S1–S7、1万反復、n=50/100/200、B=2,000、カバレッジ 0.88–0.96、GUSTO-I 16地域、アンカー R8、同時適格 6地域 R1/R4/R5/R6/R14/R15、R4 最有力、Δclin=1%pt、L上限 age 10⁻²/yr・SBP 2×10⁻³/mmHg。全部ポスターどおり。」

**Donna**: （釘を刺す）
「一点だけ Tak に伝えておくわ。このポスターは指標を nABCD と呼んでる。論文本体は per-EM W₁ に置き換え済み。原稿はポスターに忠実にしたけど、再利用のときは用語のズレに注意 → [[project_ja_paper_deleted]]」

**Harvey**: （短く）
「発表用だ。キャラの声は原稿に混ぜるな。プロの presenter script として clean に。約8〜10分想定、想定時間は冒頭に明記しておけ。」

*成果物: `projects/similarity-metric/poster/Poster_GSC_TN_script_ja.md`（14セクション、スライド見出しつき）。*

---

## Current Status (2026-06-27 EOD)

**Active Project**: similarity-metric (per-EM W₁ paper, target *Statistics in Medicine*, Phase 8 submission-ready)
**EN paper**: `projects/similarity-metric/paper/per_em_W1_wiley.tex` (+`.bib`) — コンパイル 16頁クリーン
**JA paper**: **意図的に削除済み**（Tak 指示、EN 完成まで。Rule 2.7 同期は保留。再生成するな）→ [[project_ja_paper_deleted]]

---

## 🔄 直前のコンテキスト (from archived scenes)

### 直近の作業（2026-06-27 全体）
1. **SUITS Tier 1 A+B 拡張実装**: Persistence Guard (Stop hook + `/handoff`) + Numbers Verification Gate (PostToolUse hook + `/verify-numbers`)。ARS 非重複 → [[project_suits_tier1_guards]]
2. **Komiyama Ch.4 "Pooling Strategies" レビュー**（小宮山ら, 日本 E17 TF, DOI 10.1201/9781003109785-4）→ `knowledge/summaries/Komiyama_2024_Ch4_Pooling.md`
3. **Meeting**: 判別ケース S8→**S5**訂正、novelty を S5 から (a)no-moment-pre-specification + (b)Δ_max link に再配置（Louis adversarial）
4. **Komiyama を EN 論文に反映**: Intro(Komiyama 追加+narrow)、Disc(representative-value 追加)、bib(komiyama2024)。overclaim 二発回避
5. **コンパイル修正**: line 380 Unicode ₁→`$W_1$`(致命)、dangling `\ref{prop:nonnegativity}`(refactor 積み残し)解消
6. **JA 削除**（Tak 指示）
7. **Komiyama レビューの配当を Discussion に実装**: ①per-EM AND 基準 vs 集約クラスタリング対比、②Δ_max が転移問題に有界誤差で答える、③距離閾値×クラスタ数≤4 相補性、④Lasso を上流 EM 選択フロントエンドに

### 進行中のアクション
- なし（直近タスク完了）。EN 論文はコンパイル 16頁クリーン、両引用解決。

### 次にやるべきこと
- **EN/JA 乖離の解消**: EN は nABCD 撤回・per-EM W₁ 移行済みだが Discussion に "nABCD" 用語が残存（refactor 積み残し）。EN 完成後に JA を per-EM W₁ 方針で再構築。
- （任意）Discussion の "nABCD"→"W₁/Δ_max" 用語統一は Tak 判断待ち（大きめの refactor）。

### Tak からの直近の指示
- 「JA は EN が完成するまで削除」→ 実行済み。Rule 2.7 保留中。
- 「Harvey の推奨どおり進めよう」→ Komiyama 配当①②③④ 実装済み。

---

## 🎬 Live Script

### [2026-07-02 01:20] Scene: 図S1-S7修正 + 非類似行列は Option A（報告）で本文反映

**INT. PEARSON SPECTER LITT - BULLPEN - NIGHT**

*Tak の2指示——①スライド図を S1-S7 に、②非類似行列を本文反映。*

**Katrina**:（図修正）
「Simulation Design 図 `slide_scenario_overview*` が 3×3=**S1-S9** を描いてた（S8 Outlier/S9 Gamma が余分）。`figures_paper.R` で `sc_defs[1:7]` にスライス（S8/S9 定義は normalizer 研究用に温存）→ 再生成 panels=7 確認。BRA デッキ(line 421)は既に S1-S7 ラベルで参照済みなので図とラベルが一致。greyscale/color×png/pdf 4本更新。」

**Mike**:（数値の paper 品質再検証）
「Task B 数値を独立再現——**全一致**。raw W₁ 復元は論文Table比 diff≤0.004、さらに advisor 指摘で **W₁≥|平均差| 制約**が 2×版を数学的に強制（R1-R2 SBP 平均差3.84→W₁=3.94 のみ可能、1.97 は不可能）。三重に安全。age×SBP 行列相関 **r=0.133**、anchor集合={R1,R4,R5,R6,R14,R15}=R8のjoint行 完全一致、star≠clique(R1-R6 age=1.06)。」

**Harvey**:（advisor 指摘でスコープ確定）
「advisor が本質を突いた——『本文反映』の論点は配置でなく **scope: 報告 vs クラスタリング**。Komiyama を『距離行列上のクラスタ分析』と批判する論文で自らクラスタ分析したら自撃。**Option A（行列を報告）**を採用——line 472 の R2/R9 逸話に **r=0.13（全120ペアで age×SBP 行列ほぼ無相関）**を追記、逸話→行列全体エビデンスに格上げ。新方法論・図・クラスタリングなし。」

**Tak 決定**: 「行列の報告でまずはいこう」→ Option A 適用済み。**コンパイル EXIT 0 / 16頁 / エラー0**。
**Tak 質問**: 「16地域でクラスタリングは適切に使えるのか（知識薄い）」→ Mike が回答中。

**Louis**:（B の封印）
「dendrogram を作った瞬間 Komiyama 枠組みにコミットする。star≠clique は marginal な R1-R6 依存。B は Supplement 止まり、今は触るな。」

**残**: クラスタリング(B/Supplement)の可否 = Tak がクラスタリング理解後に判断。slide 25枚 base 未決。

---

### [2026-07-02 00:10] Scene: 3タスク着地 — A/B 完了報告、C は tex 反映

**INT. PEARSON SPECTER LITT - BULLPEN - NIGHT**

*background 2件が返り、Task C は Tak 承認で tex 反映。*

**Donna**:（Task A 決着）
「BRA スライドのソース md 特定——`poster/Poster_GSC_TN_marp.md`（高確度）。同一コミット `7f3c283` + 分単位 mtime 一致 + marp 16:9 デッキ構造が決め手。BRA = Biostatistics Research Association（医学統計研究会）発表用、~16枚 EN。`nABCD_presentation.md`(33枚JA) とは別物。」

**Mike**:（Task B 検討結果）
「全ペア非類似行列プーリングは **適用可能、かつ per-EM 形なら論文を強化**する。核心: age 行列と SBP 行列の相関 **r=0.133**（ほぼ独立）→ Komiyama 式に1本へ集約すると実在の per-EM 非互換が masking される。我々の per-EM 2行列 + **non-compensatory joint AND** はそれを保存。Anchor 結果 {R1,R4,R5,R6,R14,R15} は行列の R8 行として完全再現。ただし clique 検定で R1-R6(age=1.06) が閾値に衝突 → **anchor互換(star) ≠ 相互互換(clique)**。Δ_max = complete-linkage の臨床較正 cut height（Komiyama Seam 3 を埋める）。**推奨: compact Supplement + Discussion 1文**（reframe 非推奨）。
⚠️ **データの罠**: `gusto_all_pairwise.csv` は factor-2 除去前の版で nABCD=W₁/(2·IQR) 格納 → 復元は **W₁=2×nABCD×IQR**。論文 Table 値で照合済(最大誤差0.004)。**paper 投入前に CSV 再生成＋数値再検証必須**。SBP 閾値は W₁<5.0mmHg(0.5でない)。検証スクリプト `scratchpad/matrix_clustering.R`。」

**Katrina**:（Task C 反映）
「Tak 承認（①配置=¶3↔¶4間 OK ②遺伝子マーカー例=残す ③最後の一文=削除）で EN tex に新段落を挿入。EM known/unknown の軸を Komiyama Fig4.3/4.4 に紐づけ、`\cite{komiyama2024}`×2、scope を『候補 EM 集合に対し機能・同定方法に非依存』で切った。**コンパイル EXIT 0 / 16頁 / エラー0**。JA は削除済のため Rule 2.7 同期は保留のまま。」

**Louis**:（B への釘）
「Supplement 化する時は per-EM + non-compensatory AND + Δ_max-cut の差別化を前面に。marginal な R1-R6 事例に議論を背負わせるな。数値は Mike が paper 品質で再検証してからだ。」

**残・判断待ち**:
- **Task B**: Supplement 化 GO/保留 = Tak 判断待ち（GO なら CSV 再生成＋数値再検証が前段）
- **slide**: 25枚デッキ（nABCD→W₁ 経緯入り）の base = BRA 16枚(EN) か 33枚(JA) か 未決

---

### [2026-07-01 18:40] Scene: スライド精査 → 3タスク並行始動

**INT. PEARSON SPECTER LITT - BULLPEN - EVENING**

*Tak がスライド作業を再開。まず BRA 用スライドの精査から。*

**Donna**:（状況整理）
「BRA スライドの実体は `poster/nABCD_slide_20260508.pdf`（Tak 確認済み）。ソース md を探索中——background に回したわ。既存デッキ `nABCD_presentation.md`（~31枚）は Application 部が既に per-EM/L*/joint-eligible(R4主候補) で現行論文と整合、一方 Methods/Simulation 部はまだ旧 nABCD=W₁/IQR 定義のまま。EN 論文は raw W₁ に統一済み——ここが乖離ポイント。」

**Tak（指示3件）**:
1. BRA スライドのソース md を探す（@bg）
2. 事例で anchor-vs-others でなく**全ペア非類似行列→近いものをクラスタリング**する方法が適用できるか検討
3. 並行して Komiyama Ch.4 で Introduction 強化 — **EM known/unknown の状況説明**を追加

**Mike**:（Task 2 に着手）
「`gusto_all_pairwise.csv` に全120ペア×2変数の nABCD + IQR_pooled がある。raw W₁ = nABCD×IQR で復元できる。W₁ は proper metric（対称・三角不等式）だから 16×16 非類似行列→階層クラスタリングは原理的に可能。KL では不可能——ここは強み。per-EM で組めば R2/R9 逆転論法も保たれる。"I got it!" background で計算・検討する。」

**Harvey**:（Task 3 を締める）
「Introduction は既に Komiyama 段落(¶4)を持つ。追加するのは EM が known/unknown で計画可能性が変わるという軸——Komiyama Fig4.3(factor hierarchy)/Fig4.4(plannable ∝ EM knowledge)。ただし上流の EM 同定(Lasso)は our contribution ではない。scope を切って提案する。段落レビューは全チーム、Tak 承認を取ってから tex に触る。」

**Louis**:（釘刺し）
「known/unknown を足すなら『日本=定性/定量ゼロ』に逆戻りするな。Komiyama は具体的手法を持ってる。我々の novelty は (a)モーメント非事前指定 + (b)Δ_max 連結の二本だけだ。それ以外を混ぜたら撃たれる。」

**進行中**: Task A(md探索)/Task B(非類似行列検討) = background。Task C(Intro EM known/unknown) = foreground レビュー。

---

### [2026-06-29 10:30] Scene: 段落レビュー再開 — Abstract defer、Intro ¶1–¶3 修正

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*citation-check 完了後、段落レビュー再開。bib クリーンアップ2件は @bg 完了。*

**Katrina**:（bg 報告）
「bib クリーンアップ完了。`iche17` に URL 追加、`rousseeuw1993`（IQR 正規化撤去で orphan 化）削除。39→38 エントリ、citation-safe。」

**Tak**:「Abstract は原稿が完成した最後に作成すべきだ。」

**Harvey**:（同意）
「その通りだ。本文確定後に書く——順序が逆だった。Abstract は defer、Introduction から再開する。」

**全チーム**:（Intro ¶1–¶3 を full-team レビュー、Louis 全段落）
- **¶1**: benefits 文（専門読者に自明）削除、"central assumption that effects are generalizable"→"evaluate whether effects can be regarded as generalizable"（E17 性格づけの精度、Mike/Louis）
- **¶2**: `\emph{regional pooling approach}` 除去（[[feedback_paper_no_emph]]）、"Several regulatory authorities"→"Regulatory authorities in **Japan and China**"（Tak 指示、引用 matsushima/song と具体名一致、overclaim 回避）
- **¶3**: age 例の重複（2文目）削除、結論文に "the full effect modifier distribution, not only its average level" を布石（Louis: 段落例が location のみなのに distributional と結論する gap を修正）

**Donna**:（記録）
「3段落、全部 Tak 承認で適用済み。記録完了。"I'm Donna. I know everything."」

**残**: Intro ¶4（Komiyama gap 段落）以降継続。line 70 の `\emph{planning stage}` 除去も後続で。

---

### [2026-06-28 01:30] Scene: nABCD 完全撤去 — Option A 実装完了

**INT. PEARSON SPECTER LITT - BULLPEN - NIGHT**

*Tak「nABCD完全に消せ」。Katrina の raw 結果から Simulation 全体を W₁ に書き換え。*

**Katrina**:（raw 結果を配って）
「`w1_raw_simulation_results.md` から全部埋めた。tab:scenarios/bias/coverage/precision を raw W₁ に差し替え、tab:smd は detection 比較に reframe。S5=4.38±1.04、S6=12.36±1.85（mean=True+bias、SD=√(RMSE²−bias²)で再構成）。図は元々 raw W₁ だから無傷。」

**Mike**:（漸近論を直して）
「Appendix を ρ の delta-method から del Barrio two-sample Gaussian に簡略化。rate √(n₁n₂/(n₁+n₂))、F₁≠F₂ 条件、F₁=F₂ 境界 caveat 保持。提案=評価=証明が全部 W₁ で揃った。"I got it!"」

**Rachel**:（Abstract を確認）
「Abstract は『W₁ framework を提案』に reframe。nABCD 造語を撤去、ABCD/nABCD を abbreviations からも削除。Intro の \emph も除去。」

**Harvey**:（締めて）
「本体に nABCD・ρ の残存ゼロ。コンパイル 16頁クリーン、undefined 0。提案した量を評価し証明する——三枚舌は終わった。」

**Louis**:（確認）
「半端なしだ。表・図・Appendix・tab:smd・R コード(compute_W1)・Abstract、全部 W₁。tab:smd は単位不一致 attack を『detection 比較・magnitude は比較不可』の注で封じた。通す。」

**残**: supplement_path_alpha/normalizer_comparison（正規化議論が本質なので別途検討）、figures_paper_W1.R の width=10→7 nit（コミット済み図は raw W₁ で正しい）。

---

### [2026-06-28 00:30] Scene: Meeting — nABCD を片付ける方針（Option A 徹底に決定）

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - NIGHT**

*4名が並行分析。意見が割れる。Mike/Rachel=B、Katrina/Louis=A。*

**Louis**:（攻撃的に）
「命名の話じゃない。**提案=W₁、評価=ρ、証明=nABCD の三枚舌**だ。reviewer に『W₁ を提案したのに operating characteristics を W₁ で一つも報告してない』と撃たれる。反論不能。」

**Katrina**:（決定的な新事実）
「コミット済みの図 `fig2_simulation_results.pdf` は**既に raw W₁**（panel A "Bias of Ŵ₁", S1≈2.46）。論文は図(W₁)↔本文4表(ρ)の不整合を既に抱えてる。B はそれを凍結するだけ。raw 結果は完備、A の実コストは表4つ＋tab:smd だけ。」

**Mike**:（収束）
「coverage は estimated IQR で割ると非単調 → ρ̂ と Ŵ₁ の coverage は一致しない。提案が W₁ なら Ŵ₁ の coverage を報告すべき。Louis が正しい。B は間違った推定量の coverage を報告してる。」

**Harvey**:（断定）
「**Option A、徹底的に。** 図は既に raw W₁、B はその矛盾を凍結する。methods paper は提案した量を評価・証明せねばならない。中途半端は B より悪い — 表・図・Appendix・tab:smd・R コード全部 W₁ に統一。」

**実行計画**: ①tab:bias/coverage/precision を raw W₁ ②tab:smd を detection 比較に reframe ③Appendix 漸近論を W₁(del Barrio+Sommerfeld)に簡略化 ④Abstract を W₁ framework に ⑤Discussion/R コード/図 width nit ⑥ρ は推論対象から外す

**Jessica**:（承認）
「Let me be clear。一貫性(提案=評価=証明)最優先は正しい。承認。ただし全部やり切れ。半端は許さない。Tak の go を取れ。」

---

### [2026-06-27 20:58] Scene: Archive

**INT. PEARSON SPECTER LITT - FILE ROOM - NIGHT**

*Donna が分厚いフォルダをアーカイブ棚へ移す。Hook が 1005 行で発火。*

**Donna**:（手際よく）
「SUITS.md が 1000 行を超えたからアーカイブしたわ。`archives/SUITS_20260627_205843.md` に保存済み。新しいスクリプト開始よ。直前のコンテキストは全部引き継いだ。"I'm Donna. I know everything."」

**Harvey**:（通りがかりに）
「過去は過去だ。前を見ろ。EN を完成させる。」

---

## 📊 Key Memory References (Active)

### CRITICAL Rules
- Rule 2.5 (Auto-Archive): 本シーンで発火
- Rule 2.7 (EN-JA Sync): **保留中**（JA 削除済み、EN 完成まで）
- Rule 3.7 (Speaker Clarity): `**Name**:「...」` 形式必須
- Rule 3.8 (Tone Authenticity): canonical voice 維持

### Active Memory (cross-conv)
- [project_ja_paper_deleted.md](memory/project_ja_paper_deleted.md) — JA 削除、再生成するな
- [project_suits_tier1_guards.md](memory/project_suits_tier1_guards.md) — Persistence/Numbers guards
- [feedback_calculation_verification.md](memory/feedback_calculation_verification.md) — 数値再検証必須
- [feedback_compaction_protocol.md](memory/feedback_compaction_protocol.md) — premature declaration 禁止
- [feedback_proactive_review.md](memory/feedback_proactive_review.md) — 先回り critique
- [feedback_tak_review_principles.md](memory/feedback_tak_review_principles.md) — Tak 5 原則
- [feedback_speaker_clarity.md](memory/feedback_speaker_clarity.md) / [feedback_tone_authenticity.md](memory/feedback_tone_authenticity.md)
- [feedback_paper_no_emph.md](memory/feedback_paper_no_emph.md) — `\emph` 使わない

### Path α Specific (Active)
- **Methodology**: Per-EM W₁ raw + Δ_max = L_clinical × W₁（正規化なし、nABCD 撤回）
- **W₁ theory**: Sommerfeld 2018, del Barrio 1999, Panaretos 2019, Vallender 1974, Villani 2009
- **L_clinical**: VanderWeele 2014/2019, Fisher 2017, Riley 2010, FTT 1994, GUSTO 1993, Lee 1995
- **Komiyama 2024 (新規)**: 当事者の pooling レシピ。gap=分布構造潰し＋臨床閾値未 operationalize。Δ_max が彼らの転移問題に回答
- **Out of scope**: Multi-EM aggregation（Discussion で per-EM AND 基準と対比）、within-EM normalization（Supplement A equivalence）
