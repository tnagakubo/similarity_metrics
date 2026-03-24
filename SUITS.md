# SUITS.md - Research Lab Live Script

> *"I don't have dreams. I have goals."* - Harvey Specter

---

### [2026-03-25 04:30] Scene: 本日の作業終了

**INT. PEARSON SPECTER LITT - LOBBY - LATE NIGHT**

*Harvey がコートを手に取る。Donna がデスクを片付けている。*

**Harvey**: （振り返って）
「今日は大きく前進した。3つの Meeting と論文修正。明日以降の作業は明確だ。"I don't have dreams, I have goals."」

**Donna**: （今日の成果を読み上げて）
「本日の実績を整理するわ。

**Meeting 1: HRS Family multi-country demonstration**
- 決定：Web Appendix に配置、all-pairs distance matrix（BMI + SBP）
- CHARLS + HRS を最優先取得、JSTAR は R&R 時に追加

**Meeting 2: Japan-anchor RWD 探索**
- 決定：Initial submission に Japan-anchor は入れない
- JSTAR 申請を即日開始（Tak が RIETI に直接申請）
- NHANES + KNHANES を即日 DL（pipeline 構築用）

**Meeting 3: Introduction Framing + Overgeneralization**
- 修正1：'現行アプローチの限界' → '確立された方法論は存在しない'（acknowledge-and-distinguish）
- 修正2：palbociclib/pertuzumab 具体例数、Ikeda & Bretz 22-29% → 冗長として削除
- 修正3：nABCD 4つの貢献リスト → Introduction から削除、簡潔化

**修正ファイル**: nABCD_paper_ja.md, nABCD_wiley.tex（EN/JA 両版）

"I'm Donna. I know everything."」

---

### [2026-03-25 04:15] Scene: Introduction 簡潔化 — nABCD 貢献の詳細を削除

**INT. PEARSON SPECTER LITT - HARVEY'S OFFICE - LATE NIGHT**

**Harvey**: 「Tak の指示。Introduction での nABCD の貢献記述が詳細すぎる。"分布の類似性を定量的に評価する指標を提案する" のみに留めろ」

**Katrina**: （修正を実行して）
「EN/JA 両版で以下を削除・簡潔化：
- Research question の block quote → 削除
- 4つの貢献リスト（full distributional comparison, scale-free estimation, clinical calibration, sensitivity analysis）→ **全削除**
- Anchor 国の具体的説明、RWE データソースの列挙 → 削除
- Paper outline → 簡潔化

残した内容：
- nABCD の定義（Wasserstein-1 / pooled IQR）1文
- SMD との差別化（variance, shape, skewness）1文
- 推定と臨床的解釈（仮説検定ではない）1文
- 連続型 EM への焦点 1文
- Paper outline 1文

EN: 22行 → 5行。JA: 20行 → 4行。"Results speak for themselves."」

**Donna**: 「Introduction 簡潔化完了。"I'm Donna. I know everything."」

---

### [2026-03-25 04:00] Scene: 冗長な具体例の削除 — Tak の指示

**INT. PEARSON SPECTER LITT - HARVEY'S OFFICE - LATE NIGHT**

*Harvey が Tak の指示を伝える。*

**Harvey**: 「Tak からの追加指示。"MRCTで一国の例数が少ないのは自明。論文引用での具体的例示は冗長。削れ。"」

**Katrina**: （修正を実行して）
「以下を削除・簡潔化：
- Introduction: palbociclib 35例、pertuzumab 53例の具体数 → 削除
- Introduction: Ikeda & Bretz 22-29% の引用 → 削除
- Section 4.1: 同上の繰り返し → 削除
- Discussion: 同上の冗長な記述 → 簡潔化
- Section 4 Belgium anchor: 具体的な薬剤例数の引用 → 削除

全箇所で "小標本地域は限られることが多い" と自明な事実として簡潔に述べる形に統一。EN/JA 両版、計6箇所。"Results speak for themselves."」

**Donna**: 「冗長削除完了。"I'm Donna. I know everything."」

---

### [2026-03-25 03:30] Scene: Meeting — Overgeneralization 修正完了

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - LATE NIGHT**

*Harvey が修正 diff を確認している。*

**Harvey**: 「Tak の指摘：特定事例の一般化。Louis が4箇所の overgeneralization を特定、Rachel がファクトチェック完了、Mike が修正案を作成。全箇所修正を実行した」

