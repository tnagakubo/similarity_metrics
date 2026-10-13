# RESEARCH_FRAMEWORK — 科学研究 → 論文執筆の lifecycle（SUITS 実装）

> *"I don't have dreams, I have goals."* — 研究を 10 の Phase と gate に分け、各 gate を Claude Code の機構で機械化する。
> State は `projects/{project}/LAB_STATUS.md`、記録は `SUITS.md`、操作は `/phase`。
> 作成: 2026-09-21。改訂: 2026-10-10（科学的妥当性の機構 — §6–§8）、**2026-10-11（Option B: 生成 pipeline・protocol compiler・replication・CI — §9）**、**2026-10-11 夜（referee-grade environment — §10、S16–S20）**。CLAUDE.md（Rule 1–6）を上書きしない。CLAUDE.md が「何を守るか」、本書は「どの順で・何を証拠に進めるか」。

---

## 1. Lifecycle（10 Phase）

| # | Phase | Owner（支援） | 主要 artifact（on disk） | Gate（抜ける条件） | 使う skill / 機構 |
|---|---|---|---|---|---|
| 0 | **Question** 問い | Harvey（Jessica） | `EXISTING_METHODS_AND_NOVELTY.md`、`DECISIONS.md` D-…-1（claim と「なぜ今」）、`CLAIMS.md` 1 行目 | 1 文の claim と「なぜ今この論文か」に Jessica が Go。estimand の候補が数式で書ける | `/start`, `/decide`, `/meeting`, `agents/jessica` |
| 1 | **Literature** 文献 | Rachel | `knowledge/INDEX.md`、`summaries/`（verbatim passages + "does not say"）、`LITERATURE_SEARCH_LOG.md` | 主要文献が KB に処理済み・全 DOI・gap が 1 段落で書け、**反証条件**が書ける | `/process-paper(s)`, `/search-kb`, `/request-paper`, PubMed MCP |
| 2 | **Protocol** 設計 | Mike（Louis） | `PROTOCOL_{study}.md`（§0 honesty clause / claim / licenses / **ADEMP** / **MCSE と n_sim** / seed・環境 / Louis 攻撃 / 出力 / Go / 逸脱） | protocol が **commit** 済み、Louis の攻撃に回答、Jessica Go。θ 特定・循環設計なし | `/protocol`, `/defend`, hook `pre-run-protocol-check.sh` |
| 3 | **Implementation** 実装・検証 | Mike（Katrina） | `R/`、出力 CSV（estimate + MCSE）、`sessionInfo` / `renv.lock`、`*_PROVENANCE.md`、`results/REPRODUCTION_*.md` | `check_r_reproducibility.sh` ❌ 0、clean checkout 再実行が許容差内（`/reproduce` PASS）、数値の traceability | `/reproduce`, `/verify-numbers`, rules `r-code.md`, hooks numbers / r-repro |
| 4 | **Results** 結果 | Katrina | `SIMULATION_FINDINGS_{study}.md`（MCSE 付き、licenses / しない、探索的所見を分離）、figures、tables（CSV 生成） | 図規格・caption 規則、evidence → `CLAIMS.md` の該当行が supported、four-eyes 検証表 | rules `r-code.md`、`/verify-numbers`, `/claims check` |
| 5 | **Writing** 執筆 | Harvey / Mike / Katrina | `.tex`、`CLAIMS.md`（全主張）、`PAPER_LOGIC.md`、段落台帳 | 各段落 Tak OK（P1–P5 + S）。`/claims check` PASS。本体→Discussion→Terminal の順 | 段落レビュー（`templates/review_checklist.md`）、rules `paper-writing.md`、Option A/B/C、`/claims` |
| 6 | **Internal review** 内部審査 | Louis（全員） | `review_response/PRE_REVIEW_*.md`、`INTERNAL_REVIEW_*.md`、external review 報告 | `/pre-review` → `/review` → `/external-review` の Critical/Major 全件に方針（直す / 反論 / narrow）。Jessica 承認 | `/pre-review`, `/review`, `/external-review`, `/simulate-qa`, `/defend` |
| 7 | **Submission prep** 投稿準備 | Katrina（Rachel, Mike） | `paper/submission/SUBMISSION_CHECK_*.md`、`CITATION_AUDIT_*.md`、abstract ≤ 250 words | `templates/reporting_checklist.md` R1–R8 全 ✅（claims / ADEMP+MCSE / 不確かさ / numbers ledger / citations / reproduction / 図表 / 記録）、Jessica 承認、`/handoff` | `/submission-check`, `/verify-numbers`, `/cite-check`, `/claims check`, `/handoff` |
| 8 | **Revision** 査読応答 | Harvey（Donna） | `review_response/RESPONSE_TRACKER.md`、`RESPONSE_LETTER.md` | 全 comment closed（各変更は段落レビュー済み、新しい claim は `CLAIMS.md` 経由）→ Phase 7 へ戻る | `/respond-reviewers`, `/decide`, ARS `/ars-revision-coach`（素材） |
| 9 | **Closeout** 完了 | Donna（Harvey） | `memory/` の principles 更新、`archives/`、`IDEAS_BACKLOG.md`、`DECISIONS.md` の lessons | Lessons が versioned memory に入り、次の Question が backlog にある | `/victory`, `/archive`, `/handoff` |

**遷移規則**
- 前進は `/phase next` のみ。Donna が各 gate を **on-disk evidence** で検証（語られただけは ❌）。`scripts/check_consistency.sh` を先に走らせる
- 後退は自由（Phase 8 → 7、Phase 6 → 5 など）。理由を LAB_STATUS の history と `DECISIONS.md` に書く
- Phase 2→3（protocol Go）、6→7、7→投稿は Jessica の承認が必須。Louis は全 gate で一件以上の risk を述べる
- Phase 5 と 8 の原稿変更は **必ず段落レビュー**（Tak OK）。`@bg` 不可。包括指示で適用した段落は `DECISIONS.md` に指示の日時を残し、投稿前に Tak の拒否権期間を閉じる

---

## 2. 各 Phase の作業原則（versioned memory の集約 — `memory/INDEX.md`）

