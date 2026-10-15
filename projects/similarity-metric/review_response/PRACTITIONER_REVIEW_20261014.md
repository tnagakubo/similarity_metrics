# 実務家レビュー（MRCT 地域解析・地域プーリング担当の医学統計家の立場）— 2026-10-14

対象: `paper/per_em_W1_wiley.tex`（838 行）、`paper/generated/tab_*.tex`。Statistics in Medicine 投稿想定。
読んだもの: 原稿本文・付録・生成表（tab_gusto_nabcd / tab_gusto_lstar_joint / tab_operability）。results の CSV と R コードは開いていない（本文と生成表の範囲で判断）。SUITS / CLAIMS / DECISIONS / memory / review_response / LAB_STATUS / git 履歴は読んでいない。原稿は編集していない。

## 0. 総評（実務家の一言）

数学は丁寧で、「何を保証し、何を保証しないか」の自己申告はむしろ過剰なほど誠実である。しかし**現場の担当者がこれを SAP に書き、解析し、結果を社内・当局に説明する場面を想像すると、材料が三つ足りない**。(1) 誰が・いつ・何のデータで計算するかの手順（P-2）、(2) 提示された Δ_max / L* が意思決定に何をもたらすかの実例（P-1）、(3) 既存の consistency 評価とどう並べて使うか（P-4）。加えて、応用例の標本サイズが実際の MRCT の地域より 1〜2 桁大きく（P-3）、実務で最も多い binary/ordinal の EM が対象外（P-5）という「適用範囲」の問題がある。Study 1/2 は厳密だが、実務家が知りたい問いには直接答えていない（P-6）。

「判定規則・閾値を与えない」設計（quantify, not decide）自体は、規制当局文書（ICH E17 が非規範的）との整合の点でむしろ妥当。ただし**閾値がない代わりに「読み方の手順」が必要**で、いまはそれが薄い（P-1, P-4）。

---

## Major（6 件）

### P-1 [Major] Δ_max / L* の読み取りが、例示した L_UB と Δ_clin では意思決定に寄与しない（寄与する場面が示されていない）
- **該当**: §2.4（"Specifying $L_{\text{clinical}}$ (or its upper bound $L_{\text{UB}}$) is a clinical judgment…"、`L_UB,age ≈ 1×10^-2 per year`）、§4.4 Clinical Interpretation（"Table~\ref{tab:gusto_lstar_joint} reports, for each partner region, $L^*$…"）、Table `tab:gusto_lstar_joint`。
- **問題**:
  1. 例示された L_UB,age = 0.01/年（10 %pt/10 年）は、原稿自身が認める通り GUSTO-I の全体の治療効果（30 日死亡率 6.3 % 対 7.2 %/7.4 %、差およそ 1 %pt）と同程度かそれ以上である（§2.4 末尾「one reason the bounds are illustrative」）。この L_UB の下では Δ_max = L_UB·W1 は W1 = 0.39〜2.61 年に対し 0.4〜2.6 %pt となり、**全体効果そのものを超える**。実務家は「効果差の上限が全体効果より大きい」bound からは何も言えない。
  2. 生成表を目視で集計すると（再計算は未実施、要確認）、年齢では L* の区間が全体として L_UB（0.01）を上回るのは R5・R7（いずれも null floor 未分離）だけで、残りは「区間が L_UB を含む」か「下回る」。SBP では L_UB（0.002）に対し、ほぼ全パートナーで区間の下限が L_UB を超えるか境界上にある。すなわち**読み取りの結果は事実上 L_UB と Δ_clin の任意選択で決まり、データ（分布）の寄与は順位に出る程度**。
  3. 「Δ_clin = 1 %pt」も全体効果とほぼ同じ値で、なぜその値かの根拠がない（MCID か NI margin か）。
  4. 結果として、読者（スポンサーの統計家・当局レビュアー）が得る情報は「W1 の大小の順」以上のものにならず、本論文の売りである臨床較正の有用性が例示で立証されていない。
- **修正案**:
  - 応用例の L_UB を、原稿が既に持っている情報から**「全体効果が消える／反転しない」水準**（例: Δ_max が全体効果 ≈ 0.9 %pt 未満となる L）の側から**逆算した値**も併記し、「L_UB がどの範囲なら各パートナーの Δ_max が全体効果を超えるか」を一つの図（x 軸 L、y 軸 Δ_max、横線に全体効果）で示す。これは既存の W1 推定値の算術であり、新しいシミュレーションは不要。
  - 単調 CATE 版（eq. mono_bound）の係数を Table に列として併記する（既に比 `monoRatio*` を計算済み）。
  - Δ_clin の選択根拠を 1 文（何の margin か）で述べる。
  - 「この bound は保守的な上界であり、全体効果を超える場合は『何も保証しない』と読む」旨を明示する。これは判定規則の追加ではなく読み方の記述（quantify, not decide に抵触しない）。