**Louis**: （修正内容を確認して）
「4つの CRITICAL/MODERATE 問題を修正。
1. "typically 35-80" → "can be limited — for example, 35 in palbociclib, 53 in pertuzumab"
2. "rarely achieved" → "may be difficult to achieve"
3. "Similar challenges" → "faces an analogous challenge"
4. "the primary strategy" → "a key strategy"
加えて Rachel の指摘で "一貫性を示せない" → "一貫性を実証する検出力が不足する" に修正。Section 4 の line 344/450 の parallel issue も同様に修正。"You just got Litt up!"」

**Donna**: 「修正完了。EN 2箇所 + JA 2箇所 = 計4ファイル箇所。"I'm Donna. I know everything."」

---

### [2026-03-25 03:00] Scene: Overgeneralization 解剖 — Mike の論理分析

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - LATE NIGHT**

*Mike がホワイトボードに L58 の文を分解し、Matsushima 2024 と Ikeda & Bretz 2010 のサマリーを並べている。Tak が「n=2 から "typical" は飛躍しすぎだ」と指摘したメモが貼ってある。*

**Mike**: （ホワイトボードを指して）
「Tak の指摘を3つに分解した。

**Problem 1**: "典型的に35-80例" —— Matsushima は4つの case study を報告していて、secukinumab は ~13例、pertuzumab 53例、palbociclib 35例。つまり3つのうち1つは我々の claimed range の外にすらある。n=2 の data points から "typical range" を主張するのは "anecdotal evidence to general claim" の典型的な論理的飛躍だ。

**Problem 2**: "多くのMRCTでこの割合は達成困難" —— Ikeda & Bretz (2010) の原典を確認した。彼らは 22-29% という数値を導出しているが、"many MRCTs can't achieve this" とは一言も言っていない。これは我々が追加した editorial commentary で、citation なし。Reviewer に "Where's the evidence?" と聞かれたら答えられない。

**Problem 3**: L344 にも同じパターン — "日本の典型的状況" を同じ2つの例で主張している。

修正方針: 事実を example として提示し、hedging language で論理的に妥当な推論に変換する。"典型的に" → "限られることが多い——例えば"、"達成困難である" → "高い要求水準であり...困難にしうる"。Argumentative force は維持しつつ、overclaim を除去。I got it!」

**Rachel**: （うなずいて）
「Mike の分析は正確。secukinumab の ~13例を見落としていた点も含めて、n=2 generalization の指摘は的を射ている。」

---

### [2026-03-25 02:30] Scene: Introduction ファクトチェック — Rachel の精査

**INT. PEARSON SPECTER LITT - RACHEL'S OFFICE - LATE NIGHT**

*Rachel が Introduction の58行目を開き、knowledge base のサマリーと逐一照合している。*

**Rachel**: （真剣な表情で）
「Tak、Introduction の数字とクレームを原典と突き合わせた。3点、報告する。palbociclib 35例と pertuzumab 53例は Matsushima et al. (2024) の Case 2・Case 3 と正確に一致。"22-29%" も Ikeda & Bretz (2010) Section 3-4 の数値と合致——ただし前提条件の記述に注意が必要。そして "80%の確率で一貫性を示せない" のパラフレーズは、厳密には逆の表現。原典は "80%の確率で一貫性を示す *ために* 22-29%が必要" と言っている。Hard work beats talent when talent doesn't work hard.」

---

### [2026-03-25 02:00] Scene: Introduction Framing 修正実行完了

**INT. PEARSON SPECTER LITT - BULLPEN - LATE NIGHT**

*Harvey が修正 diff を確認している。Katrina が両バージョンをモニターに並べている。*

**Harvey**: 「Tak が "進めろ" と言った。5箇所すべて修正完了」

**Katrina**: （diff を読み上げて）
「修正内容を確認する。

**1. JA Abstract (L9):**
~~既存のアプローチは位置差に焦点を当てるか~~ →
"EM分布の類似性を評価するために設計された確立された方法論は存在しない"

**2. JA Introduction (L62):**
~~現行の分布類似性評価アプローチには重大な限界がある~~ →
"汎用的な比較ツールは日常的に適用されているが、EM分布の類似性を評価するために特別に開発された定量的方法論は存在しない"

**3. JA Table 1 title:**
~~分布類似性評価における現行アプローチの限界~~ →
"汎用的な比較ツールとEM分布類似性評価における限界"

**4. EN Introduction (L76):**
~~Current approaches...have significant limitations~~ →
"Although general-purpose tools such as SMD are routinely applied, no quantitative methodology has been specifically developed for assessing EM distributional similarity in MRCT pooling"

