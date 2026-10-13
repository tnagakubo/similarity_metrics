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

### D-20261011-9: Claude Science の一回限りの referee を、ラボの常設機構（referee-grade environment）に置き換える

- **Date**: 2026-10-11 夜  **Raised by**: Tak（「claude science を超える研究環境を構築して」）  **Decided by**: Harvey（設計）、Donna（on-disk 検証）、Jessica（承認視点は SUITS scene）
- **Question**: `claude_science/`（2026-09-21）が一度だけやった冷読・raw からの再計算・所見 → 実行ゲート・修正の再審査・構造診断・必要性分析・side study を、どうすれば毎 draft・同条件で再現し、かつ超えられるか
- **Options**: A Claude Science を必要な時に再度呼ぶ（外部依存、再現性なし）／ B 既存の `/review` `/pre-review` を強化する（Louis は文脈を持ちすぎて同じ穴を見落とす）／ C 文脈を遮断した `referee` agent + 所見を guard として永続 + 修正の二次審査 + 構造・必要性の機械化 + 探索 sandbox（本件）
- **Decision**: C。`RESEARCH_FRAMEWORK.md` §10・S16–S20。新設: scripts 5（`texprose.py` `claim_guards.py` `structure_audit.py` `cascade_check.py` `evidence_coverage.py`）、skills 5（`/referee` `/review-fix` `/structure` `/necessity` `/explore`）、agent 1（`referee`、blind list、Edit 不可）、hook 1（`check-claim-guards.sh`）、templates 2（`claim_guards_template.toml` `venue_profiles.toml`）、`projects/similarity-metric/CLAIM_GUARDS.toml`（15 guards、known_bad 10、vacuous 0）、ratchet `results_unbilled`（baseline 14）、CI 3 step、回帰テスト +31（96 件）
- **Reasons**: (1) Claude Science が最も多くの誤りを見つけた条件は「文脈が無い」「再計算した」「所見を check にした」の三つで、どれも agent の tool scope と script で再現できる。(2) `verify_corrections.R` は `claude_science/` に閉じていて原稿の hook に無かった — 所見が永続する場所（`CLAIM_GUARDS.toml`）と、guard 自身の検査（`--mutation`、known_bad = git の修正前 commit）が要る。(3) patch without cascade と compression drop は「修正の後」にしか見つからないので、修正ごとに走る `/review-fix` が default でなければ再発する
- **Evidence / references**: `review_response/CLAIM_GUARDS_20261011.log`（15 guards、0 FAIL、0 vacuous）、`review_response/STRUCTURE_AUDIT_20261011.md`（本文 9,160 語 = 1.5×、Discussion L540 に数値 7、placement 0）、`review_response/EVIDENCE_COVERAGE_20261011.md`（unbilled 14、C-31 の evidence path が削除済みの表を指す）、`scripts/tests/run_tests.sh`（90 pass、6 fail は PyYAML / R のローカル環境）、`memory/project_referee_grade_environment.md`
- **Not done（意図的）**: `/referee` 本体の初回実行。設計中は原稿が origin/main との merge の途中だった。merge は別セッションが `6895793`（記録 `fad1010`、main）で完了し、3 つの機械的報告はその確定版に対して再実行済み（数値は同一）。冷読は Tak が `/referee all` を起動して行う（agent の起動は Tak の判断に委ねる）
- **Affected artifacts**: `RESEARCH_FRAMEWORK.md`、`memory/INDEX.md`、`.claude/settings.json`、`.claude/rules/paper-writing.md`、`.claude/agents/louis.md`、`scripts/check_all.sh`、`scripts/ci_ratchet.sh`、`.github/workflows/lab-checks.yml`、`scripts/tests/`（fixtures 7 本）
- **Status**: active

### D-20261011-10: 冷読 referee の初回実行（Major 5 / Minor 14、再計算 44 行不一致 0）— 方針を記録、適用は Tak

- **Date**: 2026-10-11 夜（22:40 起動、23:25 完了）  **Raised by**: Tak（「起動」）  **Decided by**: Harvey（方針）、Louis（guard 起票）、Donna（保存・突き合わせ）；**適用は Tak の段落レビュー**
- **What ran**: `/referee all` — `referee` agent（blind list 遵守: SUITS / CLAIMS / DECISIONS / review_response / memory を開けない）が `fad1010` の原稿を冷読し、base R 8 本（`review_response/referee/20261011/r01–r08`）で応用の全数値・Study 2 の 63 セル・Study 1 の全セル・prose の range を raw から再計算。**不一致 0**（Appendix B の code は Table 5 の第 1 ペアを bit 一致で再現）
- **Findings**: M1 「定数が W₁ の bound を区別する」は false as stated（L·W₂、L·(b−a)·D_KS が同じ定数）— 区別するのは attainment（KR）で、L* が「最小の slope」であるのもそのため／M2 「n ≥ 100」は単位なしの基準として transfer 不能（coverage は √n·W₁/σ）、l.476 の transfer は false、"near-nominal" は自分の MCSE 規則に反する（Louis C-09 と同一）／M3 W₁ vs KS の headline は Set 4 の KS saturation（構成上）を含み、13 cell 中 6 cell が未報告（全報告だと 11/13 で W₁ 有利）、順序は AUC 目標依存／M4 Table 5 の rank は中位で 10 位分ぶれる、null floor は片側 5% 検定／M5 protocol に載る RV・clustering・登録済み silhouette 結果・real-data survey が未報告（ADEMP）。Minor 14（l.273 の cell 誤り、bias decay の誤記述、conservative の scope、SBP grid と dual-solution、Song 2025 PREVENT の先行例、データ screening ほか）
- **Decision（方針）**: M1 直す（attainment 論証、6 箇所 cascade）／M2 直す + narrow（SD 単位、l.476 削除、near-nominal → 範囲、abstract に qualifier）／M3 直す（saturation 明記、13 cell 表、"at AUC 0.9"）／M4 null floor = 検定と名指すのは直す、rank interval か CI 順序かは Tak／M5 RV・clustering は Tak 09-27 決定どおり報告しないが**省略を一文で宣言**、登録済み 2 結果は Tak／Minor 8 は quantify-not-decide に抵触 → 却下候補。全文は `review_response/REFEREE_20261011.md` の `## Triage`
- **Guards**: 15 本を `CLAIM_GUARDS.toml` に `pending = true`・`known_bad = fad1010` で起票。`claim_guards.py` に `pending` 意味論を追加（OPEN として報告、strict は止めない、mutation は検査する）。修正後に PASS した guard から pending を外す
- **Reasons**: (1) 不一致 0 の再計算表は、数値の生成基盤（Option B、D-20261011-4）が機能している証拠。(2) M1 は 09-21 の Claude Science M1 の続き — 主張が exclusivity → constant → attainment と一段ずつ正確になる過程で、今の版は中間で止まっていた。(3) M2 の "near-nominal" は Louis（10-11）と referee が独立に当てた — Tak の判断を待っている C-09 を今決めるべき根拠。(4) M5 は Tak の決定（RV・clustering を外す）と矛盾しない — ADEMP が求めるのは報告か省略の宣言で、宣言で足りる
- **Evidence / references**: `review_response/REFEREE_20261011.md`、`review_response/referee/20261011/`（R 8 本 + txt + sessionInfo）、`review_response/CLAIM_GUARDS_20261011.log`、`STRUCTURE_AUDIT_20261011.md`、`EVIDENCE_COVERAGE_20261011.md`
- **Affected artifacts（予定）**: `paper/per_em_W1_wiley.tex`（abstract、§2.1–2.4、§3.1、§3.2、§4.2–4.4、§5）、`R/make_paper_tables.R`（13 cell 表）、`paper/numbers_registry.csv`、`CLAIMS.md` C-05/06/08/09/10、`LAB_STATUS.md`
- **Status**: active（Tak の判断待ち: M2 の C-09、M3 の表、M4 の rank、M5 の一文、Minor 8）