| Phase | 原則 | 出典（repo 版） |
|---|---|---|
| 0–2 | 選択肢 → 選択 → 理由。いきなり結論を出さない | `memory/feedback_tak_feedback_patterns.md` |
| 2 | θ を置く効果追跡 sim はしない（一般性を破壊、KR 双対の循環） | `memory/project_no_effect_tracking_sim.md` |
| 2, 5 | 小宮山 Ch.4 = 1 EM 1 代表値。RV2/RV3 は我々の拡張。原典 verbatim で引く | `memory/feedback_komiyama_no_overreading.md` |
| 2–5 | 論文は違いを定量化するだけ。判定規則・閾値・手続きは規定しない | `memory/feedback_quantify_not_decide.md` |
| 3, 4, 7 | 計算後は必ず再検証。producer ≠ verifier。ledger に結ぶ | `memory/feedback_calculation_verification.md` |
| 4 | 図: 7"・base 11・greyscale。caption は「何がプロットされているか」のみ | `.claude/rules/r-code.md` |
| 5 | Tak の 5 原則（P1–P5）+ S、`\emph{}` 禁止、E17 に "recommends" 禁止 | `templates/review_checklist.md`、`.claude/rules/paper-writing.md` |
| 5, 8 | 段落単位、EN が原稿、全メンバー参加、Louis 必須、Option A/B/C | `memory/feedback_tak_feedback_patterns.md` |
| 5 | 本体 → Discussion → Abstract/略語（Terminal pass）。作成過程の検討事項は supplement にしない | 同上 |
| 6 | reviewer に言われる前に自分で弱点を見つける | `/pre-review`、Louis memory `.claude/agent-memory/louis/` |
| 全 | 語られた ≠ ディスクにコミット。compaction 後は 5-step verification | `memory/feedback_compaction_protocol.md` |
| 全 | bg の結果は段落レビューを中断しない。必ず SUITS に落とす | `memory/feedback_bg_report_timing.md` |
| 全 | 知識の限界では推測で進めず外部知識を要求。`[推測]` / `🔍要根拠`、`/ground`。推測は原稿・CLAIMS・DECISIONS に入らない | `memory/feedback_evidence_over_inference.md` |
| 0–1, 4–5 | 研究は発散してよい。論文は Aim に答えるものだけ。出口は原稿 / IDEAS_BACKLOG / exploratory の三つ | `memory/feedback_diverge_converge.md` |
| 全, 9 | 別論文のネタはその場で `/idea` → `IDEAS_BACKLOG.md`。判定せず登録、Phase 9 で見直す | `memory/feedback_idea_stock.md` |

---

## 3. Claude Code 機能レビューと SUITS への割当（2026-09-21、2026-10-10 更新）

| 機能 | 状態（本プロジェクト） | SUITS での用途 |
|---|---|---|
| **CLAUDE.md** | Rule 1–6（10-10 に Rule 5 Lifecycle・Rule 6 Scientific Integrity を追加） | 憲法。本書と rules は CLAUDE.md を補う位置 |
| **`.claude/rules/*.md`（`paths:` で範囲限定）** | 4 本: `paper-writing.md` / `r-code.md` / `suits-script.md` / **`protocol-and-results.md`**（新） | 原稿・R・脚本・研究記録を触るときだけ該当規則を注入 |
| **Skills（`.claude/skills/*/SKILL.md`）** | 38 本。10-11 夜 新設 5 本（§10）: `/referee` `/review-fix` `/structure` `/necessity` `/explore`。10-11 新設 `/replicate`。10-10 新設 5 本: `/claims` `/reproduce` `/cite-check` `/decide` `/lint-suits`。改訂 9 本: `/protocol`（ADEMP+MCSE）`/review`（構造化・on-disk）`/verify-numbers`（ledger・four-eyes）`/start`（scaffold）`/meeting`（decision record）`/phase`（機械的 gate）`/submission-check`（R1–R8）`/pre-review` `/handoff` | Phase gate と各段階の手順書 |
| **Subagents（`.claude/agents/*.md`）** | 9 本（10-11 夜に `referee` — blind list 付きの冷読 reviewer、`Edit` 不可、`review_response/referee/` にだけ書く）。persona は `agents/*.md`。Louis/Jessica は `disallowedTools: Edit, Write`。Louis は `memory: project`。10-10 に scientific-method duties を各 agent に追記 | `@bg @katrina` や `/pre-review` の並列を persona・tool 範囲固定で実行 |
| **Hooks** | 17 本（下表。10-12 に `referee-blind.sh` — referee の blind list を tool scope に） | Donna の enforcement |
| **Scripts（`scripts/`）** | 20 本 + R 2 本 + 回帰テスト 119 件（§7）+ `.githooks/pre-commit`（§11） | hook・skill・CI から呼ぶ機械的検証と生成 |
| **CI（`.github/workflows/`）** | **新設 2 本**（10-11）: `lab-checks.yml`（tests・consistency・lint・cite・registry・ratchet・protocol dry-run）、`r-and-tex.yml`（全 R の parse、生成表と macros の鮮度、LaTeX build） | gate を advisory から **blocking** に |
| **Cloud setup（`scripts/cloud_setup.sh`）** | **新設**（10-11）: R 4.3 + TeX Live + PyYAML。環境設定 → Setup script に登録（Tak） | cloud session で sim・再現・compile を実行できる |
| **Quarto（`templates/paper_template.qmd`, `_quarto.yml`）** | **新設**（10-11）。`/start` が scaffold | 新論文は数値を `num()` で引く executable manuscript |
| **Versioned memory（`memory/`）** | **13 本 + INDEX**（10-10 に 12 本を復元） | ローカル auto-memory に依存しない原則。cloud session・clone でも消えない |
| **Templates（`templates/`）** | 18 本。10-10 新設 9 本（protocol / simulation_findings / provenance / claims / decisions / lab_status / literature_search_log / reporting_checklist / numbers_ledger_header） | 研究記録の型 |
| **Auto memory（`~/.claude/projects/.../memory/`）** | ローカル 25 件 | Tak の feedback pattern。Phase 9 で `memory/` に反映 |
| **`@bg` / Agent tool（background）** | 運用中（Rule 3.6） | Phase 1, 3, 4 の独立調査。Tak 判断を要する作業は不可 |
| **Agent Teams / Workflow** | 未使用 | 大規模並列時に Tak が opt-in |
| **`isolation: worktree`** | `/reproduce` が使う | clean checkout 再実行 |
| **`/compact` + PreCompact hook** | `pre-compact-snapshot.sh` | compaction 前にディスクの実状態を保存 |
| **Plugins（ARS）** | 導入済み（`/ars-*`） | 素材生成器。persona・判断・記録は SUITS 側 |
| **MCP（PubMed 等）** | Rachel subagent に付与 | DOI 取得・引用確認 |

### Hooks（settings.json）