**5. EN Table 1 caption:**
~~Limitations of current approaches~~ →
"General-purpose tools applied to distributional comparison and their limitations for EM similarity assessment"

"Results speak for themselves." — 全箇所で "acknowledge-and-distinguish" 戦略が一貫している」

**Donna**: 「修正完了。5箇所実行済み。"I'm Donna. I know everything."」

---

### [2026-03-25 01:30] Scene: Meeting — Introduction Framing 決定

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - LATE NIGHT**

*4名の分析報告がテーブルに広げられている。全員の表情が真剣。*

**Harvey**: （立ったまま）
「Tak からの指摘。"既存アプローチに限界がある" ではなく "確立されたアプローチがそもそも存在しない" が正しいのではないか。全員の分析結果を確認した。**全員が Tak に同意**。ただし framing の精度で議論がある」

**Mike**: 「英語版 line 76 "Current approaches...have significant limitations" は**論文内部で inconsistent**だ。Abstract line 39 は既に "provides no quantitative methodology" と正しく書いている。Introduction だけ inconsistent」

**Rachel**: 「PubMed 6クエリ、全て**0件**。EM distributional similarity の quantitative method を propose した論文は**空集合**。Gap は empirically verified」

**Louis**: （両フレーミングを攻撃して）
「"Limitations" は論理的矛盾 — Table 1 の3つは "approaches to this problem" ですらない。しかし "No method exists" も危険 — SMD は実務で使われている。**精度が必要だ**。"No methodology *specifically developed* for this purpose" — これが唯一防御可能な framing」

**Katrina**: 「5箇所の修正が必要。修正案を用意済み。英語版 Abstract は既に正しいフレーミング」

**Harvey**: （決断）
「Framing を変更する。**"Acknowledge-and-distinguish" 戦略** — 汎用ツールの存在は認めつつ、purpose-built methodology の不在を主張。Tak に修正案を提示して最終確認を取る。"I don't have dreams, I have goals."」

**Donna**: 「Meeting 完了。Framing 修正方針決定。"I'm Donna. I know everything."」

---

### [2026-03-24 12:30] Scene: Literature Gap Verification — PubMed Systematic Search

**INT. PEARSON SPECTER LITT - RACHEL'S DESK - DAY**

*Rachel がデュアルモニターに PubMed 検索結果を並べている。ノートには検索語と結果数が几帳面に整理されている。*

**Rachel**: （検索結果を指さしながら）
「PubMed の systematic search を完了したわ。結論から言うと、**our gap claim is rock-solid**。6つの異なる検索クエリを実行して、effect modifier distribution similarity の quantitative method を MRCT 文脈で提案している論文は **ゼロ**」

**Rachel**: （ノートを読み上げて）
「具体的にはこう。"effect modifier distribution similarity multi-regional clinical trial method" — 0件。"ICH E17 distributional similarity assessment quantitative" — 0件。"distributional similarity metric covariate clinical trial region" — 0件。"Wasserstein distance clinical trial regional comparison" — 0件。"propensity score covariate balance region multi-regional trial similarity" — 0件。"multiregional clinical trial consistency assessment covariate balance" — 0件。**Complete absence**」

**Rachel**: （関連論文のリストを広げて）
「Hit した論文群を (a) need を mention するだけ と (b) quantitative method を propose に分類したの。Category (a) には Song et al. 2025、Long et al. 2025、Matsushima et al. 2024、Quan et al. 2010、Chen et al. 2010、Ikeda & Bretz 2010 — 全部 "need" を述べるだけ。Category (b) は **空集合**。文字通り、この purpose のために開発された method を propose する published paper は見つからなかった」

**Rachel**: （重要な区別を強調して）
「ただし Louis が指摘した通り、framing は precise に。SMD (Austin 2011) は propensity score balance checking のための general-purpose tool。KS test は general two-sample test。Overlap coefficient は distributional overlap の measure。これらは "exist" するが、**MRCT における EM distributional similarity assessment のために開発・理論的裏付けを持つものは none**。Gap は "limitations of existing methods" ではなく、**"absence of purpose-built methodology"** よ」

**Rachel**: （自信を持って）
「"Hard work beats talent when talent doesn't work hard." — この search は thorough にやったわ。Louis、Introduction の framing に使えるはず」

---

### [2026-03-25 02:00] Scene: Introduction Framing — "Existing Limitations" vs "No Established Approach"