### D-20261011-11: 冷読 referee の Major 5 / Minor 14 に対する判断 — ラボが決める（Tak の包括指示「claude science を超える研究環境を用いて判断をして」）

- **Date**: 2026-10-11 23:40–23:55  **Raised by**: Tak（判断の委任）  **Decided by**: Harvey（方針）、Mike（数値・数学）、Rachel（文献・ADEMP）、Katrina（表・図・語数）、Louis（全件攻撃）、Jessica（Go）、Donna（原則との照合・記録）。**包括指示による決定** — 原稿への適用は段落ごとに `% Paragraph revised 2026-10-11 (D-20261011-11, referee M?)` を印し、D-20260927-1 と同じく **Tak の個別拒否権**を投稿前に閉じる
- **物差し（memory/）**: `feedback_quantify_not_decide`（判定規則を書かない）、`feedback_no_process_supplements`（supplement を作らない — 本文の数値で支えるか主張を削る）、`feedback_komiyama_no_overreading`（Ch.4 は一例の紹介、比較しない）、`feedback_tak_feedback_patterns` P1–P5、RESEARCH_FRAMEWORK S4（uncertainty always）・S8（exploratory ≠ confirmatory）・S12（数値は生成）
- **証拠**: `review_response/referee/20261011/r01–r08`（再計算、不一致 0）、`results/required_n_selection.csv`（13 cell すべてに `required_n_lower/upper`、Set 1 scale の W₁ は grid 下限 25 で区間 NA）、`results/real_data_survey_summary.csv`（13 行、Spearman(W₁, |SMD|) 0.839–0.996）、`STRUCTURE_AUDIT_20261011.md`（Simulation 1.8×、abstract 246/250）

#### 判断 1 — M2 / C-09: "near-nominal" を捨て、推定基準を SD 単位で言い直し、§4.2 の transfer を削る
- **Decision**: (a) "near-nominal"（l.385、Table 6 注 l.426、§5 ¶1 (iii) l.538）を **範囲 + MCSE の事実**に置き換える: 「0.92–0.95; five of the ten cells at n ≥ 100 lie more than two Monte Carlo SEs below 0.95」。(b) 推定基準を「n ≥ 100」から「**W₁ ≥ 0.4 SD of the reference distribution at n ≥ 100 (normal reference, equal n)**」に（l.241、l.567）。coverage は √n·W₁/σ の関数という一文を §3.2 Results に。(c) l.476 の「well above the n ≥ 100 … a separate question from the estimation criterion」を削除し、「null floor の解像と percentile 区間の coverage は同じ noncentrality √n_eff·W₁/σ が決める。null floor 内の距離は上限だけを読む（§4.4）」に置き換える。GUSTO の noncentrality（8 partner が 1.1–2.4）は `R/make_derived_numbers.R` に決定的に計算させ registry から引く（S12）。(d) abstract: 「For differences of at least 0.4 SD in normal-reference scenarios, bootstrap coverage was 0.92--0.95 from 100 patients per region.」（20 語；判断 2 の短縮と合わせて abstract ≤ 250 を Katrina が確認）
- **Reasons**: 自分の規則（l.391「2 MCSE 以内なら nominal と整合」）に反する語を残せない（P4）。Louis（10-11）と referee が**独立に**同じ所見 — 二人目が出た時点で保留を続ける理由が消える。「n ≥ 100」は単位なしでは transfer できず、§4.2 の文は referee の直接 simulation（0.39 年の shift で coverage 0.647）で偽と示された。推奨でなく **条件の記述**にするのは quantify-not-decide とも整合
- **Louis の攻撃**: 「0.4 SD という切りは S2（0.4σ、coverage 0.703 at n=50 / 0.904 at n=100）から事後に引いた線だ」→ **defuse**: 線でなく Study 2 の設計範囲の記述（S3–S7 の最小が 0.4σ）。「S3–S7 の範囲で」と書き、閾値として提示しない。Jessica: Go

#### 判断 2 — M3: 13 cell を全部報告し、Set 4 の KS 飽和を明記し、headline を「11 of 13 at AUC 0.9」に
- **Decision**: (a) `tab:study2_required_n_mc`（W₁ vs KS、MC 区間）を **13 cell** に拡張 — `R/make_paper_tables.R` の `cells` に Set 1（location / scale / combined）と Set 2（location / shape / combined）の 6 行を足す（生成、prose 語数に影響なし）。Table 1（W₁/KS/SMD、Sets 3–4）はそのまま。(b) §3.1.1 Design に一文: 「A subgroup of prevalence ε displaced by d changes the KS distance by at most about ε whatever d is, while W₁ changes by ε·d; in the Set 4 subgroup cells the sample-size advantage of W₁ therefore follows from the mechanism, and the bulk-shift cell is the control that removes it.」(c) §3.1.3 の headline と abstract を「at the AUC 0.9 target, W₁ needed fewer patients than the KS statistic in 11 of 13 cells, was not separated from it in one, and needed more in a uniform-shift control」に。「configurations built to challenge summary measures」→「the mixture and displaced-subgroup worlds (Sets 3 and 4)」。(d) l.273 の「weakest cell … 0.99」を Minor 1 どおり asymmetric severity の値（registry key を `aucKSSet4asymsevN2000` に新設）に直し、一文に圧縮。(e) 順序の目標依存（shape-symmetric は AUC 0.8 で KS 優位、0.95 で W₁ 優位）を §3.1.3 の脚注級の一文で開示。CLAIMS C-08 を再び広げる（evidence: 13 行の CSV）
- **Reasons**: 評価したのに表に無い 6 cell は「abstract の every configuration が未報告の cell に依っている」という referee の指摘そのもの（P5、ADEMP）。全報告の方が W₁ に有利でもあり、subset から headline を取ったという批判を根から消す。表の拡張は float なので語数の 1.8× に効かない（`structure_audit` は float を除外）。prose の増分 ≈ +40 語は l.273 の圧縮で相殺
- **Louis の攻撃**: 「11 of 13 のうち Set 1 scale は W₁ が grid 下限（25）で区間が無い — "fewer" と数えてよいのか」→ **defuse**: KS の下限 73 > 25 なので separated。表では「≤ 25」と印字し、注に「grid の下限で到達」と書く（生成器の `cellmc` に NA 分岐あり）。Jessica: Go