| Event | Script | 役割 | 状態 |
|---|---|---|---|
| SessionStart | `session-start-context.sh` | 行数・branch・Phase・snapshot の有無 + **`check_consistency.sh`** | 修正（10-10） |
| SessionStart(compact) | `post-compact-remind.sh` | role reminder + 5-step + Phase | 既存 |
| PreCompact | `pre-compact-snapshot.sh` | git log/status/diff、SUITS 最新 scene、Phase を `.claude/state/` に保存 | 既存 |
| UserPromptSubmit | `remind-suits-on-prompt.sh`, `validate-paper-request.sh` | 5 分未更新の警告、DOI 必須 | 既存 |
| PreToolUse(Bash) | `pre-bash-safety.sh` | 危険な再帰削除（root / home）と main への force push の遮断 | 既存 |
| PreToolUse(Bash) | **`pre-run-protocol-check.sh`** | PROTOCOL に無い結果生成スクリプトの `Rscript` を警告（protocol first） | **新設** |
| PostToolUse(Write\|Edit) | `check-suits-update.sh`, `check-suits-lines.sh`, `check-paper-sync.sh`, `check-numbers-verification.sh` | 記録・行数・EN/JA 同期・数値検証（ledger と `numbers_audit.py` を案内） | 既存（numbers は修正） |
| PostToolUse(Write\|Edit) | **`lint-suits.sh`** | SUITS.md 編集時に `lint_suits.py`（ラストネーム・敬語・label・順序） | **新設** |
| PostToolUse(Write\|Edit) | **`check-r-reproducibility.sh`** | R ファイル編集時に静的再現性 lint（seed・絶対パス・sessionInfo・parallel RNG） | **新設** |
| PostToolUse(Write\|Edit) | **`check-claim-guards.sh`** | `CLAIM_GUARDS.toml` の `[meta].tex` に当たる原稿を編集した時だけ `claim_guards.py`。落ちた guard と FAIL の 1 行目、OPEN（pending）の件数、script 自体のエラーを表示（10-12: .qmd と他の .tex は対象外、stderr を握りつぶさない） | **新設（10-11 夜）** |
| PreToolUse(Read\|Grep\|Glob\|Bash\|Write) | **`referee-blind.sh`** | hook 入力の `agent_type` が `referee` の時だけ発火。blind list（SUITS / CLAIMS / DECISIONS / memory / lab docs / provenance / git history / review_response 以外）への Read・Grep・Glob・`git log` を exit 2 で遮断、Write と shell の書き込みは `review_response/referee/` 配下のみ。他の agent と main session は素通り | **新設（10-12）** |
| SubagentStop | `subagent-stop-record.sh` | bg メンバー完了 → SUITS 記録を促す | 既存 |
| Stop | `check-suits-lines.sh`, `check-persistence.sh` | archive 警告、Persistence Guard | 既存 |

---

## 4. 一日の流れ（運用例）

```
セッション開始  → hook が Phase と consistency findings を表示 → /phase で gate を確認
作業           → 各 significant action を SUITS.md に scene（Rule 2）。判断は /decide、主張は /claims
新しい結果が要る → /protocol（ADEMP・MCSE・licenses を commit）→ 実装 → /reproduce → /verify-numbers → SIMULATION_FINDINGS
段落を Tak へ  → review_checklist（P1–P5 + S）→ Option A/B/C → Tak OK → 適用 → 検証 grep → compile
gate が揃った  → /phase next（Donna 検証、Louis risk、必要なら Jessica 承認）
投稿前         → /claims check → /verify-numbers → /cite-check → /submission-check（R1–R8）→ Jessica
終了           → /handoff（claimed vs on-disk、consistency、lint）→ Stop hook
```

---

## 5. 未採用（意図的）

- **Agent Teams / Workflow の常時化**: cost と複雑さ。必要な Phase で Tak が opt-in
- **LLM による tone linter**: 毎編集で LLM 呼び出しが走る。機械的 lint（`lint_suits.py`）で取れる違反を先に取り、tone の質は Donna が読む
- **全 subagent への `memory:`**: 散らばると管理不能。Louis のみ
- **数値 gate の blocking 化**（hook exit 2）: 誤検出で執筆を止める。advisory + `/submission-check` での strict 判定に留める

---

## 6. Scientific integrity principles（2026-10-10 — 機構に落とした原則）