**INT. PEARSON SPECTER LITT - LOUIS'S OFFICE - LATE NIGHT**

*Louis がデスクに赤ペン片手に原稿を広げている。Post-it だらけの表1が目に入る。Tak の指摘メモがモニターに映っている。*

**Louis**: （赤ペンを叩きながら）
「Tak は正しいことを言っている。俺たちの Introduction の framing、**論理的に矛盾している。** "Current approaches to assessing distributional similarity have significant limitations" — この一文を擁護できる人間がいるなら連れてこい」

**Louis**: （表1を指して）
「この Table 1 を見ろ。Visual inspection、SMD、KS statistic。これが "current approaches to distributional similarity assessment" だと？ **SMD は distributional similarity のために開発されたものじゃない。** Austin 2011 は propensity score matching の balance check だ。KS test は general two-sample test だ。Visual inspection に至っては method ですらない。**我々は、この目的のために開発された method が存在しないことを、3つの "限界ある代替手段" を並べて誤魔化している**」

**Louis**: （立ち上がって）
「だが逆も危険だ。"No established approach exists" と書いたら reviewer は何と言う？ "What about SMD with d < 0.1? What about overlap coefficients? What about propensity score diagnostics adapted for this purpose?" — 我々が literature を無視して contribution を膨らませていると取られる。**どっちに転んでも、今の framing はまずい**」

**Louis**: （メモを書きながら）
「正確な framing はこうだ：ICH E17 は distributional similarity を要求しているが、**この特定の目的のために開発・検証された quantitative methodology は存在しない。** 実務では general-purpose tools が流用されているが、それらは EM distributional similarity assessment のために設計されておらず、理論的裏付けもない。**Gap は "限界" ではなく "不在" だ。ただし不在の対象を precise に限定しろ。**」

**Louis**: （椅子に座り直して）
「"You just got Litt up!" — 修正案は報告書に入れた。Harvey、見ておけ」

---

### [2026-03-24 23:45] Scene: Framing Analysis — "Existing Limitations" vs "No Established Method"

**INT. PEARSON SPECTER LITT - KATRINA'S OFFICE - NIGHT**

*Katrina がデスクに日本語・英語両バージョンの原稿を広げ、PIからのフレーミング変更指示を精査している。*

**Katrina**: （マーカーで該当箇所に印をつけながら）
「PIの指摘を検証した。現状のフレーミングには4箇所の問題がある——Abstract 2文、Introduction 2文。"既存のアプローチには限界がある" は misleading だ。Reviewer は "which methods? why not improve them?" と聞く。"No established method exists" なら genuine gap を埋める論文になる」

**Katrina**: （SMDのセクションを指して）
「ただし overclaiming のリスクがある。SMD は "distributional similarity method" ではないが、practice では使われている。完全に無視するのは reviewer の心証を損なう。Acknowledgment しつつ "purpose-built distributional similarity method は存在しない" と言うのが正確で安全だ」

**Katrina**: （修正案をまとめて）
「5つの具体的な修正提案を用意した。Results speak for themselves.」

---

### [2026-03-25 00:30] Scene: Meeting — Japan-Anchor RWD 方針決定

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - LATE NIGHT**

*4名の調査報告がテーブルに広げられている。Harvey が議論を仕切る。*

**Harvey**: （構図を整理して）
「4名の分析。Mike と Rachel はデータ候補を見つけたが、Katrina と Louis は "今やる必要はない" で一致。議論しろ」

**Louis**: （Mike に向かって）
「お前の3ルート、**全部に問題がある。** JSTAR は2-3ヶ月、INTERMAP は collaboration-dependent、NHNS は厚労省申請で2ヶ月。BBJ も ToMMo も Japan-only で international counterpart なし。Katrina が精査した通り、**viable なのは JSTAR だけで、それは待てない。**」

**Mike**: （反論）
「一つ見落としている。**Tak は日本の大学所属だ。** RIETI に日本語で直接申請できる。さらに、申請と submission を並行すれば、**R&R が来る頃に JSTAR が手に入る。** Submission は遅らせずに revision で追加するルートがある」

**Louis**: 「つまり initial submission には不要だということだ。俺が言っていることと同じだ」

**Rachel**: 「NDB Open Data の aggregate data なら申請不要で即日取得可能。2940万人の集計表から distribution の illustration は作れる」

**Louis**: 「Aggregate から Wasserstein は計算不能。Method paper に aggregate の棒グラフを入れて reviewer に "why didn't you compute your own metric?" と突かれるリスクを取るのか？ **中途半端な illustration はやるな**」