- **完結性**: 原稿内で完結（既存の数値の再配置と図 1 枚。追加解析なし）。ただし図の追加はページ増なので、Table 8 の整理（P-S2 参照）とトレードオフ。

### P-2 [Major] 「誰が・いつ・何を入力に・何のソフトで計算するか」が書かれていない（実装可能性）
- **該当**: §5 の "Because $W_1$, like other covariate-distribution measures, requires only baseline effect modifier distributions…"（唯一の運用記述）、Data availability statement（"available at [repository URL]"）、Appendix "R Code for $W_1$ Computation"。
- **問題**:
  1. 入力が**個別データ（IPD または少なくとも地域別の周辺 CDF）**であること、集計データ（平均・SD・分位点）では不十分であること、が明示されていない。計画段階では多くの場合、手元にあるのは公表論文の Table 1（平均 ± SD）か、過去試験の IPD（自社試験のみ）であり、**IPD が無いとき W1 は計算できない**。分位点だけ（四分位）から近似する方法があるかも言及がない。
  2. 時点が曖昧: 計画段階（RWE/過去試験で候補地域を評価）なのか、試験実施中の盲検下の baseline データ（治療割付は不要で、盲検を損なわない）なのか、解析時（最終解析前の地域プーリング決定）なのか。**baseline 分布のみで計算でき、割付情報も転帰も要らないので盲検下で実施可能**という実務上の大きな利点が書かれていない（実際、これは売りになる）。同時に、SAP に事前規定するなら何を規定すべき（候補 EM、reference 地域、B、乱数 seed、L_UB の出典、null floor の定義）かの一覧がない。
  3. コードは `[repository URL]` のプレースホルダで、R パッケージもない。付録の R コードは純 R の `replicate` + `ecdf` で、論文の応用（16 地域、N = 4 万級、15 パートナー × 2 EM × B=2000）を回す計算量の目安（秒/分）が示されていない。Study 2 は Rcpp を使っているのに付録は使っていない。
  4. 多数の候補 EM（実務では 5〜10 個）の扱いは「EM ごとに別々に」としかなく、多重の見せ方（P-4 参照）がない。
- **修正案**: §2（Estimation の後）か §5 に、5〜8 行の「Implementation in a statistical analysis plan」段落（または小さな表）を置く: 入力（IPD の baseline のみ、割付・転帰不要→盲検下可、連続 EM、地域サンプル）、計算（式 (eq:estimator)、B、seed）、SAP で事前規定する項目、必要な計算時間の実測値、パッケージ名。コードはレビュー時点で匿名リポジトリに置き、`[repository URL]` を実体化する。集計データしかない場合は計算不可である旨を限界に明記。
- **完結性**: 文章は原稿内で完結。計算時間の実測は小さな追加計測（既存コードの timing）、パッケージ化は原稿外作業。新しい統計解析は不要。

### P-3 [Major] 応用例の標本サイズと reference の置き方が、実際の MRCT の地域解析と乖離している（実例の説得力）
- **該当**: §4 冒頭 "We illustrate the per-effect-modifier Wasserstein-1 framework through a hypothetical scenario…"、Table `tab:gusto_nabcd`（パートナー n = 1231〜4352）、§3.2 Design（"samples of size $n = 50$, 100, and 200"）、§4.2 "The GUSTO-I distances are … SD of Region~8's distributions"。
- **問題**:
  1. 実際の MRCT で地域プーリングが問題になるのは、**日本・中国・韓国などの地域あたり 50〜300 例の世界**である。GUSTO-I の各地域は 1,200〜4,400 例で、W1 の bootstrap CI が 0.3〜1 年に収まるのはこの大標本のおかげ。Study 2 が n = 50〜200 を扱い、n = 100 でも CI が Δ_max でマージンの数倍（§3.2.2 で自ら認める）なのに、応用例は大標本で、**小標本での実際の見え方（null floor が大きく大半が unresolved になる等）が読者に見えない**。
  2. 実際の MRCT では比較対象は「単一 anchor 対 15 パートナー」ではなく、「注目地域（例: 日本）対 それ以外の全体（または全体）」や「地域 vs 試験全体」が普通である。anchor を選ぶ手順（"representing for instance a regulatory market"）は人為的で、**anchor の選択でランキングが変わることへの感度**が議論されていない。
  3. 地域が匿名化され、各地域の実際の治療効果差や臨床背景を検証できないため、「R2 と R9 の逆転」が臨床的に何を意味するかは読めない（これは原稿も認めているが、実務家には「で、どうなるのか」が残る）。
