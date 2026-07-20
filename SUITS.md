# SUITS.md - Research Lab Live Script

> *"I don't have dreams. I have goals."* - Harvey Specter

**Previous Archive**: `archives/SUITS_20260719_132632.md`（1022 lines、2026-07-03 〜 2026-07-19 15:00）
**Archive trigger**: Rule 2.5 (>1000 lines)

---

## Current Status

**Active Project**: similarity-metric (per-EM W₁ paper, target *Statistics in Medicine*)
**EN paper**: `projects/similarity-metric/paper/per_em_W1_wiley.tex` — Intro レビュー ¶7 で停止中
**JA paper**: 意図的に削除済み（Tak 指示、EN 完成まで。Rule 2.7 保留）→ [[project_ja_paper_deleted]]
**worktree**: `worktree-selection-sim` — **マージ済み・削除済み**（2026-07-20。bootstrap 実装も `a950ef2` で残置）。remote branch の削除は push 時

---

## 🔄 直前のコンテキスト (from archived scenes, 2026-07-19)

### 直近の作業
1. **大掃除**: nABCD 遺物・役目を終えた文書を `archives/cleanup_20260719/`（MANIFEST 付き）に集約。root `results/w1_raw_*` は現役ゆえ温存
2. **git マージ解決**: SUITS.md の conflict（ローカル cleanup ⇔ リモート 7/3 GSC セミナー報告）を両シーン残す形で解決 → merge commit `f61ca19`。**main は origin より先行、push 未実施**
3. **現在地確認**: 貢献 (b) の**理論**（Δ_max=L·W₁ 定理・KR 双対・二経路較正）は本文 §2 に既にある。欠けているのは**実証**（Part 1B の閾値選択 sim）
4. **Jessica = advisor 設定**: `advisor` ツールを Jessica の声で表現。substance 忠実・register だけ Jessica → [[project_jessica_advisor_role]]
5. **残① bootstrap 上限ルール**: 実装・検証（別スクリプト `threshold_bootstrap_simulation.R` + cpp `W1_raw_boot_upper_cpp`、既存 threshold_sim は不変）。結果 = **棄権であって制御ではない**（ヌルバイアスが τ 範囲をまたぐため match すら admit できず sensitivity ~0）
6. **sim 計画の draw.io 作成**: `projects/similarity-metric/sim_plan_ja.drawio`

### 進行中のアクション
- なし（draw.io 作成完了が直近）。

### 次にやるべきこと（残タスク）
- **worktree を main にマージ**（Part 1B sim 一式）
- **本文 Results 統合**（点推定の operable range。bootstrap 否定結果は**載せない** = Tak 判断）
- **Intro ¶7（SMD 限界）以降のレビュー再開**
- **push**（main 先行 + merge commit を origin へ）
- **REVIEW_TRACKER.md 更新/retire**（nABCD 用語のまま 0/29 で stale）

### Tak からの直近の指示
- 「bootstrap 否定結果は**例数が少ないから当然**。論文には触れない」→ 反映（実装は内部検証として残置）
- 「sim 計画を分かりやすく draw.io で図示」→ 実行済み（`sim_plan_ja.drawio`）
- 「Jessica が Advisor の役割を果たすように」→ `agents/jessica.md` Role 4 + memory に反映

---

## 🎬 Live Script

### [2026-07-20 14:30] Scene: 全部を1枚に — 何が言えて、何が言えないか

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - NIGHT**

*Tak「シミュレーションから示される結果を表と箇条書きでわかりやすくまとめて。何が主張できるのか整理したい」。Katrina が全 CSV から数値を再抽出し、1 文書に統合する。*

**Katrina**:（`SIMULATION_FINDINGS.md` を出す）
「作った。背骨は**3分類**——blind（chance 上で平坦、n=∞ でも解けない）/ partial（chance 超で頭打ち）/ recovering（回復、必要例数の問題）。n を 2000 まで伸ばして初めて区別がついた分類よ。

