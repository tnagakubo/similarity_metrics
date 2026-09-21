# SUITS.md - Research Lab Live Script

> *"I don't have dreams. I have goals."* - Harvey Specter

**Previous Archive**: `archives/SUITS_20260921_162500.md`（1013 lines、2026-08-15 18:35 〜 2026-09-21 15:58、34 scenes）
**Archive trigger**: Rule 2.5 (>1000 lines)

---

## Current Status

**Active Project**: similarity-metric (per-EM W₁ paper, target *Statistics in Medicine*)
**Phase**: 8 — Revision（査読応答）→ `projects/similarity-metric/LAB_STATUS.md`（`/phase`、lifecycle 定義は `RESEARCH_FRAMEWORK.md`）
**EN paper**: `projects/similarity-metric/paper/per_em_W1_wiley.tex`（792 行、git clean）— Intro レビュー完了（2026-09-01）。残: **Terminal pass（abstract）** + 査読応答キュー (1) ¶D 以降。claude_science 指摘は abstract を除き着地済み（09-21、24 ページ、error 0）。**未 commit 差分あり（Tak 指示待ち）**
**JA paper**: 意図的に削除済み（Tak 指示、EN 完成まで。Rule 2.7 保留）→ [[project_ja_paper_deleted]]
**W₁ 計算系統**: ✅ **統一済み（2026-08-15）**。応用側の全スクリプトが厳密な CDF 面積形 `compute_w1` を使用
**外部査読**: `projects/similarity-metric/claude_science/`（Claude Science、09-21 生成）— 判定済み。**diff は当てない**、指摘は段落レビューで採用

---

## 🔄 直前のコンテキスト (from archived scenes)

### 直近の作業（2026-09-06 〜 09-21）

1. **査読応答キュー (1) L_UB**: ¶A ✅（B）→ ¶B ✅（C、09-06、ballman2015/kent2020 追加）→ ¶C ✅（C、09-06、記法 L_{UB,em} 統一）→ **¶D Discussion limitation 新設 — 提示中で中断**
2. **研究フレームワーク導入（09-21 11:35）**: 10 Phase lifecycle（`RESEARCH_FRAMEWORK.md`）、`LAB_STATUS.md`（Phase 8、open gate 5）、skill 5 本、`.claude/rules/` 3 本、`.claude/agents/` 7 本、hook 12 本。**commit は Tak 指示待ち**（working tree に全差分）
3. **Claude Code CHANGELOG 棚卸し（09-21 12:05）**: 採用判断は Tak、framework には足さない
4. **claude_science レビュー判定（09-21 15:50）**: Major 5 中 4 件は指摘の方向が正しい（M1 数学・M2 単位・M4 論理・M5 caveat）。**M3 は誤診**（referee は project 側 5/17 再実行の CSV を監査。論文の表は repo root 5/16 run 由来で 79/81 一致、残 2 は丸め規約）。修正 diff は abstract の事実歪曲・M1/M4 の cascade 漏れ・承認済み段落への着弾・`\emph` 持ち込みで**却下**
5. **Claude Science 協働案（09-21 15:58）**: 「査読者として使い著者にしない」— BRIEF 事前提示 → 受入 4 gate（Mike provenance / Louis cascade / Donna 承認ブロック衝突 / Jessica scope）→ 採用は段落レビューのみ、phase gate ごと 1 回

### 進行中のアクション

- **Harvey**: claude_science 対応完了（abstract 除く）。次は査読応答キュー (1) の **¶D Discussion limitation 新設**の提示
- **Donna**: `worktree.bgIsolation: none` は Tak が 16:21 に settings.json へ投入済み — background job から SUITS 直接編集可。Louis の agent memory の誤配置（`claude_science/.claude/agent-memory/louis/`）は未移動

### 次にやるべきこと