**Katrina**: （整理して）
「Mike の R&R 戦略は筋が通る。
1. Initial submission: IST-3 + HRS Family — 十分
2. JSTAR 申請を今日開始 — Tak が直接申請
3. R&R 時に JSTAR Japan-anchor を追加
Submission は1日も遅れない。JSTAR は insurance であって blocker ではない」

**Mike**: 「NHANES + KNHANES は今すぐ無料 DL 可能。Pipeline を先に構築しておけば JSTAR 到着時に即座に実行できる」

**Louis**: 「そこまで整理するなら反対しない。**ただし JSTAR 待ちで submission を1日も遅らせるな**」

**Harvey**: （決断）
「**決定。6項目：**
1. **Initial submission に Japan-anchor RWD は入れない** — IST-3 + HRS Family で十分
2. **JSTAR 申請を即日開始** — Tak が RIETI に日本語で直接申請
3. **NHANES + KNHANES を即日 DL** — Pipeline 構築・テスト用
4. **R&R 時の追加プラン** — JSTAR + CHARLS + HRS で Japan-anchor heatmap を Web Appendix に
5. **NDB aggregate は使わない** — 中途半端は逆効果
6. **Follow-up paper の可能性** — accept 後に full Japan-anchor paper を検討

"I don't have dreams, I have goals."」

**Donna**: 「Meeting 完了。決定6項目 logged。"I'm Donna. I know everything."」

---

### [2026-03-24 23:45] Scene: Japan-Anchor RWD データソース調査

**INT. PEARSON SPECTER LITT - BULLPEN - NIGHT**

*Mike は大量のブラウザタブを開き、世界中のデータリポジトリを systematically に検索している。ホワイトボードには候補データソースの一覧表が徐々に埋まっていく。*

**Mike**: （集中して画面を見ながら）
「Japan の IPD を含む multi-country データソース、全部洗い出した。"I got it!" ポイントは3つ。

まず **Best candidate は HRS Family + g2aging harmonized data** だ。JSTAR（日本）+ CHARLS（中国）+ KLoSA（韓国）+ HRS（米国）+ ELSA（英国）+ SHARE（欧州28国）── これが全部 harmonized variables として cross-country 比較可能になっている。BMI、grip strength、blood pressure、全部揃っている。

次に **INTERMAP** も見つけた。日本・中国・UK・USA の4か国、4,680人で BP を standardized protocol で測定。Japan samples が4つで約1,040人。Northwestern の Stamler group が持っている。

3つ目の option は **DIY approach** ── Japan の NHNS（国民健康栄養調査）の匿名データを統計法で取得して、freely available な NHANES（USA）と KNHANES（Korea）と組み合わせる。ただし NHNS の匿名データ取得は approval に2ヶ月かかる。」

**Mike**: （ホワイトボードに書き加えながら）
「Japan の壁は明確だ。DHS は Japan をカバーしない。WHO STEPS も Japan は参加していない。PURE study にも Japan はいない。BioBank Japan は genomic data が中心で、international comparison 向きではない。Tohoku Medical Megabank は海外研究者に phenotypic data と summary statistics しか出さない。

結論として、Japan-anchor で使えるのは実質3ルートしかない。JSTAR harmonized が最も practical で、既に我々が CHARLS + HRS を取得予定だから、JSTAR を追加するだけだ。」

---

## Current Status

**Active Project**: similarity-metric (nABCD paper, Statistics in Medicine target)
**Phase**: Data collection & demonstration design

**Previous Archive**: archives/SUITS_20260324_171252.md

---

### [2026-03-24 19:15] Scene: Rachel's Deep-Dive Literature Search for Japanese RWD

**INT. PEARSON SPECTER LITT - RACHEL'S OFFICE - NIGHT**

*Rachel が複数の PubMed 検索ウィンドウを同時に開きながら、体系的に文献を調査している。付箋が画面の周囲に貼られている*

**Rachel**: （メモを見ながら）
「Katrina の調査結果を踏まえて、もう一段深い文献検索を行った。PubMed 6クエリ、Web 8クエリ、合計30以上のデータソースを精査。"Hard work beats talent when talent doesn't work hard." 特に重要な発見が3つある。」