#### 判断 3 — M4: Rank 列は残す（Tak 09-27）が、不確かさを同じセルに載せ、null floor を検定と名指す
- **Decision**: (a) 新 single writer `R/gusto_rank_intervals.R`（各 region 内で患者を復元抽出、R8 は partner 間で共有、B = 1,000、seed 宣言、sessionInfo）→ `results/gusto_rank_intervals.csv`。Table 5 の Rank セルを「7 [1, 10]」の型に（生成）。null floor 内の同順位表記「1–6†」は維持。(b) 同 script で patient-level bootstrap の Spearman（age 順位 vs SBP 順位）区間を出し、§5 l.545 の Bonett–Wright 区間（15 partner を母集団からの標本とみなす — estimand が未定義、Minor 10）を **置き換える**。(c) §4.2 l.462–471 に「the null floor is the 95th percentile of the resampled null; declaring a distance unresolved is a one-sided test of F₁ = F₂ at level 0.05, used here only to mark which estimates are read at their upper limit (Section 4.4), not to decide pooling」。l.230 の estimation-centered の文は「the framework estimates distances; the null floor is the one place a test enters, and it governs display, not decision」に整合させる。(d) l.502 の R16 の例を、resampling で頑健な R2 / R9 の対比に差し替え — 既に l.505 で使っている対比なので本文に新しい数値は書かない（referee r05 の [12, 15] / [13, 15] は seed 5 の値。ラボの生成値（seed 20261011、`results/gusto_rank_intervals.csv`）は R2 age 14 [13, 15]、R9 SBP 15 [13, 15]；Spearman の patient bootstrap 区間は [−0.51, 0.02]、referee の [−0.52, 0.04] と MC 誤差内）。(e) 追加解析の由来（referee の指摘で加えた）を `results/GUSTO_APPLICATION_PROVENANCE.md` に prior-look として開示（S8）
- **Reasons**: 順位を点推定で示すのは S4（uncertainty always）に反する。Tak の 09-27 決定は「W₁ で順位付けする」で、「不確かさを隠す」ではない。CI 順序への置換は決定の反転になり、理由が「referee が言った」だけになる（S3 違反）。Bonett–Wright は論文が問っていない super-population を答えている
- **Louis の攻撃**: 「rank interval を足すのは referee に言われてからの事後解析。結果を見て足した」→ **defuse**: 結果の選択でなく既報の統計量の不確かさの量化。prior-look を provenance に書く。「Table 5 が 9 列になって幅を超える」→ Katrina: Rank セル内に区間を入れる（列は増えない）。Jessica: Go

#### 判断 4 — M5: 省略を一文で宣言、登録済み survey は一文で引く、silhouette 結果は宣言に含めて本文には出さない
- **Decision**: (a) §3.1.1 Design に一文: 「Under the registered protocol the simulation also evaluated three representative-value distances built from one to three regional moments, SMD on the log scale, a harm measure and a clustering task; these are not reported here because the paper compares distribution-level measures with the single-summary SMD and prescribes no grouping procedure (full outputs in the repository).」Komiyama を手法として名指さない（`feedback_komiyama_no_overreading`）。(b) §5 l.552 に一文: 「A pre-registered survey of 1,503 region pairs in GUSTO-I, IST-1 and IST-3 found rank correlations between W₁ and |SMD| of 0.84–1.00 across 13 trial-by-modifier combinations.」— 数値は `make_derived_numbers.R` が `real_data_survey_summary.csv` から min/max を出し registry で引く。(c) silhouette の登録結果（estimated-k clustering は Set 3 で基準不成立）は (a) の宣言に含まれる「clustering task」として開示され、本文では論じない
- **Reasons**: ADEMP が求めるのは「報告か、省略の宣言」— 宣言で足りる（Rachel）。RV・clustering を本文から外したのは Tak の 09-27 決定（D-20261011-8）で、referee は決定を覆す理由を示していない（決定の内容を知らないだけ）。survey は supplement でなく **本文の一文 + 数値**で支える — `feedback_no_process_supplements` の「本文の数値で支えるか、主張を削る」の前者。silhouette の負の結果は、論文が W₁ clustering や k の推定について主張していないので Discussion の論点（per-modifier の解像が要る）に効かない
- **Louis の攻撃**: 「Discussion に効く負の結果を『宣言』で済ますのは隠蔽だ」→ **defuse**: 宣言は task を名指し、protocol と CSV は repository で公開。論文の claim（C-02、C-18）は clustering の性能に触れていない。効くのは「W₁ clustering が使える」と書いた時で、書いていない。Jessica: Go — 「書いていない主張を守るために結果を出す必要はない。ただし宣言は task 名を全部書け」

#### 判断 5 — Minor 8: 却下（counts も 1 年 / 5 mmHg の等価も）
- **Decision**: Table 7 の above / contains / below の件数を本文に書かない。「W₁ CI を 1 年 / 5 mmHg と比べるのと等価」も書かない
- **Reasons**: 件数は「判定の提示」そのもので quantify-not-decide（Tak 09-25）に抵触。等価の読みは v6 で削除した τ_clin（= Δ_clin / L_UB）の再導入。referee は論文の原則を知らない
- **Louis の攻撃**: 「読者は結局 L_UB と比べて数える。書かないのは不親切」→ **defuse**: 比べるのは sponsor で、論文は L* の区間と L_UB の位置を表で示すだけ（l.518）。Jessica: Go

#### 残り（triage どおり確定）
- **M1 直す**（Harvey、D-20261011-10）: attainment の論証（τ* と |τ| ≤ 1 の条件、応用で L·(b−a) = 0.91 / 0.56 — `make_derived_numbers.R` で計算）。6 箇所 cascade。CLAIMS C-05/C-06
- **Minor 2**（Mike）: 一文 — 「a Wald interval from the Gaussian two-sample limit exists under the measure-zero condition; we use the percentile bootstrap because the condition is not verifiable from data and the limit's variance involves sgn(F₁ − F₂), which is unstable where the CDFs cross」
- **Minor 3・4・5・6・9・12・13・14 直す**: 文言（bias は n^{-1/2} で落ちる / S1 は定義不能、S2 は 24% / conservative は boundary 近傍に scope / Table 2 注の訂正 / l.538(i) に n を付ける / SBP = 0 の 6 例と age > 100 の 3 例は記録どおり retained と明記 / Fig. 3 に † / 投稿時に comment を strip）
- **Minor 7**（Mike）: A.2 に「the sample CDFs of Region 8 and each partner never coincide on a grid interval (0 of 15)」— 件数は verify script が出し ledger へ
- **Minor 11**（Rachel）: Song 2025 p.362 を原典で確認してから §1 l.73 を engage。未確認のまま書かない
- **Not verified**: Fang & Santos 2019（10.1093/restud/rdy049）、Lee 1995（10.1161/01.CIR.91.6.1659）を paper request