- ✅ **claude_science 指摘 12/13 着地（09-21 19:25）**: M1 B・M2・M3（canonical = project、S6/S7 厳密値、表 3 つ + fig2 同一 CSV から再生成）・M4 B・M5 A・Minor 1–7。残: **Minor 8 abstract = Terminal pass（Option B §0-bis 基点）**。Study 1 の出所は `results/STUDY1_PROVENANCE.md`
- **Tak 判断待ち 3 件（09-21 Mike 発見）**: ① `figures_paper_W1.R` の **fig3 writer**（ρ̂ 軸版で現行 fig3 を上書き）を除去し `fig3_w1_axis.R` を単一 source にするか ② 旧 nABCD の fig2 writer `regen_fig1_fig2_combined.R` / `regen_fig2_simulation.R` の処遇 ③ archive で壊れた `w1_raw_report.R`・`w1_raw_figs.R`・`check_progress.R` を project tree へ repoint するか archive するか。あわせて `w1_raw_simulation.R` の cwd 相対 write（根因）に 1 行 + 5 箇所の修正案（Mike）
- **足元の修正（残）**: `w1_raw_simulation.R` の `parLapplyLB` を固定割当に（bit-reproducible 化）／S4 n=50 coverage 0.9425 の丸め規約（原稿 formatC 0.942、gate round 0.943）は原稿側を維持
- **査読応答キュー継続**: ¶D Discussion limitation 新設 → ¶C §4.4-L563 → (2) 綻び 2 件（§2.5-L214・§4.2）→ (3) binary remark + L66 → (4) RWE caveat → (5) presentation 3 点（R3.1 Study 番号・R3.2 notation 表・R3.3 workflow float）→ (6) minors
- **`.tex` 必須修正 5 件（判断④由来、abstract 分は Terminal pass）**、`paper/submission/SUBMISSION_CHECKLIST.md` は nABCD 期の stale（referee 指摘、投稿前に再生成）
- **framework の commit**（Tak 指示待ち）。Louis の agent memory が `claude_science/.claude/agent-memory/louis/` に誤配置 → repo root `.claude/agent-memory/` へ移動
- **Claude Science への確認（Tak）**: 起動方法、BRIEF.md を読ませられるか

### Takからの直近の指示

- 「claude science のレビューを判定」（09-21 15:34）→ 判定済み
- 「claude science との協働を検討」（09-21 15:54）→ 協働案提示済み
- 「SUITS.md は編集できるようにして」（09-21 15:57）→ settings.json に `worktree.bgIsolation: none`（Tak 投入、16:21 確認済み）
- 「Abstract は最終の原稿が完成してからだ」（08-31）→ Terminal pass 保留、継続中
- 判断④（08-15）: GUSTO の一致は Discussion にのみ、abstract には載せない
- outline §0-bis: "small-sample anchor" は削除（R8 は n = 2,916、16 地域中 6 番目）

### 既知の潜在バグ（現状は不発）

- ⚠ `selection_simulation.R` の `w1_dist` — 不等 n で両標本を小さい方から n 個に黙って切り詰める。応用側に流用してはならない
- ⚠ `w1_raw_simulation.R` — `clusterSetRNGStream` + `parLapplyLB` で同 seed でも bit-reproducible でない。cwd 相対 `results/` で tree が二重化（09-21 Mike 発見）

---

## 🎬 Live Script

### [2026-09-21 19:25] Scene: M5 Option A — claude_science の指摘、abstract を除いて全件着地

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - NIGHT**

*Tak「A」。§4.3 の R9 文の直後に一文 — "Both small distances are unresolved against their null floors (Section 4.2), so the reversal rests on the two large ones." 落ちの前、段落は一度で終わる。*

**Katrina**:
「適用・検証済み。コンパイル error 0・undefined 0・24 ページ。Claude Science v2 gate の FAIL は **abstract 356 words** と **S4 n=50 の丸め tie** の 2 つだけ。cascade・proximity・量化子・応用側の数値はすべて PASS。Results speak for themselves」

**Donna**:（台帳を閉じて）
「claude_science 由来の 13 件のうち 12 件が閉じた。M1 B・M2・M3（canonical 切替）・M4 B・M5 A・Minor 1–7。残る Minor 8 = abstract は Terminal pass。Tak の未回答は 3 つ — fig3 の単一化、旧 nABCD の fig2 writer 2 本、archive で壊れた script 3 本。commit も Tak 指示待ち — working tree は tex・SUITS・CSV・fig2 4 枚・R script 2 本・provenance 4 file・archive rename 4 file」