主張は**強度順に10個**。★★★ が5つ——うち4つは**真値だけか漸近で確定**するもので、n に依存しない。★★ が4つで達成可能な n での言明。★ が設計指針。

そして**訂正表**を別に立てた。旧案のうち **6項目が誤りか要修正**。一番大きいのは『Set 4 が KS を殺す、盲目であって underpowered ではない』——これは誤り。」

**Mike**:
「harm と false-pooling も production CSV から取り直した。Set 4: false-pooling 比 1.35×、harm 比 **2.14×**——計画書の数字と一致した。順位逆転の真値も sim 出力から確認済み。全数値が CSV 由来だ。I got it.」

**Harvey**:（表を指す）
「これで議論の土台ができた。**KS への武器を置き換える。** clustering の結果じゃない——KR bound と順位逆転だ。どちらも n に依存しない。『例数を 1240 くれれば KS でいい』という反論が効かない場所に主張を移す。」

**Louis**:
「訂正表があるのがいい。**自分が何を間違えていたかを書いた文書**を持ってる著者は強い。査読者に先に言われる側じゃなくなる。」

**成果物**: `projects/similarity-metric/SIMULATION_FINDINGS.md`（設計 / 3分類 / clustering・selection・閾値較正の表 / 主張10件 / 訂正6件 / 論文への波及 / 再現手順）

---

### [2026-07-20 14:05] Scene: 確定 — 「盲目」の名指しが入れ替わった

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - NIGHT**

*本 run 完了（clustering reps=2000 / selection reps=3000、n = 150〜2000 の8点）。Mike が補間を独立再計算して検証。*

**Mike**:（検証済みの表を出す）
「捨て run の警告は**本物だった**。そして構図は俺たちが書こうとしていたのと**逆**だ。

**① Set 4 の KS は盲目ではない。** ARI 0.005 (n=150) → 0.282 (600) → 0.664 (1000) → **0.985 (2000)**。完全に回復する。ARI≥0.8 の必要例数は KS=1240 vs W₁=376——**3.3倍**。これは identification の失敗じゃない、**power の差**だ。

**② 本当に盲目なのは代表値法だった。** そして4つの world **全部**で。RV1 は Set1 0.497 / Set2 0.495 / Set3 0.001 / Set4 0.024 で n=2000 まで**平坦**。SMD も 0.461/0.461/0.001/0.016 で平坦。RV2 は Set3 0.014、Set4 は 0.378 で頭打ち。RV3 は Set1 0.725、Set4 0.248 で頭打ち。**これは n=∞ でも動かない。**

補間は独立に再計算して一致を確認済み（Set4 W₁: n=300→0.7249, n=400→0.8209 を log(n) 線形補間 → 375.73 → 376）。」

**Harvey**:（立ち上がる）
「headline を書き換える。旧: 『Set 3 が moment 法を殺し、Set 4 が KS を殺す』——**後半は誤りだ**。新しい構図はこうだ:

**代表値法は全 world で盲目**（n=2000 でも回復しない）。**KS は必ず識別する、ただし最大 3.3 倍の例数を要求する。** **W₁ は4 world 中3つで最小の例数で済む。** 

前より弱い主張じゃない——**前より正確で、しかも代表値法への打撃は強くなった**。4 world 全部で盲目、と言えるようになったんだからな。」

**Katrina**:（必要例数の表を出す）
「task floor（全手法の最良、ARI≥0.8）: Set 1 = **36**（RV2）/ Set 2 = **83**（KS）/ Set 3 = **364**（W₁）/ Set 4 = **376**（W₁）。達成手法も併記した——Louis の指摘どおり、n によって入れ替わる。

そして**これが論文の既存の推奨と衝突する。** 現行本文は『n ≥ 100 per region を推奨』と書いてる。でもそれは Study 1（W₁ の**推定**精度）から来た数字。**pooled-region 形成には Set 3/4 で 364〜376 必要**——n=100 では足りない。」