- **修正案**:
  - 既存の GUSTO-I データから、各地域を n = 100〜300 に層別でない無作為抽出して W1・null floor・unresolved 件数・L* 区間幅を再計算する**小標本版の応用**を本文に 1 表（または Table 6/8 の列）で加える。これは supplement ではなく本文数値で支える形（Tak の方針に整合）。ただし**新しい解析が必要**。
  - 「reference を単一 anchor にしたのは例示のため。実際には対象地域 vs 残り全体でも定義は同じ」旨を 1〜2 文。
- **完結性**: 小標本版は**新規解析が必要**（既存データの再抽出であり θ を置く効果追跡シミュレーションではない）。reference の注記は原稿内で完結。

### P-4 [Major] 既存の consistency 評価・ICH E17 慣行に対し「追加で何が分かるか」「どう並べて使うか」が書かれていない
- **該当**: §1 第 2 段落〜第 4 段落（Komiyama/Song の記述と gap 宣言）、§5 "The principal contribution…" 末文（"supplies a reproducible quantitative basis for the judgment of 'similar enough' that ICH E17 describes"）。
- **問題**:
  1. 現場の consistency 評価は、日本の Method 1/2 流の効果比・差の保持確率、地域×治療の交互作用検定、サブグループ forest plot、事前規定の効果差の信頼区間である。これらは**観測された効果**を見る。本手法は**ベースライン分布のみ**を見て、効果差の**最悪ケースの上界**を与える。両者の関係（baseline 分布の差が小さいのに観測効果差が大きい場合に何を意味するか／その逆）が一切論じられていない。実務家が最初に尋ねるのは「これで consistency が良いと言えるのか」「悪いのに分布は似ていたらどう解釈するのか」。
  2. ICH E17 の文脈（内因性・外因性要因）のうち、本手法が扱うのは内因性の baseline EM 分布だけで、外因性（標準治療・医療慣行）は Proposition 1 の「共通 CATE」仮定で外に置かれる。しかし**実際に地域差が出る最大の原因の一つが外因性要因**であることは、限界節で 1 文触れるだけで、実務上の使い所（どの場面で追加情報になるか）が不明確。
  3. 使う動機: 現状は計画段階の「どの地域を束ねてよいか／どの EM を層別因子にすべきか」の定量的支援が想定用途のはずだが、本文はその用途（例: 層別割付因子の選定、地域別症例数配分、プーリング案の事前規定）を一度も具体化しない。title の "for Regional Pooling" と本文の距離が大きい。
  4. 多数の EM・多数のパートナーで出る大量の W1・L* を、意思決定者にどう縮約して見せるか（EM 別の表を並べるだけ）が不明。
- **修正案**:
  - §5 に、「既存の consistency 評価との関係」の短い段落を追加: (a) 本手法は baseline 情報のみ・割付非依存（盲検下可）、観測効果に基づく評価を置換しない補完であること、(b) 分布が近い（Δ_max が小さい）のに観測効果差が大きい場合は外因性・測定・偶然を疑う手がかりになること（解釈の方向を述べるだけで判定はしない）、(c) 想定する具体的用途 2〜3 個（層別因子選定、地域別配分、事前規定のプーリング案の事前評価）。
  - 日本の評価方法等、実在する慣行への言及は一次文献を確認の上で行う（`🔍要根拠`: Method 1/2 の原典・DOI は私の記憶頼りなので書く前に原典確認が必要）。
- **完結性**: 原稿内で完結（文章追加）。観測効果との整合を実データで見せる解析（GUSTO-I の治療群を使い地域別の観測効果差と Δ_max を並べる）は**新しい解析が必要**で、「θ を置く効果追跡」に近づくため**制約に抵触するおそれ（別枠 §C 参照）**。本文は記述的な位置づけの追加にとどめる。