| # | 原則 | 何が問題だったか（repo の記録） | 機構 |
|---|---|---|---|
| S1 | **Pre-registration**: 結果を見る前に claim・licenses・ADEMP・MCSE を commit | protocol は 1 本だけ（`PROTOCOL_real_data_survey.md`）。多くの sim は protocol なしで回り、後から用途が変わった | `/protocol` + `templates/protocol_template.md` + hook `pre-run-protocol-check.sh` |
| S2 | **Claims ↔ evidence registry**: 主張は台帳の 1 行、証拠はディスク上のパス、動詞は証拠の型に従う | 構成の迷走 v3→v6、"three gaps" の enumeration drift、per-EM bound を joint に売る overclaim（Louis memory） | `CLAIMS.md` + `/claims` + `review_checklist.md` S 節 |
| S3 | **Decision trail**: 判断は理由付きで append-only に残す。覆すときは理由に答える | ρ 残置決定の reasonless な反転、「決定 X と矛盾」だけの却下 | `DECISIONS.md` + `/decide` + `/meeting` Phase 4 |
| S4 | **Uncertainty always**: 推定値に CI/SE、性能指標に Monte Carlo SE、$n_{\mathrm{sim}}$ は目標 MCSE から | 性能指標が点推定で報告されていた（Morris et al. 2019 の基準未適用） | protocol §3P、`simulation_findings_template.md`、`paper-writing.md` |
| S5 | **Four-eyes numbers**: producer ≠ verifier、原稿の全数値は ledger に source と verifier | S6/S7 の MC 真値誤差、旧 run の読み違い、Study 番号入れ替えに伴う残存 | `scripts/numbers_audit.py` + `NUMBERS_LEDGER.csv` + `/verify-numbers` |
| S6 | **Reproducibility is executed, not asserted**: clean checkout から再実行し許容差を記録 | `w1_raw_simulation.R` の parallel RNG 非再現、絶対パス 20 本、sessionInfo 欠落 | `scripts/check_r_reproducibility.sh` + `/reproduce` + provenance |
| S7 | **Citations say what we say they say**: 原典の verbatim で照合、DOI 必須、要約から引かない | `Song_2025.md` の誤読、「定量手法は存在しない」の誤り | `scripts/cite_audit.py` + `/cite-check` + `summary_template.md` "does NOT say" |
| S8 | **Exploratory ≠ confirmatory**: protocol 外は "exploratory" と明記、prior look は開示 | 事後に選んだ閾値（SMD < 0.1）— `PROTOCOL_real_data_survey.md` §0 が手本 | protocol §0 / §5、findings §5 |
| S9 | **Quantify, do not decide**: 判定規則・閾値・手続きの推奨を書かない | v6 で判定の仕組みを全削除（Tak 09-25） | `memory/feedback_quantify_not_decide.md`、`paper-writing.md` |
| S10 | **Principles are versioned**: 原則はローカル auto-memory ではなく repo の `memory/` に | 参照先 12 本が repo に無く、cloud session では原則が消えていた | `memory/INDEX.md`、`check_consistency.sh` の参照照合 |
| S11 | **Character consistency is checked mechanically where it can be** | ラストネーム・敬語・「全部記録したわ」が再発 | `scripts/lint_suits.py` + hook `lint-suits.sh` + `/lint-suits` |
| S12 | **Numbers are generated, never typed**（10-11）: 結果に由来する数値は registry の 1 行、原稿は `\numval{key}` / `num("key")`、表は single writer が `paper/generated/` に tabular 全体を書く。CSV の 1 セルに無い導出量（grid の range、run 間の差、順位相関、閉形式の設計定数）は第二の single writer `R/make_derived_numbers.R` → `results/derived/*.csv`。設計定数は `NUMBERS_LEDGER.csv` に source_locator 付き。丸めは decimal half-even | 原稿 672 数値に source なし。0.9425 が機械によって 0.942 / 0.943 に割れた（formatC は binary の丸め） | `paper/numbers_registry.csv` + `scripts/numbers_registry.py` + `scripts/r/numbers_registry.R` + `scripts/make_numbers_macros.R` + `R/make_paper_tables.R` |
| S13 | **Protocols compile**（10-11）: ADEMP の機械可読部（YAML front matter）から R の骨格（seed・grid・MCSE・出力・provenance・findings）を生成。人が書くのは data draw と推定量だけ | protocol は文書、コードは別に手書き → 乖離（prose vs code） | `scripts/protocol_compile.py` + `templates/protocol_template.md` |
| S14 | **Replication from the Methods text**（10-11）: Louis が Methods 本文だけから推定量を再実装し、canonical と列ごとに比較 | 一度だけの `louis_independent_replication.R` | `/replicate` + `louis-replication` agent + `scripts/extract_methods.py` + `scripts/compare_results.py` |
| S15 | **Gates block in CI**（10-11）: 全チェックを push ごとに実行。ratchet baseline は下がるだけ | hook は advisory、語っただけでも merge できた | `.github/workflows/*.yml` + `scripts/ci_ratchet.sh` + `scripts/baseline/` |
| S16 | **Findings become guards**（10-11 夜）: review の所見（overclaim・単位・quantifier）は 1 文の修正でなく **class** の guard。各 guard は `known_bad` の revision で必ず落ちる（変異テスト）。落ちない guard は vacuous で CI が止める | M1 を §2.2 で直して 3 箇所に残った（patch without cascade）。`verify_corrections.R` は claude_science/ に閉じていて原稿の hook に無かった | `CLAIM_GUARDS.toml` + `scripts/claim_guards.py --mutation` + hook `check-claim-guards.sh` + `/referee` `/review` が起票 |
| S17 | **Structure is measured before content is read**（10-11 夜）: 節ごとの語数 vs venue、float の cited-before-defined、Results の外の数値段落、論証の重複、Supplement 文字の欠番 | 本文 12,371 語（2.1×）、Discussion の 348 語段落に 9 つの数値 = 第三の simulation study が §3 に無い | `scripts/structure_audit.py` + `templates/venue_profiles.toml` + `/structure` |
| S18 | **Fixes are reviewed**（10-11 夜）: 修正の diff に対して cascade（残存）・qualifier drop・quantifier strengthening を機械的に検出。Louis は diff と report だけ読む | 356 → 248 語の圧縮で "in at least one world" が "wherever" に、"non-negligible" が消えた | `scripts/cascade_check.py` + `/review-fix` |
| S19 | **Every result bills a claim, every claim names its binding cell**（10-11 夜）: unbilled results は cite するか exploratory と書く。confirmatory な scenario は load-bearing でないと明記。方向語（did not fall / plateau）は CSV の列で確認 | 8.6 MB の threshold sim が原稿のどこにも無い。「n で落ちない」が自分の CSV に反していた（非ゼロ plateau） | `scripts/evidence_coverage.py` + ratchet `results_unbilled` + `/necessity` |
| S20 | **Cold reading is a tool scope, not a request**（10-11 夜）: referee は SUITS / CLAIMS / DECISIONS / memory を開けない agent として走る。再計算 script の on-disk がない review は gate evidence にならない | Louis は memory と CLAIMS を読んでから攻める（文脈あり）。Claude Science の一回限りの冷読が最も多くの誤りを見つけた | `.claude/agents/referee.md` + **hook `referee-blind.sh`（10-12: blind list を PreToolUse で強制 — 指示でなく tool scope）** + `/referee` + `exploratory/` sandbox（`/explore`） |
| S21 | **Evidence before inference**（10-12）: 知識に限界があるときは推測で進めず、論文等の外部知識（原典・DOI・page）を要求する。根拠を名指せない発言は `[推測]`、必要な出典は `🔍要根拠` → `/ground`。推測は原稿・CLAIMS・DECISIONS に入らない | Song 2025 の誤読、E17「定量ゼロ」「日本=定性」（abstract 読み）、小宮山 Ch.4 の拡大解釈 — 全部、原典を読まずに推測で進めた型 | `memory/feedback_evidence_over_inference.md` + `/ground` + `scripts/ground_audit.py`（`check_consistency.sh` §7）+ `/request-paper`（hook `validate-paper-request.sh` が DOI を要求）+ agents の duties |
| S22 | **Research diverges, the paper converges**（10-12）: 会議・レビューの発散は許容。原稿に入るのは `LAB_STATUS.md` の **Question / Aims** に答えるものだけ。論点の出口は三つ — 原稿 / `IDEAS_BACKLOG.md` / `exploratory/`。Aim ↔ Results は一対一 | v3 → v6 の迷走、Discussion の第三の simulation study（S17）、unbilled results 14（S19）、本文 1.7× venue — 発散した論点に出口が無く原稿に流れた | `memory/feedback_diverge_converge.md` + `LAB_STATUS.md` Question / Aims 行 + `/necessity` の Aim 対応表 + `templates/review_checklist.md` Q 節 + `.claude/rules/paper-writing.md` |
| S23 | **Ideas are stocked, not debated**（10-12）: 議論で出た別論文のネタはその場で root の `IDEAS_BACKLOG.md` に `I-YYYYMMDD-n` で登録（source、一行、scope 外の理由、必要な根拠、status）。良し悪しはその場で議論しない。Phase 9 で Harvey が見直す | 効果追跡 sim、Neyman smooth 2 標本版、clustering / silhouette、因果の相対効果 — SUITS と archive に埋もれて検索不能。backlog は 02-03 以来 1 件 | `memory/feedback_idea_stock.md` + `/idea` + `IDEAS_BACKLOG.md`（`check_consistency.sh` §7 が ID 重複を見る）+ `/meeting` `/decide` `/explore` `/review` `/referee` `/victory` の登録義務 |

---

## 7. Scripts（`scripts/`）