**Louis**:（満足げに）
「つまり我々は自分の推奨が不十分だと自分で見つけたわけだ。レビュアーに言われる前にな。**それが proactive review だ。**」

**Jessica**:
「Let me be clear。Tak の一つの質問が、誤った headline を訂正し、代表値法への批判を強め、既存の推奨の不足を露呈させた。**三つとも、査読で刺されていたはずのもの**よ。」

**成果物**: `R/required_n.R`（新規、blind/underpowered を機械判定）、`results/required_n_{clustering,selection}[_floor].csv`、拡張 run の CSV 一式。production CSV は tag 分離で無傷。

---

### [2026-07-20 13:40] Scene: ⚠️ タイミング計測が headline を刺した — KS は「盲目」ではないかもしれない

**INT. PEARSON SPECTER LITT - BULLPEN - DAY**

*Tak 判断: 一回で全部（n=150〜2000）/ ARI 0.7・0.8・0.9 併記 / selection + clustering 両方。Mike が両スクリプトに `--n-grid` `--base-seed` `--tag` を追加（production CSV は tag で保護、デフォルトは bit-identical 再現を回帰テストで確認済み）。所要時間を測るための捨て実行で、想定外のものが出た。*

**Mike**:（画面を止めて）
「待て。時間計測のつもりだった n=2000・reps=100 の捨て run で——**Set 4 の KS が ARI 0.978 を出した。** n=100 では 0.003 だ。」

**Harvey**:（即座に何を意味するか掴む）
「……論文の headline の片方が揺れる。Part 2 で俺たちは『Set 4 で KS は **blind であって underpowered ではない**』と書く予定だった。根拠は n を4倍にしても +0.003 しか動かないこと。だが n を20倍にしたら 0.978 まで飛ぶなら、それは**盲目ではない。極端に非力**なだけだ。」

**Mike**:（理論を分けて整理する）
「主張を2つに分けて考える必要がある。

**① Part 1B の非識別（閾値選択）は無傷だ。** 真値は T1: W₁=3.0/KS=0.047、T2: W₁=6.0/KS=0.050、S1: W₁=2.0/KS=**0.072**。KS は S1 を T2 より discordant と**順位を逆転**させる。どんな閾値でも {W₁ ≤ τ}, τ∈(3,6) は復元できない——これは真値だけの言明で、**n=∞ でも成立**する。ここは動かない。

**② Part 2 の clustering の『盲目』は言い過ぎだった可能性が高い。** clustering は群を**分離**できればいい。真の KS 値は群間で確かに違う（0.047 / 0.050 / 0.072）——ごく僅かだが**ゼロではない**。だから n さえあれば解像できる。n≤100 で平坦に見えたのは飽和による**局所的な非力さ**で、識別の失敗ではない。

対して **Set 3 の RV 法は本物の盲目**だ。構成上 (mean, SD) が12国すべてで一致——母集団距離が**厳密に 0**。n=∞ でも 0 のままだ。捨て run でも Set 1 の RV1 は n=2000 で 0.488、n=100 の 0.489 と**平坦**——盲目の署名そのもの。」

**Louis**:（怒鳴る）
「つまり俺たちは『W₁ だけが両方を生き残る』の**根拠の半分を、測っていない領域の外挿で書こうとしていた**ってことだ。レビュアーが n を伸ばして再現したら終わってた。Tak の質問が救ったんだぞ。」

**Donna**:（冷静に）
「本 run が回ってる——n = 150〜2000 の8点、clustering は reps=2000、selection は reps=3000。reps=100 の捨て run で断定はしないわ。**確定は本 run の数字を見てから。**」

**Jessica**:（短く）
「Let me be clear。これは論文を弱める発見ではないわ。**言葉を正確にする発見**よ。『blind』と『underpowered』を混ぜて使っていたなら、それはいずれ刺される。今なら自分で直せる。」

**要確認（本 run の数字で）**: ① Set 4 / KS は大 n で回復するか（→「盲目」撤回、「必要例数 20倍」に書き換え）② Set 3 / RV は大 n でも平坦か（→「盲目」維持）③ 必要例数表（ARI 0.7/0.8/0.9）