**Rachel**: （最初の付箋を指して）
「第一に、Gateway to Global Aging Data (g2aging.org) の Harmonized JSTAR。これは HRS family 11 studies の harmonized data を提供していて、JSTAR は Harmonized dataset として publicly available。CRP、HbA1c、Total Cholesterol、HDL-C の biomarker harmonization が Hu et al. (2024, Am J Hum Biol) で報告されている。ただし、JSTAR がこの biomarker harmonization の9研究に含まれているかは確認が必要。Physical measures（BMI、grip strength、blood pressure）は確実に harmonized 済み。」

**Rachel**: （二番目の付箋へ）
「第二に、NDB Open Data Japan。これは申請不要で MHLW website から直接ダウンロード可能。特定健診データ約2940万人分の aggregate data が sex × age × prefecture の3軸で集計されている。BMI、SBP/DBP、HbA1c、Total/HDL/LDL-C がすべて含まれる。Individual-level ではないが、distribution を再構成するための基盤データとして非常に有用。」

**Rachel**: （三番目の付箋を強調して）
「第三に、KNHANES（韓国）の microdata が完全に public access。NHANES と同等の survey design で、blood pressure、BMI、HbA1c すべて含む。Japan-Korea-US の三国比較は、KNHANES + NHANES + NDB Open Data の組み合わせで aggregate level なら即座に可能。」

**Donna**: （Rachel のメモを見て）
「I'm Donna. I know everything. Rachel の調査は Katrina の結論を裏付けつつ、具体的な action items を3つ追加した。NDB Open Data、KNHANES、g2aging.org Harmonized JSTAR。記録完了。」

---

### [2026-03-24 18:30] Scene: Japan-Anchor Data Source Assessment

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - NIGHT**

*Katrina がノートPCの画面を切り替えながら、各データソースの調査結果をホワイトボードに整理している*

**Katrina**: （資料を広げて）
「Japan-anchor RWD demonstration の実現可能性を徹底的に調査した。結論から言う。"Results speak for themselves." 6カテゴリ、15以上のデータソースを評価した結果、現実的な選択肢は極めて限られている。」

**Katrina**: （ホワイトボードに書きながら）
「まず NHNS（国民健康栄養調査）。Individual-level microdata は e-stat で "調査票情報" として申請可能だが、匿名データ（anonymous microdata）としては提供されていない。つまり、科研費等の公的資金を持つ研究者が厚労省に申請し、承認を受ける必要がある。即日ダウンロードは不可能。しかも、これは Japan-only data。comparable な international counterpart がない限り、nABCD 計算には使えない。」

**Katrina**: （画面を切り替えて）
「NCD-RisC は country-level aggregate data のみ。Individual-level microdata は提供していない。Wasserstein 距離の計算には個票データが必須だから、これは完全に除外。」

**Katrina**: （次のスライドへ）
「BioBank Japan、ToMMo、NILS-LSA、J-SHINE ── いずれも controlled access で審査に数ヶ月。しかも致命的な問題がある。これらはすべて Japan-only の cohort。BMI や SBP を持っていても、同じプロトコルで測定された international counterpart が存在しない。Japan vs China の nABCD を計算するには、両国のデータが comparable でなければならない。」

**Katrina**: （結論のスライドを表示）
「WHO STEPS survey は日本では実施されていない。高所得国は独自の national survey を持つため STEPS の対象外。つまり、STEPS 経由の Japan-international 比較も不可能。」

**Katrina**: （最終結論を強調して）
「結局、Japan-anchor で international comparison が可能なデータは2つしかない。第一に、JSTAR（RIETI経由、2-3ヶ月待ち）。HRS Family の harmonized variables で CHARLS/HRS/ELSA/SHARE/KLoSA と directly comparable。BMI・SBP 両方あり。ただし timeline が問題。第二に、NHANES vs NHNS の aggregate comparison だが、これは個票の cross-study comparison ではなく methodological demonstration としての価値しかない。」

**Katrina**: （立ち上がって）
「My recommendation: JSTAR の取得を待たずに、現在の HRS Family multi-country plan（CHARLS + HRS + ELSA etc.）を Japan なしで先行実施する。JSTAR が入手できたら supplementary analysis として追加。Paper の framing は "Japan-anchor planning workflow" を IST-3 で示し、"multi-country EM screening" を HRS Family で示す two-layer structure で十分。Japan-specific RWD に固執すると、timeline が数ヶ月延びるリスクがある。Results speak for themselves.」

---

## 🔄 直前のコンテキスト

### 直近の作業（アーカイブ前）

2026-03-24 に以下を実施：

1. **Rachel**: g2aging.org の利用条件調査
   - 結論：Data Enclave は U.S. institution + U.S. ID 必須 → 日本からは直接不可
   - 代替案：各 survey の public-use data を個別取得