### P-5 [Major] 実務で最も多い EM 型（binary / ordinal / 欠測を含む / 測定差のある）が対象外または未議論で、適用範囲が実用上かなり狭い
- **該当**: §1 "We focus on continuous effect modifiers… categorical effect modifiers raise distinct considerations and are outside the present scope."、§5 "It treats continuous effect modifiers marginally, leaving categorical and multivariate extensions for future work"、§4.1 データ処理（SBP = 0、年齢 > 100、heaping）。
- **問題**:
  1. 実際の MRCT の EM 候補は、性別、前治療歴、バイオマーカー陽性、喫煙、重症度の ordinal 分類（NYHA、ECOG 等）など**離散型が過半**で、連続変数は年齢・体重・BMI・eGFR・HbA1c 程度。論文は離散型を除外する一方、導入部の事例（Matsushima の PREVENT 試験）自体が binary 特性（CRP、MRI 陽性、性別）の例である（原稿自身が "that case involved binary characteristics" と認める）。**自分の動機例に手法が適用されない**。
  2. binary EM では W1 = |p1 − p2|、ordinal では順序スコアが距離を決めるため W1 は等間隔スコアの選択に依存する、など**簡単に書ける特殊形**があるのに触れていない。Lipschitz 定数は binary なら τ(1) − τ(0) の絶対値で解釈でき、むしろ実務には扱いやすい。
  3. 欠測（baseline の欠測率が地域で異なる）の扱い、測定法・単位・キャリブレーションの地域差（検査機器、eGFR の式、血圧測定法）の影響がまったく議論されない。heaping は SBP で定量化されているが、系統的測定差は W1 に直接位置シフトとして入る（W1 は単位がそのまま効くので特に敏感）。
  4. 複数 EM が混在する場合の提示（P-4-4）。
- **修正案**:
  - binary と ordinal の特殊形（W1 = |p1 − p2|、順序スコア依存）とその Lipschitz 解釈を §2 に 3〜4 文で追加し、連続限定を緩める（適用範囲の拡張ではなく「閉形式で自明に含まれる」という整理）。ordinal のスコア選択は臨床判断とする。
  - 欠測と測定差を限界節に 2〜3 文（欠測は complete-case／多重補完のどちらで分布を作るか、地域間の測定差は W1 に直接加算されること）。
- **完結性**: 特殊形の導出と限界の追記は原稿内で完結（数式 1〜2 本、新規シミュレーションなし）。欠測・測定差の影響評価は**新規解析が必要**（行わない場合は限界として明記するのみにする）。

### P-6 [Major] 抄録・結論・title が示す「地域プーリングのための」有用性と、実際に評価された内容（Study 1 の oracle k 選択課題、Study 2 の推定性能）との間に距離がある（誇張・分かりにくさ）
- **該当**: Abstract（"In a selection simulation (matches supplied), …"）、§3 冒頭の "Study 1 evaluates identification…"、§3.1.1 Design の "supplying $k$ is itself an oracle that the application does not use"、§5 末 "supplies a reproducible quantitative basis for the judgment of 'similar enough'"、Title。
- **問題**:
  1. Study 1 の主結果は「真の一致地域数 k を与えた上での selection AUC」で、実務の意思決定（何地域をプールするか）を模擬していない。原稿はこの限界を明記しているが、abstract の 2 文目〜4 文目は `\numval` を含む 13 セル・10 セルの比較で占められ、**実務家が読み取れるのは「SMD が盲目な構成が存在する」ことだけ**である。それ自体は重要な結果なのに、セル数の集計（"11 of 13 (three by construction)"、"below 0.95 beyond Monte Carlo error in 5 of ten cells"）の中に埋もれている。
  2. 「W1 の方が KS より少ない患者数で足りる」は最終的に採用理由から外した（正しい判断）が、abstract にはまだ数が残り、読者に効率優位の印象を与える。
  3. 抄録冒頭の "the smallest slope L* at which the distance could produce a clinical margin is compared with a sponsor's bound" は、実務家には最初の一読で理解不能（L, Δ, W1 の関係を知らないと読めない）。1 文で「W1 に臨床スロープ L を掛けると効果差の上界になる」と言う方が通じる。
  4. §5 末の "reproducible quantitative basis for the judgment" は、P-1 のように読み取りが L_UB 任意性に支配される例示結果と比べると強い。
  5. 脚注の略語リスト、60 を超える `\numval` と登録プロトコル・探索的確認の事後開示が本文に大量に入っており、SIM の読者には**読解コストが非常に高い**（実務家は Study 1 設計の注釈だけで 3 ページ読む）。