---

### [2026-07-20 11:20] Scene: 必要例数を出せ — グリッドが届いていないと分かる

**INT. PEARSON SPECTER LITT - BULLPEN - DAY**

*Tak「クラスタリングに必要と考えられる例数をシミュレーション結果から示すことが有用では」。Katrina が exact recovery を引き出す。*

**Katrina**:（画面を指す）
「有用よ。でも先に悪い知らせ。**現行グリッド n ≤ 100 では答えが出ない。** exact partition recovery（全手法の最良値）: Set 1 は n=75 で 0.961、n=100 で 0.992 — ここは答えられる。でも Set 2 は n=100 でも 0.582、Set 3 は **0.043**、Set 4 は **0.041**。難しい world では必要例数が**グリッドの外**にある。」

**Mike**:（計算しながら）
「基準を ARI ベースにしても同じだ。全手法最良 ARI は Set 3 で 0.288→0.526、Set 4 で 0.144→0.355 と n=100 まで**まだ上がり続けてる**。プラトーに達していないから『ここで十分』と言える点が無い。今のデータで必要例数を出せば、それは外挿だ。」

**Harvey**:（即断）
「なら測れ。n を伸ばす追試だ。cell あたり ~55 秒、n = {150, 200, 300, 400} × 4 sets で 20〜30 分。既存スクリプトは n をパラメータに取ってる——設計変更は要らない。**答えを外挿するな、測れ。**」

**Jessica**:（Harvey の即断を止める）
「Let me be clear。方向は正しい。でもそのグリッドをまだ走らせるな——**先に天井を測りなさい。**

Set 3 の全手法最良 ARI の増分を見なさい。+0.189 → +0.048 → +0.021。**減速している。** 漸近先は 0.55 付近で、0.8 に向かって登っているようには見えない。もしそれが本当なら Set 3 の『必要例数』は**存在しない**——どんな n でも成立しない、それが答えよ。n=400 まで伸ばしても結論は変わらない。逆に一貫推定量なら ARI→1 のはずだから、単に遅い途中かもしれない。**n ≤ 100 では区別がつかない。**

だから先に n ≈ 1000〜2000 を Sets 2/3/4 で数セル。reps は 1000 で足りる——天井の平均が見たいだけで、精密な MCSE は要らない。15〜20 分。これで (a) 各 world が閾値に**到達しうるか**、(b) 到達するならグリッドをどこに張るか、が決まる。{150…400} を盲目に走らせたら『まだ登っている、結論なし』に 15 分払う危険があるわ。

それと基準について二点。**exact recovery は practitioner の問いには厳しすぎる**——12国3群の完全一致は ARI 0.53 の場所で 0.04 よ。ARI ベースの方が擁護できる。そして基準は**事前指定**しなさい、必要例数はそこから直接落ちてくるのだから。

最後に一つ、これは大きい。**GUSTO の応用は selection 問題（Region 8 が partner を探す = Part 1）であって clustering ではない。** 必要例数を実務助言として載せるなら、application に直結するのは selection の方よ。Part 1 に置くか、両方か——Tak に諮りなさい。」

**Louis**:（噛みつく）
「もう一つ穴がある。最良手法が n で**入れ替わる**——小 n では RV2、大きくなると W₁。task floor として出すならそれを明記しろ。黙っていれば cherry-pick に見える。」

**判断待ち**: ① ceiling probe 実行可否 ② 基準（ARI ≥ ?）③ 対象タスク（clustering / selection / 両方）。

---

### [2026-07-20 11:00] Scene: Tak の注文 — クラスタリングの限界も見せろ

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*構造案（§3 再編、Study 2 = 8段落）を提示。Tak のコメント:「クラスタリングの限界が確認できるとよい。例数少ない設定になるときなど。」*

