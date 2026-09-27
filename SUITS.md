# SUITS.md - Research Lab Live Script

> *"I don't have dreams. I have goals."* - Harvey Specter

**Previous Archive**: `archives/SUITS_20260927_130112.md`（1012 lines、〜 2026-09-27 14:05 の 40 scenes。今日の 4 scenes は下にも残した。直前は `archives/SUITS_20260921_162500.md`）
**Archive trigger**: Rule 2.5 (>1000 lines)

---

## Current Status

**Active Project**: similarity-metric (per-EM W₁ paper, target *Statistics in Medicine*)
**Phase**: 8 — Revision → `projects/similarity-metric/LAB_STATUS.md`（**2026-09-26 時点で未同期**。v6 構成変更を反映要）
**EN paper**: `projects/similarity-metric/paper/per_em_W1_wiley.tex` — **v6（判定の仕組みを削除）+ 誤り一括修正 + 判断確定 7 件を適用済み**。20 ページ、error 0、undefined 0。**未 commit**（09-22 の ab376fb 以降すべて working tree）
**原則（Tak 09-25）**: 論文は違いを定量化するだけ。併合の判定規則は規定しない（規定できない）→ [[feedback_quantify_not_decide]]
**段落レビュー**: 台帳 `projects/similarity-metric/REVIEW_QUEUE_v6.md`（50 段落）。**50/50 完了（09-27）**。#1–#7 Tak 承認、#8–#50 は Tak の包括指示に基づき Harvey 推奨で適用（個別拒否可）。21 ページ、error 0
**JA paper**: 意図的に削除済み（EN 完成まで Rule 2.7 保留）→ [[project_ja_paper_deleted]]
**Supplement**: **なし**（09-27 Tak「論文の supplement としては不要。論文作成の過程で検討された事項でしかない」）。A・B・実データ調査のファイルはディスクに残してあるが、投稿物ではない。本文 20 ページ

---

## 🔄 直前のコンテキスト

### 直近の作業（2026-09-23 〜 09-26）

1. **構成の迷走と収束**: v3 → v4（六段）→ 6 人審査 → v5（判定の仕組みを増やす方向）→ Tak「判定方法は規定できない」→ **v6 = 判定の仕組みを全削除**（τ_clin、§2.5 operability、適格判定・AND・6 地域、anchor vs clustering、L_UB 感度）。24 → 21 ページ。計画と全記録は `RESTRUCTURE_v6_no_decision.md`（§1–§10）
2. **§4.5 と ρ の段落を削除**（Tak、09-05 の ρ 残置決定を Tak 自身が覆した）。GUSTO での既存指標との一致の根拠は Supplement C へ
3. **実データ調査（Option C、事前登録）**: `PROTOCOL_real_data_survey.md` → `R/real_data_survey.R`。GUSTO-I・IST-3・IST-1 の 13 EM、1,503 ペア。W₁ と SMD の順位相関 0.839–0.996、SD 比 ≤ 1.65。CRASH-2 は rds が HTML で除外
4. **誤り一括修正**（Mike/Louis/Rachel 監査）: 48 箇所。KS と W₁ の bound の順序、bootstrap 一致性条件（{F₁=F₂∈(0,1)} 測度 0）、Prop. 1 の仮定、L* 表を区間付きに、¶2 の L* の誤り、cell for cell、n 1,231–4,352、S1/S2 coverage ほか。bib: quan2010 DOI、song2025 著者、komiyama2024 → year 2021、austin2009 追加
5. **判断確定 7 件**（全員議論）: harm 削除（KR 双対の循環）、α ラベル → 参照点、Supplement 番号、VanderWeele 節削除、ICH E6(R3) 句削除、Appendix の二標本正規極限の式削除、r = 0.13 と L* 表の出典 CSV 新設（`R/gusto_lstar_table.R`）
6. **09-26 原稿一冊**: `paper/per_em_W1_draft_20260926_with_supplements.pdf`（本文 20p + A + C）

### 進行中のアクション

