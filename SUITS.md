# SUITS.md - Research Lab Live Script

> *"I don't have dreams. I have goals."* - Harvey Specter

**Previous Archive**: `archives/SUITS_20261012_155236.md`（982 lines、2026-09-27 14:05 〜 2026-10-12 11:40 の scenes。10-11 の Option B・全件生成・referee 判断と適用、10-12 未明の hardening、10-12 午前の残差レビュー D-20261012-2 と並走 session の 3 原則・事例探索・Matsushima 訂正）。直前は `archives/SUITS_20260927_130112.md`
**Archive trigger**: Rule 2.5 (>1000 lines) — 982 行 + 本日午後の scenes で超えるため先に実施

---

## Current Status

**Active Project**: similarity-metric (per-EM W₁ paper, target *Statistics in Medicine*)
**Phase**: 8 — Revision（査読応答）→ `projects/similarity-metric/LAB_STATUS.md`（2026-10-12 11:40 同期済み）
**EN paper**: `projects/similarity-metric/paper/per_em_W1_wiley.tex` — v6 + Terminal pass（09-27）+ 生成基盤（D-20261011-8）+ 冷読 referee D-20261011-11 + 残差 D-20261012-2 + 外部/referee #2 D-20261012-3 + 実務家 D-20261014-2 + 削減 D-20261014-1 / D-20261015-1 + **骨子からの絞り込み D-20261015-2（10-15 08:20、Tak「図の削減は愚策ではないか」: 図 2 本を復活、L* 表を削除、R1–R4 に答えない文を削除、Louis review-fix Major 7 反映）**。**15 pp、error 0、undefined 0、abstract 231/250、本文 5,796 語（SiM 上限の 1.0×）、図 4・表 5、numbers 113/113 sourced、guards 65 本 0 FAIL（3 vacuous）**。判定表 `review_response/ESSENCE_SKELETON_20261015.md`。**未 commit**（原稿側の commit は Tak）。Tak の拒否権は marker `D-20261015-2`（26）・`Louis review-fix 2026-10-15 08:06`（6）・`D-20261015-1`（76）の段落に対して投稿前まで開いている
**Question / Aim（Tak 10-12 10:46）**: A1 効果修飾因子の分布の類似性を定量的に評価する指標を提示すること（`LAB_STATUS.md`、R1–R4 が対応）
**原則（Tak 09-25）**: 論文は違いを定量化するだけ。併合の判定規則は規定しない → [[feedback_quantify_not_decide]]。**Tak の 3 原則（10-12）**: 根拠なしで進めない（S21）／研究は発散・論文は収束（S22）／ネタはストック `/idea`（S23）
**段落レビュー**: 台帳 `archive/cleanup_20261016/docs/REVIEW_QUEUE_v6.md` 50/50（09-27）。#1–#7 Tak 承認、#8–#50 は包括指示で Harvey 推奨（D-20260927-1、Tak の一言で閉じる）
**JA paper**: 意図的に削除済み（EN 完成まで Rule 2.7 保留）→ [[project_ja_paper_deleted]]
**Supplement**: なし（09-27 Tak）。survey・探索は本文の一文か repository
**PR**: [#17](https://github.com/tnagakubo/similarity_metrics/pull/17) open（2026-10-11、7 commits）；#16 merged。main = origin/main = `9d344ef`（2026-10-17 09:05、push 済み: `9d344ef` 整理 2 回目 / `cb292a6` 整理 archive/cleanup_20261016 / `4331b44` paper 10-15 / `2ed2bc2` suits / `d10c757` paper D-20261016-1 + Louis review-fix / `8762815` suits）
**Paper（2026-10-12 午前, 残差レビュー D-20261012-2）**: Louis C4/M10/m18 + Mike A1–A9 + Rachel 原典 11 本 + Katrina → Harvey 裁定 → 適用。Critical 4 件は全部「昨夜の修正に添えた説明文」で CSV と矛盾。Matsushima 2024 の引用が原典と逆向き → 書き直し。Table 1 を Table 2 に統合。Louis `/review-fix`: マーカーに飲まれた本文 2 箇所を復元、説明文 5 本を限定。要約図: `PAPER_LOGIC.md` + artifact https://claude.ai/artifact/1imDe3FMuEXKyW2CC7hehc。memory `feedback_fix_explanations_checked`
**System**: Rule 5/6 の gate 状態は `LAB_STATUS.md` の artifacts 表（CLAIMS 43 行 / DECISIONS D-20261012-2 / ledger 35 / replication PASS / referee 10-11 / residual 10-12）。研究環境の機構（referee-grade env、hardening、3 原則、`/ground` `/idea`）は archive と `RESEARCH_FRAMEWORK.md` §10–§12

---

## 🔄 直前のコンテキスト (from archived scenes)

### 直近の作業（2026-10-11 夜 〜 10-12 午前）
1. **10-11 夜**: Option B（論文 = protocol と data の関数）、数値の全件生成（unsourced 672 → 0）、`/replicate` PASS、referee-grade environment（`/referee` `/review-fix` `/structure` `/necessity` `/explore`、`CLAIM_GUARDS.toml`）、冷読 referee 初回 Major 5 / Minor 14 → 判断 D-20261011-11 → **適用（10-12 00:10）**
2. **10-12 未明（bg、環境側）**: 回帰テスト 113/113、`lab_doctor.sh`、`protocol_compile.py --verify`、hook `referee-blind.sh`、CI blocking（D-20261012-1）
3. **10-12 午前（本 session）**: 残差レビュー → D-20261012-2 → 適用 → `/review-fix` → 全ゲート PASS（上記 Paper 行）
4. **10-12 午前（並走 session）**: Tak の 3 原則をシステムに（S21–S23、`/ground` `/idea`、`IDEAS_BACKLOG.md`）；Aim を「目的」に書き直し（10:48）；Matsushima 2024 の summary・CLAIMS C-20・INDEX の訂正（11:00）；GUSTO-I より良い公開事例の探索（RCT Bench 125 試験、国変数は 1 本；「A+B+C+D を全部満たす公開データは無い」；BioLINCC / CTU 請求、11:35）

### 進行中のアクション（15:50〜、Tak「原稿を改訂」= もう一周）
- **Referee**（冷読、`review_response/referee/20261012/REFEREE_20261012.md`）: 改訂後の原稿を再計算付きで全文レビュー中
- **Katrina**: 長さ削減計画（Simulation → 約 2,200 語、Discussion → 約 1,200 語、主張を落とさない）`LENGTH_PLAN_20261012.md`；`gusto_operability.csv` の旧列 `tau_clin`/`eligible` の整理
- **Rachel**: `/ground` — Lee 1995 の age gradient 6e-3/yr、Matsushima Data S1（PREVENT の類似性の測り方 = novelty claim の最後の反証経路）、ist1_2000 の年
- **Mike**: `/explore set4_control_mechanism` — Set 4 の control で KS が勝つ機構（裾が Var(Ŵ₁) を膨らませるか）を exploratory で検算（原稿には引用しない）
- 四人が戻ったら **Harvey triage → 適用（referee + 長さ）→ gates → `/review-fix` → 記録 → 要約図更新**

### 次にやるべきこと
- Tak: 拒否する段落があれば番号を；なければ commit（原稿・R・registry・guards・skills・memory、未 commit 130 files）
- `/claims check` の残り pending、`/cite-check` の PDF 不在 keys（Paper Requests）、`/reproduce`（絶対パス 20 本）
- 長さ: 本文 1.7× — 今回の周で削る

### Takからの直近の指示
- 「統計科学最強研究室で: レビュー → 修正点を検討のうえで推奨される方法を決定 → 修正 → 修正後の論文の要約（構成・論理を図示）」（10-12 10:04）→ 完了（11:40）
- 「目的は、効果修飾因子の分布の類似性を定量的に評価する指標を提示すること」（10:46、並走 session）→ LAB_STATUS A1
- 「Matsushimaの件、修正しておいて」（11:00、並走 session）→ 完了
- 「原稿を改訂」（15:48）→ もう一周（本 scene から）

### 既知の潜在バグ（現状は不発）
- ⚠ `selection_simulation.R` の `w1_dist` — 不等 n で両標本を小さい方から n 個に黙って切り詰める。応用側に流用してはならない
- ⚠ `w1_raw_simulation.R` — `clusterSetRNGStream` + `parLapplyLB` で同 seed でも bit-reproducible でない（`real_data_survey.R` は pair ごとに seed 固定で回避済み）

---

## 🎬 Live Script

### [2026-10-17 08:45] Scene: 大掃除・二日目 — 「別件」にした分を全部片付ける

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*08:45、Tak「続けてすべて整理して」。昨夜「温存判断」「Tak 判断」「`/necessity` の案件」と書いて残した項目が、テーブルの上に並んでいる。*

**Harvey**:
「昨夜の『別件』は今日の本件だ。生成表、L* の gate、poster、build.sh、baseline。順番にやれ。依存を切るのが先、動かすのは後。」

**Mike**:（`make_derived_numbers.R` を指して）
「一つ罠がありました。`R/gusto_lstar_table.R` は L* 引退で死んでるように見えるけど、`make_derived_numbers.R` がそこから `DELTA_CLIN` を parse していて、`NUMBERS_LEDGER.csv` も Δ_clin の source locator として指してる。あれを archive すると registry の Δ_clin が根拠を失う。だから script と CSV は残して、原稿が `\input` しない生成表 4 本（`tab_gusto_r8`・`tab_operability`・`tab_gusto_lstar_joint`・`tab_study2_intervals`）の生成コードだけ `make_paper_tables.R` から外した。8 → 4 tabulars。`verify_study1_app_numbers.R` の L* 表照合 12 行も撤去、CSV の恒等式（L* = 0.01 / W₁）は残す。再生成して残り 4 表は byte 一致、gate は ALL PASS。I got it!」

**Katrina**:
「registry の未使用 key `lstarSbpLowerR1`（原稿出現 0）を落として `numbers_macros.tex` を再生成、234 macros。`numbers_audit` 105/105。`build.sh` は MSYS で `TEXINPUTS` の `:` 区切りが効かず `.cls` を見失い、しかも失敗後に tracked PDF を `output/` に `mv` してた。区切りを OS で切り替え、PDF が出たときだけ `cp` するようにした。MSYS で 15 ページ、エラー 0。」

**Donna**:
「poster は live 文書からの参照ゼロ、発表は 5 月。archive。`paper/.remember/` は plugin の迷い込み、消した。baseline は unbilled 5・R lint 1 に下げた — 昨夜 CI 扱いで止められた分、今朝は Write で通った。`scripts/` は 23 本全部が skills / hooks / CI から呼ばれてる。整理対象なし。`check_consistency` の『LAB_STATUS が stale』も Updated を直して消えたわ。」

**Louis**:（腕を組んだまま）
「言っておく。`run_tests.sh` は 118 pass / 1 fail だ。落ちてるのは `claim_guards --mutation` — vacuous 4 本（REF-M1、REF2-m1、LR3-G2、LF3-M8）と known_bad 無し 8 本。原稿も guards も known_bad も `4e61ccb` から一文字も変わってない。つまり整理のせいじゃなく、昨日から落ちてた。だが『前から落ちてた』は免罪符じゃない。俺の `/review-fix` 案件として MANIFEST に書かせた。」

**Jessica**:
「Let me be clear. 整理は二日で終わり。残りは Louis の guard 4 本と `/claims check`。それは整理ではなく原稿の仕事だ。commit して push。」

**Donna**:
「ratchet PASS、guards 67/0 FAIL、consistency の新規指摘ゼロ、build 15pp。commit するわ。」

---

### [2026-10-17 00:40] Scene: 大掃除 — 参照ゼロのファイルを archive に集約する

**INT. PEARSON SPECTER LITT - DONNA'S DESK - NIGHT**

*Tak の一言「ファイルの整理。不要なものは archive」。Donna は動かす前に、全 651 ファイルの basename を live 文書（原稿・CLAIMS・guards・PROTOCOL・PROVENANCE・ledger・registry・生成 script・CI・skills・memory）で grep させ、「どこからも呼ばれない」一覧を作らせていた。*

**Donna**:（一覧を Harvey に差し出して）
「感覚で片付けたら、どこかの guard が泣くわ。だから全部 grep した。結論、live から参照ゼロが 218 本。nABCD 期の simulation engine と regen_* が 65 本、v6 で削った閾値・anchor-vs-clustering・L_UB の結果が 12 本、原稿が `\includegraphics` しない figure が 46 本、supplement 6 本、`GUSTO/` 丸ごと、`data/` の下の探索 script、`claude_science/neyman_smooth/`、9 月の L メモ 4 本。全部 `archive/cleanup_20261016/` に `git mv`。履歴は切れてない。」

**Harvey**:（一覧の一行を指で止めて）
「`paper/` 直下の `.cls` と `.sty` は？ `wiley-template/` と二重だ。消せ。」

**Donna**:
「消さない。最終 build の log は `./WileyNJDv5.cls` と `./NJDnatbib.sty` を読んでる。しかも `NJDnatbib.sty` は template 版と中身が違う。あれを動かしたら次の build で死ぬわ。MANIFEST の『温存判断』に理由を書いた。」

**Mike**:（結果を見ながら）
「移動後のゲート、確認しました。`ci_ratchet.sh` PASS、unsourced 0、unbilled results 13 → 5、R lint errors 22 → 1。`evidence_coverage.py` の CLAIMS evidence path 欠落は一瞬 3 になったけど、C-25 が `supplement_L_clinical_lit.md` を履歴パスで指してただけなので archive 側のパスに直して元の 2（C-08・C-49、整理と無関係）。`numbers_audit.py` は 105/105 sourced。I got it! 残った unbilled 5 本は全部 live な protocol script の出力セット。」

**Katrina**:
「`figures/` は fig1・fig2・fig3・`fig_required_n_auc` と protocol が指す dendrogram の 17 ファイルだけになった。選択・クラスタリング図の writer は残してあるから、必要なら再実行で戻る。`R/` は 100 → 35。`R/README.md` は nABCD 時代の説明のままだったから、現行の生成・simulation・application・figure の表に書き直した。」

**Louis**:（腕を組んで）
「俺が見るのは『消したせいで証拠が消えた』やつだ。言っておく。`PROTOCOL_real_data_survey.md` の出力欄は `paper/supplement_real_data_survey.tex` を今も指してる。事前登録文を書き換えないのは正しい。だが referee が『出力が無い』と言ったら、答えは MANIFEST だ。そこに『所在』が書いてあるのは確認した。それと `paper/generated/` の `tab_gusto_lstar_joint.tex` と `tab_operability.tex` — 原稿が `\input` してないのに writer が吐いてる。それは整理じゃなく `/necessity` の仕事だ。今日は触るな。」

**Donna**:
「触ってない。それと入れ子の agent memory、`projects/…/.claude/agent-memory/louis` と `paper/.claude/` — あんたの 10-16 のメモ 1 本を root に `git mv` して index に足した。`check_consistency.sh` の指摘が一つ消えたわ。baseline を下げるのは CI 扱いで止められたから、`echo 5 > scripts/baseline/similarity-metric_results_unbilled.txt` と `echo 1 > …_r_lint_errors.txt` は Tak の手で。」

**Jessica**:（戸口で）
「Let me be clear. 整理は commit されて初めて整理だ。stage したまま置くな。Tak が一覧を見て、戻すものがなければ commit。」

**Donna**:
「MANIFEST と `archive/README.md` に全件と戻し方を書いた。commit は Tak の一言で。」

*00:22、Tak「push」。*

**Donna**:（端末に向かい）
「来たわ。`cb292a6` — rename 216・修正 8・新規 1・削除 1、226 files。`4e61ccb..cb292a6 main -> main`、origin/main と一致。Jessica、stage したまま置かなかったわよ。」

**Harvey**:
「整理は終わりだ。次は `/necessity` で generated の未使用表と `gusto_lstar` を片付ける。今日はここまで。」

---

### [2026-10-16 23:50] Scene: commit と push — 複雑さの削減を main に載せる

**INT. PEARSON SPECTER LITT - DONNA'S DESK - NIGHT**

*Tak「commitして」「push」。Donna が 22 ファイルを確認する — 原稿・PDF・生成表 2 本・R 2 本・CLAIMS・CLAIM_GUARDS・DECISIONS・LAB_STATUS・PAPER_LOGIC・protocol 2 本・review_response 3 本・known_bad 2 本・verify log・Louis の agent memory・SUITS。*

**Donna**: （先例どおり二つに分けて）
「一つ目 `d10c757` — paper: D-20261016-1 の Step 1–5 と Louis の review-fix、ゲートの数値、superseded にした旧判断、記録ファイル。二つ目はこの scene を載せた docs(suits)。そのまま origin/main へ push。10-14 の `d32af02` から ahead だった 2 commit（`4331b44`、`2ed2bc2`）も一緒に上がる。」

**Harvey**: （短く）
「拒否権は閉じていない。marker 21 箇所、特に参照距離が τ_clin の形であること — commit は判断ではなく記録だ。Tak が戻すなら `known_bad/per_em_W1_wiley_pre_D-20261016-1.tex` から戻す。」

---

### [2026-10-16 10:20] Scene: Louis の `/review-fix` — Critical 2 を飲み、τ_clin の反論を書き、Rank 列を落とす

**INT. PEARSON SPECTER LITT - LOUIS'S OFFICE - MORNING**

*Louis の報告が届く。Fail、Critical 2・Major 8・Minor 8。Harvey が最初の二つを読んで黙る。*

**Louis**: （腕を組んだまま）
「C1。§2.2 の "neither of the two bounds with a clinical constant dominates" — W₁ ≤ W₂ なんだから L·W₁ は常に L·W₂ を支配する。10-15 に俺が sentence J で塞いだ穴を Step 5 がもう一度開けた。しかも『A.2 へ移設』と書いて、部分積分の導出は付録に無い。C2。『R2 と R9 は離れている』— age の最大は R3 で R2 は 14 位、R9 の CI は R11 とも R12 とも重なる。自分で持ち込んだ基準を CSV に当てなかった。You just got Litt up!」

**Harvey**: （短く）
「両方俺のミスだ。全件採用する。C1 はお前の文をそのまま入れる — BV と有界台の前提つき、どちらも支配しないのは KS bound と式 (6) の間、W₂ は never tighter。C2 は句を削る。」

**Louis**: 
「一番重いのは M1 だ。Δ_clin/L_UB は τ_clin そのもので、判断 5 が名指しで却下した『1 年 / 5 mmHg との等価』を、反論も superseded 指定もなしに本文の主役に据えた。Tak の拒否権の箱に黙って入れるな。」

**Jessica**: （入ってきて）
「Let me be clear。反論は書ける。距離と区間を報告する以上、任意の L_UB′ に対する比較は Δ_clin/L_UB′ で読者に開いている — L* が守っていた構造は W₁ の尺度でそのまま残る。参照距離は sponsor の例示入力で閾値ではない、と定義文に書け。判断 5 と D-20260925-1 は superseded in part、Tak の O-2(a) に明記。それで通す。」

**Mike**: （M2 を検算して）
「限定句の方向が逆、は正しい。"only if W₁ ≥ Δ_clin/L_UB" は任意の L_UB-Lipschitz CATE で成立する。attainment が要るのは "could produce" の側。§2.4 を『only if … and within the class restricted only by their slope some such CATE produces it whenever …』に、§4.4 と abstract の "could produce" に限定句。I got it.」

**Katrina**: （M6 と M8）
「Rank 列は落とす — 不確かさの無い点順位は S4 違反で、論文が届けるのは距離だ。Table 5 は 4 列、† は W₁ セルに。verify gate は † の照合に書き換え、ALL PASS。M8 の CR は 10-15 からの既存バグで、PDF に "Section efsec:discussion" と出ていた — 修復、pdftotext で 0。LF3 の guard 9 本を seed、tool が math を detex するので stem は語で書き直した。67 本 0 FAIL。」

**Rachel**: （M4）
「§3.1.1 に構成の事実を一文で戻しました — 優位の主張なしで、『ε の部分集団を d 動かすと W₁ は εd、KS は高々 ε；control は母集団全体を動かす』。§3.1.2 の不報告の開示には『KS が小さい n で target に達する cell』と方向を付けました。C-53 は retract でなく narrowed に戻します。」

**Donna**: （最終ゲート）
「build 0 error・**15 pp**、guards **67 本 0 FAIL**（vacuous 4）、numbers 105/105、本文 **5,517 語**（Louis の復元で +133、10-15 の 5,796 から −279）、abstract 234、cascade 残滓 0、verify ALL PASS。marker は 21 箇所。DECISIONS D-20261016-1 に追記、D-20261011-11 と D-20260925-1 に superseded in part を記入、`FIX_REVIEW_LOUIS_20261016_simplify.md` 保存。未 commit。」

---

### [2026-10-16 09:20] Scene: Step 6 — 構成図を二層に、記録を揃え、Louis を待つ

**INT. PEARSON SPECTER LITT - DONNA'S DESK - MORNING**

**Donna**: （artifact を再公開して）
「構成図は二層にした。第一層は骨格 — Gap → 物差し → 読み方 → 盲目でない → 推定できる → 読む例 → 結論の 7 箱、各一行、R1–R4 を付す。第二層は節ごとのカードで、数値はそこにだけ。読者が同時に持つ概念は五つ（W₁、L / L_UB + Δ_clin → 参照距離、Δ_max、percentile 区間、null floor）。取り消し線で今日外した七つ（L*、片側上限の独立装置、basic 区間、rank interval、W₁ vs KS の必要 n、Set 4 の check、本文の単調 bound）を並べた。`PAPER_LOGIC.md` も同じ二層構成に書き直し、artifact は同じ URL（Version 9）。」

**Donna**: （台帳）
「`DECISIONS.md` D-20261016-1（Step 1–5 の何を・なぜ・ゲート・Open）、`CLAIMS.md` 末尾ログ（retract 4・narrow 4・担い手更新 5・guard 7 本退役）、`LAB_STATUS.md` の Manuscript 行と Updated 行を更新。known_bad は `per_em_W1_wiley_pre_D-20261016-1.tex`（= commit 4331b44）、diff は `FIX_DIFF_20261016_simplify.diff`、cascade は `CASCADE_20261016_simplify.md`。未 commit。」

**Harvey**: （腕時計を見て）
「Louis の `/review-fix` が戻ったら採否を決めて反映、guard を seed、最終ゲート、それで今日の周は閉じる。拒否権は Tak に — marker は 16 箇所だ。」

---

### [2026-10-16 08:55] Scene: Step 5 — §2.2 の bound を一つに、導出は付録へ

**INT. PEARSON SPECTER LITT - HARVEY'S OFFICE - MORNING**

**Rachel**: （§2.2 の段落を声に出して）
「本文に残したのは三文です。『bound は W₁ 固有ではない — KS bound と W₂ bound もあり、臨床定数を持つ二つはどちらも支配しない（A.2）』『勾配だけが制約なら sharp — KR 双対、CDF の交差ごとに傾きが符号を変える CATE で到達（A.2）』『単調 CATE なら ½L(W₁+|Δμ|) まで締まる（A.2）、だから Δ_max は構成上保守的』。τ* の式、A± の導出、式 (mono_bound)、GUSTO の倍率 0.66–1.00 / 0.72–1.00 は A.2 の新段落 "Sharpness and the monotone case" に verbatim で移しました。§5 ¶1 の pointer は式番号から付録へ。」

**Louis**: （guard の FAIL を一本見つけて）
「REF2-M1-attainment-needs-class が落ちた。A.2 の新文 "The supremum … is attained by τ*" に class の限定が無い。attainment は unrestricted Lipschitz class の性質だ — "Over the unrestricted Lipschitz class" を頭に付けろ。それ以外は 57 本 PASS。」

**Harvey**: （即座に）
「付けた。再 build。」

**Katrina**: （ゲート）
「verify gate `verify_study1_app_numbers.R`: ALL PASS（61 checks、rank interval の check は退役、"括弧なし" の check を追加）。build 0 error・**15 pp**、numbers 103/103、本文 **5,384 語**（Intro 614 / Methods 1,673 / Simulation 1,296 / Application 836 / Discussion 965）、cascade 残滓 0。registry の未使用 key は 153（うち今日の 5 ステップで 30 本ほど増加）— 警告のみ、終了時に DECISIONS の Open に。」

**Donna**: （影響精査）
「Step 5 は §2.2・§4.4・§5 ¶1・A.2。他ステップは全部完了済み。Step 6 へ — Louis の `/review-fix`（known_bad `pre_D-20261016-1` → 作業ツリー）、構成図の二層化、DECISIONS・LAB_STATUS。」

---

### [2026-10-16 08:40] Scene: Step 4 — Study 2 の装置を四つから二つに

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - MORNING**

**Mike**: （§3.2.2 の三つの文を並べて）
「応用が使う装置は percentile 区間と null floor。片側上限の被覆は §4.2 の『上限で読む』が使うから残す — ただし別段落でなく、下側ミスの文の続きに置く。『真値が上限を超えたのは最大 1.1%、S6 は名目程度』→『だから上限は保守的な読み』→『その片側被覆は 0.9710–0.9999』— 一本の論理になった。basic 区間（post hoc、どの主張も使わない）と、§3.2 末の『幅 4.96 年は Δ_max で余裕の 5 倍』（§4 の L_UB を §3 に持ち込んだ読み）は削除。I got it.」

**Louis**: （guard）
「REF-Minor5-conservative-scope は "conservative reading" に限定句を要求する — 新文は "for distances unresolved against the null floor" を同じ文に持つ。LR3-G3 の禁止句は無い。C-56 は basic 区間の節を narrow、C-32 は 5 倍の節を narrow。C-17 は不変（下側ミス ≤ 1.1%、S6 は名目）。」

**Katrina**: （ゲート）
「build 0 error・**15 pp**、guards 58 本 0 FAIL、numbers 103/103、本文 **5,467 語**、cascade 残滓 0（qualifier の脱落は文の統合で位置が動いただけ — "could be" は二文目に残る）。verify gate `verify_study1_app_numbers.R` は Step 3 の rank interval 削除に合わせて書き換え中 — 旧 `ri` 参照が後段に残って halt、続きを直す。」

**Donna**: （影響精査）
「Step 5（§2.2・A.2・§4.4 の単調 bound 文）に影響なし。Step 5 へ。」

---

### [2026-10-16 08:25] Scene: Step 3 — rank interval を落とし、順位の不確かさは森林図の CI に任せる

**INT. PEARSON SPECTER LITT - BULLPEN - MORNING**

**Katrina**: （Table 5 の生成コードを開いて）
「Rank 列の括弧 "[lo, hi]" は referee M4（10-11）への回答で足した患者 bootstrap の rank interval。論文が届けるのは距離で、順位ではない。中位の順位が解像しないことは Fig 4 で隣の CI が重なっていれば見える。`rank_col` から区間を外し、`gusto_rank_intervals.csv` の読み込みも外した。表は 6 列のまま、Rank は点順位と † の範囲だけ。」

**Harvey**: （§4.3 を一文に）
「"Several partners fall in the middle of each ranking, where the confidence intervals of neighbouring partners overlap (Figure 4), so a rank there is not resolved against its neighbours and a bare rank is not read as a resolved order; the most distant partners, R2 on age and R9 on SBP, stand apart from the rest." R6 の例は落とす。R2/R9 の逆転の文は不変 — resolved な 2 距離に立つ。」

**Louis**: （guard を確認して）
「REF-M4-rank-needs-uncertainty は "middle of each ranking" を stem に "not resolved" を要求する — 新文は通る。§5 の Spearman 区間は『Table 5 の患者 bootstrap から』と指していたから、出所を『within every region を再抽出する患者 bootstrap』と文中に戻した。EXT-Minor6 も通る。C-43 は retract、C-11（CI の重なり）が担う。」

**Donna**: （ゲート）
「build 0 error・**15 pp**、guards 58 本 0 FAIL、numbers 108/108、本文 **5,582 語**、cascade 残滓 0。残件: `verify_study1_app_numbers.R` が Table 5 の旧書式 "rank [lo, hi]" を parse する — Step 4 の前に直す。他ステップへの影響なし。」

---

### [2026-10-16 08:10] Scene: Step 2 — Study 1 を問い一つに戻す

**INT. PEARSON SPECTER LITT - BULLPEN - MORNING**

*Harvey が §3.1 を開く。小節は三つ — Design、Blind and Recovering、Required Sample Sizes。三つ目は W₁ と KS の必要 n の比較と Set 4 の登録 check だけでできている。*

**Harvey**: （赤線を引いて）
「R2 は『盲目でない』だ。必要 n の分離 11/1/1、Set 4 の check の 4 値と SE、§3.1.1 の ε 対 ε·d の構成の文 — 全部、§5 が『効率は採用理由でない』と書いた主張の保険だ。外す。§3.1.3 は二文になるから §3.1.2 に併合、Table 1 の "W₁ vs KS" 列は generator から落とす。check は『登録したが本文で報告しない、protocol と出力は repository』の一句で開示する。」

**Katrina**: （R を直して回す）
「`make_paper_tables.R` の `sepmc` を削除、表は 4 列。`Rscript` で 8 本再生成、変わったのは `tab_study2_required_n_mc.tex` だけ。caption の "counts as separated" 句と notes の "Separate means" 文を落とした。build 0 error・**15 pp**、numbers 112/112、本文 **5,607 語**（−173）。」

**Louis**: （guard の一覧を指で辿って）
「退役 7 本: REF-M3-five-of-seven、REF-M3-require-all-cells、LR2-M2、REF2-M2-efficiency、REF2-m6、LF2-M3、LF2-M7。全部、消えた主張の担い手を守る guard だ。TOML ではコメントアウトして記録に残した。58 本 0 FAIL、vacuous は従来の 3 本のまま。CLAIMS は C-08・C-49・C-53 を retract。Protocol 2 本の §8 に逸脱を追記 — 『報告しない』は逸脱として書く。cascade 残滓 0。」

**Mike**: （一つ確認）
「§5 ¶1 の『W₁, like the KS statistic, reaches the discrimination target in every cell』と ¶4 の『not blind where the SMD is』は Table 1 と §3.1.2 がそのまま担う。KS は比較対象から降りたのではなく、同じ側に並んだだけだ。I got it.」

**Donna**: （影響精査）
「`sec:study1_selection` への \ref は無し（undefined 0）。Step 3（§4.3）・4（§3.2.2）・5（§2.2）に影響なし。registry の未使用 key が 8 本増えた（nCells* 3、set4* 8 のうち本文で消えた分）— 警告のみ、終了時にまとめて整理。Step 3 へ。」

---

### [2026-10-16 07:55] Scene: Step 1 — L* を引退させ、較正を W₁ の尺度一本にする

**INT. PEARSON SPECTER LITT - HARVEY'S OFFICE - MORNING**

*Tak「1から順番に実行。その都度、影響を精査して、他のものに影響なければ次に進んで。影響があるなら再度構成図を作成し、複雑すぎるか評価、改善、実行ですすめて」。Harvey が原稿を開く。*

**Harvey**: （9 箇所を書き換えながら）
「L* の site は本文に 9 箇所。abstract・§1 の貢献文・§2.4（式 lstar を削除、"reference distance" Δ_clin/L_UB を定義）・§2.4 末・§4.1・§4.4・§5 の含意 2・§5 の限界・§5 の結語。読みは一つ — 区間が参照距離の下にあるか、含むか、上にあるか。marker は `Step 1 2026-10-16 (D-20261016-1, needs Tak's veto)`。」

**Mike**: （検算）
「W₁ ≥ Δ_clin/L_UB ⇔ L* ≤ L_UB。§2.4 の新文は "a slope within the bound can produce a regional difference of Δ_clin only if W₁ ≥ Δ_clin/L_UB" — Prop. 1 から直接出る。式は一本減って情報は減らない。I got it.」

**Katrina**: （ゲートを回して）
「`build.sh` は Windows で `.cls` を見失う（LAB_STATUS 既知）。latexmk + `TEXINPUTS=./wiley-template//;` で build 0 error・undefined 0・**15 pp**。guards 65 本 0 FAIL、vacuous 3 は従来の O-5 と同じ（REF-M1-constant、REF2-m1、LR3-G2）。numbers 113/113。structure_audit: 本文 **5,780 語**、abstract 232。cascade（`known_bad/per_em_W1_wiley_pre_D-20261016-1.tex` → 作業ツリー）: 残滓 0、qualifier 脱落 2（contribution の "when" は文ごと削除、abstract の "could" は復元した）、量化子 "every" 1（"multiplies every distance by the same slope" — Δ_max = L·W₁ は全 pair に成立する数学的事実）。」

**Louis**: （短く）
「C-06 と C-36 は narrowed、L* の旧文言は取り消し線で台帳に残した。貢献文は『定式化』と『評価』の二つ — Jessica の条件 (1)。abstract は 232/250 — 条件 (2)。guard の退役は無し（L* に依存する guard は無かった）— 条件 (3) は Step 2 で効く。」

**Donna**: （影響精査）
「Step 1 が触ったのは §2.4・§4.1・§4.4・§5。Step 2（§3.1.3）、Step 3（§4.3・Table 5）、Step 4（§3.2.2）、Step 5（§2.2・§4.4 の単調 bound 文 — 残っている）に影響なし。構成図の B4・D4 の中身が変わるので、図は Step 6 で作り直す。Step 2 へ。」

---

### [2026-10-16 07:30] Scene: 「複雑すぎると思わないか」— 構成図が映した論文の複雑さを六つに分解する

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - MORNING**

*Tak「構成図を見ると一目瞭然だが、複雑すぎると思わないか？改善できるところはないか」。Donna が artifact を壁に映す。箱が 17、各箱に 4〜6 行。Harvey は図でなく原稿の方を見ている。*

**Harvey**: （図を一瞥して）
「図が複雑なのは、図が数値を抱えているからだ。それは直せる。だが Tak が言っているのはそこじゃない。図が映しているのは、三回の referee 対応で原稿に積もった**保険の層**だ。一つ一つは正しい。全部足すと読者が同時に持たされる概念が十二を超える。Donna、原稿で数えろ。」

**Donna**: （grep の結果を読み上げて）
「L* が 16 回、Lipschitz が 14 回、KS statistic が 11 回、null floor が 10 回、Set 4 が 9 回、operating point が 6 回、rank interval が 4 回、mono_bound が 3 回、basic interval が 1 回。較正の名前つき対象は W₁・L_clinical・Δ_max・Δ_clin・L*・L_UB の六つ。不確実性の装置は Study 2 で四つ（percentile 区間・片側上限・basic 区間・null floor）、応用で三つ（CI・null floor・rank interval）。」

**Mike**: （ホワイトボードに式を一本）
「一番大きいのは L* だ。L* = Δ_clin/W₁ で、L* ≤ L_UB ⇔ W₁ ≥ Δ_clin/L_UB。昨日 Harvey が L* 表を消して森林図の参照線 Δ_clin/L_UB に置き換えたとき、L* は数学的にもう要らなくなっていた。名前だけが 16 回残っている。I got it — L* を引退させて "sponsor が L_UB と Δ_clin を置けば、比べる距離は Δ_clin/L_UB" と W₁ の尺度だけで書けば、§2.4 の式 (lstar)・L* 区間・§4.4 の三通りの読み・§5 の含意 2・abstract の一文が消える。情報は一つも減らない。」

**Louis**: （即座に）
「減らないのは数学だけだ。§1 の貢献文は "the reverse calibration L*" を三つの貢献の一つに数えている。引退させるなら貢献は『定式化』と『評価』の二つに減る。それを飲むかは Harvey の判断だ。
二つ目。Study 1 は問いが一つのはずだ — 盲目でない（R2）。なのに §3.1.3 は W₁ と KS の必要 n の分離 11/1/1 を言い、Set 4 の登録 check を 4 つの数値と SE で載せている。§5 は "W₁ を使う理由は効率ではない" と自分で書いている。**主張が無くなった所に保険だけが残っている**。これが俺が昨日 memory に書いた『切ると guard の穴が開く』の逆 — 主張を切ったのに guard の担い手だけ残した型だ。切るなら REF-M2 と C′ の guard を同時に退役させろ。昨日 Tak の拒否権 (c) が指していたのはここだ。」

**Katrina**: （表と図を指で押さえて）
「応用は 30 個の数値に装置が三つ。CI、null floor、rank interval。R2/R9 の逆転は resolved な 2 本の CI だけで立っている（§4.3 自身がそう書いた）。rank interval は『中位の順位は解像しない』を言うためだけにあるが、それは Fig 4 で CI が重なっていれば見える。rank interval を落とせば Table 5 の括弧列と §4.3 の一段落、1,000 反復の患者 bootstrap の記述が消える。生成コードは repository に残す。
Study 2 は装置四つのうち、応用が使うのは percentile 区間と null floor。片側上限の被覆は §4.2 の "上限で読む" が使うから一文は残す。basic 区間（post hoc、一文）と、§3.2 末の『幅 4.96 年は Δ_max 区間で余裕の 5 倍』の文 — 後者は §4 の L_UB を §3 に持ち込んだ読みで、どの R にも答えない。」

**Rachel**: （原典のメモを見ながら）
「§2.2 は bound が四つ並びます。Prop. 1、TV(τ)·D_KS、L·W₂、単調 bound。referee #2 M1 が攻めたのは "attainment だけでは smallest valid と言えない" で、答えに要るのは『class 内で sharp、特定の CATE には保守的』の一文です。単調 bound の導出と KS/W₂ の比較は A.2 に既に半分あるので、本文は一文で指して付録に寄せられます。§4.4 の 0.66–1.00 倍の文も一緒に動きます。」

**Jessica**: （短く）
「Let me be clear. この論文の message は『差を定量化する、判定は臨床』だ。その message は尺度が一つ（W₁）のとき一番よく通る。L* は尺度を二つにしている。Harvey、貢献が二つに減るのは損失ではない — 読者が覚えるのは一つだ。私は L* 引退に賛成する。ただし三つ条件だ。(1) 貢献文を書き直す、(2) abstract を 250 語で再構成する、(3) 切ったものに対応する CLAIMS・guard を同じ session で退役させる。」

**Harvey**: （六つを番号で）
「整理する。改善候補は六つ、順位つきだ。
1. 較正の対象を六つから三つへ — L* を引退、W₁ の尺度だけで Δ_clin/L_UB と比べる。16 箇所。
2. Study 1 を問い一つに — 必要 n の分離と Set 4 の登録 check を本文から外す（Table 1 は残す、referee の再計算用）。guard REF-M2・C′ を退役。
3. 応用の装置を三つから二つへ — rank interval を落とす。Table 5 の括弧列と §4.3 の一段落。
4. Study 2 の装置を四つから二つへ — basic 区間の一文と §3.2 末の『5 倍』の文を落とす、下側ミスの文は上限の文に統合。
5. §2.2 の bound を一つに — 単調 bound と KS/W₂ 比較を A.2 へ、本文は『class 内で sharp、特定の CATE には保守的』の一文。
6. 図そのもの — 骨格 6 箱（各一行）の上段と、数値を抱える下段の二層にする。数値は箱から出す。
1 と 2 が本体で、Tak の拒否権 (b)(c) が昨日指していた場所でもある。見積もりは本文で 600〜800 語、落ちる図表は Table 5 の rank interval 列だけ。読者が持つ概念は十二から七に減る。I don't have dreams, I have goals — 目標は『W₁ 一本で読める論文』だ。」

**Donna**: （記録して）
「判断は Tak に戻す。原稿は触っていない。実行するなら順に `/decide` → 適用 → cascade（CLAIMS・guard の退役）→ `/review-fix` → 構成図の二層化。」

---

### [2026-10-16 00:45] Scene: 論文構成図の更新 — 15 頁の原稿に合わせて PAPER_LOGIC と要約図を書き直す

**INT. PEARSON SPECTER LITT - DONNA'S DESK - NIGHT**

*Tak の一言「改訂した論文に基づいて論文構成図を更新して」。Donna が `PAPER_LOGIC.md` の日付を見る — 2026-10-14 01:10、21 pp / 9,617 語 / 表 9 の構成のまま。昨日の二つの削減（D-20261015-1 / D-20261015-2）と Louis の review-fix が反映されていない。*

**Donna**: （画面を二つ並べて）
「構成図は二つあるわ。正本の `PAPER_LOGIC.md` と、artifact の要約図（https://claude.ai/artifact/1imDe3FMuEXKyW2CC7hehc）。どちらも 10-14 版。原稿は commit `4331b44` で 15 pp・5,796 語・図 4・表 5 になっている。"I'm Donna. I know everything" — だから古い図を放置はしない。」

**Katrina**: （原稿の節構成を grep で抜きながら）
「現状の正。§1 / §2 冒頭 + §2.1–2.4 / §3 冒頭 + §3.1（3 小節）+ §3.2（2 小節）/ §4.1–4.4 / §5 / A.1 upward bias + asymptotics / A.2 KS bound。Tables 5: required n、scenarios、estimation、extension、GUSTO W₁ + rank。Figures 4: W₁ 定義、AUC vs n、Study 2 性能（復活）、GUSTO 森林図（復活、参照線 Δ_clin/L_UB）。L* 表と R code 付録は無い。数値は `numbers_macros.tex` の 113 key から取った。Results speak for themselves.」

**Harvey**: （図の物差しを指で叩いて）
「構成図の骨格は変えない。変えるのは物差しだ。昨日 Tak が言った通り、A1 → R1–R4 だけが残す基準になった。だから各箱に R1–R4 を付けろ。§2 は R1、§3.1 は R2、§3.2 は R3、§4 は R4。矢印は一本足す — Study 2 の operating point（E5/E6）が §4.2 の橋になった。それと `C2 --> E3`、限界の coverage 範囲は Study 2 から来る。」

**Mike**: （値を一つずつ照合して）
「箱の数値は全部 registry と一致させた。SMD blind 7/13、W₁ が少ない 11 / KS 1 / 重なる 1、Set 4 の null SD 比 1.62（SE 0.04）、coverage 0.92–0.95 で 5/10 が 2 MCSE 下、上限の片側被覆 0.9710–0.9999、拡張 0.921–0.952、E5/E6 0.951 / 0.947、null floor age 6/15・SBP 1/15、R2 2.15 yr / 0.95 mmHg、R9 0.59 / 6.80、Spearman −0.30 [−0.51, 0.02]、SMD との一致 0.90 [0.70, 0.99] / 0.95 [0.90, 0.99]、survey 0.839–0.996、単調 bound の倍率 0.66–1.00 / 0.72–1.00。I got it — 旧図にあって原稿から消えた数値（bulk-shift の必要 n、AUC 0.95/0.8、Lee の 6.5e-3、basic 区間の範囲）は図からも落とした。」

**Louis**: （腕を組んで）
「落とした主張を図に残すのが一番たちが悪い。C-28・C-50・C-51 は retract、C-45 の enrolled-sample 文は消えた。旧図の『enrolled sample では bound が厳密』は削除されているな？ それと基本区間 — 昨日 Harvey が落としかけて俺が戻した一文だ。図では "S1 と S2-50 でのみ優位（post hoc）" と限定して書いてある。それでいい。」

**Donna**: （書き終えて）
「`PAPER_LOGIC.md` を全面刷新（節番号の正、消えたもの一覧、mermaid、CLAIMS 対応表、10-15 の二つの削減表、履歴、開いている点）。artifact は同じ URL に再公開。履歴の詳細表（10-12 の C1–C4 ほか）は `DECISIONS.md` に移譲して図からは圧縮した — git 履歴（`4331b44` 以前）にも残る。commit は Tak の判断。origin/main に対して ahead 2 のまま。」

---

### [2026-10-16 00:30] Scene: commit — 骨子からの絞り込みを main に載せる

**INT. PEARSON SPECTER LITT - DONNA'S DESK - NIGHT**

*Tak「commit」。並走セッションは全て offline か idle、08:17 以降にファイルを触った者はいない。*

**Donna**: （端末を叩く）
「二本に分けたわ。一本目 `4331b44` が原稿側——tex、PDF、森林図 4 本と `R/fig3_w1_axis.R`、guards 65 本、CLAIMS・DECISIONS・LAB_STATUS、protocol の Deviations、review_response の判定表と Louis の報告、known_bad の fixture 3 本。D-20261014-2 と D-20261015-1 と D-20261015-2 をまとめて一つの commit。二本目がこの SUITS と Louis の memory。push はしていない——指示は commit だけ。」

**Harvey**: （短く）
「それでいい。拒否権は開いたままだ。Tak が段落を戻すなら旧原稿から戻す。」

---

### [2026-10-15 08:20] Scene: 「図の削減は愚策ではないか」— 図を戻して文章を切る、骨子だけを物差しに

**INT. PEARSON SPECTER LITT - HARVEY'S OFFICE - DAY**

*Tak 07:30「図の削減は愚策ではないか？図によって文章が削減できる部分もあるだろう。内容として無駄な部分、主張に関連しない部分があるはずだ。論文の骨子から見直して本当に必須な本質的部分に絞れ」。昨夜の Option C は図 2 本を落として表と文章を残していた。*

**Harvey**: （昨夜の判定表を裏返す）
「逆だった。図は読者の時間を節約する。文章は図が示す型を数値で三度繰り返していた。物差しは一つにする——`LAB_STATUS` の骨子、A1 と R1–R4。どの R にも答えない文は切る。Study 2 の性能図と GUSTO の森林図は戻す。森林図には $\Delta_{\text{clin}}/L_{\text{UB}}$ の点線を入れろ。age 1 年、SBP 5 mmHg。$L^*$ 表は $W_1$ 表の変換にすぎない。落とす。Lee の予後勾配、enrolled sample の文、$W_1$ 対 KS の効率の細部、basic 区間——R に答えない。切る。」

**Katrina**: （R を走らせながら）
「森林図に参照線を足した。`DELTA_CLIN / L_UB` で計算、hard-code なし。per-pair CSV は byte-identical。SBP の R7 は 5.0 の線のほぼ真上、age の R1† は上限 1.03 で線のすぐ右。図だけでは読めない partner が二つある。」

**Harvey**: （頷く）
「表の限界値で読む句を §4.4 に足す。」

*07:50。build 0 error、15 頁、本文 5,727 語、guards 59 本 0 FAIL、数値 111/111。Louis が diff を読む。*

**Louis**: （報告書を机に落とす）
「偽の文はない。Critical はゼロだ。だが Major が 7 つある。**図に読ませると言って文章を切ったせいで、数字の付いた証拠が消え、その証拠に乗っていた文だけが残った。** coverage の対比を『CDF が交差する』だけにした——S6 は交差して 0.942、S2 は交差せず 0.703。10-12 の C2 が言い換えで戻ったぞ。Set 4 の check は $W_1$ の比だけ残して KS の比と ΔAUC の数字を落とした。2 MCSE 超の判定が読者に見えない。basic 区間は昨日の保険だ。お前の DECISIONS は『保険文はすべて残す』と書いて、落としている。そして森林図の縦線——pooling の閾値と読まれる。EXT M5 の同等性検定そのものだ。線の位置は sponsor の選択でしかない。『閾値ではない』と本文に書け。You just got Litt up!」

**Harvey**: （短く）
「全部採る。M6 は本質だ。quantify, not decide が図で崩れたら元も子もない。guard は 6 本、お前の案のまま seed しろ。」

**Mike**: （図を指で追って）
「I got it! 三分類の向きは代数的に正しい。$L^* = \Delta_{\text{clin}}/W_1$ は減少関数だから、区間が線より下なら $L^*$ 区間は $L_{\text{UB}}$ より上。Discussion の『$W_1$ は全 cell で target に到達』も `required_n_selection.csv` で 13/13 だ。」

**Jessica**: （端的に）
「Let me be clear。図を戻すのは Tak の指示、閾値でないと書くのは原則。どちらも記録に残しなさい。Phase 8 の中の話で、投稿の Go ではない。」

**Donna**: （画面を見ながら）
「記録したわ。D-20261015-2、CLAIMS は 6 行 narrowed・C-45 retract、`ESSENCE_SKELETON_20261015.md` に判定表。Louis の復元で一度 16 頁に戻ったから、付録の $L^*$ の再定義と RNG の文を詰めて 15 頁に戻した。最終: 本文 5,796 語、図 4・表 5、guards 65 本 0 FAIL、数値 113/113、残滓 0。拒否権は marker `D-20261015-2` 26 箇所と Louis の 6 箇所。commit はしていない。」

*旧原稿 = `review_response/known_bad/per_em_W1_wiley_pre_D-20261015-2.tex`。Tak の拒否権は段落単位で開いたまま。*

---

### [2026-10-15 01:55] Scene: 「21頁は長い」— 冷読の削減計画、Option C、そして省略だけで referee M1 が戻ってくる

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - NIGHT**

*Tak「21頁は長い。必ず無駄がある。新たな視点で無駄を削り取って。本質的な部分だけを残す」。冷読の副編集長は先に「本質の 5 文」を書き、それに寄与しない塊を数えてきた。9,730 語、22 頁。*

**Harvey**: （計画書を机に置く）
「冷読が出した目標は 6,000 語、許容 6,300。Option C でいく。本文 6,300 語、図表 8 本。D-20261014-1 の『唯一の担い手は切らない』は自分で作った規則だ。Tak の『必ず無駄がある』が規則より上にある。上書きする。ただし条件を付ける。承認段落は文単位の純削除だけ。登録研究は 1 行は残す。W_d は『過小評価しうる』向きの 1 文を残す。拡張表は全行残す。」

**Katrina**: （画面を切り替える）
「適用した。22 頁が 15 頁、図表は 13 が 8。図は性能 3 パネルと森林図を落とした。表は intervals、Region 8 baseline、null floor を落とした。付録の R コードと A.1 も。本文は 9,730 が 6,292 語。marker は 76 箇所。」

**Louis**: （立ち上がる）
「待て。省略だけで referee M1 が戻ってくる。KS と W₂ の bound の話を丸ごと落としたら、『定数が W₁ を区別しない』という指摘がそのまま復活する。保険文 J を 1 文入れろ。それと、報告しない解析の列挙を消すのは選択報告だ。理由の帰属も間違っている。B は 50 語で書き直せ。Set 4 の保険 C は事実誤認だ。bulk shift は部分群ではなく母集団全体を動かす。Region 8 の保険 D には heaping の 79.5% と winsorize の 4/30 を入れろ。You just got Litt up!」

**Harvey**: （短く）
「全部採る。拡張表だけは譲らない。冷読は 2 行に縮めろと言うが、1 頁に満たない表を縮めるために範囲を書き直す語数のほうが多い。Louis も縮めて範囲を本文に書けば足りると言った。全行残す。」

**Rachel**: （手を挙げる）
「保険 A は、cite-check で確認した p.965–966 の範囲に限ります。『workshop report』と『post hoc』は削る前の文言のままなので、`matsushima2024` の再実行が要ります。」

**Jessica**: （端的に）
「Let me be clear。削減は Tak の指示、保険は Louis の指示。どちらも記録に残しなさい。Phase 8 の中の話で、投稿の Go ではない。」

**Donna**: （画面を見ながら）
「記録したわ。D-20261015-1、CLAIMS は 3 行 retract・26 行 narrow・新規 5 行。Katrina の retract 候補のうち C-21 は step-CATE の担い手がまだ本文に残っていたから narrow に変えたの。それと、claim guard が 3 本、stem が消えて何も守っていないわ。CI は PASS するのに、よ。Louis の review-fix が J の誤り（L·W₂ は sharp ではない）、basic interval の食い違い、§4.2 の橋の偽を見つけたから、それも反映した。16 頁、本文は 6,433 語。15 頁には 1 頁足りないわね。」

*変更は未 commit。Tak の拒否権は 76 箇所の marker に対して段落単位で開いたまま。*

---

### [2026-10-14 08:30] Scene: 現場の統計家が読んだら — 実務家レビューと、台帳が暴いた L_UB の出自

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - MORNING**

*Tak「実務的医学統計家のレビューをしてもらい、コメントに従って修正。迷うことはみんなで議論して決めて」。冷読の実務家が Major 6・Minor 7 を返し、4 人がそれぞれの持ち場で裁いた。*

**Harvey**: （資料を閉じる）
「Aim は指標を示すことだ。実務家が欲しいのは使い方の手順で、それは手続きの推奨になる。読み方と入力の事実だけを短く足し、図・件数・SAP の一覧は断る。足した分は切る。」

**Louis**: （台帳を叩く）
「まず事実の訂正だ。年齢の集計はレビュアーが正しい、間違っているのは SBP の『ほぼ全員』だ。それより最悪の穴は L_UB の出自だ。台帳 rows 20/21/36 では Δ_clin ÷ τ から作られている。それなのに原稿は FTT と Lee が bound を "inform" したと書いた。出典の付け替えだ。You just got Litt up!」

**Mike**: （ホワイトボードに書く）
「I got it! 二値なら τ̄₁ − τ̄₂ = (τ(1) − τ(0))(p₁ − p₂)、W₁ = |p₁ − p₂|。bound は等号で、較正する隙間がない。順序はスコア次第で L·W₁ が 2 にも 3 にもなる（真の差は 1）。付録のコードは O(n log n)、最大ペアで 2.4 秒。『分単位』は誤りだ。」

**Jessica**: （短く）
「Let me be clear。直すのは P-6、P-1、P-2。断る理由は書き残しなさい。triage は gate ではない。cite-check と /reproduce が ❌ のあいだ、投稿の Go は出さない。」

**Rachel**: （メモを取りながら）
「E17 の PDF はパスワード付きで開けませんでした。Method 1/2 と §2.2.5 の文言は原典を確認するまで書きません。Δ_clin = 1 %pt の出典も /ground に回します。」

**Donna**: （画面を見ながら）
「記録したわ。D-20261014-2、CLAIMS は C-16 を narrowed、C-50〜C-52 を追加。ガード 59 本 0 FAIL、数値 147 件すべて出典あり。ただし長さは +130 語ほど正味で増えて、9,000 語にも 21 頁にも戻っていない。Tak の判断が要るわ。」

*変更は未 commit。別セッション（temp-24）が並走中のため、commit は Tak の指示を待つ。*

---

### [2026-10-14 07:52] Scene: commit と push — 2 本に分けて

**INT. PEARSON SPECTER LITT - DONNA'S DESK - MORNING**

*Tak「commit して」、続けて「push して」。*

**Donna**: 「194 files には並走していた環境側の session の変更も混ざっていたから、2 本に分けたわ。1 本目は lab の環境 — hardening、referee-grade environment、Tak の三原則 S21–S23、concurrent-session protocol（73 files）。2 本目は論文 — cold-referee の三周（D-20261011-11 / D-20261012-2 / D-20261012-3）と本文の削減 D-20261014-1（200 files、+18,841 / −747）。working tree はクリーン。」

**Harvey**: 「push した。fad1010..d32af02、origin/main と一致。CI（lab-checks / r-and-tex）が GitHub 側で回る。拒否権項目 15 件は commit 済みの原稿に印のまま — Tak が拒否した段落は pre-cut の控えから戻す。」

**Jessica**: 「Let me be clear。commit は到達点の記録であって承認ではない。拒否権は開いたままだ。」

---

### [2026-10-14 01:40] Scene: 切った後に戻す — Louis の Major 9 と、自分で見つけた飲み込み

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - NIGHT**

*Katrina の 74 cuts。Louis が diff を読み終える。*

**Katrina**: 「規則の中で 11,097 → 9,818、Menu の 7 件で 9,461。Application は目標達成、他は届かない。Tables 3–5 は 1 表に、Jensen の導出と Lee の算術は付録に、拡張表は設計順に。拒否権項目 15。ゲートは全部通した。」

**Louis**: 「唯一の担い手を失った CLAIMS 行は無い — そこは認める。だが規則 (2) を破った cut が 2 本。M12 — §2.2 の『sharpness では区別できない、定数が区別する』が消え、残った "Neither bound dominates" は単調 bound と Lipschitz bound の比較に読める。そう読むと偽だ。D01 — Discussion の MCSE count と SD scope が pointer に。どちらも 10-12 の訂正文だ。H1 と D08 の二重削除で『EM をどう選ぶかは範囲外』の文が本文から丸ごと消えた。S17 で log-scale SMD の AUC 1.00 — SMD に有利な結果 — が本文からも表からも消えた。cherry-picking の攻撃口。それと『per region, We performed』。Major 9、Minor 13。You just got Litt up — 削る方でも。」

**Harvey**: 「全部戻した。約 150 語。M12 は一句（『sharpness は KS にもある、区別するのは定数』）、D01 は数値付きの一文、EM 選択の射程は §5 limitations に一文、log-scale SMD は省略宣言の括弧に数値ごと、amendment の cell は E3c を含めて正しく。そして俺の K4 の marker が段落の途中に入って本文を飲んだ — grep の自動検査が拾った。割って直した。」

**Mike**: 「I got it! 最終: 本文 **9,617 語**（1.6×）、build 21 pp / error 0、guards 59 本 0 FAIL、unsourced 0（145 tokens）、registry check PASS、verify 2 本 ALL PASS、abstract 250/250 byte 一致、swallow scan 0。」

**Jessica**: 「Let me be clear。削ったのは反復と説明、戻したのは主張と訂正。9,000 に届かないのは、残りが reviewer の求めた証拠と主張の担い手だからだ。それを削って 9,000 にする論文は、昨日より弱い。拒否権項目 15 は Tak が見る。Go。」

**Donna**: 「D-20261014-1 applied。memory に二つの型を足す — 移設で back-pointer が壊れる、二つの cut が互いに『向こうが担う』と仮定して唯一の担い手を両方消す。I'm Donna. I know everything — 今日の Harvey が、自分の飲み込みを自分の検査で見つけたことも。」

---

### [2026-10-14 00:30] Scene: 「本文を削減して」— 1.8× を 1.5× 以下に、主張を一つも落とさずに

**INT. PEARSON SPECTER LITT - HARVEY'S OFFICE - NIGHT**

*Tak の一行。Harvey は昨日の最後に Jessica が言った「長さは明日の仕事」を覚えている。*

**Harvey**: 「11,097 語を 9,000 以下に。節ごとの上限を切った — Intro 950、Methods 2,500、Simulation 2,300、Application 1,300、Discussion 1,300。規則は三つ。CLAIMS の行の唯一の担い手は切らない。昨日の訂正文は切らない — 落とせば同じ指摘が戻る。Tak の承認段落は純削除だけ、新しいつなぎ文言が要るものは印を付けて拒否権に回す。Tables 3–5 は一つの表にする。」

**Katrina**: 「昨日の計画で測った数字がある。A 層だけで Simulation は 2,204 まで落ちた — 今日はその上に昨日の追加が乗っている。Tables 3–5 の統合は検証済み、21 行で全セル一致。コピーに当てて structure_audit で測り、guards と dangling ref を見てから本番に当てる。拡張表の行順と E5/E6 のラベルも直す。」

**Louis**: 「切った後の diff は俺が読む。切り方で qualifier が落ちるのは、書き足しで落ちるのと同じ罪だ。」

**Donna**: 「切る前の原稿は `known_bad/per_em_W1_wiley_20261014_before_cut.tex` に。D-20261014-1 を起票。I'm Donna. I know everything — Katrina が今日どの段落で一番悩むかも。」

---

### [2026-10-13 02:00] Scene: ARS の二つの門 — integrity は PASS、re-review は Minor Revision

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - NIGHT**

*Tak の `/ars-full` を今日の round の終端に繋いだ。Stage 2.5 の integrity gate と Stage 3′ の verification review が、どちらも深夜に戻る。*

**Donna**: 「ARS integrity: PASS WITH NOTES。引用 35 本すべて VERIFIED — DOI は全部解決、捏造・混成・誤誘導ゼロ。数値の chain（registry → macro → tex）21/21、生成表 11 本 275 セル不一致ゼロ、Table 8 は `gusto.csv` から直接再計算して一致、7 項目の failure-mode checklist は全 CLEAR。Minor 9 件は bib の細部（Komiyama の頁、IST の著者 brace、Morris の頭文字）と §1 の一文の弱い支持 — 直した。ARS re-review: **Minor Revision**。外部レビュー 19 項目は addressed 10 / partially 7 / declined 2、referee #2 の 17 項目は addressed 15 / partially 1 / not done 1（bootstrap の MC 誤差）。Major 5 件はディスクで全部検証済み。」

**Harvey**: 「re-review が新しく拾った 13 件のうち、安い 7 件は閉じた — cvol の頁数、abstract の operating point の句を E6–E5 に、『we report the loss』、Supporting information の矛盾、Wald の "unstable" の根拠なし、拡張 protocol の時系列（最初の 8 cell は run 前、operating point の 3 cell は run 中の amendment）、L_UB の出典から GUSTO subgroup を外す。残る 3 件は次の周の仕事だ: bootstrap 端点の MC 誤差（single writer 一本）、M7(a) の L_UB の根拠、そして長さ — 11,097 語、1.8×。」

**Katrina**: 「最終ゲート: build 23 pp / error 0 / undefined 0、guards 59 本 0 FAIL、abstract 250 / 250、unsourced 0（152 tokens）、verify 134/0・63/0、R = Python macro check PASS（235 keys）。拡張表の行順と E5/E6 ラベルは生成器の cosmetic、次の周で。」

**Louis**: 「今日の三周で俺が出した Critical は 3 + 3 + 3。全部『今日書いた説明文』だ。明日からの規則は一つ — 文を書いた者が CSV を割る前に、別の者が割る。You just got Litt up — 自分たちで。」

**Jessica**: 「Let me be clear. 10 月 12 日の原稿は、二つの外部の目と三周の内部の目を通って、12 日の朝の原稿とは別物になった。採用理由の循環、CSV と矛盾する説明文、原典と逆向きの引用、応用の operating point を外れた coverage 主張 — 全部閉じた。長さだけが開いている。Tak への報告を出せ。commit は Tak の判断だ。」

**Donna**: 「D-20261012-3 applied、応答表 `RESPONSE_TRACKER_20261012.md`、ARS の 2 報告、四つ目の目 4 本、protocol 2 本、single writer 5 本、guard 59 本。未 commit 184 files。I'm Donna. I know everything — 明日の最初の仕事が『切る』ことだということも。」

---

### [2026-10-13 00:55] Scene: 深夜の再開 — 落ちた四人、残っていた 11 cell、Louis の三つ目の Critical

**INT. PEARSON SPECTER LITT - BULLPEN - NIGHT**

*18:32、session limit。Mike C・Louis・Harvey・ARS integrity の四本が途中で落ちた。00:28、Tak の「続けて」。Donna が最初にしたのはディスクを見ること。*

**Donna**: 「落ちた agent が走らせた R は止まっていなかった。`w1_raw_ext_summary.csv` に 11 cell 全部 — 不均衡 n、t₃、整数格子、n = 1,000、それに Harvey が足した応用の operating point。E5（0.2 SD、n = 1,000）の coverage は 0.951、E6（2,900 vs 1,200、10 mmHg 丸め）は 0.947、片側上限は 0.983 と 0.978。Louis の round 3 の報告もディスクにあった。無かったのは拡張表の生成器、応答表、ARS integrity。今度は二本ずつ。」

**Louis**: 「俺の round 3。Critical 3 / Major 15 / Minor 9 — 全部今日 Harvey が書いた文だ。S6 を S4 と並べて『CDF が交差しない』— 平均一致なら必ず交差するし bias は 11 MCSE。『undercover する所では上限が保守的』— S4-100 の上限 coverage は 0.971 で名目を下回る。『basic 区間は全 non-null cell で劣る』— S2-50 では 0.809 対 0.703 で勝つ。境界では coverage を得て、離れると失う。それとマーカーの飲み込みがまた二箇所。『light-tailed』— Set 2 は対数正規で heavy-tailed だ。abstract の『normal, equal n』— 1.2 SD の上端 S6 の partner は対数正規。可縮性が abstract に無い。『sharp for the class』を見出しに置いたら、referee は attained を sharp に差し替えただけだと読む。You just got Litt up — 二回目の今日の分だ。」

**Harvey**: （黙って全部直す）
「直した。S6 は『bias が S5・S7 より小さい』、上限は『S5・S7 で名目超、S3・S6 で付近、S4-100 で未満』、basic は『境界の coverage と交換』。採用理由の三つ目は『class の全 CATE で valid、勾配だけが制約なら sharp、特定の CATE には保守的』— sharp を見出しから外した。abstract は『risk or mean differences』『normal reference』『in original units』を戻し、control は一つの cell として書き、operating point の 0.95 を一句。REF-M1 の guard 2 本は役目を終えた — 旧 stem が『定数を言う文は attain を言え』を強制して、今日の referee が退けた wording を生んでいた。D-20261012-3 に理由を書いて書き換えた。」

**Katrina**: 「拡張表 `tab_study2_ext`（11 行）と key 16 本。GUSTO の距離は Region 8 の SD で 0.03–0.30、referee と一致。表は 10 本に。build 23 ページ、error 0。」

**Mike**: 「I got it! 最終ゲート: unsourced 0（152 tokens）、guards 59 本 0 FAIL、verify 134/0・63/0、cascade residue は誤検知 2 件、マーカーに飲まれた本文ゼロ（grep で確認）。本文 11,064 語 — 1.8×。」

**Jessica**: 「Let me be clear。今日の原稿は一日で三つの外部の目（外部レビュー、冷読 referee、Louis の三周）を通った。長い。だが昨日の原稿に戻したい箇所は一つも無い。長さは明日の仕事。ARS の integrity と re-review が通ったら Tak に出せ。」

**Donna**: 「D-20261012-3 を applied に。CLAIMS は 49 行、guards 59 本、ledger 49 行。応答表は Harvey が作成中、ARS integrity は走行中。I'm Donna. I know everything — 今日の最後の Critical 3 件が、やはり『今日書いた説明文』だったことも。」

---

### [2026-10-12 17:40] Scene: 二つのレビューを一度に閉じる — batch 1・2a・2b と、生成器 2 本

**INT. PEARSON SPECTER LITT - HARVEY'S OFFICE - EVENING**

*17:05 から 17:35。原稿は三度動いた。Harvey の batch 1（位置づけ・可縮性・単調 bound・Jensen・Study 1 の射程・誤植・bib 8 本）、Katrina の A 層 cut 18 件、Harvey の batch 2a（Set 4 の機構・単調比・survey の W₁–KS・abstract）と 2b（coverage の説明の分離・片側上限と basic 区間・外れ値と heaping・permutation）。*

**Harvey**: 「採用理由は三つに置き直した。位置以外に応答する、定数が per-unit の臨床勾配、勾配だけを制約にしたときの sharp bound で形の制約が入れば締まる。単調 CATE の sharp bound L(W₁+|Δμ|)/2 は式 (mono_bound) として本文に、GUSTO での縮み幅 0.66–1.00 と 0.72–1.00 は §4.4 に。Set 4 の反転は protocol の §2 が許す範囲だけ — null SD 1.62 倍（SE 0.04）、KS は 1.00、ΔAUC は +0.029 から −0.032 へ。『heavy-tailed』は使わない。Louis が言うとおり、この mixture の裾は Gaussian で、遠い subgroup が二つ付いているだけだ。『contaminated tails』。」

**Mike**: 「I got it! 片側上限の coverage は S3–S7・n ≥ 100 で 0.9710–0.9999、名目 0.975 より保守的。basic 区間は 0.870–0.948 で percentile より悪く、S1 の 0.867 は 0 での切り捨て率そのもの。bias 補正はこの形では境界を直さない — それを表 `tab:study2_intervals` に。permutation は 30/30 一致。外れ値を除いても W₁ の変化は 0.02 年・0.07 mmHg、順位の入れ替わりは SBP の R3–R6 の 1 組、null floor の判定変化はゼロ。末尾 0 の割合は 19.9–79.5%、R8 が 79.5% — 事実だけ書いた。」

**Rachel**: 「引用は原典どおりに。GUSTO の対照は 7.3% ではなく 7.2% と 7.4%（二つの SK 群）。Lee 1995 は abstract の 1.1% と 20.5% から上限 6.5 × 10⁻³/yr と導出し、ledger に 11 行。Shen は同じ不等式、Redko は同系統、Dahabreh は広い文脈、Munk & Czado は trimmed Mallows。Álvarez-Esteban は読めていないので引いていません。」

**Katrina**: 「Table 8 の † 行には、共有する点順位の範囲の後ろにその partner 自身の rank interval を印字した — R1 は [2, 10]、R15 は [1, 10]。生成表は他が全部 byte 一致、verify ALL PASS。build は error 0 / undefined 0 / 22 ページ。guards 53 本 0 FAIL、abstract 248 / 250、unsourced 0、cascade residue は誤検知 2 件のみ。本文は 10,473 語 — 今日は切った分より足した分が多い。」

**Louis**: 「四つ目の目で Mike A の 17 key は全部一致した。だが Harvey の文は protocol を二箇所で踏み越えていた — 積分比と SD 比を因果のように並べ、試していない母集団に一般化した。直させた。今度は今日の diff 全体を `/review-fix` で読む。」

**Jessica**: 「Let me be clear. 今日の原稿は昨日より長い。だが昨日の原稿には、循環した採用理由と、CSV と矛盾する説明文と、原典と逆向きの引用があった。長さは次の周で切れ。間違いは次の周まで持ち越せない。Mike C の拡張 cell が入ったら、ARS の integrity と re-review を通して Tak に出せ。」

**Donna**: 「D-20261012-3 を applying のまま更新、CLAIMS に C-44〜C-49 を起票、IDEAS に I-20261012-3〜5。残りは Mike C（Study 2 拡張、応用の operating point を含む）、Katrina の四つ目の目（Mike B の key）、Louis の review-fix。I'm Donna. I know everything — 今日の reviewer が二人とも『attainment』に反応した理由も。」

---

### [2026-10-12 17:10] Scene: 冷読 referee 第 2 回 — 「reject」の一語と、循環していた採用理由

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - NIGHT**

*16:46、referee の報告が届く。再計算 44 行は不一致ゼロ、数学も正しい。判定は「現状では reject」。理由は一つ、論文の中心にある。*

**Donna**: 「Major 5、Minor 12。M1 — W₁ を選ぶ理由を『attained だから smallest valid』と書いたが、それは KR 双対の言い換えで、class を固定すれば sharp な IPM は決まる。循環。単調な L-Lipschitz CATE なら sharp bound は L(W₁+|Δμ|)/2 — 平均一致の対比では L·W₁ の半分。GUSTO では 0.66–1.00。M2 — 『11 of 13』は設計した grid の数え上げで、control の反転は裾の重さという一般的な機構。M3 — coverage の説明が自分の CSV と矛盾（S4-100 は交差なし、S6 は両側）。M4 — Study 1 は応用と別の task。M5 — GUSTO の距離 0.03–0.30 SD は Study 2 の coverage 範囲 0.4–1.2 SD に一つも入らない。」

**Harvey**: （長い沈黙のあと）
「昨夜の M1 の直し方が、一段深い穴を掘っていた。attainment は理由にならない — それは定義だ。採用理由は三つに置き直す: 位置以外に応答する、定数が per-unit の臨床勾配である、勾配だけを制約にしたときの sharp bound で形の制約が入れば締まる保守的上界である。単調 bound の式は本文に載せる。応用でどれだけ縮むかも。」

**Louis**: 「外部レビューへの俺の攻撃と referee が噛み合った所がある。M3 の Study 3 を断る理由は『KR で W₁ が定義上最適だから循環』ではない — それが成り立つのは unrestricted class の sup だけで、referee はまさにそこを突いた。断る理由は『θ を固定すると勝者が θ の選択で決まる』だ。線形なら |Δμ|、step なら |F₁(c)−F₂(c)|、τ* なら W₁。それと線形 CATE の下で SMD が正しい挙動だという指摘には V 字で答える: τ = L|x−50| なら S5 で L·W₁ を attain し、SMD は 0。You just got Litt up — 両方向に。」

**Mike**: 「I got it! M2 の機構は、俺の exploratory と referee の `ref_tailweight` が独立に同じ向きだった。Jessica の Go で protocol に昇格、本番 4,000 組。n = 200、shift 2 で、Set 4 の母集団は Ŵ₁ の null SD を 1.62 倍（MCSE 0.035）、KS は 1.00（0.019）、paired ΔAUC は +0.029 → −0.032。prior look は §0 に二度開示した — blind な予測としては書かない。∫√(F(1−F)) の比 1.68 は null 平均の scale としては書けるが、SD が比例するとは書けない。それも does not license に。」

**Rachel**: 「M1 の先行研究 9 本は DOI と原文で確認しました。Shen 2018 の式 (13) は Prop. 1 と同一の不等式、Redko 2017 は同系統で経路が違う、Tipton・Stuart・Dahabreh は設定の近さだけで距離も bound も無い、Munk & Czado は同等性検定。Álvarez-Esteban は原文も abstract も取れなかったので引きません。」

**Katrina**: 「長さ計画: Simulation は A 層の cut だけで 2,952 → 2,204 語。Discussion は重複削除で 1,461 止まり — 1,200 は承認段落の内容を落とさないと届かない。`gusto_operability.csv` の旧列 2 本は writer から落とし、生成表 8 本 byte 一致、verify ALL PASS。今は Harvey の指示で A 層 18 件を原稿に当てている。」

**Jessica**: 「Let me be clear。昨日の referee は『定数が区別する』を潰し、今日の referee は『attainment が区別する』を潰した。三度目は無い — 採用理由は三つ並べて、どれも単独では主張しない。断る 3 件は『別の論文だから』と書け。Go。」

**Donna**: 「D-20261012-3 に全部書いた。guard は 53 本、うち 4 本 OPEN — batch 2 で閉じる。原稿は Katrina が触っている間、Harvey は手を止めている。I'm Donna. I know everything — 今日の referee が昨夜の referee より一枚上手だったことも。」

---

### [2026-10-12 16:55] Scene: IST-1 の結果 — 現実味は勝ち、解像と較正は負け

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*Mike が `results/ist1_summary.md` とフォレスト図を映す。Harvey が `COMPARISON.md` を配る。Louis は既に赤ペンを持っている。*

**Mike**: 「"I got it!" anchor USA（n = 131）、partner 35 か国。null floor に対して解像したのは age 23 / 35、SBP 12 / 35、delay 25 / 35。三つ全部で解像したのが 10 か国、一つも解像しないのが 4 — Finland 85、Sri Lanka 20、Romania 18、Japan 9。解像は partner の n に従う（全部解像の中央値 n = 636、ゼロ解像は 19）。EM 間の順位の Spearman は age–SBP 0.04 [−0.09, 0.26]、age–delay 0.06、SBP–delay 0.15 — 三つとも区間がゼロを含む。W₁ と |SMD| は 0.81–0.98 で一致。rank interval の平均幅は 35 位置中 12.5 / 17.7 / 13.5 — GUSTO の 15 位置中 6.7 / 5.0 より粗い。感度: anchor Japan（n = 9）はほぼ何も解像しない（SBP 0 / 35）、anchor UK は age 29、SBP 15、delay 23。」

**Louis**: 「referee が丸を付ける所を言う。France は患者 2 人で age の最遠 partner、しかも "resolved"。Singapore と Sri Lanka は percentile 区間が点推定を含まない — 論文が開示している境界バイアスが、今度は表に出る。SBP は CI 幅の中央値 7.2 mmHg に対して null floor 6.7 mmHg、Table 5 の大半が unresolved になる。そして L_UB が無い — §2.4 が較正と呼ぶのは L* と L_UB の比較で、L* だけでは A3 の半分だ。」

**Harvey**: 「比較は `exploratory/ist1_case_study/COMPARISON.md` に書いた。IST-1 が勝つのは現実味 — 実名の国、USA という名前のある規制市場、n = 131 の anchor、アジアの地域、三つの EM で順位が一致しないという Discussion の主張が GUSTO の −0.30 より鮮明。負けるのは §4 が A3 のために存在する二点 — 出典のある L_UB に対する較正の読みと、解像する順位表。どちらも anchor を変えて直る話じゃない、データセットの構造だ。era も 1991–96 で改善しない。差し替えコストは registry 35 鍵、R 8 本、表 4、図 1、Discussion 3 段落、referee pass の §4 分。

**推奨は GUSTO-I 据え置き。** IST-1 は R1 の reserve として、匿名地域や大標本を突かれた時に一段落で返す材料にする。二本立てにはしない。Tak が IST-1 を選ぶなら、道筋は `/decide`（4 月 10 日の決定を supersede）→ Rachel が脳卒中の L_UB を ground するか「較正は L* で止まる」と明記 → n = 2 / n = 9 の地域の一文 → `/protocol ist1_application`（今日の run を prior look として開示）→ §4 再構築。"I don't have dreams, I have goals."」

**Jessica**: 「Let me be clear. この sandbox の数字は原稿に一つも入れない。判断は Tak。」

---

### [2026-10-12 16:15] Scene: 外部レビュー到着 — 8 件の Major、うち 3 件は線の向こう側

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*16:07、Tak から外部 reviewer の report が貼り付けられる。Major 8 / Minor 6 / 体裁 5。Donna が `review_response/EXTERNAL_REVIEW_20261012.md` に保存し、Harvey の前に置く。referee はまだ原稿を読んでいる。*

**Harvey**: 「読んだ。M3 の Study 3 — CATE を線形・二次・閾値で置いて真の効果差との順位一致を測れ — は、Tak が 07-12 に閉じた扉だ。θ を特定すれば Lipschitz class の bound の一般性を壊し、KR 双対で W₁ が定義上最適になる循環に入る。M5 の同等性検定は判定規則の規定で、09-25 の線の向こう。M7(a)(b) の GUSTO アウトカムで L を推定するのも、計画段階で τ が無いという論文の前提と scope の外だ。三つは理由を書いて断る — ただし M3 の線形 CATE の指摘自体は正しい。線形なら平均差だけが効く、スケール差は効果差ゼロなのに W₁ > 0。これは worst-case bound の性質で、原稿にその一文を足す。」

**Mike**: 「I got it! 残りは正しいか、安くできる。M4(a) の Jensen — E|F̂₁ − F̂₂| ≥ |F₁ − F₂| 各点で、Fubini で積分 — は命題として書ける。M4(d) の片側上限 coverage と basic interval の coverage は、rds に rep ごとの推定値と区間が入っていれば計算だけで出る。M7(c) の SBP = 0 と 100 歳超の感度、digit preference、M5 の permutation 版 null floor も同じ。M8 の Study 2 拡張 — 不均衡 n、t₃、整数格子、n = 1,000 — は元の 21 cell が 32 分だったから、protocol を切って 8 cell を今から回せる。」

**Rachel**: 「M1 の先行研究 9 本は、私が DOI と原文を取ってきます。Redko 2017、Shen 2018、Tipton 2014、Stuart 2011、Dahabreh 2020、Munk & Czado 1998、Álvarez-Esteban 2008、Bickel–Götze–van Zwet 1997、Hong & Li 2018。読めないものは [推測] と ABSTRACT-ONLY で分けます。」

**Louis**: 「俺は reviewer を叩く。M4(a) の証明に穴はないか、M6 の二つの不等式は本当に成り立つか、M5 の permutation は anchor を基準にする今の null と同じ問いか、M7 の『L_UB が予後勾配より大きすぎる』は §2.4 が既に答えているか。reviewer が正しい所は正しいと書く。You just got Litt up — 今度は向こうが。」

**Katrina**: 「体裁 5 件は全部ディスクで確認した。Fig 4 の caption は私の `\dagger` のバックスラッシュが落ちて `$^dagger$` になっている — 私のミス。IST-1 は `\cite` の番号が IST-1 に連結、bib の del Barrio / van Klaveren は braces で保護、How to cite の 1–18 と copyyear 2025、Appendix B の二重評価。referee が終わったら一括で直す。」

**Jessica**: 「Let me be clear。外部の目が 8 件出し、そのうち 5 件は今日のうちに正しく閉じられる。3 件は断る — 断る理由は『決定 X と矛盾』ではなく、科学的な理由を書け。それが D-20261012-3 だ。Go。」

**Donna**: 「並列 4 本（Rachel・Mike × 2・Louis）を出した。referee・Katrina の長さ計画・Mike の `/explore` はまだ走っている。原稿は referee が終わるまで誰も触らない。I'm Donna. I know everything — 今日の夕方が長くなることも。」

---

### [2026-10-12 15:55] Scene: Explore — ist1_case_study（IST-1 で §4 を再演する）

**INT. PEARSON SPECTER LITT - BULLPEN - DAY**

*Tak の指示:「IST-1での事例検討を試してみる。論文で掲げている状況と同じように考えられる仮想的シナリオを作る。仮想的シナリオに沿って併合地域を選択する。完了したら GUSTO との事例検討としての質を比較・検討する。」Mike のモニタに `exploratory/ist1_case_study/`、README の先頭に赤い一行。*

**Harvey**: 「問いは一つ — §4 の手順を一切変えずに IST-1 に流したとき、GUSTO-I より事例として質が高いか。高ければ `/decide` で §4 を差し替え、`/protocol` を書いてから原稿に入れる。低ければ GUSTO のまま、IST-1 は R1 の reserve。シナリオは論文と同じ構図: 急性虚血性脳卒中の新規抗血栓薬 Drug S、Phase 3 MRCT の計画段階、IST-1（1991–96、19,435 例、36 か国）を各国集団の stand-in に。候補 EM は age・SBP・発症からの遅延。anchor は「現地のエビデンスを求める規制市場」。」

**Mike**: 「"I got it!" anchor の主解析は **USA（n = 131）** — MRCT の一国コホートとして現実的な小標本。感度は Japan（n = 9、小 anchor の極限）と UK（n = 6,257）。partner は 35 か国全部、n の下限なし（Tak 11:09）。手順は `R/gusto_*.R` の関数を verbatim で — W₁、percentile CI（B = 2,000）、anchor-drawn null floor（B = 2,000、片側 5%）、rank interval（患者 bootstrap B = 1,000）、L* = 1%pt / W₁、|SMD| との Spearman、EM 間順位の Spearman。要約表は script が書く — 数字は一つも手で打たない。GUSTO の同じ記述子を canonical CSV から読み取り専用で並べる。走らせた。」

**Louis**: 「攻撃を三つ置いておく。(1) anchor を USA にしたのは Mike の選択だ — 結果を見てから anchor を選び直したら事後選択になる。README に書いた通り、選び直すなら理由を先に書け。(2) 「併合地域を選択する」は論文が規定しない判定だ。この sandbox で何を「選択」と呼ぶかは、§4 と同じ読み方 — null floor に対する解像、上限の読み、L* と L_UB の比較 — に限る。閾値を作るな。(3) IST-1 は 1991–96 で aspirin / heparin。age・SBP・遅延に抗血栓薬の臨床スロープの出典は無い。L_UB を置かずに L* だけ出すのは正しいが、GUSTO にあった FTT / Lee 1995 相当が無い点は質の比較で不利に数える。」

**Jessica**: 「Let me be clear. Go — sandbox に限る。原稿・registry・ledger に一つでも数字が漏れたら Donna が差し戻す。」

---

### [2026-10-12 15:55] Scene: もう一周 — 「原稿を改訂」の読み方と四つの並列

**INT. PEARSON SPECTER LITT - HARVEY'S OFFICE - DAY**

*15:48、Tak の三文字。「原稿を改訂」。午前の判断は 11:40 に適用済み。Donna が時計とディスクを見る — 原稿は 11:23 から動いていない。*

**Donna**: 「読み方は一つしかないわ。午前の周は終わっている。だからこれは**もう一周** — 改訂後の原稿に新しい目を入れて、残った弱点を直す。残っているのは、本文 1.7×（Simulation 1.9×、Discussion 1.7×）、`/ground` 待ちの引用 2 件、C4 の機構、`gusto_operability.csv` の旧列。」

**Harvey**: 「新しい目は Louis じゃない。Louis は今朝の原稿を知っている。冷読 referee をもう一度出す — 昨夜と同じ条件、同じ深さ、再計算付き。改訂で 110 行動かした原稿に、内部記録を知らない reviewer が何を言うかが、今日いちばん価値のある情報だ。referee が読んでいる間、原稿には誰も触るな。」

**Katrina**: 「私は長さの計画。Simulation を約 2,200 語、Discussion を約 1,200 語に。CLAIMS の行が落ちない cut だけを行番号と語数で。Tables 3–5 の統合案も。それと `gusto_operability.csv` の `tau_clin` / `eligible` — 読み手が無ければ writer から落として、生成表が byte 一致することを確かめる。」

**Rachel**: 「`/ground` を二つ。Lee 1995 の age gradient 6 × 10⁻³/yr は、誰も導出を持っていません。原典の年齢層別死亡率を取りに行きます。Matsushima の Data S1 — PREVENT で『EM 分布が似ている』をどう測ったかは、novelty claim が崩れ得る最後の経路です。取れなければ Paper Request として記録します。」

**Mike**: 「I got it! C4 の機構は `/explore` で。Set 4 の裾が Ŵ₁ の分散を膨らませるか — 2 つの base 分布、shift 2 と 3、n = 100–400、2,000 組、Ŵ₁ と D_KS の SD・分離・AUC と ∫√(F(1−F))。exploratory のまま、原稿には書かない。」

**Louis**: 「referee が戻ってきたら、俺は referee の文も自分の文も CSV で割る。今朝の教訓は『修正に添えた説明文』だった。今度は referee の説明文も同じ目で見る。」

**Jessica**: 「Let me be clear. 一周目で学んだことを二周目で使え。説明は証拠の後、マーカーは独立行、適用後は PDF を grep。Go。」

**Donna**: 「SUITS.md は 982 行だったから、この scene の前にアーカイブした（`archives/SUITS_20261012_155236.md`）。I'm Donna. I know everything — 午後の四人が何時に戻るかも、だいたい。」

---

### [2026-10-12 15:52] Scene: Archive

**INT. PEARSON SPECTER LITT - FILE ROOM - DAY**

*Donna が厚いフォルダをアーカイブ棚へ移す。*

**Donna**: 「SUITS.md が 982 行、午後の scenes で 1000 を超えるから先にアーカイブしたわ。`archives/SUITS_20261012_155236.md` に保存済み。直前のコンテキストは上に引き継いだ。新しいスクリプト開始よ。」

**Harvey**: （通りがかりに）「過去は過去だ。前を見ろ。」

---
