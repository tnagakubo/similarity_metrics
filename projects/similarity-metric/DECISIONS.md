# DECISIONS — similarity-metric 判断記録（append-only）

**Rule**: 方針を決めた・覆した・保留した、のすべてを 1 件 1 entry で残す。「決定 X と矛盾するから却下」は理由にならない — 却下の理由そのものを書く（Louis memory: reasonless ledger rejections）。覆すときは新 entry を作り、旧 entry の Status を `superseded by D-…` にする。削除はしない。
番号: `D-YYYYMMDD-n`。最新を **下**に追加（SUITS.md とは逆。時系列で読むため）。

> **2026-10-10 の backfill**: 以下の 09-25 〜 09-27 の entry は `SUITS.md`（Current Status と scenes）・`archives/SUITS_20260927_130112.md`・`RESTRUCTURE_v6_no_decision.md` から Donna が復元した。Tak の言葉は記録にある verbatim。Options は記録に残る範囲で書き、残っていないものは「記録なし」とした。09-25 以前の判断（例: 09-05 の ρ 残置）は archive にのみある。

---

### D-20260925-1: 判定の仕組みを原稿から外す（v6）

- **Date**: 2026-09-25 → 適用 09-26  **Raised by**: Tak  **Decided by**: Tak
- **Question**: 論文は併合の判定規則（τ_clin、operability、AND 規則、eligible partners）を規定するか
- **Options**: v5（判定の仕組みを増やす方向、`RESTRUCTURE_v5_team.md`）／ v6（判定の仕組みを全削除、`RESTRUCTURE_v6_no_decision.md`）
- **Decision**: v6。残すのは不確かさ付きの量とその読み方の補助（W₁、Prop. 1、推定量と CI、Δ_max、L*、null floor、既存指標との比較）
- **Reasons**: Tak「厳密な判定方法は記載する必要がない。というか規定できない。違いを定量化して判定は臨床的な意味を考慮して行う」（09-25）、「判定の仕組みを抜いて」（09-26）
- **Evidence / references**: `RESTRUCTURE_v6_no_decision.md` §0–§7（53 箇所、24 → 21 pp、error 0）、`memory/feedback_quantify_not_decide.md`
- **Reversibility**: 規制側から「判定規則を示せ」と求められても、量の報告（L*）で読者が任意の L_UB と比較できる構造を崩さない。覆すなら Tak
- **Affected artifacts**: §2.4、§2.5（削除）、§3 冒頭、§4.2、§4.4、§4.5、Discussion ¶1/¶4/¶5；`CLAIMS.md` narrowed log
- **Status**: active

### D-20260926-1: §4.5 と ρ の段落を削除（09-05 の ρ 残置決定を覆す）

- **Date**: 2026-09-26 16:10  **Raised by**: Tak  **Decided by**: Tak（「OK。両方外す」）
- **Question**: §4.5 Comparative Application（`tab:app_allmethods`、RV2/RV3・R6、ρ 段落）を残すか
- **Options**: 残す（09-05 決定: ρ 残置）／ 節ごと削除し、既存指標との一致の根拠を Supplement へ移す
- **Decision**: 削除。RV1 = SMD の射程の一文は Study 2 Design へ移設。Discussion ¶4 の参照先を実データ調査へ
- **Reasons**: 09-05 の残置決定を Tak 自身が覆した。記録に残る理由: v6 の基準（§4.5 の k が τ_clin に依存し、判定の仕組みを前提としていた）。**09-05 側の理由は archive にのみあり、本 entry では反駁していない**（Louis memory #3 の型）
- **Evidence / references**: `RESTRUCTURE_v6_no_decision.md` §8、SUITS archive 09-26
- **Reversibility**: 既存指標との一致を本文で示す必要が reviewer から出たとき（現在は Discussion の 15 partner の数値で支える: D-20260927-2）
- **Affected artifacts**: §4.5（削除）、§3.1 Design、Discussion ¶4、表 11 → 10
- **Status**: active（09-05 の決定を supersede）

### D-20260926-2: 実データ調査は「選り好みしない調査」として事前登録（Option C）

- **Date**: 2026-09-26  **Raised by**: Harvey  **Decided by**: Tak
- **Question**: W₁ と既存指標（SMD・KS）が実データで順位を変えるかを、どう調べて示すか
- **Options**: A 乖離例を探して示す／ B 調べない／ C 全データ・全 EM を事前登録して報告（結果はそのまま）
- **Decision**: C
- **Reasons**: Tak「探すなら選り好みしない調査」。事前に見た scan（SMD < 0.1 の閾値）は §0 に開示し、primary を閾値非依存（順位相関）に
- **Evidence / references**: `PROTOCOL_real_data_survey.md`、`R/real_data_survey.R`、`results/real_data_survey_*.csv`（13 EM、1,503 ペア、Spearman 0.839–0.996、SD 比 ≤ 1.65）
- **Reversibility**: —（調査は実施済み。掲載先は D-20260927-2 で変更）
- **Affected artifacts**: Supplement（旧 E → C → 09-27 に廃止）、Discussion ¶4
- **Status**: active（掲載は D-20260927-2 に従う）

