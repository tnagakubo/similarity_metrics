# SUITS.md - Research Lab Live Script

> *"I don't have dreams. I have goals."* - Harvey Specter

**Previous Archive**: `archives/SUITS_20260627_205843.md` (1005 lines, 2026-05-17 05:30 〜 2026-06-27 16:50)
**Archive trigger**: Rule 2.5 (>1000 lines)

---

### [2026-07-03 XX:XX] Scene: GSCポスター発表 — 社内報告会

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Takashi Nagakubo が社内統計セミナーで GSC ポスター発表を終えて戻ってきた。チームが結果を受け取る。*

**Harvey**:（椅子に深く座って）
「発表は終わった。何が残ったか、整理するぞ。」

**Donna**:（手元のメモを確認しながら）
「発表タイトル：*Quantifying Effect Modifier Similarity Using a Regional Pooling Strategy in Multiregional Clinical Trials*。発表者 Tak、参加者7名（Morisaki, Ogawa–Network, Dozono, Takenouchi, Cai, Oura）。SUITS記録、完了。」

**Mike**:（ホワイトボードに板書しながら）
「技術ポイントをまとめると——NABCDは IQR 標準化済みの 1-Wasserstein Distance。値が小さいほど分布が類似。シミュレーション S1–S7、n≈100 で実用的性能確認。GUSTO-I 16地域、アンカー R8、総合評価で R4 が最も類似。I got it。」

**Harvey**:（鋭く）
「Takの自己反省は何だ？」

**Mike**:
「標準化の意義に疑問。L を使った臨床解釈のために別パラメータを導入するなら、IQR 標準化を外す形も今後の検討対象に。」

**Rachel**:（丁寧に整理しながら）
「Q&A で重要な論点が出ていました。①カテゴリ変数拡張は現状困難、②階層ベイズとの比較可能性あり、③PMDA は日本人結果を依然重視・事前規定のプーリングが前提、④東アジア統合は疾患領域ごとに慎重に。ICH E17 ガイドライン再読と Pooling Strategy 関連論文のレビューが次のアクションです。」

**Louis**:（腕を組んで）
「一番の学びは何だ？統計的類似性と規制的受容性は別物だ、という話じゃないのか。手法を作っても PMDA が受け入れないなら意味がない。その橋渡しをどう論文に落とすか——そこが Tak の宿題だ。You just got Litt up!」

**Harvey**:（短く締める）
「方向性は明確だ。①標準化なし形式の検討、②カテゴリ変数拡張、③多変量化、④Bayesian borrowing との比較。次フェーズに進む。」

**Donna**:（全員を見渡して）
「今日の発表で一言サマリ——手法そのもの以上に「地域を併合する根拠をどう説明するか」「統計的類似性と規制的受容性をどう橋渡しするか」という本質的課題が議論された。記録、完了よ。」

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