- **Affected artifacts（適用時）**: `paper/per_em_W1_wiley.tex`（abstract、§2.1–2.4、§3.1.1–3.1.3、§3.2、§4.2–4.4、§5 ¶1・¶3・¶5、A.2）、`R/make_paper_tables.R`（mc 表 13 行、Table 5 Rank セル）、`R/make_derived_numbers.R`（noncentrality、survey min/max、L·(b−a)）、新 `R/gusto_rank_intervals.R`、`paper/numbers_registry.csv`、`results/NUMBERS_LEDGER.csv`、`CLAIMS.md` C-05/06/08/09/10/35、`CLAIM_GUARDS.toml`（PASS した guard の pending を外す）
- **順序**: Mike（R 3 本・registry）→ Harvey（M1・M2・M3 の文）→ Katrina（表・図・compile・abstract ≤ 250）→ `/review-fix fad1010` → guards strict → `/claims check`
- **Applied（2026-10-12 00:10）**: 原稿 45 + 1 置換、段落マーカー 29 本（`% Paragraph revised 2026-10-11 (D-20261011-11, cold referee M?)`）；R: `R/gusto_rank_intervals.R`（新、B = 1,000、seed 20261011、再実行 byte 一致）、`make_derived_numbers.R` §7–9、`make_paper_tables.R`（MC 表 13 行、Table 5 Rank セル `rank [lo, hi]`）；registry +20 keys（152、R = Python check PASS、未使用 7 は旧 R16 例と旧 Bonett–Wright 区間）；ledger +4（Katrina 検証）；`verify_study1_app_numbers.R` に rank interval の照合 3 件を追加 → ALL PASS、`verify_study2_figures.R` ALL PASS；build 0 errors / 0 undefined / 21 pp / overfull 4（基準 9 から減）；`numbers_audit` 0 unsourced；`claim_guards --strict --mutation`: 30 guards 0 FAIL 0 vacuous（referee の 15 本は pending → strict に昇格）；`cascade_check fad1010 → working`: residue 0、qualifier drop 6・strengthened 3 は全件 Louis が意図的と判定（`review_response/FIX_REVIEW_20261011.md`）；`structure_audit`: 本文 9,937 語（+777、1.7×）、Discussion の数値段落 3（summary 段落 2 本 + survey 一文 — 結果の再掲と登録済み survey の 1 文、Harvey 判断で許容）；回帰テスト 97/97。CLAIMS: C-08 widened、C-09 narrowed、C-05/06 strengthened、C-35 evidence replaced、新 C-40〜C-43、C-31 の stale path を注記。
- **Status**: applied（2026-10-12）。Tak の拒否権は個別段落に対して投稿前まで開いている。Minor 11（Song 2025 原典確認）と Minor 13（Fig. 3 の †）は未適用 — Rachel / Katrina の次の仕事

### D-20261012-1: CI `r-and-tex.yml` の tex job から `continue-on-error` を外して blocking にする