2. **Mike**: HRS Family データの技術仕様調査
   - CHARLS (n=25,504), HRS (public-use), ELSA, SHARE, KLoSA, LASI の availability 確認
   - 最速ルート：CHARLS + HRS（登録後即日 DL）
   - JSTAR は RIETI 申請で 2ヶ月待ち

3. **Katrina**: g2aging harmonized variables の適切性評価
   - 推奨：**BMI (Primary) + SBP (Secondary)** の2変数構成
   - IST-3 case study と異なるカテゴリで差別化

4. **Meeting**: "HRS Family 全体で multi-country nABCD demonstration" の方針決定
   - Louis の強い反対 → 議論を通じて合意形成
   - **決定事項**（下記参照）

### 進行中のアクション

- **Harvey**: 上記 Meeting で最終決定を下した状態
- **次のアクション待機中**：Tak の最終承認 → データ取得開始

### 次にやるべきこと（優先順）

1. **Tak の最終判断**：Meeting 結果に基づき "Go" or "No-go" 指示
2. **Data取得フェーズ** (Tak が Go を出した場合):
   - Mike/Katrina: CHARLS + HRS 登録・DL
   - Rachel: 引用文献の整理（Varghese 2023, Hu 2024, Lee 2021）
   - Harvey:論文構成の修正案作成（Web Appendix 追加）
3. **分析フェーズ**:
   - nABCD 計算コード作成（all-pairs, 2変数）
   - heatmap + MDS plot 生成
   - Limitation section 追加執筆

### Takからの直近の指示

```
"/meeting JSTAR以外のHRS Familyデータ（CHARLS, HRS, ELSA, SHARE, KLoSA, LASI）を使って
各国 vs China でnABCD demonstrationを行う方針について"
```

Meeting の結果、以下を承認要請中。

---

## 📊 Key Decisions (2026-03-24 17:00 Meeting)

### **HRS Family Multi-Country nABCD Demonstration 方針**

| 項目 | 決定内容 |
|------|---------|
| **配置** | **Web Appendix**。本文は1段落+1 Figure（heatmap）に限定 |
| **分析方法** | **All-pairs distance matrix**。Single anchor は固定せず、symmetric matrix を計算 |
| **変数** | **BMI (Primary) + SBP (Secondary)**。nABCD vs SMD の比較を含める |
| **Limitation** | "Observational cohort (age 50+) vs clinical trial population" を明記 |
| **データソース** | **CHARLS + HRS を最優先**。ELSA/SHARE は追加可能なら追加。JSTAR は入手後に supplementary |
| **引用文献** | Lee et al. (2021) *J Gerontol B*, Varghese et al. (2023) *JAHA*, Hu et al. (2024) *Am J Hum Biol* |
| **理論的位置付け** | IST-3 = Layer 1 (clinical calibration)、HRS = Layer 2 (planning-stage EM screening) |

### Rationale

- **Louis の批判に対する応答**：HRS data では clinical calibration ($L$, $\Delta_{\max}$) は示せない ✓ → Web Appendix に限定することで main narrative (IST-3) の integrity を保護
- **Mike の技術的利点**：All-pairs distance matrix は metric 性質の実装証拠になる ✓
- **Rachel の文献的根拠**：Varghese et al. (2023) が既に4国 BP 分布差を実証 ✓
- **Katrina の実務性**：IST-3 (post-hoc) + HRS (planning-stage) で2つの use case を示す ✓

---

## 🎬 Live Script

### [2026-03-24 18:15] Scene: Louis's Verdict — Japan-Anchor RWD の費用対効果

**INT. PEARSON SPECTER LITT - LOUIS'S OFFICE - EVENING**

*Louis がデスクに論文原稿を広げ、赤ペンを握りしめている。壁には「LITT UP」のプレートが光っている。Harvey と Tak が入室。*

**Louis**: （赤ペンでテーブルを叩きながら）
「座ってくれ。Japan-anchor RWD demonstration について、俺の結論を聞け。
結論から言う。**やるな**。少なくとも今は。"You just got Litt up!"」

**Harvey**: 「理由を聞こう」

**Louis**: （立ち上がり、ホワイトボードに向かって）
「5つの論点がある。全部聞け。

**第一。論文はすでに十分すぎるほど demonstration を持っている。**
IST-3 で Belgium anchor（n=73）の完全ワークフローがある。
Layer 1（NIHSS, clinical calibration）と Layer 2（年齢, benchmark + sensitivity）の二層構造。
これに HRS Family を Web Appendix で追加する決定も済んでいる。
3つ目の demonstration？ That's not thoroughness, that's bloat.