- **段落レビュー完了（09-27）**。Tak が個別に拒否した段落は backup（`projects/similarity-metric/paper/backup/per_em_W1_wiley_before_review0927.tex`）から戻す
- 印の種類: `% V6-BRIDGE`（新規文）/ `% ERRFIX-2026-09-26`（誤り修正）/ `% DECISION-2026-09-26`（判断確定）。承認したら `% Paragraph reviewed and approved by Tak 2026-09-26 (Option X of the v6 paragraph review, queue #N)` に置換し、台帳を ✅ に

### 次にやるべきこと

- **Terminal pass 済み（09-27）**: abstract を 247 語で書き直し（主張はすべてゲートで照合済み）、略語、Data availability（predtools 0.0.3 と IST の DataShare DOI）、Supporting information
- **次の仕事**: `gusto_operability.csv` の旧列の整理（コード公開の準備で対応）
- **stale**: `PAPER_OUTLINE_BILINGUAL.md`（operability・jointly eligible・diameter が残る）、`review_response/` のメモ（削除した §2.5・L625 を参照）、LAB_STATUS
- **commit**（Tak 指示待ち。拒否権の期間が開いているため）。09-27 以前の backup は session scratchpad、09-27 レビュー前の版は `paper/backup/`
- 未確認 🔍: 二標本 W₁ の正規極限の一次文献（Appendix では式を削除済み）

### Takからの直近の指示

- 「厳密な判定方法は記載する必要がない。というか規定できない」（09-25）→ v6
- 「探すなら選り好みしない調査」→ Option C（09-26）
- 「まず間違い・誤りをすべて修正」→ 「判断のいる項目を一つずつ全員で議論して確定」（09-26）
- 「順に段落レビューに入ろう」（09-26）→ #1 C、#2 B、#3 B、#4 C、#5 C、#6 B、#7 B
- 「Abstract は最終の原稿が完成してから」（08-31）→ 継続

### 既知の潜在バグ（現状は不発）

- ⚠ `selection_simulation.R` の `w1_dist` — 不等 n で両標本を小さい方から n 個に黙って切り詰める。応用側に流用してはならない
- ⚠ `w1_raw_simulation.R` — `clusterSetRNGStream` + `parLapplyLB` で同 seed でも bit-reproducible でない（新しい `real_data_survey.R` は pair ごとに seed 固定で回避済み）

---

## 🎬 Live Script

### [2026-09-27 14:40] Scene: Tak「Section 3 で Study 2 が先に出てくるのは気持ち悪い」— 番号を入れ替え

**INT. PEARSON SPECTER LITT - BULLPEN - DAY**

**Katrina**:
「入れ替えた。identification が Study 1、estimation が Study 2 だ。本文の 13 行、19 か所。"presented first" の説明は不要になったから消した。compile error 0、20 ページ、ゲートは 2 本とも ALL PASS」

**Mike**:
「注意点が一つあります。\label（sec:study1 = estimation、sec:study2 = identification）とスクリプト名（verify_study2_figures.R = identification のゲート）は旧番号のままです。§3 の冒頭にコメントで書いておきました」

**Donna**:
「今日より前の記録にある『Study 2』は identification のことよ。読み替えて」

---

### [2026-09-27 14:30] Scene: Tak「supplement は不要。作成過程の検討事項でしかない」— Supplement ゼロへ

**INT. PEARSON SPECTER LITT - HARVEY'S OFFICE - DAY**

**Harvey**:
「Tak の言うとおりだ。実データ調査は、俺たちが自分の主張を確かめるためにやった検討であって、読者に渡す証拠じゃない。外す。ただ、Discussion の 2 文はあの調査の数値に頼っていた。どちらも本文の GUSTO-I の 15 パートナーで支え直す」

**Mike**:
「確かめました。年齢と SBP の距離の順位相関は、15 パートナーで −0.30 です。Table 5 から読者が自分で確かめられます。W₁ と SMD の順位の一致は年齢 0.90、SBP 0.95。アンカーとの SD 比は最大 1.11 です。どれもゲートで照合して ALL PASS でした。I got it!」

**Katrina**:
「本文に残る Supplement の参照は 0 件。Data availability から IST の文を、Supporting information から Supplement の記載を外した。compile error 0、20 ページ」

**Donna**:
「記憶に残しておくわ。『論文作成の過程で検討したことは Supplement にしない』。二度と増やす提案はさせない」

---