| script | 役割 | 呼ぶ場所 |
|---|---|---|
| `lint_suits.py` | SUITS.md の機械的 character lint（ラストネーム・Harvey/Louis/Jessica の敬語・speaker label・Donna scribe・scene 順・場所見出し・silent メンバー） | hook `lint-suits.sh`、`/lint-suits`、`/handoff` |
| `numbers_audit.py` | 原稿の全数値を抽出し `results/NUMBERS_LEDGER.csv` と照合（台帳の高精度値を本文の桁に half-even で丸めて一致した時だけ sourced。粗い設計定数が近い結果を吸収しない）。`--draft-ledger` / `--draft-registry` で雛形 | `/verify-numbers`、`/submission-check` R4 |
| `cite_audit.py` | `\cite` ↔ `.bib` 照合（missing / uncited / DOI / 重複）+ citation–claim 表の雛形 | `/cite-check`、`/submission-check` R5 |
| `check_r_reproducibility.sh` | R スクリプトの静的 lint（seed・parallel RNG・絶対パス・sessionInfo・install.packages） | hook `check-r-reproducibility.sh`、`/reproduce`、`/submission-check` R6 |
| `check_consistency.sh` | Phase 同期、stale LAB_STATUS、undefined `\ref`、欠けた lifecycle artifacts、未バージョンの memory 参照、SUITS 行数 | hook `session-start-context.sh`、`/phase`、`/handoff` |
| `check_all.sh` | 上の 5 本を一度に回し、`review_response/MECHANICAL_CHECKS_{date}.md` に 1 本の報告（artifacts の有無・CLAIMS の supported/pending も） | `/submission-check`、`/handoff`、`/phase`、Donna |
| `numbers_registry.py` | registry（key → CSV の source・filter・column・agg・fmt）を評価: `build` / `check`（macros ↔ registry ↔ 原稿の `\numval`）/ `verify-draft`（原稿の literal vs CSV）/ `apply`（literal → `\numval{}`）/ `value` | `/verify-numbers`、CI |
| `r/numbers_registry.R` + `make_numbers_macros.R` | 同じ semantics の R 実装（canonical generator）。`num("key")` は Quarto 原稿の inline 用。丸めは `.num_round_dec()`（decimal half-even） | `R/make_paper_tables.R`、Quarto、CI（R vs Python 一致を `cmp`） |
| `protocol_compile.py` | protocol の YAML front matter を検証（$n_{\mathrm{sim}}$ vs 目標 MCSE、owner、true_value）し `R/{study}.R` / provenance / findings の骨格を生成。`post_hoc: true` は gate 以前に走った study の事後登録（task 固有の measure は文書化のみ） | `/protocol`、CI（dry-run） |
| `extract_methods.py` | 原稿から Methods（+ Appendix）だけを切り出す（comment・`\input` を除去）。clean-room replicator への入力 | `/replicate` |
| `compare_results.py` | 2 つの CSV を key で突き合わせ、列ごとに max abs / rel diff と欠損行を報告（PASS/FAIL、markdown） | `/replicate`、`/reproduce` |
| `ci_ratchet.sh` | numbers unsourced と R lint ❌ の件数が `scripts/baseline/` を超えたら FAIL。`--update` で現在値を baseline に | CI、Donna |
| `cloud_setup.sh` | cloud session の Setup script（R・TeX Live・PyYAML） | 環境設定（Tak） |
| `texprose.py` | 共有 LaTeX → prose ヘルパー（comment / verbatim / float / display math の除去、abstract 抽出、節・float・段落・文の分割、content words、Jaccard）。下 4 本が import | `claim_guards.py`、`structure_audit.py`、`cascade_check.py` |
| `claim_guards.py` | `CLAIM_GUARDS.toml` の guard（forbid / require / min_count / proximity / max_words、scope = prose / abstract / section）を評価。`--mutation` で各 guard を `known_bad`（git rev か file）に当て、落ちない guard を vacuous として exit 1 | hook `check-claim-guards.sh`、`/referee`、`/review-fix`、`check_all.sh` §7、CI |
| `structure_audit.py` | 節ごとの語数 vs venue profile、float の cited-before-defined / uncited、Results 外の数値段落、節をまたぐ重複文、Supplement 文字の欠番、abstract 語数。`--strict` が止めるのは placement・欠落 `\ref`・abstract の語数超過（本文の語数は止めない）。未知の `--venue` は warning 付きで generic に | `/structure`、`check_all.sh` §8、CI |
| `cascade_check.py` | 旧版と新版（git rev か file）の文を対応付け、残存（residue）・qualifier drop・強められた quantifier を表に | `/review-fix`、`/referee` 後の修正 |
| `evidence_coverage.py` | `results/` の各ファイルが原稿・supplement・registry・ledger・CLAIMS・protocol・provenance のどれかに billed か、`\includegraphics` の実在、`CLAIMS.md` の evidence path（brace 展開、repo root fallback）の実在、`exploratory/` の leak、言及の無い R script | `/necessity`、`check_all.sh` §9、ratchet、CI |
| `lab_doctor.sh` | ラボの機構がこの機械で実際に動くか: toolchain（`python3 -I`、stdlib の場所、PyYAML、tomllib、Rscript、pdflatex）、settings.json ↔ `.claude/hooks` の配線（欠落・孤児）、skills / agents の frontmatter、read-only agent の tool、referee hook の配線、CI が呼ぶ script の実在、ratchet baseline、テスト件数と本書の一致。`--strict` で ❌ があれば exit 1 | `check_all.sh` §0、CI（strict）、`/handoff` |
| `protocol_compile.py --verify [R]` | protocol ↔ code の乖離（S13）: front matter の seed・n_sim・grid の各 n・各 method の `fn`・summary CSV が R script（既定 `R/{study}.R`、または front matter の `code:`）に現れるか。TODO 残数を警告。乖離は exit 1、`post_hoc: true` の protocol は advisory | `check_all.sh` §6、CI、`/phase next` 4→5 |
| `install_git_hooks.sh` + `.githooks/pre-commit` | ローカルの blocking gate: staged の内容に応じて SUITS lint（strict）・claim guards（strict）・numbers check・回帰テスト（scripts/hooks を触った時）・ratchet を commit 前に走らせる。`core.hooksPath` を一度設定するだけ（`git commit --no-verify` で一回だけ回避可） | Tak が有効化（§11） |
| `tests/run_tests.sh` | fixtures に対する回帰テスト 119 件（各 script の検出・除外・strict exit、丸め境界、R と Python の一致、hooks の発火条件、guards の変異テスト、cascade・structure・coverage の fixture、`--verify` の乖離検出、lab doctor、referee blind-list hook の遮断 / 通過）。script や hook を触ったら必ず回す。`PYTHONIOENCODING=utf-8` を export（Windows cp932）。MSYS では Rscript にパスを渡す前に `cygpath -m` | 開発時、`/handoff`、CI |