### D-20260926-3: 判断確定 7 件（全員議論）

- **Date**: 2026-09-26  **Raised by**: Mike / Louis / Rachel（誤り監査の後）  **Decided by**: Harvey、Tak「判断のいる項目を一つずつ全員で議論して確定」
- **Question**: 誤り一括修正（48 箇所）の後に残った、判断を要する 7 項目
- **Decision / Reasons**:
  1. harm 2.14× を削除 — KR 双対で W₁ が定義上優位になる循環（`memory/project_no_effect_tracking_sim.md`）
  2. α ラベル → 参照点 — 「有意水準」と誤読される
  3. Supplement 番号の整理（D → B、E → C）
  4. VanderWeele 節を削除 — 本文の論証に不要
  5. ICH E6(R3) の句を削除 — 根拠が薄い
  6. Appendix の二標本正規極限の式を削除 — 一次文献が未確認（🔍 継続）
  7. r = 0.13 と L* 表の出典 CSV を新設（`R/gusto_lstar_table.R`）— 数値の traceability
- **Evidence / references**: SUITS Current Status「判断確定 7 件」、archive 09-26
- **Reversibility**: 6 は一次文献が見つかれば復元可
- **Affected artifacts**: §2.4、§3、Appendix、Supplement、`results/gusto_lstar_intervals.csv`
- **Status**: active

### D-20260927-1: 段落レビュー #8–#50 を Harvey 推奨で一括適用（Tak の包括指示）

- **Date**: 2026-09-27 12:30  **Raised by**: Tak  **Decided by**: Tak
- **Question**: 残り 43 段落（`REVIEW_QUEUE_v6.md` #8–#50）を個別に Tak レビューするか
- **Options**: A 個別レビュー継続／ B Harvey 推奨（Option A/B/C のうち Harvey が選ぶ）で一括適用、Tak は個別拒否可
- **Decision**: B
- **Reasons**: Tak「Harvey の推奨で直して全部終わらせろ」。#1–#7 は個別承認済み（C, B, B, C, C, B, B）
- **Evidence / references**: `REVIEW_QUEUE_v6.md`（50/50 ✅）、backup `paper/backup/per_em_W1_wiley_before_review0927.tex`
- **Reversibility**: **Tak の個別拒否権が開いている**。投稿前に Tak が「拒否なし」または拒否リストを出し、本 entry を閉じる（`/submission-check` 3b）
- **Affected artifacts**: §2–§5、Appendix、Introduction roadmap
- **Status**: active — **要クローズ**（Tak の一言）

### D-20260927-2: Supplement をゼロにする

- **Date**: 2026-09-27 14:05 → 14:30  **Raised by**: Tak  **Decided by**: Tak
- **Question**: Supplement（A 正規化の同値性 / B L_clinical 文献メモ / C 実データ調査）をどう扱うか
- **Options**: 3 本維持／ C だけ残す（14:05: Harvey 案、Louis は 0 本に反対「0.84–0.996 と r = 0.13 が検証できなくなる」）／ 0 本（14:30）
- **Decision**: 0 本。A は §2.4 の一行に吸収、B は本文の出典リストで代替、C は投稿物から外す。Discussion の 2 文は本文の GUSTO-I 15 partner で支え直す（年齢と SBP の順位相関 −0.30、W₁ と SMD の順位一致 0.90 / 0.95、SD 比 ≤ 1.11 — gate ALL PASS）
- **Reasons**: Tak「supplement はあまり付けたくない」→「supplement は不要。作成過程の検討事項でしかない」。Jessica: 0 本は 09-26 の決定（D-20260926-1 の移設先）を覆すことになると明記した上で Tak に選択肢を残した
- **Evidence / references**: SUITS scenes 09-27 14:05 / 14:30、`memory/feedback_tak_feedback_patterns.md`（論文の射程）
- **Reversibility**: reviewer が実データでの一致の証拠を要求したとき、`results/real_data_survey_*.csv` は残してある
- **Affected artifacts**: Discussion ¶4、Data availability（IST の文を外す）、Supporting information、本文 20 pp
- **Status**: active（D-20260926-1 の「Supplement へ移す」部分を supersede）

