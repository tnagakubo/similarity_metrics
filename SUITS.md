# SUITS.md - Research Lab Live Script

> *"I don't have dreams. I have goals."* - Harvey Specter

**Previous Archive**: `archives/SUITS_20260627_205843.md` (1005 lines, 2026-05-17 05:30 〜 2026-06-27 16:50)
**Archive trigger**: Rule 2.5 (>1000 lines)

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