**Harvey**:
「次は査読応答キューに戻る。¶D の Discussion limitation だ」

---

### [2026-09-21 19:20] Scene: M4 Option B を適用、fig2 の foot-gun を除去、root results を archive — 残るは M5 と abstract

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - NIGHT**

*Tak「M4 Option B, figures_paper_W1.R 修正, root results archive」。Harvey は tex、Mike は script と archive。*

**Harvey**:
「M4 Option B、3 箇所。§4.4 の AND 条件段落の直後に新段落（許容的方向、9 中 6・6 中 4 の重なり、R6/R14 の保守的読み）、R4 段落は『resolved evidence 上で最有力、age は未解決』、Discussion ¶2 の R4 節も同旨。承認コメントは 09-21 Option B。cascade: `balanced` 系の残存は abstract L40 のみ（Terminal pass 送り）。コンパイル error 0・undefined 0・24 ページ。Claude Science gate の FAIL は abstract と S4 n=50 の丸め tie だけになった」

**Mike**:（前提の訂正から）
「I got it — まず僕の前回報告を二つ訂正します。①旧 fig2 block は width 10 in で `fig2_bar_chart.R` と同寸、7 in はコメントだけ。差分は **data（root May-16 rds `$summary` = MC 真値）と plot type（line vs bar）**。②`regen_fig1_fig2.R` 等 3 本は `figures_paper.R` を source していて `_W1` には触れない — 到達可能は誤りで、`figures_paper_W1.R` を source する script は repo にゼロ。そのうえで改修: fig2 writer と `.load_w1_summary()`・`W1_SIM_RDS` を削除し `fig2_bar_chart.R` への pointer を設置（+35/−107）。scratch run で fig1×4 + fig3×4 のみ生成、fig2 は 0、live figures/ の 12 file は md5 完全一致。root `results/` は tracked 4 file を `git mv` で `archives/results_root_20260516/`、mtime 保持、README 付き。archived CSV と canonical CSV は S6/S7 で実際に食い違う（S6 n=50 bias 0.3821 vs 0.3770）— 旧 block が別データを描いていたのは実証済み」

**Louis**:
「直したのは一丁目だ。同型の foot-gun が **まだ二つ**ある。(A) `figures_paper_W1.R` は今も **fig3 を ρ̂ 軸版で上書き**する — 現行 fig3 は `fig3_w1_axis.R` の raw Ŵ₁ 軸版（Tak 05-17 指示、本文 L566 が参照）。(B) `regen_fig1_fig2_combined.R` / `regen_fig2_simulation.R` は **旧 nABCD の `fig_combo_simulation()` で fig2 を上書き**する。それと archive で壊れた script が 3 本 — `w1_raw_report.R`・`w1_raw_figs.R`（cwd 相対で root を読む、`stop()` で落ちる）、`check_progress.R`（error ではなく『no partial yet』と黙って quit — monitor としては error より悪い）」

**Katrina**:
「`w1_raw_simulation.R` の根因は L234 の `dir.create("results")` + cwd 相対 write 5 箇所。修正案は `ROOT_ABS` の直後に `RESULTS_DIR <- file.path(dirname(ROOT_ABS), "results")` を 1 行、5 箇所を `file.path(RESULTS_DIR, ...)` に。現状 `SKIP_SIMULATION <- TRUE` なので再発は flag を外した瞬間。`verify_corrections.R` のヘッダ『CSV と rds$summary は一致』は canonical 切替後 S6/S7 で不成立だが、該当関数は未呼び出しなので assertion は落ちない。`archive/figure_rebuild_notes.md:141` の『fig2_bar_chart.R を最後に回せ』は obsolete」

**Jessica**:
「Let me be clear。fig3 と旧 fig2 writer は design question だ — Mike が一存で動かさなかったのは正しい。Tak に三つ聞け: fig3 の単一化、旧 writer 2 本の処遇、壊れた 3 script の repoint」