### D-20260927-3: Study の番号を入れ替える（identification = Study 1、estimation = Study 2）

- **Date**: 2026-09-27 14:40  **Raised by**: Tak  **Decided by**: Tak
- **Question**: §3 で Study 2 が先に出る構成を直すか
- **Decision**: 入れ替え（本文 13 行・19 箇所）。`\label`（`sec:study1` = estimation、`sec:study2` = identification）と script 名（`verify_study2_figures.R` = identification の gate）は旧番号のまま、§3 冒頭にコメント
- **Reasons**: Tak「Section 3 で Study 2 が先に出てくるのは気持ち悪い」
- **Evidence / references**: SUITS scene 09-27 14:40、compile error 0、gate 2 本 ALL PASS
- **Reversibility**: —
- **Affected artifacts**: §3、Discussion の Study 参照、**09-27 以前の記録の「Study 2」は identification を指す（読み替え）**
- **Status**: active

### D-20260927-4: Terminal pass を実施（abstract 247 語、略語、Data availability、Supporting information）

- **Date**: 2026-09-27  **Raised by**: Harvey  **Decided by**: Harvey（Tak 08-31「Abstract は最終の原稿が完成してから」に従う）
- **Decision**: 本文確定後に abstract を書き直し（247 語、限定句はゲートを通った数値にだけ）、略語、Data availability（predtools 0.0.3）、Supporting information（なし）
- **Reasons**: 本体 → Discussion → Terminal の作業順序（`memory/feedback_tak_feedback_patterns.md`）
- **Evidence / references**: SUITS scenes 09-27 13:50 / 14:30、Louis の abstract 攻撃 4 点（Prop. 1 の仮定、L* の「needed to produce」、KS 比較の基準、RV2/RV3 の帰属）を反映
- **Affected artifacts**: abstract、略語表、back matter
- **Status**: active（abstract の各文は `CLAIMS.md` と照合 — `/claims init` 待ち）

### D-20261010-1: 研究システムに科学的妥当性の機構を追加する