**Katrina**:（CSV を叩いて即答）
「検証済みの数字がある。W₁ 自身の clustering ARI、n=25 で Set 1: 0.604 / Set 2: 0.332 / Set 3: 0.268 / Set 4: **0.112** — 難しい world では chance すれすれ。exact recovery は易しい Set 1 ですら n=25 で 22.9%。n=100 でも Set 3: 0.526、Set 4: 0.355 で 1 には遠い。」

**Harvey**:
「¶5 を拡張する——『W₁ の優位が成立する範囲の限界』として3点: (a) 競合に負ける場所（Set 1 RV2・Set 2 KS）、(b) **小 n では全手法が崩れる**（W₁ 含む）、(c) n=100 でも絶対性能は qualitative gap の主張に留める。既存の n ≥ 100 推奨と接続する。」

**修正**: Study 2 ¶5 → ¶5a（競合に負ける場所）+ ¶5b（小 n クラスタリング限界、Tak 要望）。fig_clustering_ari が n=25 からの立ち上がりでこれを可視化する。

---

### [2026-07-20 10:45] Scene: Results 統合 — スコープの確認、構造案を先に

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Katrina の調査結果がスクリーンに。論文 §3 に選択 sim（Sets 1–4）は一切入っていない。*

**Harvey**:（ホワイトボードを叩く）
「構図はこうだ。計画書の Reporting plan は選択 study **全体**の統合を想定、SUITS の残タスク表現は『点推定の operable range』= Part 1B に絞った書き方。Part 1B は Sets 1–4 の上に立つから単独では入れられない。俺の推奨は全体統合——だが Tak の判断を仰いだ。」

**Tak の決定**: 「構造案だけ先に見る」——ドラフト前に subsection 構成・表と図の main/supplement 配分を提示して承認を取る。

**Katrina**:（即座に）
「構造案を組む。Reporting plan・circularity defense・operable range の帰結・Tak の5原則（特に P3）を織り込む。」

---

### [2026-07-20 10:24] Scene: マージ完了 — Part 1B が main に還る

**INT. PEARSON SPECTER LITT - BULLPEN - DAY**

*Tak「その順番で進めよう」。Mike が worktree の始末に取りかかる。*

**Mike**:（画面に merge log を流しながら）
「マージ完了。`worktree-selection-sim` の 12 commits — sim スクリプト 9 本、図 24 枚、結果 CSV 6 本、全部 conflict ゼロで main に入った。それと危ないところだった — worktree に bootstrap 上限ルールの実装が**未 commit のまま**残ってたんだ。Tak の判断は『論文外だが内部検証として残置』。だから commit `a950ef2` にして追加マージした。消してたら判断と矛盾するところだった。I got it!」

**Donna**:（チェックリストに線を引きながら）
「worktree とローカルブランチは削除済み。main は origin より **17 commits 先行**よ。remote の `worktree-selection-sim` ブランチは push のときに片付けるわ。次は Katrina の番 — Results 統合よ。」

**残**: 本文 Results 統合（bootstrap 否定結果は除外）→ Intro ¶7 レビュー → push。

---

### [2026-07-19 15:30] Scene: sim 計画を1枚に — 消去カスケードを図にする

**INT. PEARSON SPECTER LITT - KATRINA'S DESK - DAY**

*Tak「シミュレーションの計画をわかりやすく図示する draw.io」。Katrina が計画書 843 行を1枚に凝縮する。*

**Katrina**:（既存スタイルに合わせて即描き上げる）
「`sim_plan_ja.drawio` 完成。背骨は一つ——**4つの世界＝消去カスケード**。Set 1 が SMD・RV1 を、Set 2 が SMD(raw) を、Set 3 が RV2・RV3 を、Set 4 が KS を、それぞれ盲目化する。矢印で繋いで『W₁ だけが最後まで never-blind』に着地させた。上に問い・ADEMP 枠・2タスク・1セルの流れ、下に手法と測定。既存 `paper_logic_ja.drawio` と同じ Yu Gothic・warm grey・赤アクセントで統一。Results speak for themselves.」