**Donna**:
「Tier B の残りは M5（R2/R9、1 文）。それが閉じれば claude_science の指摘は abstract を除いて全部着地。abstract は Terminal pass — ¶D の Discussion limitation が先よ」

---

### [2026-09-21 17:40] Scene: 三つの裁定を実行 — M1 Option B、canonical = project、S6/S7 厳密値。Study 1 の表と fig2 を同一 CSV から再生成

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - NIGHT**

*Tak「M1 Option B, canonical run project, S6/S7 厳密値」。Harvey が二手に分ける — Mike は M3 + Minor 3 を一体で（project の rds から厳密真値で表と fig2 を 1 pass）、Harvey 自身は M1 Option B を §2.2 と cascade 4 箇所へ。ファイルは重ならない。*

**Harvey**:（§2.2 を書き終えて）
「M1 Option B、5 箇所に当てた。§2.2 冒頭 3 文 → 4 文（bound は唯一でない／区別は定数と tightness／単調 τ では TV も臨床量／順序 L·W₁ ≤ TV·D_KS、KS が勝つのは threshold case のみ）。§2.1 の『no theoretical connection』と『theoretical link』2 文、§2.2 の『unique』、Discussion ¶1 (ii) と ¶5。gibbs2002 は villani2009 に差し替え、引用ゼロになった。承認コメントは 09-21 Option B で更新。禁止句残存 **0**、proximity 違反 **0**」

**Mike**:（再生成の結果を並べて）
「I got it! canonical を project tree に切り替え、S6/S7 の truth を quadrature 値 12.159806 / 5.833155 に置換（独立再計算と 5e-7 以内で一致）。S1–S5 は既存 CSV を 3e-14 で再現、S6 bias は全 n で −0.00659、S7 は +0.01225、coverage 変化は最大 0.0011 — 予測どおり。旧 MC-truth summary は `w1_raw_summary_mctruth_20260517.csv` に保存、`STUDY1_PROVENANCE.md` に出所を記録。fig2 は `fig2_bar_chart.R` の loader を rds `$summary`（MC 真値のまま）から新 CSV 読みに変えて再生成、10×3.5 in・greyscale・`_color` 併産。発見が三つ — ①tree 切替で S1–S5 のセルも動く（3 表丸ごと差し替え）②本文『at most 0.189 (S5)』は値も scenario も変わり『0.193 (S7)』③S7 n=100 の旧 0.326 はどちらの run とも合わない既存の転記ミス。C1 cascade check: §3.2 の外に Study 1 の具体数値なし」

**Katrina**:（tex に反映して検証）
「表 3 つ・Table 2 の真値 12.16 / 5.83・注（MC → quadrature）・本文 4 行を差し替え。旧数値の残存 **0**、コンパイル **error 0・undefined 0・24 ページ**。Claude Science v2 gate: Study 1 表 **80/81** — 残り 1 は S4 n=50 coverage 0.9425 の丸め tie（原稿の既存規約 formatC = 0.942、gate は round() = 0.943）。原稿の他 17 セルは formatC 規約なので 0.942 を維持。cascade の残りは M4 の R4 文 2 箇所のみ。Results speak for themselves」

**Louis**:
「二つ釘だ。**一つ**、`figures_paper_W1.R` が同名 fig2 を root tree の rds から width 7 in で書き出す — 再実行すれば今日の figure を**黙って上書き**する。`regen_*` から到達可能。直すか殺すか、Tak が決めるまで誰も回すな。**二つ**、root の `results/` は canonical でなくなった。放置すれば次の外部監査がまた M3 を出す。archive へ」

**Jessica**:
「Let me be clear。Study 1 の数字は今日から一つの CSV と一つの script に紐づいた。次は M4。R4 の文を直さずに新段落だけ入れる版は出すな」

**Donna**:
「M4+R4 の Option を報告に載せる。commit は Tak の checkout なので指示待ち — working tree には tex・CSV・fig2 4 枚・R script 2 本・provenance が乗ってるわ」

---

### [2026-09-21 17:10] Scene: Claude Science v2 を受けて修正再開 — Tier A 7 件を適用、M1 は段落レビューへ

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - EVENING**