- **修正案**: abstract を 3 つの message に再編: (i) W1×L の上界と L* の考え方（1 文）、(ii) SMD 盲目性が「構成上」ありうる（セル数集計は削る）、(iii) GUSTO-I で EM ごとに順位が異なり null floor で未分離のものがある。登録プロトコル・事後開示の詳細は本文でも 1 文に圧縮して「リポジトリ参照」にまとめる（既存の方針の延長）。§5 末の "basis for the judgment" を "a quantitative input to" に弱める。
- **完結性**: 原稿内で完結（文章整理）。

---

## Minor

### P-7 [Minor] W1 の数値を臨床家にどう説明するか（解釈可能性）
- **該当**: §2.2 "a regional $W_1 = 5$~mmHg in systolic blood pressure means that optimally transporting one distribution onto the other moves probability mass an average distance of 5~mmHg"。
- **問題**: 「質量を平均 5 mmHg 動かす」は輸送理論の語で臨床家には通じにくい。単位が元のスケールなのは長所だが、**その単位での大小の目安（EM の SD や臨床的に意味のある差）が示されない**ため、W1 = 0.4 年が大きいのか小さいのかは本文から読めない（GUSTO 全体で 0.4〜2.6 年、SBP で 1〜6.8 mmHg、これが年齢 SD ≈ 12 年・SBP SD ≈ 20 mmHg に対して何割か、は P-1 の図か表に参考列として入れられる）。
- **修正案**: 「位置のみがずれた場合 W1 = 平均差、同じ平均で SD が 1.5 倍なら W1 = 0.8×ΔSD（S5 の閉形式）」のように、馴染みのある 2〜3 パターンでの読み替えを 2〜3 文で添える。参照用に各 EM の anchor SD を表に載せる。
- **完結性**: 原稿内で完結。

### P-8 [Minor] 順位表示（Table 5）の実務での使い道と読みにくさ
- **該当**: Table `tab:gusto_nabcd`（Rank 列 "1--6$^\dagger$ [2, 10]"、脚注）、Figure 3、§4.3 "Several partners fall in the middle of each ranking…"。
- **問題**: 順位区間が [1,9] など広く、年齢では 6/15 が「同順位 1–6」に畳まれる。意思決定者にとって、順位は結局ほぼ使えない（読み取りは一部の極端なパートナーのみ）ことが本文にも表にも明確に出ていない。ダガー・順位範囲・括弧区間の三重記号は表の可読性を下げる。
- **修正案**: 表では順位を落とし、forest plot の並びだけで順序を示す。順位区間は本文 1 文または脚注に集約。「順位が使えるのは両端のみ」を 1 文で明示。
- **完結性**: 原稿内で完結（生成スクリプト `make_paper_tables.R` の列変更を含む）。

### P-9 [Minor] null floor の説明が統計家以外に通じにくく、「test ではない」と言いながら one-sided test の用語・多重性の議論が混在
- **該当**: §2.3 末尾 "Declaring a distance unresolved in this way is a one-sided test of $F_1 = F_2$ at level 0.05"、§4.2。
- **問題**: 実務側から見ると「推定中心」と宣言しつつ検定を使っている印象で説明が二重になる。30 本の検定を非調整で並べる点も、「Bonferroni 調整でも分類は同じ」の 1 文はあるが、実務家は「なぜ調整しない」を問う。
- **修正案**: "null floor = 同じ分布から 2 つの標本を取っても W1 が通常出る大きさ" と平易に 1 文定義し、"display rule であり pooling の判定ではない" を先に述べる。Bonferroni 調整でも結果が変わらない件を本文に出す（既に `nPermBonf` あり）。
- **完結性**: 原稿内で完結。

### P-10 [Minor] 盲検性・計算タイミング・SAP 事前規定との関係（P-2 の補足）
- **該当**: §5 の RWE 段落。
- **問題**: 「baseline のみで計算でき、割付情報不要」の利点が planning stage の RWE にしか触れられておらず、試験進行中の盲検下データでも使えること、SAP に何を書くかが未記述。
- **修正案**: P-2 に統合して 1〜2 文。
- **完結性**: 原稿内で完結。

### P-11 [Minor] 付録 R コードの実用性と参照実装
- **該当**: Appendix "R Code for $W_1$ Computation"。
- **問題**: `W1_bootstrap` は `replicate` + `ecdf` の毎回再計算で遅い。ties を含む SBP や 4,000 例以上では分単位になりうる。`wasserstein1d`（transport/ waddR 等）との突合や Rcpp 版を示さないと「論文のコードと実装が違う」ことになる。
- **修正案**: ソートベースの O(n log n) 実装（論文式 (estimator) と同じ）に差し替え、既存パッケージの出力との一致確認を 1 文。
- **完結性**: 原稿内で完結（小さな追加確認あり）。