すべて advisory（exit 0）。strict 判定は `--strict` / `STRICT=1` で `/submission-check` が使う。R が無い環境でも動く（静的解析のみ）。**Claude Code は repo root から起動する**（subagent の `memory: project` と hooks のパス解決が cwd に依存する。10-10 に Louis の memory が 3 か所に分裂していたのを統合した）。

---

## 8. 2026-10-10 の見直しで見つかった事実（記録）

- `LAB_STATUS.md` は 09-21 で止まり、SUITS.md と不一致（v6・Terminal pass が未反映）
- `PAPER_LOGIC.md`・`PAPER_OUTLINE_BILINGUAL.md` は削除済み節（§2.5 operability、§4.5）を参照している（stale）
- 段落レビュー #8–#50 は Tak の包括指示で Harvey 推奨を適用（個別拒否権が開いたまま）→ 投稿前に `DECISIONS.md` で閉じる
- 原稿 `per_em_W1_wiley.tex`: 数値トークン 672（355 の異なる値）に ledger なし／cited 25 keys は全件 .bib に存在、DOI 欠落は E17 guideline 1 件（URL あり）／`.bib` の 19 entries は未引用
- R スクリプト 83 本中、絶対パス 20 本、結果を書くのに `sessionInfo` 無し 50 本超、seed 無しで乱数 3 本
- Louis の subagent memory が `.claude/agent-memory/louis/`（2 本）、`projects/similarity-metric/.claude/…`（8 本）、`projects/similarity-metric/claude_science/.claude/…`（3 本）に分裂していた（起動ディレクトリ違い）→ root に統合、`check_consistency.sh` が再発を検出
- `/process-paper` の cleanup が `/tmp` の再帰削除だったため、安全フック `pre-bash-safety.sh` に必ず止められていた → `.claude/tmp/`（gitignored、相対パス）に変更
- `PAPER_LOGIC.md` と `PAPER_OUTLINE_BILINGUAL.md` に STALE banner、`LAB_STATUS.md` を on-disk sync（Phase は 8 のまま、gate は再表現）
- これらは**プロジェクトの作業**であり、本書の改訂では直していない。次セッションで `/claims init` → `/verify-numbers` → `/cite-check` → `/reproduce` → `/phase` の順に消化する

### 10-11（Option B の作業で見つかった事実）
- **丸めが機械依存だった**: S4, n=50 の coverage 0.9425（10,000 回の 9,425 回、decimal の正確な境界）が、同じ `formatC(x, "f", 3)` で Tak のマシンでは 0.942、Linux では 0.943 と印字された（binary の double は 0.9425 のわずか上）。S7, n=50 の 0.9285 も境界。registry は **decimal round-half-even** を両実装に固定し、原稿の 0.942 / 0.928 を再現する（`DECISIONS.md` D-20261011-2）
- `build.sh` の `bibtex` が絶対パスで、Linux の TeX Live（`openout_any = p`）では .bbl を書かず引用が全て undefined になっていた → 相対パスに修正（Windows でも動く）
- tabular の中に行だけを `\input` すると `\bottomrule` の `\noalign` が壊れる → 生成ファイルは **tabular 全体**を持つ
- §3.2（推定の結果）の 34 数値を registry 化、3 表を生成に置換: numbers audit 672 → **526**、compile error 0・undefined 0・20 pp、`pdftotext` の本文差分 **0 行**（内容を変えずに構造だけ変えた証拠）
- 全 R スクリプト 123 本は parse OK（CI の R job が通る前提）

---

## 9. Pipeline（Option B, 2026-10-11）— 論文を protocol と data の関数にする

```
PROTOCOL_{study}.md（YAML front matter = ADEMP の機械可読部 + 登録文書）
   │  python3 scripts/protocol_compile.py            ← n_sim ≥ p(1−p)/ε² を検証、owner・true_value 必須
   ▼
R/{study}.R（seed・grid・per-task seeding・MCSE 付き性能指標・CSV/rds/log・sessionInfo）  ← Mike は draw_sample() と推定量だけ書く
   │  Rscript R/{study}.R
   ▼
results/{study}_summary.csv（estimate + mcse）＋ results/{STUDY}_PROVENANCE.md ＋ SIMULATION_FINDINGS_{study}.md
   │  paper/numbers_registry.csv に行（key → file・filter・column・agg・fmt）／ R/make_paper_tables.R が tabular 全体を生成
   │  CSV の 1 セルに無い量は R/make_derived_numbers.R → results/derived/*.csv（prose の中で計算しない）；設計定数は results/NUMBERS_LEDGER.csv
   ▼
paper/numbers_macros.tex（Rscript scripts/make_numbers_macros.R）＋ paper/generated/*.tex
   │  原稿は \numval{key} と \input{generated/tab_x} だけ（Quarto なら `r num("key")`）
   ▼
build.sh → PDF；pdftotext の差分で「内容を変えない変更」を証明
   │
   ├─ gate: numbers_registry.py check（macros ↔ registry ↔ 原稿）、numbers_audit（残る literal の件数は ratchet で下がるだけ）
   ├─ gate: /replicate — Methods 本文だけから Louis が再実装 → compare_results.py
   ├─ gate: /reproduce — clean checkout で再実行 → compare_results.py、生成物の git diff 0
   └─ CI: lab-checks.yml（毎 push）、r-and-tex.yml（R parse・生成物の鮮度・LaTeX build）
```

**何が変わるか**: 数値の転記という作業と事故が消える。結果を再実行すれば原稿の数値が自動で変わり、変わらなかった箇所は `pdftotext` の差分で確認できる。protocol を書くことがコードを得る最短経路になるので、事前登録が default になる。Methods の記述不足は Louis の replication で毎回露出する。

**何が変わらないか**: 問いの質、臨床的判断、主張の射程は Tak と team の仕事。Louis も homage も同じモデルで、独立性は人の査読に劣る。pipeline は「正しい」を保証せず、「証拠なしに前へ進めない」ことと「同じ入力から同じ原稿が出る」ことを保証する。

**残作業（project）**: 残り 526 の literal を registry へ（§3.1 identification の表と GUSTO の表が大半 — single writer の R を 2 本書く）、`/claims init`、`/replicate` を Study 2 で初回実施、Tak が `scripts/cloud_setup.sh` を環境に登録、CI の初回 green を見て `r-and-tex.yml` の `continue-on-error` を外す

---

## 10. Referee-grade environment（2026-10-11 夜）— Claude Science を常設の機構にする

