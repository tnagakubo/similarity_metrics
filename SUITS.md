# SUITS.md - Research Lab Live Script

> *"I don't have dreams. I have goals."* - Harvey Specter

**Previous Archive**: `archives/SUITS_20261012_155236.md`（982 lines、2026-09-27 14:05 〜 2026-10-12 11:40 の scenes。10-11 の Option B・全件生成・referee 判断と適用、10-12 未明の hardening、10-12 午前の残差レビュー D-20261012-2 と並走 session の 3 原則・事例探索・Matsushima 訂正）。直前は `archives/SUITS_20260927_130112.md`
**Archive trigger**: Rule 2.5 (>1000 lines) — 982 行 + 本日午後の scenes で超えるため先に実施

---

## Current Status

**Active Project**: similarity-metric (per-EM W₁ paper, target *Statistics in Medicine*)
**Phase**: 8 — Revision（査読応答）→ `projects/similarity-metric/LAB_STATUS.md`（2026-10-12 11:40 同期済み）
**EN paper**: `projects/similarity-metric/paper/per_em_W1_wiley.tex` — v6 + Terminal pass（09-27）+ Tak の 09-27 決定 + 生成基盤（D-20261011-8）+ 冷読 referee の判断 D-20261011-11（10-12 00:10）+ 残差レビューの判断 D-20261012-2（10-12 11:40）+ **外部レビュー（Major 8）と冷読 referee #2（Major 5）の判断 D-20261012-3 と Louis round 3（10-13 00:55）**。**21 pp、error 0、undefined 0、abstract 250/250、本文 9,617 語（1.6×；10-14 D-20261014-1 で 11,097 から −1,480、拒否権項目 15）、registry 235 keys、unsourced 0、guards 59 strict 0 FAIL、verify 134/0・63/0、表 11（Study 2 拡張 `tab_study2_ext`・区間比較 `tab_study2_intervals` 新設）、Appendix A.3 新設**。**ARS（Tak の `/ars-full`、mid-entry）: Stage 2.5 integrity PASS WITH NOTES（引用 35/35 VERIFIED）、Stage 3′ re-review Minor Revision**（`review_response/ARS_INTEGRITY_20261013.md`、`ARS_REREVIEW_20261013.md`、応答表 `RESPONSE_TRACKER_20261012.md`）。**未 commit**（原稿側の commit は Tak）。Tak の拒否権は `% Paragraph revised 2026-10-11 (D-20261011-11 …)` と `% Paragraph revised 2026-10-12 (D-20261012-2 …)` の段落に対して投稿前まで開いている
**Question / Aim（Tak 10-12 10:46）**: A1 効果修飾因子の分布の類似性を定量的に評価する指標を提示すること（`LAB_STATUS.md`、R1–R4 が対応）
**原則（Tak 09-25）**: 論文は違いを定量化するだけ。併合の判定規則は規定しない → [[feedback_quantify_not_decide]]。**Tak の 3 原則（10-12）**: 根拠なしで進めない（S21）／研究は発散・論文は収束（S22）／ネタはストック `/idea`（S23）
**段落レビュー**: 台帳 `REVIEW_QUEUE_v6.md` 50/50（09-27）。#1–#7 Tak 承認、#8–#50 は包括指示で Harvey 推奨（D-20260927-1、Tak の一言で閉じる）
**JA paper**: 意図的に削除済み（EN 完成まで Rule 2.7 保留）→ [[project_ja_paper_deleted]]
**Supplement**: なし（09-27 Tak）。survey・探索は本文の一文か repository
**PR**: [#17](https://github.com/tnagakubo/similarity_metrics/pull/17) open（2026-10-11、7 commits）；#16 merged。main は `fad1010` + 未 commit の 10-11 夜〜10-12 の作業（原稿・R・registry・guards・skills・memory）
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