### P-12 [Minor] ICH E17 の引用の仕方と規制当局の読み手
- **該当**: §1、§5 末 "that ICH E17 describes"。
- **問題**: 「E17 が similarity of effect modifier distributions で pooling を述べる」との記述が、E17 本文のどの節かを示さない（ページ・節番号）。規制当局の読者はそこを確認する。
- **修正案**: 節番号またはページを付す（原典確認要: `🔍要根拠`、私は確認していない）。
- **完結性**: 原稿内で完結。

### P-13 [Minor] 「事前規定された二つの EM」「Drug T」など設定の人為性
- **該当**: §4.1、"candidate effect modifiers for Drug~T, suggested by exploratory Phase~2 analyses"。
- **問題**: 架空の Phase 2 に依拠する設定は、読者に「作った話」の印象を与え、L_UB を 10 %pt/10 年とした根拠の弱さ（P-1）と重なる。
- **修正案**: 「例示のための設定」と一言で済ませ、Phase 2 の詳細は削る。
- **完結性**: 原稿内で完結。

---

## B. 実務家としての総合評価（Major の優先順位）

致命度の高い順: P-1（有用性が実例で示されていない）＞ P-3（標本サイズの乖離）＞ P-2（実装・運用の記述欠如）＞ P-4（既存慣行との接続）＞ P-5（適用範囲）＞ P-6（主張と読みやすさ）。P-2, P-4, P-6 は文章で直せる。P-1 は既存数値の再配置で直せる。P-3 のみ新しい（既存データの）解析が必要で、P-5 の一部（欠測・測定差の影響評価）も同様。

## C. 制約に抵触する提案（別枠・採用しない前提で記載）

実務家として「あれば確かに説得力が増す」が、Tak の方針（θ を置く効果追跡シミュレーション不可、supplement 不可、判定規則・閾値不可）に反するため、**原稿への反映は推奨しない**（参考として記録）。

1. **（θ を置く効果追跡）** GUSTO-I の治療群を使い、地域別の観測効果差と Δ_max（または W1）を並べて「分布差が小さい地域ほど効果差が小さいか」を見る、あるいは特定の CATE を置いたシミュレーションで Δ_max の有用性を検証する。**制約に抵触**。P-4 は記述的な位置づけの追加にとどめる。
2. **（閾値）** 「W1 が EM の SD の x 割以下なら poolable」「Δ_max < 全体効果の y %なら許容」といった目安を示す。**制約に抵触**（quantify, not decide）。P-1 は「読み方の記述」と「L の範囲ごとの Δ_max の曲線」に限り、合否ラインは書かない。
3. **（supplement）** P-3 の小標本版、P-5 の欠測影響評価、アルゴリズムの計算時間比較などを Supplement として切り出す。**制約に抵触**。本文の 1 表・数行で支えるか、書かない。
4. **（手続き推奨）** 「プーリング地域数は何個まで」「Δ_clin の決め方の標準手順」を示す。**制約に抵触**。

## D. 追加解析の要否まとめ

| ID | 内容 | 原稿内で完結 | 新しい解析 |
|---|---|---|---|
| P-1 | Δ_max を L の関数として図示、単調版係数を併記、Δ_clin の根拠 | はい | 不要（既存数値の算術） |
| P-2 | SAP 運用段落、計算時間、リポジトリ | 文章は可 | 計算時間の実測のみ |
| P-3 | 小標本版の応用、reference の注記 | 注記のみ可 | 必要（GUSTO-I の無作為抽出再計算、記述的） |
| P-4 | 既存 consistency 評価との関係の段落 | はい | 不要（観測効果との突合は §C-1 で不可） |
| P-5 | binary/ordinal の特殊形、欠測・測定差の記述 | はい | 影響評価は必要（行わないなら限界として記述） |
| P-6 | 抄録・結論の整理 | はい | 不要 |
| P-7〜P-13 | 表現・表示・コード | はい | 不要（P-11 は照合の小確認） |

## E. 確認が必要な点（`🔍要根拠`）

- 日本・中国当局の consistency 評価の実務（Method 1/2 等）の原典と DOI（P-4）。
- ICH E17 の該当節・ページ（P-12）。
- P-1 の L_UB と L* の位置関係の集計は、生成表の目視による。誤りがありうるため、`results/gusto_lstar_intervals.csv` で再確認してから使うこと。