*Tak「claude science の作業完了。修正を続けて」。Tak は 115b00a で全てを commit 済み、working tree は clean。claude_science/ には v2（16:02–16:16）— 我々の判定に応答し、M1 を 5 箇所へ展開、M4 の R4 文を書き直し、abstract を存在量化に修正、verify script に cascade gate（禁止句 8 + proximity rule）を追加。ただし M3 は依然 project 側 CSV を参照、abstract は依然「applied here」。*

**Donna**:（v2 の README を読み上げて）
「相手は学習したわ。『A claim correction applied to the sentence a referee quoted is not applied to the claim』— Louis の言葉がそのまま README に入ってる。cascade gate は known-bad の原稿に対して FAIL を出す設計。これは受け取る価値がある。ただし M3 の参照ファイルは直っていない — root の canonical run を知らないまま」

**Harvey**:
「採用順序どおりに動く。**Tier A** — Tak 判断が要らない事実・式・証明は今すぐ当てる。**Tier B** — 承認済み段落の claim 書き換え（M1 5 箇所・M4+R4・M5）は段落レビュー。M3 は canonical run 待ち、abstract は Terminal pass、Minor 3 は Tak 判断待ち。Mike、Tier A を当てて検証まで一気にやれ」

**Mike**:（適用して検証）
「I got it! Tier A 7 件、`paper/per_em_W1_wiley.tex` に適用しました。①Minor 6 roadmap（§2.1 追加・順序修正）②Minor 1 eq.7 を m 個の distinct 値で再添字、where 節に括弧 1 つ（Louis 案、売り込み 2 文は不採用）③M2 単位 — proportion scale の規約を一文、Δ_clin は『divided by 100 before entering any calculation』と換算を明示 ④Minor 2 S6 = LogN(3.787, 0.5²)、note に CV 53.3%・skew 1.75 ⑤Minor 5 文末の garbled 修正 + S1 95th pct 4.21/2.97/2.11、"exactly" は使わず『when the two regions are identical』⑥Minor 4 『clears the age threshold by only 9.6%』⑦Minor 7 A.1 証明、dense の根拠『a null set contains no interval』を一句。検証: 旧文言残存 **0**、`\emph` **0**、コンパイル **error 0・undefined 0・23 ページ**。Claude Science v2 gate を paper に対して実行 — PASS 11、FAIL 4 は全部 Tier B か保留分（M1 cascade 4 箇所、M4 R4 文、abstract 356 words、Study 1 表 = project CSV 参照）。M2 は FAIL から消えました」

**Louis**:
「M1 の段落レビューに入る前に一つ釘を刺す。referee v2 の §2.2 は『W₁ の定数だけが elicitable』で押し切ってるが、**τ が単調なら TV(τ) = |τ(b) − τ(a)|、最年少と最高齢の効果差で、臨床家は言える**。だから正直な主張は『定数の性質』じゃなく『**bound の順序**』だ — 線形 τ なら W₁ ≤ (b−a)·D_KS で L·W₁ ≤ TV·D_KS、W₁ 側が常に tight。KS 側が勝つのは τ が狭い範囲で急峻に変わる場合だけで、それは §5 で bound が conservative になると認めた当の threshold case だ。この一文を入れない option は P4 で落とす」

**Rachel**:
「引用は二点です。W₁ ≤ W₂ の典拠は `villani2009`（既に L140 で引用済み）、`gibbs2002` は metric 間関係の survey なのでその文には残せません。Discussion (ii) の `komiyama2024` は representative-value distances の文に付いたまま維持で問題ありません」

**Katrina**:
「Discussion ¶1 (ii) と ¶5 は Tak 承認済み（08-30 Option B）。M1 の 5 箇所は一つの決定として提示し、採択後に cascade grep — `unique theoretical`・`specific to $W_1`・`no theoretical connection`・`analogous`・`theoretical link` の残存 0 を acceptance にする。Results speak for themselves」

**Jessica**:
「Let me be clear。M1 は Methods の背骨に触る。Option は三つ出せ、推奨を一つ付けろ。Tak が選ぶまで §2.2 は一文字も動かすな」