**出発点**: 2026-09-21 に Claude Science（内部記録を持たない別セッション）が原稿を一度だけ冷読し、`claude_science/` に 4 つの成果物を残した — 再計算付き referee report（Major 5 / Minor 8、Study 1 の表 23 セル不一致、M1 の数学的誤り）、structure review（本文 2.1×、Discussion に第三の simulation）、simulation necessity（S3/S4/S7 は confirmatory、plateau の読み違い、8.6 MB の未報告 sim）、`verify_corrections.R`（所見 → 実行ゲート、known-bad で変異テスト）。加えて side study 一本（`neyman_smooth/`）。ラボの `/review`・`/pre-review`・`/external-review` はどれもこの深さに届いていなかった。理由は三つ: **文脈がありすぎる**（SUITS・CLAIMS・memory を読んでから攻める）、**再計算が義務でない**、**所見が prose のまま**（Louis の memory）で check にならない。

**設計**: Claude Science がやった 8 つのことを 6 つの機構に分解し、一回限りでなく **毎 draft・同条件・CI 付き** にする。`memory/project_referee_grade_environment.md` に benchmark と対応表。

```
/referee ──► .claude/agents/referee.md（blind list: SUITS/CLAIMS/DECISIONS/memory/review_response を開けない）
   │            再計算（Rscript、review_response/referee/{date}/）→ 数学 → 解釈 → binding → abstract 圧縮
   │            固定書式 report（Arithmetic verification / Major+Guard 案 / Minor / Binding / Abstract vs body / Not verified）
   ▼
review_response/REFEREE_{date}.md ──► Harvey 方針 ──► 修正 ──► /review-fix（cascade_check.py: residue / qualifier drop / strengthened）
   │                                                          │
   └─ Louis: 各 Major を CLAIM_GUARDS.toml に起票（known_bad = 修正前 rev）──► claim_guards.py --mutation（vacuous 0）
                                                              │
hook check-claim-guards.sh（原稿を編集するたび）── CI lab-checks.yml（--strict --mutation）── check_all.sh §7
/structure  → structure_audit.py（語数 vs venue、float placement、Results 外の数値段落、重複、Supplement）── CI（placement strict）
/necessity  → evidence_coverage.py（unbilled results、CLAIMS の evidence path、図、exploratory leak）── ratchet results_unbilled
/explore    → exploratory/{slug}/（EXPLORATORY banner、出口は /protocol のみ、coverage が leak を検出）
```

**何が「超える」か**
1. **再現性のある冷読**: Claude Science の独立性は「たまたま別セッションだった」こと。`referee` agent は tool scope と blind list で同じ独立性を **毎回** 作る。再計算 script がディスクに無い review は gate evidence にならない
2. **所見が消えない**: `verify_corrections.R` は claude_science/ に閉じていた。`CLAIM_GUARDS.toml` は原稿の hook・CI・`check_all.sh` が毎回読む。seed は Claude Science の 8 forbidden phrasings + proximity + abstract quantifier guards + Louis review の "indistinguishable"（15 guards、10 に known_bad、vacuous 0）
3. **check の check**: 「known-bad で落ちない check は check でない」を `--mutation` として機械化。git の履歴（修正前の commit）が known-bad の供給源になるので、fixture を手で作る必要がない
4. **修正の二次審査が default**: patch without cascade と compression drop は Claude Science が自分の修正を再審査して見つけた。`/review-fix` は毎修正で同じ再審査を走らせ、Louis には diff と report しか渡さない
5. **構造と必要性が数値になる**: 語数比・float drift・段落の数値密度・unbilled 件数は毎回同じ物差しで測られ、unbilled は ratchet で増えない
6. **探索に場所がある**: side study は `exploratory/` に置き、原稿へは `/protocol` 経由でしか入れない（S8 の prior-look 開示付き）