- **Date**: 2026-10-12 00:45  **Raised by**: Donna（環境側 session、bg job 54fb22）  **Decided by**: Donna（環境側）；**記録と on-disk 検証**: Donna（本 session） — `.github/workflows/r-and-tex.yml` に `continue-on-error` の行が無いこと（grep 0 件、`git diff HEAD` で −2/+1 行）、生成器 2 本（`scripts/make_numbers_macros.R` +6/−1、`scripts/numbers_registry.py` ±1）の変更を確認
- **Question**: tex job は初回 green まで `continue-on-error: true`（D-20261011-1 の暫定措置）だった。いつ blocking にするか
- **Decision**: 今。`ce1cd18` / `6895793` / `fad1010` の 3 run で tex job は green。r job の赤は `numbers_macros.tex` のヘッダ 1 行の byte 差（Python 側が Windows の `\`、R 側が絶対パスを書いていた）で、両生成器を POSIX の project 相対パスに統一して解消
- **Reasons**: RESEARCH_FRAMEWORK S15「gate は CI で block する」。advisory のままでは LaTeX が壊れた原稿が merge できる。3 run 連続 green が「初回 green」の条件を満たす
- **Reversibility**: `continue-on-error: true` を 1 行戻せば元に戻る
- **Evidence / references**: `.github/workflows/r-and-tex.yml`、`scripts/make_numbers_macros.R`、`scripts/numbers_registry.py`、GitHub Actions の 3 run（commit `ce1cd18`、`6895793`、`fad1010`）、環境側 session の回帰テスト 113/113
- **Related（同 session）**: `PROTOCOL_study1_identification.md` の front matter に `code: R/selection_simulation.R` を追加（`protocol_compile.py --verify` が既定の `R/study1_identification.R` を探して DRIFT を出していた。post_hoc なので advisory だが、正しい script を指せば seed 20260711 と grid の照合が走る）。`.githooks/pre-commit` は置かれたが **未有効化**（`core.hooksPath` 未設定）— 有効化は Tak の `bash scripts/install_git_hooks.sh`
- **Status**: active

### D-20261012-2: 残差レビュー（Louis C4/M10/m18、Mike A1–A9、Rachel cite-check、Katrina）への判断 — ラボが決める（Tak の包括指示「レビュー → 推奨される方法を決定 → 修正」、D-20261011-11 と同じ委任の形）

- **Date**: 2026-10-12 10:35  **Raised by**: Tak（本日の指示）  **Decided by**: Harvey（方針）、Mike（数値・数学）、Rachel（原典）、Katrina（表・図・build）、Louis（攻撃）、Jessica（Go）、Donna（原則との照合・記録）。適用は段落ごとに `% Paragraph revised 2026-10-12 (D-20261012-2, Louis C?/M?/m? | Rachel | Mike A?)` を印し、**Tak の個別拒否権**は投稿前まで開いたまま
- **物差し**: `feedback_quantify_not_decide`、`feedback_no_process_supplements`、`feedback_komiyama_no_overreading`、`feedback_evidence_over_inference`（S21: 根拠を名指せない説明文を書かない — 今回の 4 Critical はすべて「修正に添えた説明文が CSV で検算されていなかった」型）、P1–P5、S4（uncertainty always）、S12（数値は生成）
- **証拠**: `review_response/INTERNAL_REVIEW_20261012.md`（C 4 / M 10 / m 18）、`VERIFY_RESIDUAL_20261012.md`（A1–A9）、`CITATION_AUDIT_20261012.md`（Song faithful、Matsushima NOT SUPPORTED）、`KATRINA_FIG3_TABLES_20261012.md`、`results/w1_raw_summary.csv`、`results/required_n_selection.csv`、`results/study1_miss_side.csv`、`results/gusto_rank_intervals.csv`

#### 判断 1 — Critical 4 件（CSV と矛盾する説明文）は全部直す
- **C1** l.503 "at the GUSTO-I region sizes both suffice" → 削除。required n は simulated contrast 固有で GUSTO に移せない（昨夜 M2 で coverage の transfer を削ったのと同じ理屈）。KS asym severity 1,252 [1,226, 1,278] は R16 の 1,231 を含む。W₁ を使う理由は attainment（class 内）と定数だけに
- **C2** l.400 "Coverage is governed by the true distance in units of the sampling SD" → 偽（n=100: S3 3.66 SD→0.951、S5 3.84→0.917、S7 4.15→0.935）。coverage を揃えるのは **bias / sd(Ŵ₁)**（S3 0.04、S6 0.11、S7 0.24、S5 0.38 の順 = coverage の順）で、bias は CDF が交差する scale contrast（S5–S7）で大きい。文を bias/SD の記述に置き換え（数値は `make_derived_numbers.R` → `study2_bias_over_sd.csv` → registry）。l.405 の「boundary を離れれば nominal」も削除（S7 は 0.58 SD で下側に外す）。l.497 は「どちらも標本サイズだけでは決まらない」に。**"0.4 SD" は設計範囲の記述としてのみ残す**（coverage を支配する量としては書かない）
- **C3** l.392 "same n^{-1/2} rate as elsewhere" → S1 だけが n^{-1/2}（比 1.96）、S2/S5/S6/S7 は 1/n に近く（5.7/4.4/3.4/3.3）、S3/S4 は n ≥ 100 で MC 誤差内。理論どおり（境界で非線形微分 → O(n^{-1/2})、内部で centred Gaussian → o(n^{-1/2})）
- **C4** l.297/266 "uniform shift は CDF supremum に最も向く" → Table 2 が反証（Set 1 location W₁ 33 vs KS 39、Set 2 location 129 vs 157）。**Louis の代替機構（裾の 10% が Var(Ŵ₁) を膨らませる）も検算していないので書かない**（S21）。事実だけ書く: Set 4 の control では KS が先に到達、Sets 1–2 の uniform shift では W₁ が先。control は Set 4 内の W₁ の機構的優位を外す cell であって、順序一般を反転させる cell ではない

#### 判断 2 — Major 10 件
- **M1** 判断1(a)（D-20261011-11）の適用漏れ: abstract・§3.2 末・§5 ¶1 (iii) に「10 cell 中 5 が 2 MCSE 超で 0.95 未満」を付ける（abstract は ≤ 250 語を維持、削る語は別の句）
- **M2** abstract と §4.3 の「11 of 13」に「うち 3 cell は構成上」を付ける
- **M3** attainment は KS bound も自分の class（TV ≤ V、step CATE at argmax|F₁−F₂|）で達成する — 区別するのは **class**（per-unit slope）。l.133・l.177 を「attained within the Lipschitz class」に、KS の attainment を括弧で明記。l.128/562/610 は連言なので維持
- **M4** A.2 の「0 of 15」は標本 CDF の件数で母集団の条件を言えない → 件数を削除し、「条件は標本から検証できない；null floor 内の R2 (SBP) は F₁=F₂ が除外されず区間は上限だけを読む」に。昨夜の Minor 7 の判断を**覆す**（理由: 検出力ゼロの検査を根拠に見せていた）
- **M5** Spearman −0.30 は unresolved を含む点順序で計算 → **開示**で解く（再計算は null floor を replicate ごとに要し、表示規則の変更になる）。l.578 の W₁ vs SMD の Spearman（0.90/0.95）には **患者 bootstrap 区間を付ける**（S4；`gusto_rank_intervals.R` を拡張、Mike が producer、Katrina が verifier）
- **M6** IST-1/IST-3 に \cite、survey の相関は 3 桁（0.839–0.996）、protocol 名を本文に、Data availability に IST の入手先（**ディスクに記録があるものだけ**）
- **M7** l.607 の「Lasso が EM 選択の front-end」→ 削除（outcome Lasso は prognostic 因子を選ぶ、l.231 と矛盾；Komiyama の Lasso は距離の重み）。「treatment-by-covariate interaction の証拠が要る」に
- **M8 + m17** §5 ¶1 の (i)(ii)(iii) を §2.1 の要請に揃え、(iii) coverage は「推定の特性づけ」として番号から外す。95 語の一文を分割
- **M9** "estimation criterion"（4 箇所）を廃止 → n = 50–200 の記述文に（quantify-not-decide）
- **M10 + Table 統合** Table 1 を Table 2 に畳む（13 cell × W₁/KS/SMD、MC 区間、\footnotesize）。SMD が blind でない cell の結果を本文に一文（location cell は同程度か SMD が先、combined cell は W₁ が大きく先 — 数値は registry）。1 float 減

#### 判断 3 — Rachel の cite-check
- **Matsushima（NOT SUPPORTED）**: §1 の文を原典どおりに書き直す — PREVENT の事後併合（EM 分布の類似で 5 pooled regions）、日本の不整合は割付不均衡と小標本によるもので EM によらない。例の役割は「EM 分布で併合地域を作った実例だが、その測り方は示されていない」に変わる（論文の gap とむしろ整合）
- **Song**: faithful。「more than one EM のとき」の限定を一語足す。novelty claim は維持（"to our knowledge" のまま。Matsushima Data S1 は Paper Request）
- **FTT**: "irrespective of age and blood pressure" に「ST 上昇または BBB の患者で」を付ける（l.463）
- **bib**: Otsubo / Matsuoka を訂正

#### 判断 4 — Minor（採用: m1, m2, m3, m4, m5, m6, m7(cut), m8, m9, m10, m11(段落ごと cut), m12, m13, m14（E17 の語として引用符を残す）；保留: m15（abstract 語数、Methods の開示で S8 は満たす）、m16（`gusto_operability.csv` の旧列は code 公開準備で、既に LAB_STATUS の次の仕事））
- **m2**: "at least 0.4 SD" は S5 の 0.399 を切り上げ → "about 0.4 SD or more"（設計範囲の記述）

#### 判断 5 — 長さ（P3、主張を落とさない箇所だけ）
- 切る: l.323 段落（C-30、「clinical superiority の独立証拠ではない」と自ら言う）、l.440–445 のまとめリスト（数値の反復）、l.392 の S4 文、l.339 第 2 文、l.275 の一文、l.497 冒頭、Table 5 注の CI-overlap 2 文、l.578 冒頭の §2.1 反復（1 句に）、l.585 の経路の反復（separability だけ残す）、l.604 の KS 代替文（§2.2 末と重複）、l.463 の反復
- 残す: l.281 末文（「SD を足せば」は査読者の最初の質問への先回り）
- **Louis の攻撃**: 「C4 の代替機構を書かないのは腰砕けだ」→ **defuse**: 検算していない説明文で今日 4 件落ちた。機構は `/explore` で確かめてから（IDEAS_BACKLOG に登録）。Jessica: Go — 「説明は証拠の後。今日はその順序を守れ」
- **Affected artifacts**: `paper/per_em_W1_wiley.tex`（abstract、§1、§2.1–2.4、§3 冒頭、§3.1.1–3.1.3、§3.2、§4.2–4.4、§5、A.2、Data availability）、`R/make_paper_tables.R`（表統合）、`R/make_derived_numbers.R`（bias/SD、比）、`R/gusto_rank_intervals.R`（W₁ vs |SMD| の bootstrap）、`paper/numbers_registry.csv`（+約 20 keys、survey を 3 桁）、`paper/per_em_W1_wiley.bib`、`CLAIM_GUARDS.toml`（LR2-* 11 本、pending → strict）、`CLAIMS.md`（C-30 withdrawn、C-16/C-32/C-37 更新）
- **順序**: snapshot known_bad（済） → guards 起票（済、11 OPEN） → Mike（R・registry）‖ Katrina（表統合・bib）‖ Harvey（原稿） → build → `numbers_registry.py check` → guards strict → `/review-fix`（cascade） → verify gates → SUITS / LAB_STATUS
- **Review-fix（Louis、11:18、`review_response/FIX_REVIEW_LOUIS_20261012.md`、Critical 3 / Major 10 / Minor 9）→ 適用 11:35**: (K1/K2) Harvey の改訂マーカー 2 行（§4.1 FTT、§5 ¶3）が段落末に置かれ後続の本文を飲み込み、"We therefore treat L_clinical as unknown …" と "the interval excludes the strong positive agreement … remain clinical judgments" が PDF から消えていた — 行を分離して復元、pdftotext で確認。cascade_check の "(deleted)" 行を決定済みの cut と照合しなかったのが原因（手順に追加）。(K3) Louis の paste-ready 文 "bias/SD orders the cells by coverage" は 3 cell でしか成立しない（S4 は bias/SD −0.01 で coverage 0.945 < S3）→ 「最低 3 cell が最大 3 cell」に限定、S4 は 5 cell の一つ。(M1) S4 "stable … confirming satisfactory" → 0.942–0.948、2 MCSE 内は n = 200 のみ。(M2) "where the CDFs cross … conservative" → S2/S5/S7 に限定（S6 は上側 2.6% で nominal）。"0.4 SD or more" → "0.4 to 1.2 SD"（設計範囲、`maxW1SdS3toS7` 新設）。bias 文は S3 を含め「S4 以外は n=200 で 1/3 以下」。SMD 文は Set 4 の 2 cell を明記。survey は "registered after an exploratory scan"、pooled SD の定義差を明記、GUSTO 5 行を明記。IST は "trial databases … under its data use agreement"。E17 の "leaves to sponsors and regulators" を撤回。Song/Matsushima "expect demonstration" → "examine the consistency"。del Barrio の条件、Fang の "applying"、Sommerfeld の "maximum over dual solutions" を明記。**教訓（memory `feedback_fix_explanations_checked`）**: 修正に添える説明文は Louis のものも含めて CSV で検算してから採用する；マーカーは独立行；適用後に PDF を grep する
- **最終ゲート（11:40）**: build 0/0/21 pp（飲み込まれていた本文の復元で 20 → 21）、guards 41 strict 0 FAIL 0 vacuous、abstract 250/250、unsourced 0（121 tokens）、cascade residue 0、verify 134/0・63/0、四つ目の目 23 keys 一致。本文 9,923 語（9,937 から実質不変 — 削減 ≈ 訂正で足した分）
- **Status**: applied（2026-10-12 11:40）。Tak の拒否権は `% Paragraph revised 2026-10-12 (D-20261012-2 …)` の段落に対して投稿前まで開いている

### D-20261012-3: 外部レビュー（Tak 経由、16:07、Major 8 / Minor 6 / 体裁 5）と冷読 referee 第 2 回（16:46、Major 5 / Minor 12）への判断 — ラボが決める（Tak「原稿を改訂」）

- **Date**: 2026-10-12 17:00  **Raised by**: Tak（外部レビューの貼り付け）  **Decided by**: Harvey（方針）、Mike（数値・数学・R）、Rachel（原典 9 本 + 3 本）、Katrina（表・図・build・長さ）、Louis（レビューへの攻撃 `EXTERNAL_REVIEW_ATTACK_20261012.md`）、Jessica（Go）、Donna（原則との照合・記録）。適用は段落ごとに `% Paragraph revised 2026-10-12 (D-20261012-3, EXT M?/REF M?)` を印し、Tak の個別拒否権は投稿前まで開いたまま
- **物差し**: `feedback_quantify_not_decide`（判定規則を書かない）、`project_no_effect_tracking_sim`（θ を置く効果追跡 sim はやらない — ただし断る理由は「原則」でなく科学的に書く: θ を固定すると勝者が θ の選択で決まる）、`feedback_evidence_over_inference`（機構は protocol と single writer を通してから書く）、`feedback_no_process_supplements`、S4・S8・S12
- **証拠**: `review_response/EXTERNAL_REVIEW_20261012.md`、`review_response/referee/20261012/REFEREE_20261012.md`（再計算 44 行不一致 0、`ref_*.R/.log`）、`EXTERNAL_REVIEW_ATTACK_20261012.md`（Louis）、`LIT_POSITIONING_20261012.md`（Rachel、9 本の DOI と原文）、`exploratory/set4_control_mechanism/`（Mike、Supported）、`VERIFY_FOUREYES_20261012.md`

#### A. 断る 3 件（科学的理由を response に書く）
- **EXT M3 Study 3**（CATE を線形・二次・閾値で置き、真の効果差との順位一致と bound の保守性を測る）: **断る**。θ を固定した順位一致は θ の選択で勝者が決まる — 線形なら |Δμ| の尺度、step なら |F₁(c)−F₂(c)|、τ* なら W₁ — ので、どの θ を置いても「その θ に最適な物差し」が勝つだけで、物差しの一般的性質を測れない。論文の bound は Lipschitz class 全体の worst case で、特定 θ の下での保守性はその設計どおりに大きい（単調 class では L(W₁+|Δμ|)/2 まで締まることを本文に明記する — referee M1）。ただし reviewer の線形 CATE の指摘は正しく、§3 冒頭に「線形ならスケール差は効果差 0、V 字 τ = L|x−50| なら S5 で L·W₁ を attain し SMD は 0」を書く。CvM / AD / energy の追加は protocol amendment が要る → `/idea`（I-20261012-3）
- **EXT M5 同等性検定の決定規則**: **断る**。「Ŵ_{1,U} < Δ_clin/L_UB で棄却」は Table 9 の「L* 区間全体が L_UB より上」と同じ事象で、既に全 pair を表示している。size は L_clinical ≤ L_UB という臨床入力を条件にしないと定義できず、論文はそれを規定しない。動作特性は片側上限の coverage として報告する（M4(d) を採用）。permutation null と多重性の一文は採用
- **EXT M7(a)(b) GUSTO アウトカムで L を推定・標準化推定との比較**: **(b) 断る**（GUSTO の τ̂ は t-PA vs SK の対比で Drug T の τ ではない；計画段階で τ が無いという論文の前提に反する）。**(a) 一部採用**: L_UB,age が全体効果（GUSTO-I 30 日死亡 6.3% vs 7.3%）より一桁大きいことを明記し、L* の報告で任意の小さい bound と比較できることを書く；0.006/yr の出典（ディスクに無い、Louis Extra-1）は Lee 1995 の abstract の数値（1.1% < 45 歳、20.5% > 75 歳、30 年以上で ≤ 6.5 × 10⁻³/yr）に置き換え、ledger に行を足す。**(c) 採用**（Mike B の single writer で SBP = 0 / age > 100 除外・winsorize・digit preference を計算し一文）

#### B. 採用（数値を伴わないもの — 17:00 から適用）
- **REF M1 / EXT M1 attainment の循環**: W₁ 採用の理由を「attainment」から外す。採用理由 = (i) 位置以外に応答、(ii) bound の定数が per-unit 臨床勾配、(iii) 勾配だけを制約にしたときの sharp bound（KR）で、形の制約が入れば締まる保守的上界。§2.2 に **単調 CATE の sharp bound L(W₁+|Δμ|)/2** を導出付きで置き、bounded-effect の制約でさらに締まることを書く（referee の導出を Mike/Louis が検算: A₊+A₋ = W₁、A₊−A₋ = μ₁−μ₂ ✓）。GUSTO での比（age 0.66–1.00、SBP 0.72–1.00）は `make_derived_numbers.R` → registry。§2.1・§4.3・§5 ¶1・結語の「attained」を cascade。KS bound との技術的比較は Appendix A.3 へ（EXT Minor 5 + 長さ）。CLAIMS C-05/C-16 を narrow
- **EXT M1 先行研究**: §1 に位置づけ段落 — Prop. 1 は KR 双対の系で、同じ不等式は OT domain adaptation（Shen 2018 式 (13)、Redko 2017 Lemma 1）にある；generalizability / transportability（Stuart 2011、Tipton 2014、Dahabreh 2020）は試験標本と目標集団の共変量差を propensity に基づく指標で測る；Wasserstein 近傍での類似の同等性検定（Munk & Czado 1998）。新規性 = MRCT pooling への定式化、L* の逆算、推定特性の評価。Álvarez-Esteban 2008 は原文・abstract とも未読のため引かない（Paper Request）
- **EXT M2 / REF Minor 8 可縮性**: §2 冒頭に「式 (1) と Prop. 1 は可縮な対比（リスク差・平均差・RMST 差）に限る；周辺 OR / HR は条件付きの平均でない」を 2 文。限界にも 1 文
- **EXT M4(a) Jensen**: §2.3 に E Ŵ₁ ≥ W₁（∀ n、各点の Jensen + Tonelli、非負なので可積分性の条件不要 — Louis 検算）を命題として明記。§3.2 の "well-known phenomenon" をこれに差し替え。percentile 区間が bias を補正しないことを明記
- **EXT M4(d)・M4(c)**: 片側 97.5% 上限の coverage と basic 区間の coverage を 21 cell で新表に（Mike B、rds から再計算、新規 sim なし）。m-out-of-n（Bickel–Götze–van Zwet 1997）と numerical delta method（Hong & Li 2018）を境界での正当な方法として限界に 1 文（走らせない；BCa は C-34 の retract 履歴があるため走らせるなら prior look の開示が先）
- **EXT M6 多変量**: 限界に 2 文 — 重み付き ℓ₁ cost の W_d は交互作用があっても bound を与え、Σ_k L_k W₁^(k) ≤ W_d（任意の coupling）なので周辺の和は下界。GUSTO の W_d 計算は `/idea`（I-20261012-4）
- **REF M4 / EXT M3 Study 1 の役割**: §3 冒頭を「identification（検出できるか）であり、全部異なる partner の順序付けや効果差による順位は評価していない」と明記（oracle k も）。Discussion ¶1 (i) は identification の主張のまま
- **REF M3 coverage の説明**: 「CDF 交差で集中」を「S5・S7 は上側に外れ（bias/SD 最大）、S6 と S4-100 は小さく両側」に。Table 4 注の "boundary proximity (S5)" と限界の "small distances (S2, S5)" を訂正。bias/SD の順序は 3 cell に限定（11:00 の訂正を維持）
- **REF M2 / EXT 裾の機構**: Mike の exploratory と referee の `ref_tailweight` が独立に一致 → **protocol に昇格して本番**（`PROTOCOL_set4_control_mechanism.md`、prior look 開示、n_sim 4,000）。数値は registry 経由で §3.1.3 と §5 に: Set 4 の母集団では Ŵ₁ の null SD が Gaussian の約 1.5 倍、KS は不変、paired ΔAUC の符号が反転。"rather than reversing the order in general" を削除、abstract の "uniform-shift control" を "heavy-tailed location-shift control" に。survey の W₁–KS 順位相関（0.88–0.99）を §5 に（効率の tally を主理由から外す）
- **REF M5 / EXT M8 Study 2 の範囲**: `PROTOCOL_study2_extension.md`（Mike C、実行中）: 不均衡 n、t₃、整数格子、n = 1,000、**応用の operating point**（0.2 SD で n = 1,000、n₁ = 2,900 / n₂ = 1,200 を 10 mmHg 丸め）。結果は新表（生成）と abstract の限定句（応用の距離 0.03–0.30 SD は Study 2 の元の範囲外で、拡張 cell が担う）
- **REF Minor**: 1 caption 修正；2 "rises monotonically" → "reaches the target and stays above it"；3 Wald の理由（同じ条件が bootstrap にも効く；違いは分散推定の要否）；4 permutation（Mike B の一致数で一文）+ 多重性の一文；5 † 行に rank interval を印字（Katrina 生成器）；6 Set 4 error rate に by-construction の限定；7 "displaced-subgroup" を prevalence cell を含む表現に；9 heaping（Mike B の数値で一文）；10 bootstrap MC error（Mike B）；11 Data availability に抽出手順；12 abstract に "number to retain supplied"
- **EXT Minor**: 1 採用（enrolled sample では bound が F̂ で厳密に成立、1 文）；2 採用（有界な台）；3 SI は断る（Tak 09-27）、省略の宣言に threshold study と L_UB 感度（旧 eligibility 規則のもの）を加える；4 abstract を書き直し（tally を機構の限定句付きに）；5 採用（A.3）；6 "show no positive agreement"
- **体裁**: 全部直す（caption、IST-1 の連結、del Barrio / van Klaveren の braces、IST title 19,435、copyyear 2026 / pages 1–21、R code の二重評価、Data availability）
- **長さ**: Katrina の `LENGTH_PLAN_20261012.md`（待ち）の安全な cut を適用。今日の追加（位置づけ・単調 bound・可縮性・新表 2）で増える分を相殺する

#### C. 断る理由の記録（response letter の素）
- Study 3 と決定規則は上記 A。「KR 双対で W₁ が定義上最適だから循環」という言い方はしない（それが成り立つのは unrestricted class の sup だけ — Louis）
- **Louis の攻撃**: 「M3 を断るなら、線形 CATE の下で SMD が正しい挙動だという指摘にも答えろ」→ V 字の例で答える（上記）。Jessica: Go — 「断る 3 件は、reviewer が間違っているからではなく、別の論文だからだと書け」
- **Affected artifacts**: 原稿（abstract、§1、§2 冒頭、§2.1–2.4、§3 冒頭、§3.1.1–3.1.3、§3.2、§4.2–4.4、§5、A.2、新 A.3、Data availability、R code）、bib（+8 entries、訂正 3）、`R/make_derived_numbers.R`（単調比、Set 4 機構、survey W₁–KS）、新 single writer 4 本（interval variants、outlier sensitivity、permutation null floor、Set 4 mechanism production）、`PROTOCOL_study2_extension.md`、`PROTOCOL_set4_control_mechanism.md`、`R/make_paper_tables.R`（新表 2 本、Table 8 の † 行）、registry、ledger（Lee 1995 abstract、GUSTO 1993 abstract）、`CLAIM_GUARDS.toml`（referee の guard 9 本 + 外部 3 本）、`CLAIMS.md`、`IDEAS_BACKLOG.md`（I-20261012-3 CvM/AD/energy、I-20261012-4 W_d、I-20261012-5 equivalence framing）
- **Status**: applied（2026-10-13 00:55 — batch 1・2a・2b・3a・3b、Katrina の cut 18 件と生成器 3 本、Mike の single writer 5 本（interval variants、outliers、permutation、Set 4 mechanism、Study 2 extension）、registry 235 keys；全ゲート PASS；残: ARS integrity / re-review、応答表、Katrina の 16 key の四つ目の目、m7 の IST database 引用）
- **Correction（2026-10-13 00:50、Louis round 3 m8）**: 上の A「GUSTO-I 30 日死亡 6.3% vs 7.3%」は誤り。原典 abstract（PMID 8204123）は accelerated t-PA 6.3%、SK + 皮下 heparin 7.2%、SK + 静注 heparin 7.4%。原稿は 6.3 vs 7.2/7.4 で正しい。7.3 はどの群の値でもない（Rachel、ledger 行は INFERRED 印）
- **Louis `/review-fix` round 3（`FIX_REVIEW_LOUIS_20261012_round3.md`、Critical 3 / Major 15 / Minor 9）→ 適用 2026-10-13 00:50**: C1 S6 は CDF が交差し bias 11 MCSE（S4 と一括りにしない）；C2 上限 coverage は S5/S7 で名目超、S3/S6 で名目付近、S4-100 で名目未満；C3 basic 区間は n ≥ 100 で劣り境界（S1、S2-50）で勝つ — 「境界の coverage と交換」；M1 マーカーの飲み込み 2 箇所（§3.1.3、§3.2）を復元；M2 機構文を protocol §2 の範囲に（因果動詞と class への一般化を削除、prior look を本文に）；M3 "light-tailed" 撤回（Set 2 は対数正規）；M4 Table 4 注と限界の S5 を「bias/SD が大きい」に統一；M5–M7・m9 abstract（normal reference、risk or mean differences、control に限定、in original units）；M8 "sharp for the class" を見出しから外し「valid for every CATE in the class, sharp when the slope is the only restriction, conservative for any particular CATE」に；M9 lipRange の文を Lee 1995 の最大死亡率 20.5% と比較する形に；M10 winsorize の順位変化 4 と post hoc を本文に、除外の上限は "to two decimals"；M11 heaping は "may contribute (not quantified)"；M13 位置づけ段落の "in its own units" と "originate" を撤回；M14 CLAIMS C-16/C-49；M15 guard REF-M1 の 2 本を書き換え（理由: 旧 stem が「定数を言う文は attain/sharp を言え」を強制し、referee #2 が退けた wording を生んだ）、REF2/EXT の pending を外し、G1–G6 を起票；m1–m6 文言。**M12（Study 2 拡張の表と一文、GUSTO の距離 0.03–0.30 SD）は Katrina の key 待ち（batch 3b）**。m7（IST database 論文 Sandercock 2011 の引用）は Rachel の `/ground` 後
- **ARS pipeline（Tak の `/ars-full`、mid-entry、2026-10-13 00:50–01:52）**: Stage 2.5 `integrity_verification_agent` → **PASS WITH NOTES**（`review_response/ARS_INTEGRITY_20261013.md`: 引用 35/35 VERIFIED、DOI 全解決、chain 21/21、生成表 275 セル一致、7-mode CLEAR；Minor 9 のうち bib 3 件と §1 の一文を適用）。Stage 3′ `academic-paper-reviewer re-review` → **Minor Revision**（`ARS_REREVIEW_20261013.md`: 外部 addressed 10 / partial 7 / declined 2、referee #2 addressed 15 / partial 1 / not done 1；新規 13 件のうち 7 件を適用 — cvol 1–23、abstract の operating point を E6–E5、"we report the loss"、Supporting information、Wald の "unstable"、拡張 protocol の時系列、L_UB の出典から GUSTO subgroup を除外）。Stage 4 の応答表 `RESPONSE_TRACKER_20261012.md`（Harvey）。**次の周**: 長さ（11,097 語、1.8×）、bootstrap 端点の MC 誤差（single writer）、M7(a) L_UB の根拠、拡張表の cosmetic、Álvarez-Esteban 2008 の原典
- **Status**: applied（2026-10-13 02:00）

### D-20261014-1: 本文の削減 — 11,097 語（1.8×）→ ≤ 9,000 語、主張を一つも落とさずに（Tak「本文を削減して」）

- **Date**: 2026-10-14 00:25  **Raised by**: Tak  **Decided by**: Harvey（方針と節ごとの上限）、Katrina（実測して適用）、Louis（diff の review-fix）、Donna（CLAIMS の担い手照合）、Jessica（Go）
- **Question**: 10-12 の三周で本文が 9,937 → 11,097 語に増えた。どこを、どの規則で切るか
- **Decision**: 節ごとの上限 — Intro ≤ 950、Methods ≤ 2,500、Simulation ≤ 2,300、Application ≤ 1,300、Discussion ≤ 1,300（計 ≤ 9,000）。規則: (1) CLAIMS の行の唯一の担い手は切らない、(2) 10-12/13 の訂正文は切らない（数値・限定句・引用が全部残る圧縮のみ可）、(3) Tak 承認段落は純削除のみ、新文言は `% Cut 2026-10-14 (D-20261014-1, needs Tak's veto)` を付けて拒否権に、(4) guard が依存する key・1 回しか出ない \cite・abstract・省略宣言・protocol 文・Data availability は維持。手段: Tables 3–5 を 1 表 `tab:estimation` に統合（生成器 1 本）、LENGTH_PLAN の B/C/D 層と A*r、§2.2 の KS 文と台の注意を A.3 へ、§3.1.1 の Set 記述の圧縮、§3.2 の bias/precision 段落の表への依存、§4 の R6 例を一文に、§5 の反復、§1 の背景の圧縮
- **Reasons**: 長さは referee #2・外部レビュー・ARS re-review の三者が指摘。切る対象は反復と説明であって主張ではない — 10-12 に足したものは全部「誤りの訂正」か「reviewer が求めた証拠」で、落とせば同じ指摘が戻る
- **Reversibility**: 全 cut に marker。`review_response/known_bad/` に切る前の原稿を snapshot
- **Applied（2026-10-14 01:40）**: Phase 1（規則内 67 cuts、−1,279）+ Phase 2（Menu 7 件、−357）+ Louis `/review-fix`（`FIX_REVIEW_LOUIS_20261014_cut.md`、Major 9 / Minor 13）の復元（M12 の一句、D01 の数値付き一文、EM 選択の射程、log-scale SMD の括弧、amendment cell の正確化、壊れた文、Harvey 自身の marker 飲み込み 1 件）→ **9,617 語**（1.6×）。9,000 は未達 — 残りは主張の担い手と reviewer が求めた証拠。拒否権項目 15。Tables 3–5 → `tab:estimation`。全ゲート PASS（21 pp）。記録: `review_response/LENGTH_CUT_20261014.md`
- **Status**: applied（2026-10-14 01:40）