- **Date**: 2026-10-10  **Raised by**: Tak  **Decided by**: Tak（指示）、設計は Harvey
- **Question**: 「SUITS 研究システム全体を見直し、科学的に適切に研究を進められ、論文作成ができるようにシステムを改善して。キャラクターの個性はドラマ Suits に合わせることは変えないで」
- **Options**: A CLAUDE.md に原則を追記するだけ／ B 原則を hook・script・template・skill に機械化する／ C 両方（原則は CLAUDE.md Rule 5・6、機構は `RESEARCH_FRAMEWORK.md` §6–§8）
- **Decision**: C
- **Reasons**: 原則は 09-21 の framework に既にあったが、参照先の memory 12 本が repo に無く（cloud session では消えていた）、protocol は 1 本、numbers ledger は無く、LAB_STATUS は stale だった。語るだけの原則は守られない。キャラクターは `agents/*.md` を一切変えず、機械的に取れる違反（ラストネーム・敬語）だけ lint にした
- **Evidence / references**: `RESEARCH_FRAMEWORK.md` §6（S1–S11）・§8、SUITS scene 2026-10-10、PR [#16](https://github.com/tnagakubo/similarity_metrics/pull/16)（commits `640f6a6`, `bc88e48`, `5d9c28d`; merged 2026-10-11 07:52 JST as `2d97230`）
- **Reversibility**: CLAUDE.md の Rule 5・6 は Tak の拒否権下（framework §5 の記載どおり CLAUDE.md は Tak の文書）。hook はすべて advisory（exit 0）で、不要なら settings.json から外せる
- **Affected artifacts**: CLAUDE.md、RESEARCH_FRAMEWORK.md、README.md、`.claude/{hooks,skills,rules,agents}`、`scripts/`、`memory/`、`templates/`、本 file、`CLAIMS.md`、`results/NUMBERS_LEDGER.csv`
- **Status**: active

### D-20261011-1: 研究システムを「論文 = protocol と data の関数」の pipeline にする（Option B）

- **Date**: 2026-10-11  **Raised by**: Tak（「劇的に科学的研究が進むような改修はできるか」）  **Decided by**: Tak（「B」）
- **Question**: 守りの機構（10-10）の上に、研究サイクルを速く・自動で・証拠付きで回す梃子をどこまで入れるか
- **Options**:
  - A（最小）: 数値のマクロ化 + CI（R なし）。半日〜1 日。traceability だけ片付く
  - B（構造）: 数値の生成（registry / single-writer 表）、protocol compiler、clean-room replication、R/TeX を入れた CI と cloud 環境、新論文は Quarto。システムの種類が変わる
  - C（折衷）: B のうち Quarto 移行だけ次の論文から
- **Decision**: B
- **Reasons**: Harvey「劇的に進むのは守りではなく、一回の研究サイクルが安く・速く・自動で回り、一周ごとに証拠が増るとき」。Jessica「劇的を約束するのは一つ — 数値を手で書かなくなること。構造の変化で、努力の変化ではない」。Louis の留保（アイデアの質・独立性・臨床判断は速くならない）は `RESEARCH_FRAMEWORK.md` §9「何が変わらないか」に明記
- **Evidence / references**: `RESEARCH_FRAMEWORK.md` §9・§6 S12–S15、`scripts/numbers_registry.py` / `scripts/r/numbers_registry.R` / `scripts/make_numbers_macros.R` / `scripts/protocol_compile.py` / `scripts/extract_methods.py` / `scripts/compare_results.py` / `scripts/ci_ratchet.sh` / `scripts/cloud_setup.sh`、`.github/workflows/`、`templates/paper_template.qmd`、`/replicate`。§3.2 で実証: 34 数値を registry 化、3 表を生成に置換、compile error 0、`pdftotext` 差分 0 行、numbers audit 672 → 526、回帰テスト 60/60
- **Reversibility**: `\numval{key}` は `numbers_macros.tex` の値で機械的に literal に戻せる。CI は workflow を消せば止まる。原稿の本文は 1 文字も変えていない（PDF テキスト同一）
- **Affected artifacts**: CLAUDE.md Rule 6・Technical Standards、`RESEARCH_FRAMEWORK.md`、README、skills（`/protocol` `/verify-numbers` `/start` `/reproduce` `/replicate`）、rules、agents、`paper/per_em_W1_wiley.tex`（§3.2 と preamble）、`paper/numbers_registry.csv`、`paper/numbers_macros.tex`、`paper/generated/`、`R/make_paper_tables.R`、`paper/build.sh`
- **Status**: active

### D-20261011-2: 原稿に印字する数値の丸めは decimal round-half-even に固定する

- **Date**: 2026-10-11  **Raised by**: Katrina（生成した coverage 表と原稿が 1 セル違った）  **Decided by**: Harvey（Mike・Katrina の検証後）
- **Question**: S4, n = 50 の coverage は 9,425 / 10,000 = 0.9425 で 3 桁目の正確な境界。原稿（09-21 に Tak のマシンで `formatC(x, "f", 3)` が生成）は 0.942、本環境（Linux, R 4.3.3）の同じコードは 0.943。どちらを正とするか、規則は何か
- **Options**:
  - A: `formatC` / `sprintf` のまま（binary double を丸める → 0.9425 の double は 0.9425 のわずか上なので glibc では 0.943、別の runtime では 0.942。**機械依存**）
  - B: decimal round-half-up（0.943、0.929）— 原稿の 2 セルが変わる
  - C: decimal round-half-even（IEC 60559 の既定、「偶数へ」）— 0.942、0.928。原稿を再現する
- **Decision**: C。15 有効桁の decimal 表現に対して half-even。R と Python に同一実装（`.num_round_dec` / `round_dec`）、回帰テスト 9 値で一致を確認
- **Reasons**: 原稿の既存表示（0.942、S7 n=50 の 0.928）と一致する唯一の決定的規則であり、IEEE/IEC の既定と同じ。規則を 1 つ決めて両実装に置くことが、どの機械で生成しても同じ原稿が出る条件
- **Evidence / references**: `scripts/r/numbers_registry.R::.num_round_dec`、`scripts/numbers_registry.py::round_dec`、`scripts/tests/run_tests.sh`「tie 0.9425 → 0.942」、`paper/generated/tab_coverage.tex`（原稿の旧行と byte 一致）
- **Reversibility**: 規則を変えるときは本 entry を supersede し、全生成物を再生成して `pdftotext` 差分で影響セルを列挙する
- **Affected artifacts**: `R/make_paper_tables.R`、registry 両実装、Discussion には影響なし。**付記（Mike）**: coverage は 10,000 回の割合なので 4 桁目が 5 のセル（S4 n=50、S7 n=50）は 3 桁表示で必ず境界に乗る。4 桁表示にするか否かは Tak の判断（現状維持）
- **Status**: active

### D-20261011-3: build と生成表の規約（bibtex の相対パス、tabular 全体の生成）

- **Date**: 2026-10-11  **Raised by**: Katrina  **Decided by**: Harvey
- **Question**: Linux で初めて compile したら (a) 引用が全件 undefined、(b) 行だけを `\input` した表で `Misplaced \noalign`
- **Decision / Reasons**: (a) `build.sh` の `bibtex` を相対パスに — TeX Live は `openout_any = p` で絶対パスの .bbl/.blg を書かない。Windows でも動く。(b) 生成ファイルは `\begin{tabular}` 〜 `\end{tabular}` を丸ごと持ち、原稿は 1 行の `\input{generated/tab_x}`。表の構造（列指定・見出し・罫線）も single writer の責任にする
- **Evidence / references**: `paper/build.sh`、`R/make_paper_tables.R`、build log（error 0・undefined 0・20 pp）
- **Status**: active

### D-20261011-4: 原稿の数値を全件「生成」に切り替える（表 9 本 = single writer、prose 120 値 = registry、設計定数 27 = 台帳）

- **Date**: 2026-10-11  **Raised by**: Mike  **Decided by**: Harvey（Tak の「すすめて」= LAB_STATUS Next 2 の実行）
- **Question**: `numbers_audit.py` の未ソース 526 値（表 344 + prose 182）をどう消すか。表の数値・prose の結果数値・設計定数は同じ機構で扱うべきか
- **Options**: A 全部を registry（`\numval{}`）にする／ B 表は single writer（`R/make_paper_tables.R` が tabular 全体を書く）、prose の結果数値は registry、設計定数（n grid、B、反復数、目標 AUC/ARI、CI 水準、margin、Set 4 の設計値）は `results/NUMBERS_LEDGER.csv` に出所付きで記録／ C 設計定数も registry にする
- **Decision**: B。設計定数は protocol が決めた値で「結果」ではない。`$n = \numval{nMid}$` と書くと本文が読めなくなり、生成の利益もない。台帳行は source_locator（R スクリプトの行、config CSV の列、provenance の表）を持ち、Katrina が producer（Mike）と別に検証する（four eyes）。CSV に無い導出量（grid 全体の AUC range、oracle と silhouette の差、Set 4 の母集団 W₁/KS、GUSTO の Spearman と SD 比、S6 の閉形式定数、N と n_R8）は新しい single writer `R/make_derived_numbers.R` → `results/derived/*.csv` に書き、registry はそこから引く（prose に算術を持たせない）
- **Reasons**: (1) 原稿の数値が「生成」になる割合: 672 → 526 → **2**（残り 2 は下記 finding）。(2) 生成した 6 表は旧 tabular と whitespace 正規化後に byte 一致、`\input{…}%` の後に空白 token を残さない書き方で `pdftotext` 差分 0 行、PDF サイズまで同一（373,705 bytes）。(3) 導出量を R に置くことで「prose に計算式を隠す」ことがなくなり、CI が `results/derived` の鮮度を検査できる
- **Findings（本文の変更は Tak の判断）**: tab:study2_required_n の注「RV2 and RV3 sit slightly below chance (0.44--0.46) through n = 2,000」は再現しない。grid 全体では RV2 0.444–0.458、RV3 **0.426**–0.452（n = 50, 75, 100, 150, 400 で 0.43 台）。正しくは 0.43--0.46（または RV2 だけなら 0.44--0.46）。2 token を未ソースのまま残し、ratchet baseline = 2
- **Tooling fixes（同時）**: `numbers_registry.py apply` は同じ行の token を後ろの出現から置換する（先に置換すると occ がずれる）；`1,047` と `1{,}047` を同一視；`numbers_audit.py --draft-registry` の occ は正規化値ではなく literal で数える；台帳の照合は「台帳の値（高精度）を本文の桁に丸めて一致」のみ許す（0.5 が 0.46 を吸収していた）。回帰テスト 66 本
- **Evidence / references**: `paper/numbers_registry.csv`（154 keys）、`paper/generated/tab_*.tex`（9 本）、`results/derived/`、`results/NUMBERS_LEDGER.csv`、`scripts/baseline/similarity-metric_numbers_unsourced.txt` = 2、`verify-draft` 154/154 一致、`check` PASS（R と Python の macros 一致）
- **Affected artifacts**: `paper/per_em_W1_wiley.tex`（文言不変、数値は `\numval{}` と `\input{}`）、`R/make_paper_tables.R`、`R/make_derived_numbers.R`、`R/verify_study1_app_numbers.R`（生成表を読む、predtools 無しでも走る）、`.github/workflows/r-and-tex.yml`
- **Status**: closed（Tak 2026-10-11「正しく修正」→ D-20261011-7）

### D-20261011-5: Study 2 の clean-room replication は PASS、Methods 本文に 2 件の Major な欠落

- **Date**: 2026-10-11  **Raised by**: Louis（replication）/ Katrina（比較）  **Decided by**: Mike（root cause）、Harvey（扱い）
- **Question**: `/replicate` の結果をどう読むか。true_W1 の FAIL は再現失敗か
- **Decision**: 推定量と区間の性質（coverage、bias、mean_est、rmse、mean_ci_width）は事前宣言の許容差内で再現 → **PASS**。true_W1 の FAIL（最大差 0.003155、S7）は Methods 本文が true W₁ を 2 桁で印字していることが原因（Louis は本文どおりの値を使った）。本文の欠落として扱い、再現失敗とはしない
- **Methods への action（Tak の判断で本文を直す）**: (A1 Major) two-sample bootstrap で何を resample するか（region 内で独立に size n_r）を書く；(A2 Major) S1（true W₁ = 0）の coverage の扱い（構造的に 0）を書く；true W₁ は閉形式か正確値で与える；quantile rule、seed と RNG、`sd_est`/`n_valid` の定義；`\label{sec:study1}` の付け間違い；「MCSE below 0.005」→「at most」、bias/RMSE/width の MCSE も報告；S6 のラベル "Skew" は scale も変えている
- **Reasons**: RESEARCH_FRAMEWORK S14 — Methods 本文だけで再実装できることが再現可能性の定義。許容差は run 前に Mike が宣言（`results/replication/TOLERANCE_study2_estimation.md`）
- **Evidence / references**: `results/REPLICATION_20261011.md`、`results/replication/compare_{coverage,moments,truth}_20261011.md`、`R/replication/study2_estimation_louis.R`（Ambiguities block 1–72 行）、`review_response/METHODS_ONLY_20261011.tex`
- **Affected artifacts**: Methods §2.3–§3.2（Tak 承認後）、`CLAIMS.md` C-09/C-17/C-22 の evidence に replication を追加
- **Status**: active

### D-20261011-6: `/claims init` の 3 本の弱い主張（C-34 BCa、C-35 application の動詞、C-08 abstract の効率比較）— Harvey の提案を記録、適用は Tak

- **Date**: 2026-10-11  **Raised by**: Harvey（`/claims init`、39 行起票、全行 pending）  **Decided by**: 未決（Tak）
- **Question**: 証拠を超えている 3 本をどう直すか
- **Options / Harvey の推奨**: C-34（§3.2.2 BCa の段落）: A 削除（BCa の coverage はディスクに無い）**← 推奨**／B protocol を書いて BCa を再計算／C 1 文残して exploratory と明記。C-35（§4.3 "shows"、"Section 5 quantifies this across all region pairs"）: A 動詞と参照先を直す／B 120 ペア分析を本文に戻す（D-20260927-2 を覆す）／C A + Spearman −0.30（n = 15）に CI を registry 経由で付ける **← 推奨**。C-08（abstract「fewer patients than KS in all but a uniform-shift control」）: A cell ごとの倍率で書き直す／B required n の Monte Carlo 不確かさ（delta 法、既存 CSV の mc_se から）を出して区間で比較 **← 推奨**／C 近い 4 cell に限る
- **Also flagged（⚠ 7 行）**: C-07, C-09, C-18, C-24, C-32, C-33, C-35 — 動詞が許容表（theory: shows / simulation: demonstrates, illustrates / application: illustrates, is consistent with）を超える
- **Reasons**: Rule 6「主張 ↔ 証拠」。原稿は触っていない（Harvey）。文言の変更は Tak の段落承認が必要（D-20260927-1 の運用）
- **Evidence / references**: `CLAIMS.md`（39 行、行番号は commit `0d70baf` 基準、作業ツリーへの対応表はヘッダ）
- **Status**: closed（Tak 2026-10-11「推奨通り修正」→ D-20261011-7）

### D-20261011-7: Tak の判断 3 件を適用 — Table 1 の注を訂正、Methods を replication の欠落どおりに補強、C-34/C-35/C-08 を Harvey の推奨どおりに直す

- **Date**: 2026-10-11  **Raised by**: Mike / Louis / Harvey（D-20261011-4・5・6）  **Decided by**: **Tak**（「1. 正しく修正 2. 推奨通り修正 3. 推奨通り修正」）
- **Decision**: (1) tab:study2_required_n の注「(0.44--0.46)」を registry key（`aucShapeSymRV23min/max` ← `results/derived/selection_cell_auc_range.csv`）に置き換え、印字は 0.43--0.46。(2) Methods: two-sample bootstrap は各 region 内で独立に $n_r$ 個を復元抽出、95% 区間は 2.5/97.5 percentile（R type 7）と明記；coverage の定義 $[L, U] \ni W_1$ と S1 の構造的 0 を Study 2 の performance measures に明記；true $W_1$ の正確値（S5 3.989423、S6 12.159806、S7 5.833155）を表の注に；seed（$42 + 1{,}000k$）と L'Ecuyer–CMRG streams、bit 再現不能の開示；MCSE は「at most 0.005」とし bias/RMSE/幅の MCSE 最大値（0.026/0.021/0.024、新 single writer `R/study2_mcse.R` → `results/study2_mcse.csv`）を報告；S6 ラベルを "Skew + scale"、SD 26.6 を注に；`\label{sec:study1}`/`sec:study2` の入れ替えを修正（`sec:study2_*` → `sec:study1_*`）。(3) C-34: BCa 段落を削除（retracted）。C-35: 動詞を illustrates / need not に、参照先を 15 partners に、Spearman −0.30 に Fisher z + Bonett–Wright 分散の 95% 区間 [−0.71, 0.26]（`\cite{bonett2000}`、DOI 10.1007/BF02294183 を Crossref で確認）。C-08: `R/required_n.R` に delta 法の 95% Monte Carlo 区間（log n 上、bracketing cell の mc_se）を追加し `required_n_lower/upper` 列を出力、新表 tab:study2_required_n_mc（W₁ vs KS、separate/overlap）を Table 1 の直後に置き、abstract・§3.1・§5 ¶4 を「5 of 7 cells separate、shape-symmetric は indistinguishable（690 [662, 718] vs 716 [688, 747]）、control は KS fewer」に書き換え（abstract 249 語）。Study 1 の事後 protocol `PROTOCOL_study1_identification.md` を prior-look 開示付きで登録
- **Reasons**: Tak の指示。Harvey の推奨（D-20261011-6）のうち Table 1 への区間併記は、7 cell × 6 measure に区間を入れると本文幅を超えるため、隣接する表（W₁ と KS の 2 列）に置いた — 比較の対象はこの 2 列であり、他 4 measure の区間は CSV にある
- **C1 cascade**: C-08 の文言変更は abstract・§3.1 selection・§5 ¶4 の 3 箇所で同時に行い、`CLAIMS.md` の C-08/C-33/C-34/C-35/C-11 と Narrowed/retracted log に記録。C-33 は「ensuring … genuine」を削除（narrowed）
- **Evidence / references**: `results/required_n_selection.csv`（旧列は byte 一致、新列 2 本）、`results/study2_mcse.csv`、`results/derived/derived_scalars.csv`（spearman CI、s6_sd）、`paper/generated/tab_study2_required_n_mc.tex`、`paper/numbers_registry.csv`（172 keys）、build log（0 errors）、`pdftotext` 差分（変更箇所のみ）、Louis の review（SUITS 2026-10-11）
- **Affected artifacts**: `paper/per_em_W1_wiley.tex`（abstract、§2.3、§3.1 selection、§3.2 design/results、§4.3、§5 ¶2–¶4）、`paper/per_em_W1_wiley.bib`、`R/required_n.R`、`R/study2_mcse.R`、`R/make_derived_numbers.R`、`R/make_paper_tables.R`、`CLAIMS.md`、`PROTOCOL_study1_identification.md`
- **Louis review（2026-10-11、11 項目 + B1–B6; Critical 0 / Major 8 / Minor 9）の扱い**: 適用 — "indistinguishable" を 3 箇所から除去（overlap した marginal 区間は同等性を示さない；曲線は目標付近で交差）、Spearman は "do not agree" + 区間の読み、MCSE の noise 幅を 2 cell で $z_{0.975}\sqrt{2}$ 倍と明記、S1 coverage の文言を Table 6 注と整合、S6 の cascade（§3.2 summary・§5 ¶1 (iii)・C-09）、Table 1 注の "combined pools" を ERRFIX、§3.1 Design に事後決定の開示（S8）、区間を外側丸め、R version の証拠を限定、C-38 cascade、protocol §0(b)/§5.2 の未確認の主張を訂正。**Tak の判断に回す（原稿の既存文に触るため）**: (i) "near-nominal"（§3.2 L396・summary・§5 ¶1 (iii)）を範囲の報告に置き換えるか許容幅を定義する（S5/S7 n=100 は 0.95 を noise 以上に下回る、C-09）；(ii) BCa を非公式に見た事実の一文開示（Tak は削除 A を選択）；(iii) Sets 1–2 の selection でも W₁ が 6/6 cell で先に 0.9 に届く一文（B6）；(iv) per-replicate stream で Study 2 を再 run し "not bit-reproducible" を消す；(v) Spearman 区間を region 内 resampling の joint bootstrap に置き換える；(vi) tab:study2_*/fig:study2_auc の rename
- **Status**: active（D-20261011-4・5・6 を閉じる）

### D-20261011-8: 2026-09-27 の Tak の 3 決定（RV1–RV3 を外す／クラスタリングを外す／パートナーを W₁ で順位付け）を、Option B の生成基盤の上に載せ直してマージする

- **Date**: 2026-10-11（決定そのものは 2026-09-27、Tak）  **Raised by**: Donna（`git pull` が衝突 — ローカルの 09-27 作業と cloud の PR #16/#17 が同じ原稿を別方向に変えていた）  **Decided by**: **Tak**（09-27: 「クラスタリングの話は不要になったのでは？」「RV を外し、Komiyama は一例の紹介として扱う」「シミュレーションで正しく併合地域を選べる手法を特定し、GUSTO-I に適用する」; 10-11: マージ手順「その手順で進めて」）
- **Question**: ローカル（未 commit、09-27）は RV1–RV3 と §3.1.4 clustering を原稿から外し Table 5 に Rank 列を足した。origin/main（10-11）は RV と clustering を残したまま、全数値を `\numval{}` と `\input{generated/…}` に置き換えた。どちらを土台にするか
- **Options**: A ローカルを採り生成基盤を捨てる／ B origin/main を土台にし、ローカルの内容判断を生成基盤の上で書き直す／ C リモートを正としローカルの内容変更を捨てる
- **Decision**: B。内容の判断は Tak の 09-27 決定（`memory/feedback_komiyama_no_overreading.md`、`PROTOCOL_silhouette_extension.md` の基準不成立）であり覆さない。機構（数値は生成）は Rule 6 であり覆さない。両立する
- **Reasons / what changed**: (1) 原稿: abstract（RV 文を削除、Louis の "five of seven cells / not separated in one / control" を保持、247 語）、Intro の Komiyama 段落（一例の紹介、評価なし、binary では一つの割合で分布が決まる）、§2 pooling assessment に順位付けを復元、§3.1 は three measures・selection task のみ・two behaviours（blind / recovering）、Table 1 を 3 列、§3.1.4 と Table 3（ARI）を削除、§4.3 に Study 1 → 応用の橋渡しと Table 5 の Rank 列（null floor 内は "1--6†"／"1†" の同順位）、§5 ¶1 (i)(ii) を SMD に限定、Komiyama 段落から "recipe" と "that proposal addresses" を削除、結語から "complementing summary-based clustering" を削除。(2) 生成基盤: `R/make_paper_tables.R` は required-n 表を W₁/KS/SMD の 3 列に、ARI 表を削除、GUSTO 表に Rank 列（`gusto_operability.csv` の unresolved から dagger range を機械的に作る；非連続なら stop）；`R/make_derived_numbers.R` から clustering ブロックと RV1 vs SMD の Spearman を削除し、Table 5 注の R6−R5 差を追加；registry は孤児 46 keys を削除・5 keys 追加（`aucBlindSMDmin/max`、`nCellsSMDblind`、`nCellsSelection`、`w1SbpR6minusR5`）→ **132 keys、全 key 使用、`check` PASS**。(3) ゲート: `verify_study1_app_numbers.R` は Table 5 の行を `generated/tab_gusto_nabcd.tex` から読む；両ゲート ALL PASS；`numbers_audit` 0 unsourced（ratchet 0 維持）
- **C1 cascade**: `CLAIMS.md` C-02/C-03/C-07 narrowed（RV を外した表現に）、C-27/C-29/C-31 retracted（RV1、partial、clustering）；`PROTOCOL_study1_identification.md` §8 に「RV1–RV3 と clustering の結果は本文で報告しない（Tak 09-27）」を deviation として追記；`PROTOCOL_silhouette_extension.md`（09-27 事前登録、基準不成立）をリポジトリに追加；Louis の memory 2 件（`feedback_nocut_prose_and_sim_scope_leak`、`feedback_competitor_removal_residue`）を統合先 `.claude/agent-memory/louis/` に移動
- **Evidence / references**: branch `wip/local-2026-10-11`（ローカル作業の退避 commit `bcc5913`）→ merge commit；`results/verify_study2.log`・`results/verify_study1_app.log`（ALL PASS）；`paper/numbers_registry.csv`（132）；build log；SUITS 2026-09-27 15:30 / 17:10 / 19:55 の scene
- **Reversibility**: RV と clustering の CSV（`required_n_selection.csv` の RV 行、`clustering_sim_summary*.csv`、`clustering_nok_*.csv`）は削除していない。戻すなら本 entry を supersede し、registry と `make_paper_tables.R` に列を戻す
- **Status**: active