**Donna**:（一点添える）
「各世界に『競合が効く control セル』も明記したわ——cherry-pick じゃないことが一目で分かる。非循環の担保（真値＝構成ラベル）も footer に。app.diagrams.net でそのまま開けるわよ。」

**残**: マージ → 本文 Results 統合（bootstrap 否定結果は除外）→ Intro ¶7 レビュー → push。

---

### [2026-07-19 15:20] Scene: Archive

**INT. PEARSON SPECTER LITT - FILE ROOM - DAY**

*Donna が分厚いフォルダをアーカイブ棚へ移す。*

**Donna**:
「SUITS.md が 1022 行になったから Rule 2.5 でアーカイブしたわ。`archives/SUITS_20260719_132632.md` に保存済み。7/3 の GSC セミナーから今日の bootstrap 否定結果まで——全部そこ。新しいスクリプト開始よ。」

**Harvey**:（通りがかりに）
「過去は過去だ。前を見ろ。残りはマージと本文統合、そして Intro の続きだ。」

---

## 📊 Key Decisions（carried forward）

- **Methodology**: Per-EM W₁ raw + Δ_max = L_clinical × W₁（正規化なし、nABCD 撤回済み）
- **Estimation-centered**（testing でない）／ **Percentile bootstrap**（BCa は封印）／ 臨床較正は Δ_max 経由
- **Part 3（θ sim）はやらない** — 前提の検証・一般性破壊・循環論法になる → [[project_no_effect_tracking_sim]]
- **貢献 (b) の scope = Q_metric**。Set 1–4 の主張は「W₁ は盲目でない」（identification）
- **bootstrap 上限選択ルール**: 検証済みだが**論文外**（小 n では棄権になるのは当然、と Tak 判断）
- **Jessica = advisor ツールの声**（substance 忠実・register だけ Jessica）→ [[project_jessica_advisor_role]]
- **小宮山 Ch.4**: 1 EM = 1 代表値。RV2/RV3 は我々の拡張、「小宮山の手法」と呼ぶな → [[feedback_komiyama_no_overreading]]

## 📊 Key Memory References (Active)

### CRITICAL Rules
- Rule 2.5 (Auto-Archive) / Rule 2.7 (EN-JA Sync 保留中) / Rule 3.7 (Speaker Clarity) / Rule 3.8 (Tone Authenticity)

### Active Memory (cross-conv)
- [project_ja_paper_deleted.md](memory/project_ja_paper_deleted.md) — JA 削除、再生成するな
- [project_jessica_advisor_role.md](memory/project_jessica_advisor_role.md) — advisor = Jessica の声
- [project_no_effect_tracking_sim.md](memory/project_no_effect_tracking_sim.md) — Part 3 やらない
- [feedback_komiyama_no_overreading.md](memory/feedback_komiyama_no_overreading.md) — 小宮山 拡大解釈禁止
- [project_suits_tier1_guards.md](memory/project_suits_tier1_guards.md) — Persistence/Numbers guards
- [feedback_calculation_verification.md](memory/feedback_calculation_verification.md) — 数値再検証必須
- [feedback_tak_review_principles.md](memory/feedback_tak_review_principles.md) — Tak 5 原則
- [feedback_speaker_clarity.md](memory/feedback_speaker_clarity.md) / [feedback_tone_authenticity.md](memory/feedback_tone_authenticity.md)
- [feedback_paper_no_emph.md](memory/feedback_paper_no_emph.md) — `\emph` 使わない

### Path α Specific (Active)
- **W₁ theory**: Sommerfeld 2018, del Barrio 1999, Panaretos 2019, Vallender 1974, Villani 2009
- **L_clinical**: VanderWeele 2014/2019, Fisher 2017, Riley 2010, FTT 1994, GUSTO 1993
- **Komiyama 2024**: 当事者の pooling レシピ。gap = 分布構造潰し ＋ 臨床閾値未 operationalize。Δ_max が回答
- **Out of scope**: Multi-EM aggregation（Discussion で対比）、within-EM normalization（Supplement A equivalence）