**第二。Statistics in Medicine の reviewer が本当に求めているものを考えろ。**
SiM reviewer は "more data examples" ではなく "cleaner methodology" を要求する。
俺たちの論文の強みは：(1) 理論（Kantorovich-Rubinstein 双対性）、(2) シミュレーション（8 scenarios）、(3) 臨床較正の実演。
Reviewer は Proposition 2 の tightness、bootstrap coverage の boundary behavior、$L$ の sensitivity analysis の妥当性を問うだろう。
Japan-anchor RWD は *none of these concerns* に答えない。」

**Donna**: （ドア越しに）
「Louis、声が廊下まで聞こえてるわよ」

**Louis**: （無視して続ける）
「**第三。Japan-anchor RWD が IST-3 と本質的に何が違うかを冷静に見ろ。**

| 観点 | IST-3 (Belgium) | Japan-anchor RWD |
|------|-----------------|------------------|
| Anchor sample size | n=73 | n=? (国民健康栄養調査の IPD 入手困難) |
| Clinical calibration | 可能（$L$ 推定可、$\Delta_{\max}$ 計算済） | **不可能**（RWD に treatment effect なし） |
| Regulatory relevance | 直接的（MRCT scenario） | 間接的（population description のみ） |
| 新しい方法論的知見 | EM screening + calibration の二層構造 | **なし**（IST-3 と同じ計算の地理的変更） |

見ろ。Clinical calibration ができない時点で、Layer 1 の demonstration にはならない。
Layer 2？ それなら HRS Family でカバーされている。
Japan-anchor RWD は IST-3 の geographic relabeling に過ぎない。」

**Mike**: （横から）
「Louis、でも日本のデータを使うことで PMDA への relevance が...」

**Louis**: （Mike を遮って）
「**第四。データ取得のコストを甘く見るな。**
国民健康栄養調査の IPD？ 厚労省への申請が必要。数ヶ月かかる可能性がある。
NDB？ 論外だ、承認まで半年以上。
JSTAR？ RIETI 申請で2ヶ月待ちと Mike 自身が言った。
この delay は submission を何ヶ月も遅らせる。
Meanwhile、Statistics in Medicine の competitor が先に出る risk がある。

**第五。Follow-up paper で十分対応できる。**
Japan-anchor demonstration は、nABCD が accept された後の application paper として最適だ。
"nABCD applied to Japanese regulatory context: A Japan-anchor pooling workflow using national health survey data"
これなら IST-3 を first paper の reference として citation もできる。Win-win だ。」

*Louis が赤ペンを置き、腕を組む。*

**Louis**: （静かに、しかし力強く）
「まとめる。**Statistics in Medicine に accept されるための MINIMUM は何か？**

1. ✅ 理論（Proposition 1-2, Kantorovich-Rubinstein 接続）— **済**
2. ✅ シミュレーション（8 scenarios, coverage, bias, SMD 比較）— **済**
3. ✅ 実データ demonstration（IST-3, Belgium anchor, 二層較正）— **済**
4. ✅ HRS Family multi-country（Web Appendix, planning-stage screening）— **決定済、実行待ち**
5. ❌ Japan-anchor RWD — **不要。follow-up paper に回せ**

4番の HRS Family すら、正直に言えば "nice to have" であって "must have" ではない。
IST-3 だけで methodology paper としては成立する。
HRS を追加するのは reviewer の "another application domain" 要求への保険だ。

Japan-anchor RWD を追加する marginal value は、submission delay のコストに見合わない。
"The best closer in the city doesn't take every case — he takes the ones he can win."」

**Harvey**: （しばらく黙ってから）
「...Louis の分析は正しい。Japan-anchor は follow-up だ」

---

### [2026-03-24 17:30] Scene: Archive & Status Summary

**INT. PEARSON SPECTER LITT - FILE ROOM - AFTERNOON**

*Donna が厚いフォルダをアーカイブ棚に移動させている。*

**Donna**: （フォルダを整理しながら）
「SUITS.md が 1,029 行に達したわ。アーカイブした。
archives/SUITS_20260324_171252.md に保存済み。
新しいスクリプト開始よ」

**Harvey**: （通りがかりに）
「過去は過去だ。前を見ろ」

**Donna**: 「了解。Tak からの最終判断待ちね。"I'm Donna. I know everything."」

---