### [2026-09-27 14:05] Scene: Tak「supplement はあまり付けたくない」— A・B を外し、実データ調査だけ残す

**INT. PEARSON SPECTER LITT - HARVEY'S OFFICE - DAY**

**Harvey**:
「A は約分の一行だ。§2.4 に同じことが書いてあるから、本文に吸収する。B は社内メモで、本文の出典リストがその役を果たしている。deft estimator の一句だけ本文に残して外す。実データ調査は残す。Tak が 09-26 に、既存指標との一致の証拠をあそこへ移すと決めたからだ。これで Supplement は 3 本から 1 本になる」

**Louis**:
「0 本にしないのか。……いや、それでいい。0 本にしたら、Discussion の 0.84–0.996 と r = 0.13 が検証できなくなる。事前登録の記述も、探索的スキャンの開示も一緒に消える」

**Katrina**:
「本文の Supplement の参照は 0 件、呼び方は Supporting Information に統一した。compile error 0、ゲートは 2 本とも ALL PASS。一冊綴じは 23 ページで作り直した」

**Jessica**:
「Let me be clear。0 本にする選択肢は Tak に残しておく。その場合は 09-26 の決定を覆すことになる、と明記してだ」

---

### [2026-09-27 13:50] Scene: 判断ラウンド — Tak「判断が要る点を議論して判断して」

**INT. PEARSON SPECTER LITT - JESSICA'S OFFICE - DAY**

*残っていた 6 件の判断事項。Rachel が Song 2025 の PDF を開き、Louis が新しい abstract を攻撃する。*

**Rachel**:
「Song et al. 2025 の原典を確かめました。pooling strategy を『曖昧さが残る』課題として挙げ、p.4 で EM と endpoint の相関から距離を定める clustering を提示しています。本文にあった "without quantitative tools" は原典にございません。著者も NMPA ではなく、北京大学と企業の方々です。それから、`Song_2025.md` の『定量的な指標なし』も誤りでしたので訂正いたしました」

**Louis**:
「新しい abstract の数値は全部通る。問題は抜けたものだ。一つ目、Prop. 1 の『その EM だけに依存する』という仮定が落ちていた。二つ目、L* を『needed to produce』と書いていた。これだと十分条件に読める。三つ目、KS との比較に基準がなかった。四つ目、RV2・RV3 は俺たちの拡張なのに、Komiyama の手法の話に混ぜていた。それから Data availability に IST-1 と IST-3 が載っていない。You just got Litt up!」

**Harvey**:
「全部採る。判断は次のとおりだ。
1. Introduction：Song の文を原典どおりに直す。『absence of quantitative tools』も消す。
2. L：全文を L_clinical に統一する。
3. Supplement C：一度通読してから DRAFT 印を外す。
4. Terminal pass：今やる。abstract は 247 語で、限定句はゲートを通った数値にだけ載せた。
5. operability CSV の旧列：コード公開のときまで保留。
6. commit：保留だ」

**Jessica**:
「Let me be clear。commit は Tak の拒否権の期間が閉じてから、Tak の一言でやる。Supplement B はまだ社内メモのままで、投稿物になっていない。§2.4 は B で bound を導くと約束しているが、B はそれを果たしていない。書き起こすのは次の仕事だ。Supplement A の nABCD 表記と、B を名乗る normalizer ファイルの扱いも同じく次だ」

**Katrina**:
「Results speak for themselves. compile error 0、undefined 0、21 ページ。ゲートは 2 本とも ALL PASS。abstract は 247 語で上限は 250。引用なし、keywords は 6 つ」

---

### [2026-09-27 13:10] Scene: Numbers Verification — Mike traces every digit

**INT. PEARSON SPECTER LITT - BULLPEN - DAY**

*Mike spreads the R output beside the manuscript, cross-checking line by line.*

**Mike**:（電卓を置いて）
「二つのゲートを回しました。Study 2 は `verify_study2_figures.R` を六地域と新しい表の行まで拡張して ALL PASS。Study 1・Application・Discussion の分は `verify_study1_app_numbers.R` を新しく書いて、56 項目が ALL PASS です。L* 表は 15 行 × 8 値を CSV と突き合わせて、† 印も null floor の判定と一致しました。途中で要修正が 1 件ありました。KS の対称重症度セルの AUC を 0.98 と書いていましたが、正しくは 0.99 です。直しました。S4（n = 50）の被覆率 0.9425 は四捨五入の境目で、表の 0.942 はそのままで問題ありません。I got it!」