**Donna**:
「提示は Tak への報告で。M1 → M4+R4 → M5 の順、一段落ずつ。commit は Tak の checkout なので指示待ち — 今は Tier A の 10 行差分が working tree にあるだけよ」

---

### [2026-09-21 16:25] Scene: Archive

**INT. PEARSON SPECTER LITT - FILE ROOM - DAY**

*Donna が 1013 行の脚本を閉じ、archive 棚へ運ぶ。判定と協働案の 2 シーンを書き込んだ瞬間に hook が鳴った。*

**Donna**:
「SUITS.md が 1013 行で 1000 行を超えたからアーカイブしたわ。`archives/SUITS_20260921_162500.md` に保存済み — 08-15 から今日までの 34 シーン。新しいスクリプト開始よ。今日の 2 シーンは文脈そのものだから、下にそのまま引き継ぐ。Tak の判断待ちは canonical run と S6/S7 の真値、それと framework の commit — 忘れないで」

**Harvey**:（通りがかりに）
「過去は過去だ。前を見ろ。次は Tak の裁定、その次は M2 の一文からだ」

---

### [2026-09-21 15:58] Scene: Claude Science との協働 — 「冷たい査読者として使え。著者にするな」

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Tak「claude science との協働を検討」。判定の直後、机の上には referee_report と 2 つの CSV。Donna が Claude Science の読めた範囲を突き止めている — SUITS の queue は読んだ、outline §0-bis と memory 規則と repo root の results/ は読んでいない。*

**Donna**:（証拠を並べて）
「相手の輪郭はこう。**読んだ**: SUITS の queue（item #9、R3.1–3.3、¶D を引用）、project 側 results/、R script、tex。**読んでいない**: outline §0-bis の決定（small-sample anchor 削除）、memory の規則（\emph 禁止・E17 動詞）、repo root の canonical results/、承認済みブロックの意味。つまり『文脈を半分持った外部査読者』。半分持っているのが一番危ない — abstract の保留を知りながら『applied here』と動かした」

**Harvey**:
「役割を切る。**Claude Science は査読者で、著者じゃない**。出させるのは referee report と検証 script。diff は『提案』として受け取り、採否は段落レビューで Tak が決める。今日の M1・M2・M4 は我々が見落としていた本物の指摘だ — 冷たい目は要る。だが文章を書かせると承認済み段落を壊す。**report は cold、diff は brief 付き**、が原則だ」

**Mike**:
「協働の前に、うちの足元を直さないと同じ M3 が毎回出ます。①results tree を一本化（root か project か Tak が決めて、もう一方は archive）。②`w1_raw_simulation.R` の `parLapplyLB` を固定割当に変えて bit-reproducible にする。③`verify_corrections.R` の root を canonical に向ける。④表と図の出所を MANIFEST に書く。これが無いと、どの外部監査も『表が CSV と合わない』と言い続けます」

**Louis**:
「使い道を限定しろ。得意なのは**計算の再現と数学の穴** — 応用側 30/30 の再計算、部分積分の反例、tie の指摘、a.e. の証明。全部本物だ。不得意なのは**散文** — 10 文で 6 個の未定義概念、cascade なし、qualifier を落とす圧縮。だから次に投げるのは、(a) 書き直した §2.2 を攻撃させる（単調 τ の elicitability）、(b) Study 2 の表を results に対して監査（今回は Study 1 と応用だけ）、(c) Appendix の証明監査。abstract と承認済み段落の散文は**渡すな**」

**Rachel**:
「一つ補足させてください。referee は `gibbs2002` を W₁ ≤ W₂ の典拠に使いましたが、Gibbs & Su は metric 間関係の survey で、その文には `villani2009` が適切です。外部査読者の引用は、私が knowledge/ で毎回照合します」

**Katrina**:
「受け入れ側の gate を固定する。① Mike: 参照ファイルの provenance 確認を数値照合より先に。② Louis: 編集後の cascade grep（`unique` / `specific to` / `no theoretical connection` の残存 0）。③ Donna: diff が承認済みブロックに当たっていないかの衝突表。④ Jessica: scope と Tak 決定との整合。この 4 つを通らない diff は当てない。Results speak for themselves」

