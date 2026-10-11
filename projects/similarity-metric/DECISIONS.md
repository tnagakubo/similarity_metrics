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