**Donna**:（頷いて）
「要修正は 0 件になったわね。ここから先は Tak の判断。個別の拒否と commit を待つわ」

---

### [2026-09-27 12:30] Scene: 段落レビュー #8–#50 完了 — Tak「Harvey の推奨で直して全部終わらせろ」

**INT. PEARSON SPECTER LITT - CONFERENCE ROOM - DAY**

*台帳の残り 43 段落。Louis が 3 人分の攻撃を節ごとに並行して提出し、Mike がそのすべてを CSV・rds・R コードと突き合わせる。Harvey が一段落ずつ選び、Katrina がコンパイルする。*

**Louis**:（三束の報告を叩きつけて）
「最悪の穴は三つだ。一つ目、Study 2 の "false-pooling rate among the k admitted"。コードの `f = ncm < k_true` は『k 個の中に不一致地域が一つでも入る確率』だ。二つ目、Set 4 の不一致地域は四つじゃない、六つある。bulk shift が二つだ。三つ目、Appendix の bootstrap の条件を Sommerfeld & Munk に帰している。あれは有限空間の論文だぞ。You just got Litt up!」

**Mike**:（R ファイルを開いたまま）
「全部確かめました。Louis が正しいです。`selection_simulation.R` L295 は at-least-one の確率で、W₁ 0.718・KS 0.971、偶然水準は 1 − 1/84 = 0.988。一枠あたりの不一致割合は 0.30 と 0.58（偶然 0.67）です。Set 4 の真値表も六地域で、KS 0.107 の S2 を入れても『KS の閾値では W₁ ≤ c の集合を切り出せない』は成り立ちます。それからもう一つ。#33 の『境界近くでは CI 上限で読め』は rds から裏付けが取れました。S2 では真値が上限を超えたことは一度もなく、S2・S5・S7 のどの n でも最大 1.1%。被覆の不足はすべて下側です。`R/study1_miss_side.R` として残しました。I got it!」

**Rachel**:
「実数直線上の bootstrap の一致性は Fang & Santos (2019) *Rev Econ Stud* DOI: [10.1093/restud/rdy049](https://doi.org/10.1093/restud/rdy049) に、非一致性は Dümbgen (1993) *PTRF* DOI: [10.1007/BF01197342](https://doi.org/10.1007/BF01197342) に差し替えました。Sommerfeld は、整数 mmHg の SBP のような格子上の場合に限って残しております。r = 0.13 はペア単位のデータから 0.133 と再計算し、Supplement C に明記いたしました」

**Harvey**:（台帳を見下ろして）
「選択は決めた。原則は一つだ、判定を書くな。#41 の『no more than four』は消す。#43 の『For practice, we recommend』は Methods の繰り返しだから段落ごと消す。#26 も重複だから消す。#40 の『must be evaluated』は、距離が一致しないという事実に書き換える。#47 の『where none was previously available』と『gap left by ICH E17』は Komiyama が存在する以上言い過ぎだ、"operationalizing ... that ICH E17 describes" まで下げる。#42 の最後は KR 双対の同語反復をやめて、Study 2 の効率の証拠に載せ替える。Set 3・4 の七セルのうち、KS に負けるのは bulk-shift の対照だけだ」

**Katrina**:
「Results speak for themselves. 印の残りは 0、compile error 0、undefined 0、21 ページ。Overfull の 3 件はレビュー前からあったもの。表は二つ直した。Set 3・4 の必要 n の表から漏れていた二セルを足して、L* 表では null floor 内の距離に † を付けた」

**Donna**:
「一つ念を押しておくわ。承認コメントは 'Harvey's recommendation under Tak's standing instruction' と書いた。Tak が一段落ずつ選んだわけじゃないから、'approved by Tak' とは書いていない。一覧は Tak に渡すから、気に入らない段落は個別に拒否できる」

**Jessica**:
「Let me be clear。数字はすべて出典に戻して確かめた。判定の文言も消した。残りは Terminal pass と commit、どちらも Tak の指示を待つ」

---