**初回実行（2026-10-11 夜、merge 後の確定版 `fad1010` に対して — `/referee` 本体は Tak の起動待ち）**
- `claim_guards.py --mutation`: 15 guards、0 FAIL、**0 vacuous**（`review_response/CLAIM_GUARDS_20261011.log`）
- `structure_audit.py`: 本文 **9,160 語（SiM 上限の 1.5×；09-21 の 12,371 語から −26%）**、abstract 246、float 14 本 placement issue 0、Discussion L540 の段落に数値 7 個、重複文 0、Supplement 文字の引用なし（`review_response/STRUCTURE_AUDIT_20261011.md`）
- `evidence_coverage.py`: results 49 本中 **unbilled 14**（最大 `threshold_sim_summary.csv` 8.4 MB — Claude Science が指摘したまま）、CLAIMS の evidence path 欠落 1（**C-31 → `paper/generated/tab_study2_ari.tex`**、v6 で削除済みの表）、未使用 figure 13、言及の無い R script 61/87（`review_response/EVIDENCE_COVERAGE_20261011.md`）
- 回帰テスト: 10-11 夜は 96 件中 90 pass（PyYAML 未導入 5 件、R vs Python の byte 差 1 件）。**10-12 に 113 / 113 pass** — PyYAML を導入、byte 差は両生成器のヘッダ（Python は Windows の `\`、R は絶対パス — CI の r-and-tex が 3 回赤だった原因）を POSIX の project 相対パスに統一して解消（§11）

**残作業（project）**: merge 解決後に `/referee all`（初回の冷読、R で再計算）→ guards 追加 → `/review-fix`；`/necessity` で unbilled 14 本の扱いを `/decide`（threshold sim・anchor_vs_clustering は exploratory へ？）；C-31 の evidence path を retracted に合わせて修正；Discussion L540 の段落を `/structure` で判定。

---

## 11. Hardening（2026-10-12 未明）— 「動くはず」を「動く」に

10-11 夜の referee-grade environment は設計どおりだったが、ディスク上では四つ穴があった: (i) 回帰テストが 6 件落ちていた（環境要因と書いて放置）、(ii) CI の `r-and-tex` が 3 連続で赤（R と Python の macros ヘッダの byte 差）、(iii) referee の blind list が **指示**でしかなく、agent は SUITS も CLAIMS も開けた、(iv) 新 skill 5 本の記述が script の実装と 13 か所で食い違っていた（監査 agent の所見）。この節はそれを機械で閉じた記録。

| 穴 | 機構 | 証拠 |
|---|---|---|
| テストが環境で落ちる | PyYAML 導入、MSYS の Rscript パスを `cygpath -m`、`lab_doctor.sh` が toolchain を毎回診る（`python3 -I` が動くか、stdlib が repo の外か） | `run_tests.sh` 113 / 113、`check_all.sh` §0 |
| CI r-and-tex 赤 | `make_numbers_macros.R` と `numbers_registry.py build` のヘッダを POSIX の project 相対パスに統一（R は `normalizePath(winslash="/")` + `startsWith`、Python は `as_posix()`） | テスト「R output byte-identical」PASS、CI は次 push で green 見込み。tex job は 3 回 green なので `continue-on-error` を外した（blocking） |
| blind list が request | `referee-blind.sh`（PreToolUse、`agent_type == referee` のみ）: 内部記録の Read / Grep / Glob / `git log` を exit 2、Write と shell 書き込みは `review_response/referee/` のみ。agent 定義の list と同期 | 回帰テスト 10 件（遮断 6・通過 4）、`lab_doctor` が配線を確認 |
| protocol と code の乖離（S13） | `protocol_compile.py --verify`: seed・n_sim・grid・method fn・summary CSV が R に現れるか。post_hoc は advisory、それ以外は exit 1 | テスト 3 件、CI step、`check_all.sh` §6 の行 |
| 落ちる状態を commit できる | `.githooks/pre-commit`（staged に応じた fast gate）+ `install_git_hooks.sh`。**有効化は Tak**（並走セッションの commit を突然止めないため、この job では `core.hooksPath` を設定していない） | §7 の行 |
| skill と script の食い違い | referee / review-fix / structure / necessity / explore の 13 か所を実装に合わせた（paths、`pending`、`--strict` の範囲、CI の pipefail、leak 検出の範囲、R lint の範囲、R7 の参照先、gate への配線）。`cascade_check.py --new` は省略可（working tree）、`evidence_coverage.py` は registry と ledger の leak も見る、`structure_audit.py` は未知 venue を警告、`check-claim-guards.sh` は `[meta].tex` だけを対象にし stderr を見せる | `/phase next` の 4→5・6→7 一覧に REFEREE / FIX_REVIEW / STRUCTURE_AUDIT / NECESSITY / guards strict を明記 |
| 並走セッション | `memory/feedback_concurrent_sessions.md`: bg job は ListAgents + mtime で検出 → SendMessage で path 分担 → commit しない → SUITS は再読後に原子的挿入 | 10-12 00:06 の実例（原稿側は別セッションが適用中） |

**この機械の既知の問題（Tak）**: `C:\Python313` は exe だけの残骸で、stdlib は `AppData\Local\Programs\Python\Python313\Lib` から registry 経由で読んでいる（`python3 -I` が落ちる、`sys.prefix` が cwd になり `$PWD/Lib` が `sys.path` に載る）。`lab_doctor` が ❌ 2 件で毎回指摘する。Python を一度入れ直すのが正。

**残作業（project 側、別セッション / Tak）**: `PROTOCOL_study1_identification.md` の front matter に `code: R/selection_simulation.R` を足す（`--verify` が既定の `R/study1_identification.R` を探して DRIFT 扱い）；`git commit`（この job は commit しない）；push 後に CI 2 本が green になるのを確認；`bash scripts/install_git_hooks.sh` で pre-commit を有効化；CLAUDE.md L290 の「60 regression tests」は guard で編集不可なので Tak が直す。

---

## 12. Tak の 3 原則（2026-10-12 10:09 — 「システム改修」）— 根拠・収束・ストック

Tak の指示（verbatim）:
> - 知識量に限界がある場合、論文等の外部知識を要求する。推測だけで進めない。根拠が重要。
> - 研究として、さまざまな論点に発散していくことは許容するが、論文としては論点を絞る。目的と結果が対応することが重要。
> - 議論の展開で、新たな論文のネタとなりそうなものが出てきた場合、そのネタをストックしておく。

三つは一組で動く。発散（研究）→ 根拠で篩う（S21）→ Aim に答えるものだけ原稿へ（S22）→ 外した論点は捨てずにストック（S23）。

| 原則 | 発言・記録の規約 | 機構 | 何が止まるか |
|---|---|---|---|
| S21 根拠 | 発言は **根拠あり**（path / DOI + page / CSV 列）/ **`[推測]`** / **`🔍要根拠`** の三種。「分からない」は正当な答え | `/ground <statement>`（Rachel: knowledge/ → 原典 PDF → PubMed / Crossref → `/request-paper`、結果は GROUNDED / INFERRED / OPEN）。`scripts/ground_audit.py` が `paper/*.tex` と `CLAIMS.md` の marker を finding にする（`check_consistency.sh` §7、`run_tests.sh` 6 件） | 推測のまま原稿・CLAIMS・DECISIONS が進むこと。推測に依存する判断は DECISIONS に「根拠待ち」で保留 |
| S22 収束 | 原稿の Aim は `LAB_STATUS.md` の **Question / Aims** 行 — **目的**（何を提示するか）であって方法ではない（Tak 10:46 の訂正: Study 1 / Study 2 / GUSTO は Aim でなく Result）。Aim を支える結果は **Results that answer A1**（R1, R2, …）。Results の小節と CLAIMS の行は R 番号を持つ。新段落は「どの Aim に答えるか」を 1 行で言えてから | `/necessity` の Aim ↔ Results 対応表、`templates/review_checklist.md` Q 節、`.claude/rules/paper-writing.md`「目的と結果の対応」、`/meeting` Phase 4 の出口三択 | Aim に答えない Results、Results の無い Aim、Discussion への「とりあえず」書き込み、supplement 化（`feedback_no_process_supplements`） |
| S23 ストック | 別論文のネタは `/idea <一行>` → root `IDEAS_BACKLOG.md` に `I-YYYYMMDD-n`（source、一行、scope 外の理由、必要な根拠、status、by）。その場で良し悪しを議論しない | `/idea`、`IDEAS_BACKLOG.md` v2 表（status 💡→🔬→📄/🗑）、`/meeting` `/decide` `/explore` `/review` `/referee` `/victory` の登録義務、`check_consistency.sh` §7 の ID 重複検査 | ネタが SUITS の scene に埋もれること。ネタの議論で本題が止まること。原稿の Discussion に「将来の課題」として押し込むこと |

**この日の実装**: `memory/` 3 本（+ INDEX、ローカル auto-memory と同期）、`/ground` `/idea`、`scripts/ground_audit.py`、`check_consistency.sh` §7、回帰テスト 113 → 119、`IDEAS_BACKLOG.md` を表形式に（backfill 3 件: I-20260203-1 因果の相対効果、I-20260927-1 clustering / silhouette、I-20261011-1 Neyman smooth 2 標本版）、CLAUDE.md Rule 6 に 3 bullet と slash 表 2 行、`.claude/agents/*.md` 7 本と `agents/{rachel,harvey,donna}.md` に duties、`templates/review_checklist.md` Q 節、`templates/lab_status_template.md` の Question / Aims 行、`projects/similarity-metric/LAB_STATUS.md` に Question / Aims（Tak 10:46 の文言「効果修飾因子の分布の類似性を定量的に評価する指標を提示すること」+ Results that answer A1 = R1–R4）、skills 6 本に 1–2 行（meeting / explore / decide / necessity / review / referee）、README。commit はしない（原稿側セッションと同一 tree）。