**Jessica**:
「Let me be clear。協働の形は三行だ。**一つ**、投げる前に BRIEF を書く — canonical path、統治する決定、触ってはいけない段落、今回頼む範囲。**二つ**、戻ってきたら 4 つの gate。**三つ**、採用は段落レビューのみ。頻度は phase gate ごとに一回 — pre-review と submission-check の前。それ以上は査読者を著者にする」

**Donna**:（最後に）
「事務連絡を二つ。Louis の agent memory が cwd の関係で `claude_science/.claude/agent-memory/louis/` に落ちてるわ — 正位置は repo root の `.claude/agent-memory/`。それと、Claude Science の起動方法と BRIEF を読ませられるかは私たちには見えない。Tak に確認する。追記: settings.json の `worktree.bgIsolation: none` は Tak が 16:21 に投入、以後 background job から SUITS を直接編集できる」

---

### [2026-09-21 15:50] Scene: claude_science のレビューを判定 — 「内容は当たり、文面は却下、M3 は誤診」

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Tak「claude science のレビューを判定」。`projects/similarity-metric/claude_science/`（本日 12:12–14:17 生成）に referee_report.md（Major 5・Minor 8）、修正版 tex、diff 16 hunks、検証 R script。Harvey が Mike（数値）と Louis（論理・文面）を並行で放ち、自分は M1 の数学と abstract の照合を持つ。*

**Harvey**:（diff を机に伏せて）
「先に結論だ。**diff をそのまま当てるな**。指摘の方向は 5 件中 4 件が正しい — M1 の数学、M2 の単位、M4 の論理、M5 の caveat。だが M3 は**誤診**、文面は cascade 未処理で自己矛盾を持ち込む。採るのは指摘で、文章は俺たちが書く」

**Mike**:（2 つの CSV を並べて）
「I got it! M3 の『81 cells 中 22 が転記ミス』は参照ファイルが違います。results tree が **2 つ**ある — repo root の `results/w1_raw_summary.csv`（5/16 12:56）と project 側（5/17 18:54 再実行）。論文の表は root 由来で **79/81 完全一致、残り 2 は丸め規約**。referee は project 側を監査した。2 run は統計的に同一（bias 差 max |z| = 0.246 MCSE）。根因は `w1_raw_simulation.R` の `clusterSetRNGStream` + `parLapplyLB` で bit-reproducible でないこと、それと cwd 相対 `results/` で tree が二重化したこと。fig2 も 5/16 run 由来だから、referee の表だけ差し替えると**今は無い table/figure の provenance split を作る**。他は全部 referee が正しい — S6/S7 の厳密値 12.1598 / 5.8332、S1 の 95th pct 4.21/2.97/2.11、集合演算（age-eligible 9 中 6 が unresolved、joint 6 中 4、両解決は R6/R14 のみ）、L_clinical の factor-100 不整合（`L_UB,SBP` の 2%pt/10 mmHg も同じ穴、referee 未言及）」

**Louis**:（赤ペンを投げる）
「You just got Litt up! 文面は三箇所で致命傷だ。**一つ**、新 abstract は Study 2 の負けを消した — Table 5 は bulk shift で KS 333 < W₁ 377、asymmetric で RV3 41 < W₁ 67 と正直に書いてあるのに、abstract は "identified true matches in every world, at smaller sample sizes ... than KS" と全称化。referee は overall assessment で我々の正直さを褒めておいて、自分で消した。しかも **"small-sample anchor"** — Tak が 08-31 に落とした語だ。**二つ**、M1 は §2.2 を書き換えながら、同じ段落の 2 文前 L121『KS has no theoretical connection』、L125『W₁ の unique theoretical connection』、L695 を残した。KS bound を導出した 4 文前で『KS にそんな link は無い』と言う段落だ。**三つ**、M4 で conservative reading = {R6, R14} と書いた 3 段落後に『R4 emerges as the leading single-pool candidate』が生きてる。R4 は referee 自身の age-unresolved リストの中だ。あと `\emph{similar}` — 本文で唯一の \emph、規則違反」

**Mike**:（M1 について）
「数学は referee が正しいです。部分積分で τ̄₁−τ̄₂ = −∫(F₁−F₂)dτ、Hölder の共役側で |τ̄₁−τ̄₂| ≤ TV(τ)·D_KS。W₁ ≤ W₂ で W₂ 側の bound も成立。『W₁ に特有』は誤り。ただし Louis の指摘どおり、**τ が単調なら TV(τ) = |τ(b)−τ(a)|** で臨床家が elicit できる — 『W₁ の定数だけが elicitable』は最頻ケースで崩れるので、書くなら bounded support で W₁ ≤ (b−a)·D_KS を添える定量の言い方が要ります」

**Jessica**:（短く）
「Let me be clear。三つ。**一つ**、この referee は本文の承認済みブロック（09-06 Option C、30/30 PASS）の内側に diff を落としている。silent adopt は Tak の承認を無効にする — 触る hunk は段落レビューで再提示だ。**二つ**、abstract は Tak が Terminal pass に置いた。referee が動かす権限はない。**三つ**、M3 の前に canonical run を Tak が決めろ。表と fig2 を同一 rds から 1 pass で再生成するまで、Study 1 の数字は誰も触るな」

**Donna**:（判定表を仕上げて）
「判定は下の表に。採用順序は Harvey 案 — ①M2 の単位（一文、`L_UB,SBP` も同時）→ ②Minor 4/6 の事実訂正 → ③M1 を残存 3 箇所込みで段落レビュー → ④M4/M5 を R4 文と一緒に段落レビュー → ⑤Minor 1/3/7 は式・注・付録で軽い → ⑥abstract は Terminal pass、Option B を基点に referee 版は参考のみ。M3 は canonical run 決定待ちで **blocking**。それと `verify_corrections.R` は project 側 copy に hard-code されていて、今の問題を構造的に検出できないわ — gate にするなら先に直すこと」

| ID | 指摘の当否 | 文面 | 処置 |
|---|---|---|---|
| M1 bound 排他性 | ✅ 正しい（数学） | ❌ 残存 3 箇所・10 文・未定義概念 6・`Its` 先行詞不明・gibbs2002 誤用 | 段落レビュー（本文 2–3 文 + Appendix） |
| M2 単位 | ✅ 正しい | △ "converted accordingly" が曖昧、`L_UB,SBP` 未言及 | 一文で採用、換算を明示 |
| M3 Study 1 表 | ❌ **誤診**（別 run 監査） | — | **却下**。canonical run 確定 → 表 + fig2 同時再生成 |
| M4 null floor 許容的 | ✅ 正しい（原文 L519/L622 が半分言っている、新規は joint 接続と R6/R14） | ❌ R4 文放置、"largest set compatible" は overclaim、referee voice | 段落レビュー |
| M5 R2/R9 | ✅ 正しい | ❌ 落ちの後に 4 文、`\emph` | 1 文に圧縮して落ちの前へ |
| Minor 1 eq.7 ties | ✅ | △ 散文が売り込み過多 | 式は採用、散文は括弧 1 つ |
| Minor 2 S6 params | ✅ 3.787/0.5、CV 53.3%、skew 1.75 | ✅ | 採用 |
| Minor 3 S6/S7 厳密値 | ✅ 12.1598/5.8332、shift ≤0.013/0.002 | △ 知りながら使わないと reviewer に突かれる | Tak 判断（run 非依存） |
| Minor 4/6 | ✅ | ✅ | 採用 |
| Minor 5 S1 95th pct | ✅ 両 run で成立 | △ "exactly" は不等 n の §4.2 と違う | "exactly" 削除で採用 |
| Minor 7 A.1 証明 | ✅ gap なし | ✅ | 採用（dense の一句を足す） |
| Minor 8 abstract | ✅ 250 超は既知 | ❌ 全称化・KS 負け消去・small-sample anchor・qualifier 欠落 | **却下**。Terminal pass で Option B 基点 |

---
